local cfg_AttributeFormulaManager = {}

function cfg_AttributeFormulaManager:GetName()
  return "cfg_AttributeFormulaManager"
end

function cfg_AttributeFormulaManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_AttributeFormula")
  end
  return self.dic
end

setmetatable(cfg_AttributeFormulaManager, TableManagerBase)

function cfg_AttributeFormulaManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_AttributeFormulaManager
