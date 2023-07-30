// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Fs from "fs";
import * as Path from "path";
import * as Config from "../entities/Config.bs.mjs";
import * as Stdlib from "@dzakh/rescript-stdlib/src/Stdlib.bs.mjs";
import * as SourceDirs from "../entities/SourceDirs.bs.mjs";

function make() {
  return function (config) {
    var tmp;
    try {
      tmp = {
        TAG: "Ok",
        _0: Fs.readFileSync(Path.resolve(Config.getProjectPath(config), "lib/bs/.sourcedirs.json"), {
                encoding: "utf8"
              }).toString()
      };
    }
    catch (exn){
      tmp = {
        TAG: "Error",
        _0: "RescriptCompilerArtifactsNotFound"
      };
    }
    return Stdlib.Result.flatMap(tmp, (function (file) {
                  return Stdlib.Result.mapError(SourceDirs.fromJsonString(file), (function (error) {
                                return {
                                        TAG: "ParsingFailure",
                                        _0: error
                                      };
                              }));
                }));
  };
}

export {
  make ,
}
/* fs Not a pure module */
