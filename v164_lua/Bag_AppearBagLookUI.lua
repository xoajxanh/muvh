Bag_AppearBagLookUI = class(BaseUI)
Bag_AppearBagLookUI.layer = UILayer.Panel
Bag_AppearBagLookUI.orderInLayer = 0
Bag_AppearBagLookUI.hideType = UIHideType.WaitDestroy
Bag_AppearBagLookUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_AppearBagLookUI.escClose = UIEscClose.DontClose

function Bag_AppearBagLookUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.titleImg = self:GetControl("titleImg")
  self.titleImg_model = self:GetControl("titleImg_model")
  self.obj_titleEffect = self:GetControl("obj_titleEffect")
  self.Button_CloseBag = self:GetControl("Button_CloseBag")
  self.petParent = self:GetControl("petParent")
  self.go_model = self:GetControl("AppearLook/go_model")
  self.btn_CoutureAllAttribute = self:GetControl("btn_CoutureAllAttribute")
end

function Bag_AppearBagLookUI:OnPreLoad()
end

function Bag_AppearBagLookUI:Init()
end

function Bag_AppearBagLookUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Bag_AppearBagLookUI:InitUI()
end

function Bag_AppearBagLookUI:OnShow()
  self:RegistEvents()
  self.RoleBuff = {}
  self:Refresh()
end

function Bag_AppearBagLookUI:OnHide()
  self.titleImg:SetActive(false)
  self:RemoveTitleEffect()
  if self.petCellData then
    self.petCellData:RecycleRes()
  end
  self.petCellData = nil
  if self.lookRole then
    self.lookRole:DestroyModel()
    self.lookRole:DestroyEquip()
    self.lookRole:Destroy()
    self.lookRole = nil
  end
  if type(self.buffEffectLids) == "table" then
    gameMgr:GetEffectManager():GetBuffEffectProcessor():RemoveEffects(self.buffEffectLids)
  end
  self.RoleBuff = nil
  UIManager.Hide(UIID.AppearBagInfoUI)
end

function Bag_AppearBagLookUI:OnDestroy()
  if type(self.buffEffectLids) == "table" then
    gameMgr:GetEffectManager():GetBuffEffectProcessor():RemoveEffects(self.buffEffectLids)
  end
end

function Bag_AppearBagLookUI:Update()
  if self.isShowPetAnim and self.petCellData and self.petCellData.model and self.petCellData.model.modelObject then
    self.isShowPetAnim = false
    self.petAnim:Init(self.petCellData.model.modelObject, true, true)
    self.petAnim:PlayTest("idle")
  end
end

function Bag_AppearBagLookUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.Button_CloseBag:SetOnClick(self, self.Button_CloseBagOnClick)
  self.go_model:SetOnDrag(self, self.DragViewRole)
  self.btn_CoutureAllAttribute:SetOnClick(self, self.btn_CoutureAllAttributeOnClick)
end

function Bag_AppearBagLookUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.AppearBagLookUI)
end

function Bag_AppearBagLookUI:Button_CloseBagOnClick(control)
  UIManager.Hide(UIID.AppearBagLookUI)
end

function Bag_AppearBagLookUI:DragViewRole(control, eventData)
  if self.lookRole then
    local rotY = self.lookRole.dir
    rotY = rotY - eventData.delta.x
    self.lookRole:SetRotation(0, rotY, 0)
  end
end

function Bag_AppearBagLookUI:btn_CoutureAllAttributeOnClick()
  UIManager.Show(UIID.Tip_CommonTipsUI, {
    showType = CommonTipsEnum.Couture
  })
end

function Bag_AppearBagLookUI:RegistEvents()
  self:RegistEvent(Event.Equip_AppearChange, self.AppearItemOnClick, self)
  self:RegistEvent(Event.Equip_AppearPetChange, self.SetPetModelShow, self)
  self:RegistEvent(Event.Equip_AppearNameChange, self.AppearNameItemOnClick, self)
  self:RegistEvent(Event.Equip_AppearRingChange, self.AppearRingItemOnClick, self)
  self:RegistEvent(Event.Appear_CouturToggleChange, self.Appear_CouturToggleChange, self)
  self:RegistEvent(Event.Appear_FashionSuccess, self.Appear_FashionSuccess, self)
  self:RegistEvent(Event.Appear_AllAttributeBtnRefresh, self.Appear_AllAttributeBtnRefresh, self)
  self:RegistEvent(Event.Appear_ClearChoose, self.Refresh, self)
end

function Bag_AppearBagLookUI:Refresh()
  local buffData = BuffData.GetBuffs(RoleManager.me.id)
  if table.count(buffData) > 0 then
    for i, v in pairs(buffData) do
      local configBuff = ClientTable.cfg_Buff_buffManager:TryGetValue(v.buffCId)
      local checkUseEff = false
      if configBuff.coutureEffect and configBuff.coutureEffect == 1 then
        checkUseEff = true
      end
      if checkUseEff then
        table.insert(self.RoleBuff, v.buffCId)
      end
    end
  end
  local titleData = ViewData.meData.titleData:GetShowTitleData()
  self:SetTitleShow(titleData)
  if type(self.buffEffectLids) == "table" then
    gameMgr:GetEffectManager():GetBuffEffectProcessor():RemoveEffects(self.buffEffectLids)
  end
  self.viewRoleData = {}
  local equip = table.DeepCopy(ViewData.meData.equipsData.Data)
  self.viewRoleData.equipsData = RoleEquipData(equip)
  self.viewRoleData.career = ViewData.meData.career
  self.viewRoleData.modelType = EModelType.Charactor
  self.viewRoleData.model = RoleEquipUtility.GetCurPlayerModelName(ForgeData.appearData[ViewData.meData.id], self.viewRoleData.equipsData.Data)
  self.viewRoleData.id = tonumber(self.viewRoleData.model)
  self.viewRoleData.roleName = ViewData.meData.name
  self.viewRoleData.serverCoord = Vector2Int()
  self.viewRoleData.roleType = ERoleType.Player
  self.viewRoleData.parent = self.go_model.transform
  self.viewRoleData.parent = self.go_model.transform
  self.viewRoleData.animationName = "idle"
  self.viewRoleData.isCurSafeZone = false
  ForgeData.appearData[self.viewRoleData.id] = ForgeData.appearData[ViewData.meData.id]
  if self.lookRole then
    self.lookRole:RefreshModel(self.viewRoleData)
  else
    self.lookRole = ViewRole(self.viewRoleData)
  end
  self.lookRole:SetPosition(-10, -163, -150)
  self.lookRole:SetRotation(0, 180, 0)
  if self.lookRole.RolePet then
    self.lookRole.RolePet:Destroy()
    self.lookRole.RolePet = nil
  end
  if 0 < table.count(self.RoleBuff) and self.lookRole then
    self.buffEffectLids = gameMgr:GetEffectManager():GetBuffEffectProcessor():AddEffects(self.RoleBuff, self.lookRole.model.BuffAnchor)
  end
  self:SetPetModelShow()
end

function Bag_AppearBagLookUI:AppearNameItemOnClick(_, data)
  if data.index then
    local titleData = ViewData.meData.titleData.TitleInfo[data.index]
    self:SetTitleShow(titleData)
  else
    self:SetTitleShow()
  end
end

function Bag_AppearBagLookUI:AppearRingItemOnClick(_, data)
  self.lookRole:DestroyModel()
  self.lookRole:DestroyEquip()
  if data.itemData then
    self.viewRoleData.id = tonumber(data.itemData.tblEquip.transformation)
    self.viewRoleData.model = data.itemData.tblEquip.transformation
    local tab = self:HandleAppearData(self.viewRoleData.id, self.viewRoleData.equipsData.Data)
    tab.equip_model = data.itemData.bagGridIndex
    local appear = json.encode(tab)
    ForgeData.appearData[self.viewRoleData.id] = appear
  else
    self.viewRoleData.id = tonumber(ERoleModelName.default)
    self.viewRoleData.model = ERoleModelName.default
    local tab = self:HandleAppearData(self.viewRoleData.id, self.viewRoleData.equipsData.Data)
    tab.equip_model = nil
    local appear = json.encode(tab)
    ForgeData.appearData[self.viewRoleData.id] = appear
  end
  self.lookRole:InitAttribute(self.viewRoleData)
  self.lookRole:InitModel()
  self.lookRole:SetPosition(-10, -163, -150)
  self.lookRole:SetRotation(0, 180, 0)
  self:SetPetModelShow()
end

function Bag_AppearBagLookUI:AppearItemOnClick(_, data)
  self:UpdateAppearSaveData(data)
  self:SetPetModelShow()
  if self.viewRoleData.id ~= tonumber(ERoleModelName.default) then
    return
  end
  self.lookRole:RefreshModel(self.viewRoleData)
  self.lookRole:SetPosition(-10, -163, -150)
  self.lookRole:SetRotation(0, 180, 0)
end

function Bag_AppearBagLookUI:HandleAppearData(id, data)
  local Tab = {}
  if not ForgeData.appearData[id] or string.isNullOrEmpty(ForgeData.appearData[id]) then
    ForgeData.appearData[id] = "{}"
  end
  local temp = json.decode(ForgeData.appearData[id])
  for i, v in pairs(temp) do
    if data then
      if data[v] then
        Tab[i] = v
      end
    else
      Tab[i] = v
    end
  end
  return Tab
end

function Bag_AppearBagLookUI:UpdateAppearSaveData(data)
  if table.count(data) > 0 then
    local reqTab = {}
    for i, v in pairs(data) do
      if v then
        local relativeIndex = ClientTable.cfg_EquipCell_cellManager:GetCurPosition(v)
        if relativeIndex == ERoleEquipPosition.helm then
          reqTab.equip_helm = v
        elseif relativeIndex == ERoleEquipPosition.right_weapon then
          reqTab.equip_right = v
        elseif relativeIndex == ERoleEquipPosition.left_weapon then
          reqTab.equip_left = v
        elseif relativeIndex == ERoleEquipPosition.armor then
          reqTab.equip_armor = v
        elseif relativeIndex == ERoleEquipPosition.glove then
          reqTab.equip_glove = v
        elseif relativeIndex == ERoleEquipPosition.pant then
          reqTab.equip_pant = v
        elseif relativeIndex == ERoleEquipPosition.boot then
          reqTab.equip_boot = v
        elseif relativeIndex == ERoleEquipPosition.pet then
          reqTab.equip_pet = v
        elseif relativeIndex == ERoleEquipPosition.cloak then
          reqTab.equip_cloak = v
        elseif relativeIndex == ERoleEquipPosition.wing then
          reqTab.equip_wing = v
        end
      end
    end
    local appear = json.encode(reqTab)
    ForgeData.appearData[self.viewRoleData.id] = appear
  end
end

function Bag_AppearBagLookUI:SetTitleShow(titleData)
  if titleData then
    if ViewData.meData.equipsData:GetEquipByIndex(ERoleEquipPosition.wing) then
      self.titleImg:SetAnchoredPosition(0, 160)
      self.titleImg_model:SetAnchoredPosition(0, 160)
    else
      self.titleImg:SetAnchoredPosition(0, 200)
      self.titleImg_model:SetAnchoredPosition(0, 200)
    end
    if titleData.tblItem and string.isNullOrEmpty(titleData.tblItem.modelEffect) then
      self:SetSprite("Atlas_Language", titleData.tblItem.icon, self.titleImg)
    else
      self.titleImg:SetActive(false)
    end
    self:ShowTitleEffect(titleData.tblItem.id)
  else
    self.titleImg:SetActive(false)
    self:RemoveTitleEffect()
  end
end

function Bag_AppearBagLookUI:SetPetModelShow(_, petData)
  local petData = petData or RoleEquipUtility.GetCurEquipShowData(ForgeData.appearData[self.viewRoleData.id], self.viewRoleData.equipsData.Data, ERoleEquipPosition.pet)
  if petData then
    if not self.petCellData then
      self.petCellData = ItemCellData()
    end
    self.petCellData:RefreshData(petData)
    ItemUtility.ShowItemCell(self.petParent, self.petCellData, self)
    self:SetPetAnimPlay()
  end
  if ViewData.meData.equipsData:GetEquipByIndex(ERoleEquipPosition.wing) then
    self.petParent:SetAnchoredPosition(749, -170)
  else
    self.petParent:SetAnchoredPosition(749, -234)
  end
end

function Bag_AppearBagLookUI:SetPetAnimPlay()
  if not self.petAnim then
    self.petAnim = AnimatorCtrl()
  end
  if not (self.petCellData and self.petCellData.model) or not self.petCellData.model.modelObject then
    self.isShowPetAnim = true
    return
  end
  if self.petCellData and self.petCellData.model and self.petCellData.model.modelObject then
    self.petAnim:Init(self.petCellData.model.modelObject, true, true)
    self.petAnim:PlayTest("idle")
  end
end

function Bag_AppearBagLookUI:Appear_CouturToggleChange(id, isShow)
  self.btn_CoutureAllAttribute:SetActive(isShow)
end

function Bag_AppearBagLookUI:Appear_FashionSuccess()
  self:Refresh()
end

function Bag_AppearBagLookUI:Appear_AllAttributeBtnRefresh(id, isShow)
  self.btn_CoutureAllAttribute:SetActive(isShow)
end

function Bag_AppearBagLookUI:GetTitleEffectProcessor()
  return gameMgr:GetEffectManager():GetEffectActionUtility():GetEffectProcessor(EffectProcessorType.UI_Title)
end

function Bag_AppearBagLookUI:ShowTitleEffect(_itemId)
  if self.titleImg_model and not IsNil(self.titleImg_model.transform) and self:GetTitleEffectProcessor() then
    self.titleEffectLid = self:GetTitleEffectProcessor():InstantiationEffect({
      lid = self.titleEffectLid,
      itemId = _itemId,
      panel = self
    }, self.titleImg_model.transform)
  end
end

function Bag_AppearBagLookUI:RemoveTitleEffect()
  if self.titleEffectLid then
    self:GetTitleEffectProcessor():RemoveEffect(self.titleEffectLid)
  end
end
