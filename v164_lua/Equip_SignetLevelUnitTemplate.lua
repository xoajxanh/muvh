local Equip_SignetLevelUnitTemplate = {}

function Equip_SignetLevelUnitTemplate:Init(data)
  self.clickGoCallBack = data.clickCallBack
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function Equip_SignetLevelUnitTemplate:InitParams()
  self.parentTbl = nil
  self.iconStr = {
    [true] = "signet_1_1",
    [false] = "signet_1_0"
  }
end

function Equip_SignetLevelUnitTemplate:InitControls()
  self.img_icon = self:GetControl("img_icon")
  self.lab_level = self:GetControl("lab_level")
  self.img_lvArrow = self:GetControl("img_lvArrow")
end

function Equip_SignetLevelUnitTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.ClickGoCallBack)
end

function Equip_SignetLevelUnitTemplate:ClickGoCallBack()
  if self.clickGoCallBack ~= nil then
    self.clickGoCallBack(self.parentTbl, self.levelData)
  end
end

function Equip_SignetLevelUnitTemplate:Refresh(data, ui)
  self.levelData = data
  self.sealType = ui and ui.signetType or nil
  self.parentTbl = ui
  self:RefreshView()
end

function Equip_SignetLevelUnitTemplate:RefreshView()
  if self.levelData == nil or self.sealType == nil or self.parentTbl == nil then
    return
  end
  local maxId = ClientTable.cfg_Seal_SealManager:TryGetMaxIdByType(self.sealType)
  local curInfo = self.parentTbl.curSealInfo
  self.lab_level:SetText(self.levelData.level .. "Lv")
  self.img_lvArrow:SetActive(self.levelData.id ~= maxId)
  self.parentTbl:SetSprite("Atlas_Common", self.iconStr[curInfo ~= nil and curInfo.level >= self.levelData.level], self.img_icon)
end

return Equip_SignetLevelUnitTemplate
