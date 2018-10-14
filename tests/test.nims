import std/[ strformat, strscans, strutils ]



include "common.nims"



for t in Tests:
  exec(fmt"""nim c -r 'test_{t}.nim'""")
