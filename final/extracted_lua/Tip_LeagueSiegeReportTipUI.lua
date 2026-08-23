Tip_LeagueSiegeReportTipUI = class(BaseUI)
Tip_LeagueSiegeReportTipUI.layer = UILayer.Panel
Tip_LeagueSiegeReportTipUI.orderInLayer = 30
Tip_LeagueSiegeReportTipUI.hideType = UIHideType.WaitDestroy
Tip_LeagueSiegeReportTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_LeagueSiegeReportTipUI.escClose = UIEscClose.DontClose

function Tip_LeagueSiegeReportTipUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.btn_panel_report_yes = self:GetControl("panel_report/bg/btn_panel_report_yes")
  self.btn_panel_report_yes_Text = self:GetControl("panel_report/bg/btn_panel_report_yes/Text")
  self.btn_panel_report_no = self:GetControl("panel_report/bg/btn_panel_report_no")
  self.btn_panel_report_no_Text = self:GetControl("panel_report/bg/btn_panel_report_no/Text")
  self.title = self:GetControl("panel_report/title")
  self.noticeInput = self:GetControl("panel_report/noticeInput")
  self.Placeholder = self:GetControl("panel_report/noticeInput/Placeholder")
end

function Tip_LeagueSiegeReportTipUI:Init()
end

function Tip_LeagueSiegeReportTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_LeagueSiegeReportTipUI:InitUI()
end

function Tip_LeagueSiegeReportTipUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.Bg_CloseOnClick)
  self.btn_panel_report_yes:SetOnClick(self, self.btn_panel_report_yesOnClick)
  self.btn_panel_report_no:SetOnClick(self, self.btn_panel_report_noOnClick)
  self.noticeInput:SetOnValueChanged(self, self.noticeInputOnChanged)
end

function Tip_LeagueSiegeReportTipUI:Bg_CloseOnClick(control)
  UIManager.Hide(UIID.Tip_LeagueSiegeReportTipUI)
end

function Tip_LeagueSiegeReportTipUI:btn_panel_report_yesOnClick(control)
  if self.confirmCallBack ~= nil then
    self.confirmCallBack(self)
  end
  UIManager.Hide(UIID.Tip_LeagueSiegeReportTipUI)
end

function Tip_LeagueSiegeReportTipUI:btn_panel_report_noOnClick(control)
  UIManager.Hide(UIID.Tip_LeagueSiegeReportTipUI)
end

function Tip_LeagueSiegeReportTipUI:noticeInputOnChanged(control, data)
  self.inputData = data
end

function Tip_LeagueSiegeReportTipUI:OnShow()
  if self:AnalysisParams() == false then
    return
  end
  self:RegistEvents()
  self:Refresh()
end

function Tip_LeagueSiegeReportTipUI:AnalysisParams()
  if self.args == nil then
    return false
  end
  local inputParams = self.args
  self.reportTbl = ClientTable.cfg_Ui_reportManager:TryGetValue(inputParams.reportTblId)
  if self.reportTbl == nil then
    return false
  end
  self.confirmCallBack = inputParams.confirmCallBack
  return true
end

function Tip_LeagueSiegeReportTipUI:RegistEvents()
end

function Tip_LeagueSiegeReportTipUI:Refresh()
  self.title:SetText(self.reportTbl.reportTitle)
  self.btn_panel_report_no_Text:SetText(self.reportTbl.leftButtonEvent)
  self.btn_panel_report_yes_Text:SetText(self.reportTbl.rightButtonEvent)
end

function Tip_LeagueSiegeReportTipUI:ResetData()
  self.inputData = nil
  self.noticeInput:SetInputText("")
end

function Tip_LeagueSiegeReportTipUI:OnHide()
  self:ResetData()
end

function Tip_LeagueSiegeReportTipUI:OnDestroy()
end
