local GoodReviewRewardTemplate = {}

function GoodReviewRewardTemplate:Init(data)
  self:InitControls()
  self:InitTemplates()
  self:InitUIEvents()
end

function GoodReviewRewardTemplate:InitControls()
  self.txt_introduce1 = self:GetControl("bg_goodComment/go_goodComment/img_prompt1/txt_introduce1")
  self.level_Item = self:GetControl("bg_goodComment/go_goodComment/go_gift/Viewport/grid_reward/level_Item")
  self.btn_go = self:GetControl("bg_goodComment/go_goodComment/btn_go")
  self.btn_getGift = self:GetControl("bg_goodComment/go_goodComment/btn_getGift")
  self.btn_received = self:GetControl("bg_goodComment/go_goodComment/btn_received")
end

function GoodReviewRewardTemplate:InitTemplates()
  self.rewardItemTemplate1 = UIUtility.BindUIContainerTemp(self.level_Item, LuaComponentTemplates.UIItemTemplate, self.root, {
    isShowTips = true,
    stencil = 2,
    maskType = 5
  })
end

function GoodReviewRewardTemplate:InitUIEvents()
  self.btn_go:SetOnClick(self, self.btn_goOnClick)
  self.btn_getGift:SetOnClick(self, self.btn_getGiftOnClick)
end

function GoodReviewRewardTemplate:btn_goOnClick()
  if not string.isNullOrEmpty(self.data.str) then
    Application.OpenURL(self.data.str)
  end
  if self.count > 0 then
    return
  elseif self.state then
    Coroutine.Start(function()
      Coroutine.Wait(3)
      self:ChangeBtnState(BtnState.Claim)
      Coroutine.WaitForEndOfFrame()
    end)
  else
    networkRequest.ReqGetGift({
      self.data.giftDate.id
    })
  end
end

function GoodReviewRewardTemplate:btn_getGiftOnClick()
  if self.state then
    self.timerCoroutine = Coroutine.Start(function()
      Coroutine.Wait(2)
      self.timerCoroutine = nil
      Coroutine.WaitForEndOfFrame()
    end)
    networkRequest.ReqGetGift({
      self.data.giftDate.id
    })
    self:ChangeBtnState(BtnState.Claimed)
  end
end

function GoodReviewRewardTemplate:Refresh(data, ui)
  if table.isNullOrEmpty(data) then
    return
  end
  self.data = data
  self.ui = ui
  self.count = RechargeData.GetCount(self.data.giftDate.countKey)
  local global = ClientTable.cfg_Global_globalManager:TryGetValue(72000001).effect
  self.state = self.data.id == tonumber(global)
  if self.state then
    if self.count > 0 then
      self:ChangeBtnState(BtnState.Claimed)
    else
      self:ChangeBtnState(BtnState.NotUnlocked)
    end
  end
  self.rewardItemTemplate1:SetData(self.data.Box)
end

function GoodReviewRewardTemplate:ChangeBtnState(state)
  if state == BtnState.NotUnlocked then
    self.btn_go:SetActive(true)
    self.btn_getGift:SetActive(false)
    self.btn_received:SetActive(false)
  elseif state == BtnState.Claim then
    self.btn_go:SetActive(false)
    self.btn_getGift:SetActive(true)
    self.btn_received:SetActive(false)
  elseif state == BtnState.Claimed then
    self.btn_go:SetActive(false)
    self.btn_getGift:SetActive(false)
    self.btn_received:SetActive(true)
  end
end

return GoodReviewRewardTemplate
