syntax = "proto3";
package ChatPackage;
import "Role.proto";

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "ChatProto";

message ReqGM {
  string info = 1;
}


message ReqChat{
  int32 chatType = 1;
  string chatMsg = 2;
  int64 toRoleId = 3;//可选
}

message ResChat{
  int32 chatType = 1;
  string chatMsg = 2;
  RolePackage.RoleSimpleInfo from = 3;
  int64 time = 4;
  int64 toId = 5;
  int32 hostId = 6;
  RolePackage.RoleChatInfo roleChatInfo = 7;//玩家信息
}

message ResAnnounce{
  int32 id = 1;
  repeated string parameter = 2;
  repeated string secondParameter = 3;
}


//请求反馈问卷
message ReqSubmitFeedbackQuestion{
  map<string, string> submit = 1;
}

message ResSubmitFeedbackQuestion{
  bool success = 1;
}

//反馈
message Feedback{
  string msg = 1;
  int32 mode = 2;//1 send 2 receive
  bool receive = 3;//receive==2 true 已经接收的 false 下线接收的
  int64 mills = 4;//时间戳
}

//获取反馈
message ReqFeedbacks{
}

message ResFeedbacks{
  repeated Feedback feedbacks = 1;
  bool submit = 2;//是否已经提交过问卷
}

//发送反馈
message ReqSendFeedback{
  string msg = 1;
}

message ResSendFeedback{
  bool success = 1;
}

//接收反馈
message ResReceiveFeedback{
  Feedback feedback = 1;
}

message ReqAnnounce{
  int32 id = 1;
  repeated string arg1=2;
  repeated string arg2=3;
}

message ResRoleChatBan {
  int64 banRoleId  = 1;
}

message ReqSearchRoleId {
  string name = 1;
}

message ResSearchRoleId {
  int64 toRoleId = 1;
}

message ResUnionKuaFuCamp {
  int32 camp = 1;//跨服联盟聊天
}

