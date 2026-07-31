require("GameConst/UIWordEnum")
local cfg_Ui_word_attributeManager = {}

function cfg_Ui_word_attributeManager:GetName()
  return "cfg_Ui_word_attributeManager"
end

function cfg_Ui_word_attributeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Ui_word_attribute")
  end
  return self.dic
end

setmetatable(cfg_Ui_word_attributeManager, TableManagerBase)

function cfg_Ui_word_attributeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Ui_word_attributeManager:GetKeyWord(attrKey, wordType)
  local wordTbl = self:TryGetValue(attrKey)
  if wordTbl == nil then
    logError(attrKey .. "Ui_word_attribute tr\225\187\145ng")
    return
  end
  local wordTypeStr = wordTbl[wordType]
  if wordTypeStr then
    return wordTypeStr
  end
end

function cfg_Ui_word_attributeManager:GetDes(id, type)
  local wordTbl = self:TryGetValue(id)
  if wordTbl == nil then
    return
  end
  if type == UI_Word_AttributeType.equipeTipsUI then
    return wordTbl.equipeTipsUI
  end
end

return cfg_Ui_word_attributeManager
