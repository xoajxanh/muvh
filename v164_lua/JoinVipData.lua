local JoinVipData = {}
JoinVipData.JoinDataInt = nil
JoinVipData.frequency = 0

function JoinVipData:Init()
  self.JoinDataInt = {}
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.Join_VIP
  })
end

function JoinVipData:RefreshJoinDataInt()
  self.JoinDataInt = ServerDataRecordData.GetIntRecordData(SerRecordIntType.JoinVIPOpen)
end

function JoinVipData:SetSendSaveData()
  if self.frequency == 0 and self.JoinDataInt ~= 1 then
    ServerDataRecordData.SendSaveData({
      dataInt = {
        [SerRecordIntType.JoinVIPOpen] = 1
      }
    })
    self.frequency = self.frequency + 1
    EventManager.Dispatch(Event.JoinVIPRedPoint)
  end
end

function JoinVipData:RefreshRedPoint()
  if self.JoinDataInt and self.JoinDataInt == 1 then
    return false
  end
  return true
end

return JoinVipData
