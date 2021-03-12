---
title: Récupérer un type énuméré à partir d'un code
description: Récupération d'un type énuméré à partir d'un code, de la bonne utilisation des Generics de Java 5
layout: post
lang: fr
---
## La problématique

Le but de ce billet est d'implémenter un besoin très classique : plusieurs types avec un ensemble de
valeurs finies, accessibles à partir d'un code. Cela permet de représenter des statuts, des états, …

## La solution

Préambule : cet article fait référence à l'excellent livre de Joshua Bloch : Effective Java, 2nd
Edition.

Pour chaque type, un `Enum` est créé (cf Item 30 : Use enums instead of int constants) avec une
méthode servant de factory static (cf Item 1 : Consider static factory methods instead of
constructors). Afin de respecter le principe DRY, nous allons mettre en place un mécanisme afin de
ne pas dupliquer le code de cette méthode dans chaque type. Premièrement, une interface `Reference`
est créée (cf Item 34 : Emulate extensible enums with interfaces). Ensuite, une classe utilitaire
`References` est créée afin de servir de dictionnaire; c'est-à-dire pour stocker toutes les valeurs
de tous les types (cf Item 29 : Consider heterogeneous containers).

Reference

```
public interface Reference {
    public int getCode();
}
```

References

```
public class References {
    private static final Map<String, Map<Integer, Reference>> DICTIONARIES;

    static {
        DICTIONARIES = new HashMap<String, Map<Integer, Reference>>();
    }

    public static <T extends Enum<T> & Reference> void register(Class<T> clazz) {
        Map<Integer, Reference> dictionary = new HashMap<Integer, Reference>();
        for (Reference ref : clazz.getEnumConstants()) {
            dictionary.put(ref.getCode(), ref);
        }
        DICTIONARIES.put(clazz.getName(), dictionary);
    }

    public static <T extends Enum<T> & Reference> T fromCode(Class<T> clazz, int code) {
        return clazz.cast(DICTIONARIES.get(clazz.getName()).get(code));
    }

}
```

ExampleReference

```
public enum ExampleReference implements Reference {
    FOO(1),

    BAR(2);

    private final int code;

    private ExampleReference(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }

    static {
        References.register(ExampleReference.class);
    }

    public static ExampleReference fromCode(int code) {
        return References.fromCode(ExampleReference.class, code);
    }

    public static void main(String[] args) {
        System.out.println(ExampleReference.fromCode(1));
    }

}
```

Cette implémentation présente les limites suivantes :

-   Un enum ne pouvant pas étendre une classe, l'attribut code ainsi que le constructeur et le
    getter associé sont dupliqués dans chaque enum
-   Chaque objet doit déclarer un constructeur statique

Le lecteur remarquera au passage l'incroyable complexité des génériques, en particulier cette
syntaxe indigeste : `<T extends Enum<T> & Reference>`.

N'hésitez pas à me contacter si vous avez des suggestions d'améliorations.
