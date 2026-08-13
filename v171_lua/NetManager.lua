NetManager = require("LuaCore/Event/EventManagerBase")
local this = NetManager
local HEART_BEAT_INTERVAL = 15
local CHECK_CLIENT_TIME_INTERVAL = 5
local HEART_BEAT_DISCONNECT_COUNT = 3
local Debug = CS.UnityEngine.Debug
local isDebugBuild = Debug.isDebugBuild
NetManager.isNeedSendGmMessage = false
NetManager.BlockList = {}

function NetManager.Init()
  isDebugBuild = not MuInterfaceLua.Instance:IsSDKDevelopApk()
  this.tcp = CS.Framework.NetManager.instance
  this.tcp:SetOnReceiveAction(this.Recv)
  this.tcp:SetOnDisconnectAction(this.OnDisconnect)
  NetManager.InitPackageNet()
  EventManager.Regist(Event.Game_ApplicationQuit, this.Destroy)
  EventManager.Regist(Event.Game_Restart, this.Destroy)
end

function NetManager.InitPackageNet()
  require("LuaCore/Net/PackageNet/PackageNetSend/NetworkRequest")
  require("LuaCore/Net/PackageNet/PackageNetRecv/NetMsgPreverifying")
end

function NetManager.Update()
  this.UpdateHeartBeat()
  this.OnClientTimeCheck()
end

function NetManager.Connect(host, port)
  this.tcp:Connect(host, port, this.OnConnect)
end

function NetManager.OnConnect(success)
  if success then
    EventManager.Dispatch(Event.Net_ConnectSuccess)
  else
    EventManager.Dispatch(Event.Net_ConnectFailed)
  end
  this.lastHeartBeatTime = 0
  this.heartBeatCount = 0
  this.clientTimeCheck = 0
end

function NetManager.OnDisconnect()
  this.lastHeartBeatTime = nil
  this.clientTimeCheck = nil
  EventManager.Dispatch(Event.Net_Disconnect)
end

function NetManager.Close()
  this.lastHeartBeatTime = nil
  this.clientTimeCheck = nil
  this.tcp:Close()
end

function NetManager.Destroy()
  this.tcp:SetOnReceiveAction(nil)
  this.tcp:SetOnDisconnectAction(nil)
  this.tcp:Close()
end

function NetManager.IsConnect()
  return this.tcp and this.tcp:IsConnect()
end

function NetManager.GetMessageName(id)
  return table.getKey(MessageIDToName, id)
end

function NetManager.Send(id, message)
  if isDebugBuild and not table.contains(NetManager.BlockList, id) and CS.Main.instance.IsShowLog then
    print("<color=#00FF00> [NET][\232\175\183\230\177\130]", MessageIDToName[id] ~= nil and MessageIDToName[id] or id, table.toString(message, true), Time.time, this.tcp:IsConnect(), "</color>")
  end
  if id == nil then
    logError("ID tin nh\225\186\175n y\195\170u c\225\186\167u \196\145\195\163 b\225\187\139 m\195\161y ch\225\187\167 thay \196\145\225\187\149i, h\195\163y x\225\187\173 l\195\189 ngay" .. debug.traceback())
    return
  end
  local buffer = message and Protobuf.Encode(MessageIDToName[id], message) or nil
  this.tcp:Send(id, buffer)
  if LuaClass.GMSocket and gameMgr:GetGMDataMgr() and gameMgr:GetGMDataMgr():GetReceiveState() then
    local netMessage = {
      type = GM_DataEnum.NetWork,
      typeName = string.GetColorText("Y\195\170u c\225\186\167u c\225\187\167a m\195\161y kh\195\161ch", ItemQuality2ColorDic[25]),
      id = id,
      messageIdToName = string.GetColorText(MessageIDToName[id], ItemQuality2ColorDic[25]),
      tableContent = table.DeepCopy(message),
      time = string.format("%s:%s", os.date("%Y-%m-%d %H:%M:%S", math.floor(LuaClass.GMSocket.gettime())), string.sub(string.split(tostring(LuaClass.GMSocket.gettime()), ".")[2], 1, 3)),
      index = 0
    }
    gameMgr:GetGMDataMgr():UpdateMessageData(netMessage)
  end
end

function NetManager.Recv(id, sequence, pBuffer, size)
  local message
  local protoName = MessageIDToName[id]
  if protoName then
    message = Protobuf.DecodeFast(protoName, pBuffer, size)
  end
  if LuaClass.GMSocket and gameMgr:GetGMDataMgr() and gameMgr:GetGMDataMgr():GetReceiveState() then
    local netMessage = {
      type = GM_DataEnum.NetWork,
      typeName = string.GetColorText("\196\144\195\163 nh\225\186\173n \196\145\198\176\225\187\163c m\195\161y kh\195\161ch", ItemQuality2ColorDic[5]),
      id = id,
      messageIdToName = string.GetColorText(MessageIDToName[id], ItemQuality2ColorDic[5]),
      tableContent = table.DeepCopy(message),
      time = string.format("%s:%s", os.date("%Y-%m-%d %H:%M:%S", math.floor(LuaClass.GMSocket.gettime())), string.sub(string.split(tostring(LuaClass.GMSocket.gettime()), ".")[2], 1, 3)),
      index = 0
    }
    gameMgr:GetGMDataMgr():UpdateMessageData(netMessage)
  end
  if isDebugBuild and not table.contains(NetManager.BlockList, id) and CS.Main.instance.IsShowLog then
    print("<color=#00F8FF> [NET][\230\142\165\230\148\182]", id, MessageIDToName[id], table.toString(message, true), Time.time, "</color>")
  end
  if id == UserMessage.ResHeart then
    this.OnResHeartMessage(id, message)
  end
  this.Dispatch(id, message)
  if netMsgPreprocessing ~= nil and type(netMsgPreprocessing[id]) == "function" then
    netMsgPreprocessing[id](id, message)
  end
  local recycleTime = GetMessageRecycleTime(id)
  if recycleTime then
    this.RecycleMessage(message, recycleTime)
  end
end

function NetManager.GetTempMessage(id)
  return Protobuf.GetTemp(MessageIDToName[id])
end

function NetManager.RecycleMessage(message, recycleTime)
  return Protobuf.Recycle(message, recycleTime)
end

local testCount = 1

function NetManager.UpdateHeartBeat()
  if not this.lastHeartBeatTime then
    return
  end
  local time = Time.unscaledTime - this.lastHeartBeatTime
  if time > HEART_BEAT_INTERVAL then
    if this.heartBeatCount < HEART_BEAT_DISCONNECT_COUNT then
      this.lastHeartBeatTime = Time.unscaledTime
      this.heartBeatCount = this.heartBeatCount + 1
      this.Send(UserMessage.ReqHeart, {
        clientTime = math.floor(Time.unscaledTime * 1000)
      })
    else
      logPurple("\196\144\195\163 b\225\186\175t \196\145\225\186\167u k\225\186\191t n\225\187\145i l\225\186\161i khi ng\225\186\175t k\225\186\191t n\225\187\145i")
      testCount = 1
      this.Close()
      this.OnDisconnect()
    end
  end
end

function NetManager.OnClientTimeCheck(time)
  if this.clientTimeCheck == nil then
    return
  end
  local time = Time.unscaledTime - this.clientTimeCheck
  if time >= CHECK_CLIENT_TIME_INTERVAL then
    this.clientTimeCheck = Time.unscaledTime
    NetManager.Send(CommonMessage.ReqClientTimeCheck)
  end
end

function NetManager.OnResHeartMessage(id, msg)
  this.heartBeatCount = 0
  Time.SetServerTime(msg.nowTime)
  this.delay = Time.unscaledTime - msg.clientTime / 1000
end

NetManager.Init()
