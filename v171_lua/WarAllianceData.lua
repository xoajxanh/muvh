WarAllianceData = {}
local this = WarAllianceData
WarAllianceData.ArmbandsDesignGridNum = 64
WarAllianceData.ArmbandsDesignGridData = {}
WarAllianceData.ColorGridNum = 16
WarAllianceData.ColorGridData = {
  [1] = "0xD9D9D9FF",
  [2] = "0x000000FF",
  [3] = "0x5C5A5AFF",
  [4] = "0xFFFFFFFFF",
  [5] = "0xFF0000FF",
  [6] = "0xFF8100FF",
  [7] = "0xFFF400FF",
  [8] = "0x31FF00FF",
  [9] = "0x00FF71FF",
  [10] = "0x25A41CFF",
  [11] = "0x1B2EA4FF",
  [12] = "0x5060C3FF",
  [13] = "0x0F23A2FF",
  [14] = "0x7719CFFF",
  [15] = "0x8937A9FF",
  [16] = "0x721A20FF"
}
WarAllianceData.BadgeColorData = {}
for index, value in pairs(ClientTable.cfg_union_badge_defaultManager:GetDic()) do
  local data = {}
  if value ~= nil and value.pointMap ~= nil then
    local arr = string.split(value.pointMap, "#")
    for i, num in ipairs(arr) do
      table.insert(data, tonumber(num))
    end
    table.insert(WarAllianceData.BadgeColorData, data)
  end
end
WarAllianceData.lucencyColor = 3654932991
WarAllianceData.MyWarAllianceData = {}
WarAllianceData.WarAllianceDataList = {}
WarAllianceData.MemberList = {}
WarAllianceData.AllUnionLogoData = {}
WarAllianceData.MasterMemberInfo = nil
WarAllianceData.MyArmbandData = {}
WarAllianceData.MyArmbandColorData = {}
WarAllianceData.MyAuditListData = {}
WarAllianceData.IsHaveUnion = false
WarAllianceData.WarAllianceDonateType = {
  10030001,
  10030002,
  10030003
}
WarAllianceData.WarAllianceDonateData = {}
WarAllianceData.CreatOrChange = 1
WarAllianceData.ImpeachInfo = nil
WarAllianceData.CampaignInfo = nil
WarAllianceData.ReplaceInfo = nil
WarAllianceData.IsShowImpeachRedPoint = true
WarAllianceData.IsShowCampaignRedPoint = true
WarAllianceData.IsShowReplaceRedPoint = true

function WarAllianceData.Init()
  this.ResetData()
  this.MyWarAllianceData.exp = 0
  this.transId = 100123
end

function WarAllianceData.ClearUnionData()
  WarAllianceData.MyWarAllianceData = {}
  WarAllianceData.WarAllianceDataList = {}
  WarAllianceData.MemberList = {}
  WarAllianceData.MasterMemberInfo = nil
  WarAllianceData.MyArmbandData = {}
  WarAllianceData.MyArmbandColorData = {}
  WarAllianceData.MyAuditListData = {}
  WarAllianceData.WarAllianceDonateData = {}
  WarAllianceData.AllUnionLogoData = {}
  WarAllianceData.ImpeachInfo = nil
  WarAllianceData.CampaignInfo = nil
  WarAllianceData.ReplaceInfo = nil
  WarAllianceData.IsShowImpeachRedPoint = true
  WarAllianceData.IsShowCampaignRedPoint = true
  WarAllianceData.IsShowReplaceRedPoint = true
end

function WarAllianceData.InitMyWarAlliance(data)
  if data ~= nil then
    this.MyWarAllianceData = data
    WarAllianceData.IsHaveUnion = true
    WarAllianceData:HaveUnion(IndexerEnum.dis, true)
    this.AllUnionLogoData[data.id] = data.logo
  else
    this.MyWarAllianceData = {}
  end
  EventManager.Dispatch(Event.WarAlliance_MyWarAllianceData)
end

function WarAllianceData.InitWarAllianceList(data)
  this.WarAllianceDataList = {}
  if data ~= nil then
    local dataInfo = data.info
    this.WarAllianceDataList = {}
    for i = 1, #dataInfo do
      this.WarAllianceDataList[i] = dataInfo[i]
    end
  end
  EventManager.Dispatch(Event.WarAlliance_InitWarAllianceList)
end

function WarAllianceData.InitMemberList(data)
  if data ~= nil then
    WarAllianceData.MasterMemberInfo = nil
    local dataInfo = data.info
    this.MemberList = {}
    for i = 1, #dataInfo do
      this.MemberList[i] = dataInfo[i]
      if dataInfo[i].position == WarAllianceMemberType.Leader then
        WarAllianceData.MasterMemberInfo = dataInfo[i]
      end
    end
  end
  EventManager.Dispatch(Event.WarAlliance_MasterMemberInfo)
  EventManager.Dispatch(Event.WarAlliance_MemberList)
end

function WarAllianceData.UpdateMemberList(data)
  if data ~= nil then
    for i = 1, #this.MemberList do
      if data.id == this.MemberList[i].id then
        table.remove(this.MemberList, i)
        EventManager.Dispatch(Event.WarAlliance_UpdateMemberList)
        break
      end
    end
  end
end

function WarAllianceData.UpdateAuditList(data)
  this.MyAuditListData = {}
  if data ~= nil then
    this.MyAuditListData = data
    EventManager.Dispatch(Event.WarAlliance_Manager)
  end
end

function WarAllianceData.IsUnionMember(rid)
  local isUnionMember = false
  for i = 1, #this.MemberList do
    if this.MemberList[i].id == rid then
      isUnionMember = true
    end
  end
  return isUnionMember
end

function WarAllianceData.InitMyArmbandData(data)
  if data ~= nil and data.id ~= 0 then
    this.MyArmbandData = data
    this.AllUnionLogoData[data.id] = data.logo
    EventManager.Dispatch(Event.WarAlliance_MyArmbandData)
  elseif UIManager.IsVisible(UIID.WarAlliance_menuUI) then
    EventManager.Dispatch(Event.WarAlliance_Leave, data)
  else
    WarAllianceData.RemoveArmband()
    if SceneData.mapId == 1035001 then
      NetManager.Send(MapMessage.ReqExitInstance)
    end
  end
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

local Avatar

function WarAllianceData:CreatArmband(AvatarEquip)
end

function WarAllianceData:RemoveArmband(AvatarEquip)
end

function WarAllianceData:GetColorRGBA(color)
  local colorStr = color
  local r = string.sub(colorStr, 6, 10)
  local g = string.sub(colorStr, 13, 17)
  local b = string.sub(colorStr, 20, 24)
  local a = string.sub(colorStr, 27, 31)
  return r, g, b, a
end

function WarAllianceData:UpdateData()
  this.ResetData()
end

function WarAllianceData:ResetData()
  if ViewData.meData and ViewData.meData.unionId ~= 0 then
    this.IsHaveUnion = true
    this:HaveUnion(IndexerEnum.dis, true)
    EventManager.Dispatch(Event.WarAlliance_InitWarAllianceList)
  else
    this.IsHaveUnion = false
    this:HaveUnion(IndexerEnum.dis, false)
  end
end

function WarAllianceData.InitLimitTime()
  local curTime = Time.GetServerSecondTime()
  local timeTbl = os.date("*t", curTime)
  return timeTbl
end

function WarAllianceData.GetIsSameUnion(id)
  local player = RoleManager.GetRoleById(id)
  if player and ViewData.meData.unionId == player.data.unionId then
    return true
  end
  return false
end

function WarAllianceData.GetDonateType(typeID)
  this.WarAllianceDonateData = {}
  for k, v in pairs(this.WarAllianceDonateType) do
    local donateType = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(v), "#")
    table.insert(this.WarAllianceDonateData, donateType)
  end
  return this.WarAllianceDonateData
end

function WarAllianceData.GetIsLucencyColor(r, g, b, a)
  if tonumber(r) == this.lucencyColor[1] and tonumber(g) == this.lucencyColor[2] and tonumber(b) == this.lucencyColor[3] and tonumber(a) == this.lucencyColor[4] then
    return true
  end
  return false
end

function WarAllianceData.RefreshImpeachInfo(msg)
  WarAllianceData.ImpeachInfo = msg
  EventManager.Dispatch(Event.WarAlliance_ImpeachInfo)
end

function WarAllianceData.RefreshCampaignInfo(msg)
  WarAllianceData.CampaignInfo = msg
  EventManager.Dispatch(Event.WarAlliance_CampaignInfo)
end

function WarAllianceData.RefreshReplaceInfo(msg)
  WarAllianceData.ReplaceInfo = msg
  EventManager.Dispatch(Event.WarAlliance_ReplaceInfo)
end

function WarAllianceData.IsJoinCampaign()
  local condition = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(10010101)
  return ConditionManager.Check(condition)
end

function WarAllianceData.IsJoinReplace()
  local condition = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(10010303)
  return ConditionManager.Check(condition)
end

function WarAllianceData.IsJoinedCampaign()
  local info = WarAllianceData.CampaignInfo
  if info == nil then
    return false
  end
  for id, vote_num in pairs(info.roleInfo) do
    if id == ViewData.meData.id then
      return true
    end
  end
  return false
end

function WarAllianceData.IsJoinedReplace()
  local info = WarAllianceData.ReplaceInfo
  if info == nil then
    return false
  end
  for index, roleInfo in ipairs(info.info) do
    if roleInfo.roleId == ViewData.meData.id then
      return true
    end
  end
  return false
end

function WarAllianceData.IsShowCampaign()
  local data = WarAllianceData.MyWarAllianceData
  if data.leaderName == "" then
    return true
  end
  return false
end

function WarAllianceData.IsShowImpeach()
  if WarAllianceData.IsShowCampaign() then
    return false
  end
  if WarAllianceData.IsShowReplace() then
    return false
  end
  if WarAllianceData.MasterMemberInfo == nil then
    return false
  end
  if WarAllianceData.MasterMemberInfo.id == ViewData.meData.id then
    return false
  end
  if ClientTable.cfg_union_memberManager:TryGetValue(WarAllianceData.MyWarAllianceData.position, "id").impeach ~= 1 then
    return false
  end
  return true
end

function WarAllianceData.IsShowReplace()
  local data = WarAllianceData.MasterMemberInfo
  if data == nil then
    return false
  end
  if WarAllianceData.IsShowCampaign() then
    return false
  end
  if WarAllianceData.MasterMemberInfo.id == ViewData.meData.id then
    return false
  end
  if data.mapId ~= 0 then
    return false
  end
  local offset = Time.GetServerTime() - data.logoutTime
  local maxOffset
  maxOffset = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(10010301))
  if ConditionManager.Check({
    {901, 1},
    {903, 4}
  }) and offset > maxOffset then
    return true
  end
  maxOffset = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(10010302))
  if ConditionManager.Check({
    {901, 5}
  }) and offset > maxOffset then
    return true
  end
  return false
end

function WarAllianceData.IsImpeaching()
  local info = WarAllianceData.ImpeachInfo
  if info == nil then
    return false
  end
  if info.initiatorName == "" then
    return false
  end
  return true
end

function WarAllianceData.IsCampaigning()
  local info = WarAllianceData.CampaignInfo
  if info == nil then
    return false
  end
  if info.rid == 0 then
    return false
  end
  return true
end

function WarAllianceData.IsReplaceing()
  local info = WarAllianceData.ReplaceInfo
  if info == nil then
    return false
  end
  if info.rid == 0 then
    return false
  end
  return true
end

function WarAllianceData.UnionLogoSave(data)
  if data and data.logo then
    for i = 1, table.count(data.logo) do
      this.AllUnionLogoData[data.logo[i].unionId] = data.logo[i].logo
    end
  end
end

function WarAllianceData.GetUnionLogoById(unionID)
  for k, v in pairs(this.AllUnionLogoData) do
    if k == unionID then
      return v
    end
  end
  return nil
end

function WarAllianceData.CheckActivityEnter(activityID)
  if WarAllianceData.MyWarAllianceData.id == nil then
    return WarAllianceActivityEnterCondition.NotWarAlliance
  end
  local activityCfg = ClientTable.cfg_Activity_overviewManager:TryGetValue(activityID, "activityId")
  if not ConditionManager.Check4D(activityCfg.condition) then
    return WarAllianceActivityEnterCondition.NotEnterTime
  end
  local enterCondition = activityCfg.enterCondition
  for index, condition in ipairs(enterCondition[1]) do
    if condition[1] == 101 and not ConditionManager.Check({condition}) then
      return WarAllianceActivityEnterCondition.NotLevel
    end
  end
  if not ConditionManager.Check4D(enterCondition) then
    return WarAllianceActivityEnterCondition.NotEnter
  end
  return WarAllianceActivityEnterCondition.Success
end

function WarAllianceData.TryEnterActivity(activityID, this, cb)
  local activityCfg = ClientTable.cfg_Activity_overviewManager:TryGetValue(activityID, "activityId")
  local enterCondition = WarAllianceData.CheckActivityEnter(activityID)
  if activityID == 5003 and enterCondition == WarAllianceActivityEnterCondition.NotEnterTime then
    if cb ~= nil then
      cb(this)
    end
    return
  end
  if enterCondition == WarAllianceActivityEnterCondition.NotWarAlliance then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("levelNotEnough_2"))
  elseif enterCondition == WarAllianceActivityEnterCondition.NotEnterTime then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("levelNotEnough_3"))
  elseif enterCondition == WarAllianceActivityEnterCondition.NotLevel then
    FloatingTipUtility.QuickMsg(string.format(LocalizationUtility.GetContentByKey("levelNotEnough_1"), activityCfg.showLevel))
  elseif enterCondition == WarAllianceActivityEnterCondition.NotEnter then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("CanNotBuy_3"))
  elseif enterCondition == WarAllianceActivityEnterCondition.Success and cb ~= nil then
    cb(this)
  end
end

function WarAllianceData.GetIsEnemyUnion(unionID)
  if RoleManager.me.unionId == 0 then
    return false
  end
  if this.MyWarAllianceData.enemyUnionIds and 0 < #this.MyWarAllianceData.enemyUnionIds then
    for i = 1, #this.MyWarAllianceData.enemyUnionIds do
      if this.MyWarAllianceData.enemyUnionIds[i] == unionID then
        return true
      end
    end
  end
  for i = 1, #this.WarAllianceDataList do
    if this.WarAllianceDataList[i].id == unionID then
      return this.WarAllianceDataList[i].isEnemy
    end
  end
  return false
end

function WarAllianceData.IsLeader()
  if this.MyWarAllianceData == nil then
    return false
  end
  return RoleManager.me.name == this.MyWarAllianceData.leaderName
end

function WarAllianceData:HaveUnion(_indexer, _value)
  if _indexer == IndexerEnum.dis then
    EventManager.Dispatch(Event.WarAlliance_IsHavaUnion)
  end
end

function WarAllianceData:IsMeUnion(id)
  return ViewData.meData and ViewData.meData.unionId == id
end
