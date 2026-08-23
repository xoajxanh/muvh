MasterSkill_detailUI = class(BaseUI)
MasterSkill_detailUI.layer = UILayer.Panel
MasterSkill_detailUI.orderInLayer = 0
MasterSkill_detailUI.hideType = UIHideType.WaitDestroy
MasterSkill_detailUI.hideFunc = UIHideFunc.MoveOutOfScreen
MasterSkill_detailUI.escClose = UIEscClose.DontClose

function MasterSkill_detailUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_MasterSkill/btn_close")
  self.panel_bg = self:GetControl("panel_main/panel_bg")
  self.panel_talent_tab = self:GetControl("panel_main/panel_bg/panel_talent_tab")
  self.panel_skilldetail = self:GetControl("panel_main/panel_bg/panel_talent_tab/Viewport/panel_skilldetail")
  self.masterSkill = self:GetControl("panel_main/panel_bg/panel_talent_tab/Viewport/panel_skilldetail/masterSkill")
  self.remainingPoints = self:GetControl("panel_main/tipPoints/remainingPoints")
  self.sl_alpha = self:GetControl("panel_main/panel_down/addExp/go_alpha/sl_alpha")
  self.expCount = self:GetControl("panel_main/panel_down/addExp/go_alpha/expCount")
  self.levelCount = self:GetControl("panel_main/panel_down/addExp/masterLevel/levelCount")
  self.resetPoints = self:GetControl("panel_main/panel_down/addExp/resetPoints")
  self.addExp = self:GetControl("panel_main/panel_down/addExp")
  self.panel_before = self:GetControl("panel_main/panel_before")
  self.skillDesc = self:GetControl("panel_main/panel_before/skillDesc")
  self.tab_talent = self:GetControl("panel_main/panel_tab/tab_talent")
  self.titleName = self:GetControl("panel_main/panel_tab/tab_talent/titleName")
  self.occupationIco = self:GetControl("panel_main/panel_tab/tab_talent/icoBg/occupationIco")
  self.panel_reset = self:GetControl("panel_reset")
  self.resetPointPanelClose = self:GetControl("panel_reset/resetPointPanelClose")
  self.btn_resetPointPanelClose = self:GetControl("panel_reset/btn_resetPointPanelClose")
  self.lab_resPointValue = self:GetControl("panel_reset/lab_resPoint/lab_resPointValue")
  self.lab_resPointValue2 = self:GetControl("panel_reset/lab_resPoint2/lab_resPointValue2")
  self.btn_get2 = self:GetControl("panel_reset/lab_price/btn_get2")
  self.consumeItem = self:GetControl("panel_reset/lab_price/consumeItem")
  self.lab_priceValue = self:GetControl("panel_reset/lab_price/lab_priceValue")
  self.cancelBtn = self:GetControl("panel_reset/cancelBtn")
  self.confirmBtn = self:GetControl("panel_reset/confirmBtn")
  self.confirmBtnText = self:GetControl("panel_reset/confirmBtn/Text")
  self.panel_Exp = self:GetControl("panel_Exp")
  self.btn_ExpCloseBg = self:GetControl("panel_Exp/btn_ExpCloseBg")
  self.lab_title = self:GetControl("panel_Exp/bg_vip/lab_title")
  self.btn_ExpClose = self:GetControl("panel_Exp/bg_vip/btn_ExpClose")
  self.lab_exchangeNum = self:GetControl("panel_Exp/bg_vip/lab_exchangeNum")
  self.go_exchangeMode = self:GetControl("panel_Exp/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode")
  self.btn_SmallItem = self:GetControl("panel_Exp/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode/lab_price/btn_SmallItem")
  self.btn_exchangeItem = self:GetControl("panel_Exp/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode/lab_exchange/btn_exchangeItem")
  self.btn_exchange = self:GetControl("panel_Exp/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode/btn_exchange")
  self.img_redPointfunc = self:GetControl("panel_Exp/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode/img_redPointfunc")
  self.panel_skill = self:GetControl("panel_skill")
  self.btn_SkillCloseBg = self:GetControl("panel_skill/btn_SkillCloseBg")
  self.btn_SkillClose = self:GetControl("panel_skill/bg_skillDetail/btn_SkillClose")
  self.skillImg = self:GetControl("panel_skill/bg_skillDetail/skillBg/skillImg")
  self.lab_skillName = self:GetControl("panel_skill/bg_skillDetail/lab_skillName")
  self.skillLevel = self:GetControl("panel_skill/bg_skillDetail/skillLevel")
  self.lab_skillLevel = self:GetControl("panel_skill/bg_skillDetail/skillLevel/lab_skillLevel")
  self.lab_currentLeveL = self:GetControl("panel_skill/bg_skillDetail/upperLevel/levelBg/lab_currentLeveL")
  self.lab_currentSkillTip = self:GetControl("panel_skill/bg_skillDetail/upperLevel/lab_currentSkillTip")
  self.lab_nextLeveL = self:GetControl("panel_skill/bg_skillDetail/nextLevel/levelBg/lab_nextLeveL")
  self.lab_nextSkillTip = self:GetControl("panel_skill/bg_skillDetail/nextLevel/lab_nextSkillTip")
  self.btn_goInput = self:GetControl("panel_skill/bg_skillDetail/btns/btn_goInput")
  self.panel_shop = self:GetControl("panel_shop")
  self.btn_ShopCloseBg = self:GetControl("panel_shop/btn_ShopCloseBg")
  self.btn_ExpCloseShop = self:GetControl("panel_shop/bg_shop/btn_ExpCloseShop")
  self.btn_oncePrice = self:GetControl("panel_shop/bg_shop/go_ship/once/btn_oncePrice")
  self.btn_once = self:GetControl("panel_shop/bg_shop/go_ship/once/btn_once")
  self.btn_foreverPrice = self:GetControl("panel_shop/bg_shop/go_ship/forever/btn_foreverPrice")
  self.btn_forever = self:GetControl("panel_shop/bg_shop/go_ship/forever/btn_forever")
  self.needCount = self:GetControl("panel_skill/bg_skillDetail/needTip/needCount")
end

function MasterSkill_detailUI:Init()
end

function MasterSkill_detailUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function InitExchangeMode(ctr)
  ctr.btn_SmallItem = UIControl(ctr.transform, "lab_price/btn_SmallItem")
  ctr.lab_priceNum = UIControl(ctr.transform, "lab_price/lab_priceNum")
  ctr.btn_exchangeItem = UIControl(ctr.transform, "lab_exchange/btn_exchangeItem")
  ctr.lab_exchangeNum = UIControl(ctr.transform, "lab_exchange/lab_exchangeNum")
  ctr.btn_exchange = UIControl(ctr.transform, "btn_exchange")
  ctr.costCtr = ItemUtility.InitItemCell(UIControl(ctr.btn_SmallItem))
  ctr.modelData = ItemCellData()
  ctr.getCtr = ItemUtility.InitItemCell(UIControl(ctr.btn_exchangeItem))
  ctr.modelData1 = ItemCellData()
end

local function ExchangeModeRefresh(ctr, k, info, ui)
  ctr.lab_priceNum:SetText(info.needItemNum)
  ctr.lab_exchangeNum:SetText(info.getItemNum)
  local itemData = ItemUtility.GenerateItemData(info.needItem)
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  itemData = ItemUtility.GenerateItemData(info.getItem)
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  ctr.btn_exchange:SetOnClick(self, function()
    networkRequest.ReqExchangeGrandMasterExp(info.id)
  end)
end

function MasterSkill_detailUI:InitUI()
  self.skillControl = UIUtility.BindUIContainerTemp(self.masterSkill, LuaComponentTemplates.MasterSkillTemplate, self)
  self.tabControl = UIUtility.BindUIContainerTemp(self.tab_talent, LuaComponentTemplates.MasterTabTalentTemplate, self)
  self.expList = UIContainer(self.go_exchangeMode, self, InitExchangeMode, ExchangeModeRefresh)
  self.resetModelctr = ItemUtility.InitItemCell(UIControl(self.consumeItem))
  self.resetModel = ItemCellData()
  self.changeOnceModelctr = ItemUtility.InitItemCell(UIControl(self.btn_oncePrice))
  self.changeOnceModel = ItemCellData()
  self.changeModelctr = ItemUtility.InitItemCell(UIControl(self.btn_foreverPrice))
  self.changeModel = ItemCellData()
end

function MasterSkill_detailUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.tab_talent:SetOnClick(self, self.tab_talentOnClick)
  self.resetPointPanelClose:SetOnClick(self, self.resetPointPanelCloseOnClick)
  self.btn_resetPointPanelClose:SetOnClick(self, self.btn_resetPointPanelCloseOnClick)
  self.btn_get2:SetOnClick(self, self.btn_get2OnClick)
  self.consumeItem:SetOnClick(self, self.consumeItemOnClick)
  self.cancelBtn:SetOnClick(self, self.cancelBtnOnClick)
  self.confirmBtn:SetOnClick(self, self.confirmBtnOnClick)
  self.btn_ExpCloseBg:SetOnClick(self, self.btn_ExpCloseBgOnClick)
  self.btn_ExpClose:SetOnClick(self, self.btn_ExpCloseOnClick)
  self.btn_SmallItem:SetOnClick(self, self.btn_SmallItemOnClick)
  self.btn_exchangeItem:SetOnClick(self, self.btn_exchangeItemOnClick)
  self.btn_exchange:SetOnClick(self, self.btn_exchangeOnClick)
  self.btn_SkillCloseBg:SetOnClick(self, self.btn_SkillCloseBgOnClick)
  self.btn_SkillClose:SetOnClick(self, self.btn_SkillCloseOnClick)
  self.btn_ShopCloseBg:SetOnClick(self, self.btn_ShopCloseBgOnClick)
  self.btn_ExpCloseShop:SetOnClick(self, self.btn_ExpCloseShopOnClick)
  self.btn_oncePrice:SetOnClick(self, self.btn_oncePriceOnClick)
  self.btn_once:SetOnClick(self, self.btn_onceOnClick)
  self.btn_foreverPrice:SetOnClick(self, self.btn_foreverPriceOnClick)
  self.btn_forever:SetOnClick(self, self.btn_foreverOnClick)
  self.addExp:SetOnClick(self, self.addExpOnClick)
  self.resetPoints:SetOnClick(self, self.resetOnClick)
  self.btn_goInput:SetOnClick(self, self.btn_goInputOnClick)
end

function MasterSkill_detailUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.MasterSkill_detailUI)
end

function MasterSkill_detailUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.MasterSkill_detailUI)
end

function MasterSkill_detailUI:tab_talentOnClick(control)
end

function MasterSkill_detailUI:resetPointPanelCloseOnClick(control)
end

function MasterSkill_detailUI:btn_resetPointPanelCloseOnClick(control)
  self.panel_reset:SetActive(false)
end

function MasterSkill_detailUI:btn_get2OnClick(control)
end

function MasterSkill_detailUI:consumeItemOnClick(control)
end

function MasterSkill_detailUI:cancelBtnOnClick(control)
  self.panel_reset:SetActive(false)
end

function MasterSkill_detailUI:confirmBtnOnClick(control)
  networkRequest.ReqResetGrandMaster()
end

function MasterSkill_detailUI:btn_ExpCloseBgOnClick(control)
  self.panel_Exp:SetActive(false)
end

function MasterSkill_detailUI:btn_ExpCloseOnClick(control)
  self.panel_Exp:SetActive(false)
end

function MasterSkill_detailUI:btn_SmallItemOnClick(control)
end

function MasterSkill_detailUI:btn_exchangeItemOnClick(control)
end

function MasterSkill_detailUI:btn_exchangeOnClick(control)
end

function MasterSkill_detailUI:btn_SkillCloseBgOnClick(control)
  self.panel_skill:SetActive(false)
end

function MasterSkill_detailUI:btn_SkillCloseOnClick(control)
  self.panel_skill:SetActive(false)
end

function MasterSkill_detailUI:btn_goInputOnClick(control)
  networkRequest.ReqUpGrandMasterSkill(QuickFind.MasterSysData().MasterType, QuickFind.MasterSysData().MastertabTemp.id)
end

function MasterSkill_detailUI:btn_ShopCloseBgOnClick(control)
  self.panel_shop:SetActive(false)
end

function MasterSkill_detailUI:btn_ExpCloseShopOnClick(control)
  self.panel_shop:SetActive(false)
end

function MasterSkill_detailUI:btn_oncePriceOnClick(control)
end

function MasterSkill_detailUI:btn_onceOnClick(control)
  networkRequest.ReqEnableGrandMasterTalent(self.tabID, 1)
end

function MasterSkill_detailUI:btn_foreverPriceOnClick(control)
end

function MasterSkill_detailUI:btn_foreverOnClick(control)
  networkRequest.ReqEnableGrandMasterTalent(self.tabID, 2)
end

function MasterSkill_detailUI:addExpOnClick(control)
  self.panel_Exp:SetActive(true)
  self.expList:SetData(QuickFind.MasterSysData():GetExchangeTab())
  self.lab_exchangeNum:SetText(string.format("L\198\176\225\187\163t \196\145\225\187\149i c\195\178n l\225\186\161i h\195\180m nay: <color=#139D29>%d</color>/%d", QuickFind.MasterSysData().MasterExchangeTimes, QuickFind.MasterSysData().MasterExchangeAllTimes))
end

function MasterSkill_detailUI:resetOnClick(control)
  self.panel_reset:SetActive(true)
  local info = QuickFind.MasterSysData():GetResetTab()
  self.confirmBtnText:SetText(string.format("%s", info.num > 0 and "X\195\161c nh\225\186\173n" or "L\225\186\167n \196\145\225\186\167u mi\225\187\133n ph\195\173"))
  local itemData = ItemUtility.GenerateItemData(info.needItem)
  self.resetModel:RefreshData(itemData)
  self.resetModel.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(self.resetModelctr, self.resetModel, self, true)
  self.lab_priceValue:SetActive(info.num)
end

function MasterSkill_detailUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function MasterSkill_detailUI:RegistEvents()
  self:RegistEvent(Event.RefreshMasterData, self.ShowAll, self)
  self:RegistEvent(Event.MasterTipsOpen, self.ShowSkillTips, self)
  self:RegistEvent(Event.MasterTabOpenPay, self.ShowChangePayTips, self)
end

function MasterSkill_detailUI:Refresh()
  networkRequest.ReqGrandMasterInfo()
end

function MasterSkill_detailUI:ShowAll()
  self.tabControl:SetData(QuickFind.MasterSysData():DealTogInfo(), nil, true)
  self:ShowTab(0, QuickFind.MasterSysData().MasterType)
  self.levelCount = QuickFind.MasterSysData().MasterLevel
  local text, process = QuickFind.MasterSysData():GetLevelPro()
  self.expCount:SetText(text)
  self.sl_alpha:SetValue(process)
  self.remainingPoints:SetText(QuickFind.MasterSysData():GetShowPointInfo())
end

function MasterSkill_detailUI:ShowTab(id, type)
  self.skillControl:SetData(QuickFind.MasterSysData():GetShowSkillTabCount(type), nil, true)
end

function MasterSkill_detailUI:ShowSkillTips(id, tableID)
  local skillInfo = QuickFind.MasterSysData():GetSkillInfo(tableID)
  if skillInfo then
    self.skillImg:SetSprite(skillInfo.skillIcon)
    self.lab_skillName:SetText(skillInfo.curName)
    self.lab_skillLevel:SetText(string.format("%d/%d", skillInfo.curLevel, skillInfo.maxLevel))
    self.needCount:SetText(skillInfo.needPoint)
    self.lab_currentSkillTip:SetText(string.format("%s", skillInfo.curLevel > 0 and skillInfo.curDes or "K\225\187\185 N\196\131ng ch\198\176a t\196\131ng c\225\186\165p"))
    self.lab_nextSkillTip:SetText(string.format("%s", skillInfo.maxLevel > skillInfo.curLevel and skillInfo.nextDes or "K\225\187\185 n\196\131ng \196\145\195\163 \196\145\225\186\161t c\225\186\165p t\225\187\145i \196\145a"))
  end
end

function MasterSkill_detailUI:ShowChangePayTips(id, tableID)
  local info = QuickFind.MasterSysData():GetChangeTab(1)
  local itemData = ItemUtility.GenerateItemData(info.needItem)
  itemData.count = info.num
  self.changeOnceModel:RefreshData(itemData)
  self.changeOnceModel.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(self.changeOnceModelctr, self.changeOnceModel, self, true)
  self.btn_once.skillID = tableID
  info = QuickFind.MasterSysData():GetChangeTab(2)
  itemData = ItemUtility.GenerateItemData(info.needItem)
  itemData.count = info.num
  self.changeModel:RefreshData(itemData)
  self.changeModel.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(self.changeModelctr, self.changeModel, self, true)
  self.btn_forever.skillID = tableID
end

function MasterSkill_detailUI:OnHide()
end

function MasterSkill_detailUI:OnDestroy()
end
