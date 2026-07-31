Tip_StrongerUI = class(BaseUI)
Tip_StrongerUI.layer = UILayer.Prompt
Tip_StrongerUI.orderInLayer = 0
Tip_StrongerUI.hideType = UIHideType.WaitDestroy
Tip_StrongerUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_StrongerUI.escClose = UIEscClose.Close

function Tip_StrongerUI:InitControls()
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Img_TipBg = self:GetControl("Panel_Tip/Img_TipBg")
  self.img_title = self:GetControl("Panel_Tip/Img_TipBg/img_title")
  self.sw_item = self:GetControl("Panel_Tip/Img_TipBg/sw_item")
  self.Content = self:GetControl("Panel_Tip/Img_TipBg/sw_item/Viewport/Content")
  self.icon_Stronger = self:GetControl("Panel_Tip/Img_TipBg/sw_item/Viewport/Content/icon_Stronger")
  self.tog_prompt = self:GetControl("Panel_Tip/Img_TipBg/tog_prompt")
  self.plane_left = self:GetControl("Panel_Tip/plane_left")
  self.plane_right = self:GetControl("Panel_Tip/plane_right")
  self.tipPool = self:GetControl("tipPool")
end

function Tip_StrongerUI:Init()
end

function Tip_StrongerUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_StrongerUI:InitUI()
  self.PromptListControl = UIUtility.BindUIContainerTemp(self.icon_Stronger, LuaComponentTemplates.SingleDeadStrengthenPromptTemplate, self)
end

function Tip_StrongerUI:RegistUIEvents()
  self.Panel_Tip:SetOnClick(self, self.Panel_TipOnClick)
end

function Tip_StrongerUI:Panel_TipOnClick(control)
  UIManager.Hide(UIID.Tip_StrongerUI)
end

function Tip_StrongerUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_StrongerUI:RegistEvents()
end

function Tip_StrongerUI:Refresh()
  local promptDataList = gameMgr:GetPromptDataManager():GetDeadStrengthenPromptDataManager():GetDeadStrengthenPromptDataList()
  self.PromptListControl:SetData(promptDataList)
  self:RefreshToggle()
end

function Tip_StrongerUI:RefreshToggle()
  if self.toggleTemplate == nil then
    self.toggleTemplate = luaTemplateManager.GetNewTemplate(self.tog_prompt, LuaComponentTemplates.Toggle_SingleToggleTemplate)
  end
  local inputData = {}
  inputData.name = "\196\144\196\131ng nh\225\186\173p kh\195\180ng nh\225\186\175c nh\225\187\159 n\225\187\175a"
  inputData.isOn = gameMgr:GetPromptDataManager():GetDeadStrengthenPromptDataManager():CanShowPrompt() == false
  
  function inputData.toggleCallback(inputdata, state)
    gameMgr:GetPromptDataManager():GetDeadStrengthenPromptDataManager().IsOn = not state
  end
  
  self.toggleTemplate:RefreshData(inputData)
end

function Tip_StrongerUI:OnHide()
end

function Tip_StrongerUI:OnDestroy()
end
