require("GamePlay/Scene/SceneTileEnum")
require("GamePlay/Scene/SceneClientUpdateView")
Scene = {}
local this = Scene

function Scene.Init()
  this.eventContainer = EventContainer(EventManager)
  this.OnEnterGame()
end

function Scene.OnEnterRole()
  local request = SceneManager.Load("Scene/createrole.unity", function()
    MainCamera:SetLoginAnimatorActive(false)
    UIManager.Hide(UIID.LoginUI)
    UIManager.Show(UIID.LoginRoleUI)
    PreLoadManager.CatlikeLoadUI()
    MainCamera.LoginRoleCameraSet()
  end)
end

function Scene.OnEnterCreateRole()
  local request = SceneManager.Load("Scene/createrole.unity", function()
    MainCamera:SetLoginAnimatorActive(false)
    UIManager.Hide(UIID.LoginUI)
    UIManager.Show(UIID.LoginRoleUI, {silent = true})
    if not LoginData.needInviteCode then
      UIManager.Show(UIID.LoginCreateRoleUI)
    else
      UIManager.Show(UIID.InviteFriendUI)
    end
    PreLoadManager.CatlikeLoadUI()
    MainCamera.LoginRoleCameraSet()
  end)
end

function Scene.EnterLogin()
  DynamicTerrainController.SetLoginLightMap(1078)
  LoginData.LoginLog("------------\229\138\160\232\189\189\229\156\176\229\189\162\229\174\140\230\136\144,\229\138\160\232\189\189\229\156\186\230\153\175\229\188\128\229\167\139:::::" .. tostring(CS.System.DateTime.Now.Ticks))
  local request = SceneManager.Load("Scene/Login.unity", function()
    MainCamera:SetLoginAnimatorActive(true)
    UIManager.Hide(UIID.MainMenuUI)
    UIManager.Hide(UIID.LoadingUI)
    UIManager.Show(UIID.LoginUI)
    MainCamera.LoginCameraSet()
    LoginData.LoginLog("------------\229\138\160\232\189\189\229\156\176\229\189\162\229\155\158\232\176\131\229\174\140\230\136\144,\229\133\179\233\151\173\229\174\137\229\141\147\229\177\130\233\129\174\231\189\169:::::" .. tostring(CS.System.DateTime.Now.Ticks))
    MuInterfaceLua.Instance:HideView()
  end)
end

function Scene.OnEnterGame()
  this.RegistEvents()
end

function Scene.OnLeaveGame()
  this.EnterLogin()
  this.sitPos = nil
end

function Scene.ResetTile()
  this.tileData = nil
  SceneData.mapId = nil
  SceneData.line = nil
  SceneData.cline = nil
end

function Scene.ShotScreen(type)
  if SceneData.textureType ~= type then
    SceneData.texture2D = nil
    SceneData.textureType = type
  end
  local width = Screen.width
  local height = Screen.height
  if not SceneData.rt then
    SceneData.rt = RenderTexture(width, height, 0)
  end
  if not SceneData.texture2D then
    SceneData.texture2D = Texture2D(width, height, TextureFormat.RGB24, false)
  end
  local rt = SceneData.rt
  MainCamera.initCamera.targetTexture = rt
  MainCamera.initCamera:Render()
  RenderTexture.active = rt
  SceneData.texture2D:ReadPixels(Rect(0, 0, width, height), 0, 0)
  SceneData.texture2D:Apply()
  RenderTexture.active = nil
  MainCamera.initCamera.targetTexture = nil
end

function Scene.OnShowLoading(_, type, mapId)
  SceneData.preMapId = mapId
  SceneData.mapLoaded = false
  if type == "loading" then
    SceneData.textureType = type
    if UIManager.IsVisible(UIID.LoadingUI) then
      local ui = UIManager.GetUiByName(UIID.LoadingUI)
      ui:Refresh()
    else
      if SceneData.loadingTexture == nil then
        if CS.MuInterface.Instance:GetIsSpecialLoad() == 1 then
          local a = CS.Framework.StreamingAssetsFile.Load("cLoadingBg.jpg")
          local texture
          if a ~= nil and 0 < #a then
            texture = CS.UnityEngine.Texture2D(20, 10)
            CS.UnityEngine.ImageConversion.LoadImage(texture, a)
          end
          if texture then
            SceneData.loadingTexture = texture
          else
            this.request = CS.Framework.ResourceManager.LoadAsset("Texture/Loading-pve-f.jpg", typeof(CS.UnityEngine.Texture2D))
            SceneData.loadingTexture = this.request.res
          end
        else
          this.request = CS.Framework.ResourceManager.LoadAsset("Texture/Loading-pve-f.jpg", typeof(CS.UnityEngine.Texture2D))
          SceneData.loadingTexture = this.request.res
        end
      end
      SceneData.texture2D = SceneData.loadingTexture
      UIManager.Show(UIID.LoadingUI)
    end
  else
    if LoginData.InGame then
      UIManager.Show(UIID.WaitingUI, {
        msg = "\196\144ang \196\145\225\187\149i b\225\186\163n \196\145\225\187\147"
      })
    end
    this.ShotScreen(type)
    UIManager.Show(UIID.LoadingUI)
  end
end

function Scene.EnterScene(name)
  this.loaded = false
  EventManager.Dispatch(Event.Scene_OnEnterScene, SceneData.mapId)
  local request = SceneManager.Load("Scene/" .. name .. ".unity", this.OnLoadScene)
end

function Scene.OnLoadScene()
  this.loaded = true
  this.ResetSceneInfo()
  NetManager.Send(MapMessage.ReqLoginMap)
  EventManager.Dispatch(Event.Scene_SceneLoaded, SceneData.mapId)
  RoleManager.me:ShowBubbleEffect(this.IsWaterMap(SceneData.mapId))
end

function Scene.ResetSceneInfo()
  this.InitSceneAudioData()
  this.InitStepSoundTimeOffset()
  this.InitGroundData()
  this.InitSceneWeather(SceneData.mapId)
  this.tileData = CS.Framework.SceneTileData.instance
  this.tileData:TileDataCallBack(tostring(SceneData.bytesName))
  this.tileSize = this.tileData.tileSize
  this.width = this.tileData.width
  this.height = this.tileData.height
  this.dynamicBlockTiles = {}
  this.TilesRoleData = {}
end

function Scene.GetTerrainHeight(x, y)
  if Scene.tileData == nil then
    return 0
  end
  local aa = Scene.tileData:GetTileHeight(x, y)
  return Scene.tileData:GetTileHeight(x, y)
end

local ListFloat = CS.System.Collections.Generic.List(CS.System.Single)
local ListInt = CS.System.Collections.Generic.List(CS.System.Int32)
local tempPath = ListFloat()
local tempTilePath = ListInt()
local tempGuidePath = ListInt()

function Scene.SearchPath(pos1, pos2, stopRange)
  if not this.tileData then
    return this.GetLinePath(pos1, pos2, stopRange)
  end
  local arrive = this.tileData:SearchPath(pos1.x, pos1.z, pos2.x, pos2.z, stopRange or 0, tempPath)
  local count = tempPath.Count / 3
  if count == 0 then
    return arrive, nil
  end
  local path = {}
  for i = 1, count do
    local x = tempPath[i * 3 - 3]
    local y = tempPath[i * 3 - 2]
    local z = tempPath[i * 3 - 1]
    path[i] = Vector3(x, y, z)
  end
  return arrive, path
end

function Scene.GetLinePath(pos1, pos2, stopRange)
  local dx = pos2.x - pos1.x
  local dz = pos2.z - pos1.z
  local d = math.sqrt(dx * dx + dz * dz)
  if d < Mathf.Epsilon then
    return true, nil
  end
  if not stopRange or stopRange == 0 then
    return true, {
      pos1:Clone(),
      pos2:Clone()
    }
  end
  if stopRange >= d then
    return true, nil
  end
  dx = dx * stopRange / d
  dz = dz * stopRange / d
  return true, {
    pos1:Clone(),
    Vector3(pos2.x - dx, pos2.y, pos2.z - dz)
  }
end

function Scene.SearchTilePath(cell1, cell2, stopRange, roleBlock)
  if not this.tileData then
    return this.GetTileLinePath(cell1, cell2, stopRange)
  end
  if roleBlock and SceneData.overlap <= 0 then
    this.SetRoleTilesInfor(true)
  end
  local arrive = this.tileData:SearchTilePath(cell1.x, cell1.y, cell2.x, cell2.y, stopRange or 0, tempTilePath, tempGuidePath)
  if roleBlock and SceneData.overlap <= 0 then
    this.SetRoleTilesInfor(false)
  end
  local count = tempTilePath.Count / 2
  if count == 0 then
    return arrive, nil
  end
  local path = {}
  for i = 1, count do
    local x = tempTilePath[i * 2 - 2]
    local y = tempTilePath[i * 2 - 1]
    path[i] = Vector2Int(x, y)
  end
  local guideCount = tempGuidePath.Count / 2
  local guidePath
  if guideCount ~= 0 then
    guidePath = {}
    for i = 1, guideCount do
      local x = tempGuidePath[i * 2 - 2]
      local y = tempGuidePath[i * 2 - 1]
      guidePath[i] = Vector2Int(x, y)
    end
  end
  return arrive, path, guidePath
end

function Scene.UpdateNavPath(oldPath, startIndex)
  if startIndex >= #oldPath then
    return {}
  end
  local firstWalkableIndex = #oldPath
  for i = startIndex + 1, #oldPath do
    if not this.IsBlock(oldPath[i]) then
      firstWalkableIndex = i
      break
    end
  end
  local subPath2 = {}
  for i = firstWalkableIndex + 1, #oldPath do
    subPath2[i - firstWalkableIndex] = oldPath[i]
  end
  local startCell = oldPath[startIndex]
  local endCell = oldPath[firstWalkableIndex]
  local arrive, subPath1 = this.SearchTilePath(startCell, endCell)
  if not arrive or subPath1 == nil then
    return {}
  end
  for i = #subPath1, 1, -1 do
    table.insert(subPath2, 1, subPath1[i])
  end
  return subPath2
end

function Scene.GetTileLinePath(cell1, cell2, stopRange)
  local dx = cell2.x - cell1.x
  local dz = cell2.y - cell1.y
  local d = math.sqrt(dx * dx + dz * dz)
  if d < Mathf.Epsilon then
    return true, nil
  end
  if not stopRange or stopRange == 0 then
    return true, {
      cell1:Clone(),
      cell2:Clone()
    }
  end
  if stopRange >= d then
    return true, nil
  end
  dx = dx * stopRange / d
  dz = dz * stopRange / d
  return true, {
    cell1:Clone(),
    Vector2Int(cell2.x - dx, cell2.y - dz)
  }
end

function Scene.GetCellXYByPos(pos)
  if pos == nil or Scene.tileSize == nil then
    return 0, 0
  end
  local x = Mathf.Floor(pos.x / Scene.tileSize)
  local y = Mathf.Floor(pos.z / Scene.tileSize)
  return x, y
end

function Scene.GetCellByPos(pos)
  if pos == nil or Scene.tileSize == nil then
    return Vector2Int(0, 0)
  end
  return Vector2Int(Mathf.Floor(pos.x / Scene.tileSize), Mathf.Floor(pos.z / Scene.tileSize))
end

function Scene.GetPosByCellNoGC(cell, resultPos)
  if cell then
    this.GetPosByCellNonAlloc(cell.x, cell.y, resultPos)
  end
  return resultPos
end

local cellPos = Vector3.zero

function Scene.GetPosXYZByCell(cell)
  cellPos:Set(0, 0, 0)
  if cell then
    this.GetPosByCellNonAlloc(cell.x, cell.y, cellPos)
  end
  return cellPos.x, cellPos.y, cellPos.z
end

function Scene.GetPosByCell(cell)
  local pos = Vector3()
  if cell then
    this.GetPosByCellNonAlloc(cell.x, cell.y, pos)
  end
  return pos
end

function Scene.GetPosByCellFromPool(cell)
  local pos = Vector3.Alloc(0, 0, 0)
  if cell then
    this.GetPosByCellNonAlloc(cell.x, cell.y, pos)
  end
  return pos
end

function Scene.GetPosByCellNonAlloc(cx, cy, pos)
  if Scene.tileSize == nil then
    return pos:Set(0, 0, 0)
  end
  local x = (cx + 0.5) * Scene.tileSize
  local z = (cy + 0.5) * Scene.tileSize
  pos:Set(x, Scene.GetTerrainHeight(cx, cy), z)
end

function Scene.SetTileType(x, y, type)
  if this.tileData then
    this.tileData:SetTileType(x, y, type)
  end
end

function Scene.RegistEvents()
  this.eventContainer:Regist(Event.Scene_ShowLoading, this.OnShowLoading)
  this.eventContainer:Regist(Event.Role_OnArrive, this.RoleMeOnArrivePos)
  this.eventContainer:Regist(Event.SceneInteractiveOnClick, this.SceneInteractiveOnClick)
  this.eventContainer:Regist(Event.SceneInteractiveSitOnClick, this.SceneInteractiveSitOnClick)
  this.eventContainer:Regist(Event.Role_CheckSitState, this.MoveBefore)
  this.eventContainer:Regist(Event.BreakSitState, this.BreakSitState)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.Back2Choose)
  this.eventContainer:Regist(Event.Game_Restart, this.OnRestart)
end

function Scene.OnRestart()
  if this.request then
    this.request:Dispose()
    this.request = nil
  end
end

function Scene.Back2Choose()
  this.sitPos = nil
end

function Scene.BreakSitState()
  if this.sitPos then
    RoleManager.me.model:PlayAnimation("idle")
    local positionX, positionY, positionZ = Scene.GetPosXYZByCell(this.sitPos)
    RoleManager.me.transform:SetPosition(positionX, positionY, positionZ)
    EventManager.Dispatch(Event.Role_OnArrive, this.sitPos)
    this.sitPos = nil
  end
end

function Scene.MoveBefore(_, cell)
  cell = cell and cell or this.sitPos
  if this.sitPos then
    if this.sitPos == cell then
      RoleManager.me.model:PlayAnimation("idle")
    elseif not this.IsTileType(cell.x, cell.y, SceneTileType.Ignore) then
      RoleManager.me.model:PlayAnimation("walk")
    else
      RoleManager.me.model:PlayAnimation("idle")
    end
    if cell.animation then
      RoleManager.me.model:PlayAnimation(cell.animation)
    end
    local positionX, positionY, positionZ = Scene.GetPosXYZByCell(this.sitPos)
    RoleManager.me.transform:SetPosition(positionX, positionY, positionZ)
    NetManager.Send(MapMessage.ReqChangeInteractionState, {
      interactionState = 0,
      x = this.sitPos.x,
      y = this.sitPos.y
    })
    EventManager.Dispatch(Event.Role_OnArrive, this.sitPos)
    this.sitPos = nil
  end
end

local roundCells = {}

local function CurrentCellPosRoundCells(pos)
  roundCells[1] = {
    x = pos.x + 1,
    y = pos.y
  }
  roundCells[2] = {
    x = pos.x - 1,
    y = pos.y
  }
  roundCells[3] = {
    x = pos.x,
    y = pos.y + 1
  }
  roundCells[4] = {
    x = pos.x,
    y = pos.y - 1
  }
  roundCells[5] = {
    x = pos.x + 1,
    y = pos.y + 1
  }
  roundCells[6] = {
    x = pos.x - 1,
    y = pos.y - 1
  }
  roundCells[7] = {
    x = pos.x + 1,
    y = pos.y - 1
  }
  roundCells[8] = {
    x = pos.x - 1,
    y = pos.y + 1
  }
  local canSitCells = {}
  for i = 1, #roundCells do
    if this.IsTileType(roundCells[i].x, roundCells[i].y, SceneTileType.Sit) then
      table.insert(canSitCells, roundCells[i])
    end
  end
  return canSitCells
end

local CurrentCellPos
local worldPos = Vector3.zero

function Scene.RoleMeOnArrivePos(_, pos)
  if not RoleManager.me or RoleManager.me.model:IsMounting() then
    return
  end
  local canSitCells = CurrentCellPosRoundCells(pos)
  if 0 < #canSitCells then
    local scenePos = {}
    for i = 1, #canSitCells do
      local worldPosX, worldPosY, worldPosZ = this.GetPosXYZByCell(canSitCells[i])
      worldPos:Set(worldPosX, worldPosY + 1.5, worldPosZ)
      local posInfor = {
        viewPos = MainCamera.camera:WorldToViewportPoint(worldPos),
        cellPos = canSitCells[i]
      }
      scenePos[i] = posInfor
    end
    EventManager.Dispatch(Event.SceneInteractiveSit, scenePos)
  else
    EventManager.Dispatch(Event.SceneInteractiveSit, canSitCells)
  end
  CurrentCellPos = pos
  if this.IsTileType(pos.x, pos.y, SceneTileType.LeanOn) or this.IsTileType(pos.x, pos.y, SceneTileType.FlyUp) then
    EventManager.Dispatch(Event.SetSceneInteractiveState, true)
  else
    EventManager.Dispatch(Event.SetSceneInteractiveState, false)
  end
end

local function GetSceneObjByMapPos(x, y)
  local indexKey = y * this.width + x
  if table.containsKey(this.tileData.SceneObjectByMapPos, indexKey) then
    local objList = this.tileData.SceneObjectByMapPos[indexKey]
    local MeshRend = objList[0]:GetComponentInChildren(typeof(UnityEngineLua.MeshRenderer))
    local offsetValue = MeshRend.bounds.size.y - 0.45
    return objList[0].transform.position + Vector3.up * offsetValue
  else
    return false
  end
end

local function GetAroundSceneObj(cell, role)
  local targetPos = GetSceneObjByMapPos(cell.x + 1, cell.y)
  if targetPos then
    role.transform.position = targetPos
    return
  end
  targetPos = GetSceneObjByMapPos(cell.x - 1, cell.y)
  if targetPos then
    role.transform.position = targetPos
    return
  end
  targetPos = GetSceneObjByMapPos(cell.x, cell.y + 1)
  if targetPos then
    role.transform.position = targetPos
    return
  end
  targetPos = GetSceneObjByMapPos(cell.x, cell.y - 1)
  if targetPos then
    role.transform.position = targetPos
    return
  end
  targetPos = GetSceneObjByMapPos(cell.x + 1, cell.y + 1)
  if targetPos then
    role.transform.position = targetPos
    return
  end
  targetPos = GetSceneObjByMapPos(cell.x + 1, cell.y - 1)
  if targetPos then
    role.transform.position = targetPos
    return
  end
  targetPos = GetSceneObjByMapPos(cell.x - 1, cell.y - 1)
  if targetPos then
    role.transform.position = targetPos
    return
  end
  targetPos = GetSceneObjByMapPos(cell.x - 1, cell.y + 1)
  if targetPos then
    role.transform.position = targetPos
  end
end

local function IsCanSit()
  return RoleManager.me.usingSkillId == nil and not RoleManager.me.isDead
end

function Scene:SceneInteractiveSitOnClick(cell)
  if RoleManager.me.model:IsMounting() then
    return
  end
  if not IsCanSit() then
    return
  end
  if not RoleManager.me:IsStillState() then
    return
  end
  this.sitPos = CurrentCellPos
  this.SetRoleSitState(cell, RoleManager.me)
  NetManager.Send(MapMessage.ReqChangeInteractionState, {
    interactionState = 2,
    x = cell.x,
    y = cell.y
  })
  this.RoleMeOnArrivePos(nil, cell)
end

local sitTypeDirection = {
  {
    sitType = SceneTileSitType.up,
    direction = Vector3.forward
  },
  {
    sitType = SceneTileSitType.RightUp,
    direction = Vector3.right + Vector3.forward
  },
  {
    sitType = SceneTileSitType.Right,
    direction = Vector3.right
  },
  {
    sitType = SceneTileSitType.RightDown,
    direction = Vector3.right + Vector3.back
  },
  {
    sitType = SceneTileSitType.Down,
    direction = Vector3.back
  },
  {
    sitType = SceneTileSitType.LeftDown,
    direction = Vector3.left + Vector3.back
  },
  {
    sitType = SceneTileSitType.Left,
    direction = Vector3.left
  },
  {
    sitType = SceneTileSitType.LeftUp,
    direction = Vector3.left + Vector3.forward
  },
  {
    sitType = SceneTileSitType.All,
    direction = Vector3.zero
  }
}

function Scene.GetSitTypeDirection(sitType)
  for i = 1, #sitTypeDirection do
    if bit.band(sitType, SceneTileType.Sit) == sitTypeDirection[i].sitType then
      return sitTypeDirection[i].direction
    end
  end
end

function Scene.SetRoleSitState(cell, role)
  local positionX, positionY, positionZ = Scene.GetPosXYZByCell(cell)
  role.transform:SetPosition(positionX, positionY, positionZ)
  role.model:PlayAnimation("sit")
  local sitType = this.GetTileType(cell.x, cell.y)
  local forwardDirection = this.GetSitTypeDirection(sitType)
  if forwardDirection and forwardDirection ~= Vector3.zero then
    role.model.transform.forward = forwardDirection
  end
  if bit.band(sitType, SceneTileType.Sit) == SceneTileSitType.All then
    role.model:PlayAnimation("allSit")
    local targetPos = GetSceneObjByMapPos(cell.x, cell.y)
    if targetPos then
      role.transform.position = targetPos
    else
      GetAroundSceneObj(cell, role)
    end
  end
end

function Scene.SceneInteractiveOnClick()
  if RoleManager.me.model:IsMounting() then
    return
  end
  if not RoleManager.me:IsStillState() then
    return
  end
  this.sitPos = CurrentCellPos
  if this.IsTileType(this.sitPos.x, this.sitPos.y, SceneTileType.LeanOn) then
    this.SetRoleLeanOnState({
      x = this.sitPos.x,
      y = this.sitPos.y
    }, RoleManager.me)
    NetManager.Send(MapMessage.ReqChangeInteractionState, {
      interactionState = 1,
      x = this.sitPos.x,
      y = this.sitPos.y
    })
    return
  end
  if this.SetRoleFlyUpState({
    x = this.sitPos.x,
    y = this.sitPos.y
  }, RoleManager.me) then
    NetManager.Send(MapMessage.ReqChangeInteractionState, {
      interactionState = 3,
      x = this.sitPos.x,
      y = this.sitPos.y
    })
  end
end

function Scene.SetRoleLeanOnState(cell, role)
  local type = this.GetTileType(cell.x, cell.y)
  role:PlayAnimation("leanOn")
  if bit.band(type, SceneTileType.LeanOn) == SceneLeanOnType.Up then
    role.model.transform.forward = Vector3.back
  end
  if bit.band(type, SceneTileType.LeanOn) == SceneLeanOnType.RightUp then
    role.model.transform.forward = Vector3.left + Vector3.back
  end
  if bit.band(type, SceneTileType.LeanOn) == SceneLeanOnType.Right then
    role.model.transform.forward = Vector3.left
  end
  if bit.band(type, SceneTileType.LeanOn) == SceneLeanOnType.RightDown then
    role.model.transform.forward = Vector3.left + Vector3.forward
  end
  if bit.band(type, SceneTileType.LeanOn) == SceneLeanOnType.Down then
    role.model.transform.forward = Vector3.forward
  end
  if bit.band(type, SceneTileType.LeanOn) == SceneLeanOnType.LeftDown then
    role.model.transform.forward = Vector3.right + Vector3.forward
  end
  if bit.band(type, SceneTileType.LeanOn) == SceneLeanOnType.Left then
    role.model.transform.forward = Vector3.right
  end
  if bit.band(type, SceneTileType.LeanOn) == SceneLeanOnType.LeftUp then
    role.model.transform.forward = Vector3.right + Vector3.back
  end
end

function Scene.SetRoleFlyUpState(cell, role)
  if this.IsTileType(cell.x, cell.y, SceneTileType.FlyUp) then
    role:PlayAnimation("flyUp")
    return true
  end
  return false
end

function Scene.OnEnterMap()
  this.EnterScene(SceneData.resName)
end

function Scene.IsTileType(x, y, sceneTileType)
  if not this.tileData then
    return 0
  end
  return this.tileData:IsTileType(x, y, sceneTileType)
end

function Scene.IsBlock(cell)
  if not this.tileData then
    logError("X\195\161c \196\145\225\187\139nh \196\145i\225\187\131m ch\225\186\183n, d\225\187\175 li\225\187\135u \195\180 kh\195\180ng t\225\187\147n t\225\186\161i, k\225\186\191t qu\225\186\163 l\195\160 false")
    return false
  end
  return this.tileData:IsBlock(cell.x, cell.y)
end

function Scene.PackCoordToNumber(coord)
  return bit.bor(bit.lshift(coord.x, 8), coord.y)
end

function Scene.UnpackNumberToCoord(coord)
  return bit.rshift(coord, 8), bit.band(coord, 255)
end

function Scene.MarkTileBlock(cell)
  local coordNum = this.PackCoordToNumber(cell)
  this.dynamicBlockTiles[coordNum] = true
end

function Scene.ClearTileBlockMark(cell)
  local coordNum = this.PackCoordToNumber(cell)
  this.dynamicBlockTiles[coordNum] = nil
end

function Scene.IsTileDynamicBlock(cell)
  local coordNum = this.PackCoordToNumber(cell)
  return this.dynamicBlockTiles[coordNum]
end

local blockedCells = {}

function Scene.BlockAllMarkedTiles()
  for k, _ in pairs(this.dynamicBlockTiles) do
    local x, y = this.UnpackNumberToCoord(k)
    local tileVec2 = Vector2Int(x, y)
    if not this.IsBlock(tileVec2) then
      this.AddTileType(tileVec2, SceneTileType.Block)
      blockedCells[k] = tileVec2
    end
  end
end

function Scene.RecoverDynamicBlocks()
  for _, v in pairs(blockedCells) do
    this.RemoveTileType(v, SceneTileType.Block)
  end
  blockedCells = {}
end

function Scene.AddTilesRoleInfor(cell, role)
  local coordNum = this.PackCoordToNumber(cell)
  if not this.TilesRoleData then
    this.TilesRoleData = {}
  end
  if not this.TilesRoleData[coordNum] then
    this.TilesRoleData[coordNum] = {}
  end
  if role.StaticBlockMonster and role.StaticBlockMonster(role.data.configId) then
    return
  end
  table.insert(this.TilesRoleData[coordNum], role)
end

local function GetTableLength(tab)
  local tableCount = 0
  for k, v in pairs(tab) do
    tableCount = tableCount + 1
  end
  return tableCount
end

function Scene.TileCanMoveToByRole(cell)
  if this.GetTilesRoleInfor(cell) > 0 then
    if this.IsSafeZone(cell.x, cell.y) or 0 < SceneData.overlap then
      return true
    end
    return false
  end
  return true
end

function Scene.GetTilesRoleInfor(cell)
  local coordNum = this.PackCoordToNumber(cell)
  if not this.TilesRoleData[coordNum] then
    return 0
  end
  local count = GetTableLength(this.TilesRoleData[coordNum])
  return count
end

function Scene.RomoveTilesRoleInfor(cell, role)
  local coordNum = this.PackCoordToNumber(cell)
  if not this.TilesRoleData then
    return
  end
  if not this.TilesRoleData[coordNum] then
    return
  end
  for i = 1, #this.TilesRoleData[coordNum] do
    if this.TilesRoleData[coordNum][i] == role then
      table.remove(this.TilesRoleData[coordNum], i)
      break
    end
  end
end

local calculateCell = {}

function Scene.IsRoleTile(cell)
  local roles = this.TilesRoleData[this.PackCoordToNumber(cell)]
  return roles and next(roles)
end

function Scene.SetRoleTilesInfor(isBlock)
  for k, v in pairs(this.TilesRoleData) do
    if next(v) then
      local x, y = this.UnpackNumberToCoord(k)
      calculateCell.x = x
      calculateCell.y = y
      if isBlock then
        this.AddTileType(calculateCell, SceneTileType.Block)
      else
        this.RemoveTileType(calculateCell, SceneTileType.Block)
      end
    end
  end
end

function Scene.AddTileType(cell, type)
  if this.tileData then
    this.tileData:AddTileType(cell.x, cell.y, type)
  else
    logWarning("AddTileType failed,tileData is nil.Scene has been unloaded perhaps.")
  end
end

function Scene.RemoveTileType(cell, type)
  if this.tileData then
    this.tileData:RemoveTileType(cell.x, cell.y, type)
  else
    logWarning("RemoveTileType failed,tileData is nil.Scene has been unloaded perhaps.")
  end
end

function Scene.IsSafeZone(x, y)
  if not this.tileData then
    return 0
  end
  return this.tileData:IsTileType(x, y, SceneTileType.Safe)
end

local swimMaps = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(1010001)
local SwimZoneMapId = string.split(swimMaps, "#")

function Scene.IsSwimZone(pos)
  if not pos then
    return false
  end
  for i = 1, #SwimZoneMapId do
    if tonumber(SwimZoneMapId[i]) == SceneData.groupId and not this.IsSafeZone(pos.x, pos.y) then
      return true
    end
  end
  local sitType = this.GetTileType(pos.x, pos.y)
  if sitType then
    return bit.band(sitType, SceneTileType.Material) == SceneMaterialType.Water
  end
  return false
end

function Scene.IsWaterMap(mapId)
  return mapId == 1008
end

function Scene.GetTileType(x, y)
  if not this.tileData then
    return 0
  end
  return this.tileData:GetTileType(x, y)
end

local StepSoundTileType = {
  stone = SceneMaterialType.Stone,
  grass = SceneMaterialType.Grass,
  snow = SceneMaterialType.Snow,
  water = SceneMaterialType.Water,
  sand = SceneMaterialType.Sand
}

function Scene.GetTileStepSoundType(tileType)
  for _, v in pairs(StepSoundTileType) do
    if this.IsSameStepSoundType(tileType, v) then
      return v
    end
  end
  return nil
end

function Scene.IsSameStepSoundType(type, targetType)
  return bit.band(type, SceneTileType.Material) == targetType
end

local AudioBgmType = {default = 1, indoor = 2}
local curSceneBgmInfo, defaultStepAudioInfo, cacheStepAudioInfo, cacheGripSoundType
local stepAudioIDInGlobalTable = 8000001
local stepSoundTypeToAudioIdTable = {}
local envirLoopSoundTable = {}
local envirRandomSoundTable = {}
local loopSoundPlayTable = {}
local randomSoundTimerTable = {}
local roundSoundResetTimeLoop = {}

function Scene.InitSceneAudioData()
  curSceneBgmInfo = ClientTable.cfg_Audio_audioManager:TryGetValue(SceneData.bgm, "id")
  this.PlaySceneBGM(curSceneBgmInfo.resourceName, curSceneBgmInfo.volume)
  envirLoopSoundTable = {}
  envirRandomSoundTable = {}
  local soundArray = string.split(SceneData.sounds, "|")
  for i = 1, table.count(soundArray) do
    local soundInfoArray = string.split(soundArray[i], "#")
    local audioInfo = ClientTable.cfg_Audio_audioManager:TryGetValue(tonumber(soundInfoArray[1]), "id")
    if tonumber(soundInfoArray[2]) == 0 then
      envirLoopSoundTable[i] = audioInfo
    else
      envirRandomSoundTable[i] = {
        id = tonumber(soundInfoArray[1]),
        leftValue = tonumber(soundInfoArray[2]),
        rightValue = tonumber(soundInfoArray[3]),
        audioInfo = audioInfo
      }
    end
  end
  this.PlayEnvironmentSound()
  local audioChangeTbl = ClientTable.cfg_Global_globalManager:TryGetValue(stepAudioIDInGlobalTable)
  local infoArray = string.split(audioChangeTbl.effect, "#")
  for i = 1, table.count(infoArray) do
    local infoArrayKey = string.split(infoArray[i], "_")
    stepSoundTypeToAudioIdTable[tonumber(infoArrayKey[1])] = tonumber(infoArrayKey[2])
  end
  this.UpdateDefaultStepAudio(9)
end

function Scene.InitSceneWeather(mapid)
  SceneWeatherEffect.InitEffect(mapid)
end

function Scene.UpdateDefaultStepAudio(audioId)
  defaultStepAudioInfo = ClientTable.cfg_Audio_audioManager:TryGetValue(audioId, "id")
end

function Scene.GetAudioInfoBySoundType(soundType)
  if soundType == cacheGripSoundType then
    return cacheStepAudioInfo
  end
  if stepSoundTypeToAudioIdTable[soundType] then
    local audioInfo = ClientTable.cfg_Audio_audioManager:TryGetValue(stepSoundTypeToAudioIdTable[soundType], "id")
    cacheGripSoundType = soundType
    cacheStepAudioInfo = audioInfo
    return audioInfo
  end
  return defaultStepAudioInfo
end

function Scene.ChangeBGMByZone(roleTransform, bgmName)
  if string.isNullOrEmpty(bgmName) then
    this.PlayCurrentSceneBgm()
    this.PlayLoopEnvironmentSound()
  else
    AudioManager.PlayBGM(bgmName, 1)
    this.StopLoopEnvironmentSound()
  end
end

function Scene.PlaySceneBGM(bgmName, volume)
  AudioManager.PlayBGM(bgmName, volume * 0.01)
end

function Scene.PlayCurrentSceneBgm()
  this.PlaySceneBGM(curSceneBgmInfo.resourceName, curSceneBgmInfo.volume)
end

local walkTimeOffset, runTimeOffset
local walkAudioTimeOffsetID = 8000002
local runAudioTimeOffsetID = 8000003

function Scene.InitStepSoundTimeOffset()
  local stepAudioOffsetTbl = ClientTable.cfg_Global_globalManager:TryGetValue(walkAudioTimeOffsetID)
  walkTimeOffset = tonumber(stepAudioOffsetTbl.effect) / 1000
  stepAudioOffsetTbl = ClientTable.cfg_Global_globalManager:TryGetValue(runAudioTimeOffsetID)
  runTimeOffset = tonumber(stepAudioOffsetTbl.effect) / 1000
end

local curTileType
local curStepAudioInfo = defaultStepAudioInfo

function Scene.UpdateTileType(tileType)
  if curTileType == tileType then
    return
  end
  curTileType = tileType
  curStepAudioInfo = this.GetStepSoundType(curTileType)
end

function Scene.InitGroundData()
  local terrin = CS.UnityEngine.GameObject.Find("scene/terrain")
  if terrin ~= nil then
    local grounds = terrin:GetComponentsInChildren(typeof(CS.UnityEngine.MeshCollider))
    this.terrinTrans = {}
    for index = 0, grounds.Length - 1 do
      if grounds[index].gameObject.layer == LayerMask.NameToLayer("Ground") then
        table.insert(this.terrinTrans, grounds[index].gameObject)
      end
    end
  end
end

function Scene.GetStepSoundType(tileType)
  local audioInfo
  local soundType = this.GetTileStepSoundType(tileType)
  if soundType then
    audioInfo = this.GetAudioInfoBySoundType(soundType)
  else
    audioInfo = defaultStepAudioInfo
  end
  return audioInfo
end

local walkOrRunPlaySound, currentState

function Scene.PlayStepSoundByMoveName(stateName)
  if string.isNullOrEmpty(stateName) or currentState == stateName then
    return
  end
  currentState = stateName
  if walkOrRunPlaySound then
    Timer.Stop(walkOrRunPlaySound)
  end
  if currentState == "idle" then
    return
  end
  local isWalk = currentState == "walk"
  if curStepAudioInfo then
    AudioManager.PlayEffect(curStepAudioInfo.resourceName, curStepAudioInfo.volume * 0.01, false, nil)
    walkOrRunPlaySound = Timer.StartLoopForever(isWalk and walkTimeOffset or runTimeOffset, function()
      AudioManager.PlayEffect(curStepAudioInfo.resourceName, curStepAudioInfo.volume * 0.01, false, nil)
    end)
  end
end

function Scene.PlayEnvironmentSound()
  this.PlayLoopEnvironmentSound()
  this.PlayRandomEnvironmentSound()
end

function Scene.PlayLoopEnvironmentSound()
  this.StopLoopEnvironmentSound()
  for i, v in pairs(envirLoopSoundTable) do
    if v then
      local audioObject = AudioManager.PlayEffect(v.resourceName, v.volume * 0.01, true, nil)
      loopSoundPlayTable[i] = audioObject
    end
  end
end

function Scene.StopLoopEnvironmentSound()
  for i, v in pairs(loopSoundPlayTable) do
    if v then
      AudioManager.Stop(v)
    end
  end
  loopSoundPlayTable = {}
end

function Scene.PlayRandomEnvironmentSound()
  this.StopRandomEnvironmentSound()
  randomSoundTimerTable = {}
  for i, v in pairs(envirRandomSoundTable) do
    if v then
      local timer = Timer.StartLoopForever(Mathf.Random(v.leftValue, v.rightValue), function()
        AudioManager.PlayEffect(v.audioInfo.resourceName, v.audioInfo.volume * 0.01, false, nil)
      end)
      randomSoundTimerTable[v.id] = timer
    end
  end
end

function Scene.StopRandomEnvironmentSound()
  for i, v in pairs(randomSoundTimerTable) do
    if v then
      Timer.Stop(v)
    end
  end
end

function Scene.GenerateGuidePoints()
  if this.tileData == nil then
    return
  end
  this.tileData:GenerateGuidePoints()
end

Scene.Init()
