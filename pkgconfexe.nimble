version = "0.1.0"
author = "Thanh Tung Nguyen"
description = "Wrapper to query information from the pkgconf command line tool"
license = "MIT"

requires "nim >= 0.19.1",
  "unicodedb >= 0.5.2",
  "unicodeplus >= 0.3.2",
  "zero_functional >= 0.1.1"

srcDir = packageName
skipDirs = @[ "tests" ]



const TestDir = "tests"



task test, "Run the test suite":
  withDir TestDir:
    exec "nim".toExe & " e tester.nims"


task clean_test, "Clean the test suite":
  withDir TestDir:
    exec "nim".toExe & " e cleaner.nims"
