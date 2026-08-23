Puzzle_JH_BagUI = class(BaseUI)
Puzzle_JH_BagUI.layer = UILayer.Panel
Puzzle_JH_BagUI.orderInLayer = 0
Puzzle_JH_BagUI.hideType = UIHideType.WaitDestroy
Puzzle_JH_BagUI.hideFunc = UIHideFunc.MoveOutOfScreen
Puzzle_JH_BagUI.escClose = UIEscClose.DontClose

function Puzzle_JH_BagUI:InitControls()
  self.tile_bg = self:GetControl("Scroll_BagInfos/Viewport/go_BagContent/tile_bg")
  self.go_DragCheck = self:GetControl("Scroll_BagInfos/go_DragCheck")
  self.go_ScrollTop = self:GetControl("Scroll_BagInfos/go_DragCheck/go_ScrollTop")
  self.go_ScrollBottom = self:GetControl("Scroll_BagInfos/go_DragCheck/go_ScrollBottom")
  self.go_DragEdge = self:GetControl("Scroll_BagInfos/go_DragCheck/go_DragEdge")
  self.btn_3DItem = self:GetControl("Scroll_BagInfos/Viewport/go_BagContent/tile_bg/itemBag")
  self.Scroll_BagInfos = self:GetControl("Scroll_BagInfos")
  self.go_BagContent = self:GetControl("Scroll_BagInfos/Viewport/go_BagContent")
  self.DragParent = self:GetControl("Scroll_BagInfos/DragParent")
  self.btn_SortOut = self:GetControl("Scroll_BagInfos/Content_btn/btn_SortOut")
  self.Img_TipBg = self:GetControl("Img_TipBg")
  self.btn_Close = self:GetControl("Button_CloseBag")
end

local function InlayOnClickFunction(_template, _ui)
  if _template == nil or _ui == nil or _template.data == nil then
    return
  end
  local itemData = _template.data
  UIManager.Show(UIID.Tip_CrystalNucleusUI, {data = itemData, type = 1})
end

local function InlayFilterFunction(_data, _ui)
  return true
end

local function InlaySortFunction(_data, _ui)
  table.sort(_data, function(a, b)
    if a.m_ItemConfig.quality ~= b.m_ItemConfig.quality then
      return a.m_ItemConfig.quality > b.m_ItemConfig.quality
    end
    if a.m_ItemConfig.gridNum ~= b.m_ItemConfig.gridNum then
      return tonumber(a.m_ItemConfig.gridNum) < tonumber(b.m_ItemConfig.gridNum)
    end
    if a.m_ServerInfo.nucleusLevel ~= b.m_ServerInfo.nucleusLevel then
      return a.m_ServerInfo.nucleusLevel > b.m_ServerInfo.nucleusLevel
    end
    return a.m_ItemConfig.id > b.m_ItemConfig.id
  end)
end

local function AdvancedOnClickFunction(_template, _ui)
end

local function AdvancedFilterFunction(_data, _ui)
  return true
end

local function AdvancedSortFunction(_data, _ui)
end

local function ZhuanYiItemOnClick(control)
  local itemData = control.data
  EventManager.Dispatch(Event.CrystalNucleusTransfer, itemData)
end

local function ZhuanYiItemFiltering(itemData)
  if itemData.m_ServerInfo.nucleusLevel >= 1 then
    return true
  end
  return false
end

local function ZhuanYiItemSort(dataList)
  table.sort(dataList, function(a, b)
    if a.m_ServerInfo.nucleusLevel == b.m_ServerInfo.nucleusLevel then
      return a.m_ItemConfig.id < b.m_ItemConfig.id
    end
    return a.m_ServerInfo.nucleusLevel > b.m_ServerInfo.nucleusLevel
  end)
end

local function ZhuanYiBagChangeItemFiltering(itemData, _ui)
  if itemData.m_ServerInfo.nucleusLevel < _ui.levelLimit then
    return true
  end
  return false
end

local function FenJieItemOnClick(control)
  local itemData = control.data
  itemData.obj = control.go
  if table.contains(CrystalNucleusFenJieController.GetFenJieList(), itemData) then
    CrystalNucleusFenJieController.RemoveFenJieItem(itemData)
  else
    CrystalNucleusFenJieController.AddFenJieItem(itemData)
  end
end

local function FenJieItemFiltering(itemData)
  return true
end

local function FenJieItemSort(totalBagDataList)
  table.sort(totalBagDataList, function(a, b)
    if a.m_ItemConfig.quality == b.m_ItemConfig.quality then
      return a.m_ItemConfig.id > b.m_ItemConfig.id
    end
    return a.m_ItemConfig.quality < b.m_ItemConfig.quality
  end)
end

function Puzzle_JH_BagUI:Init()
  self.crystalNucleusNavLogic = {
    [1] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Puzzle_JH_XiangqianUI, self) then
        local totalBagDataList = CrystalNucleusBagManager:GetCrystalNucleusBagData()
        if totalBagDataList == nil then
          return
        end
        self.crystalNucleusBagCellContainer:SetParam(InlayOnClickFunction, InlayFilterFunction, InlaySortFunction, true)
        self.crystalNucleusBagCellContainer:SetData(totalBagDataList)
        return true
      end
    end,
    [2] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Puzzle_JH_JinjieUI, self) then
        local totalBagDataList = CrystalNucleusBagManager:GetCrystalNucleusBagData()
        if totalBagDataList == nil then
          return
        end
        self.crystalNucleusBagCellContainer:SetParam(InlayOnClickFunction, AdvancedFilterFunction, InlaySortFunction)
        self.crystalNucleusBagCellContainer:SetData(totalBagDataList)
        return true
      end
    end,
    [3] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Puzzle_JH_QianghuaUI, self) then
        local crystalNucleusEquipTab = {}
        local totalBagDataList = CrystalNucleusBagManager:GetCrystalNucleusBagData()
        local equipTab = CrystalNucleusManager:GetCrystalNucleusEquipTab()
        if equipTab then
          for i, v in pairs(equipTab) do
            table.insert(crystalNucleusEquipTab, v)
          end
        end
        table.combine(crystalNucleusEquipTab, totalBagDataList)
        if crystalNucleusEquipTab == nil then
          return
        end
        self.qianghuaCheck = false
        self.crystalNucleusBagCellContainer:SetParam(function(control)
          EventManager.Dispatch(Event.PuzzleItemDataModel, control)
        end, InlayFilterFunction, InlaySortFunction)
        self.crystalNucleusBagCellContainer:SetData(crystalNucleusEquipTab)
        return true
      end
    end,
    [4] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Puzzle_JH_ZhuanyiUI, self) then
        local totalBagDataList = CrystalNucleusBagManager:GetCrystalNucleusBagData()
        if CrystalNucleusZhuanYiController.canChangeBagRefreshFunc == false then
          self.crystalNucleusBagCellContainer:SetParam(ZhuanYiItemOnClick, ZhuanYiItemFiltering, ZhuanYiItemSort)
        else
          self.crystalNucleusBagCellContainer:SetParam(ZhuanYiItemOnClick, ZhuanYiBagChangeItemFiltering, ZhuanYiItemSort)
        end
        self.crystalNucleusBagCellContainer:SetData(totalBagDataList)
        return true
      end
    end,
    [5] = function(content)
      if UIManager.IsVisibleOrCorrelation(UIID.Puzzle_JH_FenjieUI, self) then
        local totalBagDataList = CrystalNucleusBagManager:GetCrystalNucleusBagData()
        self.crystalNucleusBagCellContainer:SetParam(FenJieItemOnClick, FenJieItemFiltering, FenJieItemSort, false)
        self.crystalNucleusBagCellContainer:SetData(totalBagDataList)
        return true
      end
    end
  }
end

function Puzzle_JH_BagUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Puzzle_JH_BagUI:InitUI()
  local transform = self.root.transform
  local x, y = transform:GetAnchoredPosition()
  transform.anchoredPosition3D = Vector3.New(x, y, -1000)
  self.crystalNucleusBagCellContainer = CrystalNucleusBagCellContainer(self)
end

function Puzzle_JH_BagUI:RegistUIEvents()
  self.btn_SortOut:SetOnClick(self, self.btn_SortOutOnClick)
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
end

function Puzzle_JH_BagUI:btn_SortOutOnClick()
  self:CrystalNucleusNavChange()
end

function Puzzle_JH_BagUI:btn_CloseOnClick()
  UIManager.Hide(UIID.Puzzle_JH_NavUI)
end

function Puzzle_JH_BagUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Puzzle_JH_BagUI:RegistEvents()
  self:RegistEvent(Event.CrystalNucleusNavChange, self.CrystalNucleusNavChange, self)
  self:RegistEvent(Event.CrystalNucleusBagChange, self.CrystalNucleusBagChange, self)
  self:RegistEvent(Event.CrystalNucleusTransferBagChange, self.OnCrystalNucleusTransferBagChange, self)
  self:RegistEvent(Event.CrystalNucleusItemInfoChange, self.CrystalNucleusItemInfoChange, self)
  self:RegistEvent(Event.ShowSelectImg, self.OnShowSelectImg, self)
  self:RegistEvent(Event.HideSelectImg, self.OnHideSelectImg, self)
end

function Puzzle_JH_BagUI:Refresh()
end

function Puzzle_JH_BagUI:OnShowSelectImg(_, data)
  local items = self.crystalNucleusBagCellContainer:GetItemTemplate(data[1]):SetSelectState(true)
end

function Puzzle_JH_BagUI:OnHideSelectImg(_, data)
  local items = self.crystalNucleusBagCellContainer:GetItemTemplate(data[1]):SetSelectState(false)
end

function Puzzle_JH_BagUI:OnCrystalNucleusTransferBagChange(_, itemData)
  local totalBagDataList = CrystalNucleusBagManager:GetCrystalNucleusBagData()
  if itemData ~= nil then
    self.levelLimit = itemData
    CrystalNucleusZhuanYiController.canChangeBagRefreshFunc = true
    self.crystalNucleusBagCellContainer:SetParam(ZhuanYiItemOnClick, ZhuanYiBagChangeItemFiltering, ZhuanYiItemSort)
  else
    CrystalNucleusZhuanYiController.canChangeBagRefreshFunc = false
    self.crystalNucleusBagCellContainer:SetParam(ZhuanYiItemOnClick, ZhuanYiItemFiltering, ZhuanYiItemSort)
  end
  self.crystalNucleusBagCellContainer:SetData(totalBagDataList)
end

function Puzzle_JH_BagUI:CrystalNucleusNavChange()
  self:JudgeNavLogic(self.crystalNucleusNavLogic)
end

function Puzzle_JH_BagUI:CrystalNucleusBagChange(_, msg)
  if msg == nil then
    return
  end
  if msg.removeItems then
    for _, itemData in ipairs(msg.removeItems) do
      self.crystalNucleusBagCellContainer:RemoveData(itemData)
    end
  end
  if msg.addItems then
    for _, itemInfo in ipairs(msg.addItems) do
      self.crystalNucleusBagCellContainer:AddData(itemInfo, true)
    end
  end
end

function Puzzle_JH_BagUI:CrystalNucleusItemInfoChange(_, msg)
  if msg == nil then
    return
  end
  self.crystalNucleusBagCellContainer:ChangeData(msg)
end

function Puzzle_JH_BagUI:JudgeNavLogic(rules, content)
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

function Puzzle_JH_BagUI:OnHide()
end

function Puzzle_JH_BagUI:OnDestroy()
end
