Tip_HolyBoneOpenUI = class(BaseUI)
Tip_HolyBoneOpenUI.layer = UILayer.Tip
Tip_HolyBoneOpenUI.orderInLayer = 7
Tip_HolyBoneOpenUI.hideType = UIHideType.WaitDestroy
Tip_HolyBoneOpenUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_HolyBoneOpenUI.escClose = UIEscClose.DontClose

function Tip_HolyBoneOpenUI:InitControls()
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

function Tip_HolyBoneOpenUI:Init()
end

function Tip_HolyBoneOpenUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_HolyBoneOpenUI:InitUI()
  self:InitData()
end

function Tip_HolyBoneOpenUI:InitData()
  self.modelInfo = {}
  local temp = ClientTable.cfg_Global_globalManager:TryGetValue(30)
  if temp and temp.effect then
    self.modelInfo = string.split(temp.effect, "#")
  end
end

function Tip_HolyBoneOpenUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_ok:SetOnClick(self, self.btn_okOnClick)
end

function Tip_HolyBoneOpenUI:btn_closeBgOnClick(control)
  EventManager.Dispatch(Event.SystemOpenTipUIClose)
  UIManager.Hide(UIID.Tip_HolyBoneOpenUI)
end

function Tip_HolyBoneOpenUI:btn_okOnClick(control)
  self:btn_closeBgOnClick()
end

function Tip_HolyBoneOpenUI:temp_skillFrameOnClick(control)
end

function Tip_HolyBoneOpenUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_HolyBoneOpenUI:RegistEvents()
end

function Tip_HolyBoneOpenUI:Refresh()
  self:RefreshModel()
end

function Tip_HolyBoneOpenUI:RefreshModel()
  local buffs = self.modelInfo[1] and {
    tonumber(self.modelInfo[1])
  } or nil
  local position = self.modelInfo[2] and string.split(self.modelInfo[2], "|") or nil
  local scale = self.modelInfo[3] and tonumber(self.modelInfo[3]) or nil
  local rotation = self.modelInfo[4] and string.split(self.modelInfo[4], "|") or nil
  local animationSpeed = self.modelInfo[5]
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
  viewRoleData.animationName = "idle"
  if self.lookRole then
    self.lookRole:Destroy()
    if type(self.buffEffectLids) then
      gameMgr:GetEffectManager():GetBuffEffectProcessor():RemoveEffects(self.buffEffectLids)
    end
    self.lookRole = ViewRole(viewRoleData)
  else
    self.lookRole = ViewRole(viewRoleData)
  end
  if self.lookRole then
    if position and 3 <= #position then
      self.lookRole:SetPosition(position[1], position[2], position[3])
    end
    if rotation and 3 <= #rotation then
      self.lookRole:SetRotation(rotation[1], rotation[2], rotation[3])
    end
    if scale then
      self.lookRole.transform.localScale = Vector3(scale, scale, scale)
    end
    self.lookRole:SetBuffAnchorDepth(-2)
    if buffs ~= nil then
      self.buffEffectLids = gameMgr:GetEffectManager():GetBuffEffectProcessor():AddEffects(buffs, self.lookRole.model.BuffAnchor)
    end
  end
end

function Tip_HolyBoneOpenUI:OnHide()
  self:ReleaseModel()
  EventManager.Dispatch(Event.PopAutoPopUI)
end

function Tip_HolyBoneOpenUI:ReleaseModel()
  if self.lookRole ~= nil then
    self.lookRole:Destroy()
    if type(self.buffEffectLids) then
      gameMgr:GetEffectManager():GetBuffEffectProcessor():RemoveEffects(self.buffEffectLids)
    end
    self.lookRole = nil
  end
end

function Tip_HolyBoneOpenUI:OnDestroy()
end
