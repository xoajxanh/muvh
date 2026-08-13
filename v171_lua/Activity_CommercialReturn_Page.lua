local Activity_CommercialReturn_Page = {}
Activity_CommercialReturn_Page.activityData = nil

function Activity_CommercialReturn_Page:Init()
  self:InitControls()
end

function Activity_CommercialReturn_Page:InitControls()
  self.img_clickeffect = self:GetControl("img_clickeffect")
  self.lab_name = self:GetControl("lab_name")
  self.img_redPoint = self:GetControl("img_redPoint")
end

function Activity_CommercialReturn_Page:Refresh(data, ui)
  self.lab_name:SetText(data.commerceName)
  self.img_clickeffect:SetActive(data.Selected)
  local redPoint = ReturnActivityData.ReturnRedPointData[data.group]
  self.img_redPoint:SetActive(redPoint)
  self:UIControl().data = data
  self:UIControl():SetOnClick(ui, ui.BtnReturnOnClick)
  self.basePanel = ui
end

function Activity_CommercialReturn_Page:GetRedPointPath()
  return self.basePanel.root.gameObject.name .. "#" .. self:UIControl().gameObject.name
end

function Activity_CommercialReturn_Page:SetClickEffect(isActive)
  self.img_clickeffect:SetActive(isActive)
end

function Activity_CommercialReturn_Page:BindRedPoint()
  self:RemoveCacheRedPoint()
  if self.activityData == nil or self.activityData:GetRedPointTbl() == nil then
    return
  end
  self.redPointId = self.activityData:GetRedPointTbl().id
  self.redPointPath = self:GetRedPointPath()
  EventManager.Dispatch(Event.AddRedPointGoByClient, {
    id = self.redPointId,
    path = self.redPointPath,
    go = self.img_redPoint.gameObject
  })
end

function Activity_CommercialReturn_Page:RemoveCacheRedPoint(checkSameRedPoint)
  if self.redPointId ~= nil and self.redPointPath ~= nil then
    if checkSameRedPoint == true and self.activityData:GetRedPointTbl() ~= nil and self.redPointId == self.activityData:GetRedPointTbl().id then
      return
    end
    EventManager.Dispatch(Event.RemoveRedPointGoByClient, {
      id = self.redPointId,
      path = self.redPointPath
    })
    self.redPointId = nil
    self.redPointPath = nil
  end
end

function Activity_CommercialReturn_Page:Exit()
  self:RemoveCacheRedPoint()
end

return Activity_CommercialReturn_Page
