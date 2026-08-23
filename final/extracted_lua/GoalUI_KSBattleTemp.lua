local GoalUI_KSBattleTemp = {}

function GoalUI_KSBattleTemp:Init(data)
  self:InitControls()
  self:InitParams(data)
  self:BindUIEvent()
end

function GoalUI_KSBattleTemp:InitParams(data)
  self.isNone = false
  self.parentTbl = data and data.baseUI or nil
  self.rankContainer = UIUtility.BindUIContainerTemp(self.go_ranking, LuaComponentTemplates.GoalUI_KSBattleRankTemp, data.baseUI)
  self.meRankTemp = luaTemplateManager.GetNewTemplate(self.go_rankingMe, LuaComponentTemplates.GoalUI_KSBattleMeRankTemp, {baseUI = self})
end

function GoalUI_KSBattleTemp:InitControls()
  self.sw_rankList = self:GetControl("Panel_Ranking/sw_rankList")
  self.go_ranking = self:GetControl("Panel_Ranking/sw_rankList/Viewport/Content/go_ranking")
  self.go_rankingMe = self:GetControl("Panel_Ranking/go_rankingMe")
  self.btn_AllRank = self:GetControl("Panel_Ranking/btn_AllRank")
  self.noOne_Bg = self:GetControl("Panel_Ranking/noOne_Bg")
end

function GoalUI_KSBattleTemp:BindUIEvent()
  self.btn_AllRank:SetOnClick(self, self.ClickAllRankCallBack)
end

function GoalUI_KSBattleTemp:ClickAllRankCallBack()
  if self.isNone then
    FloatingTipUtility.QuickMsg(string.format(LocalizationUtility.GetContentByKey("Activity_kunshou_11")))
    return
  end
  UIManager.Show(UIID.Activity_NightFightRankUI)
end

function GoalUI_KSBattleTemp:RefreshView()
  if QuickFind:GetKunShouBattleDataMgr() == nil then
    return
  end
  self:RefreshRankView()
  self:RefreshRankMeView()
  if self.noOne_Bg and not IsNil(self.noOne_Bg.transform) then
    self.noOne_Bg:SetActive(self.isNone)
  end
end

function GoalUI_KSBattleTemp:RefreshRankView()
  local rankList = QuickFind:GetKunShouBattleDataMgr():GetRankList()
  self.isNone = rankList == nil or table.count(rankList) == 0
  self.rankContainer:SetData(rankList)
end

function GoalUI_KSBattleTemp:RefreshRankMeView()
  self.meRankTemp:Refresh(QuickFind:GetKunShouBattleDataMgr():GetMeRankData(), self.parentTbl)
end

function GoalUI_KSBattleTemp:SetStage(stage)
end

function GoalUI_KSBattleTemp:OnHide()
end

function GoalUI_KSBattleTemp:OnDestroy()
end

return GoalUI_KSBattleTemp
