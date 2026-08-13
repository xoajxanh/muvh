local RewardRank_AllPanelTemplate = {}

function RewardRank_AllPanelTemplate:Init(data)
  self.ui = data
  self:InitControls()
end

function RewardRank_AllPanelTemplate:InitControls()
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.person_rank = self:GetControl("img_bg/Scroll View/Viewport/Content/person_rank")
  self.btn_close:SetOnClick(self, self.CloseOnClick)
  self.person_rankContainer = UIContainer(self.person_rank, self.ui, self.RankCreate, self.RankRefresh)
end

local function RewardCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(ctr)
  ctr.ModelData = ItemCellData()
end

local function RewardRefresh(ctr, _, info, ui)
  local reward = string.split(info, "#")
  local itemData = ItemUtility.GenerateItemData(tonumber(reward[1]))
  itemData.count = tonumber(reward[2])
  ctr.ModelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.ModelData, ui, true)
end

function RewardRank_AllPanelTemplate.RankCreate(ctr, ui)
  ctr.bg_rank = UIControl(ctr.transform, "bg_rank")
  ctr.lab_rank = UIControl(ctr.transform, "lab_rank")
  ctr.lab_img_rank = UIControl(ctr.transform, "lab_img_rank")
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.rewardItem = UIControl(ctr.transform, "lab_rank_gift/btn_giftItem")
  if ctr.rewardContainer == nil then
    ctr.rewardContainer = UIContainer(ctr.rewardItem, ui, RewardCreat, RewardRefresh)
  end
end

function RewardRank_AllPanelTemplate.RankRefresh(ctr, index, data, ui)
  if index <= 3 then
    ctr.lab_img_rank:SetActive(true)
    ctr.lab_rank:SetActive(false)
    ui:SetSprite("Atlas_Common", "img_DemonHunt_rankList_icon_" .. index, ctr.lab_img_rank)
    ui:SetSprite("Atlas_Common", "img_DemonHunt_rankList_bg_" .. index, ctr.bg_rank)
  else
    ctr.lab_img_rank:SetActive(false)
    ctr.lab_rank:SetActive(true)
    ctr.lab_rank:SetText(index)
  end
  local des = ""
  local buffs = string.split(data.buffReward, "#")
  for i, v in ipairs(buffs) do
    local buffdes = ClientTable.cfg_Buff_buffManager:TryGetValue(tonumber(v))
    if buffdes and buffdes.desc then
      if des == "" then
        des = string.GetColorText(buffdes.desc, ItemQuality2ColorDic[EItemColorEnum.blue])
      else
        des = des .. "\n" .. string.GetColorText(buffdes.desc, ItemQuality2ColorDic[EItemColorEnum.blue])
      end
    end
  end
  ctr.lab_name:SetText(des)
  local rewardItemStrs = string.split(data.itemReward, "&")
  ctr.rewardContainer:SetData(rewardItemStrs)
end

function RewardRank_AllPanelTemplate:Refresh()
  local data = ClientTable.cfg_DemonHunt_rankRewardManager:GetDic()
  self.person_rankContainer:SetData(data)
end

function RewardRank_AllPanelTemplate:CloseOnClick()
  self.go:SetActive(false)
  self.ui:HideModel(false)
end

return RewardRank_AllPanelTemplate
