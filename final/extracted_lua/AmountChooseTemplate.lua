local AmountChooseTemplate = {}
AmountChooseTemplate.data = nil
AmountChooseTemplate.showNum = nil

function AmountChooseTemplate:Init()
  self:InitComponent()
  self:BindEvents()
end

function AmountChooseTemplate:InitComponent()
  self.btn_add = self:GetControl("btn_add")
  self.btn_minus = self:GetControl("btn_minus")
  self.lab_InputField = self:GetControl("lab_InputField")
end

function AmountChooseTemplate:BindEvents()
  self.lab_InputField:SetOnValueChanged(self, self.ValueChangeCallBack)
  self.btn_add:SetOnClick(self, self.Btn_AddOnClick)
  self.btn_minus:SetOnClick(self, self.Btn_MinusOnClick)
end

function AmountChooseTemplate:ValueChangeCallBack(control, data)
  local num = tonumber(data)
  if num == nil then
    num = 1
  end
  if num < self.data.MinNum then
    num = self.data.MinNum
  elseif num > self.data.MaxNum then
    num = self.data.MaxNum
  end
  if self.showNum ~= num then
    self.showNum = num
    self.lab_InputField:SetInputText(self.showNum)
  end
  if self.data.valueChangeCallBack ~= nil then
    self.data.valueChangeCallBack(self.data.inputData, self.showNum)
  end
end

function AmountChooseTemplate:Btn_AddOnClick()
  self.showNum = self.showNum + 1
  if self.showNum > self.data.MaxNum then
    self.showNum = self.data.MinNum
  end
  self.lab_InputField:SetInputText(self.showNum)
end

function AmountChooseTemplate:Btn_MinusOnClick()
  self.showNum = self.showNum - 1
  if self.showNum < self.data.MinNum then
    self.showNum = self.data.MaxNum
  end
  self.lab_InputField:SetInputText(self.showNum)
end

function AmountChooseTemplate:Refresh(data)
  if data == nil or data.MinNum == nil or data.MaxNum == nil then
    return
  end
  self.data = data
  self.showNum = self.data.defaultNum
  if self.showNum == nil then
    self.showNum = self.data.MinNum
  end
  self.lab_InputField:SetInputText(self.showNum)
  self:SetShowStage(true)
end

function AmountChooseTemplate:SetShowStage(stage)
  if type(stage) ~= "boolean" then
    return
  end
  self:UIControl():SetActive(stage)
end

return AmountChooseTemplate
