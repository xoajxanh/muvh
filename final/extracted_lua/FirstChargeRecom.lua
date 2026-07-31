FirstChargeRecom = class(BaseUI)
FirstChargeRecom.layer = UILayer.Panel
FirstChargeRecom.orderInLayer = 0
FirstChargeRecom.hideType = UIHideType.WaitDestroy
FirstChargeRecom.hideFunc = UIHideFunc.MoveOutOfScreen
FirstChargeRecom.escClose = UIEscClose.DontClose

function FirstChargeRecom:InitControls()
  self.t1 = self:GetControl("t1")
  self.RecomImage_bg = self:GetControl("t1/RecomImage_bg")
  self.RecomImage = self:GetControl("t1/RecomImage")
  self.Countdown = self:GetControl("t1/Countdown")
  self.t2 = self:GetControl("t2")
  self.RecomImage_bg2 = self:GetControl("t2/RecomImage_bg2")
  self.RecomImage2 = self:GetControl("t2/RecomImage2")
  self.Countdown2 = self:GetControl("t2/Countdown2")
end

function FirstChargeRecom:OnPreLoad()
end

local this = FirstChargeRecom

function FirstChargeRecom:Init()
  self.FirstChargCountdown = RechargeData.GetFirstChargeRecom()
end

function FirstChargeRecom:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function FirstChargeRecom:InitUI()
  this.messageContainer = EventContainer(EventManager)
end

function FirstChargeRecom:OnLeaveGame()
  self:WriteFun()
  self:DestroyTimer()
  self.ShowData = nil
  self.timeStr = nil
end

function FirstChargeRecom:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function FirstChargeRecom:OnHide()
  self:DestroyTimer()
  self.timeStr = 0
  self:WriteFun()
  self.ShowData = nil
  self.timeStr = nil
end

function FirstChargeRecom:OnDestroy()
  self:WriteFun()
  self:DestroyTimer()
  self.ShowData = nil
  self.timeStr = nil
end

function FirstChargeRecom:RegistUIEvents()
  self.RecomImage_bg:SetOnClick(self, self.btn_RecomImage)
  self.RecomImage_bg2:SetOnClick(self, self.btn_RecomImage)
end

function FirstChargeRecom:btn_RecomImage()
  local index = tonumber(self.ShowData[1])
  UIManager.Hide(UIID.FirstChargeRecom)
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Recharge_FirstChargeUI, {page = index})
end

function FirstChargeRecom:RegistEvents()
  this.messageContainer:Regist(Event.GamePlay_Leave, self.OnLeaveGame, self)
  this.messageContainer:Regist(Event.GamePlay_Back2Choose, self.OnLeaveGame, self)
end

function FirstChargeRecom:RefreshData(time)
  local roledata = string.format("%s-%d", RechargeData.FIRSTCHARGGIFT, RoleManager.me.id)
  self.roledata = roledata
  self.Info = PlayerPrefs.GetString(self.roledata)
  local Group = string.split(self.Info, "/")
  self.GroupShow = {}
  local manindex = -100
  local manShow
  for i, v in pairs(Group) do
    local Gr = string.split(v, "#")
    local Show = {}
    Show.text = v
    Show.Gr = Gr
    self.GroupShow[i] = Show
    if manindex < tonumber(Gr[1]) and tonumber(Gr[4]) > 0 then
      manindex = i
      manShow = Gr
    end
  end
  if manShow then
    if self.ShowData and self.ShowData[1] ~= manShow[1] then
      self:DestroyTimer()
      self.timeStr = 0
      self:WriteFun()
      self.ShowData = nil
      self.timeStr = nil
    end
    self.ShowData = manShow
    if not time and not RechargeData.IsNoRecharge(tonumber(manShow[1])) then
      UIManager.Hide(UIID.FirstChargeRecom)
      return true
    end
  else
    self:DestroyTimer()
    self.ShowData = nil
    self.timeStr = nil
    UIManager.Hide(UIID.FirstChargeRecom)
    return true
  end
end

function FirstChargeRecom:Refresh(time)
  if self:RefreshData(time) then
    return
  end
  local index = tonumber(self.ShowData[1])
  local isType1 = true
  self.t1:SetActive(isType1)
  self.t2:SetActive(not isType1)
  if isType1 then
    FirstChargeRecom:ShowPlan(self.RecomImage, self.Countdown, index)
  else
    FirstChargeRecom:ShowPlan(self.RecomImage2, self.Countdown2, index)
  end
end

function FirstChargeRecom:ShowPlan(Recomimage, Recomtext, index)
  self.ShowRecomtext = Recomtext
  local data = self.FirstChargCountdown[index]
  local image, Eff
  for i, v in pairs(data.image) do
    local Condition = string.split(v, "*")
    if not table.isNullOrEmpty(Condition) and 0 < #Condition and RoleUtility.CareerJudge(tonumber(ViewData.meData.career), tonumber(Condition[1])) then
      image = Condition[2]
      Eff = Condition[3]
      break
    end
  end
  if Recomimage == nil then
    self:InitControls()
  end
  self:SetSprite("Atlas_Main", image, Recomimage)
  if Eff then
    if self.Eff then
      self.Eff:Destroy()
    end
    self.Eff = UIEffectUtility.SetUIEffect(Eff, Recomimage, true, Vector3(1, 1, 1))
  end
  local time = tonumber(self.ShowData[4])
  local min = math.floor(time / 60)
  local sec = math.floor(time % 60)
  Recomtext:SetText(string.format("%02d:%02d", min, sec))
  self:DestroyTimer()
  self:CreatTimer(time)
end

function FirstChargeRecom:WriteFun()
  if self.ShowData and self.timeStr then
    local texts = ""
    local char = "/"
    for i, v in pairs(self.GroupShow) do
      if i ~= #self.GroupShow then
        char = "/"
      else
        char = ""
      end
      if tonumber(v.Gr[1]) == tonumber(self.ShowData[1]) then
        local time = -10
        if self.timeStr > 0 then
          time = self.timeStr
        else
          v.text = string.format("%s#%s#%s#%s", i, self.ShowData[2], self.ShowData[3], time)
        end
        local text = string.format("%s#%s#%s#%s", i, self.ShowData[2], self.ShowData[3], time)
        texts = texts .. text .. char
      else
        texts = texts .. v.text .. char
      end
    end
    PlayerPrefs.SetString(self.roledata, texts)
  end
end

function FirstChargeRecom:CreatTimer(time)
  self.timeStr = time
  
  local function UpdataTimerBtn()
    self.timeStr = self.timeStr - 1
    local min = math.floor(self.timeStr / 60)
    local sec = math.floor(self.timeStr % 60)
    if self.timeStr > 0 then
      self.ShowRecomtext:SetText(string.format("%02d:%02d", min, sec))
      self:WriteFun()
    elseif self.timeStr == 0 then
      self.ShowRecomtext:SetText(string.format("%02d:%02d", min, sec))
      self:WriteFun()
      self:Refresh(true)
    end
  end
  
  self.recTimer = Timer.StartLoop(1, self.timeStr, UpdataTimerBtn)
end

function FirstChargeRecom:DestroyTimer()
  if self.recTimer then
    Timer.Stop(self.recTimer)
  end
  self.recTimer = nil
end
