Vip_VipUI = class(BaseUI)
Vip_VipUI.layer = UILayer.Panel
Vip_VipUI.orderInLayer = 2
Vip_VipUI.hideType = UIHideType.WaitDestroy
Vip_VipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Vip_VipUI.escClose = UIEscClose.DontClose

function Vip_VipUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_vip/btn_close")
  self.tog_badge = self:GetControl("bg_vip/go_list/tog_badge")
  self.tog_upgrade = self:GetControl("bg_vip/go_list/tog_upgrade")
  self.go_badge = self:GetControl("bg_vip/go_badge")
  self.img_jian = self:GetControl("bg_vip/go_badge/img_jian")
  self.btn_upgrade = self:GetControl("bg_vip/go_badge/btn_upgrade")
  self.img_nowBadge = self:GetControl("bg_vip/go_badge/sw_vvip/Viewport/Content/img_nowBadge")
  self.lab_nowvipPower = self:GetControl("bg_vip/go_badge/sw_vvip/Viewport/Content/img_nowBadge/sw_badgePower/Viewport/Content/lab_nowvipPower")
  self.img_VacantPos = self:GetControl("bg_vip/go_badge/sw_vvip/Viewport/Content/img_VacantPos")
  self.QiJiBuy = self:GetControl("bg_vip/go_badge/QiJiBuy")
  self.btn_QiJiBuy = self:GetControl("bg_vip/go_badge/QiJiBuy/btn_QiJiBuy")
  self.lab_QiJiText = self:GetControl("bg_vip/go_badge/QiJiBuy/btn_QiJiBuy/lab_QiJiText")
  self.btn_QiJiBuyItem = self:GetControl("bg_vip/go_badge/QiJiBuy/btn_QiJiBuyItem")
  self.DiamondBuy = self:GetControl("bg_vip/go_badge/DiamondBuy")
  self.btn_DiamondBuy = self:GetControl("bg_vip/go_badge/DiamondBuy/btn_DiamondBuy")
  self.lab_DiamondText = self:GetControl("bg_vip/go_badge/DiamondBuy/btn_DiamondBuy/lab_DiamondText")
  self.btn_DiamondItem = self:GetControl("bg_vip/go_badge/DiamondBuy/btn_DiamondItem")
  self.img_beToVipTxt = self:GetControl("bg_vip/go_badge/img_beToVipTxt")
  self.go_upgrade = self:GetControl("bg_vip/go_upgrade")
  self.img_levelOne = self:GetControl("bg_vip/go_upgrade/img_levelOne")
  self.img_levelTwo = self:GetControl("bg_vip/go_upgrade/img_levelTwo")
  self.img_levelThree = self:GetControl("bg_vip/go_upgrade/img_levelThree")
  self.img_levelFour = self:GetControl("bg_vip/go_upgrade/img_levelFour")
  self.img_levelFive = self:GetControl("bg_vip/go_upgrade/img_levelFive")
  self.img_levelSix = self:GetControl("bg_vip/go_upgrade/img_levelSix")
  self.btn_levelSix = self:GetControl("bg_vip/go_upgrade/img_levelSix/btn_levelSix")
  self.img_vip_ico = self:GetControl("bg_vip/go_upgrade/img_levelSix/img_vip_ico")
  self.img_vip_title = self:GetControl("bg_vip/go_upgrade/img_levelSix/img_vip_title")
  self.btn_Icon3DItem = self:GetControl("bg_vip/go_upgrade/img_levelSix/btn_Icon3DItem")
  self.Consume_unlock = self:GetControl("bg_vip/go_upgrade/Consume_unlock")
  self.Consumenum = self:GetControl("bg_vip/go_upgrade/Consume_unlock/lab_item/img_isEnabled/Consumenum")
  self.ConsumeItem = self:GetControl("bg_vip/go_upgrade/Consume_unlock/lab_item/ConsumeItem")
  self.btn_exchange = self:GetControl("bg_vip/go_upgrade/Consume_unlock/lab_item/btn_exchange")
  self.btn_Consumeobtain = self:GetControl("bg_vip/go_upgrade/btn_Consumeobtain")
  self.lab_exchange = self:GetControl("bg_vip/go_upgrade/btn_Consumeobtain/lab_exchange")
  self.img_redPointConsume = self:GetControl("bg_vip/go_upgrade/btn_Consumeobtain/img_redPointConsume")
  self.img_Unlock = self:GetControl("bg_vip/go_upgrade/img_Unlock")
  self.btn_Unlockclose = self:GetControl("bg_vip/go_upgrade/img_Unlock/btn_Unlockclose")
  self.lab_UnlockName = self:GetControl("bg_vip/go_upgrade/img_Unlock/lab_UnlockName")
  self.img_UnlockName = self:GetControl("bg_vip/go_upgrade/img_Unlock/img_UnlockName")
  self.lab_vipPower = self:GetControl("bg_vip/go_upgrade/img_Unlock/sw_badgePower/Viewport/Content/lab_vipPower")
  self.unlock = self:GetControl("bg_vip/go_upgrade/img_Unlock/unlock")
  self.isEnablednum = self:GetControl("bg_vip/go_upgrade/img_Unlock/unlock/lab_item/img_isEnabled/isEnablednum")
  self.btn_3DItem = self:GetControl("bg_vip/go_upgrade/img_Unlock/unlock/lab_item/btn_3DItem")
  self.btn_obtain = self:GetControl("bg_vip/go_upgrade/img_Unlock/unlock/lab_item/btn_obtain")
  self.btn_unlock = self:GetControl("bg_vip/go_upgrade/img_Unlock/unlock/btn_unlock")
  self.lab_ManJi = self:GetControl("bg_vip/go_upgrade/img_Unlock/lab_ManJi")
  self.exchange = self:GetControl("exchange")
end

function Vip_VipUI:OnPreLoad()
end

function Vip_VipUI:Init()
  self.NewVipSystemInfo, self.NewVipGroup = CommercializeData.GetNewVipSystemInfo()
  self.lastcount = #self.NewVipGroup
  self.lastcellid = self.NewVipGroup[self.lastcount].id
  self.typecount = #self.NewVipSystemInfo
  self.Cellid = CommercializeEquipCell.Vvip
  self.BronzeFiveStar = self.NewVipGroup[1].id
end

local this = Vip_VipUI

function Vip_VipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function vipPowerCreat(ctr)
end

local function vipPowerRefresh(ctr, _, data, ui)
  local descmian = CommercializeData.GetVviptext(data)
  ctr:SetText(descmian)
end

local function vipPowerbadgeCreat(ctr)
  ctr.btn_Underscore = UIControl(ctr.transform, "btn_Underscore")
end

local function vipPowerbadgeRefresh(ctr, _, data, ui)
  local descmian = CommercializeData.GetVviptext(data)
  ctr:SetText(descmian)
  if _ == data.Jump then
    local mTextGenerator = ctr.btn_Underscore.text.cachedTextGeneratorForLayout
    local mTgSettings = ctr.btn_Underscore.text:GetGenerationSettings(Vector2(0, 0))
    local txtwith = mTextGenerator:GetPreferredWidth("B\225\186\163n \196\145\225\187\147 m\225\187\159: ", mTgSettings) / ctr.btn_Underscore.text.pixelsPerUnit
    local nilwith = mTextGenerator:GetPreferredWidth(" ", mTgSettings) / ctr.btn_Underscore.text.pixelsPerUnit
    local txtcount = math.floor(txtwith / nilwith)
    local niltxt = string.rep(" ", txtcount)
    if string.contains(descmian, "L\195\163nh \196\144\225\187\139a VIP T\225\186\167ng 1") then
      ctr.btn_Underscore:SetText(niltxt .. "___________")
    else
      ctr.btn_Underscore:SetText(niltxt .. "_____________")
    end
    ctr.btn_Underscore:SetActive(true)
    ctr.btn_Underscore:SetOnClick(ui, ui.btn_UnderscoreOnClick)
  else
    ctr.btn_Underscore:SetActive(false)
  end
end

local function img_nowBadCreat(ctr)
  ctr.img_tip_ico = UIControl(ctr.transform, "img_tip_ico")
  ctr.img_title_txt = UIControl(ctr.transform, "img_title_txt")
  ctr.txt_no_star = UIControl(ctr.transform, "txt_no_star")
  ctr.img_not_has_vip = UIControl(ctr.transform, "img_not_has_vip")
  ctr.NoBadge = UIControl(ctr.transform, "NoBadge")
  ctr.StarImage = UIControl(ctr.transform, "StarScroll/Viewport/Content/StarImage")
  ctr.lab_nowvipPower = UIControl(ctr.transform, "sw_badgePower/Viewport/Content/lab_nowvipPower")
end

local function img_nowBadRefresh(ctr, _, data, ui)
  if not ctr.vipPowerContainer then
    ctr.vipPowerContainer = UIContainer(ctr.lab_nowvipPower, ui, vipPowerbadgeCreat, vipPowerbadgeRefresh)
  end
  if not ctr.StarImageContainer then
    ctr.StarImageContainer = UIContainer(ctr.StarImage, ui)
  end
  local open = data.id and true or false
  ctr.img_not_has_vip:SetActive(not open)
  local xaio
  xaio = not open and MaterialUtility.GetGreyMat() or nil
  ctr.img_tip_ico:SetMaterial(xaio)
  ctr.img_title_txt:SetActive(open)
  ctr.txt_no_star:SetActive(open)
  ctr.NoBadge:SetActive(open)
  if not open then
    ctr.vipPowerContainer:SetData({})
    ctr.StarImageContainer:SetData({})
    return
  end
  ui:SetSprite("Atlas_Common", data.item.icon, ctr.img_tip_ico)
  ui:SetSprite("Atlas_Language", data.icon2, ctr.img_title_txt)
  if ui.NewHj and data.id == ui.NewHj.id then
    local DescTbl = {}
    for i, v in pairs(data.descdata) do
      DescTbl[i] = {}
      DescTbl[i] = data.descdata[i]
      DescTbl[i].Jump = tonumber(data.Jumpplace)
    end
    ctr.vipPowerContainer:SetData(DescTbl, false)
    ctr.txt_no_star:SetActive(false)
    ctr.NoBadge:SetActive(false)
    local Star = data.badgeLevel % 5
    Star = Star == 0 and 5 or Star
    local ShowStar = {}
    for i = 1, Star do
      table.insert(ShowStar, {})
    end
    ctr.StarImageContainer:SetData(ShowStar)
  else
    ctr.vipPowerContainer:SetData(data.descdata)
    if ui.NewHj then
      ctr.StarImageContainer:SetData({
        {},
        {},
        {},
        {},
        {}
      })
    else
      ctr.StarImageContainer:SetData({})
    end
  end
end

function Vip_VipUI:InitUI()
  self.modelData = ItemCellData()
  self.ConsumemodelData = ItemCellData()
  self.tog_vvipContainer = UIContainer(self.img_nowBadge, self, img_nowBadCreat, img_nowBadRefresh)
  self.vipPowerContainer = UIContainer(self.lab_vipPower, self, vipPowerCreat, vipPowerRefresh)
  self.BtnLvGrop = {
    self.img_levelOne,
    self.img_levelTwo,
    self.img_levelThree,
    self.img_levelFour,
    self.img_levelFive
  }
  for i, ctr in pairs(self.BtnLvGrop) do
    ctr.Btn_level = UIControl(ctr.transform, "Btn_level")
    ctr.lab_level = UIControl(ctr.transform, "lab_level")
    ctr.img_level_star = UIControl(ctr.transform, "img_level_star")
    ctr.img_vip_title = UIControl(ctr.transform, "img_vip_title")
    ctr.img_level_choose = UIControl(ctr.transform, "img_level_choose")
    ctr.lab_AttributePoints = UIControl(ctr.transform, "lab_AttributePoints")
    ctr.btn_Icon3DItem = UIControl(ctr.transform, "btn_Icon3DItem")
    ctr.Eff_UI_anniutishi05 = UIControl(ctr.transform, "Eff_UI_huijikuang")
    if i ~= 1 then
      ctr.img_line_sun = UIControl(ctr.transform, "img_line_sun")
    end
  end
  self:ShowSubUI(UIID.Vip_exchangeUI, {
    parent = self.exchange.transform
  })
  EventManager.Regist(Event.VipPoint, self.RefreshVipRedPoint)
  self.QiJimodelData = ItemCellData()
  self.DiamondmodelData = ItemCellData()
end

function Vip_VipUI:SixShow()
  self.img_levelSix:GetChild("img_vip_title"):SetMaterial(MaterialUtility.GetGreyMat())
  self.img_levelSix:GetChild("img_line_sun"):SetMaterial(MaterialUtility.GetGreyMat())
  self.img_levelSix:GetChild("img_level_star"):SetMaterial(MaterialUtility.GetGreyMat())
  self.img_levelSix:GetChild("btn_levelSix"):SetMaterial(MaterialUtility.GetGreyMat())
  self.img_levelSix:SetMaterial(MaterialUtility.GetGreyMat())
end

function Vip_VipUI:OnShow()
  self:StartPanelRule()
  self:RegistEvents()
  self:Refresh()
end

function Vip_VipUI:OnHide()
  Vip_VipUI.Pointa, Vip_VipUI.Pointb = nil, nil
  self:UnLoadVipEffectModel()
  self.ZhuanIcon3DItem = nil
end

function Vip_VipUI:OnDestroy()
end

function Vip_VipUI:Update()
  if self.ZhuanIcon3DItem and self.ZhuanIcon3DItem.model then
    local obj = self.ZhuanIcon3DItem.model.modelObject
    RoleEquipUtility.EquipModelRotation(obj, 0, 2)
  end
end

function Vip_VipUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_upgrade:SetOnClick(self, self.btn_upgradeOnClick)
  self.btn_exchange:SetOnClick(self, self.btn_exchangeOnClick)
  self.btn_obtain:SetOnClick(self, self.btn_obtainOnClick)
  self.btn_unlock:SetOnClick(self, self.btn_unlockOnClick)
  self.btn_Consumeobtain:SetOnClick(self, self.btn_unlockOnClick)
  self.btn_QiJiBuy:SetOnClick(self, self.btn_BuyOnClick)
  self.btn_DiamondBuy:SetOnClick(self, self.btn_BuyOnClick)
  self.btn_Unlockclose:SetOnClick(self, self.btn_UnlockcloseOnClick)
  self.btn_levelSix:SetOnClick(self, self.img_levelSixOnClick)
  self.tog_badge:SetOnToggleChanged(self, self.tog_badgeOnChanged)
  self.tog_upgrade:SetOnToggleChanged(self, self.tog_upgradeOnChanged)
end

function Vip_VipUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Vip_VipUI)
end

function Vip_VipUI:btn_upgradeOnClick(control)
  self.tog_upgrade:SetIsOn(true)
end

function Vip_VipUI:btn_UnlockcloseOnClick(control)
  self.img_Unlock:SetActive(false)
end

function Vip_VipUI:img_levelSixOnClick()
  local data = self.btn_Icon3DItem.data
  self.btn_Icon3DItem.itemData = ItemUtility.GenerateItemData(data.id)
  ItemUtility.ClickItemBtn(_, self.btn_Icon3DItem)
  if self.ZhuanIcon3DItem then
    self.ZhuanIcon3DItem.model.modelObject.transform.localEulerAngles = ItemUtility.GetModelTransformInfo(self.ZhuanIcon3DItem.itemData).rota
  end
  self.ZhuanIcon3DItem = self.btn_Icon3DItem.itemCellData
end

function Vip_VipUI:btn_UnderscoreOnClick()
  local composeJumpParam = ParseUtility.ParseId(GlobalConfig.VIPMapNpc)
  PathFinderManager.FlyTransferScene(composeJumpParam[1], nil, {
    npcId = composeJumpParam[2]
  }, Purpose.ClickNpc, function()
    self:btn_closeOnClick()
    UIManager.Show(UIID.Instance_BossHouseUI, {
      npcConfigID = composeJumpParam[2],
      index = composeJumpParam[1],
      vipUI = true
    })
  end)
end

function Vip_VipUI:btn_levelOnClick(control)
  local data = control.data
  control.itemData = ItemUtility.GenerateItemData(data.id)
  ItemUtility.ClickItemBtn(_, control)
  if self.ZhuanIcon3DItem then
    self.ZhuanIcon3DItem.model.modelObject.transform.localEulerAngles = ItemUtility.GetModelTransformInfo(self.ZhuanIcon3DItem.itemData).rota
  end
  self.ZhuanIcon3DItem = control.Icon3DItem.itemCellData
end

function Vip_VipUI:ShowConsumeBut()
  local nextData = CommercializeData.GetNextNewVIPInfo()
  if nextData then
    local a1 = BagInfoData.GetItemCountByItemConfigId(ECoinsType.VipEssence)
    local recharge = ClientTable.cfg_Item_buyManager:TryGetValue(nextData.shopId, "id")
    if not recharge then
      return
    end
    local costData = string.split(recharge.cost, "#")
    local cost = tonumber(costData[2])
    local text
    if a1 < cost then
      text = string.format("<color=#FF2323>%s/%s</color>", a1, cost)
      self.btn_Consumeobtain:SetMaterial(MaterialUtility.GetGreyMat())
      self.img_redPointConsume:SetActive(false)
    else
      text = string.format("<color=#1Add1F>%s/%s</color>", a1, cost)
      self.btn_Consumeobtain:SetMaterial(nil)
      self.img_redPointConsume:SetActive(not self.NewHj or self.NewHj.id ~= self.lastcellid)
    end
    self.Consumenum:SetText(text)
    local itemid = tonumber(costData[1])
    local itemData = ItemUtility.GenerateItemData(itemid)
    self.ConsumemodelData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.ConsumeItem, self.ConsumemodelData, self, true)
    self.btn_Consumeobtain.moneyitem = itemid
    self.btn_Consumeobtain.mun = cost
    self.btn_Consumeobtain.shopId = nextData.shopId
    self.Consume_unlock:SetActive(true)
    self.btn_Consumeobtain:SetActive(true)
  else
    self.Consume_unlock:SetActive(false)
    self.btn_Consumeobtain:SetActive(false)
  end
end

function Vip_VipUI:btn_levelOnClickII(control)
  self.levelcontrol = control
  local data = control.data
  self:SetSprite("Atlas_Language", data.icon2, self.img_UnlockName)
  self.lab_UnlockName:SetText(data.badgeLord)
  local info = CommercializeData.NewVvipLvInfoFun(data.subType, control._)
  self.vipPowerContainer:SetData(info.descdata)
  self.lab_ManJi:SetActive(false)
  if not self.VvipBuyCell or self.VvipBuyCell.itemId < data.id then
    local recharge = ClientTable.cfg_Item_buyManager:TryGetValue(data.shopId, "id")
    if not recharge then
      if not string.isNullOrEmpty(data.activation) then
        local ShopId = tonumber(string.split(data.activation, "#")[1])
        recharge = ClientTable.cfg_Item_buyManager:TryGetValue(ShopId, "id")
      else
        logError("Huy Hi\225\187\135u \196\144\225\187\147ng \225\187\159 giao di\225\187\135n T\196\131ng c\225\186\165p VIP v\225\186\171n ch\198\176a t\196\131ng \196\145\225\186\191n 5 sao")
        return
      end
    end
    local cost = string.split(recharge.cost, "#")
    local moneyitem = tonumber(cost[1])
    local mun = tonumber(cost[2])
    local itemData = ItemUtility.GenerateItemData(moneyitem)
    self.modelData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.btn_3DItem, self.modelData, self, true)
    local count = BagInfoData.GetItemTotalCountByItemId(moneyitem)
    local text
    if mun > count then
      text = string.format("<color=#FF2323>%s/%s</color>", count, mun)
      self:SetSprite("Atlas_Common", "ty_btn_short_grey", self.btn_unlock)
    else
      text = string.format("<color=#1Add1F>%s/%s</color>", count, mun)
      self:SetSprite("Atlas_Common", "ty_btn_short3_new", self.btn_unlock)
    end
    self.isEnablednum:SetText(text)
    self.unlock:SetActive(true)
    self.btn_unlock.moneyitem = moneyitem
    self.btn_unlock.mun = mun
    self.btn_unlock.shopId = data.shopId
    self.btn_unlock.data = control
  else
    self.unlock:SetActive(false)
    self.lab_ManJi:SetActive(data.id == self.lastcellid)
  end
  self.img_Unlock:SetActive(true)
end

function Vip_VipUI:btn_obtainOnClick()
  UIManager.Show(UIID.Vip_exchangeUI, {Open = true})
end

function Vip_VipUI:btn_exchangeOnClick(control)
  UIManager.Show(UIID.Vip_exchangeUI, {Open = true})
end

function Vip_VipUI:btn_unlockOnClick(control)
  if self.NewHj and self.NewHj.id == self.lastcellid then
    FloatingTipUtility.QuickMsg("Vip \196\145\195\163 t\196\131ng \196\145\225\186\191n \196\145\225\186\167y c\225\186\165p")
    return
  end
  if BagInfoData.GetItemTotalCountByItemId(control.moneyitem) < control.mun then
    FloatingTipUtility.QuickMsg("Tinh Hoa VIP kh\195\180ng \196\145\225\187\167")
    return
  end
  EventManager.Dispatch(Event.Fuc_Refresh)
  NetManager.Send(ItemBuyMessage.ReqBuy, {
    goodId = control.shopId,
    buyCount = 1
  })
end

local function PrompOK(okArgs)
  if okArgs.BagCount < okArgs.ctr.mun then
    FloatingTipUtility.QuickMsg("S\225\187\145 l\198\176\225\187\163ng kh\195\180ng \196\145\225\187\167")
  else
    Vip_VipUI.args = nil
    Vip_VipUI.Pointa, Vip_VipUI.Pointb = nil, nil
    NetManager.Send(ItemBuyMessage.ReqBuy, {
      goodId = okArgs.ctr.shopId,
      buyCount = 1
    })
  end
  UIManager.Hide(UIID.PromptTipUI)
end

function Vip_VipUI:btn_BuyOnClick(control)
  local bindCount = BagInfoData.GetItemTotalCountByItemId(control.moneyitem)
  local money = EBindCoinsType[control.moneyitem] == ECoinsType.integral and "HuiYuanJiHuo_1" or "HuiYuanJiHuo_2"
  local counttext
  if bindCount < control.mun then
    if EBindCoinsType[control.moneyitem] == ECoinsType.gem then
      RechargeData.BuyDiamond(BusinessPayType.Vvip)
      return
    end
    counttext = string.format("<color=#FF2323>%s/%s</color>", bindCount, control.mun)
  else
    counttext = string.format("<color=#1Add1F>%s</color>", control.mun)
  end
  local PrompText = string.format(LocalizationUtility.GetContentByKey(money), counttext)
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = PrompText,
    ok = PrompOK,
    okArgs = {
      BagCount = bindCount,
      ctr = control,
      ui = self
    }
  })
end

function Vip_VipUI:tog_badgeOnChanged(control, ison)
  if ison then
    self:StartPanelRule()
    self:RefreshHjData()
    self:RefreshHjTog()
  end
  self.go_badge:SetActive(ison)
end

function Vip_VipUI:RefreshHjData()
  self.NewHj = nil
  self.LastHj = nil
  local data = RoleManager.me.data.equipsData.Data
  self.VvipBuyCell = data[self.Cellid] and data[self.Cellid] or nil
  local indexgrop = {}
  if self.VvipBuyCell == nil then
    indexgrop.now = 1
    self.VvipShowInfo = CommercializeData.NewVvipInfoFun(indexgrop)
    return
  end
  if self.lastcellid == self.VvipBuyCell.itemId then
    self.NewHj = self.NewVipGroup[self.lastcount]
    indexgrop.now = self.lastcount
    self.VvipShowInfo = CommercializeData.NewVvipInfoFun(indexgrop)
    return
  end
  local last, lastchapterid
  for i, v in pairs(self.NewVipGroup) do
    if self.VvipBuyCell.itemId == v.id then
      self.NewHj = v
      last = i + 1
      if self.typecount == v.subType then
        indexgrop.now = i
        if self.VvipBuyCell.itemId ~= self.lastcellid then
          indexgrop.chapter = #self.NewVipGroup
        end
        self.VvipShowInfo = CommercializeData.NewVvipInfoFun(indexgrop)
        return
      end
      last = v.subType + 1
      lastchapterid = self.NewVipSystemInfo[last][1].id
      indexgrop.now = i
    end
    if last == i then
      self.LastHj = v
    end
    if lastchapterid == v.id then
      local differ = (indexgrop.now - 1) % 5 == 0 and 4 or -1
      indexgrop.chapter = i + differ
      self.VvipShowInfo = CommercializeData.NewVvipInfoFun(indexgrop)
      break
    end
  end
end

function Vip_VipUI:RefreshHjTog()
  local open = self.NewHj and self.NewHj.id ~= self.lastcellid and true or false
  self.img_jian:SetActive(open)
  if self.NewHj and self.img_VacantPosNil then
    self.img_VacantPosNil:SetActive(false)
  end
  self.tog_vvipContainer:SetData(self.VvipShowInfo)
  if self.NewHj then
    self.btn_upgrade:SetActive(self.NewHj.id ~= self.lastcellid)
  else
    self.btn_upgrade:SetActive(false)
  end
  if not self.NewHj then
    if not self.img_VacantPosNil then
      self.img_VacantPos:SetActive(true)
      local Content = UIControl(self.go_badge.transform, "sw_vvip/Viewport/Content")
      local item
      local go = self.img_VacantPos:Instantiate(Content.transform, Content)
      go.name = self.img_VacantPos.gameObject.name
      item = UIControl()
      item.transform = go.transform
      self.img_VacantPosNil = item
    else
      self.img_VacantPosNil:SetActive(true)
    end
  end
  self.img_VacantPos:SetActive(false)
end

function Vip_VipUI:tog_upgradeOnChanged(control, ison)
  if ison then
    self:RefreshLvData()
    self:RefreshLvTog()
  end
  self.go_upgrade:SetActive(ison)
end

function Vip_VipUI:RefreshLvData()
  if self.NewHj then
    local subType = self.NewHj.subType
    local Showdata = self.NewVipSystemInfo[subType]
    local maxindex = #self.NewVipSystemInfo[subType]
    local lastid = Showdata[maxindex].id
    if self.NewHj.id == lastid then
      if subType == self.typecount then
        self.LVShowdata = self.NewVipSystemInfo[subType]
      else
        subType = subType + 1
        self.LVShowdata = self.NewVipSystemInfo[subType]
      end
    else
      self.LVShowdata = self.NewVipSystemInfo[subType]
    end
  else
    self.LVShowdata = self.NewVipSystemInfo[1]
  end
end

local function newEffFun(Coind, data)
  if Coind then
    local recharge = ClientTable.cfg_Item_buyManager:TryGetValue(data.shopId, "id")
    if not recharge then
      if not string.isNullOrEmpty(data.activation) then
        local ShopId = tonumber(string.split(data.activation, "#")[1])
        recharge = ClientTable.cfg_Item_buyManager:TryGetValue(ShopId, "id")
      else
        return false
      end
    end
    local cost = string.split(recharge.cost, "#")
    local moneyitem = tonumber(cost[1])
    local mun = tonumber(cost[2])
    local count = BagInfoData.GetItemTotalCountByItemId(moneyitem)
    return mun <= count
  end
  return false
end

local function SetVipEffectModel(go, parent, scale)
  local scale = this.effectscale
  go:SetLayer(UI_LAYER)
  if go.transform:Find("smdimport") then
    local smdimport = go.transform:Find("smdimport")
    if smdimport:GetComponent(typeof(UnityEngineLua.SkinnedMeshRenderer)) then
      smdimport:GetComponent(typeof(UnityEngineLua.SkinnedMeshRenderer)).sortingOrder = 500
    elseif smdimport:GetComponent(typeof(UnityEngineLua.MeshRenderer)) then
      smdimport:GetComponent(typeof(UnityEngineLua.MeshRenderer)).sortingOrder = 500
    end
  end
  go.transform:SetParent(parent, false)
  go.transform.localPosition = Vector3.zero
  go.transform.localEulerAngles = Vector3.zero
  go.transform.localScale = Vector3(scale, scale, scale)
end

function Vip_VipUI:LoadVipEffectModel(path, parent)
  if self.effectObjPath ~= path then
    if self.effectModel and self.effectModel.modelObject then
      self.effectModel.modelObject.transform.localScale = Vector3.one
      PoolManagerTest.Recycle(ResourceTypeEnum.Effect_UI, ResourceConfig.GetPrefabName(self.effectObjPath), self.effectModel.modelObject)
      self.effectModel:RemoveModelObj()
      self.effectModel = nil
    elseif self.effectObj then
      PoolManagerTest.Recycle(ResourceTypeEnum.Effect_UI, ResourceConfig.GetPrefabName(self.effectObjPath), self.effectObj)
      self.effectObj = nil
    end
  end
  self.effectObjPath = path
  if not self.effectModel then
    self.effectModel = CS.Framework.GameModel(parent.gameObject, function(go, name)
      SetVipEffectModel(go, parent)
    end)
  end
  if self.effectModel.modelObject then
    SetVipEffectModel(self.effectModel.modelObject, parent)
  else
    self.effectObj = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_UI, path)
    if self.effectObj then
      SetVipEffectModel(self.effectObj, parent)
    else
      self.effectModel:LoadAsync(path)
      self.effectModel:SetLayer(UI_LAYER)
    end
  end
end

function Vip_VipUI:UnLoadVipEffectModel()
  if self.effectModel then
    if self.effectModel.modelObject then
      self.effectModel.modelObject.transform.localScale = Vector3.one
      PoolManagerTest.Recycle(ResourceTypeEnum.Effect_UI, ResourceConfig.GetPrefabName(self.effectObjPath), self.effectModel.modelObject)
    end
    self.effectModel:RemoveModelObj()
    self.effectModel = nil
  end
  if self.effectObj then
    PoolManagerTest.Recycle(ResourceTypeEnum.Effect_UI, ResourceConfig.GetPrefabName(self.effectObjPath), self.effectObj)
    self.effectObj = nil
  end
  self.effectObjPath = nil
end

function Vip_VipUI:LoadVIPModel(ctr, data)
  local itemdata = ItemUtility.GenerateItemData(data.id)
  if not ctr.itemCellData then
    ctr.itemCellData = ItemCellData()
  end
  ctr.itemCellData:RefreshData(itemdata)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, self, true)
end

function Vip_VipUI:ShowLvitem(ctr, _, data)
  ctr.lab_level:SetText(data.badgeLord)
  if not data.item then
    data.item = ClientTable.cfg_Item_itemManager:TryGetValue(data.id)
  end
  self:LoadVIPModel(ctr.btn_Icon3DItem, data)
  self:SetSprite("Atlas_Language", data.icon2, ctr.img_vip_title)
  if self.NewHj then
    local lastid = self.NewHj.id + 1
    local open = lastid >= data.id and true or false
    local ZhiHui = not open and MaterialUtility.GetGreyMat() or nil
    local teixoa = not self.VvipBuyCell or self.VvipBuyCell.itemId < data.id
    local xaio
    if ZhiHui then
      xaio = ZhiHui
    else
      xaio = teixoa and MaterialUtility.GetGreyMat() or nil
    end
    ctr.Btn_level:SetMaterial(ZhiHui)
    ctr:SetMaterial(xaio)
    ctr.img_level_choose:SetMaterial(ZhiHui)
    local newEff = newEffFun(not ZhiHui and teixoa, data)
    ctr.Eff_UI_anniutishi05:SetActive(newEff)
    ZhiHui = not xaio and xaio or not newEff and xaio or nil
    ctr.img_vip_title:SetMaterial(ZhiHui)
    ctr.img_level_star:SetMaterial(ZhiHui)
    ctr.lab_level:SetMaterial(ZhiHui)
    if ctr.img_line_sun then
      ctr.img_line_sun:SetMaterial(ZhiHui)
    end
    if lastid == data.id then
      local Attri = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Vippoints")
      Attri = string.format(Attri, data.points)
      ctr.lab_AttributePoints:SetText(Attri)
      ctr.lab_AttributePoints:SetActive(true)
    else
      ctr.lab_AttributePoints:SetActive(false)
    end
  else
    local open = _ == 1 and true or false
    ctr.Btn_level:SetInteractable(open)
    local ZhiHui = not open and MaterialUtility.GetGreyMat() or nil
    local teixoa = not self.VvipBuyCell or self.VvipBuyCell.itemId < data.id
    local xaio
    if ZhiHui then
      xaio = ZhiHui
    else
      xaio = teixoa and MaterialUtility.GetGreyMat() or nil
    end
    ctr.Btn_level:SetMaterial(ZhiHui)
    ctr.img_level_choose:SetMaterial(ZhiHui)
    local newEff = newEffFun(not ZhiHui and teixoa, data)
    ctr.Eff_UI_anniutishi05:SetActive(newEff)
    ZhiHui = not xaio and xaio or not newEff and xaio or nil
    ctr:SetMaterial(xaio)
    ctr.img_vip_title:SetMaterial(ZhiHui)
    ctr.img_level_star:SetMaterial(ZhiHui)
    ctr.lab_level:SetMaterial(ZhiHui)
    if ctr.img_line_sun then
      ctr.img_line_sun:SetMaterial(ZhiHui)
    end
    local Attri = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Vippoints")
    Attri = string.format(Attri, data.points)
    ctr.lab_AttributePoints:SetText(Attri)
    ctr.lab_AttributePoints:SetActive(true)
  end
  ctr.Btn_level.data = data
  ctr.Btn_level._ = _
  ctr.Btn_level.Icon3DItem = ctr.btn_Icon3DItem
  ctr.Btn_level:SetOnClick(self, self.btn_levelOnClick)
end

function Vip_VipUI:RefreshLvTog()
  for i, v in pairs(self.BtnLvGrop) do
    local lvdata = self.LVShowdata[i]
    if lvdata then
      self:ShowConsumeBut()
      self:ShowLvitem(v, i, lvdata)
    end
  end
  local lastdata = self.LVShowdata[#self.LVShowdata]
  local lastid = lastdata.id + 1
  local lastShowData
  for i, v in pairs(self.NewVipGroup) do
    if v.id == lastid then
      lastShowData = v
      break
    end
  end
  if lastShowData then
    if not lastShowData.item then
      lastShowData.item = ClientTable.cfg_Item_itemManager:TryGetValue(lastShowData.id)
    end
    self:SetSprite("Atlas_Language", lastShowData.icon2, self.img_vip_title)
    self.btn_Icon3DItem.data = lastShowData
    self:LoadVIPModel(self.btn_Icon3DItem, lastShowData)
    local path = string.format("Effect/UI/%s.prefab", lastShowData.effectName)
    self.effectscale = tonumber(lastShowData.effectScale) * 2.5
    if self.effectObjPath ~= path then
      self:LoadVipEffectModel(path, self.btn_Icon3DItem.transform)
    end
    self:SixShow()
    self.img_levelSix:SetActive(true)
  else
    self.img_levelSix:SetActive(false)
  end
  if self.NewHj and self.NewHj.id == self.lastcellid then
    self.btn_exchange:SetActive(false)
  else
    self.btn_exchange:SetActive(true)
  end
end

function Vip_VipUI:RegistEvents()
  self:RegistEvent(Event.Commer_NewVip, self.Commer_NewVipFun, self)
  self:RegistEvent(Event.PutOnEquip, self.OnResEquipChange, self)
  self:RegistEvent(Event.TakeOffEquip, self.TakeOffEquipFunc, self)
end

function Vip_VipUI:Commer_NewVipFun(_, data)
  if data == self.BronzeFiveStar then
    return
  end
  if self.go_upgrade.gameObject.activeSelf then
    self:RefreshHjData()
    self:tog_upgradeOnChanged(nil, true)
  end
end

function Vip_VipUI:OnResEquipChange(_, data)
  if data.itemId == self.BronzeFiveStar then
    self.tog_badge:SetIsOn(false)
    self.tog_badge:SetIsOn(true)
    return
  end
  if data.itemId % 5 == 1 then
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {
        name = "Eff_UI_huiyuandengjitisheng",
        time = 1
      })
    else
      UIManager.Show(UIID.EffectTipUI, {
        name = "Eff_UI_huiyuandengjitisheng",
        effectTime = 1
      })
    end
  end
  if self.Cellid == data.bagGridIndex then
    self:RefreshHjData()
    self:tog_upgradeOnChanged(nil, true)
  end
end

function Vip_VipUI:TakeOffEquipFunc(_, data)
  if data.itemId == self.BronzeFiveStar then
    return
  end
  if self.Cellid == data.bagGridIndex then
    self:RefreshHjData()
    self:tog_upgradeOnChanged(nil, true)
  end
end

function Vip_VipUI:RefreshVipRedPoint(bool, OpenType)
  local a = false
  local b = false
  if not OpenType and Vip_VipUI.root and Vip_VipUI.root.gameObject.activeSelf then
    if bool and (bool.a or bool.b) then
      if Vip_VipUI.tog_upgrade.gameObject.activeSelf then
        if Vip_VipUI.go_upgrade.gameObject.activeSelf then
          Vip_VipUI.tog_upgrade:SetIsOn(false)
        end
        Vip_VipUI.tog_upgrade:SetIsOn(true)
      else
        Vip_VipUI:StartPanelRule()
      end
    elseif (Vip_VipUI.args and Vip_VipUI.args.red and Vip_VipUI.args.red.a or Vip_VipUI.Pointa and Vip_VipUI.Pointb) and Vip_VipUI.tog_upgrade.gameObject.activeSelf then
      if Vip_VipUI.go_upgrade.gameObject.activeSelf then
        Vip_VipUI.tog_upgrade:SetIsOn(false)
      end
      Vip_VipUI.tog_upgrade:SetIsOn(true)
    end
  end
  if Vip_VipUI.args and Vip_VipUI.args.red then
    if Vip_VipUI.Pointa and Vip_VipUI.Pointb then
      Vip_VipUI.args.red.a = Vip_VipUI.Pointa
      Vip_VipUI.args.red.b = Vip_VipUI.Pointb
    end
    a = Vip_VipUI.args.red.a
    b = Vip_VipUI.args.red.b
  end
  if bool ~= nil then
    a = bool.a
    b = bool.b
  end
  Vip_VipUI.Pointa, Vip_VipUI.Pointb = a, b
  UIControl(Vip_VipUI.tog_upgrade.transform, "img_redPointfunc"):SetActive(a)
  UIControl(Vip_VipUI.btn_exchange.transform, "img_redPointfunc"):SetActive(b)
end

function Vip_VipUI:Refresh()
  self.tog_badge:SetIsOn(false)
  self.tog_upgrade:SetIsOn(false)
  local OpenType
  if self.args then
    OpenType = self.args.OpenType
    if OpenType == 1 then
      self.tog_badge:SetIsOn(true)
    elseif OpenType == 2 then
      self.tog_upgrade:SetIsOn(true)
    else
      self.tog_badge:SetIsOn(true)
    end
  else
    self.tog_badge:SetIsOn(true)
  end
  self:RefreshVipRedPoint(nil, OpenType)
end

function Vip_VipUI:ShowConditionJump()
  local data = RoleManager.me.data.equipsData.Data
  local Cell = data[self.Cellid] and data[self.Cellid] or nil
  if Cell and Cell.itemId >= self.BronzeFiveStar then
    return false
  else
    return true
  end
end

function Vip_VipUI:StartPanelRule()
  local NewVipCondition = self:ShowConditionJump()
  self.QiJiBuy:SetActive(NewVipCondition)
  self.DiamondBuy:SetActive(NewVipCondition)
  self.img_beToVipTxt:SetActive(NewVipCondition)
  self.tog_upgrade:SetActive(not NewVipCondition)
  if NewVipCondition then
    local BronzeFiveStar = self.NewVipGroup[1]
    local ShopIdGrop = string.split(BronzeFiveStar.activation, "#")
    local QiJi = ClientTable.cfg_Item_buyManager:TryGetValue(tonumber(ShopIdGrop[1]), "id")
    local QiJicost = string.split(QiJi.cost, "#")
    local QiJimoneyitem = tonumber(QiJicost[1])
    local QiJimun = tonumber(QiJicost[2])
    self.btn_QiJiBuy.moneyitem = QiJimoneyitem
    self.btn_QiJiBuy.mun = QiJimun
    self.btn_QiJiBuy.shopId = tonumber(ShopIdGrop[1])
    self.btn_QiJiBuy.data = {
      _ = 5,
      id = self.BronzeFiveStar
    }
    local QiJiitemData = ItemUtility.GenerateItemData(EBindCoinsType[QiJimoneyitem])
    self.QiJimodelData:RefreshData(QiJiitemData)
    ItemUtility.ShowItemCell(self.btn_QiJiBuyItem, self.QiJimodelData, self, true)
    local BagCount1 = BagInfoData.GetItemTotalCountByItemId(QiJimoneyitem)
    local color1 = "#FBD994"
    if QiJimun > BagCount1 then
      if self.btn_QiJiBuyEff then
        self.btn_QiJiBuyEff:SetActive(false)
      end
      color1 = "#FF2323"
    elseif self.btn_QiJiBuyEff then
      self.btn_QiJiBuyEff:SetActive(true)
    else
      self.btn_QiJiBuyEff = UIEffectUtility.SetUIEffect("Eff_UI_annuikuang03", self.btn_QiJiBuy, true, Vector2(1.7, 1.5))
    end
    self.lab_QiJiText:SetText(string.GetColorText(QiJimun, color1))
    local Diamond = ClientTable.cfg_Item_buyManager:TryGetValue(tonumber(ShopIdGrop[2]), "id")
    local Diamondcost = string.split(Diamond.cost, "#")
    local Diamondmoneyitem = tonumber(Diamondcost[1])
    local Diamondmun = tonumber(Diamondcost[2])
    self.btn_DiamondBuy.moneyitem = Diamondmoneyitem
    self.btn_DiamondBuy.mun = Diamondmun
    self.btn_DiamondBuy.shopId = tonumber(ShopIdGrop[2])
    self.btn_DiamondBuy.data = {
      _ = 5,
      id = self.BronzeFiveStar
    }
    local itemData = ItemUtility.GenerateItemData(EBindCoinsType[Diamondmoneyitem])
    self.DiamondmodelData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.btn_DiamondItem, self.DiamondmodelData, self, true)
    local BagCount2 = BagInfoData.GetItemTotalCountByItemId(Diamondmoneyitem)
    local color2 = "#FBD994"
    if Diamondmun > BagCount2 then
      if self.btn_DiamonBuyEff then
        self.btn_DiamonBuyEff:SetActive(false)
      end
      color2 = "#FF2323"
    elseif self.btn_DiamonBuyEff then
      self.btn_DiamonBuyEff:SetActive(true)
    else
      self.btn_DiamonBuyEff = UIEffectUtility.SetUIEffect("Eff_UI_annuikuang03", self.btn_DiamondBuy, true, Vector2(1.7, 1.5))
    end
    self.lab_DiamondText:SetText(string.GetColorText(Diamondmun, color2))
  end
end
