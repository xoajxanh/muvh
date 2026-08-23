Activity_ExpeditionPaiUI = class(BaseUI)
Activity_ExpeditionPaiUI.layer = UILayer.Panel
Activity_ExpeditionPaiUI.orderInLayer = 0
Activity_ExpeditionPaiUI.hideType = UIHideType.WaitDestroy
Activity_ExpeditionPaiUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_ExpeditionPaiUI.escClose = UIEscClose.DontClose

function Activity_ExpeditionPaiUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.tog_server = self:GetControl("img_bg/grid_group/tog_server")
  self.tog_person = self:GetControl("img_bg/grid_group/tog_person")
  self.go_server = self:GetControl("img_bg/go_server")
  self.go_person = self:GetControl("img_bg/go_person")
  self.Scroll_View = self:GetControl("img_bg/go_person/Scroll_View")
  self.Viewport = self:GetControl("img_bg/go_person/Scroll_View/Viewport")
  self.Content = self:GetControl("img_bg/go_person/Scroll_View/Viewport/Content")
  self.person_rank = self:GetControl("img_bg/go_person/Scroll_View/Viewport/Content/person_rank")
  self.lab_rank = self:GetControl("img_bg/go_person/Scroll_View/Viewport/Content/person_rank/lab_rank")
  self.lab_img_rank = self:GetControl("img_bg/go_person/Scroll_View/Viewport/Content/person_rank/lab_img_rank")
  self.lab_name = self:GetControl("img_bg/go_person/Scroll_View/Viewport/Content/person_rank/lab_name")
  self.lab_occup = self:GetControl("img_bg/go_person/Scroll_View/Viewport/Content/person_rank/lab_occup")
  self.lab_server = self:GetControl("img_bg/go_person/Scroll_View/Viewport/Content/person_rank/lab_server")
  self.lab_killNum = self:GetControl("img_bg/go_person/Scroll_View/Viewport/Content/person_rank/lab_killNum")
  self.lab_lootNum = self:GetControl("img_bg/go_person/Scroll_View/Viewport/Content/person_rank/lab_lootNum")
  self.PersonItem = self:GetControl("img_bg/go_person/PersonItem")
  self.lab_myRank = self:GetControl("img_bg/go_person/PersonItem/lab_myRank")
  self.lab_myName = self:GetControl("img_bg/go_person/PersonItem/lab_myName")
  self.lab_myOccup = self:GetControl("img_bg/go_person/PersonItem/lab_myOccup")
  self.lab_myServer = self:GetControl("img_bg/go_person/PersonItem/lab_myServer")
  self.lab_myKillNum = self:GetControl("img_bg/go_person/PersonItem/lab_myKillNum")
  self.lab_myLootNum = self:GetControl("img_bg/go_person/PersonItem/lab_myLootNum")
  self.lab_flash = self:GetControl("img_bg/go_person/lab_flash")
end

function Activity_ExpeditionPaiUI:Init()
  self:InitData()
end

function Activity_ExpeditionPaiUI:InitData()
  self.normalTimer = {}
  self.rankData = {}
  self.PersonItemData = {}
  self.playRank = 0
  self.nextFlushTime = -1
end

function Activity_ExpeditionPaiUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_ExpeditionPaiUI:InitUI()
  self:InitContent()
end

local function OnPersonRankCreate(control)
  control.lab_rank = UIControl(control.transform, "lab_rank")
  control.lab_img_rank = UIControl(control.transform, "lab_img_rank")
  control.lab_name = UIControl(control.transform, "lab_name")
  control.lab_occup = UIControl(control.transform, "lab_occup")
  control.lab_server = UIControl(control.transform, "lab_server")
  control.lab_killNum = UIControl(control.transform, "lab_killNum")
  control.lab_lootNum = UIControl(control.transform, "lab_lootNum")
end

local function OnPersonRankRefresh(ctr, _, rankData, ui)
  ctr.lab_rank:SetText(tostring(rankData.rank))
  if rankData.rank <= 3 then
    ctr.lab_img_rank:SetActive(true)
    ui:SetSprite("Atlas_Main", "ico_" .. rankData.rank, ctr.lab_img_rank, false)
  else
    ctr.lab_img_rank:SetActive(false)
  end
  ctr.lab_name:SetText(tostring(rankData.name))
  ctr.lab_occup:SetText(tostring(RoleUtility.GteCareerNameByType(rankData.occup)))
  ctr.lab_server:SetText(tostring(rankData.server))
  ctr.lab_killNum:SetText(tostring(rankData.killNum))
  ctr.lab_lootNum:SetText(tostring(rankData.lootNum))
end

function Activity_ExpeditionPaiUI:InitContent()
  self.person_rankContainer = UIContainer(self.person_rank, self, OnPersonRankCreate, OnPersonRankRefresh)
end

function Activity_ExpeditionPaiUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Activity_ExpeditionPaiUI:btn_closeBgOnClick(control)
end

function Activity_ExpeditionPaiUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_ExpeditionPaiUI)
end

function Activity_ExpeditionPaiUI:OnShow()
  self:RegistEvents()
  networkRequest.ReqColetRuinsRanks()
  self.Scroll_View.scrollRect.normalizedPosition = Vector2(0, 1)
end

function Activity_ExpeditionPaiUI:RegistEvents()
  self:RegistEvent(Event.KalunteRuinsTransRank, self.OutsideRefresh, self)
end

function Activity_ExpeditionPaiUI:Refresh()
  self:RefreshData()
  self:RefreshView()
end

function Activity_ExpeditionPaiUI:OutsideRefresh(id, rankData)
  self:RefreshData(rankData)
  self:RefreshView()
end

function Activity_ExpeditionPaiUI:RefreshData(rankData)
  if rankData ~= nil then
    self.rankData = rankData.ranks
    self.PersonItemData = rankData.playInfo
    self.playRank = rankData.playRank
    self.nextFlushTime = rankData.nextFlushTime
  elseif self.args and self.args.rankData and self.args.PersonItemData and self.args.playRank and self.args.nextFlushTime then
    self.rankData = self.args.rankData
    self.PersonItemData = self.args.PersonItemData
    self.playRank = self.args.playRank
    self.nextFlushTime = self.args.nextFlushTime
  end
end

function Activity_ExpeditionPaiUI:RefreshView()
  if self.rankData and next(self.rankData) ~= nil and self.PersonItemData and next(self.PersonItemData) ~= nil and self.playRank and self.nextFlushTime then
    self:RefreshRankScrollView()
    self:RefreshPersonItemView()
    self:RefreshCountDownView()
  end
end

function Activity_ExpeditionPaiUI:RefreshRankScrollView()
  local rankDataList = {}
  for i = 1, table.count(self.rankData) do
    local rankData = {}
    rankData.rank = i
    rankData.name = self.rankData[i].name
    rankData.occup = self.rankData[i].career
    rankData.server = self.rankData[i].sid
    rankData.killNum = self.rankData[i].score
    rankData.lootNum = self.rankData[i].gainBoxCount
    rankDataList[i] = rankData
  end
  table.sort(rankDataList, function(a, b)
    if a ~= nil and b ~= nil then
      if a.rank and b.rank then
        return a.rank < b.rank
      else
        return false
      end
    else
      return false
    end
  end)
  self.person_rankContainer:SetData(rankDataList)
end

function Activity_ExpeditionPaiUI:RefreshPersonItemView()
  self.lab_myRank:SetText(tostring(self.playRank == 0 and "Ch\198\176a l\195\170n BXH" or self.playRank))
  self.lab_myName:SetText(tostring(self.PersonItemData.name))
  self.lab_myOccup:SetText(tostring(RoleUtility.GteCareerNameByType(self.PersonItemData.career)))
  self.lab_myServer:SetText(tostring(self.PersonItemData.sid))
  self.lab_myKillNum:SetText(tostring(self.PersonItemData.score))
  self.lab_myLootNum:SetText(tostring(self.PersonItemData.gainBoxCount))
end

function Activity_ExpeditionPaiUI:RefreshCountDownView()
  if self.nextFlushTime == nil then
    return
  end
  self:WaitServerToSetCountDown()
end

function Activity_ExpeditionPaiUI:WaitServerToSetCountDown()
  local function SetCountDown(self)
    local totalTime = math.floor((self.nextFlushTime - Time.GetServerTime()) / 1000) or 0
    
    while totalTime <= 0 do
      Coroutine.Wait(1)
      networkRequest.ReqColetRuinsRanks()
    end
    self:ShowTimer(totalTime, self.lab_flash, 1)
  end
  
  if self.waitServerToSetCDCoroutine then
    Coroutine.Stop(self.waitServerToSetCDCoroutine)
    self.waitServerToSetCDCoroutine = nil
  end
  self.waitServerToSetCDCoroutine = Coroutine.Start(SetCountDown, self)
end

function Activity_ExpeditionPaiUI:DestroyAllTimer()
  if self.normalTimer then
    for k, v in pairs(self.normalTimer) do
      if v then
        Timer.Stop(v)
        v = nil
      end
    end
  end
end

function Activity_ExpeditionPaiUI:ShowTimer(surplusTime, lab_countdown, index)
  local function UpdateTimer()
    surplusTime = surplusTime - 1
    
    local timeStr = TimeUtility.ShowNewTime(surplusTime)
    lab_countdown:SetText(timeStr)
    if surplusTime <= 0 then
      if self.normalTimer[index] then
        Timer.Stop(self.normalTimer[index])
        self.normalTimer[index] = nil
      end
      networkRequest.ReqColetRuinsRanks()
    end
  end
  
  if surplusTime < 0 then
    return
  end
  local timeStr = TimeUtility.ShowNewTime(surplusTime)
  lab_countdown:SetText(timeStr)
  if self.normalTimer[index] then
    Timer.Stop(self.normalTimer[index])
    self.normalTimer[index] = nil
  end
  self.normalTimer[index] = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Activity_ExpeditionPaiUI:OnHide()
  self:DestroyAllTimer()
  self:InitData()
end

function Activity_ExpeditionPaiUI:OnDestroy()
  self.normalTimer = nil
  self.waitServerToSetCDCoroutine = nil
  self.rankData = nil
  self.PersonItemData = nil
  self.playRank = nil
  self.nextFlushTime = nil
end
