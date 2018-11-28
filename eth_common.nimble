packageName   = "eth_common"
version       = "1.0.0"
author        = "Status Research & Development GmbH"
description   = "Ethereum Common library"
license       = "MIT"
skipDirs      = @["tests"]

requires "nim > 0.18.0",
         "rlp",
         "eth_trie",
         "nimcrypto",
         "ranges",
         "stint",
         "byteutils"

task test, "run tests":
  cd "tests"
  exec "nim c -r test"