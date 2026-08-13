require("GameModel/WarAllianceData")
require("GameConst/WarAllianceEnum")
WarAllianceUIController = {}
local this = WarAllianceUIController

function WarAllianceUIController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function WarAllianceUIController.RegistMessages()
  this.messageContainer:Regist(UnionMessage.ResUnionBaseInfo, this.ResUnionBaseInfo)
  this.messageContainer:Regist(UnionMessage.ResUnionList, this.ResUnionList)
  this.messageContainer:Regist(UnionMessage.ResUnionSimpleInfo, this.ResUnionSimpleInfo)
  this.messageContainer:Regist(UnionMessage.ResMemberList, this.ResMemberList)
  this.messageContainer:Regist(UnionMessage.ResMemberDetailedInfo, this.ResMemberDetailedInfo)
  this.messageContainer:Regist(UnionMessage.ResBadgeInfo, this.ResBadgeInfo)
  this.messageContainer:Regist(UnionMessage.ResUnionInfoChange, this.ResUnionInfoChange)
  this.messageContainer:Regist(UnionMessage.ResUnionAdminInfo, this.ResUnionAdminInfo)
  this.messageContainer:Regist(UnionMessage.ResModifyApplyCondition, this.ResModifyApplyCondition)
  this.messageContainer:Regist(UnionMessage.ResLeaveUnion, this.ResLeaveUnion)
  this.messageContainer:Regist(UnionMessage.ResImpeachInfo, this.ResImpeachInfo)
  this.messageContainer:Regist(UnionMessage.ResMemberChange, this.ResMemberChange)
  this.messageContainer:Regist(UnionMessage.ResUnionItemUse, this.OnResUnionItemUse)
  this.messageContainer:Regist(CountMessage.ResCount, this.ResRefreshCount)
  this.messageContainer:Regist(CountMessage.ResInviteJoinUnion, this.ResInviteJoinUnion)
  this.messageContainer:Regist(UnionMessage.ResJoinUnion, this.ResJoinUnion)
  this.messageContainer:Regist(UnionMessage.ResImpeachInfo, this.ResImpeachInfo)
  this.messageContainer:Regist(UnionMessage.ResSelectUnionLeaderInfo, this.ResSelectUnionLeaderInfo)
  this.messageContainer:Regist(UnionMessage.ResReplaceUnionLeaderInfo, this.ResReplaceUnionLeaderInfo)
  this.messageContainer:Regist(UnionMessage.ResUnionLogoInfo, this.ResUnionLogoInfo)
end

function WarAllianceUIController.ResUnionBaseInfo(id, msg)
  WarAllianceData.InitMyWarAlliance(msg)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.waralliance
  })
  EventManager.Dispatch(Event.RefreshDailyPackRedPointByServer, {
    redPointId = ERedPointId.everydaytarget_activity
  })
end

function WarAllianceUIController.ResUnionList(id, msg)
  WarAllianceData.InitWarAllianceList(msg)
end

function WarAllianceUIController.ResUnionSimpleInfo(id, msg)
  EventManager.Dispatch(Event.WarAlliance_SimpleInfo, msg)
end

function WarAllianceUIController.ResMemberList(id, msg)
  WarAllianceData.InitMemberList(msg)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.waralliance
  })
end

function WarAllianceUIController.ResMemberDetailedInfo(id, msg)
  EventManager.Dispatch(Event.WarAlliance_MemberMsg, msg)
end

function WarAllianceUIController.ResBadgeInfo(id, msg)
  WarAllianceData.InitMyArmbandData(msg)
end

function WarAllianceUIController.ResUnionInfoChange(id, msg)
  if msg.unionId ~= WarAllianceData.MyWarAllianceData.id then
    return
  end
  if msg.type == WarAllianceDataChangeType.Notice or WarAllianceDataChangeType.RecruitNotice then
    EventManager.Dispatch(Event.WarAlliance_Notice, msg)
  elseif msg.type == WarAllianceDataChangeType.Logo then
    WarAllianceData.MyWarAllianceData.logo = msg.desc
  elseif msg.type == WarAllianceDataChangeType.Name then
    WarAllianceData.MyWarAllianceData.name = msg.desc
  end
  NetManager.Send(UnionMessage.ReqUnionBaseInfo)
end

function WarAllianceUIController.ResUnionAdminInfo(id, msg)
  WarAllianceData.UpdateAuditList(msg)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.waralliance
  })
end

function WarAllianceUIController.ResModifyApplyCondition(id, msg)
  EventManager.Dispatch(Event.WarAlliance_ChangeApplyCondition, msg)
end

function WarAllianceUIController.ResMemberChange(id, msg)
  WarAllianceData.UpdateMemberList(msg)
end

function WarAllianceUIController.ResLeaveUnion(id, msg)
  ViewData.meData.unionLogo = nil
  ViewData.meData.unionId = 0
  ViewData.meData.unionName = nil
  ViewData.meData.unionLevel = 0
  ViewData.meData.badgeLevel = 0
  WarAllianceData:ResetData()
  ViewData.meData:RefreshAttributes()
  EventManager.Dispatch(Event.WarAlliance_MyWarAllianceData)
end

function WarAllianceUIController.RegistEvent()
  this.eventContainer:Regist(Event.WarAlliance_OpenPanel, this.OpenPanel)
  this.eventContainer:Regist(Event.Bag_ResBagChange, this.goldUnionChange)
  this.eventContainer:Regist(Event.WarAlliance_KillBoss, this.ReqUnionBossKillBossActivityData)
  this.eventContainer:Regist(Event.WarAlliance_InviteJoin, this.WarAlliance_InviteJoin)
  this.eventContainer:Regist(Event.WarAlliance_OperateInviteJoin, this.WarAlliance_OperateInviteJoin)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.CleanWarAlliance)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.CleanWarAlliance)
end

function WarAllianceUIController.CleanWarAlliance()
  WarAllianceData.ClearUnionData()
end

function WarAllianceUIController.OpenPanel()
  if WarAllianceData.IsHaveUnion then
    NetManager.Send(UnionMessage.ReqUnionBaseInfo)
  end
end

function WarAllianceUIController.goldUnionChange()
  if WarAllianceData.MyWarAllianceData.exp ~= nil then
    WarAllianceData.MyWarAllianceData.exp = BagInfoData.CoinInfos[ECoinsType.goldUnion] + WarAllianceData.MyWarAllianceData.exp
  end
end

function WarAllianceUIController.OnResUnionItemUse(_, msg)
  if msg.useType == WarAllianceUseTypeEnum.employ then
    Activity_LangHunYaoSaiData.AddYongBingPosition()
    if table.count(Activity_LangHunYaoSaiData.CalledYongBingPosTbl) >= table.count(Activity_LangHunYaoSaiData.yongBingConfigTbl) then
      BubbleData.RemoveBubbleByInfo({
        id = 1,
        uiName = UIID.WolffortPreUI
      })
      EventManager.Dispatch(Event.Bubble_BubbleRefresh)
      UIManager.Hide(UIID.WolffortPreUI)
    end
  end
end

function WarAllianceUIController.ResRefreshCount(_, msg)
  EventManager.Dispatch(Event.WarAlliance_DonateCount, msg)
end

function WarAllianceUIController.ResInviteJoinUnion(_, msg)
  EventManager.Dispatch(Event.WarAlliance_RecInviteJoin, msg)
end

function WarAllianceUIController.ResJoinUnion(_, msg)
  EventManager.Dispatch(Event.WarAlliance_applyJoinCallBack, msg)
end

function WarAllianceUIController:ReqUnionBossKillBossActivityData()
  NetManager.Send(ActivityMessage.ReqUnionBossKillBossActivityData)
end

function WarAllianceUIController:WarAlliance_InviteJoin(_, msg)
  NetManager.Send(UnionMessage.ReqInviteJoinUnion, {
    beInviteId = msg.id
  })
end

function WarAllianceUIController:WarAlliance_OperateInviteJoin(_, msg)
  NetManager.Send(UnionMessage.ReqOperateInviteJoinUnion, {
    inviteId = msg.inviteId,
    unionId = msg.unionId,
    agree = msg.agree
  })
end

function WarAllianceUIController.ResImpeachInfo(id, msg)
  WarAllianceData.RefreshImpeachInfo(msg)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.waralliance
  })
end

function WarAllianceUIController.ResSelectUnionLeaderInfo(id, msg)
  WarAllianceData.RefreshCampaignInfo(msg)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.waralliance
  })
end

function WarAllianceUIController.ResReplaceUnionLeaderInfo(id, msg)
  WarAllianceData.RefreshReplaceInfo(msg)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.waralliance
  })
end

function WarAllianceUIController.ResUnionLogoInfo(id, msg)
  WarAllianceData.UnionLogoSave(msg)
end

WarAllianceUIController.Init()
