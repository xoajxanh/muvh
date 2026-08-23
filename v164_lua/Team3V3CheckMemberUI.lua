Team3V3CheckMemberUI = class(BaseUI)
Team3V3CheckMemberUI.layer = UILayer.Tip
Team3V3CheckMemberUI.orderInLayer = 0
Team3V3CheckMemberUI.hideType = UIHideType.WaitDestroy
Team3V3CheckMemberUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team3V3CheckMemberUI.escClose = UIEscClose.DontClose

function Team3V3CheckMemberUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.btn_close = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.Button_OK = self:GetControl("Panel_Tip/Image_TipBg/Button_OK")
  self.teamMember = self:GetControl("Panel_Tip/Image_TipBg/sw_memberList/Viewport/Content/img_teamMember")
end

function Team3V3CheckMemberUI:Init()
end

function Team3V3CheckMemberUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function CreateTeamMember(ctr)
  ctr.headImg = UIControl(ctr.transform, "img_headframe/img_touxiang")
  ctr.captainImg = UIControl(ctr.transform, "img_headframe/img_captain")
  ctr.levelTxt = UIControl(ctr.transform, "img_headframe/img_levelBg/level")
  ctr.nameTxt = UIControl(ctr.transform, "lab_Name")
  ctr.nameTxtContainer = UIControl(ctr.transform, "lab_NameContainer")
end

local function RefreshTeamMember(ctr, _, data, ui)
  if not data then
    return
  end
  local viewAttrData = QuickFind.LuaMainPlayerViewAttrData()
  if viewAttrData then
    local spriteName = viewAttrData:GetBaseCareerByValue(data.career)
    if spriteName then
      ui:SetSprite("Atlas_headPortrait", spriteName, ctr.headImg)
    end
  end
  ctr.captainImg:SetActive(data.isLeader or false)
  if data.level then
    ctr.levelTxt:SetText(tostring(data.level))
  end
  if data.name then
    ctr.nameTxt:SetText(data.name)
    local textWidth = ctr.nameTxt.text.preferredWidth
    local bgWidth = ctr.nameTxt:GetSizeDelta()
    if textWidth > bgWidth then
      ctr.nameTxtContainer.transform:GetComponent("AutoScrollText").text = data.name
      ctr.nameTxt:SetActive(false)
      ctr.nameTxtContainer:SetActive(true)
    else
      ctr.nameTxt:SetActive(true)
      ctr.nameTxtContainer:SetActive(false)
    end
  end
end

function Team3V3CheckMemberUI:InitUI()
  self.teamMemberContainer = UIContainer(self.teamMember, self, CreateTeamMember, RefreshTeamMember)
end

function Team3V3CheckMemberUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.Button_OK:SetOnClick(self, self.btn_closeOnClick)
end

function Team3V3CheckMemberUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Team3V3CheckMemberUI)
end

function Team3V3CheckMemberUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Team3V3CheckMemberUI:RegistEvents()
end

function Team3V3CheckMemberUI:Refresh()
  if not (self.args and self.args.teamMemberData) or not self.args.teamMemberData.infos then
    self.teamMemberContainer:SetData()
    return
  end
  self.teamMemberContainer:SetData(self.args.teamMemberData.infos)
end

function Team3V3CheckMemberUI:OnHide()
end

function Team3V3CheckMemberUI:OnDestroy()
end
