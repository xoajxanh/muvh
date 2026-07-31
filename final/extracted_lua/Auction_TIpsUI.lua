Auction_TIpsUI = class(BaseUI)
Auction_TIpsUI.layer = UILayer.Background
Auction_TIpsUI.orderInLayer = 2
Auction_TIpsUI.hideType = UIHideType.Hide
Auction_TIpsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Auction_TIpsUI.escClose = UIEscClose.DontClose

function Auction_TIpsUI:InitControls()
  self.BG = self:GetControl("BG")
  self.btn_3DItem = self:GetControl("BG/img_Bg/btn_3DItem")
  self.lab_name = self:GetControl("BG/img_Bg/btn_3DItem/lab_name")
  self.lab_num = self:GetControl("BG/img_Bg/btn_3DItem/lab_num")
  self.MyName = self:GetControl("BG/img_Bg/btn_3DItem/MyName")
  self.lab_equiptips = self:GetControl("BG/lab_equiptips")
  self.btn_quickAuction = self:GetControl("BG/btn_quickAuction")
  self.lab_quickAuction = self:GetControl("BG/btn_quickAuction/lab_quickAuction")
  self.btn_close = self:GetControl("BG/btn_close")
end

function Auction_TIpsUI:OnPreLoad()
end

function Auction_TIpsUI:Init()
  self.EquipInfo = {
    Auction = {},
    GoleBoxorOther = {}
  }
  self.showCellData = ItemCellData()
end

function Auction_TIpsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Auction_TIpsUI:InitUI()
  self.BG_pos = self.BG.transform.localPosition
end

function Auction_TIpsUI:OnShow()
  if SceneData.mapId and SceneData.mapId == 1095 then
    UIManager.Hide(UIID.AuctionTIpsUI)
    return
  end
  self:RegistEvents()
  local main = UIManager.GetUiByName(UIID.MainMenuUI)
  if main then
    if main.state then
      self.BG.transform.localPosition = self.BG_pos
    else
      self.BG.transform.localPosition = Vector3.New(self.BG_pos.x, self.BG_pos.y - 500, self.BG_pos.z)
    end
  else
    self.BG.transform.localPosition = self.BG_pos
  end
  self:SetBoxInfo()
  self:ShowData()
end

local function sort(Info, self)
  for i, v in pairs(Info) do
    if v.Condition and tonumber(v.Condition[1]) == TipFastUse.Other then
      table.insert(self.EquipInfo.GoleBoxorOther, v)
      self:CalculateCount()
    elseif v.tblEquip and v.tblItem.auction ~= "" then
      table.insert(self.EquipInfo.Auction, v)
    else
      table.insert(self.EquipInfo.GoleBoxorOther, v)
      self:CalculateCount()
    end
  end
end

function Auction_TIpsUI:ShowData()
  if table.count(self.args.ItemInfo) ~= 0 then
    sort(self.args.ItemInfo, self)
  elseif self.ShowItem ~= nil then
    sort({
      self.ShowItem
    }, self)
  else
    self:btn_closeOnClick()
    return
  end
  self:Refresh()
end

function Auction_TIpsUI:IsAddData(data)
  local Auction = self.EquipInfo.Auction
  local GoleBoxorOther = self.EquipInfo.GoleBoxorOther
  local acc = 0
  for k = 1, #data do
    k = k + acc
    if self.ShowItem and data[k].id == self.ShowItem.id then
      table.remove(data, k)
      acc = acc - 1
    else
      local noreturn = true
      for i, v in pairs(GoleBoxorOther) do
        if data[k].id == v.id then
          table.remove(data, k)
          acc = acc - 1
          noreturn = false
          break
        end
      end
      if noreturn then
        for i, v in pairs(Auction) do
          if data[k].id == v.id then
            table.remove(data, k)
            acc = acc - 1
            break
          end
        end
      end
    end
  end
end

function Auction_TIpsUI:UpLInsertData(items)
  self.EquipInfo = {
    Auction = {},
    GoleBoxorOther = {}
  }
  self:IsAddData(items)
  sort(items, self)
end

function Auction_TIpsUI:InsertData(items)
  self:IsAddData({items})
  self:SetBoxInfo(items)
  sort({items}, self)
end

function Auction_TIpsUI:CalculateCount()
  local count = 1
  if self.ShowItem then
    if self.ShowItem.params and self.ShowItem.params[1] == "31" then
      count = BagInfoData.GetItemCountByItemConfigId(self.ShowItem.itemId)
    elseif self.ShowItem.Condition and tonumber(self.ShowItem.Condition[1]) == TipFastUse.Other then
      count = BagInfoData.GetItemCountByItemConfigId(self.ShowItem.itemId)
    else
      for i, v in pairs(self.EquipInfo.Auction) do
        if self.ShowItem.itemId == v.itemId then
          count = count + 1
        end
      end
      for i, v in pairs(self.EquipInfo.GoleBoxorOther) do
        if self.ShowItem.itemId == v.itemId then
          count = count + 1
        end
      end
      if self.ShowItem and self.ShowItem.tblItem and self.ShowItem.tblItem.type == 5 then
        count = self.BoxInfo[self.ShowItem.itemId].count
      end
    end
  end
  if self.ShowItem and self.ShowItem.itemId and self.ShowItem.itemId == 3003001 then
    count = BagInfoData.GetItemTotalCountByItemId(self.ShowItem.itemId)
  end
  self.ShowCount = count
  if self.ShowCount == 0 then
    self:btn_closeOnClick()
  else
    self.lab_num:SetActive(true)
    self.lab_num:SetText(self.ShowCount)
  end
end

function Auction_TIpsUI:OnHide()
  self.showCellData:RecycleRes()
  self.args.ItemInfo = {}
  self.EquipInfo = {
    Auction = {},
    GoleBoxorOther = {}
  }
  self.ShowCount = 0
  self.BoxInfo = nil
  self.ShowItem = nil
end

function Auction_TIpsUI:OnDestroy()
  if self.showCellData then
    self.showCellData:RecycleRes()
    self.showCellData = nil
  end
end

function Auction_TIpsUI:Update()
  if self.showCellData and self.showCellData.model then
    if self.ShowCount then
      self.lab_num:SetText(self.ShowCount)
    end
    local obj = self.showCellData.model.modelObject
    RoleEquipUtility.EquipModelRotation(obj, self.showCellData.itemData.tblItem.SpinAxis, 2)
  end
end

function Auction_TIpsUI:RegistUIEvents()
  self.btn_quickAuction:SetOnClick(self, self.btn_quickAuctionOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Auction_TIpsUI:btn_quickAuctionOnClick(control)
  if self.ShowItem == nil then
    self:btn_closeOnClick()
    return
  end
  if self.ShowItem.itemId == 53090004 then
    self.btn_quickAuction:SetClickInterval(1)
  end
  if self.ShowItem.tblItem ~= nil and self.ShowItem.tblItem.subType == 21 then
    local isNeedUse, isStrengthenItem, illusionId = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():IsNeedUsePopPrompt(self.ShowItem.tblItem.id)
    if illusionId then
      local useItemTbl = {
        useCount = 1,
        useItemId = self.ShowItem.id,
        configId = self.ShowItem.itemId,
        useParam = self.ShowItem.tblItem.useParam,
        useParamExtend = self.ShowItem.tblItem.useParamExtend,
        itemInfo = self.ShowItem,
        params = nil
      }
      ItemUtility.UseItem(useItemTbl)
      UIManager.JumpShow(UIPanelType.SortAndHide, UIID.AppearBagInfoUI, {togIndex = 4})
      UIManager.Hide(UIID.AuctionTIpsUI)
      return
    end
    if isStrengthenItem then
      BagInfoController.UseItemReq(1, self.ShowItem.id)
      UIManager.Hide(UIID.AuctionTIpsUI)
      return
    end
    UIManager.Show(UIID.Equip_GuardNavUI)
    UIManager.Hide(UIID.AuctionTIpsUI)
    return
  end
  if self.ShowItem.tblEquip and self.ShowItem.tblItem.auction ~= "" then
    UIManager.Show(UIID.Auction_AuctionUI, {
      itemData = self.ShowItem
    })
    self.EquipInfo.Auction = {}
    TipData.RecommendRecord()
  elseif self.ShowItem.params and self.ShowItem.params[1] == "10" then
    local uiLogicTbl = ClientTable.cfg_Ui_logicManager:TryGetValue(tonumber(self.ShowItem.params[2]), "id")
    local argsStr = string.split(self.ShowItem.tblItem.useParamExtend, "=")
    local args
    if table.count(argsStr) > 0 then
      if argsStr[1] == "itemID" then
        args = {
          count = self.ShowItem.tblItem.useCount,
          itemId = self.ShowItem.tblItem.useItemId
        }
      else
        args = {
          [argsStr[1]] = argsStr[2]
        }
      end
    end
    if self.ShowItem and self.ShowItem.itemId and self.ShowItem.itemId == 3003001 then
      self:btn_closeOnClick()
      UIManager.JumpShow(UIPanelType.SortAndHide, uiLogicTbl.mainUI, args)
      return
    end
    UIManager.JumpShow(UIPanelType.SortAndHide, uiLogicTbl.mainUI, args)
    self:btn_closeOnClick()
  elseif self.ShowItem.params and tonumber(self.ShowItem.params[1]) == ItemUseType.FindNpc and 1 < table.count(self.ShowItem.params) then
    UIManager.UICloseType(UIPanelType.SortAndHide, true)
    local transferId = tonumber(self.ShowItem.params[2])
    local npcId = 2 < table.count(self.ShowItem.params) and tonumber(self.ShowItem.params[3]) or nil
    local promptId = table.count(self.ShowItem.params) > 3 and tonumber(self.ShowItem.params[4]) or nil
    local promptTbl
    if promptId then
      promptTbl = ClientTable.cfg_Ui_promptwordManager:TryGetValue(promptId)
    end
    if promptTbl then
      TipUtility.QuickShowPrompt({
        id = promptId,
        okArgs = {
          transferId = transferId,
          npcId = npcId,
          itemId = self.ShowItem.configId
        }
      })
    else
      PathFinderManager.FlyTransferScene(transferId, nil, {
        npcId = npcId,
        itemId = self.ShowItem.configId
      }, npcId ~= nil and npcId ~= 0 and Purpose.ClickNpc or Purpose.None)
    end
    self:btn_closeOnClick()
  elseif self.ShowItem.params and self.ShowItem.params[1] == "31" then
    UIManager.Show(UIID.Item_ChooseBoxUI, {
      boxId = tonumber(self.ShowItem.params[2]),
      itemInfo = self.ShowItem
    })
    self:OnBagChange(nil, {
      removeItems = {
        {
          id = self.ShowItem.id
        }
      },
      logType = BagChangeTypeEnum.Recycle
    })
  elseif self.ShowItem.params and self.ShowItem.params[1] == "93" then
    local useItemTbl = {
      useCount = 1,
      useItemId = self.ShowItem.id,
      configId = self.ShowItem.itemId,
      useParam = self.ShowItem.tblItem.useParam,
      useParamExtend = "",
      itemInfo = self.ShowItem,
      params = nil
    }
    ItemUtility.UseItem(useItemTbl)
    UIManager.Hide(UIID.AuctionTIpsUI)
  else
    MeController.UpdateClientItemCd(self.ShowItem.itemId)
    if self.ShowItem.Condition and tonumber(self.ShowItem.Condition[1]) == TipFastUse.Other and TipData.UpExpProp[self.ShowItem.itemId] then
      TipData.UseExpProp(self.ShowItem.id, self.ShowItem.itemId, self.ShowCount)
    end
    local params = self.ShowItem.params
    if #self.ShowItem.params == 1 and self.ShowItem.params[1] == "8" then
      params = nil
    end
    local bagidcount = BagInfoData.GetItemCountById(self.ShowItem.id)
    if bagidcount == 0 then
      self:btn_closeOnClick()
      return
    end
    local UseCount = bagidcount < self.ShowCount and bagidcount or self.ShowCount
    if self.ShowItem ~= nil and self.ShowItem.itemId ~= nil and (self.ShowItem.itemId == 3004001 or self.ShowItem.itemId == 3004002 or self.ShowItem.itemId == 3004003 or self.ShowItem.itemId == 3004004) then
      BagInfoController.UseItemReq(1, self.ShowItem.id, params, self.ShowItem.itemId)
    else
      BagInfoController.UseItemReq(UseCount, self.ShowItem.id, params, self.ShowItem.itemId)
    end
    if self.ShowItem.params and self.ShowItem.params[1] == "30" then
      TaskManager.SetTaskPickUpDrop()
    end
  end
end

function Auction_TIpsUI:btn_closeOnClick(control)
  if self.ShowItem == nil then
    UIManager.Hide(UIID.AuctionTIpsUI)
    TipData.OpenNextUI()
    return
  end
  if control or self.ShowItem.itemId == 3003001 then
    if self.ShowItem.tblEquip and self.ShowItem.tblItem.auction ~= "" then
      self.EquipInfo.Auction = {}
      TipData.RecommendRecord()
    end
    if self.ShowItem.Condition then
      TipData.BagChangeRefrsh(self.ShowItem.id)
      local GoleBoxorOther = self.EquipInfo.GoleBoxorOther
      local acc = 0
      for k = 1, #GoleBoxorOther do
        k = k + acc
        if self.EquipInfo.GoleBoxorOther[k] and self.EquipInfo.GoleBoxorOther[k].itemId == self.ShowItem.itemId then
          table.remove(self.EquipInfo.GoleBoxorOther, k)
          acc = acc - 1
        end
      end
    end
  end
  if #self.EquipInfo.Auction ~= 0 or #self.EquipInfo.GoleBoxorOther ~= 0 then
    self:Refresh()
  else
    UIManager.Hide(UIID.AuctionTIpsUI)
    TipData.OpenNextUI()
  end
end

function Auction_TIpsUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.TipsMainUIPosChange, self.TipsMainUIPosChange, self)
  self:RegistEvent(Event.NewMasterSkillExpExchangeUIHide, self.NewMasterSkillExpExchangeUIHideCallBack, self)
  self:RegistEvent(Event.HideQuickUseWindow, self.HideThisUI, self)
  self:RegistEvent(Event.RefreshQuickUseOnlyId, self.RefreshQuickUseOnlyBoxId, self)
end

function Auction_TIpsUI:HideThisUI()
  UIManager.Hide(UIID.AuctionTIpsUI)
end

function Auction_TIpsUI:NewMasterSkillExpExchangeUIHideCallBack()
  if self.ShowItem and self.ShowItem.itemId and self.ShowItem.itemId == 3003001 then
    self:btn_closeOnClick()
  end
end

function Auction_TIpsUI:OnBagChange(_, msg)
  if msg then
    local showId = false
    local showremove = false
    if table.count(msg.removeItems) ~= 0 and TipData.bageChangeType(msg) then
      for i, v in pairs(msg.removeItems) do
        local id = v.id
        local ExpendsCount = v.count
        TipData.BagChangeCountRefrsh(v.id, ExpendsCount)
        local Auction = self.EquipInfo.Auction
        local auc = true
        local acc = 0
        local acccount = 0
        if self.ShowItem and id == self.ShowItem.id then
          showId = true
          showremove = true
          acccount = acccount + 1
        end
        for k = 1, #Auction do
          k = k + acc
          if self.EquipInfo.Auction[k].id == id then
            if acccount == ExpendsCount then
              break
            end
            acccount = acccount + 1
            table.remove(self.EquipInfo.Auction, k)
            acc = acc - 1
            auc = false
          end
        end
        if auc then
          local GoleBoxorOther = self.EquipInfo.GoleBoxorOther
          if self.BoxInfo and self.BoxInfo[v.itemId] then
            self.BoxInfo[v.itemId].count = self.BoxInfo[v.itemId].count - ExpendsCount
          end
          for k = 1, #GoleBoxorOther do
            k = k + acc
            if self.EquipInfo.GoleBoxorOther[k].id == id then
              if acccount == ExpendsCount then
                break
              end
              acccount = acccount + 1
              table.remove(self.EquipInfo.GoleBoxorOther, k)
              acc = acc - 1
            end
          end
        end
      end
    end
    if table.count(msg.TruereduceTbl) ~= 0 and TipData.bageChangeType(msg) then
      for i, v in pairs(msg.TruereduceTbl) do
        local id = v.id
        local acccount = 0
        local ExpendsCount = v.count
        TipData.BagChangeCountRefrsh(v.id, ExpendsCount)
        if self.ShowItem and id == self.ShowItem.id then
          showId = true
          if not showremove then
            acccount = acccount + 1
          end
        end
        local Auction = self.EquipInfo.Auction
        local auc = true
        local acc = 0
        for k = 1, #Auction do
          k = k + acc
          if self.EquipInfo.Auction[k].id == id then
            if acccount == ExpendsCount then
              break
            end
            acccount = acccount + 1
            table.remove(self.EquipInfo.Auction, k)
            auc = false
            acc = acc - 1
          end
        end
        if auc then
          local GoleBoxorOther = self.EquipInfo.GoleBoxorOther
          if self.BoxInfo and self.BoxInfo[v.itemId] then
            self.BoxInfo[v.itemId].count = self.BoxInfo[v.itemId].count - ExpendsCount
          end
          for k = 1, #GoleBoxorOther do
            k = k + acc
            if self.EquipInfo.GoleBoxorOther[k].id == id then
              if acccount == ExpendsCount then
                break
              end
              acccount = acccount + 1
              table.remove(self.EquipInfo.GoleBoxorOther, k)
              acc = acc - 1
            end
          end
        end
      end
    end
    if showId then
      self:btn_closeOnClick()
    end
  end
end

function Auction_TIpsUI:TipsMainUIPosChange(_, state)
  local animalTime = C_UISettings.MainMenuUITime
  local distance = C_UISettings.MainUIDistance
  if state then
    self.BG.transform:DOLocalMove(self.BG_pos, animalTime):SetEase(Ease.OutQuad)
  else
    self.BG.transform:DOLocalMove(self.BG_pos + Vector3.New(0, -distance - 500, 0), animalTime):SetEase(Ease.OutQuad)
  end
end

local function AuctionFun(self)
  local aucount = #self.EquipInfo.Auction
  if aucount ~= 0 then
    if #AuctionData.AutoRackTable < 3 then
      self.ShowItem = self.EquipInfo.Auction[1]
      return 1
    else
      self.EquipInfo.Auction = {}
      return 2
    end
  end
  return 3
end

function Auction_TIpsUI:SetBoxInfo(info)
  self.BoxInfo = self.BoxInfo or {}
  if not info and table.count(self.args.ItemInfo) ~= 0 then
    for i, v in pairs(self.args.ItemInfo) do
      if v.tblItem and v.tblItem.type == 5 then
        if table.count(self.BoxInfo) == 0 or self.BoxInfo[v.itemId] == nil then
          self.BoxInfo[v.itemId] = {count = 1}
        elseif self.BoxInfo[v.itemId] then
          self.BoxInfo[v.itemId].count = self.BoxInfo[v.itemId].count + 1
        end
      end
    end
  elseif info and info.tblItem and info.tblItem.type == 5 then
    if table.count(self.BoxInfo) == 0 or not self.BoxInfo[info.itemId] then
      self.BoxInfo[info.itemId] = {count = 1}
    else
      self.BoxInfo[info.itemId].count = self.BoxInfo[info.itemId].count + 1
    end
  end
end

function Auction_TIpsUI:Refresh()
  local isbox = false
  local stack = AuctionFun(self)
  if stack == 2 then
    self:btn_closeOnClick()
    return
  elseif stack == 3 then
    self.ShowItem = self.EquipInfo.GoleBoxorOther[1]
    if self.ShowItem.tblItem and self.ShowItem.tblItem.type == 5 and self.ShowCount > 0 then
      local info = table.DeepCopy(BagInfoData.GetTotalBag())
      for i, v in pairs(info) do
        if v.itemId == self.ShowItem.itemId then
          v.Condition = self.ShowItem.Condition
          v.params = self.ShowItem.params
          self.ShowItem = v
        end
      end
    end
    isbox = true
  end
  if self.BoxInfo and self.ShowCount <= 0 then
    self:OnHide()
  end
  if self.ShowItem == nil then
    self.EquipInfo = {
      Auction = {},
      GoleBoxorOther = {}
    }
    self:btn_closeOnClick()
    return
  end
  self.showCellData:RefreshData(self.ShowItem)
  if isbox then
    table.remove(self.EquipInfo.GoleBoxorOther, 1)
    self.lab_quickAuction:SetText("D\195\185ng ngay")
  else
    table.remove(self.EquipInfo.Auction, 1)
    self.lab_quickAuction:SetText("L\195\170n k\225\187\135 ngay")
  end
  self:RefreshShow()
end

function Auction_TIpsUI:RefreshShow()
  ItemUtility.ShowItemCell(self.btn_3DItem, self.showCellData, self, true)
  local textWidth = self.lab_name.text.preferredWidth
  local bgWith = self.lab_name:GetSizeDelta()
  if textWidth > bgWith then
    local text = string.GetColorText(self.ShowItem.tblItem.name, ItemQuality2ColorDic[self.ShowItem.tblItem.colorShow])
    self.MyName.transform:GetComponent("AutoScrollText").text = text
    self.lab_name:SetActive(false)
    self.MyName:SetActive(true)
  else
    self.lab_name:SetActive(true)
    self.MyName:SetActive(false)
  end
  if self.ShowItem.tblEquip and self.ShowItem.tblItem.auction ~= "" then
    self.lab_num:SetActive(false)
  else
    self:CalculateCount()
  end
end

function Auction_TIpsUI:PushStackData()
  if self.ShowItem ~= nil then
    if self.ShowItem.tblEquip and self.ShowItem.tblItem.auction ~= "" then
      table.insert(self.EquipInfo.Auction, self.ShowItem)
    else
      table.insert(self.EquipInfo.GoleBoxorOther, self.ShowItem)
    end
  end
  self:CheckSaveBoxInfo(self.EquipInfo.GoleBoxorOther)
  local savedata = table.combine(self.EquipInfo.Auction, self.EquipInfo.GoleBoxorOther)
  TipData.CloseItemData(TipShowSort.auction)
  for i, v in pairs(savedata) do
    TipData.PopUpData(TipShowSort.auction, v)
  end
  self.EquipInfo = {
    Auction = {},
    GoleBoxorOther = {}
  }
  UIManager.Hide(UIID.AuctionTIpsUI)
  TipData.OpenNextUI()
end

function Auction_TIpsUI:CheckSaveBoxInfo(boxInfo)
  local count = 0
  local itemInfo = {}
  local removeIndex = {}
  for i = 1, table.count(boxInfo) do
    if boxInfo[i].itemId == self.ShowItem.itemId and boxInfo[i].tblItem.type == 5 then
      count = count + 1
      if not itemInfo[boxInfo[i].itemId] then
        itemInfo[boxInfo[i].itemId] = {count = 1}
      else
        itemInfo[boxInfo[i].itemId].count = itemInfo[boxInfo[i].itemId].count + 1
      end
      if count > self.ShowCount then
        table.insert(removeIndex, i)
      end
    end
  end
  if 0 < table.count(removeIndex) then
    for i, v in pairs(removeIndex) do
      table.remove(self.EquipInfo.GoleBoxorOther, v)
    end
  end
  if itemInfo[self.ShowItem.itemId] and itemInfo[self.ShowItem.itemId].count < self.ShowCount then
    self.EquipInfo.GoleBoxorOther = {}
  end
end
