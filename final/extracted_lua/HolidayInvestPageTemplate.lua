local HolidayInvestPageTemplate = {}

function HolidayInvestPageTemplate:Init(data)
  self.goCallBack = data.goCallBack
  self:InitControls()
  self:BindUIEvent()
end

function HolidayInvestPageTemplate:InitControls()
  self.img_ClickEffect = self:GetControl("img_clickeffect")
  self.lab_Name = self:GetControl("lab_name")
  self.img_redPoint = self:GetControl("img_redPoint")
end

function HolidayInvestPageTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.ClickGoCallBack)
end

function HolidayInvestPageTemplate:ClickGoCallBack()
  if self.goCallBack then
    self.goCallBack(self.data)
  end
end

function HolidayInvestPageTemplate:Refresh(data, ui)
  self.data = data
  self.parent = ui
  self:RefreshPageName()
end

function HolidayInvestPageTemplate:RefreshPageName()
  local positionTitleGlobal = CommercialHolidayData.GetCommerce_globalFun(317002)
  if not string.isNullOrEmpty(positionTitleGlobal) then
    local titleTab = string.split(positionTitleGlobal, "#")
    self.lab_Name:SetText(titleTab[self.data.position])
  end
end

function HolidayInvestPageTemplate:SetSelectFrameDisplayAndRedPoint(isSelect)
  self.img_ClickEffect:SetActive(isSelect)
  self.img_redPoint:SetActive(QuickFind:GetHolidayInvestData():PositionRedPointCheck(self.data.position))
end

return HolidayInvestPageTemplate
