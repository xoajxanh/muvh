Equip_OrnamentsUI = class(BaseUI)
Equip_OrnamentsUI.layer = UILayer.Panel
Equip_OrnamentsUI.orderInLayer = 1
Equip_OrnamentsUI.hideType = UIHideType.WaitDestroy
Equip_OrnamentsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_OrnamentsUI.escClose = UIEscClose.DontClose

function Equip_OrnamentsUI:InitControls()
  self.bg_ornaments = self:GetControl("bg_ornaments")
  self.img_jiantou = self:GetControl("bg_ornaments/img_shoushi_level/img_jiantou")
  self.img_intensifylevel = self:GetControl("bg_ornaments/img_shoushi_level/img_intensifylevel")
  self.img_intensifylevelnext = self:GetControl("bg_ornaments/img_shoushi_level/img_intensifylevelnext")
  self.tog_growUp = self:GetControl("go_toggle/tog_growUp")
  self.growUpCheckmark = self:GetControl("go_toggle/tog_growUp/Background/growUpCheckmark")
  self.tog_breach = self:GetControl("go_toggle/tog_breach")
  self.breachCheckmark = self:GetControl("go_toggle/tog_breach/Background/breachCheckmark")
  self.lab_itemName = self:GetControl("go_growUp/lab_itemName")
  self.frame_equip = self:GetControl("go_growUp/frame_equip")
  self.sw_attributeGrowUp = self:GetControl("go_growUp/sw_attributeGrowUp")
  self.text_atk = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_atk/text_atk")
  self.text_atknext = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_atk/text_atknext")
  self.text_atkimg = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_atk/text_atkimg")
  self.text_def = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_def/text_def")
  self.text_defnext = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_def/text_defnext")
  self.text_defimg = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_def/text_defimg")
  self.text_maxHp = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_maxHp/text_maxHp")
  self.text_maxHpnext = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_maxHp/text_maxHpnext")
  self.text_maxHpimg = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_maxHp/text_maxHpimg")
  self.text_maxHpMul = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_maxHpMul/text_maxHpMul")
  self.text_maxHpMulnext = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_maxHpMul/text_maxHpMulnext")
  self.text_maxHpMulimg = self:GetControl("go_growUp/sw_attributeGrowUp/Viewport/Content/lab_maxHpMul/text_maxHpMulimg")
  self.sw_attributeBreach = self:GetControl("go_growUp/sw_attributeBreach")
  self.lab_attributeItem = self:GetControl("go_growUp/sw_attributeBreach/Viewport/Content/lab_attributeItem")
  self.lab_item = self:GetControl("go_growUp/lab_item")
  self.btn_Item = self:GetControl("go_growUp/lab_item/sw_breachItem/Viewport/Content/btn_Item")
  self.btn_growUp = self:GetControl("go_growUp/btn_growUp")
  self.lab_growUp = self:GetControl("go_growUp/btn_growUp/lab_growUp")
  self.btn_breach = self:GetControl("go_growUp/btn_breach")
  self.lab_breach = self:GetControl("go_growUp/btn_breach/lab_breach")
  self.lab_level = self:GetControl("go_growUp/lab_level")
  self.text_level = self:GetControl("go_growUp/lab_level/text_level")
  self.lab_levelMax = self:GetControl("go_growUp/lab_levelMax")
  self.img_growMax = self:GetControl("go_growUp/img_growMax")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.btn_role = self:GetControl("panel_role/btn_role")
  self.btn_bag = self:GetControl("panel_bag/btn_bag")
  self.Img_noOrnaments = self:GetControl("Img_noOrnaments")
  self.btn_close = self:GetControl("btn_close")
  self.descBtn = self:GetControl("descBtn")
end

function Equip_OrnamentsUI:OnPreLoad()
end

local ECurPanelTagEnum = {tog_growUp = 1, tog_breach = 2}
local activateEnum = {
  noActivated = 1,
  ToActivated = 2,
  Activated = 3
}
local CanUpgradedEquipSubType = {
  EItemSubtype.Ring,
  EItemSubtype.Necklace,
  EItemSubtype.Earrings
}

function Equip_OrnamentsUI:Init()
  self.equipPool = {}
  self.curTagIndex = 1
end

function Equip_OrnamentsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_OrnamentsUI:InitUI()
  self.meData = ViewData.meData
  self.NeedMaterials = {
    self.btn_Item
  }
  self.AttributeInfoTab = {
    text_atk = "minimumPhysBaseDmg",
    text_def = "defenseBase",
    text_maxHp = "maximumHealth",
    text_maxHpMul = "maximumHealth_mul"
  }
  self.sw_attributeBreach:GetChild("Viewport/Content").layoutGroup.enabled = true
  self.lab_attributeItemTemp = UIContainer(self.lab_attributeItem)
end

function Equip_OrnamentsUI:OnShow()
  EquipeInfoData.curView = UIID.Equip_OrnamentsUI
  self:RegistEvents()
  self:Refresh()
end

function Equip_OrnamentsUI:OnHide()
  self:HideEquipObj()
  if UIManager.IsVisible(UIID.Equip_OrnamentsBreachUI) then
    UIManager.Hide(UIID.Equip_OrnamentsBreachUI)
  end
  EquipeInfoData.curView = nil
  if self.equipCellData then
    self.equipCellData:RecycleRes()
    self.equipCellData = nil
  end
  if self.itemCellData then
    self.itemCellData:RecycleRes()
    self.itemCellData = nil
  end
end

function Equip_OrnamentsUI:OnDestroy()
  self:DestroyEquipObj()
end

function Equip_OrnamentsUI:RegistUIEvents()
  self.frame_equip:SetOnClick(self, self.frame_equipOnClick)
  self.btn_growUp:SetOnClick(self, self.btn_growUpOnClick)
  self.btn_Item:SetOnClick(self, self.btn_ItemOnClick)
  self.btn_role:SetOnToggleChanged(self, self.BtnSelectTag)
  self.btn_bag:SetOnToggleChanged(self, self.BtnSelectTag)
  self.tog_breach:SetOnClick(self, self.BtnSelectOrnameTag)
  self.tog_growUp:SetOnClick(self, self.BtnSelectOrnameTag)
  self.btn_breach:SetOnClick(self, self.BtnSelectOrnameTag)
  self.btn_close:SetOnClick(self, function(control, eventData)
    UIManager.Hide(UIID.Equip_ForgeNavUi)
  end)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Equip_OrnamentsUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_OrnamentsUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_OrnamentsUI:frame_equipOnClick(control)
  if not self.EquipData then
    return
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = self.EquipData,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Equip_OrnamentsUI:btn_growUpOnClick(control)
  local equipId = self.EquipData.id
  if not self:IsMeetCondition() then
    return
  end
  self.isShowEffect = true
  MeEquipController.ReqEquipGrowUp(equipId)
end

function Equip_OrnamentsUI:btn_ItemOnClick(control)
end

function Equip_OrnamentsUI:btn_roleOnClick(control)
end

function Equip_OrnamentsUI:btn_bagOnClick(control)
end

function Equip_OrnamentsUI:btn_closeOnClick(control)
end

function Equip_OrnamentsUI:BtnSelectTag(control)
  if not control then
    return
  end
  if control.gameObject.name == "btn_role" then
    UIManager.Show(UIID.Bag_EquipInfoUI)
  elseif control.gameObject.name == "btn_bag" then
    UIManager.Show(UIID.NewBagInfoUI)
  end
end

function Equip_OrnamentsUI:BtnSelectOrnameTag(control)
  UIManager.Show(UIID.Equip_OrnamentsBreachUI, {
    equipData = self.EquipData,
    curLevel = self.GrowUpTable.level
  })
end

function Equip_OrnamentsUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_OrnamentsUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Equip_OrnamentsUI:RegistEvents()
  self:RegistEvent(Event.SelectedForgeEquip, self.SelectedStrengthenEquip, self)
  self:RegistEvent(Event.EquipAttriUpdate, self.EquipAttriUpdate, self)
  self:RegistEvent(Event.EquipBreachSucceed, self.EquipBreachUpdate, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
end

function Equip_OrnamentsUI:SelectedStrengthenEquip(id, msg)
  self.equipData = msg[1]
  if not (self.equipData and self.equipData.tblEquip) or self.equipData.tblEquip.growUp == 0 then
    if self.LoadEquipObject then
      local str = LocalizationUtility.GetContentByKey("OrnamentsError_1")
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = str
      })
    else
      self.Img_noOrnaments:SetActive(true)
      self.NeedMaterials[1]:SetActive(false)
    end
    return
  end
  self:HideEquipObj()
  self.NeedMaterials[1]:SetActive(true)
  self.Img_noOrnaments:SetActive(false)
  self:SetEquipIntensifyInfo(self.equipData, msg[2])
end

function Equip_OrnamentsUI:EquipAttriUpdate(id, msg)
  if msg and self.isShowEffect then
    self.isShowEffect = false
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_Ornamentchenggong",
        time = 1
      })
    else
      UIManager.Show(UIID.EffectTipUI, {
        name = "Eff_UI_Ornamentchenggong",
        effectTime = 1
      })
    end
    self.equipData = msg
    self:UpdateEquipIntensifyInfo(msg)
  end
end

function Equip_OrnamentsUI:EquipBreachUpdate(id, msg)
  if msg then
    self.equipData = msg
    self:UpdateEquipIntensifyInfo(msg)
    local breachTable = MeEquipController.GetEquipBreachCfg(msg.tblItem.subType, msg.breach)
    if self.equipCellData and not string.isNullOrEmpty(breachTable.model) and not string.contains(self.equipCellData.model.Path, breachTable.model) then
      self.equipCellData:RefreshData(msg)
      ItemUtility.ShowItemCell(self.frame_equip, self.equipCellData, self, true)
    end
  end
end

function Equip_OrnamentsUI:Refresh()
  local equipData = ViewData.meData.equipsData.Data
  if self.args and self.args.itemData then
    if self.args.openType == TipsOpenType.RoleEquipOpen then
      if not UIManager.IsVisible(UIID.Bag_EquipInfoUI) then
        UIManager.Show(UIID.Bag_EquipInfoUI)
      end
      self.btn_role.toggle.isOn = true
      self.btn_bag.toggle.isOn = false
    elseif self.args.openType == TipsOpenType.BagOpen then
      if not UIManager.IsVisible(UIID.NewBagInfoUI) then
        UIManager.Show(UIID.NewBagInfoUI)
      end
      self.btn_role.toggle.isOn = false
      self.btn_bag.toggle.isOn = true
    end
    EventManager.Dispatch(Event.Equip_ChangeEquipSelect, self.args.itemData)
    self:SelectedStrengthenEquip(nil, {
      self.args.itemData,
      self.args.itemData
    })
  else
    EventManager.Dispatch(Event.EquipForgeUIChange)
    self.btn_role.toggle.isOn = true
    self.btn_bag.toggle.isOn = false
  end
end

function Equip_OrnamentsUI:SetEquipIntensifyInfo(EquipData, index)
  self.EquipIndex = index
  self.EquipData = EquipData
  local itemId = EquipData.itemId
  if not EquipData.tblEquip then
    return
  end
  self.breachAllTable = MeEquipController.GetOrnamentsAllBreach(EquipData.tblItem.subType)
  self.breachTable = MeEquipController.GetEquipBreachCfg(EquipData.tblItem.subType, EquipData.breach or 0)
  self.LastbreachTable = MeEquipController.GetEquipBreachCfg(EquipData.tblItem.subType, EquipData.breach + 1 or 0)
  self.GrowUpTable = MeEquipController.GetEquipGrowUpCfg(EquipData.tblItem.subType, EquipData.level or 0)
  self.LastGrowUpTable = MeEquipController.GetEquipGrowUpCfg(EquipData.tblItem.subType, EquipData.level + 1 or 0)
  self:SetEquipBasics(EquipData.tblEquip, EquipData)
  self:NewSetAttributeInfo()
  self:SetDownInfo(EquipData.tblEquip, EquipData)
  self:LoadEquipModel(EquipData)
end

function Equip_OrnamentsUI:UpdateEquipIntensifyInfo(EquipData)
  if not EquipData then
    return
  end
  self.EquipData = EquipData
  self.breachAllTable = MeEquipController.GetOrnamentsAllBreach(EquipData.tblItem.subType)
  self.breachTable = MeEquipController.GetEquipBreachCfg(EquipData.tblItem.subType, EquipData.breach)
  self.LastbreachTable = MeEquipController.GetEquipBreachCfg(EquipData.tblItem.subType, EquipData.breach + 1 or 0)
  self.GrowUpTable = MeEquipController.GetEquipGrowUpCfg(EquipData.tblItem.subType, EquipData.level or 0)
  self.LastGrowUpTable = MeEquipController.GetEquipGrowUpCfg(EquipData.tblItem.subType, EquipData.level + 1 or 0)
  self:SetEquipBasics(EquipData.tblEquip, EquipData)
  self:NewSetAttributeInfo()
  self:SetDownInfo(EquipData.tblEquip, EquipData)
end

function Equip_OrnamentsUI:SetEquipBasics(cfgItem, EquipData)
  local strName = cfgItem.name
  local nameLev = EquipData.level or 0
  strName = cfgItem.name
  if nameLev and 0 < nameLev then
    strName = string.format("%s (Lv.%d)", cfgItem.name, nameLev)
  end
  strName = RoleEquipUtility.GetEquipNameColor(strName, EquipData)
  self.lab_itemName:SetText(strName)
  self.img_intensifylevel:SetText("+" .. EquipData.level)
  self.img_intensifylevelnext:SetText("+" .. EquipData.level + 1)
  self.img_intensifylevelnext:SetActive(self.LastGrowUpTable)
  self.img_jiantou:SetActive(self.LastGrowUpTable)
end

function Equip_OrnamentsUI:NewSetAttributeInfo()
  self:SetAttributeActive()
  if self.GrowUpTable then
    local minStr, maxStr
    for k, v in pairs(self.AttributeInfoTab) do
      local isActive = self.GrowUpTable and self.GrowUpTable[v]
      local nextIsActive = self.LastGrowUpTable
      if not isActive or self.GrowUpTable[v] == 0 and not nextIsActive then
        self[k].transform.parent.gameObject:SetActive(false)
      else
        local str, str2
        local num = self.GrowUpTable[v]
        if k == "text_maxHpMul" then
          num = num * 0.01
          if num ~= 0 and Mathf.Floor(num * 10) < num * 10 then
            num = num - num % 0.1
          end
          str = num .. "%"
        elseif k == "text_atk" then
          str = num .. "~" .. self.GrowUpTable.maximumPhysBaseDmg
          minStr = str
        else
          str = string.format("%d", num)
        end
        self[k].transform.parent.gameObject:SetActive(true)
        self[k]:SetText(str)
        if self.LastGrowUpTable then
          local NextNum = self.LastGrowUpTable[v]
          if k == "text_maxHpMul" then
            NextNum = NextNum * 0.01
            if NextNum ~= 0 and Mathf.Floor(NextNum * 10) < NextNum * 10 then
              NextNum = NextNum - NextNum % 0.1
            end
          end
          self[k .. "next"]:SetActive(NextNum and NextNum ~= 0)
          if NextNum == 0 and num == 0 then
            self[k].transform.parent.gameObject:SetActive(false)
          end
          if NextNum and NextNum ~= 0 then
            if k == "text_maxHpMul" then
              str2 = NextNum .. "%"
            elseif k == "text_atk" then
              if NextNum == 0 and num == 0 then
                minStr = nil
              end
              str2 = NextNum .. "~" .. self.LastGrowUpTable.maximumPhysBaseDmg
              maxStr = str2
            else
              str2 = string.format("%d", NextNum)
            end
            self[k .. "next"]:SetText("" .. str2)
          end
        end
        self[k .. "next"]:SetActive(self.LastGrowUpTable)
        self[k .. "img"]:SetActive(self.LastGrowUpTable)
      end
    end
    if minStr ~= nil then
      self.text_maxHpMul:SetText(minStr)
      self.text_maxHpMulnext:SetText(maxStr)
      self.text_maxHpMulnext:SetActive(maxStr)
      self.text_maxHpMulimg:SetActive(maxStr)
      self.text_maxHpMul.transform.parent.gameObject:SetActive(true)
    else
      self.text_maxHpMul.transform.parent.gameObject:SetActive(false)
    end
  end
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
    local isFirst = false
    if nextLevel >= self.breachAllTable[i].level then
      activateState = true
    else
      if nextLevel < self.breachAllTable[i].level and i == 1 or nextLevel < self.breachAllTable[i].level and nextLevel >= self.breachAllTable[i - 1].level then
        isFirst = true
        posIndex = i
      end
      activateState = false
    end
    local cfgBreach = MeEquipController.GetEquipBreachCfg(self.breachAllTable[i].type, self.breachAllTable[i].level - 1 or 0)
    self:SetAttribute(cfgBreach.exp, activateState, obj, nameStr, isFirst)
  end
  self.lab_attributeItemTemp:Refresh()
  self.lab_level:SetActive(false)
  if posIndex and 2 < posIndex then
    local offset = 41 * (posIndex - 3) + 30.5
    if posIndex == 10 then
      offset = 288.5
    end
    self.sw_attributeBreach:GetChild("Viewport/Content").transform.anchoredPosition = Vector2(0, offset)
  else
    self.sw_attributeBreach:GetChild("Viewport/Content").transform.anchoredPosition = Vector2(0, 0)
  end
end

function Equip_OrnamentsUI:SetAttribute(nextLevel, state, obj, attributeStr, isFirst)
  local level
  local labName = obj:GetChild("labName")
  local labState = obj:GetChild("labState")
  local btn_Breach = obj:GetChild("btn_itemBreach")
  local img_lock = obj:GetChild("img_lock")
  if state then
    attributeStr = string.GetColorText(attributeStr, "#2BBDFF")
    level = ""
    btn_Breach:SetActive(false)
    img_lock:SetActive(false)
  else
    attributeStr = string.GetColorText(attributeStr, "#666666")
    level = ""
    if isFirst then
      btn_Breach:SetOnClick(self, self.BtnSelectOrnameTag)
      if self:GetBreachRedPointActive() then
        btn_Breach:GetChild("img_redPoint"):SetActive(true)
      else
        btn_Breach:GetChild("img_redPoint"):SetActive(false)
      end
      btn_Breach:SetActive(true)
      img_lock:SetActive(false)
    else
      img_lock:SetActive(true)
      btn_Breach:SetActive(false)
    end
  end
  labName:SetText(attributeStr)
  labState:SetText(level)
end

function Equip_OrnamentsUI:SetDownInfo(itemdata, EquipData)
  if self.LastGrowUpTable then
    self.img_growMax:SetActive(false)
    self.lab_item:SetActive(true)
    self.btn_growUp:SetActive(true)
  else
    self.img_growMax:SetActive(true)
    self.lab_item:SetActive(false)
    self.btn_growUp:SetActive(false)
  end
  self.lab_growUp:SetText("N\195\162ng c\225\186\165p")
  local costStr = self.GrowUpTable.cost
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
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      if not string.isNullOrEmpty(self.GrowUpTable.currencyCost) then
        local nId = tonumber(string.split(self.GrowUpTable.currencyCost, "#")[1])
        bagCount = bagCount + BagInfoData.GetItemTotalCountByItemId(nId)
      end
      local strColor = bagCount >= tonumber(itemTbl[2]) and "#00FF00" or "#FF0000"
      local countStr = string.format("%s%s", string.GetColorText(bagCount, strColor), string.GetColorText(string.format("/%s", itemTbl[2]), ItemQuality2ColorDic[EItemColorEnum.white]))
      obj.countCtr:SetText(countStr)
      obj.countCtr:SetActive(true)
      obj.nameCtr:SetText(itemData.tblItem.name)
      obj.nameCtr:SetActive(true)
      local isShow = bagCount < tonumber(itemTbl[2])
      local btn_get = obj:GetChild("btn_obtain")
      btn_get.itemData = ItemUtility.GenerateItemData(id)
      btn_get.OpenTipsType = EOpenTipsType.FastBuy
      btn_get:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
      btn_get:SetActive(isShow)
      obj:SetActive(true)
    else
      obj:SetActive(false)
    end
  end
end

function Equip_OrnamentsUI:GetMaxExpLevel(subtype, level, exp, breach)
  local maxExp = 0
  local maxLevel = 0
  local normalTable = ClientTable.cfg_Item_equip_breachManager:GetDic()
  for k, v in pairs(normalTable) do
    if subtype == tonumber(v.type) and v.level == breach then
      maxLevel = v.exp
      break
    end
  end
  return level, maxLevel
end

function Equip_OrnamentsUI:LoadEquipModel(itemdata)
  local itemCtr = ItemUtility.InitItemCell(self.frame_equip)
  local scale = 2
  itemCtr.go_model:SetLocalScale(scale)
  if not self.equipCellData then
    self.equipCellData = ItemCellData()
  end
  self.equipCellData:RefreshData(itemdata)
  ItemUtility.ShowItemCell(self.frame_equip, self.equipCellData, self, true)
end

function Equip_OrnamentsUI:InitShowModel(itemdata)
  Equip_ForgeNavUi.InitShowModel(self, itemdata)
end

function Equip_OrnamentsUI:HideEquipObj()
  if self.LoadEquipObject then
    local go = self.LoadEquipObject
    go:SetActive(false)
    self.LoadEquipObject = nil
  end
end

function Equip_OrnamentsUI:DestroyEquipObj()
  if self.LoadEquipObject then
    local go = self.LoadEquipObject
    self.LoadEquipObject = nil
  end
  self.equipPool = {}
end

function Equip_OrnamentsUI:IsMeetCondition()
  local costStr = self.GrowUpTable.cost
  local cost = string.split(costStr, "&")
  for i = 1, table.count(cost) do
    local itemTbl = string.split(cost[i], "#")
    local id = tonumber(itemTbl[1])
    local needCount = tonumber(itemTbl[2])
    local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
    if not string.isNullOrEmpty(self.GrowUpTable.currencyCost) then
      local nId = tonumber(string.split(self.GrowUpTable.currencyCost, "#")[1])
      bagCount = bagCount + BagInfoData.GetItemTotalCountByItemId(nId)
    end
    if needCount > bagCount then
      local temp = {}
      temp.itemData = ItemUtility.GenerateItemData(id)
      UIManager.Show(UIID.ItemTipUI, {
        item = temp.itemData,
        rightOperate = EItemOperateType.Show,
        ctrl = temp,
        ShowObtain = true
      })
      return false
    end
  end
  return true
end

function Equip_OrnamentsUI:SetAttributeActive()
  self.sw_attributeBreach:SetActive(true)
  self.sw_attributeGrowUp:SetActive(true)
  self:SetGrowUpRedPointActive()
end

function Equip_OrnamentsUI:SetGrowUpRedPointActive()
  local lastGrowUpTable = MeEquipController.GetEquipGrowUpCfg(self.equipData.tblItem.subType, self.equipData.level + 1)
  if lastGrowUpTable then
    local growUpTable = MeEquipController.GetEquipGrowUpCfg(self.equipData.tblItem.subType, self.equipData.level or 0)
    local costStr = growUpTable.cost
    local cost = string.split(costStr, "&")
    for i = 1, table.count(cost) do
      local itemTbl = string.split(cost[i], "#")
      local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemTbl[1]))
      if not string.isNullOrEmpty(growUpTable.currencyCost) then
        local nId = tonumber(string.split(growUpTable.currencyCost, "#")[1])
        bagCount = bagCount + BagInfoData.GetItemTotalCountByItemId(nId)
      end
      if bagCount < tonumber(itemTbl[2]) then
        self.btn_growUp:GetChild("img_redPoint"):SetActive(false)
        return
      end
    end
    self.btn_growUp:GetChild("img_redPoint"):SetActive(true)
  else
    self.btn_growUp:GetChild("img_redPoint"):SetActive(false)
  end
end

function Equip_OrnamentsUI:GetBreachRedPointActive()
  local lastBreachTable = MeEquipController.GetEquipBreachCfg(self.equipData.tblItem.subType, self.equipData.breach + 1)
  if lastBreachTable then
    local breachTable = MeEquipController.GetEquipBreachCfg(self.equipData.tblItem.subType, self.equipData.breach)
    if self.GrowUpTable.level >= breachTable.exp then
      local costStr = breachTable.breachCost
      local cost = string.split(costStr, "&")
      for i = 1, table.count(cost) do
        local itemTbl = string.split(cost[i], "#")
        local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemTbl[1]))
        if not string.isNullOrEmpty(breachTable.currencyCost) then
          local nId = tonumber(string.split(breachTable.currencyCost, "#")[1])
          bagCount = bagCount + BagInfoData.GetItemTotalCountByItemId(nId)
        end
        if bagCount < tonumber(itemTbl[2]) then
          return false
        end
      end
      return true
    end
  end
  return false
end

function Equip_OrnamentsUI:GetEquipGrowUpCost(special, normal)
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

function Equip_OrnamentsUI:OnBagChange()
  if not self.GrowUpTable then
    return
  end
  local costStr = self.GrowUpTable.cost
  local cost = string.split(costStr, "&")
  for i = 1, table.count(self.NeedMaterials) do
    local obj = self.NeedMaterials[i]
    if i <= table.count(cost) then
      local itemTbl = string.split(cost[i], "#")
      local id = tonumber(itemTbl[1])
      local itemData = ItemUtility.GenerateItemData(id)
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      if not string.isNullOrEmpty(self.GrowUpTable.currencyCost) then
        local nId = tonumber(string.split(self.GrowUpTable.currencyCost, "#")[1])
        bagCount = bagCount + BagInfoData.GetItemTotalCountByItemId(nId)
      end
      local strColor = bagCount >= tonumber(itemTbl[2]) and "#00FF00" or "#FF0000"
      local countStr = string.format("%s%s", string.GetColorText(bagCount, strColor), string.GetColorText(string.format("/%s", itemTbl[2]), ItemQuality2ColorDic[EItemColorEnum.white]))
      obj.countCtr:SetText(countStr)
      obj.countCtr:SetActive(true)
      obj.nameCtr:SetText(itemData.tblItem.name)
      obj.nameCtr:SetActive(true)
      local isShow = bagCount < tonumber(itemTbl[2])
      local btn_get = obj:GetChild("btn_obtain")
      btn_get.itemData = ItemUtility.GenerateItemData(id)
      btn_get.OpenTipsType = EOpenTipsType.FastBuy
      btn_get:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
      btn_get:SetActive(isShow)
      obj:SetActive(true)
    else
      obj:SetActive(false)
    end
  end
end
