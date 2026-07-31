Bag_SellInfoConfigUI = class(BaseUI)
Bag_SellInfoConfigUI.layer = UILayer.Panel
Bag_SellInfoConfigUI.orderInLayer = 0
Bag_SellInfoConfigUI.hideType = UIHideType.WaitDestroy
Bag_SellInfoConfigUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_SellInfoConfigUI.escClose = UIEscClose.DontClose

function Bag_SellInfoConfigUI:InitControls()
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.lab_recover_txt = self:GetControl("img_bg/img_recover_txt/lab_recover_txt")
  self.sw_recoverConfig = self:GetControl("img_bg/sw_recoverConfig")
  self.Content = self:GetControl("img_bg/sw_recoverConfig/Viewport/Content")
  self.tog_recover = self:GetControl("img_bg/sw_recoverConfig/Viewport/Content/RecoverConfig/tog_recover")
  self.dp_recover = self:GetControl("img_bg/sw_recoverConfig/Viewport/Content/RecoverConfig/dp_recover")
  self.RecoverConfig = self:GetControl("img_bg/sw_recoverConfig/Viewport/Content/RecoverConfig")
  self.dp_allRecover = self:GetControl("img_bg/Content/dp_allRecover")
  self.tog_allRecover = self:GetControl("img_bg/Content/tog_allRecover")
  self.lb_allName = self:GetControl("img_bg/Content/lb_allName")
end

function Bag_SellInfoConfigUI:Init()
end

function Bag_SellInfoConfigUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Bag_SellInfoConfigUI:InitUI()
  self.recoverConfigTemp = UIUtility.BindUIContainerTemp(self.RecoverConfig, LuaComponentTemplates.Bag_SellInfoConfigItemTemplate, self)
end

function Bag_SellInfoConfigUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Bag_SellInfoConfigUI:btn_closeOnClick(control)
  self.args = nil
  UIManager.Hide(UIID.Bag_SellInfoConfigUI)
  UIManager.Show(UIID.BagSellInfoUI, {npcConfigID = 0})
end

function Bag_SellInfoConfigUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Bag_SellInfoConfigUI:RegistEvents()
  self:RegistEvent(Event.Bag_SellInfoConfigUI, self.OnRefresh, self)
  self:RegistEvent(Event.Bag_SellInfoConfigTog, self.RefreshAllTog, self)
end

function Bag_SellInfoConfigUI:OnRefresh(_, args)
  self.args = args
  self:Refresh()
end

function Bag_SellInfoConfigUI:RefreshAllTog()
  if self.args == nil or table.isNullOrEmpty(self.args) then
    return
  end
  local allActive = BagSellController.CheckSellConfigUIAllTogConfig(self.args[1].sellId)
  if self.args[1].paramtype == RecycleParamType.Switch then
    self.dp_allRecover:SetActive(false)
  else
    self.dp_allRecover:SetActive(true)
    self.dp_allRecover:RemoveAllOnDropDownListeners()
    if self.paramtype == nil or self.paramtype ~= self.args[1].paramtype then
      self.dp_allRecover:ClearOptions()
      local options = BagSellController.GetParamtypeTypeOptions(self.args[1].paramtype)
      table.insert(options, 1, CS.UnityEngine.UI.Dropdown.OptionData(" "))
      self.dp_allRecover:AddOptions(options)
      self.paramtype = self.args[1].paramtype
    end
    local index = 0
    local config = BagSellController.GetCurrRecycleTogConfigById(self.args[1].sellId, self.args[1].id)
    local configs = BagSellController.GetBagSellInfoUITogConfigs(self.args[1].sellId)
    if configs ~= nil and config ~= nil then
      index = config.param1
      for i, v in pairs(configs) do
        if v.param1 ~= index then
          index = 0
          break
        end
      end
    end
    self.dp_allRecover:SetSelectValue(index)
    self.dp_allRecover:SetOnDropDownValueChanged(self, self.OnDropDownValueChanged)
  end
  self.tog_allRecover:SetOnToggleChanged(self, function()
  end)
  self.tog_allRecover.toggle.isOn = allActive
  self.tog_allRecover:SetOnToggleChanged(self, self.OnToggleChanged)
end

function Bag_SellInfoConfigUI:OnDropDownValueChanged(control, option)
  if self.args == nil then
    return
  end
  BagSellController.SetSellInfoConfigAllOption(self.args[1].sellId, option - 1)
  self:Refresh()
end

function Bag_SellInfoConfigUI:OnToggleChanged(control, isOn)
  if self.args == nil then
    return
  end
  BagSellController.SetSellInfoConfigAllTogStatus(self.args[1].sellId, isOn)
  self:Refresh()
end

function Bag_SellInfoConfigUI:Refresh()
  if self.args == nil then
    return
  end
  self.lab_recover_txt:SetText(self.args[1].name)
  self.recoverConfigTemp:Refresh()
  self.recoverConfigTemp:SetData(self.args)
  self:RefreshAllTog()
end

function Bag_SellInfoConfigUI:OnHide()
end

function Bag_SellInfoConfigUI:OnDestroy()
end
