Team3V3UIEnum = {
  TEAM = enum(1),
  SCHEDULE = enum(2),
  REWARD = enum(3)
}
ScheduleTeam3V3UIEnum = {
  JINJI = enum(1),
  TAOTAI = enum(2),
  JIJUN = enum(3),
  GUANJUN = enum(4)
}
TeamCellCampType = {RED = "hong", BLUE = "lan"}
TeamCellSession = {
  ROUNDOF16 = enum(16),
  ROUNDOF8 = enum(8),
  ROUNDOF4 = enum(4),
  ROUNDOF2 = enum(2)
}
KnockoutDrawTipType = {
  ReqKnockoutDraw = enum(153),
  ResKnockoutDraw = enum(154)
}
TeamProcessStage = {
  End = enum(-1),
  Prepare = enum(0),
  SignUp = enum(1),
  PromotionMatch = enum(2),
  KnockoutRound = enum(3),
  ThirdplaceMatch = enum(4),
  Championship = enum(5)
}
TeamSmallStage = {
  SixteenToEight = enum(1),
  EightToFour = enum(2),
  FourToTwo = enum(3),
  ThirdPlace = enum(4),
  SecondPlace = enum(5),
  Champion = enum(6)
}
TeamOutResult = {
  [TeamSmallStage.SixteenToEight] = "TOP 16",
  [TeamSmallStage.EightToFour] = "TOP 8",
  [TeamSmallStage.FourToTwo] = "TOP 4",
  [TeamSmallStage.ThirdPlace] = "Qu\195\189 Qu\195\162n",
  [TeamSmallStage.SecondPlace] = "\195\129 Qu\195\162n",
  [TeamSmallStage.Champion] = "Qu\195\161n Qu\195\162n"
}
ReqTeamInfoType = {
  Default = enum(1),
  Tips = enum(2)
}
