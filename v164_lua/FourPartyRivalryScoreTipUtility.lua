FourPartyRivalryScoreTipUtility = {}
FourPartyRivalryScoreTipUtility.m_MSGTime = 3.5
FourPartyRivalryScoreTipUtility.m_FadeTime = 0.2
FourPartyRivalryScoreTipUtility.m_MaxCount = 3
FourPartyRivalryScoreTipUtility.m_ItemHeight = 50
FourPartyRivalryScoreTipUtility.m_Tip_FourPartyRivalryScoreUI = nil
FourPartyRivalryScoreTipUtility.m_Tip_FourPartyRivalryScoreProgramText = nil
FourPartyRivalryScoreTipUtility.m_ProgramTextPool = Stack:New()
FourPartyRivalryScoreTipUtility.m_ProgramTextList = List:New()
FourPartyRivalryScoreTipUtility.m_MessageList = {}

function FourPartyRivalryScoreTipUtility:ResSiFangGetScoreMessage(_tblData)
  if _tblData == nil then
    return
  end
  self:StopCoroutine()
  if _tblData.playerScore and _tblData.playerScore > 0 then
    table.insert(self.m_MessageList, string.format(LocalizationUtility.GetContentByKey("fourPartyRivalryPlayerScore"), _tblData.playerScore))
  end
  if _tblData.campScore and 0 < _tblData.campScore then
    table.insert(self.m_MessageList, string.format(LocalizationUtility.GetContentByKey("fourPartyRivalryCampScore"), _tblData.campScore))
  end
  if 0 >= table.count(self.m_MessageList) or not self:OnInit() then
    return
  end
  self.m_MessageCoroutine = Coroutine.Start(self.QuickMsg, self)
end

function FourPartyRivalryScoreTipUtility:StopCoroutine()
  if self.m_MessageCoroutine ~= nil then
    Coroutine.Stop(self.m_MessageCoroutine)
    self.m_MessageCoroutine = nil
  end
end

function FourPartyRivalryScoreTipUtility:QuickMsg()
  while table.count(self.m_MessageList) > 0 do
    self:ShowMsg(table.remove(self.m_MessageList, 1))
    Coroutine.Yield(0.5)
  end
end

function FourPartyRivalryScoreTipUtility:OnInit()
  if self.m_Tip_FourPartyRivalryScoreUI == nil then
    self.m_Tip_FourPartyRivalryScoreUI = UIManager.GetUiByName(UIID.Tip_FourPartyRivalryScoreUI)
    if self.m_Tip_FourPartyRivalryScoreUI == nil then
      return false
    end
  end
  if self.m_Tip_FourPartyRivalryScoreProgramText == nil then
    self.m_Tip_FourPartyRivalryScoreProgramText = self.m_Tip_FourPartyRivalryScoreUI.ProgramText
    if self.m_Tip_FourPartyRivalryScoreProgramText == nil or IsNil(self.m_Tip_FourPartyRivalryScoreProgramText.gameObject) then
      return false
    end
  end
  return true
end

function FourPartyRivalryScoreTipUtility:ShowMsg(_msgStr)
  if self.m_Tip_FourPartyRivalryScoreUI.activeSelf == false then
    self.m_Tip_FourPartyRivalryScoreUI:SetActive(true)
  end
  
  local function Move(_programText)
    local startPosX, startPosY, startPosZ = _programText.transform:GetLocalPosition()
    _programText.transform:SetLocalPosition(startPosX, startPosY + FourPartyRivalryScoreTipUtility.m_ItemHeight, startPosZ)
  end
  
  self.m_ProgramTextList:ForEach(Move)
  if self.m_ProgramTextList:Count() >= self.m_MaxCount then
    local programText = self.m_ProgramTextList:PopUp()
    self.m_Tip_FourPartyRivalryScoreUI:StopAnimate(programText)
    self:PoolDelete(programText)
  end
  local programText = self:PoolGet()
  if programText == nil then
    return
  end
  self.m_ProgramTextList:Add(programText)
  self.m_Tip_FourPartyRivalryScoreUI:StartAnimate(_msgStr, programText)
end

function FourPartyRivalryScoreTipUtility:PoolGet()
  local programText
  if self.m_ProgramTextPool:Count() > 0 then
    programText = self.m_ProgramTextPool:Pop()
  end
  if programText == nil then
    local item
    local go = CS.UnityEngine.GameObject.Instantiate(self.m_Tip_FourPartyRivalryScoreProgramText.gameObject, self.m_Tip_FourPartyRivalryScoreProgramText.transform.parent, false)
    go.name = self.m_Tip_FourPartyRivalryScoreProgramText.gameObject.name
    item = UIControl()
    item.transform = go.transform
    item.gameObject:SetActive(true)
    item.transform:SetAsLastSibling()
    programText = item
  end
  programText.transform:SetLocalPosition(0, 0, 0)
  programText.gameObject:SetActive(true)
  return programText
end

function FourPartyRivalryScoreTipUtility:PoolDelete(_programText)
  _programText.gameObject:SetActive(false)
  self.m_ProgramTextPool:Push(_programText)
end
