Puzzle_JH_NavUI = class(BaseUI)
Puzzle_JH_NavUI.layer = UILayer.Panel
Puzzle_JH_NavUI.orderInLayer = 0
Puzzle_JH_NavUI.hideType = UIHideType.WaitDestroy
Puzzle_JH_NavUI.hideFunc = UIHideFunc.MoveOutOfScreen
Puzzle_JH_NavUI.escClose = UIEscClose.DontClose
local this = Puzzle_JH_NavUI

function Puzzle_JH_NavUI:InitControls()
  self.tog_xiangqian = self:GetControl("go_JH_Group/tog_xiangqian")
  self.tog_jinjie = self:GetControl("go_JH_Group/tog_jinjie")
  self.tog_qianghua = self:GetControl("go_JH_Group/tog_qianghua")
  self.tog_zhuanyi = self:GetControl("go_JH_Group/tog_zhuanyi")
  self.tog_fenjie = self:GetControl("go_JH_Group/tog_fenjie")
  self.tog_jieshao = self:GetControl("go_JH_Group/tog_jieshao")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.SubPanelRootTwo = self:GetControl("SubPanelRootTwo")
end

function Puzzle_JH_NavUI:Init()
  self.UITab = {
    UIID.Puzzle_JH_XiangqianUI,
    UIID.Puzzle_JH_JinjieUI,
    UIID.Puzzle_JH_QianghuaUI,
    UIID.Puzzle_JH_ZhuanyiUI,
    UIID.Puzzle_JH_FenjieUI,
    UIID.Puzzle_JH_JieshaoUI
  }
end

function Puzzle_JH_NavUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Puzzle_JH_NavUI:InitUI()
  self.TogObjTab = {
    [UIID.Puzzle_JH_XiangqianUI] = self.tog_xiangqian,
    [UIID.Puzzle_JH_JinjieUI] = self.tog_jinjie,
    [UIID.Puzzle_JH_QianghuaUI] = self.tog_qianghua,
    [UIID.Puzzle_JH_ZhuanyiUI] = self.tog_zhuanyi,
    [UIID.Puzzle_JH_FenjieUI] = self.tog_fenjie,
    [UIID.Puzzle_JH_JieshaoUI] = self.tog_jieshao
  }
  self.TogSort = {
    [1] = UIID.Puzzle_JH_XiangqianUI,
    [2] = UIID.Puzzle_JH_JinjieUI,
    [3] = UIID.Puzzle_JH_QianghuaUI,
    [4] = UIID.Puzzle_JH_ZhuanyiUI,
    [5] = UIID.Puzzle_JH_FenjieUI,
    [6] = UIID.Puzzle_JH_JieshaoUI
  }
end

function Puzzle_JH_NavUI:RegistUIEvents()
  self.tog_xiangqian:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_jinjie:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_qianghua:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_zhuanyi:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_fenjie:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_jieshao:SetOnToggleChanged(self, self.OnToggleChanged)
end

function Puzzle_JH_NavUI:OnToggleChanged(control, isOn)
  if self.tog_xiangqian.toggle.isOn then
    if not UIManager.IsVisible(UIID.Puzzle_JH_XiangqianUI) then
      UIManager.Show(UIID.Puzzle_JH_XiangqianUI, {resetLogic = 1})
      self.CurUI = UIID.Puzzle_JH_XiangqianUI
    end
  elseif self.tog_jinjie.toggle.isOn then
    if not UIManager.IsVisible(UIID.Puzzle_JH_JinjieUI) then
      UIManager.Show(UIID.Puzzle_JH_JinjieUI, {resetLogic = 1})
      self.CurUI = UIID.Puzzle_JH_JinjieUI
    end
  elseif self.tog_qianghua.toggle.isOn then
    if not UIManager.IsVisible(UIID.Puzzle_JH_QianghuaUI) then
      UIManager.Show(UIID.Puzzle_JH_QianghuaUI, {resetLogic = 1})
      self.CurUI = UIID.Puzzle_JH_QianghuaUI
    end
  elseif self.tog_zhuanyi.toggle.isOn then
    if not UIManager.IsVisible(UIID.Puzzle_JH_ZhuanyiUI) then
      UIManager.Show(UIID.Puzzle_JH_ZhuanyiUI, {resetLogic = 1})
      self.CurUI = UIID.Puzzle_JH_ZhuanyiUI
    end
  elseif self.tog_fenjie.toggle.isOn then
    if not UIManager.IsVisible(UIID.Puzzle_JH_FenjieUI) then
      UIManager.Show(UIID.Puzzle_JH_FenjieUI, {resetLogic = 1})
      self.CurUI = UIID.Puzzle_JH_FenjieUI
    end
  elseif self.tog_jieshao.toggle.isOn and not UIManager.IsVisible(UIID.Puzzle_JH_JieshaoUI) then
    UIManager.Show(UIID.Puzzle_JH_JieshaoUI, {resetLogic = 1})
    self.CurUI = UIID.Puzzle_JH_JieshaoUI
  end
  if isOn then
    EventManager.Dispatch(Event.CrystalNucleusNavChange)
  end
end

function Puzzle_JH_NavUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  if self.args == nil then
    return
  end
  if self.args.uiID == "Puzzle_JH_QianghuaUI" then
    self.tog_qianghua:SetIsOn(true)
  elseif self.args.uiID == "Puzzle_JH_JinjieUI" then
    self.tog_jinjie:SetIsOn(true)
  end
end

function Puzzle_JH_NavUI:RegistEvents()
  self:RegistEvent(Event.JumpToCrystalNucleusDecomposition, self.OnJumpToCrystalNucleusDecomposition)
end

function Puzzle_JH_NavUI:OnJumpToCrystalNucleusDecomposition()
  this.tog_fenjie:SetIsOn(true)
end

function Puzzle_JH_NavUI:Refresh()
  self:ResetToggle()
  self.CurUI = UIID.Puzzle_JH_XiangqianUI
  if self.args and self.args.openFirstTab and self.UITab then
    self.CurUI = self.UITab[self.args.openFirstTab]
    if self.CurUI then
      UIManager.Show(self.CurUI, {resetLogic = 1})
    end
  else
    self:SetFirstUIID()
  end
  self:ToggleInit()
end

function Puzzle_JH_NavUI:ResetToggle()
  for i, v in pairs(self.TogObjTab) do
    v.toggle.isOn = false
  end
end

function Puzzle_JH_NavUI:SetFirstUIID()
  local toggleControl, targetUIID
  local isFirst = true
  for i, v in ipairs(self.TogSort) do
    toggleControl = self.TogObjTab[v]
    if not IsNil(toggleControl.gameObject) then
      if isFirst then
        targetUIID = v
        isFirst = false
      end
      if RedPointManager:GetCacheStateByPath("Puzzle_JH_NavUI#" .. toggleControl.transform.name) then
        targetUIID = v
        break
      end
    end
  end
  self.CurUI = targetUIID
  UIManager.Show(self.CurUI, {resetLogic = 1})
end

function Puzzle_JH_NavUI:ToggleInit()
  for i, v in pairs(self.TogObjTab) do
    if i == self.CurUI then
      v.toggle.isOn = true
    end
  end
end

function Puzzle_JH_NavUI:OnHide()
  self.CurUI = nil
end

function Puzzle_JH_NavUI:OnDestroy()
end
