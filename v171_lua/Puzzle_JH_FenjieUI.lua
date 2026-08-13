Puzzle_JH_FenjieUI = class(BaseUI)
Puzzle_JH_FenjieUI.layer = UILayer.Panel
Puzzle_JH_FenjieUI.orderInLayer = 0
Puzzle_JH_FenjieUI.hideType = UIHideType.WaitDestroy
Puzzle_JH_FenjieUI.hideFunc = UIHideFunc.MoveOutOfScreen
Puzzle_JH_FenjieUI.escClose = UIEscClose.DontClose

function Puzzle_JH_FenjieUI:InitControls()
  self.tog_itemPutong = self:GetControl("img_bg/img_frame/go_SellOption/tog_itemPutong")
  self.tog_itemXiyou = self:GetControl("img_bg/img_frame/go_SellOption/tog_itemXiyou")
  self.tog_itemShishi = self:GetControl("img_bg/img_frame/go_SellOption/tog_itemShishi")
  self.tog_itemChuanshuo = self:GetControl("img_bg/img_frame/go_SellOption/tog_itemChuanshuo")
  self.tog_itemYuangu = self:GetControl("img_bg/img_frame/go_SellOption/tog_itemYuangu")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.sw_decProfit = self:GetControl("img_bg/sw_decProfit")
  self.Content = self:GetControl("img_bg/sw_decProfit/Viewport/Content")
  self.decProfit = self:GetControl("img_bg/sw_decProfit/Viewport/Content/decProfit")
  self.lab_num = self:GetControl("img_bg/sw_decProfit/Viewport/Content/decProfit/lab_num")
  self.btn_decompose = self:GetControl("img_bg/btn_decompose")
  self.lab_decompose = self:GetControl("img_bg/btn_decompose/lab_decompose")
  self.descBtn = self:GetControl("descBtn")
  self.plane_top = self:GetControl("plane_top")
  self.plane_bottom = self:GetControl("plane_bottom")
end

function Puzzle_JH_FenjieUI:Init()
end

function Puzzle_JH_FenjieUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Puzzle_JH_FenjieUI:InitUI()
  self.decomposePuzzleTbl = {}
  self.togTbl = {
    [1] = self.tog_itemPutong,
    [2] = self.tog_itemXiyou,
    [3] = self.tog_itemShishi,
    [4] = self.tog_itemChuanshuo,
    [5] = self.tog_itemYuangu
  }
  self.selectTypeTbl = {
    [self.tog_itemPutong] = {isOn = false, quality = 101},
    [self.tog_itemXiyou] = {isOn = false, quality = 102},
    [self.tog_itemShishi] = {isOn = false, quality = 103},
    [self.tog_itemChuanshuo] = {isOn = false, quality = 104},
    [self.tog_itemYuangu] = {isOn = false, quality = 105}
  }
  self.isChange = true
  self.isRemove = false
  self.btn_decompose:SetActive(false)
  self.GetItemCfgTbl = ClientTable.cfg_puzzle_decomposeManager:GetDic()
  self.cellData = nil
  self:InitToggleTbl()
end

function Puzzle_JH_FenjieUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.decProfit:SetOnClick(self, self.decProfitOnClick)
  self.btn_decompose:SetOnClick(self, self.btn_decomposeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Puzzle_JH_FenjieUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Puzzle_JH_NavUI)
end

function Puzzle_JH_FenjieUI:decProfitOnClick(control)
end

function Puzzle_JH_FenjieUI:btn_decomposeOnClick(control)
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = ClientTable.cfg_Ui_promptwordManager:TryGetValue(72).content,
    okText = "X\195\161c nh\225\186\173n",
    ok = function()
      self:CrystalNucleusDecompose()
    end
  })
end

function Puzzle_JH_FenjieUI:CrystalNucleusDecompose()
  local itemIdList = {}
  local puzzleTbl = CrystalNucleusFenJieController.GetFenJieList()
  for i = 1, #puzzleTbl do
    table.insert(itemIdList, puzzleTbl[i].m_ServerInfo.id)
  end
  NetManager.Send(RoleMessage.ReqCrystalNucleusDecompose, {equipId = itemIdList})
  self.isChange = true
  self.isRemove = false
  self.btn_decompose:SetActive(false)
  self:ClearDecomposePuzzleTblAndHideSelectBox()
  CrystalNucleusFenJieController.SetFenJieList(self.decomposePuzzleTbl)
  for i, v in ipairs(self.togTbl) do
    self.selectTypeTbl[v].isOn = false
    v:SetIsOn(self.selectTypeTbl[v].isOn)
  end
  self.lab_num:SetText("0")
end

function Puzzle_JH_FenjieUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Puzzle_JH_FenjieUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Puzzle_JH_FenjieUI:InitToggleTbl()
  for i = 1, #self.togTbl do
    local toggle = self.togTbl[i]
    toggle:SetOnToggleChanged(self, self.HandleToggleChange)
  end
end

function Puzzle_JH_FenjieUI:HandleToggleChange(toggle)
  if toggle:GetIsOn() == true then
    self.selectTypeTbl[toggle].isOn = true
  else
    self.selectTypeTbl[toggle].isOn = false
  end
  self:RefreshDecomposeTbl(toggle)
end

function Puzzle_JH_FenjieUI:RefreshDecomposeTbl(toggle)
  local totalBagDataList = CrystalNucleusBagManager:GetCrystalNucleusBagData()
  if toggle:GetIsOn() == true then
    self.isRemove = true
  end
  for i = 1, #totalBagDataList do
    local puzzle = totalBagDataList[i]
    if self.selectTypeTbl[toggle].quality == puzzle.m_ItemConfig.quality then
      self:RefreshDecomposePuzzleTbl(puzzle, self.selectTypeTbl[toggle])
    end
  end
  CrystalNucleusFenJieController.SetFenJieList(self.decomposePuzzleTbl)
  local GetItemCount = 0
  for i, v in ipairs(self.decomposePuzzleTbl) do
    if v.m_ItemConfig.id == self.GetItemCfgTbl[v.m_ItemConfig.id].id then
      local itemTbl = string.split(self.GetItemCfgTbl[v.m_ItemConfig.id].decompose, "#")
      GetItemCount = GetItemCount + tonumber(itemTbl[2])
    end
    if 0 < v.m_ServerInfo.nucleusLevel then
      local ratio = ClientTable.cfg_puzzle_growupManager:GetItemDataLevelIDReturnRatio(v.m_ServerInfo.nucleusLevel, v.m_ServerInfo.itemId)
      local materialName, materialCount = ClientTable.cfg_puzzle_growupManager:GetItemDataLevelIDMaterial(v.m_ServerInfo.nucleusLevel, v.m_ServerInfo.itemId)
      local decomposeLevelCount = Mathf.Floor(materialCount * ratio)
      GetItemCount = GetItemCount + decomposeLevelCount
    end
  end
  self.lab_num:SetText(tostring(GetItemCount))
  if GetItemCount == 0 then
    self.btn_decompose:SetActive(false)
  else
    self.btn_decompose:SetActive(true)
  end
  self.isChange = true
end

function Puzzle_JH_FenjieUI:RefreshDecomposePuzzleTbl(puzzle, selectType)
  if self.isChange == false then
    self.decomposePuzzleTbl = CrystalNucleusFenJieController.GetFenJieList()
    return
  end
  if selectType.isOn and selectType.quality == puzzle.m_ItemConfig.quality then
    if self.isRemove == true then
      self:ClearListByType(selectType)
      self.isRemove = false
    end
    table.insert(self.decomposePuzzleTbl, puzzle)
    EventManager.Dispatch(Event.ShowSelectImg, {
      puzzle.m_ServerInfo.id
    })
  elseif not selectType.isOn and selectType.quality == puzzle.m_ItemConfig.quality then
    self:ClearListByType(selectType)
  end
end

function Puzzle_JH_FenjieUI:ClearListByType(selectType)
  local acc = 0
  for i = 1, #self.decomposePuzzleTbl do
    i = i + acc
    if self.decomposePuzzleTbl[i].m_ItemConfig.quality == selectType.quality then
      EventManager.Dispatch(Event.HideSelectImg, {
        self.decomposePuzzleTbl[i].m_ServerInfo.id
      })
      table.remove(self.decomposePuzzleTbl, i)
      acc = acc - 1
    end
  end
end

function Puzzle_JH_FenjieUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Puzzle_JH_FenjieUI:RegistEvents()
  self:RegistEvent(Event.CrystalNucleusDecomposeAddItem, self.OnCrystalNucleusDecomposeAddItem, self)
  self:RegistEvent(Event.CrystalNucleusDecomposeRemoveItem, self.OnCrystalNucleusDecomposeRemoveItem, self)
end

function Puzzle_JH_FenjieUI:OnCrystalNucleusDecomposeAddItem(_, itemData)
  EventManager.Dispatch(Event.ShowSelectImg, {
    itemData.m_ServerInfo.id
  })
  for i, v in ipairs(self.togTbl) do
    if self.selectTypeTbl[v].quality == itemData.m_ItemConfig.quality then
      self.isChange = false
      local togIsOn = self:WhetherSelectAll(self.selectTypeTbl[v])
      if self.selectTypeTbl[v].isOn == togIsOn then
        self:RefreshDecomposeTbl(v)
        break
      end
      self.selectTypeTbl[v].isOn = togIsOn
      v:SetIsOn(self.selectTypeTbl[v].isOn)
      break
    end
  end
end

function Puzzle_JH_FenjieUI:OnCrystalNucleusDecomposeRemoveItem(_, itemData)
  EventManager.Dispatch(Event.HideSelectImg, {
    itemData.m_ServerInfo.id
  })
  for i, v in ipairs(self.togTbl) do
    if self.selectTypeTbl[v].quality == itemData.m_ItemConfig.quality then
      self.isChange = false
      if self.selectTypeTbl[v].isOn == false then
        self:RefreshDecomposeTbl(v)
        break
      end
      self.selectTypeTbl[v].isOn = false
      v:SetIsOn(self.selectTypeTbl[v].isOn)
      break
    end
  end
end

function Puzzle_JH_FenjieUI:WhetherSelectAll(tog)
  local totalBagDataList = CrystalNucleusBagManager:GetCrystalNucleusBagData()
  local thisTypeCountInBag = 0
  for i, v in ipairs(totalBagDataList) do
    if v.m_ItemConfig.quality == tog.quality then
      thisTypeCountInBag = thisTypeCountInBag + 1
    end
  end
  local thisTypeCountInDecomposePuzzleTbl = 0
  for i, v in ipairs(self.decomposePuzzleTbl) do
    if v.m_ItemConfig.quality == tog.quality then
      thisTypeCountInDecomposePuzzleTbl = thisTypeCountInDecomposePuzzleTbl + 1
    end
  end
  if thisTypeCountInDecomposePuzzleTbl == thisTypeCountInBag then
    return true
  end
  return false
end

function Puzzle_JH_FenjieUI:ShowModel()
  local itemTbl = ClientTable.cfg_puzzle_decomposeManager:TryGetValue(24001001).decompose
  local id = tonumber(string.split(itemTbl, "#")[1])
  local itemData = ItemUtility.GenerateItemData(id)
  self.cellData = ItemCellData()
  self.cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.decProfit, self.cellData, self, true)
end

function Puzzle_JH_FenjieUI:ClearDecomposePuzzleTblAndHideSelectBox()
  for i, v in pairs(self.decomposePuzzleTbl) do
    if v.obj then
      EventManager.Dispatch(Event.HideSelectImg, {
        v.m_ServerInfo.id
      })
    end
  end
  self.decomposePuzzleTbl = {}
end

function Puzzle_JH_FenjieUI:Refresh()
  if self.cellData == nil then
    self:ShowModel()
  end
  self.lab_num:SetText("0")
end

function Puzzle_JH_FenjieUI:OnHide()
  self.isChange = true
  self.isRemove = false
  self.btn_decompose:SetActive(false)
  self:ClearDecomposePuzzleTblAndHideSelectBox()
  CrystalNucleusFenJieController.SetFenJieList(self.decomposePuzzleTbl)
  for i, v in ipairs(self.togTbl) do
    self.selectTypeTbl[v].isOn = false
    v:SetIsOn(self.selectTypeTbl[v].isOn)
  end
end

function Puzzle_JH_FenjieUI:OnDestroy()
end
