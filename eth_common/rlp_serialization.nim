import eth_types, rlp, nimcrypto, times

proc read*(rlp: var Rlp, T: typedesc[MDigest]): T {.inline.} =
  result.data = rlp.read(type(result.data))

proc append*(rlpWriter: var RlpWriter, a: MDigest) {.inline.} =
  rlpWriter.append(a.data)


proc read*(rlp: var Rlp, T: typedesc[EthTime]): T {.inline.} =
  result = fromUnix(rlp.read(int64))

proc append*(rlpWriter: var RlpWriter, t: EthTime) {.inline.} =
  rlpWriter.append(t.toUnix())


proc rlpHash*[T](v: T): Hash256 =
  keccak256.digest(rlp.encode(v).toOpenArray)
