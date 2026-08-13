local LuckyStarTemp = {}

function LuckyStarTemp:Init()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function LuckyStarTemp:InitControls()
  self.btn_LuckyList = self:GetControl("sw_LuckyStarList/Viewport/Content/btn_LuckyList")
  self.go_ZhuFuAngel = self:GetControl("go_ZhuFuAngel")
  self.go_TianLeiYuJin = self:GetControl("go_TianLeiYuJin")
  self.go_ZhuFuAngel_weap = self:GetControl("go_ZhuFuAngel_weap")
  self.go_TwoToOne = self:GetControl("go_TwoToOne")
  self.LuckyStar_RewardListPanel = self:GetControl("LuckyStar_RewardListPanel")
  self.rewardListBtnClose = self:GetControl("LuckyStar_RewardListPanel/img_bg/btn_close")
  self.List_reward = self:GetControl("LuckyStar_RewardListPanel/img_bg/Scroll View/Viewport/Content/List_reward")
  self.lab_name = self:GetControl("LuckyStar_RewardListPanel/img_bg/lab_name")
end

function LuckyStarTemp:InitUI()
  self.first = nil
  self.btnLuckyListContainar = UIContainer(self.btn_LuckyList, self, self.BtnCreate, self.BtnRefresh)
  self.List_rewardContainar = UIContainer(self.List_reward, self, self.List_rewardCreate, self.List_rewardRefresh)
  self.group = {}
  self.group[1] = luaTemplateManager.GetNewTemplate(self.go_TwoToOne, LuaComponentTemplates.LuckyStarType1Temp, self)
  self.group[2] = luaTemplateManager.GetNewTemplate(self.go_ZhuFuAngel_weap, LuaComponentTemplates.LuckyStarType1Temp, self)
  self.group[3] = luaTemplateManager.GetNewTemplate(self.go_ZhuFuAngel, LuaComponentTemplates.LuckyStarType1Temp, self)
  self.group[4] = luaTemplateManager.GetNewTemplate(self.go_TianLeiYuJin, LuaComponentTemplates.LuckyStarType1Temp, self)
end

function LuckyStarTemp:RegistUIEvents()
  self.rewardListBtnClose:SetOnClick(self, self.OnRewardListBtnCloseClick)
  EventManager.Regist(Event.ShowRewardList, self.ShowWinnerList, self)
  EventManager.Regist(Event.LuckyStarCount, self.RefreshAllTemp, self)
end

function LuckyStarTemp:OnRewardListBtnCloseClick()
  self.LuckyStar_RewardListPanel:SetActive(false)
end

function LuckyStarTemp.List_rewardCreate(ctr)
  ctr.lab_server = UIControl(ctr.transform, "lab_server")
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
end

function LuckyStarTemp.List_rewardRefresh(ctr, _, data, ui)
  local strSplit = string.split(data, ":")
  if table.count(strSplit) == 2 then
    ctr.lab_server:SetText(strSplit[1])
    ctr.lab_name:SetText(strSplit[2])
  end
end

function LuckyStarTemp:GetGroupTemp(group)
  return self.group[group]
end

function LuckyStarTemp:RefreshAllTemp()
  for i, v in pairs(RechargeData.LuckyStarData:GetTabList()) do
    if self.group[i] then
      self.group[i]:Refresh(v)
    end
  end
end

local function Tog_TabListOnChanged(ui, ctr, isOn)
  if ctr.bindTemp == nil or ctr.bindTemp.go == nil then
    return
  end
  ctr.bindTemp.go:SetActive(isOn)
  if isOn then
    ctr.bindTemp:Refresh(ctr.data)
    ctr.img_redPoint:SetActive(false)
    RechargeData.LuckyStarData:ReqRewarData(ctr.data)
    RechargeData.LuckyStarData:SetLuckyStarRed(ctr.data)
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = LuckyStarData.GroupEnumId[ctr.data.group]
    })
  end
end

function LuckyStarTemp.BtnCreate(ctr)
  ctr.Text = UIControl(ctr.transform, "Text")
  ctr.img_redPoint = UIControl(ctr.transform, "img_redPoint")
end

function LuckyStarTemp.BtnRefresh(ctr, index, data, ui)
  ctr.data = data
  ctr.gameObject.name = ClientTable.cfg_Red_pointManager:TryGetValue(LuckyStarData.GroupEnumId[data.group]).IdEnum
  ctr.Text:SetText(data.title)
  ctr:SetIsOn(false)
  ctr:SetOnToggleChanged(ui, Tog_TabListOnChanged)
  ctr.bindTemp = ui:GetGroupTemp(data.group)
  ctr.img_redPoint:SetActive(RechargeData.LuckyStarData:RedPointRefresh(LuckyStarData.GroupEnumId[data.group]))
  if ui.first ~= true then
    ctr:SetIsOn(true)
    ui.first = true
  end
end

function LuckyStarTemp:Refresh()
  for i, v in pairs(self.group) do
    v.go:SetActive(false)
  end
  self.first = nil
  RechargeData.LuckyStarData:RefreshData()
  local tablDataList = RechargeData.LuckyStarData:GetTabList()
  self.btnLuckyListContainar:RemoveKTable()
  self.btnLuckyListContainar:SetDataKTable(tablDataList)
  self.LuckyStar_RewardListPanel:SetActive(false)
end

function LuckyStarTemp:ShowWinnerList(_, data)
  if data then
    self.lab_name:SetText(string.format("Danh s\195\161ch nh\225\186\173n th\198\176\225\187\159ng %s", data.deadlineshow))
    self.LuckyStar_RewardListPanel:SetActive(true)
    self.List_rewardContainar:SetData(RechargeData.LuckyStarData:GetRewardData(data))
  else
    self.lab_name:SetText("")
    self.LuckyStar_RewardListPanel:SetActive(true)
    self.List_rewardContainar:SetData({})
  end
end

function LuckyStarTemp:Exit()
  self.LuckyStar_RewardListPanel:SetActive(false)
end

return LuckyStarTemp
