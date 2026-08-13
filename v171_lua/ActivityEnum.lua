ActivityStatusEnum = {
  INIT = enum(0),
  RUNNING = enum(),
  CLOSING = enum(),
  END = enum(),
  WAITSTART = enum()
}
LangHunYaoSaiRunStateEnum = {
  Ready = enum(0),
  Run = enum()
}
ActivityStateInfo = {
  Receive = enum(0),
  Complete = enum()
}
ServerActivityEnum = {KLTRuins = 4002}
ActivityBaseType = {
  PlayActivity = 1,
  CommerceActivity = 2,
  HolidayActivity = 3,
  RechargeActivity = 4,
  LimitedTimeActivity = 6,
  ReturnActivity = 9,
  AnniversaryActivity = 12
}
CoalitionPageType = {CoalitionPage = 1, Siege = 2}
CoalitionBtnType = {JoinCoalition = 1, JoinActivity = 2}
PlayActivityIdType = {
  CoalitionSiege = 4003,
  KunShouBattle = 4005,
  ThreeVsThree = 5001,
  DuoQiCross = 5002,
  SpaceCrack = 5003,
  DuoQiZhengBa = 5004,
  SiFangZhengBa = 5005
}
CommerceActivityIdType = {
  MiracleBattlePass = 320,
  LianChongFanLi = 307,
  CombineFirstGiftData = 100,
  GoodFiftsEveryDay = 322,
  ConsumeRanking = 321,
  CombineTask = 330
}
HolidayActivityIdType = {
  WorldCupGuess = 323,
  SpringActivity = 325,
  SevenDayGift = 328,
  FirecrackerTreasureHunting = 326,
  Yutulaixi = 327,
  HolidayInvest = 334,
  ConnectionGift = 333,
  DiamondGashapon = 335,
  LuckyRebate = 332,
  ShoppongSpree = 337
}
TimeLimitedActivityIdType = {
  LimitedTime_SpecialGiftPackageRecharge = 302,
  LimitedTime_BoosReborn = 304,
  LimitedTime_CollectWord = 328,
  LimitedTime_SpecialGiftPackageItemBuy = 326,
  OpenServerInvestment = 331,
  MiracleBattlePass = 320
}
RechargeActivityIdType = {}
ELCFLRewardState = {
  Geted = enum(-3),
  NotGet = enum(),
  GoRecharge = enum(),
  CanGet = enum(1)
}
WorldCupGuessTimeState = {
  None = enum(0),
  Guess = enum(1),
  Wait = enum(2),
  Announce = enum(3)
}
WorldCupGuessResultType = {
  None = enum(0),
  Win = enum(1),
  Lose = enum(2),
  Draw = enum(3)
}
KFTZGradeType = {Ordinary = 1900001, Advanced = 1900002}
KFTZGradeState = {
  NotRecharge = enum(1),
  GoRecharge = enum(2),
  Recharged = enum(3),
  AllGot = enum(4)
}
KFTZRewardState = {
  NeedRecharge = enum(1),
  NotGet = enum(2),
  CanGet = enum(3),
  Got = enum(4)
}
LuckyRebateAnimState = {
  Play = enum(1),
  OneFinish = enum(),
  AllFinish = enum()
}
AnniversaryActivityIdType = {
  SignIn = 1201,
  Store = 1202,
  NpcActivity = 1203,
  BattleOrder = 1204,
  NewCharacter = 1205,
  Monster = 1206
}
