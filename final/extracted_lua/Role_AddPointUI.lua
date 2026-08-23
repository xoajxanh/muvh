Role_AddPointUI = class(BaseUI)
Role_AddPointUI.layer = UILayer.Tip
Role_AddPointUI.orderInLayer = 0
Role_AddPointUI.hideType = UIHideType.WaitDestroy
Role_AddPointUI.hideFunc = UIHideFunc.MoveOutOfScreen
Role_AddPointUI.escClose = UIEscClose.DontClose

function Role_AddPointUI:InitControls()
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.btn_closeBg = self:GetControl("Panel_Tip/btn_closeBg")
  self.Image_TipBg = self:GetControl("Panel_Tip/Image_TipBg")
  self.btn_close = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.img_title = self:GetControl("Panel_Tip/Image_TipBg/panel_01/img_title")
  self.img_title2 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/img_title2")
  self.txtCount = self:GetControl("Panel_Tip/Image_TipBg/panel_01/lab_Password/bg/txtCount")
  self.btn_1 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_1")
  self.btn_2 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_2")
  self.btn_3 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_3")
  self.btn_4 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_4")
  self.btn_5 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_5")
  self.btn_6 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_6")
  self.btn_7 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_7")
  self.btn_8 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_8")
  self.btn_9 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_9")
  self.btn_no = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_no")
  self.btn_0 = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_0")
  self.btn_yes = self:GetControl("Panel_Tip/Image_TipBg/panel_01/content/btn_yes")
end

function Role_AddPointUI:Init()
end

function Role_AddPointUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Role_AddPointUI:InitUI()
  self:InitData()
  self:BindBtnEvent()
end

function Role_AddPointUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_no:SetOnClick(self, self.btn_noOnClick)
  self.btn_yes:SetOnClick(self, self.btn_yesOnClick)
end

function Role_AddPointUI:InitData()
  self.btnList = {
    [1] = self.btn_1,
    [2] = self.btn_2,
    [3] = self.btn_3,
    [4] = self.btn_4,
    [5] = self.btn_5,
    [6] = self.btn_6,
    [7] = self.btn_7,
    [8] = self.btn_8,
    [9] = self.btn_9,
    [0] = self.btn_0
  }
  self.btn_1.number = 1
  self.btn_2.number = 2
  self.btn_3.number = 3
  self.btn_4.number = 4
  self.btn_5.number = 5
  self.btn_6.number = 6
  self.btn_7.number = 7
  self.btn_8.number = 8
  self.btn_9.number = 9
  self.btn_0.number = 0
  self.inputNumber = 0
  self.preAddMapData = {}
end

function Role_AddPointUI:BindBtnEvent()
  if self.btnList and table.count(self.btnList) > 0 then
    for i, v in pairs(self.btnList) do
      v:SetOnClick(self, self.InputPointOnClick)
    end
  end
end

function Role_AddPointUI:InputPointOnClick(control)
  if self.argsData == nil or control.number == nil then
    return
  end
  local validAttributePoint = QuickFind.LuaMainPlayerViewAttrData().validAttributePoint
  local preInputNumber = self.inputNumber
  local lastAllInputNumber = self:GetAllLastInputNumber()
  local lastInputNumber = self.preAddMapData[self.argsData.control.attrType] or 0
  local curInputNumber = control.number > 9 and 9 or control.number < 0 and 0 or control.number
  preInputNumber = tonumber(tostring(preInputNumber) .. tostring(curInputNumber))
  if self.argsData.state == CAttributeAddPointState.AddAttribute then
    self.inputNumber = preInputNumber >= validAttributePoint - lastAllInputNumber and validAttributePoint - lastAllInputNumber or preInputNumber
    self.addAttributePointEmpty = self.inputNumber >= validAttributePoint - lastAllInputNumber and true or false
  elseif self.argsData.state == CAttributeAddPointState.ReduceAttribute then
    self.inputNumber = lastInputNumber <= preInputNumber and lastInputNumber or preInputNumber
    self.reduceAttributePointEmpty = lastInputNumber <= self.inputNumber and true or false
  end
  self:RefreshPointText()
end

function Role_AddPointUI:GetAllLastInputNumber()
  local allInputNumber = 0
  if self.preAddMapData == nil then
    return allInputNumber
  end
  for i, v in pairs(self.preAddMapData) do
    allInputNumber = allInputNumber + v
  end
  return allInputNumber
end

function Role_AddPointUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Role_AddPointUI)
end

function Role_AddPointUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Role_AddPointUI)
end

function Role_AddPointUI:btn_noOnClick(control)
  self:RevokeInputNumber()
end

function Role_AddPointUI:RevokeInputNumber()
  local inputStr = tostring(self.inputNumber)
  local numLength = string.len(inputStr)
  if numLength <= 1 then
    self.inputNumber = 0
  else
    self.inputNumber = tonumber(string.sub(inputStr, 1, numLength - 1))
  end
  self:RefreshPointText()
end

function Role_AddPointUI:btn_yesOnClick(control)
  if self.argsData == nil then
    return
  end
  if self.addAttributePointEmpty or self.reduceAttributePointEmpty then
    UIManager.Hide(UIID.Role_AddPointUI)
  end
  EventManager.Dispatch(Event.RoleAddAttributeChanged, {
    pointNumber = self.inputNumber,
    state = self.argsData.state,
    control = self.argsData.control
  })
  self:ResetInputPointAndText()
end

function Role_AddPointUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Role_AddPointUI:RegistEvents()
  self:RegistEvent(Event.RolePreAddMapChanged, self.RolePreAddMapChanged, self)
end

function Role_AddPointUI:Refresh()
  if self.args == nil then
    logError("Tham s\225\187\145 \196\145\225\186\167u v\195\160o r\225\187\151ng")
    return
  end
  self.argsData = self.args
  self:ResetInputPointAndText()
  self:RefreshTitle()
end

function Role_AddPointUI:ResetInputPointAndText()
  self.inputNumber = 0
  self.addAttributePointEmpty = false
  self.reduceAttributePointEmpty = false
  self:RefreshPointText()
end

function Role_AddPointUI:RefreshTitle()
  local state = self.argsData.state
  self.img_title:SetActive(state == CAttributeAddPointState.AddAttribute)
  self.img_title2:SetActive(state == CAttributeAddPointState.ReduceAttribute)
end

function Role_AddPointUI:RefreshPointText()
  self.txtCount:SetText(self.inputNumber)
end

function Role_AddPointUI:RolePreAddMapChanged(_, data)
  if data == nil then
    logError("D\225\187\175 li\225\187\135u thay \196\145\225\187\149i \196\145i\225\187\131m trong b\225\187\153 c\225\187\153ng \196\145i\225\187\131m b\225\187\139 r\225\187\151ng")
    return
  end
  self.preAddMapData = data.preAddMapData
end

function Role_AddPointUI:OnHide()
end

function Role_AddPointUI:OnDestroy()
end
