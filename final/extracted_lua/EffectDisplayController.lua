EffectDisplayController = {}
local this = EffectDisplayController
this.skillEffectCounter = 0
this.skillEffectContainer = {}

function EffectDisplayController.Init()
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvents()
end

function EffectDisplayController.RegistEvents()
  this.eventContainer:Regist(Event.Role_RoleDestroyed, this.Role_RoleDestroyed)
  this.eventContainer:Regist(Event.Scene_OnBeginEnterScene, this.OnChangeScene)
end

function EffectDisplayController.Role_RoleDestroyed(_, role)
  if not role then
    return
  end
  local casterId = role.id
  if this.skillEffectContainer[casterId] and this.skillEffectContainer[casterId] > 0 then
    this.skillEffectCounter = this.skillEffectCounter - this.skillEffectContainer[casterId]
    if 0 > this.skillEffectCounter then
      this.skillEffectCounter = 0
    end
    this.skillEffectContainer[casterId] = 0
    return true
  end
end

function EffectDisplayController.OnChangeScene()
  this.skillEffectContainer = {}
  this.skillEffectCounter = 0
end

function EffectDisplayController.IsMaxCount(casterId)
  if casterId == ViewData.meData.id then
    return false
  end
  if this.skillEffectCounter >= GameSettingsData.maxSkillEffectCount then
    return true
  end
  return false
end

function EffectDisplayController.AddSkillEffect(casterId)
  if casterId == ViewData.meData.id then
    return true
  end
  local role = RoleManager.GetRoleById(casterId)
  if not role then
    return
  end
  if this.skillEffectCounter >= GameSettingsData.maxSkillEffectCount then
    this.skillEffectCounter = GameSettingsData.maxSkillEffectCount
    return false
  end
  this.skillEffectCounter = this.skillEffectCounter + 1
  this.skillEffectContainer[casterId] = this.skillEffectContainer[casterId] and this.skillEffectContainer[casterId] + 1 or 1
  return true
end

function EffectDisplayController.RemoveSkillEffect(casterId)
  if casterId == ViewData.meData.id then
    return false
  end
  if this.skillEffectContainer[casterId] and this.skillEffectContainer[casterId] > 0 then
    this.skillEffectContainer[casterId] = this.skillEffectContainer[casterId] - 1
    this.skillEffectCounter = this.skillEffectCounter - 1
    if 0 > this.skillEffectCounter then
      this.skillEffectCounter = 0
    end
    return true
  end
end

this.Init()
