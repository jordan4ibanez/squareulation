module textures.textures;

import core.sys.posix.libgen;
import raylib;
import std.file;
import std.path;
import std.stdio;
import std.string;

final static class Textures {
static:

    Texture2D[string] database;

    void load() {

        string rootDir = absolutePath(getcwd());

        foreach (DirEntry entry; dirEntries(rootDir, SpanMode.depth)) {
            if (entry.isFile && entry.name.extension.toLower() == ".png") {
                // todo: load file into memory, save png as something. However raylib does it.

                string fullPath = entry.name;
                string fileName = fullPath.baseName;

                // This may be sloppy, but I don't want it to be that sloppy.
                if (fileName in database) {
                    throw new Exception(fileName ~ " is a duplicate! Hit in: " ~ fullPath);
                } else {
                    database[fileName] = LoadTexture(fullPath.toStringz);
                }
            }
        }
    }
}
