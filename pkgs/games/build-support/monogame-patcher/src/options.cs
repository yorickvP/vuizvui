using System.Collections.Generic;

using CommandLine;

class GenericOptions
{
    [Option('i', "infile", Required=true, HelpText="Input file to transform.")]
    public string inputFile { get; set; }
    [Option('o', "outfile", HelpText="File to write transformed data to.")]
    public string outputFile { get; set; }
}

[Verb("fix-filestreams", HelpText="Fix System.IO.FileStream constructors"
                                 +" to open files read-only.")]
class FixFileStreamsCmd : GenericOptions {
    [Value(0, Required=true, MetaName = "type", HelpText = "Types to patch.")]
    public IEnumerable<string> typesToPatch { get; set; }
};

[Verb("replace-call", HelpText="Replace calls to types.")]
class ReplaceCallCmd : GenericOptions {
    [Value(0, Min=2, Max=2, HelpText="Call to replace.")]
    public IEnumerable<string> replaceCall { get; set; }

    [Value(2, Required=true, MetaName = "type", HelpText = "Types to patch.")]
    public IEnumerable<string> typesToPatch { get; set; }

};
