Tip_HolyRingOpenUI = class(BaseUI)
Tip_HolyRingOpenUI.layer = UILayer.Tip
Tip_HolyRingOpenUI.orderInLayer = 7
Tip_HolyRingOpenUI.hideType = UIHideType.WaitDestroy
Tip_HolyRingOpenUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_HolyRingOpenUI.escClose = UIEscClose.DontClose

function Tip_HolyRingOpenUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.txtTitle = self:GetControl("img_Bg/txtTitle")
  self.btn_ok = self:GetControl("img_Bg/btn_ok")
  self.txt = self:GetControl("img_Bg/btn_ok/txt")
  self.mapOpen = self:GetControl("img_Bg/background/mapOpen")
  self.lockSkill = self:GetControl("img_Bg/background/lockSkill")
  self.lab_unlockskill = self:GetControl("img_Bg/background/lockSkill/lab_unlockskill")
  self.SkillContent = self:GetControl("img_Bg/background/lockSkill/SkillContent")
  self.temp_skillFrame = self:GetControl("img_Bg/background/lockSkill/SkillContent/temp_skillFrame")
  self.skillFeatures = self:GetControl("img_Bg/background/skillFeatures")
  self.lab_unlockequip = self:GetControl("img_Bg/background/skillFeatures/img_titleico/lab_unlockequip")
  self.go_model = self:GetControl("img_Bg/HolyRingLook/go_model")
  self.plane_left = self:GetControl("plane_left")
  self.plane_right = self:GetControl("plane_right")
end

function Tip_HolyRingOpenUI:Init()
end

function Tip_HolyRingOpenUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_HolyRingOpenUI:InitUI()
end

function Tip_HolyRingOpenUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_ok:SetOnClick(self, self.btn_okOnClick)
end

function Tip_HolyRingOpenUI:btn_closeBgOnClick(control)
  EventManager.Dispatch(Event.SystemOpenTipUIClose)
  UIManager.Hide(UIID.Tip_HolyRingOpenUI)
end

function Tip_HolyRingOpenUI:btn_okOnClick(control)
  self:btn_closeBgOnClick()
end

function Tip_HolyRingOpenUI:temp_skillFrameOnClick(control)
end

function Tip_HolyRingOpenUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_HolyRingOpenUI:RegistEvents()
end

function Tip_HolyRingOpenUI:Refresh()
  self:RefreshModel()
end

function Tip_HolyRingOpenUI:RefreshModel()
  local holyRingInfo = {}
  local count = ClientTable.cfg_Ring_levelManager:GetHolyRingHoleCount()
  for i = count, 1, -1 do
    local holyRing = {
      itemId = 15000111 - 10 * (count - i),
      point = i
    }
    table.insert(holyRingInfo, holyRing)
  end
  local viewRoleData = {}
  viewRoleData.equipsData = ViewData.meData.equipsData
  viewRoleData.career = ViewData.meData.career
  viewRoleData.modelType = EModelType.Charactor
  viewRoleData.model = 1003
  viewRoleData.id = ViewData.meData.id
  viewRoleData.roleName = ViewData.meData.name
  viewRoleData.serverCoord = Vector2Int()
  viewRoleData.roleType = ERoleType.Player
  viewRoleData.parent = self.go_model.transform
  viewRoleData.holyRingInfo = holyRingInfo
  viewRoleData.circleRotation = Vector3(-43, 0, 0)
  if self.lookRole then
    self.lookRole:Destroy()
    self.lookRole = ViewRole(viewRoleData)
  else
    self.lookRole = ViewRole(viewRoleData)
  end
  if self.lookRole then
    self.lookRole:SetRotation(0, 180, 0)
    self.lookRole:SetPosition(0, -135, 0)
  end
end

function Tip_HolyRingOpenUI:OnHide()
  self:ReleaseModel()
  EventManager.Dispatch(Event.PopAutoPopUI)
end

function Tip_HolyRingOpenUI:ReleaseModel()
  if self.lookRole then
    self.lookRole:Destroy()
    self.lookRole = nil
  end
end

function Tip_HolyRingOpenUI:OnDestroy()
end
