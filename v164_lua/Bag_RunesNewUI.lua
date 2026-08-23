Bag_RunesNewUI = class(BaseUI)
Bag_RunesNewUI.layer = UILayer.Panel
Bag_RunesNewUI.orderInLayer = 0
Bag_RunesNewUI.hideType = UIHideType.WaitDestroy
Bag_RunesNewUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_RunesNewUI.escClose = UIEscClose.DontClose

function Bag_RunesNewUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Button_CloseBag = self:GetControl("Button_CloseBag")
  self.Line_1_light = self:GetControl("OtherView/LineParent/Line_1/light")
  self.Line_2_light = self:GetControl("OtherView/LineParent/Line_2/light")
  self.Line_3_light = self:GetControl("OtherView/LineParent/Line_3/light")
  self.Line_4_light = self:GetControl("OtherView/LineParent/Line_4/light")
  self.Line_5_light = self:GetControl("OtherView/LineParent/Line_5/light")
  self.Runes_1 = self:GetControl("OtherView/RunesItem/Runes_1")
  self.Runes_2 = self:GetControl("OtherView/RunesItem/Runes_2")
  self.Runes_3 = self:GetControl("OtherView/RunesItem/Runes_3")
  self.Runes_4 = self:GetControl("OtherView/RunesItem/Runes_4")
  self.Runes_5 = self:GetControl("OtherView/RunesItem/Runes_5")
  self.Runes_6 = self:GetControl("OtherView/RunesItem/Runes_6")
  self.Runes_7 = self:GetControl("OtherView/RunesItem/Runes_7")
end

function Bag_RunesNewUI:Init()
end

function Bag_RunesNewUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:InitParams()
  self:RegistUIEvents()
end

function Bag_RunesNewUI:InitUI()
  self.runeHoleTemplateList = {
    luaTemplateManager.GetNewTemplate(self.Runes_1, LuaComponentTemplates.RuneHoleTemplate, self),
    luaTemplateManager.GetNewTemplate(self.Runes_2, LuaComponentTemplates.RuneHoleTemplate, self),
    luaTemplateManager.GetNewTemplate(self.Runes_3, LuaComponentTemplates.RuneHoleTemplate, self),
    luaTemplateManager.GetNewTemplate(self.Runes_4, LuaComponentTemplates.RuneHoleTemplate, self),
    luaTemplateManager.GetNewTemplate(self.Runes_5, LuaComponentTemplates.RuneHoleTemplate, self),
    luaTemplateManager.GetNewTemplate(self.Runes_6, LuaComponentTemplates.RuneHoleTemplate, self),
    luaTemplateManager.GetNewTemplate(self.Runes_7, LuaComponentTemplates.RuneHoleTemplate, self)
  }
end

function Bag_RunesNewUI:InitParams()
  self.Lines = {
    self.Line_1_light,
    self.Line_2_light,
    self.Line_3_light,
    self.Line_4_light,
    self.Line_5_light
  }
end

function Bag_RunesNewUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.Button_CloseBag:SetOnClick(self, self.Button_CloseBagOnClick)
end

function Bag_RunesNewUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Bag_RunesNewUI)
end

function Bag_RunesNewUI:Button_CloseBagOnClick(control)
  UIManager.Hide(UIID.Bag_RunesNewUI)
end

function Bag_RunesNewUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:RefreshDefaultHoleChoose()
end

function Bag_RunesNewUI:RegistEvents()
  self:RegistEvent(Event.RefreshNewRuneHoleData, self.Refresh, self)
end

function Bag_RunesNewUI:Refresh()
  for index, template in ipairs(self.runeHoleTemplateList) do
    template:Refresh(index, self)
  end
  local curAllMeetCombination = ClientTable.cfg_Item_equip_NewRunesSuitManager:GetCurAllMeetCombination()
  for runesSuitEffect, line in pairs(self.Lines) do
    local runeCell = ClientTable.cfg_Item_equip_NewRunesComboManager:GetRuneCellByRunesSuitEffect(runesSuitEffect)
    if runeCell and curAllMeetCombination[runeCell] ~= nil then
      line:SetActive(true)
      local childCount = line.transform.childCount - 1
      for i = 0, childCount do
        local childeObj = line.transform:GetChild(i)
        childeObj.gameObject:SetActive(childeObj.name == curAllMeetCombination[runeCell].runesEffectColor)
      end
    else
      line:SetActive(false)
    end
  end
end

function Bag_RunesNewUI:RefreshDefaultHoleChoose()
  self.runeHoleTemplateList[1]:HoleOnClick()
end

function Bag_RunesNewUI:RefreshHoleChooseState()
  for i, template in pairs(self.runeHoleTemplateList) do
    template:RefreshChooseState()
  end
end

function Bag_RunesNewUI:OnHide()
  QuickFind.GetNewRuneDataManager():SetCurChooseHoleIndex(nil)
end
