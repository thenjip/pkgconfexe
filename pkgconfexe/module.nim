import comparator, package, version
import private/[ scanresult, seqindexslice, utf8 ]

import std/[ strformat, sugar ]


export comparator



type Module* = object
  pkg*: string
  cmp*: Comparator
  version*: string



func buildModule* (pkg: string; cmp: Comparator; version: string): Module =
  Module(pkg: pkg, cmp: cmp, version: version)



func `==`* (l, r: Module): bool =
  l.cmp == r.cmp and l.pkg == r.pkg and l.version == r.version



func `$`* (self: Module): string =
  fmt"{self.pkg}{self.cmp}{self.version}"



func scanModule* (input: string; start: Natural): Optional[ScanResult[Module]] =
  input.scanPackage(start).flatMap(
    func (pkgSlice: SeqIndexSlice): Optional[ScanResult[Module]] =
      input.scanComparator(
        ((i: Natural) => i + input.skipSpaces(i))(pkgSlice.b + 1)
      ).flatMap((cmpSlice: SeqIndexSlice, cmp: Comparator) =>
        input.scanVersion(
          ((i: Natural) => i + input.skipSpaces(i))(cmpSlice.b + 1)
        ).flatMap((versionSlice: SeqIndexSlice) =>
          someScanResult(
            start,
            versionSlice.b + 1,
            buildModule(input[pkgSlice], cmp, input[versionSlice])
          )
        )
      )
  )


func scanModule* (input: string): Optional[ScanResult[Module]] =
  input.scanModule(input.low())



func module* (input: static[string]; start: static[Natural]): Module =
  input.scanModule(start).get().value()


func module* (input: static[string]): Module =
  input.scanModule().get().value()
