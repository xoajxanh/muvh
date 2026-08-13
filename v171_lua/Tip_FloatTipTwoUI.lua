Tip_FloatTipTwoUI = class(BaseUI)
Tip_FloatTipTwoUI.layer = UILayer.Tip
Tip_FloatTipTwoUI.orderInLayer = 10
Tip_FloatTipTwoUI.hideType = UIHideType.Hide
Tip_FloatTipTwoUI.hideFunc = UIHideFunc.Deactive
Tip_FloatTipTwoUI.escClose = UIEscClose.DontClose

function Tip_FloatTipTwoUI:InitControls()
  self.ProgramText = self:GetControl("ProgramText")
end

function Tip_FloatTipTwoUI:Init()
end

function Tip_FloatTipTwoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_FloatTipTwoUI:InitUI()
  self.ProgramText.transform:GetChild(0).gameObject:AddMissingComponent(typeof(CS.Framework.TextFadeEffct))
end

function Tip_FloatTipTwoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_FloatTipTwoUI:OnHide()
end

function Tip_FloatTipTwoUI:OnDestroy()
end

function Tip_FloatTipTwoUI:RegistUIEvents()
end

function Tip_FloatTipTwoUI:RegistEvents()
end

function Tip_FloatTipTwoUI:Refresh()
end

function Tip_FloatTipTwoUI:StopAnimate(item)
  if item.StartAni then
    Coroutine.Stop(item.StartAni)
    item.StartAni = nil
  end
  if item.StartCor then
    Coroutine.Stop(item.StartCor)
    item.StartCor = nil
  end
end

function Tip_FloatTipTwoUI:StartAnimate(msgStr, item)
  if item.ProgramText == nil then
    item.ProgramText = UIControl(item.transform, "Text")
    item.ProgramImage = UIControl(item.transform, "Image")
  end
  item.ProgramText:SetText(msgStr)
  item.StartAni = Coroutine.Start(self.StartCoroutine, self, item)
end

function Tip_FloatTipTwoUI:StartCoroutine(item)
  local graphics = item.transform:GetComponentInChildren(typeof(CS.Framework.TextFadeEffct))
  graphics:DoFade(1, FloatingTipUtility.Fade_Time)
  item.image.enabled = true
  Coroutine.Wait(FloatingTipUtility.MSG_Time)
  item.StartCor = Coroutine.Start(self.WaitDelete, self, item)
end

function Tip_FloatTipTwoUI:OpenCorWaitDelete(item)
  FloatingTipUtility.PoolDelete(item)
end

function Tip_FloatTipTwoUI:WaitDelete(item)
  local graphics = item.transform:GetComponentInChildren(typeof(CS.Framework.TextFadeEffct))
  graphics:DoFade(0, FloatingTipUtility.Fade_Time)
  Coroutine.Wait(FloatingTipUtility.Fade_Time)
  self:StopAnimate(item)
  FloatingTipUtility.TipFloatTipUIList:Remove(item)
  FloatingTipUtility.PoolDelete(item)
end

local publicVect2 = Vector2.zero

function Tip_FloatTipTwoUI:SetTipsPos()
  local rootRect = self.root.rectTransform
  publicVect2:Set(0, 0)
  rootRect.anchorMin = publicVect2
  rootRect.anchorMax = publicVect2
  publicVect2:Set(157, 100)
  rootRect.anchoredPosition = publicVect2
end
