Bag_EquipInfoAngelUI = class(BaseUI)
Bag_EquipInfoAngelUI.layer = UILayer.Panel
Bag_EquipInfoAngelUI.orderInLayer = 0
Bag_EquipInfoAngelUI.hideType = UIHideType.WaitDestroy
Bag_EquipInfoAngelUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_EquipInfoAngelUI.escClose = UIEscClose.DontClose

function Bag_EquipInfoAngelUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Windows = self:GetControl("Windows")
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
  self.signet_frame = self:GetControl("Windows/View_EquipFrame/signet_frame")
  self.orbs_frame = self:GetControl("Windows/View_EquipFrame/orbs_frame")
  self.grail_frame = self:GetControl("Windows/View_EquipFrame/grail_frame")
  self.piFeng_frame = self:GetControl("Windows/View_EquipFrame/piFeng_frame")
  self.lab_title = self:GetControl("Windows/lab_title")
  self.img_title = self:GetControl("Windows/img_title")
  self.btn_close = self:GetControl("Windows/btn_close")
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
  self.signet_info = self:GetControl("Windows/frameInfoParent/signet_info")
  self.orbs_info = self:GetControl("Windows/frameInfoParent/orbs_info")
  self.grail_info = self:GetControl("Windows/frameInfoParent/grail_info")
  self.piFeng_info = self:GetControl("Windows/frameInfoParent/piFeng_info")
  self.bg_stoneCombinationAttribute = self:GetControl("bg_stoneCombinationAttribute")
  self.btn_closeAttribute = self:GetControl("bg_stoneCombinationAttribute/btn_closeAttribute")
  self.plane_top = self:GetControl("plane_top")
  self.Content = self:GetControl("Windows/Scroll_EquipSwitch/Viewport/Content")
  self.btnSwitch = self:GetControl("Windows/Scroll_EquipSwitch/Viewport/Content/btnSwitchArch")
  self.btnSwitchHongzhuang = self:GetControl("Windows/Scroll_EquipSwitch/Viewport/Content/btnSwitchHongzhuang")
  self.eye_Frame = self:GetControl("Windows/View_EquipFrame/eye_frame")
  self.heart_Frame = self:GetControl("Windows/View_EquipFrame/heart_frame")
  self.eye_Info = self:GetControl("Windows/frameInfoParent/eye_info")
  self.heart_Info = self:GetControl("Windows/frameInfoParent/heart_info")
end

function Bag_EquipInfoAngelUI:Init()
  self:InitData()
end

local equipObjTable = {}
local equipInfoTable = {}

function Bag_EquipInfoAngelUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self:BtnEquipPosInit()
  self:InitParams()
end

function Bag_EquipInfoAngelUI:InitUI()
  self:InitUIObj()
  self:CoinsInit()
  self.btnSwitchWith, _ = self.btnSwitch:GetSizeDelta()
end

function Bag_EquipInfoAngelUI:RegistUIEvents()
  for index, btn in pairs(equipObjTable) do
    if index == 1 then
      btn:SetOnClick(self, self.pet_frameOnClick)
    else
      btn.index = index
      btn:SetOnClick(self, self.EquipModelOnClick)
    end
  end
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
end

function Bag_EquipInfoAngelUI:InitParams()
  self.btnSwitchContainer = UIUtility.BindUIContainerTemp(self.btnSwitch, LuaComponentTemplates.SuitSwitchTemplate, self)
end

function Bag_EquipInfoAngelUI:IsJewelryObjectIndex(index)
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

function Bag_EquipInfoAngelUI:btn_closeOnClick()
  UIManager.Hide(UIID.Bag_EquipInfoAngelUI)
end

function Bag_EquipInfoAngelUI:pet_frameOnClick()
  if self.ShowEquipType == EquipCellType.NORMAL then
    UIManager.Show(UIID.Tip_GuardUI, {
      plyerType = EUIPlyerType.MainPlayer
    })
  end
end

function Bag_EquipInfoAngelUI:jewelryOnClick(control)
  local ModelIndex = control.index
  local EquipDataItem, itemCount = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetJewelryData():TryGetStartEquipDataItem(ModelIndex)
  if self.ShowEquipType == EquipCellType.NORMAL and EquipDataItem ~= nil then
    if itemCount == 1 then
      local itemData = EquipDataItem:GetEquipData()
      UIManager.Show(UIID.ItemTipUI, {
        item = itemData,
        rightOperate = EItemOperateType.Disboard,
        ctrl = control,
        openType = TipsOpenType.RoleEquipOpen,
        otherType = TipsOtherType.RoleEquipOpen_jewelry
      })
    else
      UIManager.Show(UIID.Tip_TrinketTipUI, {
        equipIndex = ModelIndex,
        plyerType = EUIPlyerType.MainPlayer,
        baseTransform = control.transform
      })
    end
  end
end

function Bag_EquipInfoAngelUI:EquipModelOnClick(control)
  local ModelIndex = control.index
  local cellBasicId = ClientTable.cfg_Item_equip_bingjianManager:GetCellBasicIdByCellType(self.ShowEquipType)
  if cellBasicId == nil then
    return
  end
  if ModelIndex == EEquipInfoTableKey.Necklace then
    ModelIndex = ERoleEquipPosition.bingJian_necklace
  end
  ModelIndex = ModelIndex + cellBasicId
  self:ShowTips(control)
  if self.ModelIndex == ModelIndex then
    return
  end
  if self.ModelIndex and ModelIndex ~= self.ModelIndex then
    self:StopRotate(self.ModelIndex)
  end
  self.ModelIndex = ModelIndex
  self:BeginRotate(self.ModelIndex)
end

function Bag_EquipInfoAngelUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Bag_EquipInfoAngelUI:RegistEvents()
  self:RegistEvent(Event.PutOnEquip, self.PutOnEquipFunc, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
  self:RegistEvent(Event.Equip_ChangeEquipSelect, self.ChangeEquipSelect, self)
  self:RegistEvent(Event.EquipAttriUpdate, self.EquipDataUpDate, self)
  self:RegistEvent(Event.EquipInfoChange, self.OnEquipInfoChange, self)
  self:RegistEvent(Event.PutOnSuit, self.PutOnSuitFunc, self)
  self:RegistEvent(Event.TakeOffSuit, self.TakeOffSuitFunc, self)
  self:RegistEvent(Event.SuitChange, self.OnSuitChange, self)
  self:RegistEvent(Event.ShowSuitTypeChange, self.OnShowSuitTypeChange, self)
end

function Bag_EquipInfoAngelUI:PutOnEquipFunc(id, msg)
  if RoleEquipUtility.EquipTypeUtility(msg.bagGridIndex, ERoleEquipCondition.Foot) or RoleEquipUtility.EquipTypeUtility(msg.bagGridIndex, ERoleEquipCondition.timeEquip) or RoleEquipUtility.EquipTypeUtility(msg.bagGridIndex, ERoleEquipCondition.RingChange) then
    return
  end
  self.WearEquipId = msg.id
  self:SuitChange()
  if self:GetSuitMgr():GetSuitTypeByEquipCellId(msg.bagGridIndex) == self.ShowEquipType then
    self:EquipInfoShowOrHide(msg)
  end
end

function Bag_EquipInfoAngelUI:OnResBagChange(id, msg)
  self:ShowCoins()
end

function Bag_EquipInfoAngelUI:EquipDataUpDate(_, itemInfo)
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

function Bag_EquipInfoAngelUI:EquipBreachSucceed(_, msg)
  local breachTable = MeEquipController.GetEquipBreachCfg(msg.tblItem.subType, msg.breach)
  if self.equipCellData[msg.bagGridIndex] and not string.contains(self.equipCellData[msg.bagGridIndex].model.Path, breachTable.model) then
    self:LoadEquipModel(equipObjTable[msg.bagGridIndex], msg)
  end
end

function Bag_EquipInfoAngelUI:OnEquipInfoChange(id, data)
  self:SuitChange()
end

function Bag_EquipInfoAngelUI:PutOnSuitFunc(id, msg)
  if msg == nil then
    return
  end
  local cfg_EquipCell = ClientTable.cfg_EquipCell_cellManager:TryGetValue(msg.position)
  if cfg_EquipCell and self:GetSuitMgr():CheckIsBingjian(msg.position) then
    self:RefreshSuit(cfg_EquipCell.cellType)
  elseif cfg_EquipCell and cfg_EquipCell.cellType == EquipCellType.NORMAL then
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.NewBagInfoUI)
    self:btn_closeOnClick()
    return
  elseif cfg_EquipCell and cfg_EquipCell.cellType == EquipCellType.HONGZHUANG then
    EventManager.Dispatch(Event.RedEquipIndexInitalize, msg.position)
    gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():CurOpenEquipType(IndexerEnum.set, EquipCellType.HONGZHUANG)
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.NewBagInfoUI)
    self:btn_closeOnClick()
    return
  end
end

function Bag_EquipInfoAngelUI:TakeOffSuitFunc(id, msg)
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

function Bag_EquipInfoAngelUI:ChangeEquipSelect(id, equipData)
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

function Bag_EquipInfoAngelUI:Equip_IntensifyEffect(_, data)
  local obj = self:GetEquipModel(data.bagGridIndex)
  if not IsNil(obj) then
    EquipEffectSet:SetModelEffecByIntensify(data, obj)
  end
  RoleManager.me.AvatarEquip:SetEquipEffect(data)
end

function Bag_EquipInfoAngelUI:OnEquipForgeUIChange(id, msg)
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
  end
end

function Bag_EquipInfoAngelUI:OnRedEquipUIChange(msgId, _index)
  self:SetRedEquipFirstChoose(_index)
end

function Bag_EquipInfoAngelUI:OnSuitChange(id, msg)
  if self.ShowEquipType == msg.type then
    return
  end
  self:RefreshSuit(msg.type)
end

function Bag_EquipInfoAngelUI:OnShowSuitTypeChange(id, msg)
  local dataTabl = self:GetSuitMgr():GetBingJianDataMgr():GetShowBingjianSuitTypeListBySelectType(self.ShowEquipType)
  self.btnSwitchContainer:SetData(dataTabl)
  self.Content:SetSizeDelta(self.btnSwitchWith * Mathf.Max(5, #dataTabl), 0)
end

function Bag_EquipInfoAngelUI:Refresh()
  self.isShowSelect = false
  self.select_effect:SetActive(false)
  if self.args ~= nil and self.args.showEquipType ~= nil then
    self.ShowEquipType = self.args.showEquipType
  end
  if self.ShowEquipType == nil then
    self.ShowEquipType = self:GetSuitMgr():GetBingJianDataMgr():GetFirstShowBingJianSuitType()
  end
  self:RefreshSuit(self.ShowEquipType)
end

function Bag_EquipInfoAngelUI:RefreshSuit(type)
  if type then
    self.ShowEquipType = type
    self:SuitChange()
    local dataTabl = self:GetSuitMgr():GetBingJianDataMgr():GetShowBingjianSuitTypeListBySelectType(type)
    self.btnSwitchContainer:SetData(dataTabl)
    self.Content:SetSizeDelta(self.btnSwitchWith * Mathf.Max(5, #dataTabl), 0)
    local tbl = ClientTable.cfg_Item_equip_bingjianManager:TryGetValue(type, "cellType")
    if tbl then
      if self.spriteCol ~= nil then
        Coroutine.Stop(self.spriteCol)
        self.spriteCol = nil
      end
      self.spriteCol = self:SetSprite("Atlas_Language", tbl.titleSprite, self.img_title, true)
    end
  end
end

function Bag_EquipInfoAngelUI:Update()
  if self.isShowSelect and not self.select_effect:GetActive() then
    self.isShowSelect = false
    self.select_effect:SetActive(true)
  end
end

function Bag_EquipInfoAngelUI:OnHide()
  self.select_effect:SetActive(false)
  self:StopRotate(self.ModelIndex)
  for i, v in pairs(self.equipCellData) do
    if v and v.model then
      v:RecycleRes()
    end
  end
  self.equipCellData = {}
  self:UnLoadVipEffectModel()
  self.redEquipIndex = nil
  self.ShowEquipType = nil
  self.btnSwitchContainer:SetData({})
  self.Content:SetSizeDelta(self.btnSwitchWith * 5, 0)
end

function Bag_EquipInfoAngelUI:OnDestroy()
  self:StopRotate(self.ModelIndex)
end

function Bag_EquipInfoAngelUI:GetEquipData()
  return RoleManager.me.data.equipsData.Data
end

function Bag_EquipInfoAngelUI:GetStoneData()
  return RoleManager.me.data.equipsData.StoneData
end

function Bag_EquipInfoAngelUI:GetSuitMgr()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager()
end

function Bag_EquipInfoAngelUI:InitData()
  self.goldTbl = {}
  self.integralTbl = {}
  self.gemTbl = {}
  self.meltingTbl = {}
  self.btnEquipPos = {}
  self.WearEquipId = -1
  self.equipCellData = {}
  self:InitSwitchConfig()
end

function Bag_EquipInfoAngelUI:InitUIObj()
  equipObjTable = {
    [6] = self.armor_frame,
    [1] = self.pet_frame,
    [10] = self.boot_frame,
    [8] = self.glove_frame,
    [2] = self.helm_frame,
    [7] = self.necklace_frame,
    [9] = self.pant_frame,
    [11] = self.ring_frame_left,
    [12] = self.ring_frame_right,
    [3] = self.wing_frame,
    [4] = self.weapon_frame_left,
    [5] = self.weapon_frame_right,
    [13] = self.earrings_frame_left,
    [14] = self.earrings_frame_right,
    [5001] = self.vvip_frame,
    [16] = self.orbs_frame,
    [17] = self.signet_frame,
    [18] = self.grail_frame,
    [31] = self.eye_Frame,
    [32] = self.heart_Frame,
    [ERoleEquipPosition.cloak] = self.piFeng_frame
  }
  self.showEquipIndexTable = {
    [EquipCellType.ARCHANGEL] = EquipCellBasicCode.ARCHANGEL,
    [EquipCellType.ARCHANGEL_BLESS] = EquipCellBasicCode.ARCHANGEL_BLESS,
    [EquipCellType.ARCHANGEL_CHRISTMAS] = EquipCellBasicCode.ARCHANGEL_CHRISTMAS,
    [EquipCellType.BINGJIAN_SPRINGFESTIVAL] = EquipCellBasicCode.BINGJIAN_SPRINGFESTIVAL,
    [EquipCellType.BINGJIAN_DianYi] = EquipCellBasicCode.BINGJIAN_DianYi,
    [EquipCellType.BINGJIAN_BeachParty] = EquipCellBasicCode.BINGJIAN_BeachParty,
    [EquipCellType.BINGJIAN_YuanTianYueBai] = EquipCellBasicCode.BINGJIAN_YuanTianYueBai
  }
  self.equipIndexTable_ARCHANGEL = {
    [7] = 3115,
    [11] = 3111,
    [12] = 3112,
    [13] = 3113,
    [14] = 3114
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
    1003
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
    [12] = UIControl(self.ringR_info.transform),
    [13] = UIControl(self.earL_info.transform),
    [14] = UIControl(self.earR_info.transform),
    [16] = UIControl(self.orbs_info.transform),
    [17] = UIControl(self.signet_info.transform),
    [18] = UIControl(self.grail_info.transform),
    [5001] = UIControl(self.vvip_info.transform),
    [31] = UIControl(self.eye_Info.transform),
    [32] = UIControl(self.heart_Info.transform),
    [ERoleEquipPosition.cloak] = UIControl(self.piFeng_info.transform)
  }
  self.btnSwitchHongzhuang:SetActive(false)
end

function Bag_EquipInfoAngelUI:CoinsInit()
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

function Bag_EquipInfoAngelUI:BtnEquipPosInit()
end

function Bag_EquipInfoAngelUI:ShowCoins()
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

function Bag_EquipInfoAngelUI:EquipInfoUpdate(data)
  for k, v in pairs(equipInfoTable) do
    v:SetActive(false)
  end
  for k, v in pairs(data) do
    if v and RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.Archangel) then
      if v.valid then
        equipObjTable[v.bagGridIndex]:SetColor("0xFF0000FF")
      end
      self:LoadEquipModel(equipObjTable[v.bagGridIndex % 100], v)
    end
  end
end

function Bag_EquipInfoAngelUI:JewelryEquipInfoUpdate(id, data)
  self:EmptyJewelryCellData()
  for index, btn in pairs(equipObjTable) do
    if self.ShowEquipType == EquipCellType.NORMAL then
      if self:IsJewelryObjectIndex(index) then
        local equipData = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetJewelryData():TryGetStartEquipDataItem(index)
        if equipData ~= nil then
          local cellData = self:LoadEquipModel(btn, equipData:GetEquipData())
        end
      end
    elseif self.ShowEquipType == EquipCellType.ARCHANGEL and self.equipIndexTable_ARCHANGEL[index] ~= nil then
      local SuitDic = self:GetSuitMgr().SuitDic
      if SuitDic ~= nil and SuitDic[EquipCellType.ARCHANGEL] ~= nil then
        local ARC_SuitDic = SuitDic[EquipCellType.ARCHANGEL]
        if ARC_SuitDic ~= nil and ARC_SuitDic.EquipList ~= nil then
          local nowEquipInfo = ARC_SuitDic.EquipList[self.equipIndexTable_ARCHANGEL[index]]
          if nowEquipInfo ~= nil then
            self:LoadEquipModel(btn, nowEquipInfo.equipData)
          end
        end
      end
    end
  end
end

function Bag_EquipInfoAngelUI:EmptyJewelryCellData()
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

function Bag_EquipInfoAngelUI:ShowTips(control)
  local ModelIndex = control.index
  if ModelIndex == EEquipInfoTableKey.Necklace then
    ModelIndex = ERoleEquipPosition.bingJian_necklace
  end
  ModelIndex = ModelIndex + ClientTable.cfg_Item_equip_bingjianManager:GetCellBasicIdByCellType(self.ShowEquipType)
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
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = itemInfo,
    rightOperate = rr,
    ctrl = control,
    openType = openType
  })
end

function Bag_EquipInfoAngelUI:GetEquipModel(ModelIndex)
  if self.equipCellData and self.equipCellData[ModelIndex] and self.equipCellData[ModelIndex].model then
    return self.equipCellData[ModelIndex].model.modelObject
  else
    return nil
  end
end

function Bag_EquipInfoAngelUI:BeginRotate(ModelIndex)
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

function Bag_EquipInfoAngelUI:StopRotate(ModelIndex)
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

function Bag_EquipInfoAngelUI:StopTimer()
  if self.timer then
    Timer.Stop(self.timer)
  end
end

function Bag_EquipInfoAngelUI:ShowSelectEffect(condition, parent)
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
  elseif condition == 11 then
    self.select_effect:SetScale(Vector3(48, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(0, 3.8)
  elseif condition == 12 then
    self.select_effect:SetScale(Vector3(48, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(-0.6, 3.8)
  elseif condition == 13 then
    self.select_effect:SetScale(Vector3(48, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(0, 3.1)
  elseif condition == 14 then
    self.select_effect:SetScale(Vector3(48, 39, 1))
    self.select_effect.transform.anchoredPosition = Vector2(0, 3.8)
  elseif condition == ERoleEquipPosition.cloak then
    self.select_effect:SetScale(Vector3(99, 78, 1))
    self.select_effect.transform.anchoredPosition = Vector2(-1.5, 4.9)
  end
  self.select_effect:SetActive(true)
  self.isShowSelect = true
  self.img_select:SetActive(false)
  self.selectModelIndex = condition
end

function Bag_EquipInfoAngelUI:SuitChange()
  self:ShowCoins()
  if self.ModelIndex then
    self:StopRotate(self.ModelIndex)
  end
  for k, v in pairs(equipInfoTable) do
    v:SetActive(false)
  end
  for k, v in pairs(self.equipCellData) do
    v:RecycleRes()
  end
  local newSuitData = self:GetSuitMgr():GetSingleSuit(self.ShowEquipType)
  if newSuitData then
    for k, suitEquipItem in pairs(newSuitData.EquipList) do
      local equipData = suitEquipItem:GetEquipData()
      if self.equipCellData[equipData.bagGridIndex] and self.equipCellData[equipData.bagGridIndex].model and not IsNil(self.equipCellData[equipData.bagGridIndex].model.modelObject) then
        self.equipCellData[equipData.bagGridIndex].model.modelObject:SetActive(true)
        self:EquipInfoShowOrHide(equipData)
      end
      if equipData.bagGridIndex % 100 == ERoleEquipPosition.bingJian_necklace then
        self:LoadEquipModel(equipObjTable[EEquipInfoTableKey.Necklace], equipData)
      else
        self:LoadEquipModel(equipObjTable[equipData.bagGridIndex % 100], equipData)
      end
    end
  end
  self:RefreshEquipBgByType(self.ShowEquipType)
  self:TryRefreshEquipIndexObj()
end

function Bag_EquipInfoAngelUI:NormalAndArchangelChange()
  local equipData = self:GetEquipData()
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
          self:LoadEquipModel(equipObjTable[v.bagGridIndex % 100], v)
        elseif self.equipCellData[v.bagGridIndex] and self.equipCellData[v.bagGridIndex].model and not IsNil(self.equipCellData[v.bagGridIndex].model.modelObject) then
          self.equipCellData[v.bagGridIndex].model.modelObject:SetActive(false)
        end
      elseif self.ShowEquipType == EquipCellType.ARCHANGEL_BLESS then
        if RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.ARCHANGEL_BLESS) then
          if self.equipCellData[v.bagGridIndex] and self.equipCellData[v.bagGridIndex].model and not IsNil(self.equipCellData[v.bagGridIndex].model.modelObject) then
            self.equipCellData[v.bagGridIndex].model.modelObject:SetActive(true)
          end
          self:LoadEquipModel(equipObjTable[v.bagGridIndex % 100], v)
        elseif self.equipCellData[v.bagGridIndex] and self.equipCellData[v.bagGridIndex].model and not IsNil(self.equipCellData[v.bagGridIndex].model.modelObject) then
          self.equipCellData[v.bagGridIndex].model.modelObject:SetActive(false)
        end
      end
    end
  end
end

function Bag_EquipInfoAngelUI:HandleEquipUIShowOrHide()
  if UIManager.IsVisible(UIID.Equip_ForgeNavUi) then
    return
  end
end

function Bag_EquipInfoAngelUI:EquipInfoShowOrHide(itemInfo, position)
  local obj
  if position then
    if position == ERoleEquipPosition.vipIndex then
      obj = equipInfoTable[position]
    else
      if position % 100 == ERoleEquipPosition.bingJian_necklace then
        obj = equipInfoTable[EEquipInfoTableKey.Necklace]
      else
        obj = equipInfoTable[position % 100]
      end
      self:UnLoadVipEffectModel()
    end
    obj:SetActive(false)
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
    obj = nil
  elseif itemInfo.bagGridIndex % 100 == ERoleEquipPosition.bingJian_necklace then
    obj = equipInfoTable[EEquipInfoTableKey.Necklace]
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
  if itemInfo.isSuit then
    isShow = true
    iconName = "ty_ico_suit_N"
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
  obj:SetActive(true)
end

function Bag_EquipInfoAngelUI:LoadEquipModel(parent, itemData)
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

function Bag_EquipInfoAngelUI:LoadVipEffectModel(path, parent, scale)
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

function Bag_EquipInfoAngelUI:UnLoadVipEffectModel()
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

function Bag_EquipInfoAngelUI:RefreshEquipBgByType(type)
  local tbl = ClientTable.cfg_EquipCell_cellManager:GetBagIndexTblByEquipTypeDic()
  if tbl[type] == nil then
    return
  end
  for i, v in pairs(tbl[type]) do
    self:TrySetEquipObjBg(v)
  end
end

function Bag_EquipInfoAngelUI:TrySetEquipObjBg(equipIndex)
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

function Bag_EquipInfoAngelUI:InitSwitchConfig()
  self.objEquipIndexShowBySuit = {
    [true] = {
      ERoleEquipPosition.helm,
      ERoleEquipPosition.cloak
    },
    [false] = {
      ERoleEquipPosition.helm
    }
  }
end

function Bag_EquipInfoAngelUI:TryRefreshEquipIndexObj()
  local isShow
  for state, tbl in pairs(self.objEquipIndexShowBySuit) do
    for i, v in pairs(tbl) do
      if equipObjTable[v] and not IsNil(equipObjTable[v].gameObject) then
        if v == ERoleEquipPosition.helm or v == ERoleEquipPosition.cloak then
          isShow = RoleEquipUtility.IsShowEquipIndexObjByCarrer(v, true)
        else
          isShow = isSuit == state
        end
        equipObjTable[v]:SetActive(isShow)
      end
    end
  end
  if not self.helmOrCloak then
    self:AddHelmOrCloakType()
  end
  if self.helmOrCloak and self.helmOrCloak[self.ShowEquipType] then
    equipObjTable[ERoleEquipPosition.helm].gameObject:SetActive(true)
    equipObjTable[ERoleEquipPosition.cloak].gameObject:SetActive(false)
  end
end

function Bag_EquipInfoAngelUI:AddHelmOrCloakType()
  if not self.helmOrCloak then
    self.helmOrCloak = {}
    local data = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(63000009)
    if data then
      local str = string.split(data, "#")
      for i, v in pairs(str) do
        local type = tonumber(v)
        if not self.helmOrCloak[type] then
          self.helmOrCloak[type] = type
        end
      end
    end
  end
end
