Equip_OrnamentsBreachUI = class(BaseUI)
Equip_OrnamentsBreachUI.layer = UILayer.Tip
Equip_OrnamentsBreachUI.orderInLayer = 1
Equip_OrnamentsBreachUI.hideType = UIHideType.WaitDestroy
Equip_OrnamentsBreachUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_OrnamentsBreachUI.escClose = UIEscClose.DontClose

function Equip_OrnamentsBreachUI:InitControls()
  self.bg_ornamentsBreach = self:GetControl("bg_ornamentsBreach")
  self.btn_close = self:GetControl("bg_ornamentsBreach/btn_close")
  self.btn_bg = self:GetControl("btn_bg")
  self.sw_attributeBreach = self:GetControl("sw_attributeBreach")
  self.lab_attributeItem = self:GetControl("sw_attributeBreach/Viewport/Content/lab_attributeItem")
  self.tx_level = self:GetControl("tx_level")
  self.lab_level = self:GetControl("tx_level/lab_level")
  self.lab_material = self:GetControl("lab_material")
  self.frame_item = self:GetControl("lab_material/frame_item")
  self.lab_levelMax = self:GetControl("lab_levelMax")
  self.btn_breach = self:GetControl("btn_breach")
end

function Equip_OrnamentsBreachUI:OnPreLoad()
end

function Equip_OrnamentsBreachUI:Init()
end

function Equip_OrnamentsBreachUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_OrnamentsBreachUI:InitUI()
  self.lab_attributeItemTemp = UIContainer(self.lab_attributeItem)
  self.NeedMaterials = {}
  table.insert(self.NeedMaterials, self.frame_item)
end

function Equip_OrnamentsBreachUI:OnShow()
  self.equipData = self.args.equipData
  self.curLevel = self.args.curLevel
  self:RegistEvents()
  self:Refresh()
end

function Equip_OrnamentsBreachUI:OnHide()
  if self.itemCellData then
    self.itemCellData:RecycleRes()
    self.itemCellData = nil
  end
end

function Equip_OrnamentsBreachUI:OnDestroy()
end

function Equip_OrnamentsBreachUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.frame_item:SetOnClick(self, self.frame_itemOnClick)
  self.btn_breach:SetOnClick(self, self.btn_breachOnClick)
  self.btn_bg:SetOnClick(self, self.btn_closeOnClick)
end

function Equip_OrnamentsBreachUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_OrnamentsBreachUI)
end

function Equip_OrnamentsBreachUI:frame_itemOnClick(control)
end

function Equip_OrnamentsBreachUI:btn_breachOnClick(control)
  if not self.isEnoughLevel then
    FloatingWordUtility.QuickMsg("C\225\186\165p kh\195\180ng \196\145\225\187\167")
    return
  end
  if self:IsMeetCondition() then
    local equipId = self.equipData.id
    self.isShowEffect = true
    MeEquipController.ReqEquipBreach(equipId)
  end
end

function Equip_OrnamentsBreachUI:IsMeetCondition()
  local costStr = self.breachTable.breachCost
  local itemTbl = string.split(costStr, "#")
  local id = tonumber(itemTbl[1])
  local itemData = ItemUtility.GenerateItemData(id)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
  if not string.isNullOrEmpty(self.breachTable.currencyCost) then
    local nId = tonumber(string.split(self.breachTable.currencyCost, "#")[1])
    bagCount = bagCount + BagInfoData.GetItemTotalCountByItemId(nId)
  end
  local isShow = bagCount < tonumber(itemTbl[2])
  if isShow then
    local temp = {}
    temp.itemData = itemData
    UIManager.Show(UIID.ItemTipUI, {
      item = temp.itemData,
      rightOperate = EItemOperateType.Show,
      ctrl = temp,
      ShowObtain = true
    })
    return false
  end
  return true
end

function Equip_OrnamentsBreachUI:RegistEvents()
  self:RegistEvent(Event.EquipAttriUpdate, self.EquipAttriUpdate, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.SetBreachCost, self)
end

function Equip_OrnamentsBreachUI:Refresh()
  self:NewSetAttributeInfo()
  self:SetBreachCost()
  self:GetBreachRedPointActive()
end

function Equip_OrnamentsBreachUI:NewSetAttributeInfo()
  if self.equipData then
    self.sw_attributeBreach:GetChild("Viewport/Content").transform.anchoredPosition = Vector2(0, 0)
    local lastBreachTable = MeEquipController.GetEquipBreachCfg(self.equipData.tblItem.subType, self.equipData.breach + 1 or 0)
    self.btn_breach:SetActive(lastBreachTable)
    self.lab_material:SetActive(lastBreachTable)
    self.tx_level:SetActive(lastBreachTable)
    self.lab_levelMax:SetActive(not lastBreachTable)
    self.breachAllTable = MeEquipController.GetOrnamentsAllBreach(self.equipData.tblItem.subType, self.equipData.breach or 0)
    self.breachTable = MeEquipController.GetEquipBreachCfg(self.equipData.tblItem.subType, self.equipData.breach or 0)
    if not self.breachTable and not self.breachAllTable then
      return
    end
    self.lab_attributeItemTemp:SetMaxCount(table.count(self.breachAllTable))
    local posIndex
    for i = 1, table.count(self.breachAllTable) do
      local obj = self.lab_attributeItemTemp:GetOrCreateItem(i)
      local nameStr = RoleEquipUtility.GetExcellenceShowById(self.breachAllTable[i].excellentId)
      local nextLevel = self.breachTable.level
      local activateState
      if nextLevel >= self.breachAllTable[i].level then
        activateState = true
      else
        if nextLevel < self.breachAllTable[i].level and i == 1 or nextLevel < self.breachAllTable[i].level and nextLevel >= self.breachAllTable[i - 1].level then
          posIndex = i
        end
        activateState = false
      end
      local cfgBreach = MeEquipController.GetEquipBreachCfg(self.breachAllTable[i].type, self.breachAllTable[i].level - 1 or 0)
      self:SetAttribute(cfgBreach.exp, activateState, obj, nameStr)
    end
    self.lab_attributeItemTemp:Refresh()
    local _, height = self.lab_attributeItem:GetSizeDelta()
    if posIndex and 2 < posIndex then
      local offset = 41 * (posIndex - 3) + 30.5
      if 8 < posIndex then
        offset = 233
      end
      self.sw_attributeBreach:GetChild("Viewport/Content").transform.anchoredPosition = Vector2(0, offset)
    else
      self.sw_attributeBreach:GetChild("Viewport/Content").transform.anchoredPosition = Vector2(0, 0)
    end
  end
end

function Equip_OrnamentsBreachUI:SetAttribute(nextLevel, state, obj, attributeStr)
  local level
  local labName = obj:GetChild("labName")
  local labState = obj:GetChild("labState")
  if state then
    attributeStr = string.GetColorText(attributeStr, "#2BBDFF")
    level = ""
  else
    attributeStr = string.GetColorText(attributeStr, "#666666")
    if nextLevel <= self.equipData.level then
      level = "C\195\179 th\225\187\131 k\195\173ch ho\225\186\161t"
      level = string.GetColorText(level, "#00FF00")
    else
      level = nextLevel .. " c\225\186\165p c\195\179 th\225\187\131 k\195\173ch ho\225\186\161t"
      level = string.GetColorText(level, "#FF0F00")
    end
  end
  labName:SetText(attributeStr)
  labState:SetText(level)
end

function Equip_OrnamentsBreachUI:SetBreachCost()
  local costStr = self.breachTable.breachCost
  local cost = string.split(costStr, "&")
  for i = 1, table.count(self.NeedMaterials) do
    local obj = self.NeedMaterials[i]
    if i <= table.count(cost) then
      local itemTbl = string.split(cost[i], "#")
      local id = tonumber(itemTbl[1])
      local itemData = ItemUtility.GenerateItemData(id)
      if not self.itemCellData then
        self.itemCellData = ItemCellData()
      end
      self.itemCellData:RefreshData(itemData)
      ItemUtility.ShowItemCell(obj, self.itemCellData, self, true)
      obj:SetActive(true)
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      if not string.isNullOrEmpty(self.breachTable.currencyCost) then
        local nId = tonumber(string.split(self.breachTable.currencyCost, "#")[1])
        bagCount = bagCount + BagInfoData.GetItemTotalCountByItemId(nId)
      end
      local strColor = bagCount >= tonumber(itemTbl[2]) and "#00FF00" or "#FF0000"
      local countStr = string.format("%s%s", string.GetColorText(bagCount, strColor), string.GetColorText(string.format("/%s", itemTbl[2]), ItemQuality2ColorDic[EItemColorEnum.white]))
      obj.countCtr:SetText(countStr)
      obj.countCtr:SetActive(true)
      local btn_get = obj:GetChild("btn_obtain")
      btn_get.itemData = itemData
      btn_get:SetOnClick(self, self.BtnObtainOnClick)
      self.isEnoughCost = bagCount >= tonumber(itemTbl[2])
    else
      obj:SetActive(false)
    end
  end
  self.isEnoughLevel = self.curLevel >= self.breachTable.exp
  local tempStr = self.curLevel .. "/" .. self.breachTable.exp
  local strColor = self.curLevel >= self.breachTable.exp and "#00FF00" or "#FF0000"
  self.lab_level:SetText(string.GetColorText(tempStr, strColor))
end

function Equip_OrnamentsBreachUI:EquipAttriUpdate(id, msg)
  if msg and self.isShowEffect then
    self.isShowEffect = false
    self.equipData = msg
    local GrowUpTable = MeEquipController.GetEquipGrowUpCfg(self.equipData.tblItem.subType, self.equipData.level or 0)
    self.curLevel = GrowUpTable.level
    self:Refresh()
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_Breachchenggong",
        time = 1
      })
    else
      UIManager.Show(UIID.EffectTipUI, {
        name = "Eff_UI_Breachchenggong",
        effectTime = 1
      })
    end
    EventManager.Dispatch(Event.EquipBreachSucceed, msg)
  end
end

function Equip_OrnamentsBreachUI:BtnObtainOnClick(control)
  UIManager.Show(UIID.ItemTipUI, {
    item = control.itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control,
    ShowObtain = true
  })
end

function Equip_OrnamentsBreachUI:GetBreachRedPointActive()
  self.btn_breach:GetChild("img_redPoint"):SetActive(self.isEnoughLevel and self.isEnoughCost)
end

function Equip_OrnamentsBreachUI:GetEquipBreachCost(special, normal)
  local cost = string.split(special, "&")
  local isSpEnough = true
  local isHave = false
  for i = 1, table.count(cost) do
    local itemTbl = string.split(cost[i], "#")
    local id = tonumber(itemTbl[1])
    local count = tonumber(itemTbl[2])
    local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
    if count > bagCount then
      isSpEnough = false
    end
    if 0 < bagCount then
      isHave = true
    end
  end
  cost = string.split(normal, "&")
  if not isHave then
    for i = 1, table.count(cost) do
      local itemTbl = string.split(cost[i], "#")
      local id = tonumber(itemTbl[1])
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      if 0 < bagCount then
        return normal
      end
    end
  elseif not isSpEnough then
    local norEnough = true
    for i = 1, table.count(cost) do
      local itemTbl = string.split(cost[i], "#")
      local id = tonumber(itemTbl[1])
      local count = tonumber(itemTbl[2])
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      if count > bagCount then
        norEnough = false
      end
    end
    if norEnough then
      return normal
    end
  end
  return special
end
