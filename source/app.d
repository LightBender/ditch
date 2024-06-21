import std.file;
import std.path;
import std.stdio;

import ditch.map;

int main(string[] args)
{
	string headerPath = buildNormalizedPath(getcwd(), args[1]);
	auto hdrFile = File(headerPath, "r").byLineCopy();

	string[] fileLines;
	foreach(line; hdrFile) {
		fileLines ~= line;
	}

	string[] headers = mapIncludes(fileLines);
	foreach(hdr; headers) {
		writeln(hdr);
	}

	return 0;
}
