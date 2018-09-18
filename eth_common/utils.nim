import nimcrypto, hashes, byteutils, eth_types

proc hash*(d: MDigest): Hash {.inline.} = hash(d.data)

proc toDigestAux(len: static[int], s: string): MDigest[len] =
  hexToByteArray(s, result.data)

proc toDigest*(hexString: static[string]): auto =
  toDigestAux(hexString.len div 2 * 8, hexString)

proc parseAddress*(hexString: string): EthAddress =
  hexToPaddedByteArray[20](hexString)

proc `$`*(a: EthAddress): string =
  a.toHex()

