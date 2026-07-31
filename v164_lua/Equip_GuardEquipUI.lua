Equip_GuardEquipUI = class(BaseUI)
Equip_GuardEquipUI.layer = UILayer.Panel
Equip_GuardEquipUI.orderInLayer = 0
Equip_GuardEquipUI.hideType = UIHideType.WaitDestroy
Equip_GuardEquipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_GuardEquipUI.escClose = UIEscClose.DontClose

function Equip_GuardEquipUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.btn_3DItem = self:GetControl("bg_equip/Equip_pet/Viewport/Content/btn_3DItem")
  self.btn_Item = self:GetControl("bg_equip/btn_Item")
  self.lb_name = self:GetControl("bg_equip/lb_name")
  self.helm_frame = self:GetControl("bg_equip/View_EquipFrame/helm_frame")
  self.necklace_frame = self:GetControl("bg_equip/View_EquipFrame/necklace_frame")
  self.glove_frame = self:GetControl("bg_equip/View_EquipFrame/glove_frame")
  self.boot_frame = self:GetControl("bg_equip/View_EquipFrame/boot_frame")
  self.descBtn = self:GetControl("descBtn")
end

function Equip_GuardEquipUI.GetGuardData()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData()
end

function Equip_GuardEquipUI:OnPreLoad()
end

function Equip_GuardEquipUI:Init()
  self.equipCellData = nil
end

function Equip_GuardEquipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_GuardEquipUI:InitUI()
  self.btn_3DItemTemp = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.Equip_GuardTopItemTemplate, self)
  self.CenterModel = ItemCellData()
  self.isRotating = true
  self.gridIndexTable = {
    helm = {
      [1] = 1100001,
      [2] = 1100005,
      [4] = 1100009
    },
    necklace = {
      [1] = 1100002,
      [2] = 1100006,
      [4] = 1100010
    },
    glove = {
      [1] = 1100003,
      [2] = 1100007,
      [4] = 1100011
    },
    boot = {
      [1] = 1100004,
      [2] = 1100008,
      [4] = 1100012
    }
  }
  self.equipObjTable = {
    [1100001] = self.helm_frame,
    [1100002] = self.necklace_frame,
    [1100003] = self.glove_frame,
    [1100004] = self.boot_frame,
    [1100005] = self.helm_frame,
    [1100006] = self.necklace_frame,
    [1100007] = self.glove_frame,
    [1100008] = self.boot_frame,
    [1100009] = self.helm_frame,
    [1100010] = self.necklace_frame,
    [1100011] = self.glove_frame,
    [1100012] = self.boot_frame
  }
end

function Equip_GuardEquipUI:OnShow()
  local guardInfoList = self.GetGuardData():GetGuardInfoList()
  if #guardInfoList == 0 then
    return
  end
  self.GetGuardData():SelectGuarItem(guardInfoList[1].nowtable.petType)
  self:OnRefresh()
  self:RegistEvents()
end

function Equip_GuardEquipUI:OnHide()
  self:EmptyCellData()
  self.equipCellData = nil
end

function Equip_GuardEquipUI:Update()
  if self.isRotating and self.CenterModel and self.CenterModel:GetModelData() and self.CenterModel.itemData ~= nil and self.CenterModel.itemData.tblItem ~= nil then
    RoleEquipUtility.EquipModelRotation(self.CenterModel:GetModelData(), self.CenterModel.itemData.tblItem.SpinAxis, 2)
  end
end

function Equip_GuardEquipUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.helm_frame.type = "helm"
  self.helm_frame:SetOnClick(self, self.EquipModelOnClick)
  self.necklace_frame.type = "necklace"
  self.necklace_frame:SetOnClick(self, self.EquipModelOnClick)
  self.glove_frame.type = "glove"
  self.glove_frame:SetOnClick(self, self.EquipModelOnClick)
  self.boot_frame.type = "boot"
  self.boot_frame:SetOnClick(self, self.EquipModelOnClick)
end

function Equip_GuardEquipUI:descBtnOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1057})
end

function Equip_GuardEquipUI:btn_closeOnClick(control)
  self.GetGuardData():CancelNowSelect()
  UIManager.Hide(UIID.Equip_GuardEquipUI)
end

function Equip_GuardEquipUI:EquipModelOnClick(control)
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil or nowSelectData.nowtable == nil then
    return
  end
  local type = control.type
  local index = self.gridIndexTable[type][nowSelectData.nowtable.petType]
  local equipData = self:GetEquipData()
  if equipData[index] then
    self:ShowTips(index, control)
  elseif not UIManager.IsVisible(UIID.NewBagInfoUI) then
    UIManager.Show(UIID.NewBagInfoUI)
  end
end

function Equip_GuardEquipUI:ShowTips(index, control)
  local itemInfo = RoleManager.me.data.equipsData:GetEquipByIndex(index)
  local rr = EItemOperateType.Disboard
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

function Equip_GuardEquipUI:GetEquipData()
  return RoleManager.me.data.equipsData.Data
end

function Equip_GuardEquipUI:RegistEvents()
  self:RegistEvent(Event.Guard_InfoChange, self.OnRefresh, self)
  self:RegistEvent(Event.Guard_SelectChange, self.OnRefresh, self)
  self:RegistEvent(Event.PutOnEquip, self.EquipInfoUpdate, self)
  self:RegistEvent(Event.TakeOffSuit, self.EquipInfoUpdate, self)
end

function Equip_GuardEquipUI:OnRefresh()
  local guardInfoList = self.GetGuardData():GetGuardInfoList()
  self.btn_3DItemTemp:SetData(guardInfoList)
  self:RefreshCenterModel()
  self:RefreshInactivatedActive()
  self:EquipInfoUpdate()
end

function Equip_GuardEquipUI:RefreshCenterModel()
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil or nowSelectData.nowtable == nil then
    return
  end
  local itemID = nowSelectData.nowtable.model
  if nowSelectData.guardStrengthen then
    itemID = nowSelectData.nowtable.strengthenModel
  end
  local itemData = ItemUtility.GenerateItemData(itemID)
  self.CenterModel:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_Item, self.CenterModel, self, false)
end

function Equip_GuardEquipUI:RefreshInactivatedActive()
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil or nowSelectData.nowtable == nil then
    return
  end
  if nowSelectData.guardStrengthen then
    self.lb_name:SetText(nowSelectData.nowtable.changeName)
  else
    self.lb_name:SetText(nowSelectData.nowtable.name)
  end
end

function Equip_GuardEquipUI:EquipInfoUpdate()
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil or nowSelectData.nowtable == nil then
    return
  end
  self:EmptyCellData()
  self.equipCellData = {}
  for k, v in pairs(self.gridIndexTable) do
    local index = v[nowSelectData.nowtable.petType]
    local equipData = self:GetEquipData()
    if equipData[index] then
      self:LoadEquipModel(self.equipObjTable[index], equipData[index])
    end
  end
end

function Equip_GuardEquipUI:LoadEquipModel(parent, itemData)
  if not parent then
    return
  end
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
  return cellData
end

function Equip_GuardEquipUI:EmptyCellData()
  if self.equipCellData == nil then
    return
  end
  for k, v in pairs(self.equipCellData) do
    if v and v.model then
      v:RecycleRes()
    end
  end
end
