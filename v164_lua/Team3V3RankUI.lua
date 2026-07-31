Team3V3RankUI = class(BaseUI)
Team3V3RankUI.layer = UILayer.Panel
Team3V3RankUI.orderInLayer = 1
Team3V3RankUI.hideType = UIHideType.WaitDestroy
Team3V3RankUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team3V3RankUI.escClose = UIEscClose.DontClose

function Team3V3RankUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.scrollView = self:GetControl("img_bg/Scroll View")
  self.personRank = self:GetControl("img_bg/person_rank")
  self.txt_nodata = self:GetControl("img_bg/txt_nodata")
  self.myRank = self:GetControl("img_bg/MyRank")
  self.myRank_rank = self:GetControl("img_bg/MyRank/lab_rank")
  self.myRank_teamName = self:GetControl("img_bg/MyRank/lab_teamName")
  self.myRank_captainName = self:GetControl("img_bg/MyRank/lab_captainName")
  self.myRank_server = self:GetControl("img_bg/MyRank/lab_sever")
  self.myRank_wins = self:GetControl("img_bg/MyRank/lab_wins")
  self.myRank_score = self:GetControl("img_bg/MyRank/lab_score")
end

function Team3V3RankUI:Init()
end

function Team3V3RankUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Team3V3RankUI:InitUI()
  self.selectIndex = 1
end

function Team3V3RankUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Team3V3RankUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Team3V3RankUI)
end

function Team3V3RankUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Team3V3RankUI:RegistEvents()
end

function Team3V3RankUI:Refresh()
  self:SetDefaultCellIndex()
  self:RefreshItemView(self.selectIndex)
  self:ResetPanel()
  self:RefreshMyItemView()
end

function Team3V3RankUI:SetDefaultCellIndex()
  self.rankItemTbl = QuickFind:GetTeam3V3DataMgr():GetStairsRank()
  self.selectIndex = QuickFind:GetTeam3V3DataMgr():GetMyTeamStairsRankIndex()
end

function Team3V3RankUI:RefreshItemView(selectIndex)
  if not self.rankItemTbl or table.count(self.rankItemTbl) == 0 then
    self.txt_nodata:SetActive(true)
    self.txt_nodata:SetText("Ch\198\176a c\195\179 d\225\187\175 li\225\187\135u")
    return
  end
  self.txt_nodata:SetActive(false)
  self.txt_nodata:SetText("")
  if self.itemTableView == nil then
    self.itemTableView = UITableView:CreateTableView(self.scrollView, self.personRank, self.rankItemTbl, EScrollViewDireEnum.Vertical, self.UpdateCellCallBack, self)
  end
  if self.itemTableView then
    self.itemTableView:SetCurDataList(self.rankItemTbl)
    if selectIndex and 1 <= selectIndex and selectIndex <= #self.rankItemTbl then
      self.itemTableView:ReloadData(selectIndex)
    else
      self.itemTableView:ReloadData()
    end
  end
end

function Team3V3RankUI:UpdateCellCallBack(index)
  if type(self.rankItemTbl) ~= "table" or next(self.rankItemTbl) == nil then
    return
  end
  if self.rankItemTbl[index] ~= nil then
    local cell = self.itemTableView:GetLoadedCell(index)
    self:RefreshRankOption(self.rankItemTbl[index], cell, index)
  end
end

function Team3V3RankUI:RefreshRankOption(data, obj, index)
  self:TryInitControls(obj)
  obj.personRank_rank:SetText(data.rank)
  obj.personRank_teamName:SetText(data.teamName)
  obj.personRank_captainName:SetText(data.leaderName)
  obj.personRank_server:SetText(data.serverId)
  obj.personRank_wins:SetText(data.winCount)
  obj.personRank_score:SetText(data.score)
end

function Team3V3RankUI:TryInitControls(obj)
  if obj.personRank_rank == nil then
    obj.personRank_rank = obj:GetChild("lab_rank")
  end
  if obj.personRank_teamName == nil then
    obj.personRank_teamName = obj:GetChild("lab_teamName")
  end
  if obj.personRank_captainName == nil then
    obj.personRank_captainName = obj:GetChild("lab_captainName")
  end
  if obj.personRank_server == nil then
    obj.personRank_server = obj:GetChild("lab_sever")
  end
  if obj.personRank_wins == nil then
    obj.personRank_wins = obj:GetChild("lab_wins")
  end
  if obj.personRank_score == nil then
    obj.personRank_score = obj:GetChild("lab_score")
  end
end

function Team3V3RankUI:RefreshMyItemView()
  local myRankData = QuickFind:GetTeam3V3DataMgr():GetMyTeamStairsRank()
  if not myRankData then
    return
  end
  self.myRank_rank:SetText(myRankData.rank > 0 and myRankData.rank or "Ch\198\176a l\195\170n BXH")
  self.myRank_teamName:SetText(myRankData.teamName)
  self.myRank_captainName:SetText(myRankData.leaderName)
  self.myRank_server:SetText(myRankData.serverId)
  self.myRank_wins:SetText(myRankData.winCount)
  self.myRank_score:SetText(myRankData.score)
end

function Team3V3RankUI:ResetPanel()
  self.myRank_rank:SetText("Ch\198\176a l\195\170n BXH")
  self.myRank_teamName:SetText("-")
  self.myRank_captainName:SetText("-")
  self.myRank_server:SetText("-")
  self.myRank_wins:SetText("-")
  self.myRank_score:SetText("-")
end

function Team3V3RankUI:OnHide()
  QuickFind:GetTeam3V3DataMgr():ResetStairsRankData()
end

function Team3V3RankUI:OnDestroy()
end
