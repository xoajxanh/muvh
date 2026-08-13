local Activity_CombineFirstGift_ItemTemplates = {}

function Activity_CombineFirstGift_ItemTemplates:Init(ParPanel)
  self.ParPanel = ParPanel
  self:InitControls()
  self:InitTemplates()
  self:BindOnClick()
end

function Activity_CombineFirstGift_ItemTemplates:InitControls()
  self.lab_firstGistName = self:GetControl("lab_firstGistName")
  self.btn_Item = self:GetControl("go_firstGistItem/sw_ItemSecondary/Viewport/Content/btn_Item")
  self.lab_limitNum = self:GetControl("lab_limit/lab_limitNum")
  self.btn_freePrize = self:GetControl("btn_freePrize")
  self.lab_buy = self:GetControl("btn_freePrize/lab_buy")
  self.img_recommend = self:GetControl("img_recommend")
  self.img_sellOut = self:GetControl("img_sellOut")
end

function Activity_CombineFirstGift_ItemTemplates:InitTemplates()
  self.btn_ItemTemplate = UIUtility.BindUIContainerTemp(self.btn_Item, LuaComponentTemplates.UIItemTemplate, self.ParPanel, {isShowTips = true})
end

function Activity_CombineFirstGift_ItemTemplates:BindOnClick()
  self.btn_freePrize:SetOnClick(self, self.btn_freePrizeOnClick)
end

function Activity_CombineFirstGift_ItemTemplates:Refresh(data, ui)
  if data == nil then
    return
  end
  self.nowData = data
  local limitNumNumber = 0
  if QuickFind:GetCombineFirstGiftData() ~= nil then
    limitNumNumber = QuickFind:GetCombineFirstGiftData():GetItemBuydataRemainingTimes(data)
  end
  self.lab_firstGistName:SetText(data.title)
  self.img_recommend:SetActive(false)
  self.lab_limitNum:SetText(limitNumNumber .. "G\195\179i Qu\195\160")
  self.lab_buy:SetText(self:GetShowStrByNowData())
  self.btn_ItemTemplate:SetData(TableParse:GetBoxListChangeItemCountList(data.BoxItem))
  self.btn_freePrize:SetActive(limitNumNumber ~= 0)
  self.img_sellOut:SetActive(limitNumNumber == 0)
end

function Activity_CombineFirstGift_ItemTemplates:GetShowStrByNowData()
  if self.nowData == nil then
    return ""
  end
  local data = self.nowData
  local num = data.amount or 0
  local len = tostring(num):len()
  local showNum, suffix = num, ""
  if 4 <= len then
    showNum = num / 1000
    suffix = "K"
  end
  if data.type == 1 then
    return showNum .. suffix .. " KC"
  elseif data.type == 2 then
    local rmb = data.rmb or 0
    return 1000 <= rmb and rmb / 1000 .. "K VND" or rmb .. " VND"
  elseif data.type == 3 then
    return showNum .. suffix .. " V\195\160ng"
  end
  return ""
end

function Activity_CombineFirstGift_ItemTemplates:btn_freePrizeOnClick()
  if self.nowData == nil then
    return
  end
  if self.nowData.type == 2 then
    if self.nowData.rmb then
      local itemPrice = tonumber(self.nowData.rmb) / 100
      DataToCSharpMgr.Pay({
        amount = itemPrice,
        product_Id = self.nowData.itemBuyTable.id
      })
      NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
    end
  elseif self.nowData.type == 1 then
    local costArray = string.split(self.nowData.itemBuyTable.cost, "#")
    if #costArray == 2 then
      local costItemId = tonumber(costArray[1])
      local costItemNum = tonumber(costArray[2])
      local bagCount = BagInfoData.GetItemTotalCountByItemId(costItemId)
      if costItemNum > bagCount then
        RechargeData.BuyDiamond()
      else
        NetManager.Send(ItemBuyMessage.ReqBuy, {
          goodId = self.nowData.itemBuyTable.id,
          buyCount = 1
        })
      end
    else
      NetManager.Send(ItemBuyMessage.ReqBuy, {
        goodId = self.nowData.itemBuyTable.id,
        buyCount = 1
      })
    end
  elseif self.nowData.type == 3 then
    local costArray = string.split(self.nowData.itemBuyTable.cost, "#")
    if #costArray == 2 then
      local costItemId = tonumber(costArray[1])
      local costItemNum = tonumber(costArray[2])
      local bagCount = BagInfoData.GetItemTotalCountByItemId(costItemId)
      if costItemNum > bagCount then
        FloatingWordUtility.UIWordQuickMsg("CombineGift_JB")
      else
        NetManager.Send(ItemBuyMessage.ReqBuy, {
          goodId = self.nowData.itemBuyTable.id,
          buyCount = 1
        })
      end
    else
      NetManager.Send(ItemBuyMessage.ReqBuy, {
        goodId = self.nowData.itemBuyTable.id,
        buyCount = 1
      })
    end
  end
end

return Activity_CombineFirstGift_ItemTemplates
