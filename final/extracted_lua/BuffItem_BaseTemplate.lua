local BuffItem_BaseTemplate = {}

function BuffItem_BaseTemplate:Init()
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function BuffItem_BaseTemplate:InitParams()
  self.curCardInfo = nil
  self.lastCardInfo = nil
  self.accupdata = 300
  self.Intervals = 300
  self.fillAmount = 1
  self.isRefreshMask = false
  self.callEnded = false
  self:InitTemplateType()
end

function BuffItem_BaseTemplate:InitTemplateType()
  self.buffItemType = EBuffItemType.None
end

function BuffItem_BaseTemplate:InitControls()
  self.lab_buff = self:GetControl("lab_buff")
  self.img_icon = self:GetControl("img_icon")
  self.img_mask = self:GetControl("img_mask")
end

function BuffItem_BaseTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.ClickGoCallBack)
end

function BuffItem_BaseTemplate:ClickGoCallBack()
  if self.clickCallBack then
    self.clickCallBack(self.parentTbl, self.buffItemType)
  end
end

function BuffItem_BaseTemplate:InitTemplate(data)
  if data == nil then
    return
  end
  self.parentTbl = data.ui
  self.clickCallBack = data.clickCallBack
  self.timeEndCallBack = data.timeEndCallBack
  self.refreshCallBack = data.refreshCallBack
end

function BuffItem_BaseTemplate:Refresh(data, ui)
  if self:UIControl() == nil or IsNil(self:UIControl().gameObject) then
    return
  end
  if self:UIControl().gameObject.activeSelf then
    self:UIControl():SetActive(false)
  end
  self:RefreshData()
  local isNeedRefrsh, isNeedShow = self:CheckItemState()
  if isNeedRefrsh then
    self:RefreshView()
    self.isRefreshMask = true
    self.callEnded = false
  end
  if self:UIControl().gameObject.activeSelf ~= isNeedShow then
    EventManager.Dispatch(Event.SpecialBuffChange, isNeedShow)
    self:UIControl():SetActive(isNeedShow)
  end
end

function BuffItem_BaseTemplate:RefreshData()
  self.curCardInfo, self.iconStr = self:GetCardTipsInfo()
  if self.curCardInfo then
    self.accupdata = self.curCardInfo.totalTime / 10
    self.Intervals = self.curCardInfo.totalTime / 10
    self.totalTime = self.curCardInfo.totalTime
    self.endTime = self.curCardInfo.endTime
    self.isRefreshMask = true
  end
end

function BuffItem_BaseTemplate:RefreshView()
  if self.iconStr and self.parentTbl then
    self.parentTbl:SetSprite("Atlas_Buff", self.iconStr, self.img_icon)
  end
  if self.refreshCallBack ~= nil then
    self.refreshCallBack(self.parentTbl, self.buffItemType)
  end
end

function BuffItem_BaseTemplate:UpdataMaskView()
  if not self.isRefreshMask then
    return
  end
  if self.totalTime ~= nil and self.totalTime > 0 then
    self.accupdata = self.accupdata + Time.deltaTime
    if self.accupdata > self.Intervals then
      self.fillAmount = 1 - TimeUtility.RefreshSec(self.endTime) / self.totalTime
      self.img_mask:SetFillAmount(self.fillAmount)
      if self.fillAmount >= 1 then
        self.isRefreshMask = false
        self:TimeEndCallBack()
      end
      self.accupdata = 0
    end
  end
end

function BuffItem_BaseTemplate:TimeEndCallBack()
  if self.callEnded then
    return
  end
  self.callEnded = true
  if self.timeEndCallBack ~= nil then
    self.timeEndCallBack(self.parentTbl, self.buffItemType)
  end
  self:UIControl():SetActive(false)
  EventManager.Dispatch(Event.SpecialBuffChange, false)
end

function BuffItem_BaseTemplate:CheckItemState()
  if self.curCardInfo == nil then
    return false, false
  end
  if self.lastCardInfo ~= nil and self.lastCardInfo.id == self.curCardInfo.id and self.lastCardInfo.endTime == self.curCardInfo.endTime then
    return false, true
  end
  if self.lastCardInfo == nil then
    self.lastCardInfo = {}
  end
  self.lastCardInfo.id = self.curCardInfo.id
  self.lastCardInfo.endTime = self.curCardInfo.endTime
  return true, true
end

function BuffItem_BaseTemplate:GetCardTipsInfo()
  return nil, nil
end

return BuffItem_BaseTemplate
