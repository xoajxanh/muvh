Bag_EquipInfoUI = class(BaseUI)
Bag_EquipInfoUI.layer = UILayer.Panel
Bag_EquipInfoUI.orderInLayer = 2
Bag_EquipInfoUI.hideType = UIHideType.Destroy
Bag_EquipInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_EquipInfoUI.escClose = UIEscClose.DontClose

function Bag_EquipInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Windows = self:GetControl("Windows")
  self.img_title = self:GetControl("Windows/img_title")
  self.View_EquipFrame = self:GetControl("Windows/View_EquipFrame")
  self.img_select = self:GetControl("Windows/View_EquipFrame/img_select")
  self.pet_frame = self:GetControl("Windows/View_EquipFrame/pet_frame")
  self.armor_frame = self:GetControl("Windows/View_EquipFrame/armor_frame")
  self.boot_frame = self:GetControl("Windows/View_EquipFrame/boot_frame")
  self.glove_frame = self:GetControl("Windows/View_EquipFrame/glove_frame")
  self.helm_frame = self:GetControl("Windows/View_EquipFrame/helm_frame")
  self.necklace_frame = self:GetControl("Windows/View_EquipFrame/necklace_frame")
  self.pant_frame = self:GetControl("Windows/View_EquipFrame/pant_frame")
  self.ring_frame_left = self:GetControl("Windows/View_EquipFrame/ring_frame_left")
  self.ring_frame_right = self:GetControl("Windows/View_EquipFrame/ring_frame_right")
  self.wing_frame = self:GetControl("Windows/View_EquipFrame/wing_frame")
  self.weapon_frame_left = self:GetControl("Windows/View_EquipFrame/weapon_frame_left")
  self.weapon_frame_right = self:GetControl("Windows/View_EquipFrame/weapon_frame_right")
  self.earrings_frame_left = self:GetControl("Windows/View_EquipFrame/earrings_frame_left")
  self.earrings_frame_right = self:GetControl("Windows/View_EquipFrame/earrings_frame_right")
  self.vvip_frame = self:GetControl("Windows/View_EquipFrame/vvip_frame")
  self.select_effect = self:GetControl("Windows/View_EquipFrame/select_effect")
  self.bugle_frame = self:GetControl("Windows/View_EquipFrame/bugle_frame")
  self.flag_frame = self:GetControl("Windows/View_EquipFrame/flag_frame")
  self.piFeng_frame = self:GetControl("Windows/View_EquipFrame/piFeng_frame")
  self.lab_title = self:GetControl("Windows/lab_title")
  self.btn_close = self:GetControl("Windows/btn_close")
  self.btn_NormalEquip = self:GetControl("Windows/btn_NormalEquip")
  self.lab_img = self:GetControl("Windows/btn_NormalEquip/lab_img")
  self.btn_taozhuang = self:GetControl("Windows/btn_taozhuang")
  self.btn_xiangbao = self:GetControl("Windows/btn_xiangbao")
  self.currency = self:GetControl("Windows/currency")
  self.go_gold = self:GetControl("Windows/currency/go_gold")
  self.go_integral = self:GetControl("Windows/currency/go_integral")
  self.go_gem = self:GetControl("Windows/currency/go_gem")
  self.go_meltingPoint = self:GetControl("Windows/currency/go_meltingPoint")
  self.panel_attribute = self:GetControl("Windows/panel_attribute")
  self.img_bg = self:GetControl("Windows/panel_attribute/img_bg")
  self.lab_attribute = self:GetControl("Windows/panel_attribute/lab_attribute")
  self.pet_info = self:GetControl("Windows/frameInfoParent/pet_info")
  self.armor_info = self:GetControl("Windows/frameInfoParent/armor_info")
  self.boot_info = self:GetControl("Windows/frameInfoParent/boot_info")
  self.glove_info = self:GetControl("Windows/frameInfoParent/glove_info")
  self.helm_info = self:GetControl("Windows/frameInfoParent/helm_info")
  self.neck_info = self:GetControl("Windows/frameInfoParent/neck_info")
  self.pant_info = self:GetControl("Windows/frameInfoParent/pant_info")
  self.ringL_info = self:GetControl("Windows/frameInfoParent/ringL_info")
  self.ringR_info = self:GetControl("Windows/frameInfoParent/ringR_info")
  self.wing_info = self:GetControl("Windows/frameInfoParent/wing_info")
  self.weaponL_info = self:GetControl("Windows/frameInfoParent/weaponL_info")
  self.weaponR_info = self:GetControl("Windows/frameInfoParent/weaponR_info")
  self.earL_info = self:GetControl("Windows/frameInfoParent/earL_info")
  self.earR_info = self:GetControl("Windows/frameInfoParent/earR_info")
  self.vvip_info = self:GetControl("Windows/frameInfoParent/vvip_info")
  self.flag_info = self:GetControl("Windows/frameInfoParent/flag_info")
  self.bugle_info = self:GetControl("Windows/frameInfoParent/bugle_info")
  self.piFeng_info = self:GetControl("Windows/frameInfoParent/piFeng_info")
  self.Scroll_EquipSwitch = self:GetControl("Windows/Scroll_EquipSwitch")
  self.btnSwitchArch = self:GetControl("Windows/Scroll_EquipSwitch/Viewport/Content/btnSwitchArch")
  self.Eff_UI_datianshixuzhong = self:GetControl("Windows/Scroll_EquipSwitch/Viewport/Content/btnSwitchArch/Eff_UI_datianshixuzhong")
  self.btnSwitchHongzhuang = self:GetControl("Windows/Scroll_EquipSwitch/Viewport/Content/btnSwitchHongzhuang")
  self.bg_stoneCombinationAttribute = self:GetControl("bg_stoneCombinationAttribute")
  self.btn_closeAttribute = self:GetControl("bg_stoneCombinationAttribute/btn_closeAttribute")
  self.plane_top = self:GetControl("plane_top")
end

local Bag_EquipInfoUI_Stone_combinationAttr = require("GameUI/Bag_EquipInfoUI_Stone_combinationAttr")
Bag_EquipInfoUI.SuitOpenState = false
Bag_EquipInfoUI.ShowEquipType = nil
Bag_EquipInfoUI.SuitForBtnDic = nil

function Bag_EquipInfoUI:Init()
  self.goldTbl = {}
  self.integralTbl = {}
  self.gemTbl = {}
  self.meltingTbl = {}
  self.btnEquipPos = {}
  self.WearEquipId = -1
  self.equipCellData = {}
  self:InitSwitchConfig()
end

local equipObjTable = {}
local equipInfoTable = {}

function Bag_EquipInfoUI:OnCreate()
  self:InitControls()
  self:BtnEquipPosInit()
  self:InitUI()
  self:RegistUIEvents()
end

function Bag_EquipInfoUI:InitUI()
  self:InitUIObj()
  self:CoinsInit()
end

function Bag_EquipInfoUI:InitUIObj()
  equipObjTable = {
    [6] = self.armor_frame,
    [1] = self.pet_frame,
    [10] = self.boot_frame,
    [8] = self.glove_frame,
    [2] = self.helm_frame,
    [1001] = self.necklace_frame,
    [9] = self.pant_frame,
    [1002] = self.ring_frame_left,
    [1012] = self.earrings_frame_right,
    [3] = self.wing_frame,
    [4] = self.weapon_frame_left,
    [5] = self.weapon_frame_right,
    [1003] = self.earrings_frame_left,
    [1014] = self.ring_frame_right,
    [5001] = self.vvip_frame,
    [16] = self.flag_frame,
    [17] = self.bugle_frame,
    [ERoleEquipPosition.cloak] = self.piFeng_frame
  }
  self.equipIndexTable = {
    [7] = 2190010,
    [11] = 2180060,
    [12] = 2180060,
    [13] = 2260010,
    [14] = 2260010
  }
  self.shopIndexTable = {
    [11] = 20203,
    [12] = 20203,
    [13] = 20202,
    [14] = 20202
  }
  self.JewelryEquipIndexList = {
    1001,
    1002,
    1003,
    1012,
    1014
  }
  equipInfoTable = {
    [1] = UIControl(self.pet_info.transform),
    [2] = UIControl(self.helm_info.transform),
    [3] = UIControl(self.wing_info.transform),
    [4] = UIControl(self.weaponL_info.transform),
    [5] = UIControl(self.weaponR_info.transform),
    [6] = UIControl(self.armor_info.transform),
    [7] = UIControl(self.neck_info.transform),
    [8] = UIControl(self.glove_info.transform),
    [9] = UIControl(self.pant_info.transform),
    [10] = UIControl(self.boot_info.transform),
    [11] = UIControl(self.ringL_info.transform),
    [12] = UIControl(self.earR_info.transform),
    [13] = UIControl(self.earL_info.transform),
    [14] = UIControl(self.ringR_info.transform),
    [16] = UIControl(self.flag_info.transform),
    [17] = UIControl(self.bugle_info.transform),
    [5001] = UIControl(self.vvip_info.transform),
    [ERoleEquipPosition.cloak] = UIControl(self.piFeng_info.transform)
  }
end

function Bag_EquipInfoUI:CoinsInit()
  self.go_gold = ItemUtility.InitItem(self.go_gold)
  self.go_integral = ItemUtility.InitItem(self.go_integral)
  self.go_gem = ItemUtility.InitItem(self.go_gem)
  self.go_meltingPoint = ItemUtility.InitItem(self.go_meltingPoint)
  self.goldTbl = ItemUtility.GenerateItemData(ECoinsType.gemNotTrade)
  self.integralTbl = ItemUtility.GenerateItemData(ECoinsType.integral)
  self.gemTbl = ItemUtility.GenerateItemData(ECoinsType.gem)
  self.meltingTbl = ItemUtility.GenerateItemData(ECoinsType.bindIntegral)
  ItemUtility.ShowItem(self, self.go_gold, self.goldTbl, true)
  ItemUtility.ShowItem(self, self.go_integral, self.integralTbl, true)
  ItemUtility.ShowItem(self, self.go_gem, self.gemTbl, true)
  ItemUtility.ShowItem(self, self.go_meltingPoint, self.meltingTbl, true)
end

function Bag_EquipInfoUI:BtnEquipPosInit()
end

function Bag_EquipInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:RefreshEquipIndexRedPoint()
end

function Bag_EquipInfoUI:IsVisibleRefresh()
  self:RefreshEquipIndexRedPoint()
end

function Bag_EquipInfoUI:RefreshEquipIndexRedPoint()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Bag_EquipInfoUI
  })
end

function Bag_EquipInfoUI:Update()
  if self.isShowSelect and not self.select_effect:GetActive() then
    self.isShowSelect = false
    self.select_effect:SetActive(true)
  end
end

function Bag_EquipInfoUI:RegistUIEvents()
  for index, btn in pairs(equipObjTable) do
    if index == 1 then
      btn:SetOnClick(self, self.pet_frameOnClick)
    elseif self:IsJewelryObjectIndex(index) then
      btn.index = index
      btn:SetOnClick(self, self.jewelryOnClick)
    else
      btn.index = index
      btn:SetOnClick(self, self.EquipModelOnClick)
    end
  end
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_xiangbao:SetOnClick(self, self.btn_xiangbaoOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_NormalEquip:SetOnClick(self, self.NormalEquipOnClick)
  self.btnSwitchArch:SetOnClick(self, self.btnSwitchArchOnClick)
  self.btnSwitchHongzhuang:SetOnClick(self, self.btnSwitchHongzhuangOnClick)
end

function Bag_EquipInfoUI:IsJewelryObjectIndex(index)
  if self.JewelryEquipIndexList == nil then
    return false
  end
  for i, v in pairs(self.JewelryEquipIndexList) do
    if index == v then
      return true
    end
  end
  return false
end

function Bag_EquipInfoUI:NormalEquipOnClick()
  self.SuitOpenState = not self.SuitOpenState
  self:SuitViewRefresh()
  EventManager.Dispatch(Event.EquipBtnClick, self.ShowEquipType)
end

function Bag_EquipInfoUI:SuitViewRefresh()
  self.SuitType = self.SuitOpenState and EquipCellType.HONGZHUANG or EquipCellType.NORMAL
  self:SuitBtnClick(self.SuitType)
  self:SuitBtnRefresh()
  self:TrySelectSuitView()
end

function Bag_EquipInfoUI:ChangeSuitPanel(equipCellType)
  if equipCellType == nil then
    return
  end
  self.SuitOpenState = equipCellType == EquipCellType.HONGZHUANG
  self:SuitViewRefresh()
end

function Bag_EquipInfoUI:SetEquipBtnShowState(_suitType)
  self.SuitOpenState = _suitType ~= EquipCellType.NORMAL and true or false
  self:SuitBtnClick(_suitType)
  self:SuitBtnRefresh()
end

function Bag_EquipInfoUI:btnSwitchArchOnClick()
  self:SuitBtnClick(EquipCellType.ARCHANGEL)
end

function Bag_EquipInfoUI:btnSwitchHongzhuangOnClick()
  self:SuitBtnClick(EquipCellType.HONGZHUANG)
end

function Bag_EquipInfoUI:btn_closeOnClick()
  UIManager.Hide(UIID.Bag_EquipInfoUI)
end

function Bag_EquipInfoUI:pet_frameOnClick()
  if self.ShowEquipType == EquipCellType.NORMAL then
    UIManager.Show(UIID.Tip_GuardUI, {
      plyerType = EUIPlyerType.MainPlayer
    })
  end
end

function Bag_EquipInfoUI:jewelryOnClick(control)
  local OpenType, OtherType
  local ModelIndex = control.index
  local EquipDataItem, itemCount, bagIndex
  if self.ShowEquipType == EquipCellType.NORMAL and ModelIndex then
    EquipDataItem, itemCount = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetJewelryData():TryGetStartEquipDataItem(ModelIndex)
    OpenType = TipsOpenType.RoleEquipOpen
    OtherType = TipsOtherType.RoleEquipOpen_jewelry
  elseif self.ShowEquipType == EquipCellType.HONGZHUANG and ModelIndex then
    bagIndex = ClientTable.cfg_EquipCell_cellManager:GetBagIndexByBasicIndexAndType(EquipCellType.HONGZHUANG, ModelIndex)
    if bagIndex then
      local hongzhuangList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSingleSuit(EquipCellType.HONGZHUANG)
      if hongzhuangList then
        EquipDataItem = hongzhuangList:GetEquipDataByGridIndex(bagIndex)
        itemCount = EquipDataItem == nil and 0 or 1
      end
    end
    OpenType = TipsOpenType.RoleEquipOpen
    OtherType = TipsOtherType.RoleRedEquipOpen_jewelry
  end
  if EquipDataItem == nil and EquipeInfoData.curView ~= UIID.Equip_RunesInlayUI then
    return
  end
  if self.ShowEquipType == EquipCellType.HONGZHUANG and EquipeInfoData.curView == UIID.Equip_IntensifyUI then
    if EquipDataItem:GetEquipData() then
      self:ShowSelectEffect(ModelIndex, equipObjTable[ModelIndex])
      EventManager.Dispatch(Event.SelectedForgeEquip, {
        EquipDataItem:GetEquipData(),
        ModelIndex
      })
    end
  elseif self.ShowEquipType == EquipCellType.HONGZHUANG and EquipeInfoData.curView == UIID.Equip_RunesInlayUI then
    self:ShowSelectEffect(ModelIndex, equipObjTable[ModelIndex])
    bagIndex = ClientTable.cfg_EquipCell_cellManager:GetBagIndexByBasicIndexAndType(EquipCellType.HONGZHUANG, ModelIndex)
    local equipData = EquipDataItem
    if EquipDataItem then
      equipData = EquipDataItem:GetEquipData()
    end
    MeRunneController:SetSelectRuneEquip(equipData, bagIndex)
  elseif itemCount == 1 then
    local itemData = EquipDataItem:GetEquipData()
    local openSource = UIID.Bag_EquipInfoUI
    if EquipeInfoData.curView == UIID.Equip_IntensifyUI or EquipeInfoData.curView == UIID.Equip_ZhuijiaUI then
      openSource = UIID.Equip_IntensifyUI
    end
    UIManager.Show(UIID.ItemTipUI, {
      item = itemData,
      rightOperate = EItemOperateType.Disboard,
      ctrl = control,
      openType = OpenType,
      otherType = OtherType,
      OpenSourceUI = openSource
    })
  else
    UIManager.Show(UIID.Tip_TrinketTipUI, {
      equipIndex = ModelIndex,
      plyerType = EUIPlyerType.MainPlayer,
      baseTransform = control.transform
    })
  end
  ModelIndex = bagIndex or ModelIndex
  if self.ModelIndex ~= ModelIndex then
    if self.ModelIndex and ModelIndex ~= self.ModelIndex then
      self:StopRotate(self.ModelIndex)
    end
    self.ModelIndex = ModelIndex
    self:BeginRotate(self.ModelIndex)
  end
end

function Bag_EquipInfoUI:btn_xiangbaoOnClick(control)
  local isOpen = self.bg_stoneCombinationAttribute:GetActive()
  self.bg_stoneCombinationAttribute:SetActive(not isOpen)
  if not isOpen then
    Bag_EquipInfoUI_Stone_combinationAttr(self.bg_stoneCombinationAttribute, self)
  end
end

function Bag_EquipInfoUI:RegistEvents()
  self:RegistEvent(Event.PutOnEquip, self.PutOnEquipFunc, self)
  self:RegistEvent(Event.TakeOffEquip, self.TakeOffEquipFunc, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
  self:RegistEvent(Event.EquipForgeUIChange, self.OnEquipForgeUIChange, self)
  self:RegistEvent(Event.RedEquipUIChange, self.OnRedEquipUIChange, self)
  self:RegistEvent(Event.Equip_ChangeEquipSelect, self.ChangeEquipSelect, self)
  self:RegistEvent(Event.Equip_IntensifyEffect, self.Equip_IntensifyEffect, self)
  self:RegistEvent(Event.EquipAttriUpdate, self.EquipDataUpDate, self)
  self:RegistEvent(Event.EquipBreachSucceed, self.EquipBreachSucceed, self)
  self:RegistEvent(Event.EquipInfoChange, self.OnEquipInfoChange, self)
  self:RegistEvent(Event.PutOnSuit, self.PutOnSuitFunc, self)
  self:RegistEvent(Event.TakeOffSuit, self.TakeOffSuitFunc, self)
  self:RegistEvent(Event.GemIndexDataChange, self.OnGemIndexDataChange, self)
  self:RegistEvent(Event.EquipOrBagChange, self.OnEquipOrBagChange, self)
  self:RegistEvent(Event.SuitEquipChange, self.OnSuitEquipChange, self)
  self:RegistEvent(Event.RefreshEnchantEquipIndexChange, self.EnchantedInlayChange, self)
end

function Bag_EquipInfoUI:OnResBagChange(id, msg)
  self:ShowCoins()
end

function Bag_EquipInfoUI:OnEquipForgeUIChange(id, msg)
  self.isShowSelect = false
  self.select_effect:SetActive(false)
  if EquipeInfoData.curView == UIID.Equip_StoneUI then
    self:SetEquipStoneFirst()
  elseif EquipeInfoData.curView == UIID.Equip_IntensifyUI then
    self:SetEquipIntensifyFirst()
  elseif EquipeInfoData.curView == UIID.Equip_ZhuijiaUI then
    self:SetEquipZhuijiaFirst()
  elseif EquipeInfoData.curView == UIID.Equip_OrnamentsUI then
    self:SetEquipOrnamentsUIFirst()
  elseif EquipeInfoData.curView == UIID.Equip_Lucky then
    self:SetEquipLuckyFirst()
  elseif EquipeInfoData.curView == UIID.Equip_GemUI then
    self:SetGemFirstChoose()
  elseif EquipeInfoData.curView == UIID.Equip_RegenerateUI then
    self:SetRegenerateFirst()
  elseif EquipeInfoData.curView == UIID.Equip_RunesInlayUI then
    self:SetRunesInlayFirst()
  end
end

function Bag_EquipInfoUI:OnEquipOrBagChange(id, msg, _equipIndex)
  self.isShowSelect = false
  self.select_effect:SetActive(false)
  if msg == UIID.Equip_IntensifyUI then
    self:SetEquipIntensifyFirst()
  elseif msg == UIID.Equip_ZhuijiaUI then
    self:SetEquipZhuijiaFirst()
  elseif msg == UIID.Equip_EnchantUpgradeUI then
    self:SetEquip_EnchantUpgradeUIFirst(_equipIndex)
  elseif msg == UIID.Equip_EnchantInlayUI then
    self:SetEquip_EnchantInlayUIFirst(_equipIndex)
  end
end

function Bag_EquipInfoUI:OnSuitEquipChange(id, msg)
  if type(msg) ~= "table" or msg.cellType == nil then
    return
  end
  self:ChangeSuitPanel(msg.cellType)
  if msg.from ~= nil then
    self:OnEquipOrBagChange(nil, msg.from, msg.equipIndex)
  end
end

function Bag_EquipInfoUI:OnRedEquipUIChange(msgId, _index)
  self:SetRedEquipFirstChoose(_index)
end

function Bag_EquipInfoUI:GetEquipData()
  return RoleManager.me.data.equipsData.Data
end

function Bag_EquipInfoUI:GetStoneData()
  return RoleManager.me.data.equipsData.StoneData
end

function Bag_EquipInfoUI:IsHaveArchangelEquip()
  local equipData = self:GetEquipData()
  if equipData and table.count(equipData) > 0 then
    for k, v in pairs(equipData) do
      if v and RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.Archangel) or RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.HongZhuang) then
        return true
      end
    end
  end
  return false
end

function Bag_EquipInfoUI:HandleEquipUIShowOrHide()
  if UIManager.IsVisible(UIID.Equip_ForgeNavUi) then
    return
  end
end

function Bag_EquipInfoUI:Refresh()
  self.isShowSelect = false
  self.SuitType = nil
  if MeRunneController:GetShowEquipType() == EquipCellType.HONGZHUANG then
    self.ShowEquipType = EquipCellType.HONGZHUANG
    self.SuitType = EquipCellType.HONGZHUANG
  end
  if UIManager.IsVisible(UIID.Enchant_NavUI) then
    self.ShowEquipType = EquipCellType.HONGZHUANG
    self.SuitType = EquipCellType.HONGZHUANG
  end
  self:RefreshEquipInfoTableUI()
  self:RefreshSuitData()
  self.select_effect:SetActive(false)
  self:HandleEquipUIShowOrHide()
  self:ShowCoins()
  self:EquipInfoUpdate(self:GetEquipData())
  self:JewelryEquipInfoUpdate()
  self:SuitBtnRefresh()
  self:TrySelectSuitView()
end

function Bag_EquipInfoUI:RefreshEquipInfoTableUI()
  local equipData = self:GetEquipData()
  if self.ShowEquipType == EquipCellType.HONGZHUANG and EquipeInfoData.curView == UIID.Equip_RunesInlayUI then
    for index, btn in pairs(equipObjTable) do
      local equipDataItem, bagIndex
      if self:IsJewelryObjectIndex(index) then
        bagIndex = ClientTable.cfg_EquipCell_cellManager:GetBagIndexByBasicIndexAndType(EquipCellType.HONGZHUANG, index)
        if bagIndex then
          local redEquipList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSingleSuit(EquipCellType.HONGZHUANG)
          if redEquipList then
            equipDataItem = redEquipList:GetEquipDataByGridIndex(bagIndex)
            btn:SetColor(equipDataItem == nil and "0xFA5D5DFF" or "0xFFFFFFFF")
            btn.isChange = true
          end
        end
      elseif index ~= 1 and index ~= 3 then
        bagIndex = index + 3500
        btn:SetColor(equipData[bagIndex] == nil and "0xFA5D5DFF" or "0xFFFFFFFF")
        btn.isChange = true
      end
    end
  else
    for index, btn in pairs(equipObjTable) do
      if btn.isChange then
        btn:SetColor("0xFFFFFFFF")
      end
    end
  end
end

function Bag_EquipInfoUI:RefreshSuitData()
  if self.ShowEquipType == nil then
    self.ShowEquipType = EquipCellType.NORMAL
  end
  local equipMgr = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager()
  local mShowEquipType = equipMgr:CurOpenEquipType(IndexerEnum.get)
  if mShowEquipType and mShowEquipType == EquipCellType.HONGZHUANG or self.ShowEquipType == EquipCellType.HONGZHUANG then
    self.ShowEquipType = EquipCellType.HONGZHUANG
    equipMgr:CurOpenEquipType(IndexerEnum.set, nil)
  end
  self.SuitOpenState = self.ShowEquipType ~= EquipCellType.NORMAL and true or false
  self.SuitForBtnDic = {
    [EquipCellType.ARCHANGEL] = Bag_EquipInfoUI.btnSwitchArch,
    [EquipCellType.HONGZHUANG] = Bag_EquipInfoUI.btnSwitchHongzhuang
  }
  self:ResetAllSuitBtn(self.ShowEquipType)
end

function Bag_EquipInfoUI:ShowCoins()
  local coinCount = 0
  if BagInfoData.CoinInfos[ECoinsType.gemNotTrade] then
    coinCount = BagInfoData.CoinInfos[ECoinsType.gemNotTrade]
  end
  self.go_gold.countCtr:SetText(coinCount)
  local integralCount = 0
  if BagInfoData.CoinInfos[ECoinsType.integral] then
    integralCount = BagInfoData.CoinInfos[ECoinsType.integral]
  end
  self.go_integral.countCtr:SetText(integralCount)
  local gemCount = 0
  if BagInfoData.CoinInfos[ECoinsType.gem] then
    gemCount = BagInfoData.CoinInfos[ECoinsType.gem]
  end
  self.go_gem.countCtr:SetText(gemCount)
  local meltingCount = 0
  if BagInfoData.CoinInfos[ECoinsType.bindIntegral] then
    meltingCount = BagInfoData.CoinInfos[ECoinsType.bindIntegral]
  end
  self.go_meltingPoint.countCtr:SetText(meltingCount)
end

function Bag_EquipInfoUI:EquipInfoUpdateSingle(v)
end

function Bag_EquipInfoUI:EquipInfoUpdate(data)
  for k, v in pairs(equipInfoTable) do
    v:SetActive(false)
  end
  for k, v in pairs(data) do
    if v then
      if self.ShowEquipType == EquipCellType.NORMAL then
        if RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.Normal) or RoleEquipUtility.IsVipEquipData(v.bagGridIndex) then
          if v.valid then
            equipObjTable[v.bagGridIndex]:SetColor("0xFF0000FF")
          end
          self:LoadEquipModel(equipObjTable[v.bagGridIndex], v)
        end
      elseif self.ShowEquipType == EquipCellType.ARCHANGEL then
        if RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.Archangel) then
          if v.valid then
            equipObjTable[v.bagGridIndex]:SetColor("0xFF0000FF")
          end
          self:LoadEquipModel(equipObjTable[v.bagGridIndex], v)
        end
      elseif self.ShowEquipType == EquipCellType.HONGZHUANG and RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.HongZhuang) then
        if v.valid then
          equipObjTable[v.bagGridIndex]:SetColor("0xFF0000FF")
        end
        local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(v.bagGridIndex)
        if cellTbl then
          self:LoadEquipModel(equipObjTable[cellTbl.basicPosition], v)
        end
      end
    end
  end
end

function Bag_EquipInfoUI:JewelryEquipInfoUpdate(id, data)
  self:EmptyJewelryCellData()
  for index, btn in pairs(equipObjTable) do
    if self:IsJewelryObjectIndex(index) then
      if self.ShowEquipType == EquipCellType.NORMAL then
        local equipData = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetJewelryData():TryGetStartEquipDataItem(index)
        if equipData ~= nil then
          local cellData = self:LoadEquipModel(btn, equipData:GetEquipData())
        end
      elseif self.ShowEquipType == EquipCellType.HONGZHUANG then
        local bagIndex = ClientTable.cfg_EquipCell_cellManager:GetBagIndexByBasicIndexAndType(EquipCellType.HONGZHUANG, index)
        if bagIndex == nil then
          return
        end
        local hongzhuangList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSingleSuit(EquipCellType.HONGZHUANG)
        if hongzhuangList then
          local equipData = hongzhuangList:GetEquipDataByGridIndex(bagIndex)
          if equipData then
            self:LoadEquipModel(btn, equipData:GetEquipData())
          end
        end
      end
    end
  end
end

function Bag_EquipInfoUI:EmptyJewelryCellData()
  if self.equipCellData == nil then
    return
  end
  for i, v in pairs(self.equipCellData) do
    if QuickFind.LuaMainPlayerEquipData():GetJewelryData():IsIncludeJewelryIndex(i) then
      v:RecycleRes()
      v = nil
    end
  end
end

function Bag_EquipInfoUI:SuitBtnRefresh()
  if self.btn_NormalEquipCoroutine then
    Coroutine.Stop(self.btn_NormalEquipCoroutine)
    self.btn_NormalEquipCoroutine = nil
  end
  if UIManager.IsVisible(UIID.Equip_ForgeNavUi) and EquipeInfoData.curView ~= UIID.Equip_IntensifyUI or UIManager.IsVisible(UIID.Equip_RunesNavUI) or UIManager.IsVisible(UIID.Enchant_NavUI) then
    self.btn_NormalEquip:SetActive(false)
    return
  end
  local suitSystemOpenState = self:GetRedEquipLevelMgr() ~= nil and self:GetRedEquipLevelMgr():GetRedEquipSytemOpenState()
  if suitSystemOpenState then
    local suitBtnSpriteName = self.ShowEquipType ~= EquipCellType.HONGZHUANG and "ioc_equip" or "ioc_redEquip"
    self.btn_NormalEquipCoroutine = self:SetSprite("Atlas_Common", suitBtnSpriteName, self.btn_NormalEquip)
    local suitBtnLabelSpriteName = self.ShowEquipType ~= EquipCellType.HONGZHUANG and "big1_equip" or "big1_redEquip"
    self:SetSprite("Atlas_Language", suitBtnLabelSpriteName, self.lab_img)
  end
  local suitTitleSpriteName = self.ShowEquipType ~= EquipCellType.HONGZHUANG and "equip" or "txt_title_taozhuang"
  self:SetSprite("Atlas_Language", suitTitleSpriteName, self.img_title)
  self.btn_NormalEquip:SetActive(suitSystemOpenState)
end

function Bag_EquipInfoUI:RefreshSuitList()
  local suitList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSuitList()
  self.btnSwitchArch:SetActive(suitList[EquipCellType.ARCHANGEL])
  self.btnSwitchHongzhuang:SetActive(suitList[EquipCellType.HONGZHUANG])
end

function Bag_EquipInfoUI:ResetAllSuitBtn(equipType)
  for k, v in pairs(EquipCellType) do
    local suit = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSingleSuit(v)
    if suit and suit:HaveEquip() then
      self:SetSuitBtnState(v, v == equipType)
    end
  end
end

function Bag_EquipInfoUI:SuitBtnClick(suitType)
  if self.ShowEquipType == suitType then
    return
  end
  self.ShowEquipType = suitType
  self:ResetAllSuitBtn(self.ShowEquipType)
  self:NormalAndArchangelChange()
  self:JewelryEquipInfoUpdate()
end

function Bag_EquipInfoUI:SetSuitBtnState(suitType, state)
  local btnControl = self.SuitForBtnDic[suitType]
  if btnControl == nil then
    return
  end
  local nowSpriteName = btnControl.image.sprite.name
  if string.isNullOrEmpty(nowSpriteName) then
    return
  end
  local spriteNameTbl = string.split(nowSpriteName, "_")
  local newBtnState = state == true and "2" or "1"
  if spriteNameTbl[#spriteNameTbl] == newBtnState then
    return
  end
  spriteNameTbl[#spriteNameTbl] = newBtnState
  self:SetSprite("Atlas_Common", table.concat(spriteNameTbl, "_"), btnControl)
end

function Bag_EquipInfoUI:SetEquipLuckyFirst()
  local luckyIDTab = MeEquipController.EquipLuckyConfigTable
  local ModelIndex
  local equipData = self:GetEquipData()
  if equipData and table.count(equipData) > 0 then
    for k, v in pairs(equipData) do
      if v and luckyIDTab[v.tblItem.id] ~= nil then
        if self.ShowEquipType == EquipCellType.NORMAL and RoleEquipUtility.EquipTypeUtility(k, ERoleEquipCondition.Normal) then
          ModelIndex = k
          break
        elseif self.ShowEquipType == EquipCellType.ARCHANGEL and RoleEquipUtility.EquipTypeUtility(k, ERoleEquipCondition.Archangel) then
          ModelIndex = k
          break
        end
      end
    end
  end
  if ModelIndex and equipData[ModelIndex] then
    self:ShowSelectEffect(ModelIndex % 100, equipObjTable[ModelIndex % 100])
    EventManager.Dispatch(Event.SelectedForgeEquip, {
      equipData[ModelIndex],
      ModelIndex
    })
  else
    self.isShowSelect = false
    EventManager.Dispatch(Event.SelectedForgeEquip, {nil, nil})
  end
end

function Bag_EquipInfoUI:SetEquipIntensifyFirst()
  local equipData = self:GetEquipData()
  local suitType = self.SuitType or EquipCellType.NORMAL
  local suitEquipList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSingleSuit(suitType)
  if suitEquipList == nil then
    return
  end
  if suitEquipList:GetRecommendIntensifyEquip() then
    local equipIndex = suitEquipList:GetRecommendIntensifyEquip():GetEquipIndex()
    local showEquipIndex = equipIndex % 100
    if suitType == EquipCellType.HONGZHUANG then
      local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(equipIndex)
      if cellTbl then
        showEquipIndex = cellTbl.basicPosition
      end
    end
    self:ShowSelectEffect(showEquipIndex, equipObjTable[showEquipIndex])
    EventManager.Dispatch(Event.SelectedForgeEquip, {
      equipData[equipIndex],
      equipIndex
    })
  else
    self.isShowSelect = false
    EventManager.Dispatch(Event.SelectedForgeEquip, {nil, nil})
  end
end

function Bag_EquipInfoUI:SetEquipZhuijiaFirst()
  local equipData = self:GetEquipData()
  local equipSort = {}
  if equipData[ERoleEquipPosition.armor] then
    table.insert(equipSort, equipData[ERoleEquipPosition.armor])
  end
  if equipData[ERoleEquipPosition.pant] then
    table.insert(equipSort, equipData[ERoleEquipPosition.pant])
  end
  if equipData[ERoleEquipPosition.helm] then
    table.insert(equipSort, equipData[ERoleEquipPosition.helm])
  end
  if equipData[ERoleEquipPosition.glove] then
    table.insert(equipSort, equipData[ERoleEquipPosition.glove])
  end
  if equipData[ERoleEquipPosition.boot] then
    table.insert(equipSort, equipData[ERoleEquipPosition.boot])
  end
  if equipData[ERoleEquipPosition.left_weapon] then
    table.insert(equipSort, equipData[ERoleEquipPosition.left_weapon])
  end
  if equipData[ERoleEquipPosition.right_weapon] then
    table.insert(equipSort, equipData[ERoleEquipPosition.right_weapon])
  end
  if equipData[ERoleEquipPosition.wing] then
    table.insert(equipSort, equipData[ERoleEquipPosition.wing])
  end
  local ModelIndex, defalutEquipData
  if table.count(equipSort) > 0 then
    ModelIndex = equipSort[1].bagGridIndex
    defalutEquipData = equipSort[1]
  end
  local tempMinAdditional, tempMinAdditionalData
  for key, value in pairs(equipSort) do
    local isCanAdditional = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():EquipPositionCanAdditional(value.bagGridIndex)
    if isCanAdditional then
      if tempMinAdditional == nil then
        tempMinAdditional = value.additional or 0
        ModelIndex = value.bagGridIndex
        tempMinAdditionalData = value
      end
      if tempMinAdditional > value.additional then
        tempMinAdditional = value.additional or 0
        ModelIndex = value.bagGridIndex
        tempMinAdditionalData = value
      end
    end
  end
  if defalutEquipData then
    local isCanAdditionalDefalut = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():EquipPositionCanAdditional(defalutEquipData.bagGridIndex)
    if not isCanAdditionalDefalut and tempMinAdditionalData then
      ModelIndex = tempMinAdditionalData.bagGridIndex
    end
    if isCanAdditionalDefalut and tempMinAdditionalData and defalutEquipData.additional > tempMinAdditionalData.additional then
      ModelIndex = tempMinAdditionalData.bagGridIndex
    end
  end
  if ModelIndex and equipData[ModelIndex] then
    self:ShowSelectEffect(ModelIndex, equipObjTable[ModelIndex])
    EventManager.Dispatch(Event.SelectedForgeEquip, {
      equipData[ModelIndex],
      ModelIndex
    })
  else
    self.isShowSelect = false
    EventManager.Dispatch(Event.SelectedForgeEquip, {nil, nil})
  end
end

function Bag_EquipInfoUI:SetEquipStoneFirst()
  local equipData = self:GetEquipData()
  local ModelIndex
  if equipData and table.count(equipData) > 0 then
    local equip = self:GetSortEquipData()
    for i, v in ipairs(equip) do
      if v and (v.bagGridIndex == ERoleEquipPosition.right_weapon or v.bagGridIndex == ERoleEquipPosition.left_weapon or v.bagGridIndex == ERoleEquipPosition.armor or v.bagGridIndex == ERoleEquipPosition.pant or v.bagGridIndex == ERoleEquipPosition.helm or v.bagGridIndex == ERoleEquipPosition.glove or v.bagGridIndex == ERoleEquipPosition.boot) then
        ModelIndex = v.bagGridIndex
      end
    end
  end
  if ModelIndex and equipData[ModelIndex] then
    self:ShowSelectEffect(ModelIndex, equipObjTable[ModelIndex])
    EventManager.Dispatch(Event.SelectedForgeEquip, {
      equipData[ModelIndex],
      ModelIndex
    })
  else
    self.isShowSelect = false
    EventManager.Dispatch(Event.SelectedForgeEquip, {nil, nil})
  end
end

function Bag_EquipInfoUI:SetGemFirstChoose()
  local recommendGemData = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GetRecommendGemData()
  local recommendEquipIndex
  if recommendGemData ~= nil then
    recommendEquipIndex = recommendGemData.stoneCellInfo.equipIndex
  end
  local gemEquipIndexList = ClientTable.cfg_Item_stone_configManager:GetHaveGemEquipIndexOrderList()
  local equipData = self:GetEquipData()
  local ModelIndex
  if equipData and table.count(equipData) > 0 then
    for i, v in pairs(equipData) do
      if ModelIndex == nil and table.contains(gemEquipIndexList, v.bagGridIndex) then
        ModelIndex = v.bagGridIndex
      end
      if v.bagGridIndex == recommendEquipIndex then
        ModelIndex = v.bagGridIndex
        break
      end
    end
  end
  if ModelIndex and equipData[ModelIndex] then
    self:ShowSelectEffect(ModelIndex, equipObjTable[ModelIndex])
    EventManager.Dispatch(Event.SelectedGemEquip, {
      equipData = equipData[ModelIndex],
      modelIndex = ModelIndex
    })
  else
    self.isShowSelect = false
    EventManager.Dispatch(Event.SelectedGemEquip)
  end
end

function Bag_EquipInfoUI:SetEquipOrnamentsUIFirst()
  local equipData = self:GetEquipData()
  local ModelIndex, tempIndex
  if equipData and table.count(equipData) > 0 then
    for k, v in pairs(equipData) do
      if v and (k == ERoleEquipPosition.nechushou or k == ERoleEquipPosition.right_ring or k == ERoleEquipPosition.left_ring or k == ERoleEquipPosition.right_Earring or k == ERoleEquipPosition.left_Earring) then
        tempIndex = tempIndex or k
        if self:JewelryRedPoint(v) then
          ModelIndex = v.bagGridIndex
          break
        end
      end
    end
    ModelIndex = ModelIndex or tempIndex
  end
  if ModelIndex and equipData[ModelIndex] then
    self:ShowSelectEffect(ModelIndex % 100, equipObjTable[ModelIndex % 100])
    EventManager.Dispatch(Event.SelectedForgeEquip, {
      equipData[ModelIndex],
      ModelIndex
    })
  else
    EventManager.Dispatch(Event.SelectedForgeEquip, {nil, nil})
  end
end

function Bag_EquipInfoUI:ShowGetWayByIndex(index)
  if self.equipIndexTable[index] == nil then
    return
  end
  local itemObj = UIControl(equipObjTable[index].transform, "Item")
  local itemData = ItemUtility.GenerateItemData(self.equipIndexTable[index])
  itemObj.itemData = itemData
  itemObj.isShowNoEnableEquip = true
  if self.shopIndexTable[index] ~= nil then
    itemObj.itemBuyID = self.shopIndexTable[index]
  end
  ItemUtility.ClickObtainItemBtn(nil, itemObj)
end

function Bag_EquipInfoUI:SetRegenerateFirst()
  local equipData, equipPosition = gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetFirstRegenerateEquip()
  if equipData and equipPosition then
    local showEquipIndex = equipPosition % 100
    self:ShowSelectEffect(showEquipIndex, equipObjTable[showEquipIndex])
    EventManager.Dispatch(Event.SelectedForgeEquip, {equipData = equipData})
  else
    EventManager.Dispatch(Event.SelectedForgeEquip, nil)
  end
end

function Bag_EquipInfoUI:SetRunesInlayFirst()
  local equipData = self:GetEquipData()
  local suitType = EquipCellType.HONGZHUANG
  local suitEquipList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSingleSuit(suitType)
  if suitEquipList == nil then
    return
  end
  if suitEquipList:GetRecommendIntensifyEquip() then
    local equipIndex = suitEquipList:GetRecommendIntensifyEquip():GetEquipIndex()
    local showEquipIndex = equipIndex % 100
    if suitType == EquipCellType.HONGZHUANG then
      local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(equipIndex)
      if cellTbl then
        showEquipIndex = cellTbl.basicPosition
      end
    end
    self:ShowSelectEffect(showEquipIndex, equipObjTable[showEquipIndex])
    MeRunneController:SetSelectRuneEquip(equipData[equipIndex], equipIndex)
  else
    self.isShowSelect = false
    self:ShowSelectEffect(4, equipObjTable[4])
    MeRunneController:SetSelectRuneEquip(nil, 3504)
  end
end

function Bag_EquipInfoUI:EquipModelOnClick(control)
  local ModelIndex = control.index
  if self.ShowEquipType == EquipCellType.ARCHANGEL then
    ModelIndex = ModelIndex + 3100
  elseif self.ShowEquipType == EquipCellType.HONGZHUANG then
    ModelIndex = ModelIndex + 3500
  end
  local equipData = self:GetEquipData()
  local stonedata = self:GetStoneData()
  if EquipeInfoData.curView ~= UIID.Equip_RedEquipUI and EquipeInfoData.curView ~= UIID.Equip_RunesInlayUI and EquipeInfoData.curView ~= UIID.Equip_EnchantInformationUI and EquipeInfoData.curView ~= UIID.Equip_EnchantUpgradeUI and EquipeInfoData.curView ~= UIID.Equip_EnchantInlayUI then
    if not equipData[ModelIndex] then
      Bag_EquipInfoUI:ShowGetWayByIndex(ModelIndex)
    end
    if not equipData[ModelIndex] and not stonedata[ModelIndex] then
      return
    end
  end
  if EquipeInfoData.curView then
    if (ModelIndex == ERoleEquipPosition.pet or ModelIndex == ERoleEquipPosition.vipIndex or ModelIndex == ERoleEquipPosition.flag or ModelIndex == ERoleEquipPosition.bugle) and EquipeInfoData.curView ~= "Equip_IntensifyUI" then
      if EquipeInfoData.curView == UIID.Equip_IntensifyUI then
        FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 c\198\176\225\187\157ng h\195\179a \196\145\225\186\161o c\225\187\165 hi\225\187\135n t\225\186\161i")
      end
      if EquipeInfoData.curView == UIID.Equip_ZhuijiaUI then
        FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 buff \196\145\225\186\161o c\225\187\165 hi\225\187\135n t\225\186\161i")
      end
      return
    end
    if ModelIndex == ERoleEquipPosition.wing and EquipeInfoData.curView == UIID.Equip_RegenerateUI then
      FloatingWordUtility.QuickMsg("Trang B\225\187\139 n\195\160y kh\195\180ng th\225\187\131 T\195\161i Sinh")
      return
    end
    if equipData[ModelIndex] ~= nil and (equipData[ModelIndex].tblEquip.subType == EItemSubtype.Ring or equipData[ModelIndex].tblEquip.subType == EItemSubtype.Earrings) then
      FloatingWordUtility.QuickMsg("V\225\187\139 tr\195\173 n\195\160y kh\195\180ng th\225\187\131 r\195\168n")
      return
    end
    if ModelIndex % 100 == ERoleEquipPosition.wing and EquipeInfoData.curView == UIID.Equip_RunesInlayUI then
      FloatingWordUtility.QuickMsg("V\225\187\139 tr\195\173 n\195\160y kh\195\180ng th\225\187\131 kh\225\186\163m")
      return
    end
    if EquipeInfoData.curView == UIID.Equip_StoneUI and (ModelIndex == ERoleEquipPosition.right_weapon or ModelIndex == ERoleEquipPosition.left_weapon or ModelIndex == ERoleEquipPosition.armor or ModelIndex == ERoleEquipPosition.pant or ModelIndex == ERoleEquipPosition.helm or ModelIndex == ERoleEquipPosition.glove or ModelIndex == ERoleEquipPosition.boot) then
      self:ShowSelectEffect(ModelIndex, equipObjTable[ModelIndex])
      EventManager.Dispatch(Event.SelectedForgeEquip, {
        equipData[ModelIndex],
        ModelIndex
      })
    elseif EquipeInfoData.curView == UIID.Equip_IntensifyUI or EquipeInfoData.curView == UIID.Equip_ZhuijiaUI then
      if equipData and equipData[ModelIndex] then
        local showEquipIndex = ModelIndex % 100
        self:ShowSelectEffect(showEquipIndex, equipObjTable[showEquipIndex])
        EventManager.Dispatch(Event.SelectedForgeEquip, {
          equipData[ModelIndex],
          ModelIndex
        })
      end
    elseif EquipeInfoData.curView == UIID.Equip_OrnamentsUI then
      if equipData[ModelIndex].tblEquip.subType == EItemSubtype.Necklace or equipData[ModelIndex].tblEquip.subType == EItemSubtype.Ring or equipData[ModelIndex].tblEquip.subType == EItemSubtype.Earrings then
        self:ShowSelectEffect(ModelIndex, equipObjTable[ModelIndex])
        EventManager.Dispatch(Event.SelectedForgeEquip, {
          equipData[ModelIndex],
          ModelIndex
        })
      else
        FloatingWordUtility.QuickMsg("Vui l\195\178ng ch\225\187\141n Trang S\225\187\169c")
        return
      end
    elseif EquipeInfoData.curView == UIID.Equip_OverlapUI then
      self:ShowSelectEffect(ModelIndex, equipObjTable[ModelIndex])
      EventManager.Dispatch(Event.SelectedForgeEquip, {
        equipData[ModelIndex],
        ModelIndex
      })
    elseif EquipeInfoData.curView == UIID.Equip_Transfer then
      self:ShowSelectEffect(ModelIndex, equipObjTable[ModelIndex])
      if ForgeData.EquipTransferMain ~= nil and ForgeData.EquipTransferSecond ~= nil then
        UIManager.Show(UIID.PromptTipUI, {
          tile = "Nh\225\186\175c nh\225\187\159",
          textContent = "Trang B\225\187\139 \196\145\195\163 \196\145\198\176\225\187\163c ch\225\187\141n"
        })
        return
      end
      if equipData[ModelIndex] == nil then
        UIManager.Show(UIID.PromptTipUI, {
          tile = "Nh\225\186\175c nh\225\187\159",
          textContent = "\195\148 n\195\160y tr\225\187\145ng"
        })
        return
      end
      if ForgeData.EquipTransferMain == nil then
        ForgeData.SelectEquipPos = TransferEquipType.firstEquip
        ForgeData.EquipTransferMain = equipData[ModelIndex]
      elseif ForgeData.EquipTransferSecond == nil then
        ForgeData.SelectEquipPos = TransferEquipType.secondEquip
        ForgeData.EquipTransferSecond = equipData[ModelIndex]
      end
      EventManager.Dispatch(Event.SelectedForgeEquip, {
        equipData[ModelIndex],
        ModelIndex
      })
    elseif EquipeInfoData.curView == UIID.Equip_Lucky then
      self:ShowSelectEffect(ModelIndex, equipObjTable[ModelIndex])
      EventManager.Dispatch(Event.SelectedForgeEquip, {
        equipData[ModelIndex],
        ModelIndex
      })
    elseif EquipeInfoData.curView == UIID.Equip_GemUI then
      local equipIndexInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GetEquipIndexData(ModelIndex):GetGemListData()
      if equipIndexInfo.AnalysisState == false then
        return
      end
      self:ShowSelectEffect(ModelIndex, equipObjTable[ModelIndex])
      EventManager.Dispatch(Event.SelectedGemEquip, {
        equipData = equipData[ModelIndex],
        modelIndex = ModelIndex
      })
    elseif EquipeInfoData.curView == UIID.Equip_RedEquipUI then
      self:ClickRedEquipIndexObjCallBack(control)
    elseif EquipeInfoData.curView == UIID.Equip_RegenerateUI then
      if equipData and equipData[ModelIndex] then
        local showEquipIndex = ModelIndex % 100
        local isPossessStatus = gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():JudgeEquipCanRegenerate(equipData[ModelIndex])
        if isPossessStatus then
          self:ShowSelectEffect(showEquipIndex, equipObjTable[showEquipIndex])
          EventManager.Dispatch(Event.SelectedForgeEquip, {
            equipData = equipData[ModelIndex]
          })
        else
          FloatingWordUtility.QuickMsg("Trang B\225\187\139 n\195\160y kh\195\180ng th\225\187\131 T\195\161i Sinh")
          return
        end
      end
    elseif EquipeInfoData.curView == UIID.Equip_RunesInlayUI then
      if equipData and ModelIndex then
        local showEquipIndex = ModelIndex % 100
        self:ShowSelectEffect(showEquipIndex, equipObjTable[showEquipIndex])
        MeRunneController:SetSelectRuneEquip(equipData[ModelIndex], ModelIndex)
      end
    elseif EquipeInfoData.curView == UIID.Equip_EnchantInformationUI then
      if ModelIndex == nil or ModelIndex == EnchantNoSelectEquipIndex.SuitWing then
        return
      end
      local showEquipIndex = ModelIndex % 100
      self:ShowSelectEffect(showEquipIndex, equipObjTable[showEquipIndex])
      EventManager.Dispatch(Event.RefreshSelectEnchantEquipInformation, {equipIndex = ModelIndex})
    elseif EquipeInfoData.curView == UIID.Equip_EnchantUpgradeUI then
      if ModelIndex == nil or ModelIndex == EnchantNoSelectEquipIndex.SuitWing then
        return
      end
      local showEquipIndex = ModelIndex % 100
      self:ShowSelectEffect(showEquipIndex, equipObjTable[showEquipIndex])
      EventManager.Dispatch(Event.RefreshSelectEnchantEquipUpgrade, {equipIndex = ModelIndex})
    elseif EquipeInfoData.curView == UIID.Equip_EnchantInlayUI then
      if ModelIndex == nil or ModelIndex == EnchantNoSelectEquipIndex.SuitWing then
        return
      end
      local showEquipIndex = ModelIndex % 100
      self:ShowSelectEffect(showEquipIndex, equipObjTable[showEquipIndex])
      EventManager.Dispatch(Event.RefreshSelectEnchantEquipInlay, {equipIndex = ModelIndex})
    else
      self:ShowTips(control)
    end
  else
    self:ShowTips(control)
  end
  if self.ModelIndex == ModelIndex then
    return
  end
  if self.ModelIndex and ModelIndex ~= self.ModelIndex then
    self:StopRotate(self.ModelIndex)
  end
  self.ModelIndex = ModelIndex
  self:BeginRotate(self.ModelIndex)
end

function Bag_EquipInfoUI:ShowTips(control)
  local ModelIndex = control.index
  if self.ShowEquipType == EquipCellType.ARCHANGEL then
    ModelIndex = ModelIndex + 3100
  elseif self.ShowEquipType == EquipCellType.HONGZHUANG then
    ModelIndex = ModelIndex + 3500
  end
  local item = self:GetEquipData()[ModelIndex]
  local stone = self:GetStoneData()[ModelIndex]
  if item == nil and stone == nil then
    return
  end
  local itemInfo
  if item then
    itemInfo = RoleManager.me.data.equipsData:GetEquipByIndex(ModelIndex)
  elseif stone then
    itemInfo = RoleManager.me.data.equipsData:GetStoneByIndex(ModelIndex)
  end
  local rr = EItemOperateType.Disboard
  if ItemUtility.IsJewelry(itemInfo) then
    rr = EItemOperateType.Upgrade
  end
  local openType
  if RoleEquipUtility.EquipTypeUtility(itemInfo.bagGridIndex, ERoleEquipCondition.Normal) then
    openType = TipsOpenType.RoleEquipOpen
  elseif RoleEquipUtility.EquipTypeUtility(itemInfo.bagGridIndex, ERoleEquipCondition.HongZhuang) then
    openType = TipsOpenType.RoleRedEquipOpen
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = itemInfo,
    rightOperate = rr,
    ctrl = control,
    openType = openType
  })
end

function Bag_EquipInfoUI:OnEquipInfoChange(id, data)
  self:JewelryEquipInfoUpdate(id, data)
end

function Bag_EquipInfoUI:PutOnEquipFunc(id, msg)
  if RoleEquipUtility.EquipTypeUtility(msg.bagGridIndex, ERoleEquipCondition.Foot) or RoleEquipUtility.EquipTypeUtility(msg.bagGridIndex, ERoleEquipCondition.timeEquip) or RoleEquipUtility.EquipTypeUtility(msg.bagGridIndex, ERoleEquipCondition.RingChange) then
    return
  end
  self.WearEquipId = msg.id
  self:NormalAndArchangelChange()
  if gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSuitTypeByEquipCellId(msg.bagGridIndex) == self.ShowEquipType then
    self:EquipInfoShowOrHide(msg)
  end
end

function Bag_EquipInfoUI:PutOnSuitFunc(id, msg)
  if msg == nil or msg.reason == EquipChangeReason.RedEquipSyn then
    return
  end
  if EquipeInfoData.curView == UIID.Equip_IntensifyUI or EquipeInfoData.curView == UIID.Equip_ZhuijiaUI then
    return
  end
  local cfg_EquipCell = ClientTable.cfg_EquipCell_cellManager:TryGetValue(msg.position)
  local mShowEquipType = EquipCellType.NORMAL
  if cfg_EquipCell and cfg_EquipCell.cellType == EquipCellType.HONGZHUANG then
    mShowEquipType = EquipCellType.HONGZHUANG
    self.SuitOpenState = true
    EventManager.Dispatch(Event.RedEquipIndexInitalize, msg.position)
  elseif cfg_EquipCell and self:GetSuitMgr():CheckIsBingjian(msg.position) then
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Bag_EquipInfoAngelUI, {
      showEquipType = cfg_EquipCell.cellType
    })
    self:btn_closeOnClick()
    return
  else
    mShowEquipType = EquipCellType.NORMAL
  end
  self:SetEquipBtnShowState(mShowEquipType)
  self:TrySelectSuitView()
end

function Bag_EquipInfoUI:TakeOffEquipFunc(id, msg)
end

function Bag_EquipInfoUI:TakeOffSuitFunc(id, msg)
  if msg == nil or msg.reason == EquipChangeReason.RedEquipSyn then
    return
  end
  if EquipeInfoData.curView == UIID.Equip_IntensifyUI or EquipeInfoData.curView == UIID.Equip_ZhuijiaUI then
    return
  end
  self:StopTimer()
  local equipObj = self:GetEquipModel(msg.position)
  if equipObj then
    equipObj:SetActive(false)
    self:EquipInfoShowOrHide(nil, msg.position)
    if self.equipCellData[msg.position] then
      self.equipCellData[msg.position]:RecycleRes()
      self.equipCellData[msg.position] = nil
    end
  end
end

function Bag_EquipInfoUI:OnGemIndexDataChange(id, msg)
  self:SetGemFirstChoose()
end

function Bag_EquipInfoUI:RefreshBagEquipFunc(id, msg)
  EquipeInfoData.curView = msg
end

function Bag_EquipInfoUI:LoadEquipModel(parent, itemData)
  if not parent then
    return
  end
  self:EquipInfoShowOrHide(itemData)
  local path = ResourceConfig.GetUIPathByItemData(itemData)
  if not self.equipCellData[itemData.bagGridIndex] then
    self.equipCellData[itemData.bagGridIndex] = ItemCellData()
  end
  local cellData = self.equipCellData[itemData.bagGridIndex]
  cellData:RefreshData(itemData)
  if cellData.model and cellData.model.Path ~= path then
    cellData:RecycleRes()
  end
  if not cellData.model then
    cellData.model = CS.Framework.GameModel(parent.gameObject, function(go, name)
      ItemUtility.SetModelTransform(go, parent.transform, itemData, 1, 400)
      if self.WearEquipId ~= -1 and self.WearEquipId == itemData.id then
        ItemUtility.ShakeEquipItem(go)
        self.WearEquipId = -1
      end
      EquipEffectSet:SetModelEffecByIntensify(itemData, go)
    end)
  end
  if cellData.model.modelObject then
    if not cellData.isDrag then
      ItemUtility.SetModelTransform(cellData.model.modelObject, parent.transform, itemData, 1, 400)
    end
  else
    local obj = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_UI, path)
    if obj then
      cellData.model:SetModelObj(path, obj)
    else
      cellData.model:LoadAsync(path)
      cellData.model:SetLayer(UI_LAYER)
    end
  end
  if cellData.model.modelObject then
    if self.WearEquipId ~= -1 and self.WearEquipId == itemData.id then
      ItemUtility.ShakeEquipItem(cellData.model.modelObject)
      self.WearEquipId = -1
    end
    EquipEffectSet:SetModelEffecByIntensify(itemData, cellData.model.modelObject)
  end
  return cellData
end

local function SetVipEffectModel(go, parent, scale)
  go:SetLayer(UI_LAYER)
  if go.transform:Find("smdimport") then
    local smdimport = go.transform:Find("smdimport")
    if smdimport:GetComponent(typeof(UnityEngineLua.SkinnedMeshRenderer)) then
      smdimport:GetComponent(typeof(UnityEngineLua.SkinnedMeshRenderer)).sortingOrder = 500
    elseif smdimport:GetComponent(typeof(UnityEngineLua.MeshRenderer)) then
      smdimport:GetComponent(typeof(UnityEngineLua.MeshRenderer)).sortingOrder = 500
    end
  end
  go.transform:SetParent(parent, false)
  go.transform.localPosition = Vector3.zero
  go.transform.localEulerAngles = Vector3.zero
  go.transform.localScale = Vector3(scale, scale, scale)
end

function Bag_EquipInfoUI:LoadVipEffectModel(path, parent, scale)
  if self.effectObjPath ~= path then
    if self.effectModel and self.effectModel.modelObject then
      self.effectModel.modelObject.transform.localScale = Vector3.one
      PoolManagerTest.Recycle(ResourceTypeEnum.Effect_UI, ResourceConfig.GetPrefabName(self.effectObjPath), self.effectModel.modelObject)
      self.effectModel:RemoveModelObj()
      self.effectModel = nil
    elseif self.effectObj then
      PoolManagerTest.Recycle(ResourceTypeEnum.Effect_UI, ResourceConfig.GetPrefabName(self.effectObjPath), self.effectObj)
      self.effectObj = nil
    end
  end
  self.effectObjPath = path
  if not self.effectModel then
    self.effectModel = CS.Framework.GameModel(parent.gameObject, function(go, name)
      SetVipEffectModel(go, parent, scale)
    end)
  end
  if self.effectModel.modelObject then
    SetVipEffectModel(self.effectModel.modelObject, parent, scale)
  else
    self.effectObj = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_UI, path)
    if self.effectObj then
      SetVipEffectModel(self.effectObj, parent, scale)
    else
      self.effectModel:LoadAsync(path)
      self.effectModel:SetLayer(UI_LAYER)
    end
  end
end

function Bag_EquipInfoUI:UnLoadVipEffectModel()
  if self.effectModel then
    if self.effectModel.modelObject then
      self.effectModel.modelObject.transform.localScale = Vector3.one
      PoolManagerTest.Recycle(ResourceTypeEnum.Effect_UI, ResourceConfig.GetPrefabName(self.effectObjPath), self.effectModel.modelObject)
    end
    self.effectModel:RemoveModelObj()
    self.effectModel = nil
  end
  if self.effectObj then
    PoolManagerTest.Recycle(ResourceTypeEnum.Effect_UI, ResourceConfig.GetPrefabName(self.effectObjPath), self.effectObj)
    self.effectObj = nil
  end
end

function Bag_EquipInfoUI:OnHide()
  self.select_effect:SetActive(false)
  self:StopRotate(self.ModelIndex)
  for i, v in pairs(self.equipCellData) do
    if v and v.model then
      v:RecycleRes()
    end
  end
  self.equipCellData = {}
  self.ShowEquipType = nil
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():CurOpenEquipType(IndexerEnum.set, nil)
  self:UnLoadVipEffectModel()
  self.redEquipIndex = nil
  if self.delayViewRefresh then
    Timer.Stop(self.delayViewRefresh)
    self.delayViewRefresh = nil
  end
end

function Bag_EquipInfoUI:GetEquipModel(ModelIndex)
  if self.equipCellData and self.equipCellData[ModelIndex] and self.equipCellData[ModelIndex].model then
    return self.equipCellData[ModelIndex].model.modelObject
  else
    return nil
  end
end

function Bag_EquipInfoUI:BeginRotate(ModelIndex)
  local equipData = ViewData.meData.equipsData.Data
  local oldObj = self:GetEquipModel(ModelIndex)
  if not oldObj then
    return
  end
  if not equipData[ModelIndex] then
    return
  end
  self.timer = Timer.StartLoopForever(0.05, function()
    if equipData[ModelIndex] then
      RoleEquipUtility.EquipModelRotation(oldObj, equipData[ModelIndex].tblItem.SpinAxis)
    end
  end)
end

function Bag_EquipInfoUI:StopRotate(ModelIndex)
  self:StopTimer()
  if not (ViewData.meData and ViewData.meData.equipsData) or not ViewData.meData.equipsData.Data then
    return
  end
  local equipData = ViewData.meData.equipsData.Data
  local obj = self:GetEquipModel(ModelIndex)
  if not equipData[ModelIndex] then
    return
  end
  if not ModelIndex or not obj then
    return
  end
  obj.transform.localEulerAngles = ItemUtility.GetModelTransformInfo(equipData[ModelIndex]).rota
  self.ModelIndex = nil
end

function Bag_EquipInfoUI:StopTimer()
  if self.timer then
    Timer.Stop(self.timer)
  end
end

function Bag_EquipInfoUI:OnDestroy()
  self:StopRotate(self.ModelIndex)
end

function Bag_EquipInfoUI:ChangeEquipSelect(id, equipData)
  local suitList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSingleSuit(EquipCellType.HONGZHUANG)
  local isSuit = suitList and suitList:IsSuitItem(equipData)
  if isSuit then
    self.SuitOpenState = true
    if self.delayViewRefresh then
      Timer.Stop(self.delayViewRefresh)
      self.delayViewRefresh = nil
    end
    self.delayViewRefresh = Timer.Start(0.5, self.SuitViewRefresh, self)
    local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(equipData.bagGridIndex)
    if cellTbl then
      self:ShowSelectEffect(cellTbl.basicPosition, equipObjTable[cellTbl.basicPosition])
    end
    return
  end
  local openFirstTab = equipData.bagGridIndex
  if openFirstTab and equipObjTable[openFirstTab] then
    if RoleEquipUtility.IsEquipAppearData(openFirstTab) then
      local temp = openFirstTab % 100
      self:ShowSelectEffect(temp, equipObjTable[temp])
    else
      self:ShowSelectEffect(openFirstTab, equipObjTable[openFirstTab])
    end
  end
end

function Bag_EquipInfoUI:ShowSelectEffect(condition, parent)
  if parent == nil or condition == nil then
    return
  end
  self.select_effect:SetParent(parent)
  if condition == 4 then
    self.select_effect:SetScale(Vector3(77, 165, 1))
    self.select_effect.transform.anchoredPosition = Vector2(-3.3, 6.2)
  elseif condition == 5 then
    self.select_effect:SetScale(Vector3(77, 165, 1))
    self.select_effect.transform.anchoredPosition = Vector2(2, 6.2)
  elseif condition == 6 then
    self.select_effect:SetScale(Vector3(98, 165, 1))
    self.select_effect.transform.anchoredPosition = Vector2(-2.4, 4.7)
  elseif condition == 1 then
    self.select_effect:SetScale(Vector3(76, 78, 1))
    self.select_effect.transform.anchoredPosition = Vector2(-9.4, 4.9)
  elseif condition == 2 then
    self.select_effect:SetScale(Vector3(99, 78, 1))
    self.select_effect.transform.anchoredPosition = Vector2(-1.5, 4.9)
  elseif condition == 3 then
    self.select_effect:SetScale(Vector3(76, 78, 1))
    self.select_effect.transform.anchoredPosition = Vector2(-3.1, 4.9)
  elseif condition == 7 then
    self.select_effect:SetScale(Vector3(49, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(0, 3.1)
  elseif condition == 8 then
    self.select_effect:SetScale(Vector3(78, 78, 1))
    self.select_effect.transform.anchoredPosition = Vector2(-4, 4.1)
  elseif condition == 9 then
    self.select_effect:SetScale(Vector3(99, 78, 1))
    self.select_effect.transform.anchoredPosition = Vector2(2, 4.1)
  elseif condition == 10 then
    self.select_effect:SetScale(Vector3(78, 78, 1))
    self.select_effect.transform.anchoredPosition = Vector2(2.1, 4.1)
  elseif condition == 1001 then
    self.select_effect:SetScale(Vector3(48, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(0, 3.8)
  elseif condition == 1002 then
    self.select_effect:SetScale(Vector3(48, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(-0.6, 3.8)
  elseif condition == 1003 then
    self.select_effect:SetScale(Vector3(48, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(0, 3.1)
  elseif condition == ERoleEquipPosition.new_right_ring then
    self.select_effect:SetScale(Vector3(48, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(0, 3.8)
  elseif condition == ERoleEquipPosition.new_right_Earring then
    self.select_effect:SetScale(Vector3(48, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(0, 3.8)
  elseif condition == ERoleEquipPosition.cloak then
    self.select_effect:SetScale(Vector3(99, 78, 1))
    self.select_effect.transform.anchoredPosition = Vector2(-1.5, 4.9)
  elseif condition == ERoleEquipPosition.flag then
    self.select_effect:SetScale(Vector3(49, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(0, 5)
  elseif condition == ERoleEquipPosition.bugle then
    self.select_effect:SetScale(Vector3(49, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(0, 5)
  end
  self.select_effect:SetActive(true)
  self.isShowSelect = true
  self.img_select:SetActive(false)
  self.selectModelIndex = condition
end

function Bag_EquipInfoUI:Equip_IntensifyEffect(_, data)
  local obj = self:GetEquipModel(data.bagGridIndex)
  if not IsNil(obj) then
    EquipEffectSet:SetModelEffecByIntensify(data, obj)
  end
  RoleManager.me.AvatarEquip:SetEquipEffect(data)
end

function Bag_EquipInfoUI:EquipInfoShowOrHide(itemInfo, position)
  local obj
  if position then
    if RoleEquipUtility.EquipTypeUtility(position, ERoleEquipCondition.Archangel) then
      return
    end
    if position == ERoleEquipPosition.vipIndex then
      obj = equipInfoTable[position]
    elseif gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetJewelryData():IsIncludeJewelryIndex(position) then
      obj = nil
      local EquipInfoTableKey = self.JewelrybagGridIndex_EEquipInfoTableKey[position]
      if EquipInfoTableKey ~= nil then
        obj = equipInfoTable[EquipInfoTableKey]
      end
    elseif self.ShowEquipType == EquipCellType.HONGZHUANG then
      obj = equipInfoTable[self:GetHONGZHUANGBasicUIIndex(position)]
    else
      obj = equipInfoTable[position % 100]
      self:UnLoadVipEffectModel()
    end
    if obj then
      obj:SetActive(false)
    end
    return
  end
  if RoleEquipUtility.EquipTypeUtility(itemInfo.bagGridIndex, ERoleEquipCondition.Archangel) then
    return
  end
  if itemInfo.bagGridIndex == ERoleEquipPosition.vipIndex then
    obj = equipInfoTable[itemInfo.bagGridIndex]
    local vipTab = ClientTable.cfg_Vip_vipManager:TryGetValue(itemInfo.itemId, "id")
    local path = string.format("Effect/UI/%s.prefab", vipTab.effectName)
    local scale = tonumber(vipTab.effectScale)
    self:LoadVipEffectModel(path, obj.transform, scale)
    obj:SetActive(true)
    return
  elseif gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetJewelryData():IsIncludeJewelryIndex(itemInfo.bagGridIndex) then
    local equipInfoTableKey
    if itemInfo.subType == EItemSubtype.Necklace then
      equipInfoTableKey = EEquipInfoTableKey.Necklace
      obj = equipInfoTable[EEquipInfoTableKey.Necklace]
    elseif itemInfo.subType == EItemSubtype.Ring then
      equipInfoTableKey = EEquipInfoTableKey.Ring
      obj = equipInfoTable[EEquipInfoTableKey.Ring]
    elseif itemInfo.subType == EItemSubtype.Earrings then
      equipInfoTableKey = EEquipInfoTableKey.Earrings
      obj = equipInfoTable[EEquipInfoTableKey.Earrings]
    end
    if equipInfoTableKey ~= nil then
      if self.JewelrybagGridIndex_EEquipInfoTableKey == nil then
        self.JewelrybagGridIndex_EEquipInfoTableKey = {}
      end
      self.JewelrybagGridIndex_EEquipInfoTableKey[itemInfo.bagGridIndex] = equipInfoTableKey
    end
  elseif self.ShowEquipType == EquipCellType.HONGZHUANG then
    obj = equipInfoTable[self:GetHONGZHUANGBasicUIIndex(itemInfo.bagGridIndex)]
  else
    obj = equipInfoTable[itemInfo.bagGridIndex % 100]
  end
  local isShow = false
  if obj == nil then
    return
  end
  local intensify = obj:GetChild("lab_strengthen")
  if itemInfo.intensify and itemInfo.intensify > 0 then
    intensify:SetText("+" .. itemInfo.intensify)
    intensify:SetActive(true)
    isShow = true
  else
    intensify:SetActive(false)
  end
  local additional = obj:GetChild("lab_additional")
  if itemInfo.additional and 0 < itemInfo.additional then
    additional:SetText("+" .. itemInfo.additional)
    additional:SetActive(true)
    isShow = true
  else
    additional:SetActive(false)
  end
  local grid_leftIcon = obj:GetChild("grid_leftIcon")
  local img_star = obj:GetChild("grid_leftIcon/img_star")
  local iconName
  local isJewelry = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetJewelryData():IsJewelryBySubtype(itemInfo.subType)
  if itemInfo.isSuit then
    isShow = true
    if isJewelry then
      iconName = "ty_ico_excellence_N"
    else
      iconName = "ty_ico_suit_N"
    end
  elseif itemInfo.tblEquip.excellentNumber ~= "" then
    isShow = true
    iconName = "ty_ico_excellence_N"
  end
  if not obj.container then
    obj.container = UIContainer(img_star, self)
  end
  obj.container:SetData(itemInfo:GetExcellenceCount())
  if iconName then
    self:SetSprite("Atlas_Common", iconName, grid_leftIcon)
  end
  grid_leftIcon:SetActive(iconName ~= nil)
  local smeltingIcon = obj:GetChild("smeltingIcon")
  if smeltingIcon and smeltingIcon.transform then
    smeltingIcon:SetActive(false)
    if not table.isNullOrEmpty(itemInfo.serverInfo) then
      smeltingIcon:SetActive(itemInfo.serverInfo.canSmelt)
    end
  end
  local Enchan_mo = obj:GetChild("Enchan_mo")
  if Enchan_mo and Enchan_mo.transform then
    Enchan_mo:SetActive(false)
    local enchantEquipIndexData = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipIndexDataByItem(itemInfo)
    if enchantEquipIndexData and enchantEquipIndexData.m_ItemInfo then
      Enchan_mo:SetActive(true)
    end
  end
  obj:SetActive(true)
end

function Bag_EquipInfoUI:EquipDataUpDate(_, itemInfo)
  if itemInfo and self:GetEquipModel(itemInfo.bagGridIndex) then
    local equipData = self:GetEquipData()
    for i, v in pairs(equipData) do
      if v and v.id == itemInfo.id then
        self:EquipInfoShowOrHide(itemInfo)
        EquipEffectSet:SetModelEffecByIntensify(itemInfo, self:GetEquipModel(itemInfo.bagGridIndex))
        RoleManager.me.AvatarEquip:SetEquipEffect(itemInfo)
        break
      end
    end
    EventManager.Dispatch(Event.Bag_RefreshShowTransfer)
  end
end

function Bag_EquipInfoUI:EnchantedInlayChange(_, msg)
  local equipData = self:GetEquipData()
  if table.count(equipData) > 0 and msg and equipData[msg.index] then
    self:EquipInfoShowOrHide(equipData[msg.index])
  end
end

function Bag_EquipInfoUI:GetSortEquipData()
  local tab = {}
  local equipData = self:GetEquipData()
  if equipData[ERoleEquipPosition.right_weapon] then
    table.insert(tab, equipData[ERoleEquipPosition.right_weapon])
  end
  if equipData[ERoleEquipPosition.left_weapon] then
    table.insert(tab, equipData[ERoleEquipPosition.left_weapon])
  end
  if equipData[ERoleEquipPosition.armor] then
    table.insert(tab, equipData[ERoleEquipPosition.armor])
  end
  if equipData[ERoleEquipPosition.pant] then
    table.insert(tab, equipData[ERoleEquipPosition.pant])
  end
  if equipData[ERoleEquipPosition.helm] then
    table.insert(tab, equipData[ERoleEquipPosition.helm])
  end
  if equipData[ERoleEquipPosition.glove] then
    table.insert(tab, equipData[ERoleEquipPosition.glove])
  end
  if equipData[ERoleEquipPosition.boot] then
    table.insert(tab, equipData[ERoleEquipPosition.boot])
  end
  if equipData[ERoleEquipPosition.nechushou] then
    table.insert(tab, equipData[ERoleEquipPosition.nechushou])
  end
  if equipData[ERoleEquipPosition.right_Earring] then
    table.insert(tab, equipData[ERoleEquipPosition.right_Earring])
  end
  if equipData[ERoleEquipPosition.left_Earring] then
    table.insert(tab, equipData[ERoleEquipPosition.left_Earring])
  end
  if equipData[ERoleEquipPosition.right_ring] then
    table.insert(tab, equipData[ERoleEquipPosition.right_ring])
  end
  if equipData[ERoleEquipPosition.left_ring] then
    table.insert(tab, equipData[ERoleEquipPosition.left_ring])
  end
  if equipData[ERoleEquipPosition.wing] then
    table.insert(tab, equipData[ERoleEquipPosition.wing])
  end
  return tab
end

function Bag_EquipInfoUI:IntensifyRedPoint(v)
  if not RoleEquipUtility.IsReachIntensifyLevel(self:GetEquipData(), tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2010002))) then
    return false
  end
  local IntensifyTable = MeEquipController.GetEquipIntensifyCfgByEquipData(v)
  if IntensifyTable and not string.isNullOrEmpty(IntensifyTable.cost) then
    local cost = string.split(IntensifyTable.cost, "&")
    local isShow = true
    for i = 1, table.count(cost) do
      local itemTbl = string.split(cost[i], "#")
      local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemTbl[1]))
      if bagCount < tonumber(itemTbl[2]) then
        isShow = false
        break
      end
    end
    if isShow then
      if IntensifyTable.condition then
        local level = IntensifyTable.condition[2]
        if v.level >= tonumber(level) then
          return true
        end
      else
        return true
      end
    end
  end
  return false
end

function Bag_EquipInfoUI:AddRedPoint(v)
  local additionalTab = MeEquipController.GetEquipAddtion(v.itemId, v.additional or 0)
  additionalTab = additionalTab or MeEquipController.GetEquipAddtion(v.tblItem.subType, v.additional or 0)
  local LastAddTable = MeEquipController.GetEquipAddtion(v.itemId, v.additional + 1)
  LastAddTable = LastAddTable or MeEquipController.GetEquipAddtion(v.tblItem.subType, v.additional + 1 or 0)
  if LastAddTable and additionalTab then
    local cost = string.split(additionalTab.cost, "&")
    local isShow = true
    for i = 1, table.count(cost) do
      local itemTbl = string.split(cost[i], "#")
      local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemTbl[1]))
      if bagCount < tonumber(itemTbl[2]) then
        isShow = false
        break
      end
    end
    if isShow then
      if additionalTab.condition then
        local level = additionalTab.condition[2]
        if v.level >= tonumber(level) then
          return true
        end
      else
        return true
      end
    end
  end
  return false
end

local function GetEquipBreachCost(special, normal)
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

function Bag_EquipInfoUI:JewelryRedPoint(v)
  local lastGrowUpTable = MeEquipController.GetEquipGrowUpCfg(v.tblItem.subType, v.level + 1)
  if lastGrowUpTable then
    local growUpTable = MeEquipController.GetEquipGrowUpCfg(v.tblItem.subType, v.level or 0)
    if growUpTable == nil then
      return false
    end
    local costStr = growUpTable.cost
    local cost = string.split(costStr, "&")
    for i = 1, table.count(cost) do
      local itemTbl = string.split(cost[i], "#")
      local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemTbl[1]))
      if not string.isNullOrEmpty(growUpTable.currencyCost) then
        local nId = tonumber(string.split(growUpTable.currencyCost, "#")[1])
        bagCount = bagCount + BagInfoData.GetItemTotalCountByItemId(nId)
      end
      if bagCount > tonumber(itemTbl[2]) then
        return true
      end
    end
  end
  local lastBreachTable = MeEquipController.GetEquipBreachCfg(v.tblItem.subType, v.breach + 1)
  if lastBreachTable then
    local breachTable = MeEquipController.GetEquipBreachCfg(v.tblItem.subType, v.breach or 0)
    local growUpTable = MeEquipController.GetEquipGrowUpCfg(v.tblItem.subType, v.level or 0)
    if growUpTable == nil then
      return false
    end
    if growUpTable.level >= breachTable.exp then
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

function Bag_EquipInfoUI:NormalAndArchangelChange()
  local equipData = self:GetEquipData()
  self:HandleEquipUIShowOrHide()
  self:ShowCoins()
  for k, v in pairs(equipInfoTable) do
    v:SetActive(false)
  end
  for k, v in pairs(equipData) do
    if v then
      if self.ShowEquipType == EquipCellType.NORMAL then
        if RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.Normal) or RoleEquipUtility.IsVipEquipData(v.bagGridIndex) then
          if self.equipCellData[v.bagGridIndex] and self.equipCellData[v.bagGridIndex].model and not IsNil(self.equipCellData[v.bagGridIndex].model.modelObject) then
            self.equipCellData[v.bagGridIndex].model.modelObject:SetActive(true)
            self:EquipInfoShowOrHide(v)
          end
          self:LoadEquipModel(equipObjTable[v.bagGridIndex], v)
        elseif self.equipCellData[v.bagGridIndex] and self.equipCellData[v.bagGridIndex].model and not IsNil(self.equipCellData[v.bagGridIndex].model.modelObject) then
          self.equipCellData[v.bagGridIndex].model.modelObject:SetActive(false)
        end
      elseif self.ShowEquipType == EquipCellType.ARCHANGEL then
        if RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.Archangel) then
          if self.equipCellData[v.bagGridIndex] and self.equipCellData[v.bagGridIndex].model and not IsNil(self.equipCellData[v.bagGridIndex].model.modelObject) then
            self.equipCellData[v.bagGridIndex].model.modelObject:SetActive(true)
          end
          self:LoadEquipModel(equipObjTable[v.bagGridIndex % 100], v)
        elseif self.equipCellData[v.bagGridIndex] and self.equipCellData[v.bagGridIndex].model and not IsNil(self.equipCellData[v.bagGridIndex].model.modelObject) then
          self.equipCellData[v.bagGridIndex].model.modelObject:SetActive(false)
        end
      elseif self.ShowEquipType == EquipCellType.HONGZHUANG then
        if RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.HongZhuang) then
          if self.equipCellData[v.bagGridIndex] and self.equipCellData[v.bagGridIndex].model and not IsNil(self.equipCellData[v.bagGridIndex].model.modelObject) then
            self.equipCellData[v.bagGridIndex].model.modelObject:SetActive(true)
            self:EquipInfoShowOrHide(v)
          end
          local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(v.bagGridIndex)
          if cellTbl then
            self:LoadEquipModel(equipObjTable[cellTbl.basicPosition], v)
          end
        elseif self.equipCellData[v.bagGridIndex] and self.equipCellData[v.bagGridIndex].model and not IsNil(self.equipCellData[v.bagGridIndex].model.modelObject) then
          self.equipCellData[v.bagGridIndex].model.modelObject:SetActive(false)
        end
      end
    end
  end
end

function Bag_EquipInfoUI:EquipBreachSucceed(_, msg)
  local breachTable = MeEquipController.GetEquipBreachCfg(msg.tblItem.subType, msg.breach)
  if self.equipCellData[msg.bagGridIndex] and not string.contains(self.equipCellData[msg.bagGridIndex].model.Path, breachTable.model) then
    self:LoadEquipModel(equipObjTable[msg.bagGridIndex], msg)
  end
end

Bag_EquipInfoUI.mSuitePanelSelecter = {
  [true] = {
    show = UIID.Equip_RedEquipUI,
    hide = UIID.NewBagInfoUI
  },
  [false] = {
    show = UIID.NewBagInfoUI,
    hide = UIID.Equip_RedEquipUI
  }
}

function Bag_EquipInfoUI:TrySelectSuitView()
  local suitSystemOpenState = self:GetRedEquipLevelMgr() ~= nil and self:GetRedEquipLevelMgr():GetRedEquipSytemOpenState()
  local isShowSuit = self.ShowEquipType == EquipCellType.HONGZHUANG and suitSystemOpenState
  self:RefreshEquipBgByType(self.ShowEquipType)
  self:TryRefreshEquipIndexObj(isShowSuit)
end

function Bag_EquipInfoUI:SelectSuitPanel(isShowSuit)
  local temp = Bag_EquipInfoUI.mSuitePanelSelecter[isShowSuit]
  if temp.hide and UIManager.IsVisible(temp.hide) then
    UIManager.Hide(temp.hide)
  end
  if temp.show and not UIManager.IsVisible(temp.show) then
    if temp.show == UIID.Equip_RedEquipUI then
      local equipMgr = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager()
      equipMgr:CurOpenEquipType(IndexerEnum.set, EquipCellType.HONGZHUANG)
      self:SetRedEquipFirstChoose()
    end
    UIManager.Show(temp.show)
  end
end

function Bag_EquipInfoUI:GetRedEquipLevelMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetRedEquipLevelDataMgr()
  end
  return nil
end

function Bag_EquipInfoUI:SetRedEquipFirstChoose(equipIndex)
  if self:GetRedEquipLevelMgr() == nil then
    return
  end
  if equipIndex == nil then
    equipIndex = self:GetRedEquipLevelMgr():GetFirstIndex()
  end
  self:ShowSelectEffect(equipIndex - 3500, equipObjTable[equipIndex - 3500])
  EventManager.Dispatch(Event.SelectedRedEquip, {
    modelIndex = equipIndex - 3500
  })
  self.ModelIndex = 3500
end

function Bag_EquipInfoUI:ClickRedEquipIndexObjCallBack(_control)
  if self:GetRedEquipLevelMgr() == nil then
    return
  end
  if not self:GetRedEquipLevelMgr():CheckRedEquipIndexByBasicIndex(_control.index) then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Equip_RedEquip_Choose"))
    return
  end
  if self.ModelIndex ~= _control.index + 3500 then
    self:ShowSelectEffect(_control.index, equipObjTable[_control.index])
    EventManager.Dispatch(Event.SelectedRedEquip, {
      modelIndex = _control.index
    })
    return
  else
    self:ShowTips(_control)
  end
end

function Bag_EquipInfoUI:GetHONGZHUANGBasicUIIndex(bagIndex)
  local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(bagIndex)
  if cellTbl ~= nil then
    if cellTbl.basicPosition == ERoleEquipPosition.new_necklace then
      return EEquipInfoTableKey.Necklace
    elseif cellTbl.basicPosition == ERoleEquipPosition.new_left_ring then
      return EEquipInfoTableKey.Ring
    elseif cellTbl.basicPosition == ERoleEquipPosition.new_left_Earring then
      return EEquipInfoTableKey.Earrings
    else
      return cellTbl.basicPosition % 100
    end
  end
  return 0
end

function Bag_EquipInfoUI:RefreshEquipBgByType(type)
  local tbl = ClientTable.cfg_EquipCell_cellManager:GetBagIndexTblByEquipTypeDic()
  if tbl[type] == nil then
    return
  end
  for i, v in pairs(tbl[type]) do
    self:TrySetEquipObjBg(v)
  end
end

function Bag_EquipInfoUI:TrySetEquipObjBg(equipIndex)
  local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(equipIndex)
  local basicIndex = cellTbl and cellTbl.basicPosition ~= 0 and cellTbl.basicPosition or equipIndex % 100
  local obj = equipObjTable[basicIndex]
  if obj == nil then
    return
  end
  local bg = ClientTable.cfg_Global_globalManager:GetMainPlayerEquipBgSpiteByCellIndex(equipIndex)
  if bg ~= nil then
    self:SetSprite("Atlas_Tower", bg, obj)
  end
end

function Bag_EquipInfoUI:InitSwitchConfig()
  self.objEquipIndexShowBySuit = {
    [true] = {
      ERoleEquipPosition.new_right_Earring,
      ERoleEquipPosition.new_right_ring
    },
    [false] = {
      ERoleEquipPosition.flag,
      ERoleEquipPosition.bugle
    }
  }
end

function Bag_EquipInfoUI:TryRefreshEquipIndexObj(isSuit)
  local isShow
  for state, tbl in pairs(self.objEquipIndexShowBySuit) do
    for i, v in pairs(tbl) do
      if equipObjTable[v] and not IsNil(equipObjTable[v].gameObject) then
        if v == ERoleEquipPosition.helm or v == ERoleEquipPosition.cloak then
          isShow = RoleEquipUtility.IsShowEquipIndexObjByCarrer(v, isSuit)
        else
          isShow = isSuit == state
        end
        equipObjTable[v]:SetActive(isShow)
      end
    end
  end
end

function Bag_EquipInfoUI:GetSuitMgr()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager()
end

function Bag_EquipInfoUI:SetEquip_EnchantUpgradeUIFirst(_equipIndex)
  local equipIndex = EnchantEquipAllIndex[2]
  for i, index in ipairs(EnchantEquipAllIndex) do
    local enchantEquipIndexData = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipIndexDataByEquipIndex(index)
    if enchantEquipIndexData and enchantEquipIndexData:CheckEnchantEquipIndexCanUpgrade() then
      equipIndex = index
      break
    end
  end
  if _equipIndex then
    equipIndex = _equipIndex
  end
  local showEquipIndex = equipIndex % 100
  self:ShowSelectEffect(showEquipIndex, equipObjTable[showEquipIndex])
  EventManager.Dispatch(Event.RefreshSelectEnchantEquipUpgrade, {equipIndex = equipIndex})
end

function Bag_EquipInfoUI:SetEquip_EnchantInlayUIFirst(_equipIndex)
  local equipIndex = EnchantEquipAllIndex[2]
  local enchantEquipBagData = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipBagData()
  for i, index in ipairs(EnchantEquipAllIndex) do
    local enchantEquipIndexData = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipIndexDataByEquipIndex(index)
    if enchantEquipIndexData and enchantEquipIndexData:CheckEnchantEquipIndexBagHaveBetter(enchantEquipBagData) then
      equipIndex = index
      break
    end
  end
  if _equipIndex then
    equipIndex = _equipIndex
  end
  local showEquipIndex = equipIndex % 100
  self:ShowSelectEffect(showEquipIndex, equipObjTable[showEquipIndex])
  EventManager.Dispatch(Event.RefreshSelectEnchantEquipInlay, {equipIndex = equipIndex})
end
