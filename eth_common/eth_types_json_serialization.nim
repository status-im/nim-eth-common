import
  times,
  json_serialization, nimcrypto/hash, eth_types

proc writeValue*(w: var JsonWriter, a: MDigest) {.inline.} =
  w.writeValue $a

proc writeValue*(w: var JsonWriter, value: StUint) =
  w.writeValue $value

proc writeValue*(w: var JsonWriter, value: Stint) =
  # The Ethereum Yellow Paper defines the RLP serialization only
  # for unsigned integers:
  {.error: "RLP serialization of signed integers is not allowed".}
  discard

proc writeValue*(w: var JsonWriter, t: Time) {.inline.} =
  w.writeValue t.toUnix()

proc writeValue*(w: var JsonWriter, value: HashOrNum) =
  w.beginRecord(HashOrNum)
  case value.isHash
  of true:
    w.writeField("hash", value.hash)
  else:
    w.writeField("number", value.number)
  w.endRecord()

