local CoalitionTemplate = {}
CoalitionTemplate.coalitionTemplates = nil

function CoalitionTemplate:Init()
  self:InitComponent()
  self:InitTemplate()
  self:BindOnClick()
end

function CoalitionTemplate:InitComponent()
  self.descBtn = self:GetControl("descBtn")
  self.lab_siegeOpenTime = self:GetControl("lab_siegeTime/lab_siegeOpenTime")
  self.LeaguePanel = self:GetControl("LeaguePanel")
end

function CoalitionTemplate:InitTemplate()
  if self.coalitionTemplates == nil then
    self.coalitionTemplates = {}
    local coalitionIdList = ClientTable.cfg_Camp_detailManager:GetCoalitionIdList()
    for k, coalitionId in pairs(coalitionIdList) do
      local coalition_UI = self.LeaguePanel:GetChild(tostring(coalitionId))
      if coalition_UI ~= nil then
        local SingleCoalitionTemplate = luaTemplateManager.GetNewTemplate(coalition_UI, LuaComponentTemplates.SingleCoalitionTemplate)
        self.coalitionTemplates[coalitionId] = SingleCoalitionTemplate
      end
    end
  end
end

function CoalitionTemplate:BindOnClick()
  self.descBtn:SetOnClick(self, self.DescBtnOnClick)
end

function CoalitionTemplate:DescBtnOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1077})
end

function CoalitionTemplate:Refresh(rootUI)
  self.rootUI = rootUI
  self:RefreshReq()
  self:RefreshNotice()
  self:RefreshAllCoalition()
end

function CoalitionTemplate:RefreshReq()
  networkRequest.ReqAddWatchOnlineList()
end

function CoalitionTemplate:RefreshNotice()
  local des = gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.PlayActivity):GetAllActivityDes()
  if des == nil then
    return
  end
  self.lab_siegeOpenTime:SetAutoScrollText(des)
end

function CoalitionTemplate:RefreshAllCoalition()
  for k, v in pairs(self.coalitionTemplates) do
    v:Refresh(k, self.rootUI)
  end
end

function CoalitionTemplate:RefreshSingleCoalition(coalitionId)
  local coalitionTemplate = self.coalitionTemplates[coalitionId]
  if coalitionTemplate == nil then
    return
  end
  coalitionTemplate:Refresh(coalitionId, self.rootUI)
  self:RefreshAllTemplateBtn()
end

function CoalitionTemplate:RefreshAllTemplateBtn()
  for k, v in pairs(self.coalitionTemplates) do
    v:RefreshEnterBtn()
    v:RefreshEffect()
  end
end

function CoalitionTemplate:RefreshOnLinePeopleNum(coalitionId)
  local coalitionTemplate = self.coalitionTemplates[coalitionId]
  if coalitionTemplate == nil then
    return
  end
  coalitionTemplate:RefreshPeopleNum()
end

function CoalitionTemplate:Exit()
  networkRequest.ReqExitWatchOnlineList()
end

return CoalitionTemplate
