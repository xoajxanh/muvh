FloatingExpUtility = {}
local this = FloatingExpUtility
local MSG_Maxlimit = 3
this.MSG_Time = 1
this.Fade_Time = 0.8
this.MSG_Height = 20
local TipFloatExpTipUIPool = Stack:New()
this.TipFloatTipUIList = List:New()
local TipFloatExpTipUI, TipFloatTipText

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
  if TipFloatExpTipUI.activeSelf == false then
    TipFloatExpTipUI:SetActive(true)
  end
  
  local function Moveup(tip)
    local tipTF = tip.transform
    local startPosX, startPosY, startPosZ = tipTF:GetLocalPosition()
    tipTF:SetLocalPosition(startPosX, startPosY + this.MSG_Height, startPosZ)
  end
  
  this.TipFloatTipUIList:ForEach(Moveup)
  if this.TipFloatTipUIList:Count() >= MSG_Maxlimit then
    local toptip = this.TipFloatTipUIList:Top()
    this.TipFloatTipUIList:RemoveAt(1)
    TipFloatExpTipUI:StopAnimate(toptip)
    TipFloatExpTipUI:OpenCorWaitDelete(toptip)
  end
  local TipFloatTip = PoolGet()
  this.TipFloatTipUIList:Add(TipFloatTip)
  TipFloatExpTipUI:StartAnimate(msgStr, TipFloatTip)
end

function FloatingExpUtility.PoolDelete(ctr)
  ctr.gameObject:SetActive(false)
  TipFloatExpTipUIPool:Push(ctr)
end

local function OnInit(msgStr)
  if not TipFloatTipText then
    TipFloatExpTipUI = UIManager.GetUiByName(UIID.TipFloatExpTipUI)
    if TipFloatExpTipUI == nil then
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
    TipFloatTipText = TipFloatExpTipUI.ProgramText
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

function FloatingExpUtility.QuickMsg(msgStr)
  OnInit(msgStr)
end
