import operator, package, version
import private/utf8

import pkg/unicodeplus

import std/[ strformat, strscans ]
import std/unicode except isWhiteSpace


export operator



type Module* = tuple
  pkg: string
  op: Operator
  version: string



func `$`* (m: Module): string {. locks: 0 .} =
  result =
    if m.version.len() == 0:
      m.pkg
    else:
      fmt"{m.pkg}{$m.op}{m.version}"



func scanfModule* (input: string; m: var Module; start: int): int {.
  locks: 0
.} =
  result = 0
  var tmp: Module

  let pkgLen = input.scanfPackage(tmp.pkg, start)

  if pkgLen > 0:
    result += pkgLen + input.skipWhitespaces(start + pkgLen)
    let opLen = input.scanfOperator(tmp.op, start + result)

    if opLen > 0:
      result += opLen + input.skipWhitespaces(start + opLen)
      let versionLen = input.scanfVersion(tmp.version, start + result)

      if versionLen == 0:
        result -= opLen
      else:
        result += versionLen

  m = tmp



func toModule* (s: string): Module {. locks: 0, raises: [ ValueError ] .} =
  if not s.scanf(
    "$[skipWhiteSpaces]${scanfModule}$[skipWhiteSpaces]$.",
    result
  ):
    raise newException(ValueError, fmt""""{s}" is not a valid module.""")
