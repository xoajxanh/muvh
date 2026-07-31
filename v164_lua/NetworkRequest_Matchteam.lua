function networkRequest.ReqCreateMatchTeam3V3(name)
  local reqTable = {}
  
  if name ~= nil then
    reqTable.name = name
  end
  NetManager.Send(MatchTeamMessage.ReqCreateMatchTeam3V3, reqTable)
end

function networkRequest.ReqCreateMatchTeamToCenter(name, hostId, creatorId, createName, level, career)
  local reqTable = {}
  if name ~= nil then
    reqTable.name = name
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if creatorId ~= nil then
    reqTable.creatorId = creatorId
  end
  if createName ~= nil then
    reqTable.createName = createName
  end
  if level ~= nil then
    reqTable.level = level
  end
  if career ~= nil then
    reqTable.career = career
  end
  NetManager.Send(MatchTeamMessage.ReqCreateMatchTeamToCenter, reqTable)
end

function networkRequest.ReqInviteMember(rid, teamId)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(MatchTeamMessage.ReqInviteMember, reqTable)
end

function networkRequest.ReqInviteMemberToCenter(leaderId, hostId, teamId, inviteeId)
  local reqTable = {}
  if leaderId ~= nil then
    reqTable.leaderId = leaderId
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if inviteeId ~= nil then
    reqTable.inviteeId = inviteeId
  end
  NetManager.Send(MatchTeamMessage.ReqInviteMemberToCenter, reqTable)
end

function networkRequest.ReqAgreeMatchInvite(teamId)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(MatchTeamMessage.ReqAgreeMatchInvite, reqTable)
end

function networkRequest.ReqAgreeInviteToCenter(teamId, rid, hostId, name, level, career)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if name ~= nil then
    reqTable.name = name
  end
  if level ~= nil then
    reqTable.level = level
  end
  if career ~= nil then
    reqTable.career = career
  end
  NetManager.Send(MatchTeamMessage.ReqAgreeInviteToCenter, reqTable)
end

function networkRequest.ReqDisAgreeMatchInvite(teamId)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(MatchTeamMessage.ReqDisAgreeMatchInvite, reqTable)
end

function networkRequest.ReqKickMatchTeam(rid, teamId)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(MatchTeamMessage.ReqKickMatchTeam, reqTable)
end

function networkRequest.ReqKickTeamToCenter(teamId, leaderId, hostId, rid)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if leaderId ~= nil then
    reqTable.leaderId = leaderId
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(MatchTeamMessage.ReqKickTeamToCenter, reqTable)
end

function networkRequest.ReqExitMatchTeam(teamId)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(MatchTeamMessage.ReqExitMatchTeam, reqTable)
end

function networkRequest.ReqExitMatchTeamToCenter(rid, hostId, teamId)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(MatchTeamMessage.ReqExitMatchTeamToCenter, reqTable)
end

function networkRequest.ReqDissolveMatchTeam(teamId)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(MatchTeamMessage.ReqDissolveMatchTeam, reqTable)
end

function networkRequest.ReqDissolveMatchTeamToCenter(teamId, rid, hostId)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  NetManager.Send(MatchTeamMessage.ReqDissolveMatchTeamToCenter, reqTable)
end

function networkRequest.ReqGetMatchTeamInfo(teamId, msgType)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if msgType ~= nil then
    reqTable.msgType = msgType
  end
  NetManager.Send(MatchTeamMessage.ReqGetMatchTeamInfo, reqTable)
end

function networkRequest.ReqGetTeamInfoToCenter(teamId, rid, hostId, msgType)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if msgType ~= nil then
    reqTable.msgType = msgType
  end
  NetManager.Send(MatchTeamMessage.ReqGetTeamInfoToCenter, reqTable)
end

function networkRequest.ResSendUpTeamToServer(teamInfo, rid, type, coverTeam, teamMembers)
  local reqTable = {}
  if teamInfo ~= nil then
    reqTable.teamInfo = teamInfo
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if type ~= nil then
    reqTable.type = type
  end
  if coverTeam ~= nil then
    reqTable.coverTeam = coverTeam
  end
  if teamMembers ~= nil then
    reqTable.teamMembers = teamMembers
  else
    reqTable.teamMembers = {}
  end
  NetManager.Send(MatchTeamMessage.ResSendUpTeamToServer, reqTable)
end

function networkRequest.ReqSignUpMatchTeam(teamId, up)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if up ~= nil then
    reqTable.up = up
  end
  NetManager.Send(MatchTeamMessage.ReqSignUpMatchTeam, reqTable)
end

function networkRequest.ReqSignUpMatchTeamToCenter(teamId, rid, hostId, up)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if up ~= nil then
    reqTable.up = up
  end
  NetManager.Send(MatchTeamMessage.ReqSignUpMatchTeamToCenter, reqTable)
end

function networkRequest.ReqPrepareMatch(teamId, prepare)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if prepare ~= nil then
    reqTable.prepare = prepare
  end
  NetManager.Send(MatchTeamMessage.ReqPrepareMatch, reqTable)
end

function networkRequest.ReqPrepareMatchToCenter(hostId, rid, teamId, prepare)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if prepare ~= nil then
    reqTable.prepare = prepare
  end
  NetManager.Send(MatchTeamMessage.ReqPrepareMatchToCenter, reqTable)
end

function networkRequest.ReqStairsRank()
  NetManager.Send(MatchTeamMessage.ReqStairsRank)
end

function networkRequest.ReqStairsRankToCenter(hostId, reqRid)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if reqRid ~= nil then
    reqTable.reqRid = reqRid
  end
  NetManager.Send(MatchTeamMessage.ReqStairsRankToCenter, reqTable)
end

function networkRequest.ResStairsRankToServer(rankDetail, reqRid, myRank)
  local reqTable = {}
  if rankDetail ~= nil then
    reqTable.rankDetail = rankDetail
  else
    reqTable.rankDetail = {}
  end
  if reqRid ~= nil then
    reqTable.reqRid = reqRid
  end
  if myRank ~= nil then
    reqTable.myRank = myRank
  end
  NetManager.Send(MatchTeamMessage.ResStairsRankToServer, reqTable)
end

function networkRequest.ReqStairsCheckToServer()
  NetManager.Send(MatchTeamMessage.ReqStairsCheckToServer)
end

function networkRequest.ResStairsCheckToCenter(teamMembers, hostId)
  local reqTable = {}
  if teamMembers ~= nil then
    reqTable.teamMembers = teamMembers
  else
    reqTable.teamMembers = {}
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  NetManager.Send(MatchTeamMessage.ResStairsCheckToCenter, reqTable)
end

function networkRequest.ReqTeamDuelTotal()
  NetManager.Send(MatchTeamMessage.ReqTeamDuelTotal)
end

function networkRequest.ReqTeamDuelTotalToCenter(rid, hostId)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  NetManager.Send(MatchTeamMessage.ReqTeamDuelTotalToCenter, reqTable)
end

function networkRequest.ResTeamDuelTotalToServer(teamDuelStage, reqRid, releaseTime)
  local reqTable = {}
  if teamDuelStage ~= nil then
    reqTable.teamDuelStage = teamDuelStage
  else
    reqTable.teamDuelStage = {}
  end
  if reqRid ~= nil then
    reqTable.reqRid = reqRid
  end
  if releaseTime ~= nil then
    reqTable.releaseTime = releaseTime
  end
  NetManager.Send(MatchTeamMessage.ResTeamDuelTotalToServer, reqTable)
end

function networkRequest.ReqTeamDuelDetailById(duelId)
  local reqTable = {}
  if duelId ~= nil then
    reqTable.duelId = duelId
  end
  NetManager.Send(MatchTeamMessage.ReqTeamDuelDetailById, reqTable)
end

function networkRequest.ReqTeamDuelDetailByIdToCenter(duelId, rid, hostId)
  local reqTable = {}
  if duelId ~= nil then
    reqTable.duelId = duelId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  NetManager.Send(MatchTeamMessage.ReqTeamDuelDetailByIdToCenter, reqTable)
end

function networkRequest.ResTeamDuelDetailByIdToServer(redMembers, blueMembers, redWinCount, blueWinCount, reqRid, redTeamId, blueTeamId, winTeamId, stage, redTeamName, blueTeamName)
  local reqTable = {}
  if redMembers ~= nil then
    reqTable.redMembers = redMembers
  else
    reqTable.redMembers = {}
  end
  if blueMembers ~= nil then
    reqTable.blueMembers = blueMembers
  else
    reqTable.blueMembers = {}
  end
  if redWinCount ~= nil then
    reqTable.redWinCount = redWinCount
  end
  if blueWinCount ~= nil then
    reqTable.blueWinCount = blueWinCount
  end
  if reqRid ~= nil then
    reqTable.reqRid = reqRid
  end
  if redTeamId ~= nil then
    reqTable.redTeamId = redTeamId
  end
  if blueTeamId ~= nil then
    reqTable.blueTeamId = blueTeamId
  end
  if winTeamId ~= nil then
    reqTable.winTeamId = winTeamId
  end
  if stage ~= nil then
    reqTable.stage = stage
  end
  if redTeamName ~= nil then
    reqTable.redTeamName = redTeamName
  end
  if blueTeamName ~= nil then
    reqTable.blueTeamName = blueTeamName
  end
  NetManager.Send(MatchTeamMessage.ResTeamDuelDetailByIdToServer, reqTable)
end

function networkRequest.ResCompetitionPromptToServer()
  NetManager.Send(MatchTeamMessage.ResCompetitionPromptToServer)
end

function networkRequest.ResEnemyTeamInfo(teamId, enemyTeamName, reqRid, infos, msgType)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if enemyTeamName ~= nil then
    reqTable.enemyTeamName = enemyTeamName
  end
  if reqRid ~= nil then
    reqTable.reqRid = reqRid
  end
  if infos ~= nil then
    reqTable.infos = infos
  else
    reqTable.infos = {}
  end
  if msgType ~= nil then
    reqTable.msgType = msgType
  end
  NetManager.Send(MatchTeamMessage.ResEnemyTeamInfo, reqTable)
end

function networkRequest.ReqUpdateTeamInfo(infos)
  local reqTable = {}
  if infos ~= nil then
    reqTable.infos = infos
  else
    reqTable.infos = {}
  end
  NetManager.Send(MatchTeamMessage.ReqUpdateTeamInfo, reqTable)
end

function networkRequest.ResUpdateTeamInfo(hostId, infos)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if infos ~= nil then
    reqTable.infos = infos
  else
    reqTable.infos = {}
  end
  NetManager.Send(MatchTeamMessage.ResUpdateTeamInfo, reqTable)
end

function networkRequest.ReqQueryHasTeam(rids)
  local reqTable = {}
  if rids ~= nil then
    reqTable.rids = rids
  else
    reqTable.rids = {}
  end
  NetManager.Send(MatchTeamMessage.ReqQueryHasTeam, reqTable)
end

function networkRequest.ReqQueryHasTeamToCenter(hostId, rid, rids)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if rids ~= nil then
    reqTable.rids = rids
  else
    reqTable.rids = {}
  end
  NetManager.Send(MatchTeamMessage.ReqQueryHasTeamToCenter, reqTable)
end

function networkRequest.ResQueryHasTeamToServer(rids, rid)
  local reqTable = {}
  if rids ~= nil then
    reqTable.rids = rids
  else
    reqTable.rids = {}
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(MatchTeamMessage.ResQueryHasTeamToServer, reqTable)
end

function networkRequest.ReqSetTeamBattler(rids)
  local reqTable = {}
  if rids ~= nil then
    reqTable.rids = rids
  else
    reqTable.rids = {}
  end
  NetManager.Send(MatchTeamMessage.ReqSetTeamBattler, reqTable)
end

function networkRequest.ReqSetTeamBattlerToCenter(rids, rid, offlineRids)
  local reqTable = {}
  if rids ~= nil then
    reqTable.rids = rids
  else
    reqTable.rids = {}
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  if offlineRids ~= nil then
    reqTable.offlineRids = offlineRids
  else
    reqTable.offlineRids = {}
  end
  NetManager.Send(MatchTeamMessage.ReqSetTeamBattlerToCenter, reqTable)
end

function networkRequest.ReqAllTeam()
  NetManager.Send(MatchTeamMessage.ReqAllTeam)
end

function networkRequest.ReqAllTeamToCenter(hostId, rid)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(MatchTeamMessage.ReqAllTeamToCenter, reqTable)
end

function networkRequest.ResAllTeamToServer(rid, infos)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if infos ~= nil then
    reqTable.infos = infos
  else
    reqTable.infos = {}
  end
  NetManager.Send(MatchTeamMessage.ResAllTeamToServer, reqTable)
end

function networkRequest.ReqChangeTeamSetting(autoAgreeJoin, levelLimit, otherInvite)
  local reqTable = {}
  if autoAgreeJoin ~= nil then
    reqTable.autoAgreeJoin = autoAgreeJoin
  end
  if levelLimit ~= nil then
    reqTable.levelLimit = levelLimit
  end
  if otherInvite ~= nil then
    reqTable.otherInvite = otherInvite
  end
  NetManager.Send(MatchTeamMessage.ReqChangeTeamSetting, reqTable)
end

function networkRequest.ReqTeamSettingToCenter(reqCenter, info)
  local reqTable = {}
  if reqCenter ~= nil then
    reqTable.reqCenter = reqCenter
  end
  if info ~= nil then
    reqTable.info = info
  end
  NetManager.Send(MatchTeamMessage.ReqTeamSettingToCenter, reqTable)
end

function networkRequest.ReqJoinTeam(teamId)
  local reqTable = {}
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(MatchTeamMessage.ReqJoinTeam, reqTable)
end

function networkRequest.ReqJoinTeamToCenter(reqCenter, teamId, info)
  local reqTable = {}
  if reqCenter ~= nil then
    reqTable.reqCenter = reqCenter
  end
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  if info ~= nil then
    reqTable.info = info
  end
  NetManager.Send(MatchTeamMessage.ReqJoinTeamToCenter, reqTable)
end

function networkRequest.ReqApproval(targetRids, agree)
  local reqTable = {}
  if targetRids ~= nil then
    reqTable.targetRids = targetRids
  else
    reqTable.targetRids = {}
  end
  if agree ~= nil then
    reqTable.agree = agree
  end
  NetManager.Send(MatchTeamMessage.ReqApproval, reqTable)
end

function networkRequest.ReqApprovalToCenter(reqCenter, targetRids, agree)
  local reqTable = {}
  if reqCenter ~= nil then
    reqTable.reqCenter = reqCenter
  end
  if targetRids ~= nil then
    reqTable.targetRids = targetRids
  else
    reqTable.targetRids = {}
  end
  if agree ~= nil then
    reqTable.agree = agree
  end
  NetManager.Send(MatchTeamMessage.ReqApprovalToCenter, reqTable)
end

function networkRequest.ResInviteInfoToServer(rid, info)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if info ~= nil then
    reqTable.info = info
  end
  NetManager.Send(MatchTeamMessage.ResInviteInfoToServer, reqTable)
end

function networkRequest.ResMatchInviteInfo(inviter, teamName, totalLevel, memberCount, teamId)
  local reqTable = {}
  if inviter ~= nil then
    reqTable.inviter = inviter
  end
  if teamName ~= nil then
    reqTable.teamName = teamName
  end
  if totalLevel ~= nil then
    reqTable.totalLevel = totalLevel
  end
  if memberCount ~= nil then
    reqTable.memberCount = memberCount
  end
  if teamId ~= nil then
    reqTable.teamId = teamId
  end
  NetManager.Send(MatchTeamMessage.ResMatchInviteInfo, reqTable)
end

function networkRequest.ReqTeamApplyInfo()
  NetManager.Send(MatchTeamMessage.ReqTeamApplyInfo)
end

function networkRequest.ReqTeamApplyInfoToCenter(hostId, rid)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(MatchTeamMessage.ReqTeamApplyInfoToCenter, reqTable)
end

function networkRequest.ResTeamApplyInfoToServer(rid, applyInfos)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if applyInfos ~= nil then
    reqTable.applyInfos = applyInfos
  else
    reqTable.applyInfos = {}
  end
  NetManager.Send(MatchTeamMessage.ResTeamApplyInfoToServer, reqTable)
end

function networkRequest.ReqTeamKillInfo()
  NetManager.Send(MatchTeamMessage.ReqTeamKillInfo)
end

function networkRequest.ReqTeamKillInfoToCenter(hostId, rid)
  local reqTable = {}
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(MatchTeamMessage.ReqTeamKillInfoToCenter, reqTable)
end

function networkRequest.ResTeamKillInfoToServer(rid, infos)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if infos ~= nil then
    reqTable.infos = infos
  else
    reqTable.infos = {}
  end
  NetManager.Send(MatchTeamMessage.ResTeamKillInfoToServer, reqTable)
end

function networkRequest.ReqSetSecondLeader(secondLeader)
  local reqTable = {}
  if secondLeader ~= nil then
    reqTable.secondLeader = secondLeader
  end
  NetManager.Send(MatchTeamMessage.ReqSetSecondLeader, reqTable)
end

function networkRequest.ReqSetSecondLeaderToCenter(rid, secondLeader)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if secondLeader ~= nil then
    reqTable.secondLeader = secondLeader
  end
  NetManager.Send(MatchTeamMessage.ReqSetSecondLeaderToCenter, reqTable)
end

function networkRequest.ReqUpBattleMember()
  NetManager.Send(MatchTeamMessage.ReqUpBattleMember)
end

function networkRequest.ReqUpBattleMemberCenter(rid, oldBattleRid)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if oldBattleRid ~= nil then
    reqTable.oldBattleRid = oldBattleRid
  else
    reqTable.oldBattleRid = {}
  end
  NetManager.Send(MatchTeamMessage.ReqUpBattleMemberCenter, reqTable)
end

function networkRequest.ReqGmToCenter(command, params, reqCenter)
  local reqTable = {}
  if command ~= nil then
    reqTable.command = command
  end
  if params ~= nil then
    reqTable.params = params
  else
    reqTable.params = {}
  end
  if reqCenter ~= nil then
    reqTable.reqCenter = reqCenter
  end
  NetManager.Send(MatchTeamMessage.ReqGmToCenter, reqTable)
end

function networkRequest.ResGmToServer(tip, rid)
  local reqTable = {}
  if tip ~= nil then
    reqTable.tip = tip
  end
  if rid ~= nil then
    reqTable.rid = rid
  end
  NetManager.Send(MatchTeamMessage.ResGmToServer, reqTable)
end
