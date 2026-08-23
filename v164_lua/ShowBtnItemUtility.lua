ShowBtnItemUtility = {}
local this = ShowBtnItemUtility
local teamOwnData
local roleTable = {}

function ShowBtnItemUtility.CheckCombination()
  if teamOwnData == nil then
    teamOwnData = {
      [1] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamPosition"),
        callbackFunc = RoleInteractFuncEnum.SendPos
      },
      [2] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamLeave"),
        callbackFunc = RoleInteractFuncEnum.LeaveTeam
      },
      [3] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamSee"),
        callbackFunc = RoleInteractFuncEnum.CheckPlayer
      },
      [4] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamAddFriend"),
        callbackFunc = RoleInteractFuncEnum.AddFriend
      },
      [5] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamAddAlliance"),
        callbackFunc = RoleInteractFuncEnum.InviteInUnion
      },
      [6] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamApplyAlliance"),
        callbackFunc = RoleInteractFuncEnum.ApplyUnion
      },
      [7] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamPrivateChat"),
        callbackFunc = RoleInteractFuncEnum.PrivateTalk
      },
      [8] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamKickTeam"),
        callbackFunc = RoleInteractFuncEnum.KickTeam
      },
      [9] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamCaptain"),
        callbackFunc = RoleInteractFuncEnum.UpgradeCaptain
      },
      [10] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamSelect"),
        callbackFunc = RoleInteractFuncEnum.SeleteRole
      },
      [11] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamComplaint"),
        callbackFunc = RoleInteractFuncEnum.ReportRole
      },
      [12] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("FriendDelete"),
        callbackFunc = RoleInteractFuncEnum.RemoveFriend
      },
      [13] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamShield"),
        callbackFunc = RoleInteractFuncEnum.MaskFriend
      },
      [14] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamInvitation"),
        callbackFunc = RoleInteractFuncEnum.InviteTeam
      },
      [15] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamApply"),
        callbackFunc = RoleInteractFuncEnum.ApplyTeam
      },
      [16] = {
        name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamInvitation"),
        callbackFunc = RoleInteractFuncEnum.CreateAndInviteTeam
      }
    }
  end
  local checkPlayerList = {}
  local role = RoleManager.GetRoleById(roleTable.roleId)
  local mapTbl
  if roleTable.mapId and roleTable.mapId > 0 then
    mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(roleTable.mapId, "id")
  end
  local isMe = roleTable.roleId == ViewData.meData.id
  if isMe then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[1]
  end
  if isMe and roleTable.teamId then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[2]
  end
  if not isMe then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[3]
  end
  if not isMe and not FriendData.IsFriend(roleTable.roleId) and not SceneData.IsCrossRealm() and ViewData.meData.serverId == roleTable.serverId then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[4]
  end
  if not isMe and not SceneData.IsCrossRealm() and ViewData.meData.serverId == roleTable.serverId and RoleManager.me.unionId and RoleManager.me.data.unionPosition == WarAllianceMemberType.Leader and roleTable.unionPosition == 0 then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[5]
  end
  if not isMe and not SceneData.IsCrossRealm() and ViewData.meData.serverId == roleTable.serverId and (not RoleManager.me.unionId or RoleManager.me.unionId and RoleManager.me.unionId == 0) and roleTable.unionPosition and roleTable.unionPosition == WarAllianceMemberType.Leader then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[6]
  end
  if not isMe and roleTable.interactType ~= RoleOpenType.FriendOpen then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[7]
  end
  if not isMe and TeamData.isLeader and TeamData.IsTeammate(roleTable.roleId) then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[8]
  end
  if not isMe and TeamData.isLeader and TeamData.IsTeammate(roleTable.roleId) then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[9]
  end
  if not isMe and roleTable.interactType == RoleOpenType.TeamOpen and role and roleTable.roleId ~= ViewData.meData.id then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[10]
  end
  if isMe or roleTable.interactType == RoleOpenType.NearTouch then
  end
  if not isMe and roleTable.interactType == RoleOpenType.FriendOpen and FriendData.IsFriend(roleTable.roleId) and ViewData.meData.serverId == roleTable.serverId then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[12]
  end
  if not isMe and (roleTable.interactType == RoleOpenType.FriendOpen or roleTable.interactType == RoleOpenType.ChatOpen) and ViewData.meData.serverId == roleTable.serverId then
    checkPlayerList[#checkPlayerList + 1] = teamOwnData[13]
  end
  if not isMe and (roleTable.interactType == RoleOpenType.FriendOpen or roleTable.interactType == RoleOpenType.ChatOpen or roleTable.interactType == RoleOpenType.NearTouch) then
    local isTeamIn = roleTable.teamId and 0 < roleTable.teamId
    if TeamData.isLeader and not isTeamIn and TeamData.GetAskTeamCondition() and this.IsSelfSpan(mapTbl) then
      checkPlayerList[#checkPlayerList + 1] = teamOwnData[14]
    end
  end
  if not isMe and (roleTable.interactType == RoleOpenType.FriendOpen or roleTable.interactType == RoleOpenType.ChatOpen or roleTable.interactType == RoleOpenType.NearTouch) then
    local isTeamIn = roleTable.teamId and 0 < roleTable.teamId
    if not TeamData.isInTeam and isTeamIn and TeamData.GetAskTeamCondition() and this.IsSelfSpan(mapTbl) then
      checkPlayerList[#checkPlayerList + 1] = teamOwnData[15]
    end
  end
  if not isMe and roleTable.interactType == RoleOpenType.NearTouch then
    local isTeamIn = roleTable.teamId and 0 < roleTable.teamId
    if not TeamData.isInTeam and not isTeamIn and TeamData.GetAskTeamCondition() and this.IsSelfSpan(mapTbl) then
      checkPlayerList[#checkPlayerList + 1] = teamOwnData[16]
    end
  end
  return checkPlayerList
end

function ShowBtnItemUtility.IsSelfSpan(mapTbl)
  return mapTbl and mapTbl.serverType and SceneData.serverType == serverType.span and mapTbl.serverType == serverType.span or mapTbl and mapTbl.serverType and SceneData.serverType == serverType.self and mapTbl.serverType == serverType.self
end

function ShowBtnItemUtility.GetRoelShowInfo(roleId, type)
  local role = RoleManager.GetRoleById(roleId)
  if role and roleId ~= ViewData.meData.id then
    local roleInteractTable = {
      interactType = type,
      online = true,
      mapId = role.data.data.info.mapId,
      serverId = role.data.data.info.serverId,
      roleId = role.data.id,
      roleName = role.data.name,
      unionName = role.data.unionName,
      unionPosition = role.data.unionPosition,
      teamId = role.data.teamId,
      fightValue = role.data.data.info.fight,
      career = role.data.career,
      level = role.data.level,
      equipData = role.data.equipsData,
      maxHp = role.data.maxHp,
      hp = role.data.hp,
      maxMp = role.data.maxMp,
      mp = role.data.mp
    }
    return roleInteractTable
  end
  return nil
end

function ShowBtnItemUtility.GetConditionBtns(role)
  roleTable = role
  if roleTable then
    return ShowBtnItemUtility.CheckCombination()
  end
end

local AllOperate = {
  [RoleInteractFuncEnum.CheckPlayer] = function()
    ShowBtnItemUtility.CheckPlayer()
  end,
  [RoleInteractFuncEnum.AddFriend] = function()
    ShowBtnItemUtility.AddFriend()
  end,
  [RoleInteractFuncEnum.InviteInUnion] = function()
    ShowBtnItemUtility.InviteInUnion()
  end,
  [RoleInteractFuncEnum.PrivateTalk] = function()
    ShowBtnItemUtility.PrivateTalk()
  end,
  [RoleInteractFuncEnum.SendPos] = function()
    ShowBtnItemUtility.SendPos()
  end,
  [RoleInteractFuncEnum.InviteTeam] = function()
    ShowBtnItemUtility.InviteTeam()
  end,
  [RoleInteractFuncEnum.CreateAndInviteTeam] = function()
    ShowBtnItemUtility.CreateAndInviteTeam()
  end,
  [RoleInteractFuncEnum.KickTeam] = function()
    ShowBtnItemUtility.KickTeam()
  end,
  [RoleInteractFuncEnum.UpgradeCaptain] = function()
    ShowBtnItemUtility.UpgradeCaptain()
  end,
  [RoleInteractFuncEnum.LeaveTeam] = function()
    ShowBtnItemUtility.LeaveTeam()
  end,
  [RoleInteractFuncEnum.ApplyTeam] = function()
    ShowBtnItemUtility.ApplyTeam()
  end,
  [RoleInteractFuncEnum.ApplyUnion] = function()
    ShowBtnItemUtility.ApplyUnion()
  end,
  [RoleInteractFuncEnum.RemoveFriend] = function()
    ShowBtnItemUtility.RemoveFriend()
  end,
  [RoleInteractFuncEnum.MaskFriend] = function()
    ShowBtnItemUtility.MaskFriend()
  end,
  [RoleInteractFuncEnum.SeleteRole] = function()
    ShowBtnItemUtility.SeleteRole()
  end,
  [RoleInteractFuncEnum.ReportRole] = function()
    ShowBtnItemUtility.ReportRole()
  end
}

function ShowBtnItemUtility.OperateType(type)
  local operateType = AllOperate[type]
  if operateType then
    operateType()
  end
end

function ShowBtnItemUtility.CheckPlayer()
  local role = RoleManager.GetRoleById(roleTable.roleId)
  local tab = {}
  if role then
    if roleTable.equipData.Data == nil then
      tab = {
        Data = role.equipsData.Data,
        Role = role.data.data
      }
    else
      tab = {
        Data = roleTable.equipData.Data,
        Role = role.data.data
      }
    end
  else
    tab = {
      Data = roleTable.equipData.Data,
      Role = nil,
      roleTable = roleTable
    }
  end
  gameMgr:GetAvatarManager():GetOtherPlayer():GetInfo():RefrashData(roleTable)
  UIManager.Show(UIID.Rank_EquipInfoUI, tab)
  if UIManager.IsVisible(UIID.Team_RoleInteractUI) then
    UIManager.Hide(UIID.Team_RoleInteractUI)
  end
end

function ShowBtnItemUtility.AddFriend()
  if roleTable and roleTable.roleId then
    ChatUtility.GetFuncWithChatOrFriend(ChatFuncEnum.ADD_FRIEND, roleTable.roleId)
    UIManager.Hide(UIID.Team_RoleInteractUI)
  end
end

function ShowBtnItemUtility.InviteInUnion()
  if roleTable and roleTable.roleId then
    NetManager.Send(UnionMessage.ReqInviteJoinUnion, {
      beInviteId = roleTable.roleId
    })
  end
end

function ShowBtnItemUtility.PrivateTalk()
  if roleTable and roleTable.roleName then
    UIManager.Hide(UIID.Team_RoleInteractUI)
    if not roleTable.serverId or roleTable.serverId and roleTable.serverId == ViewData.meData.serverId then
      ChatUtility.GetFuncWithChatOrFriend(ChatFuncEnum.CHAT, roleTable.roleName)
    else
      ChatUtility.GetFuncWithChatOrFriend(ChatFuncEnum.CHAT, "S" .. roleTable.serverId .. "." .. roleTable.roleName)
    end
  end
end

function ShowBtnItemUtility.SendPos()
  ChatUtility.GetFuncWithChatOrFriend(ChatFuncEnum.POS)
end

function ShowBtnItemUtility.InviteTeam()
  if roleTable and roleTable.roleId then
    if Activity_LuoLanSiegeData.activityStatus == ActivityStatusEnum.RUNNING then
      FloatingTipUtility.QuickMsg("Trong C\195\180ng Th\195\160nh Chi\225\186\191n kh\195\180ng th\225\187\131 t\225\187\149 \196\145\225\187\153i")
      return
    end
    EventManager.Dispatch(Event.Team_InviteInTeam, {
      roleTable.roleId
    })
    UIManager.Hide(UIID.Team_RoleInteractUI)
  end
end

function ShowBtnItemUtility.CreateAndInviteTeam()
  EventManager.Dispatch(Event.Team_CreateTeam, nil)
  if roleTable and roleTable.roleId then
    TeamData.AddInvitateRole(roleTable.roleId)
  end
  UIManager.Hide(UIID.Team_RoleInteractUI)
end

function ShowBtnItemUtility.KickTeam()
  if roleTable and roleTable.roleId then
    EventManager.Dispatch(Event.Team_KickOutRole, roleTable.roleId)
    UIManager.Hide(UIID.Team_RoleInteractUI)
  end
end

function ShowBtnItemUtility.UpgradeCaptain()
  if roleTable and roleTable.roleId then
    EventManager.Dispatch(Event.Team_TransferLeader, roleTable.roleId)
    UIManager.Hide(UIID.Team_RoleInteractUI)
  end
end

function ShowBtnItemUtility.LeaveTeam()
  EventManager.Dispatch(Event.Team_QuitTeam, nil)
  UIManager.Hide(UIID.Team_RoleInteractUI)
end

function ShowBtnItemUtility.ApplyTeam()
  if roleTable and roleTable.teamId then
    if Activity_LuoLanSiegeData.activityStatus == ActivityStatusEnum.RUNNING then
      FloatingTipUtility.QuickMsg("Trong C\195\180ng Th\195\160nh Chi\225\186\191n kh\195\180ng th\225\187\131 t\225\187\149 \196\145\225\187\153i")
      return
    end
    EventManager.Dispatch(Event.Team_AskEnterTeam, roleTable.teamId)
    UIManager.Hide(UIID.Team_RoleInteractUI)
  end
end

function ShowBtnItemUtility.ApplyUnion()
  if roleTable and roleTable.unionId then
    NetManager.Send(UnionMessage.ReqJoinUnion, {
      id = roleTable.unionId,
      join = true
    })
    UIManager.Hide(UIID.Team_RoleInteractUI)
  end
end

function ShowBtnItemUtility.RemoveFriend()
  if roleTable and roleTable.roleId then
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "Sau khi x\195\179a b\225\186\161n b\195\168, \196\145\225\187\153 th\195\162n m\225\186\173t s\225\186\189 tr\225\187\159 v\225\187\129 0, \nX\195\161c nh\225\186\173n x\195\179a",
      cancelText = "H\225\187\167y",
      okText = "X\195\161c nh\225\186\173n",
      cancel = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      ok = function()
        EventManager.Dispatch(Event.Friend_ReqDeleteFriend, {
          id = roleTable.roleId,
          type = FriendTypeEnum.FRIEND
        })
      end
    })
  end
end

function ShowBtnItemUtility.MaskFriend()
  if roleTable and roleTable.roleId then
    local msg = {
      id = roleTable.roleId,
      type = FriendTypeEnum.BLACKLIST
    }
    EventManager.Dispatch(Event.Friend_ReqAddFriend, msg)
    UIManager.Hide(UIID.Team_RoleInteractUI)
  end
end

function ShowBtnItemUtility.SeleteRole()
  if roleTable then
    local role = RoleManager.GetRoleById(roleTable.roleId)
    role:OnTouch()
    UIManager.Hide(UIID.Team_RoleInteractUI)
  end
end

function ShowBtnItemUtility.ReportRole()
  UIManager.Show(UIID.Role_ReportUI, {
    name = roleTable.roleName,
    rid = roleTable.roleId
  })
end
