EMailState = {
  Mail_UnRead = enum(0),
  Mail_Read = enum(),
  Mail_Received = enum()
}
EMailStateType = {
  Un_Read_Items = enum(1),
  Un_Read_No_Items = enum(),
  Read_No_Receive = enum(),
  Read_Received = enum()
}
EMailStateSpriteName = {
  [EMailStateType.Un_Read_Items] = "btn_unreadNoEnclosure",
  [EMailStateType.Un_Read_No_Items] = "btn_unreadYesEnclosure",
  [EMailStateType.Read_No_Receive] = "btn_readYesEnclosure",
  [EMailStateType.Read_Received] = "btn_read"
}
