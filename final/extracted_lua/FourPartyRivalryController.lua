require("GameModel/FourPartyRivalry/FourPartyRivalryManager")
require("GameModel/FourPartyRivalry/FourPartyRivalryConstant")
require("GameModel/FourPartyRivalry/FourPartyRivalryScoreTipUtility")
require("GameModel/FourPartyRivalry/FourPartyRivalryUtility")
FourPartyRivalryController = {}
local this = FourPartyRivalryController

function FourPartyRivalryController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  FourPartyRivalryManager:Init()
end

function FourPartyRivalryController.RegistEvent()
  this.messageContainer:Regist(MapMessage.ResSystemInstance_SiFangZhengBaActivity, this.ResSystemInstance_SiFangZhengBaActivity)
  this.messageContainer:Regist(MapMessage.ResSiFangGetScore, this.ResSiFangGetScore)
  this.messageContainer:Regist(MapMessage.ResSiFangZhengBaRank, this.ResSiFangZhengBaRank)
  this.messageContainer:Regist(FightMessage.ResPlayerUseSkill, this.ResPlayerUseSkill)
  this.eventContainer:Regist(Event.Scene_SceneDataChange, this.Scene_SceneDataChange)
  this.eventContainer:Regist(Event.OpenSettlementRankPanel, this.OpenSettlementRankPanel)
  this.eventContainer:Regist(Event.Scene_SceneLoaded, this.Scene_SceneLoaded)
end

function FourPartyRivalryController.ResSystemInstance_SiFangZhengBaActivity(_msgID, _tblData)
  FourPartyRivalryManager:ResFourPartyRivalryActivityInfo(_tblData)
end

function FourPartyRivalryController.ResSiFangGetScore(_msgID, _tblData)
  FourPartyRivalryManager:ResFourPartyRivalrySiFangGetScore(_tblData)
end

function FourPartyRivalryController.ResSiFangZhengBaRank(_msgID, _tblData)
  FourPartyRivalryManager:ResFourPartyRivalryScoreRank(_tblData)
end

function FourPartyRivalryController.ResPlayerUseSkill(_msgID, _tblData)
  FourPartyRivalryManager:ResPlayerUseSkill(_tblData)
end

function FourPartyRivalryController.OpenSettlementRankPanel()
  UIManager.Show(UIID.Activity_SiFangRankUI)
end

function FourPartyRivalryController.Scene_SceneDataChange(_id, _mapId)
  if FourPartyRivalryManager:CheckInFourPartyRivalryMap(_mapId) then
    EventManager.Dispatch(Event.EnterFourPartyRivalryScene)
  elseif FourPartyRivalryManager.m_LastMapId == FourPartyRivalryConstant.MapId then
    EventManager.Dispatch(Event.QuitFourPartyRivalryScene)
  end
  FourPartyRivalryManager.m_LastMapId = _mapId
end

function FourPartyRivalryController.Scene_SceneLoaded()
  if not FourPartyRivalryManager:IsEnterFourPartyRivalryMap() then
    return
  end
  local fourPartyRivalryActivityInfo = FourPartyRivalryManager.m_FourPartyRivalryActivityInfo
  if fourPartyRivalryActivityInfo == nil then
    return
  end
  FourPartyRivalryManager:RefreshThronedBlockPoint(fourPartyRivalryActivityInfo.stage, true)
  FourPartyRivalryManager:RefreshCityGateBlockPoint(fourPartyRivalryActivityInfo.doorList, true)
end
