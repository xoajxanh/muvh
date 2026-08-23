local cfg_Ui_wordManager = {}

function cfg_Ui_wordManager:GetName()
  return "cfg_Ui_wordManager"
end

function cfg_Ui_wordManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Ui_word")
  end
  return self.dic
end

setmetatable(cfg_Ui_wordManager, TableManagerBase)

function cfg_Ui_wordManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Ui_wordManager:GetUi_wordCount(id)
  local content = ""
  local cfg_Ui_word = self:TryGetValue(id)
  if cfg_Ui_word ~= nil then
    content = cfg_Ui_word.content
  end
  return content
end

function cfg_Ui_wordManager:GetDaShiAutoFightTips()
  if self.mDashiAutoFightTips == nil then
    self.mDashiAutoFightTips = self:GetUi_wordCount("Dashi_1")
  end
  return self.mDashiAutoFightTips
end

function cfg_Ui_wordManager:GetDaShiEnableTips()
  if self.mDashiEnableTips == nil then
    self.mDashiEnableTips = self:GetUi_wordCount("Dashi_2")
  end
  return self.mDashiEnableTips
end

function cfg_Ui_wordManager:GetDaShiNoTimeStr()
  if self.mDaShiNoTimeStr == nil then
    self.mDaShiNoTimeStr = self:GetUi_wordCount("Dashi_3")
  end
  return self.mDaShiNoTimeStr
end

function cfg_Ui_wordManager:GetDaShiCoinNotSatisfiedStr()
  if self.mDaShiCoinNotSatisfiedStr == nil then
    self.mDaShiCoinNotSatisfiedStr = self:GetUi_wordCount("Dashi_4")
  end
  return self.mDaShiCoinNotSatisfiedStr
end

function cfg_Ui_wordManager:GetDaShiMasterExpPillNotSatisfiedStr()
  if self.mDaShiExpPillNotSatisfiedStr == nil then
    self.mDaShiExpPillNotSatisfiedStr = self:GetUi_wordCount("Dashi_7")
  end
  return self.mDaShiExpPillNotSatisfiedStr
end

function cfg_Ui_wordManager:GetDaShiSwitchConsumNotMeetStr()
  if self.mDaShiConsumNotMeetStr == nil then
    self.mDaShiConsumNotMeetStr = self:GetUi_wordCount("Dashi_5")
  end
  return self.mDaShiConsumNotMeetStr
end

function cfg_Ui_wordManager:GetDaShiNotEnableStr()
  if self.mDaShiNotEnableStr == nil then
    self.mDaShiNotEnableStr = self:GetUi_wordCount("Dashi_6")
  end
  return self.mDaShiNotEnableStr
end

function cfg_Ui_wordManager:GetLuckyTurntableLuckyDes()
  if self.mLuckyTurntableLuckyDes == nil then
    self.mLuckyTurntableLuckyDes = self:GetUi_wordCount("Activity_xingyunchoujiang_1")
  end
  return self.mLuckyTurntableLuckyDes
end

function cfg_Ui_wordManager:GetLuckyTurntableLuckyDrawDes()
  if self.mLuckyTurntableLuckyDrawDes == nil then
    self.mLuckyTurntableLuckyDrawDes = self:GetUi_wordCount("Activity_xingyunchoujiang_2")
  end
  return self.mLuckyTurntableLuckyDrawDes
end

function cfg_Ui_wordManager:GetCombineHolyRingNoSelectTip()
  if self.combineHolyRingNoSelectTip == nil then
    local content = self:GetUi_wordCount("shenghuanhechengtishi")
    self.combineHolyRingNoSelectTip = string.isNullOrEmpty(content) and "H\195\163y ch\225\187\141n Th\195\161nh Ho\195\160n tr\198\176\225\187\155c" or content
  end
  return self.combineHolyRingNoSelectTip or "H\195\163y ch\225\187\141n Th\195\161nh Ho\195\160n tr\198\176\225\187\155c"
end

function cfg_Ui_wordManager:GetExpAddBufferInfoTbl()
  if self.mExpAddBufferInfoTbl == nil then
    self.mExpAddBufferInfoTbl = {}
    local effect = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(63000007)
    local str = string.split(effect, "&")
    for i, v in ipairs(str) do
      local addBuffer = string.split(v, "_")
      if 2 <= #addBuffer then
        local addBufferInfo = {
          name = addBuffer[2],
          value = "0"
        }
        table.insert(self.mExpAddBufferInfoTbl, addBufferInfo)
      end
    end
  end
  return self.mExpAddBufferInfoTbl
end

function cfg_Ui_wordManager:GetSeaChestTab()
  local seaChestTabInfo = self:TryGetValue("SeaChestTab_1")
  if seaChestTabInfo then
    return seaChestTabInfo.content
  end
  return nil
end

return cfg_Ui_wordManager
