local ConnectionGiftPanelUITemp = {}

function ConnectionGiftPanelUITemp:Init()
  self:InitControls()
  self:BindEvents()
  self.ConnectionGiftUITemp = UIUtility.BindUIContainerTemp(self.Task, LuaComponentTemplates.ConnectionGiftUITemp, self, {
    Tip_taskPanel = self.Tip_taskPanel,
    Btn_ConnectionTask = self.Btn_ConnectionTask,
    root = self,
    itemShow = self.ItemShow,
    AllTaskRewardShow = self.AllTaskRewardShow
  })
end

local function OnEquipItemCreate(ctr)
  ctr.lab_Received = UIControl(ctr.transform, "lab_Received")
  ctr.itemCellData = ItemCellData()
end

local function OnEquipItemRefresh(ctr, index, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.lab_Received:SetActive(data.lab_Received)
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui.rootUI, true)
end

local function AllOnEquipItemCreate(ctr)
  ctr.itemCellData = ItemCellData()
end

local function AllOnEquipItemRefresh(ctr, index, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui.rootUI, true)
end

function ConnectionGiftPanelUITemp:InitControls()
  self.txt_lastTime_ConnectionGift = self:GetControl("txt_lastTime_ConnectionGift")
  self.Task = self:GetControl("TaskShow/sw_Task/Viewport/Content/Task")
  self.ItemShow = self:GetControl("ItemShow")
  self.Btn_ConnectionTask = self:GetControl("TaskShow/Btn_ConnectionTask")
  self.AllTaskRewardShow = self:GetControl("AllTaskRewardShow")
  self.btn_3DItem = self:GetControl("AllTaskRewardShow/sw_AllTaskReward/Viewport/Content/btn_3DItem")
  self.btn_get = self:GetControl("AllTaskRewardShow/btns/btn_get")
  self.lab_Received = self:GetControl("AllTaskRewardShow/btns/lab_Received")
  self.lab_notReached = self:GetControl("AllTaskRewardShow/btns/lab_notReached")
  self.btn_equipAllTaskRewardShow = UIContainer(self.btn_3DItem, self, AllOnEquipItemCreate, AllOnEquipItemRefresh)
  self.Tip_taskPanel = self:GetControl("Tip_taskPanel")
  self.ItemShowList = {}
  self.btn_equipItemContainer = {}
  self.getEffectData = {}
  self.lab_ReceivedData = {}
  for i = 1, self.ItemShow.transform.childCount do
    local child = self.ItemShow:GetChild("item_" .. i)
    local btn_3DItem = self.ItemShow:GetChild("item_" .. i .. "/3D_Item/btn_3DItem")
    local lab_Received = self.ItemShow:GetChild("item_" .. i .. "/3D_Item/btn_3DItem/lab_Received")
    local getEffect = self.ItemShow:GetChild("item_" .. i .. "/getEffect")
    self.btn_equipItemContainer[i] = UIContainer(btn_3DItem, self, OnEquipItemCreate, OnEquipItemRefresh)
    table.insert(self.ItemShowList, child)
    self.getEffectData[i] = getEffect
    self.lab_ReceivedData[i] = lab_Received
  end
end

function ConnectionGiftPanelUITemp:EquipPrize()
  for i = 1, self.ItemShow.transform.childCount do
    local showReward = QuickFind:GetConnectionGiftManager():RefreshRewardItemData(i)
    local Received = QuickFind:GetConnectionGiftManager():RefreshReceived(i)
    self.getEffectData[i]:SetActive(false)
    if showReward then
      self.getEffectData[i]:SetActive(true)
    end
    if Received then
      self.getEffectData[i]:SetActive(false)
    end
  end
  local showReward = QuickFind:GetConnectionGiftManager():RefreshRewardItemData(10)
  local Received = QuickFind:GetConnectionGiftManager():RefreshReceived(10)
  self.btn_get:SetActive(false)
  self.lab_Received:SetActive(false)
  self.lab_notReached:SetActive(true)
  if showReward then
    self.btn_get:SetActive(true)
    self.lab_Received:SetActive(false)
    self.lab_notReached:SetActive(false)
  end
  if Received then
    self.btn_get:SetActive(false)
    self.lab_Received:SetActive(true)
    self.lab_notReached:SetActive(false)
  end
end

function ConnectionGiftPanelUITemp:BindEvents()
  for i, v in pairs(self.getEffectData) do
    v:SetOnClickParam(self, self.btn_equipPrizeOnClick, i)
  end
  self.btn_get:SetOnClick(self, self.btn_getRewardOnClick)
end

function ConnectionGiftPanelUITemp:btn_equipPrizeOnClick(control)
  local taskLineCfg = QuickFind:GetConnectionGiftManager():GetRewardConfig()
  NetManager.Send(RechargeMessage.ReqGetGift, {
    id = {
      tonumber(taskLineCfg[control.param].giftId)
    }
  })
end

function ConnectionGiftPanelUITemp:btn_getRewardOnClick(control)
  local rewardConfig = QuickFind:GetConnectionGiftManager():GetRewardConfig()
  NetManager.Send(RechargeMessage.ReqGetGift, {
    id = {
      rewardConfig[10].giftId
    }
  })
end

function ConnectionGiftPanelUITemp:Refresh()
  self.Tip_taskPanel:SetActive(false)
  self.ItemShow:SetActive(true)
  self.AllTaskRewardShow:SetActive(true)
  self:RefreshItemData()
  self:EquipPrize()
  self:RefreshData()
  self:RefreshSurplusTime()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holidayActivity_ConnectionGift
  })
end

function ConnectionGiftPanelUITemp:RefreshSurplusTime()
  if self.remainTimeLoop then
    Timer.Stop(self.remainTimeLoop)
    self.remainTimeLoop = nil
  end
  self.txt_lastTime_ConnectionGift:SetText(QuickFind:GetConnectionGiftManager():GetRemainTimeDes())
  self.remainTimeLoop = Timer.StartLoopForever(1, function()
    self.txt_lastTime_ConnectionGift:SetText(QuickFind:GetConnectionGiftManager():GetRemainTimeDes())
  end)
end

function ConnectionGiftPanelUITemp:RefreshData()
  local rewardConfig = QuickFind:GetConnectionGiftManager():GetRewardConfig()
  for i, v in pairs(rewardConfig) do
    if i == 10 then
      local itemData = {}
      local gift = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 30)
      for j, k in pairs(gift) do
        if k.id == tonumber(rewardConfig[i].giftId) then
          local box = ConfigManager.FindConfigs("cfg_Box_box", "boxId", k.reward)
          itemData = {}
          for n, m in pairs(box) do
            if m.condition == nil or ConditionManager.Check4D(m.condition) then
              local itemInfo = {
                itemId = m.itemId,
                count = m.count
              }
              table.insert(itemData, itemInfo)
            end
          end
        end
      end
      if itemData then
        self.btn_equipAllTaskRewardShow:SetData(itemData)
      end
    else
      local itemData = QuickFind:GetConnectionGiftManager():ShowItemData(rewardConfig[i].giftId)
      if itemData then
        local showReward = QuickFind:GetConnectionGiftManager():RefreshRewardItemData(i)
        local Received = QuickFind:GetConnectionGiftManager():RefreshReceived(i)
        itemData.img_redPoint = false
        itemData.lab_Received = false
        if showReward then
          itemData.img_redPoint = true
          itemData.lab_Received = false
        end
        if Received then
          itemData.img_redPoint = false
          itemData.lab_Received = true
        end
        self.btn_equipItemContainer[i]:SetData({itemData})
      end
    end
  end
end

function ConnectionGiftPanelUITemp:RefreshItemData()
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
      table.insert(itemData, v)
    end
  end
  self.ConnectionGiftUITemp:SetData(itemData)
end

function ConnectionGiftPanelUITemp:Hide()
  if self.remainTimeLoop then
    Timer.Stop(self.remainTimeLoop)
    self.remainTimeLoop = nil
  end
end

return ConnectionGiftPanelUITemp
