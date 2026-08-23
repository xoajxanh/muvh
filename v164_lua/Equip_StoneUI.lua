Equip_StoneUI = class(BaseUI)
Equip_StoneUI.layer = UILayer.Panel
Equip_StoneUI.orderInLayer = 1
Equip_StoneUI.hideType = UIHideType.WaitDestroy
Equip_StoneUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_StoneUI.escClose = UIEscClose.DontClose

function Equip_StoneUI:InitControls()
  self.bg_equip = self:GetControl("bg_equip")
  self.btn_close = self:GetControl("bg_equip/btn_close")
  self.btn_weapen = self:GetControl("bg_equip/go_weapen/btn_weapen")
  self.img_add_weapen = self:GetControl("bg_equip/go_weapen/img_add_weapen")
  self.btn_3DItem = self:GetControl("bg_equip/go_weapen/btn_3DItem")
  self.txt_add_weapen = self:GetControl("bg_equip/go_weapen/txt_add_weapen")
  self.btn_ItemOne = self:GetControl("bg_equip/go_stoneCell/btn_ItemOne")
  self.btn_ItemTwo = self:GetControl("bg_equip/go_stoneCell/btn_ItemTwo")
  self.btn_ItemThree = self:GetControl("bg_equip/go_stoneCell/btn_ItemThree")
  self.lab_stone_one = self:GetControl("bg_equip/three_stone/three_content/lab_stone_one")
  self.lab_stone_two = self:GetControl("bg_equip/three_stone/three_content/lab_stone_two")
  self.lab_stone_three = self:GetControl("bg_equip/three_stone/three_content/lab_stone_three")
  self.all_stone = self:GetControl("bg_equip/all_stone")
  self.all_content = self:GetControl("bg_equip/all_stone/Viewport/all_content")
  self.lab_stoneAdd = self:GetControl("bg_equip/all_stone/Viewport/all_content/lab_stoneAdd")
  self.Img_noWearEquip = self:GetControl("Img_noWearEquip")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.descBtn = self:GetControl("descBtn")
  self.lab_equip = self:GetControl("bg_equip/lab_equip")
  self.unlockSlotPanel = self:GetControl("bg_equip/unlockSlotPanel")
  self.resetPointPanelClose = self:GetControl("bg_equip/unlockSlotPanel/resetPointPanelClose")
  self.btn_resetPointPanelClose = self:GetControl("bg_equip/unlockSlotPanel/btn_resetPointPanelClose")
  self.btn_get = self:GetControl("bg_equip/unlockSlotPanel/lab_price/btn_get")
  self.consumeItem = self:GetControl("bg_equip/unlockSlotPanel/lab_price/consumeItem")
  self.lab_priceValue = self:GetControl("bg_equip/unlockSlotPanel/lab_price/lab_priceValue")
  self.btn_confirm = self:GetControl("bg_equip/unlockSlotPanel/btn_confirm")
end

function Equip_StoneUI:Init()
  self.stoneCellIndexs = {}
  self.cellData = {}
  self.equipCellData = nil
  self:StoneAttributeDataInit()
  self.attributeType = {
    [EItemType.FireGem] = "minimumPhysBaseDmg",
    [EItemType.IceGem] = "minimumPhysBaseDmg",
    [EItemType.WindGem] = "defenseBase",
    [EItemType.WaterGem] = "maximumHealth"
  }
end

function Equip_StoneUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnItemInit()
end

local function OnItemRefresh(ctr, i, data, ui)
  local strColor
  if ui.attributeData.IsShow[i] then
    strColor = ItemQuality2ColorDic[EItemColorEnum.white]
    ctr:GetChild("txt_tip"):SetActive(true)
    ctr:GetChild("btn_Breach"):SetActive(false)
  else
    strColor = ItemQuality2ColorDic[EItemColorEnum.dark]
    ctr:GetChild("txt_tip"):SetActive(false)
    ctr:GetChild("btn_Breach"):SetActive(true)
  end
  ctr:GetChild("lab_name_water"):SetText(string.GetColorText(string.format("T\225\187\149ng c\225\186\165p %s c\225\186\165p %d", data.name, data.level), strColor))
  ctr:GetChild("lab_des_water"):SetText(string.GetColorText(data.word, strColor))
end

function Equip_StoneUI:InitUI()
  self.stoneCellObj = {
    self.btn_ItemOne,
    self.btn_ItemTwo,
    self.btn_ItemThree
  }
  self.stoneCellInfo = {
    self.lab_stone_one,
    self.lab_stone_two,
    self.lab_stone_three
  }
  for i = 1, table.count(self.stoneCellObj) do
    ItemUtility.InitItemCell(self.stoneCellObj[i])
  end
  self.itemAttributeContainer = UIContainer(self.lab_stoneAdd, self, OnItemInit, OnItemRefresh)
  self:InitRedPointGo()
end

function Equip_StoneUI:OnShow()
  EquipeInfoData.curView = UIID.Equip_StoneUI
  networkRequest.ReqLightStoneCellState()
  self:RegistEvents()
  self:Refresh()
end

function Equip_StoneUI:Refresh()
  self.stoneData = ViewData.meData.equipsData.RealStoneData
  EventManager.Dispatch(Event.EquipForgeUIChange)
end

function Equip_StoneUI:OnHide()
  EquipeInfoData.curView = nil
  if self.equipCellData then
    self.equipCellData:RecycleRes()
    self.equipCellData = nil
  end
  for i = 1, table.count(self.stoneCellObj) do
    if self.cellData[i] then
      self.cellData[i]:RecycleRes()
    end
  end
  self.cellData = {}
end

function Equip_StoneUI:OnDestroy()
end

function Equip_StoneUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_3DItem:SetOnClick(self, self.BtnEquipItemOnClick)
  self.resetPointPanelClose:SetOnClick(self, self.btn_CloseTipsPanelOnClick)
  self.btn_resetPointPanelClose:SetOnClick(self, self.btn_CloseTipsPanelOnClick)
  self.btn_confirm:SetOnClick(self, self.btn_OpenLightStonePosition)
  for i = 1, table.count(self.stoneCellObj) do
    self.stoneCellObj[i].index = i
    self.stoneCellObj[i]:SetOnClick(self, self.StoneCellOnClick)
  end
end

function Equip_StoneUI:BtnEquipItemOnClick(control)
  if not UIManager.IsVisible(UIID.Bag_EquipInfoUI) then
    UIManager.Show(UIID.Bag_EquipInfoUI)
  elseif self.curSelectEquip then
    UIManager.Show(UIID.ItemTipUI, {
      item = self.curSelectEquip,
      rightOperate = EItemOperateType.Show
    })
  end
end

function Equip_StoneUI:StoneCellOnClick(control)
  if not self.curSelectEquip then
    return
  end
  if not UIManager.IsVisible(UIID.NewBagInfoUI) then
    UIManager.Show(UIID.NewBagInfoUI)
  end
  if control.index ~= self.curCellObjIndex then
    if self.curCellObjIndex then
      self.stoneCellObj[self.curCellObjIndex].selectImageCtr:SetActive(false)
    end
    self.curCellObjIndex = control.index
    control.selectImageCtr:SetActive(true)
  elseif not self.stoneCellObj[self.curCellObjIndex].selectImageCtr:GetActive() then
    self.stoneCellObj[self.curCellObjIndex].selectImageCtr:SetActive(true)
  end
  local stoneIndex = self.curSelectbagGridIndex * 100 + self.curCellObjIndex
  if control.index > 1 then
    local cellInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetInlayBagDataMgr():GetCellInfoByStoneIndex(stoneIndex)
    if cellInfo and cellInfo.state == 0 then
      self:OpenUnlockSlotPanel(true)
      return
    end
  end
  if self.stoneData[stoneIndex] then
    UIManager.Show(UIID.ItemTipUI, {
      item = self.stoneData[stoneIndex],
      rightOperate = EItemOperateType.AddEquip,
      isPutOn = false
    })
  end
end

function Equip_StoneUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_ForgeNavUi)
end

function Equip_StoneUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_StoneUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_StoneUI:btn_CloseTipsPanelOnClick(control)
  self.unlockSlotPanel:SetActive(false)
end

function Equip_StoneUI:btn_OpenLightStonePosition(control)
  local stoneIndex = self.curSelectbagGridIndex * 100 + self.curCellObjIndex
  local cfg_EquipCell = ClientTable.cfg_EquipCell_cellManager:TryGetValue(stoneIndex)
  local costCount = 0
  local haveCount = 0
  if cfg_EquipCell and type(cfg_EquipCell.cost) == "table" and table.count(cfg_EquipCell.cost) >= 2 then
    local itemId = tonumber(cfg_EquipCell.cost[1])
    costCount = tonumber(cfg_EquipCell.cost[2])
    haveCount = BagInfoData.GetItemTotalCountByItemId(itemId)
  end
  if costCount <= haveCount then
    networkRequest.ReqUnlockLightStone(stoneIndex)
  else
    ItemUtility.ClickObtainItemBtn(nil, self.btn_get)
  end
end

function Equip_StoneUI:RegistEvents()
  self:RegistEvent(Event.SelectedForgeEquip, self.SelectedForgeEquip, self)
  self:RegistEvent(Event.PutOnEquip, self.PutOnEquipFunc, self)
  self:RegistEvent(Event.TakeOffEquip, self.TakeOffEquipFunc, self)
  self:RegistEvent(Event.Equip_PutOnStone, self.PutOnStoneSend, self)
  self:RegistEvent(Event.Equip_TakeOffStone, self.TakeOffStoneSend, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
  self:RegistEvent(Event.Equip_StonePosChange, self.OnEquipStonePosChange, self)
  self:RegistEvent(Event.InlayCodeStateChanged, self.OnInlayCodeStateChanged, self)
end

function Equip_StoneUI:SelectedForgeEquip(id, args)
  local equipData = args[1]
  if not equipData then
    self.Img_noWearEquip:SetActive(true)
    self.img_add_weapen:SetActive(true)
  end
  self.Img_noWearEquip:SetActive(false)
  self.img_add_weapen:SetActive(false)
  self.tagType = 0
  self.curSelectEquip = equipData
  self.curSelectbagGridIndex = args[2]
  self.excellence = equipData and equipData.excellence or nil
  self:SetStoneCell()
  self:LoadEquipModel()
  self:SetStoneInfo()
  self:SetStoneAttribute()
  self:RefreshAllRedPoint()
end

function Equip_StoneUI:PutOnEquipFunc(id, msg)
  if table.contains(self.stoneCellIndexs, msg.bagGridIndex) then
    Coroutine.Start(function()
      Coroutine.Wait(0.2)
      local stone = RoleManager.me.data.equipsData:UpdateStoneData(msg)
      local index = msg.bagGridIndex % 100
      if not self.cellData[index] then
        self.cellData[index] = ItemCellData()
      end
      self.cellData[index]:RefreshData(stone)
      ItemUtility.ShowItemCell(self.stoneCellObj[index], self.cellData[index], self)
      self.stoneCellObj[index].countCtr:SetText(string.format("Lv.%d", stone.tblEquip.equipClass))
      self.stoneCellObj[index].countCtr:SetActive(true)
      self.stoneCellObj[index].selectImageCtr:SetActive(true)
      self.stoneCellObj[index].img_lock:SetActive(false)
      self.stoneCellObj[index].img_dw:SetActive(false)
      self:SetStoneInfo()
      self:SetStoneAttribute()
      EventManager.Dispatch(Event.Equip_ForgeStone, BagInfoData.TotalItems)
    end)
  end
end

function Equip_StoneUI:TakeOffEquipFunc(id, msg)
  if table.contains(self.stoneCellIndexs, msg.position) then
    RoleManager.me.data.equipsData:RemoveStoneEquip(msg.position)
    local index = msg.position % 100
    if self.cellData[index] and self.cellData[index].model then
      self.cellData[index]:RecycleRes()
    end
    self.cellData[index] = nil
    self.stoneCellObj[index].countCtr:SetActive(false)
    self.stoneCellObj[index].selectImageCtr:SetActive(true)
    if index == 1 then
      self.stoneCellObj[index].img_lock:SetActive(false)
      self.stoneCellObj[index].img_dw:SetActive(true)
    else
      local cellInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetInlayBagDataMgr():GetCellInfoByStoneIndex(msg.position)
      local isNoOpen = (cellInfo == nil or cellInfo.state == 0) and true or false
      self.stoneCellObj[index].img_lock:SetActive(isNoOpen)
      self.stoneCellObj[index].img_dw:SetActive(not isNoOpen)
    end
    self:SetStoneInfo()
    self:SetStoneAttribute()
    EventManager.Dispatch(Event.Equip_ForgeStone, BagInfoData.TotalItems)
  end
end

function Equip_StoneUI:LoadEquipModel()
  if not self.curSelectEquip then
    return
  end
  if not self.equipCellData then
    self.equipCellData = ItemCellData()
  end
  self.equipCellData:RefreshData(self.curSelectEquip)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.equipCellData, self)
end

function Equip_StoneUI:SetStoneCell()
  if not self.curSelectEquip then
    self.lab_equip:SetText("")
    for i = 1, table.count(self.stoneCellObj) do
      self.stoneCellObj[i].countCtr:SetActive(false)
      if self.cellData[i] then
        self.cellData[i]:RecycleRes()
      end
    end
    return
  end
  self.lab_equip:SetText(self.curSelectEquip.tblItem.name)
  self.stoneCellIndexs = {}
  local mInlayDataManager = gameMgr:GetAvatarManager():GetMainPlayer():GetInlayBagDataMgr()
  local isShowSelect = true
  for i = 1, table.count(self.stoneCellObj) do
    self.stoneCellObj[i].countCtr:SetActive(false)
    local stoneIndex = self.curSelectbagGridIndex * 100 + i
    table.insert(self.stoneCellIndexs, stoneIndex)
    if self.stoneData[stoneIndex] then
      if not self.cellData[i] then
        self.cellData[i] = ItemCellData()
      end
      self.cellData[i]:RefreshData(self.stoneData[stoneIndex])
      ItemUtility.ShowItemCell(self.stoneCellObj[i], self.cellData[i], self)
      self.stoneCellObj[i].countCtr:SetText(string.format("Lv.%d", self.stoneData[stoneIndex].tblEquip.equipClass))
      self.stoneCellObj[i].countCtr:SetActive(true)
      self.stoneCellObj[i].img_lock:SetActive(false)
      self.stoneCellObj[i].img_dw:SetActive(false)
    else
      if self.cellData[i] then
        self.cellData[i].itemData = nil
        ItemUtility.ShowItemCell(self.stoneCellObj[i], self.cellData[i], self)
        self.stoneCellObj[i].countCtr:SetActive(false)
      end
      if i == 1 then
        self.stoneCellObj[i].img_lock:SetActive(false)
        self.stoneCellObj[i].img_dw:SetActive(true)
      else
        local cellInfo = mInlayDataManager:GetCellInfoByStoneIndex(stoneIndex)
        local isNoOpen = (cellInfo == nil or cellInfo.state == 0) and true or false
        self.stoneCellObj[i].img_lock:SetActive(isNoOpen)
        self.stoneCellObj[i].img_dw:SetActive(not isNoOpen)
      end
    end
  end
end

function Equip_StoneUI:SetStoneInfo()
  if not self.curSelectEquip then
    for i = 1, table.count(self.stoneCellInfo) do
      local obj = UIControl(self.stoneCellInfo[i].transform)
      obj:SetActive(false)
    end
    return
  end
  for i = 1, table.count(self.stoneCellInfo) do
    local obj = UIControl(self.stoneCellInfo[i].transform)
    local data = self.stoneData[self.stoneCellIndexs[i]]
    if data then
      obj:GetChild("lab_name"):SetText(data.tblItem.name)
      local str = RoleEquipUtility.GetEquipStoneFirstAttri(data)
      local strTab = string.split(str, ":")
      local attr = string.GetColorText(strTab[2], "#52FF00")
      str = strTab[1] .. ":" .. attr
      obj:GetChild("lab_addition"):SetText(str)
      obj:SetActive(true)
    else
      obj:SetActive(false)
    end
  end
end

function Equip_StoneUI:SetStoneAttribute()
  local condition = ClientTable.cfg_Function_functionManager:TryGetValue(2040002, "id").condition
  local isOpen = ConditionManager.Check4D(condition)
  self.all_stone:SetActive(isOpen)
  if not isOpen then
    return
  end
  self.attributeData = {
    Data = {},
    IsShow = {}
  }
  self.attributeData.Data, self.attributeData.IsShow = self:GetStoneAttributeData()
  self.itemAttributeContainer:SetData(self.attributeData.Data)
end

function Equip_StoneUI:GetStoneAttributeData()
  if not self.curSelectEquip then
    return
  end
  local data = {}
  local rData = {}
  local show = {}
  for i, v in pairs(self.cfgData) do
    local totalLevel = 0
    for _, da in pairs(self.stoneData) do
      if da.tblItem.type == i then
        totalLevel = totalLevel + da.tblEquip.equipClass
      end
    end
    for k = 1, table.count(v) do
      if totalLevel < v[1].level then
        table.insert(data, v[1])
        table.insert(show, false)
        break
      elseif totalLevel >= v[table.count(v)].level then
        table.insert(data, v[table.count(v)])
        table.insert(show, true)
        break
      elseif totalLevel >= v[k].level and totalLevel < v[k + 1].level then
        table.insert(data, v[k])
        table.insert(show, true)
        break
      end
    end
  end
  local tShow = {}
  for i = 1, table.count(data) do
    if show[i] then
      table.insert(rData, data[i])
      table.insert(tShow, true)
    end
  end
  for i = 1, table.count(data) do
    if not show[i] then
      table.insert(rData, data[i])
      table.insert(tShow, false)
    end
  end
  return rData, tShow
end

function Equip_StoneUI:StoneAttributeDataInit()
  local Tab = ClientTable.cfg_item_stone_combinationManager:GetDic()
  self.cfgData = {}
  for i, v in pairs(Tab) do
    if not self.cfgData[v.type] then
      self.cfgData[v.type] = {}
      table.insert(self.cfgData[v.type], v)
    else
      table.insert(self.cfgData[v.type], v)
    end
  end
  for i, v in pairs(self.cfgData) do
    table.sort(v, function(a, b)
      return a.level < b.level
    end)
  end
end

function Equip_StoneUI:PutOnStoneSend(_, msg)
  local stoneIndex = self.curSelectbagGridIndex * 100 + self.curCellObjIndex
  MeEquipController.ReqPutOnTheEquip(stoneIndex, msg[1])
end

function Equip_StoneUI:TakeOffStoneSend()
  local stoneIndex = self.curSelectbagGridIndex * 100 + self.curCellObjIndex
  MeEquipController.ReqTakeOffTheEquip(stoneIndex)
end

function Equip_StoneUI:OnResBagChange(_, msg)
  self:OpenUnlockSlotPanel(false)
end

function Equip_StoneUI:OnEquipStonePosChange(_, msg)
  if self.curSelectbagGridIndex and self.curCellObjIndex then
    local stoneIndex = self.curSelectbagGridIndex * 100 + self.curCellObjIndex
    local cellInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetInlayBagDataMgr():GetCellInfoByStoneIndex(stoneIndex)
    if cellInfo and cellInfo.state == 1 then
      self:btn_CloseTipsPanelOnClick()
    end
  end
  self:SetStoneCell()
end

function Equip_StoneUI:OpenUnlockSlotPanel(_isChangePanel)
  if self.curCellObjIndex == nil then
    return
  end
  local stoneIndex = self.curSelectbagGridIndex * 100 + self.curCellObjIndex
  local cfg_EquipCell = ClientTable.cfg_EquipCell_cellManager:TryGetValue(stoneIndex)
  if type(cfg_EquipCell.cost) == "number" then
    return
  end
  if type(cfg_EquipCell.cost) == "table" and table.count(cfg_EquipCell.cost) < 2 then
    return
  end
  local itemId = tonumber(cfg_EquipCell.cost[1])
  local costCount = tonumber(cfg_EquipCell.cost[2])
  local haveCount = BagInfoData.GetItemTotalCountByItemId(itemId)
  if self.itemCellData == nil then
    self.itemCellData = ItemCellData()
  end
  local itemData = ItemUtility.GenerateItemData(itemId)
  itemData.count = ""
  self.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.consumeItem, self.itemCellData, self, true)
  self.btn_get.itemData = itemData
  self.btn_get.OpenTipsType = EOpenTipsType.FastBuy
  self.btn_get:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
  local costColorStr = costCount <= haveCount and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]
  local strDis = string.format("<color=%s>%d</color><color=#DCE1E5>/%d</color>", costColorStr, haveCount, costCount)
  self.lab_priceValue:SetText(strDis)
  if _isChangePanel then
    self.unlockSlotPanel:SetActive(true)
  end
end

function Equip_StoneUI:InlayRedPointMgr()
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer():GetInlayBagDataMgr() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetInlayBagDataMgr():GetRedPointMgr()
  end
  return nil
end

function Equip_StoneUI:InitRedPointGo()
  self.mRedPointGoTbl = {}
  for i, v in pairs(self.stoneCellObj) do
    if v and not IsNil(v.gameObject) then
      table.insert(self.mRedPointGoTbl, {
        go = v.transform:Find("img_redPoint").gameObject
      })
    end
  end
end

function Equip_StoneUI:OnInlayCodeStateChanged(msgId, _cellInfo)
  if self:InlayRedPointMgr() == nil or _cellInfo == nil then
    return
  end
  if self.curSelectbagGridIndex ~= _cellInfo.equipIndex then
    return
  end
  self:RefreshItemRedPoint(_cellInfo.inlayIndex)
end

function Equip_StoneUI:RefreshAllRedPoint()
  if self:InlayRedPointMgr() == nil then
    return
  end
  local state
  for i, v in pairs(self.stoneCellIndexs) do
    state = self:InlayRedPointMgr():IsShowRedPointByCell(v)
    if self.mRedPointGoTbl[i] and not IsNil(self.mRedPointGoTbl[i].go) and self.mRedPointGoTbl[i].go.activeSelf ~= state then
      self.mRedPointGoTbl[i].go:SetActive(state)
    end
  end
end

function Equip_StoneUI:RefreshItemRedPoint(_inlayIndex)
  for i, v in pairs(self.stoneCellIndexs) do
    if v == _inlayIndex then
      local state = self:InlayRedPointMgr():IsShowRedPointByCell(v)
      if self.mRedPointGoTbl[i] and not IsNil(self.mRedPointGoTbl[i].go) and self.mRedPointGoTbl[i].go.activeSelf ~= state then
        self.mRedPointGoTbl[i].go:SetActive(state)
      end
    end
  end
end
