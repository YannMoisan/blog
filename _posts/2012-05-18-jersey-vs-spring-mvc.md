---
title: Jersey vs Spring MVC
description: Comparatif entre Jersey et Spring MVC, deux frameworks Java pour l'implémentation de services REST
layout: blog
---
En Java, il existe de nombreux frameworks pour implémenter un service REST : Spring MVC, Jersey,
RESTEasy, Restlet, Play framework, … Le but de ce billet est de comparer Spring MVC et Jersey. Ce
n'est pas un tutoriel sur REST, il en existe déjà d'excellents sur la toile<sup>[1](#note1)</sup>.
Il suppose que le lecteur a déjà une connaissance des architectures REST.

Afin d'effectuer la comparaison, j'ai développé le même service avec les deux frameworks. Ce service
est accessible en `GET`, par l'URI `/fib/{n}` et retourne en JSON les n premiers termes de la suite
de Fibonacci.

## Introduction

Jersey est l'implémentation de référence de la JSR-311 (JAX-RS). Spring MVC, bien que n'implémentant
pas cette JSR, couvre quasiment les mêmes fonctionnalités. J'ai utilisé les dernières versions
disponibles, à savoir 1.12 pour Jersey et 3.1.1 pour Spring. Depuis la version 3.0, il est conseillé
d'utiliser la nouvelle manière de créer des services en utilisant conjointement `@ResponseBody` avec
`HttpMessageConverter`<sup>[2](#note2)</sup>.

## Aperçu du code

Regardons à présent ce qui intéresse tous les développeurs, le code du service.

Jersey

```
package com.yannmoisan.restcmp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yannmoisan.restcmp.service.FibService;

@Controller
@RequestMapping("/fib")
public class FibController {

    @Autowired
    private FibService service;
    
    @RequestMapping(value = "/{n}", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public Fib getFib(@PathVariable String n) {
        return new Fib(service.calculate(Integer.valueOf(n)));
    }

}
```

Spring

```
package com.yannmoisan.restcmp;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.yannmoisan.restcmp.service.FibService;

@Component
@Path("/fib/{n}")
public class FibResource {

    @Autowired
    private FibService service;
    
    @GET
    @Produces({ MediaType.APPLICATION_JSON })
    public Fib getFib(@PathParam("n") String n) {
        return new Fib(service.calculate(Integer.valueOf(n)));
    }
}
```

Le code est assez ressemblant, seul les termes changent. Par exemple, `@Path` est l'équivalent de
`@RequestMapping`.

## Transformation en JSON

Jersey a un module jersey-json pour la transformation en JSON, qui offre 3 approches différentes :
POJO, JAXB et bas niveau. Dans notre exemple, on utilise l'approche POJO, la plus simple, basée sur
jackson. Il suffit d'activer le paramètre `POJOMappingFeature` sur la servlet.

```
<init-param>
    <param-name>com.sun.jersey.api.json.POJOMappingFeature</param-name>
    <param-value>true</param-value>
</init-param>
```

Avec Spring, il suffit d'indiquer `<mvc:annotation-driven />` et d'ajouter la librairie jackson dans
le classpath. Spring utilise alors automatiquement un `MappingJacksonHttpMessageConverter`.

## Intégration avec Spring

Dans les 2 cas, nous utilisons Spring pour l'injection de dépendances.

Jersey fournit un module jersey-spring qui contient une servlet
`com.sun.jersey.spi.spring.container.servlet.SpringServlet` qui réalise l'intégration avec Spring.

Avec Spring, bien évidemment, c'est natif.

## Tests automatisés

Jersey embarque nativement un framework de test : jersey-test-framework, qui permet de faire des
tests avec différents conteneurs.

```
package com.yannmoisan.restcmp;

import org.junit.Assert;
import org.junit.Test;
import org.springframework.web.context.ContextLoaderListener;

import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.spi.spring.container.servlet.SpringServlet;
import com.sun.jersey.test.framework.JerseyTest;
import com.sun.jersey.test.framework.WebAppDescriptor;

public class FibResourceTest extends JerseyTest {

    public FibResourceTest() throws Exception {
        super(new WebAppDescriptor.Builder("com.sun.jersey.samples.springannotations.resources.jerseymanaged")
                .contextPath("restcmp")
                .contextParam("contextConfigLocation", "classpath:mvc-dispatcher-servlet.xml")
                .servletClass(SpringServlet.class)
                .initParam("com.sun.jersey.api.json.POJOMappingFeature", "true")
                .contextListenerClass(ContextLoaderListener.class).build());
    }

    @Test
    public void testGetFib() {
        WebResource webResource = resource();
        String responseMsg = webResource.path("fib/10").get(String.class);
        Assert.assertEquals("{\"fib\":[1,1,2,3,5,8,13,21,34,55]}", responseMsg);
    }
}
```

Pour Spring, il faut utiliser un autre projet :
`spring-test-mvc` qui a vocation à être intégré au
module spring-test de Spring Framework. Ce projet se base sur l'utilisation de Mock et permet de
tester sans conteneur de Servlet. Pour récupérer la dépendance avec Maven, il faut ajouter le
repository maven snapshot de Spring.

```
package com.yannmoisan.restcmp;

import static org.springframework.test.web.server.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.server.setup.MockMvcBuilders.*;
import static org.springframework.test.web.server.result.MockMvcResultMatchers.*;

import org.junit.Test;
import org.springframework.test.web.server.MockMvc;

public class FibControllerTest {

    @Test
    public void testGetFib() throws Exception {
        String contextLoc = "classpath:mvc-dispatcher-servlet.xml";
        String warDir = "src/main/webapp";

        MockMvc mockMvc = xmlConfigSetup(contextLoc).configureWebAppRootDir(warDir, false).build();

        mockMvc.perform(get("/fib/10")).andExpect(content().string("{\"fib\":[1,1,2,3,5,8,13,21,34,55]}"));
    }
}
```

## Tests de bout en bout

Les tests de bout en bout permettent de vérifier que le résultat est identique, avec les 2 webapps
déployées sur un serveur tomcat.

```
$ curl http://localhost:8080/restcmp-jersey/fib/10
{"fib":[1,1,2,3,5,8,13,21,34,55]}
$ curl http://localhost:8080/restcmp-spring/fib/10
{"fib":[1,1,2,3,5,8,13,21,34,55]}
```

## Conclusion

Ma préférence va à Jersey car il est simple, standard et testable.

## Ressources externes

<p><a href="https://github.com/YannMoisan/restcmp">Le code source du billet</a></p>
<p id="note1">[1] <a href="http://rest.elkstein.org/">Learn REST: A Tutorial</a></p>
<p id="note2">[2] <del>Supporting XML and JSON web service endpoints in Spring 3.1 using @ResponseBody</del></p>
<p><a href="http://www.vogella.com/articles/REST/article.html">REST with Java (JAX-RS) using Jersey</a></p>
<p><a href="http://www.infoq.com/articles/springmvc_jsx-rs">A Comparison of Spring MVC and JAX-RS</a></p>
