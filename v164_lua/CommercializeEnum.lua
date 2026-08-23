CommercializeActivityTab = {
  Opening_service = enum(1),
  Combining_service = enum(),
  Holiday = enum(),
  LimitedTime = enum(6),
  Return_service = enum(9),
  Anniversary = enum(12)
}
CommerceIdEnum = {
  Holiday_SpecialGiftPackageMix = enum(30002),
  Holiday_BoosReborn = enum(30004),
  Holiday_CollectWord = enum(30006),
  LimitedTime_SpecialGiftPackageRecharge = enum(60001),
  LimitedTime_BoosReborn = enum(60002),
  LimitedTime_CollectWord = enum(60003),
  LimitedTime_SpecialGiftPackageItemBuy = enum(60004)
}
CommercializeOpeningserGrop = {
  Openingser = enum(100),
  SportsLevel = enum(),
  SportsEquip = enum(),
  SportsIntensify = enum(),
  SportsZhuijia = enum(),
  EquipFirstGet = enum(),
  BossFirstKill = enum(),
  SportsExcellenc = enum(),
  SportsJewelry = enum(),
  SportsFruit = enum(),
  SportsFight = enum(),
  weekSignIn = enum(200),
  SportsBoss = enum(248),
  GuardInvest = enum(111),
  CommercialRanking = enum(321)
}
EnumCommerceTabId = {
  GuardInvest = enum(11101)
}
CommercializeHolidayGrop = {
  DirectPurchase = enum(301),
  GiftPack = enum(),
  Fireworks = enum(),
  Exp = enum(),
  BoosActivity = enum(),
  Collect = enum(),
  ContinuousRecharge = enum(307),
  Shop = enum(309),
  HolidayRecharge = enum(310),
  Accumulating = enum(311),
  DailyCharge = enum(312),
  HideMap = enum(313),
  WarOrderTask = enum(314),
  StarrySecrets = enum(315),
  TurntableType = enum(318),
  HolidayLuckyTurntable = enum(317),
  AdsPictures = enum(316),
  Preview = enum(319),
  MountShow = enum(324),
  WorldCupGuess = enum(323),
  SpringActivity = enum(325),
  PetInvest = enum(327),
  SevenDayGift = enum(328),
  FirecrackerTreasureHunting = enum(326),
  LimitedTime_SpecialGiftPackageItemBuy = enum(330),
  OpenServerInvest = enum(331),
  WarOrderPass = enum(320),
  HolidayInvest = enum(334),
  ConnectionGift = enum(333),
  LuckyRebate = enum(332),
  CommercialNiudan = enum(335),
  HolidayGratiaGift = enum(336),
  ShoppingSpree = enum(337),
  HolidayChristmasMonster = enum(339),
  ChristmasActivity = enum(338),
  HolidayRetrunLoading = enum(901),
  HolidayRetrunTask = enum(902),
  HolidayRetrunShop = enum(903),
  HolidayRetrunPack = enum(904)
}
CommerceOverviewType = {
  TaskType = enum(1),
  GiftType = enum(2),
  RankInfo = enum(3),
  Exp = enum(4),
  BoosActivity = enum(5),
  Fireworks = enum(6),
  Collect = enum(7),
  TurntableType = enum(18),
  TurntableType = enum(18),
  Preview = enum(19),
  ContinuousRecharge = enum(20),
  MountShow = enum(23),
  SpringActivity = enum(25),
  PetInvest = enum(27),
  OpenServerInvest = enum(30),
  WarOrderPass = enum(21),
  ConnectionGift = enum(33),
  HolidayInvest = enum(34),
  LuckyRebate = enum(32),
  CommercialNiudan = enum(35),
  ShoppingSpree = enum(37)
}
CommerceActivityGiftType = {
  Shop = enum(1),
  rechange = enum()
}
FireworksBulletinType = {
  roleAnnounce = enum(1),
  serverAnnounce = enum(),
  serverTopAnnounce = enum()
}
CommerceHolidayRedTogType = {
  [CommercializeHolidayGrop.Exp] = enum(64),
  [CommercializeHolidayGrop.BoosActivity] = enum(65),
  [CommercializeHolidayGrop.Fireworks] = enum(66),
  [CommercializeHolidayGrop.Collect] = enum(69),
  [CommercializeHolidayGrop.Shop] = enum(76),
  [CommercializeHolidayGrop.ContinuousRecharge] = enum(90),
  [CommercializeHolidayGrop.TurntableType] = enum(73)
}
CommerceHolidayTogRed = {
  [64] = CommercializeHolidayGrop.Exp,
  [65] = CommercializeHolidayGrop.BoosActivity,
  [66] = CommercializeHolidayGrop.Fireworks,
  [69] = CommercializeHolidayGrop.Collect,
  [76] = CommercializeHolidayGrop.Shop
}
CommerceHolidayContinuousRechargeRed = {
  [1] = 90,
  [2] = 91,
  [3] = 92,
  [4] = 93,
  [5] = 125,
  [6] = 126
}
CommercializeTimeLimitedGrop = {
  DirectPurchase = enum(301),
  GiftPack = enum(),
  Fireworks = enum(),
  Exp = enum(),
  BoosActivity = enum(),
  Collect = enum(),
  ContinuousRecharge = enum(307),
  Shop = enum(309),
  HolidayRecharge = enum(310),
  Accumulating = enum(311),
  DailyCharge = enum(312),
  HideMap = enum(313),
  WarOrderTask = enum(314),
  StarrySecrets = enum(315),
  TurntableType = enum(318),
  HolidayLuckyTurntable = enum(317),
  AdsPictures = enum(316),
  Preview = enum(319),
  MountShow = enum(324),
  WorldCupGuess = enum(323),
  SpringActivity = enum(325),
  PetInvest = enum(327),
  SevenDayGift = enum(328),
  FirecrackerTreasureHunting = enum(326),
  LimitedTime_SpecialGiftPackageItemBuy = enum(330),
  OpenServerInvest = enum(331),
  WarOrderPass = enum(320)
}
CommerceTimeLimitedRedTogType = {
  [CommercializeTimeLimitedGrop.Exp] = enum(64),
  [CommercializeTimeLimitedGrop.BoosActivity] = enum(65),
  [CommercializeTimeLimitedGrop.Fireworks] = enum(66),
  [CommercializeTimeLimitedGrop.Collect] = enum(110),
  [CommercializeTimeLimitedGrop.Shop] = enum(76),
  [CommercializeTimeLimitedGrop.ContinuousRecharge] = enum(90)
}
CommerceTimeLimitedTogRed = {
  [64] = CommercializeTimeLimitedGrop.Exp,
  [65] = CommercializeTimeLimitedGrop.BoosActivity,
  [66] = CommercializeTimeLimitedGrop.Fireworks,
  [110] = CommercializeTimeLimitedGrop.Collect,
  [76] = CommercializeTimeLimitedGrop.Shop
}
CommerceTimeLimitedContinuousRechargeRed = {
  [1] = 90,
  [2] = 91,
  [3] = 92,
  [4] = 93
}
TianKongMiGeLevelType = {
  Ordinarydata = enum(1),
  Advanceddata = enum()
}
TianKongMiGeLevelGroup = {
  Group1 = enum(1),
  Group2 = enum()
}
TianKongMiGeMissionType = {
  day = enum(1),
  week = enum()
}
VvipBuyType = {
  iten_buy = enum(1),
  recharge = enum()
}
CommercializeEquipCell = {
  None = enum(0),
  SilverCard = enum(4001),
  GoldCard = enum(4002),
  Vvip = enum(5001),
  Sky = enum(6001)
}
TaskSchooltaskCount = {
  Four = enum(4),
  Six = enum(6),
  Eight = enum(8)
}
ActivatedState = {
  nonactivated = enum(1),
  activated = enum(),
  maxLevel = enum()
}
GuardTypeEnum = {
  DamageIncreased = enum(1),
  DamageReduction = enum(2),
  ReduceAttack = enum(4)
}
GuardRewardStateEnum = {
  NotGet = enum(0),
  CanGet = enum(1),
  Got = enum(2)
}
TurntableItemTypeEnum = {
  Ordinary = enum(1),
  Rare = enum(2),
  GiftProp = enum(3)
}
BattlePassRewardTypeEnum = {
  Ordinary = enum(1),
  Up = enum(2)
}
SevenDayGiftTypeEnum = {
  Day = enum(1),
  Target = enum(2)
}
RewardsTypeEnum = {
  DrawableRewards = enum(1),
  CumulativeRewards = enum(2)
}
AnniversaryActivityEnum = {
  SignIn = enum(1201),
  Store = enum(1202),
  NpcActivity = enum(1203),
  BattleOrder = enum(1204),
  NewCharacter = enum(1205),
  Monster = enum(1206)
}
