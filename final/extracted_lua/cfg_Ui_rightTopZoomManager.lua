local cfg_Ui_rightTopZoomManager = {}

function cfg_Ui_rightTopZoomManager:GetName()
  return "cfg_Ui_rightTopZoomManager"
end

function cfg_Ui_rightTopZoomManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Ui_rightTopZoom")
  end
  return self.dic
end

setmetatable(cfg_Ui_rightTopZoomManager, TableManagerBase)

function cfg_Ui_rightTopZoomManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Ui_rightTopZoomManager
