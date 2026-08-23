Tip_FloatTipUI = class(BaseUI)
Tip_FloatTipUI.layer = UILayer.Background
Tip_FloatTipUI.orderInLayer = 0
Tip_FloatTipUI.hideType = UIHideType.Hide
Tip_FloatTipUI.hideFunc = UIHideFunc.Deactive
Tip_FloatTipUI.escClose = UIEscClose.DontClose

function Tip_FloatTipUI:InitControls()
  self.ProgramText = self:GetControl("ProgramText")
end

function Tip_FloatTipUI:Init()
end

function Tip_FloatTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_FloatTipUI:InitUI()
  self.ProgramText.transform:GetChild(1).gameObject:AddMissingComponent(typeof(CS.Framework.TextFadeEffct))
end

function Tip_FloatTipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_FloatTipUI:OnHide()
end

function Tip_FloatTipUI:OnDestroy()
end

function Tip_FloatTipUI:RegistUIEvents()
end

function Tip_FloatTipUI:RegistEvents()
end

function Tip_FloatTipUI:Refresh()
end

function Tip_FloatTipUI:StopAnimate(item)
  if item.StartAni then
    Coroutine.Stop(item.StartAni)
    item.StartAni = nil
  end
  if item.StartCor then
    Coroutine.Stop(item.StartCor)
    item.StartCor = nil
  end
end

local publicVect2 = Vector2.zero

function Tip_FloatTipUI:StartAnimate(msgStr, item)
  local itemTF = item.transform
  local bg = itemTF:GetChild(0)
  if item.ProgramText == nil then
    item.ProgramText = UIControl(itemTF, "Text")
  end
  item.ProgramText:SetText(msgStr)
  local w = item.ProgramText.text.preferredWidth
  publicVect2:Set(w / 2, 0)
  bg.anchoredPosition = publicVect2
  local itemProgramTextTF = item.ProgramText.transform
  itemProgramTextTF.anchoredPosition = publicVect2
  publicVect2:Set(w, 18)
  bg.sizeDelta = publicVect2
  publicVect2:Set(w, 22)
  itemProgramTextTF.sizeDelta = publicVect2
  item.StartAni = Coroutine.Start(self.StartCoroutine, self, item)
end

function Tip_FloatTipUI:StartCoroutine(item)
  local itemTf = item.transform
  itemTf:GetChild(1).gameObject:SetActive(true)
  itemTf:GetChild(0).gameObject:SetActive(true)
  local graphics = itemTf:GetComponentInChildren(typeof(CS.Framework.TextFadeEffct))
  graphics:DoFade(1, FloatingWordUtility.Fade_Time)
  Coroutine.Wait(FloatingWordUtility.MSG_Time)
  item.StartCor = Coroutine.Start(self.WaitDelete, self, item)
end

function Tip_FloatTipUI:OpenCorWaitDelete(item)
  FloatingWordUtility.PoolDelete(item)
end

function Tip_FloatTipUI:WaitDelete(item)
  local itemTf = item.transform
  local graphics = itemTf:GetComponentInChildren(typeof(CS.Framework.TextFadeEffct))
  graphics:DoFade(0, FloatingWordUtility.Fade_Time)
  Coroutine.Wait(0.5)
  itemTf:GetChild(1).gameObject:SetActive(false)
  itemTf:GetChild(0).gameObject:SetActive(false)
  Coroutine.Wait(FloatingWordUtility.Fade_Time)
  self:StopAnimate(item)
  if item.ProgramText == nil then
    item.ProgramText = UIControl(itemTf:GetChild(0).transform, "Text")
  end
  FloatingWordUtility.TipFloatTipUIList:Remove(item)
  FloatingWordUtility.PoolDelete(item)
end

function Tip_FloatTipUI:SetTipsPos()
  local rootRect = self.root.rectTransform
  publicVect2:Set(0, 0)
  rootRect.anchorMin = publicVect2
  rootRect.anchorMax = publicVect2
  publicVect2:Set(157, 100)
  rootRect.anchoredPosition = publicVect2
end
