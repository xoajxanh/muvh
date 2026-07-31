require("GameModel/Activity_LuoLanSiegeData")
require("GameConst/FilterModeEnum")
Activity_LuoLanSiegeController = {}
local this = Activity_LuoLanSiegeController

function Activity_LuoLanSiegeController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function Activity_LuoLanSiegeController.RegistMessages()
  this.messageContainer:Regist(MapMessage.ResSystemInstance_LuoLanXiaGu, this.ResLuoLanSiegeStart)
  this.messageContainer:Regist(MapMessage.ResInstanceRewardMessage_LuoLanXiaGuGongCheng, this.ResGetSiegeReward)
  this.messageContainer:Regist(MapMessage.ResSystemInstance_LuoLanXiaGuGongChengActivity_Trap, this.ResTraps)
  this.messageContainer:Regist(ActivityMessage.ResGetLuoLanXiaGuGongChengActivityWinUnion, this.ResGetWinUnion)
  this.messageContainer:Regist(ActivityMessage.ResActivityUnions, this.ResActivityUnions)
  this.messageContainer:Regist(ActivityMessage.ResLuoLanXiaGuGongChengActivityScoreRank, this.ResLuoLanXiaGuGongChengScoreRank)
  this.messageContainer:Regist(ActivityMessage.ResGongChengSafe, this.ResGongChengSafe)
end

function Activity_LuoLanSiegeController.ResGongChengSafe(id, msg)
  Activity_LuoLanSiegeData.UpdateGongChengSafe(msg)
end

function Activity_LuoLanSiegeController.ResLuoLanSiegeStart(id, msg)
  Activity_LuoLanSiegeData.InitData(msg)
end

function Activity_LuoLanSiegeController.ResGetWinUnion(id, msg)
  Activity_LuoLanSiegeData.InitUnionWinData(msg)
end

function Activity_LuoLanSiegeController.ResGetSiegeReward(id, msg)
end

function Activity_LuoLanSiegeController.ResActivityUnions(id, msg)
  Activity_LuoLanSiegeData.InitUnionData(msg)
end

function Activity_LuoLanSiegeController.ResLuoLanXiaGuGongChengScoreRank(id, msg)
  Activity_LuoLanSiegeData.InitScoreData(msg)
end

function Activity_LuoLanSiegeController.ResTraps(id, trapMsg)
  if RoleManager.me.cellPos.y >= 50 and RoleManager.me.cellPos.y <= 175 then
    if not trapMsg then
      return
    end
    for i, v in ipairs(trapMsg.traps) do
      Activity_LuoLanSiegeData.AddTrap(v)
    end
  end
end

function Activity_LuoLanSiegeController.RegistEvent()
  this.eventContainer:Regist(Event.Scene_SceneDataChange, this.OnMapChange)
end

function Activity_LuoLanSiegeController.OnMapChange(id, mapId)
  if mapId ~= 1031001 and Activity_LuoLanSiegeData.activityStatus == ActivityStatusEnum.RUNNING then
    EventManager.Dispatch(Event.QuitSiege)
    Activity_LuoLanSiegeData.activityStatus = ActivityStatusEnum.INIT
    EventManager.Dispatch(Event.PKModeChanged)
  end
end
