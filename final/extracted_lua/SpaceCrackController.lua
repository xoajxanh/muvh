require("GameModel/SpaceCrack/SpaceCrackConstant")
require("GameModel/SpaceCrack/SpaceCrackUtility")
SpaceCrackController = {}
local this = SpaceCrackController

function SpaceCrackController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function SpaceCrackController.RegistEvent()
  this.messageContainer:Regist(TimeCrackMessage.ResTimeCrackPanel, this.ResTimeCrackPanel)
  this.messageContainer:Regist(TimeCrackMessage.ResSpaceCrackPersonRank, this.ResSpaceCrackPersonRank)
  this.messageContainer:Regist(TimeCrackMessage.ResSpaceCrackUnionRank, this.ResSpaceCrackUnionRank)
  this.messageContainer:Regist(TimeCrackMessage.ResServerCrackUnionBuff, this.ResServerCrackUnionBuff)
  this.messageContainer:Regist(TimeCrackMessage.ResServerCrackBoss, this.ResServerCrackBoss)
  this.messageContainer:Regist(MapMessage.ResSpaceCrackTask, this.ResSpaceCrackTask)
  this.messageContainer:Regist(MapMessage.ResSpaceCrackPvp, this.ResSpaceCrackPvp)
  this.messageContainer:Regist(TimeCrackMessage.ResSpaceCrackBox, this.ResSpaceCrackBox)
  this.messageContainer:Regist(TimeCrackMessage.ResSpaceCrackSettle, this.ResSpaceCrackSettle)
  this.messageContainer:Regist(TimeCrackMessage.ResServerCrackOpenBox, this.ResServerCrackOpenBox)
  this.eventContainer:Regist(Event.Scene_SceneLoaded, this.Scene_SceneLoaded)
  this.eventContainer:Regist(Event.ProcessCollectionAndRob, this.OnProcessCollectionAndRob)
  this.eventContainer:Regist(Event.ActivityShiKongItemCount, this.ActivityShiKongItemCount)
end

function SpaceCrackController.ResTimeCrackPanel(_msgID, _tblData)
  QuickFind:GetSpaceCrackDataManager():ResTimeCrackPanel(_tblData)
end

function SpaceCrackController.ResSpaceCrackPersonRank(_msgID, _tblData)
  QuickFind:GetSpaceCrackDataManager():ResSpaceCrackPersonRank(_tblData)
end

function SpaceCrackController.ResSpaceCrackUnionRank(_msgID, _tblData)
  QuickFind:GetSpaceCrackDataManager():ResSpaceCrackUnionRank(_tblData)
end

function SpaceCrackController.ResSpaceCrackTask(_msgID, _tblData)
  QuickFind:GetSpaceCrackDataManager():ResSpaceCrackTask(_tblData)
end

function SpaceCrackController.ResSpaceCrackPvp(_msgID, _tblData)
  QuickFind:GetSpaceCrackDataManager():ResSpaceCrackPvp(_tblData)
  EventManager.Dispatch(Event.RefreshSpaceCrackTranscriptRankButton)
end

function SpaceCrackController.ResServerCrackUnionBuff(_msgID, _tblData)
  QuickFind:GetSpaceCrackDataManager():ResServerCrackUnionBuff(_tblData)
end

function SpaceCrackController.ResServerCrackBoss(_msgID, _tblData)
  QuickFind:GetSpaceCrackDataManager():ResServerCrackBoss(_tblData)
end

function SpaceCrackController.ResSpaceCrackBox(_msgID, _tblData)
  QuickFind:GetSpaceCrackDataManager():ResSpaceCrackBox(_tblData)
end

function SpaceCrackController.ResSpaceCrackSettle(_msgID, _tblData)
  QuickFind:GetSpaceCrackDataManager():ResSpaceCrackSettle(_tblData)
end

function SpaceCrackController.ResServerCrackOpenBox(_msgID, _tblData)
  QuickFind:GetSpaceCrackDataManager():ResServerCrackOpenBox(_tblData)
end

function SpaceCrackController.ReqTimeCrackPanel()
  networkRequest.ReqTimeCrackPanel()
end

function SpaceCrackController.ReqSpaceCrackPersonRank()
  networkRequest.ReqSpaceCrackPersonRank()
end

function SpaceCrackController.ReqSpaceCrackUnionRank()
  networkRequest.ReqSpaceCrackUnionRank()
end

function SpaceCrackController.ReqEnterTimeCrack()
  networkRequest.ReqEnterTimeCrack()
end

function SpaceCrackController.ReqJoinTimeCrack(_count)
  networkRequest.ReqJoinTimeCrack(_count)
end

function SpaceCrackController.ReqSubmitInstanceTask(_taskId)
  networkRequest.ReqSubmitInstanceTask(_taskId)
end

function SpaceCrackController.ReqFlagActivityCollectBox(_boxId, _status)
  networkRequest.ReqFlagActivityCollectBox(_boxId, _status)
end

function SpaceCrackController.Scene_SceneLoaded(_id, _mapId)
  if SpaceCrackUtility:CheckInSpaceCrackMap(_mapId) then
    EventManager.Dispatch(Event.ResSpaceCrackTranscriptLeftTopPanel, true)
  else
    EventManager.Dispatch(Event.ResSpaceCrackTranscriptLeftTopPanel, false)
  end
  EventManager.Dispatch(Event.ChangeRightTopBtn, false)
end

function SpaceCrackController.OnProcessCollectionAndRob(_id, _npcList)
  QuickFind:GetSpaceCrackDataManager():OnProcessCollectionAndRob(_npcList)
end

function SpaceCrackController.ActivityShiKongItemCount(_, countKey)
  local countTbl = ClientTable.cfg_Count_countManager:TryGetValue(countKey, "key")
  local surplus = RefreshData.GetLimitCount(countKey)
  local sumCount = countTbl.refreshCountLimit
  if sumCount - surplus ~= 0 then
    FloatingWordUtility.QuickMsg(string.format("%s nh\225\186\183t (%d/%d)", countTbl.desc, sumCount - surplus, sumCount))
  end
end
