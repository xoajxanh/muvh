Instance_InstanceUI = class(BaseUI)
Instance_InstanceUI.layer = UILayer.Panel
Instance_InstanceUI.orderInLayer = 0
Instance_InstanceUI.hideType = UIHideType.WaitDestroy
Instance_InstanceUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_InstanceUI.escClose = UIEscClose.DontClose

function Instance_InstanceUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.ScrollView = self:GetControl("ScrollView")
  self.tog_instance = self:GetControl("tog_instance")
  self.grid = self:GetControl("Middel/grid")
  self.btn_Item = self:GetControl("Middel/grid/btn_Item")
  self.lab_count1 = self:GetControl("Middel/lab_condition/lab_leftcount/lab_count1")
  self.btn_get1 = self:GetControl("Middel/lab_condition/lab_leftcount/btn_get1")
  self.img_itemicon = self:GetControl("Middel/lab_condition/lab_requirements/img_itemicon")
  self.lab_count2 = self:GetControl("Middel/lab_condition/lab_requirements/lab_count2")
  self.btn_get2 = self:GetControl("Middel/lab_condition/lab_requirements/btn_get2")
  self.lab_consumeCount = self:GetControl("Middel/lab_condition/lab_requirements/lab_consumeCount")
  self.btn_enter = self:GetControl("Middel/btn_enter")
  self.btn_receive = self:GetControl("Middel/btn_receive")
  self.btn_multireceive = self:GetControl("Middel/btn_multireceive")
  self.btn_sweep = self:GetControl("Middel/btn_sweep")
end

function Instance_InstanceUI:Init()
end

function Instance_InstanceUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_InstanceUI:InitUI()
  self.tog_instance.toggle.isOn = false
end

function Instance_InstanceUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Instance_InstanceUI:OnHide()
end

function Instance_InstanceUI:OnDestroy()
end

function Instance_InstanceUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_get1:SetOnClick(self, self.btn_get1OnClick)
  self.btn_get2:SetOnClick(self, self.btn_get2OnClick)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
  self.btn_sweep:SetOnClick(self, self.btn_sweepOnClick)
  self.btn_receive:SetOnClick(self, self.btn_receiveOnClick)
  self.btn_multireceive:SetOnClick(self, self.btn_multireceiveOnClick)
end

function Instance_InstanceUI:btn_closeOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.Instance_InstanceUI)
end

function Instance_InstanceUI:btn_get1OnClick(control)
end

function Instance_InstanceUI:btn_get2OnClick(control)
end

function Instance_InstanceUI:btn_enterOnClick(control)
  if not self.CurSingleCopydata then
    return
  end
  local mapData = {
    mapId = self.CurSingleCopydata.transferTable.id
  }
  SceneController.OnReqTransferTransmitMap(nil, mapData)
end

function Instance_InstanceUI:btn_sweepOnClick(control)
end

function Instance_InstanceUI:btn_receiveOnClick(control)
end

function Instance_InstanceUI:btn_multireceiveOnClick(control)
end

function Instance_InstanceUI:RegistEvents()
  self:RegistEvent(Event.Scene_ShowLoading, self.Scene_ShootSceneFunc, self)
end

function Instance_InstanceUI:Scene_ShootSceneFunc(id, msg)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.Instance_InstanceUI)
end

function Instance_InstanceUI:Refresh()
  self.selectIndex = 1
  self.CurCopydatas = TranScriptData.GetTypeDatas(TranScriptData.TranScriptSubType.SingleMaterial)
  self:CreateTableView(self.CurCopydatas)
end

function Instance_InstanceUI:CreateTableView(copyData)
  self.tableView = TableView()
  self.tableView:SetCellInterval(1)
  self.tableView:SetScrollView(self.ScrollView)
  self.tableView:SetCell(self.tog_instance)
  self.tableView:SetUpdateCallback(bind(self, self.UpdateCellCallback))
  self.tableView:CreateTableView()
  self.tableView:SetData(copyData)
  self.tableView:SetTotalCellCount(#copyData)
  self.tableView:ReloadTableView()
end

function Instance_InstanceUI:UpdateCellCallback(index, cell, data)
  if data[index] then
    local labName = UIControl(cell.transform, "lab_instancename")
    local labLevel = UIControl(cell.transform, "lab_openlevel")
    local level = ClientTable.cfg_Map_transferManager:TryGetValue(data[index].transferTable.id, "id").condition
    labName:SetText(data[index].instanceTbl.name)
    labLevel:SetText(string.format(LocalizationUtility.GetContentByKey("suoxudengji"), level[2]))
    cell.index = index
    cell:SetOnToggleChanged(self, self.selectCopyItem)
    cell.toggle.isOn = false
    if self.selectIndex == index then
      cell.toggle.isOn = true
      cell:SetInteractable(false)
    else
      cell.toggle.isOn = false
      cell:SetInteractable(true)
    end
  else
    cell:SetActive(false)
  end
end

function Instance_InstanceUI:selectCopyItem(control)
  control:SetInteractable(not control.toggle.isOn)
  if control.toggle.isOn == false then
    return
  end
  self.selectIndex = control.index
  local data = self.CurCopydatas[self.selectIndex]
  self.CurSingleCopydata = data
  self:refreshMiddleInfo(data)
end

function Instance_InstanceUI:refreshMiddleInfo(copyData)
  self:SetCopyAward(copyData)
  self:SetCopyEsxpend(copyData)
  local countKey = copyData.transferTable.countKey
  local count = RefreshData.GetInstanceCount(countKey)
  self.lab_count1:SetText(string.format("%d l\225\186\167n", count))
  if 0 < count then
    self.btn_get1:SetActive(false)
  else
    self.btn_get1:SetActive(true)
  end
end

function Instance_InstanceUI:SetCopyAward(copyData)
  local tabReward = string.split(copyData.instanceTbl.rewards, "&")
  local childCount = self.grid.transform.childCount
  local obj
  if childCount > #tabReward then
    for index = #tabReward, childCount - 1 do
      obj = self.grid.transform:GetChild(index).gameObject
      obj:SetActive(false)
    end
  end
  for index = 1, #tabReward do
    if index > childCount then
      obj = Instantiate(self.grid.transform:GetChild(0).gameObject)
      obj.transform:SetParent(self.grid.transform, false)
    else
      obj = self.grid.transform:GetChild(index - 1).gameObject
    end
    obj:SetActive(true)
    obj = UIControl(obj.transform)
    local rewardtbl = string.split(tabReward[index], "#")
    local rewardid = tonumber(rewardtbl[1])
    local rewardCount = tonumber(rewardtbl[2])
    local itemData = ItemUtility.GenerateItemData(rewardid)
    itemData.count = rewardCount
    ItemUtility.ShowItem(self, obj, itemData, true)
  end
end

function Instance_InstanceUI:SetCopyEsxpend(copyData)
  local tabReward = string.split(copyData.transferTable.cost, "&")
  local rewardtbl = string.split(tabReward[1], "#")
  local rewardid = tonumber(rewardtbl[1])
  local rewardCount = tonumber(rewardtbl[2])
  local itemData = ItemUtility.GenerateItemData(rewardid)
  itemData.count = rewardCount
  local count = BagInfoData.GetItemCountByItemConfigId(itemData.itemId)
  if rewardCount <= count then
    self.lab_consumeCount:SetText(string.GetColorText(string.format("%d/%d", count, rewardCount), ItemQuality2ColorDic[5]))
  else
    self.lab_consumeCount:SetText(string.GetColorText(string.format("%d/%d", count, rewardCount), ItemQuality2ColorDic[7]))
  end
  ItemUtility.ShowItem(self, self.img_itemicon, itemData, true)
end
