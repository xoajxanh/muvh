local WarAllianceRedEnvelopeTemplate = {}

function WarAllianceRedEnvelopeTemplate:Init()
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function WarAllianceRedEnvelopeTemplate:InitControls()
  self.OffRedBag = self:GetControl("OffRedBag")
  self.btn_UnOpen = self:GetControl("OffRedBag/img_UnOpenBg")
  self.lab_OffUseName = self:GetControl("OffRedBag/lab_UseName")
  self.OnRedBag = self:GetControl("OnRedBag")
  self.lab_OnUseName = self:GetControl("OnRedBag/lab_UseName")
  self.lab_moneyNum = self:GetControl("OnRedBag/lab_moneyNum")
  self.btn_Thanks = self:GetControl("OnRedBag/btn_Thanks")
  self.lab_name = self:GetControl("OnRedBag/sw_RedBag_getName/Viewport/Content/lab_name")
  self.NoRedBag = self:GetControl("NoRedBag")
end

local function LabNameItemRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  ctr:SetText(string.format("<color=#ffe398>%s</color> <color=#ebdcb2>\196\145\195\163 gi\195\160nh \196\145\198\176\225\187\163c</color><color=#ff4e4e>%s KC</color>", data.roleName, data.rewardCount))
end

function WarAllianceRedEnvelopeTemplate:InitUI()
  self.lab_nameContainer = UIContainer(self.lab_name, self, nil, LabNameItemRefresh)
end

function WarAllianceRedEnvelopeTemplate:BindUIEvent()
  self.btn_UnOpen:SetOnClick(self, self.btn_UnOpenOnClick)
  self.btn_Thanks:SetOnClick(self, self.btn_ThanksOnClick)
end

function WarAllianceRedEnvelopeTemplate:btn_UnOpenOnClick()
  networkRequest.ReqAwardRedPacket(self.data.id)
end

function WarAllianceRedEnvelopeTemplate:btn_ThanksOnClick()
  networkRequest.ReqThank(self.data.id)
end

function WarAllianceRedEnvelopeTemplate:Refresh(data, ui)
  if data == nil then
    self:GetControl():SetActive(false)
    return
  end
  self.data = data
  self.parent = ui
  self:InitializeDisplay()
  self:RefreshStatus()
end

function WarAllianceRedEnvelopeTemplate:InitializeDisplay()
  self.OffRedBag:SetActive(false)
  self.OnRedBag:SetActive(false)
  self.NoRedBag:SetActive(false)
end

function WarAllianceRedEnvelopeTemplate:RefreshStatus()
  if self.data.lastCount == 0 then
    self.NoRedBag:SetActive(true)
  elseif self.data.receiveState then
    self.OnRedBag:SetActive(true)
    self.lab_nameContainer:SetData(self.data.info)
    self.lab_OnUseName:SetText(self.data.masterName)
    self.lab_moneyNum:SetText(string.format("<color=#ffe398>Ch\195\186c m\225\187\171ng b\225\186\161n \196\145\195\163 gi\195\160nh \196\145\198\176\225\187\163c </color><color=#ff4e4e>%s KC</color>", self.data.rewardCount))
    self.btn_Thanks:SetActive(not self.data.thankState)
  else
    self.OffRedBag:SetActive(true)
    self.lab_OffUseName:SetText(self.data.masterName)
  end
end

return WarAllianceRedEnvelopeTemplate
