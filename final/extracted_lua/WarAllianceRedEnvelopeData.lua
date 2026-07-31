local WarAllianceRedEnvelopeData = {}
WarAllianceRedEnvelopeData.RedEnvelopeData = nil

local function SortRedEnvelopeData(a, b)
  if a.robFinish ~= b.robFinish then
    return a.robFinish == true and true or false
  elseif a.receiveState ~= b.receiveState then
    return a.receiveState == false and true or false
  elseif a.receiveState == true and b.receiveState == true then
    return a.getTime > b.getTime
  elseif a.receiveState == false and b.receiveState == false then
    return a.sendTime > b.sendTime
  end
end

function WarAllianceRedEnvelopeData:Init()
  self.RedEnvelopeData = nil
end

function WarAllianceRedEnvelopeData:RefreshRedEnvelopeData(data)
  if data == nil then
    return
  end
  self.RedEnvelopeData = data.redPacketList
  for index, itemRedEnvelopeData in pairs(self.RedEnvelopeData) do
    local receiveState, thankState, rewardCount, getTime = false, false, 0, 0
    local roleId = RoleManager.me.id
    for i, v in pairs(itemRedEnvelopeData.info) do
      if v.rid == roleId then
        receiveState = true
        thankState = v.state == 1 and true or false
        rewardCount = v.rewardCount
        getTime = v.getTime
        break
      end
    end
    itemRedEnvelopeData.robFinish = 0 < itemRedEnvelopeData.lastCount and true or false
    itemRedEnvelopeData.receiveState = receiveState
    itemRedEnvelopeData.thankState = thankState
    itemRedEnvelopeData.rewardCount = rewardCount
    itemRedEnvelopeData.getTime = getTime
  end
  table.sort(self.RedEnvelopeData, SortRedEnvelopeData)
  EventManager.Dispatch(Event.WarAllianceRedEnvelopeChange)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.activity_redpacket
  })
end

function WarAllianceRedEnvelopeData:JudgeRedPointState()
  local roleId = RoleManager.me.id
  if table.count(self.RedEnvelopeData) > 0 and WarAllianceData.IsHaveUnion == true then
    for index, itemRedEnvelopeData in pairs(self.RedEnvelopeData) do
      local canGet = true
      if 0 < itemRedEnvelopeData.lastCount then
        for i, v in pairs(itemRedEnvelopeData.info) do
          if v.rid == roleId then
            canGet = false
            break
          end
        end
        if canGet then
          return true
        end
      end
    end
  end
  return false
end

function WarAllianceRedEnvelopeData:GetRedEnvelopeData()
  return self.RedEnvelopeData
end

function WarAllianceRedEnvelopeData:GetRedEnvelopeCount()
  return table.count(self.RedEnvelopeData)
end

return WarAllianceRedEnvelopeData
