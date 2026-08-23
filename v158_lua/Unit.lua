syntax = "proto3";
package UnitPackage;

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "UnitProto";

message Unit{
	int32 uId = 1;
    int32 type = 2;
    string param = 3;
}

message ResAddUnit{
    int32 type = 1;
    string param = 2;
}
message ResRemoveUnit{
    int32 type = 1;
}

message ReqSwitchUnitBuff{
	int32 state = 1;  //2 暂停 1 开启
	int32 type = 2;// 指定开关 那个unit 11 挂机保护卡
}

message ResSwitchUnitBuff{
	int32 state = 1; //2 暂停 1 开启
	int64 totalTime = 2; //剩余总时间
	int32 type = 3;// 指定开关 那个unit 11 挂机保护卡
	int64 endTime = 4; //结束时间
}

message ResUnitChange{
	int32 type = 1; //Unit类型
	int64 totalTime = 2; //剩余总时间
	int32 state = 3;  //2 暂停 1 开启
	int64 endTime = 4; //结束时间
}

message ResDefaultHorse{
	int64 defaultHorse = 1;//默认坐骑
}

message ReqUnitState{
	int32 type = 1;
}

message ReqEquipFunction{
	int32 type = 1;//开启什么功能
	bool open = 2;//是否开启功能
}

//返回所有圣印数据
message ResHolySealInfo{
	repeated HolySealInfo holySealInfo = 1;//圣印数据
}

//圣印数据
message HolySealInfo{
  int32 id = 1; //对应Seal_Seal表的id字段
  int32 type = 2; //圣印类型
  int32 level = 3; //圣印等级
}
//请求升级圣印
message ReqHolySealLevelUp{
  int32 type = 1; //圣印类型
}

//玩家大师数据
message GrandMasterInfo{
	int32 level = 1; //大师等级
	int64 masterExp = 2; //大师经验
	int64 masterTalent = 3; //当前启用的职业分支
	repeated GrandMasterPointInfo grandMasterPointInfo =4;//大师点数数据
	repeated GrandMasterSkillInfo grandMasterSkillInfo =5;//当前大师技能数据
	int32 surplusExchangeNum =6; //今日剩余兑换次数
	bool changeTalentFree =7; //是否永久免费切换天赋类型
	int32 allExchangeNum =8; //今日总兑换次数
	int32 resetNum =9; //已经重置的次数
}
//玩家大师点数数据
message GrandMasterPointInfo{
	int32 masterTalent = 1; //职业分支
	int32 surplusPoint = 2; //剩余点数
}
//玩家大师技能数据
message GrandMasterSkillInfo{
	int32 masterTalent = 1; //职业分支
	repeated GrandMasterSkill grandMasterSkill = 2; //大师技能
}
//玩家大师技能数据
message GrandMasterSkill{
	int32 skillId = 1; //MasterSkill_detail的id
	int32 skillLevel = 2; //技能等级
	int32 skillGroupId = 3; //技能组id
}
//请求兑换大师经验
message ReqExchangeGrandMasterExp{
	int32 countGear = 1; //兑换数量的档位
	int64 equipId = 2; //装备id
	int32 count = 3; //使用次数
}
//返回兑换大师经验结果
message ResExchangeGrandMasterExp{
	int32 level = 1; //大师等级
	int64 masterExp = 2; //大师经验
	repeated GrandMasterPointInfo grandMasterPointInfo =3;//大师点数数据
	int32 surplusExchangeNum =4; //今日剩余兑换次数
}
//请求启用大师天赋
message ReqEnableGrandMasterTalent{
	int32 masterTalent = 1; //职业分支
	int32 enableType = 2; //启用类型（0：免费启用;1:单次支付启用；2：永久支付启用）
}
//返回启用大师天赋结果
message ResEnableGrandMasterTalent{
	int32 masterTalent = 1; //职业分支
	repeated GrandMasterSkillInfo grandMasterSkillInfo =2;//当前大师技能数据
	bool changeTalentFree =3; //是否永久免费切换天赋类型
}
//请求升级大师技能
message ReqUpGrandMasterSkill{
	int32 masterTalent = 1; //职业分支
	int32 skillId = 2; //MasterSkill_detail的id
}
//返回升级大师技能结果
message ResUpGrandMasterSkill{
	int32 masterTalent = 1; //职业分支
	GrandMasterSkill grandMasterSkill =2;//大师技能
	GrandMasterPointInfo grandMasterPointInfo =3;//对应类型的大师点数数据
}
//返回重置大师点数结果
message ResResetGrandMaster{
	int64 masterTalent = 1; //当前启用的职业分支
	repeated GrandMasterPointInfo grandMasterPointInfo =2;//大师点数数据
	repeated GrandMasterSkillInfo grandMasterSkillInfo =3;//当前大师技能数据
	int32 resetNum =4; //已经重置的次数
}
//返回大师永久免费切换天赋类型
message ResGrandMasterTalentFree{
	bool changeTalentFree =1; //是否永久免费切换天赋类型
}
//返回大师经验兑换次数变更
message ResGrandMasterExchangeNumChange{
	int32 allExchangeNum =1; //今日总兑换次数
	int32 surplusExchangeNum =2; //今日剩余兑换次数
}
//请求升级圣魂点
message ReqHolySpiritLevelUp{
	int32 type =1;//圣魂类型
	int32 configId = 2;//圣魂配置id
}
//返回圣魂信息
message ResUnitHolySpirit{
	repeated TypeHolySpirit  typeHolySpirits=1;
	int32 recommmendId = 2;//推荐升级点id
}
//圣魂页
message TypeHolySpirit{
	int32 type =1;//圣魂类型
	repeated HolySpirit HolySpirits=2;
}
//圣魂点
message HolySpirit{
    int32 type =1;
	int32 id = 2;//configId
	int32 level =3;//升级次数
	bool active =4;//是否已经激活
}
message ReqPageChange{
	int32 type = 1;//切页的时候用来选取展示的圣魂点
}
message ReqHolySpiritWashPoint{
	int32 type = 1;//圣魂洗点类型
}