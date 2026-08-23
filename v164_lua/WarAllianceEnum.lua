WarAllianceMemberType = {
  Leader = enum(1),
  viceLeader = enum(),
  Captain = enum(),
  Elite = enum(),
  Member = enum()
}
CrossServerMemberType = {
  first = enum(1),
  sccend = enum(),
  three = enum()
}
CrossServerKunShouType = {
  first = enum(1),
  second = enum(),
  three = enum()
}
WarAlliancePositionType = {
  viceLeader = enum(2),
  Captain = enum(),
  Elite = enum(),
  Member = enum(),
  Demise = enum(),
  KickOut = enum(7)
}
WarAllianceDataChangeType = {
  Name = enum(1),
  Logo = enum(),
  Notice = enum(),
  RecruitNotice = enum()
}
WarAllianceUseTypeEnum = {
  employ = enum(1)
}
WarAllianceDonateType = {
  Donate = 10030001,
  highDonate = 10030002,
  superDonate = 10030003
}
WarAllianceCreatOrChange = {
  Creat = enum(1),
  Change = enum()
}
WarAllianceImpeachVote = {
  None = 2,
  Agree = 1,
  Oppose = 0
}
WarAllianceMasterEventType = {
  Impeach = 1,
  Campaign = 2,
  Replace = 3
}
WarAllianceActivityEnterCondition = {
  Success = enum(1),
  NotWarAlliance = enum(),
  NotEnterTime = enum(),
  NotLevel = enum(),
  NotEnter = enum()
}
WarAllianceMemberSortType = {
  level = enum(1),
  job = enum(),
  state = enum()
}
WarAllianceMemberSortStateType = {
  levelUp = enum(1),
  levelDown = enum(),
  jobUp = enum(),
  jobDown = enum(),
  stateUp = enum(),
  stateDown = enum()
}
WarAllianceBadgeTag = {
  HP = enum(1),
  Attack = enum(),
  Defense = enum()
}
