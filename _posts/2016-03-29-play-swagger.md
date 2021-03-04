---
title: Add a swagger documentation on a Play application
description: Add a swagger documentation on a Play application
layout: blog
---
The starting point of this post is the need to document an existing REST APIs. I want the
documentation to live with my code because I think it's the only way to have an up-to-date doc.
Swagger seems to be a defacto standard. This post is not a tutorial, it's just to share some issues
I faced. So let's get the party started.

I use PlayFramework and Scala. Thankfully, an integration already exists :
[play-swagger](https://github.com/swagger-api/swagger-play). Play-swagger relies mainly on
annotations. I'm not a big fan of annotations, maybe because they remind me of my long years of Java
EE development. Last point, my APIs uses snake case and because swagger-core introspect fields, the
default behaviour won't work as expected.

## Tuple serialization

Some of my services returns `Tuple`, so I have a custom `Writes`

```
  implicit val tupleWrites :  Writes[(Int, String)] = Writes[(Int, String)] {
    case (id, action) =>
        Json.obj(
          "tip_id" -> id,
          "action" -> action
        )
  }
```

Swagger uses the return type of your operation method. It detects `ActionAnyContent` or
`ActionJsValue`, depending on the BodyParser you use, that is never what you want. (I don't
understand how the erroneous concatenation happens between the type `Action` and the type parameter
`JsValue`).

```
"responses": {
  "200": {
    "description": "successful operation",
    "schema": {
      "$ref": "#/definitions/ActionAnyContent"
    }
  }
}
```

So we have to explicitly set the response class with the following annotation :

```
@ApiOperation(response = classOf[Tuple2[Int, String]])
```

Due to Java type erasure, swagger will only generate :

```
"definitions": {
    "Tuple2": {
      "type": "object",
      "properties": {
        "_1": {
          "type": "object"
        },
        "_2": {
          "type": "object"
        }
      }
    },
```

In fact, play-swagger has no idea how the Tuple is serialized and I came up with a trick to generate
the documentation by creating a fake case class.

```
@ApiModel(value="Tip id and action")
case class TipIdAndAction(
  @ApiModelProperty(name="tip_id", required=true) tipId: Id,
  @ApiModelProperty(required=true) action: String)
```

The annotation `@ApiModelProperty` is used to specify the name because I use snake case in JSON and
camel case in Scala.

Lastly, this annotation should be added on the action :

```
@ApiOperation(response = classOf[TipIdAndAction])
```

In fact, there are some cases where you can have different representation of a model, at least for
read and write. For example, a timestamp is forbidden at creation but mandatory during retrieval. It
seems impossible to do that with swagger annotations.

And now, I have to maintain the mapping and the case class. It seems boring and error prone. So
let's get rid of the Tuple and use case class instead.

```
implicit val actionWrites :  Writes[TipIdAndAction] = Writes[TipIdAndAction] { ta =>
Json.obj(
  "tip_id" -> ta.tipId,
  "action" -> ta.action
)
}
```

Either I can modify my service to return a `TipIdAndAction` or I have to transform a Tuple into a
`TipIdAndAction`. At first sight, the last idea seems like the return of the DTO antipattern, a
really bad idea. Nevertheless, I'd prefer that over polluting my domain model with swagger
annotations.

I can also use [JSON Macro
inception](https://playframework.com/documentation/2.4.x/ScalaJsonInception) and
[play-json-naming](https://github.com/tototoshi/play-json-naming) to avoid writing the `Writes`
class. Unfortunately, I still need annotations on the case class. So now, all the boilerplate is
just for swagger purpose. Even if Macro Inception is great, beware that a simple renaming of a
property will change the JSON output, so the contract of your API.

```
  implicit val actionWrites : Writes[TipIdAndAction] = JsonNaming.snakecase(Json.writes[TipIdAndAction])
```

## Nested annotation

for @ApiResponses, the syntax mentioned in the swagger doc triggers a compilation issue for an
unknown reason (let me know if you know) :

```
@ApiResponses(value = { 
      @ApiResponse(code = 400, message = "Invalid ID supplied", 
                   responseHeaders = @ResponseHeader(name = "X-Rack-Cache", description = "Explains whether or not a cache was used", response = Boolean.class)),
      @ApiResponse(code = 404, message = "Pet not found") })
```

## Manage HTTP Header

For HTTP Header, like `Accept-Language`, you have to copy/paste the following on each operation that
deals with this header.

```
  new ApiImplicitParam(
    name = "Accept-Language", 
    value = "language for the tip in the response", 
    defaultValue = "en", 
    required = false, 
    paramType = "header", 
    dataType="string"
  )
```

Finally, I still have two questions :

-   [How do you model an empty
    body](http://stackoverflow.com/questions/36306341/how-do-you-model-an-empty-body-with-swagger-annotation)
-   [Why swagger-ui doesn't display the response model for an alternate
    response](http://stackoverflow.com/questions/36304732/swagger-ui-doesnt-display-the-response-model-for-a-400)

## Conclusion

Using swagger with Play is a pain. It forces you to break the DRY rule. But it remains better than
writing swagger with a tool like Swagger Editor, due to the colocation of the spec with the code.
Here are some points of attention :

-   Beware of always mentioning an explicit response class
-   Don't use snake case to benefit from swagger automatic generation
-   Don't use Tuples
-   Don't pollute your domain model with annotations

