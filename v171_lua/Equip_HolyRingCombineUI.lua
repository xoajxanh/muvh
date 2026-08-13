Equip_HolyRingCombineUI = class(BaseUI)
Equip_HolyRingCombineUI.layer = UILayer.Panel
Equip_HolyRingCombineUI.orderInLayer = 0
Equip_HolyRingCombineUI.hideType = UIHideType.WaitDestroy
Equip_HolyRingCombineUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolyRingCombineUI.escClose = UIEscClose.DontClose

function Equip_HolyRingCombineUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.OtherView = self:GetControl("bg_equip/OtherView")
  self.sw_RingItem = self:GetControl("bg_equip/HolyRingBag/sw_RingItem")
  self.RingItem = self:GetControl("bg_equip/HolyRingBag/sw_RingItem/Viewport/Content/RingItem")
  self.NoItem = self:GetControl("NoItem")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
end

function Equip_HolyRingCombineUI:Init()
end

function Equip_HolyRingCombineUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolyRingCombineUI:InitUI()
  self.holyRingCombineOtherViewTemp = luaTemplateManager.GetNewTemplate(self.OtherView, LuaComponentTemplates.HolyRingCombineOtherViewTemp)
  self.holyRingCombineBagTemp = UIUtility.BindUIContainerTemp(self.RingItem, LuaComponentTemplates.HolyRingCombineBagTemplate, self, {
    clickCallBack = function(control)
      self:ClickBagItemCallBack(control)
    end
  })
end

function Equip_HolyRingCombineUI:RegistUIEvents()
  self.img_Bg2:SetOnClick(self, self.img_Bg2OnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Equip_HolyRingCombineUI:ClickBagItemCallBack(control)
  self.holyRingCombineOtherViewTemp:Refresh(control, self)
end

function Equip_HolyRingCombineUI:img_Bg2OnClick(control)
  UIManager.Hide(UIID.Equip_HolyRingCombineUI)
end

function Equip_HolyRingCombineUI:descBtnOnClick(control)
end

function Equip_HolyRingCombineUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_HolyRingCombineUI)
end

function Equip_HolyRingCombineUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolyRingCombineUI:RegistEvents()
  self:RegistEvent(Event.HolyRingBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.Item_CombineRsp, self.OnItemCombineRsp, self)
end

function Equip_HolyRingCombineUI:OnBagChange()
  self:Refresh()
end

function Equip_HolyRingCombineUI:OnItemCombineRsp(_, msg)
  if msg == nil then
    return
  end
  if #msg.rewards > 0 then
    local combineMap = {}
    local showItems = {}
    for i = 1, msg.combineCount do
      combineMap[tostring(i)] = i
    end
    for i, v in pairs(combineMap) do
      if msg.rewards[v] then
        table.insert(showItems, msg.rewards[v])
      end
    end
    if 0 < table.count(showItems) then
      UIManager.Show(UIID.ObtainTipUI, {
        generalRewards = showItems,
        specialRewards = nil,
        isCombine = true
      })
    end
  end
end

function Equip_HolyRingCombineUI:Refresh()
  local meetCombineHolyRingBagData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetMeetCombineHolyRingBagData()
  self.holyRingCombineBagTemp:SetData(meetCombineHolyRingBagData)
  local haveMeetCombineBagDta = not table.isNullOrEmpty(meetCombineHolyRingBagData)
  self.NoItem:SetActive(not haveMeetCombineBagDta)
  self.holyRingCombineOtherViewTemp:SetCombineButtonActive(haveMeetCombineBagDta)
  self.holyRingCombineBagFirstControl = self.holyRingCombineBagTemp.items[1] and self.holyRingCombineBagTemp.items[1].itemTemp
  self.holyRingCombineOtherViewTemp:RefreshSelectedData()
  self.holyRingCombineOtherViewTemp:RefreshCombineButtonColor()
end

function Equip_HolyRingCombineUI:ResetScrollViewPos()
  self.sw_RingItem:SetNormalizedPosition(0, 1)
end

function Equip_HolyRingCombineUI:OnHide()
  self:ResetScrollViewPos()
  self.holyRingCombineOtherViewTemp:OnHide()
end
