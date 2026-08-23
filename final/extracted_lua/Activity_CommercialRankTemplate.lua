local Activity_CommercialRankTemplate = {}
Activity_CommercialRankTemplate.activityData = nil

function Activity_CommercialRankTemplate:Init(data)
  self.root = data
  self:InitControls()
end

function Activity_CommercialRankTemplate:InitControls()
  self.lab_name = self:GetControl("lab_name")
  self.lab_img_rank = self:GetControl("lab_img_rank")
  self.lab_rank = self:GetControl("lab_rank")
  self.btn_giftItem = self:GetControl("lab_rank_gift/btn_giftItem")
end

local function ItemCreate(control)
  if control.itemCellData then
    control.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    control.itemCellData = itemCellData
  end
end

local function ItemRefresh(ctr, _, itemData, ui)
  if not ctr.itemCellData then
    ctr.itemCellData = ItemCellData()
  end
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

function Activity_CommercialRankTemplate:Refresh(data)
  local itemdata = {}
  for i, v in pairs(data) do
    if type(v) ~= "boolean" then
      table.insert(itemdata, v)
    end
  end
  self:RankUI()
  if self:GameMgrAllRank().itemRefrth == false then
    self:RefreshuUI(itemdata)
  end
end

function Activity_CommercialRankTemplate:RefreshuUI(itemdata)
  if itemdata == nil then
    return
  end
  local data = UIContainer(self.btn_giftItem, self.root, ItemCreate, ItemRefresh)
  data:SetData(itemdata)
end

function Activity_CommercialRankTemplate:RankUI()
  local index = self:GameMgrAllRank().Index
  if 3 < index then
    self.lab_img_rank:SetActive(false)
  else
    self.lab_img_rank:SetActive(true)
    self.root:SetSprite("Atlas_Main", "ico_" .. index, self.lab_img_rank)
  end
  local winMember = self:GameMgrAllRank().CommercialRankingDataItemList
  self.lab_rank:SetText(tostring(index))
  if winMember[index] ~= nil and table.count(winMember[index]) > 0 and winMember[index].name ~= nil then
    self.lab_name:SetText(tostring(winMember[index].name))
  else
    self.lab_name:SetText("Tr\225\187\145ng")
  end
  self:GameMgrAllRank().Index = self:GameMgrAllRank().Index + 1
end

function Activity_CommercialRankTemplate:GameMgrAllRank()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.ConsumeRanking)
end

return Activity_CommercialRankTemplate
