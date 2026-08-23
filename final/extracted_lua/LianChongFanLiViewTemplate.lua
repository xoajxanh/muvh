local LianChongFanLiViewTemplate = {}

function LianChongFanLiViewTemplate:Init(data)
  self.baseUI = data.baseUI
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
  self:InitContainer()
end

function LianChongFanLiViewTemplate:InitParams()
  self.parentTbl = nil
  self.gearInfo = nil
  self.curGroup = 0
  self.timeLoop = nil
end

function LianChongFanLiViewTemplate:InitControls()
  self.gearPage = self:GetControl("sw_rechangeGet/Viewport/Content/Btn_rechangeGet")
  self.taskUnit = self:GetControl("sw_spirtsrankList/Viewport/Content/img_datarankBg")
  self.timeLabel = self:GetControl("txt_lastTimeGift")
end

function LianChongFanLiViewTemplate:InitContainer()
  self.gearPageContainer = UIUtility.BindUIContainerTemp(self.gearPage, LuaComponentTemplates.LianChongFanLiGearUnitTemplate, self, {
    clickGo = self.ClickGearPageCallBack
  })
  self.taskContainer = UIUtility.BindUIContainerTemp(self.taskUnit, LuaComponentTemplates.LianChongFanLiTaskUnitTemplate, self, {
    baseUI = self.baseUI
  })
end

function LianChongFanLiViewTemplate:BindUIEvent()
end

function LianChongFanLiViewTemplate:ClickGearPageCallBack(gearInfo)
  if gearInfo == nil then
    return
  end
  if self.gearInfo ~= nil and self.gearInfo.group == gearInfo.group then
    return
  end
  self.curGroup = gearInfo.group
  self.gearInfo = gearInfo
  self:RefreshGearPageSelectView()
  self:RefreshTaskView()
end

function LianChongFanLiViewTemplate:OnCoServeLCFLRefreshView()
  self:TryRefresh()
end

function LianChongFanLiViewTemplate:OnCoServeLCFLRefreshRedPointView()
  self:RefreshGearPageRedPointView()
end

function LianChongFanLiViewTemplate:Refresh()
  EventManager.Dispatch(Event.CommerceCombineActivityClearJumpId, CommerceActivityIdType.LianChongFanLi)
  self:SendNetMessage()
  self:TryRefresh()
end

function LianChongFanLiViewTemplate:SendNetMessage()
  networkRequest.ReqGetCommercialActivityInfo(2, CommerceActivityIdType.LianChongFanLi)
end

function LianChongFanLiViewTemplate:TryRefresh()
  if self.gearInfo == nil then
    self:RefreshView()
  else
    self:RefreshGearPageRedPointView()
    self:RefreshTaskBtnView()
  end
end

function LianChongFanLiViewTemplate:RefreshView()
  self:RefreshGearPageView()
  self:InitGearTargetGroup()
  self:RefreshTimeView()
end

function LianChongFanLiViewTemplate:RefreshGearPageView()
  if self.gearPageContainer == nil then
    return
  end
  if QuickFind:Co_serving_LCFLData() then
    self.gearPageContainer:SetData(QuickFind:Co_serving_LCFLData():GetGearsInfoList())
  else
    self.gearPageContainer:SetData({})
  end
end

function LianChongFanLiViewTemplate:RefreshGearPageSelectView()
  if self.gearInfo == nil or self.gearPageContainer == nil then
    return
  end
  for i, v in pairs(self.gearPageContainer.items) do
    if v and v.itemTemp then
      v.itemTemp:SetSelectViewByGroup(self.gearInfo.group)
    end
  end
end

function LianChongFanLiViewTemplate:RefreshGearPageRedPointView()
  if self.gearPageContainer == nil then
    return
  end
  for i, v in pairs(self.gearPageContainer.items) do
    if v and v.itemTemp then
      v.itemTemp:RefreshRedPoint()
    end
  end
end

function LianChongFanLiViewTemplate:InitGearTargetGroup()
  self:SetTargetGearGroup()
  if self.curGroup == 0 then
    self:RefreshTaskView()
    return
  end
  for i, v in pairs(self.gearPageContainer.items) do
    if v and v.itemTemp then
      v.itemTemp:SetGearByGroup(self.curGroup)
    end
  end
end

function LianChongFanLiViewTemplate:SetTargetGearGroup()
  if self.curGroup == 0 and 0 < table.count(QuickFind:Co_serving_LCFLData():GetGearsInfoList()) then
    self.curGroup = QuickFind:Co_serving_LCFLData():GetGearsInfoList()[1].group
  end
  return self.curGroup
end

function LianChongFanLiViewTemplate:RefreshTaskView()
  if self.taskContainer and self.gearInfo and self.gearInfo.taskList then
    self.taskContainer:SetData(self.gearInfo.taskList)
  else
    self.taskContainer:SetData({})
  end
end

function LianChongFanLiViewTemplate:RefreshTaskBtnView()
  if self.taskContainer == nil then
    return
  end
  for i, v in pairs(self.taskContainer.items) do
    if v and v.itemTemp then
      v.itemTemp:RefreshBtnView()
    end
  end
end

function LianChongFanLiViewTemplate:RefreshTimeView()
  if self.timeLabel == nil or QuickFind:Co_serving_LCFLData() == nil then
    return
  end
  if self.timeLoop ~= nil then
    Timer.Stop(self.timeLoop)
  end
  self.timeLabel:SetText(QuickFind:Co_serving_LCFLData():GetRemainTimeDes())
  self.timeLoop = Timer.StartLoopForever(1, function()
    self.timeLabel:SetText(QuickFind:Co_serving_LCFLData():GetRemainTimeDes())
  end)
end

function LianChongFanLiViewTemplate:Exit()
  if self:IsJump() then
    return
  end
  self.curGroup = 0
  self.gearInfo = nil
  if self.timeLoop ~= nil then
    Timer.Stop(self.timeLoop)
    self.timeLoop = nil
  end
end

function LianChongFanLiViewTemplate:IsJump()
  if self.baseUI and self.baseUI.ForceJumpActivityPageId == CommerceActivityIdType.LianChongFanLi then
    return true
  end
  return false
end

return LianChongFanLiViewTemplate
