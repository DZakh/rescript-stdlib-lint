// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Fs from "fs";
import * as Path from "path";
import * as Config from "../entities/Config.bs.mjs";
import * as BsConfig from "../entities/BsConfig.bs.mjs";
import * as Stdlib_Result from "@dzakh/rescript-stdlib/src/Stdlib_Result.bs.mjs";

function make(param) {
  return function (config) {
    return Stdlib_Result.mapError(BsConfig.fromJsonString(Fs.readFileSync(Path.resolve(Config.getProjectPath(config), "bsconfig.json"), {
                          encoding: "utf8"
                        }).toString()), (function (error) {
                  return /* ParsingFailure */{
                          _0: error
                        };
                }));
  };
}

export {
  make ,
}
/* fs Not a pure module */
