open NodeJs

@module("minimist")
external parseCommandArguments: (array<string>, unit) => S.unknown = "default"

type error = CommandNotFound | IllegalOption({optionName: string})
type command = Help | Lint | LintHelp

let make = (~runLintCommand, ~runHelpCommand, ~runLintHelpCommand) => {
  (. ()) => {
    let commandArguments = Process.process->Process.argv->Js.Array2.sliceFrom(2)
    let result =
      commandArguments
      ->parseCommandArguments()
      ->S.parseWith(
        S.union([
          S.object1(. (
            "_",
            S.union([S.tuple0(.), S.tuple1(. S.literalVariant(String("help"), ()))]),
          ))
          ->S.Object.strict
          ->S.transform(~parser=() => Help, ()),
          S.object1(. (
            "_",
            S.tuple2(. S.literalVariant(String("help"), ()), S.literalVariant(String("lint"), ())),
          ))
          ->S.Object.strict
          ->S.transform(~parser=(((), ())) => LintHelp, ()),
          S.object1(. ("_", S.tuple1(. S.literalVariant(String("lint"), ()))))
          ->S.Object.strict
          ->S.transform(~parser=() => Lint, ()),
        ]),
      )
      ->Lib.Result.mapError((. error) => {
        switch error.code {
        | InvalidUnion(unionErrors) => {
            let maybeIllegalOptionName =
              unionErrors
              ->Js.Array2.find(error =>
                switch error.code {
                | ExcessField(_) => true
                | _ => false
                }
              )
              ->Belt.Option.map(excessFieldError => {
                switch excessFieldError.code {
                | ExcessField(illegalOptionName) => illegalOptionName
                | _ =>
                  Js.Exn.raiseError("The excessFieldError always must have the ExcessField code")
                }
              })

            switch maybeIllegalOptionName {
            | Some(illegalOptionName) => IllegalOption({optionName: illegalOptionName})
            | None => CommandNotFound
            }
          }

        | _ => Js.Exn.raiseError("Parsed error always must have the InvalidUnion code")
        }
      })

    switch result {
    | Ok(Help) => runHelpCommand(.)
    | Ok(LintHelp) => runLintHelpCommand(.)
    | Ok(Lint) => runLintCommand(.)
    | Error(error) =>
      switch error {
      | CommandNotFound => Js.log2("Command not found:", commandArguments->Js.Array2.joinWith(" "))
      | IllegalOption({optionName}) => Js.log2("Illegal option:", optionName)
      }
      Process.process->Process.exitWithCode(1)
    }
  }
}
