module textures.textures;

import std.file;
import std.path;
import std.stdio;
import std.string;

final static class Textures {
static:

    void load() {
        foreach (DirEntry entry; dirEntries(getcwd(), SpanMode.depth)) {
            if (entry.isFile && entry.name.extension.toLower() == ".png") {
                // todo: load file into memory, save png as something. However raylib does it.
                writeln(entry.name);
            }
        }
    }
}
