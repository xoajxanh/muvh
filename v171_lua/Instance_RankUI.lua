Instance_RankUI = class(BaseUI)
Instance_RankUI.layer = UILayer.Panel
Instance_RankUI.orderInLayer = 0
Instance_RankUI.hideType = UIHideType.WaitDestroy
Instance_RankUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_RankUI.escClose = UIEscClose.DontClose

function Instance_RankUI:InitControls()
  self.lab_killNum = self:GetControl("Panel_rank/bg_rank/lab_killTitle/lab_killNum")
  self.lab_exp = self:GetControl("Panel_rank/bg_rank/lab_expTitle/lab_exp")
  self.btn_ok = self:GetControl("Panel_rank/bg_rank/btn_ok")
end

function Instance_RankUI:OnPreLoad()
end

function Instance_RankUI:Init()
end

function Instance_RankUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_RankUI:InitUI()
end

function Instance_RankUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Instance_RankUI:OnHide()
end

function Instance_RankUI:OnDestroy()
end

function Instance_RankUI:RegistUIEvents()
  self.btn_ok:SetOnClick(self, self.btn_okOnClick)
end

function Instance_RankUI:btn_okOnClick(control)
  UIManager.Hide(UIID.Instance_RankUI)
end

function Instance_RankUI:RegistEvents()
end

function Instance_RankUI:Refresh()
  self:ShowReward()
  self.recTimer = Timer.StartLoopForever(7, self.WaitHideUI, self)
end

function Instance_RankUI:ShowReward()
  local rewardData = self.args.msg
  self.lab_killNum:SetText(rewardData.monsterNum)
  self.lab_exp:SetText(rewardData.exp)
end

function Instance_RankUI:WaitHideUI()
  if self.recTimer then
    Timer.Stop(self.recTimer)
    self.recTimer = nil
  end
  self:btn_okOnClick()
end
