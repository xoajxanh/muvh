local GoldDiamondRechargeTemp = {}

function GoldDiamondRechargeTemp:Init(ParPanel)
  GoldDiamondRechargeTemp.ParPanel = ParPanel
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function GoldDiamondRechargeTemp:InitControls()
  self.bg_rechange = self:GetControl("Viewport/rechange_Content/bg_rechange")
  self.Slider = self:GetControl("img_reward_bg/Slider")
  self.btn_receive = self:GetControl("img_reward_bg/btn_receive")
  self.btn_received = self:GetControl("img_reward_bg/btn_cantreceive")
  self.SliderText = self:GetControl("img_reward_bg/num")
  self.point_receive = self:GetControl("img_reward_bg/paomadeng")
end

function GoldDiamondRechargeTemp:InitUI()
  self.rechargeItemContainer = UIContainer(self.bg_rechange, self, self.OnRechargeItemCreat, self.OnRechargeItemRefresh)
end

function GoldDiamondRechargeTemp:RegistUIEvents()
  self.btn_receive:SetOnClick(self, self.Onbtn_receiveClick)
end

function GoldDiamondRechargeTemp:Refresh()
  local GoldDiamondData = RechargeData.GoldDiamondRechargeData
  local RechargePrizeData = GoldDiamondData.GetGoldDiamondRechargePrize()
  self.rechargeItemContainer:SetData(RechargePrizeData)
  self:RefreshScheduleChange()
end

function GoldDiamondRechargeTemp:RefreshScheduleChange()
  local GoldDiamondData = RechargeData.GoldDiamondRechargeData
  local des = string.format("%d $ %d", GoldDiamondData.finishCount, GoldDiamondData.totalCount)
  local isShow = GoldDiamondData.totalCount == GoldDiamondData.finishCount and GoldDiamondData.totalCount ~= 0
  self.Slider:SetValue(GoldDiamondData.GetBuySchedule())
  self.SliderText:SetText(des)
  self.btn_receive:SetActive(isShow)
  self.btn_received:SetActive(not isShow)
  self:RefreshLoadPiont(GoldDiamondData.finishCount)
end

function GoldDiamondRechargeTemp:RefreshLoadPiont(count)
  for i = 1, self.point_receive.transform.childCount do
    if i <= count then
      self.point_receive:GetChild("dot" .. i .. "/dot").gameObject:SetActive(true)
    else
      self.point_receive:GetChild("dot" .. i .. "/dot").gameObject:SetActive(false)
    end
  end
end

local atlasStr = "Atlas_Common"
local GuideEffecName = "Eff_UI_annuikuang06"

local function SetItemImage(itemId, ctr)
  local itemData = ItemUtility.GenerateItemData(tonumber(itemId))
  this:SetSprite(atlasStr, itemData.tblItem.icon, ctr)
end

local function BuyPrizeRewardCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function BuyPrizeRewardRefresh(ctr, index, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  local count = Mathf.NumberShowFormat(data.count, 1, false)
  itemData.count = count
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

function GoldDiamondRechargeTemp.OnRechargeItemCreat(ctr)
  ctr.rechargePrice = UIControl(ctr.transform, "btn_rechange/lab_buy")
  ctr.rechargebtn = UIControl(ctr.transform, "btn_rechange")
  ctr.diamondParent = UIControl(ctr.transform, "go_gem/img_icon")
  ctr.goodsCount = UIControl(ctr.transform, "go_gem/img_icon/num")
  ctr.item_Picture = UIControl(ctr.transform, "img_rechagePicture")
  ctr.item_FirstRewardInfor = UIControl(ctr.transform, "img_fristReward")
  ctr.item_GemReward = UIControl(ctr.transform, "img_fristReward/lab_fristGemReward")
  ctr.img_GemRewardIcon = UIControl(ctr.transform, "img_fristReward/lab_fristGemReward/go_gemReward/img_icon")
  ctr.lab_GemRewardnum = UIControl(ctr.transform, "img_fristReward/lab_fristGemReward/go_gemReward/img_icon/num")
  ctr.item_FristReward = UIControl(ctr.transform, "img_fristReward/sw_fristItemReward")
  ctr.item_FristRewardItem = UIControl(ctr.transform, "img_fristReward/sw_fristItemReward/Viewport/Content/btn_rechangeSwItem")
  ctr.rewardContainer = UIContainer(ctr.item_FristRewardItem, GoldDiamondRechargeTemp.ParPanel, BuyPrizeRewardCreat, BuyPrizeRewardRefresh)
  ctr.item_btn_Buy = UIControl(ctr.transform, "btn_rechange")
  ctr.notBuy = UIControl(ctr.transform, "notBuy")
end

function GoldDiamondRechargeTemp.OnRechargeItemRefresh(ctr, index, rewardData, ui)
  local data = rewardData.tableData
  ctr.rechargePrice:SetText(string.format("%sVND", math.ceil(data.rmb / 100)))
  local diamondItem = RechargeData.GetItemIdAndCount(data.diamond)
  ctr.goodsCount:SetText(diamondItem[1].count)
  local iconStr = ClientTable.cfg_Item_itemManager:TryGetValue(diamondItem[1].itemId, "id").icon
  GoldDiamondRechargeTemp.ParPanel:SetSprite(atlasStr, iconStr, ctr.diamondParent, false)
  GoldDiamondRechargeTemp.ParPanel:SetSprite("Atlas_Main", data.title, ctr.item_Picture, true)
  ctr.item_FirstRewardInfor.gameObject:SetActive(not (rewardData.RechargeCount > 0))
  ctr.notBuy.gameObject:SetActive(rewardData.RechargeCount > 0)
  ctr.rechargebtn.gameObject:SetActive(rewardData.RechargeCount <= 0)
  if 0 < data.reward then
    local rewardInfors = RechargeData.GetItemIdAndCount(data.reward)
    if #rewardInfors == 1 and rewardInfors[1].itemId == 1000030 then
      ctr.item_GemReward.gameObject:SetActive(true)
      ctr.item_FristReward.gameObject:SetActive(false)
      SetItemImage(rewardInfors[1].itemId, ctr.img_GemRewardIcon)
      ctr.lab_GemRewardnum:SetText(rewardInfors[1].count)
    else
      ctr.item_GemReward.gameObject:SetActive(false)
      ctr.item_FristReward.gameObject:SetActive(true)
      local info = CommercializeData.CurrentOccupation(rewardInfors)
      ctr.rewardContainer:SetDataKTable(info)
    end
  end
  ctr.item_btn_Buy:SetOnClick(ctr.item_btn_Buy, function()
    local PayType = ui.BusinessPayType and ui.BusinessPayType or BusinessPayType.None
    DataToCSharpMgr.Pay({
      amount = math.ceil(data.rmb / 100),
      product_Id = data.id,
      product_name = data.name,
      BusinessPayType = PayType
    })
  end)
end

function GoldDiamondRechargeTemp:Onbtn_receiveClick()
  local giftid = ClientTable.cfg_Commerce_globalManager:GetGoldDiamondGiftid()
  networkRequest.ReqGetGift(giftid)
end

function GoldDiamondRechargeTemp:Exit()
end

return GoldDiamondRechargeTemp
