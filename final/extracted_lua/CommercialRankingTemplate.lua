local CommercialRankingTemplate = {}
CommercialRankingTemplate.activityData = nil

function CommercialRankingTemplate:Init(data)
  self.root = data
  self:InitControls()
  self:InitContent()
  self:BindOnClick()
  self:EventUI()
  self:GameMgrAllRank().path = self.root
  self.combinerank = UIUtility.BindUIContainerTemp(self.person_rank, LuaComponentTemplates.Activity_CommercialRankTemplate, self.root, self.root)
end

function CommercialRankingTemplate:InitControls()
  self.btn_close = self:GetControl("ConsumeRank_AllPanel/img_bg/btn_close")
  self.bg_blackbox = self:GetControl("ConsumeRank_AllPanel/bg_blackbox")
  self.desc_1 = self:GetControl("RankDes/Desc_1/desc_1")
  self.desc_2 = self:GetControl("RankDes/Desc_2/desc_2")
  self.desc_3 = self:GetControl("RankDes/Desc_3/desc_3")
  self.txt_lastTimeGift = self:GetControl("txt_lastTimeGift")
  self.btn_AllRank = self:GetControl("btn_AllRank")
  self.lb_rankNum = self:GetControl("MyRank/lb_rankNum")
  self.img_frist = self:GetControl("sw_rankList/Viewport/Content/img_frist")
  self.img_second = self:GetControl("sw_rankList/Viewport/Content/img_second")
  self.img_third = self:GetControl("sw_rankList/Viewport/Content/img_third")
  self.ConsumeRank_AllPanel = self:GetControl("ConsumeRank_AllPanel")
  self.person_rank = self:GetControl("ConsumeRank_AllPanel/img_bg/Scroll View/Viewport/Content/person_rank")
  self.img_fristrankItem = self:GetControl("sw_rankList/Viewport/Content/img_frist/sw_reward/Viewport/Content/Iteminfo")
  self.img_secondrankItem = self:GetControl("sw_rankList/Viewport/Content/img_second/sw_reward/Viewport/Content/Iteminfo")
  self.img_thirdrankItem = self:GetControl("sw_rankList/Viewport/Content/img_third/sw_reward/Viewport/Content/Iteminfo")
end

local function ItemCreate(control)
  control.btn_item = UIControl(control.transform, "btn_Item")
  if control.itemCellData then
    control.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    control.itemCellData = itemCellData
  end
end

local function ItemRefresh(ctr, _, itemData, ui)
  if not ctr.itemCellData then
    ctr.itemCellData = ItemCellData()
  end
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.btn_item, ctr.itemCellData, ui, true)
end

function CommercialRankingTemplate:InitContent()
  self.FirstRankItemTemp = UIContainer(self.img_fristrankItem, self.root, ItemCreate, ItemRefresh)
  self.SecondRankItemTemp = UIContainer(self.img_secondrankItem, self.root, ItemCreate, ItemRefresh)
  self.ThirdRankItemTemp = UIContainer(self.img_thirdrankItem, self.root, ItemCreate, ItemRefresh)
  self.RankItemTemp = {
    self.FirstRankItemTemp,
    self.SecondRankItemTemp,
    self.ThirdRankItemTemp
  }
end

function CommercialRankingTemplate:BindOnClick()
  self.btn_AllRank:SetOnClick(self, self.OnClickAllRank)
  self.btn_close:SetOnClick(self, self.OnClickAllRankPanel)
  self.bg_blackbox:SetOnClick(self, self.OnClickAllRankPanel)
end

function CommercialRankingTemplate:EventUI()
  self.leaderList = {
    self.img_frist,
    self.img_second,
    self.img_third
  }
  self.DescList = {
    self.desc_1,
    self.desc_2,
    self.desc_3
  }
  self.modeViewerList = {}
end

function CommercialRankingTemplate:Refresh()
  self:Exit()
  self:ActivityRank()
  self:ClientToServer()
end

function CommercialRankingTemplate:RefreshModelUI()
  self:ActivityRankItem()
  self:RefreshLeader()
  self:MyRank()
end

function CommercialRankingTemplate:MyRank()
  local winMember = self:GameMgrAllRank().CommercialRankingDataItemList
  local rankData = self:GameMgrAllRank():ActivityRankItemUI()
  local Ranktext = "Ch\198\176a l\195\170n BXH"
  self.lb_rankNum:SetText(Ranktext)
  for i = 1, table.count(rankData) do
    if table.count(winMember) > 0 and table.count(winMember[i]) > 0 and winMember[i].name ~= nil and winMember[i].name == ViewData.meData.name then
      self.lb_rankNum:SetText(tostring(i))
      return
    end
  end
end

function CommercialRankingTemplate:ActivityRank()
  local ActivityRank = self:GameMgrAllRank():ActivityannouncementRankUI()
  for i = 1, table.count(ActivityRank) do
    self.DescList[i]:SetText(ActivityRank[i])
  end
  self.txt_lastTimeGift:SetText(QuickFind:CommercialRankingData():GetRemainTimeDes())
end

function CommercialRankingTemplate:ClientToServer()
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityInfo, {
    icon = CommercializeActivityTab.Combining_service,
    groupId = CommercializeOpeningserGrop.CommercialRanking
  })
end

function CommercialRankingTemplate:OnClickAllRank()
  self.ConsumeRank_AllPanel:SetActive(true)
  self:ActivityRankUI()
end

function CommercialRankingTemplate:OnClickAllRankPanel()
  self.ConsumeRank_AllPanel:SetActive(false)
end

function CommercialRankingTemplate:RefreshLeader()
  local winMember = self:GameMgrAllRank().CommercialRankingDataItemList
  for i, v in ipairs(self.leaderList) do
    v:GetChild("img_jy"):SetActive(true)
    local name = v:GetChild("img_" .. i .. "/lab_Name")
    name:SetText("Tr\225\187\145ng")
  end
  if not winMember then
    return
  end
  local index = 1
  for i, v in ipairs(self.leaderList) do
    local winRole = winMember[i]
    if (table.count(winRole) > 0 or not winRole and winRole ~= nil) and v.job == winRole.job then
      local name = v:GetChild("img_" .. i .. "/lab_Name")
      local modelViewer = self.modeViewerList[index]
      local model = v:GetChild("go_model/go_model")
      name:SetActive(true)
      name:SetText(winRole.name)
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
      if not modelViewer then
        modelViewer = ViewRole(viewRoleData)
        if modelViewer then
          modelViewer:GetParent().transform.localScale = Vector3(0.8, 0.8, 0.8)
          modelViewer.transform.localScale = Vector3(180, 180, 180)
          table.insert(self.modeViewerList, index, modelViewer)
        end
      end
      if equipData then
        modelViewer:SetRotation(0, -180, 0)
        index = index + 1
      end
    end
  end
end

function CommercialRankingTemplate:ActivityRankItem()
  local rankData = self:GameMgrAllRank():ActivityRankItemUI()
  for i = 1, table.count(self.RankItemTemp) do
    if self.RankItemTemp[i] ~= nil then
      self.RankItemTemp[i]:SetData(rankData[i])
    end
  end
end

function CommercialRankingTemplate:ActivityRankUI()
  local rankData = self:GameMgrAllRank():ActivityRankItemUI()
  if not rankData then
    return
  end
  if self.ModelViewItem == nil or self.ModelViewItem ~= rankData then
    self.ModelViewItem = rankData
    self.combinerank:SetData(self.ModelViewItem)
    self:GameMgrAllRank().itemRefrth = true
    self:GameMgrAllRank().Index = 1
  end
end

function CommercialRankingTemplate:GameMgrAllRank()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.ConsumeRanking)
end

function CommercialRankingTemplate:Exit()
  for i, v in pairs(self.modeViewerList) do
    v:Destroy()
  end
  self.modeViewerList = {}
end

return CommercialRankingTemplate
