local AnniversaryActivityNpcTemplate = {}

function AnniversaryActivityNpcTemplate:Init()
  self:InitControls()
  self:RegistUIEvents()
  self:InitUI()
end

function AnniversaryActivityNpcTemplate:InitControls()
  self.Img_bg = self:GetControl("Img_bg")
  self.lab_IntimacyLv = self:GetControl("Img_bg/lab_IntimacyLv")
  self.btn_get = self:GetControl("Img_bg/Btn_group/btn_get")
  self.lab_Received = self:GetControl("Img_bg/Btn_group/lab_Received")
  self.lab_needIntimacy = self:GetControl("Img_bg/Btn_group/lab_needIntimacy")
  self.btn_Item = self:GetControl("Img_bg/sw_gift/Viewport/Content/btn_Item")
end

function AnniversaryActivityNpcTemplate:RegistUIEvents()
  self.btn_get:SetOnClick(self, self.btn_getOnClick)
end

local function RewardItemCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function RewardItemRefresh(ctr, _, data, ui)
  local showData = {}
  local giftData = string.split(data, "#")
  showData.itemId = tonumber(giftData[1])
  showData.count = tonumber(giftData[2])
  local itemData = ItemUtility.GenerateItemData(showData.itemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  itemData.count = showData.count or 0
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui.root, true)
end

function AnniversaryActivityNpcTemplate:InitUI()
  self.rewardContainer = UIContainer(self.btn_Item, self, RewardItemCreate, RewardItemRefresh)
end

function AnniversaryActivityNpcTemplate:btn_getOnClick(control)
  if self.rewardData.id and self.rewardData.commerceId then
    local rewardId = {}
    table.insert(rewardId, self.rewardData.id)
    NetManager.Send(CommerceMessage.ReqAnniversaryReward, {
      rewardId = rewardId,
      commerceId = self.rewardData.commerceId
    })
  end
end

function AnniversaryActivityNpcTemplate:Refresh(data, ui)
  self.root = ui
  self.rewardData = data
  self.lab_IntimacyLv:SetText(data.level or "")
  local state = TaskStateEnum.CanNotGet
  if data.level and data.level <= AnniversaryActivity_NPCActivityData.npcIntimacyLevel then
    state = TaskStateEnum.CanGet
    for i, v in pairs(AnniversaryActivity_NPCActivityData.hasRewardId) do
      if v == data.id then
        state = TaskStateEnum.Got
        break
      end
    end
  end
  self:SetBtnState(state)
  if not data.reward then
    return
  end
  local giftDataTbl = string.split(data.reward, "&")
  if not giftDataTbl or #giftDataTbl <= 0 then
    return
  end
  self.rewardContainer:SetData(giftDataTbl)
end

function AnniversaryActivityNpcTemplate:SetBtnState(state)
  self.btn_get:SetActive(state == TaskStateEnum.CanGet)
  self.lab_Received:SetActive(state == TaskStateEnum.Got)
  self.lab_needIntimacy:SetActive(state == TaskStateEnum.CanNotGet)
  if state == TaskStateEnum.CanNotGet then
    self.lab_needIntimacy:SetText(AnniversaryActivity_NPCActivityData.GetNpcIntimacy() .. "/" .. (self.rewardData.count or ""))
  end
end

return AnniversaryActivityNpcTemplate
