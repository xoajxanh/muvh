
local enumId = 0
function enum(n)
  enumId = n or enumId + 1
  return enumId
end
RoleReliveType = {
  Here = enum(1),
  BornPoint = enum(),
  RandomPoint = enum(),
  LuoLanXiaGu = enum(),
  ChiSeYaoSai = enum(),
  LangHunYaoSai = enum(),
  RefineTower = enum(),
  CostBornPoint = enum(),
  ReliveAndExit = enum(),
  KSBattle = enum(),
  KSBattleTimeEnd = enum(),
  ThreeVSThreeReviveTimeEnd = enum(),
  FourPartyRivalryFree = enum(),
  FourPartyRivalryPay = enum()
}
for k, v in pairs(RoleReliveType) do
  print(k .. ' = ' .. tostring(v))
end
