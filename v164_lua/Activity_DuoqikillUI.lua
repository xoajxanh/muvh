Activity_DuoqikillUI = class(BaseUI)
Activity_DuoqikillUI.layer = UILayer.Tip
Activity_DuoqikillUI.orderInLayer = 0
Activity_DuoqikillUI.hideType = UIHideType.WaitDestroy
Activity_DuoqikillUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_DuoqikillUI.escClose = UIEscClose.DontClose

function Activity_DuoqikillUI:InitControls()
  self.txt_left = self:GetControl("img_sportBg/lab_kill/lab_routine1")
  self.txt_right = self:GetControl("img_sportBg/lab_kill/img_double_slash/txt_double_slash")
  self.obj_EffBg = self:GetControl("img_sportBg/Eff_ui_beijing")
  self.obj_EffFire = self:GetControl("img_sportBg/lab_kill/Eff_ui_huoyanxiaoguo")
  self.img_kill = self:GetControl("img_sportBg/lab_kill/img_double_slash")
end

function Activity_DuoqikillUI:Init()
end

function Activity_DuoqikillUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_DuoqikillUI:InitUI()
end

function Activity_DuoqikillUI:RegistUIEvents()
end

function Activity_DuoqikillUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_DuoqikillUI:RegistEvents()
  self:RegistEvent(Event.RefreshUnionKillAnnounce, self.Refresh, self)
end

function Activity_DuoqikillUI:Refresh()
  if self.args == nil then
    UIManager.Hide(UIID.Activity_DuoqikillUI)
    return
  end
  local data = self.args
  if data.chatCfg.id == nil then
    return
  end
  if data.msg.parameter == nil or data.msg.parameter[1] == nil or data.msg.parameter[2] == nil or data.msg.parameter[3] == nil then
    return
  end
  if data.chatCfg.id ~= 1020614 and data.chatCfg.id ~= 1020623 and data.chatCfg.id ~= 1020624 then
    local killNum = data.msg.parameter[3]
    local killArtStr = QuickFind:GetDuoQiCrossDataManager():GetKillArtFont()
    if killNum == nil or string.isNullOrEmpty(killArtStr) then
      return
    end
    local showStr = string.format(data.chatCfg.remarksUI, data.msg.parameter[1], data.msg.parameter[2])
    self.txt_left:SetText(showStr)
    local showKillNumStr = string.format(killArtStr, killNum)
    self.txt_right:SetText(showKillNumStr)
    self.img_kill:SetActive(true)
    self.obj_EffFire:SetActive(false)
    self.obj_EffFire:SetActive(true)
  else
    local showStr = string.format(data.chatCfg.systemChat, data.msg.parameter[1], data.msg.parameter[2], data.msg.parameter[3])
    self.txt_left:SetText(showStr)
    self.img_kill:SetActive(false)
    self.obj_EffFire:SetActive(false)
  end
  self.obj_EffBg:SetActive(false)
  self.obj_EffBg:SetActive(true)
end

function Activity_DuoqikillUI:OnHide()
end

function Activity_DuoqikillUI:OnDestroy()
end
