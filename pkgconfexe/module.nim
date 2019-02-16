import comparator, package, version
import private/[ scanhelper, scanresult, utf8 ]

import std/[ options, strformat, sugar ]


export comparator



type Module* = object
  pkg*: string
  cmp*: Comparator
  version*: string



func `==`* (l, r: Module): bool =
  l.pkg == r.pkg and l.cmp == r.cmp and l.version == r.version



func `$`* (self: Module): string =
  fmt"{self.pkg}{self.cmp}{self.version}"



func scanModule* (input: string; start: Natural): Option[Module] =
  input.scanPackage(start).ifHasResult(
    (pkgSlice: SeqIndexSlice) =>
      input.scanComparator(
        ((i: Natural) => i + input.skipWhiteSpaces(i))(pkgSlice.b + 1)
      ).ifHasResult(
        (cmpSlice: SeqIndexSlice) =>
          input.scanVersion(
            ((i: Natural) => i + input.skipWhiteSpaces(i))(cmpSlice.b + 1)
          ).ifHasResult(
            (versionSlice: SeqIndexSlice) =>
              Module(
                pkg: input[pkgSlice],
                cmp: input[cmpSlice].findComparator().get(),
                version: input[versionSlice]
              ).some()
            ,
            returnNone[Module]
          )
        ,
        returnNone[Module]
      )
    ,
    returnNone[Module]
  )


func scanModule* (input: string): Option[Module] =
  input.scanModule(input.low())



func isModule* (x: string): bool =
  x.scanModule().isSome()



func module* (input: static[string]): Module =
  input.scanModule().get()
