require("GamePlay/Role/Animation/AnimationConfig")
AnimatorCtrl = class()
local Animator = CS.UnityEngine.Animator
local speedTimesData = {}
local weaponIndex = {
  OneHand = 1,
  Dweapon = 2,
  TStaff = 3,
  TSword = 4,
  Spear = 5,
  Bow = 6,
  Crossbow = 7
}
setmetatable(weaponIndex, {
  __index = function()
    return 0
  end
})
local mountIndex = {
  Fenrilred = 1,
  Fenrilblack = 1,
  Fenrilblue = 1,
  Fenrilgold = 1,
  Rider01 = 2,
  Rider02 = 2,
  DarkHorse = 3,
  Lanma = 3,
  Xianlu = 3,
  Baihu = 3,
  Tianma = 3,
  Xiyijushou = 3,
  Heisemoxie = 9,
  Mengmaxiang = 10,
  ["51Long"] = 11,
  Beijixiong = 3,
  Bingshuangjulong = 12,
  yangjiaoyouyishou = 13,
  Xukongyu = 14,
  Yanmiezhuzai = 15,
  Wanglingmotuo = 17,
  Shiwang = 21,
  Shiwang1 = 21,
  Shiwang2 = 21,
  Shiwang3 = 21,
  Shiwang4 = 21
}
setmetatable(mountIndex, {
  __index = function()
    return 0
  end
})
local wingIndex = {Wing = 1}
setmetatable(wingIndex, {
  __index = function()
    return 0
  end
})
local swimIndex = {Swim = 1}
setmetatable(swimIndex, {
  __index = function()
    return 0
  end
})
local prefixToParameters = {
  Fenrilred = "Mount",
  Fenrilblack = "Mount",
  Fenrilblue = "Mount",
  Fenrilgold = "Mount",
  Rider01 = "Mount",
  Rider02 = "Mount",
  Lanma = "Mount",
  DarkHorse = "Mount",
  Xianlu = "Mount",
  Baihu = "Mount",
  OneHand = "Weapon",
  Dweapon = "Weapon",
  TStaff = "Weapon",
  TSword = "Weapon",
  Spear = "Weapon",
  Bow = "Weapon",
  Crossbow = "Weapon",
  Wing = "Wing",
  Swim = "Swim",
  Tianma = "Mount",
  ["51Long"] = "Mount",
  Heisemoxie = "Mount",
  Xiyijushou = "Mount",
  Mengmaxiang = "Mount",
  Beijixiong = "Mount",
  Bingshuangjulong = "Mount",
  yangjiaoyouyishou = "Mount",
  Xukongyu = "Mount",
  Yanmiezhuzai = "Mount",
  Wanglingmotuo = "Mount",
  Shiwang = "Mount",
  Shiwang1 = "Mount",
  Shiwang2 = "Mount",
  Shiwang3 = "Mount",
  Shiwang4 = "Mount"
}
local loopMotion = {
  none = true,
  idle = true,
  walk = true,
  run = true,
  swimidle = true,
  swim = true,
  fastswim = true,
  dead = true
}
local parameters = {
  "Weapon",
  "Wing",
  "Mount",
  "Swim"
}
local AnimatorTriggerLayer = {
  none = 1,
  idle = 1,
  walk = 1,
  run = 1,
  beattack = 1,
  swimidle = 1,
  swim = 1,
  fastswim = 1,
  showstand = 1,
  sit = 1,
  leanOn = 1,
  allSit = 1,
  flyUp = 1,
  stand = 1,
  attack = 1,
  dead = 3,
  alive = 3
}
setmetatable(AnimatorTriggerLayer, {
  __index = function()
    return 2
  end
})

function AnimatorCtrl:ResetIntParameter()
  for i = 1, #parameters do
    self.animator:SetInteger(parameters[i], 0)
  end
end

function AnimatorCtrl:SetAnimatorSpeed(speed)
  if not self.animator or not self.animator.gameObject.activeSelf then
    return
  end
  self.animator.speed = speed
end

function AnimatorCtrl:PlayTest(name, speed, callback)
  if not (not IsNil(self.animator) and self.animator) or not self.animator.gameObject.activeSelf then
    return
  end
  if not self.forceUpdate then
    return
  end
  local finalName = self:GetFullAnimationName(name)
  if loopMotion[name] and self.finalName == finalName then
    return
  end
  self.finalName = finalName
  if name == "dead" and callback then
    local hash = Animator.StringToHash(self.finalName)
    self.animator:Play(hash, callback, 2)
    return
  end
  speed = speed or 1
  self:SetAnimatorSpeed(speed)
  if self.avatar and self.avatar.RoleType == ERoleType.Player then
    self:ResetIntParameter()
  end
  local nameTags = string.split(self.finalName, "_")
  local count = #nameTags
  for i = 1, count do
    if i ~= count then
      local index1 = weaponIndex[nameTags[i]]
      local index2 = mountIndex[nameTags[i]]
      local index3 = wingIndex[nameTags[i]]
      local index4 = swimIndex[nameTags[i]]
      local index = Mathf.Max(Mathf.Max(index1, index2), index3)
      index = Mathf.Max(index, index4)
      self.animator:SetInteger(prefixToParameters[nameTags[i]], index)
    else
      if self.triggerLayers[AnimatorTriggerLayer[name]] then
        self.animator:ResetTrigger(self.triggerLayers[AnimatorTriggerLayer[name]])
      end
      self.animator:SetTrigger(name)
      if AnimatorTriggerLayer[name] == 1 then
        self.originalName = name
      end
      self.triggerLayers[AnimatorTriggerLayer[name]] = name
    end
  end
end

function AnimatorCtrl:GetFullAnimationName(name)
  if name == "dead" or name == "alive" then
    return name
  end
  local finalName = name
  local hasPrefix = false
  if self.humanoid and self.weaponPrefix then
    finalName = self.weaponPrefix .. "_" .. finalName
    hasPrefix = true
  end
  if self.mountPrefix then
    finalName = self.mountPrefix .. "_" .. finalName
    hasPrefix = true
  elseif self.wingPrefix then
    finalName = self.wingPrefix .. "_" .. finalName
    hasPrefix = true
  elseif self.avatar ~= nil and self.avatar.playerEquipType == ERoleInitEquipType.datianshibianshen then
    finalName = "Wing_" .. finalName
    hasPrefix = true
  elseif self.swimPrefix then
    finalName = self.swimPrefix .. "_" .. finalName
    hasPrefix = true
  end
  return finalName
end

function AnimatorCtrl:PlayInstantAnimal(animalName, normalizeTime, layer)
  if not self.animator or not self.animator.gameObject.activeSelf then
    return
  end
  self.animator:PlayInstant(animalName, normalizeTime, layer)
end

function AnimatorCtrl:StopAnimal()
  if not self.animator or not self.animator.gameObject.activeSelf then
    return
  end
  self.animator:PlayInstant("Stop", 0, 1)
end

function AnimatorCtrl:GetAniSpeedTimes(name)
  return speedTimesData[name]
end

function AnimatorCtrl:GetAniSpeedTimesByOriginName(aniName)
  local name = self:GetAnimationName(aniName, self.weaponPrefix)
  return self:GetAniSpeedTimes(name)
end

function AnimatorCtrl:ctor(avatar)
  self.forceUpdate = false
  self.animationConfig = BaseAnimationConfig
  self.avatar = avatar
end

function AnimatorCtrl:SetConfig(animationConfig)
  self.animationConfig = animationConfig
end

function AnimatorCtrl:Init(go, humanoid, forceUpdate)
  if go then
    self.animator = go:GetComponent(typeof(Animator))
    if IsNil(self.animator) then
      self.animator = nil
    end
  else
    self.animator = nil
  end
  self.humanoid = humanoid
  self.forceUpdate = forceUpdate
  self.triggerLayers = {}
  self.finalName = ""
  self.originalName = ""
  self:InitAnimationSpeed()
  self:SetEnable(true)
  self:OnAnimatorEnable()
end

function AnimatorCtrl:InitAnimationSpeed()
  if not self.animator or not self.animator.gameObject.activeSelf then
    return
  end
  local animatorSpeed = self.animator.gameObject:GetComponent("RoleAnimatorSpeed")
  if animatorSpeed then
    animatorSpeed.AnimatorSpeed = 1
    self:ResetIntParameter()
  end
  self.animator.speed = 1
end

function AnimatorCtrl:SetEnable(enable)
  if self.animator then
    self.animator.enabled = enable
  end
end

function AnimatorCtrl:OnAnimatorEnable()
end

function AnimatorCtrl:SetWeaponPrefix(prefix)
  self.weaponPrefix = prefix
end

function AnimatorCtrl:SetMountPrefix(prefix)
  self.mountPrefix = prefix
end

function AnimatorCtrl:SetWingPrefix(prefix)
  self.wingPrefix = prefix
end

function AnimatorCtrl:SetSwimPrefix(prefix)
  self.swimPrefix = prefix
end

function AnimatorCtrl:Play(name, speed, fadeLength, normalizedTime, realTime, callback)
  self:PlayTest(name, speed, callback)
end

function AnimatorCtrl:ForceUpdate()
  self.forceUpdate = true
end

function AnimatorCtrl:PlayMount(name, speed, fadeLength, normalizedTime, realTime)
  if string.contains(name, "walk") or string.contains(name, "run") then
    self:Play(name, speed)
  else
    self:Play("idle", speed)
  end
end

function AnimatorCtrl:GetSpeedByRealTime(name, realTime)
  local tbl = ConfigManager.FindConfigs("cfg_Action_actionBaseTime", "name", name)
  if table.count(tbl) < 1 then
    return
  end
  local originTime = tonumber(tbl[1].time) * 0.001
  local speedTimes = originTime / realTime
  speedTimesData[name] = speedTimes
  return speedTimes
end

function AnimatorCtrl:GetAnimationID(name)
  return Animator.StringToHash(self:GetAnimationName(name))
end

function AnimatorCtrl:GetAnimationName(name)
  if name == "dead" or name == "alive" then
    return name
  end
  local finalName = name
  if self.humanoid and self.weaponPrefix then
    finalName = self.weaponPrefix .. "_" .. finalName
  end
  if self.mountPrefix then
    finalName = self.mountPrefix .. "_" .. finalName
  elseif self.wingPrefix then
    finalName = self.wingPrefix .. "_" .. finalName
  elseif self.swimPrefix then
    finalName = self.swimPrefix .. "_" .. finalName
  end
  return AnimationNameConfig[finalName] or AnimationNameConfig[name] or name
end
