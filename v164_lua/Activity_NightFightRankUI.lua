Activity_NightFightRankUI = class(BaseUI)
Activity_NightFightRankUI.layer = UILayer.Panel
Activity_NightFightRankUI.orderInLayer = 0
Activity_NightFightRankUI.hideType = UIHideType.WaitDestroy
Activity_NightFightRankUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_NightFightRankUI.escClose = UIEscClose.DontClose

function Activity_NightFightRankUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.person_rank = self:GetControl("img_bg/Scroll View/Viewport/Content/person_rank")
  self.MyRank = self:GetControl("img_bg/MyRank")
end

function Activity_NightFightRankUI:Init()
end

function Activity_NightFightRankUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_NightFightRankUI:InitUI()
  self.rankContainer = UIUtility.BindUIContainerTemp(self.person_rank, LuaComponentTemplates.NightFightRankTemplate, self)
  self.meRankTemp = luaTemplateManager.GetNewTemplate(self.MyRank, LuaComponentTemplates.NightFightMeRankTemplate, self)
end

function Activity_NightFightRankUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Activity_NightFightRankUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Activity_NightFightRankUI)
end

function Activity_NightFightRankUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_NightFightRankUI)
end

function Activity_NightFightRankUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_NightFightRankUI:RegistEvents()
  self:RegistEvent(Event.RefreshTrappedRank, self.RefreshTrappedRankCallBack, self)
end

function Activity_NightFightRankUI:RefreshTrappedRankCallBack()
  self:RefreshView()
end

function Activity_NightFightRankUI:Refresh()
  self:RefreshView()
end

function Activity_NightFightRankUI:RefreshView()
  if QuickFind:GetKunShouBattleDataMgr() == nil then
    return
  end
  self:RefreshRankView()
  self:RefreshRankMeView()
end

function Activity_NightFightRankUI:RefreshRankView()
  self.rankContainer:SetData(QuickFind:GetKunShouBattleDataMgr():GetRankList())
end

function Activity_NightFightRankUI:RefreshRankMeView()
  self.meRankTemp:Refresh(QuickFind:GetKunShouBattleDataMgr():GetMeRankData(), self)
end

function Activity_NightFightRankUI:OnHide()
end

function Activity_NightFightRankUI:OnDestroy()
end
