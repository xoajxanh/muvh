local CrystalNucleusPedestalItemPointTemplate = {}

function CrystalNucleusPedestalItemPointTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function CrystalNucleusPedestalItemPointTemplate:InitControls()
  self.img_ItemBg = self:GetControl("img_Itembg")
  self.img_Lock = self:GetControl("img_Lock")
  self.ima_Icon = self:GetControl("img_Icon")
end

function CrystalNucleusPedestalItemPointTemplate:BindUIEvent()
  self.ima_Icon:SetOnClick(self, self.ima_IconOnClick)
end

function CrystalNucleusPedestalItemPointTemplate:ima_IconOnClick()
  CrystalNucleusPointController.ReqTakeOffNucleus(self.data.m_ServerInfo.id)
end

function CrystalNucleusPedestalItemPointTemplate:Refresh(_data, _ui)
  if _data == nil or _ui == nil then
    return
  end
  self:Reset()
  self.data = _data
  self.rootUI = _ui
  self:RefreshUnlockState()
  self:RefreshIcon()
end

function CrystalNucleusPedestalItemPointTemplate:RefreshUnlockState()
  self.img_Lock:SetActive(not self.data.m_Unlock)
end

function CrystalNucleusPedestalItemPointTemplate:RefreshIcon()
  if not self.data.m_Occupy then
    return
  end
  local equipConfig = ClientTable.cfg_Item_equipManager:TryGetValue(self.data.m_ItemConfig.id)
  if equipConfig == nil then
    return
  end
  self.rootUI:SetSprite("Atlas_Common", equipConfig.gridIcon, self.ima_Icon, true)
end

function CrystalNucleusPedestalItemPointTemplate:Reset()
  self:ResetHitResult()
  self.ima_Icon:SetActive(false)
  self.img_Lock:SetActive(false)
end

function CrystalNucleusPedestalItemPointTemplate:RefreshHitResult()
  local putOn = self.data:CheckPutInCondition()
  local color = putOn and EUIColor.Green or EUIColor.Red
  self.img_ItemBg:SetColor(color)
end

function CrystalNucleusPedestalItemPointTemplate:ResetHitResult()
  self.img_ItemBg:SetColor(EUIColor.White)
end

return CrystalNucleusPedestalItemPointTemplate
