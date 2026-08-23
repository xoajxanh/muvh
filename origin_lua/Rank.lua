syntax = "proto3";
package RankPackage;
import "Bag.proto";
import "Equip.proto";
import "Role.proto";
import "HolyBone.proto";

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "RankProto";

message ReqQueryRanks{
  int32 rankType = 1;
  int32 career = 2;//-1==all
}

message ResLevelRanks{
  int32 career = 1;
  map<int32, LevelRankSummary> ranks = 2;
  int32 type = 3;
}

message LevelRankSummary{
  int64 lid = 1;
  string name = 2;
  int32 career = 3;
  int32 level = 4;
  int32 hostId = 5;
  repeated BagPackage.ItemInfo equips = 6;//装备
  int64 unionId = 7;
  string unionName = 8;
  int32 unionPosition = 9;// 战盟职位
  int32 fightValue = 10;
  int32 sid = 11;// 服区id
  string appear = 12;
  repeated EquipPackage.RuneInfoPacking reRuneInfoPackingInfo = 13; //符文信息
  repeated RolePackage.ResHolyRingInfo  holyRingInfo = 14;//圣环信息
  repeated int32 buffIds = 15;
  repeated HolyBonePackage.ResHolyBoneInfo holyBoneInfo = 16;//圣骨信息
}

message ResFightValueRanks{
  int32 career = 1;
  map<int32, FightValueRankSummary> ranks = 2;
  int32 type = 3;
}

message FightValueRankSummary{
  int64 lid = 1;
  string name = 2;
  int32 career = 3;
  int32 fightValue = 4;
  int32 hostId = 5;
  repeated BagPackage.ItemInfo equips = 6;//装备
  int64 unionId = 7;
  string unionName = 8;
  int32 unionPosition = 9;// 战盟职位
  int32 level = 10;
  int32 sid = 11;// 服区id
  string appear = 12;
  repeated EquipPackage.RuneInfoPacking reRuneInfoPackingInfo = 13; //符文信息
  repeated RolePackage.ResHolyRingInfo  holyRingInfo = 14;//圣环信息
  repeated int32 buffIds = 15;
  repeated HolyBonePackage.ResHolyBoneInfo holyBoneInfo = 16;//圣骨信息
}

message ResWarriorTrialRanks{
  int32 career = 1;
  map<int32, WarriorTrialRankSummary> ranks = 2;
}

message WarriorTrialRankSummary{
  int64 lid = 1;
  string name = 2;
  int32 career = 3;
  int32 fightValue = 4;
  int32 hostId = 5;
  repeated BagPackage.ItemInfo equips = 6;//装备
  int64 unionId = 7;
  string unionName = 8;
  int32 unionPosition = 9;// 战盟职位
  int32 level = 10;
  int32 layers = 11;// 层数
  int32 sid = 12;// 服区id
  string appear = 13;
  repeated EquipPackage.RuneInfoPacking reRuneInfoPackingInfo = 14; //符文信息
  repeated RolePackage.ResHolyRingInfo  holyRingInfo = 15;//圣环信息
  repeated int32 buffIds = 16;
  repeated HolyBonePackage.ResHolyBoneInfo holyBoneInfo = 17;//圣骨信息
}

message ResActivityRank{
  int32 type = 1; // 类型 等级 战力 强化 等等
  repeated ActivityRank ranks = 2; 
  int32 myRank = 3;
}

message ActivityRank{
  int32 rank = 1; //排名
  string name = 2; //名称
  int64 val = 3; // 可以是等级 战力 强化 等等
}

message ResMaxAttackRanks{
  int32 career = 1;
  map<int32, MaxAttackRankSummary> ranks = 2;
  int32 type = 3;
}

message MaxAttackRankSummary{
  int64 lid = 1;
  string name = 2;
  int32 career = 3;
  int32 maxAttack = 4;
  int32 hostId = 5;
  repeated BagPackage.ItemInfo equips = 6;//装备
  int64 unionId = 7;
  string unionName = 8;
  int32 unionPosition = 9;// 战盟职位
  int32 fightValue = 10;
  int32 sid = 11;// 服区id
  string appear = 12;
  repeated EquipPackage.RuneInfoPacking reRuneInfoPackingInfo = 13; //符文信息
  repeated RolePackage.ResHolyRingInfo  holyRingInfo = 14;//圣环信息
  repeated int32 buffIds = 15;
  repeated HolyBonePackage.ResHolyBoneInfo holyBoneInfo = 16;//圣骨信息
}

//卡伦特废墟副本排行榜响应
message ResColetRuinsRankRanks{
  int64 nextFlushTime = 1;
  map<int32, ColetRuinsRankSummary> ranks = 2;
}

message ColetRuinsRankSummary{
  int64 lid = 1;
  string name = 2;
  int32 career = 3;
  int32 fightValue = 4;
  int32 hostId = 5;
  repeated BagPackage.ItemInfo equips = 6;//装备
  int64 unionId = 7;
  string unionName = 8;
  int32 unionPosition = 9;// 战盟职位
  int32 level = 10;
  int32 sid = 11;// 服区id
  int32 gainBoxCount = 12;
  int32 score = 13;//击杀数
  string appear = 14;
  repeated EquipPackage.RuneInfoPacking reRuneInfoPackingInfo = 15; //符文信息
  repeated RolePackage.ResHolyRingInfo  holyRingInfo = 16;//圣环信息
  repeated int32 buffIds = 17;
  repeated HolyBonePackage.ResHolyBoneInfo holyBoneInfo = 18;//圣骨信息
}
//返回卡伦特废墟副本活动中的排行榜
message ResPlayerColetRuinsRanks{
  int64 rid = 1;
  map<int32, ColetRuinsRankSummary> ranks = 2;
  ColetRuinsRankSummary playInfo = 3;
  int32 playRank = 4;
  int64 nextFlushTime = 5;
}

message TarppedRankSummary{
  int64 lid = 1;
  int32 sid = 2;
  int32 hostId = 3;
  int32 rank = 4;
  string name = 5;
  int32 career = 6;
  int32 level = 7;
  int32 score = 8;
  repeated HolyBonePackage.ResHolyBoneInfo holyBoneInfo = 9;//圣骨信息
  repeated BagPackage.ItemInfo equips = 10;//装备
  string appear = 11;
  repeated EquipPackage.RuneInfoPacking reRuneInfoPackingInfo = 12; //符文信息
}

message PVPScoreRankSummary{
  int64 lid = 1;
  string name = 2;
  int32 career = 3;
  int32 level = 4;
  int32 hostId = 5;
  repeated BagPackage.ItemInfo equips = 6;//装备
  int64 unionId = 7;
  string unionName = 8;
  int32 unionPosition = 9;// 战盟职位
  int32 fightValue = 10;
  int32 sid = 11;// 服区id
  string appear = 12;
  repeated EquipPackage.RuneInfoPacking reRuneInfoPackingInfo = 13; //符文信息
  repeated RolePackage.ResHolyRingInfo  holyRingInfo = 14;//圣环信息
  repeated int32 buffIds = 15;
  repeated HolyBonePackage.ResHolyBoneInfo holyBoneInfo = 16;//圣骨信息
  int32 pvpScore = 17;//pvp积分
  int32 pvpStage = 18;//pvp大段位
  int32 pvpStageLevel = 19;//pvp小段位
}

message ResPVPScoreRanks {
  int32 career = 1;
  map<int32, PVPScoreRankSummary> ranks = 2;
  int32 type = 3;
}

message ResPlayerTarppedRanks {
  repeated TarppedRankSummary ranks = 1;
}

message ResKillMonsterScoreRanks{
	int32 career = 1;
	map<int32, KillMonsterScoreRankSummary> ranks = 2;
	int32 type = 3;
}

message KillMonsterScoreRankSummary{
  int64 lid = 1;
  string name = 2;
  int32 career = 3;
  int32 killMonsterScore = 4;
  int32 hostId = 5;
  repeated BagPackage.ItemInfo equips = 6;//装备
  int64 unionId = 7;
  string unionName = 8;
  int32 unionPosition = 9;// 战盟职位
  int32 fightValue = 10;
  int32 sid = 11;// 服区id
  string appear = 12;
  repeated EquipPackage.RuneInfoPacking reRuneInfoPackingInfo = 13; //符文信息
  repeated RolePackage.ResHolyRingInfo  holyRingInfo = 14;//圣环信息
  repeated int32 buffIds = 15;
  repeated HolyBonePackage.ResHolyBoneInfo holyBoneInfo = 16;//圣骨信息
}

message ResRoleKillMonsterScore{
	int32 score = 1;
}


message UnionKuaFuInfo {
	int64 unionId = 1;//战盟id
	string unionName = 2;//战盟名称
	int32 serverId = 3;//区服id
	int32 score = 4;//积分
	int32 rank = 5;//排名
	string leaderName = 6;//盟主
	int32 unionLevel = 7;//战盟等级
    repeated int64 unionLogo = 8;//logo
}

message ResUnionKuaFuRanks{
    repeated UnionKuaFuInfo unionInfo = 1;
}