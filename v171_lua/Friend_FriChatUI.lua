Friend_FriChatUI = class(BaseUI)
Friend_FriChatUI.layer = UILayer.Panel
Friend_FriChatUI.orderInLayer = 2
Friend_FriChatUI.hideType = UIHideType.Hide
Friend_FriChatUI.hideFunc = UIHideFunc.Deactive
Friend_FriChatUI.escClose = UIEscClose.DontClose
require("GameUI/ChatPanel")
require("GameConst/FitModeEnum")

function Friend_FriChatUI:InitControls()
  self.btn_close = self:GetControl("bg_friend/btn_close")
  self.tog_friendList = self:GetControl("bg_friend/go_togList/tog_friendList")
  self.tog_searchList = self:GetControl("bg_friend/go_togList/tog_searchList")
  self.tog_applyList = self:GetControl("bg_friend/go_togList/tog_applyList")
  self.tog_addFriend1 = self:GetControl("bg_friend/go_togList/tog_addFriend/Background")
  self.go_getFriend = self:GetControl("bg_friend/go_getFriend")
  self.btn_AddClose = self:GetControl("bg_friend/go_getFriend/bg/btn_close")
  self.tog_addFriendList1 = self:GetControl("bg_friend/go_getFriend/go_togList/tog_addFriendList")
  self.tog_searchList1 = self:GetControl("bg_friend/go_getFriend/go_togList/tog_search")
  self.btn_closeBg1 = self:GetControl("bg_friend/go_getFriend/btn_closeBg")
  self.tog_addFriend = self:GetControl("bg_friend/go_togList/tog_addFriend")
  self.go_friendAll = self:GetControl("bg_friend/go_friendAll")
  self.go_lookup = self:GetControl("bg_friend/go_getFriend/go_lookup")
  self.go_apply = self:GetControl("bg_friend/go_getFriend/go_apply")
  self.btn_lookup = self:GetControl("bg_friend/go_getFriend/go_lookup/btn_lookup")
  self.Input_roleName = self:GetControl("bg_friend/go_getFriend/go_lookup/Input_roleName")
  self.btn_change = self:GetControl("bg_friend/go_getFriend/go_lookup/bg_autoFriendList/btn_change")
  self.img_bgNoFriend = self:GetControl("bg_friend/go_friendAll/go_friend/img_bgNoFriend")
  self.img_leftLineFriend = self:GetControl("bg_friend/go_friendAll/go_friend/img_leftLine")
  self.btn_getFriend = self:GetControl("bg_friend/go_friendAll/go_friend/img_bgNoFriend/btn_getFriend")
  self.go_chatContent = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent")
  self.lab_noAddFriend = self:GetControl("bg_friend/go_getFriend/go_lookup/bg_autoFriendList/lab_noAddFriend")
  self.lab_blackTimeList = self:GetControl("bg_friend/go_friendAll/go_blacklist/bg_rightBlackList/sw_killList/Viewport/Content/lab_killList")
  self.img_auto = self:GetControl("bg_friend/go_getFriend/go_lookup/bg_autoFriendList/img_auto")
  self.sw_lookList = self:GetControl("bg_friend/go_getFriend/go_lookup/sw_lookList")
  self.sw_recommendList = self:GetControl("bg_friend/go_getFriend/go_lookup/sw_recommendList")
  self.img_lookBg = self:GetControl("bg_friend/go_getFriend/go_lookup/sw_lookList/img_lookBg")
  self.img_recommendBg = self:GetControl("bg_friend/go_getFriend/go_lookup/sw_recommendList/img_recommendBg")
  self.tog_friend = self:GetControl("bg_friend/go_friendAll/go_toggle/tog_friend")
  self.tog_blacklist = self:GetControl("bg_friend/go_friendAll/go_toggle/tog_blacklist")
  self.tog_enemy = self:GetControl("bg_friend/go_friendAll/go_toggle/tog_enemy")
  self.go_friend = self:GetControl("bg_friend/go_friendAll/go_friend")
  self.sw_friendChatList = self:GetControl("bg_friend/go_friendAll/go_friend/sw_friendChatList")
  self.img_friendChatList = self:GetControl("bg_friend/go_friendAll/go_friend/sw_friendChatList/img_friendChatList")
  self.Txt_FriendlistNum = self:GetControl("bg_friend/go_friendAll/go_friend/sw_friendChatList/Txt_FriendlistNum")
  self.go_blacklist = self:GetControl("bg_friend/go_friendAll/go_blacklist")
  self.img_leftLineblack = self:GetControl("bg_friend/go_friendAll/go_blacklist/img_leftLine")
  self.go_enemy = self:GetControl("bg_friend/go_friendAll/go_enemy")
  self.bg_rightBlackList = self:GetControl("bg_friend/go_friendAll/go_blacklist/bg_rightBlackList")
  self.lab_noBlack = self:GetControl("bg_friend/go_friendAll/go_blacklist/lab_noBlack")
  self.go_black = self:GetControl("bg_friend/go_friendAll/go_blacklist/bg_rightBlackList/go_black")
  self.btn_deleteblacklist = self:GetControl("bg_friend/go_friendAll/go_blacklist/bg_rightBlackList/go_black/btn_deleteblacklist")
  self.go_blackInputRemarks = self:GetControl("bg_friend/go_friendAll/go_blacklist/bg_rightBlackList/go_black/lab_remarks/Input_remarks")
  self.sw_friendBlackList = self:GetControl("bg_friend/go_friendAll/go_blacklist/sw_friendBlackList")
  self.Txt_BlacklistNum = self:GetControl("bg_friend/go_friendAll/go_blacklist/sw_friendBlackList/Txt_BlacklistNum")
  self.img_friendBlackList = self:GetControl("bg_friend/go_friendAll/go_blacklist/sw_friendBlackList/img_friendBlackList")
  self.lab_noEnemy = self:GetControl("bg_friend/go_friendAll/go_enemy/lab_noEnemy")
  self.img_leftLineEnemy = self:GetControl("bg_friend/go_friendAll/go_enemy/img_leftLine")
  self.bg_List = self:GetControl("bg_friend/go_friendAll/go_enemy/bg_List")
  self.sw_enemyList = self:GetControl("bg_friend/go_friendAll/go_enemy/sw_enemyList")
  self.img_enemyList = self:GetControl("bg_friend/go_friendAll/go_enemy/sw_enemyList/img_enemyList")
  self.go_enemyInformation = self:GetControl("bg_friend/go_friendAll/go_enemy/bg_rightList/go_enemyInformation")
  self.lab_killList = self:GetControl("bg_friend/go_friendAll/go_enemy/bg_rightList/go_enemyInformation/sw_killList/Viewport/Content/lab_killList")
  self.sw_applyList = self:GetControl("bg_friend/go_getFriend/go_apply/sw_applyList")
  self.img_applyBg = self:GetControl("bg_friend/go_getFriend/go_apply/sw_applyList/img_applyBg")
  self.go_chatContent = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent")
  self.img_friendName = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_friendName")
  self.btn_magnifier = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_friendName/btn_magnifier")
  self.img_friendInputRemarks = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_friendName/Input_remarks")
  self.img_inputChat = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat")
  self.btn_voice = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/btn_voice")
  self.btn_other = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/btn_other")
  self.Button_OK = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/Button_OK")
  self.img_other = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other")
  self.btn_emoji = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/btn_emoji")
  self.btn_position = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/btn_position")
  self.btn_item = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/btn_item")
  self.bg_emojiList = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/bg_emojiList")
  self.Button_emoji = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/bg_emojiList/bg_emojiList/Viewport/Content/Button_emoji")
  self.go_itemInput = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/go_itemInput")
  self.tog_bag = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/go_itemInput/tog_bag")
  self.tog_wear = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/go_itemInput/tog_wear")
  self.InputField_ChatInput = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/InputField_ChatInput")
  self.Placeholder = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/InputField_ChatInput/Placeholder")
  self.img_friendChat = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_friendChat")
  self.go_tempPlayerChar = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_friendChat/go_tempPlayerChar")
  self.tog_friendChat = self:GetControl("bg_friend/go_friend/bg_leftList/go_leftListBtnGroup/tog_friendChat")
  self.tog_friendInformation = self:GetControl("bg_friend/go_friend/bg_leftList/go_leftListBtnGroup/tog_friendInformation")
  self.img_friendChatList = self:GetControl("bg_friend/go_friendAll/go_friend/sw_friendChatList/img_friendChatList")
  self.Scroll_BagInfos = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/go_itemInput/Scroll_BagInfos")
  self.go_BagContent = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/go_itemInput/Scroll_BagInfos/Viewport/go_BagContent")
  self.tile_bg = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/go_itemInput/Scroll_BagInfos/Viewport/go_BagContent/tile_bg")
  self.go_DragCheck = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/go_itemInput/Scroll_BagInfos/go_DragCheck")
  self.go_ScrollTop = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/go_itemInput/Scroll_BagInfos/go_DragCheck/go_ScrollTop")
  self.go_ScrollBottom = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/go_itemInput/Scroll_BagInfos/go_DragCheck/go_ScrollBottom")
  self.go_DragEdge = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/go_itemInput/Scroll_BagInfos/go_DragCheck/go_DragEdge")
  self.btn_3DItem = self:GetControl("bg_friend/go_friendAll/go_friend/go_chatContent/img_inputChat/img_other/go_itemInput/Scroll_BagInfos/btn_3DItem")
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.descBtn = self:GetControl("descBtn")
end

function Friend_FriChatUI:Init()
end

function Friend_FriChatUI:OnCreate()
  self:InitControls()
  self:InitArgs()
  self:InitUI()
  self:RegistUIEvents()
end

function Friend_FriChatUI:InitArgs()
  self.curFriendInfoIndex = 1
  self.curBlacklistIndex = 1
  self.curEnemyInfoIndex = 1
  self.chatPanel = ChatPanel(self)
end

function Friend_FriChatUI:InitUI()
  _, self.limitChatHeight = self.go_tempPlayerChar:GetSizeDelta()
  self:InitFriendChatDisplay()
  self:InitAddFriendDisplay()
  self:InitContent()
end

function Friend_FriChatUI:DisplayUIByName(displayTab, displayType)
  for k, v in pairs(displayTab) do
    self:SetUItActive(v, k == displayType)
  end
end

function Friend_FriChatUI:InitFriendChatDisplay()
  self.tog_friendList.type = FriendTypeEnum.FRIEND
  self.tog_searchList.type = FriendTypeEnum.ENEMY
  self.tog_applyList.type = FriendTypeEnum.BLACKLIST
  local displayTab = {
    [FriendTypeEnum.FRIEND] = self.go_friend,
    [FriendTypeEnum.BLACKLIST] = self.go_blacklist,
    [FriendTypeEnum.ENEMY] = self.go_enemy
  }
  self.topFriendDisplay = setmetatable(displayTab, {
    __call = function(t, displayType)
      self:DisplayUIByName(t, displayType)
    end
  })
end

function Friend_FriChatUI:InitAddFriendDisplay()
  self.tog_addFriendList1.type = "lookUp"
  self.tog_searchList1.type = "apply"
  local displayTab = {
    lookUp = self.go_lookup,
    apply = self.go_apply
  }
  self.topFriendInfoDisplay = setmetatable(displayTab, {
    __call = function(t, displayType)
      self:DisplayUIByName(t, displayType)
    end
  })
end

function Friend_FriChatUI:InitFriendInfoDisplay()
  self.tog_friend.type = FriendTypeEnum.FRIEND
  self.tog_blacklist.type = FriendTypeEnum.BLACKLIST
  self.tog_enemy.type = FriendTypeEnum.ENEMY
  local displayTab = {
    [FriendTypeEnum.FRIEND] = self.go_friend,
    [FriendTypeEnum.BLACKLIST] = self.go_blacklist,
    [FriendTypeEnum.ENEMY] = self.go_enemy
  }
  self.topFriendInfoDisplay = setmetatable(displayTab, {
    __call = function(t, displayType)
      self:DisplayUIByName(t, displayType)
    end
  })
end

local function KillTextRefresh(ctr, _, killData, ui)
  local killLogs = string.split(killData, " ")
  table.remove(killLogs, #killLogs)
  local killStr = string.format("%s<color=#FF0000>%s</color>", table.concat(killLogs, " "), "Ti\195\170u di\225\187\135t")
  ctr:SetText(killStr)
end

local function blackTimeTextRefresh(ctr, _, killData, ui)
  local killStr = string.format("<color=#FF0000>%s</color>", killData)
  ctr:SetText(killStr)
end

function Friend_FriChatUI:InitContent()
  self.lab_killListTemp = UIContainer(self.lab_killList, self, nil, KillTextRefresh)
  self.lab_blackTimeListTemp = UIContainer(self.lab_blackTimeList, self, nil, blackTimeTextRefresh)
end

function Friend_FriChatUI:InitDefaultFriendInfo(friendData, index, type)
  local roleId = 0 < #friendData and friendData[index].info.roleId
  if not roleId then
    return
  end
  self:SendMessageFriendInfo(roleId, type)
end

function Friend_FriChatUI:UpdateSearchTableView()
  self.sw_lookList:SetActive(true)
  self.sw_recommendList:SetActive(false)
  if not self.tableViewSearch then
    self:CreateSearchFriendTableView()
  else
    self.tableViewSearch:ReloadData(1)
  end
end

function Friend_FriChatUI:UpdateRecommendTableView()
  self.sw_lookList:SetActive(false)
  self.sw_recommendList:SetActive(true)
  if not self.tableViewRecommend then
    self:CreateRecommendFriendTableView()
  else
    self.tableViewRecommend:ReloadData(1)
  end
end

function Friend_FriChatUI:UpdateApplyTableView()
  if not self.tableViewApply then
    self:CreateApplyFriendTableView()
  else
    self.tableViewApply:ReloadData(1)
  end
end

function Friend_FriChatUI:UpdateFriendChatTableView()
  local friendChatData = FriendData.FriendChatData
  if not self.tableViewFriendChat then
    self.linkManId = friendChatData[self.curFriendInfoIndex] and friendChatData[self.curFriendInfoIndex].info.roleId or 0
    self:CreateFriendChatTableView()
    self:InitDefaultFriendInfo(friendChatData, self.curFriendInfoIndex, FriendTypeEnum.FRIEND)
    self:UpdateChatTableView(self.linkManId)
  else
    local roleIndex = 1
    if self.friendInfoReload then
      self.friendInfoReload = false
      self.linkManId = friendChatData[self.curFriendInfoIndex] and friendChatData[self.curFriendInfoIndex].info.roleId or 0
      roleIndex = self.curFriendInfoIndex
      self:UpdateChatTableView(self.linkManId)
    elseif friendChatData[self.curFriendInfoIndex] and friendChatData[self.curFriendInfoIndex].info.roleId ~= self.linkManId or not friendChatData[self.curFriendInfoIndex] then
      roleIndex = FriendData.GetFriendIndexById(self.linkManId)
      self.linkManId = roleIndex ~= -1 and self.linkManId or friendChatData[1] and friendChatData[1].info.roleId or 0
      if roleIndex == -1 then
        roleIndex = 1
        self:UpdateChatTableView(self.linkManId)
      end
      self.curFriendInfoIndex = roleIndex
    end
    self:InitDefaultFriendInfo(friendChatData, roleIndex, FriendTypeEnum.FRIEND)
    self.tableViewFriendChat:ReloadData(self.curFriendInfoIndex)
  end
end

function Friend_FriChatUI:UpdateChatTableView(roleId)
  if not self.tableViewChat then
    self:CreateChatTableview()
  elseif roleId == self.linkManId then
    if FriendData.FriendChatInfoData[self.linkManId] then
      self.tableViewChat:ReloadData(FriendData.FriendChatInfoData[self.linkManId]:Count())
    else
      self.tableViewChat:ReloadData(1)
    end
  end
end

function Friend_FriChatUI:UpdateBlackListTableView()
  local blackData = FriendData.FriendList[FriendTypeEnum.BLACKLIST]
  if not self.blacklistTableView then
    self.blackId = blackData[self.curBlacklistIndex] and blackData[self.curBlacklistIndex].info.roleId or 0
    self:CreateBlackListTableView()
    self:InitDefaultFriendInfo(blackData, self.curBlacklistIndex, FriendTypeEnum.BLACKLIST)
  else
    local roleIndex = 1
    if self.blackInfoReload then
      self.blackInfoReload = false
    elseif blackData[self.curBlacklistIndex] and blackData[self.curBlacklistIndex].info.roleId ~= self.blackId or not blackData[self.curBlacklistIndex] then
      roleIndex = FriendData.GetRoleIndexById(self.blackId, FriendTypeEnum.BLACKLIST)
      self.blackId = roleIndex ~= -1 and self.blackId or blackData[1] and blackData[1].info.roleId or 0
      if roleIndex == -1 then
        roleIndex = 1
      end
      self.curBlacklistIndex = roleIndex
    end
    self:InitDefaultFriendInfo(blackData, roleIndex, FriendTypeEnum.BLACKLIST)
    self.blacklistTableView:ReloadData(self.curBlacklistIndex)
  end
end

function Friend_FriChatUI:UpdateEnemyTableView()
  local enemyData = FriendData.FriendList[FriendTypeEnum.ENEMY]
  if not self.enemyTableView then
    self.enemyId = enemyData[self.curEnemyInfoIndex] and enemyData[self.curEnemyInfoIndex].info.roleId or 0
    self:CreateEnemyTableView()
    self:InitDefaultFriendInfo(enemyData, self.curEnemyInfoIndex, FriendTypeEnum.ENEMY)
  else
    local roleIndex = 1
    if self.enemyInfoReload then
      self.enemyInfoReload = false
    elseif enemyData[self.curEnemyInfoIndex] and enemyData[self.curEnemyInfoIndex].info.roleId ~= self.enemyId or not enemyData[self.curEnemyInfoIndex] then
      roleIndex = FriendData.GetRoleIndexById(self.enemyId, FriendTypeEnum.ENEMY)
      self.enemyId = roleIndex ~= -1 and self.enemyId or enemyData[1] and enemyData[1].info.roleId or 0
      if roleIndex == -1 then
        roleIndex = 1
      end
      self.curEnemyInfoIndex = roleIndex
    end
    self:InitDefaultFriendInfo(enemyData, roleIndex, FriendTypeEnum.ENEMY)
    self.enemyTableView:ReloadData(self.curEnemyInfoIndex)
  end
end

function Friend_FriChatUI:UpdateApplyPanel()
  self:UpdateApplyTableView()
end

function Friend_FriChatUI:UpdateSearchFriendPanel()
  local isShow = FriendData.IsEmpty(FriendTypeEnum.FRIEND_SEARCH)
  self:SetUItActive(self.lab_noAddFriend, isShow)
  self:UpdateSearchTableView()
end

function Friend_FriChatUI:UpdateRecommendFriendPanel()
  self:UpdateRecommendTableView()
  self:SetUItActive(self.lab_noAddFriend, false)
end

function Friend_FriChatUI:UpdateFriendPanel()
  local isEmpty = FriendData.IsEmpty(FriendTypeEnum.FRIEND)
  self.img_bgNoFriend:SetActive(isEmpty)
  self.img_leftLineFriend:SetActive(not isEmpty)
  self.go_chatContent:SetActive(not isEmpty)
  self.sw_friendChatList:SetActive(not isEmpty)
  FriendData.SetFriendChatData()
  self:UpdateFriendChatTableView()
  self:UpdateFriendListNum()
end

function Friend_FriChatUI:UpdateFriendListNum()
  local friendNum = FriendData.GetFriendCountByType(FriendTypeEnum.FRIEND)
  self.Txt_FriendlistNum:SetText(string.format("S\225\187\145 ng\198\176\225\187\157i: %d/%d", friendNum, FriendData.FRIEND_MAX))
end

function Friend_FriChatUI:UpdateFriendInfo(friendData)
  local lab_name = self.img_friendName:GetChild("lab_friendName")
  local lab_IntimacyNum = self.img_friendName:GetChild("lab_Intimacy/lab_IntimacyNum")
  lab_name:SetText(friendData.info.name)
  lab_IntimacyNum:SetText(friendData.intimacy)
  self.img_friendInputRemarks:SetInputText(friendData.remark)
  self.img_friendInputRemarks.id = friendData.info.roleId
  self.img_friendName:SetActive(false)
  self.btn_magnifier.id = friendData.info.roleId
  self.btn_magnifier.roleName = friendData.info.name
  self.btn_magnifier.unionName = friendData.info.unionName
  self.btn_magnifier.unionPosition = friendData.info.unionPosition
  self.btn_magnifier.fight = friendData.info.fight
  self.btn_magnifier.career = friendData.info.career
  local teamBtnShowRule = self:UpdateTeamShowBtnRule(TeamData.teamId, friendData.teamId)
  self.btn_magnifier.teamId = teamBtnShowRule == 1 and friendData.teamId or TeamData.teamId
  local unionShowRule = self:UpdateUnionShowBtnRule(RoleManager.me.unionId, friendData.unionId)
  self.btn_magnifier.unionId = unionShowRule == 1 and friendData.unionId or RoleManager.me.unionId
  self.btn_magnifier.teamBtnShowRule = teamBtnShowRule
  self.btn_magnifier.unionShowRule = unionShowRule
  self.btn_magnifier.level = friendData.info.level
  self.btn_magnifier.isOnline = friendData.info.online
end

function Friend_FriChatUI:UpdatePlayerInfoPanel(_, friendData)
  if self.tog_friendList:GetIsOn() then
    self:UpdateFriendInfo(friendData)
  elseif self.tog_applyList:GetIsOn() then
    self:UpdateBlacklistInfoPanel(friendData)
  elseif self.tog_searchList:GetIsOn() then
    self:UpdateEnemyInfoPanel(friendData)
  end
end

function Friend_FriChatUI:UpdateTeamShowBtnRule(selfPlayerTeam, friendPlayerTeam)
  if selfPlayerTeam ~= 0 and friendPlayerTeam ~= 0 or selfPlayerTeam == 0 and friendPlayerTeam == 0 then
    return 0
  elseif selfPlayerTeam == 0 and friendPlayerTeam ~= 0 then
    return 1
  else
    return 2
  end
end

function Friend_FriChatUI:UpdateUnionShowBtnRule(selfPlayerUnion, friendPlayerUnion)
  if selfPlayerUnion ~= 0 and friendPlayerUnion ~= 0 or selfPlayerUnion == 0 and friendPlayerUnion == 0 then
    return 0
  elseif selfPlayerUnion == 0 and friendPlayerUnion ~= 0 then
    return 1
  else
    return 2
  end
end

function Friend_FriChatUI:UpdateFriendNum()
  local friendTxt = self.sw_friendInformationList:GetChild("txt_friendNum")
  local friendNum = FriendData.GetFriendCountByType(FriendTypeEnum.FRIEND)
  friendTxt:SetText(string.format("S\225\187\145 ng\198\176\225\187\157i: %d/%d", friendNum, FriendData.FRIEND_MAX))
end

function Friend_FriChatUI:UpdateBlackListPanel()
  local isEmpty = FriendData.IsEmpty(FriendTypeEnum.BLACKLIST)
  self:SetUItActive(self.lab_noBlack, isEmpty)
  self.bg_rightBlackList:SetActive(not isEmpty)
  self.Txt_BlacklistNum:SetActive(not isEmpty)
  self.img_leftLineblack:SetActive(not isEmpty)
  self:SetUItActive(self.go_black, not isEmpty)
  self:UpdateBlackListTableView()
  self:UpdateBlacklistNum()
end

function Friend_FriChatUI:UpdateBlacklistNum()
  local blacklistNum = FriendData.GetFriendCountByType(FriendTypeEnum.BLACKLIST)
  self.Txt_BlacklistNum:SetText(string.format("S\225\187\145 ng\198\176\225\187\157i: %d/%d", blacklistNum, FriendData.BLACKLIST_MAX))
end

function Friend_FriChatUI:UpdateBlacklistInfoPanel(friendData)
  local img_headPortrait = self.go_black:GetChild("img_headPortrait")
  local lab_name = self.go_black:GetChild("lab_name")
  local lab_occupationDesc = self.go_black:GetChild("lab_occupation/lab_occupationDesc")
  local lab_levelNum = self.go_black:GetChild("lab_level/lab_levelNum")
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(friendData.info.career, "id").headPortrait
  lab_name:SetText(friendData.info.name)
  lab_occupationDesc:SetText(RoleUtility.GteCareerNameByType(friendData.info.career))
  local levelStr = string.format("Lv.%d", friendData.info.level)
  lab_levelNum:SetText(levelStr)
  self.go_blackInputRemarks:SetInputText(friendData.remark)
  self.go_blackInputRemarks.id = friendData.info.roleId
  self.btn_deleteblacklist.id = friendData.info.roleId
  self.btn_deleteblacklist.type = FriendTypeEnum.BLACKLIST
  self.lab_blackTimeListTemp:SetData(friendData.log)
  self.lab_blackTimeListTemp:Refresh()
  self.bg_rightBlackList:SetActive(true)
end

function Friend_FriChatUI:UpdateEnemyPanel()
  local isEmpty = FriendData.IsEmpty(FriendTypeEnum.ENEMY)
  self:SetUItActive(self.lab_noEnemy, isEmpty)
  self.img_leftLineEnemy:SetActive(not isEmpty)
  self:SetUItActive(self.go_enemyInformation, not isEmpty)
  self:UpdateEnemyTableView()
end

function Friend_FriChatUI:UpdateEnemyInfoPanel(enemyData)
  local go_enemyInformation = self.go_enemy:GetChild("bg_rightList/go_enemyInformation")
  local img_headPortrait = go_enemyInformation:GetChild("img_headPortrait")
  local lab_name = go_enemyInformation:GetChild("lab_name")
  local lab_occupationDesc = go_enemyInformation:GetChild("lab_occupation/lab_occupationDesc")
  local lab_levelNum = go_enemyInformation:GetChild("lab_level/lab_levelNum")
  local lab_IntimacyNum = go_enemyInformation:GetChild("lab_Intimacy/lab_IntimacyNum")
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(enemyData.info.career, "id").headPortrait
  lab_name:SetText(enemyData.info.name)
  lab_occupationDesc:SetText(RoleUtility.GteCareerNameByType(enemyData.info.career))
  local levelStr = string.format("Lv.%d", enemyData.info.level)
  lab_levelNum:SetText(levelStr)
  lab_IntimacyNum:SetText(enemyData.intimacy * -1)
  self.lab_killListTemp:SetData(enemyData.log)
  self.lab_killListTemp:Refresh()
  self.go_enemyInformation:SetActive(true)
end

function Friend_FriChatUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:StartRecommendFriendCountDown()
  self:SendNetMessage(FriendMessage.ReqOpenFriendPanel, {
    type = FriendTypeEnum.FRIEND
  })
end

function Friend_FriChatUI:StartRecommendFriendCountDown()
  local roleKey = string.format("%dRecommendFriend", RoleManager.me.id)
  local clickTime = PlayerPrefs.GetInt(roleKey, 0)
  local curTime = Time.GetServerSecondTime()
  local intervalTime = curTime - clickTime
  local countText = self.btn_change:GetChild("Text")
  if intervalTime >= FriendData.RECOMMEND_COUNTDOWN then
    self.btn_change:SetInteractable(true)
    countText:SetText("\196\144\225\187\149i m\225\187\153t lo\225\186\161t")
  else
    self.btn_change:SetInteractable(false)
    local surplusTime = FriendData.RECOMMEND_COUNTDOWN - intervalTime
    
    local function UpdateRecommendBtn()
      local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
      countText:SetText(timeStr)
      surplusTime = surplusTime - 1
      if surplusTime == 0 then
        self.btn_change:SetInteractable(true)
        countText:SetText("\196\144\225\187\149i m\225\187\153t lo\225\186\161t")
      end
    end
    
    self.recTimer = Timer.StartLoop(1, surplusTime, UpdateRecommendBtn)
  end
end

function Friend_FriChatUI:OnHide()
  if self.recTimer then
    Timer.Stop(self.recTimer)
  end
  if self.tableViewApply then
    self.tableViewApply:UnloadAllCells()
  end
  self.curFriendInfoIndex = 1
  self.friendInfoReload = true
  self.curBlacklistIndex = 1
  self.blackInfoReload = true
  self.curEnemyInfoIndex = 1
  self.enemyInfoReload = true
  self.chatPanel:OnHide()
  self.tog_friendList:SetIsOn(true)
  self.tog_friend:SetIsOn(true)
end

function Friend_FriChatUI:OnDestroy()
  Timer.Stop(self.recTimer)
  self.tableViewSearch = nil
  self.tableViewApply = nil
  self.blacklistTableView = nil
  self.enemyTableView = nil
  self.tableViewRecommend = nil
  self.tableViewFriendChat = nil
  self.tableViewChat = nil
end

function Friend_FriChatUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.tog_friendList:SetOnToggleChanged(self, self.ShowRightFriendUI)
  self.tog_searchList:SetOnToggleChanged(self, self.ShowRightFriendUI)
  self.tog_applyList:SetOnToggleChanged(self, self.ShowRightFriendUI)
  self.tog_searchList1:SetOnToggleChanged(self, self.ShowApplyFriendUI)
  self.tog_addFriendList1:SetOnToggleChanged(self, self.ShowSearchFriendUI)
  self.tog_friend:SetOnToggleChanged(self, self.ShowRightFriendUI)
  self.tog_blacklist:SetOnToggleChanged(self, self.ShowRightFriendUI)
  self.tog_enemy:SetOnToggleChanged(self, self.ShowRightFriendUI)
  self.btn_getFriend:SetOnClick(self, self.btn_getFriendOnClick)
  self.btn_change:SetOnClick(self, self.ChangeFriendOnclick)
  self.btn_lookup:SetOnClick(self, self.SearchFriendOnclick)
  self.chatPanel:RegistChatPanelClickEvent()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_magnifier:SetOnClick(self, self.ShowFriendOnClick1)
  self.go_blackInputRemarks:SetOnEndEdit(self, self.SetFriendInfoRemark)
  self.img_friendInputRemarks:SetOnEndEdit(self, self.SetFriendInfoRemark)
  self.btn_deleteblacklist:SetOnClick(self, self.DeleteBlacklist)
  self.tog_addFriend1:SetOnClick(self, self.AddFriend)
  self.btn_AddClose:SetOnClick(self, self.HideAddFriend)
  self.btn_closeBg1:SetOnClick(self, self.HideAddFriend)
  self.Input_roleName:SetOnValueChanged(self, self.Input_roleNameValueChanged)
  self.Input_roleName:SetOnEndEdit(self, self.Input_roleNameEndEdit)
end

function Friend_FriChatUI:Input_roleNameValueChanged(control)
  self.limit = self.Input_roleName.transform:GetComponent("InputField")
  if self.limit.characterLimit ~= 9 then
    self.limit.characterLimit = 9
  end
end

function Friend_FriChatUI:Input_roleNameEndEdit(control)
  local inputText = self.Input_roleName:GetInputText()
  local length = string.GetKoreanStrCount(inputText)
  if 7 < length then
    self.limit.text = string.KoreanStrSub(inputText, 1, 6)
  end
  self.limit = 7
end

function Friend_FriChatUI:AddFriend(control)
  self.go_getFriend:SetActive(true)
  if RoleUtility.IsAddFriendRed then
    self:ShowSearchFriendUI(self.tog_searchList1)
    self.tog_searchList1:SetIsOn(true)
  else
    self:ShowSearchFriendUI(self.tog_addFriendList1)
    self.tog_addFriendList1:SetIsOn(true)
  end
end

function Friend_FriChatUI:HideAddFriend(control)
  self.go_getFriend:SetActive(false)
end

function Friend_FriChatUI:ShowFriendFriendUI(control)
  local selectEffect = control:GetChild("img_clickeffect")
  selectEffect:SetActive(control:GetIsOn())
  self.go_getFriend:SetActive(false)
  self.topFriendDisplay(control.type)
end

function Friend_FriChatUI:ShowSearchFriendUI(control)
  self.topFriendInfoDisplay(control.type)
  self.Input_roleName:SetInputText("")
end

function Friend_FriChatUI:ShowApplyFriendUI(control)
  self.topFriendInfoDisplay(control.type)
  self:SendMessageOfFriend(control:GetIsOn(), FriendTypeEnum.BE_APPLY_LIST)
end

function Friend_FriChatUI:ShowRightFriendUI(control)
  local selectEffect = control:GetChild("img_clickeffect")
  if selectEffect then
    selectEffect:SetActive(control:GetIsOn())
  end
  self.go_getFriend:SetActive(false)
  self:SendMessageOfFriend(control:GetIsOn(), control.type)
  self.topFriendDisplay(control.type)
end

function Friend_FriChatUI:btn_getFriendOnClick(control)
  self:AddFriend(control)
end

function Friend_FriChatUI:ChangeFriendOnclick()
  self.lookUpShowPanel = "recommend"
  self:SendNetMessage(FriendMessage.ReqGetFriendRecommend)
  local curTime = Time.GetServerSecondTime()
  local roleKey = string.format("%dRecommendFriend", RoleManager.me.id)
  PlayerPrefs.SetInt(roleKey, curTime)
  self:StartRecommendFriendCountDown()
end

function Friend_FriChatUI:SearchFriendOnclick()
  self.lookUpShowPanel = "search"
  local roleName = self.Input_roleName:GetInputText()
  roleName = string.trim(roleName)
  if roleName == "" then
    return
  end
  self:SendNetMessage(FriendMessage.ReqSearchByName, {name = roleName, accurate = false})
end

function Friend_FriChatUI:UpdateNewFriendTogByType(type)
  self.newFriendToggleTab[type]:SetIsOn(true)
end

function Friend_FriChatUI:NewFriendTogEvent(control, isOn)
  FriendData.RefreshDataByType(FriendTypeEnum.FRIEND_SEARCH)
  self.newFriendTogList[control.type](isOn)
end

function Friend_FriChatUI:btn_closeOnClick(control)
  self.go_getFriend:SetActive(false)
  UIManager.Hide(UIID.Friend_FriChatUI)
end

function Friend_FriChatUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Friend_FriChatUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Friend_FriChatUI:SetLookUpNewFriendBtnClickEvent()
  local lookUpNewFriendBtn = self.go_newFriend:GetChild("bg_addFriend/btn_lookup")
  lookUpNewFriendBtn:SetOnClick(self, self.SearchNewFriend)
end

function Friend_FriChatUI:SearchNewFriend(control)
  local input_roleName = self.go_newFriend:GetChild("bg_addFriend/Input_roleName")
  local roleName = input_roleName:GetInputText()
  FriendData.SelectSearch = FriendTypeEnum.FRIEND
  self:SendNetMessage(FriendMessage.ReqSearchByName, {name = roleName, accurate = false})
end

function Friend_FriChatUI:ApplyForFriend(control)
  local msg = {
    id = control.id,
    type = control.type
  }
  EventManager.Dispatch(Event.Friend_ReqAddFriend, msg)
end

function Friend_FriChatUI:AgreeApplyForFriend(control)
  self:SendNetMessage(FriendMessage.ReqCheckApply, {
    id = control.id,
    flag = control.flag
  })
end

function Friend_FriChatUI:RefuseApplyForFriend(control)
  self:SendNetMessage(FriendMessage.ReqCheckApply, {
    id = control.id,
    flag = control.flag
  })
end

function Friend_FriChatUI:SetFriendInfoRemark(control)
  self:SendNetMessage(FriendMessage.ReqEditRemark, {
    id = control.id,
    remark = control:GetInputText()
  })
end

function Friend_FriChatUI:DeleteBlacklist(control)
  EventManager.Dispatch(Event.Friend_ReqDeleteFriend, {
    id = control.id,
    type = control.type
  })
end

function Friend_FriChatUI:AddAllFriendOnClick(control)
  local count = FriendData.GetFriendCountByType(FriendTypeEnum.RECOMMEND)
  for i = 1, count do
    local msg = {
      id = control.id,
      type = FriendTypeEnum.FRIEND
    }
    EventManager.Dispatch(Event.Friend_ReqAddFriend, msg)
  end
end

function Friend_FriChatUI:ShowBlackListInfo(control)
  local allLoadCell = self.blacklistTableView:GetAllLoadCell()
  for i, v in pairs(allLoadCell) do
    if v.loadedCell.index == control.index then
      v.loadedCell:SetInteractable(false)
      v.loadedCell.selectEff:SetActive(true)
      v.loadedCell.playerInfo:SetActive(true)
    else
      v.loadedCell:SetInteractable(true)
      v.loadedCell.selectEff:SetActive(false)
      v.loadedCell.playerInfo:SetActive(false)
    end
  end
  self.curBlacklistIndex = control.index
  self.blackId = control.id
  self:SendMessageFriendInfo(control.id, FriendTypeEnum.BLACKLIST)
end

function Friend_FriChatUI:AddPlayerIntoBlackList(control)
  local msg = {
    id = control.id,
    type = control.type
  }
  EventManager.Dispatch(Event.Friend_ReqAddFriend, msg)
  if FriendData.GetFriendCountByType(FriendTypeEnum.BLACKLIST) < FriendData.BLACKLIST_MAX then
    control.btnStatus:SetText("\196\144\195\163 th\195\170m")
    local searchData = FriendData.FriendList[FriendTypeEnum.BLACKSEARCH]
    searchData[control.index].status = SearchStatusEnum.ADDED
    control:SetInteractable(false)
  end
end

function Friend_FriChatUI:ShowEnemyInfo(control)
  local allLoadCell = self.enemyTableView:GetAllLoadCell()
  for i, v in pairs(allLoadCell) do
    if v.loadedCell.index == control.index then
      v.loadedCell:SetInteractable(false)
      v.loadedCell.selectEff:SetActive(true)
      v.loadedCell.playerInfo:SetActive(true)
    else
      v.loadedCell:SetInteractable(true)
      v.loadedCell.selectEff:SetActive(false)
      v.loadedCell.playerInfo:SetActive(false)
    end
  end
  self.curEnemyInfoIndex = control.index
  self.enemyId = control.id
  self:SendMessageFriendInfo(control.id, FriendTypeEnum.ENEMY)
end

function Friend_FriChatUI:SendChatMessage(_, message)
  local msg = {
    chatType = ChatChannelEnum.PRIVATE,
    textData = message,
    toRoleId = self.linkManId
  }
  EventManager.Dispatch(Event.Chat_ReqChat, msg)
  self.chatPanel:RefreshInputChat()
end

function Friend_FriChatUI:ShowFriendChat(control)
  local allLoadCell = self.tableViewFriendChat:GetAllLoadCell()
  for i, v in pairs(allLoadCell) do
    if v.loadedCell.index == control.index then
      v.loadedCell:SetInteractable(false)
      v.loadedCell.selectEff:SetActive(true)
      v.loadedCell.playerInfo:SetActive(true)
    else
      v.loadedCell:SetInteractable(true)
      v.loadedCell.selectEff:SetActive(false)
      v.loadedCell.playerInfo:SetActive(false)
    end
  end
  self.linkManId = control.id
  self.curFriendInfoIndex = control.index
  self:UpdateChatTableView(self.linkManId)
  control.img_unreadUum:SetActive(false)
  control.lab_notRead:SetActive(false)
  control.lab_chat:SetAnchoredPosition(18, -15)
  FriendData.ReadChatData(control.index)
  self:SendMessageFriendInfo(control.id, FriendTypeEnum.FRIEND)
end

function Friend_FriChatUI:ShowFriendOnClick(control)
  if not control.friendinfo.info.roleId then
    return
  end
  if self.tog_friendList:GetIsOn() and self.linkManId ~= control.friendChatCell.id then
    return
  elseif self.tog_searchList:GetIsOn() and self.enemyId ~= control.friendChatCell.id then
    return
  elseif self.tog_applyList:GetIsOn() and self.blackId ~= control.friendChatCell.id then
    return
  end
  control.friendinfo.info.id = control.friendinfo.info.roleId
  control.friendinfo.info.roleName = control.friendinfo.info.name
  self:ShowPanel(control.friendinfo.info)
end

function Friend_FriChatUI:ShowFriendOnClick1(control)
  if not control.id then
    return
  end
  self:ShowPanel(control)
end

function Friend_FriChatUI:ShowPanel(control)
  RoleInteractData.roleId = control.id
  RoleInteractData.roleName = control.roleName
  RoleInteractData.unionId = control.unionId
  RoleInteractData.career = control.career
  RoleInteractData.unionName = control.unionName
  RoleInteractData.unionPosition = control.unionPosition
  RoleInteractData.fight = control.fight
  RoleInteractData.level = control.level
  RoleInteractData.serverId = control.serverId
  RoleInteractData.interactType = RoleOpenType.FriendOpen
  RoleInteractData.isOnline = control.isOnline
  NetManager.Send(RoleMessage.ReqTeamEquipsInfo, {
    roleId = control.id
  })
end

function Friend_FriChatUI:RegistEvents()
  self:RegistEvent(Event.Friend_ResFriendList, self.UpdateFriendList, self)
  self:RegistEvent(Event.Friend_ResFriendSelfPanelInfo, self.UpdatePlayerInfoPanel, self)
  self:RegistEvent(Event.Chat_SendMessage, self.SendChatMessage, self)
  self:RegistEvent(Event.Friend_RefreshChat, self.RefreshChatPanel, self)
  self:RegistEvent(Event.Friend_Intimacy, self.UpdateFriendIntimacy, self)
  self:RegistEvent(Event.Friend_UpdateSearch, self.UpdateFriendSearch, self)
end

function Friend_FriChatUI:UpdateFriendIntimacy(_, roleId, intimacy)
  if self.linkManId == roleId then
    local lab_IntimacyNum = self.img_friendName:GetChild("lab_Intimacy/lab_IntimacyNum")
    lab_IntimacyNum:SetText(intimacy)
  end
end

function Friend_FriChatUI:RefreshChatPanel(_, roleId)
  self:UpdateFriendChatTableView()
  self:UpdateChatTableView(roleId)
end

function Friend_FriChatUI:UpdateFriendList(_, friendType)
  if friendType == FriendTypeEnum.FRIEND then
    self:UpdateFriendPanel()
  elseif friendType == FriendTypeEnum.BE_APPLY_LIST then
    self:UpdateApplyPanel()
  elseif friendType == FriendTypeEnum.RECOMMEND then
    self:UpdateSearchAndRecommendVisible()
  elseif friendType == FriendTypeEnum.FRIEND_SEARCH then
    self:UpdateSearchAndRecommendVisible()
  elseif friendType == FriendTypeEnum.BLACKLIST then
    self:UpdateBlackListPanel()
  elseif friendType == FriendTypeEnum.ENEMY then
    self:UpdateEnemyPanel()
  end
end

function Friend_FriChatUI:UpdateSearchAndRecommendVisible()
  if self.lookUpShowPanel == "search" then
    self.img_auto:SetActive(false)
    self:UpdateSearchFriendPanel()
  else
    self.img_auto:SetActive(true)
    self:UpdateRecommendFriendPanel()
  end
end

function Friend_FriChatUI:UpdateFriendSearch()
  if self.tableViewSearch then
    self.tableViewSearch:ReloadData()
  end
  if self.tableViewRecommend then
    self.tableViewRecommend:ReloadData()
  end
end

function Friend_FriChatUI:Refresh()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
  self.chatPanel:Refresh()
  self:JudgeRefreshRandomFriendPanel()
end

function Friend_FriChatUI:JudgeRefreshRandomFriendPanel()
  self.lookUpShowPanel = "recommend"
  self:SendNetMessage(FriendMessage.ReqGetFriendRecommend)
end

function Friend_FriChatUI:SetUItActive(ui, isShow)
  ui:SetActive(isShow)
end

function Friend_FriChatUI:SendNetMessage(event, msg)
  NetManager.Send(event, msg)
end

function Friend_FriChatUI:SendMessageOfFriend(isShow, type)
  if isShow == false then
    return
  end
  self:SendNetMessage(FriendMessage.ReqOpenFriendPanel, {type = type})
end

function Friend_FriChatUI:SendMessageFriendInfo(id, type)
  self.curPlayerInfoType = type
  self:SendNetMessage(FriendMessage.ReqFriendSelfPanelInfo, {id = id, type = type})
end

function Friend_FriChatUI:CreateFriendChatTableView()
  self.tableViewFriendChat = UITableView()
  self.tableViewFriendChat:SetLowerMargin(0)
  self.tableViewFriendChat:SetScrollView(self.sw_friendChatList)
  _, self.img_friendChatListSizeY = self.img_friendChatList:GetSizeDelta()
  self.tableViewFriendChat:SetScalarForCellInTableView(self, self.GetSizeFriendCell)
  self.tableViewFriendChat:SetUpperMargin(5)
  self.tableViewFriendChat:SetTotalCellCount(self, self.GetFriendChatCount)
  self.tableViewFriendChat:SetCellAtIndexInTableView(self, self.GetFriendChatCell)
  self.tableViewFriendChat:SetCellAtIndexInTableViewWillAppear(self, self.UpdateFriendChatCell)
  self.tableViewFriendChat:ReloadData(1)
end

function Friend_FriChatUI:GetSizeFriendCell()
  return self.img_friendChatListSizeY
end

function Friend_FriChatUI:GetFriendChatCount()
  return table.count(FriendData.FriendChatData)
end

function Friend_FriChatUI:GetFriendChatCell()
  return self.tableViewFriendChat:ReuseOrCreateCell(self.img_friendChatList)
end

function Friend_FriChatUI:UpdateFriendChatCell(index)
  local friendChatData = FriendData.FriendChatData
  if friendChatData[index] then
    local friendinfo = FriendData.FriendDict[friendChatData[index].info.roleId]
    local friendChatCell = self.tableViewFriendChat:GetLoadedCell(index)
    local headImage = friendChatCell:GetChild("img_headPortrait")
    local img_unreadUum = friendChatCell:GetChild("img_headPortrait/img_unreadNum")
    local lab_unreadUum = friendChatCell:GetChild("img_headPortrait/img_unreadNum/lab_unreadNum")
    local lab_name = friendChatCell:GetChild("lab_name")
    local lab_chat = friendChatCell:GetChild("lab_chat")
    local lab_notRead = friendChatCell:GetChild("lab_notRead")
    local lab_onLine = friendChatCell:GetChild("lab_onLine")
    local lab_level = friendChatCell:GetChild("lab_level")
    local lab_offLine = friendChatCell:GetChild("lab_offLine")
    local playerInfo = UIControl(friendChatCell.transform, "playerInfo")
    playerInfo.friendChatCell = friendChatCell
    playerInfo.friendinfo = friendinfo
    playerInfo:SetOnClick(self, self.ShowFriendOnClick)
    local unionName = friendChatData[index].info.unionName ~= "" and friendChatData[index].info.unionName or "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i"
    local grad = UIControl(friendChatCell.transform, "grad")
    grad:SetText("Guild: " .. unionName)
    local intimacy = UIControl(friendChatCell.transform, "intimacy")
    intimacy:SetText("Th\195\162n m\225\186\173t: " .. friendinfo.intimacy)
    local img_selectionEffect = friendChatCell:GetChild("img_selectionEffect")
    lab_offLine:SetActive(not friendChatData[index].info.online)
    lab_onLine:SetActive(friendChatData[index].info.online)
    local mapId = friendChatData[index].info.mapId
    local friendMap = ClientTable.cfg_Map_mapManager:TryGetValue(mapId)
    local meMap = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
    if friendMap and friendMap.serverType ~= meMap.serverType then
      if friendMap.serverType == 1 then
        lab_onLine:SetText("ON")
      else
        lab_onLine:SetText("Li\195\170n Server")
      end
    elseif friendMap.serverType == 1 then
      lab_onLine:SetText("ON")
    else
      lab_onLine:SetText("Li\195\170n Server")
    end
    local levelStr = string.format("Lv.%d", friendChatData[index].info.level)
    lab_level:SetText(levelStr)
    local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(friendChatData[index].info.career, "id").headPortrait
    self:SetSprite("Atlas_headPortrait", spriteName, headImage)
    headImage:SetColor(friendChatData[index].info.online and "0xFFFFFFFF" or "0x808080FF")
    lab_name:SetText(friendChatData[index].info.name)
    local id = friendChatData[index].info.roleId
    local chatDataCount = FriendData.FriendChatInfoData[id] and FriendData.FriendChatInfoData[id]:Count() or 0
    local chatMsg = ""
    if 0 < chatDataCount then
      chatMsg = FriendData.FriendChatInfoData[id]:GetValueByIndex(chatDataCount).chatMsg.message
    end
    friendChatCell.index = index
    friendChatCell.img_unreadUum = img_unreadUum
    friendChatCell.lab_notRead = lab_notRead
    friendChatCell.lab_chat = lab_chat
    friendChatCell.selectEff = img_selectionEffect
    friendChatCell.id = friendChatData[index].info.roleId
    friendChatCell.playerInfo = playerInfo
    if self.linkManId == friendChatCell.id then
      friendChatCell:SetInteractable(false)
      img_selectionEffect:SetActive(true)
      FriendData.ReadChatData(index)
    else
      friendChatCell:SetInteractable(true)
      img_selectionEffect:SetActive(false)
    end
    playerInfo:SetActive(self.linkManId == friendChatCell.id)
    local notRead = ChatData.GetNotReadMsgCount(friendChatData[index].info.roleId)
    if notRead == 0 then
      img_unreadUum:SetActive(false)
      lab_notRead:SetActive(false)
      lab_chat:SetAnchoredPosition(18, -15)
    else
      img_unreadUum:SetActive(true)
      lab_unreadUum:SetText(notRead <= 99 and notRead or 99)
      lab_notRead:SetActive(true)
      lab_chat:SetAnchoredPosition(46, -15)
    end
    lab_chat:SetText(chatMsg)
    friendChatCell:SetOnClick(self, self.ShowFriendChat)
  end
end

function Friend_FriChatUI:CreateChatTableview()
  self.chatScrollView = self.img_friendChat:GetChild("ScrollView")
  self.otherPlayerChar = self.img_friendChat:GetChild("go_otherPlayerChar")
  self.selfPlayerChar = self.img_friendChat:GetChild("go_selfPlayerChar")
  self.tempLab = self.img_friendChat:GetChild("go_tempPlayerChar/img_charBubble/lab_playChar")
  self.tableViewChat = UITableView()
  self.tableViewChat:SetLowerMargin(0)
  self.tableViewChat:SetScrollView(self.chatScrollView)
  self.tableViewChat:SetScalarForCellInTableView(self, self.ScalarForCellInTableView)
  self.tableViewChat:SetUpperMargin(0)
  self.tableViewChat:SetTotalCellCount(self, self.NumberOfCellsInTableView)
  self.tableViewChat:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView)
  self.tableViewChat:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear)
  local count = FriendData.FriendChatInfoData[self.linkManId] and FriendData.FriendChatInfoData[self.linkManId]:Count() or 0
  self.tableViewChat:ReloadData(count)
  self.tableViewChat:ScrollToCell(count, true)
end

function Friend_FriChatUI:ScalarForCellInTableView(index)
  local chatData = FriendData.FriendChatInfoData[self.linkManId]:GetValueByIndex(index)
  self.tempLab:SetText(chatData.chatMsg.message)
  local height = self.tempLab.text.preferredHeight
  local resHeight = height + self.limitChatHeight
  return resHeight
end

function Friend_FriChatUI:NumberOfCellsInTableView()
  if FriendData.FriendChatInfoData[self.linkManId] then
    return FriendData.FriendChatInfoData[self.linkManId]:Count()
  else
    return 0
  end
end

function Friend_FriChatUI:CellAtIndexInTableView(index)
  local msg = FriendData.FriendChatInfoData[self.linkManId]:GetValueByIndex(index)
  local serverRoleInfo = msg.from == nil and msg.roleChatInfo or msg.from
  if serverRoleInfo.roleId == RoleManager.me.id then
    return self.tableViewChat:ReuseOrCreateCell(self.selfPlayerChar)
  else
    return self.tableViewChat:ReuseOrCreateCell(self.otherPlayerChar)
  end
end

function Friend_FriChatUI:PlayVoice(control)
  VoiceManager.PlayAudio(control.fileId)
end

function Friend_FriChatUI:CellAtIndexInTableViewWillAppear(index)
  local chatCell = self.tableViewChat:GetLoadedCell(index)
  local chatData = FriendData.FriendChatInfoData[self.linkManId]:GetValueByIndex(index)
  local headPortrait = chatCell:GetChild("headPortrait")
  headPortrait:SetActive(true)
  local img_charBubble = chatCell:GetChild("img_charBubble")
  local lab_playChar = chatCell:GetChild("img_charBubble/lab_playChar")
  local btn_speakVoice = chatCell:GetChild("btn_speakVoice")
  local fromInfo = chatData.from == nil and chatData.roleChatInfo or chatData.from
  local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(fromInfo.career, "id").headPortrait
  self:SetSprite("Atlas_headPortrait", spriteName, headPortrait)
  if chatData.chatMsg.inputData.type == ChatInfoEnum.Voice then
    local posX, _ = img_charBubble:GetAnchoredPosition()
    img_charBubble:SetAnchoredPosition(posX, -20)
    btn_speakVoice:SetActive(true)
    btn_speakVoice.fileId = chatData.chatMsg.inputData.fileId
    btn_speakVoice:SetOnClick(self, self.PlayVoice)
    lab_playChar:SetText(chatData.chatMsg.message)
    self:UpdateTextLength(lab_playChar, img_charBubble)
  else
    local posX, _ = img_charBubble:GetAnchoredPosition()
    img_charBubble:SetAnchoredPosition(posX, -10)
    btn_speakVoice:SetActive(false)
    lab_playChar:SetText(chatData.chatMsg.message)
    lab_playChar.inputData = chatData.chatMsg.inputData
    self:UpdateTextLength(lab_playChar, img_charBubble)
    lab_playChar:SetOnTextPointerClick(self, self.ExecuteTextOrder)
  end
end

local textWidth, textHeight = 410, 15

function Friend_FriChatUI:UpdateTextLength(lab, content)
  local width = lab.text.preferredWidth
  if width > textWidth then
    content:SetHorizontalFit(FitModeEnum.Unconstrained)
    content:SetSizeDelta(textWidth, textHeight)
  else
    content:SetHorizontalFit(FitModeEnum.PreferredSize)
  end
end

function Friend_FriChatUI:ExecuteTextOrder(control, eventData, key)
  local inputData = control.inputData[key]
  ChatUtility.GetChatInfoTab(inputData.type, inputData, control, eventData)
end

function Friend_FriChatUI:CreateSearchFriendTableView()
  self.tableViewSearch = UITableView()
  self.tableViewSearch:SetLowerMargin(0)
  self.tableViewSearch:SetScrollView(self.sw_lookList)
  self.tableViewSearch:SetNumberOfCellsAtRowOrColumn(1)
  _, self.img_lookBgSizeY = self.img_lookBg:GetSizeDelta()
  self.tableViewSearch:SetScalarForCellInTableView(self, self.GetSizeSearchCell)
  self.tableViewSearch:SetUpperMargin(0)
  self.tableViewSearch:SetTotalCellCount(self, self.GetSearchCountCount)
  self.tableViewSearch:SetCellAtIndexInTableView(self, self.GetSearchCell)
  self.tableViewSearch:SetCellAtIndexInTableViewWillAppear(self, self.UpdateSearchCell)
  self.tableViewSearch:ReloadData(1)
end

function Friend_FriChatUI:GetSizeSearchCell()
  return self.img_lookBgSizeY
end

function Friend_FriChatUI:GetSearchCountCount()
  return FriendData.GetFriendCountByType(FriendTypeEnum.FRIEND_SEARCH)
end

function Friend_FriChatUI:GetSearchCell(index)
  return self.tableViewSearch:ReuseOrCreateCell(self.img_lookBg)
end

function Friend_FriChatUI:SetAddFriendBtnClick(btn, searchData, friendType, text, index)
  btn.id = searchData.roleId
  btn.type = friendType
  btn.btnStatus = text
  btn.index = index
  btn:SetOnClick(self, self.ApplyForFriend)
end

function Friend_FriChatUI:UpdateSearchCell(index)
  local searchData = FriendData.FriendList[FriendTypeEnum.FRIEND_SEARCH]
  if searchData[index] then
    local searchCell = self.tableViewSearch:GetLoadedCell(index)
    local headImage = searchCell:GetChild("img_headPortrait")
    local lab_name = searchCell:GetChild("lab_name")
    local lab_levelNum = searchCell:GetChild("lab_level/lab_levelNum")
    local btn_addFriend = searchCell:GetChild("btn_addFriend")
    local btn_addBlack = searchCell:GetChild("btn_addBlack")
    local btnFriendStatus = btn_addFriend:GetChild("Text")
    local btnBlackStatus = btn_addBlack:GetChild("Text")
    local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(searchData[index].info.career, "id").headPortrait
    self:SetSprite("Atlas_headPortrait", spriteName, headImage)
    lab_name:SetText(searchData[index].info.name)
    local levelStr = string.format("Lv.%d", searchData[index].info.level)
    lab_levelNum:SetText(levelStr)
    if FriendData.IsHasRelation(searchData[index].info.roleId, FriendTypeEnum.APPLY_LIST) then
      btnFriendStatus:SetText("\196\144\195\163 xin")
    elseif FriendData.IsHasRelation(searchData[index].info.roleId, FriendTypeEnum.FRIEND) then
      btnFriendStatus:SetText("\196\144\195\163 th\195\170m")
    else
      btnFriendStatus:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamAddFriend"))
    end
    if FriendData.IsHasRelation(searchData[index].info.roleId, FriendTypeEnum.BLACKLIST) then
      btnBlackStatus:SetText("\196\144\195\163 \225\186\169n")
    else
      btnBlackStatus:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamShield"))
    end
    self:SetAddFriendBtnClick(btn_addFriend, searchData[index].info, FriendTypeEnum.FRIEND, btnFriendStatus, index)
    self:SetAddFriendBtnClick(btn_addBlack, searchData[index].info, FriendTypeEnum.BLACKLIST, btnBlackStatus, index)
  end
end

function Friend_FriChatUI:CreateApplyFriendTableView()
  self.tableViewApply = UITableView()
  self.tableViewApply:SetLowerMargin(0)
  self.tableViewApply:SetScrollView(self.sw_applyList)
  self.tableViewApply:SetNumberOfCellsAtRowOrColumn(1)
  _, self.img_applyBgSizeY = self.img_applyBg:GetSizeDelta()
  self.tableViewApply:SetScalarForCellInTableView(self, self.GetSizeApplyCell)
  self.tableViewApply:SetUpperMargin(0)
  self.tableViewApply:SetTotalCellCount(self, self.GetApplyCountCount)
  self.tableViewApply:SetCellAtIndexInTableView(self, self.GetApplyCell)
  self.tableViewApply:SetCellAtIndexInTableViewWillAppear(self, self.UpdateApplyCell)
  self.tableViewApply:ReloadData(1)
end

function Friend_FriChatUI:GetSizeApplyCell()
  return self.img_applyBgSizeY
end

function Friend_FriChatUI:GetApplyCountCount()
  return FriendData.GetFriendCountByType(FriendTypeEnum.BE_APPLY_LIST)
end

function Friend_FriChatUI:GetApplyCell()
  return self.tableViewApply:ReuseOrCreateCell(self.img_applyBg)
end

function Friend_FriChatUI:UpdateApplyCell(index)
  local applyData = FriendData.FriendList[FriendTypeEnum.BE_APPLY_LIST]
  if applyData[index] then
    local applyCell = self.tableViewApply:GetLoadedCell(index)
    local headImage = applyCell:GetChild("img_headPortrait")
    local lab_name = applyCell:GetChild("lab_name")
    local lab_levelNum = applyCell:GetChild("lab_level/lab_levelNum")
    local btn_agree = applyCell:GetChild("btn_agree")
    local btn_refuse = applyCell:GetChild("btn_refuse")
    btn_agree.id = applyData[index].info.roleId
    btn_agree.flag = true
    btn_agree:SetOnClick(self, self.AgreeApplyForFriend)
    btn_refuse.id = applyData[index].info.roleId
    btn_refuse.flag = false
    btn_refuse:SetOnClick(self, self.RefuseApplyForFriend)
    local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(applyData[index].info.career, "id").headPortrait
    self:SetSprite("Atlas_headPortrait", spriteName, headImage)
    lab_name:SetText(applyData[index].info.name)
    local levelStr = string.format("Lv.%d", applyData[index].info.level)
    lab_levelNum:SetText(levelStr)
  end
end

function Friend_FriChatUI:CreateBlackListTableView()
  self.blacklistTableView = UITableView()
  self.blacklistTableView:SetLowerMargin(0)
  self.blacklistTableView:SetScrollView(self.sw_friendBlackList)
  _, self.img_friendBlackListSizeY = self.img_friendBlackList:GetSizeDelta()
  self.blacklistTableView:SetScalarForCellInTableView(self, self.GetSizeBlackListCell)
  self.blacklistTableView:SetUpperMargin(5)
  self.blacklistTableView:SetTotalCellCount(self, self.GetBlackListCount)
  self.blacklistTableView:SetCellAtIndexInTableView(self, self.GetBlackListCell)
  self.blacklistTableView:SetCellAtIndexInTableViewWillAppear(self, self.UpdateBlackListCell)
  self.blacklistTableView:ReloadData(1)
end

function Friend_FriChatUI:GetSizeBlackListCell()
  return self.img_friendBlackListSizeY
end

function Friend_FriChatUI:GetBlackListCount()
  return FriendData.GetFriendCountByType(FriendTypeEnum.BLACKLIST)
end

function Friend_FriChatUI:GetBlackListCell()
  return self.blacklistTableView:ReuseOrCreateCell(self.img_friendBlackList)
end

function Friend_FriChatUI:UpdateBlackListCell(index)
  local blackData = FriendData.FriendList[FriendTypeEnum.BLACKLIST]
  if blackData[index] then
    local cell = self.blacklistTableView:GetLoadedCell(index)
    local headImage = cell:GetChild("img_headPortrait")
    local lab_name = cell:GetChild("lab_name")
    local lab_levelNum = cell:GetChild("lab_levelNum")
    local lab_onLine = cell:GetChild("lab_onLine")
    local lab_offLine = cell:GetChild("lab_offLine")
    local img_selectionEffect = cell:GetChild("img_selectionEffect")
    local playerInfo = UIControl(cell.transform, "playerInfo")
    playerInfo.friendChatCell = cell
    playerInfo.friendinfo = blackData[index]
    playerInfo:SetOnClick(self, self.ShowFriendOnClick)
    local unionName = blackData[index].info.unionName ~= "" and blackData[index].info.unionName or "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i"
    local grad = UIControl(cell.transform, "grad")
    grad:SetText("Guild: " .. unionName)
    lab_offLine:SetActive(not blackData[index].info.online)
    lab_onLine:SetActive(blackData[index].info.online)
    local mapId = blackData[index].info.mapId
    local blackMap = ClientTable.cfg_Map_mapManager:TryGetValue(mapId)
    local meMap = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
    if blackMap and blackMap.serverType ~= meMap.serverType then
      if blackMap.serverType == 1 then
        lab_onLine:SetText("ON")
      else
        lab_onLine:SetText("Li\195\170n Server")
      end
    elseif blackMap.serverType == 1 then
      lab_onLine:SetText("ON")
    else
      lab_onLine:SetText("Li\195\170n Server")
    end
    local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(blackData[index].info.career, "id").headPortrait
    self:SetSprite("Atlas_headPortrait", spriteName, headImage)
    headImage:SetColor(blackData[index].info.online and "0xFFFFFFFF" or "0x808080FF")
    lab_name:SetText(blackData[index].info.name)
    local levelStr = string.format("Lv.%d", blackData[index].info.level)
    lab_levelNum:SetText(levelStr)
    cell.id = blackData[index].info.roleId
    cell.index = index
    cell.selectEff = img_selectionEffect
    cell.playerInfo = playerInfo
    if self.blackId == cell.id then
      cell:SetInteractable(false)
    else
      cell:SetInteractable(true)
    end
    img_selectionEffect:SetActive(self.curBlacklistIndex == cell.index)
    playerInfo:SetActive(self.curBlacklistIndex == cell.index)
    cell:SetOnClick(self, self.ShowBlackListInfo)
  end
end

function Friend_FriChatUI:CreateEnemyTableView()
  self.enemyTableView = UITableView()
  self.enemyTableView:SetLowerMargin(0)
  self.enemyTableView:SetScrollView(self.sw_enemyList)
  _, self.img_enemyListSizeY = self.img_enemyList:GetSizeDelta()
  self.enemyTableView:SetScalarForCellInTableView(self, self.GetSizeEnemyCell)
  self.enemyTableView:SetUpperMargin(5)
  self.enemyTableView:SetTotalCellCount(self, self.GetEnemyCount)
  self.enemyTableView:SetCellAtIndexInTableView(self, self.GetEnemyCell)
  self.enemyTableView:SetCellAtIndexInTableViewWillAppear(self, self.UpdateEnemyCell)
  self.enemyTableView:ReloadData(1)
end

function Friend_FriChatUI:GetSizeEnemyCell()
  return self.img_enemyListSizeY
end

function Friend_FriChatUI:GetEnemyCount()
  return FriendData.GetFriendCountByType(FriendTypeEnum.ENEMY)
end

function Friend_FriChatUI:GetEnemyCell()
  return self.enemyTableView:ReuseOrCreateCell(self.img_enemyList)
end

function Friend_FriChatUI:UpdateEnemyCell(index)
  local enemyData = FriendData.FriendList[FriendTypeEnum.ENEMY]
  if enemyData[index] then
    local cell = self.enemyTableView:GetLoadedCell(index)
    local headImage = cell:GetChild("img_headPortrait")
    local lab_name = cell:GetChild("lab_name")
    local lab_levelNum = cell:GetChild("lab_level")
    local lab_onLine = cell:GetChild("lab_onLine")
    local lab_offLine = cell:GetChild("lab_offLine")
    local img_selectionEffect = cell:GetChild("img_selectionEffect")
    local playerInfo = UIControl(cell.transform, "playerInfo")
    playerInfo.friendChatCell = cell
    playerInfo.friendinfo = enemyData[index]
    playerInfo:SetOnClick(self, self.ShowFriendOnClick)
    local unionName = enemyData[index].info.unionName ~= "" and enemyData[index].info.unionName or "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i"
    local grad = UIControl(cell.transform, "grad")
    grad:SetText("Guild: " .. unionName)
    local threat = UIControl(cell.transform, "threat")
    threat:SetText("\196\144i\225\187\131m th\195\185 gh\195\169t: " .. math.abs(enemyData[index].intimacy))
    lab_offLine:SetActive(not enemyData[index].info.online)
    lab_onLine:SetActive(enemyData[index].info.online)
    local mapId = enemyData[index].info.mapId
    local enemyMap = ClientTable.cfg_Map_mapManager:TryGetValue(mapId)
    local meMap = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
    if enemyMap and enemyMap.serverType ~= meMap.serverType then
      if enemyMap.serverType == 1 then
        lab_onLine:SetText("ON")
      else
        lab_onLine:SetText("Li\195\170n Server")
      end
    elseif enemyMap.serverType == 1 then
      lab_onLine:SetText("ON")
    else
      lab_onLine:SetText("Li\195\170n Server")
    end
    local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(enemyData[index].info.career, "id").headPortrait
    self:SetSprite("Atlas_headPortrait", spriteName, headImage)
    headImage:SetColor(enemyData[index].info.online and "0xFFFFFFFF" or "0x808080FF")
    lab_name:SetText(enemyData[index].info.name)
    local levelStr = string.format("Lv.%d", enemyData[index].info.level)
    lab_levelNum:SetText(levelStr)
    cell.id = enemyData[index].info.roleId
    cell.index = index
    cell.selectEff = img_selectionEffect
    cell.playerInfo = playerInfo
    if self.enemyId == cell.id then
      self.enemyId = cell.id
      cell:SetInteractable(false)
    else
      cell:SetInteractable(true)
    end
    img_selectionEffect:SetActive(self.curEnemyInfoIndex == cell.index)
    playerInfo:SetActive(self.curEnemyInfoIndex == cell.index)
    cell:SetOnClick(self, self.ShowEnemyInfo)
  end
end

function Friend_FriChatUI:CreateRecommendFriendTableView()
  self.tableViewRecommend = UITableView()
  self.tableViewRecommend:SetLowerMargin(0)
  self.tableViewRecommend:SetScrollView(self.sw_recommendList)
  self.tableViewRecommend:SetNumberOfCellsAtRowOrColumn(1)
  _, self.img_recommendBgSizeY = self.img_recommendBg:GetSizeDelta()
  self.tableViewRecommend:SetScalarForCellInTableView(self, self.GetSizeRecommendCell)
  self.tableViewRecommend:SetUpperMargin(0)
  self.tableViewRecommend:SetTotalCellCount(self, self.GetRecommendCountCount)
  self.tableViewRecommend:SetCellAtIndexInTableView(self, self.GetRecommendCell)
  self.tableViewRecommend:SetCellAtIndexInTableViewWillAppear(self, self.UpdateRecommendCell)
  self.tableViewRecommend:ReloadData(1)
end

function Friend_FriChatUI:GetSizeRecommendCell()
  return self.img_recommendBgSizeY
end

function Friend_FriChatUI:GetRecommendCountCount()
  return FriendData.GetFriendCountByType(FriendTypeEnum.RECOMMEND)
end

function Friend_FriChatUI:GetRecommendCell(index)
  return self.tableViewRecommend:ReuseOrCreateCell(self.img_recommendBg)
end

function Friend_FriChatUI:UpdateRecommendCell(index)
  local recommendData = FriendData.FriendList[FriendTypeEnum.RECOMMEND]
  if recommendData[index] then
    local recommendCell = self.tableViewRecommend:GetLoadedCell(index)
    local headImage = recommendCell:GetChild("img_headPortrait")
    local lab_name = recommendCell:GetChild("lab_name")
    local lab_levelNum = recommendCell:GetChild("lab_level/lab_levelNum")
    local btn_addFriend = recommendCell:GetChild("btn_addFriend")
    local btn_addBlack = recommendCell:GetChild("btn_addBlack")
    local btnFriendStatus = btn_addFriend:GetChild("Text")
    local btnBlackStatus = btn_addBlack:GetChild("Text")
    local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(recommendData[index].info.career, "id").headPortrait
    self:SetSprite("Atlas_headPortrait", spriteName, headImage)
    lab_name:SetText(recommendData[index].info.name)
    local levelStr = string.format("Lv.%d", recommendData[index].info.level)
    lab_levelNum:SetText(levelStr)
    if FriendData.GetFriendIndexByIdOnType(recommendData[index].info.roleId, FriendTypeEnum.APPLY_LIST) then
      btnFriendStatus:SetText("\196\144\195\163 xin")
    elseif FriendData.IsHasRelation(recommendData[index].info.roleId, FriendTypeEnum.FRIEND) then
      btnFriendStatus:SetText("\196\144\195\163 th\195\170m")
    else
      btnFriendStatus:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamAddFriend"))
    end
    if FriendData.GetFriendIndexByIdOnType(recommendData[index].info.roleId, FriendTypeEnum.BLACKLIST) then
      btnBlackStatus:SetText("\196\144\195\163 \225\186\169n")
    else
      btnBlackStatus:SetText(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamShield"))
    end
    self:SetAddFriendBtnClick(btn_addFriend, recommendData[index].info, FriendTypeEnum.FRIEND, btnFriendStatus, index)
    self:SetAddFriendBtnClick(btn_addBlack, recommendData[index].info, FriendTypeEnum.BLACKLIST, btnBlackStatus, index)
  end
end
