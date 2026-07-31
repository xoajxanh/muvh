PCActivityTypeEnum = {
  FirstLogin = enum(401),
  DailyRegistration = enum(402),
  CumulativeRecharge = enum(403)
}
UIColorEnum = {
  HorizontalTogNormal = enum(),
  HorizontalTogSelected = enum(),
  VerticalFirstTogNormal = enum(),
  VerticalFirstTogSelected = enum(),
  VerticalSecondTogNormal = enum(),
  VerticalSecondTogSelected = enum(),
  VerticalThirdTogNormal = enum(),
  VerticalThirdTogSelected = enum()
}
UIColorDic = {
  [UIColorEnum.HorizontalTogNormal] = "#A07758",
  [UIColorEnum.HorizontalTogSelected] = "#FFFDD6",
  [UIColorEnum.VerticalFirstTogNormal] = "#C8C5BB",
  [UIColorEnum.VerticalFirstTogSelected] = "#FFF4D3",
  [UIColorEnum.VerticalSecondTogNormal] = "#9E998B",
  [UIColorEnum.VerticalSecondTogSelected] = "#FFF4D3",
  [UIColorEnum.VerticalThirdTogNormal] = "#71706E",
  [UIColorEnum.VerticalThirdTogSelected] = "#F0E5C6"
}
DailyRegistrationTypeEnum = {
  Week = enum(1),
  Month = enum(2)
}
