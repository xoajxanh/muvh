ServerDataRecordData = {}
local this = ServerDataRecordData
SerRecordIntType = {
  autoBuyDrugOpen = enum(10001),
  autoRecycleOpen = enum(),
  autoPickupOpen = enum(),
  archerDirection = enum(20001),
  joined = enum(),
  ArchangeOpen = enum(40001),
  ArchangeBlessOpen = enum(40002),
  ArchangeChristmasOpen = enum(40003),
  BingJianSpringFestivalOpen = enum(40004),
  BingJianDianYiOpen = enum(40005),
  exchangeOpen = enum(50001),
  BingJianYuanTianYueBaiOpen = enum(50010),
  BingJianBeachPartyOpen = enum(50011),
  JoinVIPOpen = enum(50012)
}
ServerDataRecordData.SaveData = {
  dataInt = {},
  dataString = {}
}

function ServerDataRecordData.GetIntRecordData(index)
  return ServerDataRecordData.SaveData.dataInt[index]
end

function ServerDataRecordData.GetStringRecordData(index)
  return ServerDataRecordData.SaveData.dataString[index]
end

function ServerDataRecordData.IntDataChange(index, data)
  if not index then
    return
  end
  for i, v in pairs(ServerDataRecordData.SaveData.dataInt) do
    if index == i then
      v = data
      break
    end
  end
  ServerDataRecordData.SaveData.dataInt[index] = data
end

function ServerDataRecordData.StringDataChange(index, data)
  if not index then
    return
  end
  for i, v in pairs(ServerDataRecordData.SaveData.dataString) do
    if index == i then
      v = data
      return
    end
  end
  ServerDataRecordData.SaveData.dataString[index] = data
end

function ServerDataRecordData.SendSaveData(data)
  NetManager.Send(RoleMessage.ReqSaveClientData, data)
end

function ServerDataRecordData.InitFun()
  PlayerControlForceData.RefreshAutoBuyDrugState()
  PlayerControlForceData.RefreshAutoRecycleState()
  PlayerControlForceData.RefreshAutoPickupState()
  PlayerControlForceData.RefreshSuitOpenState()
  PlayerControlForceData.RefreshExchangeOpenState()
  QuickFind:GetJoinVipManager():RefreshJoinDataInt()
end

function ServerDataRecordData.Init()
end
