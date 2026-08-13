require("GameModel/Role/MeData")
require("GameConst/CdEnum")
require("GameModel/ExpAddData")
MeController = {}
local me, meData
local this = MeController

function MeController.Init()
  this.RegistMessages()
  this.InitEvents()
end

function MeController.RegistMessages()
  this.messageContainer = EventContainer(NetManager)
  this.messageContainer:Regist(RoleMessage.ResPlayerInfo, this.OnResPlayerInfo)
  this.messageContainer:Regist(RoleMessage.ResPlayerBasicInfo, this.ResPlayerBasicInfo)
  this.messageContainer:Regist(MapMessage.ResFailMove, this.OnResFailMove)
  this.messageContainer:Regist(MapMessage.ResChangePos, this.OnResChangePos)
  this.messageContainer:Regist(RoleMessage.ResPlayerExpChange, this.OnResPlayerExpChange)
  this.messageContainer:Regist(RoleMessage.ResPlayerLevelChange, this.OnPlayerLevelChange)
  this.messageContainer:Regist(MapMessage.ResUpdateRoundPlayer, this.ResUpdateRoundPlayer)
  this.messageContainer:Regist(RoleMessage.ResAttributeModify, this.OnResAttributeModify)
  this.messageContainer:Regist(RoleMessage.ResCDChanged, this.OnResCDChanged)
  this.messageContainer:Regist(RoleMessage.ResTransferCareer, this.OnResTransferCareer)
  this.messageContainer:Regist(FightMessage.ResRelive, this.OnResRelive)
  this.messageContainer:Regist(UnionMessage.ResUnionBaseInfo, this.ResUnionBaseInfo)
  this.messageContainer:Regist(UnionMessage.ResUnionInfoChange, this.ResUnionInfoChange)
  this.messageContainer:Regist(FruitMessage.ResFruitInfo, this.ResFruitInfo)
  this.messageContainer:Regist(RoleMessage.ResWorldExp, this.ResWorldExp)
  this.messageContainer:Regist(RoleMessage.ResWashCounts, this.ResWashCounts)
  this.messageContainer:Regist(RoleMessage.ResActorfight, this.ResActorfight)
  this.messageContainer:Regist(RoleMessage.ResRoleMaster, this.ResRoleMaster)
  this.messageContainer:Regist(RoleMessage.ResCallToRefresh, this.ResCallToRefresh)
  this.messageContainer:Regist(RoleMessage.ResRoleDieTips, this.ResRoleDieTips)
  this.messageContainer:Regist(RoleMessage.ResRoleRedName, this.ResRoleRedName)
  this.messageContainer:Regist(UserMessage.ResInviteCodeView, this.ResInviteCodeView)
end

function MeController.InitEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Role_OnLoginedMap, this.OnRoleLoginMap, _, 1)
  this.eventContainer:Regist(Event.EquipAttriUpdate, this.OnRoleEquipeChanged)
  this.eventContainer:Regist(Event.OpenNpcPanel, this.OnOpenNpcPanelType)
  this.eventContainer:Regist(Event.CloseNpcPanel, this.OnCloseNpcPanelType)
  this.eventContainer:Regist(Event.Mount_RideChange, this.MountRiderChange)
  this.eventContainer:Regist(Event.Buff_RefreshRoleBuffAttr, this.BuffRefresh)
  this.eventContainer:Regist(Event.GamePlay_Reconnect, this.ReconnectReset)
  this.eventContainer:Regist(Event.Role_RoleDead, this.Role_RoleDead)
  this.eventContainer:Regist(Event.Role_MyAttributeChanged, this.MyAttributePointChanged)
  this.eventContainer:Regist(Event.Skill_UpdateComboSkill, this.ReleaseComboSkill)
  this.eventContainer:Regist(Event.Appear_OperationFashion, this.RefreshOperationFashion)
end

function MeController.OnResPlayerInfo(_, playerinfo)
  if meData == nil then
    meData = MeData()
    this.career = playerinfo.basic.info.career
    meData:Init(playerinfo)
  else
    this.career = playerinfo.basic.info.career
    meData:Refresh(playerinfo)
  end
  meData.model, meData.modelScale = RoleEquipUtility.GetCurPlayerModelName(ForgeData.appearData[meData.id], meData.equipsData.Data)
  if RoleManager and RoleManager.me and RoleManager.me:IsArchangeActive() then
    meData.model, meData.modelScale = ERoleModelName.datianshibianshen, PlayerModelDefaultScale
  end
  ViewData.AddMe(meData)
  if RoleManager and RoleManager.me then
    me = RoleManager.me
  else
    me = Me(meData)
    SkillSettingData.Init()
    ChatData.Init()
    FriendData.Init()
    NoticeData.Init()
    QiJiHelperData.InitAutoFight()
    WarAllianceData.Init()
    Activity_DragonAttackData.Init()
    RedFortData.Init()
    OnHookData.Reset()
    HPData.Init()
    KillMonsterCardData.ResetData()
  end
  ForgeData.equipFunction = {}
  if table.count(playerinfo.basic.equipFunction) > 0 then
    for i = 1, table.count(playerinfo.basic.equipFunction) do
      table.insert(ForgeData.equipFunction, playerinfo.basic.equipFunction[i])
    end
  end
  RoleManager.InitMe(me)
end

function MeController.ResPlayerBasicInfo(_, playerinfo)
  if meData then
    this.career = playerinfo.basic.info.career
    meData:Refresh(playerinfo)
    if ViewData.meData.oldCareer and ViewData.meData.oldCareer ~= 0 then
      local isSame = RoleUtility.JudgeWardCompatibilty(playerinfo.basic.info.career, ViewData.meData.oldCareer)
      if isSame == 0 then
        SkillData.CreateCareerSkillInfos()
        SkillSettingData.RefreshSkillData()
        RoleManager.me.AvatarEquip:InitData()
        RoleManager.me.AvatarEquip:InitEquip()
      end
    end
  end
end

function MeController.OnResFailMove(_, msg)
  meData:SetServerPos(msg.x, msg.y)
  me:ChangePos(ERoleMoveType.Stand, ERoleChangePosReason.MoveFailed)
end

function MeController.OnResChangePos(id, msg)
  if msg.lid == meData.id then
    meData:SetServerPos(msg.x, msg.y)
    me:ChangePos(ERoleMoveType.Stand, msg.reason, msg.reasonParam)
    if ForgeData.isOnHookProfitStart then
      ForgeData.isOnHookProfitStart = false
    else
      EventManager.Dispatch(Event.Role_ChangePos, msg.lid, msg.reason, msg.reasonParam)
    end
    if ForgeData.UseRandomStoneState ~= EUseStoneRecordEnum.None then
      PathFinderManager.pathFinding.Reset()
      PathFinderManager.PathRecord()
    end
  end
end

function MeController.AddSkillData(skillData)
  meData:AddSkillData(skillData)
end

function MeController.RemoveSkillData(skillId)
  meData:RemoveSkillData(skillId)
end

function MeController.UpdateSkillData(skillId)
  meData:UpdateSkillExpData(skillId)
  meData:UpdateSkillUseTime(skillId)
end

function MeController.UpdateSkillExpData(skillId)
  meData:UpdateSkillExpData(skillId)
end

function MeController.UpdateSkillUseTime(skillId)
  meData:UpdateSkillUseTime(skillId)
end

function MeController.OnResPlayerExpChange(_, expMsg)
  meData.exp = expMsg.exp
end

function MeController.OnPlayerLevelChange(_, lvMsg)
  meData.validAttributePoint = lvMsg.attributePoint
  meData:RefreshLevel(lvMsg.level)
  networkRequest.ReqGrandMasterInfo()
end

function MeController.ResUpdateRoundPlayer(_, roleData)
  if roleData.info.roleId ~= meData.id then
    return
  end
  meData:SetName(roleData.info.name)
  meData:SetShieldState(roleData)
  meData:RefreshShieldNum(roleData)
  meData:SetCamp(roleData.info.unionCamp)
end

function MeController.OnResAttributeModify(_, attrMsg)
  meData.validAttributePoint = attrMsg.attributePoint
  meData:RefreshRoleBasicAttribute(attrMsg.chooseAttribute)
  EventManager.Dispatch(Event.Role_MyAttributePointChanged, attrMsg)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function MeController.OnResCDChanged(_, cdMsg)
  meData:UpdateCd(cdMsg)
  EventManager.Dispatch(Event.UpdateCd, cdMsg)
end

function MeController.OnResTransferCareer(_, msg)
  if ViewData.meData.id == msg.roleId then
    UIManager.Show(UIID.Zhuanzhi_TIpsUI, {
      type = ERoleSchema.Transfer,
      oldCareer = msg.beforeCareer,
      newCareer = msg.career
    })
    UIManager.Hide(UIID.ShopSkillTIpsUI)
  end
  meData:UpdateTransferCareer(msg)
  EventManager.Dispatch(Event.Role_TransferCareer, msg)
  TipData.OpenShopTip()
end

function MeController.UpdateClientSkillCd(skillId)
  meData:UpdateClientSkillCd(skillId)
  EventManager.Dispatch(Event.UpdateSkillCd, skillId)
end

function MeController.SpecialChangeClientSkillCd(skillId, endTime)
  meData:SpecialChangeClientSkillCd(skillId, endTime)
end

function MeController.UpdateClientItemCd(itemId)
  meData:UpdateClientItemCd(itemId)
end

function MeController.OnResRelive(_, msg)
  ViewData.ChangeRoleHp(msg.lid, msg.hp)
  ViewData.ChangeRoleMp(msg.lid, msg.mp)
  ViewData.ChangeRoleShield(msg.lid, msg.shield)
  local role = RoleManager.GetRoleById(msg.lid)
  if not role then
    return
  end
  role:PlayAnimation("alive")
  role:RefreshAnimation()
  role:RefreshMount()
  HPData.RemoveAllData(msg.lid)
  EventManager.Dispatch(Event.Relive, msg)
end

function MeController.ResUnionBaseInfo(_, msg)
  if msg ~= nil then
    meData:UpdateUnionInfoData(msg.id, msg.name, msg.logo)
    if msg.unionLevel then
      meData.unionLevel = msg.level or 0
    end
  end
end

function MeController.ResRoleBadgeLevelUp()
  if meData then
    meData:RefreshAttributes()
  end
end

function MeController.ResUnionInfoChange(_, msg)
  if msg.unionId ~= WarAllianceData.MyWarAllianceData.id then
    return
  end
  if msg.type == WarAllianceDataChangeType.Name then
    meData:UpdateUnionInfoData(nil, msg.desc, nil)
  elseif msg.type == WarAllianceDataChangeType.Logo then
    meData:UpdateUnionInfoData(nil, nil, msg.desc)
  end
end

function MeController.ResFruitInfo(_, msg)
  meData:UpdateFruitAddAttribute(msg)
end

function MeController.ResWorldExp(_, msg)
  if msg == nil then
    return
  end
  ExpAddData.WorldExp = msg.expRate
  EventManager.Dispatch(Event.Role_WordEXP, msg)
end

function MeController.ResWashCounts(_, msg)
  EventManager.Dispatch(Event.Role_WashCounts, msg)
end

function MeController.ResActorfight(_, msg)
  local changeList = msg.attribute
  if changeList[EAttributeType.fight] ~= nil then
    local value = changeList[EAttributeType.fight]
    meData:SetAttribute(EAttributeType.fight, value)
  end
end

function MeController.ResRoleMaster(_, msg)
  meData:SetMasterAttr(msg.master)
end

function MeController.ResCallToRefresh(_, msg)
  if msg.type == 0 then
    EventManager.Dispatch(Event.RefreshShop)
    EventManager.Dispatch(Event.RefreshZeroTime)
    PlayerControlForceData.InitPromptBuyDrugState(true)
    CommercializeController.OpenserActivit()
    CommercializeController.ReqEverydayRecharge()
    FucShowOrHideController.IsZeroRefreshFun()
  end
end

function MeController.ResRoleDieTips(_, msg)
  HPData.mapName = msg.mapName
  HPData.unionName = msg.unionName
  HPData.killName = msg.killName
end

function MeController.ReqAttributeModify(attrMap)
  local req = {}
  for k, v in pairs(attrMap) do
    table.insert(req, {choose = k, num = v})
  end
  NetManager.Send(RoleMessage.ReqAttributeModify, {modify = req})
end

function MeController.ReqReqRelive(reliveType)
  NetManager.Send(FightMessage.ReqRelive, {reliveType = reliveType})
end

function MeController.OnRoleLoginMap(_, x, y)
  meData:SetServerPos(x, y)
  me:LoginMap()
end

function MeController.OnRoleEquipeChanged(_)
  meData:RefreshAttributes()
  me:RefreshHp()
end

function MeController:OnOpenNpcPanelType(config_Npc)
  UIManager.UICloseType(UIPanelType.SortAndHide)
  if TranScriptData.NpcData ~= nil then
    local TranState = TranScriptData:GetTaskState()
    if TranState and TranScriptData.InTranscript then
      if TranScriptData.NpcData ~= nil then
        TranScriptData.OpenNpcHandInTask()
      end
    else
      this.OnOpenNpcPanel(config_Npc)
    end
  else
    local findTask, taskData = TaskData.FindSortingTaskForNpc(config_Npc.npcId)
    if findTask then
      EventManager.Dispatch(Event.Task_OpenNpcTaskPanel, taskData)
    else
      this.OnOpenNpcPanel(config_Npc)
    end
  end
end

function MeController.OnOpenNpcPanel(config_Npc)
  if not string.isNullOrEmpty(config_Npc.openPanel) and FucShowOrHideController.IsShowFucUI(config_Npc.openPanel) then
    local npcShowShopSkillPanlID = ClientTable.cfg_Global_globalManager:GetNPCShowShopSkillPanlID()
    if config_Npc ~= nil and npcShowShopSkillPanlID ~= nil and npcShowShopSkillPanlID ~= 0 and config_Npc.npcId == npcShowShopSkillPanlID then
      UIManager.Show(UIID.Shop, {subtype = 4})
      return
    end
    if config_Npc.npcId == 10400001 then
      if next(AnniversaryActivity_NPCActivityData.npcSpecialTask) then
        NetManager.Send(TaskMessage.ReqUpdateGoal, AnniversaryActivity_NPCActivityData.npcSpecialTask)
      end
      AnniversaryActivity_NPCActivityData.isCanOpenPanel = true
      NetManager.Send(CommerceMessage.ReqGetCommercialActivityInfo, {
        icon = CommercializeActivityTab.Anniversary,
        groupId = AnniversaryActivityEnum.NpcActivity
      })
      return
    end
    UIManager.Show(config_Npc.openPanel, {
      npcConfigID = config_Npc.npcId,
      param = config_Npc.param
    })
  else
    UIManager.Show(UIID.DialogUI, config_Npc)
  end
end

function MeController.OnCloseNpcPanelType(_, config_Npc)
  if not string.isNullOrEmpty(config_Npc.openPanel) then
    UIManager.Hide(config_Npc.openPanel)
  else
    UIManager.Hide(UIID.DialogUI)
  end
  if UIManager.IsVisible(UIID.TaskInfoUI) then
    UIManager.Hide(UIID.TaskInfoUI)
  end
  if UIManager.IsVisible(UIID.Task_TransferUI) then
    UIManager.Hide(UIID.Task_TransferUI)
  end
  RoleManager.me:SetTargetAvatar(nil)
end

function MeController.MountRiderChange(_)
  RoleManager.me:ResetMountWalkStep()
end

function MeController.BuffRefresh()
  meData:RefreshAttributes(EAttributeProviderSystem.Buff)
end

function MeController.ReconnectReset()
  if me == nil then
    return
  end
  me:StopMove()
end

function MeController.Role_RoleDead(_, role)
  if not me then
    return
  end
  if me.TargetAvatar and role.id == me.TargetAvatar.id and not QiJiHelperData.isAutoFight then
    me:SetAutoFight(AutoFightStrKey.None)
  end
end

function MeController.ResRoleRedName(_, msg)
  meData:RefreshRedNameData(msg)
  RoleManager.me:InitHeadUI()
  EventManager.Dispatch(Event.RefreshRedName)
end

function MeController.ResInviteCodeView(_, msg)
  EventManager.Dispatch(Event.RefreshInviteUI, msg)
end

function MeController.MyAttributePointChanged(_, changeList)
  if not me then
    return
  end
  for k, v in pairs(changeList) do
    if k == EAttributeType.moveSpeed then
      if not me:IsCurSafeZone(me.cellPos) then
        me:SetMoveSpeed(me:GetMoveSpeedByAttribute())
      end
    elseif k == EAttributeType.level then
      EventManager.Dispatch(Event.RefreshShop, {levelChange = true})
    end
  end
end

function MeController.ReleaseComboSkill()
  if HPData.GetComboPercent() >= 1 then
    local comboSkillId = SkillUtility.GetMeComboSkill()
    if not comboSkillId then
      return
    end
    local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(comboSkillId)
    local target = RoleManager.me.TargetAvatar
    local res = RoleUtility.TargetIsFitMyPkMode(target)
    if res then
      SkillMgr.RequestComboSkill(comboSkillId, target.id)
    else
      target = RoleTargetManager.GetRoleTarget(skillConfig.releaseDistance)
      if target then
        SkillMgr.RequestComboSkill(comboSkillId, target.id)
      else
        SkillMgr.RequestComboSkill(comboSkillId)
      end
    end
  end
end

function MeController.RefreshOperationFashion(id, data, isUninstall)
  if data ~= nil and data.isNeedActive ~= true then
    local appear = gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():GetShowCouturJson(data.showType, isUninstall)
    ForgeData.appearData[RoleManager.me.id] = appear
    networkRequest.ReqOperationFashion(data.showType, isUninstall == true and 0 or data.fashionId, 3)
    EventManager.Dispatch(Event.Appear_CouturJsonChange)
  end
end
