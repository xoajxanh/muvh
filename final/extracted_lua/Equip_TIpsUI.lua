Equip_TIpsUI = class(BaseUI)
Equip_TIpsUI.layer = UILayer.Background
Equip_TIpsUI.orderInLayer = 3
Equip_TIpsUI.hideType = UIHideType.Hide
Equip_TIpsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_TIpsUI.escClose = UIEscClose.DontClose

function Equip_TIpsUI:InitControls()
  self.BG = self:GetControl("BG")
  self.btn_3DItem = self:GetControl("BG/img_Bg/btn_3DItem")
  self.lab_name = self:GetControl("BG/img_Bg/btn_3DItem/lab_name")
  self.MyName = self:GetControl("BG/img_Bg/btn_3DItem/MyName")
  self.lab_equiptips = self:GetControl("BG/lab_equiptips")
  self.btn_quickequip = self:GetControl("BG/btn_quickequip")
  self.lab_quickequip = self:GetControl("BG/btn_quickequip/lab_quickequip")
  self.lab_countdown = self:GetControl("BG/btn_quickequip/lab_countdown")
  self.btn_Notiemquickequip = self:GetControl("BG/btn_Notiemquickequip")
  self.lab_Notiemquickequip = self:GetControl("BG/btn_Notiemquickequip/lab_Notiemquickequip")
  self.btn_close = self:GetControl("BG/btn_close")
end

function Equip_TIpsUI:OnPreLoad()
end

function Equip_TIpsUI:Init()
  self.acc = 9
  self.recTimer = nil
  self.EquipInfo = {}
  self.showCellData = ItemCellData()
end

function Equip_TIpsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_TIpsUI:InitUI()
  self.BG_pos = self.BG.transform.localPosition
end

function Equip_TIpsUI:OnShow()
  if SceneData.mapId and SceneData.mapId == 1095 then
    UIManager.Hide(UIID.EquipTIpsUI)
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
  self:ShowData()
  local ShowItem
  for i, v in pairs(self.EquipInfo) do
    local state = RoleEquipUtility.CanUpFight(v)
    if state == EquipUpState.CanWearUpFight then
      ShowItem = v
      break
    end
  end
  ShowItem = ShowItem or self.EquipInfo[1]
  self.ShowItem = ShowItem
  self:Refresh()
end

function Equip_TIpsUI:ShowData()
  if table.count(self.args.ItemInfo) ~= 0 then
    self.EquipInfo = self.args.ItemInfo
    if not self.args.bagchange then
      self:InsertData()
    end
  elseif self.ShowItem ~= nil then
    table.insert(self.EquipInfo, self.ShowItem)
  end
end

function Equip_TIpsUI:UpLInsertData(items)
  self.EquipInfo = {}
  self:InsertData(items)
end

function Equip_TIpsUI:InsertData(items)
  if items then
    local mun = #items
    local acc = 0
    for i = 1, mun do
      i = i + acc
      if items[i].itemId == self.ShowItem.itemId then
        table.remove(items, i)
        acc = acc - 1
      end
    end
    if table.count(items) ~= 0 then
      table.combine(self.EquipInfo, items)
    end
  end
  local newshowdata = {}
  for i = 1, #self.EquipInfo do
    local index = self.EquipInfo[i].wearindex
    if not newshowdata[index] then
      newshowdata[index] = self.EquipInfo[i]
    end
  end
  local newtable = {}
  for i, v in pairs(newshowdata) do
    table.insert(newtable, v)
  end
  self.EquipInfo = newtable
end

function Equip_TIpsUI:OnHide()
  self.showCellData:RecycleRes()
  self.args.ItemInfo = {}
  if self.Havetime then
    self:DestroyTimer()
  end
  self.EquipInfo = {}
  self.ShowItem = nil
end

function Equip_TIpsUI:OnDestroy()
  if self.showCellData then
    self.showCellData:RecycleRes()
    self.showCellData = nil
  end
end

function Equip_TIpsUI:Update()
  if self.showCellData and self.showCellData.model then
    local obj = self.showCellData.model.modelObject
    RoleEquipUtility.EquipModelRotation(obj, self.showCellData.itemData.tblItem.SpinAxis, 2)
  end
end

function Equip_TIpsUI:RegistUIEvents()
  self.btn_quickequip:SetOnClick(self, self.Btn_quickequip)
  self.btn_Notiemquickequip:SetOnClick(self, self.Btn_quickequip)
  self.btn_close:SetOnClick(self, self.Button_close)
end

function Equip_TIpsUI:Btn_quickequip()
  local roledata = string.format("%s-%d", "EquipTipBtn", RoleManager.me.id)
  local mun = PlayerPrefs.GetInt(roledata)
  if mun == 0 and false then
    PlayerPrefs.SetInt(roledata, 1)
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.NewBagInfoUI)
  elseif self.ShowItem.Checkstate then
    RoleEquipUtility.CheckUseItem(self.ShowItem, CheckUseItemWay.NotTip)
    RoleEquipUtility.OnWearEquip(self.ShowItem)
    self:TryDoOpenRedEquipUI()
    self:TryDoOpenHolySpiritEquipUI()
    self:TryDoOpenSuitUI()
  else
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.NewBagInfoUI)
    
    local function waitExe(self, id)
      Coroutine.Wait(0.1)
      local GuideStepData = {
        effParam = "Eff_UI_annuikuang_dengbi",
        Id = id
      }
      EventManager.Dispatch(Event.EquipTipsGuideParent, GuideStepData)
    end
    
    Coroutine.Start(waitExe, self, self.ShowItem.id)
  end
  self:Button_close()
end

function Equip_TIpsUI:TryDoOpenHolySpiritEquipUI()
  if self.ShowItem == nil or gameMgr:GetAvatarManager() == nil then
    return
  end
  if self.ShowItem.tblEquip and self.ShowItem.tblEquip.cellType and self.ShowItem.tblEquip.cellType == EEquipCellType.HolySpirit then
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Equip_HolySpiritLeftUI, {
      equipSubtype = self.ShowItem.tblItem.subType
    })
  end
end

function Equip_TIpsUI:TryDoOpenRedEquipUI()
  if self.ShowItem == nil or gameMgr:GetAvatarManager() == nil then
    return
  end
  local redEquipMgr = gameMgr:GetAvatarManager():GetMainPlayer():GetRedEquipLevelDataMgr()
  if redEquipMgr == nil then
    return
  end
  if not redEquipMgr:CheckRedEquipIndex(self.ShowItem.wearindex) then
    return
  end
  EventManager.Dispatch(Event.RedEquipIndexInitalize, self.ShowItem.wearindex)
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():CurOpenEquipType(IndexerEnum.set, EquipCellType.HONGZHUANG)
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.NewBagInfoUI)
end

function Equip_TIpsUI:TryDoOpenSuitUI()
  if self.ShowItem == nil or gameMgr:GetAvatarManager() == nil then
    return
  end
  local suitMgr = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager()
  if suitMgr == nil then
    return
  end
  if not suitMgr:CheckIsBingjian(self.ShowItem.wearindex) then
    return
  end
  local cfg_EquipCell = ClientTable.cfg_EquipCell_cellManager:TryGetValue(self.ShowItem.wearindex)
  local showEquipType
  if cfg_EquipCell and cfg_EquipCell.cellType then
    showEquipType = cfg_EquipCell.cellType
  end
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Bag_EquipInfoAngelUI, {showEquipType = showEquipType})
end

function Equip_TIpsUI:Button_close()
  if self.Havetime then
    self:DestroyTimer()
  end
  if #self.EquipInfo ~= 0 then
    local ShowItem
    for i, v in pairs(self.EquipInfo) do
      local state = RoleEquipUtility.CanUpFight(v)
      if state == EquipUpState.CantWearUpFight then
        ShowItem = v
        break
      end
    end
    ShowItem = ShowItem or self.EquipInfo[1]
    if ShowItem then
      self.ShowItem = ShowItem
      self:Refresh()
    else
      self.EquipInfo = {}
      self:Button_close()
    end
  else
    UIManager.Hide(UIID.EquipTIpsUI)
    TipData.OpenNextUI()
  end
end

function Equip_TIpsUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.TipsMainUIPosChange, self.TipsMainUIPosChange, self)
  self:RegistEvent(Event.Role_MyAttributeChanged, self.On_RoleAttributeChanged, self)
  self:RegistEvent(Event.HideQuickUseWindow, self.HideThisUI, self)
end

function Equip_TIpsUI:HideThisUI()
  UIManager.Hide(UIID.EquipTIpsUI)
end

function Equip_TIpsUI:OnBagChange(id, msg)
  local id
  if msg and msg.removeItems then
    local showId = false
    if TipData.bageChangeType(msg) then
      for i, v in pairs(msg.removeItems) do
        if v.id then
          id = v.id
          TipData.BagChangeRefrsh(id)
          if self.ShowItem and id == self.ShowItem.id then
            self.ShowItem = nil
            showId = true
          end
          local acc = 0
          for k = 1, #self.EquipInfo do
            k = acc + k
            if self.EquipInfo[k].id == id then
              table.remove(self.EquipInfo, k)
              acc = acc - 1
            end
          end
        end
      end
    end
    if showId then
      self:Button_close()
    end
  end
end

function Equip_TIpsUI:TipsMainUIPosChange(_, state)
  local animalTime = C_UISettings.MainMenuUITime
  local distance = C_UISettings.MainUIDistance
  if state then
    self.BG.transform:DOLocalMove(self.BG_pos, animalTime):SetEase(Ease.OutQuad)
  else
    self.BG.transform:DOLocalMove(self.BG_pos + Vector3.New(0, -distance - 500, 0), animalTime):SetEase(Ease.OutQuad)
  end
end

function Equip_TIpsUI:On_RoleAttributeChanged(_, changeList)
  if not self.Havetime and (changeList[EAttributeType.strength] ~= nil or changeList[EAttributeType.agility] ~= nil or changeList[EAttributeType.vitality] ~= nil or changeList[EAttributeType.energy] ~= nil) then
    local state = RoleEquipUtility.CanUpFight(self.ShowItem)
    if state == EquipUpState.CanWearUpFight then
      self.ShowItem.Checkstate = state == EquipUpState.CanWearUpFight
      self.Havetime = ViewData.meData.level <= TipData.UpLevel and self.ShowItem.Checkstate
      self.btn_quickequip:SetActive(self.Havetime)
      self.btn_Notiemquickequip:SetActive(not self.Havetime)
      if self.recTimer == nil and self.Havetime then
        self:CreatTimer()
      end
    end
  end
end

function Equip_TIpsUI:Refresh()
  if self.ShowItem == nil then
    self.EquipInfo = {}
    self:Button_close()
  end
  self.showCellData:RefreshData(self.ShowItem)
  table.remove(self.EquipInfo, 1)
  local state = RoleEquipUtility.CanUpFight(self.ShowItem)
  self.ShowItem.Checkstate = state == EquipUpState.CanWearUpFight
  self.Havetime = ViewData.meData.level <= TipData.UpLevel and self.ShowItem.Checkstate
  self.btn_quickequip:SetActive(self.Havetime)
  if not self.Havetime then
    local ButText = self.ShowItem.Checkstate and "Trang b\225\187\139 ngay" or "M\225\187\159 T\195\186i"
    self.lab_Notiemquickequip:SetText(ButText)
  end
  self.btn_Notiemquickequip:SetActive(not self.Havetime)
  if self.recTimer == nil and self.Havetime then
    self:CreatTimer()
  end
  self:RefreshShow()
end

function Equip_TIpsUI:RefreshShow()
  ItemUtility.ShowItemCell(self.btn_3DItem, self.showCellData, self, true)
  if self.Havetime then
    self.lab_countdown:SetText("(" .. self.acc .. "s)")
  end
  if not string.isNullOrEmpty(self.args.lab_quickequip) then
    self.lab_quickequip:SetText(self.args.lab_quickequip)
  end
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
end

function Equip_TIpsUI:CreatTimer()
  local timeStr = self.acc
  
  local function UpdataTimerBtn()
    if 1 < timeStr then
      timeStr = timeStr - 1
      self.lab_countdown:SetText("(" .. timeStr .. "s)")
    elseif timeStr == 1 then
      timeStr = timeStr - 1
      self.lab_countdown:SetText("(" .. timeStr .. "s)")
      self:Btn_quickequip()
    end
  end
  
  self.recTimer = Timer.StartLoop(1, timeStr, UpdataTimerBtn)
end

function Equip_TIpsUI:DestroyTimer()
  if self.recTimer then
    Timer.Stop(self.recTimer)
  end
  self.recTimer = nil
end
