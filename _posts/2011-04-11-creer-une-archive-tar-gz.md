---
title: Créer une archive .tar.gz
description: Création d'une archive .tar.gz en Java
layout: blog
---
Aujourd'hui, nous allons voir comment créer en Java une archive au format .tar.gz, à partir de
plusieurs fichiers d'entrée. Ce format est en fait une archive au format tar qui est ensuite
compressé avec l'utilitaire gzip.

Java offre le support de la compression gzip avec le package `java.util.zip`. Par contre, Java ne
fournit pas le support de l'archive tar. Nous allons donc utiliser une implémentation tierce, la
plus populaire étant [Commons Compress](http://commons.apache.org/compress/) d'Apache.

Le code à écrire est relativement court et peu complexe. Mais il pose souvent des difficultés aux
développeurs débutants. Voici les différents points d'attention :

Pour des raisons de performance, il faut éviter de créer physiquement l'archive puis de la
compresser mais travailler directement en mémoire. Pour ce faire, nous allons utiliser le mécanisme
de chainage de streams de java.

Il faut aussi gérer finement les exceptions, à l'aide de blocs `finally`, afin de garantir la
fermeture des streams en toute circonstance.

```
public final class FileUtils {
    private static final int BUFFER_SIZE = 1024;

    // Suppresses default constructor, ensuring non-instantiability.
    private FileUtils() {
    }

    /**
     * Crée une nouvelle archive compressée au format tar gz.
     *
     * Vérifie préalablement que chaque fichier à archiver peut être lu. Si tel n'est pas le cas, une exception
     * est levée et le fichier archive n'est pas créé.
     *
     * @param ins les fichiers à archiver
     * @param out le fichier de sortie
     *
     * @throws TechnicalException si au moins un fichier ne peut être lu ou dans le cas d'erreurs d'E/S
     */
    public static void createTarGz(List$lt;File$gt; ins, File out) {
        check(ins);
        TarArchiveOutputStream taos = null;
        try {
            taos = new TarArchiveOutputStream(new GZIPOutputStream(new FileOutputStream(out)));
            addFilesToArchive(ins, taos);
        } catch (IOException ioe) {
            throw new TechnicalException(ioe);
        } finally {
            closeQuietly(taos);
        }
    }

    private static void check(List$lt;File$gt; ins) {
        for (File file : ins) {
            if (!file.canRead()) {
                throw new TechnicalException("The file \"" + file.getName() + "\" cannot be read.");
            }
        }
    }

    private static void addFilesToArchive(List$lt;File$gt; ins, TarArchiveOutputStream tos) throws IOException {
        for (File in : ins) {
            addFileToArchive(in, tos);
        }
    }

    private static void addFileToArchive(File in, TarArchiveOutputStream out) throws IOException {
        TarArchiveEntry entry = new TarArchiveEntry(in.getName());
        entry.setSize(in.length());
        out.putArchiveEntry(entry);
        copy(new FileInputStream(in), out);
        out.closeArchiveEntry();
    }

    /** Astuce : laisse le flux de sortie ouvert pour permettre les écritures ultérieures */
    private static void copy(InputStream in, OutputStream out) throws IOException {
        try {
            byte[] buffer = new byte[BUFFER_SIZE];
            int n = 0;
            while (-1 != (n = in.read(buffer))) {
                out.write(buffer, 0, n);
            }
        } finally {
            closeQuietly(in);
        }
    }

    private static void closeQuietly(InputStream in) {
        if (in != null) {
            try {
                in.close();
            } catch (IOException ioe) {
                // Silent catch
            }
        }
    }

    private static void closeQuietly(OutputStream out) {
        if (out != null) {
            try {
                out.close();
            } catch (IOException ioe) {
                // Silent catch
            }
        }
    }
```
