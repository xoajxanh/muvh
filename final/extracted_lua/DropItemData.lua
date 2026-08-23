DropItemData = class()

function DropItemData:Init(data)
  self.id = data.item.id
  self.item = data.item
  self.fromInfo = data.item.fromInfo
  self.serverCoord = Vector2Int(data.x, data.y)
  self.x = data.x
  self.y = data.y
  self.fromX = data.fromX
  self.fromY = data.fromY
  self.configID = data.item.itemId
  self.itemId = data.item.itemId
  self.owner = data.owner
  self.dropTime = data.dropTime
  self.totalTime = data.totalTime
  self.ownerProtectedTime = data.ownerProtectedTime
  self.wholeOwner = data.wholeOwner
  self:InitConfig()
end

function DropItemData:InitConfig()
  local item = ClientTable.cfg_Item_itemManager:TryGetValue(self.configID)
  local equip
  if item.type == EItemType.Equipe then
    equip = ClientTable.cfg_Item_equipManager:TryGetValue(self.configID)
  end
  self.name = item.name
  self.dropAudio = item.dropAudio
  self.showColor = item.colorShow
  if item.id == 1000010 or item.id == 1000030 then
    self.type = item.subType
  elseif item.id == 1000020 or item.id == 1000021 then
    self.type = EResourcesType.QiJiBi
  elseif item.subType == 302 then
    self.type = EItemType.SkillBook
  else
    self.type = item.type
  end
  self.config_Item = item
  local equipSuffix = ""
  local equipTab = ClientTable.cfg_Item_equipManager:TryGetValue(self.configID)
  if equipTab and equipTab.uiEquip == 1 then
    equipSuffix = "_ui"
  end
  self.model = item.model
  self.itemPut = item.itemPut
  self.quality = item.quality
  self.auctionSubtype = item.auctionSubtype
  self.scale = item.size and item.size / 100 or 1
  if equip then
    if item.subType == EItemSubtype.Guards then
      self.route = item.model
    else
      self.route = equip.route .. "/" .. item.model .. equipSuffix
    end
    self:InitSuitData(equip)
  else
    self.route = item.model
  end
  if item.type == EItemType.Equipe then
    self:InitItemLevel()
  else
    self.item.rarity = item.rarity
  end
  self.itemData = ItemUtility.GenerateItemDataByServerData(self.item)
  self:InitItemHeadName()
  self:InitDropItemType()
end

function DropItemData:InitDropItemType()
  local function GetGoldModel()
    local count = self.item.count
    
    local index = 1
    if 1 <= count and count <= 1000 then
      index = 1
    elseif 1001 <= count and count <= 10000 then
      index = 2
    else
      index = 3
    end
    local goldModel = DropItemUtility.GetGoldModelChoice(index)
    return goldModel
  end
  
  local item = ClientTable.cfg_Item_itemManager:TryGetValue(self.configID)
  if self.item.itemId == 1000010 then
    local goldModel = GetGoldModel()
    self.route = goldModel
    self.modelType = EModelType.Gold
  elseif item.type == EItemType.Resources then
    self.modelType = EModelType.Gold
  elseif item.type == EItemType.Equipe then
    if item.subType == EItemSubtype.Guards then
      self.modelType = EModelType.Pet
    else
      self.modelType = EModelType.EquipItem
    end
  elseif item.type == EItemType.Transcript then
    self.modelType = EModelType.InstanceItem
  else
    self.modelType = EModelType.Item
  end
end

function DropItemData:InitSuitData(equip)
  local suitId = equip.suitId
  if not suitId or suitId == "" then
    return
  end
  local suitIdTable = string.split(suitId, "#")
  local suit = ConfigManager.FindConfigs("cfg_Item_equip_suit", "suitId", tonumber(suitIdTable[1]))
  self.item.suit = suit
end

local function IsTable(t)
  if not t or type(t) ~= "table" then
    return false
  end
  if table.count(t) > 0 then
    for i, v in ipairs(t) do
      if 0 < v then
        return true
      end
    end
  end
  return false
end

local function IsString(t)
  if not t or type(t) ~= "string" or t == "" then
    return false
  end
  return true
end

local function IsHave(t1, t2)
  if t2 then
    return not (IsTable(t1) or IsString(t1)) or IsTable(t2) or IsString(t2)
  end
  return IsTable(t1) or IsString(t1)
end

function DropItemData:InitItemLevel()
  local function GetMaxLevel(a, b)
    if b <= a then
      return a
    else
      return b
    end
  end
  
  local IsExcellent = self.item.excellentInfo ~= nil and next(self.item.excellentInfo) ~= nil
  local maxLevel = DropItemUtility.GetDropItemQToRTable(self.quality)
  local IsJewelryTable = DropItemUtility.IsDropItemIsJewelryTable(self.auctionSubtype)
  maxLevel = self.item.intensify and Mathf.Clamp(self.item.intensify, 0, 7) or maxLevel
  maxLevel = GetMaxLevel(maxLevel, IsHave(self.item.additionalAttribute) and 5 or 0)
  maxLevel = GetMaxLevel(maxLevel, 0 < table.count(self.item.lucky) and 5 or 0)
  maxLevel = GetMaxLevel(maxLevel, IsExcellent and 8 or 0)
  maxLevel = GetMaxLevel(maxLevel, self.item.suit and 12 or 0)
  if IsJewelryTable then
    maxLevel = 11
  end
  self.item.maxLevel = maxLevel
  self.item.rarity = DropItemUtility.GetDropItemRarity(maxLevel)
end

function DropItemData:InitItemHeadName()
  local headItemName = {}
  local itemName = self.name
  if self.item.itemId == 1000010 then
    itemName = self.item.count .. " " .. itemName
    self.item.headItemName = itemName
    return
  end
  headItemName[#headItemName + 1] = self.name
  if self.item.intensify > 0 then
    headItemName[#headItemName + 1] = " +" .. self.item.intensify
  end
  if self.item.additionalAttribute then
    for i, v in pairs(self.item.additionalAttribute) do
      if v and 0 < v then
        headItemName[#headItemName + 1] = " + Thu\225\187\153c t\195\173nh"
        break
      end
    end
  end
  if 0 < table.count(self.item.lucky) then
    headItemName[#headItemName + 1] = " + May m\225\186\175n"
  end
  itemName = table.concat(headItemName)
  self.item.headItemName = itemName
end
