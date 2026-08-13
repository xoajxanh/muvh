local RegenrateNewElouEntryTempateEvo = {}

function RegenrateNewElouEntryTempateEvo:Init()
  self:InitParams()
  self:InitControls()
end

function RegenrateNewElouEntryTempateEvo:InitParams()
end

function RegenrateNewElouEntryTempateEvo:InitControls()
  self.lab_name = self:GetControl("lab_name")
  self.lab_new = self:GetControl("lab_new")
  self.lab_old = self:GetControl("lab_old")
end

function RegenrateNewElouEntryTempateEvo:Refresh(data)
  self.attributeInfo = data
  if self.attributeInfo then
    local regenerate, regenerateLate, regenerateValue, regenerateLateValue
    self.lab_nameRefresh = "T\196\131ng thu\225\187\153c t\195\173nh T\195\161i Sinh"
    local regenerateEquip = gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr().RegenerateEquipCellData.itemData
    local level = ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegenerateLevelList(regenerateEquip.tblItem.subType)
    regenerate = MeEquipController.GetEquipregenerate(regenerateEquip.tblItem.subType, regenerateEquip.serverInfo.regenerateLevel or 0)
    regenerateValue = regenerate.value
    if regenerateEquip.serverInfo.regenerateLevel >= 1 and level > regenerateEquip.serverInfo.regenerateLevel then
      regenerateLate = MeEquipController.GetEquipregenerate(regenerateEquip.tblItem.subType, regenerateEquip.serverInfo.regenerateLevel + 1 or 0)
      regenerateLateValue = regenerateLate.value
      self.lab_oldRefresh = regenerateValue / 100 .. "%"
      self.lab_newRefresh = regenerateLateValue / 100 .. "%"
      self.parentTbl = ui
    elseif regenerateEquip.serverInfo.regenerateLevel == level then
      self.lab_oldRefresh = regenerateValue / 100 .. "%"
      self.lab_newRefresh = "\196\144\195\163 \196\145\225\186\167y c\225\186\165p"
      self.parentTbl = ui
    else
      regenerateLate = MeEquipController.GetEquipregenerate(regenerateEquip.tblItem.subType, regenerateEquip.serverInfo.regenerateLevel + 1 or 0)
      regenerateLateValue = regenerateLate.value
      self.lab_oldRefresh = "0" .. "%"
      self.lab_newRefresh = regenerateLateValue / 100 .. "%"
      self.parentTbl = ui
    end
    self:RefreshView()
  end
end

function RegenrateNewElouEntryTempateEvo:RefreshView()
  if self.attributeInfo == nil then
    return
  end
  self.lab_name:SetText(self.lab_nameRefresh or "")
  self.lab_new:SetText(self.lab_newRefresh or "")
  self.lab_old:SetText(self.lab_oldRefresh or "")
end

return RegenrateNewElouEntryTempateEvo
