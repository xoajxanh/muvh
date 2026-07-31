syntax = "proto3";
package BufferPackage;

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "BufferProto";

//添加BUFF响应
message ResAddBuffer {
    int32 buffId = 1;
    int32 buffCId = 2;
    int64 beAddedId = 3;
    int64 ownerId = 4;
    int64 totalTime = 5;
	int64 addTime = 6;
	int32 count = 7;
	map<int32,int64> attribute = 8;
	map<int32,int64> showAttribute = 9;
	int32 floors = 10;//层数
}

//移除BUFF响应
message ResRemoveBuffer {
    int32 buffId = 1;
    int32 buffCId = 2;
    int64 beRemovedId = 3;
	int32 removeType = 4;//读表
}

message Buff{
	int32 buffId = 1;
    int32 buffCId = 2;
    int64 ownerId = 3;
    int64 totalTime = 4;
	int64 addTime = 5;
	int32 count = 6;
}

//刷新BUFF响应
message resBufferChange{
	int32 buffCId = 1; //buffId
	int64 totalTime = 2; //buff持续总时间
	int64 changeId = 3; // 所属者id
	int32 count = 4;
	int32 floors = 5;//层数
}


//玩家护盾信息
message ResSpecialShieldInfo{
	int64 roleId = 1;
	int32 buffId = 2;
	int32 curValue = 3;//护盾当前值
	int32 maxValue = 4;//护盾最大值
}

message BufferChangeList{
	repeated resBufferChange changeList = 1;
}

