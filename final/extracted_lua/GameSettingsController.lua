require("GameModel/GameSettingsData")
require("GameController/EffectDisplayController")
local PlayerDisplayController = require("GameController/PlayerDisplayController")
GameSettingsController = {}
local this = GameSettingsController
local GameSettings_PrefsKey = "GameSettings.Settings"
local GameSettings_Version_PrefsKey = "GameSettings.Settings_version"
this.localSettingsVersion = 2
local settingsConfig = {}

local function getRoleCampType(role)
  if role.unionId == nil then
    return EBattleCamp.OtherPlayer
  end
  if role.unionId == RoleManager.me.unionId then
    return EBattleCamp.League
  elseif role.unionId == RoleManager.me.op_unionId then
    return EBattleCamp.OpLeague
  else
    return EBattleCamp.OtherPlayer
  end
end

local function shouldShowRole(compareCampType, role)
  if role.isMe then
    return true
  end
  if role.isViewRole then
    return true
  end
  if compareCampType == EBattleCamp.All then
    return false
  elseif compareCampType == EBattleCamp.None then
    return true
  else
    local campType = getRoleCampType(role)
    return compareCampType ~= campType
  end
  return true
end

local function getRolesByCamp(camp, roleType)
  if camp == EBattleCamp.All then
    return RoleManager.GetRolesByType(roleType)
  elseif camp == EBattleCamp.OtherPlayer then
    local targets = {}
    local unionId = RoleManager.me.unionId
    local op_unionId = RoleManager.me.op_unionId
    local roles = RoleManager.GetRolesByType(roleType)
    for _, v in pairs(roles) do
      if v.unionId == nil or v.unionId == 0 or v.unionId ~= unionId and v.unionId ~= op_unionId then
        targets[v.id] = v
      end
    end
    return targets
  elseif camp == EBattleCamp.League then
    local target = {}
    local roles = RoleManager.GetRolesByType(roleType)
    for _, v in pairs(roles) do
      if v.unionId and v.unionId ~= 0 and v.unionId == RoleManager.me.unionId then
        target[v.id] = v
      end
    end
    return target
  elseif camp == EBattleCamp.OpLeague then
    local roles = RoleManager.GetRolesByType(roleType)
    local target = {}
    local enList = RoleManager.me.enemyUnionList
    if #enList == 0 then
      return target
    else
      for i, v in pairs(roles) do
        for i, n in pairs(enList) do
          if v.unionId and v.unionId ~= 0 and v.unionId == n then
            target[v.id] = v
          end
        end
      end
    end
    return target
  end
  return {}
end

function GameSettingsController.Init()
  CSMobileInfo.Init()
  this.InitGameSettings()
  this.LoadSettings()
  this.ApplyBasicSettings()
  this.ApplyDisplaySettings(GameSettingsData)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvents()
  PlayerDisplayController.InitData(GameSettingsData.maxVisiblePlayers)
end

function GameSettingsController.InitGameSettings()
  DeviceInfo.defaultMaxRenderScale = C_DefaultGameSettings.defaultMaxScreenHeight / Screen.height
  DeviceInfo.defaultMinRenderScale = C_DefaultGameSettings.defaultMinScreenHeight / Screen.height
  ScreenData.height = Screen.height
  ScreenData.width = Screen.width
  if DeviceInfo.defaultMaxRenderScale > 1 then
    DeviceInfo.defaultMaxRenderScale = 1
  end
end

function GameSettingsController.Update()
  if Screen.height ~= ScreenData.height or Screen.width ~= ScreenData.width then
    ScreenData.height = Screen.height
    ScreenData.width = Screen.width
    local resolution = Screen.width .. "x" .. Screen.height
    NetManager.Send(CommonMessage.ReqResolution, {resolution = resolution})
  end
end

function GameSettingsController.LeaveGame()
  PlayerDisplayController.LeaveGame()
end

function GameSettingsController.LoadSettings()
  local settings = C_DefaultGameSettings.BaseConfig
  this.SetSettings(settings)
  local performQuality = this.GetDefaultPerformance()
  local localSettingsVer = PlayerPrefs.GetInt(GameSettings_Version_PrefsKey, 0)
  if localSettingsVer >= this.localSettingsVersion then
    local settingsStr = PlayerPrefs.GetString(GameSettings_PrefsKey)
    if settingsStr ~= nil and settingsStr ~= "" and settingsStr ~= "[]" then
      settings = json.decode(settingsStr)
      performQuality = settings.performQuality or performQuality
    end
  end
  local defaultDisplaySettings = C_DefaultGameSettings.PerformanceConfig[performQuality]
  this.SetSettings(defaultDisplaySettings)
  this.SetSettings(settings)
  GameSettingsData.performQuality = performQuality
end

function GameSettingsController.Save()
  local settingsStr = json.encode(GameSettingsData)
  PlayerPrefs.SetString(GameSettings_PrefsKey, settingsStr)
  PlayerPrefs.SetInt(GameSettings_Version_PrefsKey, this.localSettingsVersion)
end

function GameSettingsController.SetSettings(settingsData)
  for k, v in pairs(settingsData) do
    GameSettingsData[k] = v
  end
end

function GameSettingsController.ResetBasic()
  local settings = C_DefaultGameSettings.BaseConfig
  this.SetSettings(settings)
  this.ApplyBasicSettings()
end

function GameSettingsController.ResetDisplay()
  local performQuality = this.GetDefaultPerformance()
  this.ResetPerformQuality(performQuality, true)
end

function GameSettingsController.ResetPerformQuality(performQuality, bForce)
  if GameSettingsData.performQuality ~= performQuality or bForce then
    GameSettingsData.performQuality = performQuality
    local defaultDisplaySettings = C_DefaultGameSettings.PerformanceConfig[GameSettingsData.performQuality]
    this.SetGamingSettings(defaultDisplaySettings)
    this.ApplyDisplaySettings(defaultDisplaySettings)
    this.SetSettings(defaultDisplaySettings)
  end
end

function GameSettingsController.ApplyBasicSettings()
  AudioManager.SetVolume(AudioGroup.Music, GameSettingsData.musicVolume)
  AudioManager.SetVolume(AudioGroup.Sound, GameSettingsData.soundVolume)
end

function GameSettingsController.ApplyDisplaySettings(settings)
  this.SetResolution(settings.resolution)
  CS.Framework.ResourceManager.MaxLoadOrInstanceCount = settings.maxInstantiateCount
  CS.UnityEngine.Shader.globalMaximumLOD = settings.LOD
  CSGrassSceneData.SetGrassMeshLevel(settings.performQuality)
  this.ShowSceneAnimals(settings.showSceneAnimals)
  this.SetFrameRate(GameSettingsData.frameRate)
end

function GameSettingsController.SetGamingSettings(settings)
  this.SetHidePlayerModelType(settings.hidePlayerModelCamp, true)
  this.SetHideModelSkillEffectType(settings.hideSkillEffectCamp, true)
  this.SetSummonMonsterModelType(settings.hideSummonMonster, true)
  this.SetHidePlayerWingType(settings.hidePlayerWingCamp, true)
  this.SetHidePlayerBootType(settings.hidePlayerWingCamp)
  this.SetHideMonsterModel(settings.hideMonsterModel, true)
  this.SetHideMonsterSkillEffect(settings.hideMonsterSkillEffect, true)
  this.SetShowRoleShadow(GameSettingsData.showShadow)
  this.ShowSceneWeatherEffect(GameSettingsData.showWeatherEffect)
  this.SetMaxVisiblePLayers()
end

function GameSettingsController.SetResolution(resolution)
  GameSettingsData.resolution = resolution or C_ResolutionQuality.HD
  local renderScale = DeviceInfo.defaultMaxRenderScale * GameSettingsData.resolution
  renderScale = Mathf.Clamp(renderScale, DeviceInfo.defaultMinRenderScale, DeviceInfo.defaultMaxRenderScale)
  GraphicEx.SetRenderScale(renderScale)
end

function GameSettingsController.SetFrameRate(fps)
  GameSettingsData.frameRate = fps
  Application.targetFrameRate = fps
end

function GameSettingsController.SetMaxVisiblePLayers()
  local maxVisiblePlayers = GameSettingsData.limitMaxVisiblePlayers and GameSettingsData.maxVisiblePlayers or math.maxinteger
  PlayerDisplayController.SetVisiblePlayersCount(maxVisiblePlayers)
end

function GameSettingsController.RegistEvents()
  this.eventContainer:Regist(Event.Role_OnMeCreated, this.OnMeCreated, 2)
  this.eventContainer:Regist(Event.Load_PreLoadEnd, this.OnPreLoadEnd)
  this.eventContainer:Regist(Event.Main_UpdateBattery, this.UpdateBattery)
end

function GameSettingsController.OnMeCreated()
  this.SetGamingSettings(GameSettingsData)
end

function GameSettingsController.OnPreLoadEnd()
  CS.Framework.ResourceManager.MaxLoadOrInstanceCount = GameSettingsData.maxInstantiateCount
end

function GameSettingsController.UpdateBattery(_, Bat)
  DeviceInfo.Battery = Bat
end

function GameSettingsController.SetMusicVolume(volume)
  volume = Mathf.Clamp(volume, 0, 1.0)
  GameSettingsData.musicVolume = volume
  AudioManager.SetVolume(AudioGroup.Music, volume)
end

function GameSettingsController.SetSoundVolume(volume)
  volume = Mathf.Clamp(volume, 0, 1.0)
  GameSettingsData.soundVolume = volume
  AudioManager.SetVolume(AudioGroup.Sound, volume)
end

function GameSettingsController.SetSpeechVolume(volume)
  volume = Mathf.Clamp(volume, 0, 1.0)
  GameSettingsData.speechVolume = volume
end

function GameSettingsController.SetLimitShowPlayers(bLimit)
  GameSettingsData.limitMaxVisiblePlayers = bLimit
  this.SetMaxVisiblePLayers()
end

function GameSettingsController.SetPlayerShowLimitCount(count)
  GameSettingsData.maxVisiblePlayers = count
  this.SetMaxVisiblePLayers()
end

function GameSettingsController.SetJoyStickMode(mode)
  GameSettingsData.joyStickMode = mode
end

function GameSettingsController.SetPlayerEnterViewHide(role)
  if GameSettingsData.hidePlayerModelCamp == EBattleCamp.OpLeague and role.data and role.data.unionId and role.data.unionId ~= 0 then
    for k, v in pairs(RoleManager.me.enemyUnionList) do
      if v == role.data.unionId then
        role:SetModelDisplay(false)
      end
    end
  end
end

function GameSettingsController.SetHidePlayerModelType(campType, bForce)
  if GameSettingsData.hidePlayerModelCamp ~= campType or bForce then
    local roles = getRolesByCamp(GameSettingsData.hidePlayerModelCamp, ERoleType.Player)
    GameSettingsData.hidePlayerModelCamp = campType
    for _, v in pairs(roles) do
      v:SetModelDisplay(true)
    end
    roles = getRolesByCamp(campType, ERoleType.Player)
    if roles then
      for _, v in pairs(roles) do
        v:SetModelDisplay(false)
      end
    end
  end
end

function GameSettingsController.SetHideModelSkillEffectType(campType, bForce)
  if GameSettingsData.hideSkillEffectCamp ~= campType or bForce then
    local roles = getRolesByCamp(GameSettingsData.hideSkillEffectCamp, ERoleType.Player)
    GameSettingsData.hideSkillEffectCamp = campType
    for _, v in pairs(roles) do
      v:ShowSkillEffect(true)
    end
    roles = getRolesByCamp(campType, ERoleType.Player)
    if roles then
      for _, v in pairs(roles) do
        v:ShowSkillEffect(false)
      end
    end
  end
end

function GameSettingsController.SetSummonMonsterModelType(hide, bForce)
  if GameSettingsData.hideSummonMonster ~= hide or bForce then
    GameSettingsData.hideSummonMonster = hide
    local monsters = RoleManager.GetRoleListByType(ERoleType.Monster)
    for i = 1, #monsters.list do
      if monsters.list[i].data.isSummon then
        monsters.list[i]:SetModelDisplay(not hide)
      end
    end
  end
end

function GameSettingsController.SetHidePlayerWingType(campType, bForce)
  if GameSettingsData.hidePlayerWingCamp ~= campType or bForce then
    local roles = getRolesByCamp(GameSettingsData.hidePlayerWingCamp, ERoleType.Player)
    GameSettingsData.hidePlayerWingCamp = campType
    for _, v in pairs(roles) do
      v.AvatarEquip:SetEquipShowOrHideByIndex(ERoleEquipPosition.wing, true)
    end
    roles = getRolesByCamp(campType, ERoleType.Player)
    if roles then
      for _, v in pairs(roles) do
        v.AvatarEquip:SetEquipShowOrHideByIndex(ERoleEquipPosition.wing, false)
      end
    end
  end
end

function GameSettingsController.SetHidePlayerBootType(campType, aroundRefresh)
  if GameSettingsData.hidePlayerBootCamp ~= campType or aroundRefresh then
    local roles = getRolesByCamp(GameSettingsData.hidePlayerBootCamp, ERoleType.Player)
    GameSettingsData.hidePlayerBootCamp = campType
    for _, v in pairs(roles) do
      v.AvatarEquip:SetEquipShowOrHideByIndex(ERoleEquipPosition.footPrintIndex, true)
    end
    roles = getRolesByCamp(campType, ERoleType.Player)
    if roles then
      for _, v in pairs(roles) do
        v.AvatarEquip:SetEquipShowOrHideByIndex(ERoleEquipPosition.footPrintIndex, false)
      end
    end
  end
end

function GameSettingsController.SetHideMonsterModel(hide, bForce)
  if GameSettingsData.hideMonsterModel ~= hide or bForce then
    GameSettingsData.hideMonsterModel = hide
    local monsters = RoleManager.GetRoleListByType(ERoleType.Monster)
    for i = 1, #monsters.list do
      if this.CanRoleBeHiden(monsters.list[i]) and not monsters.list[i].data.isSummon and monsters.list[i].data.monsterAiType ~= 10 then
        monsters.list[i]:SetModelDisplay(not hide)
      end
    end
  end
end

function GameSettingsController.SetHideMonsterSkillEffect(hide, bForce)
  if GameSettingsData.hideMonsterSkillEffect ~= hide or bForce then
    GameSettingsData.hideMonsterSkillEffect = hide
    local monsters = RoleManager.GetRoleListByType(ERoleType.Monster)
    for i = 1, #monsters.list do
      monsters.list[i]:ShowSkillEffect(not hide)
    end
  end
end

function GameSettingsController.ShowSceneWeatherEffect(bShow)
  GameSettingsData.showWeatherEffect = bShow
  if GameSettingsData.showWeatherEffect then
    SceneWeatherEffect.InitEffect(SceneData.mapId)
  else
    SceneWeatherEffect.DestroyEffect()
  end
end

function GameSettingsController.ShowSceneAnimals(bShow)
  GameSettingsData.showSceneAnimals = bShow
  AnimalManager.SetAnimalGroupState(bShow)
end

function GameSettingsController.SetShowRoleShadow(hide)
  GameSettingsData.showShadow = hide
  local roles = getRolesByCamp(EBattleCamp.All, ERoleType.Player)
  for _, v in pairs(roles) do
    v.AvatarEquip:SetEquipShowOrHideByIndex(ERoleEquipPosition.shadow, hide)
  end
end

function GameSettingsController.ShouldShowModel(role)
  local show = true
  local roleType = role.data.roleType
  if roleType == ERoleType.Player then
    if role:GetModelLayer() == UI_LAYER or role.isMe then
      return show
    end
    show = shouldShowRole(GameSettingsData.hidePlayerModelCamp, role)
  elseif roleType == ERoleType.Pet then
    show = shouldShowRole(GameSettingsData.hidePetModelCamp, role)
  elseif roleType == ERoleType.Monster and role.data.monsterAiType ~= 10 then
    if role.data.isSummon then
      show = not GameSettingsData.hideSummonMonster
    elseif this.CanRoleBeHiden(role) then
      show = not GameSettingsData.hideMonsterModel
    end
  end
  if roleType == GameSettingsData.visibleRoleLimitType and show then
    show = PlayerDisplayController.ShouldShowRole(role)
  end
  return show
end

function GameSettingsController.CanRoleBeHiden(role)
  if not role or not role.data then
    return true
  end
  if role.RoleType == ERoleType.Monster then
    return role.data.monsterType == MonsterType.littleMonster
  end
  return true
end

function GameSettingsController.ShouldShowEquipModel(position, role)
  if UIManager.IsVisible(UIID.LoginRoleUI) then
    return true
  end
  if position == ERoleEquipPosition.wing then
    return shouldShowRole(GameSettingsData.hidePlayerWingCamp, role)
  elseif position == ERoleEquipPosition.shadow then
    return GameSettingsData.showShadow
  end
  return true
end

function GameSettingsController.ShouldShowRoleSkillEffect(role)
  if role.isMe then
    return true
  end
  if role.RoleType == ERoleType.Monster then
    return not GameSettingsData.hideMonsterSkillEffect
  elseif role.RoleType == ERoleType.Player then
    return shouldShowRole(GameSettingsData.hideSkillEffectCamp, role)
  end
end

function GameSettingsController.GetDefaultPerformance()
  if CSMobileInfo.IsEmulator then
    return EPerformanceQuality.High
  end
  local cpu = CSMobileInfo.CpuName
  if string.isNullOrEmpty(cpu) then
    return EPerformanceQuality.High
  end
  local cpus = ClientTable.cfg_cpuManager:GetDic()
  for _, v in pairs(cpus) do
    if string.contains(cpu, v.cpu) then
      return v.level
    end
  end
  return EPerformanceQuality.High
end

function GameSettingsController.GetRoleCampType(role)
  return getRoleCampType(role)
end
