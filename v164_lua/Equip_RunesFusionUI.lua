Equip_RunesFusionUI = class(BaseUI)
Equip_RunesFusionUI.layer = UILayer.Panel
Equip_RunesFusionUI.orderInLayer = 2
Equip_RunesFusionUI.hideType = UIHideType.WaitDestroy
Equip_RunesFusionUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_RunesFusionUI.escClose = UIEscClose.DontClose

function Equip_RunesFusionUI:InitControls()
  self.ContentMain = self:GetControl("LeftPanel/sw_runesList/Viewport/ContentMain")
  self.RunesMenu = self:GetControl("LeftPanel/sw_runesList/Viewport/ContentMain/RunesMenu")
  self.lab_runesName = self:GetControl("LeftPanel/sw_runesList/Viewport/ContentMain/RunesMenu/lab_runesName")
  self.sw_subMenuViewport = self:GetControl("LeftPanel/sw_subMenu/Viewport")
  self.runesBtnItem = self:GetControl("LeftPanel/sw_subMenu/Viewport/ContentSub/runesBtnItem")
  self.btn_wild3DItem = self:GetControl("LeftPanel/sw_subMenu/Viewport/ContentSub/runesBtnItem/btn_wild3DItem")
  self.bg_equip = self:GetControl("RightPanel/bg_equip")
  self.lb_name = self:GetControl("RightPanel/bg_equip/lb_name")
  self.btn_Item = self:GetControl("RightPanel/bg_equip/btn_Item")
  self.btn_Fusion = self:GetControl("RightPanel/bg_equip/btn_Fusion")
  self.text_Fusion = self:GetControl("RightPanel/bg_equip/btn_Fusion/text_Fusion")
  self.btn_FusionRedPoint = self:GetControl("RightPanel/bg_equip/btn_Fusion/img_redPoint")
  self.lab_attributegrow = self:GetControl("RightPanel/bg_equip/RunesAttribute/lab_attributegrow")
  self.lab = self:GetControl("RightPanel/bg_equip/RunesAttribute/lab_attributegrow/img_titleico/content/lab")
  self.text_atk = self:GetControl("RightPanel/bg_equip/RunesAttribute/lab_attributegrow/img_titleico/content/lab/lab_atk/text_atk")
  self.text_atkArrow = self:GetControl("RightPanel/bg_equip/RunesAttribute/lab_attributegrow/img_titleico/content/lab/lab_atk/text_atkArrow")
  self.text_atknext = self:GetControl("RightPanel/bg_equip/RunesAttribute/lab_attributegrow/img_titleico/content/lab/lab_atk/text_atknext")
  self.text_atkimg = self:GetControl("RightPanel/bg_equip/RunesAttribute/lab_attributegrow/img_titleico/content/lab/lab_atk/text_atkimg")
  self.needMaterial = self:GetControl("RightPanel/bg_equip/needMaterial")
  self.sw_Material = self:GetControl("RightPanel/bg_equip/needMaterial/sw_Material")
  self.sl_progress_runesExp = self:GetControl("RightPanel/bg_equip/needMaterial/sl_progress_runesExp")
  self.successRate = self:GetControl("RightPanel/bg_equip/successRate")
  self.sucGreenText = self:GetControl("RightPanel/bg_equip/successRate/bg/sucGreen/sucGreenText")
  self.descBtn = self:GetControl("RightPanel/descBtn")
  self.btn_close = self:GetControl("RightPanel/btn_close")
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.Img_noItem = self:GetControl("RightPanel/Img_noItem")
  self.mat_model = self:GetControl("RightPanel/bg_equip/needMaterial/sl_progress_runesExp/Model")
  self.mat_fill = self:GetControl("RightPanel/bg_equip/needMaterial/sl_progress_runesExp/Fill")
  self.mat_lab_progress = self:GetControl("RightPanel/bg_equip/needMaterial/sl_progress_runesExp/lab_progress")
  self.mat_btn_add = self:GetControl("RightPanel/bg_equip/needMaterial/sl_progress_runesExp/btn_add")
  self.lab_level = self:GetControl("RightPanel/bg_equip/LevelUp/img_RunesFusionlevel")
  self.lab_level2 = self:GetControl("RightPanel/bg_equip/LevelUp/img_RunesFusionlevelnext")
  self.img_attributeArrow = self:GetControl("RightPanel/bg_equip/LevelUp/img_attributeArrow")
end

function Equip_RunesFusionUI:Init()
  self.curRuneType = nil
  self.curRuneEquipPosition = nil
  self.curRuneHolePoint = nil
  self.curRuneStage = 0
  self.curRuneLevel = 0
  self.maxLevel = 0
  self.isCanClickFusionBtn = true
  self.reqRuneID = 0
end

function Equip_RunesFusionUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnRunesMenuCreat(ctr)
  ctr.checkmark = UIControl(ctr.transform, "Checkmark")
  ctr.pageName = UIControl(ctr.transform, "lab_runesName")
  ctr.redPoint = UIControl(ctr.transform, "img_redPoint")
end

local function OnRunesMenuRefresh(ctr, index, data, ui)
  if not data then
    ctr:SetActive(false)
    return
  end
  ctr.data = data
  ctr.pageIndex = index
  ctr:SetOnClick(ui, ui.OnFirstPageToggleValueChanged)
  local pageName = QuickFind.RunesFusionDataMgr():GetFirstPageNameByType(index)
  ctr.pageName:SetText(pageName)
  ctr.checkmark:SetActive(false)
end

local function OnRunesBtnItemCreat(ctr)
  ctr.checkmark = UIControl(ctr.transform, "img_clickeffect")
  ctr.pageName = UIControl(ctr.transform, "lab_name")
  ctr.btn_wild3DItem = UIControl(ctr.transform, "sw_HoleRuneModel/Viewport/holeRuneModel/btn_wild3DItem")
  ctr.redPoint = UIControl(ctr.transform, "img_redPoint")
end

local function OnRunesBtnItemRefresh(ctr, index, data, ui)
  if not data then
    ctr:SetActive(false)
    return
  end
  ctr.pageIndex = index
  ctr:SetOnClick(ui, ui.OnSecondPageToggleValueChanged)
  local pageName = QuickFind.RunesFusionDataMgr():GetSecondPageNameByEquipPosition(index)
  ctr.pageName:SetText(pageName)
  ctr.checkmark:SetActive(false)
  if ctr.holeRuneModel_Container ~= nil then
    for i = 1, ctr.holeRuneModel_Container.transform.childCount - 1 do
      CS.Framework.ObjectEx.Destroy(ctr.holeRuneModel_Container.transform:GetChild(i).gameObject)
    end
  end
  ctr.holeRuneModel_Container = UIContainer(ctr.btn_wild3DItem, ui, ui.OnHolePointModelCreat, ui.OnHolePointModelRefresh)
  ctr.holeRuneModel_Container:DesToryTable()
  ctr.holeRuneModel_Container:SetData(data)
end

function Equip_RunesFusionUI.OnHolePointModelCreat(ctr)
  ctr.checkmark = UIControl(ctr.transform, "img_select")
  ctr.redPoint = UIControl(ctr.transform, "img_redPoint")
end

function Equip_RunesFusionUI.OnHolePointModelRefresh(ctr, index, data, ui)
  if not data then
    ctr:SetActive(false)
    return
  end
  ctr.data = data
  ctr.pageIndex = index
  ctr:SetOnClick(ui, ui.OnThirdPageToggleValueChanged)
  ctr.checkmark:SetActive(false)
  ItemUtility.ShowItemCellByItemId(ctr.data.itemId, 1, ctr, ui, false)
end

function Equip_RunesFusionUI:InitUI()
  self.firstPage_Container = UIContainer(self.RunesMenu, self, OnRunesMenuCreat, OnRunesMenuRefresh)
  self.secondPage_Container = UIContainer(self.runesBtnItem, self, OnRunesBtnItemCreat, OnRunesBtnItemRefresh)
  self.attributesTemplate = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.AttributeUnitTemplate, self)
end

function Equip_RunesFusionUI:OnFirstPageToggleValueChanged(curClickFirstPageControl)
  if not curClickFirstPageControl then
    return
  end
  if self.curFirstPageControl == curClickFirstPageControl then
    local control = curClickFirstPageControl.checkmark.transform.gameObject
    control:SetActive(not control.activeSelf)
    if self.secondPage_Container then
      self.secondPage_Container:SetActive(control.activeSelf)
    end
  else
    local isHaveLastFirstPageControl = self.curFirstPageControl ~= nil
    if isHaveLastFirstPageControl then
      self.curFirstPageControl.checkmark:SetActive(false)
    end
    self.curFirstPageControl = curClickFirstPageControl
    self.curFirstPageControl.checkmark:SetActive(true)
    self.curFirstPageIndex = self.curFirstPageControl.pageIndex
    self.curRuneType = self.curFirstPageControl.pageIndex
    if self.secondPage_Container then
      self.secondPage_Container:SetActive(true)
      self.secondPage_Container:SetParent(self.sw_subMenuViewport.transform)
      local siblingIndex = self.curFirstPageControl.transform:GetSiblingIndex() + 1
      self.secondPage_Container:SetParent(self.firstPage_Container.transform)
      self.secondPage_Container:SetSiblingIndex(siblingIndex)
    end
    self:RefreshSecondPageContainer(curClickFirstPageControl)
    if isHaveLastFirstPageControl and self.curSecondPageControl then
      self.curSecondPageControl = nil
      if #self.secondPage_Container.items > 0 then
        self:OnSecondPageToggleValueChanged(self.secondPage_Container:GetOrCreateItem(1), false)
      end
    end
  end
end

function Equip_RunesFusionUI:RefreshSecondPageContainer(curFirstPageControl)
  if curFirstPageControl == nil or curFirstPageControl.data == nil then
    return
  end
  local secondPageData = curFirstPageControl.data
  self.secondPage_Container:SetDataByPairs(secondPageData)
  LayoutRebuilder.ForceRebuildLayoutImmediate(self.ContentMain.rectTransform)
end

function Equip_RunesFusionUI:OnSecondPageToggleValueChanged(curClickSecondPageControl, isRuneFusionCallBack)
  if not curClickSecondPageControl then
    return
  end
  if self.curSecondPageControl == curClickSecondPageControl then
    return
  else
    if self.curSecondPageControl then
      self.curSecondPageControl.checkmark:SetActive(false)
    end
    self.curSecondPageControl = curClickSecondPageControl
    self.curSecondPageControl.checkmark:SetActive(true)
    self.curRuneEquipPosition = self.curSecondPageControl.pageIndex
    if isRuneFusionCallBack == nil or isRuneFusionCallBack == false then
      self:OnThirdPageToggleValueChanged(self.curSecondPageControl.holeRuneModel_Container:GetOrCreateItem(1), true)
    end
  end
end

function Equip_RunesFusionUI:OnThirdPageToggleValueChanged(curClickThirdPageControl, isResetRightScrollViewPos)
  if not curClickThirdPageControl then
    return
  end
  if self.waitRefreshDataCoroutine then
    Coroutine.Stop(self.waitRefreshDataCoroutine)
    self.waitRefreshDataCoroutine = nil
    self:RefreshData()
    self:OnThirdPageToggleValueChanged(curClickThirdPageControl, true)
    self.isCanClickFusionBtn = true
    return
  end
  if self.curSecondPageControl then
    self.curSecondPageControl.checkmark:SetActive(false)
  end
  for i, v in pairs(self.secondPage_Container.items) do
    if v.pageIndex == curClickThirdPageControl.data.equipIndex then
      self.curSecondPageControl = v
      self.curSecondPageControl.checkmark:SetActive(true)
      self.curRuneEquipPosition = self.curSecondPageControl.pageIndex
    end
  end
  if self.curThirdPageControl == curClickThirdPageControl then
    return
  else
    if self.curThirdPageControl then
      self.curThirdPageControl.checkmark:SetActive(false)
    end
    self.curThirdPageControl = curClickThirdPageControl
    self.curThirdPageControl.checkmark:SetActive(true)
    self.curRuneHolePoint = self.curThirdPageControl.pageIndex
    self.curRuneStage = self.curThirdPageControl.data.cfgTab.runesStage
    self.curRuneLevel = self.curThirdPageControl.data.level
    self.curRuneItemID = self.curThirdPageControl.data.itemId
    self.reqRuneID = self.curThirdPageControl.data.runeId
    self.maxLevel = QuickFind.RunesFusionDataMgr():GetRuneFusionMaxLevel(self.curRuneType, self.curRuneStage)
    if isResetRightScrollViewPos then
      self:ResetRightScrollViewPos()
    end
    self:RefreshRightView()
    self:RuneFusionBtnRedPointRefresh()
  end
end

function Equip_RunesFusionUI:RefreshRightView()
  self.Img_noItem:SetActive(false)
  ItemUtility.ShowItemCellByItemId(self.curRuneItemID, 1, self.btn_Item, self, false)
  self.lb_name:SetText(QuickFind.RunesFusionDataMgr():GetRuneFusionTblName(self.curRuneType, self.curRuneStage, self.curRuneLevel))
  self:RefreshRightLevelAndFusionBtnState()
  self:RefreshRightUpgradePreviw()
  self:RefreshRightUpgradeMaterialView()
end

function Equip_RunesFusionUI:RefreshRightLevelAndFusionBtnState()
  if self.curRuneType == nil or self.curRuneStage == nil or self.curRuneLevel == nil or self.maxLevel == nil then
    return
  end
  local isMaxLevelAndNextIdIsZero = QuickFind.RunesFusionDataMgr():CheckIsMaxLevelAndNextIdIsZero(self.curRuneType, self.curRuneStage, self.curRuneLevel)
  if isMaxLevelAndNextIdIsZero then
    self.lab_level:SetText(true)
    self.img_attributeArrow:SetActive(false)
    self.lab_level2:SetActive(false)
    self.lab_level:SetAnchoredPosition(15, 0)
    self.lab_level:SetText(self.curRuneStage .. "T")
    self.btn_Fusion:SetInteractable(false)
    self.text_Fusion:SetText("\196\144\195\163 \196\145\225\186\167y c\225\186\165p")
  else
    self.lab_level:SetText(true)
    self.img_attributeArrow:SetActive(true)
    self.lab_level2:SetActive(true)
    self.lab_level:SetAnchoredPosition(-7, 0)
    self.lab_level:SetText(self.curRuneLevel >= self.maxLevel and self.curRuneStage .. "T" or "+" .. self.curRuneLevel)
    self.lab_level2:SetText(self.curRuneLevel >= self.maxLevel and self.curRuneStage + 1 .. "T" or "+" .. self.curRuneLevel + 1)
    self.btn_Fusion:SetInteractable(true)
    self.text_Fusion:SetText(self.curRuneLevel >= self.maxLevel and "T\196\131ng b\225\186\173c" or "Gh\195\169p")
  end
end

function Equip_RunesFusionUI:RefreshRightUpgradePreviw()
  local attributeList = QuickFind.RunesFusionDataMgr():GetAttributeList(self.curRuneType, self.curRuneStage, self.curRuneLevel)
  self.attributesTemplate:SetData(attributeList)
end

function Equip_RunesFusionUI:RefreshRightUpgradeMaterialView()
  local itemId, needExp = QuickFind.RunesFusionDataMgr():GetRuneFusionNeedExp(self.curRuneType, self.curRuneStage, self.curRuneLevel)
  local curExp = BagInfoData.GetItemTotalCountByItemId(itemId)
  ItemUtility.ShowItemCellByItemId(itemId, 1, self.mat_model, self, true)
  self.mat_fill:SetFillAmount(curExp / needExp)
  self.mat_lab_progress:SetText(string.GetColorText(curExp, needExp > curExp and ItemQuality2ColorDic[7] or ItemQuality2ColorDic[5]) .. "/" .. needExp)
  self.mat_btn_add.itemId = itemId
end

function Equip_RunesFusionUI:ShowRunesFusionEff(type)
  if type == nil then
    return
  end
  local runeFusionEffName = QuickFind.RunesFusionDataMgr():GetRuneFusionEffNameByType(type)
  if runeFusionEffName == "" then
    return
  end
  if UIManager.IsVisible(UIID.EffectTipUI) then
    EventManager.Dispatch(Event.TipEffect, {
      name = runeFusionEffName,
      effectTime = 1,
      doMoveStartPos = {x = 390, y = -215},
      doMoveTagetPos = {x = 390, y = 65}
    })
  else
    UIManager.Show(UIID.EffectTipUI, {
      name = runeFusionEffName,
      effectTime = 1,
      doMoveStartPos = {x = 390, y = -215},
      doMoveTagetPos = {x = 390, y = 65}
    })
  end
end

function Equip_RunesFusionUI:RegistUIEvents()
  self.btn_Fusion:SetOnClick(self, self.btn_FusionOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.img_Bg2:SetOnClick(self, self.btn_closeOnClick)
  self.btn_Item:SetOnClick(self, self.btn_ItemOnClick)
  self.mat_btn_add:SetOnClick(self, self.Mat_btn_addOnClick)
end

function Equip_RunesFusionUI:btn_FusionOnClick()
  if self.isCanClickFusionBtn == false then
    return
  end
  if QuickFind.RunesFusionDataMgr():CheckCurExpIsCanUpgrade(self.curRuneType, self.curRuneStage, self.curRuneLevel) == false then
    local itemData = ItemUtility.GenerateItemData(self.mat_btn_add.itemId)
    if itemData == nil or itemData.tblItem == nil then
      return
    end
    self.mat_btn_add.itemData = itemData
    UIManager.Show(UIID.ItemTipUI, {
      item = itemData,
      rightOperate = EItemOperateType.Show,
      ctrl = self.mat_btn_add,
      ShowObtain = true
    })
    return
  end
  self:ShowRunesFusionEff(self.curRuneType)
  local runeFuseId = QuickFind.RunesFusionDataMgr():GetRuneFusionTblId(self.curRuneType, self.curRuneStage, self.curRuneLevel)
  networkRequest.ReqRuneFuse(self.reqRuneID, runeFuseId, self.curRuneEquipPosition, self.curRuneHolePoint)
  self.isCanClickFusionBtn = false
end

function Equip_RunesFusionUI:descBtnOnClick(control)
  local lvCfg = QuickFind.RunesFusionDataMgr():GetDescriptionTbl()
  if 0 < #lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Equip_RunesFusionUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_RunesFusionUI)
end

function Equip_RunesFusionUI:btn_ItemOnClick(control)
  local data = {
    itemId = self.curRuneItemID or 0,
    level = self.curRuneLevel or 0
  }
  local itemData = ItemUtility.GenerateItemDataByServerData(data)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function Equip_RunesFusionUI:Mat_btn_addOnClick(control)
  local itemData = ItemUtility.GenerateItemData(control.itemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  control.itemData = itemData
  UIManager.Show(UIID.ItemTipUI, {
    item = control.itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control,
    ShowObtain = true
  })
end

function Equip_RunesFusionUI:OnBagChange(_, msg)
  if self.curFirstPageControl and self.curSecondPageControl and self.curThirdPageControl then
    self:RefreshRightUpgradeMaterialView()
  end
end

function Equip_RunesFusionUI:RuneFusionCallBack()
  if self.waitRefreshDataCoroutine then
    Coroutine.Stop(self.waitRefreshDataCoroutine)
    self.waitRefreshDataCoroutine = nil
  end
  self.waitRefreshDataCoroutine = Coroutine.Start(self.WaitRefreshData, self)
end

function Equip_RunesFusionUI:WaitRefreshData()
  Coroutine.Wait(1)
  if UIManager.IsVisible(UIID.EffectTipUI) then
    EventManager.Dispatch(Event.TipEffect, {
      name = "Eff_UI_fuwenronghechenggong",
      effectTime = 1
    })
  else
    UIManager.Show(UIID.EffectTipUI, {
      name = "Eff_UI_fuwenronghechenggong",
      effectTime = 1
    })
  end
  self:RefreshData()
  Coroutine.Wait(1.5)
  self.isCanClickFusionBtn = true
end

function Equip_RunesFusionUI:RefreshData()
  if self.curFirstPageControl and self.curSecondPageControl and self.curThirdPageControl then
    local firstPageControl = self.curFirstPageControl
    local secondPageControl = self.curSecondPageControl
    local curRuneHolePoint = self.curThirdPageControl.pageIndex
    self.curFirstPageControl = nil
    self.curSecondPageControl = nil
    self.curThirdPageControl = nil
    self.firstPage_Container:SetDataByPairs(QuickFind.RunesFusionDataMgr():GetMeetConditionRunesData())
    self:OnFirstPageToggleValueChanged(firstPageControl)
    self:OnSecondPageToggleValueChanged(secondPageControl, true)
    self:OnThirdPageToggleValueChanged(secondPageControl.holeRuneModel_Container:GetOrCreateItem(curRuneHolePoint), false)
  end
end

function Equip_RunesFusionUI:AllPageRedPointRefresh()
  self.redPointStateTbl = QuickFind.RunesFusionDataMgr():RefreshRedPointData()
  self:FirstPageRedPointRefresh()
  self:SecondPageRedPointRefresh()
  self:ThirdPageRedPointRefresh()
  self:RuneFusionBtnRedPointRefresh()
end

function Equip_RunesFusionUI:FirstPageRedPointRefresh()
  for k, v in pairs(self.firstPage_Container.items) do
    local item = v
    if item.transform.gameObject.activeSelf then
      item.redPoint:SetActive(false)
      if self.redPointStateTbl and item.pageIndex and self.redPointStateTbl[item.pageIndex] then
        item.redPoint:SetActive(self.redPointStateTbl[item.pageIndex].state)
      end
    end
  end
end

function Equip_RunesFusionUI:SecondPageRedPointRefresh()
  for k, v in pairs(self.secondPage_Container.items) do
    local item = v
    if item.transform.gameObject.activeSelf then
      item.redPoint:SetActive(false)
      if self.redPointStateTbl and item.pageIndex and self.curRuneType and self.redPointStateTbl[self.curRuneType] and self.redPointStateTbl[self.curRuneType][item.pageIndex] then
        item.redPoint:SetActive(self.redPointStateTbl[self.curRuneType][item.pageIndex].state)
      end
    end
  end
end

function Equip_RunesFusionUI:ThirdPageRedPointRefresh()
  for k, v in pairs(self.secondPage_Container.items) do
    local secondPageItem = v
    if secondPageItem.transform.gameObject.activeSelf then
      for r, p in pairs(v.holeRuneModel_Container.items) do
        local thirdPageItem = p
        if thirdPageItem.transform.gameObject.activeSelf then
          thirdPageItem.redPoint:SetActive(false)
          local type, equipPosition, holePoint = self.curRuneType, secondPageItem.pageIndex, thirdPageItem.pageIndex
          if type and equipPosition and holePoint and self.redPointStateTbl and self.redPointStateTbl[type] and self.redPointStateTbl[type][equipPosition] and self.redPointStateTbl[type][equipPosition][holePoint] then
            thirdPageItem.redPoint:SetActive(self.redPointStateTbl[type][equipPosition][holePoint].state)
          end
        end
      end
    end
  end
end

function Equip_RunesFusionUI:RuneFusionBtnRedPointRefresh()
  self.btn_FusionRedPoint:SetActive(false)
  if self.curRuneType and self.curRuneEquipPosition and self.curRuneHolePoint and self.redPointStateTbl and self.redPointStateTbl[self.curRuneType] and self.redPointStateTbl[self.curRuneType][self.curRuneEquipPosition][self.curRuneHolePoint] then
    self.btn_FusionRedPoint:SetActive(self.redPointStateTbl[self.curRuneType][self.curRuneEquipPosition][self.curRuneHolePoint].state)
  end
end

function Equip_RunesFusionUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_RunesFusionUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.RuneFusionCallBack, self.RuneFusionCallBack, self)
end

function Equip_RunesFusionUI:Refresh()
  self.Img_noItem:SetActive(true)
  local data = QuickFind.RunesFusionDataMgr():GetMeetConditionRunesData()
  if data == nil or next(data) == nil then
    return
  end
  self.firstPage_Container:SetActive(true)
  self.firstPage_Container:SetDataByPairs(data)
  self:OnFirstPageToggleValueChanged(self.firstPage_Container:GetOrCreateItem(1))
end

function Equip_RunesFusionUI:ResetRightScrollViewPos()
  self.lab_attributegrow.scrollRect.normalizedPosition = Vector2(0, 1)
end

function Equip_RunesFusionUI:OnHide()
  if self.curFirstPageControl then
    self.curFirstPageControl = nil
  end
  if self.curSecondPageControl then
    self.curSecondPageControl = nil
  end
  if self.curThirdPageControl then
    self.curThirdPageControl = nil
  end
  if self.firstPage_Container then
    self.firstPage_Container:SetActive(false)
  end
  if self.secondPage_Container then
    self.secondPage_Container:SetParent(self.sw_subMenuViewport.transform)
    self.secondPage_Container:SetActive(false)
  end
  if self.btn_Item.itemCellData then
    self.btn_Item.itemCellData:RecycleRes()
  end
  if self.mat_model.itemCellData then
    self.mat_model.itemCellData:RecycleRes()
  end
  self:ResetRightScrollViewPos()
  if self.waitRefreshDataCoroutine then
    Coroutine.Stop(self.waitRefreshDataCoroutine)
    self.waitRefreshDataCoroutine = nil
  end
  self.curRuneType = nil
  self.curRuneEquipPosition = nil
  self.curRuneHolePoint = nil
  self.curRuneStage = 0
  self.curRuneLevel = 0
  self.maxLevel = 0
  self.isCanClickFusionBtn = true
  self.reqRuneID = 0
end
