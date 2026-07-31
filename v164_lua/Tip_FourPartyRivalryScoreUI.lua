Tip_FourPartyRivalryScoreUI = class(BaseUI)
Tip_FourPartyRivalryScoreUI.layer = UILayer.Panel
Tip_FourPartyRivalryScoreUI.orderInLayer = 0
Tip_FourPartyRivalryScoreUI.hideType = UIHideType.WaitDestroy
Tip_FourPartyRivalryScoreUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_FourPartyRivalryScoreUI.escClose = UIEscClose.DontClose

function Tip_FourPartyRivalryScoreUI:InitControls()
  self.ProgramText = self:GetControl("ProgramText")
end

function Tip_FourPartyRivalryScoreUI:Init()
end

function Tip_FourPartyRivalryScoreUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_FourPartyRivalryScoreUI:InitUI()
end

function Tip_FourPartyRivalryScoreUI:RegistUIEvents()
end

function Tip_FourPartyRivalryScoreUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_FourPartyRivalryScoreUI:RegistEvents()
end

function Tip_FourPartyRivalryScoreUI:Refresh()
end

function Tip_FourPartyRivalryScoreUI:StartAnimate(_msgStr, _programText)
  if _programText.ProgramText == nil then
    _programText.ProgramText = UIControl(_programText.transform, "Text")
  end
  _programText.ProgramText:SetText(_msgStr)
  _programText.StartAni = Coroutine.Start(self.StartCoroutine, self, _programText)
end

function Tip_FourPartyRivalryScoreUI:StartCoroutine(_programText)
  local graphics = _programText.transform:GetComponentsInChildren(typeof(CS.UnityEngine.UI.MaskableGraphic))
  for i = 0, graphics.Length - 1 do
    graphics[i].color = Color.New(graphics[i].color.r, graphics[i].color.g, graphics[i].color.b, 0)
    if i == 0 then
      graphics[i]:DOFade(0.5, FourPartyRivalryScoreTipUtility.m_FadeTime)
    else
      graphics[i]:DOFade(1, FourPartyRivalryScoreTipUtility.m_FadeTime)
    end
  end
  Coroutine.Wait(FourPartyRivalryScoreTipUtility.m_MSGTime)
  for i = 0, graphics.Length - 1 do
    if i == 0 then
      graphics[i]:DOFade(0, FourPartyRivalryScoreTipUtility.m_FadeTime)
    else
      graphics[i]:DOFade(0, FourPartyRivalryScoreTipUtility.m_FadeTime)
    end
  end
  FourPartyRivalryScoreTipUtility.m_ProgramTextList:Remove(_programText)
  FourPartyRivalryScoreTipUtility:PoolDelete(_programText)
  self:StopAnimate(_programText)
end

function Tip_FourPartyRivalryScoreUI:StopAnimate(_programText)
  if _programText.StartAni then
    Coroutine.Stop(_programText.StartAni)
    _programText.StartAni = nil
  end
end

function Tip_FourPartyRivalryScoreUI:OnHide()
end

function Tip_FourPartyRivalryScoreUI:OnDestroy()
end
