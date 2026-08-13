local Bag_SellInfoConfigItemTemplate = {}

function Bag_SellInfoConfigItemTemplate:Init()
  self.lb_recoverName = self:GetControl("lb_recoverName")
  self.tog_recover = self:GetControl("tog_recover")
  self.dp_recover = self:GetControl("dp_recover")
  self.tog_forceRecover = self:GetControl("tog_forceRecover")
  self.transfer = {}
end

function Bag_SellInfoConfigItemTemplate:Refresh(data, ui)
  self.args = data
  self.lb_recoverName:SetText(data.createName)
  local togCinfig = BagSellController.GetCurrRecycleTogConfigById(data.sellId, data.id)
  if togCinfig == nil then
    return
  end
  self.tog_recover.toggle.isOn = togCinfig.right or false
  self.tog_recover:SetOnToggleChanged(self, self.Tog_recoverOnCliek)
  self.tog_forceRecover.toggle.isOn = togCinfig.upFight or false
  self.tog_forceRecover:SetOnToggleChanged(self, self.Tog_forceRecoverOnClieck)
  if data.paramtype == RecycleParamType.Switch then
    self.dp_recover:SetActive(false)
  else
    self.dp_recover:SetActive(true)
    self.dp_recover:RemoveAllOnDropDownListeners()
    if self.dpType == nil or self.dpType ~= data.paramtype then
      self.dp_recover:ClearOptions()
      local options = BagSellController.GetParamtypeTypeOptions(data.paramtype)
      local openstemp = {}
      for i = 1, #options do
        if options ~= "" then
          table.insert(openstemp, options[i])
        end
      end
      self.dp_recover:AddOptions(openstemp)
      self.dpType = data.paramtype
    end
    self.dp_recover:SetSelectValue(tonumber(togCinfig.param1) - 1)
    self.dp_recover:SetOnDropDownValueChanged(self, self.OnDropDownValueChangedCallback)
  end
end

function Bag_SellInfoConfigItemTemplate:Tog_forceRecoverOnClieck(control, status)
  BagSellController.SetUpFightById(self.args.sellId, self.args.id, status)
  EventManager.Dispatch(Event.Bag_SellInfoConfigTog)
end

function Bag_SellInfoConfigItemTemplate:Tog_recoverOnCliek(control, status)
  BagSellController.SetSellInfoConfigTogStatus(self.args.sellId, self.args.id, status)
  EventManager.Dispatch(Event.Bag_SellInfoConfigTog)
end

function Bag_SellInfoConfigItemTemplate:OnDropDownValueChangedCallback(ui, index)
  BagSellController.SetSellInfoConfigOption(self.args.sellId, self.args.id, index)
  EventManager.Dispatch(Event.Bag_SellInfoConfigTog)
end

return Bag_SellInfoConfigItemTemplate
