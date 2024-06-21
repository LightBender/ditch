module ditch.map;

import std.algorithm.searching;
import std.algorithm.iteration;
import std.array;
import std.path;
import std.stdio;
import std.uni;

public class Header {
	public immutable string name;
	public Header[string] headers;


	public string[] lines;

	public this (string name, string[] lines) {
		this.name = name;
		this.lines = lines;
	}

	public void writeImportC(string outputPath) {
		auto hdrfile = File(buildNormalizedPath(outputPath, withExtension(name, ".h")).array, "w");
		auto cfile = File(buildNormalizedPath(outputPath, withExtension(name, ".c")).array, "w");
		scope(exit) {
			hdrfile.flush();
			hdrfile.close();
			cfile.flush();
			cfile.close();
		}

		foreach (string l; lines) {
			hdrfile.writeln(t);
		}

		cfile.writeln("#include \"" ~ withExtension(name, ".c").array ~ "\"");
	}
}

Header mapHeader(string path, Header[string] headers) {
	string headerPath = buildNormalizedPath(getcwd(), path);
	auto hdrFile = File(headerPath, "r").byLineCopy();

	string[] fileLines;
	foreach(line; hdrFile) {
		fileLines ~= line;
	}

	Header hdr = new Header(baseName(stripExtension(path)), fileLines);

	foreach(string line; headerLines) {
		string[] words = line.splitter!isWhite().array;

		if (words.length > 1) {
			for (int i = 0; i < words.length; i++) {
				if(words[i].canFind("#include")) {
					writeln("Found include directive: ", line);
					if (words[i+1][0] == '<' || words[i+1][0] == '"') {
						string hdrName = stripExtension(words[i+1][1..$-1]);
						if ((hdrName in headers) !is null) {
							hdr.headers[hdrName] = headers[hdrName];
						}
					}
				}
			}
		}
	}

	return hdr;
}
