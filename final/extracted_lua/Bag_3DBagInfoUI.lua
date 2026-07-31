Bag_3DBagInfoUI = class(BaseUI)
Bag_3DBagInfoUI.layer = UILayer.Panel
Bag_3DBagInfoUI.orderInLayer = 0
Bag_3DBagInfoUI.hideType = UIHideType.Hide
Bag_3DBagInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_3DBagInfoUI.escClose = UIEscClose.DontClose

function Bag_3DBagInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.img_bgBg = self:GetControl("bg/img_bgBg")
  self.Scroll_BagInfos = self:GetControl("Scroll_BagInfos")
  self.Scroll_bg = self:GetControl("Scroll_BagInfos/Scroll_bg")
  self.go_BagContent = self:GetControl("Scroll_BagInfos/Viewport/go_BagContent")
  self.tile_bg = self:GetControl("Scroll_BagInfos/Viewport/go_BagContent/tile_bg")
  self.img_lock = self:GetControl("Scroll_BagInfos/Viewport/go_BagContent/img_lock")
  self.go_DragCheck = self:GetControl("Scroll_BagInfos/go_DragCheck")
  self.go_ScrollTop = self:GetControl("Scroll_BagInfos/go_DragCheck/go_ScrollTop")
  self.go_ScrollBottom = self:GetControl("Scroll_BagInfos/go_DragCheck/go_ScrollBottom")
  self.go_DragEdge = self:GetControl("Scroll_BagInfos/go_DragCheck/go_DragEdge")
  self.btn_3DItem = self:GetControl("Scroll_BagInfos/btn_3DItem")
  self.Button_SortOut = self:GetControl("Button_SortOut")
  self.btn_Buy = self:GetControl("btn_Buy")
  self.btn_Sell = self:GetControl("btn_Sell")
  self.btn_Storage = self:GetControl("btn_Storage")
  self.btn_Decompose = self:GetControl("btn_Decompose")
  self.btn_Combine = self:GetControl("btn_Combine")
  self.btn_compose = self:GetControl("btn_compose")
  self.Button_CloseBag = self:GetControl("Button_CloseBag")
  self.go_subTransfrom = self:GetControl("go_subTransfrom")
  self.plane_top = self:GetControl("plane_top")
  self.plane_bottom = self:GetControl("plane_bottom")
end

function Bag_3DBagInfoUI:OnPreLoad()
  self:Init()
  self:OnCreate()
end

function Bag_3DBagInfoUI:Init()
  if self.inited then
    return
  end
  self.inited = true
  self.EquipWearff = {}
  self.effectObj = nil
  self.selectIndexTbl = {}
  self.curPanelType = UIID.NewBagInfoUI
  self.curChildPanelType = -1
  self.canSellRefresh = true
  self:AudioTypeInit()
  self.forgeNavShowRule = {
    [1] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Equip_OverlapUI, self) then
        self.curPanelType = UIID.Equip_OverlapUI
        local TotalItems = BagInfoData.EquipSuitSort(BagInfoData.TotalItems)
        self:ShowBagInOverlap(TotalItems, content)
        return true
      end
    end,
    [2] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Equip_Decompose, self) then
        self.curPanelType = UIID.Equip_Decompose
        local TotalDecomposeItems = BagInfoData.EquipDecomposeSort(BagInfoData.TotalItems)
        self:ShowBagDecompose(TotalDecomposeItems, content)
        return true
      end
    end,
    [3] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Equip_Transfer, self) then
        self.curPanelType = UIID.Equip_Transfer
        self.curChildPanelType = self.args.OpenType
        local TotalItems = BagInfoData.TotalItems
        if self.args.OpenType == TransferOpenType.Intensify then
          self:ShowBagTransferInIntensify(TotalItems, content)
        elseif self.args.OpenType == TransferOpenType.Zhuijia then
          self:ShowBagTransferInZhuiJia(TotalItems, content)
        elseif self.args.OpenType == TransferOpenType.IntensifyAndAdd then
          self:ShowBagTransfer(TotalItems, content)
        end
        return true
      end
    end,
    [4] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Equip_Lucky, self) then
        self.curPanelType = UIID.Equip_Lucky
        self:ShowBagLuckyIntensify(BagInfoData.TotalItems, content)
        return true
      end
    end,
    [5] = function(content)
      if UIManager.IsVisible(UIID.Equip_ZhuijiaUI) then
        self.curPanelType = UIID.Equip_ZhuijiaUI
        self:ShowBagInZhuiJia(BagInfoData.TotalItems, content)
        return true
      end
    end,
    [6] = function(content)
      if UIManager.IsVisible(UIID.Equip_OrnamentsUI) then
        self.curPanelType = UIID.Equip_OrnamentsUI
        self:ShowBagOrnaments(BagInfoData.TotalItems, content)
        return true
      end
    end,
    [7] = function(content)
      if UIManager.IsVisible(UIID.Equip_StoneUI) then
        self.curPanelType = UIID.Equip_StoneUI
        self:ShowBagStone(nil, BagInfoData.TotalItems, content)
        return true
      end
    end,
    [8] = function(content)
      if UIManager.IsVisible(UIID.Equip_XiLianUI) then
        self.curPanelType = UIID.Equip_XiLianUI
        self:ShowXiLianEquip(BagInfoData.TotalItems, content)
        return true
      end
    end,
    [9] = function(content)
      if UIManager.IsVisible(UIID.Equip_HolySpiritLeftUI) then
        self.curPanelType = UIID.Equip_HolySpiritLeftUI
        self:ShowHolySpiritEquip(BagInfoData.TotalItems, content)
        return true
      end
    end,
    [10] = function(content)
      if UIManager.IsVisible(UIID.Equip_RunesDecomposeUI) then
        self.curPanelType = UIID.Equip_RunesDecomposeUI
        self:ShowRuneItems(BagInfoData.TotalItems, content)
        return true
      end
    end,
    [11] = function(content)
      self.curPanelType = UIID.Equip_IntensifyUI
      local TotalItems = BagInfoData.EquipIntensifySort(BagInfoData.TotalItems)
      self:ShowBagIntensify(TotalItems, content)
      return true
    end
  }
  self.setSkillShowRue = {
    [1] = function(content)
      self.curPanelType = UIID.Skill_SetSkillUI
      local totalConsumables = BagInfoData.EquipConsumablesSort(BagInfoData.TotalItems)
      self:ShowBagConsumables(totalConsumables, content)
      return true
    end
  }
  self.bagInfoShowRule = {
    [1] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Equip_ForgeNavUi, self) then
        return self:JudgeShowRue(self.forgeNavShowRule, content)
      end
    end,
    [2] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Skill_SetSkillUI, self) then
        return self:JudgeShowRue(self.setSkillShowRue, content)
      end
    end,
    [3] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Equip_HolySpiritLeftUI, self) then
        return self:JudgeShowRue(self.forgeNavShowRule, content)
      end
    end,
    [4] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Equip_RunesDecomposeUI, self) then
        return self:JudgeShowRue(self.forgeNavShowRule, content)
      end
    end,
    [5] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.BagSellInfoUI, self) then
        self.curPanelType = UIID.BagSellInfoUI
        local recycleItems = BagInfoData.RecycleItems(BagInfoData.TotalItems)
        self:ShowBagRecycle(recycleItems, content)
      else
        self.curPanelType = UIID.NewBagInfoUI
        self:RefreshBagInfoCell(content)
      end
      return true
    end
  }
end

function Bag_3DBagInfoUI:JudgeShowRue(rules, content)
  self.forgeCellData = nil
  local index = 1
  local count = #rules
  while index <= count do
    local res = rules[index](content)
    if res then
      return true
    end
    index = index + 1
  end
  return false
end

function Bag_3DBagInfoUI:OnCreate()
  if self.created then
    return
  end
  self.created = true
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self:InitTipsParams()
end

function Bag_3DBagInfoUI:InitTipsParams()
  if self.img_bgBg and not IsNil(self.img_bgBg.gameObject) then
    self.bgWidth, self.bgHeight = self.img_bgBg:GetSizeDelta()
  end
end

function Bag_3DBagInfoUI:InitUI()
  local CellDataTbl = {
    curCellCount = BagInfoData.curBagCellCount,
    totalCellCount = BagInfoData.bagCellCount,
    colCount = BagInfoData.colCount
  }
  self.dragTbl = UIDragCellContainer(self, self.PutIn, self.Button_ShowUseOperation, CellDataTbl, false, self.SetDataState)
  self.ArrowheadTbl = {
    GreenArrow = {},
    YellowArrow = {}
  }
end

function Bag_3DBagInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:CheckSellEffect()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {2140001, 2230001})
end

function Bag_3DBagInfoUI:CheckSellEffect()
  if PlayerControlForceData.autoRecycleState then
    if self.effectObj then
      self.effectObj:SetActive(false)
    end
  else
    if not self.effectObj then
      self.effectObj = UIEffectUtility.SetUIEffect("Eff_UI_annuikuang04", self.btn_Sell, true, Vector3(0.96, 0.65, 0))
      self.effectObj:SetActive(false)
    end
    if BagInfoData.bagFull and not UIManager.IsVisibleOrCorrelation(UIID.BagSellInfoUI, self) then
      self.effectObj:SetActive(true)
    else
      self.effectObj:SetActive(false)
    end
  end
end

function Bag_3DBagInfoUI:OnHide()
  if self.effectObj then
    self.effectObj:SetActive(false)
  end
  if self.selectCol then
    Timer.Stop(self.selectCol)
    self.selectCol = nil
  end
  if #self.EquipWearff ~= 0 then
    for i, v in pairs(self.EquipWearff) do
      v:Destroy()
    end
    self.EquipWearff = {}
  end
  if self.ArrowrecTimer then
    Timer.Stop(self.ArrowrecTimer)
    self.ArrowrecTimer = nil
  end
  self.dragTbl:RecycleRes()
  self.selectIndexTbl = {}
  BagInfoData.EquipItemIds = {}
end

function Bag_3DBagInfoUI:OnDestroy()
  self.dragTbl:Destroy()
  self.dragTbl = nil
  self.created = false
  self.inited = false
  self.curPanelType = UIID.NewBagInfoUI
  self.curChildPanelType = -1
end

function Bag_3DBagInfoUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.Button_SortOut:SetOnClick(self, self.Button_SortOutOnClick)
  self.btn_Sell:SetOnClick(self, self.btn_SellOnClick)
  self.btn_Buy:SetOnClick(self, self.btn_BuyOnClick)
  self.Button_CloseBag:SetOnClick(self, self.Button_CloseBagOnClick)
  self.btn_Storage:SetOnClick(self, self.Button_StorageOnClick)
  self.btn_compose:SetOnClick(self, self.Button_ComposeOnClick)
  self.img_lock:SetOnClick(self, self.OnClickLock)
  self.btn_Decompose:SetOnClick(self, self.BtnDecomposeOnClick)
  self.btn_Combine:SetOnClick(self, self.BtnCombineOnClick)
end

function Bag_3DBagInfoUI:BottomBtnRefresh()
  if UIManager.IsVisible(UIID.Equip_StoneUI) then
    self.btn_Decompose:SetActive(true)
    self.btn_Combine:SetActive(true)
    self.Button_SortOut:SetActive(false)
    self.btn_Sell:SetActive(false)
    self.btn_Buy:SetActive(false)
    self.btn_Storage:SetActive(false)
  else
    self.btn_Decompose:SetActive(false)
    self.btn_Combine:SetActive(false)
    self.Button_SortOut:SetActive(true)
    self.btn_Sell:SetActive(true)
    self.btn_Buy:SetActive(true)
    self.btn_Storage:SetActive(true)
  end
end

function Bag_3DBagInfoUI:BtnDecomposeOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Equip_ForgeNavUi, {
    uiID = UIID.Equip_Decompose
  })
end

function Bag_3DBagInfoUI:BtnCombineOnClick()
  if FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.Combine_Carry, true) == false then
    return
  end
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Item_CombineUI, {
    npcConfigID = PlayerControlForceData.composeJumpParam[2],
    combineId = 106001
  })
end

local function PromptOK(okArgs)
  if BagInfoData.GetItemTotalCountByItemId(okArgs.itemData.tblItem.id) > 0 then
    local itemDatas = BagInfoData.GetItemTblByConfigId(okArgs.itemData.tblItem.id)
    local itemData = itemDatas[1]
    if itemData then
      local useItemTbl = {
        useCount = 1,
        useItemId = itemData.id,
        configId = itemData.itemId,
        useParam = itemData.tblItem.useParam,
        useParamExtend = itemData.tblItem.useParamExtend,
        params = nil
      }
      ItemUtility.UseItem(useItemTbl)
    end
  elseif 0 < BagInfoData.GetItemTotalCountByItemId(okArgs.itemData2.tblItem.id) then
    local itemDatas2 = BagInfoData.GetItemTblByConfigId(okArgs.itemData2.tblItem.id)
    local itemData2 = itemDatas2[1]
    if itemData2 then
      local useItemTb2 = {
        useCount = 1,
        useItemId = itemData2.id,
        configId = itemData2.itemId,
        useParam = itemData2.tblItem.useParam,
        useParamExtend = itemData2.tblItem.useParamExtend,
        params = nil
      }
      ItemUtility.UseItem(useItemTb2)
    end
  else
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetUIWord("WarehouseTips_2"))
  end
end

function Bag_3DBagInfoUI:OnClickLock(control)
  local itemData = ItemUtility.GenerateItemData(6000720)
  itemData.count = BagInfoData.GetItemTotalCountByItemId(6000720)
  local itemData2 = ItemUtility.GenerateItemData(6000721)
  itemData2.count = BagInfoData.GetItemTotalCountByItemId(6000721)
  local str = string.format("C\195\179 ti\195\170u hao %s m\225\187\159 r\225\187\153ng t\195\186i kh\195\180ng?", string.GetColorText(itemData.tblItem.name, ItemQuality2ColorDic[EItemColorEnum.green]))
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = str,
    Item = itemData,
    Item2 = itemData2,
    okText = "",
    ok = PromptOK,
    okArgs = {itemData = itemData, itemData2 = itemData2}
  })
end

function Bag_3DBagInfoUI:btn_closeBgOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(self.name)
end

function Bag_3DBagInfoUI:Button_CloseBagOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  if self.args and self.args.OnClose then
    self.args.OnClose(control)
  else
    UIManager.Hide(self.name)
  end
end

function Bag_3DBagInfoUI:Button_SortOutOnClick(control)
  if UIManager.IsVisible(UIID.Equip_ForgeNavUi) then
    FloatingWordUtility.QuickMsg("\196\144ang r\195\168n, kh\195\180ng th\225\187\131 d\195\185ng")
    return
  end
  if not UIManager.IsVisibleOrCorrelation(UIID.BagSellInfoUI, self) then
    NetManager.Send(BagMessage.ReqBagSort)
  end
  if #self.EquipWearff ~= 0 then
    for i, v in pairs(self.EquipWearff) do
      v:Destroy()
    end
    self.EquipWearff = {}
  end
end

function Bag_3DBagInfoUI:Button_StorageOnClick(control)
  if UIManager.IsVisible(UIID.Equip_ForgeNavUi) then
    FloatingWordUtility.QuickMsg("\196\144ang r\195\168n, kh\195\180ng th\225\187\131 d\195\185ng")
    return
  end
  local openDir = PlayerControlForceData.StorageIsOpen()
  if openDir then
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.BagWarehouseUI)
    self:ShowBag()
  else
    TipUtility.QuickShowPrompt({
      id = PromptWordType.TransferWarHouseNpcPrompt
    })
  end
end

function Bag_3DBagInfoUI:Button_ComposeOnClick(control)
  local openDir = PlayerControlForceData.ComposeIsOpen()
  if openDir then
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Item_CombineUI, {
      npcConfigID = PlayerControlForceData.composeJumpParam[2]
    })
    self:ShowBag()
  else
    TipUtility.ShowComposeOpenPrompt()
  end
end

function Bag_3DBagInfoUI:btn_SellOnClick(control)
  if FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.Recycle_Bag, true) == false then
    return
  end
  self:OpenBagSellInfoUI()
end

function Bag_3DBagInfoUI:OpenBagSellInfoUI()
  if UIManager.IsVisible(UIID.Equip_ForgeNavUi) then
    FloatingWordUtility.QuickMsg("\196\144ang r\195\168n, kh\195\180ng th\225\187\131 d\195\185ng")
    return
  end
  if not UIManager.IsVisibleOrCorrelation(UIID.BagSellInfoUI, self) then
    if self.effectObj then
      self.effectObj:SetActive(false)
    end
    local openDir = PlayerControlForceData.BagSellIsOpen()
    if openDir then
      self.canSellRefresh = false
      UIManager.Show(UIID.BagSellInfoUI)
      self:Refresh()
    end
  end
end

function Bag_3DBagInfoUI:btn_BuyOnClick(control)
  if UIManager.IsVisible(UIID.Equip_ForgeNavUi) then
    FloatingWordUtility.QuickMsg("\196\144ang r\195\168n, kh\195\180ng th\225\187\131 d\195\185ng")
    return
  end
  local openDir = PlayerControlForceData.BagShopIsOpen()
  if openDir then
    UIManager.Show(UIID.BagShopInfoUI)
    self:ShowBag()
  else
    TipUtility.QuickShowPrompt({
      id = PromptWordType.TransferShopNpcPrompt
    })
  end
end

function Bag_3DBagInfoUI:PutIn(itemData, fromUiName, index)
  if fromUiName == self.name then
    NetManager.Send(BagMessage.ReqMoveItem, {
      itemId = itemData.id,
      bagGridIndex = index,
      type = EDragUIType.Bag
    })
  elseif fromUiName == UIID.BagWarehouseUI then
    NetManager.Send(BagMessage.ReqTakeOutFromStorage, {
      id = itemData.id,
      bagGridIndex = index
    })
  end
end

function Bag_3DBagInfoUI:DoubleClick(itemData)
  local rightOperate
  local queryType = CheckUseItemWay.AddPointTip
  if UIManager.IsVisibleOrCorrelation(UIID.BagWarehouseUI, self) then
    rightOperate = EItemOperateType.Deposit
    queryType = CheckUseItemWay.NotAddPoint
  end
  local canUse, state = RoleEquipUtility.CheckUseItem(itemData, queryType)
  rightOperate = rightOperate or itemData.tblItem.rightOperate
  if rightOperate == EItemOperateType.Use then
    if not canUse then
      return
    end
    local useItemTbl = {
      useCount = 1,
      useItemId = itemData.id,
      configId = itemData.itemId,
      useParam = itemData.tblItem.useParam,
      useParamExtend = itemData.tblItem.useParamExtend,
      itemInfo = itemData,
      params = nil
    }
    ItemUtility.UseItem(useItemTbl)
  elseif rightOperate == EItemOperateType.Wear then
    if state == ItemUseCheckState.levelUnEnough or state == ItemUseCheckState.careerUnEnough or state == ItemUseCheckState.transferUnEnough or state == ItemUseCheckState.attrPointUnEnough then
      local tipStr = "ngh\225\187\129 ho\225\186\183c c\225\186\165p kh\195\180ng ph\195\185 h\225\187\163p"
      FloatingWordUtility.QuickMsg(tipStr)
      return
    elseif state == ItemUseCheckState.attrPointEnough then
      return
    end
    RoleEquipUtility.OnWearEquip(itemData)
  elseif rightOperate == EItemOperateType.Deposit then
    NetManager.Send(BagMessage.ReqPutIntoStorage, {
      id = itemData.id,
      bagGridIndex = -1
    })
  end
end

function Bag_3DBagInfoUI:JudgeShowTipsPanel(itemData)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemData.itemId)
  local useParam = string.split(itemConfig.useParam, "#")
  return useParam[1]
end

function Bag_3DBagInfoUI:JudgeCanSelectDecomposeProp(itemData, customLimitCount)
  local propDescription = {}
  for i, v in pairs(BagInfoData.DecomposeItemTbl) do
    if propDescription[v.itemId] == nil then
      propDescription[v.itemId] = {}
    end
  end
  local propCount = table.count(propDescription)
  local limitCount = customLimitCount or ForgeData.limitDecomposeCount
  if propCount >= limitCount then
    if propDescription[itemData.itemId] then
      return true
    else
      return false
    end
  else
    return true
  end
end

function Bag_3DBagInfoUI:Button_ShowUseOperation(control, _, isDouble)
  if control.data.lock then
    local tipStr = "Ch\198\176a m\225\187\159 kh\195\179a \195\180"
    FloatingWordUtility.QuickMsg(tipStr)
    return
  end
  if control.data.itemData == nil then
    return
  end
  if not control.data.enabled then
    return
  end
  local itemCellData = control.data:GetData()
  local itemData = itemCellData.itemData
  if UIManager.IsVisibleOrCorrelation(UIID.Skill_SetSkillUI, self) then
    EventManager.Dispatch(Event.Skill_Pan_SetItem, itemData.itemId)
  elseif UIManager.IsVisibleOrCorrelation(UIID.BagSellInfoUI, self) then
    itemCellData.selected = not itemCellData.selected
    ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
    local recycleTbl = {
      bagIndex = itemData.bagGridIndex,
      id = itemData.id,
      count = itemData.count,
      sell = itemData.tblItem.sell,
      bind = itemData.bind,
      intensify = itemData.serverInfo.intensify,
      additional = itemData.serverInfo.additional
    }
    BagInfoData.SelectRecycle(recycleTbl, itemCellData.selected)
    BagInfoData.RecycleCancel[itemData.bagGridIndex] = not itemCellData.selected
    self:ShowTipsContrast(control, itemCellData.itemData)
    EventManager.Dispatch(Event.Bag_SellItemClick)
  elseif UIManager.IsVisibleOrCorrelation(UIID.Equip_Decompose, self) then
    if not self:JudgeCanSelectDecomposeProp(itemData) and not itemCellData.selected then
      local tipStr = LocalizationUtility.GetContentByKey("DecomposeError_1")
      FloatingWordUtility.QuickMsg(tipStr)
      return
    else
      itemCellData.selected = not itemCellData.selected
      ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
      self:ShowTipsContrast(control, itemCellData.itemData)
      BagInfoData.RefreshDecomposeItemData(control, itemCellData.selected)
      EventManager.Dispatch(Event.Bag_DecomposeItemClick, control)
    end
  elseif UIManager.IsVisibleOrCorrelation(UIID.Equip_RunesDecomposeUI, self) then
    local mapList = TableParse:SplitStringToMapList(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2800023), "&", "#")
    local customLimitCount = tonumber(mapList[itemData.tblItem.type] or 15)
    if not self:JudgeCanSelectDecomposeProp(itemData, customLimitCount) and not itemCellData.selected then
      FloatingWordUtility.QuickMsg(string.format("M\225\187\151i l\225\186\167n ch\225\187\137 \196\145\198\176\225\187\163c t\195\161ch t\225\187\145i \196\145a %d lo\225\186\161i \196\145\225\186\161o c\225\187\165 Ph\195\185 V\196\131n", customLimitCount))
      return
    else
      itemCellData.selected = not itemCellData.selected
      ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
      BagInfoData.RefreshDecomposeItemData(control, itemCellData.selected)
      EventManager.Dispatch(Event.Bag_DecomposeItemClick, control)
    end
  elseif UIManager.IsVisibleOrCorrelation(UIID.Equip_OverlapUI, self) then
    if isDouble then
      local itemCellData = control.data:GetData()
      if ForgeData.EquipOverlapMain == nil then
        ForgeData.EquipOverlapMain = control.data.itemData
      elseif ForgeData.EquipOverlapSide == nil then
        ForgeData.EquipOverlapSide = control.data.itemData
      elseif ForgeData.EquipOverlapSide ~= nil then
        ForgeData.EquipOverlapSide = control.data.itemData
      end
      EventManager.Dispatch(Event.SelectedForgeEquip, {
        control.data.itemData,
        control.data.itemData.bagGridIndex
      })
      self:ShowBagInOverlap(BagInfoData.TotalItems)
    else
      if self.forgeCellData then
        self.forgeCellData.selected = false
        ItemUtility.ShowSelectImg(self.dragTbl, self.forgeCellData)
      end
      local itemCellData = control.data:GetData()
      self.forgeCellData = itemCellData
      itemCellData.selected = true
      ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
      UIManager.Show(UIID.ItemTipUI, {
        item = control.data.itemData,
        rightOperate = EItemOperateType.AddEquip
      })
    end
  else
    if isDouble then
      self:DoubleClick(itemData)
    else
      local state
      if UIManager.IsVisibleOrCorrelation(UIID.BagWarehouseUI, self) then
        state = EItemOperateType.Deposit
      end
      UIManager.Show(UIID.ItemTipUI, {
        item = itemData,
        rightOperate = state,
        ctrl = control,
        openType = TipsOpenType.BagOpen,
        contrast = true
      })
    end
    if control.data.itemData ~= nil and control.data.itemData.tblItem.type == EItemType.Equipe then
      local itemCellData = control.data:GetData()
      if not itemCellData.isClicked and itemCellData.isNewGet then
        local itemCtrl = self.dragTbl:GetCtrByCellData(itemCellData)
        itemCellData.isClicked = true
        itemCellData.isNewGet = false
        itemCtrl.img_new:SetActive(false)
      end
    end
  end
end

function Bag_3DBagInfoUI:ShowTipsContrast(control, itemData)
  if not itemData then
    return
  end
  if UIManager.IsVisible(UIID.ItemTipUI) then
    UIManager.SwitchVisible(UIID.ItemTipUI)
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control,
    contrast = false,
    tipsPosValue = self:CalculationTipsPos(),
    SetLayerCallBack = function()
      ItemUtility.TrySetTipsLayer(UILayer.Panel)
    end
  })
end

function Bag_3DBagInfoUI:CalculationTipsPos()
  if self.bgWidth == nil or self.bgHeight == nil then
    return nil
  end
  local pos = self.root.transform.localPosition
  pos.x = -self.bgWidth / 2
  pos.y = pos.y + self.bgHeight / 2
  pos.z = 0
  return self.root.transform:TransformPoint(pos)
end

function Bag_3DBagInfoUI:Button_ShowEquipIntensify(control)
  if control.data.itemData == nil then
    print("\228\189\160\231\130\185\229\135\187\228\186\134\231\169\186\230\160\188\229\173\144")
    return
  end
  if not control.data.enabled and not control.data.selected then
    UIManager.Show(UIID.PromptTipUI, {
      tile = "Nh\225\186\175c nh\225\187\159",
      textContent = string.GetColorText("Trang B\225\187\139 n\195\160y kh\195\180ng th\225\187\131 thao t\195\161c", "#FFFFFFFF")
    })
    return
  end
  if UIManager.IsVisibleOrCorrelation(UIID.Equip_Transfer, self) then
    if ForgeData.EquipTransferMain == nil then
      ForgeData.EquipTransferMain = control.data.itemData
    elseif ForgeData.EquipTransferSecond == nil then
      ForgeData.EquipTransferSecond = control.data.itemData
    end
    EventManager.Dispatch(Event.SelectedForgeEquip, {
      control.data.itemData,
      control.data.itemData.bagGridIndex
    })
    self:ShowBagTransfer(BagInfoData.TotalItems)
  elseif UIManager.IsVisibleOrCorrelation(UIID.Equip_HolySpiritLeftUI, self) then
    UIManager.Show(UIID.ItemTipUI, {
      item = control.data.itemData,
      rightOperate = EItemOperateType.Wear,
      isPutOn = true
    })
  elseif UIManager.IsVisibleOrCorrelation(UIID.Equip_StoneUI, self) then
    if self.forgeCellData then
      self.forgeCellData.selected = false
      ItemUtility.ShowSelectImg(self.dragTbl, self.forgeCellData)
    end
    local itemCellData = control.data:GetData()
    self.forgeCellData = itemCellData
    itemCellData.selected = true
    ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
    UIManager.Show(UIID.ItemTipUI, {
      item = control.data.itemData,
      rightOperate = EItemOperateType.AddEquip,
      isPutOn = true
    })
  else
    if self.forgeCellData then
      self.forgeCellData.selected = false
      ItemUtility.ShowSelectImg(self.dragTbl, self.forgeCellData)
    end
    local itemCellData = control.data:GetData()
    self.forgeCellData = itemCellData
    itemCellData.selected = true
    ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
    EventManager.Dispatch(Event.SelectedForgeEquip, {
      control.data.itemData,
      control.data.itemData.bagGridIndex
    })
  end
end

function Bag_3DBagInfoUI:Button_ShowEquipXiLian(control)
  if control.data.lock then
    local tipStr = "Ch\198\176a m\225\187\159 kh\195\179a \195\180"
    FloatingWordUtility.QuickMsg(tipStr)
    return
  end
  if control.data.itemData == nil then
    return
  end
  if not control.data.enabled then
    return
  end
  if self.xiLianCellData then
    self.xiLianCellData.selected = false
    ItemUtility.ShowSelectImg(self.dragTbl, self.xiLianCellData)
  end
  self.xiLianCellData = control.data:GetData()
  local itemData = self.xiLianCellData.itemData
  self.xiLianCellData.selected = true
  ItemUtility.ShowSelectImg(self.dragTbl, self.xiLianCellData)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    itemCellData = self.xiLianCellData,
    rightOperate = EItemOperateType.XiLianEquip
  })
end

function Bag_3DBagInfoUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.Bag_ResBagInfo, self.ResBagInfo, self)
  self:RegistEvent(Event.Bag_ResItemInfoUpdateMessage, self.ResItemInfoUpdateMessage, self)
  self:RegistEvent(Event.Bag_FullState, self.OnBagFullState, self)
  self:RegistEvent(Event.Bag_SellInfoClose, self.OnSellInfoClose, self)
  self:RegistEvent(Event.Bag_RefreshSellSelect, self.OnRefreshSellSelect, self)
  self:RegistEvent(Event.Bag_DecomposeInfoClose, self.Bag_DecomposeInfoClose, self)
  self:RegistEvent(Event.Bag_RefreshShowTransfer, self.Bag_RefreshShowTransfer, self)
  self:RegistEvent(Event.Bag_RefreshShowHolySpirit, self.Bag_RefreshShowHolySpirit, self)
  self:RegistEvent(Event.Bag_RefreshShowOverlap, self.Bag_RefreshShowOverlap, self)
  self:RegistEvent(Event.Bag_TransferClose, self.Bag_TransferClose, self)
  self:RegistEvent(Event.Equip_ResEquipChange, self.RefreshBag, self)
  self:RegistEvent(Event.Role_MyLvChanged, self.RefreshBag, self)
  self:RegistEvent(Event.Bag_CancelDecomposeSelect, self.CancelSelectBagInfoCell, self)
  self:RegistEvent(Event.GetGuideParent, self.GetGuideParent, self)
  self:RegistEvent(Event.EquipTipsGuideParent, self.EquipTipsGuideEff, self)
  self:RegistEvent(Event.Bag_RefreshShowXiLian, self.Bag_RefreshShowXiLian, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.SetBuyDrugGuide, self)
  self:RegistEvent(Event.Bag_ResUseItem, self.SetBuyDrugGuide, self)
  self:RegistEvent(Event.Bag_GridUpdate, self.OnGridUpdate, self)
  self:RegistEvent(Event.Equip_ChangeEquipSelect, self.ChangeEquipSelect, self)
  self:RegistEvent(Event.Equip_ForgeStone, self.ShowBagStone, self)
  self:RegistEvent(Event.EquipInfoChange, self.RefreshBag, self)
end

function Bag_3DBagInfoUI:DoRefreshSellSelect()
  if not self.canSellRefresh then
    return
  end
  local dataInfos = self.dragTbl:GetCtrInfos()
  self.selectIndexTbl = {}
  for index, itemCellData in pairs(dataInfos) do
    if itemCellData.itemData then
      local bagGridIndex = itemCellData.itemData.bagGridIndex
      if BagInfoData.RecycleItemTbl[bagGridIndex] then
        self.selectIndexTbl[index] = index
        itemCellData.selected = true
        ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
      else
        itemCellData.selected = false
        ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
      end
    end
  end
end

function Bag_3DBagInfoUI:OnRefreshSellSelect()
  if self.selectCol then
    Timer.Stop(self.DoRefreshSellSelect)
    self.selectCol = nil
  end
  self.selectCol = Timer.Start(0.16, self.DoRefreshSellSelect, self)
end

function Bag_3DBagInfoUI:Refresh()
  self:BottomBtnRefresh()
  self:OnRefresh()
  self:SetBuyDrugGuide()
end

function Bag_3DBagInfoUI:ResBagInfo()
  self:JudgeShowRue(self.bagInfoShowRule)
  AudioManager.PlayMusicClipById(3002)
end

function Bag_3DBagInfoUI:OnRefresh()
  self:JudgeShowRue(self.bagInfoShowRule)
end

function Bag_3DBagInfoUI:ShowBag()
  self:JudgeShowRue(self.bagInfoShowRule)
end

function Bag_3DBagInfoUI:OnBagChange(_, msg)
  if msg and msg.logType == BagChangeTypeEnum.Recycle then
    return
  end
  if msg and msg.removeItems then
    for _, itemData in ipairs(msg.removeItems) do
      if BagInfoData.IsCanShowInBag(self.curPanelType, itemData, self.curChildPanelType) then
        self.dragTbl:RemoveData(itemData)
        if table.contains(self.audioTypeTab, itemData.itemId) then
          AudioManager.PlayMusicClipById(3004)
        else
          AudioManager.PlayMusicClipById(3002)
        end
      end
    end
  end
  if msg and msg.showItems then
    for _, itemInfo in pairs(msg.showItems) do
      if BagInfoData.IsCanShowInBag(self.curPanelType, itemInfo, self.curChildPanelType) then
        self.dragTbl:AddItemInfo(itemInfo, true)
        if table.contains(self.audioTypeTab, itemInfo.itemId) then
          AudioManager.PlayMusicClipById(3004)
        else
          AudioManager.PlayMusicClipById(3002)
        end
      end
    end
  end
  if msg then
    if msg.removeItems then
      for i, v in pairs(msg.removeItems) do
        if v.tblItem.rightOperate == EItemOperateType.Wear then
          local state = RoleEquipUtility.CanUpFight(v)
          if state == EquipUpState.CanWearUpFight or state == EquipUpState.CantWearUpFight then
            self:ArrowheadFun()
            return
          end
        end
      end
    end
    if msg.showItemTbl then
      for i, v in pairs(msg.showItemTbl) do
        if v.tblItem.rightOperate == EItemOperateType.Wear then
          local state = RoleEquipUtility.CanUpFight(v)
          if state == EquipUpState.CanWearUpFight or state == EquipUpState.CantWearUpFight then
            self:ArrowheadFun()
            return
          end
        end
      end
    end
  end
end

function Bag_3DBagInfoUI:RefreshBag(_)
  self.dragTbl:RefreshShowGrrowUI()
  self:ArrowheadFun()
end

function Bag_3DBagInfoUI:ResItemInfoUpdateMessage(id, msg)
  if msg and msg.type == EDragUIType.Bag then
    self.dragTbl:MoveItemInfo(msg.items)
    if table.contains(self.audioTypeTab, msg.items.itemId) then
      AudioManager.PlayMusicClipById(3004)
    else
      AudioManager.PlayMusicClipById(3002)
    end
  end
end

function Bag_3DBagInfoUI:OnBagFullState()
  self:CheckSellEffect()
end

function Bag_3DBagInfoUI:OnSellInfoClose(id, msg)
  self:Refresh()
end

function Bag_3DBagInfoUI:Bag_DecomposeInfoClose()
  self:Refresh()
end

function Bag_3DBagInfoUI:Bag_RefreshShowTransfer()
  self:Refresh()
end

function Bag_3DBagInfoUI:Bag_RefreshShowHolySpirit()
  self:Refresh()
end

function Bag_3DBagInfoUI:Bag_TransferClose()
  self:Refresh()
end

function Bag_3DBagInfoUI:Bag_RefreshShowOverlap()
  self:Refresh()
end

function Bag_3DBagInfoUI:Bag_RefreshShowXiLian()
  self:Refresh()
end

function Bag_3DBagInfoUI:CancelSelectBagInfoCell(_, itemInfo)
  local infos = self.dragTbl:GetCtrInfos()
  for _, data in pairs(infos) do
    if data.itemData and itemInfo == data.itemData then
      local itemCellData = data:GetData()
      itemCellData.selected = false
      ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
    end
  end
end

local function IsHaveDifferentExcellence(itemInfo)
  local secondItemInfo
  if itemInfo.wingAttr then
    secondItemInfo = table.metatableCopy(nil, itemInfo.wingAttr)
  else
    secondItemInfo = table.metatableCopy(nil, itemInfo.excellence)
  end
  if ForgeData.EquipOverlapMain ~= nil then
    for k, v in pairs(ForgeData.EquipOverlapMain.excellence) do
      for kk, vv in pairs(secondItemInfo) do
        if v == vv then
          table.remove(secondItemInfo, kk)
        end
      end
    end
  end
  return RoleEquipUtility.GetEquipExcellence(secondItemInfo, itemInfo.tblEquip)
end

function Bag_3DBagInfoUI:ShowBagInOverlap(TotalItems)
  local ExcellenceSuitBagItems = {}
  local itemStatistics = {}
  if ViewData.meData.equipsData.Data and table.count(ViewData.meData.equipsData.Data) > 0 then
    for k, v in pairs(ViewData.meData.equipsData.Data) do
      if RoleEquipUtility.CheckItemCanOverlap(v) then
        if itemStatistics[v.tblEquip.overlap] == nil then
          itemStatistics[v.tblEquip.overlap] = {}
        end
        table.insert(itemStatistics[v.tblEquip.overlap], v)
      end
    end
  end
  for k, v in pairs(TotalItems) do
    if RoleEquipUtility.CheckItemCanOverlap(v) then
      if itemStatistics[v.tblEquip.overlap] == nil then
        itemStatistics[v.tblEquip.overlap] = {}
      end
      table.insert(itemStatistics[v.tblEquip.overlap], v)
    end
  end
  for k, v in pairs(itemStatistics) do
    if type(v) == "table" and 2 <= #v then
      for k1, itemData in pairs(v) do
        table.insert(ExcellenceSuitBagItems, itemData)
      end
    end
  end
  local ExcellenceSuitBagItemsTemp = {}
  if ForgeData.EquipOverlapMain then
    local targetList = itemStatistics[ForgeData.EquipOverlapMain.tblEquip.overlap]
    if targetList and next(targetList) then
      for k1, itemData in pairs(targetList) do
        if itemData.id ~= ForgeData.EquipOverlapMain.id then
          table.insert(ExcellenceSuitBagItemsTemp, itemData)
        end
      end
    end
  else
    ExcellenceSuitBagItemsTemp = ExcellenceSuitBagItems
  end
  ExcellenceSuitBagItems = ExcellenceSuitBagItemsTemp
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowUseOperation, true, true)
  self.dragTbl:SetData(ExcellenceSuitBagItems, "ShowBagInSuit")
end

function Bag_3DBagInfoUI:ShowBagDecompose(TotalItems)
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowUseOperation, true, true)
  self.dragTbl:SetData(TotalItems, "ShowBagDecompose")
end

function Bag_3DBagInfoUI:ShowBagInZhuiJia(TotalItems)
  local showItems = {}
  for _, itemData in pairs(TotalItems) do
    if RoleEquipUtility.CheckCanZhuiJia(itemData.tblItem.id) then
      table.insert(showItems, itemData)
    end
  end
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowEquipIntensify, true, true)
  self.dragTbl:SetData(showItems, "ShowBagInZhuiJia")
end

function Bag_3DBagInfoUI:ShowBagTransferInIntensify(TotalItems)
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowEquipIntensify, true, true)
  self.dragTbl:SetData(TotalItems, "ShowBagTransferInIntensify")
end

function Bag_3DBagInfoUI:ShowBagTransferInZhuiJia(TotalItems)
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowEquipIntensify, true, true)
  self.dragTbl:SetData(TotalItems, "ShowBagTransferInZhuiJia")
end

function Bag_3DBagInfoUI:ShowBagTransfer(TotalItems)
  local showItems = {}
  if ViewData.meData.equipsData.Data and table.count(ViewData.meData.equipsData.Data) > 0 then
    for k, itemData in pairs(ViewData.meData.equipsData.Data) do
      local cellIndex = tonumber(string.split(itemData.tblEquip.equipPosition, "#")[1])
      if (RoleEquipUtility.EquipTypeUtility(cellIndex, ERoleEquipCondition.Normal) or RoleEquipUtility.EquipTypeUtility(cellIndex, ERoleEquipCondition.HongZhuang)) and BagInfoData.IsShowEquip(itemData) then
        table.insert(showItems, itemData)
      end
    end
  end
  for _, itemData in pairs(TotalItems) do
    if itemData.tblItem.type == EItemType.Equipe then
      local cellIndex = tonumber(string.split(itemData.tblEquip.equipPosition, "#")[1])
      if (RoleEquipUtility.EquipTypeUtility(cellIndex, ERoleEquipCondition.Normal) or RoleEquipUtility.EquipTypeUtility(cellIndex, ERoleEquipCondition.HongZhuang)) and BagInfoData.IsShowEquip(itemData) then
        table.insert(showItems, itemData)
      end
    end
  end
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowEquipIntensify, true, true)
  self.dragTbl:SetData(showItems, "ShowBagTransfer")
end

function Bag_3DBagInfoUI:ShowBagIntensify(TotalItems)
  local showItems = {}
  for _, itemData in pairs(TotalItems) do
    if RoleEquipUtility.CheckCanIntensify(itemData.tblItem.id) then
      table.insert(showItems, itemData)
    end
  end
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowEquipIntensify, true, true)
  self.dragTbl:SetData(showItems, "ShowBagIntensify")
end

function Bag_3DBagInfoUI:ShowBagOrnaments(TotalItems)
  local showItems = {}
  for _, itemData in pairs(TotalItems) do
    if itemData.tblItem.type == EItemType.Equipe and (itemData.tblItem.subType == EItemSubtype.Ring or itemData.tblItem.subType == EItemSubtype.Necklace or itemData.tblItem.subType == EItemSubtype.Earrings) then
      table.insert(showItems, itemData)
    end
  end
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowEquipIntensify, true, true)
  self.dragTbl:SetData(showItems, "ShowBagOrnaments")
end

function Bag_3DBagInfoUI:ShowBagStone(_, TotalItems)
  local showItems = {}
  for _, itemData in pairs(TotalItems) do
    if itemData.tblItem.type == EItemType.FireGem or itemData.tblItem.type == EItemType.WaterGem or itemData.tblItem.type == EItemType.IceGem or itemData.tblItem.type == EItemType.WindGem then
      table.insert(showItems, itemData)
    end
  end
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowEquipIntensify, true, true)
  self.dragTbl:SetData(showItems, "ShowBagStone")
end

function Bag_3DBagInfoUI:ShowXiLianEquip(TotalItems)
  local showItems = {}
  if ViewData.meData.equipsData.Data and table.count(ViewData.meData.equipsData.Data) > 0 then
    for k, itemData in pairs(ViewData.meData.equipsData.Data) do
      if itemData:CheckCanXiLian() and not gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():IsXiLianEquip(itemData.id) then
        table.insert(showItems, itemData)
      end
    end
  end
  for _, itemData in pairs(TotalItems) do
    if ItemUtility.IsEquipType(itemData.tblItem.type) and itemData:CheckCanXiLian() and not gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():IsXiLianEquip(itemData.id) then
      table.insert(showItems, itemData)
    end
  end
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowEquipXiLian, true, true)
  self.dragTbl:SetData(showItems, "ShowXiLianEquip")
end

function Bag_3DBagInfoUI:ShowHolySpiritEquip(TotalItems)
  local showItems = {}
  for _, itemData in pairs(TotalItems) do
    if ItemUtility.IsEquipType(itemData.tblItem.type) and itemData.tblEquip and ItemUtility.IsHolySpiritEquipType(itemData.tblEquip.subType) then
      table.insert(showItems, itemData)
    end
  end
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowUseOperation, true, true)
  self.dragTbl:SetData(showItems, "ShowHolySpirit", true)
end

function Bag_3DBagInfoUI:ShowRuneItems(TotalItems)
  local showItems = {}
  for _, itemData in pairs(TotalItems) do
    if ItemUtility.IsRuneType(itemData.tblItem.type) and itemData.serverInfo and itemData.serverInfo.runesLevel == 0 then
      table.insert(showItems, itemData)
    end
  end
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowUseOperation, true, true)
  self.dragTbl:SetData(showItems, "ShowRune", true)
end

function Bag_3DBagInfoUI:ShowBagLuckyIntensify(TotalItems)
  local luckyIDTab = MeEquipController.EquipLuckyConfigTable
  local tempTab = {}
  for _, itemData in pairs(TotalItems) do
    if luckyIDTab[itemData.tblItem.id] ~= nil then
      table.insert(tempTab, itemData)
    end
  end
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowEquipIntensify, true, true)
  self.dragTbl:SetData(tempTab, "ShowBagLuckyIntensify")
end

function Bag_3DBagInfoUI:ShowBagConsumables(TotalItems)
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowUseOperation, true, true)
  self.dragTbl:SetData(TotalItems, "ShowBagConsumables")
end

function Bag_3DBagInfoUI:ShowBagRecycle(TotalItems)
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowUseOperation, true, true)
  self.dragTbl:SetData(TotalItems, "ShowBagRecycle")
  if not self.canSellRefresh then
    self.canSellRefresh = true
    self:OnRefreshSellSelect()
  end
end

function Bag_3DBagInfoUI:RefreshBagInfoCell()
  self.dragTbl:SetLock(BagInfoData.curBagCellCount)
  local cantDrag = false
  local needCalc = false
  local showItems = BagInfoData.TotalItems
  if TranScriptData.InTranscript then
    showItems = BagInfoData.TransfromShow(BagInfoData.TotalItems)
    needCalc = true
    cantDrag = true
  end
  if UIManager.IsVisibleOrCorrelation(UIID.Bag_PandoraInfoUI, self) then
    needCalc = true
    cantDrag = true
  end
  self.dragTbl:SetParam(self.PutIn, self.Button_ShowUseOperation, needCalc, cantDrag)
  self.dragTbl:SetData(showItems, "RefreshBagInfoCell", true)
  self:ArrowheadFun()
end

function Bag_3DBagInfoUI:SetDataState(itemCellData)
  local enabled = true
  if self.curPanelType == UIID.Skill_SetSkillUI then
    if not BagInfoData.IsConsumables(itemCellData.itemData) then
      enabled = false
    end
  elseif self.curPanelType == UIID.BagSellInfoUI then
    itemCellData.selected = BagInfoData.IsAutoSelectRecycle(itemCellData.itemData)
    if BagInfoData.RecycleItemTbl[itemCellData.itemData.bagGridIndex] then
      itemCellData.selected = true
    end
    if BagInfoData.RecycleCancel[itemCellData.itemData.bagGridIndex] then
      itemCellData.selected = false
    end
    local isChanged = BagInfoData.SelectRecycle({
      bagIndex = itemCellData.itemData.bagGridIndex,
      id = itemCellData.itemData.id,
      count = itemCellData.itemData.count,
      sell = itemCellData.itemData.tblItem.sell
    }, itemCellData.selected)
    if isChanged then
      ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
      EventManager.Dispatch(Event.Bag_SellItemClick)
    end
  elseif self.curPanelType == UIID.Equip_OverlapUI then
    if ForgeData.EquipOverlapMain and ForgeData.EquipOverlapMain == itemCellData.itemData or ForgeData.EquipOverlapSide and ForgeData.EquipOverlapSide == itemCellData.itemData then
      itemCellData.selected = true
    else
      itemCellData.selected = false
    end
    if ForgeData.EquipOverlapMain and itemCellData.itemData then
      local tempTab = IsHaveDifferentExcellence(itemCellData.itemData)
      if itemCellData.itemData.itemId == ForgeData.EquipOverlapMain.itemId and table.count(tempTab) == 0 then
        itemCellData.enabled = false
      elseif itemCellData.itemData.itemId ~= ForgeData.EquipOverlapMain.itemId then
        itemCellData.enabled = false
      end
    end
  elseif self.curPanelType == UIID.Equip_Decompose then
    if not BagInfoData.IsDecompose(itemCellData.itemData) then
      enabled = false
    end
  elseif self.curPanelType == UIID.Equip_Transfer then
    itemCellData.isShowArrow = false
    if self.curChildPanelType == TransferOpenType.Intensify then
      if not BagInfoData.IsIntensify(itemCellData.itemData) then
        enabled = false
      end
    elseif self.curChildPanelType == TransferOpenType.Zhuijia then
      if not BagInfoData.IsZhuiJia(itemCellData.itemData) then
        enabled = false
      end
    elseif self.curChildPanelType == TransferOpenType.IntensifyAndAdd then
    end
  elseif self.curPanelType == UIID.Equip_IntensifyUI then
    itemCellData.isShowArrow = false
    local enabled = true
    if not BagInfoData.IsOnClick(itemCellData.itemData) then
      enabled = false
    end
  elseif self.curPanelType == UIID.Equip_ZhuijiaUI then
    itemCellData.isShowArrow = false
  end
  itemCellData.enabled = enabled
end

function Bag_3DBagInfoUI:GetGuideParent(id, msg)
  local infos = self.dragTbl:GetCtrInfos()
  for _, data in pairs(infos) do
    if data.itemData then
      local function SendEvent()
        local itemCellData = data:GetData()
        
        if itemCellData.itemData then
          local item = self.dragTbl:GetCtrByCellData(itemCellData)
          if item then
            local setMsg = {
              parent = item or nil,
              data = msg
            }
            EventManager.Dispatch(Event.SetGuideParent, setMsg)
          end
        end
      end
      
      if string.contains(msg.itemId, "#") then
        local itemIdTbl = string.split(msg.itemId, "#")
        for kk, vv in pairs(itemIdTbl) do
          if data.itemData.itemId == tonumber(vv) then
            SendEvent()
            return
          end
        end
      elseif data.itemData.itemId == tonumber(msg.itemId) then
        SendEvent()
        return
      end
    end
  end
end

function Bag_3DBagInfoUI:EquipTipsGuideEff(id, msg)
  local infos = self.dragTbl:GetCtrInfos()
  for _, data in pairs(infos) do
    if data.itemData then
      local function SendEvent()
        local itemCellData = data:GetData()
        
        if itemCellData.itemData then
          local parent = self.dragTbl:GetCtrByCellData(itemCellData)
          if parent then
            local ScaleX = tonumber(data.itemData.tblItem.xTranslate)
            local ScaleY = tonumber(data.itemData.tblItem.yTranslate)
            local PosX = 22 + 20 * (ScaleX - 1)
            local PosY = -22 - 20 * (ScaleY - 1)
            local Effect = UIEffectUtility.SetUIEffect(msg.effParam, parent, true, Vector2(ScaleX, ScaleY), Vector3(PosX, PosY, 0))
            table.insert(self.EquipWearff, Effect)
          end
        end
      end
      
      if data.itemData.id == msg.Id then
        SendEvent()
        return
      end
    end
  end
end

local drugItemId = {}
local drugMpItemId = {}
local minNum = 10

function Bag_3DBagInfoUI:SetBuyDrugGuide()
  drugItemId = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(1100004), "|")
  drugMpItemId = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(1100005), "|")
  local level = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(1100003))
  if level > ViewData.meData.level then
    if self.BuyDrugGuideEff then
      self.BuyDrugGuideEff:SetActive(false)
    end
    if self.BuyDrugGuideProText then
      self.BuyDrugGuideProText:SetActive(false)
      self.BuyDrugGuideProText.data.state = false
    end
    return
  end
  local number = 0
  local MpNumber = 0
  local state = false
  for k, v in pairs(drugItemId) do
    number = number + BagInfoData.GetItemCountByItemConfigId(tonumber(v))
  end
  for k, v in pairs(drugMpItemId) do
    MpNumber = MpNumber + BagInfoData.GetItemCountByItemConfigId(tonumber(v))
  end
  state = not (number >= minNum) or not (MpNumber >= minNum)
  if self.BuyDrugGuideEff then
    self.BuyDrugGuideEff:SetActive(state)
  else
    self.BuyDrugGuideEff = UIEffectUtility.SetUIEffect("Eff_UI_annuikuang04", self.btn_Buy, false, Vector3(0.96, 0.65, 500))
    self.BuyDrugGuideEff:SetActive(state)
  end
  if self.BuyDrugGuideProText then
    self.BuyDrugGuideProText:SetActive(state)
    self.BuyDrugGuideProText.data.state = state
  else
    local data = {
      text = "D\198\176\225\187\163c ph\225\186\169m kh\195\180ng \196\145\225\187\167, nh\225\186\165p d\225\187\139ch chuy\225\187\131n \196\145\225\186\191n Ti\225\187\135m",
      gameObject = self.btn_Buy,
      pos = Vector3(0, 88, -1000),
      scale = Vector3(260, 40, 0),
      arrows = 2,
      sortOrder = 500,
      posLeft = Vector3(-65, -5, 0),
      scaLeft = Vector3(140, 71, 0),
      rotationLeft = 0,
      posRight = Vector3(70, -5, 0),
      scaRight = Vector3(130, 71, 0),
      rotationRight = 0
    }
    self.BuyDrugGuideProText = TextPromptUtility.SetTextPrompt(data, state)
    self.BuyDrugGuideProText:SetActive(state)
  end
end

function Bag_3DBagInfoUI:OnGridUpdate(_, msg)
  if msg.type == EDragUIType.Bag then
    self.dragTbl:SetLock(BagInfoData.curBagCellCount)
  end
end

function Bag_3DBagInfoUI:ChangeEquipSelect(_, msg)
  local infos = self.dragTbl:GetCtrInfos()
  for _, data in pairs(infos) do
    if data.itemData and data.itemData == msg then
      local itemCellData = data:GetData()
      itemCellData.selected = true
      ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
    end
  end
end

function Bag_3DBagInfoUI:AudioTypeInit()
  local temp = string.split(GlobalConfig.GetGlobalConfig(2070003), "#")
  self.audioTypeTab = {}
  for i = 1, table.count(temp) do
    table.insert(self.audioTypeTab, tonumber(temp[i]))
  end
end

function Bag_3DBagInfoUI:ArrowheadFun()
  self.Arrowacc = 0
  if self.ArrowrecTimer then
    Timer.Stop(self.ArrowrecTimer)
  end
  self.ArrowrecTimer = nil
  self:ArrowCreatTimer()
end

function Bag_3DBagInfoUI:ArrowCreatTimer()
  local function UpdataTimerBtn()
    if UIManager.IsVisibleOrCorrelation(UIID.Bag_EquipInfoUI, self) then
      self.Arrowacc = self.Arrowacc + 1
      
      if self.Arrowacc >= 2 then
        if self.Arrowacc == 2 then
          self.ArrowheadTbl = BagInfoData.ArrowheadItems(self.dragTbl.items)
        end
        for i, item in pairs(self.ArrowheadTbl.GreenArrow) do
          local pos = item.img_grrow.transform.localPosition
          item.img_grrow.transform:DOLocalMoveY(pos.y + 6, 0.05):SetEase(Ease.OutQuart):OnComplete(function()
            item.img_grrow.transform:DOLocalMoveY(pos.y, 0.05):SetEase(Ease.OutQuart):OnComplete(function()
              item.img_grrow.transform:DOLocalMoveY(pos.y + 6, 0.05):SetEase(Ease.OutQuart):OnComplete(function()
                item.img_grrow.transform:DOLocalMoveY(pos.y, 0.05):SetEase(Ease.OutQuart)
              end)
            end)
          end)
        end
        if self.Arrowacc % 2 == 0 then
          for i, item in pairs(self.ArrowheadTbl.YellowArrow) do
            local pos = item.img_grrow.transform.localPosition
            item.img_grrow.transform:DOLocalMoveY(pos.y + 6, 0.05):SetEase(Ease.OutQuart):OnComplete(function()
              item.img_grrow.transform:DOLocalMoveY(pos.y, 0.05):SetEase(Ease.OutQuart):OnComplete(function()
                item.img_grrow.transform:DOLocalMoveY(pos.y + 6, 0.05):SetEase(Ease.OutQuart):OnComplete(function()
                  item.img_grrow.transform:DOLocalMoveY(pos.y, 0.05):SetEase(Ease.OutQuart)
                end)
              end)
            end)
          end
        end
      end
    end
  end
  
  self.ArrowrecTimer = Timer.StartLoopForever(1.3, UpdataTimerBtn)
end
