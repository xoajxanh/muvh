local RegenerateNewEntrysTemplate = {}

function RegenerateNewEntrysTemplate:Init()
  self:InitControls()
end

function RegenerateNewEntrysTemplate:InitControls()
  self.lab_atk = self:GetControl("lab_atk")
  self.effect = self:GetControl("Eff_UI_duanzhaoshuaxin")
  self.imgNewItem = self:GetControl("imgNewItem")
end

function RegenerateNewEntrysTemplate:Refresh(data, ui)
  if data then
    self.attributeInfo = data
    self.parentTbl = ui
    self.color = ClientTable.cfg_Item_class_settingManager:TryGetValue(data.excellentLevel, "id").excellentLevelColor
    self:RefreshView()
  else
    self:UIControl():SetActive(false)
  end
end

function RegenerateNewEntrysTemplate:RefreshView()
  if self.attributeInfo == nil then
    return
  end
  self.imgNewItem:SetActive(false)
  self.effect:SetActive(false)
  self.effect:SetActive(true)
  self.lab_atk:SetText(string.format("<color=%s>%s</color>", self.color, self.attributeInfo.attributeInfo or "Tr\225\187\145ng"))
  if gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetLockConfigId() and self.attributeInfo.configId == gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetLockConfigId() and self.attributeInfo.lockItem then
    self.imgNewItem:SetActive(true)
  end
end

return RegenerateNewEntrysTemplate
