import comparator, package, version
import private/[ scanresult, seqindexslice, utf8 ]

import std/[ sugar ]


export comparator



type
  VersionInfo* = object
    cmp*: Comparator
    version*: string

  Module* = object
    pkg*: string
    versionInfo*: Optional[VersionInfo]



func buildModule* (pkg: string): Module {. locks: 0 .} =
  Module(pkg: pkg, versionInfo: VersionInfo.none())


func buildModule* (pkg: string; cmp: Comparator; version: string): Module {.
  locks: 0
.} =
  Module(pkg: pkg, versionInfo: VersionInfo(cmp: cmp, version: version).some())



func hasVersion* (self: Module): bool {. locks: 0 .} =
  self.versionInfo.isSome()



func `==` (l, r: VersionInfo): bool {. locks: 0 .} =
  l.cmp == r.cmp and l.version == r.version


func `==`* (l, r: Module): bool {. locks: 0 .} =
  if l.hasVersion():
    r.hasVersion() and
      l.pkg == r.pkg and l.versionInfo.get() == r.versionInfo.get()
  else:
    (not r.hasVersion()) and l.pkg == r.pkg



func `$` (vi: VersionInfo): string {. locks: 0 .} =
  $vi.cmp & vi.version


func `$`* (self: Module): string {. locks: 0 .} =
  self.pkg & self.versionInfo.ifSome((vi: VersionInfo) => $vi, "")



func scanModule* (
  input: string; start: Natural
): Optional[ScanResult[Module]] {. locks: 0 .} =
  input.scanPackage(start).flatMap(
    func (pkgSlice: SeqIndexSlice): Optional[ScanResult[Module]] =
      if pkgSlice.b == input.high():
        someScanResult(
          pkgSlice.a, pkgSlice.len(), input[pkgSlice].buildModule()
        )
      else:
        input.scanComparator(
          ((i: Natural) =>
            i + input.skipSpaces(i)
          )(pkgSlice.b + 1)
        ).flatMapOr(
          someScanResult(
            pkgSlice.a, pkgSlice.len(), input[pkgSlice].buildModule()
          ),
          (cmpSlice: SeqIndexSlice, cmp: Comparator) =>
            input.scanVersion(
              ((i: Natural) =>
                i + input.skipSpaces(i)
              )(cmpSlice.b + 1)
            ).flatMap((versionSlice: SeqIndexSlice) =>
              someScanResult(
                start,
                versionSlice.b + 1,
                input[pkgSlice].buildModule(cmp, input[versionSlice])
              )
            )
        )
  )


func scanModule* (input: string): Optional[ScanResult[Module]] {. locks: 0 .} =
  input.scanModule(input.low())



func module* (input: static[string]; start: static[Natural]): static[Module] {.
  locks: 0
.} =
  input.scanModule(start).get().value()


func module* (input: static[string]): static[Module] {. locks: 0 .} =
  input.scanModule().get().value()
