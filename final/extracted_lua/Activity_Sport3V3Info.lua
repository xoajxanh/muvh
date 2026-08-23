Activity_Sport3V3Info = class(BaseUI)
Activity_Sport3V3Info.layer = UILayer.Tip
Activity_Sport3V3Info.orderInLayer = 0
Activity_Sport3V3Info.hideType = UIHideType.WaitDestroy
Activity_Sport3V3Info.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_Sport3V3Info.escClose = UIEscClose.DontClose

function Activity_Sport3V3Info:InitControls()
  self.img_infoBg = self:GetControl("img_infoBg")
  self.headImg = self:GetControl("img_infoBg/infoBg/headImg")
  self.tip = self:GetControl("img_infoBg/infoBg/tip")
  self.tip10v10 = self:GetControl("img_infoBg/infoBg/tip10v10")
end

function Activity_Sport3V3Info:Init()
end

function Activity_Sport3V3Info:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_Sport3V3Info:InitUI()
end

function Activity_Sport3V3Info:RegistUIEvents()
end

function Activity_Sport3V3Info:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_Sport3V3Info:RegistEvents()
end

function Activity_Sport3V3Info:Refresh()
  if self.args == nil then
    UIManager.Hide(UIID.Activity_Sport3V3Info)
    return
  end
  local resMsg = self.args
  local cfg = ClientTable.cfg_PVP_3v3_InfoManager:TryGetValue(resMsg.params, "info")
  if cfg then
    self.tip:SetText(cfg.content)
  end
  if resMsg.rid then
    local campPlayerInfo = QuickFind:GetThreeVsThreeDataMgr():GetMainPlayerCampInfo():GetPlayerInfo(resMsg.rid)
    local career = campPlayerInfo:GetCareer()
    local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(career, "id")
    if spriteName then
      self:SetSprite("Atlas_headPortrait", spriteName.headPortrait, self.headImg)
    end
  end
end

function Activity_Sport3V3Info:OnHide()
end

function Activity_Sport3V3Info:OnDestroy()
end
