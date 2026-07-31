local RegenerateEntrysTemplate = {}

function RegenerateEntrysTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function RegenerateEntrysTemplate:InitControls()
  self.lab_atk = self:GetControl("lab_atk")
  self.btnUnlock = self:GetControl("btnUnlock")
  self.effect = self:GetControl("Eff_UI_duanzhaoshuaxin")
end

function RegenerateEntrysTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.btnLockOrUnlockOnClick)
end

function RegenerateEntrysTemplate:btnLockOrUnlockOnClick()
  if gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetRegenerateLockState() and not self.isLock then
    FloatingTipUtility.QuickMsg("\196\144\195\163 kh\195\179a qu\195\161 nhi\225\187\129u, h\195\163y m\225\187\159 b\225\187\155t")
    return
  end
  self.isLock = not self.isLock
  self.btnUnlock:SetActive(self.isLock)
  gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():SetLockConfigId(self.isLock == true and self.configId or 0)
  gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():SetRegenerateLockStateChange(self.isLock)
  gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():SetLockAttributeIndex(self.nowIndex)
end

function RegenerateEntrysTemplate:Refresh(data, ui)
  if data then
    self.attributeInfo = data.attributeInfo
    self.configId = data.configId
    self.parentTbl = ui
    self.isLock = false
    self.nowIndex = data.nowIndex
    self.color = ClientTable.cfg_Item_class_settingManager:TryGetValue(data.excellentLevel, "id").excellentLevelColor
    self:RefreshView()
  else
    self:UIControl():SetActive(false)
  end
end

function RegenerateEntrysTemplate:RefreshView()
  self.effect:SetActive(false)
  self.effect:SetActive(true)
  self.btnUnlock:SetActive(false)
  self.lab_atk:SetText(string.format("<color=%s>%s</color>", self.color, self.attributeInfo))
end

return RegenerateEntrysTemplate
