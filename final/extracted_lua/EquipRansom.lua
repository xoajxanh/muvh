EquipRansomMessage = {
  ReqGetEquipRansomInfo = 213001,
  ResGetEquipRansomInfo = 213002,
  ReqRansomEquip = 213003
}
MessageIDToName[213002] = "EquipRansomPackage.RansomEquipInfoList"
MessageIDToName[213003] = "EquipRansomPackage.RansomRequest"
Protobuf.LoadProto("EquipRansom.proto")
