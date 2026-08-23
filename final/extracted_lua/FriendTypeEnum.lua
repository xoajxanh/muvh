FriendTypeEnum = {
  NULL = enum(0),
  FRIEND = enum(1),
  ENEMY = enum(),
  BLACKLIST = enum(),
  APPLY_LIST = enum(),
  BE_APPLY_LIST = enum(),
  RECOMMEND = enum(),
  HISTORY = enum(8),
  UNION = enum(),
  FRIEND_SEARCH = enum(100)
}
OperateFriendListEnum = {
  ADD = enum(1),
  REMOVE = enum(),
  REFRESH = enum()
}
SearchStatusEnum = {
  NONE = enum(1),
  ADDED = enum(),
  APPLIED = enum()
}
