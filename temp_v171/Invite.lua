syntax = "proto3";
package InvitePackage;

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "InviteProto";

message ResInvitationInfo{
	int32 type = 1;//邀请消息类型 0 全部 1 队伍 2战盟
	repeated ResTeamInvitationInfo teamInfo = 2;//队伍邀请信息
	repeated ResUnionInvitationInfo unionInfo = 3;//战盟邀请信息
}

message ResTeamInvitationInfo{
	int64 inviterId = 1;
	string inviterName = 2;
	int64 teamId = 3;
	int32 career = 4;
	int32 level = 5;
}

message ResUnionInvitationInfo{
	int64 inviterId = 1;
	string inviterName = 2;
	int64 unionId = 3;
	string unionName = 4;
	int32 career = 5;
	int32 level = 6;
}