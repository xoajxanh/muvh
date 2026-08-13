LeftTopPanelUI = class(BaseUI)
LeftTopPanelUI.layer = UILayer.Background
LeftTopPanelUI.orderInLayer = 2
LeftTopPanelUI.hideType = UIHideType.Hide
LeftTopPanelUI.hideFunc = UIHideFunc.MoveOutOfScreen
LeftTopPanelUI.escClose = UIEscClose.DontClose

function LeftTopPanelUI:InitControls()
  self.btn_hide = self:GetControl("sumcon/btn_hide")
  self.subPanel = self:GetControl("SubPanel/subPanel")
  self.Btns = self:GetControl("SubPanel/subPanel/Btns")
  self.btn_Task = self:GetControl("SubPanel/subPanel/Btns/btn_Task")
  self.lb_Task = self:GetControl("SubPanel/subPanel/Btns/btn_Task/lab_b")
  self.lb_CheckTask = self:GetControl("SubPanel/subPanel/Btns/btn_Task/Checkmark/lab_c")
  self.btn_Team = self:GetControl("SubPanel/subPanel/Btns/btn_Team")
  self.PanelUIs = self:GetControl("SubPanel/subPanel/PanelUIs")
end

function LeftTopPanelUI:OnPreLoad()
end

function LeftTopPanelUI:Init()
  self.panelHideFlag = false
end

function LeftTopPanelUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local taskCheckmark, teamCheckmark

function LeftTopPanelUI:InitUI()
  self:GoPosInit()
  self:SubPanelInit()
  self:SetHidePos()
  self.transTempUI:SetVisible(false)
  self.GodComeTaskUI:SetVisible(false)
  self.btn_hide:SetRotation(0, 0, 180)
  taskCheckmark = UIControl(self.btn_Task.transform, "Checkmark")
  teamCheckmark = UIControl(self.btn_Team.transform, "Checkmark")
end

function LeftTopPanelUI:GoPosInit()
  self.panelUIs_pos = self.PanelUIs.transform.localPosition
end

function LeftTopPanelUI:SubPanelInit()
  self.taskTempUI = UIManager.Show(UIID.TaskUI, {
    parent = self.PanelUIs.transform
  })
  self.teamTempUI = UIManager.Show(UIID.TeamTempUI, {
    parent = self.PanelUIs.transform
  })
  self.transTempUI = UIManager.Show(UIID.Instance_GoalUI, {
    parent = self.PanelUIs.transform,
    onShow = function()
      EventManager.Dispatch(Event.UpdateCopyDataInfo)
    end
  })
  self.GodComeTaskUI = UIManager.Show(UIID.Activity_GodComeTaskUI, {
    parent = self.PanelUIs.transform,
    onShow = function()
      EventManager.Dispatch(Event.UpdateGodComeTaskUI)
    end
  })
end

function LeftTopPanelUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:ChangePanel()
end

function LeftTopPanelUI:ChangePanel()
  self:OpenPanelUi()
  self:SetPanelHide(false)
end

function LeftTopPanelUI:OnRefushTask()
  LeftTopPanelManager.SetCurrentPanelType(PanelType.TaskPanelType)
  if UIManager.IsVisible(UIID.TaskUI) and self.taskTempUI.RootPanel then
    self.taskTempUI:RootPanelState(true)
  else
    self.taskTempUI:Show()
  end
  if UIManager.IsVisible(UIID.TeamTempUI) and self.teamTempUI.RootPanel then
    self.teamTempUI:RootPanelState(false)
  else
    self.teamTempUI:Hide()
  end
  self.transTempUI:Hide()
  self.GodComeTaskUI:Hide()
end

function LeftTopPanelUI:OnRefushTeam()
  LeftTopPanelManager.SetCurrentPanelType(PanelType.TeamPanelType)
  if UIManager.IsVisible(UIID.TaskUI) and self.taskTempUI.RootPanel then
    self.taskTempUI:RootPanelState(false)
  else
    self.taskTempUI:Hide()
  end
  if UIManager.IsVisible(UIID.TeamTempUI) and self.teamTempUI.RootPanel then
    self.teamTempUI:RootPanelState(true)
  else
    self.teamTempUI:Show()
  end
  if UIManager.IsVisible(UIID.Instance_GoalUI) then
    if TranScriptData.InTranscript then
      self.transTempUI:RootPanelState(true)
      self.transTempUI.AllPanel:SetActive(false)
    else
      self.transTempUI:RootPanelState(false)
    end
  elseif TranScriptData.InTranscript then
    self.transTempUI:Show()
  end
  if UIManager.IsVisible(UIID.Activity_GodComeTaskUI) then
    if TranScriptData.InAllGodsscript then
      self.GodComeTaskUI:RootPanelState(true)
      self.GodComeTaskUI.AllPanel:SetActive(false)
    else
      self.GodComeTaskUI:RootPanelState(false)
    end
  end
end

function LeftTopPanelUI:OnRefushTrans()
  LeftTopPanelManager.SetCurrentPanelType(PanelType.TransPanelType)
  self.taskTempUI:Hide()
  if UIManager.IsVisible(UIID.TeamTempUI) and self.teamTempUI.RootPanel then
    self.teamTempUI:RootPanelState(false)
  else
    self.teamTempUI:Hide()
  end
  if UIManager.IsVisible(UIID.Instance_GoalUI) and self.transTempUI and self.transTempUI.RootPanel then
    self.transTempUI:RootPanelState(true)
    self.transTempUI.AllPanel:SetActive(true)
  else
    self.transTempUI:Show()
  end
end

function LeftTopPanelUI:OnRefushSiege()
  if LeftTopPanelManager.GetPanelHide() then
    self:OnRefushTask()
    self:HidePanelOfMap(0, true)
    return
  end
end

function LeftTopPanelUI:OnRefushGodCome()
  LeftTopPanelManager.SetCurrentPanelType(PanelType.GodComePaneType)
  self.taskTempUI:Hide()
  if UIManager.IsVisible(UIID.TeamTempUI) and self.teamTempUI.RootPanel then
    self.teamTempUI:RootPanelState(false)
  else
    self.teamTempUI:Hide()
  end
  if UIManager.IsVisible(UIID.Activity_GodComeTaskUI) and self.GodComeTaskUI.RootPanel then
    self.GodComeTaskUI:RootPanelState(true)
    self.GodComeTaskUI.AllPanel:SetActive(true)
  else
    self.GodComeTaskUI:Show()
  end
end

function LeftTopPanelUI:OpenPanelUi()
  self:TryChangeTaskBtnText()
  taskCheckmark:SetActive(LeftTopPanelManager.GetCurrentPanelType() == PanelType.TaskPanelType or LeftTopPanelManager.GetCurrentPanelType() == PanelType.TransPanelType or LeftTopPanelManager.GetCurrentPanelType() == PanelType.GodComePaneType or LeftTopPanelManager.GetCurrentPanelType() == PanelType.KSBattlePaneType)
  teamCheckmark:SetActive(LeftTopPanelManager.GetCurrentPanelType() == PanelType.TeamPanelType)
  if LeftTopPanelManager.GetPanelHide() then
    self:OnRefushTask()
    self:HidePanelOfMap(0, true)
    return
  end
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TaskPanelType then
    self:OnRefushTask()
  end
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TeamPanelType then
    self:OnRefushTeam()
  end
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TransPanelType or LeftTopPanelManager.GetCurrentPanelType() == PanelType.KSBattlePaneType then
    self:OnRefushTrans()
  end
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.GodComePaneType then
    self:OnRefushGodCome()
  end
end

function LeftTopPanelUI:TryChangeTaskBtnText()
  local curTxt = LeftTopPanelManager.GetCurrentPanelType() ~= PanelType.KSBattlePaneType and "Nhi\225\187\135m V\225\187\165" or "X\225\186\191p h\225\186\161ng"
  local lastTxt = self.lb_Task:GetText()
  if curTxt == lastTxt then
    return
  end
  self.lb_Task:SetText(curTxt)
  self.lb_CheckTask:SetText(curTxt)
end

function LeftTopPanelUI:OnHide()
end

function LeftTopPanelUI:OnDestroy()
end

function LeftTopPanelUI:RegistUIEvents()
  self.btn_Task:SetOnClick(self, self.TaskBtnClick)
  self.btn_Team:SetOnClick(self, self.TeamBtnClick)
  self.btn_hide:SetOnClick(self, self.SetClickHide)
end

function LeftTopPanelUI:TaskBtnClick()
  if TranScriptData.InTranscript then
    self:OnRefushTrans()
  elseif TranScriptData.InAllGodsscript then
    self:OnRefushGodCome()
  else
    self:OnRefushTask()
  end
  taskCheckmark:SetActive(LeftTopPanelManager.GetCurrentPanelType() == PanelType.TaskPanelType or LeftTopPanelManager.GetCurrentPanelType() == PanelType.TransPanelType or LeftTopPanelManager.GetCurrentPanelType() == PanelType.GodComePaneType or LeftTopPanelManager.GetCurrentPanelType() == PanelType.KSBattlePaneType)
  teamCheckmark:SetActive(LeftTopPanelManager.GetCurrentPanelType() == PanelType.TeamPanelType)
end

function LeftTopPanelUI:TeamBtnClick()
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TeamPanelType then
    self:TeamInfoClick()
  else
    self:OnRefushTeam()
  end
  taskCheckmark:SetActive(LeftTopPanelManager.GetCurrentPanelType() == PanelType.TaskPanelType or LeftTopPanelManager.GetCurrentPanelType() == PanelType.TransPanelType or LeftTopPanelManager.GetCurrentPanelType() == PanelType.GodComePaneType or LeftTopPanelManager.GetCurrentPanelType() == PanelType.KSBattlePaneType)
  teamCheckmark:SetActive(LeftTopPanelManager.GetCurrentPanelType() == PanelType.TeamPanelType)
end

function LeftTopPanelUI:TeamInfoClick()
  EventManager.Dispatch(Event.Team_ReqTeamsInfo, nil)
  local openType = {
    openType = ShowTeamType.MyMemberType
  }
  UIManager.Show(UIID.Team_TeamInfoUI, {type = openType})
end

function LeftTopPanelUI:SetClickHide()
  self.panelHideFlag = not self.panelHideFlag
  self:SetPanelHide(self.panelHideFlag)
end

function LeftTopPanelUI:SetPanelHide(hide)
  if LeftTopPanelManager.GetPanelHide() then
    return
  end
  self:GetHidePos()
  self.panelHideFlag = hide
  self.subPanel.transform:DOLocalMove(hide and Vector2(-700, 0) or Vector2(0, 0), 0.5)
  self.btn_hide.transform:DOLocalMove(hide and Vector2(-295, 0) or self.hidePos, 0.5)
  LeftTopPanelManager.SetTaskBtnFlag(hide)
  EventManager.Dispatch(Event.Task_MianPanelHide)
  self.btn_hide:SetActive(true)
  if hide then
    self.btn_hide:SetRotation(0, 0, 0)
  else
    self.btn_hide:SetRotation(0, 0, 180)
  end
end

function LeftTopPanelUI:HidePanelOfMap(id, hide)
  self.panelHideFlag = hide
  self:GetHidePos()
  self.otherEventFlag = hide
  self.subPanel.transform:DOLocalMove(hide and Vector2(-700, 0) or Vector2(0, 0), 0.5)
  self.btn_hide:SetActive(not hide)
  if hide then
    self.btn_hide:SetRotation(0, 0, 0)
  else
    self.btn_hide:SetRotation(0, 0, 180)
  end
  self.btn_hide.transform:DOLocalMove(false and Vector2(0, 110) or self.hidePos, 0.5)
  LeftTopPanelManager.SetTaskBtnFlag(false)
  EventManager.Dispatch(Event.Task_MianPanelHide)
end

function LeftTopPanelUI:GetHidePos()
  self.hidePos = LeftTopPanelManager.GetBtnFlag() and Vector2(0, 0) or Vector2(5, 0)
end

function LeftTopPanelUI:SetHidePos()
  self.hidePos = LeftTopPanelManager.GetBtnFlag() and Vector2(0, 0) or Vector2(5, 0)
  self.btn_hide.transform:DOKill()
  if not self.panelHideFlag then
    self.btn_hide.transform.localPosition = self.hidePos
  end
end

function LeftTopPanelUI:RegistEvents()
  self:RegistEvent(Event.Task_SetTaskPanelHide, self.HidePanelOfMap, self)
  self:RegistEvent(Event.GamePlay_Leave, self.RetOnUI, self)
  self:RegistEvent(Event.GamePlay_Back2Choose, self.RetOnUI, self)
  self:RegistEvent(Event.TaskSlideBtnUpdate, self.SetHidePos, self)
  self:RegistEvent(Event.UpdateCopyInfo, self.ChangePanel, self)
  self:RegistEvent(Event.Task_ChangePanelState, self.ChangePanel, self)
end

function LeftTopPanelUI:RetOnUI()
  self.panelHideFlag = false
  self.taskTempUI:Hide()
  self.teamTempUI:Hide()
  self.transTempUI:Hide()
  self.GodComeTaskUI:Hide()
end

function LeftTopPanelUI:Refresh()
end
