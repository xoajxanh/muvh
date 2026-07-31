Career_DialogueUI = class(BaseUI)
Career_DialogueUI.layer = UILayer.Panel
Career_DialogueUI.orderInLayer = 0
Career_DialogueUI.hideType = UIHideType.WaitDestroy
Career_DialogueUI.hideFunc = UIHideFunc.MoveOutOfScreen
Career_DialogueUI.escClose = UIEscClose.DontClose

function Career_DialogueUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.plane_change = self:GetControl("plane_change")
  self.btn_close = self:GetControl("plane_change/btn_close")
  self.btn_careerTransfer = self:GetControl("plane_change/btn_careerTransfer")
  self.btn_wingTransfer = self:GetControl("plane_change/btn_wingTransfer")
  self.plane_transfer = self:GetControl("plane_transfer")
  self.panel_career = self:GetControl("plane_transfer/panel_career")
  self.myOccuImg = self:GetControl("plane_transfer/panel_career/myOccupation/myOccuImg")
  self.tog_career = self:GetControl("plane_transfer/panel_career/Viewport/Content/tog_career")
  self.Background = self:GetControl("plane_transfer/panel_career/Viewport/Content/tog_career/Background")
  self.lab_careerTemp = self:GetControl("plane_transfer/panel_career/Viewport/Content/tog_career/lab_careerTemp")
  self.panel_wing = self:GetControl("plane_transfer/panel_wing")
  self.btn_3DWings = self:GetControl("plane_transfer/panel_wing/myWingPanel/btn_3DWings")
  self.selectTransferWingPanel = self:GetControl("plane_transfer/panel_wing/selectTransferWingPanel")
  self.tog_wing = self:GetControl("plane_transfer/panel_wing/selectTransferWingPanel/tog_wing")
  self.btn_3DItemWing = self:GetControl("plane_transfer/panel_wing/selectTransferWingPanel/tog_wing/wingItem/btn_3DItemWing")
  self.selectWingPanel = self:GetControl("plane_transfer/panel_wing/selectWingPanel")
  self.btn_selectWing = self:GetControl("plane_transfer/panel_wing/selectWingPanel/btn_selectWing")
  self.img_transferinside = self:GetControl("plane_transfer/img_transferinside")
  self.go_costone = self:GetControl("plane_transfer/img_transferinside/go_costItem/go_costone")
  self.needItem = self:GetControl("plane_transfer/img_transferinside/go_costItem/go_costone/Viewport/Content/needItem")
  self.btn_transfer = self:GetControl("plane_transfer/img_transferinside/btn_transfer")
  self.go_costEquip = self:GetControl("plane_transfer/go_costEquip")
  self.btn_closeCostEquipe = self:GetControl("plane_transfer/go_costEquip/btn_closeCostEquipe")
  self.sw_costEquip = self:GetControl("plane_transfer/go_costEquip/img_smallBg/sw_costEquip")
  self.SelectWingItem = self:GetControl("plane_transfer/go_costEquip/img_smallBg/sw_costEquip/Viewport/Content/SelectWingItem")
  self.btn_select = self:GetControl("plane_transfer/go_costEquip/img_smallBg/btn_select")
  self.Button_CloseBag = self:GetControl("plane_transfer/Button_CloseBag")
end

function Career_DialogueUI:OnPreLoad()
end

function Career_DialogueUI:Init()
end

function Career_DialogueUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Career_DialogueUI:InitUI()
  self:InitTransferType()
  self:InitContent()
  self:InitSprite()
end

function Career_DialogueUI:InitSprite()
  local spriteIconAtlas = self:LoadAsset("Texture/Atlas_Common.spriteatlas", typeof(CS.UnityEngine.U2D.SpriteAtlas))
  self.fashiSprite = spriteIconAtlas:GetSprite(BaseCareerIconEnum[ERoleCareer.Magic])
  self.jianshiSprite = spriteIconAtlas:GetSprite(BaseCareerIconEnum[ERoleCareer.SwordMan])
  self.sheshouSprite = spriteIconAtlas:GetSprite(BaseCareerIconEnum[ERoleCareer.Archer])
  self.mojianshiSprite = spriteIconAtlas:GetSprite(BaseCareerIconEnum[ERoleCareer.SpellSword])
  self.SummonMagician = spriteIconAtlas:GetSprite(BaseCareerIconEnum[ERoleCareer.SummonMagician])
end

function Career_DialogueUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Career_DialogueUI:OnHide()
  for k, v in pairs(self.CareerLabelManger) do
    v:SetActive(false)
  end
  for k, v in pairs(self.JobSelectBtn) do
    v:GetChild("Checkmark"):SetActive(false)
  end
  self:RefreshCurrentWingItem()
  EventManager.Dispatch(Event.CancelClickNpc)
end

function Career_DialogueUI:OnDestroy()
end

function Career_DialogueUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.Button_CloseBag:SetOnClick(self, self.btn_closeOnClick)
  self.btn_careerTransfer:SetOnClick(self, self.btn_careerTransferOnClick)
  self.btn_wingTransfer:SetOnClick(self, self.btn_wingTransferOnClick)
  self.btn_transfer:SetOnClick(self, self.btn_transferOnClick)
  self.btn_select:SetOnClick(self, self.btn_selectOnClick)
  self.btn_selectWing:SetOnClick(self, self.btn_selectWingOnClick)
  self.btn_closeCostEquipe:SetOnClick(self, self.btn_closeCostEquipeOnClick)
  self.btn_3DWings:SetOnClick(self, self.btn_3DItemWingOnClick)
end

function Career_DialogueUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Career_DialogueUI)
end

function Career_DialogueUI:btn_careerTransferOnClick(control)
  if not self.careerTbl then
    FloatingTipUtility.QuickMsg("ngh\225\187\129 hi\225\187\135n t\225\186\161i kh\195\180ng th\225\187\131 Chuy\225\187\131n Ch\225\187\169c")
    return
  end
  self:SetButtonPitchOn(control)
  self:PanelOnOffManger(TransferType.career)
  self:RefreshNeedItem(TransferType.career)
end

function Career_DialogueUI:btn_wingTransferOnClick(control)
  if not self.haveWingTbl or #self.haveWingTbl < 1 then
    FloatingTipUtility.QuickMsg("Kh\195\180ng c\195\179 c\195\161nh c\195\179 th\225\187\131 Chuy\225\187\131n Ch\225\187\169c")
    return
  end
  self:SetButtonPitchOn(control)
  self:RefreshCurrentWingItem()
  self:PanelOnOffManger(TransferType.wing)
  self:RefreshNeedItem(TransferType.wing)
end

function Career_DialogueUI:btn_transferOnClick(control)
  if self.needCount > self.bagCount then
    FloatingTipUtility.QuickMsg("\196\144\225\186\161o c\225\187\165 kh\195\180ng \196\145\225\187\167")
    return
  end
  local itemInfo
  itemInfo = BagInfoData.GetItemTblByConfigId(self.needItemID)
  if self.CurrentType == TransferType.career then
    if self.CurrentSelectCareer == nil then
      FloatingTipUtility.QuickMsg("M\225\187\157i ch\225\187\141n 1 ngh\225\187\129")
      return
    end
    local careerName = RoleUtility.GteCareerNameByType(self.CurrentSelectCareer)
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = string.format(LocalizationUtility.GetContentByKey("zhuanzhi"), careerName),
      okText = "X\195\161c nh\225\186\173n",
      ok = function()
        TransferCareerData.SetTransferCareer(self.CurrentSelectCareer)
        if self:GetBaseCareer(self.CurrentSelectCareer) == 14 then
          ServerDataRecordData.IntDataChange(SerRecordIntType.archerDirection, 0)
          ServerDataRecordData.SendSaveData({
            dataInt = {
              [SerRecordIntType.archerDirection] = 0
            }
          })
        else
          ServerDataRecordData.IntDataChange(SerRecordIntType.archerDirection, 1)
          ServerDataRecordData.SendSaveData({
            dataInt = {
              [SerRecordIntType.archerDirection] = 1
            }
          })
        end
        networkRequest.ReqTransferRole(itemInfo[1].id, self.CurrentSelectCareer)
        UIManager.Hide(UIID.Career_DialogueUI)
      end
    })
  elseif self.CurrentType == TransferType.wing then
    networkRequest.ReqTransferItem(self.selectedAddItem.id, self.selectWingId)
    UIManager.Hide(UIID.Career_DialogueUI)
  end
end

function Career_DialogueUI:GetBaseCareer(value)
  return value % 10 + 10
end

function Career_DialogueUI:btn_selectOnClick(control)
  if not self.selectedAddItem then
    FloatingTipUtility.QuickMsg("M\225\187\157i ch\225\187\141n 1 c\195\161nh")
    return
  end
  self.go_costEquip:SetActive(false)
  self:SetWingUIPanelActive(true)
  self:RefreshSelectableWing(self.selectedAddItem)
end

function Career_DialogueUI:btn_selectWingOnClick(control)
  self.selectedAddItem = nil
  self.SelectWingItemTemp:SetData(self.haveWingTbl)
  self.go_costEquip:SetActive(true)
end

function Career_DialogueUI:btn_closeCostEquipeOnClick()
  self.go_costEquip:SetActive(false)
end

function Career_DialogueUI:SetWingUIPanelActive(isShow)
  self.selectTransferWingPanel:SetActive(isShow)
  self.img_transferinside:SetActive(isShow)
  self.selectWingPanel:SetActive(not isShow)
end

function Career_DialogueUI:RefreshArgsUI()
  if self.args and self.args.param then
    local itemConfig = ConfigManager.GetConfig("cfg_Item_item", self.args.param.itemId, "id")
    if itemConfig then
      if itemConfig.subType == EItemSubtype.TransferCard then
        self:btn_careerTransferOnClick(self.btn_careerTransfer)
      elseif itemConfig.subType == EItemSubtype.TransferCardWing then
        self:btn_wingTransferOnClick(self.btn_wingTransfer)
      end
    end
  end
end

function Career_DialogueUI:UIRefresh()
  self:UIPosAndActiveRefresh(false)
  self.go_costEquip:SetActive(false)
end

function Career_DialogueUI:RefreshCurrentWingItem()
  self.CurrentWingItem:Reset()
  ItemUtility.ShowItemCell(self.btn_3DWings, self.CurrentWingItem, self)
end

function Career_DialogueUI:UIPosAndActiveRefresh(isShow)
  self.plane_transfer:SetActive(isShow)
  self.plane_transferPos = self.plane_transfer.transform:GetComponent("RectTransform").rect
  if self.plane_transfer:GetActive() then
    self.plane_change.transform.anchoredPosition = Vector2(self.plane_transfer.transform.anchoredPosition.x - self.plane_transferPos.width, 0)
  else
    self.plane_change.transform.anchoredPosition = Vector2(self.plane_transfer.transform.anchoredPosition.x, 0)
  end
end

function Career_DialogueUI:RegistEvents()
end

function Career_DialogueUI:Refresh()
  self.meData = ViewData.meData
  self.careerTbl = ProfessionalUtility.GetCanCareer(ERoleSchema.TransferCard)
  self.costTbl = ProfessionalUtility.GetCanCost(ERoleSchema.TransferCard)
  self.wingIDTbl = PropsTransUtility.GetCareerItemIDTbl()
  self.haveWingTbl = BagInfoData.SelectItemsInID(self.wingIDTbl)
  self:UIRefresh()
  self:RefreshCareer()
end

function Career_DialogueUI:RefreshCareer()
  self.transferCareerTbl = {}
  self.CurrentSelectCareer = nil
  if self.careerTbl then
    self.transferCareerTbl = table.metatableCopy(nil, self.careerTbl)
  end
  local meCareerData = ProfessionalUtility.GetTblType(ERoleSchema.TransferCard, self.meData.career)
  if meCareerData then
    if RoleUtility.GetBasicCareer(self.meData.career) == ERoleCareer.SwordMan then
      self.myOccuImg:SetSprite(self.jianshiSprite)
    elseif RoleUtility.GetBasicCareer(self.meData.career) == ERoleCareer.Magic then
      self.myOccuImg:SetSprite(self.fashiSprite)
    elseif RoleUtility.GetBasicCareer(self.meData.career) == ERoleCareer.Archer then
      self.myOccuImg:SetSprite(self.sheshouSprite)
    elseif RoleUtility.GetBasicCareer(self.meData.career) == ERoleCareer.SpellSword then
      self.myOccuImg:SetSprite(self.mojianshiSprite)
    elseif RoleUtility.GetBasicCareer(self.meData.career) == ERoleCareer.SummonMagician then
      self.myOccuImg:SetSprite(self.SummonMagician)
    end
  end
  self.panel_career.scrollRect.normalizedPosition = Vector2(0, 1)
  self.tog_careerTemp:SetData(self.transferCareerTbl)
  if self.costTbl then
    local needItemTbl = string.split(self.costTbl, "&")
    self.Need3DItemTemp:SetData(needItemTbl)
  end
  self:SetWingUIPanelActive(true)
end

function Career_DialogueUI:RefreshWing()
  self.selectedAddItem = nil
  if #self.haveWingTbl == 1 then
    self:RefreshSelectableWing(self.haveWingTbl[1])
  end
  self:SetWingUIPanelActive(#self.haveWingTbl == 1)
end

function Career_DialogueUI:RefreshSelectableWing(item)
  self.selectedAddItem = item
  local selectWingTbl = PropsTransUtility.GetCanCareerPropItem(item.itemId)
  self.CurrentWingItem:RefreshData(self.selectedAddItem)
  local lab_name = UIControl(self.btn_3DWings.transform, "lab_name")
  lab_name:SetActive(true)
  ItemUtility.ShowItemCell(self.btn_3DWings, self.CurrentWingItem, self)
  self.tog_wingTemp:SetData(selectWingTbl)
  self.costWingTbl = PropsTransUtility.GetCanPropItemCost(item.itemId)
  if self.costWingTbl then
    local needItemTbl = string.split(self.costWingTbl, "&")
    self.Need3DItemTemp:SetData(needItemTbl)
  end
end

function Career_DialogueUI:OnSelectedAddItemTipsOnClick(control)
  UIManager.Hide(UIID.ItemTipUI)
  self:btn_selectWingOnClick()
end

function Career_DialogueUI:OnCancelAddItemTipsOnClick()
  UIManager.Hide(UIID.ItemTipUI)
end

function Career_DialogueUI:btn_3DItemWingOnClick(control)
  if not self.selectedAddItem then
    return
  end
  self.selectedAddItem.tblItem.leftOperate = 0
  local args = {
    item = self.selectedAddItem,
    ctrl = control,
    rightOperate = {
      name = Localization.GetUIWord("tihuan"),
      ui = self,
      func = self.OnSelectedAddItemTipsOnClick
    }
  }
  UIManager.Show(UIID.ItemTipUI, args)
end

function Career_DialogueUI:RefreshNeedItem(panelType)
  if panelType == TransferType.career then
    self:RefreshCareer()
  elseif panelType == TransferType.wing then
    self:RefreshWing()
  end
end

function Career_DialogueUI:PanelOnOffManger(panelType)
  self.CurrentType = panelType
  if not self.plane_transfer:GetActive() then
    self:UIPosAndActiveRefresh(true)
  end
  for k, v in pairs(self.PanelManger) do
    if k == panelType then
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
end

function Career_DialogueUI:SetButtonPitchOn(Control)
  for k, v in pairs(self.JobSelectBtn) do
    if v == Control then
      v:GetChild("Checkmark"):SetActive(true)
    else
      v:GetChild("Checkmark"):SetActive(false)
    end
  end
end

function Career_DialogueUI:tog_careerOnClick(Data)
  self.CurrentSelectCareer = Data
end

local function tog_careerTempRefresh(ctr, _, Data, ui)
  if RoleUtility.GetBasicCareer(Data) == ERoleCareer.SwordMan then
    ctr.Background:SetSprite(ui.jianshiSprite)
  elseif RoleUtility.GetBasicCareer(Data) == ERoleCareer.Magic then
    ctr.Background:SetSprite(ui.fashiSprite)
  elseif RoleUtility.GetBasicCareer(Data) == ERoleCareer.Archer then
    ctr.Background:SetSprite(ui.sheshouSprite)
  elseif RoleUtility.GetBasicCareer(Data) == ERoleCareer.SpellSword then
    ctr.Background:SetSprite(ui.mojianshiSprite)
  elseif RoleUtility.GetBasicCareer(Data) == ERoleCareer.SummonMagician then
    ctr.Background:SetSprite(ui.SummonMagician)
  end
  ctr:SetOnToggleChanged(ui, function()
    ui:tog_careerOnClick(Data)
  end)
  ctr.toggle.isOn = _ == 1
  if ctr.toggle.isOn then
    ui.CurrentSelectCareer = Data
  end
end

local function tog_careerTempCreate(control)
  control.itemCellData = ItemCellData()
  control.Background = UIControl(control.transform, "Background")
end

local function Need3DItemTempRefresh(ctr, _, Data, ui)
  local needItem = string.split(Data, "#")
  local count
  ui.needItemID = tonumber(needItem[1])
  ui.needCount = tonumber(needItem[2])
  ui.bagCount = BagInfoData.GetItemTotalCountByItemId(ui.needItemID)
  if ui.bagCount >= ui.needCount then
    count = string.GetColorText(tostring(ui.bagCount), ItemQuality2ColorDic[5])
  else
    count = string.GetColorText(tostring(ui.bagCount), ItemQuality2ColorDic[7])
  end
  ctr.lab_needNum:SetText(count .. "/" .. ui.needCount)
  local itemData = ItemUtility.GenerateItemData(ui.needItemID)
  itemData.count = 1
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.Need3DItem, ctr.itemCellData, ui, true)
end

local function Need3DItemTempCreate(control)
  control.itemCellData = ItemCellData()
  control.Need3DItem = UIControl(control.transform, "Need3DItem")
  control.lab_needNum = UIControl(control.transform, "lab_needNum")
end

local function tog_wingTempRefresh(ctr, _, Data, ui)
  local itemData = ItemUtility.GenerateItemData(Data)
  itemData.count = 1
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.wingItem, ctr.itemCellData, ui)
  ctr:SetOnToggleChanged(ui, function()
    ui:OnSelectWingTogChanged(Data)
  end)
  if ctr.toggle.isOn then
    ui.selectWingId = Data
  end
end

local function tog_wingTempCreate(control)
  control.itemCellData = ItemCellData()
  control.wingItem = UIControl(control.transform, "wingItem/btn_3DItemWing")
end

local function SelectWingItemTempRefresh(ctr, _, Data, ui)
  ctr.itemCellData:RefreshData(Data)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui)
  ctr.item = Data
  if ctr.selectImageCtr:GetActive() then
    ui.selectedAddItem = Data
  end
  ctr:SetOnClick(ui, ui.OnSelectItemTogChanged)
end

local function SelectWingItemTempCreate(control)
  control.itemCellData = ItemCellData()
end

function Career_DialogueUI:InitContent()
  self.tog_careerTemp = UIContainer(self.tog_career, self, tog_careerTempCreate, tog_careerTempRefresh)
  self.Need3DItemTemp = UIContainer(self.needItem, self, Need3DItemTempCreate, Need3DItemTempRefresh)
  self.tog_wingTemp = UIContainer(self.tog_wing, self, tog_wingTempCreate, tog_wingTempRefresh)
  self.SelectWingItemTemp = UIContainer(self.SelectWingItem, self, SelectWingItemTempCreate, SelectWingItemTempRefresh)
  self.CurrentWingItem = ItemCellData()
end

function Career_DialogueUI:OnSelectWingTogChanged(itemId)
  self.selectWingId = itemId
end

function Career_DialogueUI:OnSelectItemTogChanged(control)
  for i = 1, self.SelectWingItemTemp.maxCount do
    local tmepObjBtn = self.SelectWingItemTemp:GetOrCreateItem(i)
    tmepObjBtn.selectImageCtr:SetActive(false)
  end
  self.selectedAddItem = control.item
  control.selectImageCtr:SetActive(true)
end

function Career_DialogueUI:InitTransferType()
  self.JobSelectBtn = {
    [1] = self.btn_careerTransfer,
    [2] = self.btn_wingTransfer
  }
  self.PanelManger = {
    [TransferType.career] = self.panel_career,
    [TransferType.wing] = self.panel_wing
  }
  self.CareerLabelManger = {
    [ERoleCareer.Templar] = self.lab_careerTemplars,
    [ERoleCareer.Archmage] = self.lab_careerMage,
    [ERoleCareer.ElvesRangers] = self.lab_careerElf
  }
end
