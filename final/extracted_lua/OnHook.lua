OnHookMessage = {
  ReqGetOnHookInfo = 211001,
  ResGetOnHookInfo = 211002,
  ReqGetOnHookReward = 211003
}
MessageIDToName[211002] = "OnHookPackage.ResGetOnHookInfo"
MessageIDToName[211003] = "OnHookPackage.ReqGetOnHookReward"
Protobuf.LoadProto("OnHook.proto")
