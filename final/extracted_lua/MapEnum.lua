MapTransferSourceType = {
  Npc = enum()
}
MapMonsterPointFindType = {
  FlyToPoint = enum(1),
  WalkToPoint = enum()
}
MapMonsterPointFindArriveBehaviour = {
  AutoFight = enum(1)
}
MapPointType = {
  NPC = 1,
  MonsterPoint = 2,
  GoldMonster = 3,
  Boss = 4,
  TransferPoint = 5
}
MapPointListType = {NORMAL = 0, VIP = 1}
MapTypeFlag = {
  VIP = enum(1014)
}
EMapLimitOperationType = {
  BLACKHOUSE = enum(1)
}
EMapPointType = {
  None = enum(-1),
  Team = enum(),
  CarryBox = enum(),
  Box = enum(),
  KaLunTeBoss = enum(),
  Box_Silvery = enum(),
  CarryBox_Silvery = enum(),
  KaLunTeElite = enum()
}
MapPointBuffRefreshType = {MINIMAP = 1, MAXMAP = 2}
BigMapHeadShowType = {
  NORMAL = 1,
  GRAY = 2,
  DISABLE = 3
}
MapIDType = {THREEVSTHREE = 1095}
