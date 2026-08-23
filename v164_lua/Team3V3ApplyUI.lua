Team3V3ApplyUI = class(BaseUI)
Team3V3ApplyUI.layer = UILayer.Panel
Team3V3ApplyUI.orderInLayer = 10
Team3V3ApplyUI.hideType = UIHideType.WaitDestroy
Team3V3ApplyUI.hideFunc = UIHideFunc.MoveOutOfScreen
Team3V3ApplyUI.escClose = UIEscClose.DontClose

function Team3V3ApplyUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.person_rank = self:GetControl("img_bg/Scroll View/Viewport/Content/person_rank")
  self.Text = self:GetControl("img_bg/Text")
  self.descBtn = self:GetControl("img_bg/descBtn")
  self.btn_totalLevel = self:GetControl("img_bg/Title/btn_totalLevel")
  self.btn_member = self:GetControl("img_bg/Title/btn_member")
  self.btn_limitLevel = self:GetControl("img_bg/Title/btn_limitLevel")
end

function Team3V3ApplyUI:Init()
end

function Team3V3ApplyUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnPerson_rankCreate(ctr)
  ctr.lab_teamName = UIControl(ctr.transform, "lab_teamName")
  ctr.lab_captainName = UIControl(ctr.transform, "lab_captainName")
  ctr.lab_totalLevel = UIControl(ctr.transform, "lab_totalLevel")
  ctr.lab_memberCount = UIControl(ctr.transform, "lab_member")
  ctr.lab_limitLevel = UIControl(ctr.transform, "lab_limitLevel")
  ctr.apply_btn = UIControl(ctr.transform, "apply_btn")
  ctr.applied_btn = UIControl(ctr.transform, "applied_btn")
end

local function OnPerson_rankRefresh(ctr, _, data, ui)
  ctr.apply_btn:SetActive(true)
  ctr.applied_btn:SetActive(false)
  ctr.lab_teamName:SetText(data.teamName)
  ctr.lab_totalLevel:SetText(data.totalLevel)
  ctr.lab_captainName:SetText(data.leadName)
  local numberColor = data.memberCount < 4 and ItemQuality2ColorDic[EItemColorEnum.green] or ItemQuality2ColorDic[EItemColorEnum.red]
  ctr.lab_memberCount:SetText(string.GetColorText(data.memberCount .. "/4", numberColor))
  local levelColor = ViewData.meData.level >= data.needLevel and ItemQuality2ColorDic[EItemColorEnum.green] or ItemQuality2ColorDic[EItemColorEnum.red]
  ctr.lab_limitLevel:SetText(string.GetColorText(data.needLevel, levelColor))
  ctr.apply_btn:SetOnClickParam(ui, ui.ApplyJoinTeam, data)
  if data.apply then
    ctr.applied_btn:SetActive(true)
  end
end

function Team3V3ApplyUI:InitUI()
  self.person_rankContainer = UIContainer(self.person_rank, self, OnPerson_rankCreate, OnPerson_rankRefresh)
  self.sortBtns = {
    {
      btn = self.btn_totalLevel,
      sortKey = "totalLevel"
    },
    {
      btn = self.btn_member,
      sortKey = "memberCount"
    },
    {
      btn = self.btn_limitLevel,
      sortKey = "needLevel"
    }
  }
  self.sortState = {
    totalLevel = 0,
    memberCount = 0,
    needLevel = 0
  }
  for i, v in ipairs(self.sortBtns) do
    v.arrowUp = UIControl(v.btn.transform, "bg_arrows_job/arrow_up/arrow_up_job")
    v.arrowDown = UIControl(v.btn.transform, "bg_arrows_job/arrow_down/arrow_down_job")
    v.arrowUp:SetActive(false)
    v.arrowDown:SetActive(false)
  end
end

function Team3V3ApplyUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  for i, v in ipairs(self.sortBtns) do
    v.btn:SetOnClickParam(self, self.OnSortClick, v)
  end
end

function Team3V3ApplyUI:ApplyJoinTeam(control)
  local teamData = control.param
  if teamData.memberCount >= 4 then
    return FloatingTipUtility.QuickMsg("\196\144\225\187\153i \196\145\195\163 \196\145\225\186\167y")
  end
  if ViewData.meData.level < teamData.needLevel then
    return FloatingTipUtility.QuickMsg("Kh\195\180ng \196\145\225\187\167 c\225\186\165p")
  end
  networkRequest.ReqJoinTeam(teamData.teamId)
  networkRequest.ReqAllTeam()
end

function Team3V3ApplyUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Team3V3ApplyUI)
end

function Team3V3ApplyUI:OnSortClick(control)
  local sortBtn = control.param
  local key = sortBtn.sortKey
  if self.sortState[key] == 1 then
    self.sortState[key] = 2
  else
    self.sortState[key] = 1
  end
  for i, v in ipairs(self.sortBtns) do
    local otherKey = v.sortKey
    if otherKey ~= key then
      self.sortState[otherKey] = 0
    end
  end
  self:UpdateSortArrows()
  self:ApplySort(key, self.sortState[key] == 1)
end

function Team3V3ApplyUI:UpdateSortArrows()
  for i, v in ipairs(self.sortBtns) do
    local state = self.sortState[v.sortKey]
    v.arrowUp:SetActive(state == 1)
    v.arrowDown:SetActive(state == 2)
  end
end

function Team3V3ApplyUI:ApplySort(key, isAsc)
  local teamList = self:GetClassData().AllTeamList
  if not teamList or #teamList == 0 then
    return
  end
  table.sort(teamList, function(a, b)
    local va = a[key] or 0
    local vb = b[key] or 0
    if va ~= vb then
      if isAsc then
        return va < vb
      else
        return va > vb
      end
    end
    return (a.teamId or 0) < (b.teamId or 0)
  end)
  self.person_rankContainer:SetData(teamList)
end

function Team3V3ApplyUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Team3V3ApplyUI:RegistEvents()
  self:RegistEvent(Event.RefreshTeam3v3List, self.RefreshTeam3v3List, self)
  self:RegistEvent(Event.RefreshTeam3V3Info, self.RefreshTeam3V3Info, self)
end

function Team3V3ApplyUI:Refresh()
  networkRequest.ReqAllTeam()
  if self.timer then
    Timer.Stop(self.timer)
    self.timer = nil
  end
  self.timer = Timer.StartLoopForever(0.5, function()
    local countDown = self:GetClassData():GetBaoMinTime()
    local NowTime = Time.GetServerSecondTime()
    if NowTime <= countDown.endStamp then
      self.Text:SetText(TimeUtility.ShowTime(countDown.endStamp - Time.GetServerSecondTime()))
    else
      self.Text:SetText(TimeUtility.ShowTime(0))
    end
  end)
end

function Team3V3ApplyUI:RefreshTeam3V3Info()
  if table.count(self:GetClassData().MenbersInfo) > 0 then
    UIManager.Hide(UIID.Team3V3ApplyUI)
  end
end

function Team3V3ApplyUI:RefreshTeam3v3List()
  local teamList = self:GetClassData().AllTeamList
  for i, v in ipairs(self.sortBtns) do
    local state = self.sortState[v.sortKey]
    if state ~= 0 then
      self:ApplySort(v.sortKey, state == 1)
      self:UpdateSortArrows()
      return
    end
  end
  self.person_rankContainer:SetData(teamList)
end

function Team3V3ApplyUI:OnHide()
  if self.timer then
    Timer.Stop(self.timer)
    self.timer = nil
  end
end

function Team3V3ApplyUI:OnDestroy()
end

function Team3V3ApplyUI:GetClassData()
  return QuickFind:GetTeam3V3DataMgr()
end
