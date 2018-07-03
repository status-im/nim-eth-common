import stint, nimcrypto, times, rlp
export stint

type
  Hash256* = MDigest[256]
  EthTime* = Time

  VMWord* = UInt256

  BlockNonce* = UInt256
  Blob* = seq[byte]

  BloomFilter* = StUint[2048]
  EthAddress* = array[20, byte]

  GasInt* = int64
  ## Type alias used for gas computation
  # For reference - https://github.com/status-im/nimbus/issues/35#issuecomment-391726518

  Transaction* = object
    accountNonce*:  uint64
    gasPrice*:      GasInt
    gasLimit*:      GasInt
    to*:            EthAddress
    value*:         UInt256
    payload*:       Blob
    V*, R*, S*:     UInt256

  BlockNumber* = UInt256

  BlockHeader* = object
    parentHash*:    Hash256
    ommersHash*:    Hash256
    coinbase*:      EthAddress
    stateRoot*:     Hash256
    txRoot*:        Hash256
    receiptRoot*:   Hash256
    bloom*:         BloomFilter
    difficulty*:    UInt256
    blockNumber*:   BlockNumber
    gasLimit*:      GasInt
    gasUsed*:       GasInt
    timestamp*:     EthTime
    extraData*:     Blob
    mixDigest*:     Hash256
    nonce*:         BlockNonce

  BlockBody* = object
    transactions*:  seq[Transaction]
    uncles*:        seq[BlockHeader]

  Log* = object
    address*:       EthAddress
    topics*:        seq[int32]
    data*:          Blob

  Receipt* = object
    stateRoot*:     Blob
    gasUsed*:       GasInt
    bloom*:         BloomFilter
    logs*:          seq[Log]

  AccessList* = object
    # XXX: Specify the structure of this

  ShardTransaction* = object
    chain*:         uint
    shard*:         uint
    to*:            EthAddress
    data*:          Blob
    gas*:           GasInt
    accessList*:    AccessList
    code*:          Blob
    salt*:          Hash256

  CollationHeader* = object
    shard*:         uint
    expectedPeriod*: uint
    periodStartPrevHash*: Hash256
    parentHash*:    Hash256
    txRoot*:        Hash256
    coinbase*:      EthAddress
    stateRoot*:     Hash256
    receiptRoot*:   Hash256
    blockNumber*:   BlockNumber

  HashOrNum* = object
    case isHash*: bool
    of true:
      hash*: Hash256
    else:
      number*: BlockNumber

  BlocksRequest* = object
    startBlock*: HashOrNum
    maxResults*, skip*, reverse*: uint64

when BlockNumber is int64:
  ## The goal of these templates is to make it easier to switch
  ## the block number type to a different representation
  template vmWordToBlockNumber*(word: VMWord): BlockNumber =
    BlockNumber(word.toInt)

  template blockNumberToVmWord*(n: BlockNumber): VMWord =
    u256(n)

  template toBlockNumber*(n: SomeInteger): BlockNumber =
    int64(n)

else:
  template vmWordToBlockNumber*(word: VMWord): BlockNumber =
    word

  template blockNumberToVmWord*(n: BlockNumber): VMWord =
    n

  template toBlockNumber*(n: SomeInteger): BlockNumber =
    u256(n)

#
# Rlp serialization:
#

func trailingNonZeros(val: openarray[byte]): int =
  for i in countdown(val.len - 1, 0):
    if val[i] == 0:
      return val.len - i - 1

  return val.len

proc read*(rlp: var Rlp, T: typedesc[Stint|StUint]): T {.inline.} =
  if rlp.isBlob:
    let bytes = rlp.toBytes
    if bytes.len > 0:
      result = readUintBE[result.bits](bytes.toOpenArray)
    else:
      result = 0.to(T)
  else:
    result = rlp.getByteValue.to(T)

  rlp.skipElem

proc append*(rlpWriter: var RlpWriter, value: Stint|StUint) =
  if value > 128:
    let bytes = value.toByteArrayBE
    let nonZeroBytes = trailingNonZeros(bytes)
    rlpWriter.append bytes.toOpenArray(bytes.len - nonZeroBytes,
                                       bytes.len - 1)
  else:
    rlpWriter.append(value.toInt)


proc read*(rlp: var Rlp, T: typedesc[MDigest]): T {.inline.} =
  result.data = rlp.read(type(result.data))

proc append*(rlpWriter: var RlpWriter, a: MDigest) {.inline.} =
  rlpWriter.append(a.data)


proc read*(rlp: var Rlp, T: typedesc[Time]): T {.inline.} =
  result = fromUnix(rlp.read(int64))

proc append*(rlpWriter: var RlpWriter, t: Time) {.inline.} =
  rlpWriter.append(t.toUnix())


proc rlpHash*[T](v: T): Hash256 =
  keccak256.digest(rlp.encode(v).toOpenArray)

