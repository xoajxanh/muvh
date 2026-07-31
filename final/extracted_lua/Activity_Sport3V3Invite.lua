Activity_Sport3V3Invite = class(BaseUI)
Activity_Sport3V3Invite.layer = UILayer.Prompt
Activity_Sport3V3Invite.orderInLayer = 0
Activity_Sport3V3Invite.hideType = UIHideType.WaitDestroy
Activity_Sport3V3Invite.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_Sport3V3Invite.escClose = UIEscClose.DontClose

function Activity_Sport3V3Invite:InitControls()
  self.Panel_rank = self:GetControl("Panel_rank")
  self.btn_closeBg = self:GetControl("Panel_rank/btn_closeBg")
  self.img_bg = self:GetControl("Panel_rank/bg_rank/img_bg")
  self.btn_close = self:GetControl("Panel_rank/bg_rank/btn_close")
  self.headImg = self:GetControl("Panel_rank/bg_rank/inviteInfo/headBg/headImg")
  self.nameTxt = self:GetControl("Panel_rank/bg_rank/inviteInfo/headBg/nameTxt")
  self.levelTxt = self:GetControl("Panel_rank/bg_rank/inviteInfo/headBg/levelTxt")
  self.inviteInfo = self:GetControl("Panel_rank/bg_rank/inviteInfo/inviteInfo")
  self.tip = self:GetControl("Panel_rank/bg_rank/inviteInfo/inviteInfo/tip")
  self.tog_remind = self:GetControl("Panel_rank/bg_rank/inviteInfo/inviteInfo/tog_remind")
  self.btn_consent = self:GetControl("Panel_rank/bg_rank/inviteInfo/inviteInfo/btn_consent")
  self.btn_refuse = self:GetControl("Panel_rank/bg_rank/inviteInfo/inviteInfo/btn_refuse")
  self.btn_refuseText = self:GetControl("Panel_rank/bg_rank/inviteInfo/inviteInfo/btn_refuse/lab_ok")
  self.refuseInfo = self:GetControl("Panel_rank/bg_rank/inviteInfo/refuseInfo")
  self.btn_ok = self:GetControl("Panel_rank/bg_rank/inviteInfo/refuseInfo/btn_ok")
end

function Activity_Sport3V3Invite:Init()
end

function Activity_Sport3V3Invite:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_Sport3V3Invite:InitUI()
end

function Activity_Sport3V3Invite:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_consent:SetOnClick(self, self.btn_consentOnClick)
  self.btn_refuse:SetOnClick(self, self.btn_refuseOnClick)
  self.btn_ok:SetOnClick(self, self.btn_okOnClick)
  self.tog_remind:SetOnToggleChanged(self, self.OnToggleChanged)
end

function Activity_Sport3V3Invite:btn_closeBgOnClick(control)
  self:btn_refuseOnClick()
end

function Activity_Sport3V3Invite:btn_closeOnClick(control)
  self:btn_refuseOnClick()
end

function Activity_Sport3V3Invite:btn_consentOnClick(control)
  if self.data and self.data.teamId then
    networkRequest.ReqThreeVThreeInviteAck(self.data.teamId, true, 1)
    QuickFind:GetThreeVsThreeDataMgr():SetMatchPeopleType(2)
    if not UIManager.IsVisible(UIID.CrossServer_IntoUI) then
      UIManager.UICloseType(UIPanelType.HideOpen, false)
      UIManager.Show(UIID.CrossServer_IntoUI, {
        openFirstTab = CrossServerTabType.ThreeVsThree,
        isRefreshSportTeam3V3Template = true
      })
    else
      local CrossServer_IntoUI = UIManager.GetUiByName(UIID.CrossServer_IntoUI)
      CrossServer_IntoUI.isRefreshSportTeam3V3Template = true
      if CrossServer_IntoUI.curType ~= CrossServerTabType.ThreeVsThree then
        CrossServer_IntoUI.mainTogs[CrossServer_IntoUI.curType]:SetIsOn(true)
      else
        CrossServer_IntoUI:RefreshThreeVsThreeCrossPanel()
      end
    end
  end
  UIManager.Hide(UIID.Activity_Sport3V3Invite)
end

function Activity_Sport3V3Invite:btn_refuseOnClick(control)
  if self.data and self.data.teamId and self.data.type and self.data.type == 1 then
    networkRequest.ReqThreeVThreeInviteAck(self.data.teamId, false, 1)
  end
  UIManager.Hide(UIID.Activity_Sport3V3Invite)
end

function Activity_Sport3V3Invite:btn_okOnClick(control)
  UIManager.Hide(UIID.Activity_Sport3V3Invite)
end

function Activity_Sport3V3Invite:OnToggleChanged()
  if self.tog_remind:GetIsOn() == true then
  end
end

function Activity_Sport3V3Invite:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_Sport3V3Invite:RegistEvents()
  self:RegistEvent(Event.RefreshThreeVThreeInviteUIInfo, self.Refresh, self)
end

function Activity_Sport3V3Invite:Refresh(_, data)
  self.data = data or self.args and self.args.data
  if table.isNullOrEmpty(self.data) then
    return
  end
  self:RefreshUIView()
end

function Activity_Sport3V3Invite:RefreshUIView()
  local cfgData = ClientTable.cfg_PVP_3v3_team_stageManager:GetTabDataByStageAndLevel(self.data.stage, self.data.stageLevel)
  self:SetSprite("Atlas_headPortrait", tostring(RoleUtility.GetBasicCareer(self.data.career)), self.headImg)
  self.nameTxt:SetText(self.data.name)
  self.levelTxt:SetText(cfgData and cfgData.name)
  self.inviteInfo:SetActive(self.data.type == 1)
  self.refuseInfo:SetActive(self.data.type == 2 and self.data.result == 1)
  if self.data.type == 1 then
    self:RefreshMatchTime()
  end
end

function Activity_Sport3V3Invite:RefreshMatchTime()
  if self.surplusTimeLoop then
    Timer.Stop(self.surplusTimeLoop)
    self.surplusTimeLoop = nil
  end
  local surplusTime = 30
  self.btn_refuseText:SetText(string.format("T\225\187\171 ch\225\187\145i (%d)", surplusTime))
  self.surplusTimeLoop = Timer.StartLoopForever(1, function()
    surplusTime = surplusTime - 1
    self.btn_refuseText:SetText(string.format("T\225\187\171 ch\225\187\145i (%d)", surplusTime))
    if surplusTime <= 0 then
      Timer.Stop(self.surplusTimeLoop)
      self.surplusTimeLoop = nil
      self:btn_refuseOnClick()
    end
  end)
end

function Activity_Sport3V3Invite:OnHide()
  self.args = nil
  self.data = nil
  if self.surplusTimeLoop then
    Timer.Stop(self.surplusTimeLoop)
    self.surplusTimeLoop = nil
  end
  local playerPrefsStr = string.format("%s_Sport3V3InviteRemindTogTime", tostring(ViewData.meData.id))
  if self.tog_remind:GetIsOn() == true then
    PlayerPrefs.SetString(playerPrefsStr, Time.GetServerTime())
  else
    PlayerPrefs.SetString(playerPrefsStr, "")
  end
  self.tog_remind:SetIsOn(false)
end
