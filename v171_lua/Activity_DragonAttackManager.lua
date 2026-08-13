Activity_DragonAttackManager = {}
local grassSetting = {
  _AmplitudeZ = 0.15,
  _PowZ = 3,
  _WavelengthZ = 120,
  _WaveSpeedZ = -9,
  _AmplitudeX = 2,
  _VertXOffset = -0.5
}
local ambientIntensity = 0.7
local this = Activity_DragonAttackManager
this.screenEffects = {}
this.dragonEffect = nil
this.countDownDragonFly = nil
this.isCameraAttach = false

function Activity_DragonAttackManager.OnEnterGame()
  this.RegistEvents()
end

function Activity_DragonAttackManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Map_ChangeMap, this.ChangeMap)
  this.eventContainer:Regist(Event.CameraAttach, this.CameraAttach)
  this.eventContainer:Regist(Event.Role_OnMeDestroy, this.OnRoleDestroy)
  this.eventContainer:Regist(Event.ActivityDragonAttackStatusRefresh, this.RefreshEffect)
  this.eventContainer:Regist(Event.ActivityDragonItemCount, this.ActivityDragonItemCountUpdate)
end

function Activity_DragonAttackManager.ActivityDragonItemCountUpdate(_, countKey)
  local countTbl = ClientTable.cfg_Count_countManager:TryGetValue(countKey, "key")
  local surplus = RefreshData.GetLimitCount(countKey)
  local sumCount = countTbl.refreshCountLimit
  if sumCount - surplus ~= 0 then
    FloatingWordUtility.QuickMsg(string.format("%s nh\225\186\183t (%d/%d)", countTbl.desc, sumCount - surplus, sumCount))
  end
end

function Activity_DragonAttackManager.ChangeMap()
  if this.isCameraAttach then
    this.StartDragonAttackEffect()
  end
  this.SetAmbientIntensity()
  if Activity_DragonAttackData.IsDragonAttackEffectOpen() then
    AnimalManager.HideAnimGroup()
  else
    SceneGrassEffectManager.SetGrassSettings(SceneData.mapId)
  end
end

function Activity_DragonAttackManager.CameraAttach()
  this.isCameraAttach = true
  if Activity_DragonAttackData.IsDragonAttackEffectOpen() then
    this.StartDragonAttackEffect()
    this.SetAmbientIntensity()
    AnimalManager.HideAnimGroup()
  else
    SceneGrassEffectManager.SetGrassSettings(SceneData.mapId)
  end
end

function Activity_DragonAttackManager.OnRoleDestroy()
  this.isCameraAttach = false
end

function Activity_DragonAttackManager.ResetAllMapGrass()
  if not Activity_DragonAttackData.mapList then
    return
  end
  for i, v in ipairs(Activity_DragonAttackData.mapList) do
    SceneGrassEffectManager.SetGrassSettings(v)
  end
end

function Activity_DragonAttackManager.SetAllMapGrass()
  if not Activity_DragonAttackData.mapList then
    return
  end
  for i, v in ipairs(Activity_DragonAttackData.mapList) do
    SceneGrassEffectManager.SetGrassSettings(v, grassSetting)
  end
end

function Activity_DragonAttackManager.ReSetAmbientIntensity()
  CS.UnityEngine.Shader.SetGlobalFloat("_GlobalAmbientIntensity", 1)
end

function Activity_DragonAttackManager.SetAmbientIntensity()
  if Activity_DragonAttackData.IsDragonAttackEffectOpen() then
    CS.UnityEngine.Shader.SetGlobalFloat("_GlobalAmbientIntensity", ambientIntensity)
  else
    CS.UnityEngine.Shader.SetGlobalFloat("_GlobalAmbientIntensity", 1)
  end
end

function Activity_DragonAttackManager.RefreshEffect(_, state)
  if state == ActivityStatusEnum.CLOSING then
    this.StopAllEffect()
    this.ResetAllMapGrass()
    this.ReSetAmbientIntensity()
    AnimalManager.SetAnimGroupHide(false)
  else
    this.SetAllMapGrass()
    if this.isCameraAttach and Activity_DragonAttackData.IsDragonAttackEffectOpen() then
      this.StartDragonAttackEffect()
      this.SetAmbientIntensity()
    end
  end
end

function Activity_DragonAttackManager.Update()
  for i, v in pairs(this.screenEffects) do
    v:Update()
  end
  if this.dragonEffect then
    this.dragonEffect:Update()
  end
end

function Activity_DragonAttackManager.CreateFireballEffectData(startPos, moveTime, index)
  local effectData = {
    x = startPos.x,
    y = startPos.y,
    z = startPos.z,
    moveTime = moveTime,
    index = index
  }
  return effectData
end

function Activity_DragonAttackManager.StartFireballEffect()
  local function StartCountDown()
    local index = 1
    
    while true do
      local randomFireball = Mathf.Random(0, 10)
      if randomFireball < 5 then
        local startX = Random.Range(0.5, 0.8)
        local startY = 1
        local zInfo = 14
        local startPos = Vector3(startX, startY, zInfo)
        local startWorldPos = MainCamera.initCamera:ViewportToWorldPoint(startPos)
        if startWorldPos.y < 4 then
          startWorldPos.y = 4
        end
        local moveTime = Random.Range(2, 3)
        local effectData = this.CreateFireballEffectData(startWorldPos, moveTime, index)
        local daEffect = DAFireballEffect(effectData)
        this.screenEffects[index] = daEffect
        index = index + 1
      end
      randomFireball = Mathf.Random(0, 10)
      if randomFireball < 5 then
        local startX = 1
        local startY = Random.Range(0.5, 0.8)
        local zInfo = 14
        local startPos = Vector3(startX, startY, zInfo)
        local startWorldPos = MainCamera.initCamera:ViewportToWorldPoint(startPos)
        if startWorldPos.y < 4 then
          startWorldPos.y = 4
        end
        local moveTime = Random.Range(2, 3)
        local effectData = this.CreateFireballEffectData(startWorldPos, moveTime, index)
        local daEffect = DAFireballEffect(effectData)
        this.screenEffects[index] = daEffect
        index = index + 1
      end
      Coroutine.Wait(2)
    end
  end
  
  if SceneData.mapId and Activity_DragonAttackData.IsDragonAttackEffectOpen() then
    if not this.screenEffectCoroutine then
      this.screenEffectCoroutine = Coroutine.Start(StartCountDown)
    end
  elseif this.screenEffectCoroutine then
    Coroutine.Stop(this.screenEffectCoroutine)
    this.screenEffectCoroutine = nil
  end
end

function Activity_DragonAttackManager.CreateDragonFlyEffect()
  local startX = Random.Range(0.5, 1)
  local startY = 1
  local zInfo = 14
  local startPos = Vector3(startX, startY, zInfo)
  local startWorldPos = MainCamera.initCamera:ViewportToWorldPoint(startPos)
  local effectData = {
    x = startWorldPos.x,
    y = startWorldPos.y,
    z = startWorldPos.z
  }
  this.dragonEffect = DragonFlyEffect(effectData)
end

function Activity_DragonAttackManager.DestroyDragon()
  if this.dragonEffect then
    this.dragonEffect:Destroy()
    this.dragonEffect = nil
  end
  if this.countDownDragonFly then
    Timer.Stop(this.countDownDragonFly)
    this.countDownDragonFly = nil
  end
end

function Activity_DragonAttackManager.RefreshDragonFlyEffect()
  if SceneData.mapId and Activity_DragonAttackData.IsDragonAttackEffectOpen() then
    if not this.countDownDragonFly then
      local timeInterval = Mathf.Random(3, 5)
      this.countDownDragonFly = Timer.StartLoop(timeInterval, 1, function()
        this.CreateDragonFlyEffect()
      end)
    end
  elseif this.countDownDragonFly then
    Timer.Stop(this.countDownDragonFly)
    this.countDownDragonFly = nil
  end
end

function Activity_DragonAttackManager.StartDragonAttackEffect()
  this.RefreshDragonFlyEffect()
  this.StartFireballEffect()
  this.SetAnimalGroupAlpha()
end

function Activity_DragonAttackManager.SetAnimalGroupAlpha()
  if SceneData.mapId and Activity_DragonAttackData.IsDragonAttackEffectOpen() then
    AnimalManager.SetAnimGroupHide(true)
  else
    AnimalManager.SetAnimGroupHide(false)
  end
end

function Activity_DragonAttackManager.StopAllEffect()
  if this.screenEffectCoroutine then
    this.isStopScreenEffect = true
    Coroutine.Stop(this.screenEffectCoroutine)
    this.screenEffectCoroutine = nil
  end
  if this.countDownDragonFly then
    Timer.Stop(this.countDownDragonFly)
    this.countDownDragonFly = nil
  end
end

function Activity_DragonAttackManager.DestroyScreenEffect()
  if this.screenEffectCoroutine then
    this.isStopScreenEffect = true
    Coroutine.Stop(this.screenEffectCoroutine)
    this.screenEffectCoroutine = nil
  end
  this.DestroyDragon()
  for i, v in pairs(this.screenEffects) do
    v:Destroy()
  end
  this.screenEffects = {}
end

function Activity_DragonAttackManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.DestroyScreenEffect()
  this.ReSetAmbientIntensity()
  this.ResetAllMapGrass()
  AnimalManager.SetAnimGroupHide(false)
end

function Activity_DragonAttackManager.UnRegistAll()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
end
