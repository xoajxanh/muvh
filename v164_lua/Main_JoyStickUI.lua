Main_JoyStickUI = class(BaseUI)
Main_JoyStickUI.layer = UILayer.Background
Main_JoyStickUI.orderInLayer = 0
Main_JoyStickUI.hideType = UIHideType.Hide
Main_JoyStickUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_JoyStickUI.escClose = UIEscClose.DontClose
Main_JoyStickUI.movingWithJoyStick = false
Main_JoyStickUI.holdingJoyStick = false

function Main_JoyStickUI:InitControls()
  self.Stick = self:GetControl("Stick")
  self.ZoomArea = self:GetControl("Stick/ZoomArea")
  self.StickBG = self:GetControl("Stick/StickBG")
  self.JoyStickBtn = self:GetControl("Stick/JoyStickBtn")
end

function Main_JoyStickUI:Init()
end

function Main_JoyStickUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local maxRandius = 70
local isFixedPosition = false
local isDrag = false

function Main_JoyStickUI:InitUI()
  if self.Stick then
    self.StickTrans = self.Stick.transform
  end
  if self.StickBG then
    self.StickBGTrans = self.StickBG.transform
  end
  if self.JoyStickBtn then
    self.JoyStickBtnTrans = self.JoyStickBtn.transform
  end
  if self.StickBG then
    self.StickBGImage = self.StickBG.image
  end
  if self.JoyStickBtn then
    self.JoyStickBtnImage = self.JoyStickBtn.image
  end
  if self.ZoomArea then
    self.ZoomAreaImage = self.ZoomArea.image
  end
  self:SetFixPosition(isFixedPosition)
end

local joyStickVisible = true

function Main_JoyStickUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  joyStickVisible = true
end

local backGroundPos, direction, distance, radius

function Main_JoyStickUI:Update()
  if LockScreenState then
    return
  end
  if not joyStickVisible then
    return
  end
  if RoleManager.me and RoleManager.me.buffCantMove then
    return
  end
  if Input.GetKey(KeyCode.W) or Input.GetKey(KeyCode.S) or Input.GetKey(KeyCode.A) or Input.GetKey(KeyCode.D) then
    direction = Vector2(0, 0)
    if Input.GetKey(KeyCode.W) then
      direction = direction + Vector2(0, 1)
    elseif Input.GetKey(KeyCode.S) then
      direction = direction + Vector2(0, -1)
    end
    if Input.GetKey(KeyCode.D) then
      direction = direction + Vector2(1, 0)
    elseif Input.GetKey(KeyCode.A) then
      direction = direction + Vector2(-1, 0)
    end
    distance = Vector2.Magnitude(direction)
    self.JoyStickBtnTrans.localPosition = direction.normalized * maxRandius
    self:SetAlphaScale(true)
    direction = Direction8Utility:GetJoyStickNormalOffset(direction.x, direction.y)
    self:MoveWithDirection()
    AutoTaskManage.SetCurRoleOperate(AutoTaskOperateType.JoyStick)
    return
  end
  if (Input.GetKeyUp(KeyCode.W) or Input.GetKeyUp(KeyCode.S) or Input.GetKeyUp(KeyCode.A) or Input.GetKeyUp(KeyCode.D)) and not Input.GetKey(KeyCode.W) and not Input.GetKey(KeyCode.S) and not Input.GetKey(KeyCode.A) and not Input.GetKey(KeyCode.D) then
    self:ResetStick()
  end
  self:MoveWithDirection()
end

local currentCell = Vector2()

function Main_JoyStickUI:MoveWithDirection()
  if direction == nil or direction == Vector2Int.zero then
    if Main_JoyStickUI.movingWithJoyStick then
      local roleCtr = RoleManager.me
      roleCtr:StopMove()
      Main_JoyStickUI.movingWithJoyStick = false
    end
    return
  end
  if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
    UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
  end
  local targetCell = RoleManager.me.cellPos + direction
  local targetCellIsBlock = Scene.IsBlock(targetCell)
  Main_JoyStickUI.movingWithJoyStick = not targetCellIsBlock
  RoleManager.me:MoveCloseAutoFight()
  RoleManager.me:LineMoveTo(targetCell, currentCell)
  EventManager.Dispatch(Event.CloseKillMonsterCard)
end

function Main_JoyStickUI:ResetCurrentCell(cell)
  currentCell:Set(cell.x, cell.y)
end

local function DragJoystick(self, eventData)
  Main_JoyStickUI.holdingJoyStick = true
  direction = Vector2(eventData.position.x - backGroundPos.x, eventData.position.y - backGroundPos.y)
  distance = Vector2.Magnitude(direction)
  radius = Mathf.Clamp(distance, 0, maxRandius)
  self.JoyStickBtnTrans.localPosition = direction.normalized * radius
  self:SetAlphaScale(true)
  direction = Direction8Utility:GetJoyStickNormalOffset(direction.x, direction.y)
end

function Main_JoyStickUI:DragEvent(control, eventData)
  if eventData == nil or eventData.pressEventCamera == nil then
    backGroundPos = self.StickBGTrans.position
  else
    backGroundPos = eventData.pressEventCamera:WorldToScreenPoint(self.StickBGTrans.position)
  end
  DragJoystick(self, eventData)
  AutoTaskManage.SetCurRoleOperate(AutoTaskOperateType.JoyStick)
end

function Main_JoyStickUI:ResetStick(control, eventData)
  Main_JoyStickUI.holdingJoyStick = false
  self.StickTrans.localPosition = Vector2.zero
  self.JoyStickBtnTrans.localPosition = Vector2.zero
  direction = nil
  self:SetAlphaScale(false)
end

local pointPos

function Main_JoyStickUI:JoyStickZoomDown(_, eventData)
  if GameSettingsData.joyStickMode == EJoyStickMode.Free then
    if eventData == nil or eventData.pressEventCamera == nil then
      pointPos = self.StickBGTrans.position
    else
      if eventData.position.z == nil then
        pointPos = Vector3(eventData.position.x, eventData.position.y, self.StickBGTrans.position.z)
      else
        pointPos = Vector3(eventData.position.x, eventData.position.y, eventData.position.z)
      end
      pointPos = eventData.pressEventCamera:ScreenToWorldPoint(pointPos)
    end
    self.StickTrans.position = pointPos
  else
    if eventData == nil or eventData.pressEventCamera == nil then
      backGroundPos = self.StickBGTrans.position
    else
      backGroundPos = eventData.pressEventCamera:WorldToScreenPoint(self.StickBGTrans.position)
    end
    DragJoystick(self, eventData)
  end
  self:SetAlphaScale(true)
end

function Main_JoyStickUI:SetFixPosition(fixPosition)
  if self.JoyStickBtnImage ~= nil then
    self.JoyStickBtnImage.raycastTarget = fixPosition
  end
  if self.StickBGImage ~= nil then
    self.StickBGImage.raycastTarget = fixPosition
  end
  if self.ZoomAreaImage ~= nil then
    self.ZoomAreaImage.raycastTarget = not fixPosition
  end
end

function Main_JoyStickUI:SetAlphaScale(isActive)
  if self.JoyStickBtnImage ~= nil and (self.JoyStickBtnImage.color.a ~= 1 and isActive or self.JoyStickBtnImage.color.a ~= 0.4 and not isActive) then
    if isActive then
      self.JoyStickBtnImage.color = Color(1, 1, 1, 1)
    else
      self.JoyStickBtnImage.color = Color(1, 1, 1, 0.4)
    end
  end
  if self.StickBGImage ~= nil and (self.StickBGImage.color.a ~= 1 and isActive or self.StickBGImage.color.a ~= 0.4 and not isActive) then
    if isActive then
      self.StickBGImage.color = Color(1, 1, 1, 1)
    else
      self.StickBGImage.color = Color(1, 1, 1, 0.4)
    end
  end
end

function Main_JoyStickUI:OnHide()
end

function Main_JoyStickUI:OnDestroy()
  self.JoyStickBtn = nil
  self.Stick = nil
  self.StickBG = nil
  self.ZoomArea = nil
  self.JoyStickBtnTrans = nil
  self.StickTrans = nil
  self.StickBGTrans = nil
  backGroundPos = nil
  backGroundPos = nil
  direction = nil
  distance = nil
  radius = nil
  pointPos = nil
end

function Main_JoyStickUI:RegistUIEvents()
  if self.JoyStickBtn then
    self.JoyStickBtn:SetOnDrag(self, self.DragEvent)
    self.JoyStickBtn:SetOnPointerUp(self, self.ResetStick)
  end
  if self.ZoomArea then
    self.ZoomArea:SetOnPointerDown(self, self.JoyStickZoomDown)
    self.ZoomArea:SetOnDrag(self, self.DragEvent)
    self.ZoomArea:SetOnPointerUp(self, self.ResetStick)
  end
  if self.StickBG then
    self.StickBG:SetOnPointerDown(self, self.DragEvent)
    self.StickBG:SetOnDrag(self, self.DragEvent)
    self.StickBG:SetOnPointerUp(self, self.ResetStick)
  end
end

function Main_JoyStickUI:RegistEvents()
  self:RegistEvent(Event.Logic_ActiveMainUI, self.OnActiveMainUI, self)
end

function Main_JoyStickUI:OnActiveMainUI(_, visible)
  joyStickVisible = visible
  self:ResetStick()
  self:MoveWithDirection()
end

function Main_JoyStickUI:Refresh()
end
