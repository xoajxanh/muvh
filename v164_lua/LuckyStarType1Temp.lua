local LuckyStarType1Temp = {}

function LuckyStarType1Temp:Init(ParPanel)
  self.ParPanel = ParPanel
  self:InitControls()
  self:InitTemplate()
end

function LuckyStarType1Temp:InitControls()
  self.img_Bg = self:GetControl("img_Bg")
  self.btn_GoRewardList = self:GetControl("btn_GoRewardList")
  self.img_name = self:GetControl("img_name")
  self.desc = self:GetControl("LuckyStarDes/desc")
  self.btn_recharge = self:GetControl("btn_recharge")
  self.tip = self:GetControl("btn_recharge/tip")
  self.lb_time = self:GetControl("lb_time")
  self.btn_3DItem = self:GetControl("btn_3DItem")
end

function LuckyStarType1Temp:InitTemplate()
end

function LuckyStarType1Temp:Refresh(data)
  if data == nil then
    return
  end
  self.data = data
  local des = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(tostring(data.des))
  self.desc:SetText(string.format(des, data.deadlineshow))
  self:ShowBuyBtn()
  self.btn_GoRewardList:SetOnClick(self, self.OnWinnerListClick)
  self:ShowTime()
  self:ShowItem()
end

function LuckyStarType1Temp:ShowItem()
  local boxcfgs = ClientTable.cfg_Box_boxManager:TryGetTabListByType(self.data.boxId, "boxId")
  local boxcfg
  for i, v in pairs(boxcfgs) do
    if v.condition == nil or ConditionManager.Check4D(v.condition) then
      boxcfg = v
      break
    end
  end
  if boxcfg == nil then
    self.btn_3DItem:SetActive(false)
    return
  end
  if self.showCellData == nil then
    self.showCellData = ItemCellData()
  end
  local itemData = ItemUtility.GenerateItemData(boxcfg.itemId)
  itemData.count = 1
  self.showCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.showCellData, nil, true)
end

function LuckyStarType1Temp:RechargeOnClick()
  RechargeData.LuckyStarData:BuyReward(self.data)
end

function LuckyStarType1Temp:ShowBuyBtn()
  local rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(self.data.rechargeid)
  local amount = rechargeCfg and rechargeCfg.rmb or 0
  if ConditionManager.Check4D(self.data.deadline) then
    if RechargeData.LuckyStarData:CheckIsBought(self.data) then
      self.tip:SetText("\196\144\195\163 mua")
      self.btn_recharge:SetSprite(self:GetSprite("Atlas_Common", "ty_btn_click_L_N_grey"))
      self.btn_recharge:SetOnClick(self, function()
      end)
    else
      self.tip:SetText("" .. math.floor(amount / 100) .. "VND")
      self.btn_recharge:SetSprite(self:GetSprite("Atlas_Common", "ty_btn_new_red_new"))
      self.btn_recharge:SetOnClick(self, self.RechargeOnClick)
    end
  else
    self.tip:SetText("" .. math.floor(amount / 100) .. "VND")
    self.btn_recharge:SetSprite(self:GetSprite("Atlas_Common", "ty_btn_click_L_N_grey"))
    self.btn_recharge:SetOnClick(self, function()
    end)
  end
end

function LuckyStarType1Temp:ShowTime()
  if self.timer then
    Timer.Stop(self.timer)
  end
  if ConditionManager.Check4D(self.data.deadline) then
    if RechargeData.LuckyStarData:CheckIsBought(self.data) then
      self.lb_time:SetText("\196\144\225\187\163i m\225\187\159 th\198\176\225\187\159ng")
    else
      local curTime = Time.GetServerSecondTime()
      local index = string.find(self.data.deadline[1][1][2], "-", 1, true)
      local endTime = TimeUtility.GetyearTimeStampBySubStr(self.data.deadline[1][1][2], index + 1)
      local showTime = endTime - curTime + 86400
      if 0 < showTime then
        self.lb_time:SetText("Th\225\187\157i gian c\195\178n: " .. TimeUtility.ShowNewTime(showTime))
        do
          local function UpdateTimer()
            self.lb_time:SetText("Th\225\187\157i gian c\195\178n: " .. TimeUtility.ShowNewTime(showTime))
          end
          
          self.timer = Timer.StartLoop(1, showTime, UpdateTimer)
        end
      end
    end
  elseif ConditionManager.Check4D(self.data.opentime) then
    self.lb_time:SetText("\196\144\225\187\163i k\225\187\179 sau")
  end
end

function LuckyStarType1Temp:GetSprite(atlasName, IconName)
  local atlasPath = string.format("Texture/%s.spriteatlas", atlasName)
  local request = CS.Framework.ResourceManager.LoadAsset(atlasPath, typeof(CS.UnityEngine.U2D.SpriteAtlas))
  local spriteAtlas = request.res
  return spriteAtlas:GetSprite(tostring(IconName))
end

function LuckyStarType1Temp:OnWinnerListClick()
  local id = 0
  if ConditionManager.Check4D(self.data.opentime) then
    id = self.data.id
  else
    id = self.data.id - 1
  end
  local lastCfg = ClientTable.cfg_Commerce_luckystarManager:TryGetValue(id)
  EventManager.Dispatch(Event.ShowRewardList, lastCfg)
end

function LuckyStarType1Temp:Exit()
  if self.timer then
    Timer.Stop(self.timer)
  end
  self.timer = nil
end

return LuckyStarType1Temp
