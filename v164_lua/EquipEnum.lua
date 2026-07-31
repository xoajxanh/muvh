EquipOperationType = {
  PUT_ON = enum(),
  TAKE_OFF = enum()
}
EquipCellType = {
  NORMAL = enum(1),
  GEM = enum(2),
  ARCHANGEL = enum(6),
  HONGZHUANG = enum(15),
  SHOUHU = enum(16),
  ARCHANGEL_BLESS = enum(17),
  SHENGHUN = enum(18),
  ARCHANGEL_CHRISTMAS = enum(20),
  BINGJIAN_SPRINGFESTIVAL = enum(21),
  BINGJIAN_DianYi = enum(22),
  BINGJIAN_BeachParty = enum(24),
  BINGJIAN_YuanTianYueBai = enum(23),
  SF_SUIT = enum(31)
}
EquipCellBasicCode = {
  ARCHANGEL = 3100,
  ARCHANGEL_BLESS = 3600,
  ARCHANGEL_CHRISTMAS = 3700,
  BINGJIAN_SPRINGFESTIVAL = 3800,
  BINGJIAN_DianYi = 3900,
  BINGJIAN_BeachParty = 4200,
  BINGJIAN_YuanTianYueBai = 4100
}
ERedEquipUpgradeCode = {
  MeetMax = enum(-3),
  NotMeetCondition = enum(),
  NotMeetConsumable = enum(),
  None = enum(0),
  MeetAll = enum()
}
EquipChangeReason = {
  Noraml = enum(0),
  RedEquipSyn = enum()
}
EquipAttributeCalculateType = {
  Ratio = "tTRatio",
  LevelFixed = "fixed",
  Constant = "constant",
  RatioInterval = "ratioInterval",
  LevelFixedInterval = "fixedInterval",
  ConstantInterval = "constantInterval",
  ConstantLevel = "constantLevel"
}
EquipType = {
  Normal = 1,
  HongZhuang_NoJewel = 2,
  HongZhuang_Jewel = 3,
  Normal_FlagOrBugle = 4
}
BingJianExcellenceShowType = {
  Show = enum(0),
  NotShow = enum(),
  SpecialShow = enum()
}
