local LianChongFanLiGearUnitTemplate = {}

function LianChongFanLiGearUnitTemplate:Init(data)
  self.ClickGoCallBack = data.clickGo
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function LianChongFanLiGearUnitTemplate:InitParams()
  self.parentTbl = nil
  self.gearInfo = nil
end

function LianChongFanLiGearUnitTemplate:InitControls()
  self.lab_name = self:GetControl("lab_name")
  self.img_clickeffect = self:GetControl("img_clickeffect")
  self.img_redPoint = self:GetControl("img_redPoint")
end

function LianChongFanLiGearUnitTemplate:BindUIEvent()
  self:GetControl():SetOnClick(self, self.ClickCallBack)
end

function LianChongFanLiGearUnitTemplate:ClickCallBack()
  if self.ClickGoCallBack ~= nil then
    self.ClickGoCallBack(self.parentTbl, self.gearInfo)
  end
end

function LianChongFanLiGearUnitTemplate:Refresh(data, ui)
  self.parentTbl = ui
  self.gearInfo = data
  self:RefreshView()
end

function LianChongFanLiGearUnitTemplate:RefreshView()
  self.lab_name:SetText(self.gearInfo and self.gearInfo.title or "")
  self:RefreshRedPoint()
end

function LianChongFanLiGearUnitTemplate:SetSelectViewByGroup(group)
  local isMeet = self.gearInfo and self.gearInfo.group == group
  self.img_clickeffect:SetActive(isMeet)
end

function LianChongFanLiGearUnitTemplate:SetGearByGroup(group)
  if self.gearInfo and self.gearInfo.group == group then
    self:ClickCallBack()
  end
end

function LianChongFanLiGearUnitTemplate:RefreshRedPoint()
  local isShow = false
  if self.gearInfo then
    isShow = QuickFind:Co_serving_LCFLData():CheckRedPointStateByGroup(self.gearInfo.group)
  end
  self.img_redPoint:SetActive(isShow)
end

return LianChongFanLiGearUnitTemplate
