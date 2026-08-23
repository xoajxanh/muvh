require("GameModel/Activity_LangHunYaoSaiData")
Activity_LangHunYaoSaiController = {}
local this = Activity_LangHunYaoSaiController

function Activity_LangHunYaoSaiController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function Activity_LangHunYaoSaiController.RegistMessages()
  this.messageContainer:Regist(MapMessage.ResSystemUnionInstance_LangHunYaoSai, this.ResSystemUnionInstance_LangHunYaoSai)
  this.messageContainer:Regist(ActivityMessage.ResLangHunYaoSaiRank, this.OnResRankMessage)
  this.messageContainer:Regist(ActivityMessage.ResLangHunYaoSaiSettle, this.OnResSettleMessage)
  this.messageContainer:Regist(ActivityMessage.ResLangHunYaoSaiQueryUnionCoin, this.OnResUnionCoin)
  this.messageContainer:Regist(ActivityMessage.ResLangHunYaoSaiPosition, this.OnWarAlliancePos)
  this.messageContainer:Regist(ActivityMessage.ResLangHunYaoSaiTalentCount, this.LangHunYaoSaiTalentCount)
  this.messageContainer:Regist(ActivityMessage.ResLangHunYaoSaiTalent, this.OnResLangHunYaoSaiTalent)
end

function Activity_LangHunYaoSaiController.RegistEvent()
  this.eventContainer:Regist(Event.Load_PreLoadEnd, this.OnEnterScene)
  this.eventContainer:Regist(Event.Role_OnArrive, this.RoleMeOnMove)
  this.eventContainer:Regist(Event.Scene_SceneDataChange, this.OnMapChange)
end

function Activity_LangHunYaoSaiController.OnMapChange(id, mapId)
  if mapId ~= 1035001 and Activity_LangHunYaoSaiData.State == ActivityStatusEnum.RUNNING then
    EventManager.Dispatch(Event.QuitWolffortSiege)
    Activity_LuoLanSiegeData.activityStatus = ActivityStatusEnum.INIT
  end
end

function Activity_LangHunYaoSaiController.OnResLangHunYaoSaiTalent(id, msg)
  if Activity_LangHunYaoSaiData.Count == -1 then
    EventManager.Dispatch(Event.TalentBtnShow, true)
  end
  Activity_LangHunYaoSaiData.Count = msg.count
  EventManager.Dispatch(Event.LangHunTalentCountChange)
  Activity_LangHunYaoSaiData.TalentInfors = msg
  if not UIManager.IsVisible(UIID.WolffortbuffUI) then
    if Activity_LangHunYaoSaiData.TalentBtnOnClick then
      UIManager.Show(UIID.WolffortbuffUI)
    end
  else
    EventManager.Dispatch(Event.RefreshWolfforbuffUI)
  end
end

function Activity_LangHunYaoSaiController.LangHunYaoSaiTalentCount(id, msg)
  Activity_LangHunYaoSaiData.Count = msg.count
  EventManager.Dispatch(Event.LangHunTalentCountChange)
end

function Activity_LangHunYaoSaiController.OnWarAlliancePos(id, msg)
  Activity_LangHunYaoSaiData.SelfWarAlliance = msg.position
end

function Activity_LangHunYaoSaiController:OnResSettleMessage(msg)
  Activity_LangHunYaoSaiData.Ranks = msg
  UIManager.Show(UIID.Activity_WolffortRankUI, {
    success = msg.success
  })
end

function Activity_LangHunYaoSaiController:OnResUnionCoin(msg)
  EventManager.Dispatch(Event.WarAlliance_Money, msg.coin)
  BagInfoData.CoinInfos[ECoinsType.warAllianceMoney] = msg.coin
end

function Activity_LangHunYaoSaiController:OnResRankMessage(msg)
  Activity_LangHunYaoSaiData.RankInfor = msg
  EventManager.Dispatch(Event.RefreshLangHunYaoSaiRankInfor)
end

local SceneState

function Activity_LangHunYaoSaiController:OnEnterScene()
  if SceneData.mapId == 1035001 then
    UIManager.Show(UIID.Activity_WolffortTaskUI)
    SceneState = true
    this:RoleMeOnMove(RoleManager.me.cellPos)
  else
    UIManager.Hide(UIID.Activity_WolffortTaskUI)
    SceneState = false
  end
end

local OpenPos = false
Activity_LangHunYaoSaiController.SummonControl = false

function Activity_LangHunYaoSaiController:RoleMeOnMove(msg)
  if SceneData.mapId == 1035001 and SceneState then
    if msg.x <= 126 and msg.x >= 115 and msg.y < 37 and msg.y > 26 then
      if not OpenPos and Activity_LangHunYaoSaiController.SummonControl and not UIManager.IsVisible(UIID.WolffortPreUI) and Activity_LangHunYaoSaiData.runState == LangHunYaoSaiRunStateEnum.Ready and ViewData.meData.unionPosition < 3 and Activity_LangHunYaoSaiData.State == ActivityStatusEnum.RUNNING then
        UIManager.Show(UIID.WolffortPreUI)
        RoleManager.me:StopMove()
        OpenPos = true
        Activity_LangHunYaoSaiController.SummonControl = false
      end
    else
      OpenPos = false
    end
  end
end

local timeCol

function Activity_LangHunYaoSaiController.ResSystemUnionInstance_LangHunYaoSai(_, msg)
  EventManager.Dispatch(Event.WarAlliance_Activity, msg)
  if Activity_LangHunYaoSaiData.State == msg.protectStatusActivity.state or msg.protectStatusActivity.state == ActivityStatusEnum.CLOSING then
  end
  Activity_LangHunYaoSaiData.State = msg.protectStatusActivity.state
  Activity_LangHunYaoSaiData.runState = msg.protectStatusActivity.runState
  Activity_LangHunYaoSaiData.initTime = msg.protectStatusActivity.initTime
  Activity_LangHunYaoSaiData.prepareTime = msg.protectStatusActivity.prepareTime
  Activity_LangHunYaoSaiData.status = msg.protectStatusActivity.status
  Activity_LangHunYaoSaiData.monsterRefreshEnd = msg.protectStatusActivity.monsterRefreshEnd
  Activity_LangHunYaoSaiData.monsterRefreshStep = msg.protectStatusActivity.monsterRefreshStep
  Activity_LangHunYaoSaiData.nextMonsterRefreshTime = msg.protectStatusActivity.nextMonsterRefreshTime
  Activity_LangHunYaoSaiData.yongBing = #msg.protectStatusActivity.yongBing
  Activity_LangHunYaoSaiData.yongBingIds = msg.protectStatusActivity.yongBing
  Activity_LangHunYaoSaiData.nextMonsterAttackTime = msg.protectStatusActivity.nextMonsterAttackTime
  Activity_LangHunYaoSaiData.rewardExp = msg.protectStatusActivity.rewardExp
  logPurple(string.format("\196\144\225\187\163t %d", msg.protectStatusActivity.monsterRefreshStep))
  logPurple(string.format("Tr\225\186\161ng th\195\161i SK %d", msg.protectStatusActivity.state))
  logPurple(string.format("X\195\161c nh\225\186\173n chu\225\186\169n b\225\187\139 %d", msg.protectStatusActivity.runState))
  EventManager.Dispatch(Event.RefreshLangHunYaoSaiTaskInfor)
  if Activity_LangHunYaoSaiData.State == ActivityStatusEnum.RUNNING then
    if not UIManager.IsVisible(UIID.Activity_WolffortTaskUI) then
      EventManager.Dispatch(Event.EnterWolffortSiege)
      RoleManager.RefreshHeadColor()
    end
  else
    EventManager.Dispatch(Event.QuitWolffortSiege)
  end
end

function Activity_LangHunYaoSaiController.ActivityStateHandle(msg)
  if timeCol then
    Timer.Stop(timeCol)
    timeCol = nil
  end
  if Activity_LangHunYaoSaiData.State == ActivityStatusEnum.INIT then
    Activity_LangHunYaoSaiData.throughState = ActivityStatusEnum.INIT
  elseif Activity_LangHunYaoSaiData.State == ActivityStatusEnum.RUNNING then
    Activity_LangHunYaoSaiData.throughState = ActivityStatusEnum.RUNNING
    if Activity_LangHunYaoSaiData.runState == LangHunYaoSaiRunStateEnum.Ready then
      Activity_LangHunYaoSaiData.SetYongBingPositionTbl(msg.protectStatusActivity.yongBing)
      Activity_LangHunYaoSaiData.StartTimeSec = Mathf.Floor((msg.protectStatusActivity.prepareTime + msg.protectStatusActivity.initTime - Time.GetServerTime()) / 1000)
      logOrange("Activity_LangHunYaoSaiData.StartTimeSec ...", Activity_LangHunYaoSaiData.StartTimeSec)
      logOrange(table.count(Activity_LangHunYaoSaiData.CalledYongBingPosTbl), table.count(Activity_LangHunYaoSaiData.yongBingConfigTbl))
      if table.count(Activity_LangHunYaoSaiData.CalledYongBingPosTbl) < table.count(Activity_LangHunYaoSaiData.yongBingConfigTbl) then
        BubbleData.AddBubble({
          id = 1,
          uiName = UIID.WolffortPreUI,
          type = BubbleTypeEnum.MapRelated
        })
      end
    else
      BubbleData.RemoveBubbleByInfo({
        id = 1,
        uiName = UIID.WolffortPreUI
      })
      logPurple("monsterNum ..", Activity_LangHunYaoSaiData.monsterNum, msg.protectStatusActivity.monsterRefreshStep)
      logPurple("buffNum ..", Activity_LangHunYaoSaiData.buffNum, msg.protectStatusActivity.monsterRefreshStep)
      if Activity_LangHunYaoSaiData.monsterNum ~= msg.protectStatusActivity.monsterRefreshStep and Activity_LangHunYaoSaiData.buffNum ~= msg.protectStatusActivity.monsterRefreshStep then
        Activity_LangHunYaoSaiData.buffNum = msg.protectStatusActivity.monsterRefreshStep
        Activity_LangHunYaoSaiData.RandomBuff()
        Activity_LangHunYaoSaiData.nextMonsterRefreshTimeSec = Mathf.Floor((msg.protectStatusActivity.nextMonsterRefreshTime - Time.GetServerTime()) / 1000)
        logOrange("Th\225\187\157i gian l\195\160m m\225\187\155i \196\145\225\187\163t qu\195\161i ti\225\186\191p theo ...", Activity_LangHunYaoSaiData.nextMonsterRefreshTimeSec)
        BubbleData.AddBubble({
          id = 2,
          uiName = UIID.WolffortbuffUI,
          type = BubbleTypeEnum.MapRelated
        })
      end
    end
  elseif Activity_LangHunYaoSaiData.State == ActivityStatusEnum.CLOSING then
    Activity_LangHunYaoSaiData.throughState = ActivityStatusEnum.CLOSING
    BubbleData.RemoveBubbleByInfo({
      id = 1,
      uiName = UIID.WolffortPreUI
    })
    BubbleData.RemoveBubbleByInfo({
      id = 2,
      uiName = UIID.WolffortbuffUI
    })
  elseif Activity_LangHunYaoSaiData.State == ActivityStatusEnum.END then
    Activity_LangHunYaoSaiData.throughState = ActivityStatusEnum.END
    BubbleData.RemoveBubbleByInfo({
      id = 1,
      uiName = UIID.WolffortPreUI
    })
    BubbleData.RemoveBubbleByInfo({
      id = 2,
      uiName = UIID.WolffortbuffUI
    })
  end
  EventManager.Dispatch(Event.Bubble_BubbleRefresh)
end

function Activity_LangHunYaoSaiController.OnChooseBuff(_, msg)
  if not msg then
    return
  end
  logPurple("OnChooseBuff ...", table.toString(msg, true))
  if msg.step > 1 and table.count(Activity_LangHunYaoSaiData.UsedBuffTbl) == 0 then
    for _, buffId in pairs(Activity_LangHunYaoSaiData.BuffPool) do
      logOrange("Ki\225\187\131m tra buffID ", buffId)
      if BuffData.GetBuff(ViewData.meData.id, buffId) then
        logOrange("\196\144\195\163 ch\225\187\141n", buffId)
        Activity_LangHunYaoSaiData.AddUsedBuff(buffId)
      end
    end
  end
  if 0 < msg.result then
    Activity_LangHunYaoSaiData.monsterNum = msg.step
    if this.CurBuffId ~= -1 then
      Activity_LangHunYaoSaiData.AddUsedBuff(this.CurBuffId)
    end
    BubbleData.RemoveBubbleByInfo({
      id = 2,
      uiName = UIID.WolffortbuffUI
    })
  elseif Activity_LangHunYaoSaiData.CurBuffId ~= -1 then
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "Th\195\170m Buff th\225\186\165t b\225\186\161i!"
    })
  end
  EventManager.Dispatch(Event.Activity_LangHunYaoSaiBuffResult)
  EventManager.Dispatch(Event.Bubble_BubbleRefresh)
end
