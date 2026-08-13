local SevenDayGiftTargetRewardTemplate = {}

function SevenDayGiftTargetRewardTemplate:Init(rootUI)
  self:InitControls(rootUI)
end

function SevenDayGiftTargetRewardTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.lab_TargetNum = self:GetControl("lab_TargetNum")
  self.img_choose = self:GetControl("img_choose")
  self.rewardGet = self:GetControl("rewardGet")
end

function SevenDayGiftTargetRewardTemplate:InitContainer()
end

function SevenDayGiftTargetRewardTemplate:InitData()
end

function SevenDayGiftTargetRewardTemplate:BindUIEvent()
end

function SevenDayGiftTargetRewardTemplate:btn_ItemTargetOnClick()
  NetManager.Send(CommerceMessage.ReqSevenDaysGiftsReward, {
    configId = self.data.id
  })
end

function SevenDayGiftTargetRewardTemplate:Refresh(data, ui)
  self.data = data
  ItemUtility.ShowItemCellByItemId(data.rewardId, data.rewardCount, self.nowControl, ui, true)
  if data.state == GuardRewardStateEnum.CanGet then
    self.nowControl:SetOnClick(self, self.btn_ItemTargetOnClick)
  end
  local finishTaskCount = QuickFind:GetSevenDayGiftData():GetFinishTaskCount()
  local text = string.format("Ho\195\160n th\195\160nh (%d/%d) m\225\187\165c ti\195\170u", finishTaskCount, data.totalTaskNum)
  if data.state == GuardRewardStateEnum.NotGet then
    text = string.GetColorText(text, ItemQuality2ColorDic[11])
  else
    text = string.GetColorText(text, ItemQuality2ColorDic[5])
  end
  self.lab_TargetNum:SetText(text)
  self.img_choose:SetActive(data.state == GuardRewardStateEnum.CanGet)
  self.rewardGet:SetActive(data.state == GuardRewardStateEnum.Got)
end

function SevenDayGiftTargetRewardTemplate:ReleaseModel()
  if self.nowControl.itemCellData then
    ItemUtility.ReleaseItemCell(self.nowControl, self.nowControl.itemCellData)
  end
end

return SevenDayGiftTargetRewardTemplate
