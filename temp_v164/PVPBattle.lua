syntax = "proto3";
package PVPBattlePackage;

import "Map.proto";

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "PVPBattleProto";


//pvp阵营信息
message ResPvPAllCampInfo{
	repeated CampInfo campInfo = 1;//阵营信息
	int64 endTime = 2;//结束时间
}

//单个阵营信息
message CampInfo{
	int32 groupType = 1;//所属方
	repeated PlayerInfo playerInfo = 2;//玩家信息
	int32 killCount = 3;
}

//玩家战斗信息
message PlayerInfo{
	int64 id = 1;//玩家id
	string name = 2;//玩家名字
	int32 host = 3;//玩家hostId
	int32 groupType = 4;//阵营
	int32 career = 5;//职业
	int32 status = 6;//0存活,1死亡,2离线
	int64 reviveTime = 7;//复活时间
	int32 killNum = 8;//击杀数
	int32 dieNum = 9;//死亡数
	int32 level = 10;//等级
}

//请求投降
message ReqCapitulate{
	int32 agree = 1;//1同意,0反对
}

//返回阵营投降信息
message ResCapitulateInfo{
	int32 groupType = 1;//所属方
	int32 sum = 2;//总人数
	repeated int32 vote  = 3;//当前投票1同意,0反对
	int64 endTime = 4;//结算时间
	repeated int64 rids = 5;
}


//单个阵营击杀信息变动
message CampKillChange{
	int32 groupType = 1;//所属方
	int32 killCount = 2;//击杀数
}

//3v3结束
message ResInstance3v3End{
}


//请求pvp己方广播
message ReqPVPAnnounce{
	int32 id = 1;
	string params = 2;
}

//pvp己方广播
message ResPVPAnnounce{
	int64 rid = 1;
	int32 id = 2;
	string params = 3;
}

//玩家死亡任务
message ResPlayerKillTask{
	int64 rid = 1;
	repeated MapPackage.InstanceTask task = 2; 
}

//战斗结束结算
message ResInstanceBattleBalance{
	repeated CampInfo campInfo = 1;//阵营信息
	int64 startTime = 2;//开始时间
	int64 endTime = 3;//结束时间
	int32 groupType = 4;//胜利方
	bool competition = 5;//是否赛事
}



