HolySpiritPointData = {}
local this = HolySpiritPointData
this.CurTypeHolySpiritData = {}
this.equipTab = {
  [1] = {
    [1] = 201,
    [2] = 211
  },
  [2] = {
    [1] = 202,
    [2] = 212
  },
  [3] = {
    [1] = 203,
    [2] = 213
  },
  [4] = {
    [1] = 204,
    [2] = 214
  },
  [5] = {
    [1] = 205,
    [2] = 215
  },
  [6] = {
    [1] = 206,
    [2] = 216
  },
  [7] = {
    [1] = 207,
    [2] = 217
  },
  [8] = {
    [1] = 208,
    [2] = 218
  }
}
this.unLockPointArray = {}
this.pageNameArray = {}

function HolySpiritPointData.GetCurTypeHolySpiritData(type)
  if this.CurTypeHolySpiritData[type] == nil then
    logError("D\225\187\175 li\225\187\135u \196\145i\225\187\131m Th\195\161nh H\225\187\147n lo\225\186\161i t\198\176\198\161ng \225\187\169ng tr\225\187\145ng")
    return nil
  end
  return this.CurTypeHolySpiritData[type]
end

function HolySpiritPointData.GetLastPointState(id)
  local tab = ClientTable.cfg_Holyspirit_panelManager:TryGetValue(id)
  if tab.previous == 0 then
    return true
  end
  if this.GetHolySpiritPointTab(tab.type, tab.previous) == nil then
    return false
  end
  return this.GetHolySpiritPointTab(tab.type, tab.previous).serverInfo.active
end

function HolySpiritPointData.GetNowPointStateById(id)
  local tab = ClientTable.cfg_Holyspirit_panelManager:TryGetValue(id)
  if this.GetHolySpiritPointTab(tab.type, id) == nil then
    return false
  end
  return this.GetHolySpiritPointTab(tab.type, id).serverInfo.active
end

function HolySpiritPointData.GetNowTypeIsActive(type)
  for i, oneTypeItemTab in pairs(this.CurTypeHolySpiritData[type]) do
    if oneTypeItemTab.serverInfo.active == false then
      return false
    end
  end
  return true
end

function HolySpiritPointData.GetPointExpendById(id)
  local tab = ClientTable.cfg_Holyspirit_panelManager:TryGetValue(id)
  if this.GetHolySpiritPointTab(tab.type, id) ~= nil then
    local expendTab = {}
    local expendStr = ""
    if this.GetHolySpiritPointTab(tab.type, id).serverInfo.level < this.GetHolySpiritPointTab(tab.type, id).CfgInfo.numUpgrades - 1 then
      expendStr = this.GetHolySpiritPointTab(tab.type, id).CfgInfo.upgradeCons
    else
      expendStr = this.GetHolySpiritPointTab(tab.type, id).CfgInfo.activationCons
    end
    expendTab = TableParse:SpliteStringToItemCountList(expendStr)
    return expendTab
  end
end

function HolySpiritPointData.GetNowTypeActivePointCount(type)
  local count = 0
  for i, oneTypeItemTab in pairs(this.CurTypeHolySpiritData[type]) do
    if oneTypeItemTab.serverInfo.active == true then
      count = count + 1
    end
  end
  return count
end

function HolySpiritPointData.GetPointStageById(id)
  local tab = ClientTable.cfg_Holyspirit_panelManager:TryGetValue(id)
  if this.GetHolySpiritPointTab(tab.type, id) ~= nil then
    return this.GetHolySpiritPointTab(tab.type, id).serverInfo.level, this.GetHolySpiritPointTab(tab.type, id).CfgInfo.numUpgrades
  end
end

function HolySpiritPointData.CheckAllTypeIsActive()
  for type, v in pairs(this.CurTypeHolySpiritData) do
    if this.GetNowTypeIsActive(type) == false then
      return false
    end
  end
  return true
end

function HolySpiritPointData.GetHolySpiritTotalPage()
  return table.count(this.CurTypeHolySpiritData)
end

function HolySpiritPointData.GetHolySpiritUpgradeCount(type)
  local upgradeCount = 0
  for id, itemHolySpiritData in pairs(this.CurTypeHolySpiritData[type]) do
    upgradeCount = upgradeCount + itemHolySpiritData.serverInfo.level
  end
  return upgradeCount
end

function HolySpiritPointData.Init()
  this.InitHolySpiritPointData()
  this.InitHolySpiritGlobalData()
end

function HolySpiritPointData.InitHolySpiritPointData()
  for i, v in pairs(ClientTable.cfg_Holyspirit_panelManager:GetDic()) do
    if this.CurTypeHolySpiritData[v.type] == nil then
      this.CurTypeHolySpiritData[v.type] = {}
    end
    local itemSpiritData = {
      CfgInfo = v,
      serverInfo = {
        type = v.type,
        id = v.id,
        level = 0,
        active = false
      }
    }
    if this.CurTypeHolySpiritData[v.type][v.id] == nil then
      this.CurTypeHolySpiritData[v.type][v.id] = {}
    end
    this.CurTypeHolySpiritData[v.type][v.id] = itemSpiritData
  end
end

function HolySpiritPointData.InitHolySpiritGlobalData()
  local globalStr = ClientTable.cfg_Global_globalManager:TryGetValue(4100001).effect
  if not string.isNullOrEmpty(globalStr) then
    local suitPointTab = string.split(globalStr, "&")
    for suitType, value in pairs(suitPointTab) do
      this.unLockPointArray[suitType] = string.split(value, "#")
    end
  end
  local globalStr = ClientTable.cfg_Global_globalManager:TryGetValue(4100002).effect
  if not string.isNullOrEmpty(globalStr) then
    local suitNameTab = string.split(globalStr, "&")
    for suitType, value in pairs(suitNameTab) do
      this.pageNameArray[suitType] = string.split(value, "#")
    end
  end
end

function HolySpiritPointData.UpdateHolySpiritPointData(tblData)
  if table.count(tblData) == 0 then
    return
  end
  for index, pageDataTab in pairs(tblData) do
    for index, itemHolySpirits in pairs(pageDataTab.HolySpirits) do
      if this.GetHolySpiritPointTab(pageDataTab.type, itemHolySpirits.id) ~= nil then
        this.GetHolySpiritPointTab(pageDataTab.type, itemHolySpirits.id).serverInfo = itemHolySpirits
      end
    end
  end
end

function HolySpiritPointData.GetHolySpiritPointTab(type, id)
  if this.CurTypeHolySpiritData[type] == nil then
    return nil
  end
  if this.CurTypeHolySpiritData[type][id] == nil then
    return nil
  end
  return this.CurTypeHolySpiritData[type][id]
end
