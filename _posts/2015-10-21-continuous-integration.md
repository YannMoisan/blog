---
title: Continuous Integration for Reactive Web Applications
description: Continuous Integration for Reactive Web Applications, leverage the power of Travis CI, Sauce Labs and Heroku
layout: blog
lang: en
---
I've started a new pet project. It's an online board game, for two players.

On the technical side, it uses Scala, PlayFramework, Akka and Javascript. For the testing part, I
use jasmine for javascript unit testing and specs2 with FluentLenium (a library on top of Selenium)
for functional testing. Thanks to sbt-web, I run all these test with one command : `sbt test`

As I'm a professional, I write unit tests and functional tests. So I want [continous
integration](http://www.martinfowler.com/articles/continuousIntegration.html) for my project, and
also continuous deployment to a staging environment. The good news is you can have that for free,
using Travis CI, Sauce Labs and Heroku. The bad news is that it's not that smooth to configure, and
I have encountered a lot of issues. Yes, I really had ALL the following issues :

## Writing Selenium Tests

### HTMLUnit support Javascript, really ?

PlayFramework provide an example in the documentation. Cool. Unfortunately, when I run my test, I
have the following error

```
[error] Caused by com.gargoylesoftware.htmlunit.ScriptException: TypeError: Cannot find function addEventListener in object [object HTMLDocument]. (http://localhost:19001/assets/awale-ws.js#134)
```

By default, the test use `HTMLUnitDriver` that is not a real browser and do not support all
Javascript.

The solution is to use `FirefoxDriver`.

### FirefoxDriver fails with Play 2.3

```
[error]    IllegalArgumentException: : No enum constant org.openqa.selenium.Platform.Windows 7  (Platform.java:30)
```

Solution : it's [a known bug](https://code.google.com/p/selenium/issues/detail?id=8083), you have to
update selenium version

### Numeric id

I use numeric `id`s in the HTML.

```
 <div id="0" class="col">4</div>
```

In my test, I fire an event on this div with `browser.find("#0").click()` and the test fails

```
InvalidSelectorException: : The given selector #0 is either invalid or does not result in a WebElement.
```

Selenium doesn't support that, even if it's conform with the
[spec](http://www.w3.org/TR/html5/dom.html#the-id-attribute).

The workaround is to access the element by its position.

### As it's a multiplayer game, how can I test with multiple browsers ?

After some search on the internet, the Selenium way seems to use multiple windows in the same
browser instead of using multiple browsers.

Selenium/FluentLenium doesn't provide a straightforward way to do that. The trick is to use a
javascript method `window.open`.

As I use this code a lot, I've written some helpers :

```
def goToInNewTab(url: String, windowName: String): Fluent = {
  f.executeScript(s"window.open('${url}', '${windowName}');")
  f.getDriver.switchTo().window(windowName)
  f
}
```

### Tests are executed sequentially

By reading the PlayFramework code, I see the following code.

```
  def running[T](testServer: TestServer)(block: => T): T = {
    PlayRunners.mutex.synchronized {
      try {
        testServer.start()
        block
      } finally {
        testServer.stop()
      }
    }
  }
```

Specs2 support parallel execution of tests. But a mutex prevents parallel execution of tests. So
tests are executed sequentially. And obviously, that will have a negative impact on the overall
execution time of the test suite.

Not solved for the moment

### Akka issue

I got another strange issue : the first test succeed, but following tests fail.

My code relies on Akka, and I kept a reference to an `ActorRef` in an ugly global state.

Unfortunately, after each test, the actor system is restarted, making the reference invalid.

It was solved by using actorSelection to avoid the ref

```
val games = context.actorSelection("/user/games")
```

and using Play `Global` object to have a hook at the application start-up.

```
object Global extends GlobalSettings {
  override def onStart(app: Application) {
    Akka.system.actorOf(Props[GamesActor], "games")
  }
}
```

### ChromeDriver fails

The gameplay use some animations, based on the javascript method `setTimeout`.

By default, `ChromeDriver` doesn't display the window. And according to the best resource for web
developers,
[MDN](https://developer.mozilla.org/en-US/docs/Web/API/WindowTimers/setTimeout#Timeouts_in_inactive_tabs_clamped_to_%3E1000ms),
browser have an optimisation that prevents timer events to occur when the window is not visible.

I'm still stuck with that one.

## Travis CI

If you don't know Travis CI, it's a continuous integration solution with a simple GitHub
integration.

You can install the CLI with `gem install travis`

Travis CI has a decent[Scala support](http://docs.travis-ci.com/user/languages/scala/). You just
have to add a `.travis.yml` file in the root of your repository. And that's it. By default, travis
will run `sbt test`

```
language: scala
scala:
- 2.11.1
```

If you're lazy, you can generate this file by using `travis init`

### Java 8

Hum, here is a compilation issue : 

```
[error] /home/travis/build/YannMoisan/awale/app/actors/EventStore.scala:3: object time is not a member of package java

[error] import java.time.LocalDateTime
```

Let's check the travis console :

```
$ jdk_switcher use default
Switching to Oracle JDK7 (java-7-oracle), JAVA_HOME will be set to /usr/lib/jvm/java-7-oracle
```

Bingo ! By default, Travis CI uses Java 7 and my application requires Java 8. Let's configure that :

```
jdk:
- oraclejdk8
```

### GUI tests fails

Setup is really easy, isn't it ? I'm ready to run my first build and … TADA ! Here is the error :
` Error: no display specified`

Hum. This one smells bad. Ready to install an X server ? Just kidding !

Travis CI allow you to do some GUI tests. Firefox is installed by default and you just have to
[configure
Xvfb](http://docs.travis-ci.com/user/gui-and-headless-browsers/#Using-xvfb-to-Run-Tests-That-Require-GUI-%28e.g.-a-Web-browser%29)

### Downloading the whole internet

At each build, sbt download the whole internet.

Travis CI provides [caching](http://docs.travis-ci.com/user/caching/#Arbitrary-directories), let's
configure that :

```
cache:
  directories:
    - $HOME/.m2/repository
    - $HOME/.sbt
    - $HOME/.ivy2
```

### GitHub release

I want to make a release after each build. So I can deploy easily to production each successful
build.

It's feasible but not straightforward. There is a [feature
request](https://github.com/travis-ci/travis-ci/issues/1476).

As my project is on GitHub, it's a logic solution to use GitHub release.

```
travis setup releases
```

Here are the steps, with the matching travis configuration :

-   build the artefact

```
- after_success:
  - sbt dist
```

-   create a tag

```
- after_success:
  - git config --global user.email "builds@travis-ci.com"
  - git config --global user.name "Travis CI"
  - export GIT_TAG=build-$TRAVIS_BRANCH-$(date -u "+%Y-%m-%d-%H-%M-%S")-$TRAVIS_BUILD_NUMBER
  - git tag $GIT_TAG -a -m "Generated tag from TravisCI build $TRAVIS_BUILD_NUMBER"
  - git push origin $GIT_TAG
```

-   release

```
deploy:
  - provider: releases
    skip_cleanup: true
    api_key:
      secure: …
    file: target/universal/awale-1.0-SNAPSHOT.zip
    on:
      repo: YannMoisan/awale
```

### Heroku

Houra ! I have some tests to guarantee the quality of my builds. I'm therefore confident enough to
deploy automatically on a staging environment.

If you don't know Heroku, it's a PaaS, that support a lot of technology, including Scala and
Playframework.

Travis CI provides an [Heroku integration](http://docs.travis-ci.com/user/deployment/heroku/).

```
travis setup heroku
```

Traditionnaly, you set up a Git remote and each commit is deployed on Heroku (after a `git push`).
The benefit of using Travis CI is, by design, you only deploy successful build.

### Multi provider issue

Travis CI supports deployment to multiple providers, but there is a [known
issue](https://github.com/travis-ci/travis.rb/issues/201) in the CLI : `travis setup` doesn't
support it.

## Sauce Labs

If you don't know SauceLabs, it's a cloud solution to test a web app on a lot of
[OS/browser](https://saucelabs.com/platforms/) combination. And it's free for *open source* project.

Sauce Labs provides an integration with Travis CI, and Travis CI provide an integration with Sauce
Labs.

-   [Travis doc](http://docs.travis-ci.com/user/sauce-connect/)

The main point is to configure sauce-connect, a tunnel to secure communication between Travis CI and
Sauce Labs.

```
addons:
  sauce_connect:
    no_ssl_bump_domains: all
```

### Use Sauce Labs only for on CI

I want to use Sauce Labs only for Travis CI builds, and not for local builds. Locally, I only use
Firefox Driver to have a quick feedback loop.

PlayFramework doesn't provide built-in support for that.

Travis CI set an environnement variable `CI`, so we can detect on which environnement the test is
running.

```
trait EnvAwareDriver {
  def localDrivers: Seq[String => WebDriver]
  def remoteDrivers: Seq[String => WebDriver]

  def drivers: Seq[String => WebDriver] = if (System.getenv("CI") != "true") 
    localDrivers 
  else 
    remoteDrivers
}
```

### Set the tunnel identifier, the build number and the name

You must set the tunnel identifier to allow communication between Travis CI and Sauce Labs. The
build number and the name are useful to generate a comprehensive dashboard.

PlayFramework doesn't provide built-in support for that.

As previously, Travis CI set some environment variables that we can use. Let's do that with
*Enhanced my library* pattern :

```
object SauceLabs {
  implicit class SauceLabsCapabilities(caps: DesiredCapabilities) {
    def setSauceLabs(name: String) = {
      caps.setCapability("tunnelIdentifier", System.getenv("TRAVIS_JOB_NUMBER"))
      caps.setCapability("build", System.getenv("TRAVIS_BUILD_NUMBER"))
      caps.setCapability("name", name)
    }
}  
```

The full code is provided below.

For the name, I propagate to the driver factory the label of the *specs2* example.

```
"my example" in ((s: String) => new WithBrowser(driver(s)) {
```

### Timeout

Some tests fail, client are disconnected for unknown reason. Nothing in the log, the kind of
situation that developers hate.

```
Command duration or timeout: 85 milliseconds
```

One more time, I've spent a lot of time to fix this one. The root cause was instantiation of all
`RemoteWebDriver` at the beginning of the suite. Unfortunately, an HTTP connection is created during
the object construction.

And Sauce Labs timeout connections after 90 seconds.

### The revenge of the timeout

Some tests fail, client are disconnected for unknown reason. Nothing in the log, the kind of
situation that developers hate.

After wasting a lot of time to investigate, I've found that it was due to timeout. In fact, when you
use WebSocket, there is a magic option for Sauce Connect, not documented that you SHOULD have !

```
no_ssl_bump_domains: all
```

Good to know : I've reported an [issue](https://github.com/travis-ci/travis-ci/issues/4927) :
`travis lint` reports a false negative with this option.

### How can I run a test against multiple drivers

The PlayFramework provides an example, but it runs with only one driver.

And the specs2 source code is not as easy to read. I've come up with this trait :

```
trait MultiBrowser {
  self : Specification =>

  def drivers : Seq[String => WebDriver]

  def browsers(u: (String => WebDriver) => Unit) = examplesBlock {
    for (driver <- drivers) {
      u(driver)
    }
  }
}
```

### Network latency

Locally, the browser and the server runs on the same machine. So far so good.

But in CI env, it is not the case anymore, and latency appears, especially when your application
uses WebSocket. So some tests that have always passed locally, fail randomly remotely. Personally,
I've found this issue is really tough and sometimes makes GUI testing time consuming.

The workaround is to use `await` method.

```
browser.await().atMost(5, TimeUnit.SECONDS).until("#invitation").areDisplayed()
```

### Problem : Status unknown

Now it's configured, you want to display the information on your `README` page. So you add the
snippet as explained in the Sauce Labs documentation and … the status is unknown !

PlayFramework doesn't provide built-in support for Sauce Labs, you have to update the status of each
test manually by using the REST API provided by Sauce Labs.

## Conclusion

It's awesome to reap the benefit from these tools, and moreover for free because I do open source.
Sauce Labs provides also free support, and it rocks (thanks guys for your help)!

These cloud-based tools makes my life a lot easier : I receive a mail when a build fails (once, i
received an email by getting my kids to school), I can check the overall status of my project on the
[README](https://github.com/yannmoisan/awale). Releases and deployments are fully automated.

## Helpers methods

I've started to implement some helpers methods. There are still too much boilerplate in the tests
and I definitely need to improve the design.

```
abstract class WithBrowserAndSauceLabsUpdater[WEBDRIVER <: WebDriver](
                                                                       webDriver: WebDriver = WebDriverFactory(Helpers.HTMLUNIT),
                                                                       app: FakeApplication = FakeApplication(),
                                                                       port: Int = Helpers.testServerPort) extends WithBrowser(webDriver, app, port) {

  // call synchronously the Sauce Labs REST API
  def updateJob(sessionId: SessionId, passed: Boolean) = {
    val holder: WSRequestHolder = WS.url(s"https://saucelabs.com/rest/v1/yamo93/jobs/${sessionId}")
    val data = Json.obj("passed" -> passed)
    val f = holder.withAuth("yamo93", "xxx", WSAuthScheme.BASIC).put(data).map(t => {println(t.body)})
    Await.result (f, Duration(5, TimeUnit.SECONDS))
  }

  def getSessionId() : Option[SessionId] = webDriver match {
    case remote : RemoteWebDriver => Some(remote.getSessionId)
    case _ => None
  }

  override def around[T: AsResult](t: => T): Result = {
    var maybeResult : Option[Result] = None
    val maybeSessionId = getSessionId()  // call before browser.quit() in super.around
    try {
      maybeResult = Some(super.around(t))
      maybeResult.get
    }
    finally {
      maybeSessionId.foreach { updateJob(_, maybeResult.map(_.isSuccess).getOrElse(false)) }
    }
  }
}
```
