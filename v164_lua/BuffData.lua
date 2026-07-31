BuffData = {}
local this = BuffData
BuffData.BuffDic = {}
BuffData.ColorDic = {}

local function GetEnumBySubType(buff_struct)
  local enumKey = ""
  if buff_struct.buffConfig and BuffSubType2Str[buff_struct.buffConfig.subType] then
    enumKey = RoleBuffState[BuffSubType2Str[buff_struct.buffConfig.subType]]
  end
  return enumKey
end

local function AddRoleBuffState(buff_struct)
  if buff_struct ~= nil then
    local roleData = ViewData.GetGameObjectInViewById(buff_struct.buffOwnerId)
    local enumKey = GetEnumBySubType(buff_struct)
    if roleData and not string.isNullOrEmpty(enumKey) then
      roleData.roleBuffData:AddState(enumKey)
    end
  end
end

local function RemoveRoleBuffState(buff_struct)
  if buff_struct ~= nil then
    local roleData = ViewData.GetGameObjectInViewById(buff_struct.buffOwnerId)
    local enumKey = GetEnumBySubType(buff_struct)
    if roleData and not string.isNullOrEmpty(enumKey) then
      roleData.roleBuffData:RemoveState(enumKey)
    end
  end
end

function BuffData.GenerateBuffStruct(data, roleId)
  local buff_struct = {}
  buff_struct.buffId = data.buffId
  buff_struct.buffCId = data.buffCId
  buff_struct.buffOwnerId = data.beAddedId or roleId
  buff_struct.attackerId = data.ownerId
  buff_struct.totalTime = 0
  buff_struct.time = 0
  buff_struct.buffConfig = ClientTable.cfg_Buff_buffManager:TryGetValue(buff_struct.buffCId, "id")
  buff_struct.count = data.count
  buff_struct.attribute = data.attribute or {}
  buff_struct.showAttribute = data.showAttribute or {}
  buff_struct.overlayNum = data.floors
  if buff_struct.buffConfig and 0 < buff_struct.buffConfig.buffPicture then
    buff_struct.mapShowConfig = ClientTable.cfg_Map_buffPictureManager:TryGetValue(buff_struct.buffConfig.buffPicture)
  end
  if buff_struct.buffConfig then
    if buff_struct.buffConfig.type == BuffTypeEnum.MultipleBuff or buff_struct.buffConfig.type == BuffTypeEnum.GoldRecoverBuff then
      buff_struct.totalTime = data.totalTime / 1000
      buff_struct.time = data.totalTime / 1000
    elseif buff_struct.buffConfig.totalTimeType == BuffTimeType.TimeAdd or buff_struct.buffConfig.totalTimeType == BuffTimeType.TimeDefaultAdd then
      buff_struct.totalTime = data.totalTime / 1000
      local tempTime = data.addTime / 1000 + buff_struct.totalTime - Time.GetServerSecondTime()
      buff_struct.time = tempTime - tempTime % 0.1
    else
      buff_struct.totalTime = buff_struct.buffConfig.totalTime / 1000
      local tempTime = data.addTime / 1000 + buff_struct.totalTime - Time.GetServerSecondTime()
      buff_struct.time = tempTime - tempTime % 0.1
      if buff_struct.buffConfig.show ~= 0 then
        buff_struct.buffAction = ConfigManager.GetConfig("cfg_buffAction", buff_struct.buffConfig.show, "id")
      end
    end
  end
  if buff_struct.buffOwnerId then
    buff_struct.buffOwner = RoleManager.GetRoleById(buff_struct.buffOwnerId)
  end
  return buff_struct
end

local replaceBuffData = {}

local function replaceBuffRemove(buff_struct)
  RemoveRoleBuffState(buff_struct)
  if buff_struct == nil or this.BuffDic[buff_struct.buffOwnerId] == nil then
    return
  end
  for i = 1, #this.BuffDic[buff_struct.buffOwnerId] do
    if this.BuffDic[buff_struct.buffOwnerId][i].buffId == buff_struct.buffId then
      table.remove(this.BuffDic[buff_struct.buffOwnerId], i)
      if #this.BuffDic[buff_struct.buffOwnerId] == 0 then
        this.BuffDic[buff_struct.buffOwnerId] = nil
      end
      return
    end
  end
end

local function replaceBuffDealWith(buff_struct)
  local item
  for i = #replaceBuffData, 1, -1 do
    item = replaceBuffData[i]
    if buff_struct.buffConfig.buffGroup == item.buffConfig.buffGroup then
      replaceBuffRemove(item)
      table.remove(replaceBuffData, i)
    end
  end
end

function BuffData.AddBuff(buff_struct)
  AddRoleBuffState(buff_struct)
  BuffData.CheckLostTargetBuff(buff_struct)
  if this.BuffDic[buff_struct.buffOwnerId] == nil then
    this.BuffDic[buff_struct.buffOwnerId] = {}
  end
  for i = 1, #this.BuffDic[buff_struct.buffOwnerId] do
    if this.BuffDic[buff_struct.buffOwnerId][i].buffId == buff_struct.buffId then
      this.BuffDic[buff_struct.buffOwnerId][i] = buff_struct
      return
    end
  end
  table.insert(this.BuffDic[buff_struct.buffOwnerId], 1, buff_struct)
  BuffData.SummonMagicianMutualExclusionBuff(buff_struct)
end

local MutualExclusionBuff = {
  [1001400] = 1001300,
  [1001300] = 1001400
}

function BuffData.SummonMagicianMutualExclusionBuff(buff_struct)
  if this.BuffDic[buff_struct.buffOwnerId] then
    local groupId = buff_struct.buffConfig.buffGroup
    if MutualExclusionBuff[groupId] then
      for i = #this.BuffDic[buff_struct.buffOwnerId], 1, -1 do
        if this.BuffDic[buff_struct.buffOwnerId][i].buffConfig.buffGroup == MutualExclusionBuff[groupId] then
          table.remove(this.BuffDic[buff_struct.buffOwnerId], i)
          return
        end
      end
    end
  end
end

function BuffData.CheckLostTargetBuff(buff_struct)
  if not buff_struct then
    return
  end
  if RoleManager.me and buff_struct.buffOwnerId == RoleManager.me.id and QuickFind.LuaMainPlayerViewAttrData():GetBaseCareerByValue(RoleManager.me.career) ~= ERoleCareer.SwordMan and buff_struct.buffConfig and buff_struct.buffConfig.buffGroup == 26030100 then
    RoleManager.me:CloseTarget()
  end
end

function BuffData.AddColorBuff(buff_struct)
  local flag = false
  if buff_struct.buffOwnerId and (not this.ColorDic[buff_struct.buffOwnerId] or this.ColorDic[buff_struct.buffOwnerId].buff_struct.buffCId ~= buff_struct.buffCId) then
    flag = true
    if not this.ColorDic[buff_struct.buffOwnerId] then
      this.ColorDic[buff_struct.buffOwnerId] = {
        buff_struct = buff_struct,
        delayDestroy = false,
        time = 0.1
      }
    end
  end
  this.ColorDic[buff_struct.buffOwnerId].buff_struct = buff_struct
  this.ColorDic[buff_struct.buffOwnerId].delayDestroy = false
  this.ColorDic[buff_struct.buffOwnerId].time = 0.1
  return flag
end

function BuffData.RemoveColorBuff(buff_struct)
  if buff_struct == nil then
    return
  end
  this.OnRemoveColor(buff_struct)
  if this.ColorDic[buff_struct.buffOwnerId] and this.ColorDic[buff_struct.buffOwnerId].buff_struct.buffId == buff_struct.buffId then
    this.ColorDic[buff_struct.buffOwnerId].delayDestroy = true
  end
end

function BuffData.OnRemoveColor(buff_struct)
  if buff_struct.buffOwnerId and buff_struct.buffOwner and buff_struct.buffAction then
    local buffs = BuffData.GetBuffs(buff_struct.buffOwnerId)
    local colorBuffOther
    for k, v in pairs(buffs) do
      if buff_struct.buffId ~= v.buffId and v.buffAction and v.buffAction.isBuffColorSet then
        colorBuffOther = v
      end
    end
    if colorBuffOther then
      BuffEffectMgr.ChangeColor(colorBuffOther, true)
    else
      BuffEffectMgr.ChangeColor(buff_struct, false)
      BuffData.ColorDic[buff_struct.buffOwnerId] = nil
    end
  end
end

function BuffData.RemoveBuff(buff_struct)
  RemoveRoleBuffState(buff_struct)
  if buff_struct == nil or this.BuffDic[buff_struct.buffOwnerId] == nil then
    return
  end
  for i = #this.BuffDic[buff_struct.buffOwnerId], 1, -1 do
    if this.BuffDic[buff_struct.buffOwnerId][i].buffId == buff_struct.buffId then
      table.remove(this.BuffDic[buff_struct.buffOwnerId], i)
      if #this.BuffDic[buff_struct.buffOwnerId] == 0 then
        this.BuffDic[buff_struct.buffOwnerId] = nil
      end
      return
    end
  end
end

function BuffData.RemoveAllBuff()
  this.BuffDic = {}
end

function BuffData.GetBuff(roleId, buffCId)
  if this.BuffDic[roleId] == nil then
    return nil
  end
  for i = 1, #this.BuffDic[roleId] do
    if this.BuffDic[roleId][i].buffCId == buffCId then
      return this.BuffDic[roleId][i]
    end
  end
  return nil
end

function BuffData.IsHasBuff(roleId, buffCId)
  if this.BuffDic[roleId] == nil then
    return nil
  end
  local buffData = ClientTable.cfg_Buff_buffManager:TryGetValue(buffCId)
  for i = 1, #this.BuffDic[roleId] do
    local buffId = this.BuffDic[roleId][i].buffCId
    local buffConfig = ClientTable.cfg_Buff_buffManager:TryGetValue(buffId)
    if buffConfig ~= nil and buffData ~= nil and buffConfig.buffGroup == buffData.buffGroup then
      return true
    end
  end
  return false
end

function BuffData.IsHasBuffStateByGroupId(roleId, buffGroupId)
  if this.BuffDic[roleId] == nil then
    return nil
  end
  for i = 1, #this.BuffDic[roleId] do
    if not this.BuffDic[roleId][i].buffConfig then
      return false
    end
    local GroupId = this.BuffDic[roleId][i].buffConfig.buffGroup
    if GroupId == buffGroupId then
      return true
    end
  end
  return false
end

function BuffData.GetBuffs(roleId)
  return this.BuffDic[roleId] or {}
end

function BuffData.GetFirstBuffByType(roleId, buffType)
  if this.BuffDic[roleId] == nil then
    return nil
  end
  local buff
  for i = 1, #this.BuffDic[roleId] do
    buff = this.BuffDic[roleId][i]
    if buff and buff.buffConfig ~= nil and buff.buffConfig.type == buffType then
      return buff
    end
  end
  return nil
end

BuffData.BuffEffectPool = {}

function BuffData.AddBuffEffectToPool(bid, gobj)
  if this.BuffEffectPool[bid] == nil then
    this.BuffEffectPool[bid] = {}
  end
  table.insert(this.BuffEffectPool[bid], gobj)
end

function BuffData.GetSkillEffect(bid)
  if this.BuffEffectPool[bid] ~= nil and table.count(this.BuffEffectPool[bid]) > 0 then
    local gobj = this.BuffEffectPool[bid][1]
    table.remove(this.BuffEffectPool[bid], 1)
    return gobj
  end
  return nil
end

function BuffData.GetOffsetByOffset(buffOwner, offset)
  if buffOwner ~= nil and buffOwner.dir ~= nil then
    local directionz = Direction8Utility:GetOffsetZByAngle(Mathf.Round(buffOwner.dir))
    local directionx = Direction8Utility:GetOffsetXByAngle(Mathf.Round(buffOwner.dir))
    return Vector3(directionz.x, 0, directionz.z) * offset.z + Vector3(directionx.x, 0, directionx.z) * offset.x + Vector3(0, offset.y, 0)
  end
  return Vector3(0, 0, 0)
end
