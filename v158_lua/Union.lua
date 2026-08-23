syntax = "proto3";
package UnionPackage;
option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "UnionProto";
import "Role.proto";

message ResUnionList {
  repeated UnionSimpleInfo info = 1;
}

message UnionSimpleInfo {
  int64 id = 1;
  string name = 2;
  int32 count = 3;
  int32 level = 4;
  bool apply = 5;//是否已申请
  int64 unionFight = 6;
  bool isEnemy = 7;
}


message ReqUid{
  int64 id = 1;
}

message ResUnionSimpleInfo {
  int64 id = 1;
  string name = 2;
  int32 count = 3;
  int32 level = 4;
  string announce = 5;//(招人公告)
  repeated int64 logo = 6;//战盟臂章像素
  string leaderName = 7;//盟主名字
  int64 unionFight = 8;
}

message ResMemberList {
  repeated MemberInfo info = 1;
}

message MemberInfo {
  int64 id = 1;
  string name = 2;
  int32 position = 3;
  int32 mapId = 4;
  repeated BadgeInfo badgeInfo = 5;//战盟臂章数据
  int32 career = 6;
  int32 level = 7;
  int32 fight = 8;
  int64 logoutTime = 9;
  int64 joinTime = 10;
  int32 pvpScore = 11;//pvp积分
  int32 pvpStage = 12;//pvp大段位
  int32 pvpStageLevel = 13;//pvp小段位
  int32 pvpCount = 14;
  bool offline = 15;//是否离线
}

//战盟臂章数据
message BadgeInfo {
  int32 id = 1; //对应union_badge表的id字段
  int32 type = 2; //臂章类型
  int32 level = 3; //臂章等级
  int32 maxId = 4; //臂章等级上限等级对应数据id（对应union_badge表的id字段）
}

message ResMemberDetailedInfo {
  RolePackage.RoleSimpleInfo info = 1;
  int32 position = 2;
  bool friend = 3;
  repeated BadgeInfo badgeInfo = 4;//战盟臂章数据
  int32 mapId = 5;
  int32 myPosition = 6;
}

message ReqRoleBadgeLevelUp {
  int32 type = 1; //臂章类型
}



message ReqCreateUnion{
  string name = 1;
  repeated int64 logo = 2;//战盟臂章像素
}

message ReqJoinUnion{
  int64 id = 1;
  bool join = 2;
}

message ReqApprovalApply{
  repeated int64 id = 1;
  bool join = 2;
}

message ResUnionBaseInfo{
  int64 id = 1;
  string name = 2;
  int32 count = 3;
  int32 level = 4;
  string announce = 5;//(战盟公告)
  int32 exp = 6;//经验
  int32 position = 7;
  repeated int64 logo = 8;//战盟臂章像素
  int32 money = 9;//资金
  repeated EventInfo event =10;
  string leaderName = 11;
  int64 joinTime = 12;
  int32 announceLeftTimes = 13;
  repeated string enemyUnions = 14;
  repeated int64 enemyUnionIds = 15;//敌对盟ID
  int32 changeNameTimes = 16;//战盟改名次数
}

message EventInfo{
	int32 time = 1;
	string msg = 2;
}

message ResBadgeInfo{
  repeated int64 logo = 1;//战盟臂章像素
  repeated BadgeInfo badgeInfo = 2;//战盟臂章数据
  int32 unionLevel = 3;
  int32 exp = 4;
  string name = 5;//军团名字
  int64 id = 6;
  repeated int32 reward = 7;//已领取奖励id，废弃字段
}

message ReqUnionInfoChange{
  int32 type = 1;//1:改名：2改logo 3改公告 4 改招募公告
  string desc = 2;
  repeated int64 logo = 3;
}
message ResUnionInfoChange{
  int32 type = 1;
  string desc = 2;
  int64 unionId = 3;//unionid
}

message ResUnionAdminInfo{
  repeated ApplyInfo info = 1;
  int32 limitLevel = 2;//等级限制
  string announce = 3;//(公告)
  string recruitAnnounce = 4;//(招人公告)
  int32 position = 5;
  bool autoJoin = 6;
  int32 limitFight = 7;//战力限制
}

message ApplyInfo{
  RolePackage.RoleSimpleInfo info = 1;
}

message ResMemberChange{
  int64 id = 1;//退出
  MemberInfo info = 2;//加入
}


message ReqAssignment{
  int64 id = 1;
  int32 position = 2;
}

message ReqModifyApplyCondition{
  int32 limitLevel = 1;
  bool autoJoin = 2;
  int32 limitFight = 3;
}

message ResModifyApplyCondition{
  int32 limitLevel = 1;
  bool autoJoin = 2;
  int32 limitFight = 3;
}


message ReqVoteImpeach{
  bool agree = 1;
}

message ResImpeachInfo{
  string name = 1;
  string leaderName = 2;//盟主名字
  string initiatorName = 3;//发起者名字
  int64 time = 4;
  int32 agree = 5;
  int32 disagree = 6;
  bool vote = 7;//已投票,废弃
  int32 type = 8;//反对0，赞同1，没投2
}

//int SUMMON_STATUS_PROTECTOR = 1; 召唤狼魂要塞带哦想守护者
message ReqUnionItemUse{
  int32 useType = 1;
  int32 itemId = 2;//道具Id
  int32 count = 3;
  repeated string clientParams = 4;//额外参数
}

message ResUnionItemUse{
  int64 itemId = 1;//道具Id
  int32 count = 2;
  int32 useType = 3;
}


message ReqUnionDonate{
  int32 type = 1;
}

message ReqGetBadgeReward{
  int32 id = 1;
}

message ReqInviteJoinUnion{
	int64 beInviteId = 1;//被邀请者
}

message ResInviteJoinUnion{
	int64 inviteId = 1;//邀请者
	string inviteName = 2;
	int64 unionId = 3;//战盟id
	string unionName = 4;
}

message ReqOperateInviteJoinUnion{
	int64 inviteId = 1;
	int64 unionId = 2;
	bool agree = 3;
}

message ResJoinUnion{
  int64 id = 1;
}

message ReqInitiateImpeach{
  int64 rid = 1;
}

message ReqInitiateReplaceUnionLeader{
  int64 rid = 1;//发起者
}

message ReqGetUnionEventInfo{
	int32 type = 1;//1.弹劾 2.竞选 3.取代
}

message ResReplaceUnionLeaderInfo{
	int64 rid = 1;//发起者
	string name = 2;//战盟名字
	int64 time = 3;//发起截止时间
	repeated RolePackage.RoleSimpleInfo info = 4;//参与者
}

message ReqInitiateSelectUnionLeader{
	int64 rid = 1;//发起者
}

message ReqVoteSelectUnionLeader{
	int64 rid = 1;//发起者
	int32 count = 2;//票数
	int64 selectRid = 3;//投给谁
}

message ResSelectUnionLeaderInfo{
	int64 rid = 1;//发起者
	string name = 2;//战盟名字
	int64 time = 3;//发起截止时间
	map<int64, int32> roleInfo = 4;//投票结果
	repeated RolePackage.RoleSimpleInfo info = 5;
}

message ReqUnionLogoInfo{
	int64 unionId = 1;
	int32 count = 2;
}

message ResUnionLogoInfo{
	repeated UnionLogo logo = 1;
}

message UnionLogo{
	int64 unionId = 1;
	repeated int64 logo = 2;
}

message ReqAnnounceEnemy{
	int64 unionId = 1;
}

message ResUnionRedPacket {
	repeated UnionRedPacket redPacketList = 1;//红包列表
}
//战盟红包
message UnionRedPacket {
	int64 id = 1;//红包id
	string masterName = 2;//发红包人的名字
	int32 maxCount = 3;//红包金额
	int32 lastCount = 4;//红包当前剩余金额
	repeated RedPacketAward info = 5;//领取记录
	int32 sendTime = 6;//发送时间
}

message RedPacketAward {
	int64 rid = 1;//领取角色id
	string roleName = 2;//领取角色名字
	int32 rewardCount = 3;//开红包获得的金额
	int32 state = 4;//感谢状态：0未感谢1已感谢
	int32 getTime = 5;//领取时间
}

message ReqAwardRedPacket {
	int64 id = 1;//红包id
}

message ReqSendRedPacket {
	int32 maxCount = 1;//红包金额
	int32 maxNum = 2;//可领取人数
}