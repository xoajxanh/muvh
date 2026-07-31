HPMPTypeEnum = {
  HP = enum(1),
  MP = enum(),
  ABILITY = enum(),
  SHIELD = enum(),
  COMBO = enum()
}
AttributeEnum = {
  NONE = enum(0),
  RECOVER = enum(),
  RELIVE = enum(),
  HURT = enum(),
  CURE = enum(),
  BUFF = enum(),
  CREATE = enum(),
  REFLECTION = enum(7),
  USE_SKILL = enum(8),
  ATTRIBUTE = enum(9),
  KILL_MONSTER_ADD_HP = enum(12),
  KILL_MONSTER_ADD_MP = enum(14),
  SYN_HP_MP = enum(17)
}
ThreeUnitExp = {
  Open = enum(1),
  Close = enum()
}
KillMonsterCardType = {
  Open = enum(1),
  Close = enum()
}
UnitType = {
  ThreeExp = enum(1),
  Efficient = enum(6),
  KillMonster = enum(11),
  KillMonsterCross = enum(13),
  BossExp = enum(21)
}
