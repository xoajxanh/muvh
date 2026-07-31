syntax = "proto3";
package CountPackage;

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "CountProto";


message Counts{
  repeated Count counts = 1;
}

message Count{
  int64 key = 1;
  int64 updateTime = 2;
  int32 count = 3;
  int32 total = 4;
}

message ReqCountByType{
  int32 type = 1;
}

message ReqCountByKey{
	int64 key = 1;
}