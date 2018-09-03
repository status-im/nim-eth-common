import unittest, eth_common, nimcrypto

suite "Addresses":
  test "Creating new address with nonce":
    proc doTest(a, b: string, nonce: AccountNonce) =
      var x: EthAddress
      x[0..19] = a.fromHex
      check x.generateAddress(nonce).toHex(true) == b

    # TODO: Placeholder values, generate from other clients
    doTest(
      "54f84fea31bedf6c60e42a3fca529a74147dd443",
      "7dc9b1b4503bf29773038fbccb53b52d2affbf56", 0)
    doTest(
      "6ac7ea33f8831ea9dcc53393aaa88b25a785dbf0",
      "cd234a471b72ba2f1ccf0a70fcaba648a5eecd8d", 0)
    doTest(
      "6ac7ea33f8831ea9dcc53393aaa88b25a785dbf0",
      "343c43a37d37dff08ae8c4a11544c718abb4fcf8", 1)
    doTest(
      "6ac7ea33f8831ea9dcc53393aaa88b25a785dbf0",
      "f778b86fa74e846c4f0a1fbd1335fe81c00a0c91", 2)
    doTest(
      "6ac7ea33f8831ea9dcc53393aaa88b25a785dbf0",
      "fffd933a0bc612844eaf0c6fe3e5b8e9b6c1d19c", 3)
