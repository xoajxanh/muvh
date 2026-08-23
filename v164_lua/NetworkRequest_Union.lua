function networkRequest.ReqUnionList()
  NetManager.Send(UnionMessage.ReqUnionList)
end

function networkRequest.ReqUnionSimpleInfo(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(UnionMessage.ReqUnionSimpleInfo, reqTable)
end

function networkRequest.ReqMemberList()
  NetManager.Send(UnionMessage.ReqMemberList)
end

function networkRequest.ReqMemberDetailedInfo(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(UnionMessage.ReqMemberDetailedInfo, reqTable)
end

function networkRequest.ReqUnionBaseInfo()
  NetManager.Send(UnionMessage.ReqUnionBaseInfo)
end

function networkRequest.ReqCreateUnion(name, logo)
  local reqTable = {}
  if name ~= nil then
    reqTable.name = name
  end
  if logo ~= nil then
    reqTable.logo = logo
  else
    reqTable.logo = {}
  end
  NetManager.Send(UnionMessage.ReqCreateUnion, reqTable)
end

function networkRequest.ReqJoinUnion(id, join)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if join ~= nil then
    reqTable.join = join
  end
  NetManager.Send(UnionMessage.ReqJoinUnion, reqTable)
end

function networkRequest.ReqQuitUnion()
  NetManager.Send(UnionMessage.ReqQuitUnion)
end

function networkRequest.ReqApprovalApply(id, join)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  else
    reqTable.id = {}
  end
  if join ~= nil then
    reqTable.join = join
  end
  NetManager.Send(UnionMessage.ReqApprovalApply, reqTable)
end

function networkRequest.ReqKickMember(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(UnionMessage.ReqKickMember, reqTable)
end

function networkRequest.ReqDismissUnion()
  NetManager.Send(UnionMessage.ReqDismissUnion)
end

function networkRequest.ReqBadgeInfo()
  NetManager.Send(UnionMessage.ReqBadgeInfo)
end

function networkRequest.ReqUnionInfoChange(type, desc, logo)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  if desc ~= nil then
    reqTable.desc = desc
  end
  if logo ~= nil then
    reqTable.logo = logo
  else
    reqTable.logo = {}
  end
  NetManager.Send(UnionMessage.ReqUnionInfoChange, reqTable)
end

function networkRequest.ReqGetBadgeReward(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(UnionMessage.ReqGetBadgeReward, reqTable)
end

function networkRequest.ReqRoleBadgeLevelUp(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(UnionMessage.ReqRoleBadgeLevelUp, reqTable)
end

function networkRequest.ReqUnionAdminInfo()
  NetManager.Send(UnionMessage.ReqUnionAdminInfo)
end

function networkRequest.ReqAssignment(id, position)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if position ~= nil then
    reqTable.position = position
  end
  NetManager.Send(UnionMessage.ReqAssignment, reqTable)
end

function networkRequest.ReqModifyApplyCondition(limitLevel, autoJoin, limitFight)
  local reqTable = {}
  if limitLevel ~= nil then
    reqTable.limitLevel = limitLevel
  end
  if autoJoin ~= nil then
    reqTable.autoJoin = autoJoin
  end
  if limitFight ~= nil then
    reqTable.limitFight = limitFight
  end
  NetManager.Send(UnionMessage.ReqModifyApplyCondition, reqTable)
end

function networkRequest.ReqInitiateImpeach(rid)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(UnionMessage.ReqInitiateImpeach, reqTable)
end

function networkRequest.ReqVoteImpeach(agree)
  local reqTable = {}
  if agree ~= nil then
    reqTable.agree = agree
  end
  NetManager.Send(UnionMessage.ReqVoteImpeach, reqTable)
end

function networkRequest.ReqGetUnionEventInfo(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(UnionMessage.ReqGetUnionEventInfo, reqTable)
end

function networkRequest.ReqUnionItemUse(useType, itemId, count, clientParams)
  local reqTable = {}
  if useType ~= nil then
    reqTable.useType = useType
  end
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  if count ~= nil then
    reqTable.count = count
  end
  if clientParams ~= nil then
    reqTable.clientParams = clientParams
  else
    reqTable.clientParams = {}
  end
  NetManager.Send(UnionMessage.ReqUnionItemUse, reqTable)
end

function networkRequest.ReqUnionDonate(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(UnionMessage.ReqUnionDonate, reqTable)
end

function networkRequest.ReqInviteJoinUnion(beInviteId)
  local reqTable = {}
  if beInviteId ~= nil then
    reqTable.beInviteId = beInviteId
  end
  NetManager.Send(UnionMessage.ReqInviteJoinUnion, reqTable)
end

function networkRequest.ReqOperateInviteJoinUnion(inviteId, unionId, agree)
  local reqTable = {}
  if inviteId ~= nil then
    reqTable.inviteId = inviteId
  end
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  if agree ~= nil then
    reqTable.agree = agree
  end
  NetManager.Send(UnionMessage.ReqOperateInviteJoinUnion, reqTable)
end

function networkRequest.ReqInitiateReplaceUnionLeader(rid)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(UnionMessage.ReqInitiateReplaceUnionLeader, reqTable)
end

function networkRequest.ReqInitiateSelectUnionLeader(rid)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(UnionMessage.ReqInitiateSelectUnionLeader, reqTable)
end

function networkRequest.ReqVoteSelectUnionLeader(rid, count, selectRid)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if count ~= nil then
    reqTable.count = count
  end
  if selectRid ~= nil then
    reqTable.selectRid = selectRid
  end
  NetManager.Send(UnionMessage.ReqVoteSelectUnionLeader, reqTable)
end

function networkRequest.ReqUnionLogoInfo(unionId, count)
  local reqTable = {}
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  if count ~= nil then
    reqTable.count = count
  end
  NetManager.Send(UnionMessage.ReqUnionLogoInfo, reqTable)
end

function networkRequest.ReqAnnounceEnemy(unionId)
  local reqTable = {}
  if unionId ~= nil then
    reqTable.unionId = unionId
  end
  NetManager.Send(UnionMessage.ReqAnnounceEnemy, reqTable)
end

function networkRequest.ReqUnionRedPacket()
  NetManager.Send(UnionMessage.ReqUnionRedPacket)
end

function networkRequest.ReqAwardRedPacket(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(UnionMessage.ReqAwardRedPacket, reqTable)
end

function networkRequest.ReqSendRedPacket(maxCount, maxNum)
  local reqTable = {}
  if maxCount ~= nil then
    reqTable.maxCount = maxCount
  end
  if maxNum ~= nil then
    reqTable.maxNum = maxNum
  end
  NetManager.Send(UnionMessage.ReqSendRedPacket, reqTable)
end

function networkRequest.ReqThank(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(UnionMessage.ReqThank, reqTable)
end

function networkRequest.ReqUnionSeekHelp()
  NetManager.Send(UnionMessage.ReqUnionSeekHelp)
end
