ELogoutType = {
  Maintain = enum(0),
  Block = enum(1),
  AnotherSession = enum(2),
  HearBeat = enum(3),
  Disconnect = enum(4),
  LogOut = enum(5),
  BackToChoose = enum(6),
  RepeatedLogin = enum(7)
}
WaitServer = {
  Wait = enum(0),
  NoWait = enum(1)
}
EServerState = {
  NewServer = enum(1),
  Fluent = enum(),
  Crowd = enum(),
  Defend = enum(),
  Hidden = enum()
}
EServerStateColor = {
  [1] = Color.blue,
  [2] = Color.green,
  [3] = Color.red,
  [4] = Color.gray,
  [5] = Color.gray
}
ESubmitDataType = {
  TYPE_SELECT_SERVER = enum(1),
  TYPE_CREATE_ROLE = enum(),
  TYPE_ENTER_GAME = enum(),
  TYPE_LEVEL_UP = enum(),
  TYPE_EXIT_GAME = enum(),
  TYPE_ONLINE_STATISTICS = enum(),
  TYPE_RECHARGE = enum(),
  TYPE_AccountCancellation = enum()
}
