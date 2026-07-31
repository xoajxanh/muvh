require("GameUI/TemplateUI/ItemCombineCostTemplate")
require("GameUI/TemplateUI/ItemCombineBonusItemTemplate")
Item_CombineUI = class(BaseUI)
Item_CombineUI.layer = UILayer.Panel
Item_CombineUI.orderInLayer = 0
Item_CombineUI.hideType = UIHideType.WaitDestroy
Item_CombineUI.hideFunc = UIHideFunc.MoveOutOfScreen
Item_CombineUI.escClose = UIEscClose.DontClose
Item_CombineUI.ECostType = {
  Fixed = enum(0),
  Increasable = enum()
}

function Item_CombineUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.combineMenu = self:GetControl("sw_combine/Viewport/ContentMain/combineMenu")
  self.lab_combineName = self:GetControl("sw_combine/Viewport/ContentMain/combineMenu/lab_combineName")
  self.img_combine = self:GetControl("img_combine")
  self.subMenu = self:GetControl("sw_subMenu/Viewport/ContentSub/subMenu")
  self.subPageMenuItem = self:GetControl("sw_subTwo/Viewport/ContentMain/subMenu")
  self.Button_CloseBag = self:GetControl("img_combine/Button_CloseBag")
  self.img_itemGrey1 = self:GetControl("img_combine/img_combineInside/go_itemGet/img_itemGrey1")
  self.img_itemGrey2 = self:GetControl("img_combine/img_combineInside/go_itemGet/img_itemGrey2")
  self.img_itemGrey3 = self:GetControl("img_combine/img_combineInside/go_itemGet/img_itemGrey3")
  self.img_itemGet = self:GetControl("img_combine/img_combineInside/go_itemGet/btn_3DItem")
  self.lab_desc = self:GetControl("img_combine/img_combineInside/lab_desc")
  self.lab_num = self:GetControl("img_combine/img_combineInside/go_itemGet/img_itemGet/lab_num")
  self.lab_moneyCost = self:GetControl("img_combine/img_combineInside/tx_consumeGold/lab_moneyCost")
  self.go_costone = self:GetControl("img_combine/img_combineInside/go_costItem/go_costone")
  self.go_costTwo = self:GetControl("img_combine/img_combineInside/go_costItem/go_costTwo")
  self.go_costThree = self:GetControl("img_combine/img_combineInside/go_costItem/go_costThree")
  self.go_costFour = self:GetControl("img_combine/img_combineInside/go_costItem/go_costFour")
  self.go_costFive = self:GetControl("img_combine/img_combineInside/go_costItem/go_costFive")
  self.go_costSix = self:GetControl("img_combine/img_combineInside/go_costItem/go_costSix")
  self.go_costSeven = self:GetControl("img_combine/img_combineInside/go_costItem/go_costSeven")
  self.go_costEight = self:GetControl("img_combine/img_combineInside/go_costItem/go_costEight")
  self.go_combineNum = self:GetControl("img_combine/img_combineInside/go_consume/go_combineNum")
  self.btn_mineComCount = self:GetControl("img_combine/img_combineInside/go_consume/go_combineNum/img_progress/btn_mineComCount")
  self.btn_addComCount = self:GetControl("img_combine/img_combineInside/go_consume/go_combineNum/img_progress/btn_addComCount")
  self.lab_combineNum = self:GetControl("img_combine/img_combineInside/go_consume/go_combineNum/img_progress/lab_combineNum")
  self.btn_bonusBuckets = self:GetControl("img_combine/img_combineInside/go_consume/successRate/btn_bonusBuckets")
  self.lab_successRate = self:GetControl("img_combine/img_combineInside/go_consume/successRate/lab_successRate")
  self.btn_combine = self:GetControl("img_combine/img_combineInside/btn_combine")
  self.go_costEquip = self:GetControl("img_combine/go_costEquip")
  self.btn_closeCostEquipe = self:GetControl("img_combine/go_costEquip/btn_closeCostEquipe")
  self.sw_costEquip = self:GetControl("img_combine/go_costEquip/img_smallBg/sw_costEquip")
  self.tog_item = self:GetControl("img_combine/go_costEquip/img_smallBg/sw_costEquip/Viewport/Content/tog_item")
  self.btn_select = self:GetControl("img_combine/go_costEquip/img_smallBg/btn_select")
  self.lab_equipdemand = self:GetControl("img_combine/go_costEquip/img_smallBg/Text/lab_equipdemand")
  self.go_bonusBuckets = self:GetControl("img_combine/go_bonusBuckets")
  self.btn_closeBonusBuckets = self:GetControl("img_combine/go_bonusBuckets/btn_closeBonusBuckets")
  self.go_bonusBucketsItem = self:GetControl("img_combine/go_bonusBuckets/sw_bonusBucketsItem/Viewport/Content/go_bonusBucketsItem")
  self.descBtn = self:GetControl("descBtn")
  self.btn_preview = self:GetControl("img_combine/btn_preview")
  self.combineDefeat = self:GetControl("img_combine/img_combineInside/go_itemGet/combineDefeat")
  self.subMenuRoot = self:GetControl("sw_subMenu/Viewport")
end

function Item_CombineUI:Init()
  self.combineItemObjTab = {}
end

function Item_CombineUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Item_CombineUI:InitUI()
  self:InitCollections()
  self.go_costEquip:SetActive(false)
  self.go_bonusBuckets:SetActive(false)
end

local function OnSubMenuCreate(ctr)
  ctr.nameLab = UIControl(ctr.transform, "lab_subMenu")
  ctr.select = UIControl(ctr.transform, "Checkmark")
  ctr.selectIco_jian = UIControl(ctr.transform, "Checkmark/ico_jian")
  ctr.redPoint = UIControl(ctr.transform, "img_redPoint")
  ctr.ico_jian = UIControl(ctr.transform, "ico_jian")
end

local function SetItemIndex(userInterface, data, index, isLastSubMenu)
  local isSelect
  if userInterface.args then
    if userInterface.args.combineId then
      if data.titleStr then
        if not isLastSubMenu then
          for i = 1, #data do
            isSelect = data[i].id == userInterface.args.combineId
            if isSelect then
              return isSelect
            end
          end
        else
          return data[index].id == userInterface.args.combineId
        end
      elseif ClientTable.cfg_Item_combineManager:TryGetValue(userInterface.args.combineId) then
        isSelect = data.id == userInterface.args.combineId
      else
        isSelect = index == 1
      end
    elseif userInterface.args.openSecondTab and userInterface.args.openSecondTab > 0 then
      isSelect = index == userInterface.args.openSecondTab
    else
      isSelect = index == 1
    end
  else
    isSelect = index == 1
  end
  return isSelect
end

local function OnSubMenuShow(ctr, index, data, ui)
  if not data then
    ctr:SetActive(false)
    return
  else
    ctr:SetActive(true)
  end
  if data.titleStr then
    local namelabKey = string.format("UIItemCombinePageName_%s", data.titleStr)
    if namelabKey then
      ctr.nameLab:SetText(Localization.GetUIWord(namelabKey))
    else
      ctr.nameLab:SetText("C\195\160i \196\145\225\186\183t ui_world" .. namelabKey)
    end
    ctr:SetOnClick(ctr, function()
      ui:RefreshSubCombineItems(ctr)
    end)
    ctr.ico_jian:SetActive(true)
    ctr.selectIco_jian:SetActive(true)
  else
    ctr.nameLab:SetText(Localization.GetUIWord(data.combineFormula))
    ctr.ico_jian:SetActive(false)
    ctr.selectIco_jian:SetActive(false)
    ctr:SetOnClick(ctr, function()
      ui:OnCombineItemToggleValueChanged(ctr, "combineItemToggle")
    end)
  end
  ctr.cfg = data
  ctr.index = index
  ctr.pageKey = data[1] and data[1].subCombineMenu or (data.subCombineMenu == nil or data.subCombineMenu == 0) and data.id or data.subCombineMenu
  if not ui.bagRefresh then
    if SetItemIndex(ui, data, ctr.transform:GetSiblingIndex(), false) then
      ctr.cfg = data
      ctr.select:SetActive(true)
      if data.titleStr then
        ui:RefreshSubCombineItems(ctr)
      else
        ui:OnCombineItemToggleValueChanged(ctr, "combineItemToggle")
      end
    else
      ctr.select:SetActive(false)
    end
  end
end

local function OnSubPageMenuShow(ctr, index, data, ui)
  if not data then
    ctr:SetActive(false)
    return
  else
    ctr:SetActive(true)
  end
  if data.combineFormula then
    ctr.nameLab:SetText(Localization.GetUIWord(data.combineFormula))
  else
    logError(string.format("item_Combine >> combineFormula ch\198\176a c\195\160i \196\145\225\186\183t t\195\170n nh\195\163n, id_%s", data.id))
  end
  ctr:SetOnClick(ctr, function()
    ui:OnCombineItemToggleValueChanged(ctr, "combineItemSubToggle")
  end)
  ctr.cfg = data
  ctr.index = data.id
  ctr.uiIndex = index
  if not ui.bagRefresh then
    if SetItemIndex(ui, data, index, true) then
      ctr.cfg = data
      ctr.select:SetActive(true)
      ui:OnCombineItemToggleValueChanged(ctr, "combineItemSubToggle")
      if ui.args ~= nil then
        ui.args.combineId = nil
      end
    else
      ctr.select:SetActive(false)
    end
  end
end

local function OnItemCreate(ctr)
  ctr.ItemCell = ItemUtility.InitItemCell(ctr)
  ctr.modelData = ItemCellData()
end

local function OnItemRefresh(ctr, index, data, ui)
  if data then
    ctr:SetActive(true)
  else
    ctr:SetActive(false)
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.additional = data.additional
  itemData.intensify = data.intensify
  ctr.modelData:RecycleRes()
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.modelData, ui)
  ctr.item = data
  if ctr.selectImageCtr:GetActive() then
    ui.selectedAddItem = data
  end
  ctr.selectImageCtr:SetActive(ui.HonourTable[data.id] and true or false)
  ctr:SetOnClick(ui, ui.OnSelectItemTogChanged)
end

local function OnPageItemCreat(ctr)
  ctr.checkmark = UIControl(ctr.transform, "Checkmark")
  ctr.pageNameLab = UIControl(ctr.transform, "lab_combineName")
  ctr.redPoint = UIControl(ctr.transform, "img_redPoint")
end

local function OnPageItemRefresh(ctr, index, data, ui)
  if not data then
    ctr:SetActive(false)
    return
  else
    ctr:SetActive(true)
  end
  ctr.pageIndex = index
  ctr:SetOnClick(ui, ui.OnPageToggleValueChanged)
  local pageName = Localization.GetContent("cfg_Ui_word", string.format("UIItemCombinePageName_%d", index))
  ctr.pageNameLab:SetText(pageName)
  ctr.checkmark:SetActive(false)
end

local function CreateCombineItemContainer(self, container, refreshFunc)
  local otherSubMenu = Instantiate(self[container].transform)
  otherSubMenu:SetParent(self[container].transform.parent)
  otherSubMenu.localPosition = Vector3.zero
  otherSubMenu.localScale = Vector3.one
  local btn_3DItem = UIControl(otherSubMenu, "subMenu")
  return UIContainer(btn_3DItem, self, OnSubMenuCreate, refreshFunc)
end

function Item_CombineUI:InitCollections()
  self.pageContainer = UIContainer(self.combineMenu, self, OnPageItemCreat, OnPageItemRefresh)
  self.combineItemContainer = UIContainer(self.subPageMenuItem, self, OnSubMenuCreate, OnSubMenuShow)
  self.otherCombineItemContainer = CreateCombineItemContainer(self, "combineItemContainer", OnSubMenuShow)
  self.subPageMenu = UIContainer(self.subMenu, self, OnSubMenuCreate, OnSubPageMenuShow)
  self.otherSubPageMenu = CreateCombineItemContainer(self, "subPageMenu", OnSubPageMenuShow)
  self.displayBoxItemControls = {
    self.img_itemGet,
    self.img_itemGrey1,
    self.img_itemGrey2,
    self.img_itemGrey3
  }
  self.costSlots = {}
  table.insert(self.costSlots, ItemCombineCostTemplate(self, self.go_costone))
  table.insert(self.costSlots, ItemCombineCostTemplate(self, self.go_costTwo))
  table.insert(self.costSlots, ItemCombineCostTemplate(self, self.go_costThree))
  table.insert(self.costSlots, ItemCombineCostTemplate(self, self.go_costFour))
  table.insert(self.costSlots, ItemCombineCostTemplate(self, self.go_costFive))
  table.insert(self.costSlots, ItemCombineCostTemplate(self, self.go_costSix))
  table.insert(self.costSlots, ItemCombineCostTemplate(self, self.go_costSeven))
  table.insert(self.costSlots, ItemCombineCostTemplate(self, self.go_costEight))
  self.costSlotsObj = {}
  table.insert(self.costSlotsObj, self.go_costone)
  table.insert(self.costSlotsObj, self.go_costTwo)
  table.insert(self.costSlotsObj, self.go_costThree)
  table.insert(self.costSlotsObj, self.go_costFour)
  table.insert(self.costSlotsObj, self.go_costFive)
  table.insert(self.costSlotsObj, self.go_costSix)
  table.insert(self.costSlotsObj, self.go_costSeven)
  table.insert(self.costSlotsObj, self.go_costEight)
  local tempBtn_item = self.sw_costEquip:GetChild("Viewport/Content/btn_3DItem")
  self.HonourTable = {}
  self.addItemContainer = UIContainer(tempBtn_item, self, OnItemCreate, OnItemRefresh)
  self.bonusBucketContainer = UIContainer(self.go_bonusBucketsItem)
end

function Item_CombineUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  if self.args and self.args.npcConfigID then
    self.OpenNPCLog = self.args.npcConfigID
  end
end

function Item_CombineUI:OnHide()
  if self.combineItemsPage then
    self.combineItemsPage.transform:SetParent(self.subMenuRoot.transform)
  end
  if self.combineItemsSubPage then
    self.combineItemsSubPage.transform:SetParent(self.subMenuRoot.transform)
  end
  if self.args and self.args.npcConfigID then
    self.args.npcConfigID = nil
  end
  if self.OpenNPCLog then
    self.OpenNPCLog = nil
  end
  self.selectedAddItem = nil
  self.HonourTable = {}
  ItemCombineData:SetClickHonoerId(nil)
end

function Item_CombineUI:OnDestroy()
end

function Item_CombineUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.Button_CloseBagOnClick)
  self.Button_CloseBag:SetOnClick(self, self.Button_CloseBagOnClick)
  self.btn_mineComCount:SetOnClick(self, self.btn_mineComCountOnClick)
  self.btn_mineComCount:SetOnPress(self, self.btn_mineComCountOnClick, self.OnStopPress, 1)
  self.btn_addComCount:SetOnClick(self, self.btn_addComCountOnClick)
  self.btn_addComCount:SetOnPress(self, self.btn_addComCountOnClick, self.OnStopPress, 1)
  self.btn_bonusBuckets:SetOnClick(self, self.btn_bonusBucketsOnClick)
  self.btn_combine:SetOnClick(self, self.btn_combineOnClick)
  self.btn_closeCostEquipe:SetOnClick(self, self.btn_closeCostEquipeOnClick)
  self.btn_select:SetOnClick(self, self.btn_selectOnClick)
  self.btn_closeBonusBuckets:SetOnClick(self, self.btn_closeBonusBucketsOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_preview:SetOnClick(self, self.BtnPreviewOnClick)
end

function Item_CombineUI:OnStopPress()
end

function Item_CombineUI:Button_CloseBagOnClick(control)
  UIManager.Hide(UIID.Item_CombineUI)
  RoleManager.me:SetTarget(nil)
  if self.args and self.args.openPanel == UIID.SkillUI then
    UIManager.Show(UIID.SkillUI)
  end
end

function Item_CombineUI:btn_mineComCountOnClick(control)
  self:SetCombineCount(self.combineCount - 1)
end

function Item_CombineUI:btn_addComCountOnClick(control)
  self:SetCombineCount(self.combineCount + 1)
end

function Item_CombineUI:btn_bonusBucketsOnClick(control)
  self:ShowAddBonusWidget()
end

function Item_CombineUI:btn_combineOnClick(control)
  self:ReqCombine()
end

function Item_CombineUI:btn_closeCostEquipeOnClick(control)
  self:HideAddItemWidget()
end

function Item_CombineUI:btn_selectOnClick(control)
  self:HideAddItemWidget()
end

function Item_CombineUI:btn_closeBonusBucketsOnClick(control)
  self.go_bonusBuckets:SetActive(false)
end

function Item_CombineUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Item_CombineUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Item_CombineUI:BtnPreviewOnClick()
  if self.previewInfoTab then
    if UIManager.IsVisible(UIID.Item_CombinePreviewUI) then
      UIManager.Hide(UIID.Item_CombinePreviewUI)
    else
      UIManager.Show(UIID.Item_CombinePreviewUI, {
        itemTab = self.previewInfoTab
      })
    end
  end
end

function Item_CombineUI:RegistEvents()
  self:RegistEvent(Event.Item_CombineRsp, self.OnItemCombineRsp, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
end

function Item_CombineUI:Refresh()
  self:RefreshPage()
end

function Item_CombineUI:SetTabPageIndex(count)
  local tabPageItem
  if self.args then
    if self.args.param then
      if self.args.param.guide then
        local guideTab = NavigationUtility.GetNavTblForId(self.args.param.guide)
        if guideTab then
          self.args.combineId = guideTab.subPosition > 0 and guideTab.subPosition or nil
        end
      end
      if self.args.param.combineId then
        self.args.combineId = self.args.param.combineId
      end
    end
    if self.args.combineId then
      local selectCombineTbl = ClientTable.cfg_Item_combineManager:TryGetValue(self.args.combineId)
      if selectCombineTbl then
        for k, v in pairs(self.pageContainer.items) do
          if v.transform.gameObject.activeSelf and v.pageIndex == selectCombineTbl.combineMenu then
            return v
          end
        end
      else
        tabPageItem = self.pageContainer:GetOrCreateItem(1)
      end
    elseif self.args.openFirstTab and count >= self.args.openFirstTab and 0 < self.args.openFirstTab then
      tabPageItem = self.pageContainer:GetOrCreateItem(self.args.openFirstTab)
    else
      tabPageItem = self.pageContainer:GetOrCreateItem(1)
    end
  else
    tabPageItem = self.pageContainer:GetOrCreateItem(1)
  end
  return tabPageItem
end

function Item_CombineUI:RefreshPage()
  local npcId
  if self.args ~= nil and self.args.npcConfigID ~= nil then
    npcId = tostring(self.args.npcConfigID)
  end
  if npcId == nil then
    npcId = self.OpenNPCLog or 1004005
  end
  local dataContainer, redPoints = ItemCombineData:GetCombineList(npcId)
  self.redPointState = redPoints
  local dataCount = self.pageContainer:SetDataByPairs(dataContainer)
  local pagesCount = dataCount
  local pageItem
  self.pageToggle = nil
  pageItem = self:SetTabPageIndex(pagesCount)
  self:OnPageToggleValueChanged(pageItem)
  self:PageRedPointRefresh()
end

function Item_CombineUI:PageRedPointRefresh()
  for k, v in pairs(self.pageContainer.items) do
    local item = v
    if item.transform.gameObject.activeSelf then
      if self.redPointState and item.pageIndex and self.redPointState[item.pageIndex] then
        item.redPoint:SetActive(self.redPointState[item.pageIndex].redPoint)
      else
        item.redPoint:SetActive(false)
      end
    end
  end
end

function Item_CombineUI:SubPageRedPointRefresh()
  for k, v in pairs(self.combineItemsPage.items) do
    local item = v
    if item.transform.gameObject.activeSelf then
      if self.redPointState[self.curPage] == nil then
        item.redPoint:SetActive(false)
      else
        local state = self.redPointState[self.curPage][v.pageKey]
        if type(state) == "table" then
          item.redPoint:SetActive(state.redPoint)
        else
          item.redPoint:SetActive(state)
        end
      end
    end
  end
end

function Item_CombineUI:ItemPageRedPointRefresh()
  if not self.combineItemsSubPage then
    return
  end
  local redPointState = self.redPointState[self.curPage][self.combineItemToggle.pageKey]
  if not redPointState then
    return
  end
  for k, v in pairs(self.combineItemsSubPage.items) do
    local item = v
    if item.transform.gameObject.activeSelf then
      if type(redPointState) == "table" then
        local state = redPointState[k]
        item.redPoint:SetActive(state)
      else
        item.redPoint:SetActive(redPointState)
      end
    end
  end
end

local function RefreshInterfaceSize(self, containerValue)
  local hight = 0
  for i = 1, self[containerValue].transform.childCount - 1 do
    local pageItem = self[containerValue].transform:GetChild(i)
    if pageItem.gameObject.activeSelf then
      hight = hight + pageItem.sizeDelta.y + 7
    end
  end
  local size = self[containerValue].transform.sizeDelta
  self[containerValue].transform.sizeDelta = Vector2.right * size.x + Vector2.up * hight
end

local currrentSubMenuCut = false

function Item_CombineUI:RefreshCombineItems(control)
  if self.combineItemToggle and self.combineItemToggle.cfg.titleStr then
    self:RefreshSubCombineItems(self.combineItemToggle)
  end
  self.go_bonusBuckets:SetActive(false)
  local combineCfgs = ItemCombineData.combineItems[tonumber(control.pageIndex)]
  local currenContainer, runingContainer
  if currrentSubMenuCut then
    currenContainer = self.combineItemContainer
    runingContainer = self.otherCombineItemContainer
  else
    currenContainer = self.otherCombineItemContainer
    runingContainer = self.combineItemContainer
  end
  currrentSubMenuCut = not currrentSubMenuCut
  currenContainer:SetActive(false)
  self.combineItemsPage = runingContainer
  local combineCfgsSorted = {}
  for k, v in pairs(combineCfgs) do
    table.insert(combineCfgsSorted, v)
  end
  table.sort(combineCfgsSorted, function(a, b)
    return self:SortRuler(a, b)
  end)
  local dataCount = runingContainer:SetDataByPairs(combineCfgsSorted)
  runingContainer:SetActive(true)
  runingContainer.transform:SetParent(control.transform.parent)
  runingContainer.transform:SetSiblingIndex(control.transform:GetSiblingIndex() + 1)
  self:SubPageRedPointRefresh()
  currenContainer.transform:SetParent(self.subMenuRoot.transform)
  local hightSize = self.subPageMenuItem.transform.sizeDelta.y
  local wideSize = runingContainer.transform.sizeDelta.x
  runingContainer.transform.sizeDelta = Vector2.right * wideSize + Vector2.up * (hightSize + 7) * dataCount
  RefreshInterfaceSize(self, "combineItemsPage")
  RefreshInterfaceSize(self, "pageContainer")
end

local currenSubContainer = false

function Item_CombineUI:RefreshSubCombineItems(control)
  if self.combineItemToggle == control then
    local currenContainer
    if currenSubContainer then
      currenContainer = self.subPageMenu
    else
      currenContainer = self.otherSubPageMenu
    end
    if currenContainer ~= nil then
      currenContainer:SetActive(not currenContainer:GetActive())
      control.selectIco_jian:SetRotation(0, 0, currenContainer:GetActive() and 0 or -90)
      if currenContainer:GetActive() then
        currenContainer.transform:SetParent(control.transform.parent)
        currenContainer.transform:SetSiblingIndex(control.transform:GetSiblingIndex() + 1)
        self.combineItemsSubPage = currenContainer
      else
        currenContainer.transform:SetParent(self.subMenuRoot.transform)
      end
    end
    RefreshInterfaceSize(self, "combineItemsPage")
    RefreshInterfaceSize(self, "pageContainer")
    return
  end
  if self.combineItemToggle then
    self.combineItemToggle.select:SetActive(false)
  end
  self.combineItemToggle = control
  self.combineItemToggle.select:SetActive(true)
  self.combineItemToggle.selectIco_jian:SetRotation(0, 0, 0)
  local currenContainer, runingContainer
  if currenSubContainer then
    currenContainer = self.subPageMenu
    runingContainer = self.otherSubPageMenu
  else
    currenContainer = self.otherSubPageMenu
    runingContainer = self.subPageMenu
  end
  currenSubContainer = not currenSubContainer
  currenContainer:SetActive(false)
  self.combineItemsSubPage = runingContainer
  local dataCount = runingContainer:SetDataByPairs(control.cfg)
  self:ItemPageRedPointRefresh()
  runingContainer:SetActive(true)
  runingContainer.transform:SetParent(control.transform.parent)
  runingContainer.transform:SetSiblingIndex(control.transform:GetSiblingIndex() + 1)
  currenContainer.transform:SetParent(self.subMenuRoot.transform)
  local hightSize = self.subMenu.transform.sizeDelta.y
  local wideSize = runingContainer.transform.sizeDelta.x
  runingContainer.transform.sizeDelta = Vector2.right * wideSize + Vector2.up * (hightSize + 7) * dataCount
  RefreshInterfaceSize(self, "combineItemsPage")
  RefreshInterfaceSize(self, "pageContainer")
end

function Item_CombineUI:RefreshCombineItemPageInfo(cfgItem)
  self.curCombineCfg = cfgItem
  self:RefreshBoxInfo(cfgItem)
  self:RefreshCostInfo(cfgItem)
  self:RefreshItemCost(cfgItem)
  self:RefreshGoldCost(cfgItem)
end

function Item_CombineUI:RefreshBoxInfo(cfgItem)
  if not self.propDisplay then
    self.propDisplay = ItemCellData()
  end
  self.propDisplay:RecycleRes()
  local boxes = ItemboxDisplayManager.GetBox(ViewData.meData.career, cfgItem.rewardBoxId)
  if UIManager.IsVisible(UIID.Item_CombinePreviewUI) then
    UIManager.Hide(UIID.Item_CombinePreviewUI)
  end
  local itemData = ItemboxDisplayManager.GenerateItemShowData(boxes[1])
  local itemTab = ItemUtility.InitItemCell(self.img_itemGet)
  itemTab.nameCtr:SetText(Localization.GetUIWord(cfgItem.combineFormula))
  itemTab.countCtr:SetText("")
  if cfgItem.rewardDesc == "" then
    self.btn_preview:SetActive(false)
    self.img_itemGet.boxCfg = boxes[1]
    self.img_itemGet.itemData = itemData
    self.lab_desc:SetActive(false)
    self.previewInfoTab = nil
  else
    self.btn_preview:SetActive(true)
    self.img_itemGet.itemData = nil
    self.lab_desc:SetActive(true)
    self.lab_desc:SetText(Localization.GetUIWord(cfgItem.rewardDesc))
    self.previewInfoTab = boxes
    if self.previewInfoTab and not UIManager.IsVisible(UIID.Item_CombinePreviewUI) then
      UIManager.Show(UIID.Item_CombinePreviewUI, {
        itemTab = self.previewInfoTab
      })
    end
  end
  self.propDisplay:RefreshData(itemData)
  self.propDisplay.isShowArrow = false
  if not string.isNullOrEmpty(cfgItem.showImage) then
    local pathStrs = string.split(cfgItem.showImage, "#")
    itemData.tblItem = {
      name = Localization.GetUIWord(cfgItem.combineFormula),
      type = itemData.tblItem.type,
      subType = itemData.tblItem.subType,
      model = pathStrs[#pathStrs],
      xTranslate = itemData.tblItem.xTranslate,
      yTranslate = itemData.tblItem.yTranslate,
      Position = itemData.tblItem.Position
    }
    ItemUtility.ShowItemCell(itemTab, self.propDisplay, self, false)
  else
    if itemData.tblItem.subType == 20 then
      local qualityDataDic = ItemCombineData:GetQualityData()
      local info = qualityDataDic[itemData.tblItem.quality]
      if info then
        itemData:DoWingGenerateAttr({
          damageBonus = info.damageBonus,
          damageAbsorption = info.damageAbsorption
        })
      else
        itemData:DoWingGenerateAttr({damageBonus = "#N/A", damageAbsorption = "#N/A"})
      end
    end
    if itemData.tblItem.type == EItemType.NewRune and cfgItem.costSecondaryBuckets then
      local itemCtr = ItemUtility.ShowItemCell(itemTab, self.propDisplay, self, false)
      local costStr = string.split(cfgItem.costSecondaryBuckets, "#")
      local _, ownCount, notBindCount = BagInfoData.GetItemTotalCountByItemIdAndContainBind(tonumber(costStr[1]))
      local BindCount = bindCount and bindCount or 0
      itemCtr:SetOnClick(itemCtr, function()
        UIManager.Show(UIID.ItemTipUI, {
          item = itemTab.itemData,
          rightOperate = EItemOperateType.Show,
          ctrl = itemTab,
          bindCount = ownCount,
          notBindCount = notBindCount
        })
      end)
    else
      ItemUtility.ShowItemCell(itemTab, self.propDisplay, self, true)
    end
  end
  itemTab.countCtr:SetActive(false)
  itemTab.go_model.transform.localPosition = Vector3.forward * -10
  if cfgItem.scale then
    itemTab.go_model.transform.localScale = Vector3.one * cfgItem.scale
  else
    itemTab.go_model.transform.localScale = Vector3.one * 2
  end
end

function Item_CombineUI:RefreshCostInfo(cfgItem)
  local costParams = string.stringToNumberArray(cfgItem.monenyCost, "#")
  self.costType = costParams[1] and costParams[1] or 0
  self.costItemId = costParams[2] and costParams[2] or 1000010
  self.costBase = costParams[3] and costParams[3] or 0
  self.sucRate = cfgItem.basicSuccessRate
  self.maxSucRate = cfgItem.maxSuccessRate
  self.maxBonusRate = self.maxSucRate - self.sucRate
  self.lab_successRate:SetText(tostring(math.floor(self.sucRate / 100) .. "%"))
  self.btn_bonusBuckets:SetActive(not string.isNullOrEmpty(cfgItem.bonusBuckets))
  self.selectedAddItem = nil
end

function Item_CombineUI:RefreshGoldCost(cfgItem)
  if self.costType == self.ECostType.Fixed then
    self.costfianl = self.costBase
  else
    self.costfianl = self.costBase * self.sucRate / 10000
  end
  self.costfianl = self.costfianl * self.combineCount
  local ownGold = BagInfoData.GetItemTotalCountByItemId(self.costItemId)
  self.costGoldEnough = ownGold >= self.costfianl
end

function Item_CombineUI:CheckIsHonour()
  if table.count(self.costBuckets.buckets) == 1 and self.costBuckets.buckets[1].count and 1 < self.costBuckets.buckets[1].count and self.costBuckets.buckets[1].conditions and self.costBuckets.buckets[1].conditions[1] and tonumber(self.costBuckets.buckets[1].conditions[1].param) == 42990001 then
    return true
  else
    return false
  end
end

function Item_CombineUI:RefreshItemCost(cfgItem)
  self.curCombineItem = cfgItem
  self.costBuckets = Cost_ItemCombine()
  self.costBuckets:AddOptionalBuckets(cfgItem.costMainBuckets)
  self.costBuckets:AddRequiredBuckets(cfgItem.costSecondaryBuckets)
  local bucketCount = self.costBuckets.BucketCount
  for i = bucketCount + 1, #self.costSlots do
    self.costSlots[i]:SetActive(false)
  end
  if self:CheckIsHonour() then
    self.ShowManyCostOne = true
    bucketCount = self.costBuckets.buckets[1].count
    for i = 1, bucketCount do
      local isOptionalBuckets = true
      local isSelectedAddItem = self.selectedAddItem ~= nil
      self.costSlots[i]:InitUI(cfgItem, self.costBuckets.buckets[1], isOptionalBuckets, isSelectedAddItem)
      self.costSlots[i]:SetActive(true)
    end
  else
    self.ShowManyCostOne = false
    for i = 1, bucketCount do
      local isOptionalBuckets = i == 1
      local isSelectedAddItem = self.selectedAddItem ~= nil
      self.costSlots[i]:InitUI(cfgItem, self.costBuckets.buckets[i], isOptionalBuckets, isSelectedAddItem)
      self.costSlots[i]:SetActive(true)
    end
  end
  self.maxTblLimitCount = cfgItem.countMax
  self.maxCanCombineCount = self.costSlots[1].MaxCombineCount
  for i = 2, #self.costSlots do
    if self.costSlots[i].active and self.maxCanCombineCount > self.costSlots[i].MaxCombineCount then
      self.maxCanCombineCount = self.costSlots[i].MaxCombineCount
    end
  end
  if not self.bagRefresh then
    self:SetCombineCount(1)
  end
  if self.costfianl == 0 then
    self.costSlots[bucketCount + 1]:SetActive(false)
  else
    self:RefreshGoldCost()
    self.costSlots[bucketCount + 1]:InitUI(cfgItem, {
      itemId = 1000010,
      count = self.costfianl,
      isCoin = true
    })
    local bagCoinStr = ""
    local bagCount = BagInfoData.GetItemTotalCountByItemId(self.costItemId)
    bagCount = Mathf.NumberShowFormat(bagCount, 0)
    if self.costGoldEnough then
      bagCoinStr = string.GetColorText(bagCount, "#00DD00")
    else
      bagCoinStr = string.GetColorText(bagCount, "#FF0000")
    end
    local costCount = Mathf.NumberShowFormat(self.costfianl, 0)
    bagCoinStr = bagCoinStr .. [[

/]] .. costCount
    local cosText = self.costSlotsObj[bucketCount + 1]:GetChild("lab_costInfo")
    cosText:SetText(bagCoinStr)
    local originSize = cosText.rectTransform.sizeDelta
    cosText.rectTransform.sizeDelta = Vector2.right * originSize.x + Vector2.up * 40
    self.costSlots[bucketCount + 1]:SetActive(true)
  end
  self:CheckCanCombineMulti()
end

function Item_CombineUI:CheckCanCombineMulti()
  local can = true
  for i = 1, #self.costSlots do
    if not (not self.costSlots[i].active or self.costSlots[i].isCertainCost) or self.curCombineItem.batchCombine == 0 then
      can = false
      break
    end
  end
  self.go_combineNum:SetActive(can)
end

function Item_CombineUI:OnPageToggleValueChanged(pageControl)
  if not pageControl then
    return
  end
  if self.pageToggle == pageControl then
    local currenContainer = currrentSubMenuCut and self.combineItemContainer or self.otherCombineItemContainer
    if currenContainer ~= nil then
      currenContainer:SetActive(not currenContainer:GetActive())
    end
    return
  end
  if self.combineItemsSubPage then
    self.combineItemsSubPage:SetParent(self.subMenuRoot.transform)
    self.combineItemsSubPage = nil
  end
  if self.pageToggle ~= nil then
    self.pageToggle.checkmark:SetActive(false)
  end
  self.pageToggle = pageControl
  self.pageToggle.checkmark:SetActive(true)
  self.curPage = pageControl.pageIndex
  self:RefreshCombineItems(pageControl)
  self.HonourTable = {}
  ItemCombineData:SetClickHonoerId(nil)
end

function Item_CombineUI:OnCombineItemToggleValueChanged(itemControl, currentToggle)
  if self[currentToggle] == itemControl then
    return
  elseif self[currentToggle] and self[currentToggle].cfg.titleStr and self[currentToggle].select.transform.gameObject.activeSelf then
    self:RefreshSubCombineItems(self[currentToggle])
  end
  if self[currentToggle] then
    self[currentToggle].select:SetActive(false)
  end
  self[currentToggle] = itemControl
  itemControl.select:SetActive(true)
  self:RefreshCombineItemPageInfo(itemControl.cfg)
  self:BtnCombineRedPointRefresh()
  self.selectedAddItem = nil
  if self.go_costEquip.gameObject.activeSelf then
    self.go_costEquip:SetActive(false)
  end
end

function Item_CombineUI:OnClickBoxDisplayItem(control)
  if not control.itemData then
    return
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = control.itemData,
    ctrl = control,
    rightOperate = EItemOperateType.Show
  })
end

function Item_CombineUI:ShowAddItemWidget(template, optionalItems, onclose)
  self.costTemplate = template
  self.onCloseAddItemWidget = onclose
  local bucketIndex = -1
  for i = 1, #self.costSlots do
    if template == self.costSlots[i] then
      bucketIndex = i
      break
    end
  end
  local title
  local titles = string.split(self.curCombineCfg.costName, "#")
  if bucketIndex <= #titles then
    title = Localization.GetUIWord(titles[bucketIndex])
  end
  self.lab_equipdemand:SetText(title)
  self.addItemContainer:SetData(optionalItems)
  self.go_costEquip:SetActive(true)
end

function Item_CombineUI:HideAddItemWidget()
  if self.ShowManyCostOne then
    self.go_costEquip:SetActive(false)
    if self.checkIsClick and self.addHonourItem and not self.HonourTable[self.addHonourItem] and self.selectedAddItem then
      if self.onCloseAddItemWidget ~= nil then
        self.onCloseAddItemWidget(self.costTemplate, self.selectedAddItem)
        self.onCloseAddItemWidget = nil
      end
      self.HonourTable[self.addHonourItem] = self.addHonourItem
    end
    self.checkIsClick = false
  else
    self.go_costEquip:SetActive(false)
    if self.onCloseAddItemWidget ~= nil then
      self.onCloseAddItemWidget(self.costTemplate, self.selectedAddItem)
      self.onCloseAddItemWidget = nil
    end
  end
  self.thisClickOnce = false
  ItemCombineData:SetClickHonoerId(nil)
end

function Item_CombineUI:OnSelectItemTogChanged(control)
  local clickId = ItemCombineData:GetClickHonoerId()
  if self.ShowManyCostOne then
    if self.HonourTable[control.item.id] then
      return
    end
    self.checkIsClick = true
    local infoCount = self.costBuckets.buckets[1].count
    local count = 0
    for i = 1, self.addItemContainer.maxCount do
      local tmepObjBtn = self.addItemContainer:GetOrCreateItem(i)
      tmepObjBtn.selectImageCtr:SetActive(self.HonourTable[tmepObjBtn.item.id] and true or false)
      if tmepObjBtn.selectImageCtr.gameObject.activeSelf then
        count = count + 1
      end
    end
    if not self.HonourTable[control.item.id] and infoCount > count then
      self.selectedAddItem = control.item
      control.selectImageCtr:SetActive(true)
      self.addHonourItem = control.item.id
      if clickId then
        self.HonourTable[clickId] = nil
        if not self.thisClickOnce then
          self:RefreshSelectShow(clickId)
          self.thisClickOnce = true
        end
      end
    elseif self.HonourTable[control.item.id] and infoCount > count then
    elseif count == infoCount then
      if self.HonourTable[control.item.id] then
      else
        self.addHonourItem = control.item.id
        self.selectedAddItem = control.item
        control.selectImageCtr:SetActive(true)
        self.HonourTable[clickId] = nil
        if not self.thisClickOnce then
          self:RefreshSelectShow(clickId)
          self.thisClickOnce = true
        end
      end
    else
      self.addHonourItem = nil
    end
  else
    for i = 1, self.addItemContainer.maxCount do
      local tmepObjBtn = self.addItemContainer:GetOrCreateItem(i)
      tmepObjBtn.selectImageCtr:SetActive(false)
    end
    self.selectedAddItem = control.item
    control.selectImageCtr:SetActive(true)
  end
end

function Item_CombineUI:RefreshSelectShow(clickId)
  for i = 1, self.addItemContainer.maxCount do
    local tmepObjBtn = self.addItemContainer:GetOrCreateItem(i)
    if tmepObjBtn.item.id == clickId then
      tmepObjBtn.selectImageCtr:SetActive(false)
      break
    end
  end
end

function Item_CombineUI:SetCombineCount(count)
  local maxCount
  if self.maxTblLimitCount ~= nil and self.maxTblLimitCount > 0 then
    maxCount = self.maxCanCombineCount > self.maxTblLimitCount and self.maxTblLimitCount or self.maxCanCombineCount
  else
    maxCount = self.maxCanCombineCount
  end
  if count < 1 then
    count = maxCount
  end
  self.combineCount = count
  self.combineCount = Mathf.Clamp(count, 1, maxCount)
  self.btn_mineComCount:SetInteractable(0 < self.combineCount)
  self.btn_addComCount:SetInteractable(maxCount > self.combineCount)
  self.lab_combineNum:SetText(self.combineCount)
  self:RefreshGoldCost()
  for i = 1, #self.costSlots do
    if self.costSlots[i].active then
      self.costSlots[i]:RefreshCombineCount(self.combineCount)
    end
  end
end

function Item_CombineUI:ShowAddBonusWidget()
  local bonusBucketStrs = string.split(self.curCombineCfg.bonusBuckets, "&")
  self.bonusBucketContainer:SetMaxCount(#bonusBucketStrs)
  if self.bonusBucketTemplates == nil then
    self.bonusBucketTemplates = {}
  end
  for i = 1, #bonusBucketStrs do
    if self.bonusBucketTemplates[i] == nil then
      self.bonusBucketTemplates[i] = ItemCombineBonusItemTemplate(self, self.bonusBucketContainer:GetOrCreateItem(i))
    end
    self.bonusBucketTemplates[i]:RefreshUI(bonusBucketStrs[i])
  end
  self.bonusBucketContainer:Refresh()
  self.go_bonusBuckets:SetActive(true)
end

function Item_CombineUI:ResetBonusInfo()
  if self.bonusBucketTemplates ~= nil then
    for i = 1, #self.bonusBucketTemplates do
      self.bonusBucketTemplates[i]:ResetUI()
    end
  end
end

function Item_CombineUI:CheckMaxBonusRate()
  return self.bonusRate < self.maxBonusRate
end

function Item_CombineUI:RefreshBonusInfo()
  local tmp
  self.bonusRate = 0
  for i = 1, #self.bonusBucketTemplates do
    tmp = self.bonusBucketTemplates[i]
    if tmp.Active then
      self.bonusRate = self.bonusRate + tmp.SumBonusRate
    end
  end
  self.sucRate = self.curCombineCfg.basicSuccessRate + self.bonusRate
  self.lab_successRate:SetText(tostring(math.floor(self.sucRate / 100) .. "%"))
  self:RefreshGoldCost()
end

function Item_CombineUI:SetToggleState(state, control, checkMarkPath)
  control = control:GetChild(checkMarkPath)
  control:SetActive(state)
end

function Item_CombineUI:ReqCombine()
  if not self.costGoldEnough then
    TipUtility.ShowPrompt("tishi", "CombineFailed_2")
  end
  local mainBuckets = {}
  local bucketIndex = 0
  local tmpObject
  for i = 1, #self.costSlots do
    tmpObject = self.costSlots[i]
    if tmpObject.active then
      if not tmpObject.satisfied then
        TipUtility.ShowPrompt("tishi", "CombineFailed_1")
        return
      end
      if not tmpObject.isCertainCost then
        mainBuckets[bucketIndex] = tmpObject.filledItemData.id
        bucketIndex = bucketIndex + 1
      end
    end
  end
  local bonusBuckets = {}
  if self.bonusBucketTemplates ~= nil then
    for i = 1, #self.bonusBucketTemplates do
      tmpObject = self.bonusBucketTemplates[i]
      if tmpObject.Active and 0 < tmpObject.bonusCount then
        bonusBuckets[tmpObject.bonusItemId] = tmpObject.bonusCount
      end
    end
  end
  self:ShowCombineCostEffect(self.costSlotsObj)
  ItemCombineController.ReqCombine(self.curCombineItem.id, mainBuckets, bonusBuckets, self.combineCount)
  self.selectedAddItem = nil
end

function Item_CombineUI:OnItemCombineRsp(_, msg)
  if #msg.rewards > 0 then
    local combineMap = {}
    local showItems = {}
    for i = 1, msg.combineCount do
      combineMap[tostring(i)] = i
    end
    for i, v in pairs(combineMap) do
      if msg.rewards[v] then
        table.insert(showItems, msg.rewards[v])
      end
    end
    if 0 < table.count(showItems) then
      UIManager.Show(UIID.ObtainTipUI, {
        generalRewards = showItems,
        specialRewards = nil,
        isCombine = true
      })
    end
  elseif UIManager.IsVisible(UIID.EffectTipUI) then
    EventManager.Dispatch(Event.TipEffect, {
      name = "combineDefeat",
      time = 1
    })
  else
    UIManager.Show(UIID.EffectTipUI, {
      name = "combineDefeat",
      effectTime = 1
    })
  end
  self:SetCombineCount(1)
  self.HonourTable = {}
  ItemCombineData:SetClickHonoerId(nil)
end

function Item_CombineUI:OnBagChange(_, msg)
  local npcId = "nil"
  if self.args ~= nil then
    npcId = tostring(self.args.npcConfigID)
  end
  if npcId == "nil" then
    npcId = self.OpenNPCLog or 1004005
  end
  local dataContainer, redPoints = ItemCombineData:GetCombineList(npcId)
  self.redPointState = redPoints
  local combineCfgs = dataContainer[self.curPage]
  if combineCfgs == nil or next(combineCfgs) == nil then
    self.args = nil
    self:Refresh()
    return
  end
  local combineCfgsSorted = {}
  for k, v in pairs(combineCfgs) do
    table.insert(combineCfgsSorted, v)
  end
  table.sort(combineCfgsSorted, function(a, b)
    return self:SortRuler(a, b)
  end)
  self.selectedAddItem = nil
  self.HonourTable = {}
  ItemCombineData:SetClickHonoerId(nil)
  self.bagRefresh = true
  local selectItemcfg_SecondPage, selectItemcfg_ThridPage
  local dataCount = 0
  
  local function OnBagChangeOnContainerNumChange(pageIndex, combineItemsPage, index, dataCount)
    local curPageIndex = index
    local finalPageIndex = dataCount >= curPageIndex and curPageIndex or dataCount
    for i = 1, dataCount do
      combineItemsPage.items[i].select:SetActive(i == finalPageIndex)
    end
    local isBagReduce = table.count(msg.TruereduceTbl) ~= 0 or table.count(msg.removeItems) ~= 0
    if pageIndex == 2 then
      if not isBagReduce then
        self.combineItemToggle = combineItemsPage.items[finalPageIndex]
      end
      selectItemcfg_SecondPage = self.curPage and dataContainer[self.curPage][finalPageIndex]
    elseif pageIndex == 3 then
      if not isBagReduce then
        self.combineItemSubToggle = combineItemsPage.items[finalPageIndex]
      end
      selectItemcfg_ThridPage = dataContainer[self.curPage][self.combineItemToggle.pageKey][finalPageIndex]
    end
  end
  
  if self.combineItemsPage then
    self.combineItemsPage:SetParent(self.subMenuRoot.transform)
  end
  self.pageContainer:SetDataByPairs(dataContainer)
  if self.pageToggle then
    self.pageToggle.checkmark:SetActive(true)
  end
  if self.combineItemsPage then
    self.combineItemsPage:SetParent(self.pageContainer.transform)
    self.combineItemsPage:SetSiblingIndex(self.pageToggle.transform:GetSiblingIndex() + 1)
  end
  if self.combineItemsSubPage and next(combineCfgs) then
    local index = self.combineItemsSubPage.transform:GetSiblingIndex()
    local parent = self.combineItemsSubPage.transform.parent
    self.combineItemsSubPage.transform:SetParent(self.subMenuRoot.transform)
    dataCount = self.combineItemsPage:SetDataByPairs(combineCfgsSorted)
    self.combineItemsSubPage.transform:SetParent(parent)
    self.combineItemsSubPage.transform:SetSiblingIndex(index)
    local subItems = self.combineItemToggle and dataContainer[self.curPage][self.combineItemToggle.pageKey]
    if subItems then
      local subCount = self.combineItemsSubPage:SetDataByPairs(subItems)
      local hightSize = self.subMenu.transform.sizeDelta.y
      local wideSize = self.combineItemsSubPage.transform.sizeDelta.x
      self.combineItemsSubPage.transform.sizeDelta = Vector2.right * wideSize + Vector2.up * (hightSize + 7) * subCount
      if 0 < subCount and self.combineItemsSubPage and self.combineItemSubToggle then
        OnBagChangeOnContainerNumChange(3, self.combineItemsSubPage, self.combineItemSubToggle.uiIndex, subCount)
      end
    end
  else
    dataCount = self.combineItemsPage:SetDataByPairs(combineCfgsSorted)
    if dataCount == 0 then
      self.pageToggle:SetActive(false)
    elseif self.combineItemsPage and self.combineItemToggle then
      OnBagChangeOnContainerNumChange(2, self.combineItemsPage, self.combineItemToggle.index, dataCount)
    end
  end
  if selectItemcfg_ThridPage then
    self:RefreshCombineItemPageInfo(selectItemcfg_ThridPage)
  elseif selectItemcfg_SecondPage then
    self:RefreshCombineItemPageInfo(selectItemcfg_SecondPage)
  elseif self.curCombineCfg then
    self:RefreshCombineItemPageInfo(self.curCombineCfg)
  end
  local hightSize = self.subMenu.transform.sizeDelta.y
  local wideSize = self.combineItemsPage.transform.sizeDelta.x
  self.combineItemsPage.transform.sizeDelta = Vector2.right * wideSize + Vector2.up * (hightSize + 7) * dataCount
  RefreshInterfaceSize(self, "combineItemsPage")
  RefreshInterfaceSize(self, "pageContainer")
  self:PageRedPointRefresh()
  self:SubPageRedPointRefresh()
  self:ItemPageRedPointRefresh()
  self:BtnCombineRedPointRefresh()
  self.bagRefresh = false
end

function Item_CombineUI:PageItemRefresh(cfgTab, pageItem)
  if not pageItem or not cfgTab then
    return
  end
  local isShow = false
  for i = 1, #cfgTab do
    local cfgItem = cfgTab[i]
    if not cfgItem.titleStr then
    end
  end
  pageItem:GetChild("img_redPoint"):SetActive(isShow)
end

function Item_CombineUI:SubMenuRedPointRefresh(cfgItem, combineItem)
  if not cfgItem or not combineItem then
    return
  end
  local isCanCombine = true
  local costParams = string.stringToNumberArray(cfgItem.monenyCost, "#")
  costParams[1] = costParams[1] and costParams[1] or 0
  costParams[2] = costParams[2] and costParams[2] or 1000010
  costParams[3] = costParams[3] and costParams[3] or 0
  local costFinal, combineCount = nil, 1
  if costParams[1] == self.ECostType.Fixed then
    costFinal = costParams[3]
  else
    costFinal = costParams[3] * cfgItem.basicSuccessRate / 10000
  end
  costFinal = costFinal * combineCount
  local ownGold = BagInfoData.GetItemTotalCountByItemId(costParams[2])
  isCanCombine = costFinal <= ownGold
  if isCanCombine then
    if cfgItem.costMainBuckets ~= nil then
      local strTab = cfgItem.costMainBuckets
      local costTab, conditionTab, condition, equipCount
      local tempTab = {}
      conditionTab = strTab[1][1]
      equipCount = table.count(conditionTab[2])
      for j = 1, #strTab[1] do
        condition = ConditionManager.GenerateSingleCondition(strTab[1][j])
        table.insert(tempTab, condition)
      end
      local bagEquipTab = BagInfoData.SelectItems(tempTab)
      if not bagEquipTab or #bagEquipTab == 0 then
        isCanCombine = false
      end
    end
    if isCanCombine then
      local strTab, itemTab, itemId, itemCount, bagCount
      strTab = string.split(cfgItem.costSecondaryBuckets, "&")
      for i = 1, #strTab do
        itemTab = string.split(strTab[i], "#")
        itemId = tonumber(itemTab[1])
        itemCount = tonumber(itemTab[2])
        bagCount = BagInfoData.GetItemTotalCountByItemId(itemId)
        if itemCount > bagCount then
          isCanCombine = false
          break
        end
      end
    end
  end
  combineItem:GetChild("img_redPoint"):SetActive(isCanCombine)
end

function Item_CombineUI:BtnCombineRedPointRefresh()
  local isCanCombine = true
  if self.costGoldEnough then
    local tmpTab, tmpObj
    if self:CheckIsHonour() then
      local configId = self.costBuckets.buckets[1].conditions[1].param
      local NeedCost = self.costBuckets.buckets[1].count
      local HaveNum = BagInfoData.GetItemCountByItemConfigId(tonumber(configId))
      if NeedCost <= HaveNum then
        isCanCombine = true
      else
        isCanCombine = false
      end
    else
      for i = 1, #self.costSlots do
        tmpTab = self.costSlots[i]
        tmpObj = self.costSlotsObj[i]
        if tmpTab.active then
          if tmpObj:GetChild("btn_addEquipe").gameObject.activeSelf then
            local optionalItems
            if self:CheckIsHonour() then
              optionalItems = BagInfoData.SelectItems(self.costBuckets.buckets[1].conditions)
            else
              optionalItems = BagInfoData.SelectItems(self.costBuckets.buckets[i].conditions)
            end
            if not optionalItems or #optionalItems == 0 then
              isCanCombine = false
              break
            end
          elseif not tmpTab.satisfied then
            isCanCombine = false
            break
          end
        end
      end
    end
  else
    isCanCombine = false
  end
  self.btn_combine:GetChild("img_redPoint"):SetActive(isCanCombine)
end

function Item_CombineUI:ShowCombineDefeatEffect(effectObj)
  effectObj:SetActive(false)
  effectObj:SetActive(true)
  Timer.Start(0.8, function()
    if effectObj.gameObject.activeSelf then
      effectObj:SetActive(false)
    end
  end)
end

function Item_CombineUI:ShowCombineCostEffect(objTab)
  if self.showEffectCost ~= nil then
    Coroutine.Stop(self.showEffectCost)
    self.showEffectCost = nil
  end
  for i = 1, table.count(objTab) do
    local obj = objTab[i]:GetChild("effect")
    self:EffectOrderLayerSet(obj, 1000)
    obj:SetActive(false)
  end
  
  local function EffectFuc()
    for i = 1, table.count(objTab) do
      local obj = objTab[i]:GetChild("effect")
      obj:SetActive(true)
    end
    Coroutine.Wait(1)
    for i = 1, table.count(objTab) do
      local obj = objTab[i]:GetChild("effect")
      obj:SetActive(false)
    end
  end
  
  self.showEffectCost = Coroutine.Start(EffectFuc)
end

function Item_CombineUI:EffectOrderLayerSet(go, layer)
  local particles = go.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  if particles then
    for i = 0, particles.Length - 1 do
      local renderer = particles[i].gameObject:GetComponent(typeof(CS.UnityEngine.Renderer))
      if renderer then
        renderer.sortingOrder = layer
      end
    end
  end
end

function Item_CombineUI:SortRuler(a, b)
  local idA = a.id or a[1].id
  local idB = b.id or b[1].id
  return idA < idB
end
