local ExtraBuffItemsTemplate = {}
ExtraBuffItemsTemplate.buffStructList = nil
ExtraBuffItemsTemplate.stage = nil

function ExtraBuffItemsTemplate:Init()
  self:InitComponent()
end

function ExtraBuffItemsTemplate:InitComponent()
  self.btn_buffExtend = self:GetControl("btn_buffExtend")
end

function ExtraBuffItemsTemplate:InitEvent()
  self:UIControl():SetOnClick(self, self.SelfClickCallBack)
end

function ExtraBuffItemsTemplate:SelfClickCallBack()
  if self.stage == nil then
    self.stage = true
  end
  self:ChangeStage(not self.stage)
end

function ExtraBuffItemsTemplate:BindTemplate()
  if self.btn_buffExtend == nil then
    return
  end
  if self.btn_buffExtend.transform == nil then
    return
  end
  if self.btn_buffExtend.gameObject == nil then
    return
  end
  if IsNil(self.btn_buffExtend.gameObject) then
    return
  end
  if IsNil(self.btn_buffExtend.transform) then
    return
  end
  self.buffsTemplate = UIUtility.BindUIContainerTemp(self.btn_buffExtend, LuaComponentTemplates.BuffItem_NormalTemplate, self.baseUI)
end

function ExtraBuffItemsTemplate:Refresh(data)
  if self:AnalysisParams(data) == false then
    return
  end
  if self.buffsTemplate == nil then
    self:BindTemplate()
  end
  if self.buffsTemplate ~= nil then
    self.buffsTemplate:SetData(self.buffStructList)
  end
end

function ExtraBuffItemsTemplate:AnalysisParams(data)
  if data == nil or data.baseUI == nil or data.buffStructList == nil then
    return false
  end
  if self.btn_buffExtend == nil then
    return false
  end
  self.baseUI = data.baseUI
  self.buffStructList = data.buffStructList
  return true
end

function ExtraBuffItemsTemplate:RefreshSingleBuff(buffId)
  if self.buffsTemplate == nil then
    return
  end
  for k, v in pairs(self.buffsTemplate.items) do
    if IsNil(v) == false and v.itemTemp.buffStruct.buffCId == buffId then
      v.itemTemp:ChangeNum(v.itemTemp.buffStruct)
      v.itemTemp:ChangeMask(v.itemTemp.buffStruct)
    end
  end
end

function ExtraBuffItemsTemplate:AutoChangeStage()
  if self.stage == nil then
    self:ChangeStage(true)
  else
    self:ChangeStage(not self.stage)
  end
end

function ExtraBuffItemsTemplate:ChangeStage(stage)
  if stage == self.stage then
    return
  end
  self.stage = stage
  if self:UIControl() ~= nil then
    self:UIControl():SetActive(self.stage)
  end
end

return ExtraBuffItemsTemplate
