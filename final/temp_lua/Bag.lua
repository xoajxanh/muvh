syntax = "proto3";
package BagPackage;

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "BagProto";

message CoinInfo {
  int32 itemId = 1;
  int64 count = 2;
}

message FromInfo{
  int32 type = 1;//来源类型 1 杀怪 2 NPC
  repeated string params = 2;//来源参数列表
}

message ItemInfo {
  int32 itemId = 1;
  int64 id = 2;
  int64 count = 3;
  int64 time = 4;//过期时间
  int32 bagGridIndex = 5;//背包位置，装备位
  int32 durability = 6;//耐久
  int32 intensify = 7;//强化等级
  int32 bind = 8;//绑定

  int32 additional = 9;//追加等级
  repeated int32 additionalAttribute = 10;//追加属性
  repeated int32 lucky = 11;//幸运属性
  repeated int32 excellent = 12;//卓越属性--废弃字段
  bool valid = 13;//是否生效
  bool skill = 14;//是否有技能
  
  int64 exp = 15;
  int32 level = 16;
  int32 breach = 17;
  FromInfo fromInfo = 18;//道具来源
  repeated int32 wingAttr = 19;//翅膀属性
  string generateAttr = 20;// 生成的属性 json
  int64 equipTime = 21;//装备过期总时间
  int32 luck = 22;//幸运一击的等级
  int32 quickUse = 23;
  bool cBind = 24;
  repeated ExcellentInfo excellentInfo = 25;//新卓越属性
  repeated int32 specialEffectIds = 26;//特殊属性id
  repeated ExcellentInfo equipExcellentClear = 27;//洗炼卓越属性
  repeated RegenerateAttrInfo regenerateAttrs = 28;//再生属性(进化等级提升之后的属性)
  int32 regenerateLevel = 29;//再生等级
  repeated RegenerateAttrInfo regenerateClearAttrs = 30;//再生属性（洗练属性）
  int32 levelEnergyReduce = 31;//该装备穿戴所需等级减少
  repeated Attribute randomAttrs = 32;//按职业随机生成的基础属性
  int32 runesLevel = 33;//符文等级
  repeated BoneSoulInfo boneSoulInfo = 34;//圣骨灵魂属性
  int32 basicCareer = 35;//此装备拥有者的职业
  repeated int32 honourAttr = 36;//荣耀属性
  repeated int32 nucleusAttr = 37;//晶核属性
  int32 nucleusLevel = 38;
  bool canSmelt = 39;//套装是否能熔炼
  repeated int32 enchantAttr = 40;//孔位附魔材料属性
}

//属性
message Attribute{
  string attributeName = 1;
  int64 attributeValue = 2;
}

//再生属性信息
message RegenerateAttrInfo{
  string configId = 1;
  repeated RegenerateAttribute RegenerateAttribute= 2;
}

//再生属性
message RegenerateAttribute{
  string attributeName = 1;
  int64 attributeValue = 2;//进化等级提升之后的值
  int64 orginalValue = 3;//进化等级提升之前的值
}

//新卓越词条信息
message ExcellentInfo{
  int32 configId = 1;
  repeated ExcellentAttribute excellentAttribute= 2;
}
//新卓越词条属性
message ExcellentAttribute{
  string attributeName = 1;
  int64 attributeValue = 2;
}

message CellInfo{
  int32 index = 1;
  int32 state = 2;
}
//背包信息
message BagInfo {
  int32 gridCount = 1;//格子数
  repeated ItemInfo items = 2;//道具
  repeated CoinInfo coins = 3;//资源 
}

message LightStoneCellInfo{
  repeated CellInfo cellInfo =4;//荧光宝石格子状态
}

//使用物品
message UseItem {
  int32 count = 1;
  int64 itemId = 2;//道具Id
  repeated string clientParams = 3;//额外参数
}

//使用物品响应
message UseItemRes {
  int32 count = 1;
  int64 itemId = 2;//道具Id
}

//仓库信息
message ResStorageInfo {
  int32 gridCount = 1;//格子数
  repeated ItemInfo items = 2;//道具
}

//放入仓库
message PutIntoStorage {
  int64 id = 1;//道具Id
  int32 bagGridIndex = 2 ;//位置
}

//仓库取出
message TakeOutFromStorage {
  int64 id = 1;//道具Id
  int32 bagGridIndex = 2 ;//位置
}

//仓库放入取出响应
message ResStorageUpdate {
  repeated ItemInfo item = 1;
  repeated int64 removeItem = 2;//移除物品
  int32 operate = 3;//1:存入、2取出
}

//背包物品变化响应
message ResBagChange {
  repeated ItemInfo items = 1;//道具
  repeated CoinInfo coins = 2;//资源
  repeated int64 removeItem = 3;//移除物品
  int32 logType = 4;//行为
  map<int32,bool> firstGains = 5;//是否为第一次获取
  int32 storageType = 6;//背包类型
}

message AddCellReq {
  int32 type = 1;//类型
}

//Enough(0, "足够"),
//ItemId_NotEnough(1, "配置Id不满足"),
//UniqueItemId_NotEnough(2, "唯一Id不满足"),
//ALLGroup_NotEnough(3, "所有情况都不满足");
message ResItemCheckCount {
  int32 type = 1;//类型
  int32 itemId = 2;//数据
  int64 uniqueId = 3;//数据
  int32 action = 4;
}


message ReqMoveItem {
  int64 itemId = 1;//道具
  int32 bagGridIndex = 2 ;//位置
  int32 type = 3 ;//1 背包，2 仓库
}

message ReqThrowItem {
  int64 itemId = 1;//道具
}

message ResItemInfoUpdate {
	ItemInfo items = 1;
	int32 type = 2 ;//1 背包，2 仓库
}

message ResStorageGridExtend {
	int32 gridCount = 1;
	int32 type = 2 ;//0 仓库，1 背包
}

message ReqDestroyItem	{
	int64 itemId = 1;//道具
}

message ReqUseCDKey	{
	string cdKey = 1;//key
}

message UnlockLightStone{
  int32 index = 1;//孔位索引
}

message LightStoneInfo{
  repeated LightStone lightStone =1;//新荧石
}

message LightStone{
  int32 index = 1;
  int32 level = 2;
  int32 type = 3;
  bool success = 4;
}

message LightStoneLevelUp{
  int32 index = 1;
}

message LightStoneChange{
  LightStone lightStone =1;
}

message RuneInfo{
	int64 runeId = 1; //道具唯一id
	int32 point = 2;//具体点位
	int32 level = 3;//融合等级
	int64 itemId = 4;//道具配置id
}

message RemoveRuneInfo{
	int32 index = 1; //装备位
	int32 point = 2;//具体点位
}

//圣环背包变化响应
message ResHolyRingBagChange {
  repeated ItemInfo items = 1;//道具
  repeated int64 removeItem = 2;//移除物品
  int32 logType = 3;//行为
}

//圣环背包信息
message ResHolyRingBag {
  repeated ItemInfo items = 1;//道具
}

//圣骨灵魂词条信息
message BoneSoulInfo{
  int32 configId = 1;
  string attributeName = 2;
  int64 attributeValue = 3;
}

//某个类型的背包信息
message BagInfoByType {
  int32 gridCount = 1;//格子数
  repeated ItemInfo items = 2;//道具
  repeated CoinInfo coins = 3;//资源 
  int32 storageType = 4;//4:圣骨背包
}

//请求某个类型背包信息
message ReqBagInfoByType{
	int32 storageType = 1;
}

//请求整理某类型背包
message ReqBagSortByType {
	int32 type = 1;//背包类型
}

//从潘多拉活动背包取出
message ReqTakeOutFromPandoraBag {
  repeated int64 ids = 1;//道具Id
}

//从潘多拉活动背包丢弃道具
message ReqDestroyFromPandoraBag{
  repeated int64 itemIds = 1;//道具
}
