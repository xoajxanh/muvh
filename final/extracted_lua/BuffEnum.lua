BuffEnum = {
  Revive = enum(2000002)
}
BuffTypeEnum = {
  attributeBuff = enum(1),
  stateBuff = enum(),
  mapBuff = enum(),
  harmBuff = enum(),
  recoverBuff = enum(),
  dispelBuff = enum(),
  specialBuff = enum(),
  markBuff = enum(9),
  MultipleBuff = enum(10),
  GoldRecoverBuff = enum(16),
  RankBuff = enum(55),
  KaLunTeBoxBuff = enum(98)
}
BuffTimeType = {
  TimeAdd = enum(1),
  TimeDefaultAdd = enum(2)
}
BuffSubTypeEnum = {
  KSRankBuff = enum(5501),
  RoleBoxBuff = enum(9801)
}
BuffSubType2Str = {
  [102] = "SLOW_DOWN",
  [106] = "LIFE_LIGHT",
  [207] = "IMPRISON",
  [203] = "INVISIBLE",
  [218] = "INVINCIBLE",
  [219] = "SILENT",
  [220] = "RELEASE_SKILL",
  [1101] = "PUSHED_IMMUNITY"
}
BuffType = {
  None = 0,
  Buff = 1,
  DeBuff = 2
}
RoleBuffState = {
  None = 0,
  IMPRISON = 1,
  SLOW_DOWN = 2,
  LIFE_LIGHT = 4,
  PUSHED_IMMUNITY = 8,
  INVISIBLE = 16,
  INVINCIBLE = 32,
  SILENT = 64,
  RELEASE_SKILL = 128
}
EBuffItemType = {
  None = enum(0),
  Member = enum(),
  AdvanceMonthCard = enum()
}
EBuffOperationType = {
  Add = enum(1),
  Remove = enum(),
  Change = enum()
}
