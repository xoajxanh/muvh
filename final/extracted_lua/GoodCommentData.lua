GoodCommentData = {}

function GoodCommentData:Init()
  self.giftDate = {}
  self.textList = {}
  self.awardList = {}
  self.goodCommentUrl = ""
  self.isHideGooComment = false
end

function GoodCommentData:Updata()
  local pid = LoginData.pId == 0 and 15 or LoginData.pId
  local goodComment = ClientTable.cfg_GoodCommentManager:TryGetValue(pid)
  if goodComment ~= nil and next(goodComment) ~= nil then
    self.goodCommentUrl = goodComment.link
    local tempContentArray = string.split(goodComment.content, "#")
    for i, v in pairs(tempContentArray) do
      table.insert(self.textList, i, ClientTable.cfg_Ui_wordManager:GetUi_wordCount(v) or "")
    end
    self.giftDate = ClientTable.cfg_Gift_giftManager:TryGetValue(goodComment.giftId)
    if table.isNullOrEmpty(self.giftDate) then
      return
    end
    local tempBoxDate = ClientTable.cfg_Box_boxManager:TryGetTabListByType(self.giftDate.reward, "boxId")
    for i = 1, #tempBoxDate do
      if tempBoxDate[i] ~= nil then
        table.insert(self.awardList, ClientTable.cfg_Item_itemManager:TryGetValue(tempBoxDate[i].itemId))
      end
    end
  end
end

function GoodCommentData:UpdataWithWX()
  local pid = LoginData.pId == 0 and 4 or LoginData.pId
  local goodComment = ClientTable.cfg_GoodCommentManager:TryGetValue(pid)
  if goodComment ~= nil and next(goodComment) ~= nil then
    self.goodCommentUrl = goodComment.link
    local tempContentArray = string.split(goodComment.content, "#")
    for i, v in pairs(tempContentArray) do
      table.insert(self.textList, i, ClientTable.cfg_Ui_wordManager:GetUi_wordCount(v) or "")
    end
    self.giftDate = ClientTable.cfg_Gift_giftManager:TryGetValue(goodComment.giftId)
    if table.isNullOrEmpty(self.giftDate) then
      return
    end
    local tempBoxDate = ClientTable.cfg_Box_boxManager:TryGetTabListByType(self.giftDate.reward, "boxId")
    for i = 1, #tempBoxDate do
      if tempBoxDate[i] ~= nil then
        table.insert(self.awardList, ClientTable.cfg_Item_itemManager:TryGetValue(tempBoxDate[i].itemId))
      end
    end
  end
end
