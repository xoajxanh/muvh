CombatPowerShowUI = class(BaseUI)
CombatPowerShowUI.layer = UILayer.Background
CombatPowerShowUI.orderInLayer = 3
CombatPowerShowUI.hideType = UIHideType.WaitDestroy
CombatPowerShowUI.hideFunc = UIHideFunc.MoveOutOfScreen
CombatPowerShowUI.escClose = UIEscClose.DontClose

function CombatPowerShowUI:InitControls()
  self.player_fight = self:GetControl("player_fight")
  self.lab_playerFightNum = self:GetControl("player_fight/lab_playerFightNum")
end

function CombatPowerShowUI:OnPreLoad()
end

function CombatPowerShowUI:Init()
end

function CombatPowerShowUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function CombatPowerShowUI:InitUI()
  self.CountingNumber = self.lab_playerFightNum.transform:GetComponent("CountingNumber")
end

function CombatPowerShowUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function CombatPowerShowUI:OnHide()
end

function CombatPowerShowUI:OnDestroy()
end

local function CombatAnimation(self)
  self.player_fight:SetActive(false)
  self.lab_playerFightNum:SetText("E0")
  if self.recTimer then
    Timer.Stop(self.recTimer)
    self.recTimer = nil
  end
end

function CombatPowerShowUI:RegistUIEvents()
end

function CombatPowerShowUI:RegistEvents()
  self:RegistEvent(Event.Role_MyAttributeChanged, self.On_RoleAttributeChanged, self)
end

function CombatPowerShowUI:CalculatingTime(mun)
  if mun <= 5 then
    return 0.5
  elseif mun <= 10 then
    return 1
  elseif mun <= 20 then
    return 1.5
  elseif mun <= 40 then
    return 2
  elseif mun <= 75 then
    return 2.5
  else
    return 3
  end
end

local function SetPos(fight)
  local initpos = Vector3(242, 359, 50)
  fight = math.floor(fight)
  local aac = tostring(fight)
  local indx = #aac
  indx = 4 <= indx and indx - 4 or 0
  local pos = Vector3(initpos.x + 17 * indx, 359, 50)
  return pos
end

function CombatPowerShowUI:On_RoleAttributeChanged(_, changeList)
  if changeList[EAttributeType.fight] ~= nil then
    local mun = changeList[EAttributeType.fight]
    if 0 < mun then
      local time = self:CalculatingTime(mun)
      local fight = ViewData.meData:GetAttribute(EAttributeType.fight)
      local pos = SetPos(fight)
      self.root.transform.localPosition = pos
      self.CountingNumber:ChangeTo(mun, time)
      if self.recTimer then
        Timer.Stop(self.recTimer)
      end
      local timeII = time + 0.5
      self.recTimer = Timer.StartLoop(timeII, 1, CombatAnimation, self)
      self.player_fight:SetActive(true)
    end
  end
end

function CombatPowerShowUI:Refresh()
end

function CombatPowerShowUI:StartGame()
  local figth = ViewData.meData:GetAttribute(EAttributeType.fight)
  local time = self:CalculatingTime(figth)
  self.CountingNumber:ChangeTo(figth, time)
  self.player_fight:SetActive(true)
  if self.recTimer then
    Timer.Stop(self.recTimer)
  end
  local timeII = time + 0.5
  self.recTimer = Timer.StartLoop(timeII, 1, CombatAnimation, self)
end
