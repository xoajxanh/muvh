Activity_SiegeManager = {}
local this = Activity_SiegeManager
this.haloModel = nil
this.screenEffectCoroutine = nil
this.isStopScreenEffect = false
this.isHideBuilding = false
this.screenEffects = {}
this.defenseMonster = {}
this.safeAreaTable = {}

function Activity_SiegeManager.Update()
  for i, v in pairs(this.screenEffects) do
    v:Update()
  end
end

function Activity_SiegeManager.OnEnterGame()
  this.RegistEvents()
end

function Activity_SiegeManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Role_OnMove, this.Role_OnMove)
  this.eventContainer:Regist(Event.Scene_SceneLoaded, this.SiegePrefabLoad)
  this.eventContainer:Regist(Event.Load_PreLoadEnd, this.SiegePrefabLoad)
  this.eventContainer:Regist(Event.EnterSiege, this.SiegePrefabLoad)
  this.eventContainer:Regist(Event.Role_OnRoleEnterView, this.OnRoleEnterView, nil, 10)
  this.eventContainer:Regist(Event.GameObject_OnGameObjectLeaveView, this.OnRoleLeaveView)
  this.eventContainer:Regist(Event.Map_ChangeMap, this.Map_ChangeMap)
  this.eventContainer:Regist(Event.UpdateSiegeSafeArea, this.UpdateSiegeSafeArea)
end

local cell = Vector2(0, 0)

function Activity_SiegeManager.SetSceneTileTypeToSafe(minCell, maxCell)
  for i = minCell.x, maxCell.x do
    for j = minCell.y, maxCell.y do
      cell:Set(i, j)
      local sceneTileType = Scene.GetTileType(cell.x, cell.y)
      if sceneTileType == SceneTileType.Normal then
        Scene.AddTileType(cell, SceneTileType.Safe)
      end
    end
  end
end

function Activity_SiegeManager.SetSceneTileTypeToNormal(minCell, maxCell)
  for i = minCell.x, maxCell.x do
    for j = minCell.y, maxCell.y do
      cell:Set(i, j)
      local sceneTileType = Scene.GetTileType(cell.x, cell.y)
      if sceneTileType == SceneTileType.Safe then
        Scene.RemoveTileType(cell, SceneTileType.Safe)
      end
    end
  end
end

function Activity_SiegeManager.GetCellPos(safeAreaStr)
  local safeAreaPos = string.split(safeAreaStr, "&")
  local safeXs = string.split(safeAreaPos[1], "#")
  local safeYs = string.split(safeAreaPos[2], "#")
  local minPos = Vector2(tonumber(safeXs[1]), tonumber(safeYs[1]))
  local maxPos = Vector2(tonumber(safeXs[2]), tonumber(safeYs[2]))
  local midPos = Vector2(Mathf.Floor((minPos.x + maxPos.x) / 2), Mathf.Floor((minPos.y + maxPos.y) / 2))
  return minPos, maxPos, midPos
end

function Activity_SiegeManager.GetSafeArea(minPos, maxPos, midPos)
  local position = Scene.GetPosByCell(midPos)
  local model = "Eff_anquanqu"
  local safeArea
  local effectData = {
    modelType = EEffectModelType.Scene,
    model = model
  }
  safeArea = EffectModel(Effect.root, nil, effectData)
  safeArea:Init()
  safeArea:SetModel(1)
  safeArea:SetLayer(ROLE_LAYER)
  local scaleX = maxPos.x - minPos.x
  local scaleZ = maxPos.y - minPos.y
  safeArea:SetScale(Mathf.Ceil(scaleX + 0.5) - 0.5, 1, Mathf.Ceil(scaleZ + 0.5))
  safeArea:SetPosition(position.x, position.y + 0.1, position.z + 0.5)
  return safeArea
end

function Activity_SiegeManager.UpdateSiegeSafeArea(_, msg)
  local safeAreaConfig = ClientTable.cfg_Activity_globalManager:TryGetValue(msg.id)
  if msg.type == 1 then
    if this.safeAreaTable[msg.id] then
      this.safeAreaTable[msg.id]:Destroy()
      this.safeAreaTable[msg.id] = nil
    end
    local minPos, maxPos, midPos = this.GetCellPos(safeAreaConfig.effect)
    this.safeAreaTable[msg.id] = this.GetSafeArea(minPos, maxPos, midPos)
    this.SetSceneTileTypeToSafe(minPos, maxPos)
  elseif this.safeAreaTable[msg.id] then
    this.safeAreaTable[msg.id]:Destroy()
    this.safeAreaTable[msg.id] = nil
    local minPos, maxPos, _ = this.GetCellPos(safeAreaConfig.effect)
    this.SetSceneTileTypeToNormal(minPos, maxPos)
  end
  RoleManager.RefreshAllCell()
end

function Activity_SiegeManager.Map_ChangeMap()
  this.isHideBuilding = false
end

function Activity_SiegeManager.OnRoleEnterView(_, roleData)
  if roleData == nil then
    return
  end
  if roleData.roleType == ERoleType.Monster then
    if roleData.isSummon then
      return
    end
    this.defenseMonster[roleData.id] = roleData
    this.UpdateDefenseRoleType(roleData)
  end
end

function Activity_SiegeManager.OnRoleLeaveView(_, roleData)
  if roleData == nil then
    return
  end
  if roleData.roleType == ERoleType.Monster then
    this.defenseMonster[roleData.id] = nil
  end
end

function Activity_SiegeManager.DestroyAllDefenseMonster()
  this.defenseMonster = {}
end

function Activity_SiegeManager.UpdateDefenseRoleType(roleData)
  if Activity_LuoLanSiegeData.IsActivityOpen() and Activity_LuoLanSiegeData.IsWinUnionAreMeUnion() then
    roleData.roleType = ERoleType.LuoLanDefense
  end
end

function Activity_SiegeManager.UpdateALLDefenseRoleType()
  if Activity_LuoLanSiegeData.IsActivityOpen() and Activity_LuoLanSiegeData.IsWinUnionAreMeUnion() then
    for i, v in pairs(this.defenseMonster) do
      v.roleType = ERoleType.LuoLanDefense
    end
  else
    for i, v in pairs(this.defenseMonster) do
      v.roleType = ERoleType.Monster
    end
  end
end

function Activity_SiegeManager.Role_OnMove(_, oldCell, cellPos)
  if Activity_LuoLanSiegeData.IsActivityOpen() then
    if not this.screenEffectCoroutine and cellPos.y >= 50 and cellPos.y < 175 then
      this.StartScreenEffect()
    end
    local tipsCellPos = string.format("%d_%d", cellPos.x, cellPos.y)
    if Activity_LuoLanSiegeData.IsShowTipsPos(tipsCellPos) then
      FloatingTipUtility.QuickMsg("T\198\176\225\187\163ng Th\225\186\167n Th\225\187\167 H\225\187\153 ch\198\176a b\225\187\139 ph\195\161, kh\195\180ng th\225\187\131 v\195\160o")
    end
  end
end

function Activity_SiegeManager.SiegePrefabLoad()
  if not CS.DynamicScene.SceneObjectGroupManager.Instance then
    return
  end
  if Activity_LuoLanSiegeData.IsActivityOpen() and not this.isHideBuilding then
    local group = CS.DynamicScene.SceneObjectGroupManager.Instance:FindGroup("Activity_Siege")
    if group then
      local hidePrefabs = group.sceneObjectList
      this.isHideBuilding = true
      for i = 0, hidePrefabs.Count - 1 do
        if hidePrefabs[i] then
          hidePrefabs[i]:SetActive(false)
        end
      end
    end
  end
  if Activity_LuoLanSiegeData.IsActivityOpen() and not this.screenEffectCoroutine and RoleManager.me.cellPos.y >= 50 and RoleManager.me.cellPos.y < 175 then
    this.StartScreenEffect()
  end
end

function Activity_SiegeManager.UpdateHalo(holdUnionId, curHaveUnionId, myUnionId)
  if this.haloModel then
    this.haloModel:Destroy()
    this.haloModel = nil
  end
  local haloEffect = ClientTable.cfg_Activity_globalManager:TryGetValue(100361, "id").effect
  local posData = string.split(haloEffect, "#")
  local posX, posY = posData[1], posData[2]
  local cellPos = Vector2Int(posX, posY)
  local position = Scene.GetPosByCell(cellPos)
  local model = ""
  if holdUnionId == 0 and curHaveUnionId == 0 then
    model = "Eff_zhanlingquan_bai"
  elseif myUnionId ~= 0 and (curHaveUnionId ~= 0 and curHaveUnionId == myUnionId or curHaveUnionId == 0 and holdUnionId == myUnionId) then
    model = "Eff_zhanlingquan_lv"
  else
    model = "Eff_zhanlingquan_hong"
  end
  local effectData = {
    modelType = EEffectModelType.Scene,
    model = model
  }
  this.haloModel = EffectModel(Effect.root, nil, effectData)
  this.haloModel:Init()
  this.haloModel:SetModel(1)
  this.haloModel:SetLayer(ROLE_LAYER)
  this.haloModel:SetPosition(position.x, position.y + 0.1, position.z)
  this.UpdateALLDefenseRoleType()
end

function Activity_SiegeManager.CreateUnionFightEffect(effectData, arrowDir, index)
  local effect = UnionFightEffect(effectData)
  this.screenEffects[index] = effect
  local rotateX = arrowDir == -1 and 0 or 180
  effect:SetRotation({
    x = rotateX,
    y = 0,
    z = 0
  })
end

function Activity_SiegeManager.CreateUnionFightEffectData(effectIndex, firstPos, arrowDir, index)
  local effectTab = {
    "Eff_G_pugong_02",
    "Eff_yunshi_01"
  }
  local effectData = {
    name = "unionFightEffect",
    modelType = EEffectModelType.Scene,
    model = effectTab[effectIndex],
    x = firstPos.x,
    y = firstPos.y,
    z = firstPos.z + arrowDir * 2,
    moveDir = arrowDir,
    id = index
  }
  return effectData
end

function Activity_SiegeManager.StartScreenEffect(cellPos)
  this.isStopScreenEffect = false
  local curTime = 0
  
  local function StartCountDown()
    local index = 1
    local oldTime = Time.GetServerSecondTime()
    while true do
      if not (RoleManager.me and Activity_LuoLanSiegeData.IsActivityOpen()) or this.isStopScreenEffect then
        this.screenEffectCoroutine = nil
        Coroutine.Break()
      end
      local arrowDir
      if RoleManager.me.cellPos.y >= 50 and RoleManager.me.cellPos.y < 95 then
        arrowDir = -1
      elseif RoleManager.me.cellPos.y >= 136 and RoleManager.me.cellPos.y < 175 then
        arrowDir = 1
      elseif RoleManager.me.cellPos.y >= 95 and RoleManager.me.cellPos.y < 135 then
        arrowDir = Mathf.Random(0, 1)
        arrowDir = arrowDir == 0 and -1 or 1
      else
        this.screenEffectCoroutine = nil
        Coroutine.Break()
      end
      curTime = Time.GetServerSecondTime()
      if 1 < curTime - oldTime then
        local num = Mathf.Random(1, 2)
        for i = 1, num do
          local move = Mathf.Random(0, 1)
          local firstPos = Vector3(0, 0, 0)
          local zInfo = Random.Range(3, 5)
          if move == 0 then
            local yInfo = Random.Range(0.1, 0.9)
            firstPos = MainCamera.initCamera:ViewportToWorldPoint(Vector3(Mathf.Clamp(arrowDir + 1, 0, 1), yInfo, zInfo))
          else
            local xInfo = Random.Range(0.1, 0.9)
            firstPos = MainCamera.initCamera:ViewportToWorldPoint(Vector3(xInfo, Mathf.Clamp(arrowDir + 1, 0, 1), zInfo))
          end
          local effectIndex = Mathf.Random(1, 2)
          local effectData = this.CreateUnionFightEffectData(effectIndex, firstPos, arrowDir, index)
          Activity_SiegeManager.CreateUnionFightEffect(effectData, arrowDir, index)
          index = index + 1
          if effectIndex == 1 and num == 1 then
            local threeSide = Mathf.Random(1, 10)
            if threeSide <= 2 then
              local leftArrowData = this.CreateUnionFightEffectData(effectIndex, firstPos, arrowDir, index)
              leftArrowData.x = leftArrowData.x + 1
              leftArrowData.z = leftArrowData.z - 0.5
              this.CreateUnionFightEffect(leftArrowData, arrowDir, index)
              index = index + 1
              local rightArrowData = this.CreateUnionFightEffectData(effectIndex, firstPos, arrowDir, index)
              rightArrowData.x = rightArrowData.x - 1
              rightArrowData.z = rightArrowData.z - 0.5
              this.CreateUnionFightEffect(rightArrowData, arrowDir, index)
              index = index + 1
            end
          end
        end
        oldTime = Time.GetServerSecondTime()
      end
      Coroutine.Wait(1)
    end
  end
  
  if not this.screenEffectCoroutine then
    this.screenEffectCoroutine = Coroutine.Start(StartCountDown)
  end
end

function Activity_SiegeManager.DestroyScreenEffect()
  if this.screenEffectCoroutine then
    this.isStopScreenEffect = true
    Coroutine.Stop(this.screenEffectCoroutine)
    this.screenEffectCoroutine = nil
  end
  if this.haloModel then
    this.haloModel:Destroy()
    this.haloModel = nil
    UIManager.Hide(UIID.Activity_SiegeProgressUI)
  end
  for k, v in pairs(this.safeAreaTable) do
    v:Destroy()
  end
  this.safeAreaTable = {}
  for i, v in pairs(this.screenEffects) do
    v:Destroy()
  end
  this.screenEffects = {}
  this.DestroyAllDefenseMonster()
end

function Activity_SiegeManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.DestroyScreenEffect()
  this.DestroyAllDefenseMonster()
  this.isHideBuilding = false
end

function Activity_SiegeManager.UnRegistAll()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.DestroyAllDefenseMonster()
  this.isHideBuilding = false
end
