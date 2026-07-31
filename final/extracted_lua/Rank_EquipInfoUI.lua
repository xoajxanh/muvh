Rank_EquipInfoUI = class(BaseUI)
Rank_EquipInfoUI.layer = UILayer.Panel
Rank_EquipInfoUI.orderInLayer = 10
Rank_EquipInfoUI.hideType = UIHideType.WaitDestroy
Rank_EquipInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Rank_EquipInfoUI.escClose = UIEscClose.DontClose

function Rank_EquipInfoUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.Windows = self:GetControl("Windows")
  self.img_Bg = self:GetControl("Windows/img_Bg")
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
  self.bugle_frame = self:GetControl("Windows/View_EquipFrame/bugle_frame")
  self.piFeng_frame = self:GetControl("Windows/View_EquipFrame/piFeng_frame")
  self.flag_frame = self:GetControl("Windows/View_EquipFrame/flag_frame")
  self.signet_frame = self:GetControl("Windows/View_EquipFrame/signet_frame")
  self.orbs_frame = self:GetControl("Windows/View_EquipFrame/orbs_frame")
  self.grail_frame = self:GetControl("Windows/View_EquipFrame/grail_frame")
  self.piFeng_frame = self:GetControl("Windows/View_EquipFrame/piFeng_frame")
  self.btn_close = self:GetControl("Windows/btn_close")
  self.lab_title = self:GetControl("Windows/lab_title")
  self.img_title = self:GetControl("Windows/img_title")
  self.btn_taozhuang = self:GetControl("Windows/btn_taozhuang")
  self.btn_xiangbao = self:GetControl("Windows/btn_xiangbao")
  self.panel_attribute = self:GetControl("Windows/panel_attribute")
  self.img_bg = self:GetControl("Windows/panel_attribute/img_bg")
  self.lab_attribute = self:GetControl("Windows/panel_attribute/lab_attribute")
  self.bg_stoneCombinationAttribute = self:GetControl("bg_stoneCombinationAttribute")
  self.btn_closeAttribute = self:GetControl("bg_stoneCombinationAttribute/btn_closeAttribute")
  self.btn_closeBg = self:GetControl("Windows/btn_closeBg")
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
  self.flag_info = self:GetControl("Windows/frameInfoParent/flag_info")
  self.bugle_info = self:GetControl("Windows/frameInfoParent/bugle_info")
  self.piFeng_info = self:GetControl("Windows/frameInfoParent/piFeng_info")
  self.signet_info = self:GetControl("Windows/frameInfoParent/signet_info")
  self.orbs_info = self:GetControl("Windows/frameInfoParent/orbs_info")
  self.grail_info = self:GetControl("Windows/frameInfoParent/grail_info")
  self.btn_NormalEquip = self:GetControl("Windows/btn_NormalEquip")
  self.lab_img = self:GetControl("Windows/btn_NormalEquip/lab_img")
  self.btnSwitchArch = self:GetControl("Scroll_EquipSwitch/Viewport/Content/btnSwitchArch")
  self.Content = self:GetControl("Scroll_EquipSwitch/Viewport/Content")
end

function Rank_EquipInfoUI:OnPreLoad()
end

local Bag_EquipInfoUI_Stone_combinationAttr = require("GameUI/Bag_EquipInfoUI_Stone_combinationAttr")
local equipObjTable = {}
local equipInfoTable = {}

function Rank_EquipInfoUI:Init()
  self.equipPool = {}
  self.LoadEquipObject = {}
  self.ModelIndex = nil
  self.equipCellData = {}
  self:InitSwitchConfig()
  self:InitEquipIndexTable()
end

function Rank_EquipInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:InitData()
  self:RegistUIEvents()
  self:InitContainer()
end

function Rank_EquipInfoUI:InitUI()
  self:InitUIObj()
end

function Rank_EquipInfoUI:OnShow()
  self:RegistEvents()
  self:RefreshData()
  self:Refresh()
  self:CheckGuide_PromptUI()
end

function Rank_EquipInfoUI:CheckGuide_PromptUI()
  if BagInfoData.bagFull then
    TextPromptUtility.HideTextPrompt()
  end
end

function Rank_EquipInfoUI:OnHide()
  self:StopRotate(self.ModelIndex)
  for i, v in pairs(self.equipCellData) do
    if v and v.model then
      v:RecycleRes()
    end
  end
  self.equipCellData = {}
  self.Content:SetSizeDelta(self.btnSwitchWith * 5, 0)
  if BagInfoData.bagFull then
    TextPromptUtility.ShowTextPrompt()
  end
end

function Rank_EquipInfoUI:OnDestroy()
  equipObjTable = {}
  equipInfoTable = {}
  self.equipPool = {}
  self.LoadEquipObject = {}
end

function Rank_EquipInfoUI:InitData()
  self.btnSwitchWith, _ = self.btnSwitchArch:GetSizeDelta()
end

function Rank_EquipInfoUI:RegistUIEvents()
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
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_taozhuang:SetOnClick(self, self.btn_taozhuangOnClick)
  self.btn_xiangbao:SetOnClick(self, self.btn_xiangbaoOnClick)
  self.btn_closeAttribute:SetOnClick(self, self.btn_closeAttributeOnClick)
  self.btn_NormalEquip:SetOnClick(self, self.btn_NormalEquipOnClick)
end

function Rank_EquipInfoUI:RefreshRank_EquipInfoUI(_, data)
  self.args = data
  self:Refresh()
end

function Rank_EquipInfoUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Rank_EquipInfoUI)
end

function Rank_EquipInfoUI:btn_taozhuangOnClick(control)
  UIManager.Show(UIID.PromptTipUI, {
    tile = "Nh\225\186\175c nh\225\187\159",
    textContent = "Kh\195\180ng c\195\179 UI B\225\187\153"
  })
end

function Rank_EquipInfoUI:btn_xiangbaoOnClick(control)
  self.bg_stoneCombinationAttribute:SetActive(true)
  Bag_EquipInfoUI_Stone_combinationAttr(self.bg_stoneCombinationAttribute, self)
end

function Rank_EquipInfoUI:btn_closeAttributeOnClick(control)
  self.bg_stoneCombinationAttribute:SetActive(false)
end

function Rank_EquipInfoUI:btn_NormalEquipOnClick()
  if self.haveHongZhuang then
    self.SuitBtnOpenState = not self.SuitBtnOpenState
  end
  self.showEquipType = nil
  self:SuitBtnRefresh()
  self:BingJianSuitSwitchContainerRefresh(self.showEquipType)
  self:RefreshEquipList()
  self:JewelryEquipInfoUpdate()
end

function Rank_EquipInfoUI:RegistEvents()
  self:RegistEvent(Event.EquipInfoChange, self.OnEquipInfoChange, self)
  self:RegistEvent(Event.SuitChange, self.OnSuitChange, self)
  self:RegistEvent(Event.RefreshRank_EquipInfoUI, self.RefreshRank_EquipInfoUI, self)
end

function Rank_EquipInfoUI:RefreshData()
  self.haveHongZhuang = nil
  self.SuitBtnOpenState = false
  self.showEquipType = nil
end

function Rank_EquipInfoUI:Refresh()
  self.lab_title:SetActive(self.args.Role ~= nil)
  self.img_title:SetActive(self.args.Role == nil)
  self:SuitBtnRefresh()
  self:BingJianSuitSwitchContainerRefresh(self.showEquipType)
  self:RefreshRoleName()
  self:RefreshEquipList()
  self:JewelryEquipInfoUpdate()
end

function Rank_EquipInfoUI:RefreshRoleName()
  if self.args.Role then
    local rolename = self.args.Role.info.name
    if not string.isNullOrEmpty(self.args.Role.info.unionName) then
      rolename = string.format("<color=#e6e600>[%s]</color>%s", self.args.Role.info.unionName, self.args.Role.info.name)
    end
    self.lab_title:SetText(rolename)
  end
end

function Rank_EquipInfoUI:RefreshEquipList()
  self:ReSetEquipInfoTableObj()
  local suitType = self.showEquipType
  if suitType == nil then
    suitType = self.SuitBtnOpenState and EquipCellType.HONGZHUANG or EquipCellType.NORMAL
  end
  local suitList = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetSuitManager():GetSingleSuit(suitType)
  local jewelryData = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetJewelryData()
  for k, v in pairs(self.equipCellData) do
    if v.model and not IsNil(v.model.modelObject) then
      v.model.modelObject:SetActive(false)
    end
  end
  if suitType == EquipCellType.NORMAL then
    self:HolySkeletonEquipSetChange()
  end
  if (suitList ~= nil and type(suitList.EquipList) ~= "table" or next(suitList.EquipList) == nil) and jewelryData and table.count(jewelryData.JewelryDataInfoDic) <= 0 then
    self:EquipObjSwitchShow()
    return
  end
  for k, v in pairs(suitList.EquipList) do
    local bagGridIndex = v:GetEquipIndex()
    local curPosition = ClientTable.cfg_EquipCell_cellManager:GetCurPosition(bagGridIndex)
    local equipItem = equipObjTable[curPosition]
    self:LoadEquipModel(equipItem, v:GetEquipData())
    self:EquipInfoShowOrHide(v:GetEquipData())
  end
  if jewelryData and jewelryData.JewelryDataInfoDic and suitType == EquipCellType.NORMAL then
    for key, value in pairs(jewelryData.JewelryDataInfoDic) do
      self:EquipInfoShowOrHide(value.equipData)
    end
  end
  self:EquipObjSwitchShow()
  if not self.helmOrCloak then
    self:AddHelmOrCloakType()
  end
  if self.helmOrCloak and self.helmOrCloak[suitType] then
    equipObjTable[ERoleEquipPosition.helm].gameObject:SetActive(true)
    equipObjTable[ERoleEquipPosition.cloak].gameObject:SetActive(false)
  else
    equipObjTable[ERoleEquipPosition.helm].gameObject:SetActive(true)
  end
end

function Rank_EquipInfoUI:AddHelmOrCloakType()
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

function Rank_EquipInfoUI:InitEquipIndexTable()
end

function Rank_EquipInfoUI:InitContainer()
  self.btnSwitchContainer = UIUtility.BindUIContainerTemp(self.btnSwitchArch, LuaComponentTemplates.SuitSwitchTemplate, self)
end

function Rank_EquipInfoUI:InitUIObj()
  equipObjTable = {
    [6] = self.armor_frame,
    [1] = self.pet_frame,
    [10] = self.boot_frame,
    [8] = self.glove_frame,
    [2] = self.helm_frame,
    [1001] = self.necklace_frame,
    [9] = self.pant_frame,
    [1002] = self.ring_frame_left,
    [1014] = self.ring_frame_right,
    [3] = self.wing_frame,
    [4] = self.weapon_frame_left,
    [5] = self.weapon_frame_right,
    [1003] = self.earrings_frame_left,
    [1012] = self.earrings_frame_right,
    [16] = self.flag_frame,
    [17] = self.bugle_frame,
    [18] = self.grail_frame,
    [20] = self.orbs_frame,
    [21] = self.signet_frame,
    [ERoleEquipPosition.cloak] = self.piFeng_frame
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
    [ERoleEquipPosition.new_right_Earring] = UIControl(self.earR_info.transform),
    [13] = UIControl(self.earL_info.transform),
    [ERoleEquipPosition.new_right_ring] = UIControl(self.ringR_info.transform),
    [16] = UIControl(self.flag_info.transform),
    [17] = UIControl(self.bugle_info.transform),
    [20] = UIControl(self.orbs_info.transform),
    [21] = UIControl(self.signet_info.transform),
    [18] = UIControl(self.grail_info.transform),
    [ERoleEquipPosition.cloak] = UIControl(self.piFeng_info.transform)
  }
  self.JewelryEquipIndexList = {
    1001,
    1002,
    1003
  }
end

function Rank_EquipInfoUI:LoadEquipModel(parent, itemData)
  if not parent then
    return
  end
  local path = ResourceConfig.GetUIPathByItemData(itemData)
  if not self.equipCellData[itemData.bagGridIndex] then
    self.equipCellData[itemData.bagGridIndex] = ItemCellData()
  end
  local cellData = self.equipCellData[itemData.bagGridIndex]
  cellData:RefreshData(itemData)
  if cellData.model then
    if cellData.model.modelObject then
      cellData.model.modelObject:SetActive(true)
    end
    if cellData.model.Path ~= path then
      cellData:RecycleRes()
    end
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
end

function Rank_EquipInfoUI:InitShowModel(itemdata, equipItem)
  local go
  local bagGridIndex = itemdata.bagGridIndex
  if self.LoadEquipObject[bagGridIndex] then
    go = self.LoadEquipObject[bagGridIndex]
    go:SetActive(false)
  end
  local poolKey = string.format("%d%d", bagGridIndex, itemdata.itemId)
  local subType = itemdata.tblItem.subType
  local itemId = itemdata.tblItem.id
  if self.equipPool[poolKey] then
    go = self.equipPool[poolKey]
    go:SetActive(true)
  else
    local modelName = RoleEquipUtility.GetEquipUIModelName(itemdata)
    local path = ModelConfig.GetCommentModelPath(subType, modelName)
    local request = self:LoadAssetAsync(path, typeof(CS.UnityEngine.GameObject))
    Coroutine.Yield(request)
    if request.isError then
      logError(request.error)
      Coroutine.Break()
    end
    go = Instantiate(request.res)
    self.equipPool[poolKey] = go
  end
  EquipEffectSet:SetModelEffecByIntensify(itemdata, go)
  self.LoadEquipObject[itemdata.bagGridIndex] = go
  return ItemUtility.SetModelTransform(go, equipItem.transform, itemdata, 1, 400)
end

function Rank_EquipInfoUI:EquipModelOnClick(control)
  local ModelIndex = self:GetCurEquipIndex(control.index)
  if not self.args.Data or not self.args.Data[ModelIndex] then
    return
  end
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

function Rank_EquipInfoUI:ShowTips(control)
  if not self.args.Data then
    return
  end
  local ModelIndex = self:GetCurEquipIndex(control.index)
  local item = self.args.Data[ModelIndex]
  if item == nil then
    return
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = item,
    rightOperate = EItemOperateType.Show,
    equips = self.args.Data,
    career = self:GetCurCareer()
  })
end

function Rank_EquipInfoUI:BeginRotate(ModelIndex)
  if not self.args.Data then
    return
  end
  local equipdata = self.args.Data
  if self.equipCellData[ModelIndex] == nil or self.equipCellData[ModelIndex].model == nil then
    return
  end
  local oldObj = self.equipCellData[ModelIndex].model.modelObject
  if not oldObj then
    return
  end
  self.timer = Timer.StartLoopForever(0.05, function()
    RoleEquipUtility.EquipModelRotation(oldObj, equipdata[ModelIndex].tblItem.SpinAxis)
  end)
end

function Rank_EquipInfoUI:StopRotate(ModelIndex)
  self:StopTimer()
  if not self.args.Data then
    return
  end
  local equipdata = self.args.Data
  if not (ModelIndex and self.equipCellData[ModelIndex] and self.equipCellData[ModelIndex].model) or not self.equipCellData[ModelIndex].model.modelObject then
    return
  end
  local oldObj = self.equipCellData[ModelIndex].model.modelObject
  oldObj.transform.localEulerAngles = ItemUtility.GetModelTransformInfo(equipdata[ModelIndex]).rota
  self.ModelIndex = nil
end

function Rank_EquipInfoUI:StopTimer()
  if self.timer then
    Timer.Stop(self.timer)
  end
end

function Rank_EquipInfoUI:EquipInfoShowOrHide(itemInfo, position)
  local obj
  if position then
    local index = self:GetHONGZHUANGBasicUIIndex(position)
    obj = equipInfoTable[index]
    obj:SetActive(false)
    return
  end
  if self:JudgeHolySpiritEquip(itemInfo.subType) then
    return
  end
  local index = self:GetHONGZHUANGBasicUIIndex(itemInfo.bagGridIndex)
  obj = equipInfoTable[index]
  if itemInfo.subType == EItemSubtype.Necklace then
    obj = equipInfoTable[EEquipInfoTableKey.Necklace]
  elseif itemInfo.subType == EItemSubtype.Ring then
    obj = equipInfoTable[EEquipInfoTableKey.Ring]
  elseif itemInfo.subType == EItemSubtype.Earrings then
    obj = equipInfoTable[EEquipInfoTableKey.Earrings]
  end
  if obj == nil then
    return
  end
  local isShow = false
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
  grid_leftIcon:SetActive(iconName)
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
    local enchantEquipIndexData = gameMgr:GetAvatarManager():GetOtherPlayer():GetEnchantEquipManager():GetEnchantEquipIndexDataByItem(itemInfo)
    if enchantEquipIndexData and enchantEquipIndexData.m_ItemInfo then
      Enchan_mo:SetActive(true)
    end
  end
  local img_bg = obj:GetChild("img_bg")
  img_bg:SetActive(false)
  if isShow then
    img_bg:SetActive(true)
    obj:SetActive(true)
  end
end

function Rank_EquipInfoUI:ReSetEquipInfoTableObj()
  for i, obj in pairs(equipInfoTable) do
    obj:SetActive(true)
    local img_bg = obj:GetChild("img_bg")
    img_bg:SetActive(false)
    local intensify = obj:GetChild("lab_strengthen")
    intensify:SetActive(false)
    local additional = obj:GetChild("lab_additional")
    additional:SetActive(false)
    local grid_leftIcon = obj:GetChild("grid_leftIcon")
    local img_star = obj:GetChild("grid_leftIcon/img_star")
    grid_leftIcon:SetActive(false)
    local smeltingIcon = obj:GetChild("smeltingIcon")
    if smeltingIcon and smeltingIcon.transform then
      smeltingIcon:SetActive(false)
    end
    local Enchan_mo = obj:GetChild("Enchan_mo")
    if Enchan_mo and Enchan_mo.transform then
      Enchan_mo:SetActive(false)
    end
    if not obj.container then
      obj.container = UIContainer(img_star, self)
    end
    obj.container:SetData({})
    if obj.transform:Find("hole") ~= nil then
      obj:GetChild("hole"):SetActive(self.showEquipType == nil and self.SuitBtnOpenState == false)
    end
  end
end

function Rank_EquipInfoUI:pet_frameOnClick()
  if self.showEquipType == nil and self.SuitBtnOpenState == false then
    UIManager.Show(UIID.Tip_GuardUI, {
      plyerType = EUIPlyerType.OtherPlayer
    })
  end
end

function Rank_EquipInfoUI:JudgeHolySpiritEquip(subType)
  local globalStr = ClientTable.cfg_Global_globalManager:TryGetValue(4100003).effect
  local globalTab = string.split(globalStr, "&")
  for i, v in pairs(globalTab) do
    local holySpiritSubType = string.split(v, "#")[2]
    if tonumber(holySpiritSubType) == subType then
      return true
    end
  end
  return false
end

function Rank_EquipInfoUI:jewelryOnClick(control)
  if self.showEquipType ~= nil or self.SuitBtnOpenState then
    self:EquipModelOnClick(control)
    return
  end
  local ModelIndex = control.index
  local EquipDataItem, itemCount = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetJewelryData():TryGetStartEquipDataItem(ModelIndex)
  if ForgeData.showEquipType == 1 and EquipDataItem ~= nil then
    if itemCount == 1 then
      local itemData = EquipDataItem:GetEquipData()
      UIManager.Show(UIID.ItemTipUI, {
        item = itemData,
        rightOperate = EItemOperateType.Show,
        otherType = TipsOtherType.RoleEquipOpen_jewelry,
        career = self:GetCurCareer(),
        equips = self:GetCurEquipsInfo()
      })
    else
      UIManager.Show(UIID.Tip_TrinketTipUI, {
        equipIndex = ModelIndex,
        plyerType = EUIPlyerType.OtherPlayer,
        baseTransform = control.transform
      })
    end
  end
end

function Rank_EquipInfoUI:GetCurEquipsInfo()
  local equips
  if self.args.roleTable and self.args.Data then
    equips = self.args.Data
  elseif self.args.Role and self.args.Data then
    equips = self.args.Data
  elseif self.args.roleInfo and self.args.Data then
    equips = self.args.Data
  end
  return equips
end

function Rank_EquipInfoUI:IsJewelryObjectIndex(index)
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

function Rank_EquipInfoUI:JewelryEquipInfoUpdate(id, data)
  for index, btn in pairs(equipObjTable) do
    if self.showEquipType == nil and not self.SuitBtnOpenState and self:IsJewelryObjectIndex(index) then
      local equipData = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetJewelryData():TryGetStartEquipDataItem(index)
      if equipData ~= nil then
        local cellData = self:LoadEquipModel(btn, equipData:GetEquipData())
      end
    end
  end
end

function Rank_EquipInfoUI:OnEquipInfoChange(id, data)
  self:JewelryEquipInfoUpdate(id, data)
end

function Rank_EquipInfoUI:EquipObjSwitchShow()
  self:TryRefreshEquipIndexObj(self.showEquipType ~= nil, self.showEquipType ~= nil or self.SuitBtnOpenState == true)
end

function Rank_EquipInfoUI:OnSuitChange(id, data)
  self.showEquipType = data.type
  self:BingJianSuitSwitchContainerRefresh(self.showEquipType)
  self:RefreshEquipList()
  self:JewelryEquipInfoUpdate()
end

function Rank_EquipInfoUI:GetCurEquipIndex(objIndex)
  local cellType = self.showEquipType
  if cellType == nil then
    cellType = self.SuitBtnOpenState and EquipCellType.HONGZHUANG or EquipCellType.NORMAL
  end
  local suitType = ClientTable.cfg_Item_equip_bingjianManager:GetCellBasicIdByCellType(cellType) / 100
  local ModelIndex = ClientTable.cfg_EquipCell_cellManager:GetOriginPosition(cellType, suitType, objIndex)
  return ModelIndex
end

function Rank_EquipInfoUI:GetHONGZHUANGBasicUIIndex(bagIndex)
  local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(bagIndex)
  if cellTbl ~= nil then
    if cellTbl.basicPositionSetting == ERoleEquipPosition.new_necklace then
      return EEquipInfoTableKey.Necklace
    elseif cellTbl.basicPositionSetting == ERoleEquipPosition.new_left_ring then
      return EEquipInfoTableKey.Ring
    elseif cellTbl.basicPositionSetting == ERoleEquipPosition.new_left_Earring then
      return EEquipInfoTableKey.Earrings
    else
      local index = ClientTable.cfg_EquipCell_cellManager:GetCurPosition(bagIndex)
      if index <= 0 then
        index = bagIndex
      end
      return index
    end
  end
  return 0
end

function Rank_EquipInfoUI:GetCurCareer()
  local career
  if self.args.roleTable then
    career = self.args.roleTable.career
  elseif self.args.Role and self.args.Role.info then
    career = self.args.Role.info.career
  elseif self.args.roleInfo then
    career = self.args.roleInfo.career
  end
  return career
end

function Rank_EquipInfoUI:SuitBtnRefresh()
  self.haveHongZhuang = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetSuitManager():CheckHaveSuitByType(EquipCellType.HONGZHUANG)
  self:RefreshEquipBgByType(self.SuitBtnOpenState and EquipCellType.HONGZHUANG or EquipCellType.NORMAL)
  local bingJianSuitTypeList = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetSuitManager():GetBingJianDataMgr():GetHasEquipBingJianSuitTypeList()
  self.btn_NormalEquip:SetActive(true)
  if self.haveHongZhuang == false and next(bingJianSuitTypeList) == nil then
    self.btn_NormalEquip:SetActive(false)
    return
  end
  local suitBtnSpriteName, suitBtnLabelSpriteName = "ioc_equip", "big1_equip"
  if self.haveHongZhuang then
    suitBtnSpriteName = self.SuitBtnOpenState and "ioc_equip" or "ioc_redEquip"
    suitBtnLabelSpriteName = self.SuitBtnOpenState and "big1_equip" or "big1_redEquip"
  end
  self:SetSprite("Atlas_Common", suitBtnSpriteName, self.btn_NormalEquip)
  self:SetSprite("Atlas_Language", suitBtnLabelSpriteName, self.lab_img)
end

function Rank_EquipInfoUI:BingJianSuitSwitchContainerRefresh(suitType)
  local showSuitTypeList = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetSuitManager():GetBingJianDataMgr():GetHasEquipBingjianSuitTypeListBySelectType(suitType)
  self.Content:SetSizeDelta(self.btnSwitchWith * Mathf.Max(5, #showSuitTypeList), 0)
  self.btnSwitchContainer:SetData(showSuitTypeList)
end

function Rank_EquipInfoUI:RefreshEquipBgByType(type)
  local tbl = ClientTable.cfg_EquipCell_cellManager:GetBagIndexTblByEquipTypeDic()
  if tbl[type] == nil then
    return
  end
  for i, v in pairs(tbl[type]) do
    self:TrySetEquipObjBg(v)
  end
end

function Rank_EquipInfoUI:TrySetEquipObjBg(equipIndex)
  local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(equipIndex)
  local basicIndex = cellTbl and cellTbl.basicPositionSetting ~= 0 and cellTbl.basicPositionSetting or equipIndex % 100
  local obj = equipObjTable[basicIndex]
  if obj == nil then
    return
  end
  local bg = ClientTable.cfg_Global_globalManager:GetEquipBgSpiteByCellIndex(equipIndex, self:GetCurCareer())
  if bg ~= nil then
    self:SetSprite("Atlas_Tower", bg, obj)
  end
end

function Rank_EquipInfoUI:InitSwitchConfig()
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
  self.objEquipIndexShowByBingJian = {
    [true] = {
      ERoleEquipPosition.bingJian_orbs,
      ERoleEquipPosition.bingJian_signet,
      ERoleEquipPosition.bingJian_grail,
      ERoleEquipPosition.cloak
    },
    [false] = {
      ERoleEquipPosition.pet,
      ERoleEquipPosition.wing,
      ERoleEquipPosition.helm
    }
  }
end

function Rank_EquipInfoUI:TryRefreshEquipIndexObj(isBingJian, isSuit)
  local isShow
  for state, tbl in pairs(self.objEquipIndexShowByBingJian) do
    for i, v in pairs(tbl) do
      if equipObjTable[v] and not IsNil(equipObjTable[v].gameObject) then
        if v == ERoleEquipPosition.helm or v == ERoleEquipPosition.cloak then
          isShow = RoleEquipUtility.IsShowEquipIndexObjByCarrer(v, isBingJian, self:GetCurCareer())
        else
          isShow = isBingJian == state
        end
        equipObjTable[v]:SetActive(isShow)
      end
    end
  end
  for state, tbl in pairs(self.objEquipIndexShowBySuit) do
    for i, v in pairs(tbl) do
      if equipObjTable[v] and not IsNil(equipObjTable[v].gameObject) then
        equipObjTable[v]:SetActive(isSuit == state)
      end
    end
  end
end

function Rank_EquipInfoUI:HolySkeletonEquipSetChange()
  local SacredBoneEquipDataDic = gameMgr:GetAvatarManager():GetOtherPlayer():GetSacredBoneDataMgr():GetSacredBoneEquipDataByBoneEquipIndexMap()
  for position, sacredBoneEquipData in pairs(SacredBoneEquipDataDic) do
    for index, sacredBoneData in ipairs(sacredBoneEquipData.SacredBoneData) do
      if index == 1 then
        local img_LordSoul = equipInfoTable[position]:GetChild("hole/img_LordSoul")
        img_LordSoul:SetActive(true)
        if IsNil(img_LordSoul) then
          if sacredBoneData.SacredBoneSetType == false then
            img_LordSoul:SetActive(false)
          else
            self:SetSprite("Atlas_Common", "1600007", img_LordSoul)
          end
        end
      else
        local img_ViceSoul = equipInfoTable[position]:GetChild("hole/img_ViceSoul/ViceSoul_" .. index - 1)
        local img_on = img_ViceSoul:GetChild("img_on")
        img_on:SetActive(true)
        img_ViceSoul:GetChild("img_off"):SetActive(true)
        if IsNil(img_ViceSoul) then
          if sacredBoneData.SacredBoneLockType == false then
            img_ViceSoul:GetChild("img_off"):SetActive(false)
          end
          if sacredBoneData.SacredBoneSetType == false then
            img_on:SetActive(false)
          else
            local Number = "160000" .. sacredBoneData.SacredBoneEquip.Quality % 10
            self:SetSprite("Atlas_Common", Number, img_on)
          end
        end
      end
    end
  end
end
