FloatingWordUtility = {}
local this = FloatingWordUtility
local MSG_Maxlimit = 7
this.MSG_Time = 3.5
this.Fade_Time = 0.8
this.MSG_Height = 20
local TipFloatTipUIPool = Stack:New()
this.TipFloatTipUIList = List:New()
local TipFloatTipUI, TipFloatTipText

local function PoolGet()
  local TipFloatTip
  if TipFloatTipUIPool:Count() > 0 then
    TipFloatTip = TipFloatTipUIPool:Pop()
  end
  if TipFloatTip == nil then
    local item
    local go = CS.UnityEngine.GameObject.Instantiate(TipFloatTipText.gameObject, TipFloatTipText.transform.parent, false)
    go.name = TipFloatTipText.gameObject.name
    item = UIControl()
    item.transform = go.transform
    item.transform:SetAsLastSibling()
    TipFloatTip = item
  end
  TipFloatTip.transform:SetLocalPosition(0, 0, 0)
  TipFloatTip.gameObject:SetActive(true)
  return TipFloatTip
end

local function ShowMsg(msgStr)
  if TipFloatTipUI.activeSelf == false then
    TipFloatTipUI:SetActive(true)
  end
  
  local function Moveup(tip)
    local tipTF = tip.transform
    local startPosX, startPosY, startPosZ = tipTF:GetLocalPosition()
    tipTF:SetLocalPosition(startPosX, startPosY + this.MSG_Height, startPosZ)
  end
  
  this.TipFloatTipUIList:ForEach(Moveup)
  if this.TipFloatTipUIList:Count() >= MSG_Maxlimit then
    local toptip = this.TipFloatTipUIList:PopUp()
    TipFloatTipUI:StopAnimate(toptip)
    this.PoolDelete(toptip)
  end
  local TipFloatTip = PoolGet()
  this.TipFloatTipUIList:Add(TipFloatTip)
  TipFloatTipUI:StartAnimate(msgStr, TipFloatTip)
end

function FloatingWordUtility.PoolDelete(ctr)
  ctr.gameObject:SetActive(false)
  TipFloatTipUIPool:Push(ctr)
end

local function OnInit(msgStr)
  if not TipFloatTipText then
    TipFloatTipUI = UIManager.GetUiByName(UIID.TipFloatTipUI)
    if TipFloatTipUI == nil then
      return
    end
    TipFloatTipText = TipFloatTipUI.ProgramText
    if not TipFloatTipText then
      return
    end
    if IsNil(TipFloatTipText.gameObject) == true then
      TipFloatTipText = nil
      logError("Kh\195\180ng t\195\172m th\225\186\165y m\195\180-\196\145un hi\225\187\135u \225\187\169ng ch\225\187\175 n\225\187\149")
      return
    end
  end
  ShowMsg(msgStr)
end

function FloatingWordUtility.QuickMsg(msgStr)
  FloatingWordUtility.MaxMsgFilterList(msgStr)
end

FloatingWordUtility.PushMsgTime = nil
FloatingWordUtility.PushMsgWaitTime = 300
FloatingWordUtility.msgQueue = nil

function FloatingWordUtility.MaxMsgFilterList(msgStr)
  if FloatingWordUtility.msgQueue == nil then
    FloatingWordUtility.msgQueue = Queue:New()
  end
  if FloatingWordUtility.msgQueue:Count() >= MSG_Maxlimit then
    FloatingWordUtility.msgQueue:PopFirst()
  end
  FloatingWordUtility.msgQueue:PushLast(msgStr)
  FloatingWordUtility.PushMsgTime = Time.GetServerTime() + FloatingWordUtility.PushMsgWaitTime
end

function FloatingWordUtility.Update()
  if FloatingWordUtility.PushMsgTime == nil or FloatingWordUtility.msgQueue == nil or FloatingWordUtility.msgQueue:Count() <= 0 or Time == nil then
    return
  end
  local time = Time.GetServerTime()
  if type(time) ~= "number" or time > FloatingWordUtility.PushMsgTime or math.abs(time - FloatingWordUtility.PushMsgTime) > 100 then
    return
  end
  while not FloatingWordUtility.msgQueue:IsEmpty() do
    OnInit(FloatingWordUtility.msgQueue:PopFirst())
  end
end

function FloatingWordUtility.UIWordQuickMsg(id)
  local msgStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(id)
  this.QuickMsg(msgStr)
end

this.MSG_BtnTime = 2
local MsG_BtnLastParent

local function GetBtnMsgPos(args)
  local sizedata = args.parent.rectTransform.sizeDelta
  args.PosY = sizedata.y / 2
  args.parent = args.parent.transform
end

function FloatingWordUtility.QuickBtnMsg(args)
  GetBtnMsgPos(args)
  UIManager.Hide(UIID.TipDefectPromptTipUI)
  UIManager.Show(UIID.TipDefectPromptTipUI, args)
  MsG_BtnLastParent = args.parent
end

function FloatingWordUtility.GetParentBtnMsg(msg, worConfig)
  local UIName = worConfig.uiName
  local uiAddress = worConfig.uiAddress
  local Parent
  if UIManager.IsVisible(UIName) then
    Parent = UIManager.GetUiByName(UIName)
    if Parent[uiAddress] then
      local args = {
        parent = Parent[uiAddress],
        msgStr = msg
      }
      this.QuickBtnMsg(args)
    else
      logPurple("Serverbut_Tip___" .. UIName .. "..." .. uiAddress .. "___btn is nil!!!")
    end
  else
    logPurple("Serverbut_Tip___" .. UIName .. "___turn off!!!")
  end
end

function FloatingWordUtility.RemoveProps(itemData)
  local removetip = string.GetColorText("Ti\195\170u hao ", "#ED2E2E") .. string.GetColorText(itemData.tblItem.name, ItemQuality2ColorDic[itemData.tblItem.quality])
  removetip = removetip .. "*" .. itemData.count
  if itemData.count ~= 0 then
    this.QuickMsg(removetip)
  end
end

function FloatingWordUtility.GetProps(itemData)
  local removetip = "Nh\225\186\173n " .. string.GetColorText(itemData.tblItem.name, ItemQuality2ColorDic[itemData.tblItem.quality])
  removetip = removetip .. "*" .. itemData.count
  this.QuickMsg(removetip)
end
