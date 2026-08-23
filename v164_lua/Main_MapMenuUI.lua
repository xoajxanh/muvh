Main_MapMenuUI = class(BaseUI)
Main_MapMenuUI.layer = UILayer.Panel
Main_MapMenuUI.orderInLayer = 0
Main_MapMenuUI.hideType = UIHideType.WaitDestroy
Main_MapMenuUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_MapMenuUI.escClose = UIEscClose.DontClose

function Main_MapMenuUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Scroll_Mapinfos = self:GetControl("Scroll_Mapinfos")
  self.Scroll_Content = self:GetControl("Scroll_Mapinfos/Viewport/Scroll_Content")
  self.Button_MapInfo = self:GetControl("Scroll_Mapinfos/Viewport/Scroll_Content/Button_MapInfo")
  self.Text_MapArea = self:GetControl("Scroll_Mapinfos/Viewport/Scroll_Content/Button_MapInfo/Text_MapArea")
  self.Text_MapName = self:GetControl("Scroll_Mapinfos/Viewport/Scroll_Content/Button_MapInfo/Text_MapName")
  self.Text_MapLevel = self:GetControl("Scroll_Mapinfos/Viewport/Scroll_Content/Button_MapInfo/Text_MapLevel")
  self.Text_MapCoin = self:GetControl("Scroll_Mapinfos/Viewport/Scroll_Content/Button_MapInfo/Text_MapCoin")
  self.Button_Close = self:GetControl("Button_Close")
end

function Main_MapMenuUI:Init()
end

function Main_MapMenuUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local sceneBtnInfos = {}

function Main_MapMenuUI:InitUI()
  local tempName = self.Button_MapInfo.transform.name
  local scrollContainer = self.Scroll_Content.transform:GetComponent("UIScrollContainer")
  if scrollContainer then
    scrollContainer.MaxCount = table.count(SceneData.sceneTransferInfosTbl)
    for i = 1, scrollContainer.MaxCount do
      local go = scrollContainer:GetScrollGoByIndex(i - 1)
      local objControl = UIControl(go.transform)
      GuideUtility.AddCreatNameObj("Main_MapMenuUI", go)
      local data = SceneData.sceneTransferInfosTbl[i]
      if not self.args or self.args.transID == data.id then
      else
      end
      local mapAreaTxt = UIControl(objControl.transform, "Text_MapArea")
      mapAreaTxt:SetText(data.id)
      local mapNameTxt = UIControl(objControl.transform, "Text_MapName")
      mapNameTxt:SetText(data.name)
      local mapLevelTxt = UIControl(objControl.transform, "Text_MapLevel")
      mapLevelTxt:SetText(data.level)
      local mapCoinTxt = UIControl(objControl.transform, "Text_MapCoin")
      mapCoinTxt:SetText(data.coin)
      local mapData = {
        mapId = data.id
      }
      objControl:SetOnClick(self, function()
        self:MapInfoClick(mapData)
      end)
    end
  end
end

function Main_MapMenuUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_MapMenuUI:OnHide()
  UIManager.Hide(UIID.MapMenuUI)
end

function Main_MapMenuUI:OnDestroy()
end

function Main_MapMenuUI:RegistUIEvents()
  self.Button_Close:SetOnClick(self, self.CloseClick)
  self.btn_closeBg:SetOnClick(self, self.CloseClick)
end

function Main_MapMenuUI:MapInfoClick(mapData)
  EventManager.Dispatch(Event.Map_ChangeMap, mapData)
  self.CloseClick()
end

function Main_MapMenuUI:CloseClick()
  UIManager.Hide(UIID.MapMenuUI)
end

function Main_MapMenuUI:RegistEvents()
end

function Main_MapMenuUI:Refresh()
end
