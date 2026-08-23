local OtherWelfareData = {}
BtnState = {
  NotUnlocked = enum(),
  Claim = enum(),
  Claimed = enum()
}
Page = {
  tog_goodComment = enum(5200101),
  tog_bindPhone = enum(),
  tog_followFB = enum(),
  tog_joinTeam = enum(),
  tog_gameGuide = enum()
}

function OtherWelfareData:Init()
end

function OtherWelfareData:GetData(id)
  self.tblData = {}
  local goodGlobal = ClientTable.cfg_Global_globalManager:TryGetValue(id)
  if goodGlobal ~= nil and next(goodGlobal) ~= nil then
    local str = string.split(goodGlobal.effect, "||")
    self.giftDate = ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(str[1]))
    if table.isNullOrEmpty(self.giftDate) then
      return
    end
    self.boxTbl = ClientTable.cfg_Box_boxManager:GetTabListByIdAndCondition(self.giftDate.reward, "boxId")
    self.giftBox = {}
    if table.isNullOrEmpty(self.boxTbl) == false then
      for i, v in ipairs(self.boxTbl) do
        local data = {
          count = v.count,
          itemId = v.itemId
        }
        table.insert(self.giftBox, data)
      end
    end
    local tbl = {
      str = str[2],
      giftDate = self.giftDate,
      Box = self.giftBox,
      id = id
    }
    self.tblData = tbl
  end
  return self.tblData
end

return OtherWelfareData
