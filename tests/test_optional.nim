import pkgconfexe/private/[ optional ]

import pkg/[ zero_functional ]

import std/[ sugar, unittest ]



suite "optional":
  test "none":
    let o = string.none()

    check:
      o.isNone()
      not o.isSome()


  test "some":
    let
      someInt = 32.some()
      someIntSet = { 0.int8 .. 67.int8 }.some()
      someArray = [ "pqfq", "" ].some()

    check:
      someInt.isSome()
      not someInt.isNone()

      someIntSet.isSome()
      not someIntSet.isNone()

      someArray.isSome()
      not someArray.isNone()



  test "get":
    [ -6498, 0, 1, 36465 ].zfun:
      foreach:
        let someInt = it.some()

        check:
          someInt.get() == it

    expect NoValueError:
      discard Slice[int].none().get()



  test "doIfSome":
    let
      someBool = true.some()
      noneSeq = seq[char].none()

    var boolVal = false

    someBool.doIfSome(
      proc (val: bool) =
        boolVal = val
    )

    noneSeq.doIfSome(
      proc (val: seq[char]) = discard,
      proc () =
        expect NoValueError:
          discard noneSeq.get()
    )

    check:
      boolVal == someBool.get()



  test "flatMap":
    let
      opt = int.none().flatMap((val: int) => (val == 0).some())
      someFloat = 34.some().flatMap((val: int) => val.float.some())

    check:
      opt.isNone()
      someFloat.get() == 34.0
