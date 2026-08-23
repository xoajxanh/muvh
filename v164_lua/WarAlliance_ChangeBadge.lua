WarAlliance_ChangeBadge = class(BaseUI)
WarAlliance_ChangeBadge.layer = UILayer.Panel
WarAlliance_ChangeBadge.orderInLayer = 2
WarAlliance_ChangeBadge.hideType = UIHideType.WaitDestroy
WarAlliance_ChangeBadge.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_ChangeBadge.escClose = UIEscClose.DontClose

function WarAlliance_ChangeBadge:InitControls()
  self.panel_left = self:GetControl("panel_left")
  self.btn_closeBg = self:GetControl("panel_left/btn_closeBg")
  self.bg_frame = self:GetControl("panel_left/bg_frame")
  self.CloseBtn = self:GetControl("panel_left/bg_frame/CloseBtn")
  self.WarAllianceSetting = self:GetControl("panel_left/WarAllianceSetting")
  self.warAllianceName = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/warAllianceName")
  self.lab_Expenditure = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/Expenditure/lab_Expenditure")
  self.btn_3DItem = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/Expenditure/lab_Expenditure/btn_3DItem")
  self.NotarizeCreateBtn = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/NotarizeCreateBtn")
  self.CancelCreateBtn = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/CancelCreateBtn")
  self.badgeOne = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/RecommendBtn/bg_badge1/badgeOne")
  self.badgeOneChoose = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/RecommendBtn/bg_badge1/badgeOneChoose")
  self.badgeTwo = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/RecommendBtn/bg_badge2/badgeTwo")
  self.badgeTwoChoose = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/RecommendBtn/bg_badge2/badgeTwoChoose")
  self.badgeThree = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/RecommendBtn/bg_badge3/badgeThree")
  self.badgeThreeChoose = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/RecommendBtn/bg_badge3/badgeThreeChoose")
  self.badgeFour = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/RecommendBtn/bg_badge4/badgeFour")
  self.badgeFourChoose = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/RecommendBtn/bg_badge4/badgeFourChoose")
  self.badgeFive = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/RecommendBtn/bg_badge5/badgeFive")
  self.badgeFiveChoose = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/RecommendBtn/bg_badge5/badgeFiveChoose")
  self.Button_ArmletColorItem = self:GetControl("panel_left/WarAllianceSetting/ArmbandsStyle/ArmbandsStylePanel/Viewport/Content/Button_ArmletColorItem")
  self.CurrentlySelected = self:GetControl("panel_left/WarAllianceSetting/ArmbandsStyle/CurrentlySelected")
  self.Button_ColorItem = self:GetControl("panel_left/WarAllianceSetting/ArmbandsStyle/ColorTypePanel/Viewport/Content/Button_ColorItem")
end

function WarAlliance_ChangeBadge:OnPreLoad()
end

function WarAlliance_ChangeBadge:Init()
end

function WarAlliance_ChangeBadge:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_ChangeBadge:InitUI()
  self:InitContent()
end

function WarAlliance_ChangeBadge:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_ChangeBadge:OnHide()
end

function WarAlliance_ChangeBadge:OnDestroy()
end

function WarAlliance_ChangeBadge:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.CloseBtnOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.NotarizeCreateBtn:SetOnClick(self, self.NotarizeCreateBtnOnClick)
  self.CancelCreateBtn:SetOnClick(self, self.CancelCreateBtnOnClick)
  self.badgeOne:SetOnClick(self, function()
    self:BadgeExaOnClick(1)
  end)
  self.badgeTwo:SetOnClick(self, function()
    self:BadgeExaOnClick(2)
  end)
  self.badgeThree:SetOnClick(self, function()
    self:BadgeExaOnClick(3)
  end)
  self.badgeFour:SetOnClick(self, function()
    self:BadgeExaOnClick(4)
  end)
  self.badgeFive:SetOnClick(self, function()
    self:BadgeExaOnClick(5)
  end)
end

function WarAlliance_ChangeBadge:CloseBtnOnClick(control)
  UIManager.Hide(UIID.WarAlliance_ChangeBadge)
end

function WarAlliance_ChangeBadge:BadgeExaOnClick(num)
  for i = 1, #self.ArmbandsColorData do
    local color = WarAllianceData.ColorGridData[WarAllianceData.BadgeColorData[num][i]]
    self.ArmbandsColorData[i]:SetColor(WarAllianceData.ColorGridData[WarAllianceData.BadgeColorData[num][i]])
    self.ArmbandsColorData[i]:SetActive(color ~= WarAllianceData.ColorGridData[1])
  end
end

function WarAlliance_ChangeBadge:NotarizeCreateBtnOnClick(control)
  if not self.canChange then
    LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughGold, control)
    return
  end
  local colorData = {}
  for i = 1, #self.ArmbandsColorData do
    local logoNum = ColorUtility.ColorToInt(self.ArmbandsColorData[i]:GetColor())
    if logoNum == WarAllianceData.lucencyColor then
      logoNum = 0
    end
    colorData[i] = logoNum
  end
  NetManager.Send(UnionMessage.ReqUnionInfoChange, {type = 2, logo = colorData})
end

function WarAlliance_ChangeBadge:CancelCreateBtnOnClick(control)
  self:CloseBtnOnClick()
end

local function Button_ArmletColorItemCreate(control)
  control.colorBg = UIControl(control.transform, "colorBg")
end

function WarAlliance_ChangeBadge:InitContent()
  self.Button_ArmletColorItemTemp = UIContainer(self.Button_ArmletColorItem, self, Button_ArmletColorItemCreate)
  self.Button_ColorItemTemp = UIContainer(self.Button_ColorItem)
end

function WarAlliance_ChangeBadge:RegistEvents()
  self:RegistEvent(Event.WarAlliance_MyWarAllianceData, self.RefreshWarAllianceInfo, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshGlobal, self)
end

function WarAlliance_ChangeBadge:Refresh()
  self:RefreshGlobal()
  self:RefreshWarAllianceInfo()
  self:InitColorGrid()
end

function WarAlliance_ChangeBadge:RefreshGlobal()
  self.canChange = false
  local globalID = 10000007
  local goldTbl = ClientTable.cfg_Global_globalManager:TryGetValue(globalID)
  local effects = string.split(goldTbl.effect, "/")
  local itemID, needCount
  for index, effect in ipairs(effects) do
    local temp = string.split(effect, "#")
    itemID = tonumber(temp[1])
    needCount = tonumber(temp[2])
    local haveCount = BagInfoData.GetItemTotalCountByItemId(itemID)
    if needCount <= haveCount then
      self.canChange = true
      break
    end
  end
  local countText
  if self.canChange then
    countText = string.GetColorText(needCount, ItemQuality2ColorDic[0])
  else
    countText = string.GetColorText(needCount, ItemQuality2ColorDic[11])
  end
  self.lab_Expenditure:SetText(countText)
  local itemData = ItemUtility.GenerateItemData(itemID)
  self.btn_3DItem.itemCellData = self.btn_3DItem.itemCellData or ItemCellData()
  self.btn_3DItem.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.btn_3DItem.itemCellData, self, true)
end

function WarAlliance_ChangeBadge:RefreshWarAllianceInfo()
  local data = WarAllianceData.MyWarAllianceData
  if data ~= nil and data.name ~= nil then
    self.warAllianceName:SetText(WarAllianceData.MyWarAllianceData.name)
  end
  self.Button_ArmletColorItemTemp:SetActiveTable()
  if data ~= nil and data.logo ~= nil then
    local num = WarAllianceData.ArmbandsDesignGridNum
    self.ArmbandsColorData = {}
    for i = 1, num do
      local obj = self.Button_ArmletColorItemTemp:GetOrCreateItem(i)
      obj:SetActive(true)
      obj.colorBg:SetActive(data.logo[i] ~= 0)
      obj.colorBg:SetColor(WarAllianceData.lucencyColor)
      if data.logo[i] ~= 0 then
        obj.colorBg:SetColor(data.logo[i])
      end
      obj:SetOnClick(self, self.ColorChangeOnClick)
      table.insert(self.ArmbandsColorData, obj.colorBg)
    end
  end
end

local SelectColor

function WarAlliance_ChangeBadge:ColorChangeOnClick(control)
  if SelectColor then
    control.colorBg:SetColor(SelectColor)
    control.colorBg:SetActive(SelectColor ~= WarAllianceData.ColorGridData[1])
  end
end

function WarAlliance_ChangeBadge:InitColorGrid()
  local num = WarAllianceData.ColorGridNum
  local ColorData = WarAllianceData.ColorGridData
  for i = 1, num do
    local obj = self.Button_ColorItemTemp:GetOrCreateItem(i)
    obj:SetColor(ColorData[i])
    obj:SetOnClick(self, function()
      self:ColorSelectOnClick(ColorData[i])
    end)
  end
end

function WarAlliance_ChangeBadge:ColorSelectOnClick(color)
  self.CurrentlySelected:SetColor(color)
  SelectColor = color
end
