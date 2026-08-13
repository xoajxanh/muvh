local cfg_Audio_audioManager = {}

function cfg_Audio_audioManager:GetName()
  return "cfg_Audio_audioManager"
end

function cfg_Audio_audioManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Audio_audio")
  end
  return self.dic
end

setmetatable(cfg_Audio_audioManager, TableManagerBase)

function cfg_Audio_audioManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Audio_audioManager
