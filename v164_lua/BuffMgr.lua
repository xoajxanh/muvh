BuffMgr = {}
require("GamePlay/FightFramework/Buff/BuffEffectMgr")
require("GamePlay/FightFramework/Buff/BuffRoleAction")
require("GamePlay/FightFramework/Buff/BuffAttributeCalculator")
local this = BuffMgr
this.RemoveBuffList = {}
local intervalTime = Time.deltaTime

local function BuffDelayRemove()
  local item, ownerItem
  for i = #this.RemoveBuffList, 1, -1 do
    item = this.RemoveBuffList[i]
    if item then
      item.delayDestroyTime = item.delayDestroyTime - intervalTime
      if item.delayDestroyTime < 0 then
        local buffs = BuffData.GetBuffs(item.buffOwnerId)
        for n = #buffs, 1, -1 do
          ownerItem = buffs[n]
          if ownerItem.buffId == item.buffId then
            BuffMgr.RemoveBuff(ownerItem)
            this.RoleBuffAttributeCheck(ownerItem, false)
          end
        end
        table.remove(this.RemoveBuffList, i)
      end
    end
  end
end

local lastFrameTime = 0

function BuffMgr.Update()
  intervalTime = Time.unscaledTime - lastFrameTime
  lastFrameTime = Time.unscaledTime
  BuffDelayRemove()
  for k, v in pairs(BuffData.BuffDic) do
    for i = #v, 1, -1 do
      if v[i] then
        if v[i].time > 0 then
          v[i].time = v[i].time - intervalTime
        elseif v[i].time < 0 then
          v[i].time = 0
          if 0 < v[i].totalTime then
            this.OnTimeOver(v[i])
          end
        end
      end
    end
  end
  for _, v in pairs(BuffData.ColorDic) do
    if v.delayDestroy then
      v.time = v.time - Time.deltaTime
      if v.time < 0 then
        BuffData.OnRemoveColor(v.buff_struct)
      end
    end
  end
  BuffEffectMgr.Update()
end

function BuffMgr.AddBuff(buff_struct)
  BuffData.AddBuff(buff_struct)
  if buff_struct.buffOwner then
    if buff_struct.buffOwner.RoleType == ERoleType.Player then
      if buff_struct.buffOwner.isShowModel then
        this.LoadBuffEffect(buff_struct)
      end
      if buff_struct.buffOwner:IsArchangeActive(buff_struct.buffCId) then
        buff_struct.buffOwner:ArchangelSkillChange(true)
      end
      BuffMgr.PlayerBuffChangeFunc(buff_struct, EBuffOperationType.Add)
      if (buff_struct.buffConfig.subType == 203 or buff_struct.buffConfig.subType == 209) and buff_struct.buffOwner.CloakingBufferAction then
        buff_struct.buffOwner.buffCloakingState = true
        buff_struct.buffOwner:CloakingBufferAction(true)
      end
    else
      this.LoadBuffEffect(buff_struct)
    end
  end
end

function BuffMgr.RemoveBuff(buff_struct)
  if buff_struct == nil then
    return
  end
  if buff_struct.buffOwner and buff_struct.buffAction then
    if not string.isNullOrEmpty(buff_struct.buffAction.animationName) then
      BuffRoleAction.RemoveAction(buff_struct.buffOwner, buff_struct.removeType)
    end
    if buff_struct.buffAction.isBuffColorSet then
      BuffData.RemoveColorBuff(buff_struct)
    end
    if buff_struct.buffAction and buff_struct.buffAction.prefabs and #buff_struct.buffAction.prefabs > 0 then
      BuffEffectMgr.Destroy(buff_struct.buffId, buff_struct.removeType, buff_struct.buffOwnerId)
    end
  end
  if buff_struct.buffOwner and buff_struct.buffOwner.RoleType == ERoleType.Player then
    if buff_struct.buffOwner:IsArchangeActive(buff_struct.buffCId) then
      buff_struct.buffOwner:ArchangelSkillChange(false, 0)
    end
    BuffMgr.PlayerBuffChangeFunc(buff_struct, EBuffOperationType.Remove)
  end
  if buff_struct.buffOwner and buff_struct.buffConfig and (buff_struct.buffConfig.subType == 203 or buff_struct.buffConfig.subType == 209) then
    local cloakingState
    if buff_struct.buffConfig.subType == 232 and buff_struct.buffOwner and buff_struct.buffOwner.RoleType == ERoleType.Player then
      local buffs = BuffData.GetBuffs(buff_struct.buffOwner.id)
      for k, v in pairs(buffs) do
        if v.buffConfig.subType == 203 then
          cloakingState = true
          break
        end
      end
    end
    if buff_struct.buffOwner.CloakingBufferAction and not cloakingState then
      buff_struct.buffOwner.buffCloakingState = false
      buff_struct.buffOwner:CloakingBufferAction(false)
    end
  end
  BuffData.RemoveBuff(buff_struct)
  if buff_struct.buffOwner and buff_struct.buffOwner.RoleType == ERoleType.Player then
    BuffMgr.PlayerBuffChangeFunc(buff_struct, EBuffOperationType.Remove)
  end
end

function BuffMgr.ChangeBuff(msg)
  if msg.buffCId then
    local buff_struct = BuffData.GetBuff(msg.changeId, msg.buffCId)
    if buff_struct then
      buff_struct.count = msg.count
      buff_struct.overlayNum = msg.floors
      EventManager.Dispatch(Event.Buff_RefreshMainPlayerSingleBuff, msg.buffCId)
    end
  end
end

function BuffMgr.ChangeAllBuff(msg)
  if msg == nil or msg.changeList == nil then
    return
  end
  for i = 1, #msg.changeList do
    if msg.changeList[i].buffCId then
      local buff_struct = BuffData.GetBuff(msg.changeList[i].changeId, msg.changeList[i].buffCId)
      if buff_struct then
        buff_struct.count = msg.changeList[i].count
        buff_struct.overlayNum = msg.changeList[i].floors
      end
    end
  end
  if #msg.changeList <= 0 then
    return
  end
  EventManager.Dispatch(Event.Buff_RefreshMainPlayerAllBuff, msg.changeList)
end

local buffAttrByHp = {
  [30001008] = 1000,
  [30001009] = 2000,
  [30001010] = 3000,
  [30001011] = 1000,
  [30001012] = 2000,
  [30001013] = 3000,
  [30002007] = 1000,
  [30002008] = 2000,
  [30002009] = 3000,
  [30002010] = 1000,
  [30002011] = 2000,
  [30002012] = 3000
}

function BuffMgr.RoleBuffAttributeCheck(buff_struct, isAdd)
  if buff_struct.buffOwnerId == ViewData.meData.id then
    EventManager.Dispatch(Event.Buff_RefreshRoleBuff)
    if buff_struct.attribute and next(buff_struct.attribute) ~= nil or buff_struct.showAttribute and next(buff_struct.showAttribute) ~= nil then
      EventManager.Dispatch(Event.Buff_RefreshRoleBuffAttr)
    end
    if buffAttrByHp[buff_struct.buffConfig.id] then
      ViewData.meData:SetAttributeByHpBuff(ViewData.meData.hp)
    end
  else
    if buff_struct.buffConfig.subType == 102 then
    end
    EventManager.Dispatch(Event.Buff_RefreshLid, buff_struct.buffOwnerId)
  end
  if buff_struct.buffConfig.subType == 207 then
    if isAdd then
      if buff_struct.buffOwnerId == ViewData.meData.id then
        buff_struct.buffOwner.buffCantMove = true
        buff_struct.buffOwner:StopMoveImmediate()
        UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
      end
    elseif buff_struct.buffOwnerId == ViewData.meData.id then
      buff_struct.buffOwner.buffCantMove = false
      buff_struct.buffOwner:SetMoveSpeed(buff_struct.buffOwner:GetMoveSpeed())
      Main_JoyStickUI:ResetCurrentCell(buff_struct.buffOwner.cellPos)
    end
  end
  if buff_struct.buffConfig and ClientTable.cfg_Global_globalManager:CheckIsChangeMoveSpeedBuffBySubType(buff_struct.buffConfig.subType) and buff_struct.buffOwnerId == ViewData.meData.id then
    buff_struct.buffOwner:SetMoveSpeed(buff_struct.buffOwner:GetMoveSpeed())
    buff_struct.buffOwner:RefreshAnimationSpeed()
  end
  if buff_struct.buffConfig and (buff_struct.buffConfig.subType == 203 or buff_struct.buffConfig.subType == 209) and buff_struct.buffOwner and buff_struct.buffOwner.RoleType == ERoleType.Player and buff_struct.buffOwner.id ~= RoleManager.me.id and TeamUtility.IsTeammate(buff_struct.buffOwner.id) == false then
    buff_struct.buffOwner:SetModelCloakingShowHidden(not isAdd)
    if isAdd then
      EventManager.Dispatch(Event.OtherPlayerEnterCloaking, buff_struct.buffOwner.data)
    else
      EventManager.Dispatch(Event.OtherPlayerExitCloaking, buff_struct.buffOwner.data)
    end
  end
  if buff_struct.buffOwner and BuffMgr.CheckHideModelByBuff(buff_struct) then
    local scale = isAdd and 0.01 or DragonFlyEffect:GetModelScale()
    buff_struct.buffOwner.model:SetModelScale(scale)
  end
end

function BuffMgr.CheckHideModelByBuff(buff_struct)
  if not BuffMgr.HideModelBuff then
    BuffMgr.HideModelBuff = {}
    local globalEffect = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2430018)
    local info = string.split(globalEffect, "#")
    for i, v in pairs(info) do
      BuffMgr.HideModelBuff[tonumber(v)] = tonumber(v)
    end
  end
  if buff_struct.buffConfig and buff_struct.buffConfig.buffGroup and BuffMgr.HideModelBuff[buff_struct.buffConfig.buffGroup] then
    return true
  end
  return false
end

function BuffMgr.RoleEnterView(buf, roleId)
  if not buf then
    return
  end
  for _, data in pairs(buf) do
    local buff_struct = BuffData.GenerateBuffStruct(data, roleId)
    this.AddBuff(buff_struct)
    BuffMgr.RoleBuffAttributeCheck(buff_struct, true)
  end
end

function BuffMgr.RoleExit(rid)
  this.RemoveAllBuffOwnerID(rid)
end

function BuffMgr.RemoveAllBuffOwnerID(ownerId)
  if BuffData.ColorDic[ownerId] then
    BuffData.OnRemoveColor(BuffData.ColorDic[ownerId].buff_struct)
  end
  if BuffData.BuffDic[ownerId] == nil then
    return
  end
  for i = #BuffData.BuffDic[ownerId], 1, -1 do
    BuffMgr.RemoveBuff(BuffData.BuffDic[ownerId][i])
  end
end

function BuffMgr.RemoveAllBuff()
  local buffItem
  for k, v in pairs(BuffData.BuffDic) do
    for i = #v, 1, -1 do
      buffItem = v[i]
      if buffItem then
        this.RemoveBuff(buffItem)
      end
    end
    if k == ViewData.meData.id then
      EventManager.Dispatch(Event.Buff_RefreshRoleBuff)
    end
    EventManager.Dispatch(Event.Buff_RefreshLid, k)
  end
end

function BuffMgr.CheckMainPlayerBuffer()
end

function BuffMgr.LoadBuffEffect(buff_struct)
  if buff_struct.buffOwner and buff_struct.buffAction and buff_struct.buffAction then
    if not string.isNullOrEmpty(buff_struct.buffAction.animationName) then
      BuffRoleAction.PlayAction(buff_struct)
    end
    if buff_struct.buffAction.isBuffColorSet and BuffData.AddColorBuff(buff_struct) then
      BuffEffectMgr.ChangeColor(buff_struct, true)
    end
    if buff_struct.buffAction and buff_struct.buffAction.prefabs and #buff_struct.buffAction.prefabs > 0 then
      for i = 1, #buff_struct.buffAction.prefabs do
        BuffEffectMgr.AddEffect(buff_struct, buff_struct.buffAction.prefabs[i])
      end
    end
  end
end

function BuffMgr.OnRoleDead(rid)
end

function BuffMgr.OnRoleRelive(rid)
end

function BuffMgr.OnSkillRecycle(sid)
end

function BuffMgr.OnFightOver(rid)
end

function BuffMgr.OnSkilledOver(rid)
end

function BuffMgr.OnTimeOver(buffStruct)
  buffStruct.delayDestroyTime = 3
  table.insert(this.RemoveBuffList, buffStruct)
  if LoginData.reconnectState then
    this.RemoveBuff(buffStruct)
    this.RoleBuffAttributeCheck(buffStruct, false)
  end
end

function BuffMgr.OnNPCRelive(buffId)
end

function BuffMgr.PlayerBuffChangeFunc(buff_struct, reason)
  if buff_struct == nil then
    return
  end
  if buff_struct.buffConfig and buff_struct.buffConfig.type == BuffTypeEnum.KaLunTeBoxBuff then
    EventManager.Dispatch(Event.TaLunTeBoxBuffChanged, {
      rid = buff_struct.buffOwnerId,
      time = buff_struct.time,
      buffSubType = buff_struct.buffConfig and buff_struct.buffConfig.subType or 0,
      type = reason
    })
  elseif buff_struct.buffConfig and buff_struct.buffConfig.type == BuffTypeEnum.RankBuff then
    EventManager.Dispatch(Event.RankBuffChanged, {
      rid = buff_struct.buffOwnerId,
      buffId = buff_struct.buffConfig and buff_struct.buffConfig.id or 0,
      type = reason
    })
  elseif buff_struct.buffConfig and buff_struct.buffConfig.type == FourPartyRivalryConstant.FlagBuffType then
    EventManager.Dispatch(Event.RefreshFourPartyRivalryCampFlagIcon, {
      rid = buff_struct.buffOwnerId,
      buffId = buff_struct.buffConfig and buff_struct.buffConfig.id or 0,
      type = reason
    })
  elseif buff_struct.buffConfig and buff_struct.buffConfig.id == FourPartyRivalryManager.m_ReviveBuffId then
    EventManager.Dispatch(Event.RefreshFourPartyRivalryCampFlagIcon, {
      rid = buff_struct.buffOwnerId,
      buffId = buff_struct.buffConfig and buff_struct.buffConfig.id or 0,
      type = reason
    })
  end
end
