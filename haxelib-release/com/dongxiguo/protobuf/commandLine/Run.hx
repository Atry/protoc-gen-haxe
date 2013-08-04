package com.dongxiguo.protobuf.commandLine;

import com.dongxiguo.utils.HaxelibRun;

/**
  @author 杨博
**/
class Run
{

  public static function main()
  {

    var args = Sys.args();
    var returnValue = HaxelibRun.run(args);
    if (returnValue == null)
    {
      switch (args)
      {
        case [ "generateBootstrapFiles", descriptorFileName, outputDirectory, cwd ]:
        {
          Sys.setCwd(cwd);
          BootstrapGenerator.generateBootstrapFiles(descriptorFileName, outputDirectory);
        }
        default:
        {
          Sys.print(HaxelibRun.usage());
          Sys.print('\nUsage: haxelib run ${HaxelibRun.libraryName()} generateBootstrapFiles descriptorFileName outputDirectory');
          Sys.exit(-1);
        }
      }
    }
    else
    {
      Sys.exit(returnValue);
    }
  }

}