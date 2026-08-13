Role_ResurgenceUI = class(BaseUI)
Role_ResurgenceUI.layer = UILayer.Prompt
Role_ResurgenceUI.orderInLayer = 6
Role_ResurgenceUI.hideType = UIHideType.WaitDestroy
Role_ResurgenceUI.hideFunc = UIHideFunc.MoveOutOfScreen
Role_ResurgenceUI.escClose = UIEscClose.DontClose

function Role_ResurgenceUI:InitControls()
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Image_TipBg = self:GetControl("Panel_Tip/Image_TipBg")
  self.ButtonContent = self:GetControl("Panel_Tip/Image_TipBg/ButtonContent")
  self.Button_1 = self:GetControl("Panel_Tip/Image_TipBg/ButtonContent/Button_1")
  self.Text_1 = self:GetControl("Panel_Tip/Image_TipBg/ButtonContent/Button_1/Text_1")
  self.num_1 = self:GetControl("Panel_Tip/Image_TipBg/ButtonContent/Button_1/num_1")
  self.Button_2 = self:GetControl("Panel_Tip/Image_TipBg/ButtonContent/Button_2")
  self.Text_2 = self:GetControl("Panel_Tip/Image_TipBg/ButtonContent/Button_2/Text_2")
  self.Button_3 = self:GetControl("Panel_Tip/Image_TipBg/ButtonContent/Button_3")
  self.Text_3 = self:GetControl("Panel_Tip/Image_TipBg/ButtonContent/Button_3/Text_3")
  self.Text_TipContent = self:GetControl("Panel_Tip/Image_TipBg/Text_TipContent")
  self.Text_TipTitle = self:GetControl("Panel_Tip/Image_TipBg/Text_TipTitle")
  self.Image_ItemBg = self:GetControl("Panel_Tip/Image_ItemBg")
  self.Button_Cance = self:GetControl("Panel_Tip/Image_ItemBg/Button_Cance")
  self.Button_Ok = self:GetControl("Panel_Tip/Image_ItemBg/Button_Ok")
  self.Text_OK = self:GetControl("Panel_Tip/Image_ItemBg/Button_Ok/Text_OK")
  self.needItem = self:GetControl("Panel_Tip/Image_ItemBg/needItem")
  self.btn_needGold = self:GetControl("Panel_Tip/Image_ItemBg/btn_needGold")
  self.lab_num = self:GetControl("Panel_Tip/Image_ItemBg/btn_needGold/lab_num")
end

local resurageGoldId = 7020002

function Role_ResurgenceUI:Init()
  self.goldId = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(resurageGoldId))
  self.resurageGoldTbl = ClientTable.cfg_Item_buyManager:TryGetValue(self.goldId)
  self.costTbl = ParseUtility.ParseSingleCost(self.resurageGoldTbl.cost)
  self.needTbl = ParseUtility.ParseSingleCost(self.resurageGoldTbl.reward)
  self.clickButton_2State = nil
end

function Role_ResurgenceUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:InitData()
  self:RegistUIEvents()
end

function Role_ResurgenceUI:InitUI()
  self.btn_needGold.itemCellData = ItemCellData()
  self.num_1:SetActive(true)
  self.num_1:SetText("")
end

function Role_ResurgenceUI:InitData()
  local space = self.ButtonContent.layoutGroup.spacing
  self.spaceGroup = {
    [0] = space,
    [1] = space,
    [2] = {x = 20, y = 0}
  }
  self.textCtrGroup = {
    [1] = self.Text_1,
    [2] = self.Text_3
  }
end

function Role_ResurgenceUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:SetDeadText()
end

function Role_ResurgenceUI:OnHide()
  if self.countdownRelive then
    Timer.Stop(self.countdownRelive)
    self.countdownRelive = nil
  end
  HPData.killName = ""
  HPData.unionName = ""
  HPData.mapName = ""
  self.clickButton_2State = nil
  self:ResetUI()
  self:ReleaseModel()
end

function Role_ResurgenceUI:OnDestroy()
end

function Role_ResurgenceUI:RegistUIEvents()
  self.Button_1:SetOnClick(self, self.Button_1OnClick)
  self.Button_2:SetOnClick(self, self.Button_2OnClick)
  self.Button_3:SetOnClick(self, self.Button_3OnClick)
  self.Button_Cance:SetOnClick(self, self.Button_CanceOnClick)
  self.Button_Ok:SetOnClick(self, self.Button_OkOnClick)
end

function Role_ResurgenceUI:Button_1OnClick(control)
  if Activity_LuoLanSiegeData.IsActivityOpen() then
    MeController.ReqReqRelive(RoleReliveType.LuoLanXiaGu)
  elseif TranScriptData.IsInRefineTow() then
    MeController.ReqReqRelive(RoleReliveType.RefineTower)
  elseif TranScriptData.IsOpenKaLunTeResultTipUIByDead() then
    TranScriptController.ReqExitInstance()
  elseif ClientTable.cfg_Map_instanceManager:TryGetTypeByMapId(SceneData.mapId) == TranScriptData.TranScriptSubType.HolyRingBoss then
    MeController.ReqReqRelive(RoleReliveType.ReliveAndExit)
  elseif TranScriptData.IsInRefineKSBattle() then
    MeController.ReqReqRelive(self.isZeroReliveTime and RoleReliveType.KSBattleTimeEnd or RoleReliveType.KSBattle)
  elseif FourPartyRivalryManager:IsEnterFourPartyRivalryMap() then
    MeController.ReqReqRelive(RoleReliveType.FourPartyRivalryFree)
  else
    MeController.ReqReqRelive(RoleReliveType.BornPoint)
  end
  TranScriptData.InAllGodCloseBtn = true
  UIManager.Hide(UIID.Role_ResurgenceUI)
  TipUtility.GetSessionTips()
  RiskSpotManager.RiskSpotPlaceType(RiskSpotType.FreeResurrection)
  self.isZeroReliveTime = false
end

function Role_ResurgenceUI:Button_2OnClick(control)
  if QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() == true and QuickFind:GetDuoQiCrossDataManager():GetCanReliveTime() ~= nil then
    local str = QuickFind:GetDuoQiCrossDataManager():GetReliveTip()
    local canReliveTime = QuickFind:GetDuoQiCrossDataManager():GetCanReliveTime()
    if string.isNullOrEmpty(str) == true then
      return
    end
    local num, _ = math.modf(canReliveTime)
    local showStr = string.format(str, tostring(num))
    if showStr == nil then
      return
    end
    FloatingTipUtility.QuickMsg(showStr)
    return
  end
  self.clickButton_2State = true
  if Activity_LuoLanSiegeData.IsActivityOpen() then
    local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Gongchengzhan_1")
    self:Tips(content)
    return
  end
  local bagdata = BagInfoData.GetItemTotalCountByItemId(self.needTbl.itemId)
  if 0 < bagdata then
    if FourPartyRivalryManager:IsEnterFourPartyRivalryMap() then
      MeController.ReqReqRelive(RoleReliveType.FourPartyRivalryPay)
    else
      MeController.ReqReqRelive(RoleReliveType.Here)
    end
    UIManager.Hide(UIID.Role_ResurgenceUI)
  else
    self.Image_ItemBg:SetActive(true)
    self.Image_TipBg:SetActive(false)
    self:RefreshItemBg()
  end
end

function Role_ResurgenceUI:Button_3OnClick(control)
  self.clickButton_2State = false
  local bagdata = BagInfoData.GetItemTotalCountByItemId(self.needTbl.itemId)
  if 0 < bagdata then
    MeController.ReqReqRelive(RoleReliveType.CostBornPoint)
    UIManager.Hide(UIID.Role_ResurgenceUI)
  else
    self.Image_ItemBg:SetActive(true)
    self.Image_TipBg:SetActive(false)
    self:RefreshItemBg()
  end
end

function Role_ResurgenceUI:Button_CanceOnClick(control)
  self.clickButton_2State = nil
  self.Image_ItemBg:SetActive(false)
  self.Image_TipBg:SetActive(true)
end

function Role_ResurgenceUI:Button_OkOnClick(control)
  if BagInfoData.GetItemTotalCountByItemId(self.costTbl.itemId) < self.costTbl.count then
    local tipStr = LocalizationUtility.GetContentByKey("huobibuzu")
    FloatingWordUtility.QuickMsg(tipStr)
    RechargeData.BuyDiamond()
    return
  end
  NetManager.Send(ItemBuyMessage.ReqBuy, {
    goodId = self.goldId,
    buyCount = 1
  })
  self.Image_ItemBg:SetActive(false)
  TranScriptData.InAllGodCloseBtn = true
  EventManager.Dispatch(Event.DisabledCloseBtn)
end

function Role_ResurgenceUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.Bag_ResBagChange, self)
  self:RegistEvent(Event.Relive, self.OnRelive, self)
  self:RegistEvent(Event.Bag_CoinChanged, self.OnCoinChanged, self)
  self:RegistEvent(Event.DieBuyRelive, self.OnDieBuyRelive, self)
end

function Role_ResurgenceUI:OnDieBuyRelive(_, msg)
  if self.clickButton_2State ~= nil then
    if self.clickButton_2State then
      if FourPartyRivalryManager:IsEnterFourPartyRivalryMap() then
        MeController.ReqReqRelive(RoleReliveType.FourPartyRivalryPay)
      else
        MeController.ReqReqRelive(RoleReliveType.Here)
      end
      UIManager.Hide(UIID.Role_ResurgenceUI)
    else
      MeController.ReqReqRelive(RoleReliveType.CostBornPoint)
      UIManager.Hide(UIID.Role_ResurgenceUI)
    end
  end
end

function Role_ResurgenceUI:Bag_ResBagChange(_, msg)
  if self.clickButton_2State ~= nil and msg.showItems then
    for _, itemInfo in pairs(msg.showItems) do
      if itemInfo.itemId == self.needTbl.itemId then
        if self.clickButton_2State then
          self:Button_2OnClick()
          break
        end
        self:Button_3OnClick()
        break
      end
    end
  end
end

function Role_ResurgenceUI:ResetUI()
  self.Image_ItemBg:SetActive(false)
  self.Image_TipBg:SetActive(true)
  self.num_1:SetText("")
end

function Role_ResurgenceUI:OnRelive(_, msg)
  if msg.lid == ViewData.meData.id then
    UIManager.Hide(self.name)
  end
end

function Role_ResurgenceUI:SetDeadText()
  self.Text_TipContent:SetText("B\225\186\161n \196\145\195\163 t\225\187\173 vong, c\195\179 h\225\187\147i sinh ngay kh\195\180ng")
  if string.isNullOrEmpty(HPData.killName) then
    return
  end
  if not string.isNullOrEmpty(HPData.unionName) then
    HPData.unionName = "[" .. HPData.unionName .. "]"
  end
  if TranScriptData.IsInRefineKSBattle() then
    self:RefreshKSBattleContentText(1)
  else
    local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Character_death1")
    self.Text_TipContent:SetText(string.format(content, HPData.mapName, HPData.unionName, HPData.killName))
  end
end

function Role_ResurgenceUI:OnCoinChanged()
  if BagInfoData.GetItemTotalCountByItemId(self.costTbl.itemId) >= self.costTbl.count then
    self.lab_num:SetText(self.costTbl.count)
  end
end

function Role_ResurgenceUI:Refresh()
  if Activity_LuoLanSiegeData.IsActivityOpen() or TranScriptData.IsInRefineKSBattle() or TranScriptData.IsInPersonBossBattle() then
    self.Button_2:SetActive(false)
  else
    self.Button_2:SetActive(true)
  end
  local cfg_Map = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
  local needShow = ViewData.meData.hp <= 0 and string.isNullOrEmpty(cfg_Map.relivePanel) == false
  if not needShow then
    UIManager.Hide(self.name)
    return
  end
  local nameTbl = string.split(cfg_Map.relivePanel, "#")
  local btnNum = table.count(nameTbl)
  if btnNum <= 0 then
    self.Button_1:SetActive(false)
    self.Button_3:SetActive(false)
  elseif btnNum <= 1 then
    self.Button_1:SetActive(true)
    self.Button_3:SetActive(false)
    self:RefreshBtn(nameTbl)
    self:TryRefreshBtnByKLT()
    self:StartCountdownRelive(self.Text_1:GetText())
  elseif btnNum <= 2 then
    self.Button_1:SetActive(true)
    self.Button_3:SetActive(true)
    self:RefreshBtn(nameTbl)
  end
  self.ButtonContent.layoutGroup.spacing = self.spaceGroup[btnNum]
  TranScriptData.InAllGodCloseBtn = false
  EventManager.Dispatch(Event.DisabledCloseBtn)
end

function Role_ResurgenceUI:RefreshBtn(nameTbl)
  for i, name in ipairs(nameTbl) do
    self.textCtrGroup[i]:SetText(name)
  end
end

function Role_ResurgenceUI:TryRefreshBtnByKLT()
  if TranScriptData.InTranscriptType == TranScriptType.KalunteRuins then
    local canReliveCount = TranScriptData.InTranscriptData.canReliveCount
    if canReliveCount then
      local numText = "L\198\176\225\187\163t mi\225\187\133n ph\195\173:"
      if canReliveCount < 1 then
        numText = numText .. string.GetColorText(canReliveCount, ItemQuality2ColorDic[7])
        self.Text_1:SetText("Tho\195\161t")
      else
        numText = numText .. string.GetColorText(canReliveCount, ItemQuality2ColorDic[5])
      end
      self.num_1:SetText(numText)
    end
  end
end

function Role_ResurgenceUI:RefreshItemBg()
  self.btn_needGold.itemCellData = self.btn_needGold.itemCellData or ItemCellData()
  local needGoldData = ItemUtility.GenerateItemData(self.costTbl.itemId)
  needGoldData.count = self.costTbl.count
  self.btn_needGold.itemCellData:RefreshData(needGoldData)
  ItemUtility.ShowItemCell(self.btn_needGold, self.btn_needGold.itemCellData, self, true)
  if BagInfoData.GetItemTotalCountByItemId(self.costTbl.itemId) < self.costTbl.count then
    self.lab_num:SetText(string.GetColorText(self.costTbl.count, ItemQuality2ColorDic[EItemColorEnum.red]))
  end
end

function Role_ResurgenceUI:ReleaseModel()
  ItemUtility.ReleaseItemCell(self.btn_needGold, self.btn_needGold.itemCellData)
end

function Role_ResurgenceUI:Tips(tip)
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = tip,
    okText = "X\195\161c nh\225\186\173n",
    ok = function()
      UIManager.Hide(UIID.PromptTipUI)
    end
  })
end

function Role_ResurgenceUI:StartCountdownRelive(name)
  local cfg_Map = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
  local reliveTime = 0
  if cfg_Map and 0 < cfg_Map.reliveCd then
    reliveTime = cfg_Map.reliveCd
  else
    reliveTime = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(7020003)
  end
  reliveTime = tonumber(reliveTime) / 1000
  local totalTime = reliveTime
  self.isZeroReliveTime = false
  self.Text_1:SetText(string.format("%s(%d)", name, reliveTime))
  self.countdownRelive = Timer.StartLoop(1, reliveTime, function()
    reliveTime = reliveTime - 1
    self.Text_1:SetText(string.format("%s(%d)", name, reliveTime))
    self:RefreshKSBattleContentText(totalTime - reliveTime + 1)
    if reliveTime == 0 then
      self.isZeroReliveTime = true
      self:Button_1OnClick()
    end
  end)
end

function Role_ResurgenceUI:RefreshKSBattleContentText(time)
  if not TranScriptData.IsInRefineKSBattle() then
    return
  end
  local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Character_death2")
  if string.isNullOrEmpty(content) then
    return
  end
  local scoreNum = ClientTable.cfg_Activity_globalManager:GetDeathScore(time)
  self.Text_TipContent:SetText(string.format(content, HPData.killName, scoreNum))
end
