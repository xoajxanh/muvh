UILayer = {
  Loading = enum(0),
  Background = enum(1),
  Panel = enum(2),
  Dialog = enum(3),
  MessageBox = enum(4),
  Tip = enum(5),
  Prompt = enum(7),
  Tooltip = enum(8)
}
UIPanelType = {
  Nothing = enum(0),
  NormalAndHide = enum(),
  SortAndHide = enum(),
  NoHide = enum(),
  HideOpen = enum()
}
UIHideType = {
  Hide = enum(1),
  Destroy = enum(),
  WaitDestroy = enum()
}
UIHideFunc = {
  MoveOutOfScreen = enum(1),
  Deactive = enum()
}
UIEscClose = {
  DontClose = enum(1),
  Close = enum(),
  Block = enum()
}
EUIMainSubOrderInLayer = {
  TranScript = enum(8)
}
EUIColor = {
  Red = "0xFF2323FF",
  Green = "0x1ADD1FFF",
  White = "0xFFFFFFFF",
  Gray = "0x8E8E8EFF"
}
EUIPlyerType = {
  MainPlayer = enum(1),
  OtherPlayer = enum()
}
UI_DEFAULT_LAYER = "Panel"
UI_DEFAULT_HIDE_TYPE = "WaitDestroy"
UI_DEFAULT_HIDE_FUNC = "MoveOutOfScreen"
UI_DEFAULT_ESC_CLOSE = "DontClose"
WAIT_DESTROY_TIME = 300
