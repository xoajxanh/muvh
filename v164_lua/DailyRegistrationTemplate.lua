local DailyRegistrationTemplate = {}

function DailyRegistrationTemplate:Init(data)
  if data then
    self.rootUI = data.rootUI
    self.activityType = data.activityType
  end
  self:InitControls()
  self:InitContainer()
end

function DailyRegistrationTemplate:InitControls()
  self.go_Item = self:GetControl("Scrollview/Viewport/Content/go_Item")
end

local function OnDailyRegistrationCreate(control)
  control.lab_Name = UIControl(control.transform, "lab_Name")
  control.btn_Get = UIControl(control.transform, "btn_Get")
  control.btn_Received = UIControl(control.transform, "btn_Received")
  control.btn_3DItem = UIControl(control.transform, "btn_3DItem")
  control.btn_3DItem.itemCellData = ItemCellData()
end

local function OnDailyRegistrationRefresh(control, index, data, ui)
  if data == nil then
    return
  end
  local boxConfigTab = ClientTable.cfg_Box_boxManager:TryGetValue(tonumber(data.reward), "boxId")
  if boxConfigTab == nil then
    return
  end
  control.btn_3DItem.itemCellData:RecycleRes()
  local itemData = ItemUtility.GenerateItemData(boxConfigTab.itemId)
  itemData.count = boxConfigTab.count
  control.btn_3DItem.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(control.btn_3DItem, control.btn_3DItem.itemCellData, ui.rootUI, true)
  local day = PCActivityManager:GetDailyRegistrationDays()
  if day == nil then
    return
  end
  if index > day then
    control.btn_Get:SetActive(false)
    control.btn_Received:SetActive(false)
  else
    local isReceiveReward = PCActivityManager:CheckIsReceiveReward(data.countKey)
    control.btn_Get:SetActive(not isReceiveReward)
    control.btn_Received:SetActive(isReceiveReward)
  end
  control.lab_Name:SetText("Day" .. data.sortId)
  control.btn_Get:SetOnClick(ui, function()
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {
        data.id
      }
    })
  end)
end

function DailyRegistrationTemplate:InitContainer()
  self.dailyRegistrationContainer = UIContainer(self.go_Item, self, OnDailyRegistrationCreate, OnDailyRegistrationRefresh)
end

function DailyRegistrationTemplate:Refresh()
  self:RefreshView()
end

function DailyRegistrationTemplate:RefreshView()
  local dailyRegistrationGiftData = PCActivityManager:GetDailyRegistrationGiftData()
  if dailyRegistrationGiftData == nil or next(dailyRegistrationGiftData) == nil then
    return
  end
  self.dailyRegistrationContainer:SetData(dailyRegistrationGiftData)
end

return DailyRegistrationTemplate
