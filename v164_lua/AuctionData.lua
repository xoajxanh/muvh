AuctionData = {}
local this = AuctionData
AuctionData.SaleCount = 60
AuctionData.RoleID = nil
AuctionData.PutAwayPriceItem = nil
AuctionData.filterMeetTabs = {}
AuctionData.equipGradeTypeDP = 0
AuctionData.page = 0
AuctionData.TradeScreen = {
  Equip = 1,
  Weapon = 101,
  Helmet = 102,
  Armour = 103,
  EgGuard = 104,
  HandGuard = 105,
  Shoe = 106,
  Wing = 107,
  BigAngelSuit = 108,
  JewelryEquip = 109,
  RedEquip = 110,
  SkillBooks = 2,
  Material = 3,
  Gem = 301,
  TicketMat = 302,
  WingMat = 303,
  JewelryMat = 304,
  SkillMat = 305,
  FluorescentGems = 306,
  BigAngelSuitMat = 307,
  EquipSuperpositionStone = 308,
  GuardMat = 309,
  ArmbandsMat = 310,
  MasterExperiencePotion = 311,
  Currency = 4,
  MiracleCurrency = 401,
  Diamond = 402,
  SuitEquip = 81,
  SuitEquip_Weapon = 801,
  SuitEquip_Helmet = 802,
  SuitEquip_Armour = 803,
  SuitEquip_EgGuard = 804,
  SuitEquip_HandGuard = 805,
  SuitEquip_Shoe = 806,
  JewelryEquip = 91,
  JewelryEquip_Necklace = 901,
  JewelryEquip_Earrings = 902,
  JewelryEquip_Rings = 903,
  JewelryEquip_ReinNecklace = 904,
  JewelryEquip_ReinEarrings = 905,
  JewelryEquip_ReinRings = 906,
  HolySpirit = 5501,
  HolyRing = 541,
  HolyRing_1 = 5411,
  HolyRing_2 = 5412,
  HolyRing_3 = 5413,
  HolyRing_4 = 5414,
  HolyRing_5 = 5415,
  Reliquary = 561,
  Reliquary_1 = 5601,
  Reliquary_2 = 5602,
  Reliquary_3 = 5603,
  Newrunes = 571
}
AuctionData.toServerValue = {
  System = 0,
  Union = 1,
  CampUnion = 2,
  History = 3,
  PutOn = 4,
  TradeScreenControl = 0,
  Career_Defalut = "",
  Career_Swordman = "0#1",
  Career_Mage = "0#2",
  Career_SmartSagittary = "0#3#31",
  Career_AgilitySagittary = "0#3",
  Career_SpellSword = "0#4",
  SummonMagician = "0#6",
  Sort_DefValue = 0,
  Sort_PriceUp = 1,
  Sort_PriceDown = 2,
  Sort_TimeUp = 3,
  Sort_TimeDown = 4,
  EquipClass_defalult = enum(0),
  RoleLevel_defalult = enum(0),
  itemEquipNoJudge = 0,
  itemEquip_YesExcellent_NotSuit = 0,
  itemEquip_YesSuit_NotExcellent = 0,
  allItem = 0,
  prebuy = 1,
  prebuyData = 1,
  defMainType = 0,
  defServerType = 0
}

function AuctionData:JsonMsg(_indexer)
  if _indexer == IndexerEnum.get then
    local jsonStr = {
      sort = 0,
      career = "",
      roleLevel = 0,
      roleLevelFilter = 0,
      equipClassFilter = 0,
      itemConfigId = 0,
      itemType = "",
      itemSubType = "",
      itemCellType = 0,
      itemEquipClassMin = 0,
      itemEquipClassMax = 0,
      itemEquipSuit = 0,
      prebuy = 0,
      prebuyData = 0,
      auctionType = "",
      auctionSubtype = "",
      strideDealType = 0
    }
    return jsonStr
  end
end

AuctionData.ToServerJson = {
  mainType = 0,
  strideDealType = 0,
  allItem = 0,
  sort = 0,
  career = "",
  roleLevel = 0,
  roleLevelFilter = 0,
  equipClassFilter = 0,
  itemConfigId = 0,
  itemType = "",
  itemSubType = "",
  itemCellType = 0,
  itemEquipSuit = 0,
  prebuy = 0,
  prebuyData = 0,
  auctionType = "",
  auctionSubtype = ""
}
AuctionData.LeftSubTabDefault = {
  Default = 0,
  Equip_Weapon = enum(1),
  Equip_Helmet = enum(),
  Equip_Armour = enum(),
  Equip_EgGuard = enum(),
  Equip_HandGuard = enum(),
  Equip_Shoe = enum(),
  Equip_Wing = enum(),
  SuitEquip_Weapon = enum(1),
  SuitEquip_Helmet = enum(),
  SuitEquip_Armour = enum(),
  SuitEquip_EgGuard = enum(),
  SuitEquip_HandGuard = enum(),
  SuitEquip_Shoe = enum(),
  JewelryEquip_Necklace = enum(1),
  JewelryEquip_Earrings = enum(),
  JewelryEquip_Rings = enum(),
  JewelryEquip_ReinNecklace = enum(),
  JewelryEquip_ReinEarrings = enum(),
  JewelryEquip_ReinRings = enum(),
  Mat_Gem = enum(1),
  Mat_Ticket = enum(),
  Mat_Wing = enum(),
  Mat_Jewelry = enum(),
  Mat_Skill = enum(),
  Mat_FluorescentGems = enum(),
  Mat_EquipSuperpositionStone = enum(),
  Mat_GuardMat = enum(),
  Mat_ArmbandsMat = enum(),
  Mat_MasterExperiencePotion = enum(),
  Currency_Miracle = 1,
  Currency_Diamond = 2,
  HolyRingSmallTag_1 = enum(1),
  HolyRingSmallTag_2 = enum(),
  HolyRingSmallTag_3 = enum(),
  HolyRingSmallTag_4 = enum(),
  HolyRingSmallTag_5 = enum(),
  ReliquarySmallTag_1 = enum(1),
  ReliquarySmallTag_2 = enum(),
  ReliquarySmallTag_3 = enum()
}
AuctionData.EquipTabLis = {
  "V\197\169 kh\195\173",
  "N\195\179n S\225\186\175t",
  "Kh\225\186\163i Gi\195\161p",
  "Bao Ch\195\162n",
  "Bao Tay",
  "Gi\195\160y",
  "C\195\161nh"
}
AuctionData.SuitEquipTabLis = {
  "V\197\169 kh\195\173",
  "N\195\179n S\225\186\175t",
  "Kh\225\186\163i Gi\195\161p",
  "Bao Ch\195\162n",
  "Bao Tay",
  "Gi\195\160y"
}
AuctionData.JewelryEquipTabLis = {
  "Chuy\225\187\129n",
  "Khuy\195\170n",
  "Nh\225\186\171n",
  "D\195\162y Chuy\225\187\129n Chuy\225\187\131n Sinh",
  "Nh\225\186\171n Chuy\225\187\131n Sinh",
  "Khuy\195\170n Tai Chuy\225\187\131n Sinh"
}
AuctionData.HolySpiritTabLis = {}
AuctionData.MaterialTabList = {
  "\196\144\195\161",
  "Nguy\195\170n li\225\187\135u V\195\169 C\225\187\149ng",
  "Nguy\195\170n li\225\187\135u c\195\161nh",
  "Nguy\195\170n li\225\187\135u Trang S\225\187\169c",
  "Nguy\195\170n li\225\187\135u K\225\187\185 N\196\131ng",
  "Nguy\195\170n li\225\187\135u Hu\225\187\179nh Th\225\186\161ch",
  "X\225\186\191p ch\225\187\147ng \196\144\195\161 May M\225\186\175n",
  "Nguy\195\170n Li\225\187\135u Th\225\187\167 H\225\187\153",
  "Nguy\195\170n li\225\187\135u Ph\195\185 Hi\225\187\135u",
  "Thu\225\187\145c EXP B\225\186\173c Th\225\186\167y"
}
AuctionData.CurrencyTabList = {"V\195\160ng"}
AuctionData.LeftTagTabList = {
  "To\195\160n b\225\187\153",
  "Khu th\195\180ng b\195\161o",
  "\196\144eo",
  "B\225\187\153",
  "Trang s\225\187\169c",
  "Th\195\161nh H\225\187\147n ",
  "S\195\161ch K\225\187\185 N\196\131ng",
  "Nguy\195\170n li\225\187\135u",
  "Ti\225\187\129n",
  "\196\144\225\186\183t tr\198\176\225\187\155c",
  "Th\195\161nh Ho\195\160n",
  "Di V\225\186\173t "
}
AuctionData.HolyRingTabList = {
  "Th\195\161nh Ho\195\160n T\225\186\165n C\195\180ng",
  "Th\195\161nh Ho\195\160n Ph\195\178ng Th\225\187\167",
  "Th\195\161nh Ho\195\160n Gi\225\186\163m Buff",
  "Th\195\161nh Ho\195\160n H\225\187\147i Ph\225\187\165c",
  "Th\195\161nh Ho\195\160n Ki\225\187\131m So\195\161t"
}
AuctionData.ReliquaryTabList = {
  "Linh H\225\187\147n Th\198\176\225\187\157ng ",
  "Linh H\225\187\147n \196\144\225\186\183c Bi\225\187\135t",
  "Linh H\225\187\147n \198\175u T\195\186"
}
AuctionData.ContentData = {
  TagCount = 0,
  Spacing = 0,
  ContentDeltaY = 0
}
AuctionData.PetTabLis = {}
AuctionData.AllAuctionData = {}
AuctionData.PageAuctionData = {}
AuctionData.AppointData = {}
AuctionData.MyHistoryData = {}
AuctionData.MyBoughtTab = false
AuctionData.serverGroup = {}
AuctionData.AutoRackTable = {}
AuctionData.UnionAuctionData = {}
AuctionData.CareerType = {
  [11] = "11",
  [21] = "11",
  [31] = "11",
  [12] = "12",
  [22] = "12",
  [32] = "12",
  [13] = "13",
  [23] = "13",
  [33] = "13",
  [14] = "14",
  [24] = "14",
  [34] = "14"
}
AuctionData.EquipClassInfo = {
  [0] = {
    minClass = 0,
    maxClass = 0,
    dpIndex = 0
  },
  [1] = {
    minClass = 4,
    maxClass = 10,
    dpIndex = 1
  },
  [2] = {
    minClass = 11,
    maxClass = 15,
    dpIndex = 2
  },
  [3] = {
    minClass = 16,
    maxClass = 20,
    dpIndex = 3
  },
  [4] = {
    minClass = 21,
    maxClass = 25,
    dpIndex = 4
  },
  [5] = {
    minClass = 26,
    maxClass = 30,
    dpIndex = 5
  },
  [6] = {
    minClass = 31,
    maxClass = 35,
    dpIndex = 6
  },
  [7] = {
    minClass = 36,
    maxClass = 40,
    dpIndex = 7
  },
  [8] = {
    minClass = 41,
    maxClass = 45,
    dpIndex = 8
  },
  [9] = {
    minClass = 46,
    maxClass = 50,
    dpIndex = 9
  },
  [10] = {
    minClass = 51,
    maxClass = 55,
    dpIndex = 10
  },
  [11] = {
    minClass = 56,
    maxClass = 60,
    dpIndex = 11
  },
  [12] = {
    minClass = 61,
    maxClass = 65,
    dpIndex = 12
  },
  [13] = {
    minClass = 66,
    maxClass = 70,
    dpIndex = 13
  },
  [14] = {
    minClass = 71,
    maxClass = 75,
    dpIndex = 14
  },
  [15] = {
    minClass = 76,
    maxClass = 80,
    dpIndex = 15
  },
  [16] = {
    minClass = 81,
    maxClass = 85,
    dpIndex = 16
  }
}
AuctionData.RoleLevelInfo = {
  [0] = {
    roleLv = 0,
    playerLvDes = "To\195\160n b\225\187\153 c\225\186\165p \196\145\225\187\153",
    dpIndex = 0
  },
  [1] = {
    roleLv = 1,
    playerLvDes = "Lv.1",
    dpIndex = 1
  },
  [2] = {
    roleLv = 401,
    playerLvDes = "1 Chuy\225\187\131n Lv1",
    dpIndex = 2
  },
  [3] = {
    roleLv = 801,
    playerLvDes = "Chuy\225\187\131n 2 Lv1",
    dpIndex = 3
  },
  [4] = {
    roleLv = 1201,
    playerLvDes = "3 Chuy\225\187\131n Lv1",
    dpIndex = 4
  },
  [5] = {
    roleLv = 1601,
    playerLvDes = "4 Chuy\225\187\131n Lv1",
    dpIndex = 5
  },
  [6] = {
    roleLv = 2001,
    playerLvDes = "5 Chuy\225\187\131n Lv1",
    dpIndex = 6
  },
  [7] = {
    roleLv = 2401,
    playerLvDes = "6 Chuy\225\187\131n Lv1",
    dpIndex = 7
  },
  [8] = {
    roleLv = 2801,
    playerLvDes = "7 Chuy\225\187\131n Lv1",
    dpIndex = 8
  },
  [9] = {
    roleLv = 3201,
    playerLvDes = "8 Chuy\225\187\131n Lv1",
    dpIndex = 9
  },
  [10] = {
    roleLv = 3601,
    playerLvDes = "9 Chuy\225\187\131n Lv1",
    dpIndex = 10
  },
  [11] = {
    roleLv = 4001,
    playerLvDes = "10 Chuy\225\187\131n Lv1",
    dpIndex = 11
  },
  [12] = {
    roleLv = 4401,
    playerLvDes = "11 Chuy\225\187\131n Lv1",
    dpIndex = 12
  },
  [13] = {
    roleLv = 4801,
    playerLvDes = "1Chuy\225\187\131n 2 Lv1",
    dpIndex = 13
  },
  [14] = {
    roleLv = 5201,
    playerLvDes = "13 Chuy\225\187\131n Lv1",
    dpIndex = 14
  },
  [15] = {
    roleLv = 5601,
    playerLvDes = "14 Chuy\225\187\131n Lv1",
    dpIndex = 15
  },
  [16] = {
    roleLv = 6001,
    playerLvDes = "15 Chuy\225\187\131n Lv1",
    dpIndex = 16
  }
}
AuctionData.AuctionSortUpDown = false
AuctionData.unionServerType = 100
AuctionData.IsLoadAllData = false
AuctionData.LoadDataNum = 10
AuctionData.pageIndex = 0
AuctionData.mainType = 0
AuctionData.WearEquipTipData = {}
AuctionData.serverStallPositionData = {}
AuctionData.stallAuctionInfo = {}
AuctionData.isOwnSelfStall = false
AuctionData.isFirstOpenAuctionUnionTips = true
AuctionData.isFirstOpenAuctionUnionCampTips = true
AuctionData.isSlider = false

function AuctionData.Init()
end

function AuctionData.InitAllServerAuctionData(data)
  if data ~= nil then
    if data.type == AuctionData.toServerValue.PutOn then
      this.LookPutOn(data)
    elseif data.type == AuctionData.toServerValue.History then
      this.LookHistory(data)
    else
      this.LookPage(data)
    end
  end
end

function AuctionData.LookPutOn(data)
  if data.auctionInfo == nil then
    AuctionData.isOwnSelfStall = false
  else
    AuctionData.isOwnSelfStall = true
    AuctionData.stallAuctionInfo = data.auctionInfo
  end
  this.AutoRackTable = {}
  for i = 1, #data.shelf do
    table.insert(this.AutoRackTable, data.shelf[i].items)
  end
  EventManager.Dispatch(Event.Auction_InitPutAway)
end

function AuctionData.LookHistory(data)
  this.MyHistoryData = {}
  for i = 1, #data.history do
    table.insert(this.MyHistoryData, data.history[i])
  end
  EventManager.Dispatch(Event.Auction_LookHistory)
end

function AuctionData.LookPage(data)
  this.PageAuctionData = {}
  if data then
    this.pageIndex = data.index
    this.mainType = data.type
    for i = 1, #data.shelf do
      table.insert(this.PageAuctionData, data.shelf[i].items)
    end
    if data.type == AuctionData.toServerValue.Union or data.type == AuctionData.toServerValue.CampUnion then
      EventManager.Dispatch(Event.Auction_LookUnion)
    else
      EventManager.Dispatch(Event.Auction_PageAuctionData)
    end
  end
end

function AuctionData.PutAwayOffData(data)
  if data ~= nil then
    local dataRes = data.items
    if 0 <= #dataRes then
      this.AutoRackTable = {}
      for i = 1, #dataRes do
        this.AutoRackTable[i] = dataRes[i]
      end
    end
    EventManager.Dispatch(Event.Auction_Shelf)
  end
end

function AuctionData.AllAuctionDataAdd(data)
  if data ~= nil then
    for i = 1, #data.items do
      table.insert(this.PageAuctionData, data.items[i])
    end
    this.UpdateAllAuctionData()
  end
end

function AuctionData.AllAuctionDataDel(data)
  if data ~= nil then
    local dataDel = data.items
    local dataAll
    dataAll = this.PageAuctionData
    if 0 < #dataDel and 0 < #dataAll and 0 < #dataAll then
      for i = 1, #dataDel do
        for j = 1, #dataAll do
          if dataDel[i].tid == dataAll[j].tid then
            table.remove(this.PageAuctionData, j)
            this.UpdateAllAuctionData()
            break
          end
        end
      end
    end
  end
end

function AuctionData.AllAuctionDataMod(data)
  if data ~= nil and this.PageAuctionData ~= nil then
    local dataMod = data.items
    local dataAll = this.PageAuctionData
    if 0 < #dataMod and 0 < #dataAll then
      for i = 1, #dataMod do
        for j = 1, #dataAll do
          if dataMod[i].tid == dataAll[j].tid then
            dataAll[j].lowPrice = dataMod[i].lowPrice
            dataAll[j].endTime = dataMod[i].endTime
            dataAll[j].preBuyer = dataMod[i].preBuyer
            dataAll[j].item.count = dataMod[i].item.count
            dataAll[j].buyer = dataMod[i].buyer
            this.UpdateAllAuctionData()
            break
          end
        end
      end
    end
    this.IsLoadAllData = false
  end
end

function AuctionData:UpdateAllAuctionData()
  this.UnionAuctionData = {}
  EventManager.Dispatch(Event.Auction_UpdateAuctionData)
end

function AuctionData.RecordID(id)
  if id ~= nil then
    this.RoleID = id
  end
end

function AuctionData.GetItemConfigInfo(itemInfo)
  local cfgItem = ClientTable.cfg_Item_itemManager:TryGetValue(itemInfo.itemId)
  local item
  if ItemUtility.IsEquipType(cfgItem.type) then
    item = EquipData(itemInfo)
  else
    item = ItemData(itemInfo)
  end
  return item
end

function AuctionData.MyAuctionTimeSort(UpOrDown, ref, t, cmp)
  this.AuctionSortUpDown = UpOrDown
  local refData = ref
  local normalTable = table.metatableCopy(nil, refData)
  table.sort(normalTable, function(a, b)
    if a.time ~= nil and b.time ~= nil then
      if this.AuctionSortUpDown then
        return a.time > b.time
      else
        return a.time < b.time
      end
    end
  end)
  local n = #ref
  local r = {}
  for i = 1, n do
    r[i] = i
  end
  cmp = cmp or function(a, b)
    if this.AuctionSortUpDown then
      return a.time > b.time
    else
      return a.time < b.time
    end
  end
  table.sort(r, function(a, b)
    return cmp(ref[a], ref[b])
  end)
  for i = 1, n do
    r[i] = t[r[i]]
  end
  return normalTable, r
end

function AuctionData.SortByTime(isUpSort, tabList)
  table.sort(tabList, function(a, b)
    if a.time ~= nil and b.time ~= nil then
      if this.isUpSort then
        return a.time < b.time
      else
        return a.time > b.time
      end
    end
  end)
  return tabList
end

function AuctionData.GetTotalPutOnNumber()
  local totalPutOnNum = AuctionData.GetDefalutPutOnNum() + AuctionData.GetIncreaseNumber()
  return totalPutOnNum
end

function AuctionData.GetIncreaseNumber()
  local putAwayNumStr = ClientTable.cfg_Global_globalManager:TryGetValue(17000002, "id").effect
  local putAwayArray = string.split(putAwayNumStr, "&")
  local memberGridDic = {}
  for i = 1, #putAwayArray do
    local infoArray = string.split(putAwayArray[i], "#")
    local tabInfo = {memberLevel = 0, gridCount = 0}
    tabInfo.memberLevel = tonumber(infoArray[1])
    tabInfo.gridCount = tonumber(infoArray[2])
    table.insert(memberGridDic, tabInfo)
  end
  local mMemberLevel = AuctionData.GetMemberLevel()
  local tempMemberLv = 0
  local increaseMum = 0
  for key, value in pairs(memberGridDic) do
    if mMemberLevel >= value.memberLevel and tempMemberLv < value.memberLevel then
      increaseMum = increaseMum + value.gridCount
      tempMemberLv = value.memberLevel
    end
  end
  return increaseMum
end

function AuctionData.GetDefalutPutOnNum()
  local defalutPutOnNum = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(2310004, "id").effect)
  return defalutPutOnNum
end

function AuctionData.GetMemberLevel()
  local memberLevel = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetMemberLevle()
  return memberLevel
end

function AuctionData.CheckPutAway()
  local cfg_Global = ClientTable.cfg_Global_globalManager:TryGetValue(17000001)
  local isCanPutAway = ConditionManager.Check4D(cfg_Global.effect)
  return isCanPutAway
end

function AuctionData.CheackUnion()
  return WarAllianceData.IsHaveUnion
end

function AuctionData.CheackUnionCamp()
  local isOpen = ConditionManager.Check(GlobalConfig.GetGlobalConfig(11110001))
  local isHaveUnionCamp = ViewData.meData.unionCamp > 0
  return isOpen and isHaveUnionCamp
end

function AuctionData.CheackIsOpenSZGD()
  local isOpen = false
  isOpen = ConditionManager.Check(GlobalConfig.GetGlobalConfig(11110001))
  return isOpen
end

function AuctionData.InitServerGroupData(data)
  this.serverGroup = {}
  if table.count(data.serverId) > 0 then
    for i, v in pairs(data.serverId) do
      table.insert(this.serverGroup, v)
    end
  end
end

function AuctionData.GetServerGroupData()
  if table.count(this.serverGroup) > 0 then
    table.sort(this.serverGroup)
    return this.serverGroup
  end
  return nil
end

function AuctionData.AuctionDataReSet()
  AuctionData.PageAuctionData = {}
  AuctionData.AppointData = {}
  AuctionData.MyHistoryData = {}
end

AuctionData.Init()
