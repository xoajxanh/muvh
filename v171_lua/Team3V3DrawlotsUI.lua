Team3V3DrawlotsUI = class(BaseUI)
Team3V3DrawlotsUI.layer = UILayer.Tip
Team3V3DrawlotsUI.orderInLayer = 0
Team3V3DrawlotsUI.hideType = UIHideType.WaitDestroy
Team3V3DrawlotsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team3V3DrawlotsUI.escClose = UIEscClose.DontClose

function Team3V3DrawlotsUI:InitControls()
  self.Choqian = self:GetControl("Choqian")
  self.img_lots = self:GetControl("img_lots")
  self.text_group = self:GetControl("img_lots/text_group")
  self.text_num = self:GetControl("img_lots/text_num")
  self.mask = self:GetControl("mask")
  self.text = self:GetControl("text")
end

function Team3V3DrawlotsUI:Init()
end

function Team3V3DrawlotsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Team3V3DrawlotsUI:InitUI()
  self.animator = self.Choqian.transform:GetComponent(typeof(CS.UnityEngine.Animation))
  self.timer = nil
  self.showContentMoveTween = nil
  self.startPosY = -1000
  self.endPosY = 18
  self.knockoutDrawData = nil
end

function Team3V3DrawlotsUI:RegistUIEvents()
  self.mask:SetOnClick(self, self.MaskOnClick)
end

function Team3V3DrawlotsUI:MaskOnClick()
  if not self.knockoutDrawData then
    return
  end
  local groupName = QuickFind.GetTeam3V3DataMgr():GetKnockoutDrawGroupName(self.knockoutDrawData.position)
  local timeStr = ""
  if self.knockoutDrawData and self.knockoutDrawData.releaseTime > 0 then
    timeStr = QuickFind:GetTeam3V3DataMgr():FormatTime(self.knockoutDrawData.releaseTime)
  end
  UIManager.Hide(UIID.Team3V3DrawlotsUI)
  UIManager.Show(UIID.Team3V3UI)
  
  local function func()
    networkRequest.ReqTeamDuelTotal()
  end
  
  Team3V3Controller:TipShow(KnockoutDrawTipType.ResKnockoutDraw, {
    "T\225\187\149 " .. groupName .. " 0" .. self.knockoutDrawData.type,
    timeStr
  }, func)
end

function Team3V3DrawlotsUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Team3V3DrawlotsUI:RegistEvents()
end

function Team3V3DrawlotsUI:Refresh()
  UIManager.Hide(UIID.Team3V3UI)
  EventManager.Dispatch(Event.ChangeRightTopBtn, false)
  self.animator.enabled = true
  self.animator:Play("A_choqian")
  self.knockoutDrawData = QuickFind.GetTeam3V3DataMgr():GetKnockoutDrawData()
  self:SetSprite("Atlas_Common", "team3v3_drawlots_txt_" .. self.knockoutDrawData.position, self.text_group)
  self:SetSprite("Atlas_Common", "team3v3_drawlots_txt2_" .. self.knockoutDrawData.type, self.text_num)
  self:CloseTimer()
  self:ResetTween()
  local animClip = self.animator:GetClip("A_choqian")
  local animDuration = animClip and animClip.length or 3
  self.timer = Timer.Start(animDuration, function()
    self:OnChoqianAnimComplete()
  end)
end

function Team3V3DrawlotsUI:OnChoqianAnimComplete()
  self.animator.enabled = false
  self.img_lots:SetActive(true)
  self.showContentMoveTween = DOTween.To(function(value)
    self.img_lots.transform.localPosition = Vector3(0, value, -1000)
  end, self.startPosY, self.endPosY, 1.5):SetEase(Ease.InOutQuad):OnComplete(function()
    self.text:SetActive(true)
    self.mask:SetRaycastTarget(true)
  end)
end

function Team3V3DrawlotsUI:ResetTween()
  if self.showContentMoveTween then
    self.showContentMoveTween:Kill()
    self.showContentMoveTween = nil
  end
end

function Team3V3DrawlotsUI:CloseTimer()
  if self.timer ~= nil then
    Timer.Stop(self.timer)
    self.timer = nil
  end
end

function Team3V3DrawlotsUI:OnHide()
  self:CloseTimer()
  self:ResetTween()
  self.img_lots:SetActive(false)
  self.text:SetActive(false)
  self.mask:SetRaycastTarget(false)
end

function Team3V3DrawlotsUI:OnDestroy()
end
