Tip_AttrChangeUI = class(BaseUI)
Tip_AttrChangeUI.layer = UILayer.Prompt
Tip_AttrChangeUI.orderInLayer = 1
Tip_AttrChangeUI.hideType = UIHideType.WaitDestroy
Tip_AttrChangeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_AttrChangeUI.escClose = UIEscClose.DontClose

function Tip_AttrChangeUI:InitControls()
  self.ProgramText = self:GetControl("ProgramText")
end

function Tip_AttrChangeUI:OnPreLoad()
end

function Tip_AttrChangeUI:Init()
end

local originPos

function Tip_AttrChangeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self.changeAttribute = {}
end

local intervalTime = 0
local stoptime = 0
local showingTips = 0
local removeLog = 0

function Tip_AttrChangeUI:InitUI()
  intervalTime = ClientTable.cfg_Global_globalManager:TryGetValue(2430007, "id").effect / 1000
  stoptime = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2430009)) / 1000
  originPos = self.ProgramText.transform.anchoredPosition
end

function Tip_AttrChangeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_AttrChangeUI:OnHide()
end

function Tip_AttrChangeUI:OnDestroy()
end

function Tip_AttrChangeUI:RegistUIEvents()
end

function Tip_AttrChangeUI:RegistEvents()
  self:RegistEvent(Event.Role_MyAttributeChanged, self.OnMyAttributeChanged, self)
  self:RegistEvent(Event.Tip_AddLeftMiddleFloatTip, self.AddLeftMiddleFloatTip, self)
end

local this = Tip_AttrChangeUI
local animaTime = 0.2

local function TextLifeCycle(textItem)
  local graphics = textItem:GetComponentsInChildren(typeof(CS.UnityEngine.UI.MaskableGraphic))
  for i = 0, graphics.Length - 1 do
    graphics[i].color = Color.New(graphics[i].color.r, graphics[i].color.g, graphics[i].color.b, 0)
    if i == 0 then
      graphics[i]:DOFade(0.5, animaTime * 2)
    else
      graphics[i]:DOFade(1, animaTime * 2)
    end
  end
  Coroutine.Wait(stoptime)
  for i = 0, graphics.Length - 1 do
    if i == 0 then
      graphics[i]:DOFade(0, animaTime * 2)
    else
      graphics[i]:DOFade(0, animaTime * 2)
    end
  end
  Coroutine.Wait(0.4)
  removeLog = removeLog + 1
  if removeLog == showingTips then
    removeLog = 0
    showingTips = 0
    this.changeAttribute = {}
  end
  textItem.gameObject:SetActive(false)
end

local function GetLeaveUnusedObj(ui)
  for i = 1, ui.root.transform.childCount - 1 do
    local child = ui.root.transform:GetChild(i)
    if not child.gameObject.activeSelf then
      return child
    end
  end
  local item = Instantiate(ui.ProgramText.transform)
  item:SetParent(ui.root.transform)
  item.localPosition = Vector3.zero
  item.localScale = Vector3.one
  return item
end

local function ShowChangeAttributInfor(ui, inforTable)
  while showingTips < #inforTable do
    local item = GetLeaveUnusedObj(ui)
    showingTips = showingTips + 1
    item.gameObject:SetActive(true)
    item:GetComponentInChildren(typeof(CS.UnityEngine.UI.Text)).text = inforTable[showingTips]
    local size = item.sizeDelta
    item.anchoredPosition = -Vector2.up * ((size.y + 5) * (showingTips % 10) - size.y / 2 - 5)
    Coroutine.Yield(animaTime / 2)
    Coroutine.Start(TextLifeCycle, item)
  end
end

local lastMoment = 0
local minimumPhysBaseDmg = 0
local maximumPhysBaseDmg = 0
local minimumWizBaseDmg = 0
local maximumWizBaseDmg = 0
local minimumCurseBaseDmg = 0
local maximumCurseBaseDmg = 0

local function AddInfor(inforTbl, changeItem, attributeKey)
  local attStr
  local increment = changeItem
  if 0 < increment then
    attStr = AttributeWordUtil.GetUIWord(attributeKey, "AttrChangeUI")
    table.insert(inforTbl, string.format(attStr, increment))
  end
end

function Tip_AttrChangeUI:OnMyAttributeChanged(_, changeList, refreshType)
  if refreshType == EAttributeProviderSystem.Buff or refreshType == 666 then
    return
  end
  for k, v in pairs(changeList) do
    if k == EAttributeType.maximumHealth then
      AddInfor(self.changeAttribute, v, "maximumHealth")
    elseif k == EAttributeType.maximumMana then
      AddInfor(self.changeAttribute, v, "maximumMana")
    elseif k == EAttributeType.maximumShield and ViewData.meData.hasShield then
      AddInfor(self.changeAttribute, v, "maximumShield")
    elseif k == EAttributeType.minimumPhysBaseDmg then
      minimumPhysBaseDmg = v
    elseif k == EAttributeType.maximumPhysBaseDmg then
      maximumPhysBaseDmg = v
    elseif k == EAttributeType.minimumWizBaseDmg then
      minimumWizBaseDmg = v
    elseif k == EAttributeType.maximumWizBaseDmg then
      maximumWizBaseDmg = v
    elseif k == EAttributeType.minimumCurseBaseDmg then
      minimumCurseBaseDmg = v
    elseif k == EAttributeType.maximumCurseBaseDmg then
      maximumCurseBaseDmg = v
    elseif k == EAttributeType.attackRatePvp then
      AddInfor(self.changeAttribute, v, "attackRatePvm")
    elseif k == EAttributeType.defenseBase then
      AddInfor(self.changeAttribute, v, "defenseBase")
    elseif k == EAttributeType.defenseRatePvm then
      AddInfor(self.changeAttribute, v, "defenseRatePvm")
    elseif k == EAttributeType.attackSpeedUI then
      AddInfor(self.changeAttribute, v, "attackSpeed")
    elseif k == EAttributeType.skillMultiplier then
      AddInfor(self.changeAttribute, v, "skillDamageBonus")
    elseif k == EAttributeType.zhuoyueAttribute then
      AddInfor(self.changeAttribute, v, "zhuoyueAttribute")
    end
  end
  if 0 < minimumPhysBaseDmg or 0 < maximumPhysBaseDmg then
    table.insert(self.changeAttribute, string.format(AttributeWordUtil.GetUIWord("physBaseDmgRange", "AttrChangeUI"), minimumPhysBaseDmg, maximumPhysBaseDmg))
  end
  if 0 < minimumWizBaseDmg or 0 < maximumWizBaseDmg then
    table.insert(self.changeAttribute, string.format(AttributeWordUtil.GetUIWord("WizBaseDmgRange", "AttrChangeUI"), minimumWizBaseDmg, maximumWizBaseDmg))
  end
  if (minimumWizBaseDmg < 0 or maximumWizBaseDmg < 0) and QuickFind.LuaMainPlayerViewAttrData():GetBaseCareer() == ERoleCareer.SummonMagician then
    table.insert(self.changeAttribute, string.format(AttributeWordUtil.GetUIWord("WizBaseDmgRange", "AttrChangeUIR"), math.abs(minimumWizBaseDmg), math.abs(maximumWizBaseDmg)))
  end
  if (minimumCurseBaseDmg < 0 or maximumCurseBaseDmg < 0) and QuickFind.LuaMainPlayerViewAttrData():GetBaseCareer() == ERoleCareer.SummonMagician then
    table.insert(self.changeAttribute, string.format(AttributeWordUtil.GetUIWord("client_CurseBaseDmg", "AttrChangeUIR"), math.abs(minimumCurseBaseDmg), math.abs(maximumCurseBaseDmg)))
  end
  if (0 < minimumCurseBaseDmg or 0 < maximumCurseBaseDmg) and QuickFind.LuaMainPlayerViewAttrData():GetBaseCareer() == ERoleCareer.SummonMagician then
    table.insert(self.changeAttribute, string.format(AttributeWordUtil.GetUIWord("client_CurseBaseDmg", "AttrChangeUI"), minimumCurseBaseDmg, maximumCurseBaseDmg))
  end
  if self.beforeAttrChange then
    for i = 1, #self.beforeAttrChange do
      if not string.isNullOrEmpty(self.beforeAttrChange[i]) then
        table.insert(self.changeAttribute, self.beforeAttrChange[i])
      end
    end
    self.beforeAttrChange = nil
  end
  Coroutine.Start(ShowChangeAttributInfor, self, self.changeAttribute)
  minimumPhysBaseDmg = 0
  maximumPhysBaseDmg = 0
  minimumWizBaseDmg = 0
  maximumWizBaseDmg = 0
  minimumCurseBaseDmg = 0
  maximumCurseBaseDmg = 0
end

function Tip_AttrChangeUI:AddLeftMiddleFloatTip(_, content)
  self.beforeAttrChange = content
end

function Tip_AttrChangeUI:Refresh()
end
