Activity_RedfortRankUI = class(BaseUI)
Activity_RedfortRankUI.layer = UILayer.Panel
Activity_RedfortRankUI.orderInLayer = 0
Activity_RedfortRankUI.hideType = UIHideType.WaitDestroy
Activity_RedfortRankUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_RedfortRankUI.escClose = UIEscClose.DontClose

function Activity_RedfortRankUI:InitControls()
  self.lab_knockNum = self:GetControl("Panel_rank/bg_rank/lab_knockNum")
  self.lab_rank = self:GetControl("Panel_rank/bg_rank/lab_rank")
  self.btn_ok = self:GetControl("Panel_rank/bg_rank/btn_ok")
end

function Activity_RedfortRankUI:OnPreLoad()
end

function Activity_RedfortRankUI:Init()
  if self.args then
    self.knockOutNum = self.args.knockOut
    self.rank = self.args.rank
  else
  end
end

function Activity_RedfortRankUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_RedfortRankUI:InitUI()
  if not self.args then
    return
  end
  self:Refresh()
end

function Activity_RedfortRankUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_RedfortRankUI:OnHide()
end

function Activity_RedfortRankUI:OnDestroy()
end

function Activity_RedfortRankUI:CloseClick(control)
  UIManager.Hide(UIID.Activity_RedfortRankUI)
end

function Activity_RedfortRankUI:RegistUIEvents()
  self.btn_ok:SetOnClick(self, self.CloseClick)
end

function Activity_RedfortRankUI:RegistEvents()
end

function Activity_RedfortRankUI:Refresh()
  self.lab_knockNum:SetText(RedFortData.rank.count)
  self.lab_rank:SetText(RedFortData.rank.rank)
end
