Tip_ItemTipTwoUI = class(BaseUI)
Tip_ItemTipTwoUI.layer = UILayer.Tip
Tip_ItemTipTwoUI.orderInLayer = 8
Tip_ItemTipTwoUI.hideType = UIHideType.WaitDestroy
Tip_ItemTipTwoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_ItemTipTwoUI.escClose = UIEscClose.DontClose

function Tip_ItemTipTwoUI:InitControls()
  self.btn_Close = self:GetControl("btn_Close")
  self.go_obtain = self:GetControl("ExtendPanel/go_obtain")
  self.img_obtainBg = self:GetControl("ExtendPanel/go_obtain/img_obtainBg")
  self.grid_obtain = self:GetControl("ExtendPanel/go_obtain/grid_obtain")
  self.bg_obtain = self:GetControl("ExtendPanel/go_obtain/grid_obtain/bg_obtain")
  self.buy_thing = self:GetControl("ExtendPanel/go_obtain/grid_obtain/buy_thing")
  self.model_item = self:GetControl("ExtendPanel/go_obtain/grid_obtain/buy_thing/model_item")
  self.btn_quick_buy = self:GetControl("ExtendPanel/go_obtain/grid_obtain/buy_thing/btn_quick_buy")
  self.model_money = self:GetControl("ExtendPanel/go_obtain/grid_obtain/buy_thing/model_money")
  self.model_money_Num = self:GetControl("ExtendPanel/go_obtain/grid_obtain/buy_thing/model_money/lab_num")
  self.img_itemicon = self:GetControl("ExtendPanel/go_obtain/grid_obtain/buy_thing/img_itemicon")
  self.count = self:GetControl("ExtendPanel/go_obtain/grid_obtain/buy_thing/count")
  self.Img_TipBg = self:GetControl("Img_TipBg")
  self.tips = self:GetControl("tips")
  self.directBuyPanel = self:GetControl("Img_TipBg/go_top/directBuyPanel")
  self.btn_directBuyPanelBuy = self:GetControl("Img_TipBg/go_top/directBuyPanel/btn_directBuyPanelBuy")
  self.lab_count = self:GetControl("Img_TipBg/go_top/directBuyPanel/count/lab_count")
  self.btn_add = self:GetControl("Img_TipBg/go_top/directBuyPanel/count/btn_add")
  self.btn_minus = self:GetControl("Img_TipBg/go_top/directBuyPanel/count/btn_minus")
end

function Tip_ItemTipTwoUI:OnPreLoad()
end

local function OnObtainCreate(ctr)
  ctr.lab_obtainName = UIControl(ctr.transform, "lab_obtainName")
  ctr.img_bg = UIControl(ctr.transform, "img_bg")
end

local function OnObtainRefresh(ctr, _, obtainTbl, ui)
  local s = ClientTable.cfg_Item_itemManager:TryGetValue(ui.args.item.itemId)
  local color = ""
  ctr.lab_obtainName:SetText(string.GetColorText(obtainTbl.uiName, color))
  ctr.img_bg.obtainTbl = obtainTbl
  if ui.args ~= nil then
    ctr.img_bg.args = ui.args.ctrl
  end
  ctr.img_bg:SetOnClick(ui, ui.OpenObtain)
end

local function OnUpgradeCreate(ctr)
  ctr.lab_TipUpgradeKK = UIControl(ctr.transform, "lab_TipUpgradeKK")
  ctr.lab_TipUpgradeSS = UIControl(ctr.transform, "lab_TipUpgradeSS")
end

local function OnUpgradeRefresh(ctr, index, breachTbl, ui)
  local nameStr = RoleEquipUtility.GetExcellenceShowById(breachTbl.excellentId)
  local nextLevel = ui.breachTable.level
  local activateState
  local ssStr = ""
  if nextLevel >= breachTbl.level then
    activateState = true
  else
    activateState = false
    if ui.args.item.level >= (breachTbl.level - 1) * 10 then
      ssStr = string.GetColorText("C\195\179 th\225\187\131 k\195\173ch ho\225\186\161t", ItemQuality2ColorDic[EItemColorEnum.green])
    else
      ssStr = string.GetColorText((breachTbl.level - 1) * 10 .. " c\225\186\165p c\195\179 th\225\187\131 k\195\173ch ho\225\186\161t", ItemQuality2ColorDic[EItemColorEnum.gray])
    end
  end
  local color = activateState and ItemQuality2ColorDic[EItemColorEnum.blue] or ItemQuality2ColorDic[EItemColorEnum.gray]
  nameStr = string.GetColorText(nameStr, color)
  ctr.lab_TipUpgradeKK:SetText(nameStr)
  ctr.lab_TipUpgradeSS:SetText(ssStr)
end

function Tip_ItemTipTwoUI:OpenObtain(ctr)
  if ctr.obtainTbl.id == 999 then
    UIManager.Hide(UIID.ItemTipUI)
    RechargeData.BuyDiamond(self.args.BusinessPay)
    return
  end
  if ctr.obtainTbl.name == "Activity_IndexUI" then
    NetManager.Send(RoleMessage.ReqActiveAndFind)
    return
  end
  if ctr.obtainTbl.name == "Instance_GoldOriginUI" then
    PathFinderManager.JumpMapMoveToNpc({npcId = 1001027}, nil, Purpose.ClickNpc)
    return
  end
  if ctr.obtainTbl.name == "Equip_RunesNavUI" then
    EventManager.Dispatch(Event.ObtainToJumpRunesNavUI, ctr.obtainTbl.position)
    return
  end
  local args = Tip_ItemTipTwoUI:GetExtraArgs(ctr)
  if args.combineId ~= nil and args.combineId ~= 0 then
    self:Compound(args)
    return
  end
  if ctr.obtainTbl.type and ctr.obtainTbl.type == 1 then
    ctr.obtainTbl.route = ctr.obtainTbl.name
    NavigationUtility.OpenPanel(ctr.obtainTbl)
  else
    UIManager.JumpShow(UIPanelType.SortAndHide, ctr.obtainTbl.name, args)
  end
end

function Tip_ItemTipTwoUI:GetExtraArgs(ctr)
  local extraArgs = {}
  if ctr.args ~= nil and ctr.args.itemBuyID ~= nil then
    extraArgs = {
      openFirstTab = ctr.obtainTbl.subSubType,
      openSecondTab = ctr.obtainTbl.position,
      itemBuyID = ctr.args.itemBuyID
    }
  else
    extraArgs = {
      openFirstTab = ctr.obtainTbl.subSubType,
      openSecondTab = ctr.obtainTbl.position,
      TipJump = true
    }
  end
  if ctr.obtainTbl.name == UIID.Item_CombineUI then
    if ctr.obtainTbl.position and ctr.obtainTbl.position > 0 then
      extraArgs = {}
      extraArgs.combineId = ctr.obtainTbl.position
    end
  elseif ctr.obtainTbl.type == 2 then
    extraArgs.shopID = ctr.obtainTbl.shopId
  end
  return extraArgs
end

function Tip_ItemTipTwoUI:Init()
  self.minWidth = 360
  self.maxCenterHeight = 315
  self.modelExtLine = 0
  self.minSpaceLine = 5
  self.maxSpaceLine = 5
  self.bottomHeight = 8
  self.modelSpace = 20
  self.minDisToScreenBottom = 50
  self.minDisToScreenLeft = 100
  self.disTipsToTips = 1
  self.titleSpaceLine = 5
  self.tipTopPos = 680
  self.tipDevX = 50
  self.modelWidth = 250
  self.tipsTbl = {
    tips = {},
    contrastTips = {isContrast = true}
  }
  self.fastBuyModel1 = ItemCellData()
  self.fastBuyModel2 = ItemCellData()
  self.suitTblattributesForBannerBugleSuit = {}
  self.bannerBugleSuitforAdd15Tbl = {}
end

local ExcellenceTbl = {
  client_physAndWizBaseDmg = "constant",
  minimumPhysBaseDmg = "constant",
  maximumWizBaseDmg = "constant",
  minimumWizBaseDmg = "constant",
  maximumCurseBaseDmg = "constant",
  minimumCurseBaseDmg = "constant",
  attackSpeed = "constant",
  maximumAbility = "constant"
}

function Tip_ItemTipTwoUI:OnCreate()
  self:InitControls()
  self:BindTemplates()
  self:InitUI()
  self:RegistUIEvents()
end

local function InitRuneAttributeUI(control)
  control.equipRuneCellData = ItemCellData()
  control.ima_Model = UIControl(control.transform, "go_model")
  control.lab_RunesName = UIControl(control.transform, "lab_RunesName")
  control.lab_RunesAttribute = UIControl(control.transform, "lab_RunesAttribute")
end

local function RefreshRuneAttribute(ctr, _, data, ui)
  if data == nil then
    return
  end
  local height = _ == 1 and 20 or 15
  local itemCfgTab = ClientTable.cfg_Item_itemManager:TryGetValue(data.itemId)
  local cfgTab = ClientTable.cfg_Runes_inlayManager:GetItemCfgData(data.itemId)
  if itemCfgTab == nil or cfgTab == nil then
    return
  end
  ui:SetSprite("Atlas_Common", tostring(itemCfgTab.icon), ctr.ima_Model, true)
  ctr.ima_Model:SetNativeSize()
  data.tips.centerHeight = data.tips.centerHeight + height
  local modelX = ctr.ima_Model:GetAnchoredPosition()
  ctr.ima_Model:SetAnchoredPosition(modelX, -data.tips.centerHeight)
  local nameX = ctr.lab_RunesName:GetAnchoredPosition()
  ctr.lab_RunesName:SetAnchoredPosition(nameX, -data.tips.centerHeight)
  local nameStr = string.GetColorText(cfgTab.runesName, ItemQuality2ColorDic[itemCfgTab.quality])
  if data.level ~= 0 then
    nameStr = string.GetColorText(string.format("%s +%d", nameStr, data.level), ItemQuality2ColorDic[itemCfgTab.quality])
  end
  ctr.lab_RunesName:SetText(nameStr)
  data.tips.centerHeight = data.tips.centerHeight + 15
  local textX = ctr.lab_RunesAttribute:GetAnchoredPosition()
  ctr.lab_RunesAttribute:SetAnchoredPosition(textX, -data.tips.centerHeight)
  ctr.lab_RunesAttribute:SetText(table.concat(data.attribute, "\n"))
  data.tips.centerHeight = data.tips.centerHeight + ctr.lab_RunesAttribute.text.preferredHeight + 5
end

local function InitHolySkeletonAttributeUI(control)
  control.CellData = ItemCellData()
  control.ima_Model = UIControl(control.transform, "go_model")
  control.lab_Name = UIControl(control.transform, "lab_HolySkeletonName")
  control.lab_Attribute = UIControl(control.transform, "lab_HolySkeletonAttribute")
end

local function RefreshHolySkeletonAttribute(ctr, _, data, ui)
  if data == nil then
    return
  end
  local height = _ == 1 and 15 or 12
  local itemCfg = ClientTable.cfg_Item_itemManager:TryGetValue(data.sacredBonetbl.itemInfo.itemId)
  ui:SetSprite("Atlas_Common", tostring(itemCfg.icon), ctr.ima_Model, false)
  data.tips.centerHeight = data.tips.centerHeight + height
  local modelX = ctr.ima_Model:GetAnchoredPosition()
  ctr.ima_Model:SetAnchoredPosition(modelX, -data.tips.centerHeight)
  local nameX = ctr.lab_Name:GetAnchoredPosition()
  ctr.lab_Name:SetAnchoredPosition(nameX, -data.tips.centerHeight)
  ctr.lab_Name:SetText(ClientTable.cfg_Bone_attributeManager:GetAttrDesBySacredBoneInfoData(data.sacredBonetbl))
  data.tips.centerHeight = data.tips.centerHeight + 12
  local textX = ctr.lab_Attribute:GetAnchoredPosition()
  ctr.lab_Attribute:SetAnchoredPosition(textX, -data.tips.centerHeight)
  ctr.lab_Attribute:SetActive(false)
end

function Tip_ItemTipTwoUI:InitUI()
  self:LocalInit()
  self.Img_TipBg:SetActive(false)
  self.obtainWidth, self.obtainHeight = self.bg_obtain:GetSizeDelta()
  self.buy_thing:SetActive(false)
  self.obtainContainer = UIContainer(self.bg_obtain, self, OnObtainCreate, OnObtainRefresh)
  local bannerBugleSuitStr = GlobalConfig.GetGlobalConfig(60000016)
  self.suitTblattributesForBannerBugleSuit = string.split(bannerBugleSuitStr, "#")
  self.bannerBugleSuitforAdd15Tbl = MeEquipController.GetSuitCfg(270001, 15)
  for name, tips in pairs(self.tipsTbl) do
    local obj = self.Img_TipBg:Instantiate(nil, name)
    local objCtr = UIControl(obj.transform)
    tips.Img_TipBg = objCtr
    tips.img_topBg = UIControl(objCtr.transform, "go_top/img_topBg")
    tips.img_top = UIControl(objCtr.transform, "go_top/img_topBg/img_top")
    tips.lab_TipTitle = UIControl(objCtr.transform, "go_top/lab_TipTitle")
    tips.go_model = UIControl(objCtr.transform, "go_top/Tip_ModelShow/go_model")
    tips.Tip_ModelShow = UIControl(objCtr.transform, "go_top/Tip_ModelShow")
    tips.modelData = ItemCellData()
    tips.lab_TipTopInfo = UIControl(objCtr.transform, "go_top/lab_TipTopInfo")
    tips.plane_bottom = UIControl(objCtr.transform, "go_top/Tip_ModelShow/plane_bottom")
    tips.lab_itemclass = UIControl(objCtr.transform, "go_top/lab_itemclass")
    tips.sv_center = UIControl(objCtr.transform, "sv_center")
    tips.Content = UIControl(objCtr.transform, "sv_center/Viewport/Content")
    tips.img_centerBg = UIControl(objCtr.transform, "sv_center/img_centerBg")
    tips.lab_TipAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipAttribute")
    tips.title_attributeEnchantment = UIControl(objCtr.transform, "sv_center/Viewport/Content/title_attributeEnchantment")
    tips.title_attributeEnchantmentDetail = UIControl(objCtr.transform, "sv_center/Viewport/Content/title_attributeEnchantmentDetail")
    tips.lab_attribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_attribute")
    tips.lab_TipAttributeEnchantment = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipAttributeEnchantment")
    tips.lab_TipAttributeEnchantmentDetail = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipAttributeEnchantmentDetail")
    tips.lab_ConsumAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_ConsumAttribute")
    tips.lab_TipIntensify = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipIntensify")
    tips.lab_TipZhuiJia = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipZhuiJia")
    tips.lab_Luck = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_Luck")
    tips.lab_TipLuck = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipLuck")
    tips.lab_Skill = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_Skill")
    tips.lab_TipSkill = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipSkill")
    tips.lab_excellent = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_excellent")
    tips.lab_TipExcellentAdditional = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipExcellentAdditional")
    tips.lab_excellentInherit = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_excellentInherit")
    tips.lab_TipExcellentInherit = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipExcellentInherit")
    tips.lab_VIPattribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_VIPattribute")
    tips.lab_VIPTipAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_VIPTipAttribute")
    tips.lab_suitAdditional = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_suitAdditional")
    tips.suitContainer = UIControl(objCtr.transform, "sv_center/Viewport/Content/suitContainer")
    tips.lab_TipSuitAdditional = UIControl(objCtr.transform, "sv_center/Viewport/Content/suitContainer/lab_TipSuitAdditional")
    tips.lab_StoneAdditional = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_StoneAdditional")
    tips.lab_TipStoneAdditional = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipStoneAdditional")
    tips.lab_TipStoneLightAdditional = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipStoneLightAdditional")
    tips.lab_growUp = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_growUp")
    tips.lab_TipGrowUp = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipGrowUp")
    tips.sl_expGrowUp = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipGrowUp/lab_TipGrowUpExp/sl_exp")
    tips.lab_TipGrowUpExpNum = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipGrowUp/lab_TipGrowUpExp/lab_TipGrowUpExpNum")
    tips.lab_ModelShow = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_ModelShow")
    tips.lab_ModelShowModel = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_ModelShow/lab_model")
    tips.lab_TipJewelryCur = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipJewelryCur")
    tips.lab_TipJewelryNext = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipJewelryNext")
    tips.grid_jewelyUpgrade = UIControl(objCtr.transform, "sv_center/Viewport/Content/grid_jewelyUpgrade")
    tips.go_Upgrade = UIControl(objCtr.transform, "sv_center/Viewport/Content/grid_jewelyUpgrade/go_Upgrade")
    tips.lab_TipEquipDura = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipEquipDura")
    tips.lab_bugle = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_bugle")
    tips.lab_TipBugleAdditional = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipBugleAdditional")
    tips.lab_flag = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_flag")
    tips.lab_TipFlagAdditional = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipFlagAdditional")
    tips.upgradeContainer = UIContainer(tips.go_Upgrade, self, OnUpgradeCreate, OnUpgradeRefresh)
    tips.lab_SpecialAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_SpecialAttribute")
    tips.lab_TipSpecialAttributeAdditional = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipSpecialAttributeAdditional")
    tips.Img_bottom = UIControl(objCtr.transform, "go_bottom")
    tips.img_downBg = UIControl(objCtr.transform, "go_bottom/img_downBg")
    tips.img_down = UIControl(objCtr.transform, "go_bottom/img_downBg/img_down")
    tips.lab_TipItemTips = UIControl(objCtr.transform, "go_bottom/Scroll_DownTips/Viewport/Content/lab_TipItemTips")
    tips.lab_ResidueDegree = UIControl(objCtr.transform, "go_bottom/lab_ResidueDegree")
    tips.lab_TipCountDownTime = UIControl(objCtr.transform, "go_bottom/lab_TipCountDownTime")
    tips.lab_TipEquipTime = UIControl(objCtr.transform, "go_bottom/lab_TipEquipTime")
    tips.Scroll_DownTips = UIControl(objCtr.transform, "go_bottom/Scroll_DownTips")
    tips.img_line = UIControl(objCtr.transform, "go_bottom/img_line")
    tips.mount_bottom = UIControl(objCtr.transform, "go_bottom/img_line/mount_bottom")
    tips.go_btns = UIControl(objCtr.transform, "go_bottom/go_btns")
    tips.btn_RightClick = UIControl(objCtr.transform, "go_bottom/go_btns/btn_RightClick")
    tips.lab_rightBtn = UIControl(objCtr.transform, "go_bottom/go_btns/btn_RightClick/lab_rightBtn")
    tips.btn_LeftClick = UIControl(objCtr.transform, "go_bottom/go_btns/btn_LeftClick")
    tips.lab_leftBtn = UIControl(objCtr.transform, "go_bottom/go_btns/btn_LeftClick/lab_leftBtn")
    tips.btn_CenterClick = UIControl(objCtr.transform, "go_bottom/go_btns/btn_CenterClick")
    tips.lab_centerBtn = UIControl(objCtr.transform, "go_bottom/go_btns/btn_CenterClick/lab_centerBtn")
    tips.Img_moreBg = UIControl(objCtr.transform, "go_bottom/go_btns/Img_moreBg")
    tips.btn_MoreClick = UIControl(objCtr.transform, "go_bottom/go_btns/Img_moreBg/btn_MoreClick")
    tips.txt_itemId = UIControl(objCtr.transform, "go_bottom/txt_itemId")
    tips.directBuyPanel = UIControl(objCtr.transform, "go_top/directBuyPanel")
    tips.price = UIControl(objCtr.transform, "go_top/directBuyPanel/price")
    tips.priceTitle = UIControl(objCtr.transform, "go_top/directBuyPanel/price/priceTitle")
    tips.title = UIControl(objCtr.transform, "go_top/directBuyPanel/count/title")
    tips.AuctionBtn = UIControl(objCtr.transform, "go_top/directBuyPanel/btn_directBuyPanelBuy/img_btn")
    tips.AuctionText = UIControl(objCtr.transform, "go_top/directBuyPanel/btn_directBuyPanelBuy/img_btn/Text")
    tips.AuctionInputPrice = UIControl(objCtr.transform, "go_top/directBuyPanel/price/lab_finalPriceValue2")
    tips.AuctionInputTextPrice = UIControl(objCtr.transform, "go_top/directBuyPanel/price/lab_finalPriceValue2/Text")
    tips.lab_fixedPriceValue = UIControl(objCtr.transform, "go_top/directBuyPanel/price/lab_fixedPriceValue")
    tips.lab_fixedPriceText = UIControl(objCtr.transform, "go_top/directBuyPanel/price/lab_fixedPriceValue/Placeholder")
    tips.img_icon = UIControl(objCtr.transform, "go_top/directBuyPanel/price/img_icon")
    tips.img_icon.moneyModel = ItemCellData()
    tips.count = UIControl(objCtr.transform, "go_top/directBuyPanel/count")
    tips.lab_count = UIControl(objCtr.transform, "go_top/directBuyPanel/count/lab_count")
    tips.lab_InputField = UIControl(objCtr.transform, "go_top/directBuyPanel/count/lab_InputField")
    tips.btn_add = UIControl(objCtr.transform, "go_top/directBuyPanel/count/btn_add")
    tips.btn_minus = UIControl(objCtr.transform, "go_top/directBuyPanel/count/btn_minus")
    tips.putOnTips = UIControl(objCtr.transform, "go_top/directBuyPanel/change_price/putOnTips")
    tips.lab_putOnPrice = UIControl(objCtr.transform, "go_top/directBuyPanel/change_price/putOnTips/lab_putOnPrice")
    tips.allPrice = UIControl(objCtr.transform, "go_top/directBuyPanel/allPrice")
    tips.InputAllPrice = UIControl(objCtr.transform, "go_top/directBuyPanel/allPrice/lab_AllPrice")
    tips.change_price = UIControl(objCtr.transform, "go_top/directBuyPanel/change_price")
    tips.bg_buy = UIControl(objCtr.transform, "go_top/directBuyPanel/bg_buy")
    tips.allImg_icon = UIControl(objCtr.transform, "go_top/directBuyPanel/allPrice/img_icon")
    tips.lab_regenerate = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_regenerate")
    tips.lab_Tipregenerate = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_Tipregenerate")
    tips.lab_RunesAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_RunesAttribute")
    tips.grid_RunesAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/grid_RunesAttribute")
    tips.go_RunesAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/grid_RunesAttribute/go_RunesAttribute")
    tips.go_RunesAttributeContainer = UIContainer(tips.go_RunesAttribute, self, InitRuneAttributeUI, RefreshRuneAttribute)
    tips.lab_TipRunesAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipRunesAttribute")
    tips.grid_RunesSuitAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/grid_RunesSuitAttribute")
    tips.lab_RunesSuitAdditional = UIControl(objCtr.transform, "sv_center/Viewport/Content/grid_RunesSuitAttribute/lab_TipSuitAdditional")
    tips.lab_suitAdditional_runes = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_suitAdditional_runes")
    tips.allImg_icon.moneyModel = ItemCellData()
    tips.lab_HolySkeletonAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_HolySkeletonAttribute")
    tips.grid_HolySkeletonAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/grid_HolySkeletonAttribute")
    tips.go_HolySkeletonAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/grid_HolySkeletonAttribute/go_HolySkeletonAttribute")
    tips.go_HolySkeletonAttributeContainer = UIContainer(tips.go_HolySkeletonAttribute, self, InitHolySkeletonAttributeUI, RefreshHolySkeletonAttribute)
    tips.lab_TipHolySkeletonAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipHolySkeletonAttribute")
    tips.lab_suitAdditional_HolySkeleton = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_suitAdditional_HolySkeleton")
    tips.grid_HolySkeletonSuitAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/grid_HolySkeletonSuitAttribute")
    tips.lab_HolySkeletonSuitAttribute = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipHolySkeletonAttribute")
    tips.Scroll_BagInfo = UIControl(objCtr.transform, "sv_center/Viewport/Content/Scroll_BagInfo")
    tips.btn_3DItem = UIControl(objCtr.transform, "sv_center/Viewport/Content/Scroll_BagInfo/Viewport/childContent/btn_3DItem")
    tips.btn_3DItemContainer = UIUtility.BindUIContainerTemp(tips.btn_3DItem, LuaComponentTemplates.UIItemTemplate, self, {
      isShowTips = true,
      stencil = 3,
      maskType = 3
    })
    tips.lab_excellentHonour = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_excellentHonour")
    tips.lab_TipExcellentHonourAdditional = UIControl(objCtr.transform, "sv_center/Viewport/Content/lab_TipExcellentHonourAdditional")
    tips.honour_bg = UIControl(objCtr.transform, "go_top/img_topBg/honour_bg")
    GuideUtility.AddCreatNameObj("Tip_ItemTipTwoUI", tips.btn_RightClick)
    GuideUtility.AddCreatNameObj("Tip_ItemTipTwoUI", tips.AuctionBtn)
    tips.btnName2Lab = {}
    tips.btnName2Lab[tips.btn_RightClick:GetName()] = tips.lab_rightBtn
    tips.btnName2Lab[tips.btn_LeftClick:GetName()] = tips.lab_leftBtn
    tips.btnName2Lab[tips.btn_CenterClick:GetName()] = tips.lab_centerBtn
    tips.imgTitleTbl = {}
    tips.imgContentTbl = {}
    tips.moreState = false
    tips.moreBtnList = {}
    tips.arrtibuteTable = {}
    tips.jewelryTable = {}
    tips.conditionTable = {}
    tips.additionalTable = {}
    tips.skillTable = {}
    tips.luckTable = {}
    tips.lucksTable = {}
    tips.excellentadditionalTable = {}
    tips.VIPattributeTable = {}
    tips.excellentInheritTable = {}
    tips.suitadditionalTable = {}
    tips.itemTipsTable = {}
    tips.itemStoneTable = {}
    tips.itemStoneLightTable = {}
    tips.itemSpecialTable = {}
    tips.regenerateTable = {}
    tips.itemEnchantTable = {}
    tips.itemEnchantDetailTable = {}
    tips.topHeight = 16
    tips.centerHeight = 10
    tips.bottomHeight = 10
    tips.contentHeight = 0
    tips.showTransOrDurability = false
    tips.imgWidth = 0
    tips.Scroll_DownTipsCriticalHeight = 80
    self:TipsComponentReset(tips)
  end
end

function Tip_ItemTipTwoUI:BindTemplates()
  if self.QuickBuyAmountChooseTemplate == nil then
    self.QuickBuyAmountChooseTemplate = luaTemplateManager.GetNewTemplate(self.count, LuaComponentTemplates.AmountChooseTemplate)
  end
end

function Tip_ItemTipTwoUI:RefreshAccessChannels(bagChangeType)
  local function setFastBuy()
    Coroutine.Wait(0.1)
    
    Tip_ItemTipTwoUI:SetFastBuy(Tip_ItemTipTwoUI.fastBuyId, bagChangeType)
  end
  
  Coroutine.Start(setFastBuy)
end

function Tip_ItemTipTwoUI:SetFastBuy(id, bagChangeType)
  if id == nil or tonumber(id) == nil then
    self.buy_thing:SetActive(false)
    return 0
  end
  self.fastBuyId = id
  self.buy_thing:SetActive(true)
  local itemData = ItemUtility.GenerateItemData(self.args.item.tblItem.id)
  self.fastBuyModel1:RefreshData(itemData)
  self.fastBuyModel1.itemData.count = 1
  ItemUtility.ShowItemCell(self.model_item, self.fastBuyModel1, self, true, nil, 3, 5)
  local buyNum = 99999999
  if tonumber(id) > 0 then
    local shop = ClientTable.cfg_Item_buyManager:TryGetValue(tonumber(id), "id")
    local countKey = shop.countKey
    if countKey ~= nil and countKey ~= 0 then
      local refresh = RefreshData.GetRefreshByKey(countKey)
      local countTbl = ClientTable.cfg_Count_countManager:TryGetValue(countKey, "key")
      if refresh == nil then
        buyNum = countTbl.refreshCountLimit
        if countTbl.key == 2360058 or countTbl.key == 2360059 then
          self.btn_quick_buy:GetChild("txt_quick_buy"):SetText(string.format("M\225\187\151i ng\195\160y %d l\225\186\167n", countTbl.refreshCountLimit))
        else
          self.btn_quick_buy:GetChild("txt_quick_buy"):SetText(string.format("M\225\187\151i ng\195\160y Mua %d l\225\186\167n", countTbl.refreshCountLimit))
        end
      else
        local remainder = countTbl.refreshCountLimit - refresh.count
        buyNum = remainder
        if countTbl.key == 2360058 or countTbl.key == 2360059 then
          self.btn_quick_buy:GetChild("txt_quick_buy"):SetText(string.format("M\225\187\151i ng\195\160y %d l\225\186\167n", remainder))
        else
          self.btn_quick_buy:GetChild("txt_quick_buy"):SetText(string.format("M\225\187\151i ng\195\160y Mua %d l\225\186\167n", remainder))
        end
      end
    else
      self.btn_quick_buy:GetChild("txt_quick_buy"):SetText("Mua")
    end
    local costTab = string.split(shop.cost, "#")
    if 1 < #costTab then
      local itemId, costNum = tonumber(costTab[1]), tonumber(costTab[2])
      itemData = ItemUtility.GenerateItemData(itemId)
      local bagCanBuyNum = ItemUtility:GetMaxCostNum(itemId, costNum)
      local maxBuyNum = buyNum
      buyNum = buyNum > bagCanBuyNum and bagCanBuyNum or buyNum
      self.fastBuyModel2:RefreshData(itemData)
      self.fastBuyModel2.itemData.count = tonumber(costNum)
      ItemUtility.ShowItemCell(self.model_money, self.fastBuyModel2, self, true, nil, 3, 5)
      self.btn_quick_buy.data = shop
      self.btn_quick_buy.id = id
      self.btn_quick_buy:SetOnClick(self, self.Button_FastBuy)
      if bagChangeType == nil or table.contains(ClientTable.cfg_Global_globalManager:GetQuickBuyRefreshType(), bagChangeType) then
        self:QuickBuyAmountChooseCallBack(1)
        local showBuyMaxNum = maxBuyNum == 0 and 1 or maxBuyNum
        self.QuickBuyAmountChooseTemplate:Refresh({
          MinNum = 1,
          MaxNum = showBuyMaxNum,
          inputData = self,
          valueChangeCallBack = self.QuickBuyAmountChooseCallBack
        })
      else
        self:RefreshCost()
      end
    end
  end
  return 104
end

function Tip_ItemTipTwoUI:QuickBuyAmountChooseCallBack(data)
  if data == nil then
    return
  end
  self.buyCount = data
  self:RefreshCost()
end

function Tip_ItemTipTwoUI:RefreshCost()
  local singleCost = self.fastBuyModel2.itemData.count
  local totalCost = singleCost * self.buyCount
  local isEnoughCost = ItemUtility:IsEnoughCost(self.fastBuyModel2.itemData.itemId, totalCost)
  local colorIndex = isEnoughCost and 0 or 24
  self.model_money_Num:SetText(string.format("<color=%s>%s</color>", ItemQuality2ColorDic[colorIndex], MathUtility.TransNumber(totalCost, 1)))
end

function Tip_ItemTipTwoUI:Button_FastBuy(control)
  local shopInfo = control.data
  local costTab = string.split(shopInfo.cost, "#")
  if 1 < #costTab then
    local costID = tonumber(costTab[1])
    local costNum = tonumber(costTab[2])
    if shopInfo.countKey > 0 and 1 > RefreshData.GetInstanceCount(shopInfo.countKey) then
      LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughCount, control)
      return
    end
    if BagInfoData.GetItemTotalCountByItemId(costID) < costNum * self.buyCount then
      LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughGold, control)
      return
    end
    if not BagInfoData.SafeBagSpaceJudge(costID, 1) then
      LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughBgCell, control)
      return
    end
    NetManager.Send(ItemBuyMessage.ReqBuy, {
      goodId = shopInfo.id,
      buyCount = self.buyCount
    })
    self:RefreshAccessChannels()
  end
end

function Tip_ItemTipTwoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_ItemTipTwoUI:OnHide()
  for _, tips in pairs(self.tipsTbl) do
    self:ReSet(tips)
    self:CloseMounModle(tips)
  end
  self.go_obtain:SetActive(false)
  self.showContrastTips = false
  self.fastBuyId = nil
  if self.tipsTbl.contrastTips ~= nil and self.tipsTbl.contrastTips.modelData then
    self.tipsTbl.contrastTips.modelData:RecycleRes()
  end
  if self.tipsTbl.tips ~= nil and self.tipsTbl.tips.modelData then
    self.tipsTbl.tips.modelData:RecycleRes()
  end
  UIManager.Hide(UIID.TipDefectPromptTipUI)
end

function Tip_ItemTipTwoUI:OnDestroy()
end

function Tip_ItemTipTwoUI:Update()
  for _, tips in pairs(self.tipsTbl) do
    if tips.modelData and tips.modelData.model and tips.ItemInfo and tips.ItemInfo.tblItem and tips.ItemInfo.tblItem.toSpin == 0 then
      local obj = tips.modelData.model.modelObject
      RoleEquipUtility.EquipModelRotation(obj, tips.ItemInfo.tblItem.SpinAxis, 2)
    end
  end
end

function Tip_ItemTipTwoUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.Button_Close)
end

function Tip_ItemTipTwoUI:Button_Close()
  EventManager.Dispatch(Event.Tips_ItemTipsClose)
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:CheckIsOpenAndShowTips()
  if self.args.item.tblItem.type == EItemType.NewRune then
    local condition = ClientTable.cfg_Function_functionManager:TryGetValue(3000701).condition
    if not ConditionManager.Check4D(condition) then
      local text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Newrunes_1")
      FloatingTipUtility.QuickMsg(text)
      return true
    end
  end
  return false
end

function Tip_ItemTipTwoUI:Button_UseItem(control)
  local canUse = RoleEquipUtility.CheckUseItem(self.args.item, CheckUseItemWay.AddPointTip)
  if not canUse then
    return
  end
  if self:CheckIsOpenAndShowTips() then
    return
  end
  if not string.isNullOrEmpty(control.tips.ItemInfo.tblItem.transCondition) then
    local conditionTbl = TableParse:SplitStringToStrList(control.tips.ItemInfo.tblItem.transCondition, "/")
    if table.count(conditionTbl) > 1 and not ConditionManager.Check4D(conditionTbl[1]) then
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey(conditionTbl[2]))
      return
    end
  end
  local useItemTbl = {
    useCount = 1,
    useItemId = control.tips.ItemInfo.id,
    configId = control.tips.ItemInfo.itemId,
    useParam = control.tips.ItemInfo.tblItem.useParam,
    useParamExtend = control.tips.ItemInfo.tblItem.useParamExtend,
    itemInfo = control.tips.ItemInfo,
    params = nil
  }
  ItemUtility.UseItem(useItemTbl)
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_JumpPanelOrUse(control)
  local canUse = RoleEquipUtility.CheckUseItem(self.args.item, CheckUseItemWay.AddPointTip)
  if not canUse then
    return
  end
  local useItemTbl = {
    useCount = 1,
    useItemId = control.tips.ItemInfo.id,
    configId = control.tips.ItemInfo.itemId,
    useParam = control.tips.ItemInfo.tblItem.useParam,
    useParamExtend = control.tips.ItemInfo.tblItem.useParamExtend,
    itemInfo = control.tips.ItemInfo,
    params = nil
  }
  if self.args.openSource ~= nil then
    ItemUtility.UseItem(useItemTbl)
    UIManager.Hide(UIID.ItemTipUI)
  else
    local argsStr = string.split(useItemTbl.useParamExtend, "=")
    if 2 <= #argsStr then
      UIManager.Hide(UIID.ItemTipUI)
      UIManager.JumpShow(UIPanelType.SortAndHide, argsStr[2], nil)
    end
  end
end

function Tip_ItemTipTwoUI:Button_UseAllItem(control)
  local canUse = RoleEquipUtility.CheckUseItem(self.args.item, CheckUseItemWay.AddPointTip)
  if not canUse then
    return
  end
  local useItemTbl = {
    useCount = control.tips.ItemInfo.count,
    useItemId = control.tips.ItemInfo.id,
    configId = control.tips.ItemInfo.itemId,
    useParam = control.tips.ItemInfo.tblItem.useParam,
    useParamExtend = control.tips.ItemInfo.tblItem.useParamExtend,
    itemInfo = control.tips.ItemInfo,
    params = nil
  }
  ItemUtility.UseItem(useItemTbl)
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_WearEquip(control)
  local canUse = RoleEquipUtility.CheckUseItem(self.args.item, CheckUseItemWay.AddPointTip)
  if not canUse then
    return
  end
  RoleEquipUtility.OnWearEquip(control.tips.ItemInfo)
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_Disboard(control)
  if control.tips.ItemInfo.tblItem.type == 22 then
    EventManager.Dispatch(Event.HolyRingDisboardEquip)
  else
    local isFull = BagInfoData.SafeBagSpaceJudge(control.tips.ItemInfo.itemId, 1)
    if isFull then
      MeEquipController.ReqTakeOffTheEquip(control.tips.ItemInfo.bagGridIndex)
    else
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = "T\195\186i \196\145\225\186\167y"
      })
    end
  end
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_MountDisboard(control)
  local isFull = BagInfoData.SafeBagSpaceJudge(control.tips.ItemInfo.itemId, 1)
  if isFull then
    if RoleManager.me.data.rideMount and RoleManager.me.data.rideMount.id == control.tips.ItemInfo.equipid then
      NetManager.Send(EquipMessage.ReqChangeHorseState, {
        position = control.tips.ItemInfo.equipposition,
        ride = false
      })
    end
    if MountData.DefaultMount == control.tips.ItemInfo.equipid then
      NetManager.Send(EquipMessage.ReqEquipDefaultHorse, {equipId = 0})
    end
    NetManager.Send(EquipMessage.ReqTakeOffTheHorse, {
      equipId = control.tips.ItemInfo.equipid,
      position = control.tips.ItemInfo.equipposition
    })
  else
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "T\195\186i \196\145\225\186\167y"
    })
  end
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_TakeOut(control)
  NetManager.Send(BagMessage.ReqTakeOutFromStorage, {
    id = control.tips.ItemInfo.id,
    bagGridIndex = -1
  })
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_Deposit(control)
  NetManager.Send(BagMessage.ReqPutIntoStorage, {
    id = control.tips.ItemInfo.id,
    bagGridIndex = -1
  })
  UIManager.Hide(UIID.ItemTipUI)
end

local function DoPutIn(itemData)
  NetManager.Send(BagMessage.ReqDestroyItem, {
    itemId = itemData.id
  })
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_Discard(control)
  local itemData = control.tips.ItemInfo
  local tipTbl = {}
  tipTbl.title = LocalizationUtility.GetContentByKey("tishi")
  tipTbl.cancelText = LocalizationUtility.GetContentByKey("quxiao")
  tipTbl.okText = LocalizationUtility.GetContentByKey("queding")
  if itemData.tblItem.destroy == 0 then
    tipTbl.textContent = string.format(LocalizationUtility.GetContentByKey("Destroy_1"), itemData.tblItem.name)
    tipTbl.ok = DoPutIn
    tipTbl.okArgs = itemData
  else
    tipTbl.textContent = string.format(LocalizationUtility.GetContentByKey("Destroy_2"), itemData.tblItem.name)
  end
  UIManager.Show(UIID.PromptTipUI, tipTbl)
end

function Tip_ItemTipTwoUI:Button_More(control)
  local tips = control.tips
  tips.moreState = not tips.moreState
  tips.Img_moreBg:SetActive(tips.moreState)
  if tips.moreState then
    for _, btn in pairs(tips.moreBtnList) do
      btn:SetActive(false)
    end
    local leftOperateTbl = string.split(tips.ItemInfo.tblItem.leftOperate, "#")
    local count = #leftOperateTbl
    for i = 1, #leftOperateTbl do
      local operateNum = tonumber(leftOperateTbl[i])
      if operateNum == EItemOperateType.Shelves and tips.ItemInfo.tblEquip ~= nil and not AuctionController.CheckMeetPutOnCondition(tips.ItemInfo.tblEquip, tips.ItemInfo.bind, tips.ItemInfo.intensify, tips.ItemInfo.additional, true) then
        table.remove(leftOperateTbl, i)
        if count == 1 then
          table.insert(leftOperateTbl, i, EItemOperateType.Close)
        end
      end
    end
    for _, operate in pairs(leftOperateTbl) do
      local objCtr
      local name = tips.btn_MoreClick:GetName() .. operate
      if tips.moreBtnList[name] then
        objCtr = tips.moreBtnList[name]
      else
        local obj = tips.btn_MoreClick:Instantiate(nil, name)
        objCtr = UIControl(obj.transform)
        tips.moreBtnList[name] = objCtr
        tips.btnName2Lab[name] = UIControl(objCtr.transform, "lab_more")
      end
      objCtr:SetActive(true)
      self:BindBtnOperate(tips, objCtr, tonumber(operate))
    end
  end
end

function Tip_ItemTipTwoUI:Button_CancelSelect()
  local control = self.args.ctrl
  BagInfoData.RefreshDecomposeItemData({
    data = {itemData = control}
  }, false)
  EventManager.Dispatch(Event.Bag_DecomposeItemClick, control)
  EventManager.Dispatch(Event.Bag_CancelDecomposeSelect, control)
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_OpenUI()
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(self.args.item.itemId)
  local useParam = string.split(itemConfig.useParam, "#")
  if useParam[1] == TipPanelEnum.ExpMedicine then
    UIManager.Show(UIID.Item_ExpMedicine, {
      item = self.args.item
    })
  end
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_OpenOtherUI()
  if self.args.hideUiId then
    UIManager.Hide(self.args.hideUiId)
  end
  UIManager.Hide(UIID.ItemTipUI)
  UIManager.Show(self.args.uiId)
end

function Tip_ItemTipTwoUI:Button_AddEquipToOverlap()
  if ForgeData.EquipOverlapMain == nil then
    ForgeData.EquipOverlapMain = self.args.item
  elseif ForgeData.EquipOverlapSide == nil then
    ForgeData.EquipOverlapSide = self.args.item
  elseif ForgeData.EquipOverlapSide ~= nil then
    ForgeData.EquipOverlapSide = self.args.item
  end
  EventManager.Dispatch(Event.SelectedForgeEquip, {
    self.args.item,
    self.args.item.bagGridIndex
  })
  EventManager.Dispatch(Event.Bag_RefreshShowOverlap)
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_AddEquipToStone()
  EventManager.Dispatch(Event.Equip_PutOnStone, {
    self.args.item
  })
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_TakeOffEquipStone()
  EventManager.Dispatch(Event.Equip_TakeOffStone)
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_XiLianOnClick()
  gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():SetXiLianEquipByEquipData(self.args.item, XiLianEquipDataSource.Equip_XiLianUI)
  EventManager.Dispatch(Event.Bag_RefreshShowXiLian)
  UIManager.Hide(UIID.ItemTipUI)
end

function Tip_ItemTipTwoUI:Button_XiLianRedEquipOnClick()
  if FucShowOrHideController.IsFuncButtonShow("Equip_ForgeNavUi#tog_xilian") then
    if UIManager.IsVisible(UIID.Tip_TrinketTipUI) then
      UIManager.Hide(UIID.Tip_TrinketTipUI)
    end
    UIManager.JumpShow(UIPanelType.Nothing, UIID.Equip_ForgeNavUi, {
      uiID = UIID.Equip_XiLianUI,
      openType = self.args.openType,
      itemData = self.args.item
    })
  else
    FloatingTipUtility.QuickMsg("Ch\225\187\169c n\196\131ng t\225\186\169y luy\225\187\135n hi\225\187\135n ch\198\176a m\225\187\159 ")
  end
end

function Tip_ItemTipTwoUI:Button_Shelves()
  if TipData.AuctionOpen == false then
    FloatingTipUtility.QuickMsg("S\195\160n Giao D\225\187\139ch ch\198\176a m\225\187\159")
  else
    UIManager.JumpShow(UIPanelType.Nothing, UIID.Auction_AuctionUI, {
      itemData = self.args.item
    })
  end
end

function Tip_ItemTipTwoUI:Button_Strengthen()
  if FucShowOrHideController.IsFuncButtonShow("Equip_ForgeNavUi#tog_intensify") then
    UIManager.JumpShow(UIPanelType.Nothing, UIID.Equip_ForgeNavUi, {
      uiID = UIID.Equip_IntensifyUI,
      openType = self.args.openType,
      itemData = self.args.item
    })
  else
    FloatingTipUtility.QuickMsg("T\195\173nh n\196\131ng R\195\168n ch\198\176a m\225\187\159")
  end
end

function Tip_ItemTipTwoUI:Button_Decompose()
  if FucShowOrHideController.IsFuncButtonShow("Equip_ForgeNavUi#tog_decompose") then
    UIManager.JumpShow(UIPanelType.Nothing, UIID.Equip_ForgeNavUi, {
      uiID = UIID.Equip_Decompose,
      openType = self.args.openType,
      itemData = self.args.item
    })
  else
    FloatingTipUtility.QuickMsg("T\195\173nh n\196\131ng T\195\161ch ch\198\176a m\225\187\159")
  end
end

local function ReachTaskNpc()
  UIManager.Show(UIID.Item_CombineUI, {
    combineId = Tip_ItemTipTwoUI.curItemombineId
  })
end

function Tip_ItemTipTwoUI:Compound(ctrl)
  if ctrl.tips and ctrl.tips.ItemInfo and ctrl.tips.ItemInfo.tblItem and ctrl.tips.ItemInfo.tblItem.type == 22 then
    UIManager.Hide(UIID.ItemTipUI)
    EventManager.Dispatch(Event.HolyRingJumpSynthesis)
    return
  end
  UIManager.Hide(UIID.ItemTipUI)
  UIManager.Hide(UIID.NewBagInfoUI)
  UIManager.Hide(UIID.Bag_EquipInfoUI)
  UIManager.Hide(UIID.Role_AttributeUI)
  UIManager.Hide(UIID.Tip_TrinketTipUI)
  if ctrl.combineId ~= nil then
    local selectCombineTbl = ClientTable.cfg_Item_combineManager:TryGetValue(tonumber(ctrl.combineId))
    if selectCombineTbl and selectCombineTbl.openCondition and ConditionManager.Check4D(selectCombineTbl.openCondition) then
      self.curItemombineId = ctrl.combineId
    else
      self.curItemombineId = 101001
    end
  else
    self.curItemombineId = 101001
  end
  if FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.Combine_Carry) == false then
    TipUtility.QuickShowPrompt({
      id = PromptWordType.TipCombinePrompt,
      cancelAction = function()
        local composeJumpParam = ParseUtility.ParseId(GlobalConfig.composeJump)
        PathFinderManager.FlyTransferScene(composeJumpParam[1], nil, {
          npcId = composeJumpParam[2]
        }, Purpose.ForTask, ReachTaskNpc)
      end
    })
    return
  end
  ReachTaskNpc()
end

function Tip_ItemTipTwoUI:Button_Upgrade()
  UIManager.JumpShow(UIPanelType.Nothing, UIID.Equip_ForgeNavUi, {
    uiID = UIID.Equip_OrnamentsUI,
    openType = self.args.openType,
    itemData = self.args.item
  })
end

function Tip_ItemTipTwoUI:Button_Exchange()
  local tblItem = self.args.item.tblItem
  local argsStr = string.split(tblItem.useParamExtend, "#")
  local args = {}
  local uiID
  for i, v in pairs(argsStr) do
    local str = string.split(v, "=")
    if str[1] == "uiID" then
      uiID = str[2]
    else
      local index = str[1]
      args[index] = str[2]
    end
  end
  UIManager.Hide(UIID.ItemTipUI)
  if uiID == UIID.Commercial_HolidayActivityUI then
    local group = args.openType
    local cfgtbl = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", tonumber(group))
    for i, v in pairs(cfgtbl) do
      if not (string.isNullOrEmpty(v.deadline) or ConditionManager.Check(v.deadline)) or not string.isNullOrEmpty(v.level) and not ConditionManager.Check4D(v.level) then
        FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Festivalitem5"))
        return
      end
    end
  end
  UIManager.JumpShow(UIPanelType.Nothing, uiID, args)
end

function Tip_ItemTipTwoUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResUseItem, self.OnResUseItem, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
end

function Tip_ItemTipTwoUI:OnResUseItem(_, msg)
  if msg ~= nil and self.args.item.id == msg.itemId then
    UIManager.Hide(UIID.ItemTipUI)
  end
end

function Tip_ItemTipTwoUI:OnBagChange(_, msg)
  self:RefreshAccessChannels(msg.logType)
end

function Tip_ItemTipTwoUI:Refresh()
  if not self.args.item then
    return
  end
  BagInfoController:SetCurSelectItemInfo(self.args.item)
  self.tipsTbl.tips.ItemInfo = self.args.item
  self.career = self.args.career == nil and RoleUtility.GetBasicCareer(RoleManager.me.career) or RoleUtility.GetBasicCareer(self.args.career)
  self:ShowTip(self.tipsTbl.tips)
  if self.args.contrast and self.args.item.subType ~= 50 and self.args.item.tblItem.type == EItemType.Equipe then
    local index = RoleEquipUtility.WearEquipIndex(self.args.item)
    local equip = ViewData.meData.equipsData:GetEquipByIndex(tonumber(index))
    if not equip and self.tipsTbl.tips.ItemInfo.tblItem.subType ~= EItemSubtype.Mount then
      equip = ViewData.meData.equipsData:GetStoneByIndex(index)
    end
    if QuickFind.LuaMainPlayerEquipData():GetJewelryData():IsIncludeJewelryIndex(tonumber(index)) then
      local JewelryData = QuickFind.LuaMainPlayerEquipData():GetJewelryData():GetJewelryDataInfoDic(tonumber(index))
      if JewelryData ~= nil then
        equip = JewelryData:GetEquipData()
      end
    end
    if equip and self.tipsTbl.tips.ItemInfo.tblItem.subType ~= EItemSubtype.Mount then
      self.showContrastTips = true
      self.tipsTbl.contrastTips.ItemInfo = equip
      self:ShowTip(self.tipsTbl.contrastTips)
    end
  end
  self:SetPosition()
  if self.args.SetLayerCallBack then
    self.args.SetLayerCallBack()
  end
end

function Tip_ItemTipTwoUI:ShowTip(tips)
  if ItemUtility.IsEquipType(tips.ItemInfo.tblItem.type) then
    self:EquipTop(tips)
    self:EquipCenter(tips)
    if tips.ItemInfo.tblItem.subType ~= EItemType.Vvip then
      self:EquipBottom(tips)
    end
  else
    self:ItemTop(tips)
    self:ItemCenter(tips)
    self:ItemBottom(tips)
  end
  self:ShowItemID(tips)
  self:AdjustUI(tips)
end

function Tip_ItemTipTwoUI:ShowItemID(tips)
  if CS.UnityEngine.Debug.isDebugBuild or not LoginData.externalNet then
    tips.txt_itemId:SetActive(true)
    if tips.ItemInfo.tblItem and tips.ItemInfo.tblItem.id then
      tips.txt_itemId:SetText("id:" .. tips.ItemInfo.tblItem.id)
    end
    tips.txt_itemId:SetAnchoredPosition(0, -tips.bottomHeight)
  else
    tips.txt_itemId:SetActive(false)
  end
end

function Tip_ItemTipTwoUI:ItemTop(tips)
  tips.topHeight = 0
  self:ItemModel(tips)
  self:TitleStr(tips)
end

local function ResolutionCompositestone(compStr)
  local result = {}
  if compStr ~= nil or compStr ~= "" then
    local tupleArray = string.split(compStr, "&")
    for i = 1, #tupleArray do
      local id = tonumber(string.split(tupleArray[i], "#")[2])
      id = tonumber(ClientTable.cfg_Item_combineManager:TryGetValue(id).rewardBoxId)
      if id ~= nil then
        id = tonumber(ClientTable.cfg_Box_showManager:TryGetValue(id, "boxId").itemId)
        if id ~= nil then
          local itemData = ClientTable.cfg_Item_itemManager:TryGetValue(id)
          table.insert(result, itemData)
        end
      end
    end
  end
  if next(result) ~= nil then
    local career = ViewData.meData.career
    for i = 1, #result do
      local strTbl = string.split(result[i].compositestone, "#")
      if result[i] ~= nil and table.contains(strTbl, tostring(career)) then
        return result[i]
      end
    end
  end
  return nil
end

function Tip_ItemTipTwoUI:ItemCenter(tips)
  self:BoneSoulAttribute(tips)
  self:RunePropAttribute(tips)
  self:HolyRingAttribute(tips)
  self:ConsumAttribute(tips)
  self:MountModelShow(tips)
  self:RefreshBoxReward(tips)
  self:RefreshEnchantedCrystal(tips)
end

function Tip_ItemTipTwoUI:BoneSoulAttribute(tips)
  if tips.ItemInfo.tblItem.type == EItemType.BoneSoul or tips.ItemInfo.tblItem.type == EItemType.FixedBoneSoul then
    local attributeTab
    attributeTab = ClientTable.cfg_Bone_attributeManager:GetDesTabByServerData(tips.ItemInfo)
    local attTab = {}
    if attributeTab then
      for i, itemAttributeData in pairs(attributeTab) do
        table.insert(attTab, itemAttributeData)
      end
    end
    if table.count(attTab) > 0 then
      self:CalculStrPosAndHeight(attTab, tips.lab_TipHolySkeletonAttribute, tips, tips.lab_HolySkeletonAttribute)
    end
  end
end

function Tip_ItemTipTwoUI:RunePropAttribute(tips)
  if tips.ItemInfo.tblItem.type == 19 then
    local attributeTab
    if tips.ItemInfo.serverInfo == nil then
      attributeTab = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetRuneAttributeByItemId(tips.ItemInfo.tblItem.id, 0)
    else
      local runesLevel = tips.ItemInfo.serverInfo.runesLevel or tips.ItemInfo.serverInfo.level
      attributeTab = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetRuneAttributeByItemId(tips.ItemInfo.tblItem.id, runesLevel)
    end
    local attTab = {}
    if attributeTab then
      for i, itemAttributeData in pairs(attributeTab) do
        table.insert(attTab, itemAttributeData.attributeDes)
      end
    end
    if 0 < table.count(attTab) then
      self:CalculStrPosAndHeight(attTab, tips.lab_TipRunesAttribute, tips, tips.lab_RunesAttribute)
    end
  end
end

function Tip_ItemTipTwoUI:HolyRingAttribute(tips)
  if tips.ItemInfo.tblItem.type == 22 then
    local attributeTab
    attributeTab = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingItemTip(tips.ItemInfo.tblItem.id)
    if attributeTab then
      self:CalculStrPosAndHeight(attributeTab, tips.lab_TipAttribute, tips, tips.lab_attribute)
    end
    local buffList = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingHoleDataSkillBuff(tips.ItemInfo.tblItem.id)
    local attributeTableText
    local attributeBuff = {}
    if buffList.typeId == 2211000 then
      local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingEnumSkillShow[buffList.typeId])
      attributeTableText = string.format(string.GetColorText(Text, ItemQuality2ColorDic[5]), tonumber(buffList.buffOther[1]) / 100)
    elseif buffList.typeId == 2212000 then
      local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingEnumSkillShow[buffList.typeId])
      attributeTableText = string.format(string.GetColorText(Text, ItemQuality2ColorDic[5]), tonumber(buffList.buffMy[1]) / 100, tonumber(buffList.buffMy[3]) / 100)
    elseif buffList.typeId == 2213000 then
      local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingEnumSkillShow[buffList.typeId])
      attributeTableText = string.format(string.GetColorText(Text, ItemQuality2ColorDic[5]), tonumber(buffList.buffMy[1]) / 100)
    elseif buffList.typeId == 2214000 then
      local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingEnumSkillShow[buffList.typeId])
      attributeTableText = string.format(string.GetColorText(Text, ItemQuality2ColorDic[5]), tonumber(buffList.buffOther[1]) / 100)
    elseif buffList.typeId == 2215000 then
      local Text = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(HolyRingEnumSkillShow[buffList.typeId])
      attributeTableText = string.format(string.GetColorText(Text, ItemQuality2ColorDic[5]), tonumber(buffList.buffMy[1]) / 100, -tonumber(buffList.buffOther[1]) / 100)
    end
    table.insert(attributeBuff, attributeTableText)
    if attributeBuff then
      self:CalculStrPosAndHeight(attributeBuff, tips.lab_TipSpecialAttributeAdditional, tips, tips.lab_SpecialAttribute)
    end
  end
end

function Tip_ItemTipTwoUI:ItemBottom(tips)
  self:ItemItemTipsStr(tips)
  self:ThingTimeDown(tips)
  self:ButtonShow(tips)
end

function Tip_ItemTipTwoUI:EquipTop(tips)
  self:EquiptTilteStr(tips)
  self:EquipInfoModel(tips)
end

function Tip_ItemTipTwoUI:EquipCenter(tips)
  if ItemUtility.IsFakeEquipType(tips.ItemInfo.tblItem.type) then
    self:EquipStoneAttribute(tips)
  else
    self:EquipBasicAttributeStr1(tips)
  end
  self:EquipSpecialAttributeStr(tips)
  self:EquipSkill(tips)
  self:EquipExcellence(tips)
  self:WingAttribute(tips)
  self:BuffAttributeStr(tips)
  self:RuneEquip(tips)
  self:RuneSuitEquip(tips)
  self:NewRuneSuitEquip(tips)
  self:BoneSoulEquip(tips)
  self:BoneSoulSuitEquip(tips)
  self:EnchantmenAttribute(tips)
  self:EquipSuitAttributeStr(tips)
  self:EquipInlayAttributeStr(tips)
  self:FluorsparattributeStr(tips)
  self:MountModelShow(tips)
  self:ConsumAttribute(tips)
  self:EquipDur(tips)
  self:RegenerateEquip(tips)
  self:HonourAttribute(tips)
end

function Tip_ItemTipTwoUI:EnchantmenAttribute(tips)
  tips.itemEnchantTable = {}
  tips.itemEnchantDetailTable = {}
  if self.args and (self.args.ChatEnchantMen or self.args.ChatEnchantMenDetail) then
    if not table.isNullOrEmpty(self.args.ChatEnchantMenDetail.attr) and not table.isNullOrEmpty(self.args.ChatEnchantMenDetail.EnchantMen) and self.args.ChatEnchantMenDetail.EnchantMen.m_PointGrade > 0 then
      table.insert(tips.itemEnchantDetailTable, string.format("\236\160\149\235\160\168 \235\160\136\235\178\168: %s", self.args.ChatEnchantMenDetail.EnchantMen.m_EnchantUpgradeConfig.labGrade))
      local count = table.count(self.args.ChatEnchantMenDetail.attr)
      for i = 1, count do
        table.insert(tips.itemEnchantDetailTable, string.GetColorText(self.args.ChatEnchantMenDetail.attr[i], ItemQuality2ColorDic[2]))
      end
    end
    self:CalculStrPosAndHeight(tips.itemEnchantDetailTable, tips.lab_TipAttributeEnchantmentDetail, tips, tips.title_attributeEnchantmentDetail)
    return
  end
  if table.isNullOrEmpty(tips.ItemInfo) or tips.ItemInfo.bagGridIndex == 0 or tips.ItemInfo.tblEquip == nil then
    self:CalculStrPosAndHeight(tips.itemEnchantDetailTable, tips.lab_TipAttributeEnchantmentDetail, tips, tips.title_attributeEnchantmentDetail)
    return
  end
  local isMePositionEquip = true
  local cellType = tips.ItemInfo.tblEquip.cellType
  local mainPlayerEquipData = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipDataByEquipIndex(tips.ItemInfo.bagGridIndex, cellType)
  local mainEnchantmen = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipIndexDataByItem(tips.ItemInfo)
  local otherEnchantmen = gameMgr:GetAvatarManager():GetOtherPlayer():GetEnchantEquipManager():GetEnchantEquipIndexDataByItem(tips.ItemInfo)
  if mainPlayerEquipData and mainPlayerEquipData.equipData and mainPlayerEquipData.equipData.id == tips.ItemInfo.id then
    isMePositionEquip = true
  else
    isMePositionEquip = false
  end
  local equipData = isMePositionEquip and mainEnchantmen or otherEnchantmen
  if not table.isNullOrEmpty(equipData) and equipData.m_PointGrade > 0 then
    local totalAttribute = EnchantEquipUtility:GetAppointEquipIndexAllAttributeDes({
      [1] = equipData
    }, true)
    if not table.isNullOrEmpty(totalAttribute) then
      table.insert(tips.itemEnchantDetailTable, string.GetColorText(string.format("Dung Luy\225\187\135n C\225\186\165p: %s", equipData.m_EnchantUpgradeConfig.labGrade), ItemQuality2ColorDic[2]))
      local count = table.count(totalAttribute)
      for i, v in pairs(totalAttribute) do
        table.insert(tips.itemEnchantDetailTable, string.GetColorText(v, ItemQuality2ColorDic[2]))
      end
    end
  end
  self:CalculStrPosAndHeight(tips.itemEnchantDetailTable, tips.lab_TipAttributeEnchantmentDetail, tips, tips.title_attributeEnchantmentDetail)
end

function Tip_ItemTipTwoUI:RefreshEnchantedCrystal(tips)
  tips.itemEnchantDetailTable = {}
  self:CalculStrPosAndHeight(tips.itemEnchantDetailTable, tips.lab_TipAttributeEnchantmentDetail, tips, tips.title_attributeEnchantmentDetail)
  if tips.ItemInfo.tblItem == nil or tips.ItemInfo.tblItem.type ~= EItemType.EnchantedCrystal then
    return
  end
  tips.itemEnchantTable = {}
  local ConfigEnchantFixedEntry = EnchantEquipUtility:GetEquipDataAttributeDataTab(tips.ItemInfo.itemId)
  if not table.isNullOrEmpty(ConfigEnchantFixedEntry) then
    for a, b in pairs(ConfigEnchantFixedEntry) do
      local des = string.format(AttributeWordUtil.GetUIWord(b.attributeName, "enchantattributeUI"), MathUtility.FormatNum(b.attributeValue))
      table.insert(tips.itemEnchantTable, string.GetColorText(des, ItemQuality2ColorDic[2]))
    end
  end
  self:CalculStrPosAndHeight(tips.itemEnchantTable, tips.lab_TipAttributeEnchantment, tips, tips.title_attributeEnchantment)
end

function Tip_ItemTipTwoUI:RegenerateEquip(tips)
  tips.regenerateTable = {}
  local regenerate = RoleEquipUtility.RegenerateEquipInfo(tips.ItemInfo)
  if regenerate ~= nil then
    local attribute = RoleEquipUtility.GetEquipRegenerateAttribute(regenerate)
    for i, v in ipairs(attribute) do
      if v then
        table.insert(tips.regenerateTable, string.GetColorText(v.attributeInfo, ItemQuality2ColorDic[1]))
      end
    end
  end
  self:CalculStrPosAndHeight(tips.regenerateTable, tips.lab_Tipregenerate, tips, tips.lab_regenerate)
end

function Tip_ItemTipTwoUI:HonourAttribute(tips)
  tips.honourAttribute = {}
  if not string.isNullOrEmpty(tips.ItemInfo.tblEquip.excellentHonourNumber) and tips.ItemInfo.HonourAttribute == nil then
    local honourAttributeTab = ClientTable.cfg_Item_equip_excell_honourManager:GetHonourAttributeData()
    if table.count(honourAttributeTab) > 0 and tips.ItemInfo.itemId ~= 42990001 and not UIManager.IsVisible(UIID.Item_CombineUI) then
      for i, v in ipairs(honourAttributeTab) do
        local des = AttributeWordUtil.GetUIWordNew(v.attributeDescription, "equipHonourUI", v.minValue, v.maxValue)
        table.insert(tips.honourAttribute, des)
      end
    end
  elseif tips.ItemInfo.HonourAttribute and table.count(tips.ItemInfo.HonourAttribute) > 0 then
    local maxLevel, color = 0, ""
    for i, v in ipairs(tips.ItemInfo.HonourAttribute) do
      local config = ClientTable.cfg_Item_equip_excell_honourManager:TryGetValue(v)
      if maxLevel < config.level then
        maxLevel = config.level
        color = config.color
      end
      local value, description = ClientTable.cfg_Item_equip_excell_honourManager:GetAttributeDescription(config)
      local data = {attributeName = description, value = value}
      local str = RoleEquipUtility.GetEquipattributeStrByTbl(data, "equipHonourUI")
      if not string.isNullOrEmpty(str) then
        local des = string.GetColorText(string.format("[Lv%s]%s", config.level, str), config.color)
        table.insert(tips.honourAttribute, des)
      end
    end
    tips.honour_bg:SetActive(true)
    tips.honour_bg:SetColor(ColorUtility.HexToHexCode(color))
  end
  self:CalculStrPosAndHeight(tips.honourAttribute, tips.lab_TipExcellentHonourAdditional, tips, tips.lab_excellentHonour)
end

function Tip_ItemTipTwoUI:RuneEquip(tips)
  local equipIndex = tips.ItemInfo.bagGridIndex
  local equipRuneData, equipData
  if UIManager.IsVisible(UIID.Rank_EquipInfoUI) then
    equipRuneData = gameMgr:GetAvatarManager():GetOtherPlayer():GetRuneDataMgr():GetItemRuneInfoDataByEquipIndex(equipIndex)
    equipData = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetEquipData().Data
  else
    equipRuneData = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetItemRuneInfoDataByEquipIndex(equipIndex)
    equipData = gameMgr:GetAvatarManager():GetMainPlayer():GetMe().equipsData.Data
  end
  if equipRuneData and table.count(equipRuneData[1]) > 0 and equipData[equipIndex] then
    self:AddTitleHeight(tips.lab_RunesAttribute, tips)
    local allTemp = {}
    for i, itemHoleData in pairs(equipRuneData) do
      local attributeTab = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetRuneAttributeByItemId(itemHoleData.itemId, itemHoleData.level)
      local attTab = {}
      if attributeTab then
        for i, itemAttributeData in pairs(attributeTab) do
          if attTab.attribute == nil then
            attTab.attribute = {}
          end
          table.insert(attTab.attribute, itemAttributeData.attributeDes)
          attTab.itemId = itemHoleData.itemId
          attTab.name = itemHoleData.cfgTab.runesName
          attTab.tips = tips
          attTab.level = itemHoleData.level
        end
        table.insert(allTemp, attTab)
      end
    end
    tips.grid_RunesAttribute:SetActive(true)
    tips.go_RunesAttributeContainer:SetData(allTemp)
  end
end

function Tip_ItemTipTwoUI:RuneSuitEquip(tips)
  local equipIndex = tips.ItemInfo.bagGridIndex
  local RuneManager, equipRuneData, equipData
  if UIManager.IsVisible(UIID.Rank_EquipInfoUI) then
    RuneManager = gameMgr:GetAvatarManager():GetOtherPlayer():GetRuneDataMgr()
    equipData = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetEquipData().Data
  else
    RuneManager = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr()
    equipData = gameMgr:GetAvatarManager():GetMainPlayer():GetMe().equipsData.Data
  end
  equipRuneData = RuneManager:GetItemRuneInfoDataByEquipIndex(equipIndex)
  if equipRuneData and table.count(equipRuneData[1]) > 0 and equipData[equipIndex] then
    tips.runesSuitTable = RuneManager:GetRunesSuitDes(tips.ItemInfo.bagGridIndex)
    if not table.isNullOrEmpty(tips.runesSuitTable) then
      tips.grid_RunesSuitAttribute:SetActive(true)
    end
    self:CalculStrPosAndHeight(tips.runesSuitTable, tips.lab_RunesSuitAdditional, tips, tips.lab_suitAdditional_runes)
  end
end

function Tip_ItemTipTwoUI:NewRuneSuitEquip(tips)
  if tips.ItemInfo.tblItem == nil or tips.ItemInfo.tblItem.type ~= EItemType.NewRune then
    return
  end
  local suitId = tips.ItemInfo.tblEquip.suitId
  local suitSpilt = string.split(suitId, "#")
  tips.runesSuitTable = QuickFind.GetNewRuneDataManager():GetTipRunesMasterDes(tonumber(suitSpilt[1]), tonumber(suitSpilt[2]))
  if not table.isNullOrEmpty(tips.runesSuitTable) then
    tips.grid_RunesSuitAttribute:SetActive(true)
  end
  self:CalculStrPosAndHeight(tips.runesSuitTable, tips.lab_RunesSuitAdditional, tips, tips.lab_suitAdditional_runes)
end

function Tip_ItemTipTwoUI:BoneSoulEquip(tips)
  local sacredBonetbl
  if UIManager.IsVisible(UIID.Rank_EquipInfoUI) then
    local equipIndex = tips.ItemInfo.bagGridIndex
    sacredBonetbl = gameMgr:GetAvatarManager():GetOtherPlayer():GetSacredBoneDataMgr():GetSacredBoneInfo(equipIndex)
  else
    local equipIndex = RoleEquipUtility.GetWearEquipPosition(tips.ItemInfo)
    sacredBonetbl = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetSacredBoneInfo(equipIndex)
  end
  if sacredBonetbl and table.count(sacredBonetbl) > 0 then
    self:AddTitleHeight(tips.lab_HolySkeletonAttribute, tips)
    tips.grid_HolySkeletonAttribute:SetActive(true)
    local dataTab = {}
    for i, v in ipairs(sacredBonetbl) do
      table.insert(dataTab, {sacredBonetbl = v, tips = tips})
    end
    tips.go_HolySkeletonAttributeContainer:SetData(dataTab)
  end
end

function Tip_ItemTipTwoUI:BoneSoulSuitEquip(tips)
  local equipIndex = RoleEquipUtility.WearEquipIndex(tips.ItemInfo)
  local sacredBonetbl, count, suitDesTab
  if UIManager.IsVisible(UIID.Rank_EquipInfoUI) then
    local equipIndex = tips.ItemInfo.bagGridIndex
    sacredBonetbl, count = gameMgr:GetAvatarManager():GetOtherPlayer():GetSacredBoneDataMgr():GetSuitDes(equipIndex)
    suitDesTab = gameMgr:GetAvatarManager():GetOtherPlayer():GetSacredBoneDataMgr():GetSuitPartDes(sacredBonetbl)
  else
    local equipIndex = RoleEquipUtility.GetWearEquipPosition(tips.ItemInfo)
    sacredBonetbl, count = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetSuitDes(equipIndex)
    suitDesTab = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetSuitPartDes(sacredBonetbl)
  end
  if sacredBonetbl then
    local suitName
    if 7 <= count then
      suitName = string.GetColorText(string.format(sacredBonetbl.suitName .. "(7/7)"), ItemQuality2ColorDic[EItemColorEnum.orange])
    else
      suitName = string.GetColorText(string.format(sacredBonetbl.suitName .. "(%d/7)", count), ItemQuality2ColorDic[EItemColorEnum.gray])
    end
    tips.holySkeletonSuitTable = {}
    table.insert(tips.holySkeletonSuitTable, suitName)
    for i, v in ipairs(suitDesTab) do
      table.insert(tips.holySkeletonSuitTable, v)
    end
    local skillCfg = ClientTable.cfg_Skill_skillManager:TryGetValue(sacredBonetbl.skillID)
    if skillCfg then
      table.insert(tips.holySkeletonSuitTable, string.GetColorText("Hi\225\187\135u qu\225\186\163 B\225\187\153", ItemQuality2ColorDic[EItemColorEnum.orange]))
      table.insert(tips.holySkeletonSuitTable, string.GetColorText(ClientTable.cfg_Item_tipsManager:GetContentByItemTipsID(skillCfg.description), ItemQuality2ColorDic[EItemColorEnum.gold]))
    end
    self:CalculStrPosAndHeight(tips.holySkeletonSuitTable, tips.lab_HolySkeletonSuitAttribute, tips, tips.lab_suitAdditional_HolySkeleton)
  end
end

function Tip_ItemTipTwoUI:EquipBottom(tips)
  self:ItemItemTipsStr(tips)
  self:EquipTimeDown(tips)
  self:ButtonShow(tips)
end

function Tip_ItemTipTwoUI:SetPosition()
  self:FixedPosition()
end

function Tip_ItemTipTwoUI:FixedPosition()
  local position = Vector3.zero
  local tipsWH = Vector2.zero
  local offset = Vector2.zero
  tipsWH.x, tipsWH.y = self.tipsTbl.tips.Img_TipBg:GetSizeDelta()
  if self.showContrastTips then
    local w, h = self.tipsTbl.contrastTips.Img_TipBg:GetSizeDelta()
    if h > tipsWH.y then
      tipsWH.y = h
    end
  end
  local tipsBuyOffset = 0
  if not self.showContrastTips and self.args.openType == TipsOpenType.AuctionOpen or self.args.openType == TipsOpenType.ShopOpen then
    tipsBuyOffset = self.tipsTbl.tips.directBuyPanel:GetSizeDelta()
    tipsBuyOffset = tipsBuyOffset / 2
  end
  if not self.showContrastTips and self.go_obtain:GetActive() then
    tipsBuyOffset = self.img_obtainBg:GetSizeDelta()
    tipsBuyOffset = tipsBuyOffset / 2
  end
  position.x = tipsWH.x / 2 + self.tipDevX - tipsBuyOffset
  position.y = UIManager.height / 4 - 10
  self:FixedCalculTipsPos(position, offset, tipsWH)
  if self.go_obtain:GetActive() then
    local x, y = self.tipsTbl.tips.Img_TipBg:GetAnchoredPosition()
    local obtainW = self.img_obtainBg:GetSizeDelta()
    x = x + obtainW / 2
    if self.tipsTbl.tips.directBuyPanel:GetActive() then
      y = y - self.directBuyPanel.rectTransform.sizeDelta.y
      self:ShopBuyUIAdjust(self.tipsTbl.tips)
    end
    self.go_obtain:SetAnchoredPosition(x, y)
  elseif self.tipsTbl.tips.directBuyPanel:GetActive() then
    local y = 20
    if self.tips.rectTransform.sizeDelta.y > 500 and (self.args.isAuction or self.args.isUp) then
      y = 52
    elseif self.args.isUp and self.args.buyType == 0 then
      y = -3
    end
    self.tipsTbl.tips.directBuyPanel:SetAnchoredPosition(self.tipsTbl.tips.directBuyPanel.rectTransform.sizeDelta.x / 2, -(self.tipsTbl.tips.directBuyPanel.rectTransform.sizeDelta.y / 2 + y))
  end
end

function Tip_ItemTipTwoUI:FixedCalculTipsPos(position, offset, tipsWH)
  local devX, devY = offset.x, offset.y
  local h1 = 0
  if UIManager.IsVisible(UIID.Auction_AuctionUI) and tipsWH.y > 470 then
    h1 = 40
  end
  local realLocalPos = Vector3.New(position.x + devX / 2, position.y + devY / 2 - h1, 0)
  self.tipsTbl.tips.Img_TipBg.transform.localPosition = realLocalPos
  local _, imgY = self.tipsTbl.tips.Img_TipBg:GetAnchoredPosition()
  if imgY - tipsWH.y < self.minDisToScreenBottom then
    realLocalPos.y = realLocalPos.y + Mathf.Abs(imgY - tipsWH.y) + self.minDisToScreenBottom
  end
  if self.args.item and self.args.item.tipsPosition then
    local pos = self.args.item.tipsPosition
    realLocalPos = Vector3.New(realLocalPos.x + pos.x, realLocalPos.y + pos.y, realLocalPos.z + pos.z)
  elseif self.args.item and self.args.item.tipsPosValue then
    realLocalPos = self.tipsTbl.tips.Img_TipBg.transform.parent:InverseTransformPoint(self.args.item.tipsPosValue)
  elseif self.args.item and self.args.tipsPosValue then
    realLocalPos = self.tipsTbl.tips.Img_TipBg.transform.parent:InverseTransformPoint(self.args.tipsPosValue)
  end
  self:OnSetPosition("left", realLocalPos, tipsWH.x + self.disTipsToTips)
end

function Tip_ItemTipTwoUI:OnSetPosition(dir, pos, imgX)
  if dir == "left" then
    self.tipsTbl.tips.Img_TipBg:SetPivot(1, 1)
    self.tipsTbl.tips.Img_TipBg.transform.localPosition = pos
    local modelPos = Vector3.New(108, -90, 0)
    if self.args.openType ~= TipsOpenType.ShopOpen then
      self.tipsTbl.tips.directBuyPanel:SetAnchoredPosition(modelPos.x, modelPos.y)
    end
    if self.showContrastTips then
      self.tipsTbl.contrastTips.Img_TipBg:SetPivot(1, 1)
      self.tipsTbl.contrastTips.Img_TipBg.transform.localPosition = Vector3.New(pos.x - imgX, pos.y, pos.z)
    end
  else
  end
end

function Tip_ItemTipTwoUI:AddTitleHeight(titleImgCtr, tips)
  local x = titleImgCtr:GetAnchoredPosition()
  titleImgCtr:SetAnchoredPosition(x, -tips.centerHeight)
  titleImgCtr:SetActive(true)
  tips.centerHeight = tips.centerHeight + titleImgCtr.transform.rect.height + self.titleSpaceLine
end

function Tip_ItemTipTwoUI:CalculStrPosAndHeight(tbl, textControl, tips, titleImgCtr)
  if #tbl == 0 then
    textControl:SetActive(false)
    return
  else
    if titleImgCtr ~= nil then
      self:AddTitleHeight(titleImgCtr, tips)
    end
    local x = textControl:GetAnchoredPosition()
    local viceTextControl = UIControl(textControl.transform, "lab_TipSuitAdditional2")
    if viceTextControl.transform ~= nil then
      if tips.viceSuitadditionalTable ~= nil then
        viceTextControl:SetText(table.concat(tips.viceSuitadditionalTable, "\n"))
      else
        viceTextControl:SetText("")
      end
    end
    textControl:SetAnchoredPosition(x, -tips.centerHeight)
    textControl:SetText(table.concat(tbl, "\n"))
    textControl:SetActive(true)
    tips.centerHeight = tips.centerHeight + textControl.text.preferredHeight + self.minSpaceLine
  end
end

function Tip_ItemTipTwoUI:ShopBuyUIAdjust(tips)
  local UIControl = {
    itemInfo = self.args.item,
    buyBtn = tips.AuctionBtn,
    AuctionText = tips.AuctionText,
    input_price = tips.AuctionInputPrice,
    inputText_price = tips.AuctionInputTextPrice,
    fixed_price = tips.lab_fixedPriceValue,
    fixed_text = tips.lab_fixedPriceText,
    img_icon = tips.img_icon,
    lab_count = tips.lab_count,
    btn_add = tips.btn_add,
    btn_minus = tips.btn_minus,
    lab_InputField = tips.lab_InputField
  }
  EventManager.Dispatch(Event.ShowShopBuyPanel, UIControl)
  if self.args and self.args.showType and self.args.showType == TipSubPanelPos.down then
    tips.directBuyPanel.transform.anchorMin = Vector2.right * 0.5 + Vector2.up
    tips.directBuyPanel.transform.anchorMax = Vector2.right * 0.5 + Vector2.up
    local hightSize = tips.contentHeight + tips.directBuyPanel.rectTransform.sizeDelta.y / 2
    hightSize = math.floor(hightSize)
    tips.directBuyPanel:SetAnchoredPosition(0, hightSize)
  else
    tips.directBuyPanel.transform.anchorMin = Vector2.one
    tips.directBuyPanel.transform.anchorMax = Vector2.one
    local widthSize = tips.imgWidth + tips.directBuyPanel.rectTransform.sizeDelta.x / 2
    widthSize = math.floor(widthSize)
    tips.directBuyPanel:SetAnchoredPosition(tips.directBuyPanel.rectTransform.sizeDelta.x / 2, -tips.directBuyPanel.rectTransform.sizeDelta.y / 2)
  end
end

function Tip_ItemTipTwoUI:OpenSpecialPanel(tips)
  if tips.isContrast then
    tips.go_btns:SetActive(true)
    tips.directBuyPanel:SetActive(false)
    return
  end
  tips.title:SetText("S\225\187\145 l\198\176\225\187\163ng")
  tips.price:SetActive(true)
  tips.putOnTips:SetActive(false)
  tips.allPrice:SetActive(false)
  tips.change_price:SetActive(false)
  tips.bg_buy:SetSizeDelta(230, 180)
  tips.bg_buy:SetAnchoredPosition(0, -70)
  tips.AuctionBtn:SetAnchoredPosition(0, 93)
  if self.args.openType == TipsOpenType.AuctionOpen then
    tips.go_btns:SetActive(false)
    tips.directBuyPanel:SetActive(true)
    local UIControl = {
      type = self.args.buyType,
      itemInfo = self.args.item,
      AuctionBtn = tips.AuctionBtn,
      AuctionText = tips.AuctionText,
      AuctionInputPrice = tips.AuctionInputPrice,
      AuctionInputTextPrice = tips.AuctionInputTextPrice,
      lab_count = tips.lab_count,
      btn_add = tips.btn_add,
      btn_minus = tips.btn_minus,
      img_icon = tips.img_icon,
      putOnTips = tips.putOnTips,
      lab_putOnPrice = tips.lab_putOnPrice,
      allPrice = tips.allPrice,
      InputAllPrice = tips.InputAllPrice,
      change_price = tips.change_price,
      bg_buy = tips.bg_buy,
      allImg_icon = tips.allImg_icon,
      priceTitle = tips.priceTitle,
      count = tips.count,
      price = tips.price
    }
    EventManager.Dispatch(Event.Auction_SetPanel, UIControl)
  elseif self.args.openType == TipsOpenType.UnionAuction then
    tips.go_btns:SetActive(false)
    tips.directBuyPanel:SetActive(true)
    local UIControl = {
      itemInfo = self.args.item,
      AuctionBtn = tips.AuctionBtn,
      AuctionText = tips.AuctionText,
      lab_count = tips.lab_count,
      btn_add = tips.btn_add,
      btn_minus = tips.btn_minus,
      img_icon = tips.img_icon,
      title = tips.title,
      priceIsActive = tips.price
    }
    EventManager.Dispatch(Event.Auction_SetPanel, UIControl)
  elseif self.args.openType == TipsOpenType.ShopOpen then
    tips.go_btns:SetActive(false)
    tips.directBuyPanel:SetActive(true)
    self:ShopBuyUIAdjust(tips)
  else
    tips.go_btns:SetActive(true)
    tips.directBuyPanel:SetActive(false)
    if self.args.ShowObtain and not string.isNullOrEmpty(tips.ItemInfo.tblItem.obtainId) then
      self.go_obtain:SetActive(true)
      local obtainIds = string.split(tips.ItemInfo.tblItem.obtainId, "#")
      local obtainTbl = {}
      local cfgTblAll
      local dOpen = false
      local open = false
      local openServerDay = LoginData.openServerDay
      for _, obtainId in ipairs(obtainIds) do
        local cfgTbl = ClientTable.cfg_Obtain_obtainManager:TryGetValue(tonumber(obtainId))
        if cfgTbl ~= nil and (not cfgTbl.condition or cfgTbl.condition ~= nil and ConditionManager.Check4D(cfgTbl.condition)) then
          if cfgTbl.showcolor ~= 1 then
            table.insert(obtainTbl, cfgTbl)
          elseif cfgTbl.showcolor == 1 then
            if not open and cfgTbl.name == "Recharge_WelfareUI" then
              if cfgTbl.giftId ~= nil then
                local DConditions = string.split(cfgTbl.giftId, "-")
                local c1 = {}
                local c2 = {}
                local c11 = {}
                local bool = false
                for i = 1, #DConditions do
                  if DConditions[i] ~= nil then
                    c1 = string.split(DConditions[i], "\\")
                    if c1 ~= nil and c1[1] ~= nil then
                      c2 = string.split(c1[1], "&")
                    end
                    if c2[1] ~= nil and c2[2] ~= nil and tonumber(c2[1]) ~= nil and tonumber(c2[2]) ~= nil and openServerDay >= tonumber(c2[1]) and openServerDay <= tonumber(c2[2]) then
                      c11 = c1
                      bool = true
                    end
                  end
                end
                if bool then
                  dOpen = Tip_ItemTipTwoUI:ConditionOpen(c11)
                  if dOpen then
                    table.insert(obtainTbl, cfgTbl)
                  end
                end
              end
            elseif cfgTbl.name == "Commercialization_FirstActivityUI" and cfgTbl.giftId ~= nil and cfgTbl.giftId ~= "" then
              open = Tip_ItemTipTwoUI:ConditionOpen(cfgTbl.giftId)
              local bool1 = false
              if 1 <= openServerDay and openServerDay <= 7 then
                bool1 = true
              end
              if open and bool1 then
                table.insert(obtainTbl, cfgTbl)
              end
            end
          end
        end
        if cfgTbl ~= nil and not string.isNullOrEmpty(cfgTbl.shopId) and cfgTbl.name == "Shop_ShopUI" then
          cfgTblAll = cfgTbl
        end
      end
      if #obtainTbl == 0 then
        self.go_obtain:SetActive(false)
      end
      self.obtainContainer:SetData(obtainTbl)
      local w = self.img_obtainBg:GetSizeDelta()
      local leng = 0
      if cfgTblAll ~= nil then
        for i, v in pairs(obtainTbl) do
          if v.id == cfgTblAll.id then
            leng = self:SetFastBuy(cfgTblAll.shopId)
            break
          end
          self.buy_thing:SetActive(false)
        end
      else
        self.buy_thing:SetActive(false)
      end
      self.img_obtainBg:SetSizeDelta(w, 40 + leng + self.maxSpaceLine + self.obtainHeight * #obtainTbl)
    end
  end
end

function Tip_ItemTipTwoUI:ConditionOpen(conditions)
  local s1 = {}
  local dOpen = false
  if type(conditions) == "table" and conditions[2] ~= nil and string.contains(conditions[2], "#") or type(conditions) == "table" and table.contains(conditions, "#") or type(conditions) == "string" and string.contains(conditions, "#") then
    if type(conditions) ~= "table" then
      s1 = string.split(conditions, "#")
    else
      s1 = string.split(conditions[2], "#")
    end
    for i, v in ipairs(s1) do
      dOpen = RefreshData.GetLimitCount(tonumber(v)) ~= 0 and true or false
      if not dOpen then
        break
      end
    end
  elseif type(conditions) == "table" and conditions[2] ~= nil and string.contains(conditions[2], "|") or type(conditions) == "table" and table.contains(conditions, "|") or type(conditions) == "string" and string.contains(conditions, "|") then
    if type(conditions) ~= "table" then
      s1 = string.split(conditions, "|")
    else
      s1 = string.split(conditions[2], "|")
    end
    for i, v in ipairs(s1) do
      dOpen = RefreshData.GetLimitCount(tonumber(v)) ~= 0 and true or false
      if dOpen then
        break
      end
    end
  elseif type(conditions) == "table" and conditions[2] ~= nil then
    dOpen = RefreshData.GetLimitCount(tonumber(conditions[2])) ~= 0 and true or false
  elseif type(conditions) == "string" then
    dOpen = RefreshData.GetLimitCount(tonumber(conditions)) ~= 0 and true or false
  end
  return dOpen
end

function Tip_ItemTipTwoUI:AdjustUI(tips)
  tips.imgWidth = tips.imgWidth > self.minWidth and tips.imgWidth or self.minWidth
  local maxCenterHeight = self.maxCenterHeight
  tips.sv_center.scrollRect.enabled = maxCenterHeight < tips.centerHeight
  local realCenterHeight = maxCenterHeight < tips.centerHeight and maxCenterHeight or tips.centerHeight
  if tips.ItemInfo.itemId == 53090001 or tips.ItemInfo.itemId == 53090002 or tips.ItemInfo.itemId == 53090003 then
    realCenterHeight = tips.centerHeight
    tips.sv_center.scrollRect.enabled = false
  end
  local centerX, centerY = tips.sv_center:GetAnchoredPosition()
  tips.sv_center:SetAnchoredPosition(centerX, -tips.topHeight)
  centerY = -tips.topHeight
  if tips.ItemInfo.tblEquip ~= nil and (string.contains(tips.ItemInfo.tblEquip.name, "Nh\225\186\171n \196\144\225\186\161i Thi\195\170n S\225\187\169-Tr\195\161i") or string.contains(tips.ItemInfo.tblEquip.name, "Nh\225\186\171n \196\144\225\186\161i Thi\195\170n S\225\187\169-Ph\225\186\163i")) then
    realCenterHeight = realCenterHeight + 25
  end
  local centerWidth = tips.sv_center:GetSizeDelta()
  tips.sv_center:SetSizeDelta(centerWidth, realCenterHeight)
  local ccHeight = tips.Content:GetSizeDelta()
  tips.Content:SetSizeDelta(ccHeight, tips.centerHeight)
  tips.Content:SetAnchoredPosition(Vector2.zero)
  if realCenterHeight == 10 then
    realCenterHeight = 0
  end
  tips.contentHeight = tips.contentHeight + realCenterHeight
  local bottomX = tips.Img_bottom:GetAnchoredPosition()
  local bottomY = 10 < realCenterHeight and centerY - realCenterHeight or centerY
  tips.Img_bottom:SetAnchoredPosition(bottomX, bottomY)
  if tips.topHeight > 0 then
    tips.img_topBg:SetActive(true)
    tips.img_topBg:SetAnchoredPosition(Vector2.zero)
    tips.img_topBg:SetSizeDelta(tips.imgWidth, tips.topHeight + realCenterHeight + tips.bottomHeight)
  end
  if tips.bottomHeight >= 18 then
    tips.img_line:SetActive(true)
  end
  self:OpenSpecialPanel(tips)
  tips.Img_TipBg:SetActive(true)
  tips.Img_TipBg:SetSizeDelta(tips.imgWidth, tips.contentHeight)
  if #tips.suitadditionalTable > 1 then
    self.itemChooseContainer = UIContainer(tips.lab_TipSuitAdditional, self)
    self.itemChooseContainer:SetMaxCount(table.count(tips.suitadditionalTable))
    local h = tips.lab_TipSuitAdditional.text.preferredHeight
    for i = 1, table.count(tips.suitadditionalTable) do
      local obj
      if i < tips.suitContainer.transform.childCount then
        obj = UIControl(tips.suitContainer.transform:GetChild(i).transform)
        obj.gameObject:SetActive(true)
      else
        obj = UIControl(self.itemChooseContainer:GetOrCreateItem(i))
      end
      obj:SetText(tips.suitadditionalTable[i])
      local viceTextControl = UIControl(obj.gameObject.transform, "lab_TipSuitAdditional2")
      if viceTextControl ~= nil and viceTextControl.transform ~= nil and tips.viceSuitadditionalTable ~= nil then
        viceTextControl:SetText(tips.viceSuitadditionalTable[i] or "")
      end
    end
    if 1 < tips.suitContainer.transform.childCount - table.count(tips.suitadditionalTable) then
      local count = tips.suitContainer.transform.childCount
      for i = 1, count - table.count(tips.suitadditionalTable) - 1 do
        local t = tips.suitContainer.transform:GetChild(count - i).gameObject
        t:SetActive(false)
      end
    end
    local t, y = tips.lab_suitAdditional:GetAnchoredPosition()
    local x = tips.suitContainer:GetAnchoredPosition()
    local width, ccHeight = tips.suitContainer:GetSizeDelta()
    tips.suitContainer:SetSizeDelta(ccHeight, h)
    tips.suitContainer:SetAnchoredPosition(x, y - h / 2 - 32)
    tips.suitContainer:SetActive(true)
  end
end

function Tip_ItemTipTwoUI:BindBtnOpreate(tips, rightOperate)
  local needShowLeftBtn = true
  if rightOperate == EItemOperateType.CancelSelect or rightOperate == EItemOperateType.XiLianEquip or rightOperate == EItemOperateType.XiLianRedEquip or rightOperate == EItemOperateType.AddEquip or UIManager.IsVisible(UIID.BagWarehouseUI) then
    needShowLeftBtn = false
  end
  if needShowLeftBtn and not string.isNullOrEmpty(tips.ItemInfo.tblItem.leftOperate) and self.args.openType ~= TipsOpenType.RoleEquipOpen then
    local leftOperates = string.split(tips.ItemInfo.tblItem.leftOperate, "#")
    if #leftOperates == 1 and tonumber(leftOperates[1]) == EItemOperateType.Discard and self.args.openType ~= TipsOpenType.BagOpen then
      needShowLeftBtn = false
    end
  end
  local btn = needShowLeftBtn and tips.btn_RightClick or tips.btn_CenterClick
  if not rightOperate then
    self:BindBtnOperate(tips, btn, tips.ItemInfo.tblItem.rightOperate)
  elseif type(rightOperate) ~= "table" then
    self:BindBtnOperate(tips, btn, rightOperate)
  else
    self:BindBtnOperateByFunc(tips, btn, rightOperate)
  end
  if needShowLeftBtn then
    self:BindBtnLeftOpreate(tips)
  end
  if self.args.openSource == "Fruit_FruitAddUI" then
    tips.btn_CenterClick:SetActive(false)
    self:BindBtnOperate(tips, tips.btn_LeftClick, EItemOperateType.Use)
    self:BindBtnOperate(tips, tips.btn_RightClick, EItemOperateType.UseN)
    needShowLeftBtn = true
  end
  if self.args.isHolySpiritLeft then
    tips.btn_CenterClick:SetActive(false)
    self:BindBtnOperate(tips, tips.btn_LeftClick, EItemOperateType.Disboard)
    needShowLeftBtn = true
  end
  if self.args.OpenSourceUI ~= nil and self.args.OpenSourceUI == "Equip_IntensifyUI" then
    tips.btn_CenterClick:SetActive(false)
    tips.btn_LeftClick:SetActive(false)
    tips.btn_RightClick:SetActive(false)
  end
  return not needShowLeftBtn
end

function Tip_ItemTipTwoUI:BindBtnLeftOpreate(tips)
  if tips.ItemInfo ~= nil and tips.ItemInfo.tblItem ~= nil and not string.isNullOrEmpty(tips.ItemInfo.tblItem.leftOperate) then
    local rightOperates = string.split(tips.ItemInfo.tblItem.leftOperate, "#")
    if self.args.otherType == TipsOtherType.RoleEquipOpen_jewelry then
      rightOperates = {}
      rightOperates[1] = EItemOperateType.XiLianRedEquip
    elseif self.args.otherType == TipsOtherType.RoleRedEquipOpen_jewelry then
      rightOperates = {}
      rightOperates[1] = EItemOperateType.Close
    elseif self.args.openType == TipsOpenType.RoleEquipOpen and ClientTable.cfg_Global_globalManager:CheckTipsShowStrengthenBtn(tips.ItemInfo.tblItem.id) then
      rightOperates = {}
      rightOperates[1] = EItemOperateType.Strengthen
    elseif self.args.openType == TipsOpenType.HolyRingCombineOpen then
      rightOperates = {}
      rightOperates[1] = EItemOperateType.Close
    end
    local count = #rightOperates
    for i = 1, #rightOperates do
      local operateNum = tonumber(rightOperates[i])
      if operateNum == EItemOperateType.Shelves and tips.ItemInfo.tblEquip ~= nil and not AuctionController.CheckMeetPutOnCondition(tips.ItemInfo.tblEquip, tips.ItemInfo.bind, tips.ItemInfo.intensify, tips.ItemInfo.additional, true) then
        table.remove(rightOperates, i)
        if count == 1 then
          table.insert(rightOperates, i, EItemOperateType.Close)
        end
      end
    end
    if #rightOperates == 1 then
      self:BindBtnOperate(tips, tips.btn_LeftClick, tonumber(rightOperates[1]))
    else
      self:BindBtnOperate(tips, tips.btn_LeftClick, EItemOperateType.More)
    end
  end
end

function Tip_ItemTipTwoUI:BindBtnOperate(tips, btnCtr, Operate)
  if tips.ItemInfo.bind ~= ItemBind.trade and Operate == EItemOperateType.Shelves then
    Operate = EItemOperateType.Close
  end
  btnCtr:SetActive(true)
  btnCtr.tips = tips
  if Operate == EItemOperateType.Use then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.shiyong)
    btnCtr:SetOnClick(self, self.Button_UseItem)
  elseif Operate == EItemOperateType.UseAll then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.shiyongquanbu)
    btnCtr:SetOnClick(self, self.Button_UseAllItem)
  elseif Operate == EItemOperateType.Wear then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.zhuangbei)
    btnCtr:SetOnClick(self, self.Button_WearEquip)
  elseif Operate == EItemOperateType.Disboard then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.tuoxia)
    btnCtr:SetOnClick(self, self.Button_Disboard)
  elseif Operate == EItemOperateType.MountDisboard then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.tuoxia)
    btnCtr:SetOnClick(self, self.Button_MountDisboard)
  elseif Operate == EItemOperateType.Deposit then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.fangru)
    btnCtr:SetOnClick(self, self.Button_Deposit)
  elseif Operate == EItemOperateType.TakeOut then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.quchu)
    btnCtr:SetOnClick(self, self.Button_TakeOut)
  elseif Operate == EItemOperateType.More then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.gengduo)
    btnCtr:SetOnClick(self, self.Button_More)
  elseif Operate == EItemOperateType.Discard then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.diuqi)
    btnCtr:SetOnClick(self, self.Button_Discard)
  elseif Operate == EItemOperateType.Close then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.quxiao)
    btnCtr:SetOnClick(self, self.Button_Close)
  elseif Operate == EItemOperateType.CancelSelect then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.quxiao)
    btnCtr:SetOnClick(self, self.Button_CancelSelect)
  elseif Operate == EItemOperateType.OpenUI then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.shiyong)
    btnCtr:SetOnClick(self, self.Button_OpenUI)
  elseif Operate == EItemOperateType.OpenOtherUI then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.qianwang)
    btnCtr:SetOnClick(self, self.Button_OpenOtherUI)
  elseif Operate == EItemOperateType.AddEquip then
    if UIManager.IsVisible(UIID.Equip_OverlapUI) then
      tips.btnName2Lab[btnCtr:GetName()]:SetText(self.addEquip)
      btnCtr:SetOnClick(self, self.Button_AddEquipToOverlap)
    elseif UIManager.IsVisible(UIID.Equip_StoneUI) then
      if self.args.isPutOn then
        tips.btnName2Lab[btnCtr:GetName()]:SetText("Kh\225\186\163m")
        btnCtr:SetOnClick(self, self.Button_AddEquipToStone)
      else
        tips.btnName2Lab[btnCtr:GetName()]:SetText("Th\195\161o")
        btnCtr:SetOnClick(self, self.Button_TakeOffEquipStone)
      end
    end
  elseif Operate == EItemOperateType.XiLianEquip then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.xiLianEquip)
    btnCtr:SetOnClick(self, self.Button_XiLianOnClick)
  elseif Operate == EItemOperateType.XiLianRedEquip then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.xiLianRedEquip)
    btnCtr:SetOnClick(self, self.Button_XiLianRedEquipOnClick)
  elseif Operate == EItemOperateType.Shelves then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.Shelves)
    btnCtr:SetOnClick(self, self.Button_Shelves)
  elseif Operate == EItemOperateType.Strengthen then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.strengthen)
    btnCtr:SetOnClick(self, self.Button_Strengthen)
  elseif Operate == EItemOperateType.Upgrade then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.Upgrade)
    btnCtr:SetOnClick(self, self.Button_Upgrade)
  elseif Operate == EItemOperateType.JumpPanelOrUse then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.shiyong)
    btnCtr:SetOnClick(self, self.Button_JumpPanelOrUse)
  elseif Operate == EItemOperateType.UseN then
    local useCount = tips.ItemInfo.count
    tips.btnName2Lab[btnCtr:GetName()]:SetText(string.format("D\195\185ng %d c\195\161i", useCount))
    btnCtr:SetOnClick(self, self.Button_UseAllItem)
  elseif Operate == EItemOperateType.Recycle then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.Recyle)
    btnCtr:SetOnClick(self, function()
      Bag_3DBagInfoUI:OpenBagSellInfoUI()
      UIManager.Hide(UIID.ItemTipUI)
    end)
  elseif Operate == EItemOperateType.Decompose then
    tips.btnName2Lab[btnCtr:GetName()]:SetText("T\195\161ch")
    btnCtr:SetOnClick(self, self.Button_Decompose)
  elseif Operate == EItemOperateType.compound then
    tips.btnName2Lab[btnCtr:GetName()]:SetText("Gh\195\169p")
    btnCtr:SetOnClick(self, self.Compound)
  elseif Operate == EItemOperateType.Exchange then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.Exchange)
    btnCtr:SetOnClick(self, self.Button_Exchange)
  elseif Operate == EItemOperateType.HolidayMoney then
    tips.btnName2Lab[btnCtr:GetName()]:SetText(self.shiyong)
    btnCtr:SetOnClick(self, self.Button_Exchange)
  end
end

function Tip_ItemTipTwoUI:BindBtnOperateByFunc(tips, btnCtr, Operate)
  btnCtr:SetActive(true)
  btnCtr.param = Operate.param
  btnCtr.tips = tips
  tips.btnName2Lab[btnCtr:GetName()]:SetText(Operate.name)
  btnCtr:SetOnClick(Operate.ui, Operate.func)
end

function Tip_ItemTipTwoUI:ShowButton(tips)
  local flag = true
  if not tips.isContrast then
    if self.args.rightOperate and self.args.rightOperate == EItemOperateType.Show then
      flag = false
    end
  else
    flag = false
  end
  return flag
end

function Tip_ItemTipTwoUI:AdditionalJudge(ItemInfo)
  return false
end

local function TextLengthJudge(control, str)
  control:SetText(str)
  local w = control:GetSizeDelta()
  local flag
  if w < control.text.preferredWidth then
    flag = true
  end
  control:SetText("")
  return flag
end

function Tip_ItemTipTwoUI:ItemModel(tips)
  local type = tips.ItemInfo.tblItem.type
  tips.Tip_ModelShow:SetSizeDelta(144, 90)
  if tips.ItemInfo.tblItem.needLevel > ViewData.meData.level then
    tips.Tip_ModelShow:SetSizeDelta(144, 110)
  end
  tips.go_model:SetScale(Vector3(1.3, 1.3, 1.3))
  self:ShowModel(tips)
  local x = tips.Tip_ModelShow:GetAnchoredPosition()
  tips.Tip_ModelShow:SetAnchoredPosition(x, 0)
  local MaxHeight = tips.Tip_ModelShow.transform.rect.height
  tips.contentHeight = tips.contentHeight + MaxHeight
  tips.topHeight = tips.topHeight + MaxHeight
end

function Tip_ItemTipTwoUI:TitleStr(tips)
  local color = ItemQuality2ColorDic[EItemColorEnum.white]
  local type = tips.ItemInfo.tblItem.type
  if type == 1 then
    color = ItemQuality2ColorDic[EItemColorEnum.white]
  elseif type == 3 then
    color = ItemQuality2ColorDic[EItemColorEnum.white]
  elseif type == 5 then
    color = ItemQuality2ColorDic[EItemColorEnum.gold]
  elseif type == 6 then
    color = ItemQuality2ColorDic[EItemColorEnum.gold]
  end
  if tips.ItemInfo.tblItem.titleColor ~= nil then
    color = ItemQuality2ColorDic[tips.ItemInfo.tblItem.titleColor]
  end
  local titleStr = string.GetColorText(tips.ItemInfo.tblItem.name, color)
  if tips.ItemInfo.tblItem.type == 19 and tips.ItemInfo.serverInfo ~= nil then
    local runesLevel = tips.ItemInfo.serverInfo.runesLevel or tips.ItemInfo.serverInfo.level
    if runesLevel and runesLevel ~= 0 then
      titleStr = string.GetColorText(string.format("%s +%d", titleStr, runesLevel), color)
    end
  end
  tips.lab_TipTitle:SetText(titleStr)
  tips.imgWidth = tips.lab_TipTitle.text.preferredWidth
  tips.lab_TipTitle:SetAnchoredPosition(70, -6)
  tips.lab_TipTitle:SetActive(true)
  tips.lab_TipTitle:SetTextAnchor(TextAnchor.MiddleLeft)
  local _, h = tips.lab_TipTitle:GetSizeDelta()
  tips.lab_TipTitle:SetSizeDelta(self.minWidth - 144, h)
  local infoStr = ""
  local eType = tips.ItemInfo.tblItem.type
  if eType == EItemType.Consumables then
    infoStr = "V\225\186\173t ph\225\186\169m ti\195\170u hao"
  elseif eType == EItemType.SkillBook then
    infoStr = "S\195\161ch K\225\187\185 N\196\131ng"
  elseif eType == EItemType.TreasureChest then
    infoStr = "R\198\176\198\161ng"
  elseif eType == EItemType.Material then
    infoStr = "Nguy\195\170n li\225\187\135u"
  else
    infoStr = "\196\144\225\186\161o c\225\187\165"
  end
  local bindAndEquipStr = ""
  if tips.ItemInfo.bind then
    if tips.ItemInfo.tblItem.minAuctionPrice == "" then
      bindAndEquipStr = string.GetColorText(ItemBind2Name[2], ItemQuality2ColorDic[EItemColorEnum.red])
    else
      bindAndEquipStr = string.GetColorText(ItemBind2Name[tips.ItemInfo.bind], ItemQuality2ColorDic[EItemColorEnum.green])
    end
  end
  infoStr = bindAndEquipStr .. "\n" .. infoStr
  if tips.ItemInfo.tblItem.needLevel > ViewData.meData.level then
    local cLevelTbl = ClientTable.cfg_Character_levelManager:TryGetValue(tips.ItemInfo.tblItem.needLevel)
    if cLevelTbl then
      local needLevelStr = string.format(self.suoxudengji, cLevelTbl.name)
      needLevelStr = string.GetColorText(needLevelStr, "#ED2E2E")
      infoStr = infoStr .. "\n" .. needLevelStr
    end
  end
  if tips.ItemInfo.tblItem.type == EItemType.EnchantedCrystal then
    local equipInfo = ClientTable.cfg_Item_equipManager:TryGetValue(tips.ItemInfo.itemId)
    if equipInfo and not string.isNullOrEmpty(equipInfo.equipPosition) then
      local jieshu = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Enchant_smelt_3")
      if not string.isNullOrEmpty(equipInfo.showEquipclass) then
        jieshu = jieshu .. equipInfo.showEquipclass
      end
      infoStr = infoStr .. "\n" .. jieshu
      tips.topHeight = tips.topHeight + 25
      local equipPosition = string.split(equipInfo.equipPosition, "#")
      local str = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Enchant_smelt_2")
      for i, v in pairs(equipPosition) do
        if EnchantEquipNameConstant[tonumber(v)] then
          str = str .. EnchantEquipNameConstant[tonumber(v)] .. " "
        end
      end
      infoStr = infoStr .. "\n" .. str
      tips.topHeight = tips.topHeight + 30
    end
  end
  tips.lab_TipTopInfo:SetText(infoStr)
  tips.lab_TipTopInfo:SetActive(true)
  local x = tips.lab_TipTopInfo:GetAnchoredPosition()
  tips.lab_TipTopInfo:SetAnchoredPosition(x, -44)
  tips.lab_TipTopInfo:SetFontSize(18)
end

function Tip_ItemTipTwoUI:EquiptTilteStr(tips)
  local titleStr = tips.ItemInfo.tblItem.name
  if tips.ItemInfo.tblItem.titleColor ~= nil then
    titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[tips.ItemInfo.tblItem.titleColor])
  end
  if tips.ItemInfo.specialInfo and next(tips.ItemInfo.specialInfo) ~= nil then
    local ids = tips.ItemInfo.specialInfo
    if ids ~= nil and next(ids) ~= nil then
      local showStr = ClientTable.cfg_Item_equip_specialManager:GetSuffixStrByIds(ids)
      if showStr then
        titleStr = titleStr .. showStr
      end
    end
  end
  if tips.ItemInfo.tblItem.subType == 18 or tips.ItemInfo.tblItem.subType == 19 or tips.ItemInfo.tblItem.subType == 26 then
    local GrowUpTable = MeEquipController.GetEquipGrowUpCfg(tips.ItemInfo.tblItem.subType, tips.ItemInfo.level)
    local cellIndex = tonumber(string.split(tips.ItemInfo.tblEquip.equipPosition, "#")[1])
    if GrowUpTable ~= nil and RoleEquipUtility.EquipTypeUtility(cellIndex, ERoleEquipCondition.Normal) then
      titleStr = titleStr .. "(" .. GrowUpTable.level .. " c\225\186\165p)"
    end
  end
  if tips.ItemInfo.intensify and tips.ItemInfo.intensify ~= 0 then
    titleStr = titleStr .. " +" .. tips.ItemInfo.intensify
  end
  if tips.ItemInfo.tblItem.type >= EItemType.FireGem and tips.ItemInfo.tblItem.type <= EItemType.SoilGem then
    titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.bPurple])
  else
    local subType = tips.ItemInfo.tblItem.subType
    if 1 <= subType and subType <= 17 or subType == 24 or subType == 25 or subType == 81 then
      if tips.ItemInfo.isSuit then
        titleStr = string.GetColorText(titleStr, "#f36055")
      elseif 0 < table.count(tips.ItemInfo.excellence) then
        titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.green])
      elseif 0 < table.count(tips.ItemInfo.luckIds) then
        titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.bBlue])
      else
        local equip = ConfigManager.GetConfig("cfg_Item_equip", tips.ItemInfo.itemId, "id")
        local bool = equip.excellentNumber ~= "" and true or false
        if bool then
          titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.green])
        else
          titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.white])
        end
      end
    elseif subType == 18 or subType == 19 or subType == 26 then
      titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.green])
    elseif subType == 20 then
      titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[11])
    elseif subType == 21 then
      titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.bBlue])
    elseif subType == 27 or subType == 28 then
      titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.gold])
    elseif subType == 29 then
      titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.gold])
    elseif subType == 22 then
      titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.bBlue])
    end
  end
  if tips.ItemInfo.valid == false then
    local str = string.GetColorText("Ch\198\176a c\195\179 hi\225\187\135u l\225\187\177c", ItemQuality2ColorDic[EItemColorEnum.red])
    titleStr = titleStr .. "(" .. str .. ")"
  end
  if self.args ~= nil and self.args.ctrl ~= nil and self.args.ctrl.isShowNoEnableEquip then
    titleStr = string.GetColorText(tips.ItemInfo.tblItem.name .. "(Ch\198\176a nh\225\186\173n)", ItemQuality2ColorDic[EItemColorEnum.gray])
  end
  tips.lab_TipTitle:SetTextAnchor(TextAnchor.MiddleCenter)
  local w, h = tips.lab_TipTitle:GetSizeDelta()
  tips.lab_TipTitle:SetSizeDelta(self.minWidth, h)
  tips.lab_TipTitle:SetText(titleStr)
  tips.imgWidth = tips.lab_TipTitle.text.preferredWidth
  tips.lab_TipTitle:SetAnchoredPosition(0, -tips.topHeight)
  tips.lab_TipTitle:SetActive(true)
  tips.contentHeight = tips.contentHeight + tips.lab_TipTitle.transform.rect.height + self.minSpaceLine
  tips.topHeight = tips.topHeight + tips.lab_TipTitle.transform.rect.height + self.minSpaceLine
end

function Tip_ItemTipTwoUI:EquipInfoModel(tips)
  tips.go_model:SetScale(Vector3.one)
  tips.Tip_ModelShow:SetSizeDelta(144, 144)
  if tips.ItemInfo.tblItem.subType == 18 or tips.ItemInfo.tblItem.subType == 19 or tips.ItemInfo.tblItem.subType == 26 then
    tips.go_model:SetScale(Vector3.one * 2.5)
    tips.Tip_ModelShow:SetSizeDelta(144, 80)
  end
  if tips.ItemInfo.tblItem.subType == 27 or tips.ItemInfo.tblItem.subType == 28 then
    tips.go_model:SetScale(Vector3.one * 2.5)
    tips.Tip_ModelShow:SetSizeDelta(144, 80)
  end
  if tips.ItemInfo.tblItem.subType == 29 then
    tips.go_model:SetScale(Vector3.one * 2.5)
    tips.Tip_ModelShow:SetSizeDelta(144, 80)
  end
  if tips.ItemInfo.tblItem.subType == 20 then
    tips.Tip_ModelShow:SetSizeDelta(144, 80)
  end
  if tips.ItemInfo.tblItem.subType == 21 then
    tips.go_model:SetScale(Vector3.one * 2.5)
    tips.Tip_ModelShow:SetSizeDelta(144, 80)
  end
  if tips.ItemInfo.tblItem.subType == 501 then
    tips.go_model:SetScale(Vector3.one * 0.9)
    tips.Tip_ModelShow:SetSizeDelta(144, 80)
  end
  if tips.ItemInfo.tblItem.type == 11 or tips.ItemInfo.tblItem.type == 12 or tips.ItemInfo.tblItem.type == 13 or tips.ItemInfo.tblItem.type == 14 then
    tips.Tip_ModelShow:SetSizeDelta(144, 60)
  end
  self:ShowModel(tips)
  local bindAndEquipStr = ""
  if tips.ItemInfo.bind then
    if tips.ItemInfo.tblItem.minAuctionPrice == "" then
      bindAndEquipStr = ItemBind2Name[2]
    else
      bindAndEquipStr = ItemBind2Name[tips.ItemInfo.bind]
    end
  end
  if self.args and self.args.bindCount and self.args.notBindCount and tips.ItemInfo.tblItem.type == EItemType.NewRune then
    local bind = 0
    if self.args.bindCount == 0 and self.args.notBindCount ~= 0 then
      bind = 0
    else
      bind = 1
    end
    bindAndEquipStr = ItemBind2Name[bind]
  end
  if tips.ItemInfo.tblItem.type == EItemType.Equipe then
    local equip = ViewData.meData.equipsData:GetEquipById(tips.ItemInfo.id)
    if equip then
      bindAndEquipStr = bindAndEquipStr .. self.yizhuangbei
    end
  end
  if self.args ~= nil and self.args.ctrl ~= nil and self.args.ctrl.isShowNoEnableEquip then
    bindAndEquipStr = string.GetColorText(bindAndEquipStr, ItemQuality2ColorDic[EItemColorEnum.gray])
  else
    bindAndEquipStr = string.GetColorText(bindAndEquipStr, ItemQuality2ColorDic[EItemColorEnum.white]) .. "\n"
  end
  if not string.isNullOrEmpty(tips.ItemInfo.tblEquip.showEquipclass) and tips.ItemInfo.tblEquip.equipClass ~= 0 then
    bindAndEquipStr = bindAndEquipStr .. "S\225\187\145 b\225\186\173c Trang B\225\187\139: " .. tips.ItemInfo.tblEquip.showEquipclass .. "\n"
  elseif tips.ItemInfo.tblEquip.equipClass ~= 0 then
    local tbl = ClientTable.cfg_Item_class_settingManager:TryGetValue(tips.ItemInfo.tblEquip.equipClass)
    if tbl and tbl.className then
      bindAndEquipStr = bindAndEquipStr .. "S\225\187\145 b\225\186\173c Trang B\225\187\139: " .. tbl.className .. "\n"
    end
  end
  if tips.ItemInfo.tblItem.subType == 20 then
    local quality = tips.ItemInfo.tblItem.quality
    if quality == 3 then
      quality = 2.5
    elseif 3 < quality then
      quality = quality - 1
    end
    local str = string.GetColorText(quality .. " C\195\161nh \196\145\225\187\157i ", ItemQuality2ColorDic[EItemColorEnum.white]) .. "\n"
    bindAndEquipStr = bindAndEquipStr .. str
  end
  self:ConditionStr(tips)
  local subType = tips.ItemInfo.tblItem.subType
  if subType == 1 or subType == 4 or subType == 6 or 8 <= subType and subType <= 12 then
    bindAndEquipStr = bindAndEquipStr .. "V\197\169 Kh\195\173 1 tay" .. "\n"
  elseif subType == 3 or subType == 2 or subType == 5 or subType == 7 or subType == 3 then
    bindAndEquipStr = bindAndEquipStr .. "V\197\169 Kh\195\173 2 tay" .. "\n"
  end
  bindAndEquipStr = bindAndEquipStr .. table.concat(tips.conditionTable, "\n")
  tips.lab_TipTopInfo:SetText(bindAndEquipStr)
  tips.lab_TipTopInfo:SetActive(true)
  local modeHight = tips.Tip_ModelShow.transform.rect.height
  local tipsHeight = tips.lab_TipTopInfo.text.preferredHeight
  local MaxHeight = Mathf.Max(modeHight, tipsHeight)
  local x = tips.Tip_ModelShow:GetAnchoredPosition()
  tips.Tip_ModelShow:SetAnchoredPosition(x, -tips.topHeight - self.minSpaceLine)
  x = tips.lab_TipTopInfo:GetAnchoredPosition()
  tips.lab_TipTopInfo:SetAnchoredPosition(x, -tips.topHeight - self.minSpaceLine)
  tips.lab_TipTopInfo:SetFontSize(18)
  tips.contentHeight = tips.contentHeight + MaxHeight + self.minSpaceLine
  tips.topHeight = tips.topHeight + MaxHeight + self.minSpaceLine
end

local function ModelCover(subType)
  if subType == EItemSubtype.BreastPlate or subType == EItemSubtype.ShinGuards or subType == EItemSubtype.TwoHandedStick then
    return true
  end
  return false
end

function Tip_ItemTipTwoUI:ShowModel(tips)
  tips.modelData:RefreshData(tips.ItemInfo)
  ItemUtility.ShowItemCell(tips.Tip_ModelShow, tips.modelData, self, false, nil, 3, 5)
  tips.Tip_ModelShow:SetActive(true)
  if ModelCover(tips.ItemInfo.tblItem.subType) then
    tips.plane_bottom:SetActive(true)
  end
end

function Tip_ItemTipTwoUI:ConditionStr(tips)
  if tips.ItemInfo.tblItem.needLevel ~= 0 then
    local levelbol
    local level = tips.ItemInfo.tblItem.needLevel
    local regenerate = RoleEquipUtility.RegenerateEquipInfo(tips.ItemInfo)
    if regenerate ~= nil then
      for i, v in pairs(regenerate) do
        if v.RegenerateAttribute[1].attributeName == "levelEnergyReduce" then
          level = level - v.RegenerateAttribute[1].attributeValue
          levelbol = true
        end
      end
    end
    local cLevelTbl = ClientTable.cfg_Character_levelManager:TryGetValue(level)
    local needLevelStr = ""
    if cLevelTbl then
      needLevelStr = string.format(self.suoxudengji, cLevelTbl.name)
    end
    if tips.ItemInfo.tblItem.needLevel > ViewData.meData.level then
      if not levelbol then
        needLevelStr = string.GetColorText(needLevelStr, "#ED2E2E")
      elseif level >= ViewData.meData.level then
        needLevelStr = string.GetColorText(needLevelStr, "#ED2E2E")
      end
    end
    if tips.ItemInfo.valid then
      needLevelStr = string.GetColorText(needLevelStr, ItemQuality2ColorDic[EItemColorEnum.white])
    end
    table.insert(tips.conditionTable, needLevelStr)
  end
  if tips.ItemInfo.tblItem.career ~= "0" then
    local careers = string.split(tips.ItemInfo.tblItem.career, "#")
    local career = ViewData.meData.career
    local needCareerStr = ""
    local first = true
    for _, v in pairs(careers) do
      local careerName = RoleUtility.GteCareerNameByType(tonumber(v))
      local tempStr
      if first then
        tempStr = self.ConditionTips_200 .. careerName
      else
        tempStr = careerName
      end
      local isSelfCareer = RoleUtility.UpWardCompatibilty(career, tonumber(v))
      if not isSelfCareer then
        tempStr = string.GetColorText(tempStr, "#ED2E2E")
      end
      if first then
        first = false
        needCareerStr = needCareerStr .. tempStr
      else
        needCareerStr = needCareerStr .. " " .. tempStr
      end
    end
    if tips.ItemInfo.valid then
      needCareerStr = string.GetColorText(needCareerStr, "#FF0000")
    end
    table.insert(tips.conditionTable, needCareerStr)
  end
  if tips.ItemInfo.tblItem.needStrength ~= 0 then
    local needStrengthStr = string.format(self.suoxuliliang, tips.ItemInfo.tblItem.needStrength)
    local strength = ViewData.meData:GetAttribute(EAttributeType.strength)
    if strength < tips.ItemInfo.tblItem.needStrength then
      local needStr = string.format(self.haixu, tips.ItemInfo.tblItem.needStrength - strength)
      needStrengthStr = needStrengthStr .. " " .. needStr
      needStrengthStr = string.GetColorText(needStrengthStr, "#ED2E2E")
    end
    if tips.ItemInfo.valid then
      needStrengthStr = string.GetColorText(needStrengthStr, "#FF0000")
    end
    table.insert(tips.conditionTable, needStrengthStr)
  end
  if tips.ItemInfo.tblItem.needAgility ~= 0 then
    local needAgiStr = string.format(self.suoxuminjie, tips.ItemInfo.tblItem.needAgility)
    local agility = ViewData.meData:GetAttribute(EAttributeType.agility)
    if agility < tips.ItemInfo.tblItem.needAgility then
      local needStr = string.format(self.haixu, tips.ItemInfo.tblItem.needAgility - agility)
      needAgiStr = needAgiStr .. " " .. needStr
      needAgiStr = string.GetColorText(needAgiStr, "#ED2E2E")
    end
    if tips.ItemInfo.valid then
      needAgiStr = string.GetColorText(needAgiStr, "#FF0000")
    end
    table.insert(tips.conditionTable, needAgiStr)
  end
  if tips.ItemInfo.tblItem.needEnergy ~= 0 then
    local needEnergyStr = string.format(self.suoxuzhili, tips.ItemInfo.tblItem.needEnergy)
    local energy = ViewData.meData:GetAttribute(EAttributeType.energy)
    if energy < tips.ItemInfo.tblItem.needEnergy then
      local needStr = string.format(self.haixu, tips.ItemInfo.tblItem.needEnergy - energy)
      needEnergyStr = needEnergyStr .. " " .. needStr
      needEnergyStr = string.GetColorText(needEnergyStr, "#ED2E2E")
    end
    if tips.ItemInfo.valid then
      needEnergyStr = string.GetColorText(needEnergyStr, "#ED2E2E")
    end
    table.insert(tips.conditionTable, needEnergyStr)
  end
  if tips.ItemInfo.tblItem.needHolyspirit ~= nil then
    local needRandom = TableParse:SplitStringToIntList(tips.ItemInfo.tblItem.needHolyspirit, "#")
    if needRandom[1] ~= nil and needRandom[1] ~= 0 then
      local needEnergy
      local wordTable = ClientTable.cfg_Ui_wordManager:TryGetValue("Shenghun_" .. needRandom[1])
      if wordTable ~= nil then
        needEnergy = wordTable.content
      end
      local needEnergyStr = string.format(self.suoxushenghun, needEnergy .. needRandom[2])
      local energy = HolySpiritPointData.GetNowTypeActivePointCount(needRandom[1])
      if energy < needRandom[2] then
        needEnergyStr = string.GetColorText(needEnergyStr, "#ED2E2E")
      end
      if tips.ItemInfo.valid then
        needEnergyStr = string.GetColorText(needEnergyStr, "#ED2E2E")
      end
      table.insert(tips.conditionTable, needEnergyStr)
    end
  end
end

function Tip_ItemTipTwoUI:ConsumAttribute(tips)
  local itemTips = tips.ItemInfo.tblItem.itemTips
  local ConsumTbl = {}
  if itemTips ~= 0 then
    local itemTipsTbl = ClientTable.cfg_Item_tipsManager:TryGetValue(itemTips)
    if itemTipsTbl then
      local itemTipsStr = itemTipsTbl.content
      local color = ItemQuality2ColorDic[EItemColorEnum.white]
      if tips.ItemInfo.tblItem.subType == 40 then
        color = "#999999"
      end
      itemTipsStr = string.GetColorText(itemTipsStr, color)
      table.insert(ConsumTbl, itemTipsStr)
    end
    if tips.ItemInfo.subType == EItemSubtype.Mount then
      return
    end
    local nobind = tips.ItemInfo.tblItem.bindEqualItem
    local bind = tips.ItemInfo.tblItem.bindEquip
    if tips.ItemInfo.tblItem.type == 1 and (nobind ~= 0 or bind ~= 0) then
      local bind1 = 0
      local nobind2 = 0
      local nobingStr = ""
      if nobind ~= 0 then
        nobind2 = nobind
        bind1 = tips.ItemInfo.itemId
      else
        nobind2 = tips.ItemInfo.itemId
        bind1 = bind
      end
      nobingStr = ClientTable.cfg_Item_itemManager:TryGetValue(nobind2).name
      nobind2 = BagInfoData.GetItemCountByItemConfigId(nobind2)
      bind1 = BagInfoData.GetItemCountByItemConfigId(bind1)
      local str = string.GetColorText(nobingStr .. "\239\188\154" .. nobind2 .. "\n" .. nobingStr .. " Kh\195\179a" .. "\239\188\154" .. bind1, ItemQuality2ColorDic[EItemColorEnum.yellow])
      table.insert(ConsumTbl, str)
    end
    if tips.ItemInfo.tblItem.id == 1000250 then
      local nameStr = ClientTable.cfg_Item_itemManager:TryGetValue(tips.ItemInfo.tblItem.id).name
      local num = BagInfoData.GetItemTotalCountByItemId(tips.ItemInfo.tblItem.id)
      local str = string.GetColorText(nameStr .. "\239\188\154" .. num, ItemQuality2ColorDic[EItemColorEnum.yellow])
      table.insert(ConsumTbl, str)
    end
    self:CalculStrPosAndHeight(ConsumTbl, tips.lab_ConsumAttribute, tips)
  end
end

function Tip_ItemTipTwoUI:EquipStoneVvip(tips)
  if tips.ItemInfo.tblItem.subType == EItemType.Vvip then
    local attribute = CommercializeData.GetNewItemShowVvip(tips.ItemInfo.tblEquip.id)
    for i, v in pairs(attribute) do
      table.insert(tips.VIPattributeTable, v)
    end
    self:CalculStrPosAndHeight(tips.VIPattributeTable, tips.lab_VIPTipAttribute, tips, tips.lab_VIPattribute)
  end
end

function Tip_ItemTipTwoUI:CalcJewelryUpgrade(tips, AttributeInfoTab, GrowUpTable, cur)
  for _, v in pairs(AttributeInfoTab) do
    local num = GrowUpTable[v]
    local str
    if GrowUpTable[v] ~= 0 then
      if v == "maximumPhysBaseDmg" then
        str = string.format(self.gongjili, "V\225\186\173t l\195\189", GrowUpTable.minimumPhysBaseDmg, GrowUpTable.maximumPhysBaseDmg)
      elseif v == "maximumWizBaseDmg" then
        str = string.format(self.gongjili, "Ph\195\169p", GrowUpTable.minimumWizBaseDmg, GrowUpTable.maximumWizBaseDmg)
      elseif v == "maximumHealth_mul" then
        num = num * 0.01
        if num ~= 0 and Mathf.Floor(num * 10) < num * 10 then
          num = num - num % 0.1
        end
        str = num .. "%"
      elseif v == "maximumHealth" then
        str = string.format(self.shengmingzuidazhizengjia, tostring(num))
      elseif v == "defenseBase" then
        str = string.format(self.fangyuli, tostring(num))
      end
      if cur then
        str = string.GetColorText(str, "#DCE1E5")
      else
        str = string.GetColorText(str, "#666666")
      end
    end
    table.insert(tips.jewelryTable, str)
  end
end

function Tip_ItemTipTwoUI:JewelryUpgrade(tips)
  local AttributeInfoTab = {
    "maximumPhysBaseDmg",
    "maximumWizBaseDmg",
    "defenseBase",
    "maximumHealth",
    "maximumHealth_mul"
  }
  local GrowUpTable = MeEquipController.GetEquipGrowUpCfg(tips.ItemInfo.tblItem.subType, tips.ItemInfo.level or 0)
  local LastGrowUpTable = MeEquipController.GetEquipGrowUpCfg(tips.ItemInfo.tblItem.subType, tips.ItemInfo.level + 1 or 0)
  local sstr
  if GrowUpTable then
    sstr = string.GetSizeText("LV." .. tips.ItemInfo.level, 18)
    sstr = string.GetColorText(sstr, "#DCE1E5")
    table.insert(tips.jewelryTable, sstr)
    self:CalcJewelryUpgrade(tips, AttributeInfoTab, GrowUpTable, true)
    self:CalculStrPosAndHeight(tips.jewelryTable, tips.lab_TipJewelryCur, tips, tips.lab_attribute)
  end
  local cellIndex = tonumber(string.split(tips.ItemInfo.tblEquip.equipPosition, "#")[1])
  if RoleEquipUtility.EquipTypeUtility(cellIndex, ERoleEquipCondition.Normal) and LastGrowUpTable then
    tips.centerHeight = tips.centerHeight + self.minSpaceLine
    tips.jewelryTable = {}
    sstr = string.GetSizeText("C\225\186\165p sau LV." .. tips.ItemInfo.level + 1, 18)
    sstr = string.GetColorText(sstr, "#666666")
    table.insert(tips.jewelryTable, sstr)
    self:CalcJewelryUpgrade(tips, AttributeInfoTab, LastGrowUpTable)
    self:CalculStrPosAndHeight(tips.jewelryTable, tips.lab_TipJewelryNext, tips)
  end
end

function Tip_ItemTipTwoUI:EquipStoneAttribute(tips)
  local attribute = RoleEquipUtility.GetEquipStoneFirstAttri(tips.ItemInfo)
  table.insert(tips.arrtibuteTable, attribute)
  tips.centerHeight = tips.centerHeight
  self:CalculStrPosAndHeight(tips.arrtibuteTable, tips.lab_TipAttribute, tips, tips.lab_attribute)
end

function Tip_ItemTipTwoUI:DoPetAttributeEquip(tips, tblEquip)
  local color
  if tips.ItemInfo.tblItem.subType == 20 then
    color = ItemQuality2ColorDic[EItemColorEnum.green]
  else
    color = ItemQuality2ColorDic[EItemColorEnum.blue]
  end
  local attr = 0
  attr = tblEquip.excellentDamageChance and math.floor(tblEquip.excellentDamageChance * 0.01) or 0
  if attr ~= 0 then
    local str = ClientTable.cfg_Ui_word_attributeManager:TryGetValue("excellentDamageChance").equipeUI
    local excellentDamageChance = string.format(str, attr, "%")
    table.insert(tips.arrtibuteTable, string.GetColorText(excellentDamageChance, color))
  end
  attr = tblEquip.criticalDamageChance and math.floor(tblEquip.criticalDamageChance * 0.01) or 0
  if attr ~= 0 then
    local str = ClientTable.cfg_Ui_word_attributeManager:TryGetValue("criticalDamageChance").equipeUI
    local criticalDamageChance = string.format(str, attr, "%")
    table.insert(tips.arrtibuteTable, string.GetColorText(criticalDamageChance, color))
  end
  attr = tblEquip.doubleDamageChance and math.floor(tblEquip.doubleDamageChance * 0.01) or 0
  if attr ~= 0 then
    local str = ClientTable.cfg_Ui_word_attributeManager:TryGetValue("doubleDamageChance").equipeUI
    local doubleDamageChance = string.format(str, attr, "%")
    table.insert(tips.arrtibuteTable, string.GetColorText(doubleDamageChance, color))
  end
  attr = tblEquip.disable_damageBonus and math.floor(tblEquip.disable_damageBonus * 0.01) or 0
  if attr ~= 0 then
    local str = ClientTable.cfg_Ui_word_attributeManager:TryGetValue("damageBonus").equipeExcellenceUI
    local disable_damageBonus = string.format(str, attr, "%")
    table.insert(tips.arrtibuteTable, string.GetColorText(disable_damageBonus, color))
  end
end

function Tip_ItemTipTwoUI:DoAttributeEquip(tips, tblEquip)
  local color
  if tips.ItemInfo.tblItem.subType == 20 then
    color = ItemQuality2ColorDic[EItemColorEnum.green]
  else
    color = ItemQuality2ColorDic[EItemColorEnum.blue]
  end
  local random, itemtable
  if tips.ItemInfo.serverInfo ~= nil then
    if tips.ItemInfo.serverInfo.randomAttrs ~= nil then
      random = tips.ItemInfo:GetGenerateAttrRandom(tips.ItemInfo.serverInfo.randomAttrs)
      itemtable = tips.ItemInfo.serverInfo.randomAttrs
      self.SuitBol = true
    elseif tips.ItemInfo.serverInfo.serverInfo ~= nil then
      self.SuitBol = false
      if tips.ItemInfo.serverInfo.serverInfo.randomAttrs ~= nil then
        self.SuitBol = false
        random = tips.ItemInfo:GetGenerateAttrRandom(tips.ItemInfo.serverInfo.serverInfo.randomAttrs)
        itemtable = tips.ItemInfo.serverInfo.serverInfo.randomAttrs
      end
    end
  end
  if random then
    local randomtext = tips.ItemInfo:GetGenerateAttrRandomStr(itemtable)
    if randomtext ~= nil then
      tips.arrtibuteTable = randomtext
    end
  else
    local itemData = ViewData.meData
    local randomtext = tips.ItemInfo:GetGenerateAttrNilRandomStr(tips.ItemInfo, itemData)
    if randomtext ~= nil then
      tips.arrtibuteTable = randomtext
    end
  end
  if tblEquip.maximumPhysBaseDmg and tblEquip.maximumPhysBaseDmg ~= 0 then
    local physAttackStr = ""
    if tips.ItemInfo.tblItem.subType <= EItemSubtype.Katar then
      physAttackStr = string.format(self.gongjili, ItemUtility.TwoHandedArmsJudge(tips.ItemInfo.tblItem.subType) and self.shaungshou or self.danshou, tblEquip.minimumPhysBaseDmg, tblEquip.maximumPhysBaseDmg)
    else
      physAttackStr = string.format(self.gongjili, "V\225\186\173t l\195\189", tblEquip.minimumPhysBaseDmg, tblEquip.maximumPhysBaseDmg)
    end
    table.insert(tips.arrtibuteTable, physAttackStr)
  end
  if tblEquip.maximumWizBaseDmg and tblEquip.maximumWizBaseDmg ~= 0 then
    local magicAttackStr = string.format(self.mofagongjilizengjia, tblEquip.minimumWizBaseDmg, tblEquip.maximumWizBaseDmg)
    table.insert(tips.arrtibuteTable, magicAttackStr)
  end
  if tblEquip.maximumCurseBaseDmg and tblEquip.maximumCurseBaseDmg ~= 0 then
    local CurseAttackStr = string.format(self.zuzhougongjilizengjia, tblEquip.minimumCurseBaseDmg, tblEquip.maximumCurseBaseDmg)
    table.insert(tips.arrtibuteTable, CurseAttackStr)
  end
  if tblEquip.disable_maximumPhysBaseDmg and tblEquip.disable_maximumPhysBaseDmg ~= 0 then
    local physAttackStr = ""
    if tips.ItemInfo.tblItem.subType <= EItemSubtype.Katar then
      physAttackStr = string.format(self.gongjili, ItemUtility.TwoHandedArmsJudge(tips.ItemInfo.tblItem.subType) and self.shaungshou or self.danshou, tblEquip.disable_minimumPhysBaseDmg, tblEquip.disable_maximumPhysBaseDmg)
    else
      physAttackStr = string.format(self.gongjili, "V\225\186\173t l\195\189", tblEquip.disable_minimumPhysBaseDmg, tblEquip.disable_maximumPhysBaseDmg)
    end
    table.insert(tips.arrtibuteTable, physAttackStr)
  end
  if tblEquip.disable_maximumWizBaseDmg and tblEquip.disable_maximumWizBaseDmg ~= 0 then
    local magicAttackStr = string.format(self.mofagongjilizengjia, tblEquip.disable_minimumWizBaseDmg, tblEquip.disable_maximumWizBaseDmg)
    table.insert(tips.arrtibuteTable, magicAttackStr)
  end
  if tblEquip.disable_maximumCurseBaseDmg and tblEquip.disable_maximumCurseBaseDmg ~= 0 then
    local curseAttackStr = string.format(self.zuzhougongjilizengjia, tblEquip.disable_minimumCurseBaseDmg, tblEquip.disable_maximumCurseBaseDmg)
    table.insert(tips.arrtibuteTable, curseAttackStr)
  end
  if tblEquip.moveSpeed_mul and tblEquip.moveSpeed_mul ~= 0 then
    local num = tonumber(tblEquip.moveSpeed_mul) * 0.01
    local moveSpeed_mul = "T\196\131ng t\225\187\145c \196\145\225\187\153 di chuy\225\187\131n khi c\198\176\225\187\161i:" .. math.floor(num) .. "%"
    table.insert(tips.arrtibuteTable, moveSpeed_mul)
  end
  if tblEquip.resistDamageReflection and tblEquip.resistDamageReflection ~= 0 then
    local attr = tblEquip.resistDamageReflection
    if type(attr) == "number" then
      local resistDamageReflectionStr = string.format(self.shanghaifanshedikang, attr * 0.01, "%")
      table.insert(tips.arrtibuteTable, resistDamageReflectionStr)
    end
  end
  if tblEquip.monsterDropRate and tblEquip.monsterDropRate ~= 0 then
    local num = tonumber(tblEquip.monsterDropRate) * 0.01
    local monsterDrop_mul = string.format(ClientTable.cfg_Ui_word_attributeManager:GetKeyWord("monsterDropRate", "equipeTipsUI"), num)
    table.insert(tips.arrtibuteTable, monsterDrop_mul)
  end
  if tblEquip.defenseBase and tblEquip.defenseBase ~= 0 then
    local defenseBase = string.format(self.fangyuli, tblEquip.defenseBase)
    table.insert(tips.arrtibuteTable, defenseBase)
  end
  local attr = 0
  if tblEquip.defenseRatePvm then
    local attr = tblEquip.defenseRatePvm
    if attr ~= 0 then
      local defenseRatePvm = string.format(self.fangyulv, attr)
      table.insert(tips.arrtibuteTable, defenseRatePvm)
    end
  end
  attr = tblEquip.oneHandedWeaponIncRate and math.floor(tblEquip.oneHandedWeaponIncRate * 0.01) or 0
  if attr ~= 0 and 0 < attr then
    local attackSpeedmul = string.format(self.gongjisudubaifenbi, attr + 10, "%")
    table.insert(tips.arrtibuteTable, attackSpeedmul)
  end
  attr = tblEquip.twoHandedWeaponDamageIncrease and math.floor(tblEquip.twoHandedWeaponDamageIncrease * 0.01) or 0
  if attr ~= 0 then
    local damageIncrease = string.format(self.shanghaizengjia, attr, "%")
    table.insert(tips.arrtibuteTable, damageIncrease)
  end
  attr = tblEquip.attackDamageIncrease and math.floor(tblEquip.attackDamageIncrease * 0.01) or 0
  if attr ~= 0 then
    local attackDamageIncrease = string.format(self.shanghaitisheng, attr, "%")
    table.insert(tips.arrtibuteTable, attackDamageIncrease)
  end
  attr = tblEquip.damageReceiveDecrement and math.floor(tblEquip.damageReceiveDecrement * 0.01) or 0
  if attr ~= 0 then
    local damageReceiveDecrement = string.format(self.shanghaixuejian, attr, "%")
    table.insert(tips.arrtibuteTable, damageReceiveDecrement)
  end
  attr = tips.ItemInfo:GetGenerateAttr(EAttributeType.damageBonus)
  if not attr then
    attr = tblEquip.damageBonus
    if type(attr) == "number" then
      attr = attr and attr * 0.01 or 0
    end
  elseif type(attr) == "number" then
    attr = attr and attr * 0.01 or 0
  end
  if attr ~= 0 then
    local damageBonus = ""
    if type(attr) == "number" then
      damageBonus = string.format(self.shanghaijiacheng, attr, "%")
    else
      damageBonus = string.format("T\196\131ng s\195\161t th\198\176\198\161ng %s", attr)
    end
    damageBonus = string.GetColorText(damageBonus, color)
    table.insert(tips.arrtibuteTable, damageBonus)
  end
  local ser_attr = tips.ItemInfo:GetGenerateAttr(EAttributeType.damageAbsorption)
  attr = ser_attr
  if not attr then
    attr = tips.ItemInfo.tblEquip.display_damageAbsorption
    if type(attr) == "number" then
      attr = attr and attr * 0.01 or 0
    end
  elseif type(attr) == "number" then
    attr = attr and attr * 0.01 or 0
  end
  if attr ~= 0 then
    local damageAbsorption = ""
    local clientShow = ""
    if ser_attr then
      clientShow = ItemUtility:SwitchClientShowAttr(attr, EAttributeType.damageAbsorption)
    else
      clientShow = attr
    end
    if type(attr) == "number" then
      damageAbsorption = string.format(self.shanghaixushou, clientShow, "%")
    else
      damageAbsorption = string.format("H\195\186t s\195\161t th\198\176\198\161ng %s", clientShow)
    end
    damageAbsorption = string.GetColorText(damageAbsorption, color)
    table.insert(tips.arrtibuteTable, damageAbsorption)
  end
  if tblEquip.maximumHealth and tblEquip.maximumHealth ~= 0 then
    local maximumHealth = string.format(self.shengmingzuidazhizengjia, tblEquip.maximumHealth)
    table.insert(tips.arrtibuteTable, maximumHealth)
  end
  if tblEquip.disable_maximumHealth and tblEquip.disable_maximumHealth ~= 0 then
    local maximumHealth = string.format(self.shengmingzuidazhizengjia, tblEquip.disable_maximumHealth)
    table.insert(tips.arrtibuteTable, maximumHealth)
  end
  if tblEquip.career_maximumHealth and not string.isNullOrEmpty(tblEquip.career_maximumHealth) then
    local career_maximumHealth = string.format(self.shengmingzuidazhizengjia, RoleEquipUtility.GetCareerHP(tblEquip.career_maximumHealth, self.career))
    table.insert(tips.arrtibuteTable, career_maximumHealth)
  end
  attr = tblEquip.iceResistance and math.floor(tblEquip.iceResistance * 0.01) or 0
  if attr ~= 0 then
    local iceResistance = string.format(self.bingdikangli, attr, "%")
    table.insert(tips.arrtibuteTable, iceResistance)
  end
  attr = tblEquip.fireResistance and math.floor(tblEquip.fireResistance * 0.01) or 0
  if attr ~= 0 then
    local fireResistance = string.format(self.huodikangli, attr, "%")
    table.insert(tips.arrtibuteTable, fireResistance)
  end
  attr = tblEquip.waterResistance and math.floor(tblEquip.waterResistance * 0.01) or 0
  if attr ~= 0 then
    local waterResistance = string.format(self.shuidikangli, attr, "%")
    table.insert(tips.arrtibuteTable, waterResistance)
  end
  attr = tblEquip.earthResistance and math.floor(tblEquip.earthResistance * 0.01) or 0
  if attr ~= 0 then
    local earthResistance = string.format(self.didikangli, attr, "%")
    table.insert(tips.arrtibuteTable, earthResistance)
  end
  attr = tblEquip.windResistance and math.floor(tblEquip.windResistance * 0.01) or 0
  if attr ~= 0 then
    local windResistance = string.format(self.fengdikangli, attr, "%")
    table.insert(tips.arrtibuteTable, windResistance)
  end
  attr = tblEquip.poisonResistance and math.floor(tblEquip.poisonResistance * 0.01) or 0
  if attr ~= 0 then
    local poisonResistance = string.format(self.dudikangli, attr, "%")
    table.insert(tips.arrtibuteTable, poisonResistance)
  end
  attr = tblEquip.lightningResistance and math.floor(tblEquip.lightningResistance * 0.01) or 0
  if attr ~= 0 then
    local lightningResistance = string.format(self.leidikangli, attr, "%")
    table.insert(tips.arrtibuteTable, lightningResistance)
  end
  attr = tblEquip.defenseIgnoreChanceResistance and math.floor(tblEquip.defenseIgnoreChanceResistance * 0.01) or 0
  if attr ~= 0 then
    local defenseIgnoreChanceResistance = string.format(self.tipsdikangwushifangyujilv, attr, "%")
    table.insert(tips.arrtibuteTable, defenseIgnoreChanceResistance)
  end
  attr = tblEquip.shieldBypassChanceResistance and math.floor(tblEquip.shieldBypassChanceResistance * 0.01) or 0
  if attr ~= 0 then
    local shieldBypassChanceResistance = string.format(self.tipsdikangSDwushijilv, attr, "%")
    table.insert(tips.arrtibuteTable, shieldBypassChanceResistance)
  end
  attr = tblEquip.doubleDamageChanceResistance and math.floor(tblEquip.doubleDamageChanceResistance * 0.01) or 0
  if attr ~= 0 then
    local doubleDamageChanceResistance = string.format(self.tipsdikangshuangbeishanghaijilv, attr, "%")
    table.insert(tips.arrtibuteTable, doubleDamageChanceResistance)
  end
  attr = tblEquip.excellentDamageChanceResistance and math.floor(tblEquip.excellentDamageChanceResistance * 0.01) or 0
  if attr ~= 0 then
    local excellentDamageChanceResistance = string.format(self.tipsdikangzhuoyueyijijilv, attr, "%")
    table.insert(tips.arrtibuteTable, excellentDamageChanceResistance)
  end
  attr = tblEquip.criticalDamageBonusResistance and math.floor(tblEquip.criticalDamageBonusResistance * 0.01) or 0
  if attr ~= 0 then
    local criticalDamageBonusResistance = string.format(self.tipsdikangzhimingyijijilv, attr, "%")
    table.insert(tips.arrtibuteTable, criticalDamageBonusResistance)
  end
  if tblEquip.attackDistanceIncrease and tblEquip.attackDistanceIncrease ~= 0 then
    local attackDistanceIncrease = string.format(self.tipsgongjijulizengjia, tblEquip.attackDistanceIncrease)
    table.insert(tips.arrtibuteTable, attackDistanceIncrease)
  end
  attr = tblEquip.excellentDamageBonus and math.floor(tblEquip.excellentDamageBonus * 0.01) or 0
  if attr ~= 0 then
    local excellentDamageBonus = string.format(self.tipszhimingyijishanghai, attr, "%")
    table.insert(tips.arrtibuteTable, excellentDamageBonus)
  end
  attr = tblEquip.defenseIgnoreChance and math.floor(tblEquip.defenseIgnoreChance * 0.01) or 0
  if attr ~= 0 then
    local tipswushifangyujilv = string.format(self.tipswushifangyujilv, attr, "%")
    table.insert(tips.arrtibuteTable, tipswushifangyujilv)
  end
  attr = tblEquip.PvpPhysicalDamageIncreased and MathUtility.FormatNum(tblEquip.PvpPhysicalDamageIncreased * 0.01) or 0
  if attr ~= 0 then
    local word = AttributeWordUtil.GetUIWord("PvpPhysicalDamageIncreased", "equipeUI")
    local PvpPhysicalDamageIncreased = string.format(word, tostring(attr), "%")
    table.insert(tips.arrtibuteTable, PvpPhysicalDamageIncreased)
  end
  attr = tblEquip.PvpMagicDamageIncreased and MathUtility.FormatNum(tblEquip.PvpMagicDamageIncreased * 0.01) or 0
  if attr ~= 0 then
    local word = AttributeWordUtil.GetUIWord("PvpMagicDamageIncreased", "equipeUI")
    local PvpMagicDamageIncreased = string.format(word, tostring(attr), "%")
    table.insert(tips.arrtibuteTable, PvpMagicDamageIncreased)
  end
  attr = tblEquip.pvpSufferPhysDmgReduced and MathUtility.FormatNum(tblEquip.pvpSufferPhysDmgReduced * 0.01) or 0
  if attr ~= 0 then
    local word = AttributeWordUtil.GetUIWord("pvpSufferPhysDmgReduced", "equipeUI")
    local pvpSufferPhysDmgReduced = string.format(word, tostring(attr), "%")
    table.insert(tips.arrtibuteTable, pvpSufferPhysDmgReduced)
  end
  attr = tblEquip.pvpSufferWizDmgReduced and MathUtility.FormatNum(tblEquip.pvpSufferWizDmgReduced * 0.01) or 0
  if attr ~= 0 then
    local word = AttributeWordUtil.GetUIWord("pvpSufferWizDmgReduced", "equipeUI")
    local pvpSufferWizDmgReduced = string.format(word, tostring(attr), "%")
    table.insert(tips.arrtibuteTable, pvpSufferWizDmgReduced)
  end
  attr = tblEquip.PvpPhyDmgReduced and MathUtility.FormatNum(tblEquip.PvpPhyDmgReduced * 0.01) or 0
  if attr ~= 0 then
    local word = AttributeWordUtil.GetUIWord("PvpPhyDmgReduced", "equipeUI")
    local PvpPhyDmgReduced = string.format(word, tostring(attr), "%")
    table.insert(tips.arrtibuteTable, PvpPhyDmgReduced)
  end
  attr = tblEquip.PvpWizDmgReduced and MathUtility.FormatNum(tblEquip.PvpWizDmgReduced * 0.01) or 0
  if attr ~= 0 then
    local word = AttributeWordUtil.GetUIWord("PvpWizDmgReduced", "equipeUI")
    local PvpWizDmgReduced = string.format(word, tostring(attr), "%")
    table.insert(tips.arrtibuteTable, PvpWizDmgReduced)
  end
  attr = tblEquip.PvpPhyDmgIncreased and MathUtility.FormatNum(tblEquip.PvpPhyDmgIncreased * 0.01) or 0
  if attr ~= 0 then
    local word = AttributeWordUtil.GetUIWord("PvpPhyDmgIncreased", "equipeUI")
    local PvpPhyDmgIncreased = string.format(word, tostring(attr), "%")
    table.insert(tips.arrtibuteTable, PvpPhyDmgIncreased)
  end
  attr = tblEquip.PvpWizDmgIncreased and MathUtility.FormatNum(tblEquip.PvpWizDmgIncreased * 0.01) or 0
  if attr ~= 0 then
    local word = AttributeWordUtil.GetUIWord("PvpWizDmgIncreased", "equipeUI")
    local PvpWizDmgIncreased = string.format(word, tostring(attr), "%")
    table.insert(tips.arrtibuteTable, PvpWizDmgIncreased)
  end
end

local Item_equip_growUpAttr = {}

function Tip_ItemTipTwoUI:EquipBasicAttributeStr1(tips)
  Item_equip_growUpAttr = {}
  local color
  if tips.ItemInfo.tblItem.subType == 20 then
    color = ItemQuality2ColorDic[EItemColorEnum.green]
  else
    color = ItemQuality2ColorDic[EItemColorEnum.orange]
  end
  local tblEquip = AttributeConfig.GetTableAttributes(tips.ItemInfo.tblEquip)
  local intensifyTbl = MeEquipController.GetEquipIntensifyCfgByEquipData(tips.ItemInfo)
  local GrowUpTbl
  local cellIndex = tonumber(string.split(tips.ItemInfo.tblEquip.equipPosition, "#")[1])
  if RoleEquipUtility.EquipTypeUtility(cellIndex, ERoleEquipCondition.Normal) and (tips.ItemInfo.tblItem.subType == EItemSubtype.Ring or tips.ItemInfo.tblItem.subType == EItemSubtype.Earrings or tips.ItemInfo.tblItem.subType == EItemSubtype.Necklace) then
    GrowUpTbl = MeEquipController.GetEquipGrowUpCfg(tips.ItemInfo.tblItem.subType, tips.ItemInfo.level)
  end
  if tips.ItemInfo.tblItem.subType == EItemSubtype.Mount or tips.ItemInfo.tblItem.fashion == 2 or tips.ItemInfo.subType == 50 or tips.ItemInfo.subType == 501 then
    tblEquip = MountAttributeCalculator.CalcSingleMountAttribute(tips.ItemInfo)
    if tips.ItemInfo.tblEquip.moveSpeed_mul and tips.ItemInfo.tblEquip.moveSpeed_mul ~= 0 then
      tblEquip.moveSpeed_mul = tips.ItemInfo.tblEquip.moveSpeed_mul
    end
  elseif tips.ItemInfo.subType == 502 then
    tblEquip = AttributeConfig.GetNamingAttributes(tips.ItemInfo.tblEquip)
  elseif tips.ItemInfo.tblItem.subType ~= EItemSubtype.Guards then
    tblEquip = AttributeConfig.MergeAttributeMap(tblEquip, AttributeConfig.GetTableAttributes(GrowUpTbl, Item_equip_growUpAttr))
  end
  if ItemUtility.IsJewelry(tips.ItemInfo) then
    self:JewelryUpgrade(tips)
  else
    self:DoAttributeEquip(tips, tblEquip)
    if tips.ItemInfo.subType == 21 then
      self:DoPetAttributeEquip(tips, tips.ItemInfo.tblEquip)
    end
  end
  if tips.ItemInfo.intensify and 0 < tips.ItemInfo.intensify then
    intensifyTbl = intensifyTbl or MeEquipController.GetEquipIntensifyCfgByEquipData(tips.ItemInfo)
    if intensifyTbl then
      local phyDmgDes = TableParse:GetAttributeValueDes(intensifyTbl, {
        "career_minimumPhysBaseDmg",
        "career_maximumPhysBaseDmg"
      })
      if string.isNullOrEmpty(phyDmgDes) == false then
        phyDmgDes = string.format(self.qianghua2, phyDmgDes)
        phyDmgDes = string.GetColorText(phyDmgDes, ItemQuality2ColorDic[EItemColorEnum.orange])
        table.insert(tips.arrtibuteTable, phyDmgDes)
      end
      local magicDmgDes = TableParse:GetAttributeValueDes(intensifyTbl, {
        "career_minimumWizBaseDmg",
        "career_maximumWizBaseDmg"
      })
      if string.isNullOrEmpty(magicDmgDes) == false then
        magicDmgDes = string.format(self.qianghua1, magicDmgDes)
        magicDmgDes = string.GetColorText(magicDmgDes, ItemQuality2ColorDic[EItemColorEnum.orange])
        table.insert(tips.arrtibuteTable, magicDmgDes)
      end
      local curseDmgDes = TableParse:GetAttributeValueDes(intensifyTbl, {
        "career_minimumCurseBaseDmg",
        "career_maximumCurseBaseDmg"
      })
      if string.isNullOrEmpty(curseDmgDes) == false then
        curseDmgDes = string.format(self.qianghua8, curseDmgDes)
        curseDmgDes = string.GetColorText(curseDmgDes, ItemQuality2ColorDic[EItemColorEnum.orange])
        table.insert(tips.arrtibuteTable, curseDmgDes)
      end
      local defenseDes = TableParse:GetAttributeValueDes(intensifyTbl, {
        "career_defenseBase"
      })
      if string.isNullOrEmpty(defenseDes) == false then
        defenseDes = string.format(self.qianghua3, defenseDes)
        defenseDes = string.GetColorText(defenseDes, ItemQuality2ColorDic[EItemColorEnum.orange])
        table.insert(tips.arrtibuteTable, defenseDes)
      end
      local damageReceiveDecrementDes = TableParse:GetAttributeValueDes(intensifyTbl, {
        "career_damageReceiveDecrement"
      })
      if string.isNullOrEmpty(damageReceiveDecrementDes) == false then
        damageReceiveDecrementDes = string.format(self.qianghua6, damageReceiveDecrementDes)
        damageReceiveDecrementDes = string.GetColorText(damageReceiveDecrementDes, ItemQuality2ColorDic[EItemColorEnum.orange])
        table.insert(tips.arrtibuteTable, damageReceiveDecrementDes)
      end
      local hp = TableParse:GetAttributeValueDes(intensifyTbl, {
        "career_maximumHealth"
      })
      if string.isNullOrEmpty(hp) == false then
        hp = string.format(self.qianghua7, hp)
        hp = string.GetColorText(hp, ItemQuality2ColorDic[EItemColorEnum.orange])
        table.insert(tips.arrtibuteTable, hp)
      end
    end
  end
  local zhuiJia = tips.ItemInfo:GetAttributes(EEquipeAttributeProviderSystem.Addition)
  if zhuiJia ~= nil and table.count(zhuiJia) then
    local attr = zhuiJia.minimumPhysBaseDmg ~= nil and zhuiJia.minimumPhysBaseDmg or 0
    if attr ~= 0 then
      attr = attr .. "~" .. zhuiJia.maximumPhysBaseDmg
    else
      attr = type(zhuiJia.career_minimumPhysBaseDmg) == "table" and TableParse:GetCareerAttribute(zhuiJia.career_minimumPhysBaseDmg, self.career) or 0
      if attr ~= 0 then
        attr = attr .. "~" .. TableParse:GetCareerAttribute(zhuiJia.career_maximumPhysBaseDmg, self.career)
      end
    end
    if type(attr) == "string" then
      local str = "Buff T\225\186\165n C\195\180ng: " .. attr
      table.insert(tips.arrtibuteTable, string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.orange]))
    end
    local attr = zhuiJia.minimumWizBaseDmg ~= nil and zhuiJia.minimumWizBaseDmg or 0
    if attr ~= 0 then
      attr = attr .. "~" .. zhuiJia.maximumWizBaseDmg
    else
      attr = type(zhuiJia.career_minimumWizBaseDmg) == "table" and TableParse:GetCareerAttribute(zhuiJia.career_minimumWizBaseDmg, self.career) or 0
      if attr ~= 0 then
        attr = attr .. "~" .. TableParse:GetCareerAttribute(zhuiJia.career_maximumWizBaseDmg, self.career)
      end
    end
    if type(attr) == "string" then
      local str = "Buff T\225\186\165n C\195\180ng ph\195\169p: " .. attr
      table.insert(tips.arrtibuteTable, string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.orange]))
    end
    local attr = zhuiJia.minimumCurseBaseDmg ~= nil and zhuiJia.minimumCurseBaseDmg or 0
    if attr ~= 0 then
      attr = attr .. "~" .. zhuiJia.maximumCurseBaseDmg
    else
      attr = type(zhuiJia.career_minimumCurseBaseDmg) == "table" and TableParse:GetCareerAttribute(zhuiJia.career_minimumCurseBaseDmg, self.career) or 0
      if attr ~= 0 then
        attr = attr .. "~" .. TableParse:GetCareerAttribute(zhuiJia.career_maximumCurseBaseDmg, self.career)
      end
    end
    if type(attr) == "string" then
      local str = "C\198\176\225\187\157ng h\195\179a m\225\187\165c ch\225\187\141n T\225\186\165n C\195\180ng Nguy\225\187\129n R\225\187\167a: " .. attr
      table.insert(tips.arrtibuteTable, string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.orange]))
    end
    local attr = zhuiJia.defenseRatePvm ~= nil and zhuiJia.defenseRatePvm or 0
    if attr ~= 0 then
      local str = string.format(self.zhuijiafangyulv, attr)
      table.insert(tips.arrtibuteTable, string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.orange]))
    end
    local attr = zhuiJia.defenseBase ~= nil and zhuiJia.defenseBase or 0
    if attr == 0 then
      attr = type(zhuiJia.career_defenseBase) == "table" and TableParse:GetCareerAttribute(zhuiJia.career_defenseBase, self.career) or 0
    end
    if type(attr) == "number" and 0 < attr then
      local str = string.format(self.zhuijiafangyuli, attr)
      table.insert(tips.arrtibuteTable, string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.orange]))
    end
    local attr = zhuiJia.healthRecoveryMultiplier ~= nil and Mathf.Floor(zhuiJia.healthRecoveryMultiplier / 100) or 0
    if attr ~= 0 then
      local str = string.format(self.shengmingzidonghuifu, attr, "%")
      table.insert(tips.arrtibuteTable, string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.orange]))
    end
  end
  if GrowUpTbl ~= nil and GrowUpTbl.maximumHealth_mul ~= 0 then
    local num = GrowUpTbl.maximumHealth_mul
    num = num * 0.01
    if num ~= 0 and Mathf.Floor(num * 10) < num * 10 then
      num = num - num % 0.1
    end
    local tempStr = string.format(self.shengmingzuidazhizengjiabaifenbi, num, "%")
    table.insert(tips.arrtibuteTable, tempStr)
  end
  local tblEquip = tips.ItemInfo:GetEquipeShowAttribute()
  if tblEquip.minimumWizBaseDmg_mul ~= 0 and tblEquip.maximumWizBaseDmg_mul ~= 0 then
    local magicPowerStr = string.format(self.mofagongjili, tblEquip.minimumWizBaseDmg_mul / 100, "%")
    magicPowerStr = string.GetColorText(magicPowerStr, color)
    table.insert(tips.arrtibuteTable, magicPowerStr)
  end
  if tblEquip.petAttackDamageIncrease ~= 0 then
    local petAttackDamageIncrease = string.format(self.chongwugongjilitigao, tblEquip.petAttackDamageIncrease / 100, "%")
    petAttackDamageIncrease = string.GetColorText(petAttackDamageIncrease, color)
    table.insert(tips.arrtibuteTable, petAttackDamageIncrease)
  end
  if tips.ItemInfo.luckLevel ~= 0 then
    local luckTbl = MeEquipController.GetEquipLuckyCfg(tips.ItemInfo.tblEquip.id, tips.ItemInfo.luckLevel)
    local wordTab = ClientTable.cfg_Ui_word_attributeManager:TryGetValue("criticalDamageChance")
    if luckTbl ~= nil then
      local attr = luckTbl.criticalDamageChance * 0.01
      if attr ~= 0 then
        local str = string.format(wordTab.equipeUI, attr, "%")
        table.insert(tips.arrtibuteTable, string.GetColorText(str, color))
      end
    end
  end
  if tips.ItemInfo.luckIds ~= nil and #tips.ItemInfo.luckIds ~= 0 then
    for _, w in pairs(tips.ItemInfo.luckIds) do
      if w and 0 < w then
        local luckTbl = ClientTable.cfg_Item_equip_excellenceManager:TryGetValue(w)
        local excellenceAttrs = TableDataPool.Spawn(ETableDataPoolType.ItemEquipExcellenceCfg)
        AttributeConfig.GetTableAttributes(luckTbl, excellenceAttrs)
        for i, v in pairs(excellenceAttrs) do
          if (i == "criticalDamageChance" or i == "reinforcementSuccessRate") and 0 < v then
            local type = ExcellenceTbl[i]
            local wordTab = ClientTable.cfg_Ui_word_attributeManager:TryGetValue(i)
            local attry, str
            if type then
              attry = v
              str = string.format(wordTab.equipeUI, attry)
            else
              attry = math.floor(v * 0.01)
              str = string.format(wordTab.equipeUI, attry, "%")
            end
            table.insert(tips.arrtibuteTable, string.GetColorText(str, color))
          end
        end
        TableDataPool.Recycle(ETableDataPoolType.ItemEquipExcellenceCfg, excellenceAttrs)
      end
    end
  end
  if tips.ItemInfo ~= nil and tips.ItemInfo.tblEquip ~= nil and 0 < tips.ItemInfo.tblEquip.experienceRate then
    local attackMonsterExp = string.format(ClientTable.cfg_Ui_word_attributeManager:GetDes("experienceRate", UI_Word_AttributeType.equipeTipsUI), tips.ItemInfo.tblEquip.experienceRate / 100)
    table.insert(tips.arrtibuteTable, attackMonsterExp)
  end
  if tips.ItemInfo ~= nil and tips.ItemInfo.tblEquip ~= nil then
    local tbl_reductionMonsterAttackSpeed = tips.ItemInfo.tblEquip.reductionMonsterAttackSpeed
    if tbl_reductionMonsterAttackSpeed ~= nil and tonumber(tbl_reductionMonsterAttackSpeed) ~= nil then
      local reductionMonsterAttackSpeed = string.format(ClientTable.cfg_Ui_word_attributeManager:GetDes("reductionMonsterAttackSpeed", UI_Word_AttributeType.equipeTipsUI), tonumber(tbl_reductionMonsterAttackSpeed) / 100)
      if tips.ItemInfo.tblItem.subType == EItemSubtype.Guards then
        table.insert(tips.arrtibuteTable, string.GetColorText(reductionMonsterAttackSpeed, ItemQuality2ColorDic[EItemColorEnum.blue]))
      else
        table.insert(tips.arrtibuteTable, reductionMonsterAttackSpeed)
      end
    end
  end
  if tips.ItemInfo ~= nil and tips.ItemInfo.excellentInfoTbl ~= nil and next(tips.ItemInfo.excellentInfoTbl) ~= nil then
    local equipOverlapAttribute = ClientTable.cfg_Item_equip_redManager:GetEquipOverlapBaseAttribute(tips.ItemInfo)
    if equipOverlapAttribute ~= nil and type(equipOverlapAttribute.attributeViewInfoList) == "table" then
      for k, v in pairs(equipOverlapAttribute.attributeViewInfoList) do
        local attributeDes = "X\225\186\191p ch\225\187\147ng" .. v.name .. "\239\188\154" .. tostring(v.curValue)
        attributeDes = string.GetColorText(attributeDes, ItemQuality2ColorDic[3])
        table.insert(tips.arrtibuteTable, attributeDes)
      end
    end
  end
  if ItemUtility.IsJewelry(tips.ItemInfo) then
    tips.centerHeight = tips.centerHeight + self.minSpaceLine
    self:CalculStrPosAndHeight(tips.arrtibuteTable, tips.lab_TipAttribute, tips)
  else
    self:CalculStrPosAndHeight(tips.arrtibuteTable, tips.lab_TipAttribute, tips, tips.lab_attribute)
  end
end

function Tip_ItemTipTwoUI:EquipSkill(tips)
  tips.lab_Skill:SetText(tips.ItemInfo.tblItem.subType == EItemSubtype.Mount and "K\195\173ch ho\225\186\161t K\225\187\185 N\196\131ng" or "K\225\187\185 n\196\131ng v\197\169 kh\195\173")
  local skillId = tips.ItemInfo.tblEquip.carryingSkills
  if skillId ~= 0 then
    local skillTbl = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
    if skillTbl then
      local curNum = math.floor(skillTbl.costMPPercentage / 10000 * QuickFind.LuaMainPlayerViewAttrData().maxMp) + skillTbl.costMP
      local str = string.format(self.wuqijinengshuoming, skillTbl.name, skillTbl.level, tostring(curNum))
      table.insert(tips.skillTable, string.GetColorText(str, ItemQuality2ColorDic[0]))
    end
  end
  self:CalculStrPosAndHeight(tips.skillTable, tips.lab_TipSkill, tips, tips.lab_Skill)
end

function Tip_ItemTipTwoUI:IsShieldSuitExcellence(tips)
  if tips.ItemInfo.tblEquip then
    local bagIndex = string.split(tips.ItemInfo.tblEquip.equipPosition, "#")[1]
    if bagIndex and ClientTable.cfg_Item_equip_bingjianManager:ExcellenceShowTypeJudge(tonumber(bagIndex), BingJianExcellenceShowType.NotShow) then
      return true
    end
  end
  return false
end

function Tip_ItemTipTwoUI:GetExcellenceTbl(itemInfo)
  if itemInfo == nil then
    return
  end
  local equip = ConfigManager.GetConfig("cfg_Item_equip", itemInfo.itemId, "id")
  local bool = equip.excellentNumber ~= "" and true or false
  local sameId = {}
  if not itemInfo.excellence then
    return
  end
  local ExcellenceTab = {}
  local color
  local subType = itemInfo.tblItem.subType
  if (itemInfo.excellentInfoTbl == nil or next(itemInfo.excellentInfoTbl) == nil) and (bool == true or itemInfo.isSuit) and itemInfo.id == 0 or ClientTable.cfg_Item_equip_bingjianManager:IsShowSuitSpecialEAtrByItemInfo(itemInfo) then
    local s = ConfigManager.FindConfigs("cfg_Item_equip_excellence", "subType", subType)
    if s == nil or #s == 0 then
      return nil
    end
    local ids = {}
    if ClientTable.cfg_Item_equip_bingjianManager:IsShowSuitSpecialEAtrByItemInfo(itemInfo) then
      ids = TableParse:SplitStringToIntList(itemInfo.tblEquip.createFixedExcellent, "#")
    else
      for i, v in pairs(s) do
        table.insert(ids, v.id)
      end
      table.insert(ExcellenceTab, ClientTable.cfg_Ui_wordManager:GetUi_wordCount("zhuoyueshuxing"))
    end
    local sameId1 = {}
    for i, v in ipairs(ids) do
      for k, v1 in ipairs(ids) do
        if v == v1 and i ~= k then
          table.remove(ids, k)
          table.insert(sameId, v1)
        end
      end
    end
    local excellenceTab = RoleEquipUtility.GetEquipExcellence(ids, itemInfo.tblEquip)
    if 0 < #sameId1 then
      table.combine(excellenceTab, RoleEquipUtility.GetEquipExcellence(sameId1, itemInfo.tblEquip))
    end
    table.combine(ExcellenceTab, excellenceTab)
    color = ItemQuality2ColorDic[21]
  elseif itemInfo.tblItem.subType ~= 20 then
    color = ItemQuality2ColorDic[EItemColorEnum.blue]
    ExcellenceTab = itemInfo:GetEquipExcellenceDesList()
  end
  return ExcellenceTab, color
end

function Tip_ItemTipTwoUI:EquipExcellence(tips)
  if self:IsShieldSuitExcellence(tips) then
    return
  end
  if ItemUtility.IsJewelry(tips.ItemInfo) then
    local breachAllTable = MeEquipController.GetOrnamentsAllBreach(tips.ItemInfo.tblItem.subType)
    self.breachTable = MeEquipController.GetEquipBreachCfg(tips.ItemInfo.tblItem.subType, tips.ItemInfo.breach or 0)
    local mY = tips.go_Upgrade.transform.rect.height
    local spacing = tips.grid_jewelyUpgrade.transform:GetComponent("VerticalLayoutGroup").spacing
    tips.grid_jewelyUpgrade:SetActive(true)
    tips.upgradeContainer:SetData(breachAllTable)
    self:AddTitleHeight(tips.lab_excellent, tips)
    tips.grid_jewelyUpgrade:SetAnchoredPosition(0, -tips.centerHeight)
    tips.centerHeight = tips.centerHeight + (mY + spacing) * table.count(breachAllTable) + self.minSpaceLine
  elseif ClientTable.cfg_Item_equip_bingjianManager:IsShowSuitSpecialEAtrByItemInfo(tips.ItemInfo) then
    self:SuitExcellence(tips)
    self:CalculStrPosAndHeight(tips.excellentadditionalTable, tips.lab_TipExcellentAdditional, tips, tips.lab_excellent)
  else
    local ExcellenceTab, color = self:GetExcellenceTbl(tips.ItemInfo)
    if ExcellenceTab ~= nil then
      local lab_TipExcellentAdditional2 = UIControl(tips.lab_TipExcellentAdditional.transform, "lab_TipExcellentAdditional2")
      lab_TipExcellentAdditional2:SetActive(false)
      for i = 1, table.count(ExcellenceTab) do
        table.insert(tips.excellentadditionalTable, string.GetColorText(ExcellenceTab[i], color))
      end
    end
    self:CalculStrPosAndHeight(tips.excellentadditionalTable, tips.lab_TipExcellentAdditional, tips, tips.lab_excellent)
  end
end

function Tip_ItemTipTwoUI:SuitExcellence(tips)
  local idList = {}
  local idBindAttributeType = {}
  local subType = tips.ItemInfo.tblItem.subType
  local curCellType = tips.ItemInfo.tblEquip.cellType
  local findedItems = ConfigManager.FindConfigs("cfg_Item_equip_excellence", "subType", subType)
  if findedItems and 0 < #findedItems then
    for i, v in pairs(findedItems) do
      if v.cellType == nil or curCellType == v.cellType then
        table.insert(idList, v.id)
        idBindAttributeType[v.id] = v.attributeType
      end
    end
    local idListNoRepeat = {}
    for i, v in pairs(idList) do
      if not table.contains(idListNoRepeat, v) then
        table.insert(idListNoRepeat, v)
      end
    end
    local excellenceTab = RoleEquipUtility.GetEquipExcellence(idListNoRepeat, tips.ItemInfo.tblEquip)
    local ExcellenceTab = self:GetExcellenceTbl(tips.ItemInfo)
    local ExcellenceTabCount = table.count(ExcellenceTab)
    local excellenceTabCount = table.count(excellenceTab)
    if 0 <= ExcellenceTabCount and ExcellenceTabCount <= excellenceTabCount then
      local activeStrTable = {}
      for i = 1, table.count(excellenceTab) do
        if i <= ExcellenceTabCount then
          table.insert(activeStrTable, "")
          table.insert(tips.excellentadditionalTable, string.GetColorText(excellenceTab[i], ItemQuality2ColorDic[EItemColorEnum.blue]))
        else
          local k = idBindAttributeType[idListNoRepeat[i]]
          table.insert(activeStrTable, string.format(" + %d \196\145\198\176\225\187\163c k\195\173ch ho\225\186\161t ", tonumber(k)))
          table.insert(tips.excellentadditionalTable, string.GetColorText(excellenceTab[i], ItemQuality2ColorDic[EItemColorEnum.dark]))
        end
      end
      local activeStr = table.concat(activeStrTable, "\n")
      local lab_TipExcellentAdditional2 = UIControl(tips.lab_TipExcellentAdditional.transform, "lab_TipExcellentAdditional2")
      lab_TipExcellentAdditional2:SetActive(true)
      lab_TipExcellentAdditional2:SetText(string.GetColorText(activeStr, ItemQuality2ColorDic[EItemColorEnum.dark]))
    end
  end
end

function Tip_ItemTipTwoUI:WingAttribute(tips)
  local excellenceTab = {}
  local ExcellenceTab = {}
  local color
  local subType = tips.ItemInfo.tblItem.subType
  local attr = tips.ItemInfo:GetGenerateAttr(EAttributeType.damageBonus)
  if attr and type(attr) == "string" and subType == EItemSubtype.Wing then
    local ids = {}
    local s = ConfigManager.FindConfigs("cfg_Item_equip_excellence", "type", 3)
    if 0 < #s then
      for k, v in pairs(s) do
        table.insert(ids, v.id)
      end
      excellenceTab = RoleEquipUtility.GetEquipExcellence(ids, tips.ItemInfo.tblEquip)
      if UIManager.IsVisible(UIID.Item_CombinePreviewUI) then
        table.insert(ExcellenceTab, string.GetColorText("T\196\131ng ng\225\186\171u nhi\195\170n 0~2 d\195\178ng thu\225\187\153c t\195\173nh", ItemQuality2ColorDic[1]))
      else
        table.insert(ExcellenceTab, string.GetColorText("Khi gh\195\169p th\195\160nh C\195\161nh s\225\186\189 l\198\176u d\195\178ng c\225\187\167a C\195\161nh ban \196\145\225\186\167u", ItemQuality2ColorDic[1]))
      end
      color = ItemQuality2ColorDic[21]
    end
  else
    local fixedExcellent = ConfigManager.FindConfigs("cfg_Item_equip", "createFixedExcellent", tips.ItemInfo.itemId)
    if tips.ItemInfo.wingAttr ~= nil and subType == 20 and 0 >= #tips.ItemInfo.wingAttr and 0 < #fixedExcellent then
      local ids = {}
      local s = ConfigManager.FindConfigs("cfg_Item_equip_excellence", "subType", subType)
      if s ~= nil and 0 < #s then
        for i, v in pairs(s) do
          table.insert(ids, v.id)
        end
        excellenceTab = RoleEquipUtility.GetEquipExcellence(ids, tips.ItemInfo.tblEquip)
        table.insert(ExcellenceTab, string.GetColorText("#N/A", ItemQuality2ColorDic[1]))
        color = ItemQuality2ColorDic[21]
      end
    else
      excellenceTab = RoleEquipUtility.GetEquipExcellence(tips.ItemInfo.wingAttr, tips.ItemInfo.tblEquip)
      color = ItemQuality2ColorDic[EItemColorEnum.blue]
    end
  end
  table.combine(ExcellenceTab, excellenceTab)
  if ExcellenceTab ~= nil then
    for i = 1, table.count(ExcellenceTab) do
      table.insert(tips.excellentInheritTable, string.GetColorText(ExcellenceTab[i], color))
    end
  end
  self:CalculStrPosAndHeight(tips.excellentInheritTable, tips.lab_TipExcellentInherit, tips, tips.lab_excellentInherit)
end

local suitTblattributes = {
  "strength",
  "agility",
  "vitality",
  "energy",
  "leadership",
  "maximumMana",
  "maximumHealth",
  "defenseBase",
  "minimumPhysBaseDmg",
  "maximumPhysBaseDmg",
  "minimumWizBaseDmg",
  "maximumCurseBaseDmg",
  "minimumWizBaseDmg",
  "maximumWizBaseDmg",
  "minimumCurseBaseDmg",
  "maximumCurseBaseDmg",
  "excellentDamageChance",
  "criticalDamageChance",
  "doubleDamageChance",
  "attackSpeed",
  "maximumHealth_mul",
  "monsterAttackPlayerDamageAbsorption",
  "excellentDamageChanceResistance",
  "excellentDamageBonus",
  "reductionExcellentDamage",
  "additionAttackRate",
  "defenseRatePvm_mul",
  "defenseIgnoreChance",
  "damageReceiveDecrement",
  "resistDamageReceiveDecrement",
  "damageReflection",
  "resistDamageReflection",
  "maximumMana_mul",
  "healthAfterMonsterKillAbsolute",
  "manaAfterMonsterKillAbsolute",
  "moneyAmountRate",
  "attackWarriorDamageAddition",
  "resistAttackWarriorDamageAddition",
  "attackMagicianDamageAddition",
  "resistAttackMagicianDamageAddition",
  "attackArcherDamageAddition",
  "resistAttackArcherDamageAddition",
  "physAndWizDmgLevel",
  "maximumPhysAndWizDmg_mul",
  "ignoreDamageReflectionShow",
  "suitHealthIncreased",
  "suitBaseDmgIncreased"
}

function Tip_ItemTipTwoUI:GetSuitBySuitId(suitId)
  local suitInfoTbl = {}
  for _, v in pairs(self.args.equips) do
    if v.isSuit and string.contains(v.tblEquip.suitId, tostring(suitId)) then
      table.insert(suitInfoTbl, v)
    end
  end
  return suitInfoTbl
end

function Tip_ItemTipTwoUI:SuitInfoCfgSort(suitInfoCfg)
  if self.args.item and self.args.item.tblEquip and self.args.item.tblEquip.cellType and self.args.item.tblEquip.cellType == 18 then
    table.sort(suitInfoCfg, function(a, b)
      if a.id < b.id then
        return true
      end
      return false
    end)
  end
end

function Tip_ItemTipTwoUI:EquipSuitAttributeStr(tips)
  local minSuit
  local MinCount = 0
  local MinBol = true
  if tips.ItemInfo.isSuit and tips.ItemInfo.tblItem.type ~= EItemType.NewRune then
    local suitId = tips.ItemInfo.tblEquip.suitId
    local suitSpilt = string.split(suitId, "#")
    if table.count(suitSpilt) < 2 then
      return
    end
    local suit = MeEquipController.GetSuitCfg(tonumber(suitSpilt[1]), tonumber(suitSpilt[2]))
    local suitInfo = {}
    if self.args.equips then
      suitInfo = self:GetSuitBySuitId(tonumber(suitSpilt[1]))
    else
      if ViewData.meData.equipsData then
        suitInfo = ViewData.meData.equipsData:GetSuitBySuitId(tonumber(suitSpilt[1]))
      end
      if #suitInfo == 0 then
        suitInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitBySuitId(tonumber(suitSpilt[1]))
      end
    end
    local suitNum = 0
    local heightLevelSuitNum = 0
    if table.count(suit) >= 1 then
      local curSuitTbl = {}
      for _, v in ipairs(suitInfo) do
        local a = {}
        local ttSuitInfos = string.split(v.tblEquip.suitId, "#")
        a.suitId = ttSuitInfos[1]
        a.level = tonumber(ttSuitInfos[2])
        a.subType = v.tblItem.subType
        a.name = v.tblItem.name
        a.itemId = v.tblItem.id
        table.insert(curSuitTbl, a)
        if a.level >= tonumber(suitSpilt[2]) then
          suitNum = suitNum + 1
        end
        if a.level > tonumber(suitSpilt[2]) then
          heightLevelSuitNum = heightLevelSuitNum + 1
        end
      end
      if suitNum > suit[1].suitTotal then
        suitNum = suit[1].suitTotal
      end
      local suitTitle = string.GetColorText(string.format("B\225\187\153 %s (%d/%d)", suit[1].suitName, suitNum, suit[1].suitTotal), ItemQuality2ColorDic[EItemColorEnum.orange])
      table.insert(tips.suitadditionalTable, suitTitle)
      local aaa = MeEquipController.GetSuitInfoCfg(tonumber(suitSpilt[1]), tonumber(suitSpilt[2]))
      local suitInfoCfg = {}
      for _, v in pairs(aaa) do
        local common = false
        for i, v1 in pairs(suitInfoCfg) do
          if v1.name == v.name then
            common = true
          end
        end
        if not common then
          table.insert(suitInfoCfg, v)
          local equipedPositionList = string.split(v.equipPosition, "#")
          if 1 < #equipedPositionList then
            for k = 1, #equipedPositionList - 1 do
              local a = table.metatableCopy(nil, v)
              table.insert(suitInfoCfg, a)
            end
          end
        end
      end
      if tonumber(suitSpilt[1]) == 5701 then
        local roleCareer = RoleManager.me.data.career
        if roleCareer == nil then
          return
        end
        for _, v in pairs(suitInfoCfg) do
          local infoStr = v.name
          local isEquiped = false
          for i, selfSuitInfo in pairs(curSuitTbl) do
            local vInfos = string.split(v.suitId, "#")
            if selfSuitInfo.subType == v.subType and selfSuitInfo.suitId == vInfos[1] and selfSuitInfo.level >= tonumber(vInfos[2]) then
              local isMate = true
              if SpecialSuitSubtype[selfSuitInfo.subType] and selfSuitInfo.level == tonumber(vInfos[2]) and selfSuitInfo.subType ~= v.subType then
                isMate = false
              end
              if isMate and selfSuitInfo.name == infoStr then
                infoStr = selfSuitInfo.name
                table.remove(curSuitTbl, i)
                isEquiped = true
                break
              end
            end
          end
          local itemDate = ClientTable.cfg_Item_itemManager:TryGetValue(v.id)
          local careerArray = string.split(itemDate.career, "#")
          if not careerArray or careerArray[1] == "0" then
            local color = isEquiped and ItemQuality2ColorDic[EItemColorEnum.yellow] or ItemQuality2ColorDic[EItemColorEnum.dark]
            infoStr = string.GetColorText(infoStr, color)
            table.insert(tips.suitadditionalTable, infoStr)
          else
            local isInCareers = false
            local posArray = string.split(tips.ItemInfo.tblEquip.equipPosition, "#")
            local isWeapon = false
            for i = 1, #posArray do
              if posArray[i] == "3104" or posArray[i] == "3105" then
                isWeapon = true
                break
              end
            end
            for i = 1, #careerArray do
              if isWeapon then
                if RoleUtility.UpWardCompatibilty(tonumber(careerArray[i]), tonumber(tips.ItemInfo.tblItem.career)) then
                  isInCareers = true
                  break
                end
              elseif ConditionManager.Check("201#" .. careerArray[i], roleCareer) then
                isInCareers = true
                break
              end
            end
            if isInCareers then
              local color = isEquiped and ItemQuality2ColorDic[EItemColorEnum.yellow] or ItemQuality2ColorDic[EItemColorEnum.dark]
              infoStr = string.GetColorText(infoStr, color)
              table.insert(tips.suitadditionalTable, infoStr)
            end
          end
        end
      else
        for _, v in pairs(suitInfoCfg) do
          local infoStr = v.name
          local isEquiped = false
          for i, selfSuitInfo in pairs(curSuitTbl) do
            local vInfos = string.split(v.suitId, "#")
            if (selfSuitInfo.subType == v.subType or selfSuitInfo.subType == 9 or selfSuitInfo.subType == 10 or selfSuitInfo.subType == 24 or selfSuitInfo.subType == 25) and selfSuitInfo.suitId == vInfos[1] and selfSuitInfo.level >= tonumber(vInfos[2]) then
              local isMate = true
              if SpecialSuitSubtype[selfSuitInfo.subType] and selfSuitInfo.level == tonumber(vInfos[2]) and selfSuitInfo.subType ~= v.subType then
                isMate = false
              end
              if isMate and v.cellType == 18 and v.route == "Ring" then
                infoStr = v.name
                table.remove(curSuitTbl, i)
                isEquiped = true
                break
              elseif isMate and selfSuitInfo.name == infoStr then
                infoStr = selfSuitInfo.name
                table.remove(curSuitTbl, i)
                isEquiped = true
                break
              end
            end
          end
          local color = isEquiped and ItemQuality2ColorDic[EItemColorEnum.yellow] or ItemQuality2ColorDic[EItemColorEnum.dark]
          infoStr = string.GetColorText(infoStr, color)
          table.insert(tips.suitadditionalTable, infoStr)
        end
      end
      local minSuitNum = 999
      for _, v in ipairs(suitInfo) do
        local ttSuitInfos = string.split(v.tblEquip.suitId, "#")
        if minSuitNum >= tonumber(ttSuitInfos[2]) then
          minSuitNum = tonumber(ttSuitInfos[2])
          minSuit = ttSuitInfos
        end
        MinCount = MinCount + 1
      end
      if minSuit and minSuit[2] == suitSpilt[2] then
        MinBol = false
      end
    end
    local suitTitle = string.GetColorText("Hi\225\187\135u qu\225\186\163 B\225\187\153", ItemQuality2ColorDic[EItemColorEnum.orange])
    local isInsert = false
    tips.viceSuitadditionalTable = {}
    for _, v in pairs(suit) do
      local color
      local strformat = string.format("B\225\187\153 %d m\195\179n", v.actNum)
      local s = string.format("B\225\187\153 %d m\195\179n", v.actNum)
      local first = true
      local isBannerBugleSuit = false
      isBannerBugleSuit = v.suitmark == 1
      if not isBannerBugleSuit then
        color = suitNum >= v.actNum and ItemQuality2ColorDic[EItemColorEnum.yellow] or ItemQuality2ColorDic[EItemColorEnum.dark]
        for _, vv in pairs(suitTblattributes) do
          local word = AttributeWordUtil.GetUIWord(tostring(vv), "equipeUI")
          if v[vv] ~= 0 and v[vv] ~= nil then
            if not isInsert then
              table.insert(tips.suitadditionalTable, suitTitle)
            end
            isInsert = true
            if not first then
              strformat = strformat .. "\n"
            end
            local attr
            local attrStr = ""
            if string.contains(word, "s") then
              attr = MathUtility.FormatNum(v[vv] * 0.01)
              attrStr = string.format(word, attr, "%")
            else
              attrStr = string.format(word, v[vv])
            end
            if first then
              first = false
              strformat = strformat .. "\t\t" .. attrStr
            else
              strformat = strformat .. "\t\t\t\t\t" .. attrStr
            end
          end
        end
        if strformat ~= s then
          strformat = string.GetColorText(strformat, color)
          table.insert(tips.suitadditionalTable, strformat)
        end
      else
        local suitsTemp = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetEquipDataListByEquipIndexList({16, 17})
        local curSuitTbl = {}
        if suitsTemp[1] ~= nil and suitsTemp[2] ~= nil then
          local bannerStr = string.split(suitsTemp[1]:GetEquipTbl().suitId, "#")
          local bugleStr = string.split(suitsTemp[2]:GetEquipTbl().suitId, "#")
          local lowLevel = tonumber(bannerStr[2]) <= tonumber(bugleStr[2]) and bannerStr[2] or bugleStr[2]
          curSuitTbl = MeEquipController.GetSuitCfg(270001, tonumber(lowLevel))[1]
          color = tonumber(v.level) >= tonumber(lowLevel) and ItemQuality2ColorDic[EItemColorEnum.yellow] or ItemQuality2ColorDic[EItemColorEnum.dark]
        else
          color = ItemQuality2ColorDic[EItemColorEnum.dark]
        end
        if self.args.contrast and not self.showContrastTips then
          if tips.ItemInfo.tblEquip.equipPosition == "16" and suitsTemp[2] ~= nil then
            local bannerStr = string.split(tips.ItemInfo.tblEquip.suitId, "#")
            local bugleStr = string.split(suitsTemp[2]:GetEquipTbl().suitId, "#")
            local lowLevel = tonumber(bannerStr[2]) <= tonumber(bugleStr[2]) and bannerStr[2] or bugleStr[2]
            curSuitTbl = MeEquipController.GetSuitCfg(270001, tonumber(lowLevel))[1]
            color = tonumber(v.level) >= tonumber(lowLevel) and ItemQuality2ColorDic[EItemColorEnum.yellow] or ItemQuality2ColorDic[EItemColorEnum.dark]
          else
            color = ItemQuality2ColorDic[EItemColorEnum.dark]
          end
          if tips.ItemInfo.tblEquip.equipPosition == "17" and suitsTemp[1] ~= nil then
            local bannerStr = string.split(suitsTemp[1]:GetEquipTbl().suitId, "#")
            local bugleStr = string.split(tips.ItemInfo.tblEquip.suitId, "#")
            local lowLevel = tonumber(bannerStr[2]) <= tonumber(bugleStr[2]) and bannerStr[2] or bugleStr[2]
            curSuitTbl = MeEquipController.GetSuitCfg(270001, tonumber(lowLevel))[1]
            color = tonumber(v.level) >= tonumber(lowLevel) and ItemQuality2ColorDic[EItemColorEnum.yellow] or ItemQuality2ColorDic[EItemColorEnum.dark]
          else
            color = ItemQuality2ColorDic[EItemColorEnum.dark]
          end
        end
        local viceStrformat = ""
        for k, vv in pairs(self.suitTblattributesForBannerBugleSuit) do
          local word = AttributeWordUtil.GetUIWord(tostring(vv), "equipeUI")
          if not isInsert then
            table.insert(tips.suitadditionalTable, suitTitle)
            table.insert(tips.viceSuitadditionalTable, "")
          end
          isInsert = true
          if not first then
            strformat = strformat .. "\n"
            viceStrformat = viceStrformat .. "\n"
          end
          local attr
          local attrStr = ""
          local viceAttrStr = ""
          if string.contains(word, "s") then
            attr = math.floor((self.bannerBugleSuitforAdd15Tbl[1][vv] or 0) * 0.01)
            attrStr = string.format(word, attr, "%")
          else
            attrStr = string.format(word, self.bannerBugleSuitforAdd15Tbl[1][vv] or "")
          end
          local singleColor = ItemQuality2ColorDic[EItemColorEnum.dark]
          if self.args.contrast then
            if self.showContrastTips then
              if color == ItemQuality2ColorDic[EItemColorEnum.yellow] and curSuitTbl[vv] ~= nil and curSuitTbl[vv] ~= 0 then
                singleColor = ItemQuality2ColorDic[EItemColorEnum.green]
                viceAttrStr = " "
              end
              if singleColor == ItemQuality2ColorDic[EItemColorEnum.dark] then
                viceAttrStr = k .. "C\225\186\165p k\195\173ch ho\225\186\161t "
                viceAttrStr = string.GetColorText(viceAttrStr, singleColor)
              end
              attrStr = string.GetColorText(attrStr, singleColor)
            else
              if curSuitTbl[vv] ~= nil and curSuitTbl[vv] ~= 0 then
                singleColor = ItemQuality2ColorDic[EItemColorEnum.green]
                viceAttrStr = " "
              end
              if singleColor == ItemQuality2ColorDic[EItemColorEnum.dark] then
                viceAttrStr = k .. "C\225\186\165p k\195\173ch ho\225\186\161t "
                viceAttrStr = string.GetColorText(viceAttrStr, singleColor)
              end
              attrStr = string.GetColorText(attrStr, ItemQuality2ColorDic[EItemColorEnum.dark])
            end
          else
            if color == ItemQuality2ColorDic[EItemColorEnum.yellow] and curSuitTbl[vv] ~= nil and curSuitTbl[vv] ~= 0 then
              singleColor = ItemQuality2ColorDic[EItemColorEnum.green]
              viceAttrStr = " "
            end
            if singleColor == ItemQuality2ColorDic[EItemColorEnum.dark] then
              viceAttrStr = k .. "C\225\186\165p k\195\173ch ho\225\186\161t "
              viceAttrStr = string.GetColorText(viceAttrStr, singleColor)
            end
            attrStr = string.GetColorText(attrStr, singleColor)
          end
          if first then
            first = false
            strformat = attrStr
            viceStrformat = viceAttrStr
          else
            strformat = strformat .. attrStr
            viceStrformat = viceStrformat .. viceAttrStr
          end
        end
        if strformat ~= s then
          table.insert(tips.suitadditionalTable, strformat)
          tips.viceSuitadditionalTable[#tips.suitadditionalTable] = viceStrformat
        end
      end
    end
    local suitSkillTitle = string.GetColorText("K\225\187\185 n\196\131ng B\225\187\153 Trang B\225\187\139", ItemQuality2ColorDic[EItemColorEnum.orange])
    local first = true
    for _, v in pairs(suit) do
      local color, skillId
      color = suitNum >= v.actNum and ItemQuality2ColorDic[EItemColorEnum.yellow] or ItemQuality2ColorDic[EItemColorEnum.dark]
      local strformat = string.format("B\225\187\153 %d m\195\179n", v.actNum)
      local suitInfo = ConfigManager.FindConfigs("cfg_Item_equip_suit", "id", v.id)
      local hideSkill = suitInfo[1] and suitInfo[1].hideSkill or nil
      if not string.isNullOrEmpty(suitInfo[1].careerSkills) and 0 < string.len(suitInfo[1].careerSkills) then
        local skillInfoTab = {}
        local skillInfoCfg = string.split(suitInfo[1].careerSkills, "&")
        for i, v in pairs(skillInfoCfg) do
          local skillItemCfg = string.split(v, "#")
          skillInfoTab[tonumber(skillItemCfg[1])] = tonumber(skillItemCfg[2])
        end
        local careerCategory = RoleUtility.GetCurrentCareerCategory()
        skillId = skillInfoTab[careerCategory]
      else
        skillId = suitInfo[1].skillID
      end
      if hideSkill and hideSkill ~= 1 and skillId then
        local skillInfo = ConfigManager.FindConfigs("cfg_Skill_skill", "id", skillId)[1]
        if skillInfo ~= nil then
          local skillDes = ConfigManager.FindConfigs("cfg_Item_tips", "id", skillInfo.description)[1].content
          if first and skillDes ~= "" then
            table.insert(tips.suitadditionalTable, suitSkillTitle)
          end
          strformat = strformat .. "\t\t" .. skillInfo.name
          strformat = string.GetColorText(strformat, color)
          if skillDes ~= "" then
            table.insert(tips.suitadditionalTable, strformat)
            table.insert(tips.suitadditionalTable, string.GetColorText(skillDes, color))
          end
          first = false
        end
      end
    end
    if minSuit ~= nil then
      local minsuit = MeEquipController.GetSuitCfg(tonumber(minSuit[1]), tonumber(minSuit[2]))
      for _, v in pairs(minsuit) do
        local bol = suitNum >= v.actNum and true or false
        if not bol and MinBol and MinCount >= v.actNum and self.SuitBol then
          local color = ItemQuality2ColorDic[EItemColorEnum.yellow]
          local strformat = string.format("\196\144\195\163 k\195\173ch ho\225\186\161t: ")
          local suitInfo = ConfigManager.FindConfigs("cfg_Item_equip_suit", "id", v.id)
          local skillInfoCfg
          local skillItem = {}
          local skillId
          if suitInfo[1].careerSkills == "" or suitInfo[1].careerSkills == nil then
            skillId = suitInfo[1].skillID
          else
            skillInfoCfg = string.split(suitInfo[1].careerSkills, "&")
            for i, v in ipairs(skillInfoCfg) do
              local careerSkill = string.split(v, "#")
              skillItem[tonumber(careerSkill[1])] = tonumber(careerSkill[2])
            end
            local careerCategory = RoleUtility.GetCurrentCareerCategory()
            skillId = skillItem[careerCategory]
          end
          if skillId then
            local skillInfo = ConfigManager.FindConfigs("cfg_Skill_skill", "id", skillId)[1]
            if skillInfo ~= nil then
              strformat = strformat .. skillInfo.name
              strformat = string.GetColorText(strformat, color)
              table.insert(tips.suitadditionalTable, strformat)
            end
          end
        end
      end
    end
  end
  self:CalculStrPosAndHeight(tips.suitadditionalTable, tips.lab_TipSuitAdditional, tips, tips.lab_suitAdditional)
end

function Tip_ItemTipTwoUI:EquipInlayAttributeStr(tips)
  if tips.ItemInfo.excellence == nil or table.count(tips.ItemInfo.excellence) <= 0 or tips.ItemInfo.tblItem.subType == 20 or tips.ItemInfo.tblItem.subType == 21 or tips.ItemInfo.tblItem.subType == 22 then
    return
  end
  if self.args.openType == TipsOpenType.RoleEquipOpen then
    local ModelIndex = tips.ItemInfo.bagGridIndex
    local stone = ViewData.meData.equipsData.StoneData
    local stoneData = {}
    local stonePos
    stoneData[1] = 0
    for _, v in pairs(EStonePosition) do
      stonePos = RoleEquipUtility.GetStoneEquipPos(ModelIndex, v)
      local isOpen = RoleEquipUtility.GetStoneCellIsOpen(stonePos, table.count(tips.ItemInfo.excellence))
      if isOpen and stone[stonePos] then
        stoneData[v] = stone[stonePos]
      end
    end
    for i, v in pairs(stoneData) do
      if v ~= 0 then
        local str = "Kh\225\186\163m \196\144\195\161" .. i .. "\239\188\154" .. RoleEquipUtility.GetEquipStoneFirstAttri(v)
        str = string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.blue])
        table.insert(tips.itemStoneTable, str)
      end
    end
    self:CalculStrPosAndHeight(tips.itemStoneTable, tips.lab_TipStoneAdditional, tips, tips.lab_StoneAdditional)
  end
end

function Tip_ItemTipTwoUI:FluorsparattributeStr(tips)
  if tips.ItemInfo.excellence == nil then
    return
  end
  if self.args.openType == TipsOpenType.RoleEquipOpen then
    local k, v = RoleEquipUtility.GetEquipStoneLight(tips.ItemInfo)
    for kk, vv in pairs(v) do
      local v = k[vv]
      for i = 1, #v do
        if v[i].isOpen then
          local itemData = v[i]
          local str = self:SetAttributeName(itemData.tbl)
          str = table.concat(str, "  ")
          table.insert(tips.itemStoneLightTable, i, str)
        end
      end
    end
    self:CalculStrPosAndHeight(tips.itemStoneLightTable, tips.lab_TipStoneLightAdditional, tips)
  end
end

function Tip_ItemTipTwoUI:EquipSpecialAttributeStr(tips)
  local ids = {}
  local isServer = false
  if tips.ItemInfo.specialInfo and next(tips.ItemInfo.specialInfo) ~= nil then
    ids = tips.ItemInfo.specialInfo
    isServer = true
  elseif tips.ItemInfo.id == 0 then
    local subType = tips.ItemInfo.tblItem.subType
    ids = ClientTable.cfg_Item_equip_specialManager:GetMeetIdsBySubtype(subType, tips.ItemInfo.tblEquip)
  else
    return
  end
  if ids == nil or next(ids) == nil then
    return
  end
  local showStr = ClientTable.cfg_Item_equip_specialManager:GetSpecialStrByIds(ids)
  local showInfo = ClientTable.cfg_Item_equip_specialManager:TryGetValue(ids[1])
  if showInfo ~= nil and showInfo.suitmark == 1 then
    showStr = string.format(ClientTable.cfg_Ui_wordManager:GetUi_wordCount(2), showStr)
  elseif not isServer then
    table.insert(tips.itemSpecialTable, ClientTable.cfg_Ui_wordManager:GetUi_wordCount("teshushuxing"))
  else
    showStr = string.format(ClientTable.cfg_Ui_wordManager:GetUi_wordCount(2), showStr)
  end
  table.insert(tips.itemSpecialTable, showStr)
  self:CalculStrPosAndHeight(tips.itemSpecialTable, tips.lab_TipSpecialAttributeAdditional, tips, tips.lab_SpecialAttribute)
end

function Tip_ItemTipTwoUI:CloseMounModle(tips)
  if tips.LoadMountObject ~= nil then
    local go = tips.LoadMountObject
    UnityEngineLua.GameObject.Destroy(go)
    tips.LoadMountObject = nil
  end
end

local loadMountCol

function Tip_ItemTipTwoUI:MountModelShow(tips)
  local isShow, param = self:IsShowCenterModel(tips)
  if isShow then
    if loadMountCol then
      self:CloseMounModle(tips)
      Coroutine.Stop(loadMountCol)
      loadMountCol = nil
    end
    loadMountCol = Coroutine.Start(self.DoLoadModel, self, tips, param)
    local offsetHeight = ClientTable.cfg_Global_globalManager:GetTipsModelOffsetHeight(tips.ItemInfo.itemId)
    tips.lab_ModelShow:SetActive(true)
    local x = tips.lab_ModelShow:GetAnchoredPosition()
    tips.lab_ModelShow:SetAnchoredPosition(x, -tips.centerHeight + offsetHeight * -1)
    tips.centerHeight = tips.centerHeight + tips.lab_ModelShow.transform.rect.height + self.minSpaceLine + offsetHeight
    tips.mount_bottom:SetActive(true)
    tips.sv_center:SetMovementType(ScrollMovementType.Clamped)
  else
    tips.sv_center:SetMovementType(ScrollMovementType.Elastic)
  end
end

function Tip_ItemTipTwoUI:DoLoadModel(tips, customInfo)
  local itemData = tips.ItemInfo
  local path
  if tips.ItemInfo.subType == 50 then
    path = string.format("Model/Charactor/%s.prefab", tips.ItemInfo.tblEquip.transformation)
  elseif tips.ItemInfo.tblItem.subType == 3007 and customInfo then
    local riderData = ClientTable.cfg_Item_mountManager:TryGetValue(customInfo.id, "id")
    path = string.format("Model/Charactor/%s/%s.prefab", riderData.route, riderData.model)
  else
    local riderData = ClientTable.cfg_Item_mountManager:TryGetValue(itemData.itemId, "id")
    path = string.format("Model/%s/%s.prefab", riderData.route, riderData.model)
  end
  local request = self:LoadAssetAsync(path, typeof(CS.UnityEngine.GameObject))
  Coroutine.Yield(request)
  if request.isError then
    print("\232\175\165\232\163\133\229\164\135\230\154\130\230\151\160\230\168\161\229\158\139")
    Coroutine.Break()
  else
    local go = Instantiate(request.res)
    tips.LoadMountObject = go
    local ModelParent = UIControl(tips.lab_ModelShow.transform, "lab_model")
    go.transform:SetParent(ModelParent.transform, false)
    if itemData.tblItem and itemData.tblItem.showSize then
      local scale = itemData.tblItem.showSize
      go.transform.localPosition = Vector3(0, -95, -500)
      go.transform.localEulerAngles = Vector3(0, 135, 0)
      go.transform.localScale = Vector3(scale, scale, scale)
    else
      go.transform.localPosition = Vector3(0, -95, -500)
      go.transform.localEulerAngles = Vector3(0, 135, 0)
      go.transform.localScale = Vector3(38, 38, 38)
    end
    go:SetLayer(UI_LAYER)
    local orderLayer = 500
    if self then
      orderLayer = self.root.canvas.sortingOrder
    end
    local renders = go.transform:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
    for i = 0, renders.Length - 1 do
      local rend = renders[i]
      rend.sortingOrder = orderLayer + 100
    end
    local sys = go.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    for i = 0, sys.Length - 1 do
      local par = sys[i]
      par.gameObject.layer = 5
      par:GetComponent(typeof(CS.UnityEngine.Renderer)).sortingOrder = orderLayer + 50
    end
    if customInfo ~= nil then
      if customInfo.Position ~= "" and customInfo.Position ~= nil then
        local xyStr = string.split(customInfo.Position, "#")[1]
        local xy = string.split(xyStr, "|")
        go.transform.localPosition = Vector3(tonumber(xy[1]), tonumber(xy[2]), -500)
        go.transform.localEulerAngles = Vector3(0, 0, 0)
      else
        go.transform.localPosition = Vector3(0, 0, 0)
        go.transform.localEulerAngles = Vector3(0, 0, 0)
      end
    end
    local animator = go:GetComponent(typeof(CS.UnityEngine.Animator))
    if animator then
      if tips.ItemInfo.subType == 50 then
        animator:Play("walk1")
      elseif tips.ItemInfo.tblItem.subType == 3007 then
        animator:Play("Take 001")
      else
        animator:Play("idle")
      end
    end
  end
end

function Tip_ItemTipTwoUI:IsShowCenterModel(tips)
  if tips.ItemInfo.tblItem.type == EItemType.Equipe then
    return tips.ItemInfo.tblItem.subType == EItemSubtype.Mount or tips.ItemInfo.tblItem.subType == EItemSubtype.AppearanceRing
  elseif tips.ItemInfo.tblItem.type == EItemType.Consumables then
    if tips.ItemInfo.tblItem.subType == 3007 then
      local wingInfo = ResolutionCompositestone(tips.ItemInfo.tblItem.compositestone)
      if wingInfo then
        wingInfo.isWing = true
      end
      return wingInfo ~= nil, wingInfo
    end
  elseif tips.ItemInfo.tblItem.type == EItemType.Material and tips.ItemInfo.tblItem.subType == EItemSubtype.MountUpgradeStone then
    return true
  end
  return false
end

local blackAttribute = {
  id = true,
  type = true,
  equipPosition = true,
  lightId = true,
  condition = true,
  fight = true,
  maximumPhysBaseDmg = true,
  minimumPhysBaseDmg = true,
  minimumWizBaseDmg = true,
  maximumWizBaseDmg = true
}

function Tip_ItemTipTwoUI:SetAttributeName(lightDataItem)
  local txtTable = {}
  for k, v in pairs(lightDataItem) do
    if not blackAttribute[k] and v ~= 0 and not blackAttribute[tostring(k)] then
      local word = AttributeWordUtil.GetUIWord(tostring(k), "equipeUI")
      local str = string.format(word, v)
      table.insert(txtTable, str)
    end
  end
  return txtTable
end

function Tip_ItemTipTwoUI:ShowTimer(surplusTime, lab_countdown)
  local function UpdateTimer()
    local timeStr = TimeUtility.ShowTime(surplusTime)
    
    surplusTime = surplusTime - 1
    lab_countdown:SetText("[L\225\186\167n sau m\225\187\159:  " .. string.GetColorText(tostring(timeStr), "#FF2323") .. "\227\128\145")
    if surplusTime == 0 and self.normalTimer then
      Timer.Stop(self.normalTimer)
      self.normalTimer = nil
      lab_countdown:SetText(string.GetColorText("\196\144\195\163 m\225\187\159", "#1ADD1F"))
      self.isSatisfy = true
    end
  end
  
  self.normalTimer = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Tip_ItemTipTwoUI:ItemItemTipsStr(tips)
  local sourceTips = tips.ItemInfo.tblItem.sourceTips
  if sourceTips ~= 0 then
    local sourcesTbl = ClientTable.cfg_Item_tipsManager:TryGetValue(sourceTips)
    if sourcesTbl then
      local sourcesStr = "\227\128\144" .. sourcesTbl.content .. "\227\128\145"
      sourcesStr = string.GetColorText(sourcesStr, ItemQuality2ColorDic[EItemColorEnum.lightGold])
      table.insert(tips.itemTipsTable, sourcesStr)
    end
  end
  local useParam = string.split(tips.ItemInfo.tblItem.useParam, "#")
  if useParam[1] == TipPanelEnum.BagStone then
    local notUnlockedCount, canUnlockedCount, color = 0, 0, ItemQuality2ColorDic[5]
    notUnlockedCount = BagInfoData.bagCellCount - BagInfoData.curBagCellCount
    canUnlockedCount = (notUnlockedCount <= 0 and 0 or notUnlockedCount) / BagInfoData.colCount
    color = canUnlockedCount == 0 and ItemQuality2ColorDic[7] or ItemQuality2ColorDic[5]
    local desStr = string.format("[S\225\187\145 l\198\176\225\187\163t c\195\178n l\225\186\161i: %s]", string.GetColorText(MathUtility.FormatNum(canUnlockedCount), color))
    table.insert(tips.itemTipsTable, desStr)
  end
  if useParam[1] == TipPanelEnum.WarehouseStone then
    local notUnlockedCount, canUnlockedCount, color = 0, 0, ItemQuality2ColorDic[5]
    notUnlockedCount = BagInfoData.storageCount - BagInfoData.curStorageCount
    canUnlockedCount = (notUnlockedCount <= 0 and 0 or notUnlockedCount) / BagInfoData.colCount
    color = canUnlockedCount == 0 and ItemQuality2ColorDic[7] or ItemQuality2ColorDic[5]
    local desStr = string.format("[S\225\187\145 l\198\176\225\187\163t c\195\178n l\225\186\161i: %s]", string.GetColorText(MathUtility.FormatNum(canUnlockedCount), color))
    table.insert(tips.itemTipsTable, desStr)
  end
  local itemDecomposeTab
  if ItemUtility.IsRuneType(tips.ItemInfo.tblItem.type) then
    if tips.ItemInfo.serverInfo and tips.ItemInfo.serverInfo.runesLevel then
      local id = tonumber(tips.ItemInfo.itemId .. tips.ItemInfo.serverInfo.runesLevel)
      itemDecomposeTab = ClientTable.cfg_Item_decompose_runesManager:TryGetValue(id, "id")
    end
  else
    itemDecomposeTab = ClientTable.cfg_Item_decomposeManager:TryGetValue(tonumber(tips.ItemInfo.itemId))
  end
  if itemDecomposeTab then
    local rewardTab = {}
    local RewardStr = itemDecomposeTab.clientReward
    if not string.isNullOrEmpty(RewardStr) then
      table.insert(rewardTab, RewardStr)
      if string.contains(RewardStr, "#") then
        rewardTab = string.split(RewardStr, "#")
      end
      local strTab = {}
      for _, v in pairs(rewardTab) do
        local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(v))
        if itemTab then
          local rewardName = itemTab.name
          if not string.isNullOrEmpty(rewardName) then
            table.insert(strTab, rewardName)
          end
        end
      end
      if 0 < table.count(strTab) then
        local str = table.concat(strTab, ", ")
        table.insert(tips.itemTipsTable, string.format("T\195\161ch nh\225\186\173n: %s", str))
      end
    end
  end
  local sell = tips.ItemInfo.tblItem.sell
  if not string.isNullOrEmpty(sell) then
    local sellInfos = string.split(sell, "#")
    local id = tonumber(sellInfos[1])
    local number = tonumber(sellInfos[2])
    local item = ClientTable.cfg_Item_itemManager:TryGetValue(id)
    if item then
      local str = ""
      if item.name == "V\195\160ng" and tips.ItemInfo.bind == 2 then
        str = self.shoudianjiage .. number .. "Li\195\170n k\225\186\191t" .. item.name
      else
        str = self.shoudianjiage .. number .. item.name
      end
      str = string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.lightGold])
      table.insert(tips.itemTipsTable, str)
    end
  end
  local str = table.concat(tips.itemTipsTable, "\n")
  local line = 0
  if not string.isNullOrEmpty(str) then
    local x = tips.lab_TipItemTips:GetAnchoredPosition()
    if tips.ItemInfo.tblItem.icon == 8000040 or tips.ItemInfo.tblItem.icon == 8000050 or tips.ItemInfo.tblItem.subType == 3008 then
      TranScriptData.ClearData(true)
      TranScriptData.CloseRevive()
      if tips.ItemInfo.tblItem.icon == 8000050 then
        TranScriptData.GetEnterConditionData(TranScriptData.TranScriptSubType.BloodCastle, 100414, 100404)
      elseif tips.ItemInfo.tblItem.subType == 3008 then
        TranScriptData.GetEnterConditionData(TranScriptData.TranScriptSubType.RefineTow, 101001, 101003)
      else
        TranScriptData.GetEnterConditionData(TranScriptData.TranScriptSubType.DemonPlaza, 100408, 100702)
      end
      self.ContentData = TranScriptData.GetContentData()
      TranScriptData.RefreshOpenTime(self.ContentData.mapId)
      local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(self.ContentData.mapId, "id")
      local openCondition = string.split(mapTbl.openCondition, "#")
      local taskID = tonumber(openCondition[table.count(openCondition)])
      self.intervalTime = TranScriptData.startTime - Time.GetServerSecondTime()
      if 0 >= self.intervalTime or TaskData.GetTaskById(taskID) and TaskData.GetTaskById(taskID):GetState() == TaskStateType.Accept then
        Timer.Stop(self.normalTimer)
        tips.lab_TipCountDownTime:SetText(string.GetColorText("[\196\144\195\163 m\225\187\159]", "#1ADD1F"))
        self.isSatisfy = true
      else
        Timer.Stop(self.normalTimer)
        tips.lab_TipCountDownTime:SetText("")
        self:ShowTimer(self.intervalTime, tips.lab_TipCountDownTime)
        self.isSatisfy = false
      end
      line = 36
      if tips.ItemInfo.tblItem.subType == 3008 then
        local instanceCount = RefreshData.GetInstanceCount(3020702)
        tips.lab_ResidueDegree:SetText("[L\198\176\225\187\163t h\195\180m nay c\195\178n:  " .. string.GetColorText(tostring(instanceCount), "#1Add1F") .. "\227\128\145")
      else
        local globalId = tips.ItemInfo.tblItem.icon == 8000040 and ClientTable.cfg_Global_globalManager:TryGetValue(60000002).effect or ClientTable.cfg_Global_globalManager:TryGetValue(60000001).effect
        local instanceCount = RefreshData.GetInstanceCount(tonumber(globalId))
        tips.lab_ResidueDegree:SetText("[L\198\176\225\187\163t h\195\180m nay c\195\178n:  " .. string.GetColorText(tostring(instanceCount), "#1Add1F") .. "\227\128\145")
      end
      tips.lab_ResidueDegree:SetActive(true)
      tips.lab_TipCountDownTime:SetActive(true)
      tips.lab_TipItemTips:SetAnchoredPosition(x, -tips.bottomHeight)
      tips.Scroll_DownTips:SetAnchoredPosition(x, -tips.bottomHeight)
      tips.contentHeight = tips.contentHeight + tips.lab_TipCountDownTime.text.preferredHeight + tips.lab_ResidueDegree.text.preferredHeight
      tips.bottomHeight = tips.bottomHeight + tips.lab_TipCountDownTime.text.preferredHeight + tips.lab_ResidueDegree.text.preferredHeight
    else
      line = 12
      tips.lab_ResidueDegree:SetActive(false)
      tips.lab_TipItemTips:SetAnchoredPosition(x, -(tips.bottomHeight + 12))
      tips.Scroll_DownTips:SetAnchoredPosition(x, -(tips.bottomHeight + 12))
    end
    tips.lab_TipItemTips:SetText(str)
    tips.lab_TipItemTips:SetActive(true)
    tips.contentHeight = tips.contentHeight + self:GetScrollDownTipsHeight(tips, 5)
    tips.bottomHeight = tips.bottomHeight + self:GetScrollDownTipsHeight(tips, 5)
    self:RefreshScrollDownTipsHeight(tips)
  end
end

function Tip_ItemTipTwoUI:GetScrollDownTipsHeight(tips, line)
  if not tips.lab_TipItemTips.gameObject.activeSelf then
    return self.minSpaceLine + line
  else
    local height = tips.lab_TipItemTips.text.preferredHeight
    if height >= tips.Scroll_DownTipsCriticalHeight then
      return tips.Scroll_DownTipsCriticalHeight + self.minSpaceLine + line
    else
      return height + self.minSpaceLine + line
    end
  end
end

function Tip_ItemTipTwoUI:RefreshScrollDownTipsHeight(tips)
  if not tips.lab_TipItemTips.gameObject.activeSelf then
    return
  end
  local height = tips.lab_TipItemTips.text.preferredHeight
  local rectTransorm = tips.Scroll_DownTips.rectTransform
  if height >= tips.Scroll_DownTipsCriticalHeight then
    rectTransorm.sizeDelta = Vector2(rectTransorm.sizeDelta.x, tips.Scroll_DownTipsCriticalHeight)
  else
    rectTransorm.sizeDelta = Vector2(rectTransorm.sizeDelta.x, height)
  end
end

function Tip_ItemTipTwoUI:ThingTimeDown(tips)
  if tips.ItemInfo.tblItem.overTime ~= "" and tips.ItemInfo.tblItem.overTime ~= "0" and tonumber(tips.ItemInfo.tblItem.overTime) ~= -9999 then
    local curTime = tonumber(tips.ItemInfo.time)
    local timeReduce, color
    if UIManager.IsVisible(UIID.NewBagInfoUI) then
      timeReduce = (curTime - Time.GetServerTime()) * 0.001
      color = ItemQuality2ColorDic[EItemColorEnum.red]
    elseif UIManager.IsVisible(UIID.Commercial_ReturnActivityUI) then
      local overTime = string.split(tips.ItemInfo.tblItem.overTime, "#")
      if overTime ~= nil then
        timeReduce = tonumber(overTime[2]) * 0.001
      end
      color = ItemQuality2ColorDic[EItemColorEnum.green]
    elseif UIManager.IsVisible(UIID.Reward_ShiKongUI) then
      timeReduce = (curTime - Time.GetServerTime()) * 0.001
      color = ItemQuality2ColorDic[EItemColorEnum.red]
    else
      local overTime = string.split(tips.ItemInfo.tblItem.overTime, "#")
      if overTime ~= nil then
        timeReduce = (tonumber(overTime[2]) - Time.GetServerTime()) * 0.001
      end
      color = ItemQuality2ColorDic[EItemColorEnum.green]
    end
    local timeStr = TimeUtility.ShowTime(timeReduce)
    local str = LocalizationUtility.GetContentByKey("ItemTips_equipTime")
    timeStr = string.GetColorText(string.format(str, timeStr), color)
    local x = tips.lab_TipEquipTime:GetAnchoredPosition()
    tips.lab_TipEquipTime:SetAnchoredPosition(x, -tips.bottomHeight)
    tips.lab_TipEquipTime:SetText(timeStr)
    tips.lab_TipEquipTime:SetActive(true)
    tips.contentHeight = tips.contentHeight + tips.lab_TipEquipTime.text.preferredHeight + self.minSpaceLine
    tips.bottomHeight = tips.bottomHeight + tips.lab_TipEquipTime.text.preferredHeight + self.minSpaceLine
    if not UIManager.IsVisible(UIID.Commercial_ReturnActivityUI) then
      tips.equipTimeCol = Timer.StartLoop(1, timeReduce, function()
        timeReduce = timeReduce - 1
        timeStr = TimeUtility.ShowTime(timeReduce)
        timeStr = string.GetColorText(string.format(str, timeStr), color)
        tips.lab_TipEquipTime:SetText(timeStr)
        if timeReduce == 0 then
          UIManager.Hide(self.name)
        end
      end)
    end
  end
end

function Tip_ItemTipTwoUI:EquipTimeDown(tips)
  if tips.ItemInfo.tblEquip.equipTime ~= -9999 and (UIManager.IsVisible(UIID.NewBagInfoUI) or tips.ItemInfo.tblEquip.id == 7000000 or tips.ItemInfo.tblEquip.id == 7000001 or tips.ItemInfo.tblEquip.id == 7000002) then
    local totalTime = tips.ItemInfo.tblEquip.equipTime
    local curTime = tips.ItemInfo.equipTime
    local timeReduce
    local isEquip = ViewData.meData.equipsData:GetEquipById(tips.ItemInfo.id)
    local color
    if isEquip then
      color = ItemQuality2ColorDic[EItemColorEnum.red]
      timeReduce = Mathf.Floor(tips.ItemInfo.time * 0.001) - Time.GetServerSecondTime()
    else
      timeReduce = tips.ItemInfo.tblEquip.equipTime * 0.001
      color = totalTime == curTime and ItemQuality2ColorDic[EItemColorEnum.green] or ItemQuality2ColorDic[EItemColorEnum.red]
    end
    local timeStr = TimeUtility.ShowTime(timeReduce)
    local str = LocalizationUtility.GetContentByKey("ItemTips_equipTime")
    timeStr = string.GetColorText(string.format(str, timeStr), color)
    local x = tips.lab_TipEquipTime:GetAnchoredPosition()
    tips.lab_TipEquipTime:SetAnchoredPosition(x, -tips.bottomHeight)
    tips.lab_TipEquipTime:SetText(timeStr)
    tips.lab_TipEquipTime:SetActive(true)
    tips.contentHeight = tips.contentHeight + tips.lab_TipEquipTime.text.preferredHeight + self.minSpaceLine
    tips.bottomHeight = tips.bottomHeight + tips.lab_TipEquipTime.text.preferredHeight + self.minSpaceLine
    if isEquip then
      tips.equipTimeCol = Timer.StartLoop(1, timeReduce, function()
        timeReduce = timeReduce - 1
        timeStr = TimeUtility.ShowTime(timeReduce)
        timeStr = string.GetColorText(string.format(str, timeStr), color)
        tips.lab_TipEquipTime:SetText(timeStr)
        if timeReduce == 0 then
          UIManager.Hide(self.name)
        end
      end)
    end
  elseif tips.ItemInfo.serverInfo and tips.ItemInfo.serverInfo.time and tips.ItemInfo.serverInfo.time > 0 then
    local totalTime = tips.ItemInfo.serverInfo.time
    local curTime = Time.GetServerSecondTime()
    if totalTime < curTime then
      return
    end
    local timeReduce
    local isEquip = ViewData.meData.equipsData:GetEquipById(tips.ItemInfo.id)
    local color = ItemQuality2ColorDic[EItemColorEnum.green]
    timeReduce = totalTime * 0.001 - curTime
    local timeStr = TimeUtility.ShowTime(timeReduce)
    local str = LocalizationUtility.GetContentByKey("ItemTips_equipTime")
    timeStr = string.GetColorText(string.format(str, timeStr), color)
    local x = tips.lab_TipEquipTime:GetAnchoredPosition()
    tips.lab_TipEquipTime:SetAnchoredPosition(x, -tips.bottomHeight)
    tips.lab_TipEquipTime:SetText(timeStr)
    tips.lab_TipEquipTime:SetActive(true)
    tips.contentHeight = tips.contentHeight + tips.lab_TipEquipTime.text.preferredHeight + self.minSpaceLine
    tips.bottomHeight = tips.bottomHeight + tips.lab_TipEquipTime.text.preferredHeight + self.minSpaceLine
    if isEquip then
      tips.equipTimeCol = Timer.StartLoop(1, timeReduce, function()
        timeReduce = timeReduce - 1
        timeStr = TimeUtility.ShowTime(timeReduce)
        timeStr = string.GetColorText(string.format(str, timeStr), color)
        tips.lab_TipEquipTime:SetText(timeStr)
        if timeReduce == 0 then
          UIManager.Hide(self.name)
        end
      end)
    end
  end
end

function Tip_ItemTipTwoUI:EquipDur(tips)
  local durStr
  if tips.ItemInfo.tblEquip.durability ~= -9999 then
    local totalDurability = tips.ItemInfo.tblEquip.durability
    local curDurability = Mathf.Floor(tips.ItemInfo.durability)
    if not UIManager.IsVisible(UIID.NewBagInfoUI) then
      curDurability = totalDurability
    end
    local color
    color = totalDurability == curDurability and ItemQuality2ColorDic[EItemColorEnum.green] or ItemQuality2ColorDic[EItemColorEnum.red]
    local str = LocalizationUtility.GetContentByKey("ItemTips_equipDurability")
    durStr = string.GetColorText(string.format(str, curDurability, totalDurability), color)
  elseif tips.ItemInfo.tblEquip.subType == 21 and tips.ItemInfo.tblEquip.cellType ~= 12 then
    local color
    color = ItemQuality2ColorDic[EItemColorEnum.green]
  end
  if durStr ~= nil and durStr ~= "" then
    local x = tips.lab_TipEquipDura:GetAnchoredPosition()
    tips.lab_TipEquipDura:SetAnchoredPosition(x, -tips.centerHeight)
    tips.lab_TipEquipDura:SetText(durStr)
    tips.lab_TipEquipDura:SetActive(true)
    tips.contentHeight = tips.contentHeight + tips.lab_TipEquipDura.text.preferredHeight + self.minSpaceLine
    tips.centerHeight = tips.centerHeight + tips.lab_TipEquipDura.text.preferredHeight + self.minSpaceLine
  end
end

function Tip_ItemTipTwoUI:BuffAttributeStr(tips)
  local attributeDesList, attributeDesUIControl, titleDesUIControl = {}
  if tips.ItemInfo == nil or tips.ItemInfo.tblEquip == nil or tips.ItemInfo:GetBuffTbl() == nil then
    return
  end
  table.insert(attributeDesList, tips.ItemInfo:GetBuffTbl().desc)
  if tips.ItemInfo.tblItem.type == EItemType.Equipe and tips.ItemInfo.tblItem.subType == EItemSubtype.Flag then
    attributeDesUIControl = tips.lab_TipFlagAdditional
    titleDesUIControl = tips.lab_flag
  elseif tips.ItemInfo.tblItem.type == EItemType.Equipe and tips.ItemInfo.tblItem.subType == EItemSubtype.Bugle then
    attributeDesUIControl = tips.lab_TipBugleAdditional
    titleDesUIControl = tips.lab_bugle
  end
  if next(attributeDesList) == nil or attributeDesUIControl == nil or titleDesUIControl == nil then
    return
  end
  self:CalculStrPosAndHeight(attributeDesList, attributeDesUIControl, tips, titleDesUIControl)
end

function Tip_ItemTipTwoUI:ButtonShow(tips)
  if self:ShowButton(tips) then
    local isCenterBtn = self:BindBtnOpreate(tips, self.args.rightOperate)
    local w, h = tips.go_btns:GetSizeDelta()
    h = isCenterBtn and tips.btn_CenterClick.transform.rect.height or tips.btn_LeftClick.transform.rect.height + 24
    if UIManager.IsVisible(UIID.Equip_StoneUI) and self.args.isPutOn then
      h = h + 24
    end
    if UIManager.IsVisible(UIID.BagWarehouseUI) or UIManager.IsVisible(UIID.Equip_OverlapUI) then
      h = h + 16
    end
    if UIManager.IsVisible(UIID.Equip_StoneUI) or UIManager.IsVisible(UIID.Equip_XiLianUI) then
      h = h + 14
    end
    tips.go_btns:SetSizeDelta(w, h)
    local bottomX = tips.Img_bottom:GetAnchoredPosition()
    tips.go_btns:SetAnchoredPosition(bottomX, -(tips.bottomHeight - 12))
    tips.contentHeight = tips.contentHeight + tips.go_btns.transform.rect.height + self.bottomHeight
    tips.bottomHeight = tips.bottomHeight + tips.go_btns.transform.rect.height + self.bottomHeight
  else
    tips.contentHeight = tips.contentHeight + self.bottomHeight
    tips.bottomHeight = tips.bottomHeight + self.bottomHeight
  end
end

function Tip_ItemTipTwoUI:Prompt(str, param)
  UIManager.Show(UIID.PromptTipUI, param or {
    title = self.tishi,
    textContent = str,
    cancelText = "",
    okText = "",
    cancel = nil,
    ok = nil
  })
end

function Tip_ItemTipTwoUI:ReSet(tips)
  self:TipsAttributeReset(tips)
  self:TipsComponentReset(tips)
end

function Tip_ItemTipTwoUI:TipsComponentReset(tips)
  tips.Img_TipBg:SetActive(false)
  tips.img_topBg:SetActive(false)
  tips.img_top:SetActive(false)
  tips.btn_MoreClick:SetActive(false)
  tips.btn_CenterClick:SetActive(false)
  tips.btn_RightClick:SetActive(false)
  tips.btn_LeftClick:SetActive(false)
  tips.Img_moreBg:SetActive(false)
  tips.lab_TipTopInfo:SetActive(false)
  tips.Tip_ModelShow:SetActive(false)
  tips.plane_bottom:SetActive(false)
  tips.lab_itemclass:SetActive(false)
  tips.img_centerBg:SetActive(false)
  tips.lab_attribute:SetActive(false)
  tips.title_attributeEnchantment:SetActive(false)
  tips.title_attributeEnchantmentDetail:SetActive(false)
  tips.lab_TipAttribute:SetActive(false)
  tips.lab_TipAttributeEnchantment:SetActive(false)
  tips.lab_TipIntensify:SetActive(false)
  tips.lab_excellent:SetActive(false)
  tips.lab_excellentInherit:SetActive(false)
  tips.lab_StoneAdditional:SetActive(false)
  tips.lab_growUp:SetActive(false)
  tips.lab_ConsumAttribute:SetActive(false)
  tips.lab_TipExcellentAdditional:SetActive(false)
  tips.lab_VIPattribute:SetActive(false)
  tips.lab_VIPTipAttribute:SetActive(false)
  tips.lab_suitAdditional:SetActive(false)
  tips.lab_Luck:SetActive(false)
  tips.lab_TipLuck:SetActive(false)
  tips.lab_Skill:SetActive(false)
  tips.lab_TipSkill:SetActive(false)
  tips.lab_TipZhuiJia:SetActive(false)
  tips.lab_TipGrowUp:SetActive(false)
  tips.lab_ModelShow:SetActive(false)
  tips.lab_TipJewelryCur:SetActive(false)
  tips.lab_TipJewelryNext:SetActive(false)
  tips.grid_jewelyUpgrade:SetActive(false)
  tips.lab_TipSuitAdditional:SetActive(false)
  tips.suitContainer:SetActive(false)
  tips.lab_TipStoneAdditional:SetActive(false)
  tips.lab_TipStoneLightAdditional:SetActive(false)
  tips.lab_TipExcellentInherit:SetActive(false)
  tips.lab_bugle:SetActive(false)
  tips.lab_TipBugleAdditional:SetActive(false)
  tips.lab_flag:SetActive(false)
  tips.lab_TipFlagAdditional:SetActive(false)
  tips.lab_SpecialAttribute:SetActive(false)
  tips.lab_TipSpecialAttributeAdditional:SetActive(false)
  tips.lab_regenerate:SetActive(false)
  tips.lab_Tipregenerate:SetActive(false)
  tips.lab_RunesAttribute:SetActive(false)
  tips.grid_RunesAttribute:SetActive(false)
  tips.lab_TipRunesAttribute:SetActive(false)
  tips.grid_RunesSuitAttribute:SetActive(false)
  tips.lab_RunesSuitAdditional:SetActive(false)
  tips.lab_suitAdditional_runes:SetActive(false)
  tips.Scroll_BagInfo:SetActive(false)
  tips.lab_HolySkeletonAttribute:SetActive(false)
  tips.grid_HolySkeletonAttribute:SetActive(false)
  tips.lab_TipHolySkeletonAttribute:SetActive(false)
  tips.lab_suitAdditional_HolySkeleton:SetActive(false)
  tips.grid_HolySkeletonSuitAttribute:SetActive(false)
  tips.lab_HolySkeletonSuitAttribute:SetActive(false)
  tips.img_downBg:SetActive(false)
  tips.img_down:SetActive(false)
  tips.lab_TipItemTips:SetActive(false)
  tips.lab_TipCountDownTime:SetActive(false)
  tips.lab_TipEquipDura:SetActive(false)
  tips.lab_TipEquipTime:SetActive(false)
  tips.mount_bottom:SetActive(false)
  tips.img_line:SetActive(false)
  tips.lab_ResidueDegree:SetActive(false)
  tips.AuctionInputPrice:SetActive(true)
  tips.lab_fixedPriceValue:SetActive(false)
  tips.AuctionBtn.transform:GetChild(1).gameObject:SetActive(false)
  tips.lab_InputField:SetActive(false)
  tips.lab_count:SetActive(true)
  tips.lab_excellentHonour:SetActive(false)
  tips.lab_TipExcellentHonourAdditional:SetActive(false)
  tips.honour_bg:SetActive(false)
end

function Tip_ItemTipTwoUI:TipsAttributeReset(tips)
  for key, _ in pairs(tips.arrtibuteTable) do
    tips.arrtibuteTable[key] = nil
  end
  for key, _ in pairs(tips.conditionTable) do
    tips.conditionTable[key] = nil
  end
  for key, _ in pairs(tips.additionalTable) do
    tips.additionalTable[key] = nil
  end
  for key, _ in pairs(tips.excellentadditionalTable) do
    tips.excellentadditionalTable[key] = nil
  end
  for key, _ in pairs(tips.VIPattributeTable) do
    tips.VIPattributeTable[key] = nil
  end
  for key, _ in pairs(tips.excellentInheritTable) do
    tips.excellentInheritTable[key] = nil
  end
  for key, _ in pairs(tips.itemSpecialTable) do
    tips.itemSpecialTable[key] = nil
  end
  for key, _ in pairs(tips.skillTable) do
    tips.skillTable[key] = nil
  end
  for key, _ in pairs(tips.luckTable) do
    tips.luckTable[key] = nil
  end
  for key, _ in pairs(tips.lucksTable) do
    tips.lucksTable[key] = nil
  end
  for key, _ in pairs(tips.jewelryTable) do
    tips.jewelryTable[key] = nil
  end
  for key, _ in pairs(tips.suitadditionalTable) do
    tips.suitadditionalTable[key] = nil
  end
  for key, _ in pairs(tips.itemStoneTable) do
    tips.itemStoneTable[key] = nil
  end
  for key, _ in pairs(tips.itemStoneLightTable) do
    tips.itemStoneLightTable[key] = nil
  end
  for key, _ in pairs(tips.itemTipsTable) do
    tips.itemTipsTable[key] = nil
  end
  if tips.equipTimeCol then
    Timer.Stop(tips.equipTimeCol)
    tips.equipTimeCol = nil
  end
  tips.contentHeight = 0
  tips.centerHeight = 10
  tips.topHeight = 16
  tips.bottomHeight = 10
  tips.showTransOrDurability = false
  tips.moreState = false
end

function Tip_ItemTipTwoUI:LocalInit()
  self.zhiyebufuhe = LocalizationUtility.GetContentByKey("zhiyebufuhe")
  self.dengjibufuhe = LocalizationUtility.GetContentByKey("dengjibufuhe")
  self.shuxingbufuhe = LocalizationUtility.GetContentByKey("shuxingbufuhe")
  self.yizhuangbei = LocalizationUtility.GetContentByKey("yizhuangbei")
  self.shiyong = LocalizationUtility.GetContentByKey("shiyong")
  self.shiyongquanbu = "D\195\185ng t\225\186\165t c\225\186\163"
  self.qianwang = "\196\144\225\186\191n"
  self.addEquip = "X\225\186\191p ch\225\187\147ng"
  self.xiLianEquip = "T\225\186\169y Luy\225\187\135n"
  self.xiLianRedEquip = "T\225\186\169y Luy\225\187\135n"
  self.Shelves = "Cho l\195\170n k\225\187\135"
  self.strengthen = "C\195\180ng Ph\195\178ng Chi\225\186\191n"
  self.Upgrade = "N\195\162ng c\225\186\165p"
  self.Recyle = "Thu h\225\187\147i"
  self.Exchange = LocalizationUtility.GetContentByKey("Festivalitem4")
  self.zhuangbei = LocalizationUtility.GetContentByKey("zhuangbei")
  self.tuoxia = LocalizationUtility.GetContentByKey("tuoxia")
  self.fangru = LocalizationUtility.GetContentByKey("fangru")
  self.quchu = LocalizationUtility.GetContentByKey("quchu")
  self.gengduo = LocalizationUtility.GetContentByKey("gengduo")
  self.diuqi = "Ph\195\161 h\225\187\167y"
  self.quxiao = LocalizationUtility.GetContentByKey("quxiao")
  self.gongjili = LocalizationUtility.GetContentByKey("gongjili")
  self.shaungshou = LocalizationUtility.GetContentByKey("shaungshou")
  self.danshou = LocalizationUtility.GetContentByKey("danshou")
  self.gongjisudu = LocalizationUtility.GetContentByKey("gongjisudu")
  self.gongjisudubaifenbi = LocalizationUtility.GetContentByKey("gongjisudubaifengbi")
  self.fangyuli = LocalizationUtility.GetContentByKey("fangyuli")
  self.fangyulv = LocalizationUtility.GetContentByKey("fangyulv")
  self.shanghaizengjia = LocalizationUtility.GetContentByKey("shanghaizhengjia")
  self.shanghaitisheng = LocalizationUtility.GetContentByKey("shanghaitisheng")
  self.shanghaixuejian = LocalizationUtility.GetContentByKey("shanghaixuejian")
  self.shengmingzuidazhizengjia = LocalizationUtility.GetContentByKey("shengmingzuidazhizengjia")
  self.bingdikangli = LocalizationUtility.GetContentByKey("bingdikangli")
  self.huodikangli = LocalizationUtility.GetContentByKey("huodikangli")
  self.shuidikangli = LocalizationUtility.GetContentByKey("shuidikangli")
  self.didikangli = LocalizationUtility.GetContentByKey("didikangli")
  self.fengdikangli = LocalizationUtility.GetContentByKey("fengdikangli")
  self.dudikangli = LocalizationUtility.GetContentByKey("dudikangli")
  self.leidikangli = LocalizationUtility.GetContentByKey("leidikangli")
  self.tipsdikangwushifangyujilv = LocalizationUtility.GetContentByKey("tipsdikangwushifangyujilv")
  self.tipsdikangSDwushijilv = LocalizationUtility.GetContentByKey("tipsdikangSDwushijilv")
  self.tipsdikangshuangbeishanghaijilv = LocalizationUtility.GetContentByKey("tipsdikangshuangbeishanghaijilv")
  self.tipsdikangzhuoyueyijijilv = LocalizationUtility.GetContentByKey("tipsdikangzhuoyueyijijilv")
  self.tipsdikangzhimingyijijilv = LocalizationUtility.GetContentByKey("tipsdikangzhimingyijijilv")
  self.tipsgongjijulizengjia = LocalizationUtility.GetContentByKey("tipsgongjijulizengjia")
  self.mofagongjili = LocalizationUtility.GetContentByKey("mofagongjili")
  self.chongwugongjilitigao = LocalizationUtility.GetContentByKey("chongwugongjilitigao")
  self.suoxuliliang = LocalizationUtility.GetContentByKey("suoxuliliang")
  self.haixu = LocalizationUtility.GetContentByKey("haixu")
  self.suoxuminjie = LocalizationUtility.GetContentByKey("suoxuminjie")
  self.suoxuzhili = LocalizationUtility.GetContentByKey("suoxuzhili")
  self.suoxudengji = LocalizationUtility.GetContentByKey("suoxudengji")
  self.ConditionTips_200 = LocalizationUtility.GetContentByKey("ConditionTips_200")
  self.suoxushenghun = LocalizationUtility.GetContentByKey("suoxushenghun")
  self.shoudianjiage = LocalizationUtility.GetContentByKey("shoudianjiage")
  self.naijiudu = LocalizationUtility.GetContentByKey("naijiudu")
  self.lilianghaicha = LocalizationUtility.GetContentByKey("liliang")
  self.minjiehaicha = LocalizationUtility.GetContentByKey("minjie")
  self.zhilihaicha = LocalizationUtility.GetContentByKey("zhili")
  self.zidongfenpeidianshu = LocalizationUtility.GetContentByKey("zidongfenpeidianshu")
  self.xingyunlinghunbaoshizhichenggongjilv = LocalizationUtility.GetContentByKey("xingyunlinghunbaoshizhichenggongjilv")
  self.xingyunhuixinyijilv = LocalizationUtility.GetContentByKey("xingyunhuixinyijilv")
  self.zhuoyuegongjijilvzengjia = LocalizationUtility.GetContentByKey("zhuoyuegongjijilvzengjia")
  self.gongjilizengjiadengji = LocalizationUtility.GetContentByKey("gongjilizengjiadengji")
  self.mofagongjilizengjiadengji = LocalizationUtility.GetContentByKey("mofagongjilizengjiadengji")
  self.gongjilizegnjia = LocalizationUtility.GetContentByKey("gongjilizegnjia")
  self.mofagongjilizegnjia = LocalizationUtility.GetContentByKey("mofagongjilizegnjia")
  self.gongjimofasuduzengjia = LocalizationUtility.GetContentByKey("gongjimofasuduzengjia")
  self.shasiguaiwushisuohuoshengmingzhizengjia = LocalizationUtility.GetContentByKey("shasiguaiwushisuohuoshengmingzhizengjia")
  self.shasiguaiwushisuohuomofazhizengjia = LocalizationUtility.GetContentByKey("shasiguaiwushisuohuomofazhizengjia")
  self.zuidashengmingzhi = LocalizationUtility.GetContentByKey("zuidashengmingzhi")
  self.zuidamofazhi = LocalizationUtility.GetContentByKey("zuidamofazhi")
  self.shanghaifanshe = LocalizationUtility.GetContentByKey("shanghaifanshe")
  self.fangyuchengglv = LocalizationUtility.GetContentByKey("fangyuchengglv")
  self.shasiguaiwushisuohuojinzengjia = LocalizationUtility.GetContentByKey("shasiguaiwushisuohuojinzengjia")
  self.shanghaijianshao = LocalizationUtility.GetContentByKey("shanghaijianshao")
  self.shanghaijiacheng = LocalizationUtility.GetContentByKey("shanghaijiacheng")
  self.shanghaixushou = LocalizationUtility.GetContentByKey("shanghaixushou")
  self.suitstrength = LocalizationUtility.GetContentByKey("strength")
  self.suitagility = LocalizationUtility.GetContentByKey("agility")
  self.suitvitality = LocalizationUtility.GetContentByKey("vitality")
  self.suitenergy = LocalizationUtility.GetContentByKey("energy")
  self.suitleadership = LocalizationUtility.GetContentByKey("leadership")
  self.xingyunlinghunbaoshizhichenggongjilv = LocalizationUtility.GetContentByKey("xingyunlinghunbaoshizhichenggongjilv")
  self.xingyunhuixinyijilv = LocalizationUtility.GetContentByKey("xingyunhuixinyijilv")
  self.wuqijinengshuoming = LocalizationUtility.GetContentByKey("wuqijinengshuoming")
  self.mofagongjilizengjia = LocalizationUtility.GetContentByKey("mofagongjilizengjia")
  self.zuzhougongjilizengjia = LocalizationUtility.GetContentByKey("zuzhougongjilizengjia")
  self.shanghaifanshedikang = LocalizationUtility.GetContentByKey("resistDamageReflection")
  self.zhuijiagongjili = LocalizationUtility.GetContentByKey("zhuijiagongjili")
  self.zhuijiamofagongjili = LocalizationUtility.GetContentByKey("zhuijiamofagongjili")
  self.zhuijiazuzhougongjili = LocalizationUtility.GetContentByKey("zhuijiazuzhougongjili")
  self.zhuijiafangyulv = LocalizationUtility.GetContentByKey("zhuijiafangyulv")
  self.zhuijiafangyuli = LocalizationUtility.GetContentByKey("zhuijiafangyuli")
  self.shengmingzidonghuifu = LocalizationUtility.GetContentByKey("shengmingzidonghuifu")
  self.TipsGrowthEquip_1 = LocalizationUtility.GetContentByKey("TipsGrowthEquip_1")
  self.TipsGrowthEquip_2 = LocalizationUtility.GetContentByKey("TipsGrowthEquip_2")
  self.TipsGrowthEquip_3 = LocalizationUtility.GetContentByKey("TipsGrowthEquip_3")
  self.qianghuagongjili = LocalizationUtility.GetContentByKey("qianghuagongjili")
  self.qianghuafashugongjili = LocalizationUtility.GetContentByKey("qianghuafashugongjili")
  self.qianghuafangyuli = LocalizationUtility.GetContentByKey("qianghuafangyuli")
  self.qianghuatishengyidongsudu = LocalizationUtility.GetContentByKey("qianghuatishengyidongsudu")
  self.qianghuatishengyouyongsudu = LocalizationUtility.GetContentByKey("qianghuatishengyouyongsudu")
  self.shengmingzuidazhizengjiabaifenbi = LocalizationUtility.GetContentByKey("shengmingzuidazhizengjiabaifenbi")
  self.qianghua1 = LocalizationUtility.GetContentByKey("qianghua1")
  self.qianghua2 = LocalizationUtility.GetContentByKey("qianghua2")
  self.qianghua3 = LocalizationUtility.GetContentByKey("qianghua3")
  self.qianghua4 = LocalizationUtility.GetContentByKey("qianghua4")
  self.qianghua5 = LocalizationUtility.GetContentByKey("qianghua5")
  self.qianghua6 = LocalizationUtility.GetContentByKey("qianghua6")
  self.qianghua7 = LocalizationUtility.GetContentByKey("qianghua7")
  self.qianghua8 = LocalizationUtility.GetContentByKey("qianghua8")
  self.tipszhimingyijishanghai = LocalizationUtility.GetContentByKey("tipszhimingyijishanghai")
  self.tipswushifangyujilv = LocalizationUtility.GetContentByKey("tipswushifangyujilv")
end

function Tip_ItemTipTwoUI:RefreshBoxReward(tips)
  tips.Scroll_BagInfo:SetActive(false)
  local chestTypeArr = tips.ItemInfo.tblItem.chestType
  if tips.ItemInfo.tblItem.type == EItemType.TreasureChest and type(chestTypeArr) == "table" then
    local boxTblList
    if chestTypeArr[1] == EItemBoxTblType.BoxBox then
      boxTblList = ClientTable.cfg_Box_boxManager:GetTabListByIdAndCondition(chestTypeArr[2])
      table.sort(boxTblList, function(a, b)
        return a.layer < b.layer
      end)
    elseif chestTypeArr[1] == EItemBoxTblType.CommerceGoldenBox then
      boxTblList = ClientTable.cfg_Commerce_goldenboxManager:GetTabListByIdAndCondition(chestTypeArr[2])
      table.sort(boxTblList, function(a, b)
        return a.weight < b.weight
      end)
    end
    if table.count(boxTblList) <= 0 then
      return
    end
    tips.Scroll_BagInfo:SetActive(true)
    local x = tips.Scroll_BagInfo:GetAnchoredPosition()
    tips.Scroll_BagInfo:SetAnchoredPosition(x, -tips.centerHeight)
    local w, h = tips.Scroll_BagInfo:GetSizeDelta()
    tips.centerHeight = tips.centerHeight + h + self.minSpaceLine
    local customDataList = {}
    for i, boxTbl in ipairs(boxTblList) do
      local customData = {}
      customData.itemId = boxTbl.itemId
      customData.count = boxTbl.count
      
      function customData.clickCallBack(itemCellData)
        self:btn_3DItemOnClick(itemCellData)
      end
      
      table.insert(customDataList, customData)
    end
    tips.btn_3DItemContainer:SetData(customDataList)
  end
end

function Tip_ItemTipTwoUI:btn_3DItemOnClick(itemCellData)
  if itemCellData.itemData.tblItem.type == EItemType.TreasureChest and type(itemCellData.itemData.tblItem.chestType) == "table" then
    for _, tips in pairs(self.tipsTbl) do
      self:ReSet(tips)
      self:CloseMounModle(tips)
    end
    self.go_obtain:SetActive(false)
    self.showContrastTips = false
    self.args.item = itemCellData.itemData
    self.args.rightOperate = EItemOperateType.Show
    self:Refresh()
  else
    self:ReSet(self.tipsTbl.contrastTips)
    self:CloseMounModle(self.tipsTbl.contrastTips)
    self.showContrastTips = true
    self.tipsTbl.contrastTips.ItemInfo = itemCellData.itemData
    self:ShowTip(self.tipsTbl.contrastTips)
    self:SetPosition()
  end
end
