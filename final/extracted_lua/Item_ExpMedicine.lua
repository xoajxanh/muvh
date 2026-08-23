Item_ExpMedicine = class(BaseUI)
Item_ExpMedicine.layer = UILayer.Tip
Item_ExpMedicine.orderInLayer = 3
Item_ExpMedicine.hideType = UIHideType.WaitDestroy
Item_ExpMedicine.hideFunc = UIHideFunc.MoveOutOfScreen
Item_ExpMedicine.escClose = UIEscClose.DontClose

function Item_ExpMedicine:InitControls()
  self.bg_ornamentsBreach = self:GetControl("bg_ornamentsBreach")
  self.btn_close = self:GetControl("bg_ornamentsBreach/btn_close")
  self.lab_title = self:GetControl("bg_ornamentsBreach/lab_title")
  self.btn_bg = self:GetControl("btn_bg")
  self.btn_use = self:GetControl("Panel_ExpMedicine/btn_use")
  self.input_number = self:GetControl("Panel_ExpMedicine/input_number")
  self.btn_plus = self:GetControl("Panel_ExpMedicine/input_number/btn_plus")
  self.btn_minus = self:GetControl("Panel_ExpMedicine/input_number/btn_minus")
  self.lab_expGet = self:GetControl("Panel_ExpMedicine/Text_exp/lab_expGet")
  self.normal_use = self:GetControl("Panel_ExpMedicine/type_choose/normal_use")
  self.triple_use = self:GetControl("Panel_ExpMedicine/type_choose/triple_use")
  self.lab_triTime = self:GetControl("Panel_ExpMedicine/type_choose/triple_use/lab_triTime")
  self.triple_detail = self:GetControl("Panel_ExpMedicine/triple_time/triple_detail")
end

function Item_ExpMedicine:OnPreLoad()
end

function Item_ExpMedicine:Init()
end

function Item_ExpMedicine:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Item_ExpMedicine:InitUI()
end

function Item_ExpMedicine:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Item_ExpMedicine:OnHide()
  self.normal_use:SetIsOn(true)
end

function Item_ExpMedicine:OnDestroy()
end

function Item_ExpMedicine:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_bg:SetOnClick(self, self.btn_bgOnClick)
  self.btn_use:SetOnClick(self, self.btn_useOnClick)
  self.btn_plus:SetOnClick(self, self.btn_plusOnClick)
  self.btn_minus:SetOnClick(self, self.btn_minusOnClick)
  self.input_number:SetOnEndEdit(self, self.ChangeTextWhenEditEnd)
  self.normal_use:SetOnToggleChanged(self, self.NormalUseOnClick)
  self.triple_use:SetOnToggleChanged(self, self.TripleUseOnClick)
end

function Item_ExpMedicine:btn_closeOnClick(control)
  UIManager.Hide(UIID.Item_ExpMedicine)
end

function Item_ExpMedicine:btn_bgOnClick(control)
  UIManager.Hide(UIID.Item_ExpMedicine)
end

function Item_ExpMedicine:btn_useOnClick(control)
  local useItemTbl = {
    useCount = self.num,
    useItemId = self.args.item.id,
    configId = self.args.item.itemId
  }
  if self.triple_use:GetIsOn() then
    useItemTbl.params = {"3"}
  end
  ItemUtility.UseItem(useItemTbl)
  UIManager.Hide(UIID.Item_ExpMedicine)
end

function Item_ExpMedicine:NormalUseOnClick(control)
  if not control:GetIsOn() then
    return
  end
  self:UpdateLabGetExp()
end

function Item_ExpMedicine:SetTriTime()
end

function Item_ExpMedicine:TripleUseOnClick(control)
  if not control:GetIsOn() then
    return
  end
  self:UpdateLabGetExp()
  self:SetTriTime()
end

function Item_ExpMedicine:ChangeTextWhenEditEnd(control)
  local text = control:GetInputText()
  if text == "" then
    self.num = 1
    control:SetInputText(1)
  else
    local count = BagInfoData.GetItemCountByItemConfigId(self.args.item.itemId)
    local num = tonumber(text)
    num = num <= 0 and 1 or num
    num = count < num and count or num
    self.num = num
    control:SetInputText(num)
  end
  self:UpdateTriToggle()
  self:UpdateLabGetExp()
  self:SetTriTime()
end

function Item_ExpMedicine:UpdateInfo()
  self.input_number:SetInputText(self.num)
  self:UpdateLabGetExp()
  self:SetTriTime()
end

function Item_ExpMedicine:btn_plusOnClick(control)
  local nums = tonumber(self.input_number:GetInputText())
  local count = BagInfoData.GetItemCountByItemConfigId(self.args.item.itemId)
  nums = count >= nums + 1 and nums + 1 or count
  self.num = nums
  self:UpdateInfo()
  self:UpdateTriToggle()
end

function Item_ExpMedicine:UpdateTriToggle()
end

function Item_ExpMedicine:btn_minusOnClick(control)
  local nums = tonumber(self.input_number:GetInputText())
  nums = nums - 1 > 0 and nums - 1 or 1
  self.num = nums
  self:UpdateInfo()
  self:UpdateTriToggle()
end

function Item_ExpMedicine:RegistEvents()
end

function Item_ExpMedicine:Refresh()
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(self.args.item.itemId)
  self.lab_title:SetText(itemConfig.name)
  local expPara = string.split(itemConfig.useParam, "#")
  self.singleExp = tonumber(expPara[2])
  self.threeTimesConsumeTime = tonumber(expPara[3])
  self:UpdateUI()
end

function Item_ExpMedicine:GetConsumeExp()
  if self.normal_use:GetIsOn() then
    return self.num * self.singleExp
  else
    return self.num * self.singleExp * 3
  end
end

function Item_ExpMedicine:UpdateLabGetExp()
  if not self.triple_use:GetIsOn() then
    self.lab_expGet:SetText(self.num * self.singleExp)
  else
    self.lab_expGet:SetText(self.num * self.singleExp * 3)
  end
end

function Item_ExpMedicine:UpdateUI()
  self.num = 1
  self.triple_use:SetInteractable(false)
  self.normal_use:SetIsOn(true)
  self.input_number:SetInputText(self.num)
  self:UpdateLabGetExp()
end
