Equip_Redemption = class(BaseUI)
Equip_Redemption.layer = UILayer.Panel
Equip_Redemption.orderInLayer = 10
Equip_Redemption.hideType = UIHideType.Hide
Equip_Redemption.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_Redemption.escClose = UIEscClose.DontClose

function Equip_Redemption:InitControls()
  self.bg_equip = self:GetControl("bg_equip")
  self.btn_close = self:GetControl("bg_equip/btn_close")
  self.tog_equipGet = self:GetControl("Content/tog_equipGet")
  self.tog_equipLose = self:GetControl("Content/tog_equipLose")
  self.equipLostBtn = self:GetControl("equipLostBtn")
  self.equipGetBtn = self:GetControl("equipGetBtn")
  self.equipGet = self:GetControl("equipGet")
  self.equipLose = self:GetControl("equipLose")
end

function Equip_Redemption:OnPreLoad()
end

function Equip_Redemption:Init()
end

function Equip_Redemption:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_Redemption:InitUI()
  self:CreateEquipGetTableView()
  self:CreateEquipLostTableView()
end

function Equip_Redemption:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_Redemption:OnHide()
  self.tog_equipGet:SetIsOn(true)
  self.equipGetTableView:UnloadAllCells()
  self.equipLostTableView:UnloadAllCells()
end

function Equip_Redemption:OnDestroy()
end

function Equip_Redemption:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.tog_equipGet:SetOnToggleChanged(self, self.EquipOnClick)
  self.tog_equipLose:SetOnToggleChanged(self, self.EquipOnClick)
end

function Equip_Redemption:EquipOnClick(control)
  if not control:GetIsOn() then
    return
  end
  self.equipGet:SetActive(self.tog_equipGet:GetIsOn())
  self.equipLose:SetActive(self.tog_equipLose:GetIsOn())
  self:RefreshEquipRedemption()
end

function Equip_Redemption:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_Redemption)
end

function Equip_Redemption:RegistEvents()
  self:RegistEvent(Event.EquipRedemptionRefresh, self.RefreshEquipRedemption, self)
end

function Equip_Redemption:RefreshEquipRedemption()
  if self.tog_equipGet:GetIsOn() then
    self.equipGetTableView:ReloadData()
  else
    self.equipLostTableView:ReloadData()
  end
end

function Equip_Redemption:Refresh()
  EquipRedemptionData.Reset()
  self.equipGetTableView:ReloadData(1)
  self.equipLostTableView:ReloadData(1)
  NetManager.Send(EquipRansomMessage.ReqGetEquipRansomInfo)
end

function Equip_Redemption:CreateEquipGetTableView()
  self.equipGetTableView = UITableView()
  self.equipGetTableView:SetLowerMargin(0)
  self.equipGetTableView:SetScrollView(self.equipGet)
  self.equipGetTableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView1)
  self.equipGetTableView:SetResetCellCallback(self, self.ResetTimer)
  self.equipGetTableView:SetUpperMargin(0)
  self.equipGetTableView:SetTotalCellCount(self, self.NumberOfCellsInTableView1)
  self.equipGetTableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView1)
  self.equipGetTableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear1)
  self.equipGetTableView:ReloadData(1)
end

function Equip_Redemption:ScalarForCellInTableView1()
  local _, sizeY = self.equipGetBtn:GetSizeDelta()
  return sizeY
end

function Equip_Redemption:NumberOfCellsInTableView1()
  local count = #EquipRedemptionData.GetEquipGetUnOverTime()
  return count
end

function Equip_Redemption:CellAtIndexInTableView1()
  return self.equipGetTableView:ReuseOrCreateCell(self.equipGetBtn)
end

function Equip_Redemption:ResetTimer(cell)
  if cell.countDownTime then
    Timer.Stop(cell.countDownTime)
    cell.countDownTime = nil
  end
end

function Equip_Redemption:CellAtIndexInTableViewWillAppear1(index)
  local cell = self.equipGetTableView:GetLoadedCell(index)
  local btnGet = cell:GetChild("btnGet")
  local equipItem1 = cell:GetChild("equipItem")
  local redeemBuy = cell:GetChild("redeemBuy/buyItem")
  local time = cell:GetChild("time")
  local equipGetData = EquipRedemptionData.equipGetUnOverTimeData[index]
  if not cell.equipCtr then
    cell.equipCtr = ItemUtility.InitItemCell(equipItem1)
    cell.equipModelData = ItemCellData()
  end
  local equipData = EquipData(equipGetData.equip)
  cell.equipModelData:RefreshData(equipData)
  ItemUtility.ShowItemCell(cell.equipCtr, cell.equipModelData, self, true)
  if not cell.coinCtr then
    cell.coinCtr = ItemUtility.InitItemCell(redeemBuy)
    cell.coinModelData = ItemCellData()
  end
  local itemData = ItemUtility.GenerateItemData(1000020)
  itemData.count = equipGetData.money
  cell.coinModelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(cell.coinCtr, cell.coinModelData, self, true)
  btnGet.id = equipGetData.equip.id
  btnGet.coinCount = equipGetData.money
  btnGet.name = equipData.tblItem.name
  btnGet:SetOnClick(self, self.EquipGetOnClick)
  if cell.countDownTime then
    Timer.Stop(cell.countDownTime)
    cell.countDownTime = nil
  end
  local overTime = Mathf.Floor(equipGetData.overTime / 1000)
  local intervalTime = overTime - Time.GetServerSecondTime()
  time:SetText(TimeUtility.ShowTimeWithColon(intervalTime))
  
  local function CountdownTime()
    overTime = Mathf.Floor(equipGetData.overTime / 1000)
    intervalTime = overTime - Time.GetServerSecondTime()
    time:SetText(TimeUtility.ShowTimeWithColon(intervalTime))
    if Time.GetServerSecondTime() >= overTime then
      Timer.Stop(cell.countDownTime)
      cell.countDownTime = nil
      self.equipGetTableView:ReloadData()
    end
  end
  
  cell.countDownTime = Timer.StartLoopForever(1, CountdownTime)
end

function Equip_Redemption:EquipGetOnClick(control)
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = string.format("C\195\179 t\225\187\145n %s Xu K\225\187\179 T\195\173ch\nchu\225\187\153c l\225\186\161i trang b\225\187\139 -%s kh\195\180ng", control.coinCount, control.name),
    okText = "X\195\161c nh\225\186\173n",
    ok = function()
      NetManager.Send(EquipRansomMessage.ReqRansomEquip, {
        itemId = control.id,
        type = 1
      })
    end
  })
end

function Equip_Redemption:CreateEquipLostTableView()
  self.equipLostTableView = UITableView()
  self.equipLostTableView:SetLowerMargin(0)
  self.equipLostTableView:SetScrollView(self.equipLose)
  self.equipLostTableView:SetResetCellCallback(self, self.ResetTimer)
  self.equipLostTableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView2)
  self.equipLostTableView:SetUpperMargin(0)
  self.equipLostTableView:SetTotalCellCount(self, self.NumberOfCellsInTableView2)
  self.equipLostTableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView2)
  self.equipLostTableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear2)
  self.equipLostTableView:ReloadData(1)
end

function Equip_Redemption:ScalarForCellInTableView2()
  local _, sizeY = self.equipLostBtn:GetSizeDelta()
  return sizeY
end

function Equip_Redemption:NumberOfCellsInTableView2()
  return #EquipRedemptionData.GetEquipLostUnOverTime()
end

function Equip_Redemption:CellAtIndexInTableView2()
  return self.equipLostTableView:ReuseOrCreateCell(self.equipLostBtn)
end

function Equip_Redemption:CellAtIndexInTableViewWillAppear2(index)
  local cell = self.equipLostTableView:GetLoadedCell(index)
  local btnGet = cell:GetChild("btnGet")
  local equipItem1 = cell:GetChild("equipItem")
  local redeemBuy = cell:GetChild("redeemBuy/buyItem")
  local time = cell:GetChild("time")
  local lab_name = cell:GetChild("lab_name")
  local equipGetData = EquipRedemptionData.equipGetUnOverTimeData[index]
  lab_name:SetText(equipGetData.roleName)
  if not cell.equipCtr then
    cell.equipCtr = ItemUtility.InitItemCell(equipItem1)
    cell.equipModelData = ItemCellData()
  end
  local equipData = EquipData(equipGetData.equip)
  cell.equipModelData:RefreshData(equipData)
  ItemUtility.ShowItemCell(cell.equipCtr, cell.equipModelData, self, true)
  if not cell.coinCtr then
    cell.coinCtr = ItemUtility.InitItemCell(redeemBuy)
    cell.coinModelData = ItemCellData()
  end
  local itemData = ItemUtility.GenerateItemData(1000020)
  itemData.count = equipGetData.money
  cell.coinModelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(cell.coinCtr, cell.coinModelData, self, true)
  btnGet.id = equipGetData.equip.id
  btnGet:SetOnClick(self, self.EquipLostOnClick)
  if cell.countDownTime then
    Timer.Stop(cell.countDownTime)
    cell.countDownTime = nil
  end
  local overTime = Mathf.Floor(equipGetData.overTime / 1000)
  local intervalTime = overTime - Time.GetServerSecondTime()
  time:SetText(TimeUtility.ShowTimeWithColon(intervalTime))
  
  local function CountdownTime()
    overTime = Mathf.Floor(equipGetData.overTime / 1000)
    intervalTime = overTime - Time.GetServerSecondTime()
    time:SetText(TimeUtility.ShowTimeWithColon(intervalTime))
    if Time.GetServerSecondTime() >= overTime then
      Timer.Stop(cell.countDownTime)
      cell.countDownTime = nil
      self.equipGetTableView:ReloadData()
    end
  end
  
  cell.countDownTime = Timer.StartLoopForever(1, CountdownTime)
end

function Equip_Redemption:EquipLostOnClick(control)
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = "X\195\161c nh\225\186\173n tr\225\186\163 trang b\225\187\139 n\195\160y cho \196\145\225\187\145i ph\198\176\198\161ng kh\195\180ng",
    okText = "X\195\161c nh\225\186\173n",
    ok = function()
      NetManager.Send(EquipRansomMessage.ReqRansomEquip, {
        itemId = control.id,
        type = 2
      })
    end
  })
end
