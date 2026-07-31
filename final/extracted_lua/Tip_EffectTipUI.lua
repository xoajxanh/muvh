Tip_EffectTipUI = class(BaseUI)
Tip_EffectTipUI.layer = UILayer.Panel
Tip_EffectTipUI.orderInLayer = 5
Tip_EffectTipUI.hideType = UIHideType.WaitDestroy
Tip_EffectTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_EffectTipUI.escClose = UIEscClose.DontClose

function Tip_EffectTipUI:InitControls()
  self.Eff_UI_qianghuachenggong = self:GetControl("Eff_UI_qianghuachenggong")
  self.Eff_UI_qianghuashibai = self:GetControl("Eff_UI_qianghuashibai")
  self.Eff_UI_zhuijiachenghong = self:GetControl("Eff_UI_zhuijiachenghong")
  self.Eff_UI_zhuijiashibai = self:GetControl("Eff_UI_zhuijiashibai")
  self.Eff_UI_xingyunchenggong = self:GetControl("Eff_UI_xingyunchenggong")
  self.Eff_UI_Ornamentchenggong = self:GetControl("Eff_UI_Ornamentchenggong")
  self.Eff_UI_Breachchenggong = self:GetControl("Eff_UI_Breachchenggong")
  self.Eff_UI_xuexijinneg = self:GetControl("Eff_UI_xuexijinneg")
  self.Eff_UI_jinnengshengji = self:GetControl("Eff_UI_jinnengshengji")
  self.Eff_UI_huiyuandengjitisheng = self:GetControl("Eff_UI_huiyuandengjitisheng")
  self.Eff_UI_chongwuqianghua = self:GetControl("Eff_UI_chongwuqianghua")
  self.Eff_UI_zhanmenshengji = self:GetControl("Eff_UI_zhanmenshengji")
  self.Eff_UI_xilianchenggong = self:GetControl("Eff_UI_xilianchenggong")
  self.Eff_UI_zaishengjinhuachenggong = self:GetControl("Eff_UI_zaishengjinhuachenggong")
  self.Eff_UI_zaishengjinhuashibai = self:GetControl("Eff_UI_zaishengjinhuashibai")
  self.regenerateBg = self:GetControl("regenerateBg")
  self.Eff_UI_shenghunchenggong = self:GetControl("Eff_UI_shenghunchenggong")
  self.Eff_UI_kongweijiesuo = self:GetControl("Eff_UI_kongweijiesuo")
end

function Tip_EffectTipUI:OnPreLoad()
end

function Tip_EffectTipUI:Init()
  self.effectObj = {}
  self.effectNameForIndex = {}
  self.eventContainer = EventContainer(EventManager)
end

function Tip_EffectTipUI:OnCreate()
  self:InitAllEffect()
  self:RegistUIEvents()
end

function Tip_EffectTipUI:InitAllEffect()
  local name
  for k, v in pairs(self.root.transform) do
    name = v.name
    self[name] = self:GetControl(name)
    if self[name] ~= nil and self[name].SetActive ~= nil then
      self[name]:SetActive(false)
    end
    table.insert(self.effectObj, self[name])
    self.effectNameForIndex[name] = k + 1
  end
end

function Tip_EffectTipUI:InitUI()
  table.insert(self.effectObj, self.Eff_UI_qianghuachenggong)
  table.insert(self.effectObj, self.Eff_UI_qianghuashibai)
  table.insert(self.effectObj, self.Eff_UI_zhuijiachenghong)
  table.insert(self.effectObj, self.Eff_UI_zhuijiashibai)
  table.insert(self.effectObj, self.Eff_UI_xingyunchenggong)
  table.insert(self.effectObj, self.Eff_UI_Ornamentchenggong)
  table.insert(self.effectObj, self.Eff_UI_Breachchenggong)
  table.insert(self.effectObj, self.Eff_UI_xuexijinneg)
  table.insert(self.effectObj, self.Eff_UI_jinnengshengji)
  table.insert(self.effectObj, self.Eff_UI_huiyuandengjitisheng)
  table.insert(self.effectObj, self.Eff_UI_chongwuqianghua)
  table.insert(self.effectObj, self.Eff_UI_zhanmenshengji)
  table.insert(self.effectObj, self.Eff_UI_xilianchenggong)
  table.insert(self.effectObj, self.Eff_UI_zaishengjinhuachenggong)
  table.insert(self.effectObj, self.Eff_UI_zaishengjinhuashibai)
  table.insert(self.effectObj, self.regenerateBg)
  table.insert(self.effectObj, self.Eff_UI_shenghunchenggong)
  table.insert(self.effectObj, self.Eff_UI_kongweijiesuo)
  for k, v in pairs(self.effectObj) do
    self.effectNameForIndex[v.path] = k
  end
end

function Tip_EffectTipUI:OnShow()
  self.effectIndex = self.args.effectIndex
  self.effectTime = self.args.effectTime
  self.effectActive = self.args.effectActive
  self.doMoveStartPos = self.args.doMoveStartPos
  self.doMoveTagetPos = self.args.doMoveTagetPos
  if self.effectIndex == nil and self.args.name ~= nil then
    self.effectIndex = self.effectNameForIndex[self.args.name]
  end
  self:RegistEvents()
  self:Refresh()
end

function Tip_EffectTipUI:OnHide()
  for i = 1, table.count(self.effectObj) do
    if self.effectObj[i]:GetActive() then
      self.effectObj[i]:SetActive(false)
    end
  end
end

function Tip_EffectTipUI:OnDestroy()
end

function Tip_EffectTipUI:RegistUIEvents()
  for k, v in pairs(self.effectObj) do
    v:SetOnClick(self, self.EffectBgOnClick)
  end
end

function Tip_EffectTipUI:EffectBgOnClick(control)
  if self.hideEffectCoroutine ~= nil then
    Coroutine.Stop(self.hideEffectCoroutine)
    self.hideEffectCoroutine = nil
  end
  control:SetActive(false)
end

function Tip_EffectTipUI:RegistEvents()
  self.eventContainer:Regist(Event.TipEffect, self.EffectRefresh, self)
  self.eventContainer:Regist(Event.TipEffectHide, self.OnHide, self)
end

function Tip_EffectTipUI:Refresh()
  if self.hideEffectCoroutine ~= nil then
    Coroutine.Stop(self.hideEffectCoroutine)
    self.hideEffectCoroutine = nil
  end
  for i = 1, table.count(self.effectObj) do
    if self.effectObj[i]:GetActive() and ClientTable.cfg_Global_globalManager:IsSpecialActiveEffect(self.effectObj[i].path) == false then
      self.effectObj[i]:SetActive(false)
    end
  end
  if self.effectIndex ~= nil and self.effectIndex <= table.count(self.effectObj) then
    self:EffectOrderLayerSet(self.effectObj[self.effectIndex], 1000)
    self.effectObj[self.effectIndex]:SetActive(true)
    if self.effectTime and self.doMoveStartPos and self.doMoveTagetPos then
      self.effectObj[self.effectIndex].transform:SetLocalPosition(self.doMoveStartPos.x or 0, self.doMoveStartPos.y or 0, self.doMoveStartPos.z or 0)
      self.effectObj[self.effectIndex].transform:DOLocalMove(Vector3(self.doMoveTagetPos.x or 0, self.doMoveTagetPos.y or 0, self.doMoveTagetPos.z or 0), self.effectTime):SetEase(Ease.OutQuart):OnComplete(function()
        self.effectObj[self.effectIndex].transform:DOLocalMove(Vector3(self.doMoveStartPos.x or 0, self.doMoveStartPos.y or 0, self.doMoveStartPos.z or 0), 0.2)
      end)
    end
    if self.effectTime then
      self.hideEffectCoroutine = Coroutine.Start(self.WaitTimeHideEffectAsync, self)
    end
    if self.effectActive ~= nil and self.effectTime == nil then
      self.effectObj[self.effectIndex]:SetActive(self.effectActive)
    end
  end
end

function Tip_EffectTipUI:WaitTimeHideEffectAsync()
  Coroutine.Wait(self.effectTime)
  self.effectObj[self.effectIndex]:SetActive(false)
end

function Tip_EffectTipUI:EffectRefresh(id, msg)
  self.effectIndex = msg.index
  self.effectTime = msg.effectTime
  self.effectActive = msg.effectActive
  self.doMoveStartPos = msg.doMoveStartPos
  self.doMoveTagetPos = msg.doMoveTagetPos
  if self.effectIndex == nil and msg.name ~= nil then
    self.effectIndex = self.effectNameForIndex[msg.name]
  end
  self:Refresh()
end

function Tip_EffectTipUI:EffectOrderLayerSet(go, layer)
  local particles = go.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  if particles then
    for i = 0, particles.Length - 1 do
      local renderer = particles[i].gameObject:GetComponent(typeof(CS.UnityEngine.Renderer))
      if renderer then
        renderer.sortingOrder = layer
      end
    end
  end
end
