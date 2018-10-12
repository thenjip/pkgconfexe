from std/ospaths import PathSep
import std/[ strformat, strutils ]



type
  EnvVar* {. pure .} = enum
    PkgConfigLibdir = "PKG_CONFIG_LIBDIR"
    PkgConfigPath = "PKG_CONFIG_PATH"
    PkgConfigSysrootDir = "PKG_CONFIG_SYSROOT_DIR"

  EnvInfo* = tuple
    libdirs: seq[string]
    pkgPaths: seq[string]
    sysrootDir: string



func `$`* (info: EnvInfo): string {. locks: 0 .} =
  var results: seq[string]

  for ev in EnvVar:
    result.add(fmt"""{$ev}="""")

    case ev:
      of PkgConfigLibdir:
        result.add(info.libdirs.join($PathSep))
      of PkgConfigPath:
        result.add(info.pkgPaths.join($PathSep))
      of PkgConfigSysrootDir:
        result.add(info.sysrootDir)

    result.add('\"')
    results.add(result)
    result = ""

  result = results.join($' ')



func buildEnv* (info: EnvInfo): string {. locks: 0 .} =
  result = $info
