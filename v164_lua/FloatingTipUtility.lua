FloatingTipUtility = {}
local this = FloatingTipUtility
local MSG_Maxlimit = 3
this.MSG_Time = 3.5
this.Fade_Time = 0.1
this.MSG_Height = 50
local TipFloatExpTipUIPool = Stack:New()
this.TipFloatTipUIList = List:New()
local Tip_FloatTipTwoUI, TipFloatTipText

local function PoolGet()
  local TipFloatTip
  if TipFloatExpTipUIPool:Count() > 0 then
    TipFloatTip = TipFloatExpTipUIPool:Pop()
  end
  if TipFloatTip == nil then
    local item
    local go = CS.UnityEngine.GameObject.Instantiate(TipFloatTipText.gameObject, TipFloatTipText.transform.parent, false)
    go.name = TipFloatTipText.gameObject.name
    item = UIControl()
    item.transform = go.transform
    item.gameObject:SetActive(true)
    item.transform:SetAsLastSibling()
    TipFloatTip = item
  end
  TipFloatTip.transform:SetLocalPosition(0, 0, 0)
  TipFloatTip.gameObject:SetActive(true)
  return TipFloatTip
end

local function ShowMsg(msgStr)
  if Tip_FloatTipTwoUI.activeSelf == false then
    Tip_FloatTipTwoUI:SetActive(true)
  end
  
  local function Moveup(tip)
    local tipTF = tip.transform
    local startPosX, startPosY, startPosZ = tipTF:GetLocalPosition()
    tipTF:SetLocalPosition(startPosX, startPosY + this.MSG_Height, startPosZ)
  end
  
  this.TipFloatTipUIList:ForEach(Moveup)
  if this.TipFloatTipUIList:Count() >= MSG_Maxlimit then
    local toptip = this.TipFloatTipUIList:PopUp()
    Tip_FloatTipTwoUI:StopAnimate(toptip)
    this.PoolDelete(toptip)
  end
  local TipFloatTip = PoolGet()
  this.TipFloatTipUIList:Add(TipFloatTip)
  Tip_FloatTipTwoUI:StartAnimate(msgStr, TipFloatTip)
end

function FloatingTipUtility.PoolDelete(ctr)
  ctr.gameObject:SetActive(false)
  TipFloatExpTipUIPool:Push(ctr)
end

local function OnInit(msgStr)
  if not TipFloatTipText then
    Tip_FloatTipTwoUI = UIManager.GetUiByName(UIID.Tip_FloatTipTwoUI)
    if Tip_FloatTipTwoUI == nil then
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = msgStr,
        cancelText = "",
        okText = "",
        cancel = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        ok = function()
          UIManager.Hide(UIID.PromptTipUI)
        end
      })
      return
    end
    TipFloatTipText = Tip_FloatTipTwoUI.ProgramText
    if not TipFloatTipText then
      return
    end
    if IsNil(TipFloatTipText.gameObject) == true then
      TipFloatTipText = nil
      logError("Kh\195\180ng t\195\172m th\225\186\165y m\195\180-\196\145un kinh nghi\225\187\135m")
      return
    end
  end
  ShowMsg(msgStr)
end

function FloatingTipUtility.QuickMsg(msgStr)
  OnInit(msgStr)
end
