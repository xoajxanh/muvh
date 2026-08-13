local RetrunActivityLandingPage = {}

function RetrunActivityLandingPage:Init()
  self:InitControls()
  self:BindUIEvent()
end

function RetrunActivityLandingPage:BindUIEvent()
  self.btn_get:SetOnClick(self, self.btnGetClick)
end

local function RewardCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function RewardRefresh(ctr, index, data, ui)
  local info = ClientTable.cfg_Box_boxManager:TryGetValue(data.id)
  if not info then
    return
  end
  local itemData = ItemUtility.GenerateItemData(info.itemId)
  local count = Mathf.NumberShowFormat(info.count, 1, false)
  itemData.count = count
  ctr.modelData:RefreshData(itemData)
  local obj = ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

function RetrunActivityLandingPage:InitControls()
  self.reward = self:GetControl("sw_Gift_1/Viewport/Content/btn_rewardx")
  self.btn_get = self:GetControl("btn_get")
  self.btn_got = self:GetControl("btn_got")
  self.RewardItem = UIContainer(self.reward, ui, RewardCreat, RewardRefresh)
end

function RetrunActivityLandingPage:Exit()
end

function RetrunActivityLandingPage:Refresh(data, ui)
  if not data then
    return
  end
  self.data = data
  if data.Msg and data.Msg.taskInfo and table.count(data.Msg.taskInfo) > 0 then
    self.data = data.Msg.taskInfo[1].giftInfo
  else
    return
  end
  self.RoleReturnStartLv = data.Msg.roleLevel
  local boxId = self:ChooseBoxId()
  if boxId == 0 or not boxId then
    return
  end
  local rewardInfo = ClientTable.cfg_Box_boxManager:BaseGetTabListByType(boxId, "boxId")
  self.RewardItem:SetData(rewardInfo)
  local MsgGiftData = {}
  for i, v in pairs(self.data) do
    if v.giftId == self.giftId then
      MsgGiftData = v
    end
  end
  if MsgGiftData then
    local getCount = MsgGiftData.roleCount
    local canGet = MsgGiftData.canGet
    if canGet and getCount == 0 then
      self.btn_get:SetActive(true)
      self.btn_got:SetActive(false)
    else
      self.btn_get:SetActive(false)
      self.btn_got:SetActive(true)
    end
  end
end

function RetrunActivityLandingPage:btnGetClick()
  if self.data[1] and self.data[1].giftId then
    NetManager.Send(RechargeMessage.ReqGetGift, {
      id = {
        self.giftId
      }
    })
  end
end

function RetrunActivityLandingPage:ChooseBoxId()
  local globalCondition = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(401)
  local data = string.split(globalCondition, "/")
  local boxId = 0
  for m, n in pairs(data) do
    local info = string.split(n, "&")
    local info1 = string.split(info[1], "#")
    if tonumber(info1[1]) == 101 and self.RoleReturnStartLv >= tonumber(info1[2]) then
      boxId = tonumber(info[2])
      self.giftId = boxId
    end
    if tonumber(info1[1]) == 103 and self.RoleReturnStartLv <= tonumber(info1[2]) then
      boxId = tonumber(info[2])
      self.giftId = boxId
    end
  end
  if boxId == 0 then
    return 0
  end
  return ClientTable.cfg_Gift_giftManager:TryGetValue(boxId).reward
end

return RetrunActivityLandingPage
