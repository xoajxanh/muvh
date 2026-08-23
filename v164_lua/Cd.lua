Cd = class()
setgetters(Cd, {
  endTime = function(self)
    return self.data.endTime
  end,
  type = function(self)
    return self.data.type
  end,
  id = function(self)
    return self.data.key
  end
})

function Cd:ctor(avatar, data)
  self.avatar = avatar
  self:Init(data)
end

function Cd:Init(data)
  self.data = data
end

function Cd:UpdateCd()
end

function Cd:SetEndTime(endTime)
  self.endTime = endTime
end

function Cd:ReduceCd(reduceCdTime)
  self.endTime = self.endTime - reduceCdTime
end

OthersCd = class(Cd)

function OthersCd:UpdateCd(endTime)
  self.endTime = endTime
end

CommonSkillCd = class(Cd)

function CommonSkillCd:UpdateCd(endTime)
  self.endTime = endTime
end

FixSkillCd = class(Cd)

function FixSkillCd:UpdateCd()
  local sid = ViewData.meData.skills[self.id].sid
  local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(sid)
  local cdTime = skillConfig.cdTime
  local publicCdTime = skillConfig.publicCD
  local curTime = Time.GetServerTime()
  local useSkillEndTime = cdTime + curTime
  local publicSkillEndTime = publicCdTime + curTime
  self.endTime = useSkillEndTime
  self.avatar:UpdateCommonCd(publicSkillEndTime)
end

NormalSkillCd = class(Cd)

function NormalSkillCd:UpdateCd()
  local sid = ViewData.meData.skills[self.id].sid
  local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(sid)
  local resAttackSpeedUp = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.attackSpeedIncrease) / 10000
  local cdTime = SkillUtility.GetCdTime(skillConfig) / resAttackSpeedUp
  cdTime = Mathf.Floor(cdTime)
  local publicCdTime = skillConfig.publicCD / resAttackSpeedUp
  local curTime = Time.GetServerTime()
  local useSkillEndTime = cdTime + curTime
  local publicSkillEndTime = publicCdTime + curTime
  publicSkillEndTime = Mathf.Floor(publicSkillEndTime)
  self.endTime = useSkillEndTime
  self.avatar:UpdateCommonCd(publicSkillEndTime)
end

ChargeSkillCd = class(Cd)

function ChargeSkillCd:Init(data)
  self.data = data
  self.preSkillTime = Time.GetServerTime()
end

function ChargeSkillCd:UpdateCd()
  local sid = ViewData.meData.skills[self.id].sid
  local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(sid)
  local resAttackSpeedUp = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.attackSpeedIncrease) / 10000
  local cdTime = Mathf.Floor(skillConfig.cdTime / resAttackSpeedUp)
  if skillConfig.cdTimeType == 1 then
    cdTime = skillConfig.cdTime
  end
  local chargingTimes = SkillUtility.GetChargingTimes(skillConfig)
  local startEndTime = Time.GetServerTime() - (chargingTimes - 1) * cdTime
  if not self.endTime then
    if chargingTimes - 1 < 0 then
      self.endTime = startEndTime
    else
      self.endTime = startEndTime + cdTime
    end
  elseif chargingTimes - 1 < 0 then
    self.endTime = startEndTime
  else
    self.endTime = Mathf.Max(self.endTime, startEndTime) + cdTime
  end
  self.preSkillTime = Time.GetServerTime()
  local publicCdTime = skillConfig.publicCD / resAttackSpeedUp
  local curTime = Time.GetServerTime()
  local publicSkillEndTime = publicCdTime + curTime
  publicSkillEndTime = Mathf.Floor(publicSkillEndTime)
  self.avatar:UpdateCommonCd(publicSkillEndTime)
end
