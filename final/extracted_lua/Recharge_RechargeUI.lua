Recharge_RechargeUI = class(BaseUI)
Recharge_RechargeUI.layer = UILayer.Panel
Recharge_RechargeUI.orderInLayer = 0
Recharge_RechargeUI.hideType = UIHideType.WaitDestroy
Recharge_RechargeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Recharge_RechargeUI.escClose = UIEscClose.DontClose

function Recharge_RechargeUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.tog_monthCardList = self:GetControl("go_togList/tog_monthCardList")
  self.bg_monthCard = self:GetControl("sw_monthCard/Viewport/Content/bg_monthCard")
  self.img_cardPicture = self:GetControl("sw_monthCard/Viewport/Content/bg_monthCard/img_cardPicture")
  self.lab_monthCardName = self:GetControl("sw_monthCard/Viewport/Content/bg_monthCard/lab_monthCardName")
end

function Recharge_RechargeUI:OnPreLoad()
end

function Recharge_RechargeUI:Init()
end

function Recharge_RechargeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local this = Recharge_RechargeUI
local atlasStr = "atlas_icon"

local function SetItemImage(itemId, ctr)
  local itemData = ItemUtility.GenerateItemData(tonumber(itemId))
  this:SetSprite(atlasStr, itemData.tblItem.icon, ctr)
end

local function OnMonthCardItemCreat(ctr)
  ctr.title = UIControl(ctr.transform, "lab_monthCardName")
  ctr.subTitle = UIControl(ctr.transform, "lab_monthCardDesc")
  ctr.privilegeTitle = UIControl(ctr.transform, "lab_monthCardPrivilege")
  ctr.privilegeContent = UIControl(ctr.transform, "lab_monthCardPrivilege/lab_monthCardPrivilegeDesc")
  ctr.monthCardDay = UIControl(ctr.transform, "lab_monthCardDay/lab_monthCardDayNum")
  ctr.titleImg = UIControl(ctr.transform, "img_cardPicture")
  ctr.btn_buyMonthcard = UIControl(ctr.transform, "btn_buyMonthCard")
  ctr.rmbBuy = UIControl(ctr.transform, "btn_buyMonthCard/lab_buy")
  ctr.otherBuy = UIControl(ctr.transform, "btn_buyMonthCard/img_buy")
  ctr.otherBuy_lab = UIControl(ctr.transform, "btn_buyMonthCard/img_buy/num")
end

local function OnMonthCardItemRefresh(ctr, index, data, ui)
  ctr.title:SetText(data.name)
  SetItemImage(data.id, ctr.titleImg)
  ctr.subTitle:SetText(data.subTitle)
  ctr.privilegeTitle:SetText(data.privilegeTitle)
  ctr.privilegeContent:SetText(data.PrivilegeContent)
  local remainingDays = data.residualDay
  if type(data.costCount) == "number" then
    ctr.rmbBuy.gameObject:SetActive(true)
    ctr.otherBuy.gameObject:SetActive(false)
    ctr.rmbBuy:SetText(string.format("%sVND", math.ceil(data.costCount / 100)))
  else
    local costStr = string.split(data.costCount, "#")
    ctr.otherBuy_lab:SetText(costStr[2])
    if 0 < remainingDays then
      ctr.rmbBuy.gameObject:SetActive(true)
      ctr.otherBuy.gameObject:SetActive(false)
    else
      ctr.rmbBuy.gameObject:SetActive(false)
      SetItemImage(costStr[1], ctr.otherBuy)
    end
  end
  ctr.monthCardDay:SetText(string.format("%d ng\195\160y", remainingDays))
  if 0 < remainingDays then
    if 0 < RechargeData.GetCount(data.CountKey) then
      ctr.rmbBuy:SetText(LocalizationUtility.GetContentByKey("GotPrize"))
    else
      ctr.rmbBuy:SetText(LocalizationUtility.GetContentByKey("GetPrize"))
    end
  end
  ctr.btn_buyMonthcard:SetOnClick(self, function()
    if 0 < remainingDays then
      NetManager.Send(RechargeMessage.ReqGetGift, {
        id = {
          data.GiftId
        }
      })
    elseif type(data.costCount) == "number" then
      NetManager.Send(ChatMessage.ReqGM, {
        info = string.format("@30 %d", data.rechargeId)
      })
    else
      NetManager.Send(ItemBuyMessage.ReqBuy, {
        goodId = data.rechargeId,
        buyCount = 1
      })
    end
  end)
end

function Recharge_RechargeUI:InitUI()
  self.go_sw_monthCard = self:GetControl("sw_monthCard")
  self.monthCardItemContainer = UIContainer(self.bg_monthCard, self, OnMonthCardItemCreat, OnMonthCardItemRefresh)
end

function Recharge_RechargeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    2270002,
    2270003,
    2270004
  })
  if self.args == 1 then
    self.tog_monthCardList:SetIsOn(true)
  else
    self.tog_monthCardList:SetIsOn(true)
  end
end

function Recharge_RechargeUI:OnHide()
end

function Recharge_RechargeUI:OnDestroy()
end

function Recharge_RechargeUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  if self.tog_monthCardList.gameObject.activeSelf then
    self.tog_monthCardList:SetOnToggleChanged(self, self.tog_monthCardListOnChanged)
  else
    self.go_sw_monthCard:SetActive(false)
  end
end

function Recharge_RechargeUI:btn_closeBgOnClick(control)
  UIManager.Hide(self.name)
end

function Recharge_RechargeUI:btn_closeOnClick(control)
  UIManager.Hide(self.name)
end

function Recharge_RechargeUI:tog_monthCardListOnChanged(control, eventData)
  self.tog_monthCardList.transform:Find("img_clickeffect").gameObject:SetActive(eventData)
  self.go_sw_monthCard:SetActive(eventData)
end

function Recharge_RechargeUI:RegistEvents()
  self:RegistEvent(Event.EquipAttriUpdate, self.Refresh, self)
  self:RegistEvent(Event.Recharge_InterfaceRefresh, self.Refresh, self)
end

function Recharge_RechargeUI:Refresh()
  self.monthCardItemContainer:SetDataKTable(RechargeData.GetMonthCardInfor())
end
