syntax = "proto3";
package TeamPackage;

import "Bag.proto";
import "Role.proto";

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "TeamProto";


message TeamInfo{
  int64 teamId = 1;
  int64 leaderId = 2;
  int32 enterMode = 3;
  repeated TeamMember members = 4;
  repeated TeamMember asks = 5;
  repeated TeamMember invites = 6;
  int32 reason = 7;
  int32 enterLevel = 8;
  repeated TeamMember inviteUnions = 9;
  int32 activity = 10; //0 无 1血色城堡 2 恶魔广场
  int32 minLevel = 11; 
  int32 maxLevel = 12;
}

message TeamMember{
  int64 rid = 1;
  string startName = 2;
  int32  startLevel = 3;
  int32  startCareer = 4;
  int64  time = 5;
  bool online = 6;
  repeated BagPackage.ItemInfo equips = 7;//装备
  RolePackage.RoleSimpleInfo info = 8;// 玩家基础信息
  int32 mapId = 9;
  int32 line = 10;
}

//创建队伍
message CreateTeam{
}

//请求入队
message AskEnter{
  int64 teamId = 1;
}

//同意入队
message AgreeEnter{
  repeated int64 asks = 1;
}

//不同意入队
message DisAgreeEnter{
  repeated int64 asks = 1;
}

//邀请入队
message ReqInviteEnter{
  repeated int64 invites = 1;
}

//邀请响应
message ResInviteEnter{
  int64 teamId = 1;
  string leaderName = 2;
}

//同意邀请
message AgreeInvite{
  int64 teamId = 1;
}

//同意邀请
message ReqDisAgreeInvite{
  int64 teamId = 1;
}

//同意邀请
message ResDisAgreeInvite{
  int64 teamId = 1;
}

//踢出队伍
message KickTeam{
  int64 kickId = 1;
}

//退出队伍
message ExitTeam{
}

//解散队伍
message ReqDissolveTeam{
}

message ResDissolveTeam{
  int64 teamId = 1;
}

message ResDissolveTeamToInvitor{
  int64 teamId = 1;
}

//转让队长
message ReqChangeLeader{
  int64 newLeaderId = 1;
}

//设置队伍模式
message ReqSetMode{
  int32 enterMode = 1;
}

//设置活动模式
message ReqSetActivityMode{
  int32 activityMode = 1;
}

//返回活动模式 等级限制
message ResTeamActivityLevel{
  int32 activity = 10; //0 无 1血色城堡 2 恶魔广场
  int32 minLevel = 11; 
  int32 maxLevel = 12;
}

//设置等级
message ReqSetLimit{
  int32 minLevel = 1;
  int32 maxLevel = 2;
}

message ReqGetTeamInfo{

}

message ReqRoundTeams{

}

message ResRoundTeams{
  repeated TeamInfo teams = 1;
}

message ResPlayerTeamIdUpdate{
  int64 playerId = 1;
  int64 teamId = 2;
  int32 reason = 3;
}
