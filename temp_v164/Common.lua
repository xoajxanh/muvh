syntax = "proto3";
package CommonPackage;

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "CommonProto";

message ReqOpenDay{
}

message ResOpenDay{
  int32 openDay = 1;
}

message ReqOpenWeek{
}

//周一 FirstDay
message ResOpenWeek{
  int32 openWeek = 1;
}

message ReqReport{
  int64 rid = 1;//被举报人id
  repeated int32 reasons = 2;//原因
  string content = 3;//其他原因内容
}

message ReqResolution{
  string resolution = 1;//分辨率
}

message ReqService{
  string token = 1;
  int32 type = 2;
}

message ResCloseServerToClientRole{
  int32 operationCode = 1; //关服码
}

message ResClientVersionUpdate{
  int32 clientVersion = 1;
}

message ResCurrentClientVersion{
  int32 clientVersion = 1;
}

//功能禁用列表
message ResFunctionDisable{
	repeated int32 disableList = 1;//功能禁用列表
}

message ResOpenDay_groupMinAndMax{
	bool remote = 1;//是否跨服
	int32 openDayMin = 2;//跨服组开服天数最小
	int32 openDayMax = 3;//跨服组开服天数最大
}