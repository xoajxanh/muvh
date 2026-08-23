local Activity_CommercialCombine_Page = {}
Activity_CommercialCombine_Page.activityData = nil

function Activity_CommercialCombine_Page:Init()
  self:InitControls()
  self:BindUIEvent()
end

function Activity_CommercialCombine_Page:InitControls()
  self.lab_name = self:GetControl("lab_name")
  self.img_redPoint = self:GetControl("img_redPoint")
end

function Activity_CommercialCombine_Page:BindUIEvent()
  self:UIControl():SetOnToggleChanged(self, self.ToggleCallBack)
end

function Activity_CommercialCombine_Page:ToggleCallBack(control)
  local controlState = control:GetIsOn()
  if controlState then
    EventManager.Dispatch(Event.CommerceCombineActivityPageOpen, self.activityData)
  else
    EventManager.Dispatch(Event.CommerceCombineActivityPageClose, self.activityData)
  end
end

function Activity_CommercialCombine_Page:Refresh(data, ui)
  if self:AnalysisParams(data, ui) == false then
    self:UIControl():SetActive(false)
    return
  end
  self:RefreshName()
  self:BindRedPoint()
end

function Activity_CommercialCombine_Page:AnalysisParams(data, ui)
  if data == nil or data.activityTbl == nil then
    return false
  end
  self.activityData = data
  self.basePanel = ui
  return true
end

function Activity_CommercialCombine_Page:RefreshName()
  self.lab_name:SetText(self.activityData:GetActivityName())
  if self.activityData:GetRedPointTbl() ~= nil then
    self:UIControl().gameObject.name = self.activityData:GetRedPointTbl().IdEnum
  end
end

function Activity_CommercialCombine_Page:GetRedPointPath()
  return self.basePanel.root.gameObject.name .. "#" .. self:UIControl().gameObject.name
end

function Activity_CommercialCombine_Page:SetIsOn()
  self:UIControl():SetIsOn(true)
end

function Activity_CommercialCombine_Page:GetIsOn()
  return self:UIControl():GetIsOn()
end

function Activity_CommercialCombine_Page:BindRedPoint()
  self:RemoveCacheRedPoint(true)
  if self.activityData:GetRedPointTbl() == nil then
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

function Activity_CommercialCombine_Page:RemoveCacheRedPoint(checkSameRedPoint)
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

function Activity_CommercialCombine_Page:Exit()
  self:RemoveCacheRedPoint()
end

return Activity_CommercialCombine_Page
