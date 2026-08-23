EItemOperateType = {
  Close = enum(0),
  Discard = enum(),
  Use = enum(),
  Wear = enum(),
  Split = enum(),
  Access = enum(),
  OpenOtherUI = enum(),
  Shelves = enum(),
  Strengthen = enum(),
  Recycle = enum(),
  UseAll = enum(21),
  JumpPanelOrUse = enum(22),
  UseN = enum(23),
  Exchange = enum(25),
  HolidayMoney = enum(26),
  TakeOut = enum(50),
  Deposit = enum(),
  Disboard = enum(),
  MountDisboard = enum(),
  Show = enum(),
  More = enum(),
  CancelSelect = enum(),
  OpenUI = enum(),
  AddEquip = enum(),
  Upgrade = enum(),
  Decompose = enum(),
  compound = enum(),
  XiLianEquip = enum(),
  XiLianRedEquip = enum()
}
EDragUIType = {
  Bag = enum(1),
  WarehouseInfoUI = enum(2)
}
ItemUseType = {
  None = enum(0),
  UseSkill = enum(7),
  OpenUI = enum(10),
  FindNpc = enum(11),
  Navigation = enum(24),
  UseBox = enum(30),
  UseBatchBox = enum(31),
  DoubleTip = enum(93)
}
EItemType = {
  Resources = enum(1),
  Equipe = enum(),
  Consumables = enum(),
  SkillBook = enum(),
  TreasureChest = enum(),
  Material = enum(),
  GemStone = enum(),
  Other = enum(),
  FireGem = enum(11),
  WaterGem = enum(),
  IceGem = enum(),
  WindGem = enum(),
  ThunderGem = enum(),
  SoilGem = enum(),
  Transcript = enum(18),
  Vvip = enum(29),
  Rune = enum(19),
  HolyRing = enum(22),
  BoneSoul = enum(24),
  FixedBoneSoul = enum(26),
  NewRune = enum(28),
  EnchantedCrystal = enum(30)
}
EItemSubtype = {
  Consumable = enum(0),
  OneHandedSword = enum(1),
  TwoHandedSword = enum(2),
  Spear = enum(3),
  OneHandedAxe = enum(4),
  TwoHandedAxe = enum(5),
  OneHandedStick = enum(6),
  TwoHandedStick = enum(7),
  Shield = enum(8),
  Arch = enum(9),
  CrossBow = enum(10),
  Wand = enum(11),
  Katar = enum(12),
  Helmet = enum(13),
  BreastPlate = enum(14),
  ShinGuards = enum(15),
  HandGuards = enum(16),
  Shoes = enum(17),
  Ring = enum(18),
  Necklace = enum(19),
  Wing = enum(20),
  Guards = enum(21),
  Mount = enum(22),
  Other = enum(23),
  BowBag = enum(24),
  CrossBowBag = enum(25),
  Earrings = enum(26),
  vipType = enum(29),
  pickCard = enum(31),
  Flag = enum(32),
  Bugle = enum(33),
  Suit_Earring = enum(34),
  Suit_Ring = enum(35),
  Suit_RingRight = enum(38),
  FootPrint = enum(40),
  AppearanceRing = enum(50),
  HongZhuang_OneHandedSword = enum(101),
  RedOneHandedStick = enum(106),
  RedShield = enum(108),
  RedArch = enum(109),
  RedBowBag = enum(124),
  HongZhuang_Shield = enum(181),
  ringChange = enum(50),
  mShield = enum(81),
  RedmShield = enum(181),
  Cloak = enum(191),
  Suit_OneHandedSword = enum(131),
  Suit_OneHandedSword_Other = enum(132),
  Suit_OneHandedStick = enum(136),
  Suit_Shield = enum(138),
  Suit_Arch = enum(139),
  Suit_CrossBow = enum(140),
  Suit_BowBag = enum(154),
  Suit_CrossBowBag = enum(155),
  skillBook = enum(302),
  ExpPotion = enum(303),
  TransferCard = enum(305),
  TransferCardWing = enum(306),
  title = enum(501),
  EffectTitle = enum(502),
  wingOverlap = enum(620),
  SpecialSacredBone = enum(2400),
  GeneralSacredBone = enum(2450),
  MountUpgradeStone = enum(3009),
  Couture_OneHandedSword = enum(3101),
  Couture_right = enum(3181),
  Couture_OneHandedStick = enum(3106),
  Couture_Arch = enum(3109),
  Couture_CrossBow = enum(3124),
  Couture_BowBag = enum(3125),
  Couture_left = enum(3101),
  SummonerRightHandAtk = enum(56),
  SummonerRightHandDef = enum(57),
  SummonerRightHandAtk_Red = enum(156),
  SummonerRightHandDef_Red = enum(157),
  Suit_Summoner_MagicWand = enum(134),
  Suit_Summoner_MagicBook = enum(135),
  Suit_OneHandedBook = enum(186)
}
EWeaponSubtypeName = {
  [1] = "OneHandedSword",
  [2] = "TwoHandedSword",
  [3] = "Spear",
  [4] = "OneHandedAxe",
  [5] = "TwoHandedAxe",
  [6] = "OneHandedStick",
  [7] = "TwoHandedStick",
  [8] = "Shield",
  [9] = "Arch",
  [10] = "CrossBow",
  [11] = "Wand",
  [12] = "Katar"
}
ItemQuality2ColorDic = {
  [0] = "#DCE1E5",
  [1] = "#2BBDFF",
  [2] = "#D423B8",
  [3] = "#ff8a00",
  [4] = "#D916D9",
  [5] = "#1Add1F",
  [6] = "#e6e600",
  [7] = "#FF2323",
  [10] = "#666666",
  [11] = "#E8D04B",
  [12] = "#F36055",
  [20] = "#A38B5B",
  [21] = "#666666",
  [23] = "#df4be8",
  [24] = "#f36055",
  [25] = "#4ba7e8",
  [26] = "#FF69B4",
  [27] = "#FA4729"
}
ItemQuality2RGBDic = {
  [0] = Color(0.8627451, 0.8823529, 0.8980392),
  [1] = Color(0.1686275, 0.7411765, 1),
  [2] = Color(0.8313726, 0.1372549, 0.7215686),
  [3] = Color(1, 0.5411765, 0),
  [4] = Color(0.8509804, 0.08627451, 0.8509804),
  [5] = Color(0.1019608, 0.8666667, 0.1215686),
  [6] = Color(0.9019608, 0.9019608, 0),
  [7] = Color(1, 0.1372549, 0.1372549),
  [10] = Color(0.4, 0.4, 0.4),
  [11] = Color(0.9098039, 0.8156863, 0.2941177),
  [12] = Color(0.9529412, 0.3764706, 0.3333333)
}
Monster2ColorDic = {
  [1] = Color.green,
  [2] = Color.white
}
EItemColorEnum = {
  white = enum(0),
  blue = enum(),
  purple = enum(),
  orange = enum(),
  pink = enum(),
  green = enum(),
  yellow = enum(),
  bRed = enum(),
  gray = enum(10),
  gold = enum(11),
  red = enum(12),
  lightGold = enum(20),
  dark = enum(21),
  bPurple = enum(23),
  cRed = enum(24),
  bBlue = enum(25),
  BRed = enum(27)
}
ItemBind2Name = {
  [0] = "\196\144\198\176\225\187\163c giao d\225\187\139ch",
  [1] = "Kh\195\180ng \196\145\198\176\225\187\163c giao d\225\187\139ch",
  [2] = "Kh\195\180ng \196\145\198\176\225\187\163c giao d\225\187\139ch"
}
ItemBind = {
  trade = 0,
  untrade = 1,
  untradeII = 2
}
BagChangeTypeEnum = {
  Putoff = enum(60001),
  Takeoff = enum(60002),
  Recycle = enum(160001),
  Mail = enum(140001),
  Shop = enum(50009),
  Decompose = enum(20004),
  Recharge = enum(30001),
  RechargeReward = enum(30002),
  Gift = enum(30003),
  GiftDiam = enum(21002),
  Use = enum(20001),
  Auction = enum(50008),
  OnlineGift = enum(20012),
  Destroy = enum(20028),
  OptionalBox = enum(21014),
  Warehouse = enum(20008),
  KaLunTeBox = enum(20059),
  ShoppingSpree = enum(20070),
  PuzzleFenJie = enum(20088),
  LuckyDraw = enum(220013),
  Turntable = enum(220012),
  TreasureGiftProp = enum(220015),
  WarAllianceRedEnvelope = enum(40052),
  SevenDayGift = enum(220021),
  LuckyRebate = enum(220022),
  HolidayInvest = enum(230051),
  HolidayNiudan = enum(230235),
  WarAllianceFund = enum(40002),
  PandoraActivityDig = enum(230236),
  EnchantmentSmeltingBagChange = enum(60040)
}
StorageTypeEnum = {
  SacredBone = enum(4),
  CrystalNucleus = enum(5),
  PandoraBag = enum(6),
  EnchantEquip = enum(7)
}
EBuyTipEnum = {
  noEnoughGold = enum(0),
  noEnoughCount = enum(),
  noEnoughLevel = enum(),
  noEnoughBgCell = enum(),
  noProvideTime = enum(),
  noServerTime = enum(),
  noEnoughCareer = enum(),
  noEnoughScore = enum(),
  ConditionNoteEnough = enum()
}
TipsOpenType = {
  BagOpen = enum(1),
  RoleEquipOpen = enum(),
  RoleRedEquipOpen = enum(),
  AuctionOpen = enum(),
  ShopOpen = enum(),
  UnionAuction = enum(),
  ForgeOpen = enum(),
  HolyRingCombineOpen = enum()
}
TipsOtherType = {
  RoleRedEquipOpen_jewelry = enum(0),
  RoleEquipOpen_jewelry = enum(1)
}
TransferOpenType = {
  Intensify = enum(1),
  Zhuijia = enum(),
  IntensifyAndAdd = enum(),
  XiLian = enum()
}
TransferEquipType = {
  firstEquip = enum(1),
  secondEquip = enum()
}
ECoinsType = {
  gold = enum(1000010),
  integral = enum(1000020),
  bindIntegral = enum(1000021),
  gem = enum(1000030),
  melting = enum(1000040),
  gemNotTrade = enum(1000050),
  goldUnion = enum(1000060),
  warAllianceMoney = enum(1000090),
  contributeUnion = enum(1000070),
  VipEssence = enum(1000110),
  Score = enum(1000022),
  AnniversaryActivityMemoryStone = enum(1000207),
  SiFangZhengBaBronzeHonorPoint = enum(1000208),
  SiFangZhengBaSilverHonorPoint = enum(1000209),
  SiFangZhengBaGoldHonorPoint = enum(1000210),
  pandoraDaiBi = enum(10901001)
}
EBindCoinsType = {
  [ECoinsType.bindIntegral] = enum(1000020),
  [ECoinsType.gemNotTrade] = enum(1000030)
}
GoldRecoverCardType = {
  Mid = enum(41000001),
  High = enum(41000002),
  Max = enum(41000003)
}
EResourcesType = {
  gold = enum(101),
  diamond = enum(),
  QiJiBi = enum()
}
EStonePosition = {
  First = enum(1),
  Second = enum(),
  Third = enum(),
  Forth = enum(),
  Fifth = enum()
}
TipSerType = {
  TipWindow = enum(1),
  TipFloatText = enum(),
  TipBubbles = enum(),
  TipBreathing = enum(),
  TipCentered = enum(),
  TipRadioButton = enum()
}
TipType = {
  Success = enum(1),
  Fail = enum(),
  Reward = enum(),
  RechargeBuySuccessTip = enum()
}
CheckUseItemWay = {
  AddPointTip = enum(1),
  NotTip = enum(),
  NotAddPoint = enum()
}
ItemUseCheckState = {
  None = enum(0),
  careerUnEnough = enum(),
  transferUnEnough = enum(),
  levelUnEnough = enum(),
  attrPointUnEnough = enum(),
  attrPointEnough = enum()
}
EquipUpState = {
  None = enum(0),
  CanWearUpFight = enum(1),
  CantWearUpFight = enum(2),
  cantUpFight = enum(3),
  CantWear = enum(4)
}
TipShowSort = {
  use = enum(1),
  equip = enum(),
  addPoint = enum(),
  ShopSkill = enum(),
  auction = enum()
}
TipCountdown = {
  UIindex = enum(2)
}
TipAuctionOpen = {
  Upgrade = enum(1),
  AddRefresh = enum()
}
TipFastUse = {
  Normal = enum(1),
  Other = enum(11)
}
TipSubPanelPos = {
  left = enum(1),
  right = enum(),
  down = enum
}
TipPanelEnum = {
  ExpMedicine = "13",
  GoldBox = "30",
  BagStone = "16",
  WarehouseStone = "17"
}
SpecialItemIDEnum = {BagStone = 6000720, StoreHouseStone = 6000730}
AutoMaticPush = {
  None = enum(0),
  Push = enum()
}
SpecialSuitSubtype = {
  [EItemSubtype.OneHandedSword] = true,
  [EItemSubtype.OneHandedStick] = true,
  [EItemSubtype.RedOneHandedStick] = true,
  [EItemSubtype.HongZhuang_OneHandedSword] = true,
  [EItemSubtype.Suit_OneHandedSword] = true,
  [EItemSubtype.Suit_OneHandedStick] = true
}
TipRewardType = {
  Transcript = enum(),
  SynthesisProps = enum(),
  Recycle = enum(),
  Liveness = enum(),
  Task = enum(),
  Shop = enum(50009)
}
EItemIdEnum = {
  6000090,
  6000091,
  6000378,
  6000379
}
EForgeDataEnum = {
  Forge = 2000001,
  Intensify = 2010001,
  Transfer = 2410001,
  Ornaments = 2400001
}
ETitleItemIdEnum = {
  [33001001] = "kill_king",
  [33001002] = "roland_king",
  [33001003] = "first_z",
  [33001004] = "first_f",
  [33001005] = "first_ad",
  [33001006] = "qiJiComing",
  [33001007] = "yongShiComing",
  [33001008] = "yongShiComing",
  [33001009] = "qiJiGoodMan",
  [33001012] = "dafuweng",
  [33001011] = "yonghengzhidian"
}
EUseStoneRecordEnum = {
  None = enum(0),
  Path = enum(),
  Fight = enum()
}
EOpenTipsType = {
  FastBuy = enum()
}
EItemFromType = {
  Monster = enum(1),
  NPC = enum(),
  Gift = enum(12)
}
EAppearCellType = {
  1,
  6,
  10,
  11,
  12,
  13,
  15,
  17,
  20,
  21,
  22,
  23,
  24,
  30
}
EEquipCellType = {
  None = enum(0),
  Archangel = enum(6),
  Title = enum(8),
  Foot = enum(10),
  RingChange = enum(13),
  HolySpirit = enum(18)
}
EConsumableStrType = {
  Normal = enum(0),
  All = enum()
}
EItemBoxTblType = {
  BoxBox = enum(1),
  CommerceGoldenBox = enum()
}
PandoraDigTypeEnum = {
  InfiniteDig = enum(1),
  OrdinaryDig = enum(2)
}
