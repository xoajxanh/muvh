AchievementMessage = {
  ReqAchievementInfo = 10001,
  ResAchievementInfo = 10002,
  ResAchievementChange = 10003,
  ReqGetAchievementReward = 10004
}
MessageIDToName[10002] = "AchievementPackage.AchievementInfoRes"
MessageIDToName[10003] = "AchievementPackage.AchievementChangeRes"
MessageIDToName[10004] = "AchievementPackage.GetAchievementRewardReq"
Protobuf.LoadProto("Achievement.proto")
