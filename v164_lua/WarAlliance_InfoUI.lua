WarAlliance_InfoUI = class(BaseUI)
WarAlliance_InfoUI.layer = UILayer.Panel
WarAlliance_InfoUI.orderInLayer = 2
WarAlliance_InfoUI.hideType = UIHideType.Destroy
WarAlliance_InfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_InfoUI.escClose = UIEscClose.DontClose

function WarAlliance_InfoUI:InitControls()
  self.panel_left = self:GetControl("panel_left")
  self.bg_frame = self:GetControl("panel_left/bg_frame")
  self.CloseBtn = self:GetControl("panel_left/bg_frame/CloseBtn")
  self.WarAllianceInfo = self:GetControl("panel_left/WarAllianceInfo")
  self.MyWarAllianceName = self:GetControl("panel_left/WarAllianceInfo/MyWarAllianceName")
  self.lab_WarAlliancePeopleNum = self:GetControl("panel_left/WarAllianceInfo/WarAlliancePeopleNum/lab_WarAlliancePeopleNum")
  self.lab_leaderName = self:GetControl("panel_left/WarAllianceInfo/WarAllianceLeader/lab_leaderName")
  self.lab_WarAllianceLevel = self:GetControl("panel_left/WarAllianceInfo/WarAllianceLevel/lab_WarAllianceLevel")
  self.lab_Notice = self:GetControl("panel_left/WarAllianceInfo/Notice/lab_Notice")
  self.GradArmbandsItem = self:GetControl("panel_left/WarAllianceInfo/flag/GradArmbandsShow/Viewport/Content/GradArmbandsItem")
end

function WarAlliance_InfoUI:OnPreLoad()
end

function WarAlliance_InfoUI:Init()
end

function WarAlliance_InfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_InfoUI:InitUI()
  self:InitContent()
end

function WarAlliance_InfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_InfoUI:OnHide()
end

function WarAlliance_InfoUI:OnDestroy()
end

function WarAlliance_InfoUI:RegistUIEvents()
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
end

function WarAlliance_InfoUI:CloseBtnOnClick(control)
  UIManager.Hide(UIID.WarAlliance_List)
  UIManager.Hide(UIID.WarAlliance_Rank)
end

function WarAlliance_InfoUI:InitContent()
  self.GradArmbandsItemTemp = UIContainer(self.GradArmbandsItem)
end

function WarAlliance_InfoUI:RegistEvents()
  self:RegistEvent(Event.WarAlliance_SimpleInfo, self.WarAlliance_SimpleInfo, self)
end

function WarAlliance_InfoUI:Refresh()
end

function WarAlliance_InfoUI:WarAlliance_SimpleInfo(id, msg)
  self.SimpleInfo = msg
  local data = msg
  local level = data.level
  local UnionItem = ClientTable.cfg_union_unionLevelManager:TryGetValue(level)
  local MemberCount = tostring(data.count .. "/" .. UnionItem.unionMax)
  self.MyWarAllianceName:SetText(data.name)
  self.lab_WarAlliancePeopleNum:SetText(MemberCount)
  self.lab_WarAllianceLevel:SetText(level)
  self.lab_leaderName:SetText(data.leaderName == "" and "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i" or data.leaderName)
  self.lab_Notice:SetText(data.announce)
  self.GradArmbandsItemTemp:SetActiveTable()
  if data.logo ~= nil then
    for i = 1, WarAllianceData.ArmbandsDesignGridNum do
      local obj = self.GradArmbandsItemTemp:GetOrCreateItem(i)
      obj:SetActive(true)
      if data.logo[i] == 0 then
        local isActive = true
        obj.gameObject:GetComponent(typeof(UnityEngineUI.Image)).enabled = not isActive
      else
        obj:SetColor(data.logo[i])
        obj.gameObject:GetComponent(typeof(UnityEngineUI.Image)).enabled = true
      end
    end
  end
end
