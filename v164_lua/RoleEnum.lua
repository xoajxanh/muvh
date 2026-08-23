DEFAULT_MODEL = "Model"
ERoleType = {
  Player = enum(1),
  Monster = enum(),
  NPC = enum(),
  Pet = enum(),
  LuoLanDefense = enum(),
  Shop = enum()
}
NpcLoadType = {
  ClientLoad = enum(0),
  ServiceLoad = enum()
}
EModelType = {
  Equip = enum(1),
  NPC = enum(),
  Charactor = enum(),
  Mount = enum(),
  Monster = enum(),
  Pet = enum(),
  Gold = enum(),
  EquipItem = enum(),
  Item = enum(),
  InstanceItem = enum(),
  Skill = enum(),
  LevelRein = enum()
}
ERoleMoveType = {
  Stand = enum(1),
  Run = enum(),
  Walk = enum(),
  Swim = enum(),
  FastSwim = enum(),
  SwimIdle = enum()
}
EEffectModelType = {
  Scene = enum(100),
  Skill = enum(),
  UI = enum()
}
ERoleChangePosReason = {
  None = enum(0),
  Move = enum(3),
  Revive = enum(),
  Transport = enum(),
  Flash_Monster = enum(),
  System_Handle = enum(),
  Scene_Interactive = enum(8),
  RandomTransport = enum(12),
  CoerceTransport = enum(13),
  Flash = enum(100),
  MoveFailed = enum()
}
ERoleSchema = {
  Transfer = enum(0),
  DoubleHit = enum(),
  DivineBounds = enum(),
  TransferCard = enum()
}
ERoleCareer = {
  All = -1,
  ItemTblAll = 0,
  SwordMan = 11,
  Magic = 12,
  Archer = 13,
  SpellSword = 14,
  HolyMaster = 15,
  SummonMagician = 16,
  Knight = 21,
  Magister = 22,
  Marksman = 23,
  SwordDevil = 24,
  CallingTeacher = 26,
  GodKnight = 31,
  GodMagic = 32,
  GodArcher = 33,
  Blademaster = 34,
  Minister = 34,
  SummonTheWizard = 36,
  Templar = 41,
  Archmage = 42,
  ElvesRangers = 43,
  DemonKnight = 44,
  GrandSummoner = 46
}
ERolePkMode = {
  Peace = enum(0),
  Team = enum(),
  Union = enum(),
  All = enum(),
  SiegeAttack = enum(),
  SiegeDefense = enum(),
  UnionKuaFu = enum(),
  Camp = enum()
}
ERolePkModeStr = {
  Peace = "H\195\178a b\195\172nh",
  Team = "\196\144\225\187\153i",
  Union = "Guild",
  All = "To\195\160n b\225\187\153",
  SiegeAttack = "C\195\180ng th\195\160nh",
  SiegeDefense = "Th\225\187\167 th\195\160nh",
  UnionKuaFu = "Li\195\170n Minh",
  Camp = "Phe"
}
ERoleAllPkModeToString = {
  [1] = "Peace",
  [2] = "Team",
  [3] = "Union",
  [4] = "All",
  [5] = "SiegeAttack",
  [6] = "SiegeDefense",
  [7] = "UnionKuaFu",
  [8] = "Camp"
}
ERolePkModeToString = {
  [1] = "Peace",
  [2] = "Team",
  [3] = "Union",
  [4] = "UnionKuaFu",
  [5] = "All"
}
ERoleSiegePkModeToString = {
  [1] = "SiegeAttack",
  [2] = "SiegeDefense"
}
ERoleAttackType = {
  Peace = enum(0),
  Teammate = enum(),
  League = enum(),
  Enemy = enum(),
  SiegeAttack = enum(),
  SiegeDefense = enum(),
  LeagueKuaFu = enum(),
  EnemyUnion = enum()
}
ERoleNameColor = {
  [ERoleAttackType.Enemy] = Color(0.9, 0.2, 0.1, 1),
  [ERoleAttackType.Teammate] = Color.blue,
  [ERoleAttackType.Peace] = Color.white,
  [ERoleAttackType.League] = Color.green,
  [ERoleAttackType.SiegeAttack] = Color.orange,
  [ERoleAttackType.SiegeDefense] = Color.orange,
  [ERoleAttackType.LeagueKuaFu] = Color.green
}
ENpcNameColor = {
  [0] = Color(0.9, 0.2, 0.1, 1),
  [1] = Color.red,
  [2] = Color.green,
  [3] = Color.blue,
  [4] = Color.white,
  [5] = Color.black,
  [6] = Color.yellow,
  [7] = Color.cyan,
  [8] = Color.magenta,
  [9] = Color.gray,
  [10] = Color.orange,
  [11] = Color.pink,
  [12] = Color.purple,
  [13] = Color.gold,
  [14] = Color.paleGold,
  [15] = Color.paleYellow
}
ERoleHudColor = {
  [ERoleAttackType.Enemy] = Color(0.9, 0.2, 0.1, 1),
  [ERoleAttackType.Teammate] = Color.green,
  [ERoleAttackType.Peace] = Color.white,
  [ERoleAttackType.League] = Color.green,
  [ERoleAttackType.SiegeAttack] = Color.orange,
  [ERoleAttackType.SiegeDefense] = Color.orange,
  [ERoleAttackType.LeagueKuaFu] = Color.green,
  [ERoleAttackType.EnemyUnion] = Color(1, 0.2705882, 0, 1)
}
ERoleExpBonus = {
  Vip = "Vip",
  TripleCard = "TripleCard",
  WordLevel = "WordLevel",
  Efficient = "Efficient",
  HolidayExp = "HolidayExp",
  Title = "Title"
}
ERoleEquipCondition = {
  None = enum(1),
  Equip = enum(),
  Archangel = enum(),
  Normal = enum(),
  Title = enum(),
  Sky = enum(),
  Foot = enum(),
  RingChange = enum(),
  timeEquip = enum(),
  Pet = enum(),
  HongZhuang = enum(),
  ShouHu = enum(),
  InputCellType = enum(),
  Shenghun = enum(),
  BlessArchangel = enum(),
  ChristmaSuit = enum(),
  Couture = enum(),
  BingJianSpringFestival = enum(),
  DianYiSuit = enum(),
  BingJianBeachParty = enum(),
  BingJianYuanTianYueBai = enum()
}
ERoleEquipPosition = {
  pet = enum(1),
  helm = enum(),
  wing = enum(),
  right_weapon = enum(),
  left_weapon = enum(),
  armor = enum(),
  nechushou = enum(),
  glove = enum(),
  pant = enum(),
  boot = enum(),
  right_ring = enum(),
  left_ring = enum(),
  right_Earring = enum(),
  left_Earring = enum(),
  armband = enum(),
  flag = enum(),
  bugle = enum(),
  cloak = enum(19),
  transcript_weapon = enum(2301),
  vipIndex = enum(5001),
  autoPickIndex = enum(7001),
  ringChange = enum(21),
  yongDragon = enum(24),
  footPrintIndex = enum(31),
  shadow = enum(100000),
  new_necklace = enum(1001),
  new_left_ring = enum(),
  new_left_Earring = enum(),
  new_right_Earring = enum(1012),
  new_right_ring = enum(1014),
  bingJian_necklace = enum(15),
  bingJian_orbs = enum(20),
  bingJian_signet = enum(21),
  bingJian_grail = enum(18)
}
EEquipInfoTableKey = {
  Necklace = enum(7),
  Ring = enum(11),
  Earrings = enum(13)
}
ERolePetStatus = {
  Stand = enum(1),
  Follow = enum(),
  Attack = enum()
}
ERolePetType = {
  imp = enum(1),
  angle = enum(),
  intensifyImp = enum(),
  intensifyAngle = enum(),
  deer = enum(),
  xiongMao = enum()
}
ERoleNode = {
  LeftHand = enum(0),
  RightHand = enum(),
  LeftWeapon = enum(),
  RightWeapon = enum(),
  Body = enum(),
  Head = enum(6),
  Foot = enum(7)
}
HUDNumberRenderType = {
  HUD_SHOW_HP_HURT = enum(0),
  HUD_SHOW_HP_HURT_Role = enum(),
  HUB_SHOW_DODGE = enum(),
  HUB_SHOW_DODGE_Role = enum(),
  HUD_SHOW_RECOVER_HP = enum(),
  HUD_SHOW_CT_ATTACK = enum(),
  HUD_SHOW_LUCKY = enum(),
  HUD_SHOW_EXCELLENCE = enum(),
  HUD_BACK_HURT = enum(),
  HUD_IGNORE_DEFENSE = enum(),
  HUD_SHOW_DISABLE = enum(),
  HUD_SHOW_SkILLDODGE = enum(),
  HUD_SHOW_MENGJI = enum()
}
RoleReliveType = {
  Here = enum(1),
  BornPoint = enum(),
  RandomPoint = enum(),
  LuoLanXiaGu = enum(),
  ChiSeYaoSai = enum(),
  LangHunYaoSai = enum(),
  RefineTower = enum(),
  CostBornPoint = enum(),
  ReliveAndExit = enum(),
  KSBattle = enum(),
  KSBattleTimeEnd = enum(),
  ThreeVSThreeReviveTimeEnd = enum(),
  FourPartyRivalryFree = enum(),
  FourPartyRivalryPay = enum()
}
MonsterReliveType = {
  Here = enum(0),
  Delay = enum(),
  Immediately = enum()
}
ENavigateStatus = {
  Failed = enum(1),
  Interrupted = enum(),
  Arrived = enum(),
  BlockBreak = enum(),
  EndBlockBreak = enum()
}
AutoFightReson = {
  ClickUIBtn = enum(0),
  AutoTask = enum()
}
AutoFightStrKey = {
  None = "None",
  AutoFight = "AutoFight",
  ReleaseSkill = "ReleaseSkill",
  SpecifySkill = "SpecifySkill",
  HookFight = "HookFight"
}
AddExpType = {
  performTask = enum(70005),
  killMonster = enum(110002),
  paoDian = enum(150014),
  killminiMonster = enum(110014),
  HolyForceMonster = enum(110017),
  HolyForceMinMonster = enum(110018),
  HolyForcePoint = enum(150029),
  HolyBubblePoint = enum(150038)
}
EvilRoleType = {
  Level0 = enum(0),
  Level1 = enum(),
  Level2 = enum(),
  Level3 = enum(),
  Level4 = enum()
}
ERoleEvilNameColor16 = {
  [EvilRoleType.Level1] = "#FF3000",
  [EvilRoleType.Level2] = "#E71616",
  [EvilRoleType.Level3] = "#C31E1E",
  [EvilRoleType.Level4] = "#A10000"
}
ERoleEvilName = {
  [EvilRoleType.Level1] = "L\198\176u manh",
  [EvilRoleType.Level2] = "K\225\186\187 \195\161c",
  [EvilRoleType.Level3] = "Ma \196\144\225\186\167u",
  [EvilRoleType.Level4] = "\196\144\225\186\161i Ma \196\144\225\186\167u"
}
ERoleEvilNameColor = {
  [EvilRoleType.Level1] = Color(1, 0.1882353, 0, 1),
  [EvilRoleType.Level2] = Color(0.9058824, 0.08627451, 0.08627451, 1),
  [EvilRoleType.Level3] = Color(0.7647059, 0.1176471, 0.1176471, 1),
  [EvilRoleType.Level4] = Color(0.6313726, 0, 0, 1)
}
ERoleModelName = {
  default = "1003",
  snowMan = "1103",
  snowMan1 = "1113",
  snowMan2 = "1123",
  snowMan3 = "1133",
  ghost = "1203",
  youngDragon = "1303",
  datianshibianshen = "1403",
  datianshibianshenUI = "1404"
}
PlayerModelDefaultScale = 0.35
ERoleAnimatorResName = {
  [ERoleModelName.snowMan] = "snowman",
  [ERoleModelName.snowMan1] = "snowman",
  [ERoleModelName.snowMan2] = "snowman",
  [ERoleModelName.snowMan3] = "snowman",
  [ERoleModelName.youngDragon] = "youngDragon"
}
ERoleInitEquipType = {
  default = enum(1),
  snowMan = enum(),
  ghost = enum(),
  datianshibianshen = enum()
}
ERoleModelNameType = {
  [ERoleModelName.default] = 1,
  [ERoleModelName.snowMan] = 2,
  [ERoleModelName.snowMan1] = 2,
  [ERoleModelName.snowMan2] = 2,
  [ERoleModelName.snowMan3] = 2,
  [ERoleModelName.ghost] = 3,
  [ERoleModelName.youngDragon] = 2,
  [ERoleModelName.datianshibianshen] = 4,
  [ERoleModelName.datianshibianshenUI] = 4
}
ERoleEquipCanRegenerate = {
  helm = enum(2),
  right_weapon = enum(4),
  left_weapon = enum(5),
  armor = enum(6),
  glove = enum(8),
  pant = enum(9),
  boot = enum(10)
}
ERoleShieldType = {
  AngelShield = enum(0),
  ExtraHealthShield = enum()
}
ERoleCategory = {
  FightHard = 111,
  AgileWarfare = 112,
  IntellectualMethod = 121,
  SensitizingMethod = 122,
  SensitizingBow = 131,
  WisdomBow = 132,
  Warlock = 141,
  ForceDemon = 142,
  CurseSummon = 161,
  MagicSummon = 162
}
ERoleCircleEffectType = {
  None = enum(0),
  Rein = enum(),
  HolyRing = enum(),
  ViewRoleHolyRing = enum()
}
