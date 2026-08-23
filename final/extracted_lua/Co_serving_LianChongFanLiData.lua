local Co_serving_LianChongFanLiData = {}
setmetatable(Co_serving_LianChongFanLiData, LuaClass.CommerceActivity)

function Co_serving_LianChongFanLiData:GetGearsInfoList()
  if self.mGearsInfoList == nil then
    self.mGearsInfoList = {}
  end
  return self.mGearsInfoList
end

function Co_serving_LianChongFanLiData:GetTaskInfoDic()
  if self.mTaskInfoDic == nil then
    self.mTaskInfoDic = {}
  end
  return self.mTaskInfoDic
end

function Co_serving_LianChongFanLiData:GetTaskRewardStateDic()
  if self.mTaskRewardStateDic == nil then
    self.mTaskRewardStateDic = {}
  end
  return self.mTaskRewardStateDic
end

function Co_serving_LianChongFanLiData:RereshDataByServerData(data)
  if data == nil or table.count(data) == 0 then
    return
  end
  local LianxuTbl
  local isNeedCallRedPoint, isNeedCallUI, lastState, curState = false
  local isHaveGears = table.count(self:GetGearsInfoList()) > 1
  for i, v in pairs(data) do
    LianxuTbl = ClientTable.cfg_Commerce_lianxuManager:TryGetValue(v.taskId)
    if LianxuTbl ~= nil then
      if not isHaveGears then
        self:TrySetGearInfo(LianxuTbl)
        isNeedCallUI = true
      end
      if self:GetTaskInfoDic()[v.taskId] == nil then
        self:GetTaskInfoDic()[v.taskId] = self:NewTaskInfo(LianxuTbl)
      end
      lastState = self:GetTaskRewardStateDic()[v.taskId]
      curState = self:GetRewardStateByGiftInfo(v.giftInfo[1], v.extra)
      if not isNeedCallUI and lastState ~= curState then
        isNeedCallUI = true
      end
      if not isNeedCallRedPoint and (lastState == nil or lastState * curState < 0) then
        isNeedCallRedPoint = true
      end
      self:GetTaskRewardStateDic()[v.taskId] = curState
    end
  end
  if not isHaveGears then
    self:SortGearTbl()
  end
  if isNeedCallRedPoint then
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.combineActivity_lianchong
    })
    EventManager.Dispatch(Event.CoServeLCFLRefreshRedPointView)
  end
  if isNeedCallUI then
    EventManager.Dispatch(Event.CoServeLCFLRefreshView)
  end
end

function Co_serving_LianChongFanLiData:TrySetGearInfo(tbl)
  for i, v in pairs(self:GetGearsInfoList()) do
    if v.group == tbl.group then
      if tbl.title and string.isNullOrEmpty(v.title) then
        v.title = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(tbl.title)
      end
      for i2, v2 in pairs(v.taskList) do
        if v2 == tbl.id then
          return
        end
      end
      table.insert(v.taskList, tbl.id)
      return
    end
  end
  table.insert(self:GetGearsInfoList(), self:NewGearsInfo(tbl))
end

function Co_serving_LianChongFanLiData:GetTaskInfoByTaskId(taskId)
  return self:GetTaskInfoDic()[taskId]
end

function Co_serving_LianChongFanLiData:GetTaskRewardStateByTaskId(taskId)
  return self:GetTaskRewardStateDic()[taskId] or ELCFLRewardState.NotGet
end

function Co_serving_LianChongFanLiData:NewGearsInfo(tbl)
  if tbl == nil then
    return
  end
  local temp = {}
  temp.title = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(tbl.title)
  temp.group = tbl.group
  temp.taskList = {}
  table.insert(temp.taskList, tbl.id)
  return temp
end

function Co_serving_LianChongFanLiData:NewTaskInfo(tbl)
  local temp = {}
  temp.id = tbl.id
  temp.des = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(tbl.describe)
  temp.order = tbl.same
  temp.giftId = tbl.giftId
  temp.rewardInfo = self:GetRewardListByGiftId(tbl.giftId)
  return temp
end

function Co_serving_LianChongFanLiData:GetRewardListByGiftId(giftId)
  local rewardList = {}
  local tbl = ClientTable.cfg_Gift_giftManager:TryGetValue(giftId)
  if tbl ~= nil then
    local allBoxTbl = ClientTable.cfg_Box_boxManager:TryGetTabListByType(tbl.reward, "boxId")
    for i, v in pairs(allBoxTbl) do
      if v.condition == nil or ConditionManager.Check4D(v.condition) then
        table.insert(rewardList, v)
      end
    end
  end
  return rewardList
end

function Co_serving_LianChongFanLiData:GetRewardStateByGiftInfo(data, extra)
  if not data.canGet and not string.isNullOrEmpty(extra) then
    return ELCFLRewardState.GoRecharge
  elseif data.canGet and data.roleCount < 1 then
    return ELCFLRewardState.CanGet
  elseif data.canGet and data.roleCount >= 1 then
    return ELCFLRewardState.Geted
  else
    return ELCFLRewardState.NotGet
  end
end

function Co_serving_LianChongFanLiData:SortGearTbl()
  local function taskRuler(a, b)
    local taska = self:GetTaskInfoDic()[a]
    
    local taskb = self:GetTaskInfoDic()[b]
    return taska and taskb and taska.order < taskb.order
  end
  
  for i, v in pairs(self:GetGearsInfoList()) do
    table.sort(v.taskList, taskRuler)
  end
  table.sort(self:GetGearsInfoList(), function(a, b)
    return a.group < b.group
  end)
end

function Co_serving_LianChongFanLiData:CheckRedPointStateByGroup(group)
  for i, v in pairs(self:GetGearsInfoList()) do
    if v.group == group then
      for i2, v2 in pairs(v.taskList) do
        if self:GetTaskRewardStateDic()[v2] == ELCFLRewardState.CanGet then
          return true
        end
      end
    end
  end
end

function Co_serving_LianChongFanLiData:CheckRedPointState()
  for i, v in pairs(self:GetTaskRewardStateDic()) do
    if v == ELCFLRewardState.CanGet then
      return true
    end
  end
  return false
end

function Co_serving_LianChongFanLiData:ResetActivityData()
  self.mGearsInfoList = {}
  self.mTaskInfoDic = {}
  self.mTaskRewardStateDic = {}
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.combineActivity_lianchong
  })
end

return Co_serving_LianChongFanLiData
