  
import math
import strutils
import base64
import os

const LOGINS_XOR_X: string = "F"
const LOGINS_XOR_STR {.strdefine.}: string = """89h9idsa-.;lopuhuisiad[;3ruw09er9weijo'-[9RUEAFJDOS'P[I-9EFWUOSRIQ-0[ARE']A[-0ES9UTOJ'GZEWS'AFE[-0RG'[O4[0R-JZ'PEA[IR=0P]E0IAP["""

proc `xor`(str1, str2: string): string =
  if str1.len != str2.len:
    raise newException(ValueError, "str1.len != str2.len")
  for idx in 0..str1.high:
    result.add(char(uint8(str1[idx]) xor uint8(str2[idx])))

let LOGINS_XOR: string = LOGINS_XOR_STR xor LOGINS_XOR_X.repeat(LOGINS_XOR_STR.len)

proc strXor(password: string, xorKey: string = LOGINS_XOR): string =
  let xorAmount: int = int(ceil(password.len / xorKey.len))
  let xorKey: string = xorKey.repeat(xorAmount)
  let passwordPadded: string = password.alignLeft(xorKey.len, '\0')
  return passwordPadded xor xorKey

proc hideStr*(password: string, xorKey: string = LOGINS_XOR): string =
  return base64.encode(strXor(password, xorKey))

proc showStr*(password: string, xorKey: string = LOGINS_XOR): string =
  return $strXor(base64.decode(password), xorKey).cstring


when isMainModule:
  let password: string = paramStr(1)
  let passwordXOr1: string = password.hideStr()

  echo passwordXOr1