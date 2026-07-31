local SayCommandListTemplate = {}

function SayCommandListTemplate:Init()
  self:InitComponent()
  self:InitTime()
end

local function OnSayBgCreat(ctr)
  ctr.Label_say = UIControl(ctr.transform, "Label_say")
end

local function OnSayBgRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  ctr.Label_say:SetText(data.contentServer)
  ctr.infoId = data.info
  ctr:SetOnClick(ui, ui.OnClickBtn_say)
end

function SayCommandListTemplate:InitComponent()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.saybg = self:GetControl("ScrollView/Viewport/Content/saybg")
  self.saybgContainer = UIContainer(self.saybg, self, OnSayBgCreat, OnSayBgRefresh)
  self.btn_closeBg:SetOnClick(self, self.OnClickBtnCloseBg)
end

function SayCommandListTemplate:OnClickBtnCloseBg(control)
  self.go:SetActive(false)
end

SayCommandListTemplate.IsRefresh = false

function SayCommandListTemplate:Refresh(data)
  if self.IsRefresh then
    return
  end
  self.saybgContainer:SetData(ClientTable.cfg_PVP_3v3_InfoManager:GetDic())
  self.IsRefresh = true
end

function SayCommandListTemplate:Update()
end

function SayCommandListTemplate:InitTime()
  self.cdTime = ClientTable.cfg_Activity_globalManager:GetSayCommandTime()
end

SayCommandListTemplate.cdTime = 0
SayCommandListTemplate.lastClickTime = 0

function SayCommandListTemplate:OnClickBtn_say(control)
  if self.lastClickTime + self.cdTime > Time.GetServerTime() then
    FloatingTipUtility.QuickMsg("Kho\225\186\163ng c\195\161ch gi\225\187\175a hai l\225\186\167n ph\195\161t ng\195\180n qu\195\161 ng\225\186\175n")
    self.go:SetActive(false)
    return
  end
  if control.infoId then
    networkRequest.ReqPVPAnnounce(1, control.infoId)
  end
  self.lastClickTime = Time.GetServerTime()
  self.go:SetActive(false)
end

function SayCommandListTemplate:Destroy()
  self.cdTime = 0
  self.lastClickTime = 0
  self.IsRefresh = false
end

return SayCommandListTemplate
