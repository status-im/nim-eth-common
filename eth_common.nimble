packageName   = "eth_common"
version       = "1.0.0"
author        = "Status Research & Development GmbH"
description   = "Ethereum Common library"
license       = "MIT"
skipDirs      = @["tests"]

requires "nim > 0.18.0",
         "rlp",
         "nimcrypto",
         "ranges",
         "stint",
         "byteutils"
