local SurrenderTemplate = {}
SurrenderTemplate.data = nil

function SurrenderTemplate:Init()
  self:InitComponent()
  self:BindClick()
end

function SurrenderTemplate:InitComponent()
  self.sl_alpha = self:GetControl("go_alpha/sl_alpha")
  self.surrenders = self:GetControl("surrenders")
  self.surrenderChoose = self:GetControl("surrenders/surrenderChoose")
  self.btns = self:GetControl("btns")
  self.btn_refuse = self:GetControl("btns/btn_refuse")
  self.surrender = self:GetControl("btns/surrender")
end

function SurrenderTemplate:InitContainer()
  if self.surrenderChooseContainer == nil then
    self.surrenderChooseContainer = UIUtility.BindUIContainerTemp(self.surrenderChoose, LuaComponentTemplates.SurrenderChunkTemplate, self.baseUI)
  end
end

function SurrenderTemplate:BindClick()
  self.btn_refuse:SetOnClick(self, self.btn_refuseOnCLick)
  self.surrender:SetOnClick(self, self.surrenderOnCLick)
end

function SurrenderTemplate:btn_refuseOnCLick()
  networkRequest.ReqCapitulate(0)
end

function SurrenderTemplate:surrenderOnCLick()
  networkRequest.ReqCapitulate(1)
end

function SurrenderTemplate:Refresh(data, ui)
  if self:AnalysisParams(data, ui) == false then
    self:UIControl():SetActive(false)
    return
  end
  self:InitContainer()
  self:UIControl():SetActive(true)
  self:RefreshSurrenderList()
  self:RefreshCountDown()
  self:RefreshBtnState()
end

function SurrenderTemplate:AnalysisParams(data, ui)
  if data == nil or data:GetTotalPlayer() == 0 or 0 >= data:GetRemainTimeRatio() then
    self.isSurrender = false
    return false
  end
  self.data = data
  self.baseUI = ui
  self.isSurrender = true
  return true
end

function SurrenderTemplate:RefreshChunk()
  local sumPlayer = 2
  local w, h = self.surrenders:GetSizeDelta()
  local spacing = self.surrenders:GetSpacing()
  local singleWidth = (w - spacing.x * (sumPlayer + 1)) / sumPlayer
  self.surrenders:SetCellSize(singleWidth)
end

function SurrenderTemplate:RefreshSurrenderList()
  if self.surrenderChooseContainer ~= nil then
    self.surrenderChooseContainer:SetData(self.data:GetVoteResult())
  end
end

function SurrenderTemplate:RefreshCountDown(ratio)
  self.sl_alpha:SetValue(ratio)
end

function SurrenderTemplate:RefreshBtnState()
  self.btns:SetActive(self.data:MainPlayerCanVote())
end

function SurrenderTemplate:SetPanelState(state)
  self:UIControl():SetActive(state)
end

function SurrenderTemplate:Update()
  if self.isSurrender then
    local ratio = self.data:GetRemainTimeRatio()
    self:RefreshCountDown(ratio)
    if ratio <= 0 then
      self.isSurrender = false
      self:UIControl():SetActive(false)
    end
  end
end

return SurrenderTemplate
