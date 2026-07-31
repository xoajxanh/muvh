Tip_CrystalNucleusUI = class(BaseUI)
Tip_CrystalNucleusUI.layer = UILayer.Tip
Tip_CrystalNucleusUI.orderInLayer = 8
Tip_CrystalNucleusUI.hideType = UIHideType.WaitDestroy
Tip_CrystalNucleusUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_CrystalNucleusUI.escClose = UIEscClose.DontClose

function Tip_CrystalNucleusUI:InitControls()
  self.btn_Close = self:GetControl("btn_Close")
  self.Img_TipBg = self:GetControl("Img_TipBg")
  self.sv_center = self:GetControl("Img_TipBg/sv_center")
  self.img_centerBg = self:GetControl("Img_TipBg/sv_center/img_centerBg")
  self.lab_TipTitle = self:GetControl("Img_TipBg/sv_center/lab_TipTitle")
  self.lab_TipTopInfo = self:GetControl("Img_TipBg/sv_center/lab_TipTopInfo")
  self.img_item = self:GetControl("Img_TipBg/sv_center/Tip_ModelShow/img_item/img_item")
  self.lab_TipAttribute = self:GetControl("Img_TipBg/sv_center/Viewport/Content/lab_attribute/lab_TipAttribute")
  self.lab_TipStoneLightAdditional = self:GetControl("Img_TipBg/sv_center/Viewport/Content/lab_excellent/lab_TipStoneLightAdditional")
  self.lab_TipItemTips = self:GetControl("Img_TipBg/go_bottom/Scroll_DownTips/Viewport/Content/lab_TipItemTips")
  self.go_btns = self:GetControl("Img_TipBg/go_bottom/go_btns")
  self.btn_RightClick = self:GetControl("Img_TipBg/go_bottom/go_btns/btn_RightClick")
  self.btn_LeftClick = self:GetControl("Img_TipBg/go_bottom/go_btns/btn_LeftClick")
end

function Tip_CrystalNucleusUI:Init()
end

function Tip_CrystalNucleusUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_CrystalNucleusUI:InitUI()
end

function Tip_CrystalNucleusUI:ShowTips(itemData)
  local data = itemData.m_ItemConfig
  local serverData = itemData.m_ServerInfo
  local crystalNucleusLevelStr = ""
  if serverData.nucleusLevel > 0 then
    crystalNucleusLevelStr = string.GetColorText("+" .. serverData.nucleusLevel, ItemQuality2ColorDic[data.titleColor])
  end
  local ssStr = string.GetColorText(data.name, ItemQuality2ColorDic[data.titleColor])
  if crystalNucleusLevelStr ~= "" then
    self.lab_TipTitle:SetText(crystalNucleusLevelStr .. " " .. ssStr)
  else
    self.lab_TipTitle:SetText(ssStr)
  end
  self:SetSprite("Atlas_Common", tostring(data.icon), self.img_item, true)
  if self.itemSize == nil then
    self.itemSize = self.img_item.transform.localScale
  end
  self.img_item.transform.localScale = self.itemSize * (data.pngSize / 100)
  self.sv_center.scrollRect.enabled = true
  local inlayStr
  local inlayMaxCount = ClientTable.cfg_Item_equipManager:TryGetValue(data.id).inlayMax
  if inlayMaxCount == 1 then
    inlayStr = ClientTable.cfg_Global_globalManager:TryGetValue(64000010).effect
  else
    inlayStr = string.format(ClientTable.cfg_Global_globalManager:TryGetValue(64000009).effect, inlayMaxCount)
  end
  local skillLevel = ClientTable.cfg_Item_itemManager:TryGetValue(data.id).skillCrystalNucleus
  local skillLevelStr = string.format(ClientTable.cfg_Global_globalManager:TryGetValue(64000008).effect, skillLevel)
  local bind = ClientTable.cfg_Item_itemManager:TryGetValue(data.id).bind
  local bindStr
  if bind then
    if data.minAuctionPrice == "" then
      bindStr = string.GetColorText(ItemBind2Name[2], ItemQuality2ColorDic[EItemColorEnum.red])
    else
      bindStr = string.GetColorText(ItemBind2Name[bind], ItemQuality2ColorDic[EItemColorEnum.green])
    end
  end
  self.lab_TipTopInfo:SetText(bindStr .. "\n" .. inlayStr .. "\n" .. skillLevelStr)
  local displayStrTbl = {}
  if serverData.nucleusAttr and #serverData.nucleusAttr ~= 0 then
    if serverData.nucleusLevel == 0 then
      for i, v in ipairs(serverData.nucleusAttr) do
        table.insert(displayStrTbl, ClientTable.cfg_puzzle_entryManager:TryGetValue(v))
      end
    else
      for i, v in ipairs(serverData.nucleusAttr) do
        table.insert(displayStrTbl, ClientTable.cfg_puzzle_entry_levelupManager:GetGrowUpLevel(v, serverData.nucleusLevel))
      end
    end
  end
  local mainTbl = {}
  local deputyTbl = {}
  for i, v in ipairs(displayStrTbl) do
    if v.excellType == 1 then
      table.insert(mainTbl, v)
    else
      table.insert(deputyTbl, v)
    end
  end
  local mainStrTbl = {}
  local deputyStrTbl = {}
  local minValue, maxValue, name
  local puzzleType, puzzleValue = "", ""
  if mainTbl and #mainTbl ~= 0 then
    for i, v in ipairs(mainTbl) do
      local str
      minValue, maxValue, name, puzzleType, puzzleValue = CrystalNucleusUtility:CheckEntryTableHaveValue(v)
      if maxValue == nil then
        str = name .. " +" .. puzzleValue .. minValue .. puzzleType
      else
        str = name .. " +" .. puzzleValue .. minValue .. puzzleType .. "~" .. puzzleValue .. maxValue .. puzzleType
      end
      table.insert(mainStrTbl, str)
    end
  end
  if deputyTbl and #deputyTbl ~= 0 then
    for i, v in ipairs(deputyTbl) do
      local str
      minValue, maxValue, name, puzzleType, puzzleValue = CrystalNucleusUtility:CheckEntryTableHaveValue(v)
      if maxValue == nil then
        str = name .. " +" .. puzzleValue .. minValue .. puzzleType
      else
        str = name .. " +" .. puzzleValue .. minValue .. puzzleType .. "~" .. puzzleValue .. maxValue .. puzzleType
      end
      table.insert(deputyStrTbl, str)
    end
  end
  local colorStr = "<color=%s>%s</color>"
  self.lab_TipAttribute:SetText(string.format(colorStr, ClientTable.cfg_Global_globalManager:TryGetValue(64000006).effect, table.concat(mainStrTbl, "\n")))
  self.lab_TipStoneLightAdditional:SetText(string.format(colorStr, ClientTable.cfg_Global_globalManager:TryGetValue(64000007).effect, table.concat(deputyStrTbl, "\n")))
  local sourceStr = "\227\128\144" .. ClientTable.cfg_Item_tipsManager:TryGetValue(data.sourceTips).content .. "\227\128\145"
  local decomposeTable = string.split(ClientTable.cfg_puzzle_decomposeManager:TryGetValue(serverData.itemId).decompose, "#")
  local decomposeStr = ClientTable.cfg_Ui_wordManager:TryGetValue("CrystalNucleus_1").content .. ": " .. ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(decomposeTable[1])).name .. "*" .. decomposeTable[2]
  local decomposeLevelStr
  if serverData.nucleusLevel > 0 then
    local ratio = ClientTable.cfg_puzzle_growupManager:GetItemDataLevelIDReturnRatio(serverData.nucleusLevel, serverData.itemId)
    local materialName, materialCount = ClientTable.cfg_puzzle_growupManager:GetItemDataLevelIDMaterial(serverData.nucleusLevel, serverData.itemId)
    decomposeLevelStr = ClientTable.cfg_Ui_wordManager:TryGetValue("CrystalNucleus_2").content .. ": " .. ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(materialName)).name .. "*" .. tostring(Mathf.Floor(materialCount * ratio))
  end
  if decomposeLevelStr ~= nil then
    self.lab_TipItemTips:SetText(sourceStr .. "\n" .. decomposeStr .. "\n" .. decomposeLevelStr)
  else
    self.lab_TipItemTips:SetText(sourceStr .. "\n" .. decomposeStr)
  end
  self.Img_TipBg.transform.localPosition = Vector3(210, 449, -700)
  local centerBgWidth, _ = self.img_centerBg:GetSizeDelta()
  if UIManager.IsVisible(UIID.MailUI) or UIManager.IsVisible(UIID.Tip_SeaChestReward) then
    self.go_btns:SetActive(false)
    self.img_centerBg:SetSizeDelta(centerBgWidth, 545)
  else
    self.go_btns:SetActive(true)
    self.btn_LeftClick:SetOnClick(self, function()
      EventManager.Dispatch(Event.JumpToCrystalNucleusDecomposition)
      UIManager.Hide(UIID.Tip_CrystalNucleusUI)
    end)
    self.btn_RightClick:SetOnClick(self, function()
      UIManager.Hide(UIID.Tip_CrystalNucleusUI)
    end)
    self.img_centerBg:SetSizeDelta(centerBgWidth, 630)
  end
end

function Tip_CrystalNucleusUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
end

function Tip_CrystalNucleusUI:btn_CloseOnClick(control)
  UIManager.Hide(UIID.Tip_CrystalNucleusUI)
end

function Tip_CrystalNucleusUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_CrystalNucleusUI:RegistEvents()
end

function Tip_CrystalNucleusUI:Refresh()
  if self.args and self.args.type == 1 then
    self:ShowTips(self.args.data)
  end
end

function Tip_CrystalNucleusUI:OnHide()
  self.go_btns:SetActive(false)
end

function Tip_CrystalNucleusUI:OnDestroy()
end
