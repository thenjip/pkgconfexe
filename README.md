# PkgconfExe

Wrapper to get information from the [pkgconf](http://pkgconf.org/) command line tool for [Nim](https://nim-lang.org/) modules at compile time.

## Usage

The simplest form:

```Nim
import pkgconfexe

{.
  checkModules: [
    "libpkgconf >= 1.0",
    "some-module_1 <= R12b+git2018-12-25",
    "ØMQ == 4.1.0" # Supports UTF-8 characters as well.
  ]
.}
# Equivalent to:
#[
{.
  passC: gorge("pkgconf --cflags --atleast-version 1.0 libpkgconf"),
  passC: gorge(
    "pkgconf --cflags --max-version R12b+git2018-12-25 some-module_1"
  ),
  passC: gorge("pkgconf --cflags --exact-version 4.1.0 ØMQ"),

  passL: gorge("pkgconf --ldflags --atleast-version 1.0 libpkgconf"),
  passL: gorge(
    "pkgconf --ldflags --max-version R12b+git2018-12-25 some-module_1"
  ),
  passL: gorge("pkgconf --ldflags --exact-version 4.1.0 ØMQ")
.}
]#

type
  TPkgConfPkg*
    {. importc: "pkgconf_pkg_t", header: "libpkgconf.h", incompleteStruct.}
    = tuple
```

Specifying one or more environment variables in the generated command line:

```Nim
import pkgconfexe

# We add some paths to be looked for PC files.
checkModules "libpkgconf >= 1.0":
  withEnv:
    (EnvVar.PkgConfigPath, "~/.local/lib/pkgconfig:~/.local/lib/pkgconfig")
    (EnvVar.PkgConfigLibdir, "/usr/lib/lib32/pkgconfig")
# Equivalent to:
#[
{.
  passC: gorge(
    """PKG_CONFIG_PATH="~/.local/lib/pkgconfig:~/.local/lib/pkgconfig" """ &
      """PKG_CONFIG_LIBDIR="/usr/lib/lib32/pkgconfig" """ &
      "pkgconf --cflags --atleast-version 1.0 libpkgconf"
  ),
  passL: gorge(
    """PKG_CONFIG_PATH="~/.local/lib/pkgconfig:~/.local/lib/pkgconfig" """ &
      """PKG_CONFIG_LIBDIR="/usr/lib/lib32/pkgconfig" """ &
      "pkgconf --ldflags --atleast-version 1.0 libpkgconf"
  ),
.}
]#

type
  TPkgConfPkg*
    {. importc: "pkgconf_pkg_t", header: "libpkgconf.h", incompleteStruct .}
    = tuple
```

### Other details

* Multiple `checkModules` calls in the same Nim module is supported. They do not conflict with each other.
* If you are only interested in passing linker flags, simply call `addLdFlags` instead of `checkModules`.
* Or just compiler flags ? `addCFlags` will do it for you.

## Dependencies

* nim >= 0.19.4
* unicodedb >= 0.6.0 (run-time only)
* unicodeplus >= 0.4.0 (run-time only)

* The pkgconf executable in the current working directory or $PATH (only needed at compile time)

## TODO

* [ ] Support Unicode numeric characters at compile-time.
* [ ] Support all environment variables used by pkgconf
* [ ] Support all version comparators (<<, >>, !=)
* [ ] Support all compiler flag results given by pkgconf (e.g. --cflags-only-I)
* [ ] API to specify parameters/options with the DSL
* [ ] API to get other types of result than compiler flags given by pkgconf
