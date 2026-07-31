syntax = "proto3";
package ItemBuyPackage;

option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "ItemBuyProto";


message ReqBuy{
    int32 goodId=1;
    int32 buyCount=2;
	int32 buyEntrance=3;
	int32 autoBuyLiquid=4;//0正常购买,1自动买药
}

//请求悬赏购买
message ReqBossRewardBuy{
    int32 goodId=1;
    int32 buyCount=2;
	int32 buyEntrance=3;
	int32 taskId=4;//Task_reward表id
}