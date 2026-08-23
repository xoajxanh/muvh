local SpaceCrackActivityTemplate = {}

function SpaceCrackActivityTemplate:Init(rootPanel)
  self.rootPanel = rootPanel
  self:InitControls()
  self:InitUI()
  self:BindUIEvents()
end

function SpaceCrackActivityTemplate:InitControls()
  self.btn_goRank = self:GetControl("go_main/img_Bg/btn_goRank")
  self.btn_goPerson = self:GetControl("go_main/img_Bg/btn_goPerson")
  self.btn_detail = self:GetControl("go_main/img_Bg/btn_detail")
  self.frame_item = self:GetControl("go_main/img_Bg/frame_item")
  self.btn_obtain = self:GetControl("go_main/img_Bg/frame_item/btn_obtain")
  self.state = self:GetControl("go_main/img_Bg/state")
  self.lab_signUp = self:GetControl("go_main/img_Bg/state/lab_signUp")
  self.lab_success = self:GetControl("go_main/img_Bg/state/lab_success")
  self.lab_fail = self:GetControl("go_main/img_Bg/state/lab_fail")
  self.lab_matching = self:GetControl("go_main/img_Bg/state/lab_matching")
  self.lab_union_name = self:GetControl("go_main/img_Bg/state/join_name")
  self.sw_joinUnion = self:GetControl("go_main/img_Bg/sw_joinUnion")
  self.JuItem = self:GetControl("go_main/img_Bg/sw_joinUnion/Viewport/Content/JuItem")
  self.btn_signUp = self:GetControl("go_main/img_Bg/btn_signUp")
  self.btn_goScene = self:GetControl("go_main/img_Bg/btn_goScene")
  self.bg_joinUnion = self:GetControl("go_main/img_Bg/bg_joinUnion")
  self.lab_siegeOpenTime = self:GetControl("go_main/img_Bg/bg_ActivityDes/lab_siegeTime/lab_siegeOpenTime")
  self.go_main = self:GetControl("go_main")
  self.panel_detail = self:GetControl("panel_detail")
  self.panel_union_rank = self:GetControl("panel_union_rank")
  self.panel_person_rank = self:GetControl("panel_person_rank")
  self.panel_union_rankClose = self:GetControl("panel_union_rank/img_bg/btn_close")
  self.panel_person_rankClose = self:GetControl("panel_person_rank/img_bg/btn_close")
  self.panel_detailClose = self:GetControl("panel_detail/btn_close")
  self.unionReward = self:GetControl("panel_detail/panel_UnionReward/Viewport/Content/sw/Viewport/Content/itemRank")
  self.personReward = self:GetControl("panel_detail/panel_personReward/sw/Viewport/Content/itemRank")
  self.rushLevelRewardItem = self:GetControl("panel_detail/panel_UnionReward/Viewport/Content/Reward_Drop/dropReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.boxRewardItem = self:GetControl("panel_detail/panel_UnionReward/Viewport/Content/Reward_PaoDian/paoDianReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.union_rank_Item = self:GetControl("panel_union_rank/img_bg/Scroll View/Viewport/Content/union_rank")
  self.person_rank_Item = self:GetControl("panel_person_rank/img_bg/Scroll View/Viewport/Content/person_rank")
  self.union_Lab_Rank_My = self:GetControl("panel_union_rank/img_bg/MyRank/lab_rank")
  self.union_img_noRank_My = self:GetControl("panel_union_rank/img_bg/MyRank/img_noRank")
  self.union_Lab_unionName_My = self:GetControl("panel_union_rank/img_bg/MyRank/lab_unionName")
  self.union_Lab_Name_My = self:GetControl("panel_union_rank/img_bg/MyRank/lab_name")
  self.union_Lab_value_My = self:GetControl("panel_union_rank/img_bg/MyRank/lab_value")
  self.union_Btn_giftItem_My = self:GetControl("panel_union_rank/img_bg/MyRank/gift/btn_giftItem")
  self.person_Lab_Rank_My = self:GetControl("panel_person_rank/img_bg/MyRank/lab_rank")
  self.person_img_noRank_My = self:GetControl("panel_person_rank/img_bg/MyRank/img_noRank")
  self.person_Lab_Name_My = self:GetControl("panel_person_rank/img_bg/MyRank/lab_name")
  self.person_Lab_unionName_My = self:GetControl("panel_person_rank/img_bg/MyRank/lab_unionName")
  self.person_Lab_value_My = self:GetControl("panel_person_rank/img_bg/MyRank/lab_value")
  self.person_Btn_giftItem_My = self:GetControl("panel_person_rank/img_bg/MyRank/gift/btn_giftItem")
  self.this = self:GetControl()
end

local function OnInvitedUnionItemCreate(_control)
  _control.lab_Name = UIControl(_control.transform, "lab_name")
end

local function OnInvitedUnionItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  _control.lab_Name:SetText(string.format("S%s.%s", _data.serverId, _data.unionName))
end

local function OnRushLevelRewardItemCreate(_control)
  _control.itemCtr = ItemUtility.InitItemCell(UIControl(_control.transform))
  _control.modelData = ItemCellData()
end

local function OnRushLevelRewardItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  local itemData = ItemUtility.GenerateItemData(_data)
  _control.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(_control.itemCtr, _control.modelData, _ui, true)
end

local function OnRewardItemCreate(_control)
  _control.itemCtr = ItemUtility.InitItemCell(UIControl(_control.transform))
  _control.modelData = ItemCellData()
end

local function OnRewardItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  local itemData = ItemUtility.GenerateItemData(_data.itemId)
  itemData.count = _data.count
  _control.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(_control.itemCtr, _control.modelData, _ui, true)
end

local function OnUnionRankItemCreate(_control)
  _control.lab_rank = UIControl(_control.transform, "lab_rank")
  _control.img_rankIcon = UIControl(_control.transform, "img_rankIcon")
  _control.lab_name = UIControl(_control.transform, "lab_name")
  _control.lab_value = UIControl(_control.transform, "lab_value")
  _control.lab_unionName = UIControl(_control.transform, "lab_unionName")
  _control.btn_giftItem = UIControl(_control.transform, "gift/btn_giftItem")
  _control.rankIconDic = {
    [1] = "ico_1",
    [2] = "ico_2",
    [3] = "ico_3"
  }
end

local function OnUnionRankItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  if _control.rewardContainer == nil then
    _control.rewardContainer = UIContainer(_control.btn_giftItem, _ui, OnRewardItemCreate, OnRewardItemRefresh)
  end
  _control.rewardContainer:SetActiveTable()
  if _data.rank <= 3 then
    _ui:SetSprite("Atlas_Main", _control.rankIconDic[_data.rank], _control.img_rankIcon)
    _control.lab_rank:SetText("")
  else
    _control.img_rankIcon:SetActive(false)
    _control.lab_rank:SetText(_data.rank)
  end
  _control.lab_unionName:SetText(string.format("S%s.%s", _data.serverId, _data.unionName))
  _control.lab_name:SetText(_data.leaderName)
  _control.lab_value:SetText(_data.score)
  local unionRankRewardInfoData = QuickFind:GetSpaceCrackDataManager().m_UnionRankRewardInfoData
  local rankRewardData = QuickFind:GetSpaceCrackDataManager():GetAppointRankRewardData(unionRankRewardInfoData, _data.rank)
  if rankRewardData == nil then
    return
  end
  _control.rewardContainer:SetData(rankRewardData)
end

local function OnPersonRankItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  if _control.rewardContainer == nil then
    _control.rewardContainer = UIContainer(_control.btn_giftItem, _ui, OnRewardItemCreate, OnRewardItemRefresh)
  end
  _control.rewardContainer:SetActiveTable()
  if _data.rank <= 3 then
    _ui:SetSprite("Atlas_Main", _control.rankIconDic[_data.rank], _control.img_rankIcon)
    _control.lab_rank:SetText("")
  else
    _control.img_rankIcon:SetActive(false)
    _control.lab_rank:SetText(_data.rank)
  end
  _control.lab_name:SetText(_data.name)
  _control.lab_value:SetText(_data.score)
  _control.lab_unionName:SetText(_data.unionName)
  local personRankRewardInfoData = QuickFind:GetSpaceCrackDataManager().m_PersonRankRewardInfoData
  local rankRewardData = QuickFind:GetSpaceCrackDataManager():GetAppointRankRewardData(personRankRewardInfoData, _data.rank)
  if rankRewardData == nil then
    return
  end
  _control.rewardContainer:SetData(rankRewardData)
end

function SpaceCrackActivityTemplate:InitUI()
  self.itemCtr = ItemUtility.InitItemCell(self.frame_item)
  self.modelData = ItemCellData()
  self.invitedUnionContainer = UIContainer(self.JuItem, self, OnInvitedUnionItemCreate, OnInvitedUnionItemRefresh)
  self.rushLevelRewardContainer = UIContainer(self.rushLevelRewardItem, self.rootPanel, OnRushLevelRewardItemCreate, OnRushLevelRewardItemRefresh)
  self.boxRewardContainer = UIContainer(self.boxRewardItem, self.rootPanel, OnRushLevelRewardItemCreate, OnRushLevelRewardItemRefresh)
  self.unionRewardContainer = UIUtility.BindUIContainerTemp(self.unionReward, LuaComponentTemplates.CrossServerDesRewardTemplate, self, {
    rootPanel = self.rootPanel
  })
  self.personRewardContainer = UIUtility.BindUIContainerTemp(self.personReward, LuaComponentTemplates.CrossServerDesRewardTemplate, self, {
    rootPanel = self.rootPanel
  })
  self.unionRankContainer = UIContainer(self.union_rank_Item, self.rootPanel, OnUnionRankItemCreate, OnUnionRankItemRefresh)
  self.personRankContainer = UIContainer(self.person_rank_Item, self.rootPanel, OnUnionRankItemCreate, OnPersonRankItemRefresh)
  self.union_Btn_giftItem_MyContainer = UIContainer(self.union_Btn_giftItem_My, self.rootPanel, OnRewardItemCreate, OnRewardItemRefresh)
  self.person_Btn_giftItem_MyContainer = UIContainer(self.person_Btn_giftItem_My, self.rootPanel, OnRewardItemCreate, OnRewardItemRefresh)
end

function SpaceCrackActivityTemplate:BindUIEvents()
  self.btn_goRank:SetOnClick(self, self.btn_goRankOnClick)
  self.btn_goPerson:SetOnClick(self, self.btn_goPersonOnClick)
  self.btn_detail:SetOnClick(self, self.btn_detailOnClick)
  self.panel_union_rankClose:SetOnClick(self, self.panel_union_rankCloseOnClick)
  self.panel_person_rankClose:SetOnClick(self, self.panel_person_rankCloseOnClick)
  self.panel_detailClose:SetOnClick(self, self.panel_detailCloseOnClick)
  self.btn_obtain:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
  self.btn_signUp:SetOnClick(self, self.btn_signUpOnClick)
  self.btn_goScene:SetOnClick(self, self.btn_goSceneOnClick)
end

function SpaceCrackActivityTemplate:btn_goRankOnClick()
  self:ResetPanel()
  self.panel_union_rank:SetActive(true)
end

function SpaceCrackActivityTemplate:btn_goPersonOnClick()
  self:ResetPanel()
  self.panel_person_rank:SetActive(true)
end

function SpaceCrackActivityTemplate:btn_detailOnClick()
  self:ResetPanel()
  self.panel_detail:SetActive(true)
end

function SpaceCrackActivityTemplate:panel_union_rankCloseOnClick()
  self:ResetPanel()
  self.go_main:SetActive(true)
end

function SpaceCrackActivityTemplate:panel_person_rankCloseOnClick()
  self:ResetPanel()
  self.go_main:SetActive(true)
end

function SpaceCrackActivityTemplate:panel_detailCloseOnClick()
  self:ResetPanel()
  self.go_main:SetActive(true)
end

function SpaceCrackActivityTemplate:btn_signUpOnClick()
  SpaceCrackController.ReqJoinTimeCrack(SpaceCrackMapData.SignUpCount)
  SpaceCrackController.ReqTimeCrackPanel()
end

function SpaceCrackActivityTemplate:btn_goSceneOnClick()
  SpaceCrackController.ReqEnterTimeCrack()
end

function SpaceCrackActivityTemplate:RefreshPanel()
  self:Refresh()
  SpaceCrackController.ReqTimeCrackPanel()
  SpaceCrackController.ReqSpaceCrackPersonRank()
  SpaceCrackController.ReqSpaceCrackUnionRank()
  self.this:SetActive(true)
  self:ResetPanel()
  self.go_main:SetActive(true)
end

function SpaceCrackActivityTemplate:Refresh()
  self:RefreshMainPanel()
  self:RefreshDetailPanel()
  self:RefreshUnionRankPanel()
  self:RefreshPersonRankPanel()
end

function SpaceCrackActivityTemplate:ResetPanel()
  self.go_main:SetActive(false)
  self.panel_detail:SetActive(false)
  self.panel_union_rank:SetActive(false)
  self.panel_person_rank:SetActive(false)
end

function SpaceCrackActivityTemplate:RefreshMainPanel()
  self:RefreshState()
end

function SpaceCrackActivityTemplate:RefreshState()
  self.lab_signUp:SetActive(false)
  self.lab_success:SetActive(false)
  self.lab_fail:SetActive(false)
  self.lab_matching:SetActive(false)
  self.lab_union_name:SetActive(false)
  self.sw_joinUnion:SetActive(false)
  self.frame_item:SetActive(false)
  self.btn_signUp:SetActive(false)
  self.btn_goScene:SetActive(false)
  self.bg_joinUnion:SetActive(false)
  local resTimeCrackPanelInfoData = QuickFind:GetSpaceCrackDataManager().m_ResTimeCrackPanelInfoData
  local openActivityCond = ClientTable.cfg_Activity_overviewManager:TryGetValue(5003, "activityId").condition
  local isOpen = ConditionManager.Check4D(openActivityCond)
  self.lab_siegeOpenTime:SetColor(isOpen and EUIColor.Green or EUIColor.Red)
  if resTimeCrackPanelInfoData == nil then
    self.btn_goScene:SetActive(true)
    return
  end
  if WarAllianceData.MyWarAllianceData then
    self.lab_union_name:SetText(WarAllianceData.MyWarAllianceData.name)
  end
  if resTimeCrackPanelInfoData.showType == SpaceCrackActivityState.SignUp then
    self.bg_joinUnion:SetActive(true)
    self.lab_union_name:SetActive(true)
    local config = ClientTable.cfg_Activity_globalManager:TryGetValue(500304)
    if config == nil or string.isNullOrEmpty(config.effect) then
      return
    end
    local effectTab = string.split(config.effect, "#")
    local itemId, itemNum = tonumber(effectTab[1]), tonumber(effectTab[2])
    if itemNum <= resTimeCrackPanelInfoData.itemCount then
      self.lab_success:SetActive(true)
      self.btn_goScene:SetActive(true)
    else
      self:RefreshSubmitCount(resTimeCrackPanelInfoData.itemCount, itemNum)
      self:RefreshModelData(resTimeCrackPanelInfoData.itemFree, itemId)
      self.btn_signUp:SetActive(true)
    end
  elseif resTimeCrackPanelInfoData.showType == SpaceCrackActivityState.Matching then
    self.lab_union_name:SetActive(true)
    self.bg_joinUnion:SetActive(true)
    if resTimeCrackPanelInfoData.join then
      self.lab_matching:SetActive(true)
      self.btn_goScene:SetActive(true)
    else
      self.lab_fail:SetActive(true)
      self.btn_goScene:SetActive(true)
    end
  elseif resTimeCrackPanelInfoData.showType == SpaceCrackActivityState.Open then
    if resTimeCrackPanelInfoData.join then
      self.bg_joinUnion:SetActive(true)
      self:RefreshUnion(resTimeCrackPanelInfoData.unions)
      self.btn_goScene:SetActive(true)
    else
      self.btn_goScene:SetActive(true)
    end
  end
end

function SpaceCrackActivityTemplate:RefreshSubmitCount(_itemCount, _itemNum)
  if _itemCount == nil or _itemNum == nil then
    return
  end
  local color = _itemCount < _itemNum and ItemQuality2ColorDic[7] or ItemQuality2ColorDic[5]
  self.lab_signUp:SetActive(true)
  self.lab_signUp:GetChild("number"):SetText(string.GetColorText(string.format("%s/%s", _itemCount, _itemNum), color))
end

function SpaceCrackActivityTemplate:RefreshModelData(_itemFree, _itemId)
  if _itemFree == nil or _itemId == nil then
    return
  end
  self.frame_item:SetActive(true)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(_itemId)
  local itemData = ItemUtility.GenerateItemData(_itemId)
  self.modelData:RefreshData(itemData)
  self.btn_obtain.itemData = itemData
  ItemUtility.ShowItemCell(self.itemCtr, self.modelData, self.rootPanel, true)
  self.frame_item:GetChild("lab_num"):SetActive(true)
  local numberText, color
  if _itemFree then
    numberText = string.GetColorText("Mi\225\187\133n ph\195\173 l\225\186\167n \196\145\225\186\167u", ItemQuality2ColorDic[5])
    self.btn_obtain:SetActive(false)
  else
    color = bagCount < SpaceCrackMapData.SignUpCount and ItemQuality2ColorDic[7] or ItemQuality2ColorDic[5]
    numberText = string.GetColorText(string.format("%s/%s", bagCount, SpaceCrackMapData.SignUpCount), color)
    self.btn_obtain:SetActive(bagCount < SpaceCrackMapData.SignUpCount)
  end
  self.frame_item:GetChild("lab_num"):SetText(numberText)
end

function SpaceCrackActivityTemplate:RefreshUnion(_unions)
  self.invitedUnionContainer:SetActiveTable()
  if _unions == nil then
    return
  end
  self.sw_joinUnion:SetActive(true)
  self.invitedUnionContainer:SetData(_unions)
end

function SpaceCrackActivityTemplate:RefreshDetailPanel()
  self.unionRewardContainer:SetActiveTable()
  self.personRewardContainer:SetActiveTable()
  self.rushLevelRewardContainer:SetActiveTable()
  self.boxRewardContainer:SetActiveTable()
  local unionRankRewardInfoData = QuickFind:GetSpaceCrackDataManager().m_UnionRankRewardInfoData
  if unionRankRewardInfoData then
    self.unionRewardContainer:SetData(unionRankRewardInfoData)
  end
  local personRankRewardInfoData = QuickFind:GetSpaceCrackDataManager().m_PersonRankRewardInfoData
  if personRankRewardInfoData then
    self.personRewardContainer:SetData(personRankRewardInfoData)
  end
  local rushLevelRewardInfoData = QuickFind:GetSpaceCrackDataManager().m_RushLevelRewardInfoData
  if rushLevelRewardInfoData then
    self.rushLevelRewardContainer:SetData(rushLevelRewardInfoData)
  end
  local boxRewardInfoData = QuickFind:GetSpaceCrackDataManager().m_BoxRewardInfoData
  if boxRewardInfoData then
    self.boxRewardContainer:SetData(boxRewardInfoData)
  end
end

function SpaceCrackActivityTemplate:RefreshUnionRankPanel()
  self.unionRankContainer:SetActiveTable()
  self.union_img_noRank_My:SetActive(true)
  self.union_Lab_Rank_My:SetText("")
  self.union_Lab_unionName_My:SetText("")
  self.union_Lab_Name_My:SetText("")
  self.union_Lab_value_My:SetText("")
  self.union_Btn_giftItem_MyContainer:SetActiveTable()
  local spaceCrackActivityUnionRankInfoData = QuickFind:GetSpaceCrackDataManager().m_SpaceCrackActivityUnionRankInfoData
  if spaceCrackActivityUnionRankInfoData == nil or spaceCrackActivityUnionRankInfoData.ranks == nil then
    return
  end
  self.unionRankContainer:SetData(spaceCrackActivityUnionRankInfoData.ranks)
  local selfUnionRankData
  for i, v in ipairs(spaceCrackActivityUnionRankInfoData.ranks) do
    if WarAllianceData.IsHaveUnion and WarAllianceData.MyWarAllianceData and v.unionId == WarAllianceData.MyWarAllianceData.id then
      selfUnionRankData = v
      break
    end
  end
  if selfUnionRankData == nil then
    return
  end
  self.union_Lab_Rank_My:SetText(selfUnionRankData.rank)
  self.union_Lab_unionName_My:SetText(string.format("S%s.%s", selfUnionRankData.serverId, selfUnionRankData.unionName))
  self.union_Lab_Name_My:SetText(selfUnionRankData.leaderName)
  self.union_Lab_value_My:SetText(selfUnionRankData.score)
  self.union_img_noRank_My:SetActive(false)
  local unionRankRewardInfoData = QuickFind:GetSpaceCrackDataManager().m_UnionRankRewardInfoData
  local rankRewardData = QuickFind:GetSpaceCrackDataManager():GetAppointRankRewardData(unionRankRewardInfoData, selfUnionRankData.rank)
  if rankRewardData == nil then
    return
  end
  self.union_Btn_giftItem_MyContainer:SetData(rankRewardData)
end

function SpaceCrackActivityTemplate:RefreshPersonRankPanel()
  self.personRankContainer:SetActiveTable()
  self.person_img_noRank_My:SetActive(true)
  self.person_Lab_Rank_My:SetText("")
  self.person_Lab_Name_My:SetText("")
  self.person_Lab_unionName_My:SetText("")
  self.person_Lab_value_My:SetText("")
  self.person_Btn_giftItem_MyContainer:SetActiveTable()
  local spaceCrackActivityPersonRankInfoData = QuickFind:GetSpaceCrackDataManager().m_SpaceCrackActivityPersonRankInfoData
  if spaceCrackActivityPersonRankInfoData == nil or spaceCrackActivityPersonRankInfoData.ranks == nil then
    return
  end
  self.personRankContainer:SetData(spaceCrackActivityPersonRankInfoData.ranks)
  local selfPersonRankData
  for i, v in ipairs(spaceCrackActivityPersonRankInfoData.ranks) do
    if v.rid == RoleManager.me.id then
      selfPersonRankData = v
      break
    end
  end
  if selfPersonRankData == nil then
    return
  end
  self.person_Lab_Rank_My:SetText(selfPersonRankData.rank)
  self.person_Lab_Name_My:SetText(selfPersonRankData.name)
  self.person_Lab_unionName_My:SetText(selfPersonRankData.unionName)
  self.person_Lab_value_My:SetText(selfPersonRankData.score)
  self.person_img_noRank_My:SetActive(false)
  local personRankRewardInfoData = QuickFind:GetSpaceCrackDataManager().m_PersonRankRewardInfoData
  local rankRewardData = QuickFind:GetSpaceCrackDataManager():GetAppointRankRewardData(personRankRewardInfoData, selfPersonRankData.rank)
  if rankRewardData == nil then
    return
  end
  self.person_Btn_giftItem_MyContainer:SetData(rankRewardData)
end

function SpaceCrackActivityTemplate:Update()
  if not SpaceCrackUtility:CheckRefreshCondition() then
    return
  end
  if self.timer == nil or self.timer >= SpaceCrackMapData.RefreshInterval then
    self.timer = 0
    SpaceCrackController.ReqTimeCrackPanel()
  end
  self.timer = self.timer + Time.unscaledDeltaTime
end

function SpaceCrackActivityTemplate:Exit()
  self.this:SetActive(false)
end

return SpaceCrackActivityTemplate
