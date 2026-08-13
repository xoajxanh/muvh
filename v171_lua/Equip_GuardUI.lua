Equip_GuardUI = class(BaseUI)
Equip_GuardUI.layer = UILayer.Panel
Equip_GuardUI.orderInLayer = 0
Equip_GuardUI.hideType = UIHideType.WaitDestroy
Equip_GuardUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_GuardUI.escClose = UIEscClose.DontClose

function Equip_GuardUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.frame_equip = self:GetControl("bg_equip/frame_equip")
  self.content = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content")
  self.lab = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab")
  self.text_atk = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_atkP/lab_atk/text_atk")
  self.text_atkArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_atkP/lab_atk/text_atkArrow")
  self.text_atknext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_atkP/lab_atk/text_atknext")
  self.text_atkimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_atkP/lab_atk/text_atkimg")
  self.text_def = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defP/lab_def/text_def")
  self.text_defArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defP/lab_def/text_defArrow")
  self.text_defnext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defP/lab_def/text_defnext")
  self.text_defimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defP/lab_def/text_defimg")
  self.text_defenseRate = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defenseRateP/lab_defenseRate/text_defenseRate")
  self.text_defenseRateArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defenseRateP/lab_defenseRate/text_defenseRateArrow")
  self.text_defenseRatenext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defenseRateP/lab_defenseRate/text_defenseRatenext")
  self.text_defenseRateimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_defenseRateP/lab_defenseRate/text_defenseRateimg")
  self.text_magic = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_magicP/lab_magic/text_magic")
  self.text_magicArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_magicP/lab_magic/text_magicArrow")
  self.text_magicnext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_magicP/lab_magic/text_magicnext")
  self.text_magicimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_magicP/lab_magic/text_magicimg")
  self.text_damageReceive = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_damageReceiveP/lab_damageReceive/text_damageReceive")
  self.text_damageReceiveArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_damageReceiveP/lab_damageReceive/text_damageReceiveArrow")
  self.text_damageReceivenext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_damageReceiveP/lab_damageReceive/text_damageReceivenext")
  self.text_damageReceiveimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_damageReceiveP/lab_damageReceive/text_damageReceiveimg")
  self.lab_movespeedP = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP")
  self.lab_movespeed = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP/lab_movespeed")
  self.text_movespeed = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP/lab_movespeed/text_movespeed")
  self.text_movespeedArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP/lab_movespeed/text_movespeedArrow")
  self.text_movespeednext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP/lab_movespeed/text_movespeednext")
  self.text_movespeedimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_movespeedP/lab_movespeed/text_movespeedimg")
  self.lab_appearanceChange = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_appearanceChange")
  self.text_Change = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab_appearanceChange/lab_appearanceImag/lab_appearance/text_Change")
  self.lab_material = self:GetControl("bg_equip/lab_material")
  self.text_gold = self:GetControl("bg_equip/lab_material/lab_gold/text_gold")
  self.frame_item1 = self:GetControl("bg_equip/lab_material/materialParent/frame_item1")
  self.frame_item2 = self:GetControl("bg_equip/lab_material/materialParent/frame_item2")
  self.text_successRate = self:GetControl("bg_equip/lab_material/text_successRate")
  self.btn_intensify = self:GetControl("bg_equip/btn_intensify")
  self.text_intensify = self:GetControl("bg_equip/btn_intensify/text_intensify")
  self.Equip_pet = self:GetControl("bg_equip/Equip_pet")
  self.btn_3DItem = self:GetControl("bg_equip/Equip_pet/Viewport/Content/btn_3DItem")
  self.go_levelGift = self:GetControl("bg_equip/go_levelGift")
  self.lab_finish = self:GetControl("bg_equip/go_levelGift/lab_finish")
  self.unfinished_Panel = self:GetControl("bg_equip/go_levelGift/unfinished_Panel")
  self.level_Item = self:GetControl("bg_equip/go_levelGift/unfinished_Panel/level_Item")
  self.btn_getGift = self:GetControl("bg_equip/go_levelGift/unfinished_Panel/btn_getGift")
  self.showBtn = self:GetControl("bg_equip/petShow/show/Background")
  self.showCheckmark = self:GetControl("bg_equip/petShow/show/Background/Checkmark")
  self.showCheckmarkBG = self:GetControl("bg_equip/petShow/show/Background/img_bg")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.descBtn = self:GetControl("descBtn")
  self.btn_role = self:GetControl("panel_role/btn_role")
  self.btn_bag = self:GetControl("panel_bag/btn_bag")
  self.btn_close = self:GetControl("btn_close")
  self.starNum = self:GetControl("bg_equip/starNum")
  self.starNum_1 = self:GetControl("bg_equip/starNum/1/Star")
  self.starNum_2 = self:GetControl("bg_equip/starNum/2/Star")
  self.starNum_3 = self:GetControl("bg_equip/starNum/3/Star")
  self.starNum_4 = self:GetControl("bg_equip/starNum/4/Star")
  self.starNum_5 = self:GetControl("bg_equip/starNum/5/Star")
  self.starNum_6 = self:GetControl("bg_equip/starNum/6/Star")
  self.starNum_7 = self:GetControl("bg_equip/starNum/7/Star")
  self.starNum_8 = self:GetControl("bg_equip/starNum/8/Star")
  self.starNum_9 = self:GetControl("bg_equip/starNum/9/Star")
  self.starNum_10 = self:GetControl("bg_equip/starNum/10/Star")
  self.btn_Item = self:GetControl("bg_equip/btn_Item")
  self.lab_material = self:GetControl("bg_equip/lab_material")
  self.petShow = self:GetControl("bg_equip/petShow")
  self.lb_name = self:GetControl("bg_equip/lb_name")
  self.LevelUp = self:GetControl("bg_equip/LevelUp")
  self.img_Guardlevel = self:GetControl("bg_equip/LevelUp/img_Guardlevel")
  self.img_Guardlevelnext = self:GetControl("bg_equip/LevelUp/img_Guardlevelnext")
  self.img_attributeArrow = self:GetControl("bg_equip/LevelUp/img_attributeArrow")
end

function Equip_GuardUI.GetGuardData()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData()
end

function Equip_GuardUI:OnPreLoad()
end

function Equip_GuardUI:Init()
end

function Equip_GuardUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_GuardUI:InitUI()
  self.btn_3DItemTemp = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.Equip_GuardTopItemTemplate, self)
  self.AttributesTemp = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.Equip_GuardAttributesTemplate, self)
  self.ConsumeTemp = UIUtility.BindUIContainerTemp(self.frame_item1, LuaComponentTemplates.Equip_GuardConsumeTemplate, self)
  self.StrengthenGuardian = ItemCellData()
  self.CenterModel = ItemCellData()
  self.isRotating = true
end

function Equip_GuardUI:OnShow()
  local guardInfoList = self.GetGuardData():GetGuardInfoList()
  if #guardInfoList == 0 then
    return
  end
  self.GetGuardData():SelectGuarItem(guardInfoList[1].nowtable.petType)
  self:OnRefresh()
  self:RegistEvents()
end

function Equip_GuardUI:Update()
  if self.isRotating and self.CenterModel and self.CenterModel:GetModelData() and self.CenterModel.itemData ~= nil and self.CenterModel.itemData.tblItem ~= nil then
    RoleEquipUtility.EquipModelRotation(self.CenterModel:GetModelData(), self.CenterModel.itemData.tblItem.SpinAxis, 2)
  end
end

function Equip_GuardUI:RegistUIEvents()
  self.btn_intensify:SetOnClick(self, self.btn_intensifyOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.showBtn:SetOnClick(self, self.showOnClick)
  self.btn_getGift:SetOnClick(self, self.btn_getGiftOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Equip_GuardUI:btn_intensifyOnClick(control)
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil then
    return
  end
  local isneed, itemID = self.GetGuardData():TryGetDissatisfyConsumeMaterial()
  if isneed == true then
    self:GetHuoQuTip(itemID)
    return
  end
  if nowSelectData.IsNeedJiHuo then
    networkRequest.ReqActivationGuard(nowSelectData.id)
  else
    networkRequest.ReqLevelStarGuard(nowSelectData.id)
    if nowSelectData.nextTable ~= nil then
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
    end
  end
end

function Equip_GuardUI:GetHuoQuTip(itemid)
  if itemid == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(itemid)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = self.btn_intensify,
    ShowObtain = true,
    OpenWay = EOpenTipsType.FastBuy
  })
end

function Equip_GuardUI:showOnClick(control, isOn)
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil or nowSelectData.isWear == true then
    return
  end
  networkRequest.ReqSetGuardAppearance(nowSelectData.id, 1)
end

function Equip_GuardUI:btn_getGiftOnClick()
  UIManager.Show(UIID.Tip_GuardToGiftUI)
end

function Equip_GuardUI:descBtnOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1057})
end

function Equip_GuardUI:btn_closeOnClick(control)
  self.GetGuardData():CancelNowSelect()
  UIManager.Hide(UIID.Equip_GuardUI)
end

function Equip_GuardUI:RegistEvents()
  self:RegistEvent(Event.Guard_InfoChange, self.OnRefresh, self)
  self:RegistEvent(Event.Guard_SelectChange, self.OnRefresh, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
end

function Equip_GuardUI:OnRefresh()
  local guardInfoList = self.GetGuardData():GetGuardInfoList()
  self.btn_3DItemTemp:SetData(guardInfoList)
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  local attributesData = self.GetGuardData():GetAttributesShowInfoList(nowSelectData, false)
  local ConsumeData = self.GetGuardData():GetConsumeMaterialList(nowSelectData)
  self.AttributesTemp:SetData(attributesData)
  local isNotMax = nowSelectData ~= nil and nowSelectData.nextTable ~= nil
  if isNotMax then
    self.ConsumeTemp:SetData(ConsumeData)
  else
    self.ConsumeTemp:SetData({})
  end
  self.lab_material:SetActive(isNotMax)
  self:RefreshStrengthenGuardian()
  self:RefreshStar()
  self:RefreshUpgradeBtn()
  self:RefreshCenterModel()
  self:RefreshWearStart()
  self:RefreshInactivatedActive()
end

function Equip_GuardUI:OnResBagChange()
  self.ConsumeTemp:Refresh()
  self.btn_3DItemTemp:Refresh()
end

function Equip_GuardUI:RefreshStrengthenGuardian()
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  local isShowStrengthenGuardian = nowSelectData ~= nil and nowSelectData.nowtable ~= nil and nowSelectData.guardStrengthen == false and self.GetGuardData():IsSatisfyStrengthenCondition(nowSelectData.nowtable.petType) and nowSelectData.IsNeedJiHuo == false
  self.go_levelGift:SetActive(isShowStrengthenGuardian)
  if isShowStrengthenGuardian == false then
    return
  end
  local itemData = ItemUtility.GenerateItemData(nowSelectData.nowtable.strengthenModel)
  self.StrengthenGuardian:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.level_Item, self.StrengthenGuardian, self, true)
end

function Equip_GuardUI:RefreshStar()
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil then
    self.img_Guardlevel:SetText(0)
    self.img_Guardlevelnext:SetText(1)
    return
  end
  local nowLevel = ""
  local nexLevel = ""
  if nowSelectData.nowtable ~= nil then
    nowLevel = nowSelectData.nowtable.petLevel
  end
  if nowSelectData.nextTable ~= nil then
    nexLevel = nowSelectData.nextTable.petLevel
  end
  self.img_Guardlevel:SetText(nowLevel)
  self.img_Guardlevelnext:SetText(nexLevel)
  self.img_attributeArrow:SetActive(nowSelectData.nextTable ~= nil)
end

function Equip_GuardUI:RefreshInactivatedActive()
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil then
    return
  end
  self.petShow:SetActive(nowSelectData.IsNeedJiHuo == false or nowSelectData.guardStrengthen)
  self.starNum:SetActive(false)
  self.LevelUp:SetActive(nowSelectData.IsNeedJiHuo == false)
  if nowSelectData.nowtable ~= nil then
    if nowSelectData.guardStrengthen then
      self.lb_name:SetText(nowSelectData.nowtable.changeName)
    else
      self.lb_name:SetText(nowSelectData.nowtable.name)
    end
  end
end

function Equip_GuardUI:RefreshUpgradeBtn()
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil then
    return
  end
  local text = "\196\144\225\187\153t ph\195\161"
  local iconName = "ty_btn_new_one_new"
  if nowSelectData.IsNeedJiHuo then
    text = "Mua"
    iconName = "ty_btn_new_one_new"
  elseif nowSelectData.nextTable == nil then
    text = "\196\144\195\163 \196\145\225\186\167y c\225\186\165p"
  end
  self:SetSprite("Atlas_Common", iconName, self.btn_intensify)
  self.text_intensify:SetText(text)
end

function Equip_GuardUI:GetStarObjectList()
  if self.StarList == nil then
    self.StarList = {}
    self.StarList[1] = self.starNum_1
    self.StarList[2] = self.starNum_2
    self.StarList[3] = self.starNum_3
    self.StarList[4] = self.starNum_4
    self.StarList[5] = self.starNum_5
    self.StarList[6] = self.starNum_6
    self.StarList[7] = self.starNum_7
    self.StarList[8] = self.starNum_8
    self.StarList[9] = self.starNum_9
    self.StarList[10] = self.starNum_10
  end
  return self.StarList
end

function Equip_GuardUI:RefreshCenterModel()
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

function Equip_GuardUI:RefreshWearStart()
  local nowSelectData = self.GetGuardData():GetNowSelectGuarItem()
  if nowSelectData == nil then
    return
  end
  self.showCheckmark:SetActive(nowSelectData.isWear)
  self.showCheckmarkBG:SetActive(not nowSelectData.isWear)
end
