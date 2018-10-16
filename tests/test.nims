import std/strformat


include "common.nims"



for t in Tests:
  exec(fmt"""nim c -r 'test_{t}.nim'""")
