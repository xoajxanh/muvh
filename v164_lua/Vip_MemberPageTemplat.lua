local Vip_MemberPageTemplat = {}

function Vip_MemberPageTemplat:Init(data)
  self.goCallBack = data.goCallBack
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function Vip_MemberPageTemplat:InitParams()
  self.parentTbl = nil
end

function Vip_MemberPageTemplat:InitControls()
  self.bgLb = self:GetControl("Background/lb")
  self.cmLb = self:GetControl("Checkmark/lb")
  self.bgGo = self:GetControl("Background")
  self.cmGO = self:GetControl("Checkmark")
  self.redPoint = self:GetControl("img_redPoint")
  self.unactive = self:GetControl("unactive")
  self.unactive = self:GetControl("unactive")
  self.unactive_lb = self:GetControl("unactive/lb")
end

function Vip_MemberPageTemplat:BindUIEvent()
  self:UIControl():SetOnClick(self, self.ClickGoCallBack)
end

function Vip_MemberPageTemplat:ClickGoCallBack()
  if self.goCallBack then
    self.goCallBack(self.memberId, self.group)
  end
end

function Vip_MemberPageTemplat:Refresh(data, ui)
  self.parentTbl = ui
  self.memberId = data.id
  self.group = data.group
  self.go.name = data.name
  self.SpriteName = data.str
  self.IsLock = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetMemberSrcStateByGroup(self.group) == EMemberSrcState.Lock
  self.nowemberName = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetMemberStrByGroup(self.group)
  self.nowemberName = self.nowemberName .. "VIP"
  self:RefreshView()
  self:RefreshRedPointView()
  self:RefreshUnActive()
end

function Vip_MemberPageTemplat:RefreshView()
  local nowemberName = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetMemberStrByGroup(self.group)
  self.bgLb:SetText(nowemberName .. "VIP")
  self.cmLb:SetText(nowemberName .. "VIP")
end

function Vip_MemberPageTemplat:RefreshUnActive()
  self.unactive:SetActive(self.IsLock)
  self.unactive_lb:SetText(self.nowemberName)
end

function Vip_MemberPageTemplat:GetSpriteSuffix()
  if self.IsSelect or self.IsNotGet then
    return "2"
  end
  return "1"
end

function Vip_MemberPageTemplat:RefreshRedPointView()
  local isShow = false
  if gameMgr:GetAvatarManager() then
    isShow = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():IsShowRedPoint_Group(self.group)
  end
  if self.redPoint.gameObject.activeSelf ~= isShow then
    self.redPoint:SetActive(isShow)
  end
end

function Vip_MemberPageTemplat:RefreshToggleState(group)
  self.nowSelectGroup = group
  self.IsSelect = self.nowSelectGroup == self.group
  self.cmGO:SetActive(self.IsSelect)
  self:RefreshView()
end

return Vip_MemberPageTemplat
