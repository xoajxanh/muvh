DemonHunt_ListInfoUI = class(BaseUI)
DemonHunt_ListInfoUI.layer = UILayer.Panel
DemonHunt_ListInfoUI.orderInLayer = 0
DemonHunt_ListInfoUI.hideType = UIHideType.WaitDestroy
DemonHunt_ListInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
DemonHunt_ListInfoUI.escClose = UIEscClose.DontClose

function DemonHunt_ListInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.bg = self:GetControl("img_Bg/bg")
  self.btn_close = self:GetControl("img_Bg/bg/btn_close")
  self.go_main = self:GetControl("img_Bg/go_main")
  self.panel_DemonHuntCross = self:GetControl("img_Bg/go_main/panel_DemonHuntCross")
  self.img_second = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/go_main/img_Bg/sw_leaderList/Viewport/Content/img_second")
  self.img_frist = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/go_main/img_Bg/sw_leaderList/Viewport/Content/img_frist")
  self.go_model = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/go_main/img_Bg/sw_leaderList/Viewport/Content/img_frist/go_model")
  self.img_third = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/go_main/img_Bg/sw_leaderList/Viewport/Content/img_third")
  self.btn_reward = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/go_main/img_Bg/btn_reward")
  self.plane_left = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/go_main/img_Bg/plane_left")
  self.plane_right = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/go_main/img_Bg/plane_right")
  self.bg_list = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/bg_list")
  self.img_bg = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/bg_list/img_bg")
  self.scroll_View = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/scroll_View")
  self.myRankInfo = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/myRankInfo/myRank")
  self.RewardRank_AllPanel = self:GetControl("img_Bg/RewardRank_AllPanel")
  self.descBtn = self:GetControl("img_Bg/descBtn")
  self.lab_time = self:GetControl("img_Bg/go_main/panel_DemonHuntCross/img_tipBg/lab_tips")
end

function DemonHunt_ListInfoUI:Init()
  self.leaderList = {}
  self.modeViewerList = {}
end

function DemonHunt_ListInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function DemonHunt_ListInfoUI:InitUI()
  self.leaderList = {
    self.img_frist,
    self.img_second,
    self.img_third
  }
  self.RewardRank_AllPanelTemplate = luaTemplateManager.GetNewTemplate(self.RewardRank_AllPanel, LuaComponentTemplates.RewardRank_AllPanelTemplate, self)
end

function DemonHunt_ListInfoUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_reward:SetOnClick(self, self.btn_rewardOnClick)
  self.descBtn:SetOnClick(self, self.btn_descBtnClick)
end

function DemonHunt_ListInfoUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.DemonHunt_ListInfoUI)
end

function DemonHunt_ListInfoUI:btn_rewardOnClick(control)
  self.RewardRank_AllPanel:SetActive(true)
  self.RewardRank_AllPanelTemplate:Refresh(nil, self)
  self:HideModel(true)
end

function DemonHunt_ListInfoUI:btn_descBtnClick(control)
  UIManager.Show(UIID.System_DescUI, {id = 1105})
end

function DemonHunt_ListInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function DemonHunt_ListInfoUI:RegistEvents()
  self:RegistEvent(Event.Rank_UpdateTableView, self.OnResRanks, self)
  self:RegistEvent(RankMessage.ResRoleKillMonsterScore, self.RefreshSelfInfo, self)
end

function DemonHunt_ListInfoUI:Refresh()
  self.root.canvas.overrideSorting = false
  networkRequest.ReqRoleKillMonsterScore()
  networkRequest.ReqQueryRanks(RANKTYPE.killMonsterScore, ERoleCareer.All)
  DemonHunt_ListInfoUI:RefreshTime()
end

function DemonHunt_ListInfoUI:RefreshTime()
  if self.RemainTimeLoop ~= nil then
    Timer.Stop(self.RemainTimeLoop)
  end
  self.lab_time:SetText("Kho\225\186\163ng c\195\161ch \196\145\225\186\191n l\225\186\167n t\225\187\149ng k\225\186\191t ti\225\186\191p theo:" .. TimeUtility.ShowTime(TimeUtility.GetNetTenMinutes()))
  self.RemainTimeLoop = Timer.StartLoopForever(1, function()
    self.lab_time:SetText("Kho\225\186\163ng c\195\161ch \196\145\225\186\191n l\225\186\167n t\225\187\149ng k\225\186\191t ti\225\186\191p theo:" .. TimeUtility.ShowTime(TimeUtility.GetNetTenMinutes()))
  end)
end

function DemonHunt_ListInfoUI:OnResRanks()
  local rankInfos = RankListData.RankListAll[RANKTYPE.killMonsterScore][ERoleCareer.All]
  self:RefreshRank(rankInfos)
  self:RefreshLeaderListShow(rankInfos)
  self:RefreshSelfInfo()
end

function DemonHunt_ListInfoUI:RefreshRank(rankInfos)
  if not self.rankListTableView then
    self:CreateTableView(rankInfos)
  else
    self.rankListTableView:SetCurDataList(rankInfos)
    self.rankListTableView:ReloadData(1)
  end
end

function DemonHunt_ListInfoUI:CreateTableView(rankInfos)
  self.rankListTableView = UITableView:CreateTableView(self.scroll_View, self.bg_list, rankInfos, EScrollViewDireEnum.Vertical, self.CellAtIndexInTableViewWillAppear, self)
  self.rankListTableView:ReloadData(1)
end

function DemonHunt_ListInfoUI:GetRankData()
  local rankTab = RankListData.RankListAll[RANKTYPE.killMonsterScore]
  local careerTab = rankTab and rankTab[ERoleCareer.All] or {}
  return careerTab
end

function DemonHunt_ListInfoUI:CellAtIndexInTableViewWillAppear(index)
  local rankData = self:GetRankData()
  local cell = self.rankListTableView:GetLoadedCell(index)
  local rankLevel = cell:GetChild("lab_ranking")
  local img_rank = cell:GetChild("img_rank")
  local labName = cell:GetChild("lab_name")
  local lab_text = cell:GetChild("lab_text")
  if not rankData or not rankData[index] then
    return
  end
  local des = "\196\144i\225\187\131m: " .. rankData[index].killMonsterScore
  des = string.GetColorText(des, ItemQuality2ColorDic[EItemColorEnum.orange])
  local data = ClientTable.cfg_DemonHunt_rankRewardManager:TryGetValue(index)
  local buffs = string.split(data.buffReward, "#")
  for i, v in ipairs(buffs) do
    local buffdes = ClientTable.cfg_Buff_buffManager:TryGetValue(tonumber(v))
    if buffdes and buffdes.desc then
      des = des .. "\n" .. string.GetColorText(buffdes.desc, ItemQuality2ColorDic[EItemColorEnum.blue])
    end
  end
  lab_text:SetText(des)
  labName:SetText(rankData[index].name)
  if 1 <= index and index <= 3 then
    local rankStr = string.format("img_DemonHunt_rankList_icon_%d", index)
    self:SetSprite("Atlas_Common", rankStr, img_rank)
    rankLevel:SetActive(false)
    img_rank:SetActive(true)
  elseif 3 < index then
    rankLevel:SetActive(true)
    img_rank:SetActive(false)
    rankLevel:SetText(index)
  end
end

DemonHunt_ListInfoUI.selfScore = 0

function DemonHunt_ListInfoUI:RefreshSelfInfo(id, msg)
  if msg and msg.score then
    self.selfScore = msg.score
  end
  local lab_name = self.myRankInfo:GetChild("lab_name")
  local lab_text = self.myRankInfo:GetChild("lab_text")
  local rankLevel = self.myRankInfo:GetChild("lab_ranking")
  local img_rank = self.myRankInfo:GetChild("img_rank")
  lab_name:SetText(RoleManager.me.name)
  local rankData = self:GetRankData()
  local count = table.count(rankData)
  for index = 1, count do
    if RoleManager.me.id == RankListData.GetPlayerId(RANKTYPE.killMonsterScore, ERoleCareer.All, index) then
      if 1 <= index and index <= 3 then
        local rankStr = string.format("img_DemonHunt_rankList_icon_%d", index)
        self:SetSprite("Atlas_Common", rankStr, img_rank)
        rankLevel:SetActive(false)
        img_rank:SetActive(true)
      elseif 3 < index then
        rankLevel:SetActive(true)
        img_rank:SetActive(false)
        rankLevel:SetText(index)
      end
      local des = "\196\144i\225\187\131m: " .. self.selfScore
      des = string.GetColorText(des, ItemQuality2ColorDic[EItemColorEnum.orange])
      local data = ClientTable.cfg_DemonHunt_rankRewardManager:TryGetValue(index)
      local buffs = string.split(data.buffReward, "#")
      for i, v in ipairs(buffs) do
        local buffdes = ClientTable.cfg_Buff_buffManager:TryGetValue(tonumber(v))
        if buffdes and buffdes.desc then
          des = des .. "\n" .. string.GetColorText(buffdes.desc, ItemQuality2ColorDic[EItemColorEnum.blue])
        end
      end
      lab_text:SetText(des)
      return
    end
  end
  lab_text:SetText("\196\144i\225\187\131m: " .. self.selfScore)
  rankLevel:SetActive(true)
  img_rank:SetActive(false)
  rankLevel:SetText("Ch\198\176a l\195\170n BXH")
end

function DemonHunt_ListInfoUI:RefreshLeaderListShow(winMember)
  for i, v in ipairs(self.leaderList) do
    v:GetChild("img_jy"):SetActive(true)
    v:GetChild("lab_tips"):SetActive(false)
  end
  if not winMember then
    return
  end
  for i, v in ipairs(self.leaderList) do
    local name = v:GetChild("lab_Name")
    local lab_tips = v:GetChild("lab_tips")
    name:SetActive(false)
    if not winMember[i] then
      lab_tips:SetActive(false)
      break
    end
    local winRole = winMember[i]
    local modelViewer = self.modeViewerList[i]
    local model = v:GetChild("go_model")
    name:SetActive(true)
    name:SetText(winRole.name)
    lab_tips:SetActive(true)
    local des = "\196\144i\225\187\131m: " .. winRole.killMonsterScore
    des = string.GetColorText(des, ItemQuality2ColorDic[EItemColorEnum.orange])
    local data = ClientTable.cfg_DemonHunt_rankRewardManager:TryGetValue(i)
    local buffs = string.split(data.buffReward, "#")
    for i, v in ipairs(buffs) do
      local buffdes = ClientTable.cfg_Buff_buffManager:TryGetValue(tonumber(v))
      if buffdes and buffdes.desc then
        des = des .. "\n" .. string.GetColorText(buffdes.desc, ItemQuality2ColorDic[EItemColorEnum.blue])
      end
    end
    lab_tips:SetText(des)
    v:GetChild("img_jy"):SetActive(false)
    local viewRoleData = {}
    local equipData = RoleEquipData(winRole.equips)
    viewRoleData.equipsData = equipData
    viewRoleData.career = winRole.career
    viewRoleData.modelType = EModelType.Charactor
    viewRoleData.model = 1003
    viewRoleData.id = winRole.lid
    viewRoleData.parent = model.transform
    viewRoleData.serverCoord = Vector2Int()
    viewRoleData.roleType = ERoleType.Player
    if winRole.lid ~= ViewData.meData.id then
      ForgeData.appearData[winRole.lid] = winRole.appear or "{}"
    end
    if not modelViewer then
      modelViewer = ViewRole(viewRoleData)
      if modelViewer then
        modelViewer:SetPosition(0, -170, -10)
        table.insert(self.modeViewerList, i, modelViewer)
      end
    else
      modelViewer:RefreshModel(viewRoleData)
    end
    if modelViewer then
      modelViewer:SetRotation(0, -180, 0)
    end
  end
end

function DemonHunt_ListInfoUI:HideModel(hide)
  if hide then
    self.leaderList[1]:SetActive(false)
    self.leaderList[3]:SetActive(false)
  else
    self.leaderList[1]:SetActive(true)
    self.leaderList[3]:SetActive(true)
  end
end

function DemonHunt_ListInfoUI:OnHide()
  self:ServerRankDestory()
  if self.RemainTimeLoop ~= nil then
    Timer.Stop(self.RemainTimeLoop)
  end
  self.selfScore = 0
end

function DemonHunt_ListInfoUI:ServerRankDestory()
  for i, v in ipairs(self.leaderList) do
    local nameModel = v:GetChild("lab_Name")
    nameModel:SetText("")
    nameModel:SetActive(false)
    local btn_check = v:GetChild("lab_tips")
    btn_check:SetActive(false)
    v:GetChild("img_jy"):SetActive(true)
  end
  for i, v in pairs(self.modeViewerList) do
    v:Destroy()
  end
  self.modeViewerList = {}
end

function DemonHunt_ListInfoUI:OnDestroy()
end
