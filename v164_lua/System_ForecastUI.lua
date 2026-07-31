System_ForecastUI = class(BaseUI)
System_ForecastUI.layer = UILayer.Panel
System_ForecastUI.orderInLayer = 2
System_ForecastUI.hideType = UIHideType.WaitDestroy
System_ForecastUI.hideFunc = UIHideFunc.MoveOutOfScreen
System_ForecastUI.escClose = UIEscClose.DontClose

function System_ForecastUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.grid_type = self:GetControl("grid_type")
  self.ForecastBtn = self:GetControl("grid_type/Viewport/Content/ForecastBtn")
  self.PlayPreviewpanel = self:GetControl("PlayPreviewpanel")
  self.DesContent = self:GetControl("PlayPreviewpanel/Des/Viewport/DesContent")
  self.Lab_Title = self:GetControl("PlayPreviewpanel/Des/Viewport/DesContent/Lab_Title")
  self.lab_Content = self:GetControl("PlayPreviewpanel/Des/Viewport/DesContent/Lab_Title/lab_Content")
  self.suitContainer = self:GetControl("PlayPreviewpanel/Des/Viewport/DesContent/suitContainer")
  self.PlayPreview_3DItem = self:GetControl("PlayPreviewpanel/level_gift/Viewport/Content/PlayPreview_3DItem")
  self.tips_PlayPreview = self:GetControl("PlayPreviewpanel/level_gift/tips_PlayPreview")
  self.btn_PlayPreviewget = self:GetControl("PlayPreviewpanel/level_gift/btn_PlayPreviewget")
  self.btn_PlayPreviewGoto = self:GetControl("PlayPreviewpanel/level_gift/btn_PlayPreviewGoto")
  self.panel_2 = self:GetControl("panel_2")
  self.SynthesisInfoItem = self:GetControl("panel_2/Viewport/Content/SynthesisInfoItem")
  self.panel_3 = self:GetControl("panel_3")
  self.EquipInfoItem = self:GetControl("panel_3/Viewport/Content/EquipInfoItem")
end

function System_ForecastUI:OnPreLoad()
end

function System_ForecastUI:Init()
  self.Info1 = SystemForecastData.GetInfo1()
  self.Info2 = SystemForecastData.GetInfo2()
  self.Info3 = SystemForecastData.GetInfo3()
end

function System_ForecastUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnBtnItemCreat(ctr)
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.img_redPoint = UIControl(ctr.transform, "img_redPoint")
end

local function OnBtnItemRefresh(ctr, _, data, ui)
  ctr.lab_name:SetText(data.txtTitle)
  ctr.data = data
  ctr.img_redPoint:SetActive(data.Red)
  ctr:SetOnClick(ui, ui.ForecastBtnOnClick)
end

local function OnPlayPreview_3DItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnPlayPreview_3DItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

local function Onlab_TitleCreat(ctr)
  ctr.lab_Content = UIControl(ctr.transform, "lab_Content")
end

local function DetailUICtr(ctr)
end

local function DetailUIRefresh(ctr, _, data, ui)
  local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(data)
  ctr:SetText(content)
end

local function Onlab_TitleRefresh(ctr, _, data, ui)
  local Title = ClientTable.cfg_Ui_wordManager:TryGetValue(data.Title).content
  ctr:SetText(Title)
  if not ctr.suitContainer then
    local item
    local go = ui.suitContainer:Instantiate(ui.DesContent.transform, ui.DesContent)
    go.name = ui.suitContainer.gameObject.name
    item = UIControl()
    item.transform = go.transform
    item:SetActive(true)
    ctr.suitContainer = item
    if not ctr.DetailUIContainer then
      local lab_TipSuitAdditional = ctr.suitContainer:GetChild("lab_TipSuitAdditional")
      ctr.DetailUIContainer = UIContainer(lab_TipSuitAdditional, ui, DetailUICtr, DetailUIRefresh)
    end
  else
    ctr.suitContainer:SetActive(true)
  end
  ctr.DetailUIContainer:SetData(data.DesGrop)
end

function System_ForecastUI:InitUI()
  self.BtnItemContainer = UIContainer(self.ForecastBtn, self, OnBtnItemCreat, OnBtnItemRefresh)
  self.lab_TitleContainer = UIContainer(self.Lab_Title, self, Onlab_TitleCreat)
  self.EquipInfoContainer = UIContainer(self.EquipInfoItem, self, self.OnEquipInfoCreat, self.OnEquipInfoRefresh)
  self.SynthesisInfoContainer = UIContainer(self.SynthesisInfoItem, self, self.OnSynthesisInfoCreat, self.OnSynthesisInfoRefresh)
  self.PlayPreview_3DItemContainer = UIContainer(self.PlayPreview_3DItem, self, OnPlayPreview_3DItemCreat, OnPlayPreview_3DItemRefresh)
  self.PlanType = {
    [1] = self.PlayPreviewpanel,
    [2] = self.panel_2,
    [3] = self.panel_3
  }
  self.PanelManger = {
    [SystemForecastTogType.panel_2] = self.PlanType[2],
    [SystemForecastTogType.panel_3] = self.PlanType[3]
  }
  for i, v in pairs(SystemForecastData.Tab.Preview) do
    self.PanelManger[v] = self.PlanType[1]
  end
end

function System_ForecastUI:CreateMessageTableView()
  self.PreviewTableView = UITableView()
  self.PreviewTableView:SetLowerMargin(10)
  self.PreviewTableView:SetScrollView(self.ScrollView)
  self.PreviewTableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView)
  self.PreviewTableView:SetTotalCellCount(self, self.NumberOfCellsInTableView)
  self.PreviewTableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView)
  self.PreviewTableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear)
end

function System_ForecastUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function System_ForecastUI:OnHide()
end

function System_ForecastUI:OnDestroy()
end

function System_ForecastUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_PlayPreviewget:SetOnClick(self, self.btn_PlayPreviewgetOnClick)
  self.btn_PlayPreviewGoto:SetOnClick(self, self.btn_PlayPreviewGotoOnClick)
end

function System_ForecastUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.System_ForecastUI)
end

function System_ForecastUI:tog_1OnChanged(control, eventData)
  self.panel_1:SetActive(eventData)
  if eventData then
    self:RefreshPanel1()
  end
end

function System_ForecastUI:tog_2OnChanged(control, eventData)
  self.panel_2:SetActive(eventData)
  if eventData then
    self:RefreshPanel2()
  end
end

function System_ForecastUI:tog_3OnChanged(control, eventData)
  self.panel_3:SetActive(eventData)
  if eventData then
    self:RefreshPanel3()
  end
end

function System_ForecastUI:ForecastBtnOnClick(control)
  local data = control.data
  if not data then
    self:btn_closeOnClick()
    return
  end
  self.ShowData = data
  local PlayPreview = true
  if SystemForecastData.Tab.Preview[data.group] then
    self:RefreshPlayPreviewpanel(data)
    PlayPreview = false
  elseif data.group == SystemForecastTogType.panel_2 then
    self:RefreshPanel2()
  elseif data.group == SystemForecastTogType.panel_3 then
    self:RefreshPanel3()
  end
  self:SetButtonPitchOn(data.group, PlayPreview)
  if PlayPreview then
    local ui = self.PlanType[1]
    ui:SetActive(false)
  else
    local ui = self.PanelManger[data.group]
    ui:SetActive(true)
  end
end

function System_ForecastUI:btn_PlayPreviewgetOnClick(control)
  local data = control.data
  NetManager.Send(RechargeMessage.ReqGetGift, {
    id = {
      data.giftId
    }
  })
end

function System_ForecastUI:btn_PlayPreviewGotoOnClick(control)
  local data = control.data
  if data.uiName == "Instance_BossUI" then
    UIManager.JumpShow(UIPanelType.SortAndHide, data.uiName, {openFirstTab = 6})
    return
  end
  UIManager.JumpShow(UIPanelType.SortAndHide, data.uiName)
end

function System_ForecastUI:RegistEvents()
  self:RegistEvent(Event.SystemPreview, self.SystemPreview, self)
end

function System_ForecastUI:SystemPreview(id, data)
  if data then
    self:Refresh()
  end
end

function System_ForecastUI:CalculateTog()
  local TogTble = SystemForecastData.AllGetInfo()
  self.ShowTog = {}
  local TogGrop = {}
  self.NeedshowTog = nil
  for i, v in pairs(TogTble) do
    if (not v.conditionpreview or v.conditionpreview and ConditionManager.Check4D(v.conditionpreview) and (not v.conditionclose or not ConditionManager.Check4D(v.conditionclose))) and not TogGrop[v.group] then
      local tog = v
      if v.conditionopen and ConditionManager.Check4D(v.conditionopen) and (not v.conditionget or not ConditionManager.Check(v.conditionget)) then
        tog.Red = true
        if not self.NeedshowTog then
          self.NeedshowTog = v.group
        end
      else
        tog.Red = false
      end
      TogGrop[v.group] = i
      table.insert(self.ShowTog, tog)
    end
  end
  self.BtnItemContainer:SetData(self.ShowTog)
end

function System_ForecastUI:SetButtonPitchOn(Control, UI)
  for k, v in pairs(self.ShowTog) do
    if v.group == Control then
      if UI then
        local ui = self.PanelManger[v.group]
        ui:SetActive(true)
      end
      local tog = self.BtnItemContainer:GetOrCreateItem(k)
      tog:GetChild("lab_name").text.color = Color(0.86, 0.88, 0.88, 1)
      tog:GetChild("img_clickeffect"):SetActive(true)
    else
      local ui = self.PanelManger[v.group]
      ui:SetActive(false)
      local tog = self.BtnItemContainer:GetOrCreateItem(k)
      tog:GetChild("lab_name").text.color = Color(0.6, 0.6, 0.6, 1)
      tog:GetChild("img_clickeffect"):SetActive(false)
    end
  end
end

function System_ForecastUI:Refresh()
  self:CalculateTog()
  if self.args then
    local Group = self.NeedshowTog and self.NeedshowTog or self.args.group
    for i, v in pairs(self.ShowTog) do
      if v.group == Group then
        self:ForecastBtnOnClick({data = v})
        break
      end
    end
    self.args = nil
  else
    local index = 1
    for key, value in pairs(self.ShowTog) do
      local mFinish = value.conditionget and ConditionManager.Check(value.conditionget)
      local isCanGet = value.Red and not mFinish
      if isCanGet then
        index = key
        break
      end
    end
    self:ForecastBtnOnClick({
      data = self.ShowTog[index]
    })
  end
  self.panel_2:SetNormalizedPosition(0, 1)
  self.panel_3:SetNormalizedPosition(0, 1)
end

function System_ForecastUI:ShowDescribe(des)
  local TitleGrop = string.split(des, "&")
  local ShowDes = {}
  for i, v in pairs(TitleGrop) do
    local Describe = string.split(v, "#")
    local Title = Describe[1]
    local DesGrop = string.split(Describe[2], "/")
    ShowDes[i] = {}
    ShowDes[i].Title = Title
    ShowDes[i].DesGrop = DesGrop
  end
  for i, v in pairs(self.lab_TitleContainer.items) do
    v:SetActive(false)
    if v.suitContainer then
      v.suitContainer:SetActive(false)
    end
  end
  for i, v in pairs(ShowDes) do
    local obj = self.lab_TitleContainer:GetOrCreateItem(i)
    local Title = ClientTable.cfg_Ui_wordManager:TryGetValue(v.Title).content
    obj.lab_Content:SetText(Title)
    local mTextGenerator = obj.lab_Content.text.cachedTextGeneratorForLayout
    local mTgSettings = obj.lab_Content.text:GetGenerationSettings(Vector2(0, 0))
    local txtwith = mTextGenerator:GetPreferredWidth(Title, mTgSettings) / obj.lab_Content.text.pixelsPerUnit
    obj:SetSizeDelta(txtwith * 1.5, 45)
    if not obj.suitContainer then
      local item
      local go = self.suitContainer:Instantiate(self.DesContent.transform, self.DesContent)
      go.name = self.suitContainer.gameObject.name
      item = UIControl()
      item.transform = go.transform
      item:SetActive(true)
      obj.suitContainer = item
      if not obj.DetailUIContainer then
        local lab_TipSuitAdditional = obj.suitContainer:GetChild("lab_TipSuitAdditional")
        obj.DetailUIContainer = UIContainer(lab_TipSuitAdditional, self, DetailUICtr, DetailUIRefresh)
      end
    else
      obj.suitContainer:SetActive(true)
    end
    obj.DetailUIContainer:SetData(v.DesGrop)
    obj:SetActive(true)
  end
end

function System_ForecastUI:RefreshPlayPreviewpanel(data)
  self:ShowDescribe(data.content)
  local giftTbl = ClientTable.cfg_Gift_giftManager:TryGetValue(data.giftId, "id")
  local BoxItem = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(giftTbl.reward))
  self.PlayPreview_3DItemContainer:SetData(BoxItem)
  local Finish = data.conditionget and ConditionManager.Check(data.conditionget)
  self.btn_PlayPreviewGoto.data = data
  self.btn_PlayPreviewget.data = data
  self.tips_PlayPreview:SetText(data.txtCod)
  self.tips_PlayPreview:SetActive(not data.Red and not Finish)
  self.btn_PlayPreviewGoto:SetActive(Finish and not string.isNullOrEmpty(data.uiName))
  self.btn_PlayPreviewget:SetActive(data.Red and not Finish)
end

function System_ForecastUI:RefreshPanel2()
  self.SynthesisInfoContainer:SetData(self.Info2)
end

function System_ForecastUI:RefreshPanel3()
  self.EquipInfoContainer:SetData(self.Info3)
end

function System_ForecastUI.OnEquipInfoCreat(ctr)
  ctr.lab_equipName = UIControl(ctr.transform, "itemTitle")
  ctr.btn_item = UIControl(ctr.transform, "Viewport/content/btn_3DItem")
end

function System_ForecastUI.OnEquipInfoRefresh(ctr, _, data, ui)
  ctr.lab_equipName:SetText(data.suitname)
  if ctr.EquipItemContainer == nil then
    ctr.EquipItemContainer = UIContainer(ctr.btn_item, ui, System_ForecastUI.OnEquipItemCreat, System_ForecastUI.OnEquipItemRefresh)
  end
  local itemId = string.split(data.suitid, "#")
  ctr.EquipItemContainer:SetData(itemId)
end

function System_ForecastUI.OnEquipItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

function System_ForecastUI.OnEquipItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(tonumber(data))
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

function System_ForecastUI.OnSynthesisInfoCreat(ctr)
  ctr.lab_synthesisName = UIControl(ctr.transform, "itemTitle")
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform, "btn_3DItem"))
  ctr.modelData = ItemCellData()
  ctr.btn_item = UIControl(ctr.transform, "Viewport/content/btn_3DItem")
end

function System_ForecastUI.OnSynthesisInfoRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.synthesisid)
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  if ctr.EquipItemContainer == nil then
    ctr.EquipItemContainer = UIContainer(ctr.btn_item, ui, ui.OnSynthesisItemCreat, ui.OnSynthesisItemRefresh)
  end
  local item = string.split(data.synthesiscostid, "&")
  local synthesisCostCount = #item
  for i = 1, #item do
    item[i] = item[i] .. "#" .. synthesisCostCount
  end
  ctr.EquipItemContainer:SetData(item)
end

function System_ForecastUI.OnSynthesisItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
  ctr.img_add = UIControl(ctr.transform, "img_add")
end

function System_ForecastUI.OnSynthesisItemRefresh(ctr, _, data, ui)
  local item = string.split(data, "#")
  local itemData = ItemUtility.GenerateItemData(tonumber(item[1]))
  itemData.count = tonumber(item[2])
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  local synthesisCostCount = tonumber(item[3])
  ctr.img_add:SetActive(_ < synthesisCostCount)
end
