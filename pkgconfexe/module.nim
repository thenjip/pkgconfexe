import comparator, package, version
import private/[ scanresult ]

import pkg/zero_functional

import std/[ options, strformat ]


export comparator



type
  VersionInfo* = tuple
    cmp: Comparator
    version: string

  Module* = object
    pkg*: string
    versionInfo: Option[VersionInfo]



func buildModule* (pkg: string): Module {. locks: 0 .} =
  result = Module(pkg: pkg, versionInfo: options.none(VersionInfo))


func buildModule* (pkg: string; cmp: Comparator; version: string): Module {.
  locks: 0
.} =
  result = Module(pkg: pkg, versionInfo: (cmp: cmp, version: version).some())



func hasVersion* (m: Module): bool {. locks: 0 .} =
  result = m.versionInfo.isSome()



func cmp (m: Module): Comparator {. locks: 0 .} =
  result = m.versionInfo.unsafeGet().cmp


func version (m: Module): string {. locks: 0 .} =
  result = m.versionInfo.unsafeGet().version



func `==`* (l, r: Module): bool {. locks: 0 .} =
  result =
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



func scanModule* (input: string; start: Natural): ScanResult[Module] =
  result = input.scanPackage(start).flatMap(
    func (pkgSlice: SeqIndexSlice): ScanResult[Module] =
      result =
        if pkgSlice.b == input.high():
          input[pkgSlice].buildModule().someScanResult(
            pkgSlice.a, pkgSlice.len()
          )
        else:
          input.scanComparator(pkgSlice.b + 1).flatMapOr(
            input[pkgSlice].buildModule().someScanResult(
              pkgSlice.a, pkgSlice.len()
            ),
            func (
              cmp: Comparator; cmpSlice: SeqIndexSlice
            ): ScanResult[Module] =
              result =
                if cmpSlice.b == input.high():
                  Module.emptyScanResult()
                else:
                  input.scanVersion(cmpSlice.b + 1).flatMap(
                    func (versionSlice: SeqIndexSlice): ScanResult[Module] =
                      result = input[pkgSlice].buildModule(
                        cmp, input[versionSlice]
                      ).someScanResult(start, versionSlice.b + 1)
                  )
          )
  )


func scanModule* (input: string): ScanResult[Module] =
  result = input.scanModule(input.low())



func module* (input: static[string]; start: static[Natural]): static[Module] =
  result = input.scanModule(start).get()


func module* (input: static[string]): static[Module] =
  result = input.scanModule().get()
