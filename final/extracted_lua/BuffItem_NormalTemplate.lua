local BuffItem_NormalTemplate = {}
BuffItem_NormalTemplate.baseUI = nil
BuffItem_NormalTemplate.buffStruct = nil
BuffItem_NormalTemplate.buffCallBack = nil

function BuffItem_NormalTemplate:Init()
  self:InitComponent()
  self:InitEvent()
end

function BuffItem_NormalTemplate:InitComponent()
  self.lab_buff = self:GetControl("lab_buff")
  self.img_mask = self:GetControl("img_mask")
  self.img_buff = self:GetControl("img_buff")
  self.lab_buffNum = self:GetControl("lab_buffNum")
  self.lab_num = self:GetControl("lab_num")
end

function BuffItem_NormalTemplate:InitEvent()
  self:UIControl():SetOnClick(self, self.BuffClickCallBack)
end

function BuffItem_NormalTemplate:BuffClickCallBack()
  if self.buffCallBack == nil then
    return
  end
  self:UIControl().data = self.buffStruct
  self.buffCallBack(self.baseUI, self:UIControl())
end

function BuffItem_NormalTemplate:Refresh(data, ui)
  if self:AnalysisParams(data, ui) == false then
    return
  end
  self:RefreshIcon()
  self:RefreshName()
  self:RefreshMask()
  self:RefreshNum()
end

function BuffItem_NormalTemplate:AnalysisParams(data, ui)
  if data == nil or ui == nil then
    return false
  end
  self.baseUI = ui
  self.buffStruct = data
  self.buffCallBack = ui.btn_buffOnClick
  return true
end

function BuffItem_NormalTemplate:RefreshIcon()
  if self.buffStruct == nil or self.buffStruct.buffConfig == nil or self.baseUI == nil or IsNil(self.img_buff.gameObject) then
    return
  end
  if self.buffIconLoader ~= nil then
    Coroutine.Stop(self.buffIconLoader)
  end
  self.buffIconLoader = self.baseUI:SetSprite("Atlas_Buff", self.buffStruct.buffConfig.icon, self.img_buff)
end

function BuffItem_NormalTemplate:RefreshName()
  if self.buffStruct == nil or self.buffStruct.buffConfig == nil or IsNil(self.lab_buff.text) then
    return
  end
  self.lab_buff:SetText(self.buffStruct.buffConfig.name)
end

function BuffItem_NormalTemplate:RefreshMask()
  if self.buffStruct == nil or self.buffStruct.buffConfig == nil or IsNil(self.img_mask.gameObject) then
    return
  end
  if self.buffStruct.totalTime > 0 then
    self.img_mask:SetActive(true)
    self.img_mask:SetFillAmount(1 - self.buffStruct.time / self.buffStruct.totalTime)
  else
    self.img_mask:SetActive(false)
  end
end

function BuffItem_NormalTemplate:RefreshNum()
  if self.buffStruct == nil or self.buffStruct.buffConfig == nil or IsNil(self.lab_buffNum.text) or IsNil(self.lab_num.text) then
    return
  end
  local buffOverlayNum = ""
  if type(self.buffStruct.overlayNum) == "number" and self.buffStruct.overlayNum > 1 then
    buffOverlayNum = self.buffStruct.overlayNum
  end
  self.lab_buffNum:SetText(buffOverlayNum)
  local buffCount = ""
  if type(self.buffStruct.count) == "number" and 1 < self.buffStruct.count then
    buffCount = self.buffStruct.count
  end
  self.lab_num:SetText(buffCount)
end

function BuffItem_NormalTemplate:ChangeNum(buffStruct)
  if self:IsSameBuff(buffStruct) == false then
    return
  end
  self.buffStruct = buffStruct
  self:RefreshNum()
end

function BuffItem_NormalTemplate:ChangeMask(buffStruct)
  if self:IsSameBuff(buffStruct) == false then
    return
  end
  self.buffStruct = buffStruct
  self:RefreshMask()
end

function BuffItem_NormalTemplate:IsSameBuff(buffStruct)
  return buffStruct.buffId == self.buffStruct.buffId
end

return BuffItem_NormalTemplate
