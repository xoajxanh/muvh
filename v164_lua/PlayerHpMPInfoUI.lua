PlayerHpMPInfoUI = class(BaseUI)
PlayerHpMPInfoUI.layer = UILayer.Background
PlayerHpMPInfoUI.orderInLayer = 0
PlayerHpMPInfoUI.hideType = UIHideType.WaitDestroy
PlayerHpMPInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
PlayerHpMPInfoUI.escClose = UIEscClose.DontClose

function PlayerHpMPInfoUI:InitControls()
  self.HPValue = self:GetControl("bg_Hpbar/HPValue")
  self.lab_hp = self:GetControl("bg_Hpbar/lab_hp")
  self.MPValue = self:GetControl("bg_Mpbar/MPValue")
  self.bg_Frame = self:GetControl("bg_Frame")
  self.bg_FrameIcon = self:GetControl("bg_Frame/bg_FrameIcon")
  self.lab_Name = self:GetControl("lab_Type/lab_Name")
  self.lab_Lv = self:GetControl("lab_Type/lab_Lv")
  self.btn_close = self:GetControl("btn_close")
end

function PlayerHpMPInfoUI:OnPreLoad()
end

function PlayerHpMPInfoUI:Init()
end

function PlayerHpMPInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function PlayerHpMPInfoUI:InitUI()
end

function PlayerHpMPInfoUI:OnShow()
  self:RegistEvents()
  RoleInteractData.PlayerHpMPRepelBossHp()
  EventManager.Dispatch(Event.BossHpUI_ShowHide, true)
  self:Refresh()
end

function PlayerHpMPInfoUI:OnHide()
  RoleInteractData.HpMPUIPlayerid = nil
end

function PlayerHpMPInfoUI:OnDestroy()
  RoleInteractData.HpMPUIPlayerid = nil
end

function PlayerHpMPInfoUI:RegistUIEvents()
  self.bg_Frame:SetOnClick(self, self.bg_FrameOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function PlayerHpMPInfoUI:bg_FrameOnClick(control)
  if ClientTable.cfg_Global_globalManager:CheckHideReinEffectByCurMapId() then
    return
  end
  RoleInteractData.roleId = self.args.roleId
  RoleInteractData.serverId = self.args.serverId
  RoleInteractData.roleName = self.args.roleName
  RoleInteractData.unionId = self.args.unionId
  RoleInteractData.career = self.args.career
  RoleInteractData.unionName = self.args.unionName
  RoleInteractData.unionPosition = self.args.unionPosition
  RoleInteractData.fight = self.args.fight
  RoleInteractData.level = self.args.level
  RoleInteractData.interactType = self.args.interactType
  NetManager.Send(RoleMessage.ReqTeamEquipsInfo, {
    roleId = self.args.roleId,
    hostId = self.args.hostId
  })
end

function PlayerHpMPInfoUI:btn_closeOnClick()
  if RoleManager.me.TargetAvatar then
    RoleManager.me:CloseTarget()
  end
  UIManager.Hide(UIID.PlayerHpMPInfoUI)
end

function PlayerHpMPInfoUI:RegistEvents()
  self:RegistEvent(Event.Role_RefreshHp, self.OnRole_HPChanged, self)
  self:RegistEvent(Event.Map_RemoveMon, self.RoleExitView, self)
  self:RegistEvent(Event.Main_UpdateMainUIShrink, self.Main_UpdateMainUIShrink, self)
  self:RegistEvent(Event.Map_ChangeMap, self.Map_ChangeMap, self)
  self:RegistEvent(Event.PKModeChanged, self.OnPKModeChanged, self)
  self:RegistEvent(Event.Role_OnRefreshRoleData, self.RefreshMonsterData, self)
end

function PlayerHpMPInfoUI:OnRole_HPChanged(_, data)
  if data.roleId == self.args.roleId then
    local role = RoleManager.GetRoleById(data.roleId)
    if not role then
      return
    end
    local hp = data.newValue / role.data.maxHp
    if 1 < hp then
      hp = 1
    end
    local hptext = math.ceil(hp * 100)
    hptext = hp == 0 and 0 or hptext == 0 and 1 or hptext
    hptext = hptext .. "%"
    self.lab_hp:SetText(hptext)
    self.HPValue:SetFillAmount(hp)
  end
end

function PlayerHpMPInfoUI:Role_RefreshMpChanged(_, data)
  if data.id == self.args.roleId then
    local Mp = data.newMp / self.args.maxMp
    self.MPValue:SetFillAmount(Mp)
  end
end

function PlayerHpMPInfoUI:RoleExitView(_, id)
  if id == nil then
    logError("\196\144\195\162y l\195\160 th\195\180ng b\195\161o id l\195\160 nil")
    return
  end
  if id == self.args.roleId then
    UIManager.Hide(UIID.PlayerHpMPInfoUI)
  end
end

function PlayerHpMPInfoUI:Main_UpdateMainUIShrink(_, bool)
  if bool then
    UIManager.Hide(UIID.PlayerHpMPInfoUI)
  end
end

function PlayerHpMPInfoUI:Map_ChangeMap(_, data)
  if self.ShowmapId ~= data.mapId then
    UIManager.Hide(UIID.PlayerHpMPInfoUI)
  end
end

function PlayerHpMPInfoUI:OnPKModeChanged()
  self.lab_Name:SetText(self:GetName())
  self:SetImageColor()
end

function PlayerHpMPInfoUI:GetName()
  local nameColor = RoleUtility.ModelRoleNameColor(self.args.roleId)
  local rolename = ""
  if not string.isNullOrEmpty(TranScriptData.GetInDuplicateNameStr()) then
    rolename = string.format("<color=%s>%s</color>", nameColor, TranScriptData.GetInDuplicateNameStr())
  elseif not string.isNullOrEmpty(self.args.unionName) then
    rolename = string.format("<color=#e6e600>[%s]</color>%s", self.args.unionName, self.args.roleName)
  else
    rolename = string.format("<color=%s>%s</color>", nameColor, self.args.roleName)
  end
  return rolename
end

function PlayerHpMPInfoUI:RefreshMonsterData(_, data)
  if data.id == self.args.roleId then
    self:OnPKModeChanged()
  end
end

function PlayerHpMPInfoUI:SetImageColor()
  local ownerInfo = RoleManager.GetRoleById(self.args.roleId)
  if RoleUtility.TargetIsFitMyPkMode(ownerInfo) then
    self.HPValue.image.color = Color(0.7607843, 0.09019608, 0.09019608)
  else
    self.HPValue.image.color = Color(0.1647059, 0.7647059, 0.1647059)
  end
end

function PlayerHpMPInfoUI:Refresh()
  self.ShowmapId = SceneData.mapId
  self:OnPKModeChanged()
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(self.args.career, "id").headPortrait
  self:SetSprite("Atlas_headPortrait", spriteName, self.bg_FrameIcon)
  if TranScriptData:IsHideLevel() then
    self.lab_Lv:SetText("")
  else
    local level = string.format("C\225\186\165p: %s", UIUtility.GetLevlDes(self.args.level))
    self.lab_Lv:SetText(level)
  end
  local hp = self.args.hp / self.args.maxHp
  local hptext = math.ceil(hp * 100)
  hptext = hp == 0 and 0 or hptext == 0 and 1 or hptext
  hptext = hptext .. "%"
  self.lab_hp:SetText(hptext)
  self.HPValue:SetFillAmount(hp)
  local Mp = self.args.mp / self.args.maxMp
  self.MPValue:SetFillAmount(Mp)
end
