---
title: Self-bound generic type
description: Self-bound generic type
layout: post
lang: fr
---
Ce billet porte sur les self-bound generic types. Mais que se cache derrière ce terme étrange.
Rassurez-vous, aucun développeur n'a été blessé pour réaliser ce billet. Laissons le besoin émerger
à travers un exemple. Le point de départ consiste à construire à l'aide de Builders deux objets,
Child1 et Child2, ayant une propriété commune. Voici une première implémentation naive. Pour des
raisons de clarté, nous n'affichons que le code nécessaire à la compréhension :

```java
public class Child1Builder {
    private String parentProperty;
    private String child1Property;

    public Child1Builder setParentProperty(String parentProperty) {
        this.parentProperty = parentProperty;
        return this;
    }
    
    public Child1Builder setChild1Property(String child1Property) {
        this.child1Property = child1Property;
        return this;
    }


    public static void main(String[] args) {
        Child1Builder childBuilder = new Child1Builder();
        childBuilder.setParentProperty("parent").setChild1Property("childProperty");
    }
}

public class Child2Builder {
    private String parentProperty;
    private String child2Property;

    public Child2Builder setParentProperty(String parentProperty) {
        this.parentProperty = parentProperty;
        return this;
    }
    
    public Child2Builder setChild2Property(String child2Property) {
        this.child2Property = child2Property;
        return this;
    }


    public static void main(String[] args) {
        Child2Builder childBuilder = new Child2Builder();
        childBuilder.setParentProperty("parent").setChild2Property("childProperty");
    }
}
```

Nous allons maintenant refactorer pour supprimer le code dupliqué de la méthode setParentProperty.

```java
public class ParentBuilder {
    public String parentProperty;

    public ParentBuilder setParentProperty(String parentProperty) {
        this.parentProperty = parentProperty;
        return this;
    }
}

public class Child1Builder extends ParentBuilder {
    private String child1Property;

    public Child1Builder setChild1Property(String child1Property) {
        this.child1Property = child1Property;
        return this;
    }


    public static void main(String[] args) {
        Child1Builder childBuilder = new Child1Builder();
        childBuilder.setParentProperty("parent").setChild1Property("childProperty");
    }
}
```

Malheureusement, ce code ne compile pas car la méthode `setParentProperty` renvoie une instance de
`ParentBuilder` et il n'est pas possible de chainer l'appel à `setChildProperty`. La méthode
setParentProperty a besoin de renvoyer le type de la classe dérivée. L'astuce consiste à utiliser
une méthode getThis().

```java
public abstract class ParentBuilder<T> {
    public String parentProperty;

    public T setParentProperty(String parentProperty) {
        this.parentProperty = parentProperty;
        return getThis();
    }
    
    public abstract T getThis();
}

public class Child1Builder extends ParentBuilder<Child1Builder> {
    private String child1Property;

    public Child1Builder setChild1Property(String child1Property) {
        this.child1Property = child1Property;
        return this;
    }

    public static void main(String[] args) {
        Child1Builder childBuilder = new Child1Builder();
        childBuilder.setParentProperty("parent").setChild1Property("childProperty");
    }

    @Override
    public Child1Builder getThis() {
        return this;
    }
}
```

Bien que ce code fonctionne, il est possible de l'améliorer. Le paramètre générique `T` doit être une
sous-classe de `ParentBuilder`. Cela donne donc l'expression `class ParentBuilder<T extends
ParentBuilder<T>>` qui peut paraitre étrange et montre la complexité des génériques qui se
cache derrière leur apparente simplicité. C'est ce que l'on appelle un self-bound generic type.

Source :

-   [Strategy Pattern with
    Generics](http://www.javaspecialists.co.za/archive/newsletter.do?issue=123)
-   [How do I recover the actual type of the this object in a class
    hierarchy?](http://www.angelikalanger.com/GenericsFAQ/FAQSections/ProgrammingIdioms.html#FAQ205)

