Tip_duoqiScoreUI = class(BaseUI)
Tip_duoqiScoreUI.layer = UILayer.Prompt
Tip_duoqiScoreUI.orderInLayer = 1
Tip_duoqiScoreUI.hideType = UIHideType.WaitDestroy
Tip_duoqiScoreUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_duoqiScoreUI.escClose = UIEscClose.DontClose

function Tip_duoqiScoreUI:InitControls()
  self.ProgramText = self:GetControl("ProgramText")
end

function Tip_duoqiScoreUI:OnPreLoad()
end

function Tip_duoqiScoreUI:Init()
end

function Tip_duoqiScoreUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self.sentences = {}
end

local stoptime = 0
local showingTips = 0
local removeLog = 0

function Tip_duoqiScoreUI:InitUI()
  stoptime = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2430009)) / 1000
end

function Tip_duoqiScoreUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_duoqiScoreUI:OnHide()
end

function Tip_duoqiScoreUI:OnDestroy()
end

function Tip_duoqiScoreUI:RegistUIEvents()
end

function Tip_duoqiScoreUI:RegistEvents()
  self:RegistEvent(Event.ScoreBubbleChange, self.OnBubbleChanged, self)
end

local this = Tip_duoqiScoreUI
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
    this.sentences = {}
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

local function ShowBubbleInfor(ui, inforTable)
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

function Tip_duoqiScoreUI:OnBubbleChanged(_, data)
  if next(data) ~= nil then
    local txt = QuickFind:GetDuoQiCrossDataManager():GetScoreStrByType(data.type)
    if txt == nil then
      return
    end
    table.insert(self.sentences, string.format(txt, data.score))
  end
  Coroutine.Start(ShowBubbleInfor, self, self.sentences)
end

function Tip_duoqiScoreUI:Refresh()
end
