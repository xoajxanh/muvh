superpositionSucceedUI = class(BaseUI)
superpositionSucceedUI.layer = UILayer.Dialog
superpositionSucceedUI.orderInLayer = 4
superpositionSucceedUI.hideType = UIHideType.WaitDestroy
superpositionSucceedUI.hideFunc = UIHideFunc.MoveOutOfScreen
superpositionSucceedUI.escClose = UIEscClose.DontClose

function superpositionSucceedUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_Item = self:GetControl("Middel/lab_rewards/btn_Item")
  self.btn_ok = self:GetControl("Middel/btn_ok")
  self.lab_excellence1 = self:GetControl("Middel/lab_excellence/lab_excellence1")
  self.lab_excellence2 = self:GetControl("Middel/lab_excellence/lab_excellence2")
  self.lab_excellence3 = self:GetControl("Middel/lab_excellence/lab_excellence3")
  self.lab_excellenceNew = self:GetControl("Middel/lab_excellence/lab_excellenceNew")
end

function superpositionSucceedUI:OnPreLoad()
end

function superpositionSucceedUI:Init()
end

function superpositionSucceedUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function superpositionSucceedUI:InitUI()
  self.OldExcellenceShow = {
    [1] = self.lab_excellence1,
    [2] = self.lab_excellence2,
    [3] = self.lab_excellence3
  }
end

function superpositionSucceedUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function superpositionSucceedUI:OnHide()
end

function superpositionSucceedUI:OnDestroy()
end

function superpositionSucceedUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_Item:SetOnClick(self, self.btn_ItemOnClick)
  self.btn_ok:SetOnClick(self, self.btn_okOnClick)
end

function superpositionSucceedUI:btn_closeBgOnClick(control)
end

function superpositionSucceedUI:btn_ItemOnClick(control)
end

function superpositionSucceedUI:btn_okOnClick(control)
  UIManager.Hide(UIID.superpositionSucceedUI)
end

function superpositionSucceedUI:RegistEvents()
end

function superpositionSucceedUI:Refresh()
  self:SetPanel()
end

function superpositionSucceedUI:SetPanel()
  local newExcellenceID = {}
  for k, v in pairs(self.args[1].excellence) do
    if not table.contains(ForgeData.OverlapItem, v) then
      table.insert(newExcellenceID, v)
    end
  end
  local ExcellenceTab = RoleEquipUtility.GetEquipExcellence(ForgeData.OverlapItem)
  local newExcellence = RoleEquipUtility.GetEquipExcellence(newExcellenceID)
  local TabCount = table.count(ExcellenceTab)
  for i = 1, TabCount do
    self.OldExcellenceShow[i]:SetText(ExcellenceTab[i])
  end
  self.lab_excellenceNew:SetText(newExcellence[1])
  ItemUtility.ShowItem(self, self.btn_Item, self.args[1], true)
end
