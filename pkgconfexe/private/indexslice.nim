import pkg/zero_functional



## Index slices are slices whose lower bound is always less than its uper bound.



type
  SomeIndexInteger* = SomeInteger | SomeOrdinal | range


  IndexHSlice* [L, U: SomeIndexInteger] = concept x of HSlice[L, U]
    x.a <= x.b

  IndexSlice* [I: SomeIndexInteger] = concept x of Slice[I]
    x.a <= x.b


  NonEmptyIndexHSlice* [L, U: SomeIndexInteger] =
    concept x of HSlice[L, U]
      x.a < x.b

  NonEmptyIndexSlice* [I: SomeIndexInteger] = concept x of Slice[I]
    x.a < x.b



func isEmpty* [L, U: SomeIndexInteger](hs: HSlice[L, U]): bool {. locks: 0 .} =
  result = hs.a == hs.b


func isEmpty* [I: SomeIndexInteger](s: Slice[I]): bool {. locks: 0 .} =
  result = s.a == s.b



static:
  [
    0 .. 0,
    Natural.low().int .. Natural.high().int,
    1088943 .. 982037420
  ].zfun:
    foreach:
      doAssert(it is IndexHSlice[int, int])
      doAssert(it is IndexSlice[int])

  [ -1..0, int.low() .. -9, 242 .. 98, 23 .. -56 ].zfun:
    foreach:
      doAssert(it isnot IndexHSlice[int, int])
      doAssert(it isnot IndexSlice[int])

  [ -1 .. -1, 0 .. 0, 4983094 .. 4983094 ].zfun:
    foreach:
      doAssert(it.isEmpty())
