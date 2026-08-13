MainCamera = {}
local this = MainCamera
local MIN_DISTANCE = Vector2(4, 2.5)
local MAX_DISTANCE = Vector2(9.7, 8.42)
local MIN_ANGLE_X = 20
local MAX_ANGLE_X = 42
local INIT_ANGLE_Y = -45
local ROLE_FOV = 35
local DEFAULT_FOV = 60
local xDev = 1
local zDev = 1

function MainCamera.Init()
  this.initCamera = CS.UnityEngine.Camera.main
  this.SetCamera(this.initCamera)
  this.uac = this.initCamera:GetComponent(typeof(CS.UnityEngine.Rendering.Universal.UniversalAdditionalCameraData))
  this.animator = this.initCamera:GetComponent(typeof(CS.UnityEngine.Animator))
end

function MainCamera.SetCamera(camera)
  this.camera = camera or self.initCamera
  this.transform = this.camera.transform
  this.originalParent = this.transform.parent
  this.initCamera.gameObject:SetActive(this.camera == this.initCamera)
end

function MainCamera.AttachRole(role)
  if not this.camera or not role then
    return
  end
  xDev = 1
  zDev = 1
  this.target = role.transform
  this.transform:SetParent(this.target, false)
  this.zoom = 1
  this.angle = INIT_ANGLE_Y
  this.toZoom = this.zoom
  this.toAngle = this.angle
  this.camera.fieldOfView = ROLE_FOV
  this.RefreshPosition()
end

function MainCamera.Detach()
  this.transform:SetParent(this.parent, false)
  this.target = nil
end

function MainCamera.LoginAnimal()
  do return end
  this.transform:DOMove(Vector3(0, 1, -10.2), 1):SetEase(Ease.OutQuart):OnComplete(function()
    this.transform:DOMove(Vector3(0, 1, -10.8), 8)
  end)
end

function MainCamera.LoginRoleCameraSet()
  EventManager.Dispatch(Event.Scene_HideLoading)
  this.transform:DOKill()
  this.camera.fieldOfView = DEFAULT_FOV
  this.transform:SetLocalPosition(0, 1, -10)
  this.transform:SetLocalEulerAngles(0, 0, 0)
end

function MainCamera.LoginCameraSet()
  this.transform:SetLocalPosition(50, 4, 190)
  this.transform:SetLocalEulerAngles(10, 0, 0)
end

function MainCamera.Reset()
  this.zoom = 1
  this.angle = INIT_ANGLE_Y
  this.camera.fieldOfView = this.target and ROLE_FOV or DEFAULT_FOV
end

function MainCamera.RefreshPosition()
  this.zoom = this.zoom or 1
  local distance = Vector2.LerpUnclamped(MIN_DISTANCE, MAX_DISTANCE, this.zoom)
  local angleX = Mathf.LerpUnclamped(MIN_ANGLE_X, MAX_ANGLE_X, this.zoom)
  this.transform:SetLocalEulerAngles(angleX, this.angle, 0)
  this.angle = this.angle or INIT_ANGLE_Y
  local rad = math.rad(this.angle)
  local x = -distance.x * math.sin(rad) * xDev
  local z = -distance.x * math.cos(rad) * zDev
  this.transform:SetLocalPosition(x, distance.y, z)
end

function MainCamera.SetCameraDev(dev)
  xDev = dev.x
  zDev = dev.y
end

local MOUSE_SCROLL_WHEEL_ID = StringPool.ToID("Mouse ScrollWheel")
local Input = CS.UnityEngine.Input
local InputEx = CS.Framework.InputEx
local KeyCode = CS.UnityEngine.KeyCode
local DAMPING = 5

function MainCamera.LateUpdate()
  if IsNil(this.camera) then
    this.SetCamera(this.initCamera)
  end
  if not this.target then
    return
  end
  local delta = InputEx.GetAxis(MOUSE_SCROLL_WHEEL_ID)
  if delta ~= 0 then
    this.toZoom = this.toZoom - delta
  end
  if this.finger1 then
    local touch1, x1, y1 = InputEx.GetTouchPosition(this.finger1)
    local touch2, x2, y2 = InputEx.GetTouchPosition(this.finger2)
    if touch1 and touch2 then
      local dx = x2 - x1
      local dy = y2 - y1
      local d = math.sqrt(dx * dx + dy * dy)
      if Mathf.Abs(d) < Mathf.Epsilon then
        this.toZoom = this.toZoom - (d - this.fingerDistance) / 100
        this.fingerDistance = d
      end
    else
      this.finger1 = nil
    end
  elseif Input.touchCount == 2 then
    this.finger1 = Input.GetTouch(0)
    local _, x1, y1 = InputEx.GetTouchPosition(this.finger1)
    this.finger2 = Input.GetTouch(1)
    local _, x2, y2 = InputEx.GetTouchPosition(this.finger2)
    local dx = x2 - x1
    local dy = y2 - y1
    this.fingerDistance = math.sqrt(dx * dx + dy * dy)
  end
  if Input.GetKey(KeyCode.Z) then
    this.toZoom = this.toZoom - 0.01
  end
  if Input.GetKey(KeyCode.C) then
    this.toZoom = this.toZoom + 0.01
  end
  if Input.GetKey(KeyCode.Q) then
    this.toAngle = this.toAngle - 1
  end
  if Input.GetKey(KeyCode.E) then
    this.toAngle = this.toAngle + 1
  end
  this.toZoom = Mathf.Clamp01(this.toZoom)
  if this.zoom ~= this.toZoom or this.angle ~= this.toAngle then
    local t = Time.deltaTime * DAMPING
    this.zoom = Mathf.Lerp(this.zoom, this.toZoom, t)
    this.angle = Mathf.Lerp(this.angle, this.toAngle, t)
  end
end

function MainCamera.GetAngle()
  return INIT_ANGLE_Y
end

function MainCamera:SetLoginAnimatorActive(isActive)
  if this.animator ~= nil then
    this.animator.enabled = isActive
  end
end
