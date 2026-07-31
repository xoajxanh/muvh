Equip_GuardCultivateUI = class(BaseUI)
Equip_GuardCultivateUI.layer = UILayer.Panel
Equip_GuardCultivateUI.orderInLayer = 0
Equip_GuardCultivateUI.hideType = UIHideType.WaitDestroy
Equip_GuardCultivateUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_GuardCultivateUI.escClose = UIEscClose.DontClose

function Equip_GuardCultivateUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.btn_3DItem = self:GetControl("bg_equip/Equip_pet/Viewport/Content/btn_3DItem")
  self.btn_Item = self:GetControl("bg_equip/btn_Item")
  self.lb_name = self:GetControl("bg_equip/lb_name")
  self.sl_progress = self:GetControl("bg_equip/sl_progress")
  self.lab_progress = self:GetControl("bg_equip/sl_progress/lab_progress")
  self.lab_level = self:GetControl("bg_equip/sl_progress/lab_level")
  self.lab = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab")
  self.lab_material = self:GetControl("bg_equip/lab_material")
  self.frame_item1 = self:GetControl("bg_equip/lab_material/materialParent/frame_item1")
  self.btn_levelUp = self:GetControl("bg_equip/btn_levelUp")
  self.text_intensify = self:GetControl("bg_equip/btn_levelUp/text_intensify")
  self.descBtn = self:GetControl("descBtn")
end

function Equip_GuardCultivateUI.GetGuardData()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData()
end

function Equip_GuardCultivateUI:OnPreLoad()
end

function Equip_GuardCultivateUI:Init()
end

function Equip_GuardCultivateUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_GuardCultivateUI:InitUI()
  self.btn_3DItemTemp = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.Equip_GuardTopItemTemplate, self)
  self.AttributesContainer = UIContainer(self.lab, self, self.OnAttributesCreat, self.OnAttributesRefresh)
  self.ConsumeContainer = UIContainer(self.frame_item1, self, self.OnConsumeCreat, self.OnConsumeRefresh)
  self.CenterModel = ItemCellData()
  self.isRotating = true
end

function Equip_GuardCultivateUI:OnShow()
  local guardInfoList = self.GetGuardData():GetGuardCultureInfoList()
  if #guardInfoList == 0 then
    return
  end
  self.GetGuardData():SelectGuarItem(guardInfoList[1].nowtable.petType)
  self:OnRefresh()
  self:RegistEvents()
end

function Equip_GuardCultivateUI:Update()
  if self.isRotating and self.CenterModel and self.CenterModel:GetModelData() and self.CenterModel.itemData ~= nil and self.CenterModel.itemData.tblItem ~= nil then
    RoleEquipUtility.EquipModelRotation(self.CenterModel:GetModelData(), self.CenterModel.itemData.tblItem.SpinAxis, 2)
  end
end

function Equip_GuardCultivateUI:RegistUIEvents()
  self.btn_levelUp:SetOnClick(self, self.btn_levelUpOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Equip_GuardCultivateUI:btn_levelUpOnClick(control)
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil then
    return
  end
  local itemId
  for i = 1, #self.ConsumeContainer.items do
    local item = self.ConsumeContainer.items[i]
    local isSelected = item.tog.toggle.isOn
    if isSelected then
      itemId = self.ConsumeContainer.data[i].ItemID
      break
    end
  end
  if itemId then
    networkRequest.ReqLevelStarGuard(nowSelectData.id, itemId)
  end
end

function Equip_GuardCultivateUI:descBtnOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1057})
end

function Equip_GuardCultivateUI:btn_closeOnClick(control)
  self.GetGuardData():CancelNowSelect()
  UIManager.Hide(UIID.Equip_GuardCultivateUI)
end

function Equip_GuardCultivateUI:RegistEvents()
  self:RegistEvent(Event.Guard_InfoChange, self.OnRefresh, self)
  self:RegistEvent(Event.Guard_SelectChange, self.OnRefresh, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
end

function Equip_GuardCultivateUI:OnRefresh()
  local guardInfoList = self.GetGuardData():GetGuardCultureInfoList()
  self.btn_3DItemTemp:SetData(guardInfoList)
  self:RefreshCenterModel()
  self:RefreshInactivatedActive()
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  local ConsumeData = self.GetGuardData():GetCultureConsumeMaterialList()
  local isNotMax = nowSelectData ~= nil and nowSelectData.nextTableCulture ~= nil
  if isNotMax then
    self.ConsumeContainer:SetData(ConsumeData)
  else
    self.ConsumeContainer:SetData({})
  end
  self.lab_material:SetActive(isNotMax)
  local attributesData = self.GetGuardData():GetCultureAttributesShowInfoList(nowSelectData, false)
  self.AttributesContainer:SetData(attributesData)
  self:RefreshUpgradeBtn()
end

function Equip_GuardCultivateUI:OnResBagChange()
  self.ConsumeContainer:Refresh()
end

function Equip_GuardCultivateUI:RefreshCenterModel()
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

function Equip_GuardCultivateUI:RefreshInactivatedActive()
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil then
    return
  end
  if nowSelectData.nowtable ~= nil then
    if nowSelectData.guardStrengthen then
      self.lb_name:SetText(nowSelectData.nowtable.changeName)
    else
      self.lb_name:SetText(nowSelectData.nowtable.name)
    end
  end
  if nowSelectData.nextTableCulture then
    local upgradeExp = nowSelectData.nextTableCulture.upgradeExp
    self.sl_progress.slider.value = nowSelectData.cultureExp / upgradeExp
    self.lab_progress:SetText(nowSelectData.cultureExp .. "/" .. upgradeExp)
  else
    self.sl_progress.slider.value = 1
    self.lab_progress:SetText("\196\144\195\163 \196\145\225\186\167y c\225\186\165p")
  end
  self.lab_level:SetText("Lv." .. nowSelectData.cultureLevel)
end

function Equip_GuardCultivateUI.OnAttributesCreat(ctr)
  ctr.lab_des = UIControl(ctr.transform, "lab_atk")
  ctr.lab_nowDes = UIControl(ctr.transform, "lab_atk/text_atk")
  ctr.lab_nextDes = UIControl(ctr.transform, "lab_atk/text_atknext")
end

function Equip_GuardCultivateUI.OnAttributesRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  local des, now, next = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():GetCultureAttributesShowInfo(data.GuardInfoItem, data.AttributesName)
  ctr.lab_des:SetText(des)
  ctr.lab_nowDes:SetText(now)
  ctr.lab_nextDes:SetText(next)
end

function Equip_GuardCultivateUI.OnConsumeCreat(ctr)
  ctr.go_model_Icon = UIControl(ctr.transform, "Model")
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.lab_num = UIControl(ctr.transform, "lab_num")
  ctr.btn_obtain = UIControl(ctr.transform, "btn_obtain")
  ctr.tog = UIControl(ctr.transform, "tog")
  ctr.go_modelData = ItemCellData()
  ctr.btn_obtain:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Equip_GuardCultivateUI.OnConsumeRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.ItemID)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(data.ItemID)
  local Text = bagCount
  if bagCount <= 0 then
    Text = string.format("<color=red>%s</color>", Text)
  end
  ctr.lab_num:SetText(Text)
  ctr.lab_name:SetText(itemData.tblItem.name)
  ctr.go_modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.go_model_Icon, ctr.go_modelData, ui, true)
  ctr.btn_obtain:SetActive(bagCount <= 0)
  ctr.btn_obtain.itemData = itemData
  ctr.btn_obtain.OpenTipsType = EOpenTipsType.FastBuy
end

function Equip_GuardCultivateUI:RefreshUpgradeBtn()
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil then
    return
  end
  local text = "\196\144\225\187\153t ph\195\161"
  if nowSelectData.nextTableCulture == nil then
    text = "\196\144\195\163 \196\145\225\186\167y c\225\186\165p"
  end
  self.text_intensify:SetText(text)
end
