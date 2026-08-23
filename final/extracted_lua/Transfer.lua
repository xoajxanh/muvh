TransferMessage = {
  ReqTransferRole = 25001,
  ReqTransferItem = 25002,
  ResRemoveTask = 25003,
  ResTransferState = 25004
}
MessageIDToName[25001] = "TransferPackage.ReqTransferRole"
MessageIDToName[25002] = "TransferPackage.ReqTransferItem"
MessageIDToName[25003] = "TransferPackage.ResRemoveTask"
MessageIDToName[25004] = "TransferPackage.ResTransferState"
Protobuf.LoadProto("Transfer.proto")
