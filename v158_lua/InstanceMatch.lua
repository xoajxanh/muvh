syntax = "proto3";
package InstanceMatchPackage;

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "InstanceMatchProto";


message ReqCreateTeam{
  int32 instanceId = 1;
}

message ResTeamInfo{
  int64 id = 1;
  int64 leader = 2;
  repeated Member members = 3;
  int64 endTime = 4;
  bool match = 5;//全部同意5秒等待？
  int32 instanceId = 6;//副本id
}

message Member{
  int64 rid = 1;
  string name = 2;
  int32 level = 3;
  int32 career = 4;
  int32 reason = 5;//未选择=0;同意 = 1;信息错误 = 2;条件不满足 = 3;道具不足 = 4;次数不足 = 5;拒绝 = 6;
}

message ReqInviteFriend{
  int64 id = 1;//好友id
}

message ResInviteFriend{
  int32 instanceId = 1;
  int64 teamId = 2;
  string name = 3;
}

message ReqInviteOperation{
  int64 teamId = 1;
  bool friend = 2;
  bool agree = 3;
}

message ResMatchInfo{
  int64 id = 1;
  repeated Member members = 2;
  int32 cd = 3;//邀请cd
  int32 state = 4;//1:匹配中，2确认中
}

