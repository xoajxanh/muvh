local FirstLoginTemplate = {}

function FirstLoginTemplate:Init(data)
  if data then
    self.rootUI = data.rootUI
    self.activityType = data.activityType
  end
  self:InitControls()
  self:InitContainer()
  self:BindUIEvent()
end

function FirstLoginTemplate:InitControls()
  self.btn_3DItem = self:GetControl("Scrollview/Viewport/Content/btn_3DItem")
  self.btn_Get = self:GetControl("btn_Get")
  self.btn_Received = self:GetControl("btn_Received")
end

local function OnFirstLoginCreate(control)
  control.itemCellData = ItemCellData()
end

local function OnFirstLoginRefresh(control, index, data, ui)
  if data == nil then
    return
  end
  control.itemCellData:RecycleRes()
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  control.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(control, control.itemCellData, ui.rootUI, true)
end

function FirstLoginTemplate:InitContainer()
  self.firstLoginContainer = UIContainer(self.btn_3DItem, self, OnFirstLoginCreate, OnFirstLoginRefresh)
end

function FirstLoginTemplate:BindUIEvent()
  self.btn_Get:SetOnClick(self, self.btn_GetOnClick)
end

function FirstLoginTemplate:btn_GetOnClick()
  local firstLoginGiftData = PCActivityManager:GetFirstLoginGiftData()
  if firstLoginGiftData == nil or next(firstLoginGiftData) == nil then
    return
  end
  NetManager.Send(RechargeMessage.ReqGetGift, {
    id = {
      firstLoginGiftData.id
    }
  })
end

function FirstLoginTemplate:Refresh()
  self:Refresh3DItem()
  self:RefreshButtonState()
end

function FirstLoginTemplate:Refresh3DItem()
  local firstLoginGiftData = PCActivityManager:GetFirstLoginGiftData()
  if firstLoginGiftData == nil or next(firstLoginGiftData) == nil then
    return
  end
  local boxConfigTab = ConfigManager.FindConfigs("cfg_Box_box", "boxId", firstLoginGiftData.reward)
  if boxConfigTab == nil or next(boxConfigTab) == nil then
    return
  end
  self.firstLoginContainer:SetData(boxConfigTab)
end

function FirstLoginTemplate:RefreshButtonState()
  local firstLoginGiftData = PCActivityManager:GetFirstLoginGiftData()
  if firstLoginGiftData == nil or next(firstLoginGiftData) == nil then
    return
  end
  local isReceiveReward = PCActivityManager:CheckIsReceiveReward(firstLoginGiftData.countKey)
  self.btn_Get:SetActive(not isReceiveReward)
  self.btn_Received:SetActive(isReceiveReward)
end

return FirstLoginTemplate
