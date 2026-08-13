syntax = "proto3";
package TradePackage;
option java_package = "com.sh.mu.basic.proto";
option java_outer_classname = "TradeProto";

import "Bag.proto";

message TradeItem{
  int64 tid = 1;//1=竞拍
  int32 tv = 2;//1=竞拍
  int64 addTime = 4;
  int64 endTime = 5;
  BagPackage.ItemInfo item = 6;
  int64 sellerId = 7;
  int32 sellHostId = 8;
  int32 pItemId = 9;
  int32 highPrice = 10;
  int32 lowPrice = 11;
  int32 type = 13;//0:sys,1:union
  int32 sort = 14;
  TradeBuyer buyer = 20;
  repeated TradeBuyer preBuyer = 21;//预购者
}

message TradeBuyer{
  int32 centerHostId = 1;
  int32 hostId = 2;
  int64 id = 3;
  int32 price = 4;
}

message TradeRecommend{
  TradeItem items = 1;
  int32 index = 2; //页数：0开始
}

message TradeHistory{
  int64 buyer = 1;
  int64 seller = 2;
  int32 itemId = 3;
  int32 price = 4;
  int32 count = 5;
  int32 time = 6;
  int32 type = 7;//1：购买2;//卖3;//预购4;//退款
}


message ReqPutOn{
  int64 uniqueId = 1;//物品的唯一id
  int32 count =2;
  int32 highPrice = 3;
  int32 lowPrice = 4;
  int32 type = 5;//0:sys,1:union
}

//发送当前的所有数据-->前端确认
message ResPutOn{
  repeated TradeItem items = 1;
}


message ReqPutOff{
  int64 tid = 1;
  int32 type = 2;//0:sys,1:union
}

message ResPutOff{
  repeated TradeItem items = 1;
}


message ReqLsTrade{
  int32 index = 1; //页数：1开始
  int32 type = 2; //0查看商品 , 1 查看历史 ,2 查看自己的商品
  string condition = 3; 
}

message ResLsTrade{
  int32 type = 1; //0查看商品，1查看预约，2 查看历史
  repeated Shelf shelf = 2;
  int32 index = 3;//页数：1开始
  int32 allIndex = 4;//页数：1开始
  repeated TradeHistory history = 5; //历史
  ResAuctionInfo auctionInfo=6;
}

message Shelf{
  int32 buyPrice = 1;
  int32 centerServerType = 2;
  TradeItem items = 3;
  int32 centerHostId = 4;
  int32 hostId = 5;
}

message ResTradeCenterRefresh{
  int32 type = 1;//0:sys,1:union
}

message ResTradeCenterAdd{
  int32 centerHostId = 1;
  int32 centerServerType = 2;
  int32 hostId = 3;
  repeated TradeItem items = 5;
  int32 reason = 6;
}

message ResTradeCenterDel{
  int32 centerHostId = 1;
  int32 centerServerType = 2;
  int32 hostId = 3;
  repeated TradeItem items = 4;
  int32 reason = 5;
}

message ResTradeCenterMod{
  int32 centerHostId = 1;
  int32 centerServerType = 2;
  int32 hostId = 3;
  repeated TradeItem items = 4;
  int32 reason = 5;
}

message ReqOpenTradePanel{
  bool state = 1;
}

message ResOpenTradePanel{
  repeated int32 serverId = 1;
}

////发起交易
message ReqStartBuy{
  int32 centerHostId = 1;
  int32 hostId = 2;
  int64 tid = 3;
  int32 buyPrice = 4;
  int32 count = 5;
  int32 type = 6;//0:sys,1:union
}

//收到此消息 只是代表付钱成功
message ResStartBuy{
}

message ReqLookItemAveragePrice{
	int32 itemId = 1;
}

message ResLookItemAveragePrice{
	int32 itemId = 1;
	int32 price = 2;
}

//查看摆摊位置信息
message ReqAuctionStallPosition{
	int32 type = 1;
}

//查看摆摊位置信息
message ResAuctionStallPosition{
	int32 type = 1;
	int32 enoughNum = 2;
	int32 position = 3;
}

//购买摊位
message ReqBuyAuctionPosition{
	string title = 1;
	int32 position = 2;
	int32 stallCost = 3;
}

message ReqAuctionInfo{
	int32 position = 1;
}

message ResAuctionInfo{
	string title = 1;
	int32 position = 2;
	int64 materId = 3;
	int32 endTime = 4;
	repeated Shelf shelf = 5;
}
