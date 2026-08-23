require("GamePlay/Role/Animation/AnimationConfig")
SnowManAnimatorCtrl = class(AnimatorCtrl)
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
  Xianlu = 3
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
  OneHand = "Weapon",
  Dweapon = "Weapon",
  TStaff = "Weapon",
  TSword = "Weapon",
  Spear = "Weapon",
  Bow = "Weapon",
  Crossbow = "Weapon",
  Wing = "Wing",
  Swim = "Swim"
}
local loopMotion = {
  walk1 = true,
  run = true,
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
  dead = 3,
  alive = 3
}
setmetatable(AnimatorTriggerLayer, {
  __index = function()
    return 2
  end
})

function SnowManAnimatorCtrl:ResetIntParameter()
  for i = 1, #parameters do
    self.animator:SetInteger(parameters[i], 0)
  end
end

function SnowManAnimatorCtrl:SetAnimatorSpeed(speed)
  if not self.animator or not self.animator.gameObject.activeSelf then
    return
  end
  self.animator.speed = speed
end

function SnowManAnimatorCtrl:PlayTest(name, speed, callback)
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
      self.animator:SetTrigger(finalName)
      if AnimatorTriggerLayer[name] == 1 then
        self.originalName = name
      end
      self.triggerLayers[AnimatorTriggerLayer[name]] = name
    end
  end
end

local attackName = {
  [1] = "attack1",
  [2] = "attack2"
}

function SnowManAnimatorCtrl:GetFullAnimationName(name)
  local finalName = ""
  if string.contains(name, "dead") or string.contains(name, "alive") then
    return name
  elseif string.contains(name, "idle") or string.contains(name, "walk") then
    finalName = "walk1"
  elseif string.contains(name, "run") then
    finalName = "run"
  else
    local index = Mathf.Random(1, 2)
    finalName = attackName[index]
    finalName = finalName or "attack1"
  end
  return finalName
end

function SnowManAnimatorCtrl:PlayInstantAnimal(animalName, normalizeTime, layer)
  if not self.animator or not self.animator.gameObject.activeSelf then
    return
  end
  self.animator:PlayInstant(animalName, normalizeTime, layer)
end

function SnowManAnimatorCtrl:StopAnimal()
  if not self.animator or not self.animator.gameObject.activeSelf then
    return
  end
  self.animator:PlayInstant("Stop", 0, 1)
end

function SnowManAnimatorCtrl:GetAniSpeedTimes(name)
  return speedTimesData[name]
end

function SnowManAnimatorCtrl:GetAniSpeedTimesByOriginName(aniName)
  local name = self:GetAnimationName(aniName, self.weaponPrefix)
  return self:GetAniSpeedTimes(name)
end

function SnowManAnimatorCtrl:ctor(avatar)
  self.forceUpdate = false
  self.animationConfig = BaseAnimationConfig
  self.avatar = avatar
end

function SnowManAnimatorCtrl:SetConfig(animationConfig)
  self.animationConfig = animationConfig
end

function SnowManAnimatorCtrl:Init(go, humanoid, forceUpdate)
  if go then
    self.animator = go:GetComponent(typeof(Animator))
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

function SnowManAnimatorCtrl:InitAnimationSpeed()
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

function SnowManAnimatorCtrl:SetEnable(enable)
  if self.animator then
    self.animator.enabled = enable
  end
end

function SnowManAnimatorCtrl:OnAnimatorEnable()
end

function SnowManAnimatorCtrl:SetWeaponPrefix(prefix)
  self.weaponPrefix = prefix
end

function SnowManAnimatorCtrl:SetMountPrefix(prefix)
  self.mountPrefix = prefix
end

function SnowManAnimatorCtrl:SetWingPrefix(prefix)
  self.wingPrefix = prefix
end

function SnowManAnimatorCtrl:SetSwimPrefix(prefix)
  self.swimPrefix = prefix
end

function SnowManAnimatorCtrl:Play(name, speed, fadeLength, normalizedTime, realTime, callback)
  self:PlayTest(name, speed, callback)
end

function SnowManAnimatorCtrl:ForceUpdate()
  self.forceUpdate = true
end

function SnowManAnimatorCtrl:PlayMount(name, speed, fadeLength, normalizedTime, realTime)
  if string.contains(name, "walk") or string.contains(name, "run") then
    self:Play(name, speed)
  else
    self:Play("idle", speed)
  end
end

function SnowManAnimatorCtrl:GetSpeedByRealTime(name, realTime)
  local tbl = ConfigManager.FindConfigs("cfg_Action_actionBaseTime", "name", name)
  if table.count(tbl) < 1 then
    return
  end
  local originTime = tonumber(tbl[1].time) * 0.001
  local speedTimes = originTime / realTime
  speedTimesData[name] = speedTimes
  return speedTimes
end

function SnowManAnimatorCtrl:GetAnimationID(name)
  return Animator.StringToHash(self:GetAnimationName(name))
end

function SnowManAnimatorCtrl:GetAnimationName(name)
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
