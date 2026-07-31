TipMessage = {
  ResPrompt = 300001,
  ResBattleReport = 300002,
  ResWindowsTip = 300003,
  ResPushEvaluate = 300004,
  ReqNextPushEvaluate = 300005
}
MessageIDToName[300001] = "TipPackage.PromptMsg"
MessageIDToName[300002] = "TipPackage.BattleReport"
MessageIDToName[300003] = "TipPackage.WindowsTip"
Protobuf.LoadProto("Tip.proto")
