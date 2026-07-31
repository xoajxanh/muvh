syntax = "proto3";
package matchTeamPackage;


option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "MatchTeamProto";


//创建队伍
message CreateMatchTeam{
	string name = 1;//战队名称
}

//创建队伍 通知中心服
message CreateMatchTeamToCenter{
	string name = 1;//战队名称
	int32 hostId = 2;
	int64 creatorId = 3;
	string createName = 4;
	int32 level = 5;
	int32 career = 6;
}

//战队改变通知游戏服
message SendUpTeamToServer{
	MatchTeamInfo teamInfo = 1;
	int64 rid = 2;//被踢的rid
	int32 type = 3;//1玩家加入 2玩家退出 3解散 4//踢人 5建队
	bool coverTeam = 5;
	repeated allTeamMember teamMembers = 6;
}

message allTeamMember{
	int64 teamId = 1;
	repeated int64 memberIds = 2;
}

//队伍信息
message MatchTeamInfo{
  int64 teamId = 1;
  string teamName = 2;
  int64 leaderId = 3;//队长rid
  repeated MatchTeamMember members = 4;//正式成员信息
  int32 status = 6;//0未报名 1已报名
  repeated int64 battleIds = 7; //战斗成员信息
  bool autoAgreeJoin = 8;//自动同意申请
  int32 levelLimit = 9;//等级要求
  bool otherInvite = 10;//开放队友邀请
  int32 teamStage = 11;//队伍所处阶段,被淘汰的队伍记录的是止步的阶段,没淘汰的队伍记录的是当前阶段
  bool isDraw = 12;//淘汰赛抽签弹窗 true弹 false不弹
  int64 secondLeader = 13;//副队长
  int64 battleId = 14;//战斗id
  PromoteInfo promoteInfo = 15;//晋级赛数据
  int64 enemyTeamId = 16;//敌对战队id
  bool isOut = 17;//战队是否淘汰 true淘汰 false未淘汰
  int32 promoteOutRank = 18;//晋级赛被淘汰时位次
  int32 knockoutRound = 19;//淘汰赛第几轮  淘汰与未淘汰共用
  int32 matchStartTime = 20;//当天比赛开始时间
  int32 matchEndTime = 21;//当天比赛结束时间
  int32 knockoutStartTime = 22;//淘汰赛及之后战斗开始时间
  bool bye = 23;//是否轮空 true轮空 false未轮空
}

//晋级赛数据
message PromoteInfo{
	int32 score = 1;
	int32 rank = 2;
	int32 promoteCount = 3;//晋级队伍数量
	int32 validBattleCount = 4;//剩余战斗场次
	int32 winCount = 5;//晋级赛胜利场次
}

message MatchTeamMember{
  int64 rid = 1;
  bool online = 2;//是否在线
  int32 level = 3;
  int32 career = 4;
  bool prepare = 5;//是否准备
  string name = 6;
  int32 joinTime = 7;
}


//邀请入队
message ReqInviteMember{
  int64 rid = 1;
  int64 teamId = 3;
}

//邀请入队通知中心服
message ReqInviteMemberToCenter{
  int64 leaderId = 1;
  int32 hostId = 2;
  int64 teamId = 3;//战队id
  int64 inviteeId = 5;//受邀者
}

//同意邀请
message AgreeInvite{
  int64 teamId = 1;
}

//同意邀请通知中心服
message AgreeInviteToCenter{
  int64 teamId = 1;
  int64 rid = 2;
  int32 hostId = 3;
  string name = 5;
  int32 level = 6;
  int32 career = 7;
}

//不同意邀请
message ReqDisAgreeInvite{
  int64 teamId = 1;
}

//踢出队伍
message KickTeam{
  int64 rid = 1;
  int64 teamId = 2;
}

//踢出队伍通知中心服
message KickTeamToCenter{
    int64 teamId = 1;
	int64 leaderId = 2;//队长
	int32 hostId = 3;
	int64 rid = 4;//被踢者
}

//被踢出响应
message ResKickMatchTeam{
  int64 teamId = 1;//战队id
}

//退出队伍
message ReqExitMatchTeam{
	int64 teamId = 1;
}

//退出队伍通知中心服
message ReqExitMatchTeamToCenter{
	int64 rid = 1;
	int32 hostId = 2;
	int64 teamId = 3;
}

//退出队伍响应
message ResExitMatchTeam{
  int64 teamId = 1;//战队id
}

//获取战队信息
message ReqGetTeamInfo{
  int64 teamId = 1;//战队id
  int32 msgType = 2;
}

//获取战队信息通知中心服
message ReqGetTeamInfoToCenter{
  int64 teamId = 1;//战队id
  int64 rid = 2;
  int32 hostId = 3;
  int32 msgType = 4;
}

//解散队伍
message ReqDissolveMatchTeam{
	int64 teamId = 1;
}

//解散响应
message ResDissolveMatchTeam{
  int64 teamId = 1;
}

//解散队伍通知中心服
message ReqDissolveMatchTeamToCenter{
	int64 teamId = 1;
	int64 rid = 2;
	int32 hostId = 3;
}

//战队报名/取消报名
message ReqSignUpMatchTeam{
	int64 teamId = 1;
	bool up = 2;//true报名 false取消报名
}

//战队报名通知中心服
message ReqSignUpMatchTeamToCenter{
	int64 teamId = 1;
	int64 rid = 2;
	int32 hostId = 3;
	bool up = 4;//true报名 false取消报名
}

message ReqPrepareMatch{
	int64 teamId = 1;
	bool prepare = 2;//true准备 false取消准备
}

message ReqPrepareMatchToCenter{
	int32 hostId = 1;
	int64 rid = 2;
	int64 teamId = 3;
	bool prepare = 4;
}

//晋级赛排名
message ReqStairsRankToCenter{
	int32 hostId = 1;
	int64 reqRid = 2;
}

message ResStairsRank{
	repeated StairsRankDetail rankDetail = 1;
	int64 reqRid = 2;
	StairsRankDetail myRank = 3;
}

message StairsRankDetail{
	int32 rank = 1;
	string teamName = 2;
	int32 serverId = 3;
	int32 winCount = 4;//胜利次数
	string leaderName = 5;//队长名称
	int32 score = 6;//积分
}

message ResStairsCheckToCenter{
	repeated allTeamMember teamMembers = 1;
	int32 hostId = 2;
}


message ReqTeamDuelTotalToCenter{
	int64 rid = 1;
	int32 hostId = 2;
}

message ResTeamDuelTotal{
	repeated TeamDuelStage teamDuelStage = 1;//各阶段所有对决信息
	int64 reqRid = 2; //服务器专用字段
	int32 releaseTime = 3;//系统分配后的公布时间
}

message TeamDuelStage{
	int32 stage = 1;
	repeated TeamDuelInfo info = 2;//每组对决信息
}

message TeamDuelInfo{
	int32 duelId = 1;//对决编号(与位置编号一致？)
	int64 redTeamId = 2;
	string redTeamName = 3;
	int64 blueTeamId = 4;
	string blueTeamName = 5;
	int64 winTeamId = 6;
	int32 position = 7;//位置编号
}

message ReqTeamDuelDetailById{
	int32 duelId = 1;//对决编号
}

message ReqTeamDuelDetailByIdToCenter{
	int32 duelId = 1;
	int64 rid = 2;
	int32 hostId = 3;
}

message ResTeamDuelDetailById{
	repeated MemberSimpleInfo redMembers = 1;
	repeated MemberSimpleInfo blueMembers = 2;
	int32 redWinCount = 3;
	int32 blueWinCount = 4;
	int64 reqRid = 5;//服务器专用字段
	int64 redTeamId = 6;
	int64 blueTeamId = 7;
	int64 winTeamId = 8;
	int32 stage = 9;//阶段
	string redTeamName = 10;
	string blueTeamName = 11;
}

//敌对队伍信息
message ResEnemyTeamInfo{
	int64 teamId = 1;
	string enemyTeamName = 2;//敌对战队名称
	int64 reqRid = 3;
	repeated MemberSimpleInfo infos = 4;
	int32 msgType = 5;
}

message MemberSimpleInfo{
	int32 level = 1;
	int32 career = 2;
	string name = 3;
	int64 rid = 4;
	bool isLeader = 5;//是否为队长 true队长 false非队长
}

message ResEnemyTeamInfoToRole{
	int64 teamId = 1;
	string enemyTeamName = 2;//敌对战队名称
	repeated MemberSimpleInfo infos = 3;
	int32 msgType = 4;
}

//刷新队伍里玩家数据
message ReqUpdateTeamInfo{
	repeated ReqUpdateTeam infos = 1;
}

message ReqUpdateTeam{
	int64 teamId = 1;
	repeated int64 rids = 2;
}
//返回刷新队伍里玩家数据
message ResUpdateTeamInfo{
	int32 hostId = 1;
	repeated ResUpdateTeam infos = 2;
}

message ResUpdateTeam{
	int64 teamId = 1;
	repeated MemberSimpleInfo infos = 2;
}

message ReqQueryHasTeam{
	repeated int64 rids = 1;
}


message ReqQueryHasTeamToCenter{
	int32 hostId = 1;
	int64 rid = 2;
	repeated int64 rids = 3;
}

message ResQueryHasTeamToServer{
	repeated int64 rids = 1;
	int64 rid = 2;
}

message ResQueryHasTeam{
	repeated int64 rids = 1;
}

message ReqSetTeamBattler{
	repeated int64 rids = 1;
}

message ReqSetTeamBattlerToCenter{
	repeated int64 rids = 1;
	int64 rid = 3;
	repeated int64 offlineRids = 4;//服务器自用字段 队内不在线玩家
}

message ReqCenter{
	int32 hostId = 1;
	int64 rid = 2;
}

message ResAllTeamToServer{
	int64 rid = 1;
	repeated TeamOverview infos = 2;
}

message TeamOverview{
	string teamName = 1;
	string leadName = 2;
	int32 totalLevel = 3;
	int32 memberCount = 4;
	int32 needLevel = 5;
	bool apply = 6;//已申请加入该队伍
	int64 teamId = 7;
}

message ResAllTeam{
	repeated TeamOverview infos = 1;
}

message ReqChangeTeamSetting{
	bool autoAgreeJoin = 1;//自动同意申请
	int32 levelLimit = 2;//等级要求
	bool otherInvite = 3;//开放队友邀请
}

message ReqTeamSettingToCenter{
	ReqCenter reqCenter = 1;
	ReqChangeTeamSetting info = 2;
}

message ReqJoinTeam{
	int64 teamId = 1;
}

message ReqJoinTeamToCenter{
	ReqCenter reqCenter = 1;
	int64 teamId = 2;
	MemberSimpleInfo info = 3;
}

message ReqApproval{
	repeated int64 targetRids = 1;
	bool agree = 2;//同意入队
}

message ReqApprovalToCenter{
	ReqCenter reqCenter = 1;
	repeated int64 targetRids = 2;
	bool agree = 3;
}

message ResInviteInfoToServer{
	int64 rid = 1;
	ResMatchInviteInfo info = 2;
	
}

message ResMatchInviteInfo{
	MemberSimpleInfo inviter = 1;
	string teamName = 2;
	int32 totalLevel = 3;
	int32 memberCount = 4;
	int64 teamId = 5;
}

message ResTeamApplyInfoToServer{
	int64 rid = 1;
	repeated MemberSimpleInfo applyInfos = 2;
}

message ResTeamApplyInfo{
	repeated MemberSimpleInfo applyInfos = 1;
}

message ResTeamKillInfoToServer{
	int64 rid = 1;
	repeated MemberKillInfo infos = 2;
}

message ResTeamKillInfo{
	repeated MemberKillInfo infos = 1;
}

message MemberKillInfo{
	int64 rid = 1;
	int32 killCount = 2;//击杀数
	int32 dieCount = 3;//死亡数
	int32 battleCount = 4;//参与场次
	int32 winCount = 5;//胜利场次
	int32 winRate = 6;//胜利概率
}

message ReqSetSecondLeader{
	int64 secondLeader = 1;
}

message ReqSetSecondLeaderToCenter{
	int64 rid = 1;
	int64 secondLeader = 2;
}

// 赛前更新未在线队员出战状态
message upBattleMember{
	int64 rid = 1;
	repeated int64 oldBattleRid = 2;
}

message ReqGmToCenter{
	string command = 1;
	repeated string params = 2;
	ReqCenter reqCenter = 3;
}

message ResGmToServer{
	string tip = 1;
	int64 rid = 2;
}