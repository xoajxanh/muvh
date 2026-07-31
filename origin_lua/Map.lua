syntax = "proto3";
package MapPackage ;
import "Bag.proto";
import "Role.proto";
import "Buffer.proto";
import "Equip.proto";

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "MapProto";

//副本状态
//执行初始化操作  INIT(1),
//等待玩家进入 WAITING(2),
//副本进行中 RUNNING(3),
//关闭 CLOSING(4),
//终止  END(5);

//活动状态
//    init(0),
//    running(1),
//    close(2),
//    end(3);

//更新视野消息
message ResBuildView {
  repeated RoundPlayer addPlayers = 1;
  repeated RoundMonster addMonsters = 2;
  repeated RoundNpc addNpcs = 3;
  repeated RoundItem addItems = 4;
  repeated RoundBlockBuilding addBlockBuildings = 5;
  repeated RoundTrap addTraps = 6;
  repeated RoundTransmit addTransmits = 7;
  repeated RoundGrave addGraves = 8;
  repeated RoundAuction addAuction = 9;
  repeated RoundStatue addStatue = 10;
}

//更新视野消息
message ResUpdateView {
  repeated int64 exitIds = 1; //移除的对象id
  repeated RoundPlayer addPlayers = 2;
  repeated RoundMonster addMonsters = 3;
  repeated RoundNpc addNpcs = 4;
  repeated RoundItem addItems = 5;
  repeated RoundBlockBuilding addBlockBuildings = 6;
  repeated RoundTrap addTraps = 7;
  repeated RoundTransmit addTransmits = 8;
  repeated RoundGrave addGraves = 9;
  repeated RoundAuction addAuction = 10;
  ResSelfAOIInfo selfAOIInfo = 11;  //自己的视野相关信息，用于调试服务器问题
  repeated RoundStatue addStatue = 12;
}

//自己的视野相关信息，用于调试服务器问题
message ResSelfAOIInfo {
	int32 enterTowerObjectTime = 1;  //进入tower object的时间
    int32 leaveTowerObjectTime = 2;  //离开tower object的时间
    int32 enterTowerWatchTime = 3;  //进入tower watch的时间
    int32 leaveTowerWatchTime = 4; //离开tower watch的时间
    //repeated int64 enterWatchTowers = 5; //进入的tower watch坐标
    //repeated int64 enterObjectTowers = 6; //进入的tower obect坐标
}

//退出视野消息
message ResExitView {
  int64 exitId = 1;
}

//玩家信息
message RoundPlayer {
  RolePackage.RoleSimpleInfo info = 1;
  int64 maxHp = 2; //最大血量
  int64 hp = 3; //血量
  int32 x = 4;
  int32 y = 5;
  repeated EquipInfo equips = 6;//装备
  Pet pet = 7;
  int64 teamId = 8;
  repeated BufferPackage.Buff buff = 9;//buff
  int32 interactionState = 10;//场景交互状态
  int32 moveSpeed = 11;//移速
  int32 PKmode = 12;//和平模式
  int32 maxMp = 13; //最大蓝量
  int32 mp = 14; //蓝量
  int64 hangUpProtectionTime = 15; //挂机保护时间(结束时间)
  int32 maxShield = 17; //最大护盾
  int32 shield = 18; //当前护盾
  int32 blockIndexX = 19;
  int32 blockIndexY = 20;
  int64 crossServerHangUpTime = 21; //跨服挂机保护时间(结束时间)
  RolePackage.ResArchangelShieldInfo archangelShieldInfo =22;//大天使护盾信息
  repeated RolePackage.ResHolyRingInfo  holyRingInfo = 23;//圣环信息
  repeated EquipPackage.RuneInfoPacking reRuneInfoPackingInfo = 24; //符文信息
  int64 expRateEndTime=25;//杀怪多倍经验结束时间,0为未开启
  int64 campId = 26;//阵营id
  bool offline = 27;//是否离线
  repeated int32 skills = 28;//技能
}

//怪物信息
message RoundMonster {
  int64 id = 1; //id
  int32 configId = 2;
  string name = 3; //名称
  int64 maxHp = 4; //最大血量
  int64 hp = 5; //血量
  int32 x = 6;
  int32 y = 7;
  int64 master = 8; //主人
  int64 owner = 9; //归属者
  string ownerName = 10; //归属者名字
  int32 bornX = 11;//出生点 x
  int32 bornY = 12;//出生点 y
  int32 nameColor = 13;//名称颜色
  int64 campId = 14;//为0不判断 不为0 相同同阵营不能选择目标
  int32 status = 15;//100 无法选择状态 其他情况正常
  repeated BufferPackage.Buff buff = 16;//buff
  string belongCampName = 17; //归属阵营名称
}

//NPC信息
message RoundNpc {
  int64 id = 1;
  int32 configId = 2;
  int32 x = 3;
  int32 y = 4;
  int64 unionId = 5;
  string unionName = 6;
  string name = 7;
}

//墓碑信息
message RoundGrave {
  int64 id = 1; //怪物id
  int32 configId = 2;//怪物配置id
  int64 reliveTime = 3;//复活倒计时 毫秒数
  int32 x = 4;
  int32 y = 5;
}

//道具信息
message RoundItem {
  BagPackage.ItemInfo item = 1;//道具
  int32 x = 2;
  int32 y = 3;
  int32 fromX = 4;//
  int32 fromY = 5;//
  repeated int64 owner = 6; //归属
  int32 dropTime = 8; //掉落时间
  int32 totalTime = 9; //停留时间
  int32 ownerProtectedTime = 10; //归属者保护时间
  int64 wholeOwner = 11; //归属者才看的到
}

//阻挡建筑信息
message RoundBlockBuilding {
  int64 id = 1;
  int32 configId = 2;
  int32 x = 3;
  int32 y = 4;
  int64 blockData = 5;
}

//阻挡建筑信息
message RoundTrap {
  int64 id = 1;
  int32 configId = 2;
  int32 x = 3;
  int32 y = 4;
  int64 createTime = 5;
}

//阻挡建筑信息
message RoundTransmit {
  int64 id = 1;
  int32 configId = 2;
  int32 x = 3;
  int32 y = 4;
}

message EquipInfo {
  int32 itemId = 1;
  int32 bagGridIndex = 2;//装备位
  int32 intensify = 3;//强化等级
  bool valid = 4;//是否激活
}

message Pet {
  int64 id = 1; //id
  int32 configId = 2; //id
  int32 x = 3;
  int32 y = 4;
}

message ReqPetMove {
  int32 x = 1;
  int32 y = 2;
}

message ResPetMove {
  int64 rid = 1; //id
  int64 id = 2; //id
  int32 x = 3;
  int32 y = 4;
}

message ReqMove {
  int32 x = 1;
  int32 y = 2;
  int32 action = 3;
  int64 time = 4; //请求时间
  int32 blockIndex = 5;
}

message ResMove {
  int64 lid = 1; //对象id
  int32 x = 2;
  int32 y = 3;
  int32 action = 4; //1走路 2跑步,3
  int32 moveSpeed = 5;
  int32 blockIndexX = 6;
  int32 blockIndexY = 7;
}

message ResFailMove {
  int32 x = 1;
  int32 y = 2;
  int32 reason = 3;
  int32 blockIndex = 4;
}

//请求改变朝向
message ReqChangeDir {
  int32 dir = 1; //朝向
}

//返回改变朝向
message ResChangeDir {
  int64 lid = 1; //对象id
  int32 dir = 2; //朝向
}

//玩家尝试进入地图
message ReqTryEnterMap {
  int32 mid = 1;
  int32 line = 2; //地图分线
}

//玩家尝试进入地图
message ResTryEnterMap {
  int32 mid = 1;
  int32 line = 2; //地图分线
  bool reconnect = 3; //是否断线重连上来
}

//请求传送 暂时只传送本地地图
message ReqTransferTransmit {
  int32 transferId = 1; //TransferId
  int32 line = 2; //line
  bool changeLine = 3;//是否是切线
}

//请求传送
message ReqTransmit {
  int32 mapId = 1; //地图id
  int32 line = 2; //地图id
  int32 x = 3; //坐标x
  int32 y = 4; //坐标y
}

//玩家切换地图
message ResChangeMap {
  int32 mapId = 1;
  int32 line = 2;
  int32 x = 3;
  int32 y = 4;
  int32 reason = 5; //原因
  int32 reasonParam = 6; //原因参数（需要参数返回时发）
}

//玩家进入地图
message ResLoginMap {
  int64 id = 1; //id
  int32 mapId = 2;
  int32 line = 3;
  int32 x = 4;
  int32 y = 5;
}

//切换位置
message ResChangePos {
  int64 lid = 1;
  int32 x = 2;
  int32 y = 3;
  int32 reason = 4; //原因
  string reasonParam = 5; //原因参数（需要参数返回时发）
  int32 mapId = 6; 
  int32 line = 7; 
}

message ReqPickUpMapItem {
  int64 objId = 1;
}

message ReqPickUpMapItems {
  repeated int64 objIds = 1;
}

message ResPickUpMapItem {
  repeated int64 objIds = 1;
}

//退出副本
message ReqExitInstance {

}

//副本倒计时
message ResInstanceCountDown {
  int32 mapId = 1;
  int32 countdownTime = 2;//seconds
}

//领奖
message ReqInstanceReward {

}

//领奖响应
message ResInstanceReward {
  int32 instanceId = 1;
  repeated BagPackage.ItemInfo rewards = 2;//奖励
}

//领奖响应
message ResInstanceReward_LuoLanXiaGuGongCheng {
  int32 activityGlobalId = 1;
  repeated BagPackage.ItemInfo rewards = 2;//奖励
}

message InstanceMonster {
  int64 mid = 1;//怪物Id
  int32 cid = 2;//怪物配置id
  int64 hp = 3;//怪物血量
  int32 x = 4;
  int32 y = 5;
  int64 reliveTime = 6;//复活时间
}

//副本基础信息
message BasicInstance {
  int32 mapId = 1;
  int32 line = 2;
  int32 creatorType = 3;
  int64 creatorId = 4;
  int64 createTime = 5;
  int32 state = 6;
}

message ResPersonInstance_PersonBoss {
  BasicInstance basic = 1;
  repeated InstanceMonster monsters = 2;
  bool success = 3;
  repeated int64 rewardRids = 4;
  repeated int64 alreadyRewardRids = 5;
}

message ResPersonInstance_PersonResource {
  BasicInstance basic = 1;
  repeated InstanceMonster monsters = 2;
  bool success = 3;
  repeated int64 rewardRids = 4;
  repeated int64 alreadyRewardRids = 5;
}

//狼魂要塞
message ResSystemUnionInstance_LangHunYaoSai {
  BasicInstance basic = 1;
  SystemUnionInstance_ProtectStatusActivity protectStatusActivity = 2;
}
//狼魂要塞保卫雕像活动
message SystemUnionInstance_ProtectStatusActivity {
  int32 state = 1;
  int32 runState = 2;//运行状态 0:准备阶段
  int64 initTime = 3;//开始时间
  int32 prepareTime = 4;//准备时间
  RoundMonster status = 5;//雕像状态
  bool monsterRefreshEnd = 6;//刷新是否结束
  int32 monsterRefreshStep = 7;//当前怪物波数
  int64 nextMonsterRefreshTime = 8;//下一次刷新的的时间
  repeated int64 yongBing = 9;//佣兵
  int64 nextMonsterAttackTime = 10;//下一次怪物进攻的时间
  int64 rewardExp = 11;//奖励的战盟经验数量
}

//帮会boss
message UnionSystemInstance_BangHuiBoss {
  BasicInstance basic = 1;
  UnionSystemInstance_BangHuiBossKillBossActivity killBossActivity = 2;
}

//帮会boss-Boss活动
message UnionSystemInstance_BangHuiBossKillBossActivity {
  int32 state = 1;
  int32 run_step = 2;//运行阶段
  map<int32, InstanceMonster> boss = 3;//boss信息
  repeated int64 hurtRoleIds = 4;//参与过伤害的id
  bool tradeReward = 5;
}

//罗兰峡谷活动
message SystemInstance_LuoLanXiaGu {
  int32 state = 1;
  SystemInstance_LuoLanXiaGuGongChengActivity gongCheng = 2;
}

//罗兰峡谷攻城活动
message SystemInstance_LuoLanXiaGuGongChengActivity {
  int32 state = 1;//活动状态
  int64 curHaveUnionId = 2;//当前正在占领的
  int64 holdUnionId = 3;//当时end的时候:是胜利方  其他情况：当前防守的帮会id 
  map<string, RoundMonster> monsters = 4;//特殊怪物列表
  map<int64, int32> holdTime = 5;//占领时间
}

//罗兰峡谷攻城活动-机关信息
message SystemInstance_LuoLanXiaGuGongChengActivity_Trap {
  repeated RoundTrap traps = 1;
}

//赤色要塞
message SystemInstance_ChiSeYaoSai {
  int32 state = 1;
  SystemInstance_ChiSeYaoSaiActivity chiSeYaoSaiActivity = 2;
}
//赤色要塞活动
message SystemInstance_ChiSeYaoSaiActivity {
  int32 activityState = 1;//活动状态
  int32 runStep = 2;//运行阶段
  int32 next_control_index = 3;//当前控制阶段
  int32 enterCount = 4;//参与人数
  int32 currentCount = 5;//当前人数
}
//赤色要塞活动排行
message SystemInstance_ChiSeYaoSaiActivityRank {
  map<int32, SystemInstance_ChiSeYaoSaiActivityRankRole> rankRole = 1;
}
//赤色要塞活动排行数据
message SystemInstance_ChiSeYaoSaiActivityRankRole{
  int64 roleId = 1;//id
  string roleName = 2;//name
  int32 count = 3;//击杀数
  int32 rank = 4;//排名
}

message ResPersonInstance_BloodCastle {
  PersonBasicInstance basic = 1;
}

message ResPersonInstance_Tower {
  PersonBasicInstance basic = 1;
}

message InstanceTask {
  int32 id = 1;
  int32 count = 2;
  int32 state = 3;
  int64 endTime = 4;
  bool complete = 5;//是否已经提交
}

message ReqSubmitInstanceTask {
  int32 id = 1;
}

message ResInviteJoinInstance {
  int32 instanceId = 1;
  int64 line = 2;
  string createName = 3;
}

message ResPersonInstance_DemonSquare {
  PersonBasicInstance basic = 1;
  int32 count = 2;
  int32 score = 3;
}


message PersonBasicInstance {
  BasicInstance basic = 1;
  repeated InstanceTask task = 2;
  bool success = 3;
  int32 nextStateTime = 4;
  repeated int64 rewardRids = 5;
  repeated int64 alreadyRewardRids = 6;
  repeated InstanceMonster monsters = 7;
  int32 initWaitTime = 8;
}

//火龙来袭活动状态
message ResHuoLongLaiXiActivity{
	int32 state =1;
	repeated int32 mapIds = 2;// 出现火龙来袭活动的地图
}

message ResCallFlag{
  int32 type = 1;// 1战盟召唤令 2队伍召唤令
  int64 rid = 2;// 召唤者
  string callName = 3;// 召唤者名字
  int32 mapId = 4;
  int32 line = 5;
  int32 x = 6;
  int32 y = 7;
  int32 hostId = 8;
}

message ReqCallFlag{
  int32 type = 1;// 1战盟召唤令 2队伍召唤令
  int64 rid = 2;// 召唤者
  int32 mapId = 3;
  int32 line = 4;
  int32 x = 5;
  int32 y = 6;
  int32 hostId = 7;
}


message BossMapAndCount{
	int32 bossId = 1; //怪物configId
	repeated bMapAndCount mapCount = 2; //地图和数量
}
message bMapAndCount{
	int32 mapId = 1;// 地图id
	int32 count = 2;// boss数量
	int32 line = 3;
	repeated BossState bossState = 4;
}
message ResGetBossMapAndCount{
	repeated BossMapAndCount bosses = 1; // boss 位置数量信息
}

message ReqChangeInteractionState{
	int32 interactionState = 1; //场景交互状态
	int32 x = 2;
	int32 y = 3;
}

message ResMonsterDie{
	int32 type = 1;//死亡怪物类型
}

message ResBossIcon{
	repeated BossIcon list = 1;// 所有图标状态
}

message BossIcon{
	int32 id = 1;//图标表id
	int32 state = 2;//状态 0死亡 1活着
}

message ResBossSmallIcon{
	repeated BossSmallIcon list = 1;// 所有图标状态
	int32 x = 2;//玩家进入地图坐标 x
	int32 y = 3;//玩家进入地图坐标 y
}

message BossSmallIcon{
	int64 id = 1;//id
	int32 configId = 2;//配置id
	int32 x = 3;//坐标 x
	int32 y = 4;//坐标 y
	int32 state = 5;//状态 0死亡 1活着
	int64 reliveTime = 6;//复活时间戳
	int32 showType = 7;//显示类型,1:默认类型,2:死亡不显示
}

message ResInstanceCoolDown{
	repeated InstanceCoolDown list = 1;
}

message ReqInstanceCoolDown{
	int32 type = 1;
}

message InstanceCoolDown{
	int32 mapId = 1;//副本地图id
	int64 endTime = 2;//冷却结束时间
}

message ResGoldBoxSpecialEffects{
	int32 x = 1;
	int32 y = 2;
	int32 specialEffects = 3;//是否播放特效
}

message ResShowMapLinePlayer{
	repeated MapLinePlayerNums numsList = 1;
}

message MapLinePlayerNums{
	int32 mapId = 1;
	int32 line = 2;
	int32 nums = 3;
}

message RoundAuction {
  int64 id = 1;
  int32 position = 2;
  int32 x = 3;
  int32 y = 4;
  string title = 5;
  int64 roleId = 6; //角色ID
  string name = 7; //名称
  int32 career = 8; //职业
  repeated EquipInfo equips = 9;//装备
}

message ReqBossStateByType{
	int32 type = 1;
}

message ResBossStateByType{
	int32 type = 1;
	repeated BossState bossState = 2;
}

message BossState{
	int32 transferId = 1;
	int32 bossId = 2;
	int32 reliveTime = 3;
}

message ResMysteryBossInfo{
	BasicInstance basic = 1;
	repeated InstanceMonster monsters = 2;
	repeated MysteryBossInfo bossInfo = 3;
	int32 instanceType = 4; //转生boss复用秘境的消息，instanceType用来标记该消息是什么类型的副本
}


message MysteryBossInfo{
	int64 mid = 1;//怪物Id
	repeated BossHurt hurts= 2;
}

message BossHurt{
  int64 id = 1;
  string name = 2;
  int64 damage = 3 ;
}

message InstanceSettle{
	PersonBasicInstance basic = 1;
	int32 monsterNum = 2;
	int64 exp = 3;
}

message BlackRoomInfo{
  int64 time=1;//剩余时间
}

message ReqCanJoinRemoteMap{
}

message ResCanJoinRemoteMap{
  bool canEnter = 1;//是否进入跨服
  bool openRemote = 2;//是否开启跨服
}

message ResSystemInstanceGodDeity{
	int32 mapId = 1;
	int64 endTime = 2;
	RoundMonster boss = 3;
}
message ResGodDeityInstance{
	RoundMonster boss = 1;
}
//修复视野
message FixView{
	int64 rid = 1;//异常玩家id
}
//修复视野响应-目前用于出错的情况
message FixViewResponse{
	int64 rid = 1;//异常玩家id
	string name = 2;//异常玩家名字
	int32 type = 3;//1：玩家 0：其他
}

//返回挂机收益点信息
message ResMapHangUpPoint{
	int32 mapId = 1;//地图id
	repeated MapHangUpPoint mapHangUpPoint = 2;//收益点信息
}
//收益点信息
message MapHangUpPoint{
	int32 x = 1;//经度
	int32 y = 2;//纬度
	int32 profitType = 3;//收益类型：1宝石掉落收益；2经验收益；3装备掉落收益
	int32 profitValue = 4;//收益数值
}

//返回地图特效显示点
message ResMapEffectsPoint{
	int32 mapId = 1;//地图id
	repeated MapEffectsPoint mapEffectsAddPoint = 2;//添加特效显示点信息
	repeated MapEffectsPoint mapEffectsRemovePoint = 3;//移除的特效显示点信息
}
//特效显示点信息
message MapEffectsPoint{
	int64 id = 1;//唯一id
	int32 x = 2;//经度
	int32 y = 3;//纬度
	int32 effectId = 4;//特效id
	int32 dir = 5;//朝向
	int64 fromId = 6;//特效触发者
}
//玩家队友位置
message ResTeamMatePosition{
	repeated TeamMatePosition teamMatePosition = 1;
}

message TeamMatePosition{
	string name = 1;
	int32 X = 2;
	int32 Y = 3;
}

//玩家阵营位置信息
message ResCampPosition {
	repeated  CampPosition campPosition = 1;
}

message CampPosition{
	string name = 1;
	int32 X = 2;
	int32 Y = 3;
	int64 lid = 4;
}

//请求创建临时传送阵
message ReqCreateTemporaryTransmit{
	int32 transferId =1;//传送id
}

//卡利玛神庙消息
message ResGodTemple {
	BasicInstance basic = 1;
	repeated InstanceMonster monsters = 2;
	repeated MysteryBossInfo bossInfo = 3;
	int64 surplusTime = 4;//玩家在地图的剩余时间
}
//返回临时传送阵消息
message ResCreateTemporaryTransmit{
	int32 transferId =1;//传送id
	int32 mapId =2;//当前地图id
	int32 x =3;//x坐标
	int32 y =4;//y坐标
}
//请求按副本类型和怪物类型获取怪物信息
message ReqMonsterInfoByTypeAndInstanceType{
	int32 instanceType =1;
	repeated int32 monsterType =2;
}
//按副本类型和怪物类型返回怪物信息
message ResMonsterInfoByTypeAndInstanceType{ 
	repeated MonsterMapAndCount MonsterMapAndCount = 1; // monster 位置数量信息
	int32 instanceType =2;
}
message MonsterMapAndCount{   //builder1
	int32 mapId = 1; //地图Id
	repeated MapMonsters mapMonsters= 2; //
}
message MapMonsters{  //builder2
	int32 monsterType =1;
	repeated MonsterInfo monsterInfo =2;
}
message MonsterInfo{   //builder3
	int32 monsterConfigId =1;
	int32 monsterCount =2;
}

//神之国度诸神之战胜利特效
message ResBattleOfTheGodEffects{
	bool hasStatue =1;//是否有雕像
}

message RoundStatue {
  int64 id = 1;
  int32 x = 2;
  int32 y = 3;
  int64 roleId = 4; //角色ID
  string name = 5; //名称
  int32 career = 6; //职业
  repeated EquipInfo equips = 7;//装备
  int32 sid = 8; //区服id
  string appear = 9;//当前时装
}

//神之国度诸神之战活动
message SystemInstance_BattleOfTheGodsActivity {
  int32 state = 1;//活动状态
  int64 curHaveLeagueType = 2;//当前正在占领的联盟
  int64 holdLeagueType = 3;//当时end的时候:是胜利方  其他情况：当前防守的联盟Type 
  repeated RoundMonster monsters = 4;//特殊怪物列表
  map<int32, int32> holdTime = 5;//占领时间 联盟类型/占领时间
  int32 bossFlushTime = 6;
}
//请求卡利玛怪物刷新时间
message ReqCountDown{
  int32 mapId =1;
}
//返回卡利玛怪物刷新时间
message ResCountDown{
  int32 countDownTime =1;
}

//请求怪物掉率
message ReqMonsterDropRate{
  repeated int32 monsterConfigId =1;//需要展示掉率的怪物
}

//返回怪物掉率
message ResMonsterDropRate{
  repeated DropRate drapRates =1;
}
message DropRate{
  int32 monsterConfigId =1;//需要展示掉率的怪物
  int32 dropNum =2;//掉落次数
}
//个人卡利玛信息
message ResPersonGodTempleInfo{
	BasicInstance basic = 1;
	int32 countDownTime =2;//倒计时
}
//试炼之地信息
message ResExerciseAreaInfo{
	BasicInstance basic = 1;
	repeated InstanceMonster monsters = 2;
	repeated ExerciseAreaInfo bossInfo = 3;
	int32 instanceType = 4; 
}

message ExerciseAreaInfo{
	int64 mid = 1;//怪物Id
	repeated BossHurt hurts= 2;
}

message RefineTowerInstance {
   PersonBasicInstance basic = 1;
}

message ResPicture {
    int32 code = 1;
	bool switch =2;//客户端特效开关
}

//再生boss信息
message ResRegenerateBossInfo{
	BasicInstance basic = 1;
	repeated InstanceMonster monsters = 2;
	repeated RegenerateBossInfo bossInfo = 3;
	int32 instanceType = 4;
}
message RegenerateBossInfo{
	int64 mid = 1;//怪物Id
	repeated BossHurt hurts= 2;
}

//操作被限制
message ResLimitOperation{
	int32 type = 1;//操作被限制原因，1：被关小黑屋
}
message ReqSpecialOjbectPosition{
	int32 type = 1;//特殊目标类型,1:拥有卡伦特宝箱
}

message ResSpecialOjbectPosition{
	int32 type = 1;
	repeated SpecialOjbectPosition specialOjbectPosition = 2;
}

message SpecialOjbectPosition{
	string name = 1;
	int32 X = 2;
	int32 Y = 3;
	int32 monsterId = 4;
	int64 roleId = 5;
}

message ResColetRuinsInfo{
	BasicInstance basic = 1;
	repeated InstanceMonster monsters = 2;
	int32 hasKillNum = 4;//击杀数
	int32 openBoxNum = 5;//开宝箱数
	int32 remainTime= 6;//缩圈剩余时间
	int32 nextStateTime = 7;//下一副本状态
	int32 totalStage = 8;//总阶段
	int32 nowStage = 9;//现在是第几阶段
	int32 coletBossNum = 10;//剩余卡伦特boss数量
	int32 coletEliteNum = 11;//剩余卡伦特精英数量
	int32 canReliveCount = 12;//玩家还能复活多少次
}
//如果不处于缩圈,缩圈结束时间，宽度每秒变化值，缩圈上一个阶段的圆心,这三个可以不发
message ResColetShrinkLoop{
	int64 shrinkLoopEndTime = 1;//缩圈结束时间(毫秒值)
	int32 width = 2;//缩圈后的宽度
	Point afterPoint = 4;//缩圈后的中心点
	Point beforePoint = 5;//缩圈前的中心点
	int64 shrinkLoopStartTime = 6;//缩圈开始时间(毫秒值)
	int32 beforeWidth = 7;//缩圈前的宽度
}

message Point{
	int32 X = 2;
	int32 Y = 3;
}

message ResExitActivityInstance{
	int32 instanceType = 1;//副本类型
}

message ResColetSettle {
    int32 reliveRank = 1;//存活排行
	int64 gainExpCount = 2;//获取经验数量
	int32 gainBoxCount = 3;//获取宝箱数量
	int32 killPlayerCount = 4;//击杀玩家数量
}
message ResBigIconMonsterInfo{
	repeated ResBigIconMonster bigIconMonsters =1;
}
message ResBigIconMonster{
	int32 configId =1;
	int64 lid =2;//怪物唯一id
	int32 X = 3;
	int32 Y = 4;
	repeated int32 buffIds = 5;
	bool state = 6;//存活状态
	int32 showType = 7;//显示类型,1:默认类型,2:死亡不显示
	string showName = 8;//大地图怪物名字
	string unionName = 9;//占领的战盟信息
}
message RoleCountDownTime{
	int32 mapId = 1;
	int64 countDownTime = 2;
}
//困兽之斗排行榜信息
message ResTrappedRankInfo{
	repeated TrappedRank rankList = 1;
	TrappedRank myRank = 2;//自己的排名
	bool close = 3;//结算
}

message TrappedRank {
	int32 rank = 1;//排名
	string name = 2;//名字
	int32 score = 3;//积分
	int32 killNum = 4;//击杀总数
	int32 helpAttackNum = 5;//助攻总数
	int64 roleId = 6;//玩家id
	int32 level = 7;//等级
	int32 maxKill = 8;//最高连杀
	int32 career = 9;//职业
}
//困兽之斗最高连续击杀数
message ResTrappedMaxKill {
	int32 maxKill = 1;
}
//连杀公告
message ResTrappedKillAnnounce {
	int32 id = 1;//对应公告表id
	int32 group = 2;//击杀者阵营
	string killName = 3;//击杀者名字
	int32 killCareer = 4;//击杀者职业
	int64 killRid = 5;//击杀者id
	string dieName = 6;//被杀者名字
	int32 dieCareer = 7;//被杀者职业
	int32 dieGroup = 8;//被杀者阵营
}

message ResCampTeamInfo {
	int32 myCampTeam = 1;//我的阵营id
	repeated CampTeamInfo campTeamList = 2;
}

message CampTeamInfo {
	int32 campTeam = 1;//阵营id
	repeated int64 lid = 2;//阵营包含玩家id
}
//困兽之斗地图信息
message ResTrappedInstance {
	BasicInstance basic = 1;
	repeated InstanceTask task = 2;
	int32 countDownTime = 3; 
}
//困兽之斗获取积分信息
message ResGetScore {
	int32 score = 1; 
}

//根据类型自动拾取
message ReqPickUpMapItemsByType {
  repeated int64 objIds = 1;//物品唯一id
  int32 storageType = 2;//背包类型
}

message ResCallBossInfo{
	int32 id = 1;//唯一id
	int32 mid = 2;//怪物id
}

message ReqCallBoss{
	int32 id = 1;//唯一id
	int32 mid = 2;//怪物id
	int32 state = 3;//状态 1.普通2.钻石 3.不召唤
}

message ResCallBossProbability{
	int32 state = 1;//1成功 0失败
}

//挑战boss副本消息
message ResVacantSpaceBossInfo{
	PersonBasicInstance basic = 1;
	int32 endTime = 2;
}

message ReqAncientBossInfo{
	int32 type = 1;//怪物类型
}
message ResAncientBossInfo{
	repeated AncientBossInfo ancientBossInfo = 1; // 远古boss信息
	repeated CountData countData = 2;
	repeated int32 showBoss = 3;
	int32 type = 4;//怪物类型
}

message AncientBossInfo{
	int32 monsterId = 1;
	int32 mapId = 2;
	int32 line =3;
	int32 x = 4;
	int32 y = 5;
}

message CountData{
	int32 monsterId = 1;
	int32 count = 2;
	int32 refreshCount = 3; //今日刷新次数
}

message ResAncientBossRedPoint{
	bool light = 1;
	int32 type = 2;//怪物类型
}

//爬塔副本信息
message ResNewTowerInfo{
	PersonBasicInstance basic = 1;
	int32 level = 2;
	bool finish = 3;//true当前层次挑战成功
	int64 endTime = 4;//打怪结算
}

message GoldCavesInfo {
	bool finish =  1;//黄金洞窟是否通关过
}

message ReqJoinGoldCaves {
	int32 type = 1;//1挑战、2扫荡
	int32 count = 2;//次数
}
//获得boss数量
message ReqGetRingBossCount {
	int32 transfer = 1;//传送id
	int32 line = 2;//分线
}

message ResGetRingBossCount {
	int32 transfer = 1;//传送id
	int32 line = 2;//分线
	int32 count = 3;//存活数量
	int32 totalCount =4;//总数量
}

message ResYuanGuBossInfo{
	PersonBasicInstance basic = 1;
}

message ReqGetAllLine {
	int32 mapId = 1;//地图id
}

message ResMapAllLine {
	int32 mapId = 1;//地图id
	repeated int32 lines = 2;//分线列表
}

//战盟夺旗副本信息
message ResUnionSystemInstance_FlagActivity {
	BasicInstance basic = 1;
	FlagActivityScorePanel panel = 2;
	int64 endTime = 3;
}

message FlagActivityScorePanel {
	repeated FlagActivityUnionInfo unionInfo = 1;
	repeated FlagActivityPlayerInfo playerInfo = 2;
	repeated FlagActivityStrongholdInfo strongholdInfo = 3;
	int32 serverType = 4; // 1 游戏服 2 跨服
}

message FlagActivityUnionInfo {
	int64 unionId = 1;//战盟id
	string unionName = 2;//战盟名称
	int32 serverId = 3;//区服id
	int32 score = 4;//积分
	int32 rank = 5;//排名
	string leaderName = 6;//盟主
	int32 unionLevel = 7;//战盟等级
}

message FlagActivityPlayerInfo {
	int64 rid = 1;//角色id
	string name = 2;//角色名
	int32 score = 3;//积分
	int32 rank = 4;//排名
	repeated int32 rewards = 5;//已经领取的奖励id
}

message FlagActivityStrongholdInfo {
	int32 id = 1;//据点编号
	int64 unionId = 2;//持有的战盟id
	string unionName = 3;//持有的战盟名称
    int32 serverId = 4;//区服id
}

//夺旗宝箱采集
message FlagActivityCollectBox {
	int64 boxId = 1;//宝箱唯一id
	int32 status = 2;//采集状态1开始采集2结束采集
}

//气泡弹窗
message ResFlagActivityBubble {
	int32 type = 1;//类型: 1采集宝箱积分. 2据点积分 3击杀积分
	int32 score = 2;//积分
}

//领取夺旗奖励
message ReqGetFlagActivityReward {
	int32 configId = 1;//奖励配置id
	int32 rewardType =2;//领取类型,1普通2双倍
}
//夺旗进度条
message ResFlagActivityProgressBar {
	int32 percentage = 1;//进度条(百分比)
}

message ResSmallMapBoxInfo{
	repeated ResFlagBoxInfo list = 1;
}

message ResFlagBoxInfo{
	int32 configId =1;//配置表id
	int64 lid =2;//宝箱唯一id
	int32 X = 3;
	int32 Y = 4;
	string name = 5;
}

message ResSpaceCrackTask {
  BasicInstance basic = 1;
  InstanceTask task = 2;
  int64 endTime = 3;//结束时间
} 

//时空裂缝pvp
message ResSpaceCrackPvp {
	repeated SpaceCrackUnionInfo unionInfo = 1;//战盟信息
	repeated SpaceCrackPersonInfo personInfo=2;//个人排名
	int64 endTime = 3;//结束时间
	BasicInstance basic = 4;
	int32 boxSum = 5;//宝箱数量
	int64 bossTime = 6;//boss出现时间
}

message SpaceCrackUnionInfo {
	int64 unionId = 1;//战盟id
	string unionName = 2;//战盟名称
	int32 serverId = 3;//区服id
	int64 score = 4;//积分
	int32 rank = 5;//排名
	string unionLeaderName = 6;//盟主名
}

message SpaceCrackPersonInfo {
	int32 rank = 1;//排名
	string name = 2;//名字
	int64 score = 3;//积分
	int64 rid = 4;//角色id
	string unionName = 5;//战盟名称
}

//跃升秘境副本召怪
message ReqAscendSecretRealmMonster {
	int32 itemId = 1;
}

//跃升秘境副本消息
message AscendSecretRealmInstance {
   PersonBasicInstance basic = 1;
   repeated InstanceMonster monsters = 2;
}

message RuWeiInfo{
    int32 serverId = 1;
    string UnionName = 2;
    int32 rank = 3;
    int64 unionId = 4;
}

message ReqUnionKuaFuSystemInstanceInfo {
}

message ResUnionKuaFuSystemInstanceInfo {
    repeated RuWeiInfo ruWeiInfo = 1;
    repeated int32 serverIds = 2;
}


