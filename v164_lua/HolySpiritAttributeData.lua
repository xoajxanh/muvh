HolySpiritAttributeData = {}
local this = HolySpiritAttributeData
this.CurTypeHolySpiritData = {}
this.EveryTypeAttributeData = {}

function HolySpiritAttributeData.GetCurEveryTypeAttributeData(type)
  if this.EveryTypeAttributeData[type] == nil then
    logError("T\225\187\149ng thu\225\187\153c t\195\173nh tr\225\187\145ng")
    return nil
  end
  return this.EveryTypeAttributeData[type]
end

function HolySpiritAttributeData.GetAttributeDataById(type, id)
  if this.GetHolySpiritAttributeTab(type, id) == nil then
    return nil
  end
  return this.GetHolySpiritAttributeTab(type, id).allAttributeTab
end

function HolySpiritAttributeData.Init()
  this.InitData()
  this.InitHolySpiritData()
  this.SetOneTypeAllAttribute()
end

function HolySpiritAttributeData.InitData()
  this.EveryTypeAttributeData = {}
end

function HolySpiritAttributeData.InitHolySpiritData()
  for i, v in pairs(ClientTable.cfg_Holyspirit_panelManager:GetDic()) do
    if this.CurTypeHolySpiritData[v.type] == nil then
      this.CurTypeHolySpiritData[v.type] = {}
    end
    local allAttributeTab = this.GetInitAttributeDataById(v.id)
    if this.CurTypeHolySpiritData[v.type][v.id] == nil then
      this.CurTypeHolySpiritData[v.type][v.id] = {}
    end
    this.CurTypeHolySpiritData[v.type][v.id] = allAttributeTab
  end
end

function HolySpiritAttributeData.GetInitAttributeDataById(id)
  if id == nil or id == 0 then
    return
  end
  local itemTab = ClientTable.cfg_Holyspirit_panelManager:TryGetValue(id).attribute
  local allAttributeTab = {}
  local itemAllAttributeTab = {}
  if itemTab then
    local attributeStr = string.split(itemTab, "#")
    for i = 1, #attributeStr do
      local itemAttribute = ClientTable.cfg_Holyspirit_attributeManager:TryGetValue(tonumber(attributeStr[i]), "id")
      for attributeItemName, attributeItemData in pairs(itemAttribute) do
        if attributeItemData ~= 0 and attributeItemData ~= "" and attributeItemName ~= "id" then
          local attributeValue = this.GetCareerAttributeValue(attributeItemData)
          table.insert(itemAllAttributeTab, {
            attributeName = attributeItemName,
            value = attributeValue,
            sort = i,
            showData = 0,
            serverInfo = {
              id = id,
              level = 0,
              active = false
            }
          })
          break
        end
      end
    end
  end
  allAttributeTab.allAttributeTab = itemAllAttributeTab
  return allAttributeTab
end

function HolySpiritAttributeData.GetCareerAttributeValue(allCareerAttribute)
  if type(allCareerAttribute) == "table" and table.count(allCareerAttribute) > 0 then
    local basicCareer = RoleUtility.GetBasicCareer(ViewData.meData.career)
    if basicCareer then
      for index, itemAttribute in pairs(allCareerAttribute) do
        if itemAttribute[1] == basicCareer then
          return itemAttribute[2]
        end
      end
    end
  else
    return allCareerAttribute
  end
end

function HolySpiritAttributeData.UpdateHolySpiritAttributeData(tblData)
  if table.count(tblData) == 0 then
    return
  end
  for index, pageDataTab in pairs(tblData) do
    for index, itemHolySpirits in pairs(pageDataTab.HolySpirits) do
      local nowStage, totalStage = HolySpiritPointData.GetPointStageById(itemHolySpirits.id)
      for i = 1, nowStage do
        if this.GetHolySpiritAttributeTab(pageDataTab.type, itemHolySpirits.id).allAttributeTab[i] then
          this.GetHolySpiritAttributeTab(pageDataTab.type, itemHolySpirits.id).allAttributeTab[i].showData = this.GetHolySpiritAttributeTab(pageDataTab.type, itemHolySpirits.id).allAttributeTab[i].value
          this.GetHolySpiritAttributeTab(pageDataTab.type, itemHolySpirits.id).allAttributeTab[i].serverInfo = itemHolySpirits
        end
      end
    end
  end
end

function HolySpiritAttributeData.SetOneTypeAllAttribute()
  for type, oneTypeAttribute in pairs(this.CurTypeHolySpiritData) do
    local oneTypeAttributeTab = {}
    for id, itemAttribute in pairs(oneTypeAttribute) do
      for i, basItemAttribute in pairs(itemAttribute.allAttributeTab) do
        if oneTypeAttributeTab[basItemAttribute.attributeName] == nil then
          oneTypeAttributeTab[basItemAttribute.attributeName] = {
            attributeName = basItemAttribute.attributeName,
            value = basItemAttribute.showData
          }
        else
          oneTypeAttributeTab[basItemAttribute.attributeName].value = oneTypeAttributeTab[basItemAttribute.attributeName].value + basItemAttribute.showData
        end
      end
    end
    this.EveryTypeAttributeData[type] = oneTypeAttributeTab
  end
end

function HolySpiritAttributeData.GetHolySpiritAttributeTab(type, id)
  if this.CurTypeHolySpiritData[type] == nil then
    return nil
  end
  if this.CurTypeHolySpiritData[type][id] == nil then
    return nil
  end
  return this.CurTypeHolySpiritData[type][id]
end
