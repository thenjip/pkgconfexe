import pkg/zero_functional



type
  IndexHSlice* [L, U] = concept x of HSlice[L, U]
    L is SomeInteger
    U is SomeInteger
    x.a <= x.b

  IndexSlice* [I] = concept x of IndexHSlice[I, I]


  NonEmptyIndexHSlice* [L, U] = concept x of IndexHSlice[L, U]
    x.a < x.b

  NonEmptyIndexSlice* [I] = concept x of NonEmptyIndexHSlice[I, I]



func isEmpty* [L, U](hs: IndexHSlice[L, U]): bool {. locks: 0 .} =
  result = hs.a == hs.b


func isEmpty* [I](s: IndexSlice[I]): bool {. locks: 0 .} =
  result = s.isEmpty[: I, I]()



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
