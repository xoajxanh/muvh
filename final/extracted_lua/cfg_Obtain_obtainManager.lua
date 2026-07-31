local cfg_Obtain_obtainManager = {}

function cfg_Obtain_obtainManager:GetName()
  return "cfg_Obtain_obtainManager"
end

function cfg_Obtain_obtainManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Obtain_obtain")
  end
  return self.dic
end

setmetatable(cfg_Obtain_obtainManager, TableManagerBase)

function cfg_Obtain_obtainManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Obtain_obtainManager:JumpByObtainId(id)
  if id == nil or type(id) ~= "number" then
    return
  end
  local obtainTbl = ClientTable.cfg_Obtain_obtainManager:TryGetValue(id)
  self:JumpByObtainTbl(obtainTbl)
end

function cfg_Obtain_obtainManager:JumpByObtainTbl(obtainTbl)
  if obtainTbl == nil then
    return
  end
  UIManager.JumpShow(UIPanelType.SortAndHide, obtainTbl.name, {
    openFirstTab = obtainTbl.subSubType,
    openSecondTab = obtainTbl.position,
    itemBuyID = obtainTbl.itemBuyID,
    shopID = obtainTbl.shopId
  })
end

return cfg_Obtain_obtainManager
