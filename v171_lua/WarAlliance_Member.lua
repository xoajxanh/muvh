WarAlliance_Member = class(BaseUI)
WarAlliance_Member.layer = UILayer.Panel
WarAlliance_Member.orderInLayer = 2
WarAlliance_Member.hideType = UIHideType.Destroy
WarAlliance_Member.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_Member.escClose = UIEscClose.DontClose

function WarAlliance_Member:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.TwoTierCloseBtn = self:GetControl("img_bg/TwoTierCloseBtn")
  self.btn_memberManager = self:GetControl("btn_memberManager")
  self.btn_levelSort = self:GetControl("WarAllianceMemberListScr/Title/btn_levelSort")
  self.arrows_level = self:GetControl("WarAllianceMemberListScr/Title/btn_levelSort/arrows_level")
  self.bg_arrows_level = self:GetControl("WarAllianceMemberListScr/Title/btn_levelSort/bg_arrows_level")
  self.arrow_up_level = self:GetControl("WarAllianceMemberListScr/Title/btn_levelSort/bg_arrows_level/arrow_up/arrow_up_level")
  self.arrow_down_level = self:GetControl("WarAllianceMemberListScr/Title/btn_levelSort/bg_arrows_level/arrow_down/arrow_down_level")
  self.btn_jobSort = self:GetControl("WarAllianceMemberListScr/Title/btn_jobSort")
  self.arrows_job = self:GetControl("WarAllianceMemberListScr/Title/btn_jobSort/arrows_job")
  self.bg_arrows_job = self:GetControl("WarAllianceMemberListScr/Title/btn_jobSort/bg_arrows_job")
  self.arrow_up_job = self:GetControl("WarAllianceMemberListScr/Title/btn_jobSort/bg_arrows_job/arrow_up/arrow_up_job")
  self.arrow_down_job = self:GetControl("WarAllianceMemberListScr/Title/btn_jobSort/bg_arrows_job/arrow_down/arrow_down_job")
  self.btn_stateSort = self:GetControl("WarAllianceMemberListScr/Title/btn_stateSort")
  self.arrows_state = self:GetControl("WarAllianceMemberListScr/Title/btn_stateSort/arrows_state")
  self.bg_arrows_state = self:GetControl("WarAllianceMemberListScr/Title/btn_stateSort/bg_arrows_state")
  self.arrow_up_state = self:GetControl("WarAllianceMemberListScr/Title/btn_stateSort/bg_arrows_state/arrow_up/arrow_up_state")
  self.arrow_down_state = self:GetControl("WarAllianceMemberListScr/Title/btn_stateSort/bg_arrows_state/arrow_down/arrow_down_state")
  self.WarAllianceMemberItem = self:GetControl("WarAllianceMemberListScr/bg_WarAlliancePanel/Viewport/Content/WarAllianceMemberItem")
  self.lab_memberCount = self:GetControl("lab_memberCount")
  self.notice_member = self:GetControl("notice_member")
  self.MemberDataPanel = self:GetControl("MemberDataPanel")
  self.btn_PanelClose = self:GetControl("MemberDataPanel/btn_PanelClose")
  self.HeadPortrait = self:GetControl("MemberDataPanel/panel_member/HeadPortrait")
  self.MemberNameText = self:GetControl("MemberDataPanel/panel_member/MemberNameText")
  self.PowerText = self:GetControl("MemberDataPanel/panel_member/Power/PowerText")
  self.MemberLevelText = self:GetControl("MemberDataPanel/panel_member/MemberLevel/MemberLevelText")
  self.AddFriendBtn = self:GetControl("MemberDataPanel/panel_member/BtnBg/AddFriendBtn")
  self.PrivateChatBtn = self:GetControl("MemberDataPanel/panel_member/BtnBg/PrivateChatBtn")
  self.PlayerDetailBtn = self:GetControl("MemberDataPanel/panel_member/BtnBg/PlayerDetailBtn")
  self.panel_manager = self:GetControl("MemberDataPanel/panel_manager")
  self.tog_SetType1 = self:GetControl("MemberDataPanel/panel_manager/MemberSetType/tog_SetType1")
  self.tog_SetType2 = self:GetControl("MemberDataPanel/panel_manager/MemberSetType/tog_SetType2")
  self.tog_SetType3 = self:GetControl("MemberDataPanel/panel_manager/MemberSetType/tog_SetType3")
  self.tog_SetType4 = self:GetControl("MemberDataPanel/panel_manager/MemberSetType/tog_SetType4")
  self.tog_SetType5 = self:GetControl("MemberDataPanel/panel_manager/MemberSetType/tog_SetType5")
  self.tog_SetType6 = self:GetControl("MemberDataPanel/panel_manager/MemberSetType/tog_SetType6")
  self.CancelManageBtn = self:GetControl("MemberDataPanel/panel_manager/CancelManageBtn")
  self.ConfirmManageBtn = self:GetControl("MemberDataPanel/panel_manager/ConfirmManageBtn")
end

function WarAlliance_Member:Init()
  self.MemberInfo = {}
  self.GradMemberObjTab = {}
  self.ToggleTab = {}
end

function WarAlliance_Member:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_Member:InitUI()
  self.ToggleTab = {
    [1] = self.tog_SetType1,
    [2] = self.tog_SetType2,
    [3] = self.tog_SetType3,
    [4] = self.tog_SetType4,
    [5] = self.tog_SetType5,
    [6] = self.tog_SetType6
  }
  self.sortLevelTab = {
    [1] = self.arrow_up_level,
    [2] = self.arrow_down_level
  }
  self.sortJobTab = {
    [1] = self.arrow_up_job,
    [2] = self.arrow_down_job
  }
  self.sortStateTab = {
    [1] = self.arrow_up_state,
    [2] = self.arrow_down_state
  }
  self:InitContent()
end

function WarAlliance_Member:OnShow()
  self.OpenThisUI = true
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_Member:OnHide()
  self.OpenThisUI = true
end

function WarAlliance_Member:OnDestroy()
end

function WarAlliance_Member:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.TwoTierCloseBtn:SetOnClick(self, self.btn_closeBgOnClick)
  self.AddFriendBtn:SetOnClick(self, self.AddFriendBtnOnClick)
  self.PrivateChatBtn:SetOnClick(self, self.PrivateChatBtnOnClick)
  self.CancelManageBtn:SetOnClick(self, self.CancelManageBtnOnClick)
  self.ConfirmManageBtn:SetOnClick(self, self.ConfirmManageBtnOnClick)
  self.btn_memberManager:SetOnClick(self, self.btn_memberManagerOnClick)
  self.PlayerDetailBtn:SetOnClick(self, self.PlayerDetailBtnOnClick)
  self.btn_PanelClose:SetOnClick(self, self.btn_PanelCloseOnClick)
  self.btn_levelSort:SetOnClick(self, self.btn_levelSortOnClick)
  self.btn_jobSort:SetOnClick(self, self.btn_jobSortOnClick)
  self.btn_stateSort:SetOnClick(self, self.btn_stateSortOnClick)
end

function WarAlliance_Member:btn_closeBgOnClick(control)
  self:btn_PanelCloseOnClick()
  UIManager.Hide(UIID.WarAlliance_Member)
end

function WarAlliance_Member:PlayerDetailBtnOnClick()
  local role = RoleManager.GetRoleById(self.MemberInfo.info.roleId)
  local tab = {}
  if role then
    tab = {
      Data = role.equipsData.Data,
      roleInfo = {
        career = self.MemberInfo.info.career
      }
    }
  elseif RoleInteractData.equipData.Data ~= nil then
    tab = {
      Data = RoleInteractData.equipData.Data,
      roleInfo = {
        career = self.MemberInfo.info.career
      }
    }
  end
  gameMgr:GetAvatarManager():GetOtherPlayer():GetInfo():RefrashData({
    career = self.MemberInfo.info.career
  })
  if UIManager.IsVisible(UIID.Rank_EquipInfoUI) and not self.openThisUI then
    EventManager.Dispatch(Event.RefreshRank_EquipInfoUI, tab)
  else
    UIManager.Show(UIID.Rank_EquipInfoUI, tab)
    self.openThisUI = false
  end
end

function WarAlliance_Member:btn_PanelCloseOnClick()
  self.MemberDataPanel:SetActive(false)
end

function WarAlliance_Member:AddFriendBtnOnClick(control)
  if self.MemberInfo.info.roleId then
    ChatUtility.GetFuncWithChatOrFriend(ChatFuncEnum.ADD_FRIEND, self.MemberInfo.info.roleId)
  end
end

function WarAlliance_Member:PrivateChatBtnOnClick(control)
  if self.MemberInfo.info.name then
    ChatUtility.GetFuncWithChatOrFriend(ChatFuncEnum.CHAT, self.MemberInfo.info.name)
  end
end

function WarAlliance_Member:CancelManageBtnOnClick(control)
  if QuickFind:GetDuoQiCrossDataManager():IsDuoQiActivityOpen() == true then
    FloatingTipUtility.QuickMsg(QuickFind:GetDuoQiCrossDataManager():GetCanNotOperateStr())
    return
  end
  self:btn_PanelCloseOnClick()
end

function WarAlliance_Member:ConfirmManageBtnOnClick(control)
  if QuickFind:GetDuoQiCrossDataManager():IsDuoQiActivityOpen() == true then
    FloatingTipUtility.QuickMsg(QuickFind:GetDuoQiCrossDataManager():GetCanNotOperateStr())
    return
  end
  local PosTbl = {
    "Ph\195\179 Guild",
    "\196\144\225\187\153i Tr\198\176\225\187\159ng \196\144\225\187\153t K\195\173ch",
    "Th\195\160nh Vi\195\170n Tinh Anh",
    "Th\195\160nh Vi\195\170n Guild ",
    "Tr\198\176\225\187\159ng Guild "
  }
  local pitchNum
  for i = 1, #self.ToggleTab do
    if self.ToggleTab[i].toggle.isOn == true and self.ToggleTab[i]:GetActive() then
      pitchNum = i + 1
      break
    end
  end
  if pitchNum == self.MemberInfo.info.unionPosition then
    local str = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("WarAlliance_MemberDataPrompt")
    FloatingTipUtility.QuickMsg(str)
  elseif pitchNum <= 6 then
    local formatArgs = {
      self.MemberInfo.info.name,
      PosTbl[self.MemberInfo.info.unionPosition - 1],
      PosTbl[pitchNum - 1],
      self.MemberInfo.info.unionPosition,
      pitchNum
    }
    TipUtility.QuickShowPrompt({
      id = 65,
      contentFormatArgs = formatArgs,
      okAction = function()
        self:ChangeWarAllianceMemberPosCallBack(pitchNum)
      end
    })
  elseif pitchNum == 7 then
    TipUtility.QuickShowPrompt({
      id = 66,
      contentFormatArgs = self.MemberInfo.info.name,
      okAction = function()
        self:ChangeWarAllianceMemberPosCallBack(pitchNum)
      end
    })
  end
end

function WarAlliance_Member:ChangeWarAllianceMemberPosCallBack(pitchNum)
  if pitchNum == WarAlliancePositionType.KickOut then
    NetManager.Send(UnionMessage.ReqKickMember, {
      id = self.MemberInfo.info.roleId
    })
  elseif pitchNum == WarAlliancePositionType.Demise then
    NetManager.Send(UnionMessage.ReqAssignment, {
      id = self.MemberInfo.info.roleId,
      position = 1
    })
    NetManager.Send(UnionMessage.ReqMemberList)
  elseif pitchNum ~= self.MemberInfo.info.unionPosition then
    NetManager.Send(UnionMessage.ReqAssignment, {
      id = self.MemberInfo.info.roleId,
      position = pitchNum
    })
  end
  NetManager.Send(UnionMessage.ReqUnionBaseInfo)
  self:btn_PanelCloseOnClick()
end

function WarAlliance_Member:btn_memberManagerOnClick()
  UIManager.Show(UIID.WarAlliance_MemberApplyUI)
end

function WarAlliance_Member:RegistEvents()
  self:RegistEvent(Event.WarAlliance_MemberList, self.WarAlliance_MemberList, self)
  self:RegistEvent(Event.WarAlliance_UpdateMemberList, self.WarAlliance_UpdateMemberList, self)
  self:RegistEvent(Event.WarAlliance_MemberMsg, self.WarAllianceMemberMsg, self)
  self:RegistEvent(Event.WarAlliance_MyWarAllianceData, self.InitMyWarAlliance, self)
end

function WarAlliance_Member:InitMyWarAlliance()
  self.levelSort = true
  self.jobSort = true
  self.stateSort = true
  self.arrows_level.transform.rotation = Vector3.zero
  self.arrows_job.transform.rotation = Vector3.zero
  self.arrows_state.transform.rotation = Vector3.zero
  if WarAllianceData.IsHaveUnion and not WarAllianceData.MyWarAllianceData then
    NetManager.Send(UnionMessage.ReqMemberList)
  end
  self.MyPosition = WarAllianceData.MyWarAllianceData
  if self.MyPosition.position == WarAllianceMemberType.Leader or self.MyPosition.position == WarAllianceMemberType.viceLeader or self.MyPosition.position == WarAllianceMemberType.Captain then
    self.btn_memberManager:SetActive(true)
  else
    self.btn_memberManager:SetActive(false)
  end
end

function WarAlliance_Member:Refresh()
  NetManager.Send(UnionMessage.ReqMemberList)
  self:btn_PanelCloseOnClick()
  self:InitMyWarAlliance()
  self:HideArrow()
end

local function WarAllianceMemberItemCreate(control)
  control.lab_name = UIControl(control.transform, "lab_name")
  control.lab_job = UIControl(control.transform, "lab_job")
  control.lab_armband = UIControl(control.transform, "lab_armband")
  control.lab_state = UIControl(control.transform, "lab_state")
  control.img_prof = UIControl(control.transform, "img_prof")
end

function WarAlliance_Member:InitContent()
  self.WarAllianceMemberItemTemp = UIContainer(self.WarAllianceMemberItem, self, WarAllianceMemberItemCreate)
end

local function MemberListSort(data1, data2)
  local isOnline1 = data1.mapId ~= 0
  local isOnline2 = data2.mapId ~= 0
  if isOnline1 and not isOnline2 then
    return true
  elseif not isOnline1 and isOnline2 then
    return false
  elseif not isOnline1 and not isOnline2 then
    return data1.logoutTime > data2.logoutTime
  end
  if data1.position ~= data2.position then
    return data1.position < data2.position
  end
  local level1 = data1.level or 0
  local level2 = data2.level or 0
  if level1 ~= level2 then
    return level1 > level2
  end
  return false
end

function WarAlliance_Member:WarAlliance_MemberList()
  local data = table.DeepCopy(WarAllianceData.MemberList)
  table.sort(data, MemberListSort)
  self:SetMemberList(data)
end

function WarAlliance_Member:SetMemberList(data)
  if self.GradMemberObjTab ~= nil then
    for i = 1, #self.GradMemberObjTab do
      self.GradMemberObjTab[i]:SetActive(false)
    end
    self.GradMemberObjTab = {}
  end
  local onlineCnt = 0
  if 0 < #data then
    for i = 1, #data do
      local memberTbl = ClientTable.cfg_union_memberManager:TryGetValue(data[i].position, "id")
      local charaConfig = ClientTable.cfg_Character_attributeManager:TryGetValue(data[i].career, "id")
      local obj = self.WarAllianceMemberItemTemp:GetOrCreateItem(i)
      local isMe = ViewData.meData.id == data[i].id
      local isOnline = data[i].mapId ~= 0
      if isOnline then
        onlineCnt = onlineCnt + 1
      end
      if isOnline then
        local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(data[i].mapId, "id")
        obj.lab_state:SetText(string.format(LocalizationUtility.GetContentByKey("UnionWord_14"), mapTbl.name))
      else
        local timerStr = ""
        local sec = (Time.GetServerTime() - data[i].logoutTime) / 1000
        local seconds = math.fmod(sec, 60)
        local min = math.floor(sec / 60)
        local hour = math.floor(min / 60)
        local day = math.floor(hour / 24)
        if 0 < day then
          timerStr = string.format("%d ng\195\160y", day)
        elseif 0 < hour then
          timerStr = string.format("%d gi\225\187\157", hour)
        end
        obj.lab_state:SetText(string.format(LocalizationUtility.GetContentByKey("UnionWord_2"), timerStr))
      end
      obj.lab_name:SetText(data[i].name)
      obj.lab_job:SetText(memberTbl.desc)
      obj.lab_armband:SetText(data[i].level or 0)
      obj:SetSprite("Atlas_Common", charaConfig.roleicon, obj.img_prof)
      obj:SetOnClick(self, function()
        self:WarAllianceMemberItemOnClick(obj, data[i])
      end)
      obj:SetActive(true)
      local nameColor = ItemQuality2ColorDic[0]
      if isMe then
        nameColor = ItemQuality2ColorDic[5]
      end
      if not isOnline then
        nameColor = ItemQuality2ColorDic[10]
      end
      local jobColors = {
        ItemQuality2ColorDic[12],
        ItemQuality2ColorDic[12],
        ItemQuality2ColorDic[26],
        ItemQuality2ColorDic[25],
        ItemQuality2ColorDic[0]
      }
      local jobColor = jobColors[memberTbl.id]
      if not isOnline then
        jobColor = ItemQuality2ColorDic[10]
      end
      local onlineColor = ItemQuality2ColorDic[5]
      if not isOnline then
        onlineColor = ItemQuality2ColorDic[10]
      end
      nameColor = string.format("0x%sFF", string.sub(nameColor, 2))
      jobColor = string.format("0x%sFF", string.sub(jobColor, 2))
      onlineColor = string.format("0x%sFF", string.sub(onlineColor, 2))
      obj.lab_name:SetColor(nameColor)
      obj.lab_job:SetColor(jobColor)
      obj.lab_armband:SetColor(nameColor)
      obj.lab_state:SetColor(onlineColor)
      table.insert(self.GradMemberObjTab, obj)
    end
  end
  self.lab_memberCount:SetText(string.format("S\225\187\145 ng\198\176\225\187\157i online %s", string.GetColorText(string.format("%d/%d", onlineCnt, #data), ItemQuality2ColorDic[5])))
end

function WarAlliance_Member:WarAllianceMemberItemOnClick(_, data)
  if data.id == RoleManager.me.id then
    return
  end
  if not self.MemberDataPanel:GetActive() then
    networkRequest.ReqOtherRoleInfo(0, 0, data.id)
    NetManager.Send(UnionMessage.ReqMemberDetailedInfo, {
      id = data.id
    })
  end
  RoleInteractData.interactType = RoleOpenType.WarOpen
  NetManager.Send(RoleMessage.ReqTeamEquipsInfo, {
    roleId = data.id
  })
  self.MemberDataPanel:SetActive(not self.MemberDataPanel:GetActive())
  self.panel_manager:SetActive(WarAllianceData.MyWarAllianceData.position < data.position)
end

function WarAlliance_Member:WarAlliance_UpdateMemberList()
  for i = #self.GradMemberObjTab, 1, -1 do
    self.GradMemberObjTab[i]:Destroy()
    self.WarAllianceMemberItemTemp:DesToryItem(i)
  end
  self:WarAlliance_MemberList()
  NetManager.Send(UnionMessage.ReqUnionBaseInfo)
end

function WarAlliance_Member:WarAllianceMemberMsg(id, msg)
  local data = msg
  local dataInfo = msg.info
  if data ~= nil then
    self.MemberNameText:SetText(dataInfo.name)
    self.MemberLevelText:SetText(dataInfo.level)
    self.PowerText:SetText(dataInfo.fight)
    local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(dataInfo.career, "id").headPortrait
    local color
    if dataInfo.online then
      color = "0xFFFFFFFF"
    else
      color = "0x605252FF"
    end
    self.HeadPortrait:SetColor(color)
    self:SetSprite("Atlas_headPortrait", spriteName, self.HeadPortrait)
    self.MemberInfo = data
  end
  for i = 1, #WarAllianceData.MemberList do
    if dataInfo.roleId == WarAllianceData.MemberList[i].id and data.position ~= WarAllianceData.MemberList[i].position then
      WarAllianceData.MemberList[i].position = data.position
      self:WarAlliance_MemberList()
    end
  end
  self:SetPositionPower(WarAllianceData.MyWarAllianceData.position, msg.position)
end

function WarAlliance_Member:PromptTipUI(str)
  UIManager.Show(UIID.PromptTipUI, {
    tile = LocalizationUtility.GetContentByKey("tishi"),
    textContent = str
  })
end

function WarAlliance_Member:SetPositionPower(pos, pos1)
  self.ToggleTab[1]:SetInteractable(pos == WarAllianceMemberType.Leader)
  self.ToggleTab[2]:SetInteractable(pos <= WarAllianceMemberType.viceLeader)
  self.ToggleTab[3]:SetInteractable(pos <= WarAllianceMemberType.Captain)
  self.ToggleTab[4]:SetInteractable(pos <= WarAllianceMemberType.Captain)
  self.ToggleTab[5]:SetInteractable(pos == WarAllianceMemberType.Leader)
  self.ToggleTab[6]:SetInteractable(pos <= WarAllianceMemberType.Captain)
  if pos1 == WarAllianceMemberType.Leader then
    self.ToggleTab[5].toggle.isOn = true
  end
  if pos1 == WarAllianceMemberType.viceLeader then
    self.ToggleTab[1].toggle.isOn = true
  end
  if pos1 == WarAllianceMemberType.Captain then
    self.ToggleTab[2].toggle.isOn = true
  end
  if pos1 == WarAllianceMemberType.Elite then
    self.ToggleTab[3].toggle.isOn = true
  end
  if pos1 == WarAllianceMemberType.Member then
    self.ToggleTab[4].toggle.isOn = true
  end
end

function WarAlliance_Member:btn_levelSortOnClick()
  local sortType = self:SetSortType(WarAllianceMemberSortType.level, self.levelSort)
  self:SortStateIcon(self.sortLevelTab, self.levelSort)
  self:SortState(sortType)
  self.levelSort = not self.levelSort
end

function WarAlliance_Member:btn_jobSortOnClick()
  local sortType = self:SetSortType(WarAllianceMemberSortType.job, self.jobSort)
  self:SortStateIcon(self.sortJobTab, self.jobSort)
  self:SortState(sortType)
  self.jobSort = not self.jobSort
end

function WarAlliance_Member:btn_stateSortOnClick()
  local sortType = self:SetSortType(WarAllianceMemberSortType.state, self.stateSort)
  self:SortStateIcon(self.sortStateTab, self.stateSort)
  self:SortState(sortType)
  self.stateSort = not self.stateSort
end

function WarAlliance_Member:SetSortType(type, state)
  if type == WarAllianceMemberSortType.level then
    if state then
      return WarAllianceMemberSortStateType.levelUp
    else
      return WarAllianceMemberSortStateType.levelDown
    end
  elseif type == WarAllianceMemberSortType.job then
    if state then
      return WarAllianceMemberSortStateType.jobUp
    else
      return WarAllianceMemberSortStateType.jobDown
    end
  elseif type == WarAllianceMemberSortType.state then
    if state then
      return WarAllianceMemberSortStateType.stateUp
    else
      return WarAllianceMemberSortStateType.stateDown
    end
  end
end

function WarAlliance_Member:SortStateIcon(ctr, state)
  self:HideArrow()
  ctr[1]:SetActive(state)
  ctr[2]:SetActive(not state)
end

function WarAlliance_Member:HideArrow()
  for k, v in pairs(self.sortLevelTab) do
    v:SetActive(false)
  end
  for k, v in pairs(self.sortJobTab) do
    v:SetActive(false)
  end
  for k, v in pairs(self.sortStateTab) do
    v:SetActive(false)
  end
end

function WarAlliance_Member:SortState(sortType)
  local data = table.DeepCopy(WarAllianceData.MemberList)
  table.sort(data, function(a, b)
    local isOnline1 = a.mapId ~= 0
    local isOnline2 = b.mapId ~= 0
    if sortType == WarAllianceMemberSortStateType.levelUp then
      if a.level == b.level then
        if isOnline1 and not isOnline2 then
          return true
        elseif not isOnline1 and isOnline2 then
          return false
        end
        if a.position ~= b.position then
          return a.position < b.position
        end
      end
      return a.level < b.level
    elseif sortType == WarAllianceMemberSortStateType.levelDown then
      if a.level == b.level then
        if isOnline1 and not isOnline2 then
          return true
        elseif not isOnline1 and isOnline2 then
          return false
        end
        if a.position ~= b.position then
          return a.position < b.position
        end
      end
      return a.level > b.level
    elseif sortType == WarAllianceMemberSortStateType.jobUp then
      if a.position == b.position then
        if a.level ~= b.level then
          return a.level < b.level
        end
        if isOnline1 and not isOnline2 then
          return true
        elseif not isOnline1 and isOnline2 then
          return false
        end
      end
      return a.position > b.position
    elseif sortType == WarAllianceMemberSortStateType.jobDown then
      if a.position == b.position then
        if a.level ~= b.level then
          return a.level > b.level
        end
        if isOnline1 and not isOnline2 then
          return true
        elseif not isOnline1 and isOnline2 then
          return false
        end
      end
      return a.position < b.position
    elseif sortType == WarAllianceMemberSortStateType.stateUp then
      if a.logoutTime == b.logoutTime then
        if a.position ~= b.position then
          return a.position < b.position
        end
        if a.level ~= b.level then
          return a.level < b.level
        end
      end
      return a.logoutTime < b.logoutTime
    elseif sortType == WarAllianceMemberSortStateType.stateDown then
      if a.logoutTime == b.logoutTime then
        if a.position ~= b.position then
          return a.position < b.position
        end
        if a.level ~= b.level then
          return a.level < b.level
        end
      end
      return a.logoutTime > b.logoutTime
    end
  end)
  self:SetMemberList(data)
end
