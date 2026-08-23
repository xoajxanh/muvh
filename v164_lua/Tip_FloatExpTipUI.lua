Tip_FloatExpTipUI = class(BaseUI)
Tip_FloatExpTipUI.layer = UILayer.Background
Tip_FloatExpTipUI.orderInLayer = 2
Tip_FloatExpTipUI.hideType = UIHideType.Hide
Tip_FloatExpTipUI.hideFunc = UIHideFunc.Deactive
Tip_FloatExpTipUI.escClose = UIEscClose.DontClose

function Tip_FloatExpTipUI:InitControls()
  self.ProgramText = self:GetControl("ProgramText")
end

function Tip_FloatExpTipUI:Init()
end

function Tip_FloatExpTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_FloatExpTipUI:InitUI()
  self.ProgramText.transform:GetChild(0).gameObject:AddMissingComponent(typeof(CS.Framework.TextFadeEffct))
end

function Tip_FloatExpTipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_FloatExpTipUI:OnHide()
end

function Tip_FloatExpTipUI:OnDestroy()
end

function Tip_FloatExpTipUI:RegistUIEvents()
end

function Tip_FloatExpTipUI:RegistEvents()
end

function Tip_FloatExpTipUI:Refresh()
end

function Tip_FloatExpTipUI:StopAnimate(item)
  if item.StartAni then
    Coroutine.Stop(item.StartAni)
    item.StartAni = nil
  end
  if item.StartCor then
    Coroutine.Stop(item.StartCor)
    item.StartCor = nil
  end
end

function Tip_FloatExpTipUI:StartAnimate(msgStr, item)
  if item.ProgramText == nil then
    item.ProgramText = UIControl(item.transform, "Text")
  end
  item.ProgramText:SetText(msgStr)
  item.StartAni = Coroutine.Start(self.StartCoroutine, self, item)
end

function Tip_FloatExpTipUI:StartCoroutine(item)
  local graphics = item.transform:GetComponentInChildren(typeof(CS.Framework.TextFadeEffct))
  graphics:DoFade(1, FloatingExpUtility.Fade_Time)
  Coroutine.Wait(FloatingExpUtility.MSG_Time)
  item.StartCor = Coroutine.Start(self.WaitDelete, self, item)
end

function Tip_FloatExpTipUI:OpenCorWaitDelete(item)
  FloatingExpUtility.PoolDelete(item)
end

function Tip_FloatExpTipUI:WaitDelete(item)
  local graphics = item.transform:GetComponentInChildren(typeof(CS.Framework.TextFadeEffct))
  graphics:DoFade(0, FloatingExpUtility.Fade_Time)
  Coroutine.Wait(FloatingExpUtility.Fade_Time)
  self:StopAnimate(item)
  FloatingExpUtility.TipFloatTipUIList:Remove(item)
  FloatingExpUtility.PoolDelete(item)
end

local publicVect2 = Vector2.zero

function Tip_FloatExpTipUI:SetTipsPos()
  local rootRect = self.root.rectTransform
  publicVect2:Set(0, 0)
  rootRect.anchorMin = publicVect2
  rootRect.anchorMax = publicVect2
  publicVect2:Set(157, 100)
  rootRect.anchoredPosition = publicVect2
end
