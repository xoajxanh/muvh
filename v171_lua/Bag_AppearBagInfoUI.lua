Bag_AppearBagInfoUI = class(BaseUI)
Bag_AppearBagInfoUI.layer = UILayer.Panel
Bag_AppearBagInfoUI.orderInLayer = 0
Bag_AppearBagInfoUI.hideType = UIHideType.WaitDestroy
Bag_AppearBagInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_AppearBagInfoUI.escClose = UIEscClose.DontClose

function Bag_AppearBagInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.titil = self:GetControl("titil")
  self.Button_Save = self:GetControl("Button_Save")
  self.Button_Not = self:GetControl("Button_Not")
  self.Button_CloseBag = self:GetControl("Button_CloseBag")
  self.btn_3DItem = self:GetControl("btn_3DItem")
  self.Scroll_Appear = self:GetControl("Scroll_Appear")
  self.groupAtt = self:GetControl("Scroll_Appear/groupAtt")
  self.ScrollAttEquip = self:GetControl("Scroll_Appear/groupAtt/ScrollAttEquip")
  self.attrEquipItem = self:GetControl("Scroll_Appear/groupAtt/ScrollAttEquip/Content/attrEquipItem")
  self.AppearBg = self:GetControl("Scroll_Appear/AppearBg")
  self.apViewport = self:GetControl("Scroll_Appear/apViewport")
  self.parentContent = self:GetControl("Scroll_Appear/apViewport/parentContent")
  self.parentItem = self:GetControl("Scroll_Appear/apViewport/parentContent/parentItem")
  self.Scroll_BagInfo = self:GetControl("Scroll_Appear/apViewport/parentContent/parentItem/Scroll_BagInfo")
  self.childContent = self:GetControl("Scroll_Appear/apViewport/parentContent/parentItem/Scroll_BagInfo/Viewport/childContent")
  self.Scroll_Name = self:GetControl("Scroll_Name")
  self.nameItem = self:GetControl("Scroll_Name/Viewport/Content/nameItem")
  self.attributeItem = self:GetControl("Scroll_Name/sw_titleAttribute/Viewport2/Content/attributeItem")
  self.Scroll_jewelryBox = self:GetControl("Scroll_jewelryBox")
  self.jewelryItem = self:GetControl("Scroll_jewelryBox/Viewport/Content/jewelryItem")
  self.attributeRingItem = self:GetControl("Scroll_jewelryBox/Viewport2/Content/attributeRingItem")
  self.tog_appear = self:GetControl("toggleParent/tog_appear")
  self.tog_name = self:GetControl("toggleParent/tog_name")
  self.tog_jewelryBox = self:GetControl("toggleParent/tog_jewelryBox")
  self.tog_Illusion = self:GetControl("toggleParent/tog_Illusion")
  self.tog_Couture = self:GetControl("toggleParent/tog_Couture")
  self.Scroll_Illusion = self:GetControl("Scroll_Illusion")
  self.Scroll_Couture = self:GetControl("Scroll_Couture")
  self.illusionItem = self:GetControl("Scroll_Illusion/Viewport/Content/jewelryItem")
  self.IllusionattributeRingItem = self:GetControl("Scroll_Illusion/Viewport2/Content/attributeRingItem")
end

function Bag_AppearBagInfoUI:OnPreLoad()
end

function Bag_AppearBagInfoUI:Init()
  self.saveBagIndexTab = {}
  self.saveBagIndexCopyTab = {}
  self.childItemTab = {}
  self.nameIndex = 0
  self.objPool = {}
  self.objCellDataPool = {}
  self.nameTimer = {}
  self.attTimer = {}
  self.ringTimer = {}
  self.ringCellData = {}
  self.equipFashion = {timeEquip = 2}
  self.appearWidth = 387
  self.appearMinHeight = 289
  self.appearMaxHeight = 521
end

function Bag_AppearBagInfoUI:OnCreate()
  self:InitControls()
  self:InitData()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnNameCreate(control)
  control.img_niceName_model = control:GetChild("img_niceName_model")
  control.img_title = control:GetChild("img_niceName")
end

local function RemoveDataByIndex(tab, index)
  for j = 1, table.count(tab) do
    if tab[j] == index then
      table.remove(tab, j)
      break
    end
  end
end

local function OnNameRefresh(ctr, index, data, ui)
  if ctr.img_title and not IsNil(ctr.img_title.transform) then
    if data.tblItem and string.isNullOrEmpty(data.tblItem.modelEffect) then
      ui:SetSprite("Atlas_Language", data.tblItem.icon, ctr.img_title)
    else
      ctr.img_title:SetActive(false)
    end
  end
  if ctr.img_niceName_model and not IsNil(ctr.img_niceName_model.transform) and data.tblItem and data.tblItem.id ~= ctr.titleItemId then
    if ctr.titleEffectLid ~= nil then
      ui:GetUITitleEffectProcessor():RemoveEffect(ctr.titleEffectLid)
    end
    ctr.titleEffectLid = ui:GetUITitleEffectProcessor():InstantiationEffect({
      lid = ctr.img_titleEffect,
      panel = ui,
      itemId = data.tblItem.id
    }, ctr.img_niceName_model.transform)
  end
  ctr.titleItemId = data.tblItem and data.tblItem.id or 0
  ctr.select = ctr:GetChild("img_btn_choose")
  ctr.allTime = ctr:GetChild("allTime")
  ctr.index = index
  if data.time == 0 then
    ctr.allTime:SetText("Hi\225\187\135u l\225\187\177c v\196\169nh vi\225\187\133n")
  else
    local surplusTime = Mathf.Floor(data.time * 0.001) - Time.GetServerSecondTime()
    ui:StartTimer(index, ui.nameTimer, surplusTime, ctr.allTime, "")
  end
  if data.valid then
    ui.nameIndex = index
    ui.defaultNameIndex = index
    ctr.select:SetActive(true)
  else
    ctr.select:SetActive(false)
  end
  ctr:SetOnClick(ui, ui.btn_NameOnClick)
  table.insert(ui.nameItemTab, ctr)
end

local function OnParentCreate(control)
end

local function OnParentRefresh(ctr, i, data, ui)
  local name = ctr:GetChild("Image/btnText")
  name:SetText(data)
  local Content = ctr:GetChild("Scroll_BagInfo/Viewport/childContent")
  local dataCount = table.count(ui.totalEquip[i])
  local row = dataCount // ui.rowCount
  if dataCount % ui.rowCount ~= 0 then
    row = row + 1
  end
  local h = ui.singleParentItemHigh + (row - 1) * ui.itemSize
  if i == 1 then
    ui.parentItemPosY = ui.parentItemStartPos.y
  end
  ctr:SetAnchoredPosition(ui.parentItemStartPos.x, ui.parentItemPosY)
  ui.parentItemPosY = ui.parentItemPosY - h
  for j = 1, dataCount do
    ui.objPoolIndex = ui.objPoolIndex + 1
    local childItem
    local isAddClick = false
    if ui.objPool[ui.objPoolIndex] then
      childItem = ui.objPool[ui.objPoolIndex]
    else
      isAddClick = true
      local go = ui.btn_3DItem:Instantiate(Content.transform, "btn_3DItem")
      childItem = UIControl(go.transform)
      table.insert(ui.objPool, childItem)
    end
    childItem:SetParent(Content.transform)
    childItem.index = ui.totalEquip[i][j]
    childItem.itemInfo = ui.equipData[childItem.index]
    childItem.arrow = childItem:GetChild("img_select")
    childItem.go_model = childItem:GetChild("go_model")
    if ui.objCellDataPool[ui.objPoolIndex] then
      ui.objCellDataPool[ui.objPoolIndex]:RecycleRes()
      ui.objCellDataPool[ui.objPoolIndex]:RefreshData(ui.equipData[childItem.index])
      ItemUtility.ShowItemCell(childItem, ui.objCellDataPool[ui.objPoolIndex], ui)
    else
      ui.objCellDataPool[ui.objPoolIndex] = ItemCellData()
      ui.objCellDataPool[ui.objPoolIndex]:RefreshData(ui.equipData[childItem.index])
      ItemUtility.ShowItemCell(childItem, ui.objCellDataPool[ui.objPoolIndex], ui)
    end
    if table.contains(ui.saveBagIndexTab, childItem.index) then
      childItem.arrow:SetActive(true)
    else
      childItem.arrow:SetActive(false)
    end
    childItem:SetActive(true)
    if isAddClick then
      childItem:SetOnClick(ui, ui.btn_ItemOnClick)
    end
    table.insert(ui.childItemTab, childItem)
  end
end

local function OnIllusionCreate(ctr)
  ctr.objItem = ctr:GetChild("objItem")
  ctr.jewelryName = ctr:GetChild("jewelryName")
  ctr.select = ctr:GetChild("img_btn_choose")
  ctr.allTime = ctr:GetChild("allTime")
  ctr.go_modelData = ItemCellData()
  ctr.tog_select = ctr:GetChild("tog_select")
end

local function OnIllusionRefresh(ctr, i, data, ui)
  ctr.allTime:SetActive(false)
  if data == nil then
    return
  end
  ctr.GuardInfoItem = data
  local itemid = data.nowtable.model
  if data.guardStrengthen then
    itemid = data.nowtable.strengthenModel
  end
  ctr.itemData = ItemUtility.GenerateItemData(itemid)
  ctr.go_modelData:RefreshData(ctr.itemData)
  ItemUtility.ShowItemCell(ctr.objItem, ctr.go_modelData, ui, false)
  ctr.select:SetActive(data.isWear)
  local isShowSelectEffect = false
  if ui.selectIllusionGuard and ui.selectIllusionGuard.id == data.id then
    isShowSelectEffect = true
    local guardData = ui.GetGuardData():GetAttributesShowInfoList(data, false)
    ui.attributeRingItemContainer:SetData(guardData)
  end
  ctr.jewelryName:SetText(data.nowtable.name)
  ctr.tog_select:SetActive(isShowSelectEffect)
  ctr:SetOnClick(ui, ui.OnClickIllusionSelect)
end

function Bag_AppearBagInfoUI:OnClickIllusionSelect(ctr)
  if self.selectIllusionGuard and self.selectIllusionGuard.id == ctr.GuardInfoItem.id then
    return
  end
  self.selectIllusionGuard = ctr.GuardInfoItem
  self:IllusionRefresh()
  local itemid = ctr.GuardInfoItem.nowtable.model
  if ctr.GuardInfoItem.guardStrengthen then
    itemid = ctr.GuardInfoItem.nowtable.strengthenModel
  end
  local itemData = ItemUtility.GenerateItemData(itemid)
  EventManager.Dispatch(Event.Equip_AppearPetChange, ctr.itemData)
end

local function OnAttributeRingCreate(ctr)
  ctr.txt_des = ctr:GetChild("txt_des")
end

local function OnAttributeRingRefresh(ctr, i, data, ui)
  local des, nowDes, nextDes, StrengthenDes = ui.GetGuardData():GetAttributesShowInfo(data.GuardInfoItem, data.AttributesName)
  ctr.txt_des:SetText(des .. " " .. nowDes)
end

local function OnAttrCreate(control)
end

local function OnAttrRefresh(ctr, i, data, ui)
  local name = ctr:GetChild("txt_des")
  if type(data) == "string" then
    name:SetText(data)
  else
    ui:StartTimer(i, ui.attTimer, data, name, "Hi\225\187\135u l\225\187\177c: ")
  end
end

local function OnRingCreate(control)
end

local function OnRingRefresh(ctr, i, data, ui)
  ctr.index = data.bagGridIndex
  ctr.objItem = ctr:GetChild("objItem")
  if not ui.ringCellData[i] then
    ui.ringCellData[i] = ItemCellData()
  end
  ui.ringCellData[i]:RefreshData(data)
  ItemUtility.ShowItemCell(ctr.objItem, ui.ringCellData[i], ui, true)
  ctr.jewelryName = ctr:GetChild("jewelryName")
  ctr.jewelryName:SetText(data.tblItem.name)
  ctr.select = ctr:GetChild("img_btn_choose")
  ctr.allTime = ctr:GetChild("allTime")
  ctr.itemData = data
  if data.time == 0 then
    ctr.allTime:SetText("Hi\225\187\135u l\225\187\177c v\196\169nh vi\225\187\133n")
  else
    local surplusTime = Mathf.Floor(data.time * 0.001) - Time.GetServerSecondTime()
    ui:StartTimer(i, ui.ringTimer, surplusTime, ctr.allTime, "")
  end
  if ui.ringShowIndex and ui.ringShowIndex == data.bagGridIndex then
    ui.ringChangeIndex = data.bagGridIndex
    ctr.select:SetActive(true)
    ui.lastRingObjCtrl = ctr
  else
    ctr.select:SetActive(false)
  end
  ctr:SetOnClick(ui, ui.btn_RingChangeOnClick)
end

function Bag_AppearBagInfoUI:InitUI()
  self.parentContent.contentSizeFitter.enabled = false
  self.parentContent.layoutGroup.enabled = false
  self.childContent.layoutGroup.enabled = true
  self.childContent.layoutGroup.spacing = {x = 5, y = 5}
  self.childContent.layoutGroup.constraint = 0
  self.childContent:SetHorizontalFit(FitModeEnum.Unconstrained)
  self.parentItem:SetAnchorMin(0, 1)
  self.parentItem:SetAnchorMax(0, 1)
  self.parentContainer = UIContainer(self.parentItem, self, OnParentCreate, OnParentRefresh)
  self.equipAttrContainer = UIContainer(self.attrEquipItem, self, OnAttrCreate, OnAttrRefresh)
  self.nameContainer = UIContainer(self.nameItem, self, OnNameCreate, OnNameRefresh)
  self.nameAttrContainer = UIContainer(self.attributeItem, self, OnAttrCreate, OnAttrRefresh)
  self.ringChangeContainer = UIContainer(self.jewelryItem, self, OnRingCreate, OnRingRefresh)
  self.ringChangeAttrContainer = UIContainer(self.attributeRingItem, self, OnAttrCreate, OnAttrRefresh)
  self.illusionItemContainer = UIContainer(self.illusionItem, self, OnIllusionCreate, OnIllusionRefresh)
  self.attributeRingItemContainer = UIContainer(self.IllusionattributeRingItem, self, OnAttributeRingCreate, OnAttributeRingRefresh)
  self.CoutureTemplate = luaTemplateManager.GetNewTemplate(self.Scroll_Couture, LuaComponentTemplates.Appear_CoutureTemplate, self)
end

function Bag_AppearBagInfoUI:InitData()
  self.parentItemStartPos = {x = 91, y = -58}
  self.parentItemPosY = self.parentItemStartPos.y
  self.itemSize = self.childContent.layoutGroup.cellSize.x + self.childContent.layoutGroup.spacing.x
  local w, h = self.Scroll_BagInfo:GetSizeDelta()
  self.rowCount = w // self.itemSize
  self.singleParentItemHigh = self.parentContent.layoutGroup.cellSize.y + self.parentContent.layoutGroup.spacing.y
end

function Bag_AppearBagInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:CheckFunctionShow()
end

function Bag_AppearBagInfoUI:CheckFunctionShow()
  if self.tog_Couture.gameObject.activeSelf then
    EventManager.Dispatch(Event.Fuc_SingleRefresh, {3000301})
  end
end

function Bag_AppearBagInfoUI:OnHide()
  self.selectIllusionGuard = nil
  self:StopTimer(self.nameTimer)
  self:StopTimer(self.attTimer)
  self:StopTimer(self.ringTimer)
  self.groupAtt:SetActive(false)
  self.AppearBg:SetActive(true)
  self.apViewport:SetSizeDelta(self.appearWidth, self.appearMaxHeight)
  self:RemoveAllTitleEffect()
  UIManager.Hide(UIID.AppearBagLookUI)
end

function Bag_AppearBagInfoUI:OnDestroy()
end

function Bag_AppearBagInfoUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.Button_Save:SetOnClick(self, self.Button_SaveOnClick)
  self.Button_CloseBag:SetOnClick(self, self.Button_CloseBagOnClick)
  self.Button_Not:SetOnClick(self, self.Button_CloseBagOnClick)
  self.tog_appear:SetOnToggleChanged(self, self.AppearOnToggleChanged)
  self.tog_name:SetOnToggleChanged(self, self.NameOnToggleChanged)
  self.tog_jewelryBox:SetOnToggleChanged(self, self.RingChangeOnToggleChanged)
  self.tog_Illusion:SetOnToggleChanged(self, self.IllusionChangeOnToggleChanged)
  self.tog_Couture:SetOnToggleChanged(self, self.CoutureChangeOnToggleChanged)
end

function Bag_AppearBagInfoUI:AppearOnToggleChanged(control, isOn)
  if isOn then
    self.Scroll_Appear:SetActive(true)
  else
    self.Scroll_Appear:SetActive(false)
  end
end

function Bag_AppearBagInfoUI:NameOnToggleChanged(control, isOn)
  if isOn then
    self.Scroll_Name:SetActive(true)
  else
    self.Scroll_Name:SetActive(false)
  end
end

function Bag_AppearBagInfoUI:RingChangeOnToggleChanged(control, isOn)
  if isOn then
    self.Scroll_jewelryBox:SetActive(true)
  else
    self.Scroll_jewelryBox:SetActive(false)
  end
end

function Bag_AppearBagInfoUI:IllusionChangeOnToggleChanged(control, isOn)
  if isOn then
    self.Scroll_Illusion:SetActive(true)
  else
    self.Scroll_Illusion:SetActive(false)
  end
end

function Bag_AppearBagInfoUI:CoutureChangeOnToggleChanged(control, isOn)
  if isOn then
    self.Scroll_Couture:SetActive(true)
    self.Button_Save:SetActive(false)
    self.Button_Not:SetActive(false)
    if self.args ~= nil then
      self.args = nil
    end
    if self.CoutureTemplate ~= nil then
      self.CoutureTemplate:RefreshAll()
    end
  else
    self.Scroll_Couture:SetActive(false)
    self.Button_Save:SetActive(true)
    self.Button_Not:SetActive(true)
  end
  EventManager.Dispatch(Event.Appear_CouturToggleChange, isOn)
end

function Bag_AppearBagInfoUI:btn_closeBgOnClick(control)
  if self.isShowSaveTips then
    self:Button_SaveOnClick()
  else
    UIManager.Hide(UIID.AppearBagInfoUI)
  end
end

function Bag_AppearBagInfoUI:Button_SaveOnClick(control)
  if self.Scroll_Appear:GetActive() then
    self:Button_AppearSaveOnClick()
  elseif self.Scroll_Name:GetActive() then
    self:Button_NameSaveOnClick()
  elseif self.Scroll_Illusion:GetActive() then
    self:Button_IllusionSaveOnClick()
  else
    self:Button_RingSaveOnClick()
  end
end

function Bag_AppearBagInfoUI:Button_IllusionSaveOnClick()
  local function PromptCancel()
    UIManager.Hide(UIID.AppearBagInfoUI)
  end
  
  local function PromptOK()
    local nowSelectData = self.selectIllusionGuard
    if nowSelectData == nil or nowSelectData.isWear == true then
      return
    end
    networkRequest.ReqSetGuardAppearance(nowSelectData.id, 1)
    UIManager.Hide(UIID.AppearBagInfoUI)
  end
  
  local title = {
    title = string.GetColorText("Nh\225\186\175c nh\225\187\159", "#FFFFFFFF"),
    textContent = string.GetColorText("L\198\176u c\195\160i \196\145\225\186\183t", "#FFFFFFFF"),
    cancelText = "",
    okText = "",
    cancel = PromptCancel,
    ok = PromptOK,
    okArgs = nil
  }
  UIManager.Show(UIID.PromptTipUI, title)
end

function Bag_AppearBagInfoUI:Button_NameSaveOnClick()
  local function PromptCancel()
    UIManager.Hide(UIID.AppearBagInfoUI)
  end
  
  local function PromptOK()
    local data = ViewData.meData.titleData.TitleInfo
    if self.isHideTitle then
      NetManager.Send(EquipMessage.ReqChangeTitleState, {
        rid = RoleManager.me.id,
        position = data[self.nameIndex].bagGridIndex,
        wear = false
      })
    else
      NetManager.Send(EquipMessage.ReqChangeTitleState, {
        rid = RoleManager.me.id,
        position = data[self.nameIndex].bagGridIndex,
        wear = true
      })
    end
    UIManager.Hide(UIID.AppearBagInfoUI)
  end
  
  local title = {
    title = string.GetColorText("Nh\225\186\175c nh\225\187\159", "#FFFFFFFF"),
    textContent = string.GetColorText("L\198\176u c\195\160i \196\145\225\186\183t", "#FFFFFFFF"),
    cancelText = "",
    okText = "",
    cancel = PromptCancel,
    ok = PromptOK,
    okArgs = nil
  }
  if table.count(ViewData.meData.titleData.TitleInfo) == 0 then
    UIManager.Hide(UIID.AppearBagInfoUI)
  else
    UIManager.Show(UIID.PromptTipUI, title)
  end
end

function Bag_AppearBagInfoUI:Button_AppearSaveOnClick()
  local function PromptCancel()
    UIManager.Hide(UIID.AppearBagInfoUI)
  end
  
  local function PromptOK()
    local reqTab = {}
    if table.count(self.saveBagIndexTab) > 0 then
      for i, v in pairs(self.saveBagIndexTab) do
        if v then
          local relativeIndex = v % 100
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
          elseif relativeIndex == ERoleEquipPosition.footPrintIndex then
            reqTab.equip_foot = v
          elseif relativeIndex == ERoleEquipPosition.ringChange or relativeIndex == ERoleEquipPosition.yongDragon then
            reqTab.equip_model = v
          elseif relativeIndex == ERoleEquipPosition.cloak then
            reqTab.equip_cloak = v
          end
        end
      end
      if self.ringChangeIndex ~= 0 then
        reqTab.equip_model = self.ringChangeIndex
      end
      local appear = json.encode(reqTab)
      ForgeData.appearData[RoleManager.me.id] = appear
      MeEquipController.ReqSaveAppear(appear)
      for i = 1, #self.saveBagIndexCopyTab do
        if not table.contains(self.saveBagIndexTab, self.saveBagIndexCopyTab[i]) then
          RoleManager.me.AvatarEquip:RemoveEquipModel(self.saveBagIndexCopyTab[i])
        end
      end
      for i = 1, #self.saveBagIndexTab do
        if not table.contains(self.saveBagIndexCopyTab, self.saveBagIndexTab[i]) then
          RoleManager.me.AvatarEquip:PutOnEquip(self.saveBagIndexTab[i], self.equipData[self.saveBagIndexTab[i]].modelPath)
          RoleManager.me.AvatarEquip:CheckAndLoadCapeDisplay()
        end
      end
      UIManager.Hide(UIID.AppearBagInfoUI)
    end
  end
  
  local title = {
    title = string.GetColorText("Nh\225\186\175c nh\225\187\159", "#FFFFFFFF"),
    textContent = string.GetColorText("L\198\176u c\195\160i \196\145\225\186\183t", "#FFFFFFFF"),
    cancelText = "",
    okText = "",
    cancel = PromptCancel,
    ok = PromptOK,
    okArgs = nil
  }
  if table.count(self.saveBagIndexTab) == 0 then
    UIManager.Hide(UIID.AppearBagInfoUI)
  else
    UIManager.Show(UIID.PromptTipUI, title)
  end
end

function Bag_AppearBagInfoUI:Button_RingSaveOnClick()
  if self.ringChangeIndex then
    if self.ringChangeIndex ~= self.ringShowIndex then
      local function PromptCancel()
        UIManager.Hide(UIID.AppearBagInfoUI)
      end
      
      local function PromptOK()
        local reqTab = json.decode(ForgeData.appearData[RoleManager.me.id])
        reqTab.equip_model = self.ringChangeIndex
        local appear = json.encode(reqTab)
        ForgeData.appearData[RoleManager.me.id] = appear
        MeEquipController.ReqSaveAppear(appear)
        RoleManager.me:ChangeModel(self.equipData[self.ringChangeIndex].tblEquip.transformation, tonumber(self.equipData[self.ringChangeIndex].tblEquip.transformationSize))
        UIManager.Hide(UIID.AppearBagInfoUI)
      end
      
      local title = {
        title = string.GetColorText("Nh\225\186\175c nh\225\187\159", "#FFFFFFFF"),
        textContent = string.GetColorText("L\198\176u c\195\160i \196\145\225\186\183t", "#FFFFFFFF"),
        cancelText = "",
        okText = "",
        cancel = PromptCancel,
        ok = PromptOK,
        okArgs = nil
      }
      UIManager.Show(UIID.PromptTipUI, title)
    else
      UIManager.Hide(UIID.AppearBagInfoUI)
    end
  else
    if tostring(self.ringShowModel) ~= tostring(ERoleModelName.default) then
      RoleEquipUtility.UpdateAppearSaveData(self.ringShowIndex, true)
      RoleManager.me:ChangeModel(ERoleModelName.default, PlayerModelDefaultScale)
    end
    UIManager.Hide(UIID.AppearBagInfoUI)
  end
end

function Bag_AppearBagInfoUI:Button_CloseBagOnClick(control)
  if self.isShowSaveTips then
    self:Button_SaveOnClick()
  else
    UIManager.Hide(UIID.AppearBagInfoUI)
  end
end

local function ChooseWeaponJudge(self, child, idx)
  local Weapon = {}
  if idx == ERoleEquipPosition.right_weapon then
    for i = 1, table.count(self.childItemTab) do
      local tempIndex = self.childItemTab[i].index % 100
      if tempIndex == ERoleEquipPosition.left_weapon then
        table.insert(Weapon, self.childItemTab[i])
      end
    end
  else
    for i = 1, table.count(self.childItemTab) do
      local tempIndex = self.childItemTab[i].index % 100
      if tempIndex == ERoleEquipPosition.right_weapon then
        table.insert(Weapon, self.childItemTab[i])
      end
    end
  end
  if table.count(Weapon) > 0 then
    local isChoose = false
    for i = 1, table.count(Weapon) do
      if table.contains(self.saveBagIndexTab, Weapon[i].index) then
        isChoose = true
      end
    end
    if not isChoose then
      local isHave = false
      for i = 1, table.count(Weapon) do
        if child.index - Weapon[i].index == 1 then
          isHave = true
          Weapon[i].arrow.gameObject:SetActive(true)
          table.insert(self.saveBagIndexTab, Weapon[i].index)
          return
        end
      end
      if not isHave then
        for i = 1, table.count(Weapon) do
          local conSubType = self.equipData[child.index].tblItem.subType
          local childSubType = self.equipData[Weapon[i].index].tblItem.subType
          if RoleEquipUtility.WearWeaponsCondition(conSubType, childSubType) then
            Weapon[i].arrow.gameObject:SetActive(true)
            table.insert(self.saveBagIndexTab, Weapon[i].index)
            return
          end
        end
      end
    end
  end
end

function Bag_AppearBagInfoUI:btn_ItemOnClick(control)
  if gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():IsConfineChangeAppearEquipCell(control.index) then
    FloatingTipUtility.QuickMsg("Kh\195\180ng th\225\187\131 thay \196\145\225\187\149i khi \196\145ang m\225\186\183c th\225\187\157i trang")
    return
  end
  if self.equipData[control.index].tblItem.fashion == self.equipFashion.timeEquip then
    self:StopTimer(self.attTimer)
    local attrData = self:GetEquipAttributeData(self.equipData[control.index])
    self.equipAttrContainer:SetData(attrData)
    self.groupAtt:SetActive(true)
    self.AppearBg:SetActive(false)
    self.apViewport:SetSizeDelta(self.appearWidth, self.appearMinHeight)
  else
    self.AppearBg:SetActive(true)
    self.groupAtt:SetActive(false)
    self.apViewport:SetSizeDelta(self.appearWidth, self.appearMaxHeight)
  end
  self.isShowSaveTips = true
  if not control.arrow:GetActive() then
    local relativeIndex = control.index % 100
    if relativeIndex == ERoleEquipPosition.right_weapon and gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():IsConfineChangeAppearEquipCell(ERoleEquipPosition.left_weapon) == false then
      for i = 1, table.count(self.childItemTab) do
        local tempIndex = self.childItemTab[i].index % 100
        if tempIndex == ERoleEquipPosition.left_weapon or tempIndex == ERoleEquipPosition.right_weapon then
          local conSubType = self.equipData[control.index].tblItem.subType
          local childSubType = self.equipData[self.childItemTab[i].index].tblItem.subType
          if tempIndex == ERoleEquipPosition.right_weapon or not RoleEquipUtility.WearWeaponsCondition(conSubType, childSubType) then
            self.childItemTab[i].arrow.gameObject:SetActive(false)
            RemoveDataByIndex(self.saveBagIndexTab, self.childItemTab[i].index)
          end
        end
      end
      ChooseWeaponJudge(self, control, ERoleEquipPosition.right_weapon)
    elseif relativeIndex == ERoleEquipPosition.left_weapon and gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():IsConfineChangeAppearEquipCell(ERoleEquipPosition.right_weapon) == false then
      for i = 1, table.count(self.childItemTab) do
        local tempIndex = self.childItemTab[i].index % 100
        if tempIndex == ERoleEquipPosition.left_weapon or tempIndex == ERoleEquipPosition.right_weapon then
          local conSubType = self.equipData[control.index].tblItem.subType
          local childSubType = self.equipData[self.childItemTab[i].index].tblItem.subType
          if tempIndex == ERoleEquipPosition.left_weapon or not RoleEquipUtility.WearWeaponsCondition(conSubType, childSubType) then
            self.childItemTab[i].arrow.gameObject:SetActive(false)
            RemoveDataByIndex(self.saveBagIndexTab, self.childItemTab[i].index)
          end
        end
      end
      ChooseWeaponJudge(self, control, ERoleEquipPosition.left_weapon)
    else
      for i = 1, table.count(self.childItemTab) do
        if self.childItemTab[i].index % 100 == relativeIndex then
          self.childItemTab[i].arrow.gameObject:SetActive(false)
          RemoveDataByIndex(self.saveBagIndexTab, self.childItemTab[i].index)
        end
      end
    end
    control.arrow.gameObject:SetActive(true)
    table.insert(self.saveBagIndexTab, control.index)
    EventManager.Dispatch(Event.Equip_AppearChange, self.saveBagIndexTab)
  end
end

function Bag_AppearBagInfoUI:btn_NameOnClick(control)
  self.isShowSaveTips = true
  if self.nameIndex ~= control.index then
    self.nameIndex = control.index
    for i = 1, table.count(self.nameItemTab) do
      if i == self.nameIndex then
        if not self.nameItemTab[i].select:GetActive() then
          self.nameItemTab[i].select:SetActive(true)
        end
      elseif self.nameItemTab[i].select:GetActive() then
        self.nameItemTab[i].select:SetActive(false)
      end
    end
    EventManager.Dispatch(Event.Equip_AppearNameChange, {
      index = self.nameIndex,
      showType = 1
    })
  else
    local isShow = control.select:GetActive()
    control.select:SetActive(not isShow)
    self.isHideTitle = isShow
    if not isShow then
      EventManager.Dispatch(Event.Equip_AppearNameChange, {
        index = self.nameIndex,
        showType = 2
      })
    else
      EventManager.Dispatch(Event.Equip_AppearNameChange, {showType = 2})
    end
  end
end

function Bag_AppearBagInfoUI:btn_RingChangeOnClick(control)
  self.isShowSaveTips = true
  if self.ringChangeIndex ~= control.index then
    if self.lastRingObjCtrl then
      self.lastRingObjCtrl.select:SetActive(false)
    end
    self.lastRingObjCtrl = control
    self.ringChangeIndex = control.index
    control.select:SetActive(true)
    EventManager.Dispatch(Event.Equip_AppearRingChange, {
      itemData = control.itemData
    })
  else
    local isShow = control.select:GetActive()
    control.select:SetActive(not isShow)
    if not isShow then
      self.ringChangeIndex = control.index
      EventManager.Dispatch(Event.Equip_AppearRingChange, {
        itemData = control.itemData
      })
    else
      self.ringChangeIndex = nil
      EventManager.Dispatch(Event.Equip_AppearRingChange, {})
    end
  end
end

function Bag_AppearBagInfoUI:RegistEvents()
  self:RegistEvent(Event.Equip_ResTitle, self.OnNameRefresh, self)
  self:RegistEvent(Event.Equip_ResRingChange, self.OnRingChangeNameRefresh, self)
  self:RegistEvent(Event.PutOnEquip, self.RightToggleShowRefresh, self)
  self:RegistEvent(Event.Guard_InfoChange, self.IllusionRefresh, self)
  self:RegistEvent(Event.Appear_CoutureSelectChange, self.Appear_CoutureSelectChange, self)
  self:RegistEvent(Event.Appear_CouturDataChange, self.Appear_CouturDataChange, self)
  self:RegistEvent(Event.Appear_FashionSuccess, self.Appear_FashionSuccess, self)
end

function Bag_AppearBagInfoUI:Refresh()
  self.isShowSaveTips = false
  self.equipData = RoleManager.me.data.equipsData.Data
  self:AppearRefresh()
  self:NameRefresh()
  self:IllusionRefresh()
  self:RingChangeRefresh()
  self:RightToggleShowRefresh()
  self:RefreshCouture()
end

function Bag_AppearBagInfoUI.GetGuardData()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData()
end

function Bag_AppearBagInfoUI:IllusionRefresh()
  local guardDataList = self.GetGuardData():GetAllActiveGuardInfoList()
  if not self.selectIllusionGuard then
    for i, v in pairs(guardDataList) do
      if v.isWear then
        self.selectIllusionGuard = v
      end
    end
  end
  if not self.selectIllusionGuard and not table.isNullOrEmpty(guardDataList) then
    self.selectIllusionGuard = guardDataList[1]
  end
  self.illusionItemContainer:SetData(guardDataList)
end

function Bag_AppearBagInfoUI:AppearRefresh()
  self.AppearBg:SetActive(true)
  self.apViewport:SetSizeDelta(self.appearWidth, self.appearMaxHeight)
  self.groupAtt:SetActive(false)
  self.childItemTab = {}
  self.saveBagIndexTab = {}
  self.saveBagIndexCopyTab = {}
  self.saveBagIndexTab = RoleEquipUtility.DefaultShowAppearEquip(RoleManager.me.id, self.equipData)
  for i = 1, table.count(self.saveBagIndexTab) do
    table.insert(self.saveBagIndexCopyTab, self.saveBagIndexTab[i])
  end
  self.parentName, self.totalEquip = self:HandleShowEquipData()
  self.objPoolIndex = 0
  for i = 1, table.count(self.objPool) do
    self.objPool[i]:SetActive(false)
  end
  self.parentContainer:SetData(self.parentName)
  self.parentContent:SetSizeDelta(0, -self.parentItemPosY)
end

function Bag_AppearBagInfoUI:HandleShowEquipData()
  local parentName, totalEquip, equip_helm, equip_pet, equip_left, equip_right, equip_armor, equip_glove, equip_pant, equip_boot, equip_foot, equip_cloak = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
  for i, v in pairs(self.equipData) do
    if v and RoleEquipUtility.IsEquipAppearData(i) and RoleEquipUtility.IsDotShowAppearData(i) then
      if i % 100 == ERoleEquipPosition.helm then
        table.insert(equip_helm, i)
      elseif i % 100 == ERoleEquipPosition.right_weapon then
        table.insert(equip_right, i)
      elseif i % 100 == ERoleEquipPosition.left_weapon then
        table.insert(equip_left, i)
      elseif i % 100 == ERoleEquipPosition.armor then
        table.insert(equip_armor, i)
      elseif i % 100 == ERoleEquipPosition.glove then
        table.insert(equip_glove, i)
      elseif i % 100 == ERoleEquipPosition.pant then
        table.insert(equip_pant, i)
      elseif i % 100 == ERoleEquipPosition.boot then
        table.insert(equip_boot, i)
      elseif i % 100 == ERoleEquipPosition.footPrintIndex then
        table.insert(equip_foot, i)
      elseif i % 100 == ERoleEquipPosition.cloak then
        table.insert(equip_cloak, i)
      end
    end
  end
  if 0 < #equip_helm then
    table.insert(parentName, "N\195\179n S\225\186\175t")
    table.sort(equip_helm, function(a, b)
      return b < a
    end)
    table.insert(totalEquip, equip_helm)
  end
  if 0 < #equip_pet then
    table.insert(parentName, "Th\225\187\167 H\225\187\153")
    table.sort(equip_pet, function(a, b)
      return b < a
    end)
    table.insert(totalEquip, equip_pet)
  end
  if 0 < #equip_right then
    table.insert(parentName, "V\197\169 kh\195\173 ch\195\173nh")
    table.sort(equip_right, function(a, b)
      return b < a
    end)
    table.insert(totalEquip, equip_right)
  end
  if 0 < #equip_left then
    table.insert(parentName, "V\197\169 kh\195\173 ph\225\187\165")
    table.sort(equip_left, function(a, b)
      return b < a
    end)
    table.insert(totalEquip, equip_left)
  end
  if 0 < #equip_armor then
    table.insert(parentName, "Kh\225\186\163i Gi\195\161p")
    table.sort(equip_armor, function(a, b)
      return b < a
    end)
    table.insert(totalEquip, equip_armor)
  end
  if 0 < #equip_glove then
    table.insert(parentName, "Bao Tay")
    table.sort(equip_glove, function(a, b)
      return b < a
    end)
    table.insert(totalEquip, equip_glove)
  end
  if 0 < #equip_pant then
    table.insert(parentName, "Bao Ch\195\162n")
    table.sort(equip_pant, function(a, b)
      return b < a
    end)
    table.insert(totalEquip, equip_pant)
  end
  if 0 < #equip_boot then
    table.insert(parentName, "Gi\195\160y")
    table.sort(equip_boot, function(a, b)
      return b < a
    end)
    table.insert(totalEquip, equip_boot)
  end
  if 0 < #equip_foot then
    table.insert(parentName, "D\225\186\165u ch\195\162n")
    table.sort(equip_foot, function(a, b)
      return b < a
    end)
    table.insert(totalEquip, equip_foot)
  end
  if 0 < #equip_cloak then
    table.insert(parentName, "\195\129o cho\195\160ng")
    table.sort(equip_cloak, function(a, b)
      return b < a
    end)
    table.insert(totalEquip, equip_cloak)
  end
  return parentName, totalEquip
end

function Bag_AppearBagInfoUI:NameRefresh()
  self.nameItemTab = {}
  self.isHideTitle = false
  self.nameIndex = nil
  self.defaultNameIndex = nil
  self:StopTimer(self.nameTimer)
  self.nameContainer:SetData(ViewData.meData.titleData.TitleInfo)
  local attrData = self:GetAttributeData(ViewData.meData.titleData.TitleInfo)
  self.nameAttrContainer:SetData(attrData)
end

function Bag_AppearBagInfoUI:OnNameRefresh()
  if self.Scroll_Name:GetActive() then
    self:NameRefresh()
  end
end

function Bag_AppearBagInfoUI:RingChangeRefresh()
  local data = {}
  local temp = RoleManager.me.data.equipsData:GetRingChangeData()
  self.ringShowIndex = nil
  self.ringChangeIndex = nil
  self.ringShowModel = ERoleModelName.default
  for i, v in pairs(temp) do
    if v then
      if string.contains(ForgeData.appearData[RoleManager.me.id], v.bagGridIndex) then
        self.ringShowIndex = v.bagGridIndex
        self.ringShowModel = v.tblEquip.transformation
      end
      table.insert(data, v)
    end
  end
  self.ringChangeContainer:SetData(data)
  local attData = Bag_AppearBagInfoUI:GetAttributeData(temp)
  self.ringChangeAttrContainer:SetData(attData)
end

function Bag_AppearBagInfoUI:OnRingChangeNameRefresh()
  if self.Scroll_Name:GetActive() then
    self:RingChangeRefresh()
  end
end

function Bag_AppearBagInfoUI:GetAttributeData(equipData)
  local data = {}
  local minP, maxP, minW, maxW, minC, maxC, defenseBase, hp = 0, 0, 0, 0, 0, 0, 0, 0
  local expRate = 0
  local pvpSufferPhysDmg = 0
  local PvpMagicDamage = 0
  local ShengliExperience = 0
  for i, v in pairs(equipData) do
    if v then
      minP = minP + v.tblEquip.disable_minimumPhysBaseDmg
      maxP = maxP + v.tblEquip.disable_maximumPhysBaseDmg
      minW = minW + v.tblEquip.disable_minimumWizBaseDmg
      maxW = maxW + v.tblEquip.disable_maximumWizBaseDmg
      minC = minC + v.tblEquip.disable_minimumCurseBaseDmg
      maxC = maxC + v.tblEquip.disable_maximumCurseBaseDmg
      defenseBase = defenseBase + v.tblEquip.disable_defenseBase
      expRate = expRate + v.tblEquip.experienceRate
      if v.tblEquip.maximumHealth then
        hp = hp + v.tblEquip.maximumHealth
      end
      if v.tblEquip.pvpSufferPhysDmgReduced and v.tblEquip.pvpSufferWizDmgReduced and v.tblEquip.pvpCurseDmgReduced and v.tblEquip.pvpSufferPhysDmgReduced == v.tblEquip.pvpSufferWizDmgReduced and v.tblEquip.pvpSufferWizDmgReduced == v.tblEquip.pvpCurseDmgReduced then
        pvpSufferPhysDmg = pvpSufferPhysDmg + v.tblEquip.pvpSufferPhysDmgReduced
      end
      if v.tblEquip.PvpMagicDamageIncreased and v.tblEquip.PvpPhysicalDamageIncreased and v.tblEquip.pvpCurseDmgIncreased and v.tblEquip.PvpMagicDamageIncreased == v.tblEquip.PvpPhysicalDamageIncreased and v.tblEquip.PvpPhysicalDamageIncreased == v.tblEquip.pvpCurseDmgIncreased then
        PvpMagicDamage = PvpMagicDamage + v.tblEquip.PvpMagicDamageIncreased
      end
      if v.tblEquip.ringExperienceRate then
        ShengliExperience = ShengliExperience + v.tblEquip.ringExperienceRate
      end
    end
  end
  table.insert(data, string.format("Ph\195\178ng th\225\187\167: %d", defenseBase))
  table.insert(data, string.format("EXP \196\145\195\161nh qu\195\161i t\196\131ng: %d%%", expRate / 100))
  table.insert(data, string.format("T\196\131ng DMG PvP: %d%%", PvpMagicDamage / 100))
  table.insert(data, string.format("Gi\225\186\163m DMG PvP: %d%%", pvpSufferPhysDmg / 100))
  table.insert(data, string.format("HP: %d", hp))
  table.insert(data, string.format("T\196\131ng EXP Th\195\161nh L\225\187\177c: %s%% ", ShengliExperience / 100))
  return data
end

function Bag_AppearBagInfoUI:GetEquipAttributeData(itemInfo)
  local data = {}
  if itemInfo.tblEquip.disable_maximumPhysBaseDmg and itemInfo.tblEquip.disable_maximumPhysBaseDmg > 0 then
    table.insert(data, string.format("#N/A", itemInfo.tblEquip.disable_minimumPhysBaseDmg, itemInfo.tblEquip.disable_maximumPhysBaseDmg))
  end
  if itemInfo.tblEquip.disable_maximumWizBaseDmg and 0 < itemInfo.tblEquip.disable_maximumWizBaseDmg then
    table.insert(data, string.format("#N/A", itemInfo.tblEquip.disable_minimumWizBaseDmg, itemInfo.tblEquip.disable_maximumWizBaseDmg))
  end
  if itemInfo.tblEquip.disable_maximumCurseBaseDmg and 0 < itemInfo.tblEquip.disable_maximumCurseBaseDmg then
    table.insert(data, string.format("#N/A", itemInfo.tblEquip.disable_minimumCurseBaseDmg, itemInfo.tblEquip.disable_maximumCurseBaseDmg))
  end
  if itemInfo.tblEquip.disable_defenseBase and 0 < itemInfo.tblEquip.disable_defenseBase then
    table.insert(data, string.format("Ph\195\178ng Th\225\187\167: %s", itemInfo.tblEquip.disable_defenseBase))
  end
  if 0 < itemInfo.time then
    local surplusTime = Mathf.Floor(itemInfo.time * 0.001) - Time.GetServerSecondTime()
    table.insert(data, surplusTime)
  end
  return data
end

function Bag_AppearBagInfoUI:EquipNameToPosition(name)
  local bagGridIndex
  if name == "N\195\179n S\225\186\175t" then
    bagGridIndex = ERoleEquipPosition.helm
  elseif name == "Th\225\187\167 H\225\187\153" then
    bagGridIndex = ERoleEquipPosition.pet
  elseif name == "V\197\169 kh\195\173 ch\195\173nh" then
    bagGridIndex = ERoleEquipPosition.right_weapon
  elseif name == "V\197\169 kh\195\173 ph\225\187\165" then
    bagGridIndex = ERoleEquipPosition.left_weapon
  elseif name == "Kh\225\186\163i Gi\195\161p" then
    bagGridIndex = ERoleEquipPosition.armor
  elseif name == "Bao Ch\195\162n" then
    bagGridIndex = ERoleEquipPosition.pant
  elseif name == "Bao Tay" then
    bagGridIndex = ERoleEquipPosition.glove
  elseif name == "Gi\195\160y" then
    bagGridIndex = ERoleEquipPosition.boot
  elseif name == "D\225\186\165u ch\195\162n" then
    bagGridIndex = ERoleEquipPosition.footPrintIndex
  end
  return bagGridIndex
end

function Bag_AppearBagInfoUI:StartTimer(index, tblTimer, surplusTime, lab_countdown, tips)
  if 0 < surplusTime then
    local timeStr = self:ShowDayHourMin(surplusTime)
    lab_countdown:SetText(string.GetColorText(tips .. timeStr, ItemQuality2ColorDic[EItemColorEnum.bRed]))
    tblTimer[index] = Timer.StartLoop(1, surplusTime, function()
      if surplusTime <= 1 then
        lab_countdown:SetText(string.GetColorText(self:ShowDayHourMin(0), ItemQuality2ColorDic[EItemColorEnum.bRed]))
        Timer.Stop(tblTimer[index])
        tblTimer[index] = nil
      end
      surplusTime = surplusTime - 1
      local timeStr = self:ShowDayHourMin(surplusTime)
      lab_countdown:SetText(string.GetColorText(tips .. timeStr, ItemQuality2ColorDic[EItemColorEnum.bRed]))
    end)
  else
    lab_countdown:SetText(string.GetColorText(self:ShowDayHourMin(0), ItemQuality2ColorDic[EItemColorEnum.bRed]))
  end
end

function Bag_AppearBagInfoUI:StopTimer(tblTimer)
  for i, v in pairs(tblTimer) do
    if v then
      Timer.Stop(v)
    end
  end
  tblTimer = {}
end

function Bag_AppearBagInfoUI:ShowDayHourMin(sec)
  local timeStr = ""
  local day = Mathf.Floor(sec / ETimeSec.day)
  local hour = Mathf.Floor(sec % ETimeSec.day / ETimeSec.hour)
  local min = Mathf.Ceil(sec % ETimeSec.hour / ETimeSec.min)
  if min == 60 then
    min = 59
  end
  timeStr = string.format(LocalizationUtility.GetContentByKey("Time_kfhd"), day, hour, min)
  return timeStr
end

function Bag_AppearBagInfoUI:RightToggleShowRefresh()
  self.tog_appear:SetActive(false)
  self.tog_name:SetActive(table.count(ViewData.meData.titleData.TitleInfo) > 0)
  self.tog_jewelryBox:SetActive(false)
  for i, v in pairs(self.equipData) do
    if RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.Equip) then
      self.tog_appear:SetActive(true)
      break
    end
  end
  for i, v in pairs(self.equipData) do
    if v.tblItem.subType == EItemSubtype.ringChange then
      self.tog_jewelryBox:SetActive(true)
      break
    end
  end
  self.tog_Illusion:SetActive(true)
  goto lbl_68
  self.tog_Illusion:SetActive(false)
  ::lbl_68::
  if self.args then
    local toggles = {
      [1] = self.tog_appear,
      [2] = self.tog_name,
      [3] = self.tog_jewelryBox,
      [4] = self.tog_Illusion,
      [5] = self.tog_Couture
    }
    for i = 1, #toggles do
      toggles[i].toggle.isOn = self.args.togIndex == i
    end
  end
end

function Bag_AppearBagInfoUI:RefreshCouture()
  if self.CoutureTemplate ~= nil then
    self.CoutureTemplate:RefreshAll()
  end
end

function Bag_AppearBagInfoUI:Appear_CoutureSelectChange(id, data)
  if self.CoutureTemplate == nil then
    return
  end
  self.CoutureTemplate:AttributeInfoChange(data)
end

function Bag_AppearBagInfoUI:Appear_CouturDataChange(id, data)
  self.CoutureTemplate:RefreshCoutureItem()
end

function Bag_AppearBagInfoUI:Appear_FashionSuccess()
  self.isShowSaveTips = false
  self.equipData = RoleManager.me.data.equipsData.Data
  self:AppearRefresh()
end

function Bag_AppearBagInfoUI:OnPutOnEquip()
  self:RightToggleShowRefresh()
  self:RefreshAppear()
end

function Bag_AppearBagInfoUI:RefreshAppear(isReset)
  if self.appearTemplate ~= nil then
    self.appearTemplate:Refresh(isReset)
  end
end

function Bag_AppearBagInfoUI:OnEquip_AppearChange()
  self.isShowSaveTips = true
  self.appearTemplate:RefreshAppear()
  self:RefreshSaveBtn()
end

function Bag_AppearBagInfoUI:IsNeedSave()
  if self.defaultNameIndex == self.nameIndex and self.defaultIsHideTitle == self.isHideTitle and self.ringShowIndex == self.ringChangeIndex and not gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_AppearManager():IsChangeSaveBagIndexTab() then
    return false
  end
  return true
end

function Bag_AppearBagInfoUI:RefreshSaveBtn()
  if not self:IsNeedSave() then
    self.Button_Save:SetActive(false)
    self.Button_Not:SetActive(false)
  else
    self.Button_Save:SetActive(true)
    self.Button_Not:SetActive(true)
  end
end

function Bag_AppearBagInfoUI:GetUITitleEffectProcessor()
  return gameMgr:GetEffectManager():GetEffectActionUtility():GetEffectProcessor(EffectProcessorType.UI_Title)
end

function Bag_AppearBagInfoUI:RemoveAllTitleEffect()
  if self.nameItemTab == nil then
    return
  end
  for i, v in pairs(self.nameItemTab) do
    if v and v.titleEffectLid then
      self:GetUITitleEffectProcessor():RemoveEffect(v.titleEffectLid)
      v.titleItemId = nil
    end
  end
end
