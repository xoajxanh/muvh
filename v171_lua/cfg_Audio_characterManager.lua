local cfg_Audio_characterManager = {}

function cfg_Audio_characterManager:GetName()
  return "cfg_Audio_characterManager"
end

function cfg_Audio_characterManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Audio_character")
  end
  return self.dic
end

setmetatable(cfg_Audio_characterManager, TableManagerBase)

function cfg_Audio_characterManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Audio_characterManager
