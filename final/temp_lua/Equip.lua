syntax = "proto3";
package EquipPackage;
import "Bag.proto";

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "EquipProto";

message EquipChange {
	int32 position = 1;
	BagPackage.ItemInfo items = 2;//装备
	repeated int32 stoneLight = 3;
	BagPackage.ItemInfo remove = 4;//移除时装备信息
	int32 reason = 5;//改变原因，0：正常改变；1：红装同步装备位改变
}

message PutOnTheEquipReq {
	int32 position = 1;
    int64 equipId = 2;
}

message TakeOffTheEquipReq {
	int32 position = 1;
}

message EquipIntensifyReq {
	int64 equipId = 1;
}

message EquipIntensifyRes {
	bool success = 1;
	BagPackage.ItemInfo items = 2;//装备
	bool inBag = 3;//true:bag
}

message EquipAdditionalReq {
	int64 equipId = 1;
}

message EquipAdditionalRes {
	bool success = 1;
	BagPackage.ItemInfo items = 2;//装备
	bool inBag = 3;//true:bag
}

message ChangeHorseStateReq {
	int32 position = 1;
    bool ride = 2; //上马or下马
}

message EquipChooseReq {
	int64 equipId = 1;
}

message EquipDefaultHorseReq {
	int64 equipId = 1;//默认坐骑
}

message TakeOffTheHorseReq {
	int64 equipId = 1;//脱下坐骑
	int32 position = 2;
}

message EquipSuperposeReq {
	int64 equipId = 1; //叠加后的装备id
	int64 supEquipId = 2;// 被叠加的装备id
	repeated int32 excellent = 3;
	map<int32,int32> upRate = 4;
	int32 chooseId = 5;//选择主装备的词条
	int32 excellentId = 6;//选择材料的词条
	repeated BagPackage.ExcellentInfo excellentInfo = 7; //锁定词条
}

message EquipSuperposeRes {
	BagPackage.ItemInfo items = 1;//装备
	bool inBag = 2;//true:bag
	bool success = 3;
}

message EquipTransferReq {
	int64 equipId = 1; //转移的装备id
	int64 traEquipId = 2;// 被转移的装备id
	repeated int32 type = 3;//1 强化 2 追加 3 再生
	int32 maxIntensify = 4;//最大强化等级
	int32 maxAdditional = 5;//最大追加等级
}

message EquipTransferRes {
	repeated BagPackage.ItemInfo items = 1;//装备
	repeated bool inBag = 2;//true:bag
}

message EquipDecomposeReq {
	repeated int64 equipId = 1; //分解的装备id
}

message EquipLuckyReq {
	int64 equipId = 1;
}

message EquipLuckyRes {
	bool success = 1;
	BagPackage.ItemInfo items = 2;//装备
	bool inBag = 3;//true:bag
}

message ChangeTitleStateReq {
	int64 rid = 1;
	int32 position = 2;
    bool wear = 3; //是否穿戴展示
}

message EquipReplace {
	int32 position = 1;
	BagPackage.ItemInfo remove = 2;//替换的装备信息
}

//返回所有红装信息
message ResAllRedEquipUpRank {
	repeated RedEquipUpRank redEquipUpRank =1;//红装数据
}

//请求红装升阶
message ReqRedEquipUpRank {
	int32 position = 1;//装备位编号
    int64 equipId = 2;//装备唯一id（没有装备则不用传，服务端没有合成最低等级红装）
    int32 equipItemId = 3;//装备道具id（没有装备则不用传）
}

//返回红装升阶
message RedEquipUpRank {
	int32 position = 1;//装备位编号
    int64 equipId = 2;//装备唯一id
    int32 equipItemId = 3;//装备道具id（没有装备则不用传）
}

//请求洗炼卓越属性
message ReqEquipExcellentClear {
	int64 equipId = 1; //装备唯一id
	int32 state = 2; //是否洗炼 0：确认替换洗炼数据 1：洗炼新卓越数据
}

//返回洗炼结果
message ResEquipExcellentClear{
	repeated BagPackage.ExcellentInfo equipExcellentClear = 1; //新的卓越属性
}
//请求装备再生
message ReqEquipReGenerate{
	int64 equipId =1;
	string attId = 2;//锁定的属性
}
//请求装备再生进化
message ReqEquipReEvolution{
	int64 equipId =1;
}

//返回装备再生
message ResEquipReGenerate{
	BagPackage.ItemInfo reGenerateItem = 1;//装备再生的装备信息
}

//返回装备再生进化
message ResEquipReEvolution{
	bool success = 1;//进化是否成功
	BagPackage.ItemInfo reGenerateItem = 2;//再生进化的装备信息
}

//替换再生属性
message ReqreplaceEquipReGenerate{
	int64 equipId =1;
}

//转移装备职业
message ReqTransferEquipCareer{
	int64 equipId = 1; //装备唯一id
	int32 itemId = 2;//转移生成的装备道具id
	int64 consumEquipId = 3;//消耗道具唯一id
}

//镶嵌替换符文
message ReqInlayReplaceRune{
	int64 itemId = 1; //道具唯一id
	int32 indexId = 2;//孔位id
	int32 point = 3;//符文具体位置
}


//返回符文信息
message ResRuneInfo{
	repeated RuneInfoPacking reRuneInfoPackingInfo = 1; //符文信息
}

//符文消息封装
message RuneInfoPacking{
	int32 index = 1; //孔位id
	repeated BagPackage.RuneInfo reRuneInfo = 2;//具体符文信息
}

//符文融合
message RuneFuse{
	int64 runeId = 1; //符文唯一id
	int32 runeFuseId = 2; //符文融合id
	int32  index = 3; //装备位
	int32  point = 4; //具体点位
}

//脱下符文
message TakeOffRune{
	int32 index = 1;//装备位
	int32 point =2;//具体点位
}

//请求穿戴时装
message ReqOperationFashion {
	int32 fashionType = 1;//主手、副手、防具
	int32 position = 2; //具体是哪个主手副手或者防具
	int32 type = 3;//操作类型 1：激活 2：升级 3：穿戴
}

message ResAllFashionInfo {
	repeated FashionInfo info = 1;
}

message FashionInfo {
	int32 fashionType = 1;
	int32 position = 2;
	bool crulUse = 3;//是否是当前使用
	int32 level = 4;
	int32 overtime = 5;//过期时间，等于0为永久的
	bool firstActive = 6; //首次激活(使用物品)
}

//返回新符文信息
message ResNewRuneInfo {
	repeated NewRuneInfo runeList = 1; //符文信息
}

message NewRuneInfo {
	int32 index = 1;//孔位
	int32 level = 2;//孔位等级
	BagPackage.ItemInfo runeItem = 3;//符文信息
}

message ReqRuneUp {
	int32 index = 1;//孔位
	int32 type = 2;//类型：1解锁，2升级
}

message ReqImplantRune {
	int32 index = 1;//孔位
	int64 itemId = 2;//装备id，itemId为0即是卸下符文
}

//附魔孔位升级
message ReqEnchantUpgrade {
 int32 index = 1;//孔位id
}

//附魔孔位装卸
message ReqEnchantReplace{
	int32 index = 1;//孔位id
	int64 uniqueId = 2;//道具唯一id,为0卸下,孔位已有道具时替换
}

//所有附魔孔位信息
message ResAllEnchantInfo {
	repeated ResEnchantInfo enchantInfo = 1;
}

//单个附魔孔位信息
message ResEnchantInfo {
	int32 index = 1;//孔位id
	int32 grade = 2;//当前强化等级
	BagPackage.ItemInfo item = 3;//附魔材料
}

//请求套装熔炼
message ReqEquipSmelt {
	int64 equipId = 1;//唯一id
	int32 type = 2;//1普通熔炼 2高级熔炼
}