local cfg_Map_buffPictureManager = {}

function cfg_Map_buffPictureManager:GetName()
  return "cfg_Map_buffPictureManager"
end

function cfg_Map_buffPictureManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Map_buffPicture")
  end
  return self.dic
end

setmetatable(cfg_Map_buffPictureManager, TableManagerBase)

function cfg_Map_buffPictureManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Map_buffPictureManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Map_buffPictureManager
