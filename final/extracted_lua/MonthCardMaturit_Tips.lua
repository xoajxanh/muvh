MonthCardMaturit_Tips = class(BaseUI)
MonthCardMaturit_Tips.layer = UILayer.Panel
MonthCardMaturit_Tips.orderInLayer = 7
MonthCardMaturit_Tips.hideType = UIHideType.WaitDestroy
MonthCardMaturit_Tips.hideFunc = UIHideFunc.MoveOutOfScreen
MonthCardMaturit_Tips.escClose = UIEscClose.DontClose

function MonthCardMaturit_Tips:InitControls()
  self.bg = self:GetControl("bg")
  self.ImgTitle = self:GetControl("ImgTitle")
  self.But_Close = self:GetControl("But_Close")
  self.go_itemModel = self:GetControl("go_itemModel")
  self.Btn_Vip = self:GetControl("Btn_Vip")
  self.Btn_VipText = self:GetControl("Btn_Vip/Btn_VipText")
  self.desTextImg = self:GetControl("text")
end

function MonthCardMaturit_Tips:OnPreLoad()
end

function MonthCardMaturit_Tips:Init()
end

function MonthCardMaturit_Tips:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function MonthCardMaturit_Tips:InitUI()
  self.Monthid = nil
  self.showCellData = ItemCellData()
end

function MonthCardMaturit_Tips:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function MonthCardMaturit_Tips:OnHide()
end

function MonthCardMaturit_Tips:OnDestroy()
end

function MonthCardMaturit_Tips:RegistUIEvents()
  self.But_Close:SetOnClick(self, self.But_CloseOnClick)
  self.bg:SetOnClick(self, self.But_CloseOnClick)
  self.Btn_Vip:SetOnClick(self, self.Btn_VipOnClick)
end

function MonthCardMaturit_Tips:But_CloseOnClick(control)
  EventManager.Dispatch(Event.MemberPrivilegeCardBubbleTips)
  UIManager.Hide(UIID.MonthCardMaturit_Tips)
  ExpiredPromptData.TraverseShowUI()
end

function MonthCardMaturit_Tips:Btn_VipOnClick(control)
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  self:But_CloseOnClick()
  local mMemberDataMgr = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  local cfg_memberSetting = mMemberDataMgr:GetCurCfgSetting()
  if cfg_memberSetting == nil then
    return
  end
  NavigationUtility.ClickNavigationByNavId(cfg_memberSetting.jump)
end

function MonthCardMaturit_Tips:RegistEvents()
end

function MonthCardMaturit_Tips:Refresh()
  local mMemberDataMgr = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  local mCardType = mMemberDataMgr:CardType(IndexerEnum.get)
  ExpiredPromptData.RemoveExpiredByType(mCardType)
  if self.args then
    mMemberDataMgr:CardInfo(IndexerEnum.set, self.args)
  end
  self:CheckUIByTabInfo()
end

function MonthCardMaturit_Tips:CheckUIByTabInfo()
  local mMemberDataMgr = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  local cfg_memberSetting = mMemberDataMgr:GetCurCfgSetting()
  if cfg_memberSetting == nil then
    return
  end
  self:SetSprite("Atlas_Language", cfg_memberSetting.word1, self.ImgTitle)
  self:SetSprite("Atlas_Language", cfg_memberSetting.word2, self.desTextImg)
  local text = ClientTable.cfg_Ui_wordManager:TryGetValue(cfg_memberSetting.word3).content
  self.Btn_VipText:SetText(text)
  local itemData = ItemUtility.GenerateItemData(cfg_memberSetting.itemid)
  self.showCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.go_itemModel, self.showCellData, self, true)
end
