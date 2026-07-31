require("GameModel/SceneData")
require("GameConst/SceneEnum")
SceneController = {}
local this = SceneController

function SceneController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
end

function SceneController:OnEnterGame()
  this.RegistMessages()
  this.RegistEvent()
end

function SceneController:OnLeaveGame()
  this.UnRegistMessages()
  this.UnRegistEvent()
end

function SceneController.RegistMessages()
  this.messageContainer:Regist(MapMessage.ResTryEnterMap, this.OnResTryEnterMap)
  this.messageContainer:Regist(MapMessage.ResLoginMap, this.OnResLoginMap)
  this.messageContainer:Regist(MapMessage.ResChangeMap, this.OnResChangeMap)
  this.messageContainer:Regist(MapMessage.ResFailMove, this.OnResFailMove)
  this.messageContainer:Regist(MapMessage.ResGetBossMapAndCount, this.ResGetBossMapAndCount)
  this.messageContainer:Regist(MapMessage.ResBossIcon, this.ResGetBossState)
  this.messageContainer:Regist(MapMessage.ResGoldBoxSpecialEffects, this.ResGoldBoxSpecialEffects)
  this.messageContainer:Regist(MapMessage.ResBossSmallIcon, this.ResBossSmallIcon)
  this.messageContainer:Regist(MapMessage.ResSingleBossSmallIcon, this.ResSingleBossSmallIcon)
  this.messageContainer:Regist(MapMessage.ResShowMapLinePlayer, this.ResShowMapLinePlayer)
  this.messageContainer:Regist(MapMessage.ResBlackRoomInfo, this.ResBlackRoomInfo)
  this.messageContainer:Regist(MapMessage.ResMonsterInfoByTypeAndInstanceType, this.ResGetKaLiMaBossMapAndCount)
  this.messageContainer:Regist(MapMessage.ResCountDown, this.ResCountDown)
end

function SceneController.UnRegistMessages()
  this.messageContainer:UnRegistAll()
end

function SceneController.RegistEvent()
  this.eventContainer:Regist(Event.Map_ChangeMap, this.OnReqTransferTransmitMap)
end

function SceneController.UnRegistEvent()
  this.eventContainer:UnRegistAll()
end

SceneController.InstanceAutoData = {}

function SceneController.TransTargetDo(id, msg)
  if (SceneController.InstanceAutoData == nil or SceneController.InstanceAutoData[SceneData.mapId] == nil) and SceneData.mapId == 1013001 then
    local eff = ClientTable.cfg_Activity_globalManager:TryGetValue(100102, "id").effect
    local info = string.split(eff, "&")
    local tab = {}
    for i = 1, #info do
      local data = string.split(info[i], "#")
      if 3 < #data then
        table.insert(tab, {
          x = tonumber(data[3]),
          y = tonumber(data[4])
        })
      end
    end
    SceneController.InstanceAutoData[1013001] = tab
  end
  if SceneData.mapId == 1013001 then
    local curindex = GradData.JudgeArea(RoleManager.me.cellPos)
    RoleManager.me:MoveTo(SceneController.InstanceAutoData[1013001][curindex], 0, nil)
  end
end

function SceneController.OnResTryEnterMap(id, msg)
  LogManager.AddLoginLog("OnResTryEnterMap", "Login")
  SceneData.SetCurrentMapById(msg.mid, msg.line)
  if not LoginData.reconnectState then
    EventManager.Dispatch(Event.Scene_ShowLoading, "loading", msg.mid)
  else
    LoginData.reconnectState = false
    UIManager.Hide(UIID.WaitingUI)
  end
  Scene.OnEnterMap()
end

function SceneController.OnResLoginMap(id, msg)
  SceneData.SetCurrentMapById(msg.mapId, msg.line, msg.x, msg.y)
  AuctionData.RecordID(msg.id)
  EventManager.Dispatch(Event.SetIsExpShow)
  LoginData.roleName = ViewData.meData.name
  EventManager.Dispatch(Event.Role_OnLoginedMap, SceneData.defaultX, SceneData.defaultY)
end

function SceneController.OnResChangeMap(id, msg)
  this.ChangeMap(msg.mapId, msg.line, msg.x, msg.y)
end

function SceneController.OnResFailMove(id, msg)
end

function SceneController.TransferStateJudge()
  local canTransfer = true
  if ViewData.meData.hp <= 0 then
    canTransfer = false
  end
  if ViewData.meData.roleBuffData:CheckState(RoleBuffState.IMPRISON) then
    canTransfer = false
  end
  return canTransfer
end

function SceneController.OnReqTransferTransmitMap(id, mapData)
  if not SceneController.TransferStateJudge() then
    FloatingWordUtility.QuickMsg("HP kh\195\180ng \196\145\225\187\167")
    return
  end
  if TranScriptData.InTranscript and TranScriptData.InTranscriptType ~= TranScriptType.PersonBoss_Tower then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n trong ph\195\179 b\225\186\163n")
    return
  end
  if TranScriptData.InAllGodsscript then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n trong s\225\187\177 ki\225\187\135n Li\195\170n Server")
    return
  end
  if QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() == true then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n trong ph\195\179 b\225\186\163n")
    return
  end
  if BuffUtility.HasBuff(3100003) then
    FloatingWordUtility.QuickMsg("\196\144\195\179ng b\196\131ng kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n")
    return
  end
  if SceneData.groupId == 100510 then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n \225\187\159 tr\225\186\161ng th\195\161i kh\195\179a")
    return
  end
  if RedFortData.InRedFortActivity then
    local tipsStr
    if RedFortData.prepareCountDown > Time.GetServerSecondTime() then
      tipsStr = "B\225\186\161n c\195\179 ch\225\186\175c ch\225\186\175n mu\225\187\145n tho\195\161t kh\195\180ng?"
    else
      tipsStr = "Sau khi tho\195\161t s\225\186\189 kh\195\180ng th\225\187\131 v\195\160o l\225\186\161i s\225\187\177 ki\225\187\135n l\225\186\167n n\195\160y, b\225\186\161n c\195\179 ch\225\186\175c ch\225\186\175n mu\225\187\145n tho\195\161t kh\195\180ng?"
    end
    local prompTipArgs = {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = tipsStr,
      ok = function()
        TranScriptController.ReqExitInstance()
      end
    }
    UIManager.Show(UIID.PromptTipUI, prompTipArgs)
    return
  end
  local line = 0
  if mapData.line then
    line = mapData.line
  end
  EventManager.Dispatch(Event.Role_CheckSitState)
  NetManager.Send(MapMessage.ReqTransferTransmit, {
    transferId = mapData.mapId,
    line = line,
    changeLine = mapData.changeLine
  })
end

function SceneController.ResGetBossMapAndCount(id, msg)
  SceneData.MonsterMapDataInit(msg)
end

function SceneController.ResGetBossState(id, msg)
  EventManager.Dispatch(Event.Map_BossAndElite, msg)
end

function SceneController.ResGoldBoxSpecialEffects(id, msg)
  EventManager.Dispatch(Event.BroadcastFireWorks, msg)
end

function SceneController.ResBossSmallIcon(id, msg)
  SceneData.BossSmallIconDataInit(msg)
end

function SceneController.ResSingleBossSmallIcon(id, msg)
  SceneData.ResSingleBossSmallIcon(msg)
end

function SceneController.ResShowMapLinePlayer(id, msg)
  EventManager.Dispatch(Event.Map_LinePlayerCount, msg)
end

function SceneController.ResBlackRoomInfo(id, msg)
  EventManager.Dispatch(Event.Map_BlackRoomInfo, msg)
end

function SceneController.ResGetKaLiMaBossMapAndCount(id, msg)
  SceneData.KaLiMaMonsterMapDataInit(msg)
end

function SceneController.ResCountDown(id, msg)
  SceneData.SetKaLiMaBossRefreShTime(msg)
end

function SceneController.ChangeMap(id, line, x, y)
  EventManager.Dispatch(Event.Scene_OnBeginEnterScene)
  if RoleManager.me and RoleManager.me.footPrintEffect then
    RoleManager.me.footPrintEffect:SetActive(false)
  end
  SceneData.SetCurrentMapById(id, line, x, y)
  EventManager.Dispatch(Event.Scene_ShowLoading, "ScreenShot", id)
  Scene.OnEnterMap()
  EventManager.Dispatch(Event.Role_OnChangeMap)
  SceneController.ChangePKMode(id)
  RoleManager.DestroyOtherRoles()
  RoleManager.RefreshHeadColor()
  DropItemManager.DestroyDropItems()
  VipManager.DestroyVipDropItems()
  BlockBuildManager.DestroyBlockBuilds()
  TrapManager.DestroyTraps()
  SceneWeatherEffect.DestroyEffect()
  Activity_SiegeManager.DestroyScreenEffect()
  Activity_DragonAttackManager.DestroyScreenEffect()
  MapEffectManager.DestroyMapEffects()
  TransManager.DestroyAllTrans()
  GraveManager.DestroyAllGrave()
  ChatData.WelcomeEnterMap()
  TranScriptData.CloseRevive()
  EventManager.Dispatch(Event.Bubble_BubbleRefresh)
  PickupManager.RefreshDropSceneCellPos()
  BaseSkill.ChangeScene()
end

function SceneController.ChangePKMode(id)
  if SceneData.IsCrossRealm(id) and not SceneData.IsCrossRealm() and RoleManager.me.PKMode == ERolePkMode.Union and ViewData.meData.unionCamp > 0 then
    NetManager.Send(RoleMessage.ReqSetPKMode, {
      param = ERolePkMode.UnionKuaFu
    })
  end
  if SceneData.IsCrossRealm() and not SceneData.IsCrossRealm(id) and RoleManager.me.PKMode == ERolePkMode.UnionKuaFu then
    NetManager.Send(RoleMessage.ReqSetPKMode, {
      param = ERolePkMode.Union
    })
  end
end

SceneController.Init()
