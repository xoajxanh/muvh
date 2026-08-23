Tip_DefectPromptTipUI = class(BaseUI)
Tip_DefectPromptTipUI.layer = UILayer.Tooltip
Tip_DefectPromptTipUI.orderInLayer = 5
Tip_DefectPromptTipUI.hideType = UIHideType.WaitDestroy
Tip_DefectPromptTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_DefectPromptTipUI.escClose = UIEscClose.DontClose

function Tip_DefectPromptTipUI:InitControls()
  self.Image_DefectPromptTipBg = self:GetControl("Image_DefectPromptTipBg")
  self.img_DownBubbleArrow = self:GetControl("Image_DefectPromptTipBg/img_DownBubbleArrow")
  self.img_UpBubbleArrow = self:GetControl("Image_DefectPromptTipBg/img_UpBubbleArrow")
  self.lab_DefectPromptTipContent = self:GetControl("Image_DefectPromptTipBg/lab_DefectPromptTipContent")
end

function Tip_DefectPromptTipUI:OnPreLoad()
end

function Tip_DefectPromptTipUI:Init()
end

function Tip_DefectPromptTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_DefectPromptTipUI:InitUI()
  local BgPosY = self.Image_DefectPromptTipBg.rectTransform.sizeDelta.y / 2
  local ArrowPosY = self.img_DownBubbleArrow.rectTransform.sizeDelta.y
  self.MovePosY = BgPosY + ArrowPosY
  self.detween = {}
end

function Tip_DefectPromptTipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_DefectPromptTipUI:OnHide()
  if self.StartCor then
    Coroutine.Stop(self.StartCor)
    self.StartCor = nil
  end
  for i, v in pairs(self.detween) do
    v:Kill()
  end
end

function Tip_DefectPromptTipUI:OnDestroy()
end

function Tip_DefectPromptTipUI:RegistUIEvents()
end

function Tip_DefectPromptTipUI:RegistEvents()
end

function Tip_DefectPromptTipUI:Refresh()
  self.lab_DefectPromptTipContent:SetText(self.args.msgStr)
  local bgWidth = self.lab_DefectPromptTipContent.text.preferredWidth * 1.2
  local bgheight = self.Image_DefectPromptTipBg.rectTransform.sizeDelta.y
  self.Image_DefectPromptTipBg:SetSizeDelta(bgWidth, bgheight)
  local PosYMove = self.args.PosY + self.MovePosY
  if self.args.Dir then
    self.Image_DefectPromptTipBg.transform.localPosition = Vector3.New(0, -PosYMove, 0)
    self.img_DownBubbleArrow:SetActive(false)
    self.img_UpBubbleArrow:SetActive(true)
  else
    self.Image_DefectPromptTipBg.transform.localPosition = Vector3.New(0, PosYMove, 0)
    self.img_DownBubbleArrow:SetActive(true)
    self.img_UpBubbleArrow:SetActive(false)
  end
  self.StartCor = Coroutine.Start(self.WaitDelete, self)
end

function Tip_DefectPromptTipUI:WaitDelete()
  local graphics = self.root.transform:GetComponentsInChildren(typeof(CS.UnityEngine.UI.MaskableGraphic))
  for i = 0, graphics.Length - 1 do
    if graphics[i].name ~= "Eff_UI_annuikuang" then
      graphics[i].color = Color.New(graphics[i].color.r, graphics[i].color.g, graphics[i].color.b, 255)
      local tween = graphics[i]:DOFade(0, FloatingWordUtility.MSG_BtnTime)
      self.detween[i + 1] = tween
    end
  end
  Coroutine.Wait(FloatingWordUtility.MSG_BtnTime)
  UIManager.Hide(UIID.TipDefectPromptTipUI)
end
