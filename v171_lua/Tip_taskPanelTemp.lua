local Tip_taskPanelTemp = {}

function Tip_taskPanelTemp:Init(data)
  self.Tip_taskPanel = data.Tip_taskPanel
  self.root = data.root
  self.BaseItemShow = data.itemShow
  self.BaseAllTaskRewardShow = data.AllTaskRewardShow
  self:InitControls()
  self:BindEvents()
  self.ConnectionGiftOpenTipsUITemp = UIUtility.BindUIContainerTemp(self.Task, LuaComponentTemplates.ConnectionGiftOpenTipsUITemp, self.root)
end

local function OnEquipItemCreate(ctr)
  ctr.lab_Received = UIControl(ctr.transform, "lab_Received")
  ctr.getEffect = UIControl(ctr.transform, "getEffect")
  ctr.itemCellData = ItemCellData()
end

local function OnEquipItemRefresh(ctr, index, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.lab_Received:SetActive(data.lab_Received)
  ctr.getEffect:SetActive(data.getEffect)
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui.rootUI, true)
end

function Tip_taskPanelTemp:InitControls()
  self.Task = self:GetControl("TaskShow/sw_Task/Viewport/Content/Task")
  self.ItemShow = self:GetControl("ItemShow")
  self.Btn_return = self:GetControl("Btn_return")
  self.getEffectData = {}
  self.lab_ReceivedData = {}
  self.ItemShowList = {}
  self.btn_equipItemContainer = {}
  for i = 1, self.ItemShow.transform.childCount do
    local child = self.ItemShow:GetChild("item_" .. i)
    local btn_3DItem = self.ItemShow:GetChild("item_" .. i .. "/btn_3DItem")
    local lab_Received = self.ItemShow:GetChild("item_" .. i .. "/btn_3DItem/lab_Received")
    local getEffect = self.ItemShow:GetChild("item_" .. i .. "/btn_3DItem/getEffect")
    self.btn_equipItemContainer[i] = UIContainer(btn_3DItem, self, OnEquipItemCreate, OnEquipItemRefresh)
    table.insert(self.ItemShowList, child)
    self.getEffectData[i] = getEffect
    self.lab_ReceivedData[i] = lab_Received
  end
end

function Tip_taskPanelTemp:BindEvents()
  self.Btn_return:SetOnClick(self, self.StrengthenBtnOnClick)
  self.Tip_taskPanel:SetOnClick(self, self.StrengthenBtnOnClick)
end

function Tip_taskPanelTemp:StrengthenBtnOnClick()
  self.Tip_taskPanel:SetActive(false)
  self.BaseItemShow:SetActive(true)
  self.BaseAllTaskRewardShow:SetActive(true)
end

function Tip_taskPanelTemp:Refresh()
  self:RefreshItemData()
  self:RefreshData()
end

function Tip_taskPanelTemp:RefreshData()
  local rewardConfig = QuickFind:GetConnectionGiftManager():GetRewardConfig()
  for i, v in pairs(rewardConfig) do
    if i ~= 10 then
      local itemData = QuickFind:GetConnectionGiftManager():ShowItemData(rewardConfig[i].giftId)
      if itemData then
        local showReward = QuickFind:GetConnectionGiftManager():RefreshRewardItemData(i)
        local Received = QuickFind:GetConnectionGiftManager():RefreshReceived(i)
        itemData.lab_Received = false
        itemData.getEffect = false
        if showReward then
          itemData.lab_Received = false
          itemData.getEffect = true
        end
        if Received then
          itemData.lab_Received = true
          itemData.getEffect = false
        end
        self.btn_equipItemContainer[i]:SetData({itemData})
      end
    end
  end
end

function Tip_taskPanelTemp:RefreshItemData()
  local itemData = {}
  local ItemCfg = ClientTable.cfg_Commerce_ConnectionGiftManager:GetDic()
  if not ItemCfg then
    return
  end
  local RefreshData = QuickFind:GetConnectionGiftManager():RefreshData()
  if not RefreshData then
    return
  end
  for i, v in ipairs(ItemCfg) do
    local isContains = false
    for j, k in pairs(RefreshData.goalMap) do
      if v.id == j then
        isContains = true
      end
    end
    if (table.contains(RefreshData.goals, v.id) or isContains == true) and ConditionManager.Check4D(v.condition) then
      v.isBol = false
      for j, k in pairs(RefreshData.goals) do
        if k == v.id then
          v.isBol = true
        end
      end
      if RefreshData.goalMap[i] then
        v.count = RefreshData.goalMap[i]
      else
        v.count = 0
      end
      table.insert(itemData, v)
    end
  end
  self.ConnectionGiftOpenTipsUITemp:SetData(itemData)
end

return Tip_taskPanelTemp
