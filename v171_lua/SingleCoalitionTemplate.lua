local SingleCoalitionTemplate = {}
SingleCoalitionTemplate.coalitionId = nil
SingleCoalitionTemplate.coalitionInfo = nil

function SingleCoalitionTemplate:Init()
  self:InitComponent()
  self:BindOnClick()
end

function SingleCoalitionTemplate:InitComponent()
  self.btn_detail = self:GetControl("LeagueInfo/btn_detail")
  self.btn_goScene = self:GetControl("LeagueInfo/btn_goScene")
  self.Text = self:GetControl("LeagueInfo/btn_goScene/Text")
  self.img_recommend = self:GetControl("LeagueInfo/btn_goScene/img_recommend")
  self.lab_name = self:GetControl("LeagueInfo/lab_name")
  self.lab_playerNum = self:GetControl("LeagueInfo/lab_playerNum")
  self.img_choose_league = self:GetControl("LeagueInfo/img_choose_league")
  self.img_choose_ground = self:GetControl("img_choose_ground")
  self.icon_league = self:GetControl("LeagueInfo/icon_league")
end

function SingleCoalitionTemplate:BindOnClick()
  self.btn_detail:SetOnClick(self, self.Btn_detailOnClick)
  self.btn_goScene:SetOnClick(self, self.Btn_goSceneOnClick)
end

function SingleCoalitionTemplate:Btn_detailOnClick()
  UIManager.Show(UIID.Tip_LeagueSiegeInfoTipUI, {
    coalitionId = self.coalitionId
  })
end

function SingleCoalitionTemplate:Btn_goSceneOnClick()
  local btnType = self:GetBtnType()
  if btnType == CoalitionBtnType.JoinCoalition then
    networkRequest.ReqJoinUnionKuaFu(self.coalitionInfo.serverData.camp)
  elseif btnType == CoalitionBtnType.JoinActivity then
    self.InProgressActivityData:ReqJoinActivity()
  end
end

function SingleCoalitionTemplate:Refresh(coalitionId, rootUI)
  if self:AnalysisParams(coalitionId, rootUI) == false then
    return
  end
  self:RefreshName()
  self:RefreshFlagPicture()
  self:RefreshPeopleNum()
  self:RefreshEnterBtn()
  self:RefreshEffect()
  self:RefreshRecommendHint()
end

function SingleCoalitionTemplate:AnalysisParams(coalitionId, rootUI)
  if coalitionId == nil then
    return false
  end
  self.coalitionId = coalitionId
  self.rootUI = rootUI
  self.coalitionInfo = gameMgr:GetCoalitionManager():GetCoalitionInfo(coalitionId)
  if self.coalitionInfo == nil then
    return false
  end
  return true
end

function SingleCoalitionTemplate:RefreshInProgressActivity()
  local activityManager = gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.PlayActivity)
  if activityManager ~= nil then
    local InProgressActivityDataList = activityManager:GetInProgressActivityList()
    self.InProgressActivityData = self:GetInProgressActivityData(InProgressActivityDataList)
  end
end

function SingleCoalitionTemplate:GetInProgressActivityData(inProgressActivityDataList)
  for k, v in pairs(inProgressActivityDataList) do
    if string.isNullOrEmpty(v:GetEnterBtnName()) == false then
      return v
    end
  end
end

function SingleCoalitionTemplate:RefreshName()
  self.lab_name:SetText(self.coalitionInfo:GetName())
end

function SingleCoalitionTemplate:RefreshFlagPicture()
  if self.rootUI == nil then
    return
  end
  self.rootUI:SetSprite("Atlas_Common", self.coalitionInfo:GetIconName(), self.icon_league)
end

function SingleCoalitionTemplate:RefreshPeopleNum()
  self.lab_playerNum:SetText(self.coalitionInfo:GetPeopleNumDes())
end

function SingleCoalitionTemplate:RefreshEnterBtn()
  local btnName = ""
  local btnType = self:GetBtnType()
  if btnType == CoalitionBtnType.JoinCoalition then
    btnName = "Gia nh\225\186\173p Li\195\170n Minh"
  elseif btnType == CoalitionBtnType.JoinActivity then
    btnName = self.InProgressActivityData:GetEnterBtnName()
  end
  self.Text:SetText(btnName)
  self.btn_goScene:SetActive(string.isNullOrEmpty(btnName) == false)
end

function SingleCoalitionTemplate:RefreshEffect()
  local showEffect = self:IsMainPlayerCoalition()
  self.img_choose_league:SetActive(showEffect)
  self.img_choose_ground:SetActive(showEffect)
end

function SingleCoalitionTemplate:RefreshRecommendHint()
  self.img_recommend:SetActive(gameMgr:GetCoalitionManager():IsRecommendCoalitionId(self.coalitionInfo.serverData.camp))
end

function SingleCoalitionTemplate:GetBtnType()
  local IsUnionLeader = gameMgr:GetAvatarManager():GetMainPlayer():GetWarAllianceData().IsLeader()
  local mainPlayerCoalitionInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetCoalitionInfo()
  self:RefreshInProgressActivity()
  if IsUnionLeader == true and mainPlayerCoalitionInfo == nil then
    return CoalitionBtnType.JoinCoalition
  elseif mainPlayerCoalitionInfo and mainPlayerCoalitionInfo.id == self.coalitionId and self.InProgressActivityData ~= nil then
    return CoalitionBtnType.JoinActivity
  end
end

function SingleCoalitionTemplate:MainPlayerHaveCoalition()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetCoalitionInfo() ~= nil
end

function SingleCoalitionTemplate:IsMainPlayerCoalition()
  local mainPlayerCoalition = gameMgr:GetAvatarManager():GetMainPlayer():GetCoalitionInfo()
  return mainPlayerCoalition ~= nil and mainPlayerCoalition.id == self.coalitionInfo.id
end

return SingleCoalitionTemplate
