local LuckyRebateDesTemplate = {}

function LuckyRebateDesTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:BindUIEvent()
end

function LuckyRebateDesTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.Label = self:GetControl("Label")
  self.Eff_UI_liuguang_kuang = self:GetControl("Eff_UI_liuguang_kuang")
  self.img_redPoint = self:GetControl("img_redPoint")
  self.Background = self:GetControl("Background")
end

function LuckyRebateDesTemplate:InitContainer()
end

function LuckyRebateDesTemplate:InitData()
end

function LuckyRebateDesTemplate:BindUIEvent()
  self.nowControl:SetOnToggleChanged(self, self.ToggleCallBack)
end

function LuckyRebateDesTemplate:ToggleCallBack(control)
  local controlState = control:GetIsOn()
  if controlState then
    EventManager.Dispatch(Event.LuckyRebateToggleChange, {
      data = self.data,
      isPlayAnim = false
    })
  end
end

function LuckyRebateDesTemplate:Refresh(data)
  if data == nil then
    return
  end
  self.data = data
  if not string.isNullOrEmpty(data.des) then
    self.Label:SetText(data.des)
  end
  self.Eff_UI_liuguang_kuang:SetActive(data.state == GuardRewardStateEnum.CanGet)
  self.img_redPoint:SetActive(data.state == GuardRewardStateEnum.CanGet)
  if data.state == GuardRewardStateEnum.Got then
    self.Background:SetColor("0x808080FF")
  else
    self.Background:SetColor("0xFFFFFFFF")
  end
end

function LuckyRebateDesTemplate:SetIsOn(isOn)
  self.nowControl:SetIsOn(isOn)
end

function LuckyRebateDesTemplate:GetIsOn()
  return self.nowControl:GetIsOn()
end

function LuckyRebateDesTemplate:Exit()
end

return LuckyRebateDesTemplate
