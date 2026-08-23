MailMessage = {
  ResNewMail = 3001,
  ReqGetMailList = 3002,
  ResGetMailList = 3003,
  ReqReadMail = 3004,
  ResReadMail = 3005,
  ReqGetMailItems = 3006,
  ResGetMailItems = 3007,
  ReqDeleteMail = 3008,
  ResDeleteMail = 3009
}
MessageIDToName[3001] = "MailPackage.ResNewMail"
MessageIDToName[3002] = "MailPackage.ReqGetMailList"
MessageIDToName[3003] = "MailPackage.ResGetMailList"
MessageIDToName[3004] = "MailPackage.ReqReadMail"
MessageIDToName[3005] = "MailPackage.ResReadMail"
MessageIDToName[3006] = "MailPackage.ReqGetMailItems"
MessageIDToName[3007] = "MailPackage.ResGetMailItems"
MessageIDToName[3008] = "MailPackage.ReqDeleteMail"
MessageIDToName[3009] = "MailPackage.ResDeleteMail"
Protobuf.LoadProto("Mail.proto")
