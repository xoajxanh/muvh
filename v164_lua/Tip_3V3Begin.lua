Tip_3V3Begin = class(BaseUI)
Tip_3V3Begin.layer = UILayer.Panel
Tip_3V3Begin.orderInLayer = 0
Tip_3V3Begin.hideType = UIHideType.WaitDestroy
Tip_3V3Begin.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_3V3Begin.escClose = UIEscClose.DontClose

function Tip_3V3Begin:InitControls()
  self.SportMatch3V3 = self:GetControl("SportMatch3V3")
  self.levelBg = self:GetControl("SportMatch3V3/SegLevel/levelBg")
  self.countDown = self:GetControl("SportMatch3V3/SegLevel/countDown")
  self.twoTeam = self:GetControl("SportMatch3V3/twoTeam")
  self.RightScroll_Item = self:GetControl("SportMatch3V3/twoTeam/Scroll_Item")
  self.RightBg_list = self:GetControl("SportMatch3V3/twoTeam/Scroll_Item/Viewport/Content/bg_list")
  self.oneTeam = self:GetControl("SportMatch3V3/oneTeam")
  self.leftScroll_Item = self:GetControl("SportMatch3V3/oneTeam/Scroll_Item")
  self.leftBg_list = self:GetControl("SportMatch3V3/oneTeam/Scroll_Item/Viewport/Content/bg_list")
end

function Tip_3V3Begin:Init()
end

function Tip_3V3Begin:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_3V3Begin:InitUI()
  self.LeftTeamMember = UIUtility.BindUIContainerTemp(self.leftBg_list, LuaComponentTemplates.ThreeVSThreeTemplate, self)
  self.RightTeamMember = UIUtility.BindUIContainerTemp(self.RightBg_list, LuaComponentTemplates.ThreeVSThreeTemplate, self)
end

function Tip_3V3Begin:RegistUIEvents()
end

function Tip_3V3Begin:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_3V3Begin:RegistEvents()
  self:RegistEvent(Event.ThreeVSThree3V3BeginBgHide, self.Hide3V3BeginBg, self)
end

function Tip_3V3Begin:Hide3V3BeginBg()
  if self.eff then
    self.eff:Destroy()
    self.eff = nil
  end
  UIManager.Hide(UIID.Tip_3V3Begin)
end

function Tip_3V3Begin:Refresh()
  self:ThreeDaoJiTime()
  self:TeamRefresh()
end

function Tip_3V3Begin:TeamRefresh()
  local MainInfo, EnemyInfo
  for i, v in ipairs(self.args.Data.matchGroup) do
    if v.red then
      MainInfo = v.member
    else
      EnemyInfo = v.member
    end
  end
  self.LeftTeamMember:SetData(MainInfo)
  self.RightTeamMember:SetData(EnemyInfo)
end

function Tip_3V3Begin:RefreshTime()
  if self.DaoJiTime > 0 then
    self.DaoJiTime = self.DaoJiTime - 1
    self.countDown:SetText(self.DaoJiTime)
  else
    self.countDown:SetText("0")
    if self.threeTime then
      Timer.Stop(self.threeTime)
      self.threeTime = nil
    end
  end
end

function Tip_3V3Begin:ThreeDaoJiTime()
  if self.threeTime then
    Timer.Stop(self.threeTime)
    self.threeTime = nil
  end
  self.DaoJiTime = tonumber(ClientTable.cfg_Activity_globalManager:TryGetValue(500070).effect)
  self.threeTime = Timer.StartLoopForever(1, self.RefreshTime, self)
end

function Tip_3V3Begin:OnHide()
end

function Tip_3V3Begin:OnDestroy()
end
