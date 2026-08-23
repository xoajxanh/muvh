BackMessage = {
  ReqBackLogin = 202001,
  ResBackLogin = 202002,
  ReqBackPing = 202003,
  ResBackPong = 202004,
  ReqCloseServer = 202005,
  ResCloseServer = 202006
}
MessageIDToName[202001] = "BackPackage.ReqBackLogin"
MessageIDToName[202002] = "BackPackage.ResBackLogin"
MessageIDToName[202006] = "BackPackage.ResCloseServer"
Protobuf.LoadProto("Back.proto")
