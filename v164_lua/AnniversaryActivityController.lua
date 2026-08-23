require("GameModel/AnniversaryActivity/AnniversaryActivity_ActivityData")
require("GameModel/AnniversaryActivity/AnniversaryActivity_SignInData")
require("GameModel/AnniversaryActivity/AnniversaryActivity_StoreData")
require("GameModel/AnniversaryActivity/AnniversaryActivity_NPCActivityData")
require("GameModel/AnniversaryActivity/AnniversaryActivity_BattleOrderData")
require("GameModel/AnniversaryActivity/AnniversaryActivity_NewCharacterData")
require("GameModel/AnniversaryActivity/AnniversaryActivity_MonsterData")
AnniversaryActivityController = {}
local this = AnniversaryActivityController

function AnniversaryActivityController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function AnniversaryActivityController.RegistEvent()
  this.messageContainer:Regist(CommerceMessage.ResQianDaoInfo, this.ResQianDaoInfo)
  this.messageContainer:Regist(CommerceMessage.ResGetCommercialActivityInfo, this.ResGetCommercialActivityInfo)
end

function AnniversaryActivityController.ResQianDaoInfo(_, data)
  if data then
    AnniversaryActivity_SignInData.SetSignInInfo(data)
  end
  AnniversaryActivityController.RefreshByGroup(AnniversaryActivityEnum.SignIn)
end

function AnniversaryActivityController.ResGetCommercialActivityInfo(_, data)
  if data.icon ~= CommercializeActivityTab.Anniversary then
    return
  end
  if data.groupId == AnniversaryActivityEnum.SignIn then
    AnniversaryActivity_SignInData.SetSignInData(data)
    return
  elseif data.groupId == AnniversaryActivityEnum.Store then
  elseif data.groupId == AnniversaryActivityEnum.NpcActivity then
    AnniversaryActivity_NPCActivityData.SetNpcActivityData(data)
    if AnniversaryActivity_NPCActivityData.isCanOpenPanel == true then
      AnniversaryActivity_NPCActivityData.isCanOpenPanel = false
      UIManager.Show(UIID.Commercial_AnniversaryCelebrationNpcUI)
    elseif UIManager.IsVisible(UIID.Commercial_AnniversaryCelebrationNpcUI) then
      EventManager.Dispatch(Event.RefreshAnniversaryCelebrationNpcUI)
    end
    return
  elseif data.groupId == AnniversaryActivityEnum.BattleOrder then
    AnniversaryActivity_BattleOrderData.SetBattleOrderData(data)
    EventManager.Dispatch(Event.RefreshAnniversaryCelebrationBattleOrderUI)
  elseif data.groupId == AnniversaryActivityEnum.NewCharacter then
    AnniversaryActivity_NewCharacterData.SetNewCharacterData(data)
  elseif data.groupId == AnniversaryActivityEnum.Monster then
    AnniversaryActivity_MonsterData.SetMonsterData(data)
  end
  AnniversaryActivityController.RefreshByGroup(data.groupId)
end

function AnniversaryActivityController.RefreshByGroup(groupId)
  EventManager.Dispatch(Event.AnniversaryPanelRefresh, AnniversaryActivity_ActivityData.GetActivityByGroupId(groupId))
end

function AnniversaryActivityController.GetActivityData()
  for i, v in pairs(AnniversaryActivityEnum) do
    local Tbl = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", v)[1]
    if Tbl then
      local condition = Tbl.condition
      if condition and ConditionManager.Check(condition) then
        NetManager.Send(CommerceMessage.ReqGetCommercialActivityInfo, {
          icon = CommercializeActivityTab.Anniversary,
          groupId = v
        })
      end
    end
  end
end

function AnniversaryActivityController.GoTask(data)
  if not data.toFunction then
    return
  end
  if data.toFunction == "-1" then
    local goalId = data.mission
    local taskGoal = TaskGoal(goalId)
    if taskGoal:GetTarget() == TaskTargetType.NpcTarget then
      PathFinderManager.JumpMapMoveToNpc({
        npcId = taskGoal:GetNpc()
      }, nil, Purpose.ClickNpc)
    end
    if taskGoal:GetTarget() == TaskTargetType.SingleMap or taskGoal:GetTarget() == TaskTargetType.MultiMap then
      local mul, groundId, pos, transferId = taskGoal:GetPosition()
      PathFinderManager.JumpMapToMoveToPos(groundId, PathFinderManager.GetCalcPosData(pos), transferId, nil, nil, nil, function()
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
      end)
    end
  elseif data.toFunction == "4010003" then
    NetManager.Send(RoleMessage.ReqActiveAndFind)
  else
    local navTal = NavigationUtility.GetNavTblForId(tonumber(data.toFunction))
    if NavigationUtility.OpenPanrlCondition(navTal) == false then
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("ZhouNianQing_transfer"))
      return
    end
    NavigationUtility.OpenPanelForId(tonumber(data.toFunction))
  end
end
