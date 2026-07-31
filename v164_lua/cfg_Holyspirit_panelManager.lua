local cfg_Holyspirit_panelManager = {}

function cfg_Holyspirit_panelManager:GetName()
  return "cfg_Holyspirit_panelManager"
end

function cfg_Holyspirit_panelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Holyspirit_panel")
  end
  return self.dic
end

setmetatable(cfg_Holyspirit_panelManager, TableManagerBase)

function cfg_Holyspirit_panelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Holyspirit_panelManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Holyspirit_panelManager:GetPositionById(id)
  if id == nil or id == 0 then
    return Vector3(0, 0, 0)
  end
  if self.positionTab == nil then
    self.positionTab = {}
  end
  if self.positionTab[id] == nil then
    self.positionTab[id] = {}
    if self:TryGetValue(id).position then
      local posTab = string.split(self:TryGetValue(id).position, "_")
      self.positionTab[id] = Vector3(tonumber(posTab[1]), tonumber(posTab[2]), 0)
    end
  end
  return self.positionTab[id]
end

function cfg_Holyspirit_panelManager:GetTypeById(id)
  if id == nil then
    return
  end
  if self.typeTab == nil then
    self.typeTab = {}
  end
  if self.typeTab[id] == nil then
    self.typeTab[id] = {}
    if self:TryGetValue(id).type then
      self.typeTab[id] = self:TryGetValue(id).type
    end
  end
  return self.typeTab[id]
end

function cfg_Holyspirit_panelManager:GetSubTypeById(id)
  if id == nil then
    return
  end
  if self.subTypeTab == nil then
    self.subTypeTab = {}
  end
  if self.subTypeTab[id] == nil and self:TryGetValue(id).subType then
    self.subTypeTab[id] = self:TryGetValue(id).subType
  end
  return self.subTypeTab[id]
end

return cfg_Holyspirit_panelManager
