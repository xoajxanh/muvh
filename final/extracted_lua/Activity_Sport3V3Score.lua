Activity_Sport3V3Score = class(BaseUI)
Activity_Sport3V3Score.layer = UILayer.Panel
Activity_Sport3V3Score.orderInLayer = 5
Activity_Sport3V3Score.hideType = UIHideType.WaitDestroy
Activity_Sport3V3Score.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_Sport3V3Score.escClose = UIEscClose.DontClose

function Activity_Sport3V3Score:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.resultTitle = self:GetControl("go_3V3SportScore/resultTitle")
  self.blueTitle2 = self:GetControl("go_3V3SportScore/resultNumber/myResult/imgTilte/blueTitle2")
  self.blueTitle1 = self:GetControl("go_3V3SportScore/resultNumber/myResult/imgTilte/blueTitle1")
  self.redTeamMember = self:GetControl("go_3V3SportScore/resultNumber/myResult/redTeamMember")
  self.teamMateList = self:GetControl("go_3V3SportScore/resultNumber/emResult/redTeamMember/Viewport/Content/foeList")
  self.redTitle2 = self:GetControl("go_3V3SportScore/resultNumber/emResult/imgTilte/redTitle2")
  self.redTitle1 = self:GetControl("go_3V3SportScore/resultNumber/emResult/imgTilte/redTitle1")
  self.blutTeamMember = self:GetControl("go_3V3SportScore/resultNumber/emResult/blutTeamMember")
  self.foeList = self:GetControl("go_3V3SportScore/resultNumber/myResult/blueTeamMember/Viewport/Content/teamMateList")
  self.btn_more = self:GetControl("go_3V3SportScore/btns/btn_more")
  self.btn_surrender = self:GetControl("go_3V3SportScore/btns/btn_surrender")
  self.txt_explan = self:GetControl("go_3V3SportScore/txt_explan")
  self.txt_bottom = self:GetControl("go_3V3SportScore/txt_explan/txt_bottom")
  self.txt_time = self:GetControl("go_3V3SportScore/txt_explan/txt_time")
end

function Activity_Sport3V3Score:Init()
end

function Activity_Sport3V3Score.InitTeamMateListControls(ctr)
  ctr.deadCount = UIControl(ctr.transform, "deadCount")
  ctr.killCount = UIControl(ctr.transform, "killCount")
  ctr.name = UIControl(ctr.transform, "name")
  ctr.headImg = UIControl(ctr.transform, "headBg/headImg")
  ctr.levelCount = UIControl(ctr.transform, "levelBg/levelCount")
end

function Activity_Sport3V3Score.ItemTeamMateListRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  ctr.name:SetText(data:GetName())
  ctr.deadCount:SetText(data:GetDieNum())
  ctr.killCount:SetText(data:GetKillNum())
  local career = data:GetCareer()
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(career, "id")
  if spriteName then
    ui:SetSprite("Atlas_headPortrait", spriteName.headPortrait, ctr.headImg)
  end
  ctr.levelCount:SetText(data:GetLevel())
end

function Activity_Sport3V3Score.InitblutTeamMemberControls(ctr)
end

function Activity_Sport3V3Score.ItemblutTeamMemberRefresh(ctr, _, data, ui)
end

function Activity_Sport3V3Score:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_Sport3V3Score:InitUI()
  self.teamMateListContainer = UIContainer(self.teamMateList, self, self.InitTeamMateListControls, self.ItemTeamMateListRefresh)
  self.blutTeamMemberContainer = UIContainer(self.foeList, self, self.InitTeamMateListControls, self.ItemTeamMateListRefresh)
end

function Activity_Sport3V3Score:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_more:SetOnClick(self, self.btn_moreOnClick)
  self.btn_surrender:SetOnClick(self, self.btn_surrenderOnClick)
end

function Activity_Sport3V3Score:btn_closeBgOnClick(control)
  if QuickFind:GetThreeVsThreeDataMgr():GetOpenActivity_Sport3V3RankData() and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshResultTipDataByServerData(QuickFind:GetThreeVsThreeDataMgr():GetOpenActivity_Sport3V3RankData())
  end
  UIManager.Hide(UIID.Activity_Sport3V3Score)
end

function Activity_Sport3V3Score:btn_moreOnClick(control)
  if QuickFind:GetThreeVsThreeDataMgr():GetOpenActivity_Sport3V3RankData() and QuickFind:GetThreeVsThreeDataMgr() then
    QuickFind:GetThreeVsThreeDataMgr():RefreshResultTipDataByServerData(QuickFind:GetThreeVsThreeDataMgr():GetOpenActivity_Sport3V3RankData())
  end
  UIManager.Hide(UIID.Activity_Sport3V3Score)
end

function Activity_Sport3V3Score:btn_surrenderOnClick(control)
  networkRequest.ReqCapitulate(1)
  UIManager.Hide(UIID.Activity_Sport3V3Score)
end

function Activity_Sport3V3Score:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_Sport3V3Score:RegistEvents()
  self:RegistEvent(Event.RefreshThreeVThreeScoreUIInfo, self.Refresh, self)
end

function Activity_Sport3V3Score:Refresh(_, data)
  local resultData = data or self.args and self.args.resultData
  if table.isNullOrEmpty(resultData) then
    local MainInfo
    if QuickFind:GetThreeVsThreeDataMgr() and QuickFind:GetThreeVsThreeDataMgr():GetMainPlayerCampInfo() and QuickFind:GetThreeVsThreeDataMgr():GetMainPlayerCampInfo():GetPlayerInfoList() then
      MainInfo = QuickFind:GetThreeVsThreeDataMgr():GetMainPlayerCampInfo():GetPlayerInfoList()
    end
    local EnemyInfo = QuickFind:GetThreeVsThreeDataMgr():GetEnemyCampInfoList()[1]:GetPlayerInfoList()
    self.resultTitle:SetActive(false)
    local redCamp, blueCamp
    if MainInfo and MainInfo[1] and MainInfo[1]:GetGroupId() == EThreeVSThreePlayerCamp.Red then
      redCamp = MainInfo
      blueCamp = EnemyInfo
    else
      redCamp = EnemyInfo
      blueCamp = MainInfo
    end
    self.teamMateListContainer:SetData(redCamp)
    self.blutTeamMemberContainer:SetData(blueCamp)
  else
    local myCampPlayerInfo = resultData.myResultScoreCampInfo and resultData.myResultScoreCampInfo:GetPlayerInfoList()
    local enemyCampPlayerInfo = resultData.enemyResultScoreCampInfoList[1] and resultData.enemyResultScoreCampInfoList[1]:GetPlayerInfoList()
    local redCamp, blueCamp
    if myCampPlayerInfo and myCampPlayerInfo[1] and myCampPlayerInfo[1]:GetGroupId() == EThreeVSThreePlayerCamp.Red then
      redCamp = myCampPlayerInfo
      blueCamp = enemyCampPlayerInfo
    else
      redCamp = enemyCampPlayerInfo
      blueCamp = myCampPlayerInfo
    end
    self.teamMateListContainer:SetData(redCamp)
    self.blutTeamMemberContainer:SetData(blueCamp)
    self.resultTitle:SetActive(true)
    local isWin = resultData.myResultScoreCampInfo and resultData.myResultScoreCampInfo.GroupId == resultData.winGroupType
    self:SetSprite("Atlas_Language", isWin and "3V3Win" or "3V3Fail", self.resultTitle)
  end
  local isResultRefresh = resultData ~= nil
  self.resultTitle:SetActive(isResultRefresh)
  self.btn_more:SetActive(isResultRefresh)
  self.btn_surrender:SetActive(not isResultRefresh)
  self.txt_explan:SetActive(false)
end

function Activity_Sport3V3Score:SetOpenActivity_Sport3V3RankData(data)
  self.openActivity_Sport3V3RankData = data
end

function Activity_Sport3V3Score:OnHide()
  self.args = nil
  QuickFind:GetThreeVsThreeDataMgr():SetOpenActivity_Sport3V3RankData(nil)
end
