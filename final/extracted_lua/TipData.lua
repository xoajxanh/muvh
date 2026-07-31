TipData = {}
local this = TipData
local UICount = 6
TipData.UpLevel = 0
TipData.addPointCondition = 0
TipData.UpAddProint = {}
TipData.UpExpProp = {}
TipData.UpExpPropid = 0
local ShopBuycond
local ShopSkilltype = 4
local HistorySkillTip = {}
TipData.shopTypeTbl = {}
local shopShowedItemList = {}
TipData.AuctionOpen = false
local HistoryPrint = 0
local ProintDiffer = 5
local LastRefreshLv = -1
local LastRefreshLvnun = 0
local LvMaxCount = 2
TipData.AUCTIONSHENGJI = "AUCTIONSHENGJI"
local LVRefreshTime = 1800000
local AuctRecomAddTime = {}
local AuctRecomdiffer = 1800000
TipData.HistoryTotal = {}
TipData.PushTotalCount = 10
TipData.AUCTIONRECOMBUY = "AUCTIONRECOMBUY"
local RandomNumber = 1
local AuctTypelimit = {}
local SelfEquipRecomTime = 600000
local SelfEquipRecomCount = 3
TipData.AUCTIONSELFEQUIP = "AUCTIONSELFEQUIP"
TipData.ShowSortUIName = {
  [1] = "Skill_TIpsUI",
  [2] = "Equip_TIpsUI",
  [3] = "Attribute_AddTipsUI",
  [4] = "ShopSkill_TIpsUI",
  [5] = "Auction_TIpsUI"
}
TipData.StorageInfo = {
  [1] = {},
  [2] = {},
  [3] = {},
  [4] = {},
  [5] = {}
}

function TipData.CloseData()
  this.StorageInfo[1] = {}
  this.StorageInfo[2] = {}
  this.StorageInfo[3] = {}
  this.StorageInfo[4] = {}
  this.StorageInfo[5] = {}
end

function TipData.ClosetypeData(type)
  if type ~= TipShowSort.use then
    this.StorageInfo[1] = {}
  end
  this.StorageInfo[2] = {}
  this.StorageInfo[3] = {}
  this.StorageInfo[4] = {}
end

function TipData.CloseItemData(type)
  this.StorageInfo[type] = {}
end

function TipData.PopUpItemData(type, data)
  if type == TipShowSort.addPoint or type == TipShowSort.ShopSkill then
    this.StorageInfo[type] = data
  else
    table.insert(this.StorageInfo[type], data)
  end
end

function TipData.CoverItemData(type, data)
  this.StorageInfo[type] = data
end

function TipData.PopUpData(type, data)
  table.insert(this.StorageInfo[type], data)
end

function TipData.RefreshItem(type, data)
  if type ~= TipShowSort.use then
    this.StorageInfo[type] = data
  end
end

function TipData.OpenNextUI()
  for i = 1, UICount do
    local index = i
    if table.count(this.StorageInfo[index]) > 0 then
      UIManager.Show(this.ShowSortUIName[index], {
        ItemInfo = this.StorageInfo[index]
      })
      this.StorageInfo[index] = {}
      return
    end
  end
end

function TipData.UnCacheData(type, data)
  local SortUI = this.ShowSortUIName
  local uiindex
  for i, v in pairs(SortUI) do
    local ui = UIManager.IsVisible(v)
    if ui then
      uiindex = i
    end
  end
  if uiindex == nil then
    this.CloseData()
    return true
  elseif uiindex <= TipCountdown.UIindex then
    if uiindex == type then
      return true
    else
      this.PopUpItemData(type, data)
      return false
    end
  elseif type < uiindex then
    this.PopUpItemData(type, data)
    local UI = UIManager.GetUiByName(this.ShowSortUIName[uiindex])
    UI:PushStackData()
    return false
  elseif uiindex == type then
    return true
  elseif type > uiindex then
    this.PopUpItemData(type, data)
    return false
  end
end

function TipData.UnlvPointData(type, data)
  local SortUI = this.ShowSortUIName
  local uiindex
  for i, v in pairs(SortUI) do
    local ui = UIManager.IsVisible(v)
    if ui then
      uiindex = i
    end
  end
  if uiindex == nil then
    this.ClosetypeData(type)
    return true
  elseif uiindex <= TipCountdown.UIindex then
    if uiindex == type then
      return true
    else
      this.PopUpItemData(type, data)
      return false
    end
  elseif type < uiindex then
    this.PopUpItemData(type, data)
    local UI = UIManager.GetUiByName(this.ShowSortUIName[uiindex])
    UI:PushStackData()
    return false
  elseif uiindex == type then
    return true
  elseif type > uiindex then
    this.PopUpItemData(type, data)
    return false
  end
end

function TipData.UnCacheUse(type)
  local SortUI = this.ShowSortUIName
  local uiindex
  for i, v in pairs(SortUI) do
    local ui = UIManager.IsVisible(v)
    if ui then
      uiindex = i
    end
  end
  if uiindex == nil then
    this.CloseData()
    return true
  elseif uiindex <= TipCountdown.UIindex then
    if uiindex == type then
      return true
    else
      return false
    end
  elseif type < uiindex then
    local UI = UIManager.GetUiByName(this.ShowSortUIName[uiindex])
    UI:PushStackData()
    return false
  elseif uiindex == type then
    return true
  elseif type > uiindex then
    return false
  end
end

function TipData.UnCacheinfo(type, info)
  local SortUI = this.ShowSortUIName
  local uiindex
  for i, v in pairs(SortUI) do
    local ui = UIManager.IsVisible(v)
    if ui then
      uiindex = i
    end
  end
  if uiindex == nil then
    this.ClosetypeData(type)
    return true
  elseif uiindex <= TipCountdown.UIindex then
    if uiindex == type then
      return true
    else
      this.RefreshItem(type, info)
      return false
    end
  elseif type < uiindex then
    this.RefreshItem(type, info)
    local UI = UIManager.GetUiByName(this.ShowSortUIName[uiindex])
    UI:PushStackData()
    return false
  elseif uiindex == type then
    return true
  elseif type > uiindex then
    this.RefreshItem(type, info)
    return false
  end
end

function TipData.UseExpProp(id, itemid, count)
  local cpunt = 0
  for i = 1, count do
    cpunt = cpunt + this.UpExpProp[itemid]
  end
  local lvCfg = ClientTable.cfg_Character_levelManager:TryGetValue(RoleManager.me.data.level, "level").exp
  local Difference = lvCfg - RoleManager.me.data.exp
  if cpunt > Difference then
    this.UpExpPropid = id
  end
end

function TipData.UseExpPropInit()
  local expprop = ConfigManager.FindConfigs("cfg_Item_item", "subType", 303)
  for i = 1, #expprop do
    local itemid = expprop[i].id
    local count = tonumber(string.split(expprop[i].useParam, "#")[2])
    this.UpExpProp[itemid] = count
  end
end

function TipData.Init()
  this.UpLevel = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(11000002))
  local AddProint1 = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(1150001)
  local AddProint2 = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(1150002)
  this.UpAddProint[1] = string.split(AddProint1, "&")
  this.UpAddProint[2] = string.split(AddProint2, "&")
  this.UseExpPropInit()
  LvMaxCount = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2310013))
  LVRefreshTime = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2310014))
  AuctRecomdiffer = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2310015))
  this.PushTotalCount = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2310016))
  local limit = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2310019)
  local limitGrop = string.split(limit, "&")
  for i, v in pairs(limitGrop) do
    local data = string.split(v, "#")
    local type = tonumber(data[1])
    local subtype = tonumber(data[2])
    if AuctTypelimit[type] then
      table.insert(AuctTypelimit[type], subtype)
    else
      AuctTypelimit[type] = {}
      table.insert(AuctTypelimit[type], subtype)
    end
  end
  local strEffect = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2360004)
  local strEffectTab = string.split(strEffect, "&")
  ShopBuycond = {}
  for i = 1, #strEffectTab do
    ShopBuycond[i] = string.split(strEffectTab[i], "#")
  end
  SelfEquipRecomTime = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2310017))
  SelfEquipRecomCount = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2310018))
  this.addPointCondition = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(11000004)
end

TipData.Init()

function TipData.OpenShopTip()
  for i = 1, #ShopBuycond do
    if not ConditionManager.GenerateSingleCondition(ShopBuycond[i]):Check() then
      return
    end
  end
  local ShopData = ShopData.GetShopInfo()
  
  local function Judge(item)
    local roleid = RoleManager.me.data.id
    local historyrole = true
    local historyitem = true
    for i, v in pairs(shopShowedItemList) do
      if i == roleid then
        historyrole = false
        for k, w in pairs(shopShowedItemList[i]) do
          if w == item.id then
            historyitem = false
            break
          end
        end
        break
      end
    end
    if historyrole then
      return true
    elseif historyitem then
      return true
    end
    return false
  end
  
  local maxLevelItem
  local minPushsort = -1
  for i, v in pairs(ShopData) do
    if v.automaticpush == AutoMaticPush.Push then
      local buyLimitShow = LimitUtility.GetLimitShow(v.buyCondition)
      local str, limitType = LimitUtility.GetTipText(buyLimitShow, v)
      if not limitType then
        local das = string.split(v.reward, "#")
        local itemid = tonumber(das[1])
        local item = ClientTable.cfg_Item_itemManager:TryGetValue(itemid)
        local isNotJiHuoGuard = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():IsNotJiHuoGuardByItemId(itemid)
        if Judge(item) and isNotJiHuoGuard == false and (minPushsort == -1 or minPushsort > v.pushsort) then
          minPushsort = v.pushsort
          maxLevelItem = item
          this.shopTypeTbl = {
            type = v.type,
            subtype = v.subtype
          }
        end
      end
    end
  end
  if maxLevelItem then
    local roleid = RoleManager.me.data.id
    local historyrole = true
    local historyitem = true
    for i, v in pairs(shopShowedItemList) do
      if i == roleid then
        historyrole = false
        for k, w in pairs(shopShowedItemList[i]) do
          if w == maxLevelItem.id then
            historyitem = false
            break
          end
        end
        break
      end
    end
    if historyrole then
      shopShowedItemList[roleid] = {}
      table.insert(shopShowedItemList[roleid], maxLevelItem.id)
      local UnCacheData = this.UnCacheData(TipShowSort.ShopSkill, {maxLevelItem})
      if UnCacheData then
        UIManager.Show(UIID.ShopSkillTIpsUI, {
          ItemInfo = {maxLevelItem}
        })
      end
    elseif historyitem then
      table.insert(shopShowedItemList[roleid], maxLevelItem.id)
      local UnCacheData = this.UnCacheData(TipShowSort.ShopSkill, {maxLevelItem})
      if UnCacheData then
        UIManager.Show(UIID.ShopSkillTIpsUI, {
          ItemInfo = {maxLevelItem}
        })
      end
    end
  end
end

function TipData.BagChangeRefrsh(id)
  for i = 1, #this.StorageInfo do
    local info = this.StorageInfo[i]
    if i ~= TipShowSort.addPoint then
      local acc = 0
      for k = 1, #info do
        k = acc + k
        if info[k] then
          if info[k].id == id then
            table.remove(this.StorageInfo[i], k)
            acc = acc - 1
          end
        else
          logError("D\225\187\175 li\225\187\135u b\225\186\163ng l\195\160 nil, c\225\186\167n ki\225\187\131m tra nguy\195\170n nh\195\162n")
        end
      end
    end
  end
end

function TipData.BagChangeCountRefrsh(id, count)
  local mun = 0
  for i = 1, #this.StorageInfo do
    local info = this.StorageInfo[i]
    if i ~= TipShowSort.addPoint then
      local acc = 0
      for k = 1, #info do
        if mun == count then
          return
        end
        k = acc + k
        if info[k] then
          if info[k].id == id then
            table.remove(this.StorageInfo[i], k)
            acc = acc - 1
            mun = mun + 1
          end
        else
          logError("D\225\187\175 li\225\187\135u b\225\186\163ng l\195\160 nil, c\225\186\167n ki\225\187\131m tra nguy\195\170n nh\195\162n")
        end
      end
    end
  end
end

function TipData.bageChangeType(msg)
  if msg.logType == BagChangeTypeEnum.Recycle or msg.logType == BagChangeTypeEnum.Putoff or msg.logType == BagChangeTypeEnum.Use or msg.logType == BagChangeTypeEnum.Decompose or msg.logType == BagChangeTypeEnum.Auction or msg.logType == BagChangeTypeEnum.Destroy or msg.logType == BagChangeTypeEnum.Warehouse then
    return true
  end
  return false
end

function TipData.AuctionTip()
  if this.AuctionOpen then
    return true
  end
  local Tab = ClientTable.cfg_Function_functionManager:TryGetValue(2310001, "id").condition
  local strTab
  if 1 < #Tab then
    strTab = Tab
    for i = 1, #strTab do
      if ConditionManager.GenerateSingleCondition(strTab[i][1]):Check() then
        this.AuctionOpen = true
        return true
      end
    end
  else
    strTab = Tab[1]
    for i = 1, #strTab do
      if not ConditionManager.GenerateSingleCondition(strTab[i]):Check() then
        this.AuctionOpen = false
        return false
      end
    end
    this.AuctionOpen = true
    return true
  end
  return false
end

local function PopupAuctTIpUI(Items)
  local UnCacheData = this.UnCacheData(TipShowSort.auction, Items)
  if UnCacheData then
    if Items.itemId == 3003001 and QuickFind.MasterDataMgr() then
      local exChangeInfo = QuickFind.MasterDataMgr():GetExChangeInfo()
      local todaySurplusExchangeCount = exChangeInfo and exChangeInfo.value or 1
      if todaySurplusExchangeCount <= 0 then
        return
      end
    end
    local AuctionTIpsUI = UIManager.GetUiByName(UIID.AuctionTIpsUI)
    if not AuctionTIpsUI or not AuctionTIpsUI.visible then
      UIManager.Show(UIID.AuctionTIpsUI, {
        ItemInfo = {Items}
      })
    else
      AuctionTIpsUI:InsertData(Items)
    end
  end
end

function TipData.WearEquip(Items, msg)
  if Items.tblItem.rightOperate == EItemOperateType.Wear then
    local state = RoleEquipUtility.CanUpFight(Items)
    local isRecommendEquip = RoleEquipUtility.IsRecommendEquipByCareer(Items.itemId, RoleUtility.GetCurrentCareerCategory())
    if state == EquipUpState.CanWearUpFight or state == EquipUpState.CantWearUpFight then
      local wearindex = RoleEquipUtility.WearEquipIndex(Items)
      local wearble = RoleManager.me.data.equipsData.Data[wearindex]
      Items.wearindex = wearindex
      local EquipTIpsUI = UIManager.GetUiByName(UIID.EquipTIpsUI)
      if wearble == nil then
        local UnCacheData = this.UnCacheData(TipShowSort.equip, Items) and isRecommendEquip
        if UnCacheData then
          if not EquipTIpsUI or not EquipTIpsUI.visible then
            UIManager.Show(UIID.EquipTIpsUI, {
              ItemInfo = {Items},
              bagchange = true
            })
          else
            EquipTIpsUI:InsertData({Items})
          end
        end
      else
        local UnCacheData = this.UnCacheData(TipShowSort.equip, Items) and isRecommendEquip
        if UnCacheData then
          if not EquipTIpsUI or not EquipTIpsUI.visible then
            UIManager.Show(UIID.EquipTIpsUI, {
              ItemInfo = {Items},
              bagchange = true
            })
          else
            EquipTIpsUI:InsertData({Items})
          end
        end
      end
      return
    end
    if RoleManager.me.data.level >= 30 and this.AuctionOpen and #AuctionData.AutoRackTable < 3 and Items.bind == ItemBind.trade and LoginData.openServerDay <= GlobalConfig.AutoRackopenServerDay then
      if not this.AuctionOpen then
        return
      end
      if Items.tblEquip and Items.tblItem.auction ~= "" and this.RecommendCount() then
        local canuse = RoleEquipUtility.JobUseItem(Items)
        if not canuse then
          PopupAuctTIpUI(Items)
        end
      end
    end
  elseif Items.tblItem.rightOperate == EItemOperateType.Use or Items.tblItem.rightOperate == EItemOperateType.UseAll then
    local canUse, state = RoleEquipUtility.CheckUseItem(Items, CheckUseItemWay.NotAddPoint)
    if canUse or state == ItemUseCheckState.attrPointEnough then
      if Items.subType == 21 then
        local isNeedUse, isStrengthenItem = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():IsNeedUsePopPrompt(Items.tblItem.id)
        if isStrengthenItem then
        end
        if isNeedUse then
          PopupAuctTIpUI(Items)
        end
        return
      end
      local UseSkill, usegoldbox = ItemUtility.UseRoleSkill(Items)
      if not UseSkill then
        return
      end
      if usegoldbox then
        PopupAuctTIpUI(Items)
      else
        local UnCacheData = this.UnCacheUse(TipShowSort.use)
        if UnCacheData then
          local SkillTIpsUI = UIManager.GetUiByName(UIID.SkillTIpsUI)
          if not SkillTIpsUI or not SkillTIpsUI.visible then
            UIManager.Show(UIID.SkillTIpsUI, {
              ItemInfo = {UseSkill},
              bagchange = true
            })
          elseif UseSkill.params[1] == "1" then
            SkillTIpsUI:InsertData(UseSkill)
          else
            SkillTIpsUI:AddData(UseSkill)
          end
          this.CloseItemData(TipShowSort.use)
        end
      end
    end
  end
end

function TipData.GuidEquip(msg, TrueTbl)
  if msg.logType == BagChangeTypeEnum.Recycle then
    return
  end
  if table.count(TrueTbl) ~= 0 and msg.logType ~= BagChangeTypeEnum.Takeoff then
    for i, v in pairs(TrueTbl) do
      if v.itemId ~= 1000250 then
        for k = 1, v.count do
          local Itemsinfo = BagInfoData.GetTotalBag()
          local Items = Itemsinfo[v.bagGridIndex + 1] or nil
          this.WearEquip(Items, msg)
        end
      end
    end
  end
end

function TipData.RecommendCount()
  local roledata = string.format("%s-%d", this.AUCTIONSELFEQUIP, RoleManager.me.id)
  local CountAndTime = PlayerPrefs.GetString(roledata)
  local Group = string.split(CountAndTime, "#")
  if Group[1] then
    if tonumber(Group[1]) < SelfEquipRecomCount then
      local time = Time.GetServerTime()
      if time - tonumber(Group[2]) > SelfEquipRecomTime then
        return true
      end
    end
  else
    return true
  end
  return false
end

function TipData.RecommendRecord()
  local roledata = string.format("%s-%d", this.AUCTIONSELFEQUIP, RoleManager.me.id)
  local CountAndTime = PlayerPrefs.GetString(roledata)
  local count
  local Group = string.split(CountAndTime, "#")
  if not Group[1] then
    count = 1
  else
    count = tonumber(Group[1]) + 1
  end
  local time = Time.GetServerTime()
  local text = string.format("%d#%s", count, time)
  PlayerPrefs.SetString(roledata, text)
end

function TipData.AuctionRecomBuyFuc()
  TipData.AuctionTip()
  if not this.AuctionOpen and LoginData.openServerDay <= GlobalConfig.AutoRackopenServerDay then
    NetManager.Send(TradeMessage.ReqLsTrade, {
      type = AuctionData.toServerValue.PutOn
    })
  end
end

local function GetBuyCountAuction()
  local cDateCurrectTime = math.floor(Time.GetServerTime() / 1000)
  local year = tonumber(os.date("%Y", cDateCurrectTime))
  local month = tonumber(os.date("%m", cDateCurrectTime))
  local day = tonumber(os.date("%d", cDateCurrectTime))
  local cDateTodayTime = os.time({
    year = year,
    month = month,
    day = day,
    hour = 0,
    min = 0,
    sec = 0
  })
  local roledata = string.format("%s-%d", this.AUCTIONRECOMBUY, RoleManager.me.id)
  local TimeAndCount = PlayerPrefs.GetString(roledata)
  local Group = string.split(TimeAndCount, "#")
  if tonumber(Group[1]) == cDateTodayTime then
    if tonumber(Group[2]) >= this.PushTotalCount then
      return false
    end
  else
    PlayerPrefs.DeleteKey(roledata)
    local roleSHENGJI = string.format("%s-%d", this.AUCTIONSHENGJI, RoleManager.me.id)
    PlayerPrefs.DeleteKey(roleSHENGJI)
    AuctRecomAddTime = {}
  end
  return true
end

function TipData.Recommendeds()
  local cDateCurrectTime = math.floor(Time.GetServerTime() / 1000)
  local year = tonumber(os.date("%Y", cDateCurrectTime))
  local month = tonumber(os.date("%m", cDateCurrectTime))
  local day = tonumber(os.date("%d", cDateCurrectTime))
  local cDateTodayTime = os.time({
    year = year,
    month = month,
    day = day,
    hour = 0,
    min = 0,
    sec = 0
  })
  local roledata = string.format("%s-%d", this.AUCTIONRECOMBUY, RoleManager.me.id)
  local TimeAndCount = PlayerPrefs.GetString(roledata)
  local Group = string.split(TimeAndCount, "#")
  if tonumber(Group[1]) == cDateTodayTime then
    if tonumber(Group[2]) < this.PushTotalCount then
      local count = tonumber(Group[2]) + 1
      local text = string.format("%s#%d", cDateTodayTime, count)
      PlayerPrefs.SetString(roledata, text)
    end
  else
    local text = string.format("%s#%d", cDateTodayTime, 1)
    PlayerPrefs.SetString(roledata, text)
  end
end

function TipData.AuctionRecomBuyInit()
  if not TipData.AuctionTip() then
    return
  end
  local WearEquipTipData = {}
  local index = 1
  local meid = ViewData.meData.id
  for i, v in pairs(AuctionData.AllAuctionData) do
    if v.sellerId ~= meid then
      local itemInfo = AuctionData.GetItemConfigInfo(v.item)
      if itemInfo.tblItem.rightOperate == EItemOperateType.Wear then
        WearEquipTipData[index] = itemInfo
        index = index + 1
      end
    end
  end
  AuctionData.WearEquipTipData = WearEquipTipData
end

local function AuctionRecomBuyStore(info, mun)
  local roleid = RoleManager.me.data.id
  local historyrole = true
  local lastmun = -1
  for i, v in pairs(info) do
    if i == roleid then
      historyrole = false
      if v ~= mun then
        lastmun = v
      end
      break
    end
  end
  if historyrole then
    info[roleid] = mun
  end
  return historyrole, roleid, lastmun
end

local function Judgmentlevel()
  local roledata = string.format("%s-%d", this.AUCTIONSHENGJI, RoleManager.me.id)
  local lvTimeAndCount = PlayerPrefs.GetString(roledata)
  local Group = string.split(lvTimeAndCount, "#")
  if tonumber(Group[2]) == RoleManager.me.level then
    local count = tonumber(Group[3])
    if count < LvMaxCount then
      return true, roledata, Group
    end
  else
    return true, roledata, Group
  end
  return false
end

function TipData.AuctionRecomBuyAdd(data)
  if data.items[1] and data.items[1].sellerId == ViewData.meData.id then
    return
  end
  if not this.AuctionOpen then
    return
  end
  for i, v in pairs(data.items) do
    local itemInfo = AuctionData.GetItemConfigInfo(v.item)
    if itemInfo.tblItem.rightOperate == EItemOperateType.Wear then
      table.insert(AuctionData.WearEquipTipData, itemInfo)
    end
  end
  if not GetBuyCountAuction() then
    return
  end
  local sertime = Time.GetServerTime()
  local role, roleid, lastmun = AuctionRecomBuyStore(AuctRecomAddTime, sertime)
  if role then
    local isok, id, Groups = Judgmentlevel()
    if isok then
      this.AuctionRecomBuyFun(TipAuctionOpen.AddRefresh, {id = id, Group = Groups})
    end
  elseif sertime - lastmun > AuctRecomdiffer then
    local isok, id, Groups = Judgmentlevel()
    if isok then
      AuctRecomAddTime[roleid] = sertime
      this.AuctionRecomBuyFun(TipAuctionOpen.AddRefresh, {id = id, Group = Groups})
    end
  end
end

function TipData.AuctionRecomBuyDataDel(data)
  if data ~= nil then
    if data.items[1] and data.items[1].sellerId == ViewData.meData.id then
      return
    end
    if not this.AuctionOpen then
      return
    end
    local dataDel = data.items
    for i, v in pairs(dataDel) do
      local itemInfo = AuctionData.GetItemConfigInfo(v.item)
      if itemInfo.tblItem.rightOperate ~= EItemOperateType.Wear then
        return
      end
    end
    local dataAll = AuctionData.WearEquipTipData
    local index = 0
    if 0 < #dataDel and 0 < #dataAll then
      for i = 1, #dataDel do
        for j = 1, #dataAll do
          j = j + index
          if dataDel[i].item.id == dataAll[j].id then
            index = index - 1
            table.remove(AuctionData.WearEquipTipData, j)
          end
        end
      end
    end
  end
end

function TipData.AuctionRecomBuyUpLv(level)
  if not this.AuctionOpen then
    return
  end
  if not GetBuyCountAuction() then
    return
  end
  local roledata = string.format("%s-%d", this.AUCTIONSHENGJI, RoleManager.me.id)
  local lvTimeAndCount = PlayerPrefs.GetString(roledata)
  local Group = string.split(lvTimeAndCount, "#")
  local level = RoleManager.me.level
  local cDateCurrectTime = Time.GetServerTime()
  if tonumber(Group[1]) then
    if cDateCurrectTime - tonumber(Group[1]) >= LVRefreshTime then
      if tonumber(Group[2]) == level then
        local count = tonumber(Group[2])
        if count < LvMaxCount then
          this.AuctionRecomBuyFun(TipAuctionOpen.Upgrade, {mun = count, id = roledata})
        end
      else
        this.AuctionRecomBuyFun(TipAuctionOpen.Upgrade, {mun = 0, id = roledata})
      end
    end
  else
    this.AuctionRecomBuyFun(TipAuctionOpen.Upgrade, {mun = 0, id = roledata})
  end
end

function TipData.AucRecomBuyProint()
end

function TipData.GradeRecord(type, data)
  if type == TipAuctionOpen.Upgrade then
    local Time = Time.GetServerTime()
    local shu = data.mun + 1
    local lv = RoleManager.me.level
    local text = string.format("%s#%d#%s", Time, lv, shu)
    PlayerPrefs.SetString(data.id, text)
  elseif type == TipAuctionOpen.AddRefresh then
    local lv = RoleManager.me.level
    if data.Group == nil then
      local text = string.format("%s#%d#%s", 0, lv, 1)
      PlayerPrefs.SetString(data.id, text)
    else
      local time = tonumber(data.Group[1])
      if tonumber(data.Group[2]) == lv then
        local count = tonumber(data.Group[3]) + 1
        local text = string.format("%s#%d#%s", time, lv, count)
        PlayerPrefs.SetString(data.id, text)
      else
        local text = string.format("%s#%d#%s", time, lv, 1)
        PlayerPrefs.SetString(data.id, text)
      end
    end
  end
end

function TipData.AuctionRecomBuyFun(type, data)
  local WearData = AuctionData.WearEquipTipData
  local count = #WearData
  local RecomBuyItem
  local Random = 0
  if count ~= 0 then
    for i = 1, count do
      if RoleEquipUtility.CanUpFight(WearData[i]) == EquipUpState.CanWearUpFight then
        local type = WearData[i].tblItem.type
        if AuctTypelimit[type] then
          for k, w in pairs(AuctTypelimit[type]) do
            if WearData[i].tblItem.subType == w then
              RecomBuyItem = WearData[i]
              Random = Random + 1
              if RandomNumber == Random then
                break
              end
            end
          end
        end
      end
    end
  end
  if Random == RandomNumber then
    RandomNumber = RandomNumber + 1
  else
    RandomNumber = 1
  end
  if RecomBuyItem then
    local AuctionRecommendTIpsUI = UIManager.GetUiByName(UIID.AuctionRecommendTIpsUI)
    if not AuctionRecommendTIpsUI or not AuctionRecommendTIpsUI.visible then
      local data = {
        type = type,
        data = data,
        RecomBuyItem = RecomBuyItem
      }
      EventManager.Dispatch(Event.AuctionTipsUI, data)
    end
  end
end

function TipData.OnCloseUI()
  for i, v in pairs(this.ShowSortUIName) do
    if UIManager.IsVisible(v) then
      UIManager.Hide(v)
    end
  end
end

function TipData.OnLeaveGame()
  TipData.OnCloseUI()
  this.AuctionOpen = false
  TipData.CloseData()
end
