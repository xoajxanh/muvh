local Vip_TaskMemberItemTemplate = {}

function Vip_TaskMemberItemTemplate:Init()
  self:InitControls()
end

function Vip_TaskMemberItemTemplate:InitControls()
  self.nowControl = self:UIControl()
  self.lab_level = self:GetControl("lab_level")
  self.lab_level_s = self:GetControl("lab_level_s")
  self.img_unactive = self:GetControl("img_unactive")
  self.img_choose = self:GetControl("img_choose")
  self.level_info = self:GetControl("level_info")
  self.lab_member = self:GetControl("level_info/lab_member")
  self.nowControl:SetOnClick(self, self.nowControlOnClick)
end

function Vip_TaskMemberItemTemplate:Refresh(memberData, ui)
  self.parentTbl = ui
  if memberData == nil then
    return
  end
  self.memberData = memberData
  self.starnum = self.memberData.starnum
  self.memberNowTable = self.memberData.nowTable
  local uiword = ClientTable.cfg_Ui_wordManager:TryGetValue("Newmember_name_txt_" .. self.memberData.vipLevel)
  if uiword ~= nil then
    self.lab_level:SetText(uiword.content)
  else
    self.lab_level:SetText("")
  end
  self.lab_level_s:SetText("\226\152\133" .. self.memberData.starnum)
  local curMemberStar = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetCurMemberStar()
  self.img_unactive:SetActive(curMemberStar < self.memberData.starnum)
  self.img_choose:SetActive(self.memberData.starnum == curMemberStar)
  self.level_info:SetActive(self.memberData.starnum == curMemberStar)
  local MemberTable = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetcurMemberTable()
  if MemberTable ~= nil then
    if self.starnum == 8 then
      self.lab_member.rectTransform.localPosition = Vector3(-25, 0, 0)
    end
    self.lab_member:SetText(MemberTable.tips2)
  end
end

function Vip_TaskMemberItemTemplate:nowControlOnClick()
  UIManager.Show(UIID.Tip_NewMemberTipsUI, {
    starnum = self.starnum,
    memberNowTable = self.memberNowTable
  })
end

return Vip_TaskMemberItemTemplate
