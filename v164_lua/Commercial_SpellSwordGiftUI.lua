Commercial_SpellSwordGiftUI = class(BaseUI)
Commercial_SpellSwordGiftUI.layer = UILayer.Panel
Commercial_SpellSwordGiftUI.orderInLayer = 3
Commercial_SpellSwordGiftUI.hideType = UIHideType.WaitDestroy
Commercial_SpellSwordGiftUI.hideFunc = UIHideFunc.MoveOutOfScreen
Commercial_SpellSwordGiftUI.escClose = UIEscClose.DontClose

function Commercial_SpellSwordGiftUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.bg_SpellSwordActivity = self:GetControl("bg_SpellSwordActivity")
  self.go_GiftGift = self:GetControl("bg_SpellSwordActivity/go_GiftGift")
  self.leftBg = self:GetControl("bg_SpellSwordActivity/go_GiftGift/leftBg")
  self.rightBg = self:GetControl("bg_SpellSwordActivity/go_GiftGift/rightBg")
  self.TogGroup = self:GetControl("bg_SpellSwordActivity/go_GiftGift/TogGroup")
  self.tog_wingGift = self:GetControl("bg_SpellSwordActivity/go_GiftGift/TogGroup/tog_wingGift")
  self.txtLeft = self:GetControl("bg_SpellSwordActivity/go_GiftGift/TogGroup/tog_wingGift/txtLeft")
  self.tog_equipGift = self:GetControl("bg_SpellSwordActivity/go_GiftGift/TogGroup/tog_equipGift")
  self.txtRight = self:GetControl("bg_SpellSwordActivity/go_GiftGift/TogGroup/tog_equipGift/txtRight")
  self.sw_equipGift = self:GetControl("bg_SpellSwordActivity/go_GiftGift/sw_equipGift")
  self.equipGift_Content = self:GetControl("bg_SpellSwordActivity/go_GiftGift/sw_equipGift/Viewport/equipGift_Content")
  self.bg_GiftShow = self:GetControl("bg_SpellSwordActivity/go_GiftGift/sw_equipGift/Viewport/equipGift_Content/bg_GiftShow")
  self.Img_rechangeArrow = self:GetControl("bg_SpellSwordActivity/go_GiftGift/sw_equipGift/Img_rechangeArrow")
  self.Img_rechangeArrow2 = self:GetControl("bg_SpellSwordActivity/go_GiftGift/sw_equipGift/Img_rechangeArrow2")
  self.TogGroupHolyMaster = self:GetControl("bg_SpellSwordActivity/go_GiftGift/TogGroupHolyMaster")
  self.tog_wingGiftHolyMaster = self:GetControl("bg_SpellSwordActivity/go_GiftGift/TogGroupHolyMaster/tog_wingGiftHolyMaster")
  self.tog_equipGiftHolyMaster = self:GetControl("bg_SpellSwordActivity/go_GiftGift/TogGroupHolyMaster/tog_equipGiftHolyMaster")
  self.tog_stoneGiftHolyMaster = self:GetControl("bg_SpellSwordActivity/go_GiftGift/TogGroupHolyMaster/tog_stoneGiftHolyMaster")
  self.txt_lastTime = self:GetControl("bg_SpellSwordActivity/go_GiftGift/txt_lastTime")
  self.lab_lastTime = self:GetControl("bg_SpellSwordActivity/go_GiftGift/txt_lastTime/lab_lastTime")
  self.btn_close = self:GetControl("bg_SpellSwordActivity/btn_close")
  self.bg_equipDesc = self:GetControl("bg_equipDesc")
  self.btn_out = self:GetControl("bg_equipDesc/btn_out")
  self.go_model = self:GetControl("bg_equipDesc/attBg/AppearLookBg/AppearLook/go_model")
  self.lab_TipSuitAdditional = self:GetControl("bg_equipDesc/attBg/arm/attBg/Viewport/Content/lab_TipSuitAdditional")
  self.sw_leftquipDesc = self:GetControl("bg_equipDesc/sw_leftquipDesc")
  self.left_equipTipsShow = self:GetControl("bg_equipDesc/sw_leftquipDesc/Content/tip_Content/left_equipTipsShow")
  self.sw_rightequipDesc = self:GetControl("bg_equipDesc/sw_rightequipDesc")
  self.right_equipTipsShow = self:GetControl("bg_equipDesc/sw_rightequipDesc/Content/tip_Content/right_equipTipsShow")
  self.btn_equipCheck = self:GetControl("bg_equipDesc/btn_equipCheck")
end

function Commercial_SpellSwordGiftUI:Init()
end

function Commercial_SpellSwordGiftUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Commercial_SpellSwordGiftUI:InitUI()
  self.tog_wingGiftHolyMaster.type = 1
  self.tog_equipGiftHolyMaster.type = 2
  self.togList = {}
  table.insert(self.togList, self.tog_wingGiftHolyMaster)
  table.insert(self.togList, self.tog_equipGiftHolyMaster)
  self.bg_GiftShowContainer = UIUtility.BindUIContainerTemp(self.bg_GiftShow, LuaComponentTemplates.GiftShowTemplate, self)
end

function Commercial_SpellSwordGiftUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self:SetToggleClickEvent()
end

function Commercial_SpellSwordGiftUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Commercial_SpellSwordGiftUI)
end

function Commercial_SpellSwordGiftUI:btn_outOnClick(control)
end

function Commercial_SpellSwordGiftUI:btn_equipCheckOnClick(control)
end

function Commercial_SpellSwordGiftUI:ChangeToggleClick(control)
  local showGiftInfo = ClientTable.cfg_Item_buyManager:GetSpellSwordGiftBySubType(control.type)
  self.bg_GiftShowContainer:SetData(showGiftInfo)
end

function Commercial_SpellSwordGiftUI:SetToggleClickEvent()
  for i, v in ipairs(self.togList) do
    v:SetOnToggleChanged(self, self.ChangeToggleClick)
  end
end

function Commercial_SpellSwordGiftUI:OnShow()
  self:RegistEvents()
  self.togList[1]:SetIsOn(true)
  self:Refresh()
end

function Commercial_SpellSwordGiftUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
  self:RegistEvent(Event.Role_MyLvChanged, self.OnRole_MyLvChanged, self)
  self:RegistEvent(Event.CountsRefresh, self.OnCountsRefresh, self)
end

function Commercial_SpellSwordGiftUI:OnResBagChange()
  self:Refresh()
end

function Commercial_SpellSwordGiftUI:OnRole_MyLvChanged()
  self:Refresh()
end

function Commercial_SpellSwordGiftUI:OnCountsRefresh()
  self:Refresh()
end

function Commercial_SpellSwordGiftUI:Refresh()
  local type = 1
  for i, v in ipairs(self.togList) do
    if v:GetIsOn() then
      type = v.type
      break
    end
  end
  local showGiftInfo = ClientTable.cfg_Item_buyManager:GetSpellSwordGiftBySubType(type)
  self.bg_GiftShowContainer:SetData(showGiftInfo)
  self:RefreshCountdownTime()
end

local DaojiTime = 0

function Commercial_SpellSwordGiftUI:RefreshTime(lab_lastTime, txt_lastTime)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local DaoJiShi = TimeUtility.ShowDayHourMin(DaojiTime)
    lab_lastTime:SetText(DaoJiShi)
  else
    txt_lastTime:SetActive(false)
    lab_lastTime:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
  end
end

function Commercial_SpellSwordGiftUI:RefreshCountdownTime()
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local temp = ClientTable.cfg_Function_functionManager:TryGetValue(2600008)
  local condition
  if temp and temp.condition then
    condition = temp.condition[1]
  end
  local Difference = 0
  if condition and 0 < #condition then
    if condition[1][1] == 918 then
      local down = TimeUtility.InTweenyearTimeTheEnd(condition[1][2])
      Difference = TimeUtility.RefreshSec(down)
    else
      local down = TimeUtility.AddDay(LoginData.openServerTime, condition[2][2])
      Difference = TimeUtility.RefreshSec(down)
    end
  end
  local DaoJiShi
  if Difference <= 0 then
    self.txt_lastTime:SetText("")
    DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.lab_lastTime:SetText(DaoJiShi)
  else
    self.txt_lastTime:SetText("Th\225\187\157i gian c\195\178n: ")
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.lab_lastTime:SetText(DaoJiShi)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTime, self.txt_lastTime)
  end
end

function Commercial_SpellSwordGiftUI:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function Commercial_SpellSwordGiftUI:OnHide()
  self:SetDestroyTime()
end

function Commercial_SpellSwordGiftUI:OnDestroy()
end
