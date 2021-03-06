---
title: Tester unitairement la lecture d'un fichier, sans fichier !
description: Tester unitairement la lecture d'un fichier, sans utiliser de fichier.
layout: post
lang: fr
---
Nous allons voir comment tester unitairement un composant basé sur la lecture d'un fichier, sans
utiliser de fichier. Cette approche peut sembler étrange mais elle offre plusieurs avantages : le
test sera ainsi plus rapide, plus lisible (car le contenu à tester est dans le même fichier que le
test) et indépendant du système de fichier. Pour l'exemple, nous allons implémenter en java un
programme qui compte le nombre de lignes d'un fichier. L'astuce consiste à utiliser dans le code la
classe `java.io.Reader` et d'injecter un `java.io.StringReader` à la place du `java.io.FileReader`
dans le test.

Voyons comment faire :

```java
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class Counter {
    private final File source;

    public Counter(File source) {
        super();
        this.source = source;
    }
    
    public int countLines() {
        try (java.io.Reader reader = newReader()) {
            return countLines(reader);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    
    // for test purpose 
    protected java.io.Reader newReader() throws FileNotFoundException {
        return new FileReader(source);
    }
    
    private int countLines(java.io.Reader reader) {
        try (BufferedReader bufReader = new BufferedReader(reader)) {
            int count=0;
            while (bufReader.readLine() != null) {
                count++;
            }
            return count;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
```

```java
import static org.junit.Assert.assertEquals;

import java.io.FileNotFoundException;
import java.io.Reader;
import java.io.StringReader;

import org.junit.Test;

public class CounterTest {
    @Test
    public void test() {
        final String s = "a\nb\nc";
        Counter counter = new Counter(null) {
            @Override
            protected Reader newReader() throws FileNotFoundException {
                return new StringReader(s);
            }
        };
        assertEquals(3, counter.countLines());
    }
}
```

Voici l'explication de l'astuce : la méthode countLines() appelle une méthode protected pour
récupérer un reader et délègue le traitement 'fonctionnel' à la méthode countLines(Reader reader).
Il est ainsi possible d'étendre la classe afin de surcharger la méthode newReader.
