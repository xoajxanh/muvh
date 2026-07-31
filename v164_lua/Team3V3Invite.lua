Team3V3Invite = class(BaseUI)
Team3V3Invite.layer = UILayer.Tooltip
Team3V3Invite.orderInLayer = 0
Team3V3Invite.hideType = UIHideType.WaitDestroy
Team3V3Invite.hideFunc = UIHideFunc.MoveOutOfScreen
Team3V3Invite.escClose = UIEscClose.DontClose

function Team3V3Invite:InitControls()
  self.Panel_rank = self:GetControl("Panel_rank")
  self.btn_closeBg = self:GetControl("Panel_rank/btn_closeBg")
  self.img_bg = self:GetControl("Panel_rank/bg_rank/img_bg")
  self.btn_close = self:GetControl("Panel_rank/bg_rank/btn_close")
  self.headImg = self:GetControl("Panel_rank/bg_rank/inviteInfo/headBg/headImg")
  self.nameTxt = self:GetControl("Panel_rank/bg_rank/inviteInfo/headBg/nameTxt")
  self.levelTxt = self:GetControl("Panel_rank/bg_rank/inviteInfo/headBg/levelTxt")
  self.teamName = self:GetControl("Panel_rank/bg_rank/inviteInfo/headBg/teamName")
  self.totalLevel = self:GetControl("Panel_rank/bg_rank/inviteInfo/headBg/totalLevel")
  self.member = self:GetControl("Panel_rank/bg_rank/inviteInfo/headBg/member")
  self.inviteInfo = self:GetControl("Panel_rank/bg_rank/inviteInfo/inviteInfo")
  self.tog_remind = self:GetControl("Panel_rank/bg_rank/inviteInfo/inviteInfo/tog_remind")
  self.btn_consent = self:GetControl("Panel_rank/bg_rank/inviteInfo/inviteInfo/btn_consent")
  self.btn_refuse = self:GetControl("Panel_rank/bg_rank/inviteInfo/inviteInfo/btn_refuse")
  self.refuseInfo = self:GetControl("Panel_rank/bg_rank/inviteInfo/refuseInfo")
  self.btn_ok = self:GetControl("Panel_rank/bg_rank/inviteInfo/refuseInfo/btn_ok")
end

function Team3V3Invite:Init()
end

function Team3V3Invite:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Team3V3Invite:InitUI()
end

function Team3V3Invite:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_consent:SetOnClick(self, self.btn_consentOnClick)
  self.btn_refuse:SetOnClick(self, self.btn_refuseOnClick)
end

function Team3V3Invite:btn_closeOnClick(control)
  UIManager.Hide(UIID.Team3V3Invite)
end

function Team3V3Invite:btn_consentOnClick(control)
  networkRequest.ReqAgreeMatchInvite(self.args.teamId)
  UIManager.Hide(UIID.Team3V3Invite)
  UIManager.Show(UIID.Team3V3UI)
end

function Team3V3Invite:btn_refuseOnClick(control)
  networkRequest.ReqDisAgreeMatchInvite(self.args.teamId)
  UIManager.Hide(UIID.Team3V3Invite)
end

function Team3V3Invite:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Team3V3Invite:RegistEvents()
end

function Team3V3Invite:Refresh()
  local data = self.args
  if not data then
    return
  end
  self.tog_remind.toggle.isOn = false
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(data.inviter.career, "id").headPortrait
  self:SetSprite("Atlas_headPortrait", spriteName, self.headImg)
  self.nameTxt:SetText(data.inviter.name)
  self.levelTxt:SetText("Lv." .. data.inviter.level)
  self.teamName:SetText("T\195\170n Chi\225\186\191n \196\144\225\187\153i:" .. data.teamName)
  self.totalLevel:SetText("T\225\187\149ng c\225\186\165p Chi\225\186\191n \196\144\225\187\153i:" .. data.totalLevel)
  self.member:SetText("S\225\187\145 ng\198\176\225\187\157i Chi\225\186\191n \196\144\225\187\153i:" .. data.memberCount .. "/4")
end

function Team3V3Invite:OnHide()
  if self.tog_remind.toggle.isOn then
    QuickFind:GetTeam3V3DataMgr():InsertRefuseInviteId(self.args.teamId)
  end
  networkRequest.ReqDisAgreeMatchInvite(self.args.teamId)
end

function Team3V3Invite:OnDestroy()
end
