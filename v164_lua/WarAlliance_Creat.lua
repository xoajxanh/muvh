WarAlliance_Creat = class(BaseUI)
WarAlliance_Creat.layer = UILayer.Panel
WarAlliance_Creat.orderInLayer = 2
WarAlliance_Creat.hideType = UIHideType.Destroy
WarAlliance_Creat.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_Creat.escClose = UIEscClose.DontClose

function WarAlliance_Creat:InitControls()
  self.panel_left = self:GetControl("panel_left")
  self.btn_closeBg = self:GetControl("panel_left/btn_closeBg")
  self.bg_frame = self:GetControl("panel_left/bg_frame")
  self.CloseBtn = self:GetControl("panel_left/bg_frame/CloseBtn")
  self.WarAllianceSetting = self:GetControl("panel_left/WarAllianceSetting")
  self.WarAllianceNameInput = self:GetControl("panel_left/WarAllianceSetting/WarAllianceName/WarAllianceNameInput")
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

function WarAlliance_Creat:OnPreLoad()
end

function WarAlliance_Creat:Init()
  self.ArmbandsColorData = {}
end

function WarAlliance_Creat:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_Creat:InitUI()
  self:InitContent()
end

function WarAlliance_Creat:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_Creat:OnHide()
end

function WarAlliance_Creat:OnDestroy()
end

function WarAlliance_Creat:RegistUIEvents()
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
  self.WarAllianceNameInput:SetOnValueChanged(self, self.WarAllianceNameInputValueChanged)
  self.WarAllianceNameInput:SetOnEndEdit(self, self.WarAllianceNameInputEndEdit)
end

function WarAlliance_Creat:WarAllianceNameInputValueChanged(control)
  self.limit = self.WarAllianceNameInput.transform:GetComponent("InputField")
  if self.limit.characterLimit ~= 9 then
    self.limit.characterLimit = 9
  end
end

function WarAlliance_Creat:WarAllianceNameInputEndEdit(control)
  local inputText = self.WarAllianceNameInput:GetInputText()
  local length = string.GetKoreanStrCount(inputText)
  if 7 < length then
    self.limit.text = string.KoreanStrSub(inputText, 1, 6)
  end
  self.limit = 7
end

function WarAlliance_Creat:CloseBtnOnClick(control)
  UIManager.Hide(UIID.WarAlliance_Creat)
end

function WarAlliance_Creat:BadgeExaOnClick(num)
  for i = 1, #self.ArmbandsColorData do
    local color = WarAllianceData.ColorGridData[WarAllianceData.BadgeColorData[num][i]]
    self.ArmbandsColorData[i]:SetColor(WarAllianceData.ColorGridData[WarAllianceData.BadgeColorData[num][i]])
    self.ArmbandsColorData[i]:SetActive(color ~= WarAllianceData.ColorGridData[1])
  end
end

function WarAlliance_Creat:NotarizeCreateBtnOnClick(control)
  if not self.canCreate then
    LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughGold, control)
    return
  end
  local WarAllianceUIName = self.WarAllianceNameInput:GetInputText()
  local colorData = {}
  for i = 1, #self.ArmbandsColorData do
    local logoNum = ColorUtility.ColorToInt(self.ArmbandsColorData[i]:GetColor())
    if logoNum == WarAllianceData.lucencyColor then
      logoNum = 0
    end
    colorData[i] = logoNum
  end
  NetManager.Send(UnionMessage.ReqCreateUnion, {name = WarAllianceUIName, logo = colorData})
end

function WarAlliance_Creat:CancelCreateBtnOnClick(control)
  self:CloseBtnOnClick()
end

local function Button_ArmletColorItemCreate(control)
  control.colorBg = UIControl(control.transform, "colorBg")
end

function WarAlliance_Creat:InitContent()
  self.Button_ArmletColorItemTemp = UIContainer(self.Button_ArmletColorItem, self, Button_ArmletColorItemCreate)
  self.Button_ColorItemTemp = UIContainer(self.Button_ColorItem)
end

function WarAlliance_Creat:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshGlobal, self)
end

function WarAlliance_Creat:Refresh()
  self:RefreshGlobal()
  self:InitArmbandsDesignGrid()
  self:InitColorGrid()
end

function WarAlliance_Creat:RefreshGlobal()
  self.canCreate = false
  local globalID = 10000002
  local goldTbl = ClientTable.cfg_Global_globalManager:TryGetValue(globalID)
  local effects = string.split(goldTbl.effect, "/")
  local itemID, needCount
  for index, effect in ipairs(effects) do
    local temp = string.split(effect, "#")
    itemID = tonumber(temp[1])
    needCount = tonumber(temp[2])
    local haveCount = BagInfoData.GetItemTotalCountByItemId(itemID)
    if needCount <= haveCount then
      self.canCreate = true
      break
    end
  end
  local countText
  if self.canCreate then
    countText = string.GetColorText(needCount, ItemQuality2ColorDic[0])
  else
    countText = string.GetColorText(needCount, ItemQuality2ColorDic[24])
  end
  self.lab_Expenditure:SetText(countText)
  local itemData = ItemUtility.GenerateItemData(itemID)
  self.btn_3DItem.itemCellData = self.btn_3DItem.itemCellData or ItemCellData()
  self.btn_3DItem.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.btn_3DItem.itemCellData, self, true)
end

local SelectColor

function WarAlliance_Creat:InitArmbandsDesignGrid()
  local num = WarAllianceData.ArmbandsDesignGridNum
  self.ArmbandsColorData = {}
  for i = 1, num do
    local obj = self.Button_ArmletColorItemTemp:GetOrCreateItem(i)
    obj:SetColor(WarAllianceData.lucencyColor)
    obj.colorBg:SetColor(WarAllianceData.lucencyColor)
    obj.colorBg:SetActive(false)
    obj:SetOnClick(self, self.ColorChangeOnClick)
    table.insert(self.ArmbandsColorData, obj.colorBg)
  end
end

function WarAlliance_Creat:ColorChangeOnClick(control)
  if SelectColor then
    control.colorBg:SetColor(SelectColor)
    control.colorBg:SetActive(SelectColor ~= WarAllianceData.ColorGridData[1])
  end
end

function WarAlliance_Creat:InitColorGrid()
  local num = WarAllianceData.ColorGridNum
  local ColorData = WarAllianceData.ColorGridData
  for i = 1, num do
    local obj = self.Button_ColorItemTemp:GetOrCreateItem(i)
    obj:SetColor(ColorData[i])
    obj:SetOnClick(self, function()
      self:ColorSelectOnClick(ColorData[i])
    end)
  end
  self.WarAllianceNameInput:SetInputText()
end

function WarAlliance_Creat:ColorSelectOnClick(color)
  self.CurrentlySelected:SetColor(color)
  SelectColor = color
end
