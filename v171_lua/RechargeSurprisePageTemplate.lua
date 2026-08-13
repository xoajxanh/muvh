local RechargeSurprisePageTemplate = {}

function RechargeSurprisePageTemplate:Init(data)
  self.goCallBack = data.goCallBack
  self:InitControls()
  self:BindUIEvent()
end

function RechargeSurprisePageTemplate:InitControls()
  self.Checkmark = self:GetControl("Checkmark")
  self.Label = self:GetControl("Label")
end

function RechargeSurprisePageTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.ClickGoCallBack)
end

function RechargeSurprisePageTemplate:ClickGoCallBack()
  self.Checkmark:SetActive(true)
  if self.goCallBack then
    self.goCallBack(self.data)
  end
end

function RechargeSurprisePageTemplate:Refresh(data, ui)
  self.data = data
  self.parent = ui
end

function RechargeSurprisePageTemplate:SetSelectFrameDisplay(isShow)
  self.Checkmark:SetActive(isShow)
  self.Label:SetText(string.GetColorText(self.data.rechargeSurpriseConfig.giftName, isShow == true and "#f7f4ef" or "#dcc68c"))
end

return RechargeSurprisePageTemplate
