local RightMonsterList_SingleTemplate = {}
RightMonsterList_SingleTemplate.MapMonsterPointData = nil
RightMonsterList_SingleTemplate.HintEffect = nil
RightMonsterList_SingleTemplate.HintEffectShown = false
RightMonsterList_SingleTemplate.EffectInitPosition = nil

function RightMonsterList_SingleTemplate:Init()
  self:InitComponent()
  self:BindEvent()
  self.eventContainer = EventContainer(EventManager)
  self.eventContainer:Regist(Event.Role_OnChangeMap, self.OnChangeMap, self)
end

function RightMonsterList_SingleTemplate:InitComponent()
  self.lab_monsterNameControl = self:GetControl("lab_monsterName")
  self.lab_monsterOnKillControl = self:GetControl("lab_monsterOnKill")
  self.lab_monsterTimeControl = self:GetControl("lab_monsterTime")
  self.img_selectControl = self:GetControl("img_select")
  self.Eff_UI_annuikuang03 = self:GetControl("Eff_UI_annuikuang03")
  self.img_sign = self:GetControl("img_sign")
end

function RightMonsterList_SingleTemplate:BindEvent()
  self:UIControl():SetOnClick(self, function()
    EventManager.Dispatch(Event.RightMonsterEff, self.img_selectControl)
    self:FindPointOnClick()
    if self:HideEffect() then
      self.HintEffectShown = true
    end
  end)
end

function RightMonsterList_SingleTemplate:FindPointOnClick()
  if self.MapMonsterPointData == nil then
    return
  end
  self.MapMonsterPointData:RandomFindPoint()
end

function RightMonsterList_SingleTemplate:OnChangeMap(_)
  self.HintEffectShown = false
end

function RightMonsterList_SingleTemplate:Refresh(data, ui)
  self.MapMonsterPointData = data
  if data == nil or data:ShowPoint() == false then
    self:UIControl():SetActive(false)
    return
  end
  self:UIControl():SetActive(true)
  self.lab_monsterNameControl:SetText(data.customName or data:GetPointName())
  self.lab_monsterOnKillControl:SetText(data:GetFindPointName())
  self.lab_monsterTimeControl:SetActive(false)
  self.img_selectControl:SetActive(false)
  self.img_sign:SetActive(false)
  self:RefreshEffect()
end

function RightMonsterList_SingleTemplate:RefreshEffect()
  self:HideEffect()
  local showHintEffect, effParam = self.MapMonsterPointData:ShowHintEffect()
  if string.isNullOrEmpty(effParam) == false then
    self.HintEffect = self:GetControl(effParam)
    local isShow = not self.HintEffectShown and showHintEffect
    if self.HintEffect and not IsNil(self.HintEffect.transform) and isShow then
      self.HintEffect:SetActive(true)
      self:SetEffectAnimation(self.HintEffect:GetChild("img_guideSubmit").transform)
    end
  end
end

function RightMonsterList_SingleTemplate:HideEffect()
  local isShown = false
  if self.HintEffect and not IsNil(self.HintEffect.transform) then
    if self.HintEffect:GetActive() then
      isShown = true
    end
    self.HintEffect:SetActive(false)
  end
  return isShown
end

function RightMonsterList_SingleTemplate:SetEffectAnimation(transform)
  if self.EffectInitPosition then
    transform.localPosition = self.EffectInitPosition
  else
    self.EffectInitPosition = transform.localPosition
  end
  transform:DOKill()
  local left = false
  
  local function MoveLeft()
    transform:DOLocalMoveX(left and transform.localPosition.x - 10 or transform.localPosition.x + 10, 1):OnComplete(function()
      left = not left
      transform:DOLocalMoveX(left and transform.localPosition.x - 10 or transform.localPosition.x + 10, 1):OnComplete(function()
        left = not left
        MoveLeft()
      end)
    end)
  end
  
  MoveLeft()
end

return RightMonsterList_SingleTemplate
