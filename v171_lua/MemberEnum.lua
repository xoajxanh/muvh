EMemberTaskState = {
  unfinsh = enum(0),
  finish = enum(2)
}
EMemberRewardState = {
  Geted = enum(0),
  Get = enum(),
  NotGet = enum()
}
EMemberSrcState = {
  Lock = enum(0),
  UnLock = enum()
}
EMemberBuyState = {
  CanBuy = enum(0),
  Bought = enum()
}
EMemberTaskJumpType = {
  FindMonster = enum(1),
  FindNpc = enum(),
  Navigation = enum()
}
EBuyMethodType = {
  BuyTips = enum(1),
  Recharge = enum(),
  JumpPanel = enum()
}
ECardType = {
  None = enum(0),
  EMemberCard = enum(1),
  PrivilegeCard = enum(2)
}
EMemberRewarType = {
  Reward = enum(0),
  DailyReward = enum(1)
}
EMemberViewType = {
  Member = enum(1),
  Task = enum()
}
