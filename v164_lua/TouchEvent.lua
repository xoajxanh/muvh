TouchEvent = {}
local this = TouchEvent
this.clickTime = nil
this.lastCachedPos = Vector3()

function TouchEvent.OnEnterGame()
end

function TouchEvent.OnLeaveGame()
end

function TouchEvent.Update()
  this.OnClick()
  this.ProcessCachedMovePos()
end

function TouchEvent.LateUpdate()
end

local Input = CS.UnityEngine.Input
local PhysicsEx = CS.Framework.PhysicsEx
local timeduring = 1

function TouchEvent.OnClick()
  if Input.GetMouseButtonDown(0) then
    timeduring = 1
    if CS.Framework.InputEx.ClickUICheck() or Main_JoyStickUI.holdingJoyStick then
      return
    end
    this.ClickDown()
  end
  if Input.GetMouseButton(0) then
    if 1 <= timeduring then
      timeduring = 0
      if CS.Framework.InputEx.ClickUICheck() or Main_JoyStickUI.holdingJoyStick then
        return
      end
      this.ClickHold()
    end
    timeduring = timeduring + 0.02
  end
end

function TouchEvent.ClickDown()
end

local TouchEffectPos = Vector3.zero

function TouchEvent.ClickHold()
  local hitObj, hitX, hitY, hitZ = PhysicsEx.MouseRaycast(MainCamera.camera)
  local hited = false
  if hitObj then
    local layerName = LayerMask.LayerToName(hitObj.layer)
    if layerName == "Role" then
      local Avatar = RoleManager.GetRoleByModel(hitObj)
      if Avatar then
        if CS.Game.NavMesh.NavMeshPathFinding.Instance ~= nil then
          local paths, pathLength = CS.Game.NavMesh.NavMeshPathFinding.Instance:SeekPath(RoleManager.me.pos, Avatar.pos)
          if pathLength < GameInitData.PathFindLimit then
            if Avatar.RoleType == ERoleType.Monster then
              if Avatar.hp > 0 then
                RoleManager.me:SetTarget(Avatar)
                hited = true
              end
            else
              RoleManager.me:SetTarget(Avatar)
              hited = true
            end
          end
        elseif Avatar.RoleType == ERoleType.Monster then
          if Avatar.hp > 0 then
            RoleManager.me:SetTarget(Avatar)
            hited = true
          end
        else
          RoleManager.me:SetTarget(Avatar)
          hited = true
        end
        EventManager.Dispatch(Event.Touch_TargetClick, Avatar)
      end
    end
  end
  if hited or not RoleManager.me then
    return
  end
  hitX, hitY, hitZ = PhysicsEx.LinearCastGround(MainCamera.camera)
  if RoleManager.me.TargetAvatar ~= nil and RoleManager.me.TargetAvatar.RoleType == ERoleType.NPC then
    RoleManager.me:SetTarget(nil)
  end
  this.lastCachedPos:Set(hitX, hitY, hitZ)
  RoleManager.me:MoveCloseAutoFight()
  if RoleManager.me.usingSkillId then
    this.lastCachedPos.valid = true
  else
    RoleManager.me:ProcessMoveInput("Ground", hitX, hitY, hitZ)
    this.lastCachedPos.valid = false
  end
  AutoTaskManage.SetCurRoleOperate(AutoTaskOperateType.MouseClick)
  Scene.GetPosByCellNoGC(Scene.GetCellByPos(this.lastCachedPos), TouchEffectPos)
  SceneTouchEffect.Play(TouchEffectPos)
end

function TouchEvent.ProcessCachedMovePos()
  if not RoleManager.me or RoleManager.me.usingSkillId then
    return
  end
  if this.lastCachedPos.valid then
    this.lastCachedPos.valid = false
    local cellPos = Scene.GetCellByPos(Vector3(this.lastCachedPos.x, this.lastCachedPos.y, this.lastCachedPos.z))
    if RoleManager.me:IsStillState() and cellPos == RoleManager.me.cellPos then
      RoleManager.me.roleMoveContext:RefreshAutoFight()
    end
    RoleManager.me:ProcessMoveInput("Ground", this.lastCachedPos.x, this.lastCachedPos.y, this.lastCachedPos.z)
  end
end

function TouchEvent.ProcessClickInAutoAttackState()
  if not QiJiHelperData.isAutoFight then
    return true
  end
  if not this.clickTime then
    this.clickTime = Time.GetServerTime()
  end
  local intervalTime = Time.GetServerTime() - this.clickTime
  this.clickTime = Time.GetServerTime()
  if intervalTime ~= 0 and intervalTime < 500 then
    return true
  else
    return false
  end
end
