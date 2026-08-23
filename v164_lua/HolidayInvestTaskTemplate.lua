local HolidayInvestTaskTemplate = {}

function HolidayInvestTaskTemplate:Init(baseUI)
  if baseUI then
    self.baseUI = baseUI
  end
  self:InitControls()
  self:InitContainer()
  self:BindUIEvent()
end

function HolidayInvestTaskTemplate:InitControls()
  self.btn_Item = self:GetControl("sw_gift/Viewport/Content/btn_Item")
  self.lab_TaskName = self:GetControl("lab_taskName")
  self.btn_go = self:GetControl("go_state/btn_go")
  self.btn_Get = self:GetControl("go_state/btn_get")
  self.lab_AlreadyGet = self:GetControl("go_state/lab_alreadyGet")
  self.lab_CanNotGet = self:GetControl("go_state/lab_CanNotGet")
end

local function OnRewardItemCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnRewardItemRefresh(ctr, _, data, ui)
  local reward = string.split(data, "#")
  local itemData = ItemUtility.GenerateItemData(tonumber(reward[1]))
  itemData.count = tonumber(reward[2])
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

function HolidayInvestTaskTemplate:InitContainer()
  self.rewardContainer = UIContainer(self.btn_Item, self.baseUI, OnRewardItemCreate, OnRewardItemRefresh)
end

function HolidayInvestTaskTemplate:BindUIEvent()
  self.btn_Get:SetOnClick(self, self.btn_GetOnClick)
end

function HolidayInvestTaskTemplate:btn_GetOnClick()
  networkRequest.ReqInvestRewardInfo(self.data.id, self.data.finishCount, self.data.hasReward)
end

function HolidayInvestTaskTemplate:Refresh(data, ui)
  self.data = data
  self.parent = ui
  self.configData = ClientTable.cfg_Commerce_holidayinvestManager:TryGetValue(self.data.id)
  self:RefreshTaskRewardGrid()
  self:RefreshView()
end

function HolidayInvestTaskTemplate:RefreshTaskRewardGrid()
  local rewardConfig = self.configData.reward
  local rewardList = string.split(rewardConfig, "&")
  self.rewardContainer:SetData(rewardList)
end

function HolidayInvestTaskTemplate:RefreshView()
  self.lab_TaskName:SetText(self.configData.description)
  self.btn_go:SetActive(false)
  if self.data.hasReward then
    self.btn_Get:SetActive(false)
    self.lab_AlreadyGet:SetActive(true)
    self.lab_CanNotGet:SetActive(false)
  else
    local targetCount = ClientTable.cfg_Task_goalManager:TryGetValue(self.configData.mission).goalCount
    self.btn_Get:SetActive(targetCount <= self.data.finishCount)
    self.lab_AlreadyGet:SetActive(false)
    self.lab_CanNotGet:SetActive(targetCount > self.data.finishCount)
  end
end

return HolidayInvestTaskTemplate
