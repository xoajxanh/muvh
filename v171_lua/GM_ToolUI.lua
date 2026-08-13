GM_ToolUI = class(BaseUI)
GM_ToolUI.layer = UILayer.Tooltip
GM_ToolUI.orderInLayer = 500
GM_ToolUI.hideType = UIHideType.Hide
GM_ToolUI.hideFunc = UIHideFunc.MoveOutOfScreen
GM_ToolUI.escClose = UIEscClose.DontClose

function GM_ToolUI:InitControls()
  self.btn_Close = self:GetControl("btn_Close")
  self.btn_Shrink = self:GetControl("btn_Shrink")
  self.shrinkBg = self:GetControl("shrinkBg")
  self.PanelList = self:GetControl("PanelList")
  self.MessagePanel = self:GetControl("PanelList/MessagePanel")
  self.CommandPanel = self:GetControl("PanelList/CommandPanel")
  self.WarReportPanel = self:GetControl("PanelList/WarReportPanel")
  self.btn_Message = self:GetControl("PanelList/btn_List/btn_Message")
  self.btn_Command = self:GetControl("PanelList/btn_List/btn_Command")
  self.btn_WarReport = self:GetControl("PanelList/btn_List/btn_WarReport")
end

function GM_ToolUI:Init()
end

function GM_ToolUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function GM_ToolUI:InitUI()
  function self.ClickCallBack(data)
    self:ClickButtonCallBackFunc(data)
  end
  
  self.panelTemplateListTab = {
    [1] = luaTemplateManager.GetNewTemplate(self.MessagePanel, LuaComponentTemplates.MessagePanelTemplate, {
      goCallBack = self.ClickCallBack,
      curTogIndex = 1,
      relevancyBtn = self.btn_Message
    }),
    [2] = luaTemplateManager.GetNewTemplate(self.CommandPanel, LuaComponentTemplates.CommandPanelTemplate, {
      goCallBack = self.ClickCallBack,
      curTogIndex = 2,
      relevancyBtn = self.btn_Command
    }),
    [3] = luaTemplateManager.GetNewTemplate(self.WarReportPanel, LuaComponentTemplates.WarReportPanelTemplate, {
      goCallBack = self.ClickCallBack,
      curTogIndex = 3,
      relevancyBtn = self.btn_WarReport
    })
  }
  self.panelObjListTab = {
    [1] = self.MessagePanel,
    [2] = self.CommandPanel,
    [3] = self.WarReportPanel
  }
  self.is_Shrink = false
end

function GM_ToolUI:OnShow()
  self:RegistEvents()
  self:RefreshPageView()
end

local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode

function GM_ToolUI:Update()
  if Input.GetKeyDown(KeyCode.Tab) then
    self.root:SetAnchoredPosition(0, 0)
  end
end

function GM_ToolUI:RegistEvents()
  self:RegistEvent(Event.RefreshGMListView, self.RefreshLeftListView, self)
  self:RegistEvent(Event.RefreshSelectGMMessage, self.RefreshRightListView, self)
end

function GM_ToolUI:RefreshPageView()
  self.selectTogIndex = 1
  if LoginData.isClickComplete == false and LoginData.externalNet == true then
    UIManager.Hide(UIID.GM_ToolUI)
    return
  end
  for index, itemTemplate in ipairs(self.panelTemplateListTab) do
    if index == self.selectTogIndex then
      itemTemplate:ClickGoCallBack()
    end
  end
end

function GM_ToolUI:ClickButtonCallBackFunc(data)
  self.selectTogIndex = data
  self.panelTemplateListTab[self.selectTogIndex]:Refresh()
  self:RefreshPanelViewShow()
end

function GM_ToolUI:RefreshPanelViewShow()
  for index, itemPanelObj in ipairs(self.panelObjListTab) do
    itemPanelObj:SetActive(index == self.selectTogIndex)
  end
end

function GM_ToolUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
  self.btn_Shrink:SetOnClick(self, self.btn_ShrinkOnClick)
  self.root:SetOnBeginDrag(self, self.GMPanelBeginDrag)
  self.root:SetOnDrag(self, self.GMPanelDrag)
end

function GM_ToolUI:btn_CloseOnClick()
  UIManager.Hide(UIID.GM_ToolUI)
end

function GM_ToolUI:btn_ShrinkOnClick()
  self.is_Shrink = not self.is_Shrink
  self.btn_Shrink:GetChild("Text"):SetText(self.is_Shrink and "\226\150\178" or "\226\150\188")
  self.PanelList:SetActive(not self.is_Shrink)
end

function GM_ToolUI:GMPanelBeginDrag(control, eventData)
  self.rectTrans = self.root.rectTransform
end

function GM_ToolUI:GMPanelDrag(control, eventData)
  self.rectTrans.anchoredPosition = self.rectTrans.anchoredPosition + eventData.delta
end

function GM_ToolUI:RefreshLeftListView(_, data)
  self.panelTemplateListTab[self.selectTogIndex]:RefreshLeftListView(data)
end

function GM_ToolUI:RefreshRightListView(_, data)
  self.panelTemplateListTab[self.selectTogIndex]:RefreshRightListView(data)
end
