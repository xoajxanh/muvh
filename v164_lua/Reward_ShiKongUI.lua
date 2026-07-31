Reward_ShiKongUI = class(BaseUI)
Reward_ShiKongUI.layer = UILayer.Panel
Reward_ShiKongUI.orderInLayer = 0
Reward_ShiKongUI.hideType = UIHideType.WaitDestroy
Reward_ShiKongUI.hideFunc = UIHideFunc.MoveOutOfScreen
Reward_ShiKongUI.escClose = UIEscClose.DontClose

function Reward_ShiKongUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.reward_Btn_3DItem = self:GetControl("middle/reward/grid/btn_3DItem")
  self.clearance_Btn_3DItem = self:GetControl("middle/clearance/grid/btn_3DItem")
  self.btn_enter = self:GetControl("middle/btn_enter")
end

function Reward_ShiKongUI:Init()
  self.clicktime = 0
end

function Reward_ShiKongUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnRewardItemCreate(_control)
  _control.itemCtr = ItemUtility.InitItemCell(UIControl(_control.transform))
  _control.modelData = ItemCellData()
end

local function OnRewardItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  local itemData = ItemUtility.GenerateItemData(_data.itemId)
  itemData.count = _data.count
  _control.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(_control.itemCtr, _control.modelData, _ui, true)
end

local function OnClearanceItemCreate(_control)
  _control.lab_already = UIControl(_control.transform, "lab_already")
  _control.itemCtr = ItemUtility.InitItemCell(UIControl(_control.transform))
  _control.modelData = ItemCellData()
end

local function OnClearanceItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  local itemData = table.DeepCopy(ItemUtility.GenerateItemData(_data.itemId))
  local itemDataBag = BagInfoData.GetItemTblByConfigId(_data.itemId)
  _control:SetActive(true)
  if itemData.tblItem and itemData.tblItem.overTime ~= "0" then
    if table.isNullOrEmpty(itemDataBag) then
      itemData.tblItem.overTime = "0"
      _control.modelData:RefreshData(itemData)
      ItemUtility.ShowItemCell(_control.itemCtr, _control.modelData, _ui, true)
    else
      local itemDataBagData = itemDataBag[1]
      _control.modelData:RefreshData(itemDataBagData)
      _control.modelData.customData = {}
      
      function _control.modelData.customData.clickCallBack(itemCellData)
        local state
        if UIManager.IsVisibleOrCorrelation(UIID.BagWarehouseUI, self) then
          state = EItemOperateType.Deposit
        end
        UIManager.Show(UIID.ItemTipUI, {
          item = itemDataBagData,
          rightOperate = EItemOperateType.Show,
          ctrl = _control
        })
      end
      
      ItemUtility.ShowItemCell(_control.itemCtr, _control.modelData, _ui, true)
    end
  else
    _control.modelData:RefreshData(itemData)
    ItemUtility.ShowItemCell(_control.itemCtr, _control.modelData, _ui, true)
  end
  local bagCount = BagInfoData.GetItemTotalCountByItemId(_data.itemId)
  local color = bagCount >= _data.count and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]
  local text = string.GetColorText(string.format("%s/%s", bagCount, _data.count), color)
  _control.lab_already:SetText(text)
end

function Reward_ShiKongUI:InitUI()
  self.reward_Btn_3DItemContainer = UIContainer(self.reward_Btn_3DItem, self, OnRewardItemCreate, OnRewardItemRefresh)
  self.clearance_Btn_3DItemContainer = UIContainer(self.clearance_Btn_3DItem, self, OnClearanceItemCreate, OnClearanceItemRefresh)
end

function Reward_ShiKongUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
end

function Reward_ShiKongUI:btn_closeOnClick()
  UIManager.Hide(UIID.Reward_ShiKongUI)
  EventManager.Dispatch(Event.CancelClickNpc)
end

function Reward_ShiKongUI:btn_closeBgOnClick()
  UIManager.Hide(UIID.Reward_ShiKongUI)
  EventManager.Dispatch(Event.CancelClickNpc)
end

function Reward_ShiKongUI:btn_enterOnClick()
  if self.clicktime ~= 0 then
    if Time.GetServerTime() - self.clicktime < 800 then
      return
    else
      self.clicktime = Time.GetServerTime()
    end
  else
    self.clicktime = Time.GetServerTime()
  end
  local resSpaceCrackTaskInfoData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackTaskInfoData
  if resSpaceCrackTaskInfoData == nil then
    return
  end
  local serverTask = resSpaceCrackTaskInfoData.task
  if serverTask == nil then
    return
  end
  if serverTask.complete then
    return
  end
  SpaceCrackController.ReqSubmitInstanceTask(serverTask.id)
end

function Reward_ShiKongUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Reward_ShiKongUI:RegistEvents()
end

function Reward_ShiKongUI:Refresh()
  self:RefreshReward()
  self:RefreshClearance()
end

function Reward_ShiKongUI:RefreshReward()
  local resSpaceCrackTaskInfoData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackTaskInfoData
  if resSpaceCrackTaskInfoData == nil then
    return
  end
  local serverTask = resSpaceCrackTaskInfoData.task
  if serverTask == nil then
    return
  end
  local instance_missionConfig = ClientTable.cfg_Map_instance_missionManager:TryGetValue(serverTask.id, "id")
  if instance_missionConfig == nil then
    return
  end
  local boxConfig = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(instance_missionConfig.rewards))
  local itemDataTab = {}
  for n, m in pairs(boxConfig) do
    if m.condition == nil or ConditionManager.Check4D(m.condition) then
      local itemInfo = {
        itemId = m.itemId,
        count = m.count
      }
      table.insert(itemDataTab, itemInfo)
    end
  end
  self.reward_Btn_3DItemContainer:SetData(itemDataTab)
end

function Reward_ShiKongUI:RefreshClearance()
  local resSpaceCrackTaskInfoData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackTaskInfoData
  if resSpaceCrackTaskInfoData == nil then
    return
  end
  local serverTask = resSpaceCrackTaskInfoData.task
  if serverTask == nil then
    return
  end
  local instance_missionConfig = ClientTable.cfg_Map_instance_missionManager:TryGetValue(serverTask.id, "id")
  if instance_missionConfig == nil then
    return
  end
  local rewardData = SpaceCrackUtility:StructureTranScriptRewardData(instance_missionConfig.param)
  self.clearance_Btn_3DItemContainer:SetData(rewardData)
end

function Reward_ShiKongUI:OnHide()
end

function Reward_ShiKongUI:OnDestroy()
end
