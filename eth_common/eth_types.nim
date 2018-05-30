import stint, nimcrypto, times

type
  Hash256* = MDigest[256]
  EthTime* = Time

  BlockNonce* = UInt256
  Blob* = seq[byte]

  BloomFilter* = StUint[2048]
  EthAddress* = MDigest[160]

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

  BlockHeader* = object
    parentHash*:    Hash256
    ommersHash*:    Hash256
    coinbase*:      EthAddress
    stateRoot*:     Hash256
    txRoot*:        Hash256
    receiptRoot*:   Hash256
    bloom*:         BloomFilter
    difficulty*:    UInt256
    blockNumber*:   uint
    gasLimit*:      GasInt
    gasUsed*:       GasInt
    timestamp*:     uint64
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
    blockNumber*:   uint

  HashOrNum* = object
    case isHash*: bool
    of true:
      hash*: Hash256
    else:
      number*: uint

  BlocksRequest* = object
    startBlock*: HashOrNum
    maxResults*, skip*, reverse*: uint
