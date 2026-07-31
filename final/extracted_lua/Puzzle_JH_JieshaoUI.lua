Puzzle_JH_JieshaoUI = class(BaseUI)
Puzzle_JH_JieshaoUI.layer = UILayer.Panel
Puzzle_JH_JieshaoUI.orderInLayer = 0
Puzzle_JH_JieshaoUI.hideType = UIHideType.WaitDestroy
Puzzle_JH_JieshaoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Puzzle_JH_JieshaoUI.escClose = UIEscClose.DontClose

function Puzzle_JH_JieshaoUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.btn_close = self:GetControl("btn_close")
  self.sw_Jh_Item = self:GetControl("sw_Jh_Item")
  self.Content = self:GetControl("sw_Jh_Item/Viewport/Content")
end

function Puzzle_JH_JieshaoUI:Init()
end

function Puzzle_JH_JieshaoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Puzzle_JH_JieshaoUI:InitUI()
end

function Puzzle_JH_JieshaoUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Puzzle_JH_JieshaoUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Puzzle_JH_JieshaoUI)
end

function Puzzle_JH_JieshaoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Puzzle_JH_JieshaoUI:RegistEvents()
end

function Puzzle_JH_JieshaoUI:Refresh()
  self.Content.transform:GetComponent("ContentSizeFitter").enabled = false
  local itemCount = self.Content.transform.childCount
  local w, h = self.Content:GetSizeDelta()
  self.Content:SetSizeDelta(w, itemCount * 16)
end

function Puzzle_JH_JieshaoUI:OnHide()
end

function Puzzle_JH_JieshaoUI:OnDestroy()
end
