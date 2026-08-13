MoneyType = {
  MoneyOne = enum(1),
  MoneyTwo = enum()
}
AuctionRecTimer = {
  None = enum(0),
  AuctionTab = enum(1),
  History = enum(),
  MyPutOn = enum(),
  Union = enum(),
  UnionCamp = enum(),
  StrideServe = enum()
}
AuctionTabType = {
  None = enum(0),
  All = enum(1),
  Public = enum(),
  Equip = enum(),
  SuitEquip = enum(),
  JewelryEquip = enum(),
  HolySpirit = enum(),
  SkillBook = enum(),
  Material = enum(),
  Currency = enum(),
  appoint = enum(),
  HolyRing = enum(),
  Reliquary = enum(),
  Newrunes = enum()
}
AuctionLeftSubTabType = {
  None = 0,
  Equip_Weapon = 1,
  Equip_Helmet = 2,
  Equip_Armour = 3,
  Equip_EgGuard = 4,
  Equip_HandGuard = 5,
  Equip_Shoe = 6,
  Equip_Wing = 7,
  Equip_BigAngelSuit = 8,
  Mat_Gem = 1,
  Mat_Ticket = 2,
  Mat_Wing = 3,
  Mat_Jewelry = 4,
  Mat_Skill = 5,
  Mat_FluorescentGems = 6,
  Mat_BigAngelSuit = 7,
  Mat_EquipSuperpositionStone = 8,
  Currency_Miracle = 1,
  Currency_Diamond = 2
}
AuctionEquipType = {
  All = enum(0),
  Excellent = enum(),
  Suit = enum()
}
AuctionPutOnType = {
  commonAuction = enum(0),
  unionAuction = enum()
}
AuctionTipOpenType = {
  putOn = enum(0),
  appoint = enum(),
  buy = enum(),
  putOff = enum(),
  unionBuy = enum(),
  unionOneBuy = enum()
}
AuctionHistoryType = {
  buy = enum(1),
  sell = enum(2),
  appoint = enum(3),
  refund = enum(4)
}
AuctionSortType = {
  default = enum(0),
  priceUp = enum(1),
  priceDown = enum(2),
  timeUp = enum(3),
  timeDown = enum(4)
}
AuctionJobType = {
  default = enum(0),
  Career_Swordman = 1,
  Career_Mage = 2,
  Career_AgilitySagittary = 3,
  Career_SpellSword = 4,
  SummonMagician = 5
}
AuctionEquipClassType = {
  default = enum(0)
}
AuctionRoleLevelType = {
  default = enum(0)
}
AuctionHolySpiritGradeType = {
  default = enum(0)
}
AuctionTileTabType = {
  AuctionTab = enum(1),
  Union = enum(),
  History = enum(),
  MyAuction = enum(),
  UnionCamp = enum(),
  Holyring_sale = enum(),
  Holyskeleton_sale = enum()
}
AuctionFilterType = {
  CareerType = enum(0),
  SortType = enum(),
  EquipGradeType = enum(),
  RoleLevel = enum(),
  HolySpiritGradeType = enum()
}
AuctionStallMap = {
  YongZheDaLu = 1001,
  XianZongLing = 1004,
  ShengZhiGuoDu = 1091
}
IndexerEnum = {
  get = enum(1),
  set = enum(),
  dis = enum()
}
ConditionJsonEnum = {
  mainType = enum(1),
  strideDealType = enum(),
  sort = enum(),
  career = enum(),
  roleLevel = enum(),
  allItem = enum(),
  TradeScreenControl_Equip = enum(),
  TradeScreenControl_Mat = enum(),
  TradeScreenControl_Currency = enum(),
  TradeScreenControl_SkillBook = enum(),
  TradeScreenControl_SuitEquip = enum(),
  TradeScreenControl_JewelryEquip = enum(),
  TradeScreenControl_HolySpirit = enum(),
  TradeScreenControl_HolyRing = enum(),
  TradeScreenControl_Reliquary = enum(),
  TradeScreenControl_Newrunes = enum(),
  itemEquipClass = enum(),
  itemEquipSuit = enum(),
  prebuy = enum(),
  prebuyData = enum()
}
AuctionBtnType = {
  StrideServeBtn_2 = enum(2310202),
  StrideServeBtn_3 = enum(2310203),
  StrideServeBtn_4 = enum(2310204),
  StrideServeBtn_5 = enum(2310501),
  StrideServeBtn_6 = enum(2310502),
  StrideServeBtn_7 = enum(2310601),
  StrideServeBtn_8 = enum(2310602),
  StrideServeBtn_9 = enum(2310701)
}
