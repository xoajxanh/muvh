TaskStateType = {
  Acceptable = enum(0),
  Accept = enum(),
  Completed = enum(),
  Submitted = enum(),
  Fail = enum(),
  GiveUp = enum()
}
TaskMainSubType = {
  GeneralSubType = enum(0),
  GoalParamSubType = enum()
}
TaskViewState = {
  Show = enum(0),
  Hide = enum()
}
TaskCompletePanel = {
  TalkPanel = enum(0),
  TransferPanel = enum()
}
AutoTaskOperateType = {
  JoyStick = enum(0),
  KeyMove = enum(),
  MouseClick = enum(),
  GeneralAttack = enum(),
  SkillAttack = enum(),
  MapPosClick = enum(),
  AutoFight = enum(),
  UIClick = enum(),
  CliskFly = enum()
}
TaskGoalType = {
  KillMonster = enum(101),
  AffiliationKill = enum(103),
  TeamAffiliationKill = enum(113),
  Dialogue = enum(201),
  Upgrade = enum(301),
  AutoFight = enum(3010)
}
StarTaskLevel = {
  OneStar = enum(1),
  TwoStar = enum(),
  ThreeStar = enum()
}
TaskTriggeringConditionType = {
  OnClick = enum(0),
  AutoTask = enum()
}
TaskTargetMonsterType = {
  None = enum(0),
  MonsterId = enum(),
  MonsterTpye = enum(),
  Random = enum(),
  MapLock = enum(),
  AutoFight = enum(),
  CheckDistance = enum()
}
PathfindingState = {
  taskNone = enum(0),
  taskOnClickStart = enum(),
  taskAutoStart = enum(),
  taskInterruption = enum(),
  taskWait = enum(),
  taskStop = enum(),
  taskFinish = enum(),
  taskDrop = enum(),
  taskPickUp = enum()
}
TaskTargetType = {
  SingleMap = enum(1),
  NpcTarget = enum(),
  MultiMap = enum()
}
TaskTragetPosType = {
  SinglePos = enum(0),
  MultiPos = enum()
}
TaskGuideType = {
  OpenTask = enum(0),
  Navi = enum()
}
RoleTaskType = {
  MainTask = enum(1),
  BranchTask = enum(2),
  UnionTask = enum(3),
  StarTask = enum(4),
  StageTask = enum(5),
  MiracleTask = enum(6),
  MarsTask = enum(8),
  HelpTask = enum(9),
  SkillTask = enum(10),
  TranscriptTask = enum(11),
  TransferTask = enum(12),
  RewardsTask = enum(13),
  LevelUpTask = enum(15)
}
TaskNavigationType = {
  DirectlyOpen = enum(0),
  FindNpc = enum(),
  FindPos = enum(),
  ClickEvent = enum(),
  ConditionOpen = enum(),
  OpenPromptBox = enum(),
  JumpPos = enum(),
  FindRandomPos = enum(),
  OpenGiftByObtainId = enum()
}
TaskNavigationEvtntFuntion = {
  EventOpenUI = enum(0),
  GoldEvent = enum(1)
}
TaskAddBarType = {
  RewardConditions = enum(1),
  PersonageConditions = enum(2),
  WarAllianceTaskConditions = enum(3),
  FirstImpactConditions = enum(4),
  BossLandConditions = enum(5),
  CrossServerConditions = enum(6)
}
NavigationClickEvent = {
  ClickHang = enum(0)
}
TaskParalleliLneType = {
  LookFor = enum(0),
  Stand = enum()
}
WarAllianceTaskType = {
  Single = enum(1),
  Common = enum()
}
PromptBoxPanel = {
  AddWarAlliance = enum(24001)
}
TaskTeamTemp = {
  TaskTemp = enum(0),
  TeamTemp = enum()
}
TaskIdEnum = {
  RecycleTask = enum(3010)
}
RewardsTaskEnum = {
  MonsterReward = enum(1),
  BossReward = enum()
}
