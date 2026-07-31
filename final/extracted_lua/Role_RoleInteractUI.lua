Role_RoleInteractUI = class(BaseUI)
Role_RoleInteractUI.layer = UILayer.Tip
Role_RoleInteractUI.orderInLayer = 3
Role_RoleInteractUI.hideType = UIHideType.WaitDestroy
Role_RoleInteractUI.hideFunc = UIHideFunc.MoveOutOfScreen
Role_RoleInteractUI.escClose = UIEscClose.DontClose

function Role_RoleInteractUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.sp_playerPanelBg = self:GetControl("sp_playerPanelBg")
  self.go_playLils = self:GetControl("sp_playerPanelBg/go_playLils")
  self.img_bg = self:GetControl("sp_playerPanelBg/go_playLils/img_bg")
  self.img_base_bg = self:GetControl("sp_playerPanelBg/go_playLils/img_bg/img_base_bg")
  self.img_Bg_bg = self:GetControl("sp_playerPanelBg/go_playLils/img_Bg_bg")
  self.img_headPortrait = self:GetControl("sp_playerPanelBg/go_playLils/img_headPortrait")
  self.lab_name = self:GetControl("sp_playerPanelBg/go_playLils/lab_name")
  self.levelTitle = self:GetControl("sp_playerPanelBg/go_playLils/levelTitle")
  self.lab_level = self:GetControl("sp_playerPanelBg/go_playLils/lab_level")
  self.lab_warAlliance = self:GetControl("sp_playerPanelBg/go_playLils/lab_warAlliance")
  self.lab_occupation = self:GetControl("sp_playerPanelBg/go_playLils/lab_occupation")
  self.lab_fightNum = self:GetControl("sp_playerPanelBg/go_playLils/lab_fightNum")
  self.Content = self:GetControl("sp_playerPanelBg/sv_btns/Viewport/Content")
  self.Button = self:GetControl("sp_playerPanelBg/sv_btns/Viewport/Content/Button")
end

function Role_RoleInteractUI:OnPreLoad()
end

function Role_RoleInteractUI:Init()
end

function Role_RoleInteractUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Role_RoleInteractUI:InitUI()
  local transform = self.root.transform
  local x, y = transform:GetAnchoredPosition()
  transform.anchoredPosition3D = Vector3.New(x, y, -1000)
  self.levelPosition = self.levelTitle.transform.localPosition
  self.carrerPosition = self.lab_occupation.transform.localPosition
  self:InitTeamContent()
end

function Role_RoleInteractUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:ShowRoleClickBtns(self.args)
end

function Role_RoleInteractUI:ShowRoleClickBtns()
  if self.args then
    local checkPlayerList = ShowBtnItemUtility.GetConditionBtns(self.args)
    self:RefreshBtnInfo(checkPlayerList)
  end
end

local function InitBtnInfo(ctr)
  ctr.name = UIControl(ctr.transform, "name")
  ctr:SetOnClick(ctr, function()
    ShowBtnItemUtility.OperateType(ctr.btncon.callbackFunc)
  end)
end

local function RefushBtnInfo(ctr, _, btncon, ui)
  ctr.name:SetText(btncon.name)
  ctr.btncon = btncon
end

function Role_RoleInteractUI:InitTeamContent()
  self.btnTemp = UIContainer(self.Button, self, InitBtnInfo, RefushBtnInfo)
end

function Role_RoleInteractUI:RefreshBtnInfo(data)
  self.btnTemp:SetData(data)
  local count = #data % 2 == 0 and #data / 2 or (#data + 1) / 2
  local h = count * 59 + count * 10 + 122 + 25
  local y
  if 8 < #data then
    y = -70 - (h - 406) / 1.94
  else
    y = -70 + (406 - h) / 1.94
  end
  local w, h1 = self.img_Bg_bg:GetSizeDelta()
  local x = self.img_bg:GetAnchoredPosition()
  self.img_bg:SetAnchoredPosition(x, y)
  self.img_Bg_bg:SetAnchoredPosition(x, y)
  self.img_base_bg:SetSizeDelta(w - 6, h - 10)
  self.img_bg:SetSizeDelta(w - 6, h - 10)
  self.img_Bg_bg:SetSizeDelta(w, h)
end

function Role_RoleInteractUI:OnHide()
end

function Role_RoleInteractUI:OnDestroy()
end

function Role_RoleInteractUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closePanel)
end

function Role_RoleInteractUI:btn_closePanel()
  TeamData.CleanInvitateRole()
  UIManager.Hide(UIID.Team_RoleInteractUI)
end

function Role_RoleInteractUI:RegistEvents()
end

function Role_RoleInteractUI:Refresh()
  if self.args and self.args.roleId then
    networkRequest.ReqOtherRoleInfo(0, 0, self.args.roleId, self.args.serverId or 0)
  end
  self:InitBasicPlayerInfo()
end

function Role_RoleInteractUI:InitBasicPlayerInfo()
  self.lab_name:SetText(self.args.roleName)
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(self.args.career, "id")
  if spriteName then
    self:SetSprite("Atlas_headPortrait", spriteName.headPortrait, self.img_headPortrait)
  end
  local member = ClientTable.cfg_union_memberManager:TryGetValue(self.args.unionPosition, "id")
  self.lab_warAlliance:SetText(string.format("%s  %s", self.args.unionName, member and member.desc or ""))
  local fightNum = string.format("<color=#CEB6A1>L\225\187\177c Chi\225\186\191n: </color><color=#3CD937>%s</color>", self.args.fightValue)
  self.lab_fightNum:SetText(fightNum)
  self.lab_occupation:SetText(RoleUtility.GteCareerNameByType(self.args.career))
  if self.args.interactType ~= nil and self.args.interactType == RoleOpenType.RankOpen then
    self.levelTitle:SetActive(false)
    self.lab_level:SetActive(false)
    self.lab_occupation.transform.localPosition = self.levelPosition
    self.lab_level:SetText(UIUtility.GetLevlDes(self.args.level))
  else
    self.levelTitle:SetActive(true)
    self.lab_level:SetActive(true)
    self.lab_occupation.transform.localPosition = self.carrerPosition
    self.lab_level:SetText(UIUtility.GetLevlDes(self.args.level))
  end
end
