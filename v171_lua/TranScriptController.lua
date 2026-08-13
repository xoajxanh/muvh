TranScriptController = {}
require("GameModel/TranScriptData")
require("GameConst/TranScriptEnum")
local this = TranScriptController
this.TransFerTable = {}

function TranScriptController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  TranScriptData.InitData()
end

function TranScriptController.RegistMessages()
  this.messageContainer:Regist(MapMessage.ResPersonInstance_PersonResource, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResPersonInstance_PersonBoss, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResInstanceCountDown, this.OnResResInstanceCountDown)
  this.messageContainer:Regist(MapMessage.ResInstanceReward, this.OnResInstanceReward)
  this.messageContainer:Regist(MapMessage.ResPersonInstance_BloodCastle, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResPersonInstance_DemonSquare, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResMysteryBossInfo, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResGodTemple, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResPersonGodTempleInfo, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResExerciseAreaInfo, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResRegenerateBossInfo, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResColetRuinsInfo, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResNewTowerInfo, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResInviteJoinInstance, this.ResIniviteJoinInstance)
  this.messageContainer:Regist(MapMessage.ResInstanceCoolDown, this.ResInstanceCoolDown)
  this.messageContainer:Regist(MapMessage.ResBossStateByType, this.ResBossStateByType)
  this.messageContainer:Regist(MapMessage.InstanceSettle, this.InstanceSettle)
  this.messageContainer:Regist(MapMessage.ResColetSettle, this.ResColetSettle)
  this.messageContainer:Regist(MapMessage.ResSystemInstanceGodDeity, this.GoAllGods)
  this.messageContainer:Regist(MapMessage.ResGodDeityInstance, this.GoAllGodsBoss)
  this.messageContainer:Regist(MapMessage.ResRefineTowerInstance, this.ResRefineTower)
  this.messageContainer:Regist(MapMessage.ResTrappedInstance, this.ResTrappedInstanceCallBack)
  this.messageContainer:Regist(MapMessage.ResVacantSpaceBossInfo, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResYuanGuBossInfo, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResLostMirageBossInfo, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResAscendSecretRealmInstance, this.ResPersonInstance_PersonResource)
  this.messageContainer:Regist(MapMessage.ResMonsterHurtList, this.ResMonsterHurtList)
end

function TranScriptController.RegistEvent()
  this.eventContainer:Regist(Event.inviteEnterTranscript, this.ResIniviteJoinInstance)
  this.eventContainer:Regist(Event.Relive, this.OnRelive)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.OnLeaveGame)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.OnLeaveGame)
  this.eventContainer:Regist(Event.UpdateCd, this.UpdateCd)
  this.eventContainer:Regist(Event.Role_OnLoginedMap, this.OnChangeMap)
end

function TranScriptController.ResRefineTower(id, msg)
  msg.type = id
  TranScriptData.SetInTranscript(true)
  TranScriptData.InTranscriptType = id
  TranScriptData.InTranscriptData = msg
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TaskPanelType then
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TransPanelType)
    EventManager.Dispatch(Event.UpdateCopyInfo)
  else
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TransPanelType)
  end
  EventManager.Dispatch(Event.UpdateCopyDataInfo)
  UIManager.Hide(UIID.Instance_BloodCastleUI)
  UIManager.Hide(UIID.Instance_DemonPlazaUI)
end

function TranScriptController.ResTrappedInstanceCallBack(id, msg)
  msg.type = id
  TranScriptData.InTranscript = true
  TranScriptData.InTranscriptType = id
  TranScriptData.InTranscriptData = msg
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TaskPanelType then
    LeftTopPanelManager.SetCurrentPanelType(PanelType.KSBattlePaneType)
    EventManager.Dispatch(Event.UpdateCopyInfo)
  else
    LeftTopPanelManager.SetCurrentPanelType(PanelType.KSBattlePaneType)
  end
  EventManager.Dispatch(Event.UpdateCopyDataInfo)
  EventManager.Dispatch(Event.SkillViewModelChange)
  UIManager.Hide(UIID.Instance_BloodCastleUI)
  UIManager.Hide(UIID.Instance_DemonPlazaUI)
end

function TranScriptController.ResPersonInstance_PersonResource(id, msg)
  msg.type = id
  TranScriptData.SetInTranscript(true)
  TranScriptData.InTranscriptType = id
  TranScriptData.InTranscriptData = msg
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TaskPanelType then
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TransPanelType)
    EventManager.Dispatch(Event.UpdateCopyInfo)
  else
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TransPanelType)
  end
  EventManager.Dispatch(Event.UpdateCopyDataInfo)
  UIManager.Hide(UIID.Instance_BloodCastleUI)
  UIManager.Hide(UIID.Instance_DemonPlazaUI)
end

function TranScriptController.ResMonsterHurtList(id, msg)
  if msg then
    TranScriptData.BurialRankingData = msg
    EventManager.Dispatch(Event.MonsterRankingNews)
  end
end

function TranScriptController.OnResResInstanceCountDown(_, msg)
  EventManager.Dispatch(Event.InstanceCountDownTimer, msg)
end

function TranScriptController.GoAllGods(id, msg)
  TranScriptData.InAllGodsscript = true
  TranScriptData.InAllGodsscriptData = msg
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TaskPanelType then
    LeftTopPanelManager.SetCurrentPanelType(PanelType.GodComePaneType)
    EventManager.Dispatch(Event.Task_ChangePanelState)
  else
    LeftTopPanelManager.SetCurrentPanelType(PanelType.GodComePaneType)
  end
  EventManager.Dispatch(Event.UpdateGodComeTaskUI, msg)
end

function TranScriptController.GoAllGodsBoss(id, msg)
  TranScriptData.AllGodsBossData = msg
  EventManager.Dispatch(Event.UpdateGodComeEnterView)
end

function TranScriptController.OnResInstanceReward(_, msg)
end

function TranScriptController.UnRegistMessages()
  this.messageContainer:UnRegistAll()
end

function TranScriptController.ReqExitInstance()
  NetManager.Send(MapMessage.ReqExitInstance)
  TranScriptData.ClearData()
  TranScriptData.SetFlyShoe_FlyShoeUIActive()
  LeftTopPanelManager.SetCurrentPanelType(PanelType.TaskPanelType)
  EventManager.Dispatch(Event.Task_ChangePanelState)
end

function TranScriptController.ReqExitAllGods()
  NetManager.Send(MapMessage.ReqExitInstance)
  TranScriptData.ClearData()
  LeftTopPanelManager.SetCurrentPanelType(PanelType.TaskPanelType)
  EventManager.Dispatch(Event.Task_ChangePanelState)
end

function TranScriptController.ReqExitUnionMap()
  NetManager.Send(MapMessage.ReqExitInstance)
  TranScriptData.ClearData()
  LeftTopPanelManager.SetCurrentPanelType(PanelType.TaskPanelType)
  EventManager.Dispatch(Event.Task_ChangePanelState)
end

function TranScriptController.ReqInstanceReward()
  NetManager.Send(MapMessage.ReqInstanceReward)
end

function TranScriptController.ResIniviteJoinInstance(_, msg)
  TranScriptData.tranScriptInviteData = msg
  if tonumber(msg[2]) == SceneData.mapId then
    this.PromptTipUI("B\225\186\163n \196\145\225\187\147 hi\225\187\135n t\225\186\161i kh\195\180ng th\225\187\131 v\195\160o")
  else
    UIManager.Show(UIID.Instance_BloodCastleSecondUI)
  end
end

function TranScriptController.ResInstanceCoolDown(_, msg)
  TranScriptData.InitPriBossTime(msg)
end

function TranScriptController.ResBossStateByType(_, msg)
  if msg.type == MonsterBossType.secretBoss then
    TranScriptData.InitSecretBossTime(msg)
  elseif msg.type == MonsterBossType.reinBoss then
    TranScriptData.InitReinBossTime(msg)
  elseif msg.type == MonsterBossType.AngelBoss then
    TranScriptData.InitAngelBossTime(msg)
  elseif msg.type == MonsterBossType.RegenerateBoss then
    TranScriptData.InitRegenerateBossTime(msg)
  end
end

function TranScriptController.InstanceSettle(_, msg)
  UIManager.Show(UIID.Instance_RankUI, {msg = msg})
end

function TranScriptController.ResColetSettle(_, msg)
  UIManager.Show(UIID.Tip_KaLunTeResultTipUI)
end

function TranScriptController.RoleOperate(_, msg)
  if TranScriptData.InTranscript and TranScriptData.InTranscriptType and TranScriptData.InTranscriptType == TranScriptType.BloodCastle and TranScriptData.InTranscriptStage and TranScriptData.InTranscriptStage == BloodCastleStage.RUNNING then
    TranScriptData.isOperate = true
    TranScriptData.SetIsOperate()
  end
end

function TranScriptController.OnLeaveGame()
  TranScriptData.ClearData()
  TranScriptData.InAllGodsscript = false
  TranScriptData.InAllGodCloseBtn = true
end

function TranScriptController.OnRelive(_, msg)
  if (TranScriptData.InTranscriptType and TranScriptData.InTranscriptType == TranScriptType.BloodCastle or TranScriptData.InTranscriptType == TranScriptType.DemonPlaza) and not RoleManager.me:IsCurSafeZone() and msg.reliveType == RoleReliveType.Here then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
  end
end

function TranScriptController.Role_OnStop()
  if TranScriptData.IsVoluntarily == false then
    return
  end
  TranScriptData.StopMove(nil)
end

function TranScriptController.PromptTipUI(str)
  UIManager.Show(UIID.PromptTipUI, {
    tile = "Nh\225\186\175c nh\225\187\159",
    textContent = str
  })
end

function TranScriptController.UpdateCd(_, msg)
  if msg and msg.type == 22 then
    TranScriptData.UpdatePriBossTime(msg)
  end
end

function TranScriptController.OnChangeMap()
  local runeBossMapId = table.isNullOrEmpty(GlobalConfig.RuneBossHelpCfg) == false and GlobalConfig.RuneBossHelpCfg[1]
  if runeBossMapId and SceneData.groupId == runeBossMapId then
    TranScriptData.SetInTranscript(true)
    TranScriptData.InTranscriptType = 100941
    TranScriptData.InTranscriptData = {
      type = 100941,
      id = 100941,
      basic = {
        basic = {
          mapId = SceneData.groupId,
          state = 3
        }
      }
    }
    if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TaskPanelType then
      LeftTopPanelManager.SetCurrentPanelType(PanelType.TransPanelType)
      EventManager.Dispatch(Event.UpdateCopyInfo)
    else
      LeftTopPanelManager.SetCurrentPanelType(PanelType.TransPanelType)
    end
    EventManager.Dispatch(Event.UpdateCopyDataInfo)
    UIManager.Hide(UIID.Instance_BloodCastleUI)
    UIManager.Hide(UIID.Instance_DemonPlazaUI)
  end
end
