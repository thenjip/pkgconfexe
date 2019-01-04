import comparator, package, version
import private/[ scanresult, seqindexslice ]

import std/[ strformat ]


export comparator



type
  VersionInfo* = object
    cmp: Comparator
    version: string

  Module* = object
    pkg*: string
    versionInfo: Optional[VersionInfo]



func buildModule* (pkg: string): Module {. locks: 0 .} =
  Module(pkg: pkg, versionInfo: VersionInfo.none())


func buildModule* (pkg: string; cmp: Comparator; version: string): Module {.
  locks: 0
.} =
  Module(pkg: pkg, versionInfo: VersionInfo(cmp: cmp, version: version).some())



func hasVersion* (m: Module): bool {. locks: 0 .} =
  m.versionInfo.isSome()



func cmp (m: Module): Comparator {. locks: 0 .} =
  m.versionInfo.get().cmp


func version (m: Module): string {. locks: 0 .} =
  m.versionInfo.get().version



func `==`* (l, r: Module): bool {. locks: 0 .} =
  if l.hasVersion():
    r.hasVersion() and
      l.pkg == r.pkg and l.cmp == r.cmp and l.version == r.version
  else:
    (not r.hasVersion()) and l.pkg == r.pkg



func `$`* (m: Module): string {. locks: 0 .} =
  result =
    if m.hasVersion():
      fmt"{m.pkg}{$m.cmp}{m.version}"
    else:
      m.pkg



func scanModule* (
  input: string; start: Natural
): Optional[ScanResult[Module]] {. locks: 0 .} =
  input.scanPackage(start).flatMap(
    func (pkgSlice: SeqIndexSlice): Optional[ScanResult[Module]] {.
      locks: 0
    .} =
      if pkgSlice.b == input.high():
        someScanResult(
          pkgSlice.a, pkgSlice.len(), input[pkgSlice].buildModule()
        )
      else:
        input.scanComparator(pkgSlice.b + 1).flatMapOr(
          someScanResult(
            pkgSlice.a, pkgSlice.len(), input[pkgSlice].buildModule()
          ),
          func (
            cmpSlice: SeqIndexSlice; cmp: Comparator
          ): Optional[ScanResult[Module]] {. locks: 0 .} =
            input.scanVersion(cmpSlice.b + 1).flatMap(
              func (
                versionSlice: SeqIndexSlice
              ): Optional[ScanResult[Module]] {. locks: 0 .} =
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
