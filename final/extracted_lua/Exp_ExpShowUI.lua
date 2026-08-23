Exp_ExpShowUI = class(BaseUI)
Exp_ExpShowUI.layer = UILayer.Panel
Exp_ExpShowUI.orderInLayer = 0
Exp_ExpShowUI.hideType = UIHideType.Hide
Exp_ExpShowUI.hideFunc = UIHideFunc.MoveOutOfScreen
Exp_ExpShowUI.escClose = UIEscClose.DontClose

function Exp_ExpShowUI:InitControls()
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Image_TipBgExp = self:GetControl("Panel_Tip/Image_TipBgExp")
  self.Text_TipTitle = self:GetControl("Panel_Tip/Image_TipBgExp/Text_TipTitle")
  self.lab_expNum = self:GetControl("Panel_Tip/Image_TipBgExp/Text_TipTitle/lab_expNum")
  self.lab_expPause = self:GetControl("Panel_Tip/Image_TipBgExp/Text_TipTitle/lab_expPause")
  self.btn_arrow = self:GetControl("Panel_Tip/btn_arrow")
  self.btn_active = self:GetControl("Panel_Tip/btn_active")
  self.Image_TipBgHurt = self:GetControl("Image_TipBgHurt")
  self.Text_hurtTitle = self:GetControl("Image_TipBgHurt/Text_hurtTitle")
  self.lab_damageNum = self:GetControl("Image_TipBgHurt/Text_hurtTitle/lab_damageNum")
  self.lab_damagePause = self:GetControl("Image_TipBgHurt/Text_hurtTitle/lab_damagePause")
end

function Exp_ExpShowUI:OnPreLoad()
end

function Exp_ExpShowUI:Init()
  self.ExpDataTbl = {}
  self.HurtDataTbl = {}
end

function Exp_ExpShowUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Exp_ExpShowUI:InitUI()
  self.lastexpNum = 0
  self.lasthurtNum = 0
  self.norefreshCount = 0
end

function Exp_ExpShowUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Exp_ExpShowUI:OnHide()
  self.lastexpNum = 0
  self.lasthurtNum = 0
  self:CloseTimer()
end

function Exp_ExpShowUI:OnDestroy()
  self.lastexpNum = 0
  self.lasthurtNum = 0
  self:CloseTimer()
end

function Exp_ExpShowUI:RegistUIEvents()
  self.btn_arrow:SetOnClick(self, self.btn_arrowOnClick)
  self.Image_TipBgHurt:SetOnClick(self, self.Image_TipBgHurtOnClick)
end

local hurtActive = false

function Exp_ExpShowUI:btn_arrowOnClick()
end

function Exp_ExpShowUI:Image_TipBgHurtOnClick()
  UIManager.Show(UIID.System_GameBookUI, {
    openFirstTab = 2,
    openSecondTab = 1,
    subPosition = 1
  })
end

function Exp_ExpShowUI:RegistEvents()
  self:RegistEvent(Event.SelectMonster, self.SelectMonster, self)
  self:RegistEvent(Event.CancelSelectMonster, self.CancelSelectMonster, self)
  self:RegistEvent(Event.Exp_ExpRefresh, self.ShowExpPanel, self)
end

function Exp_ExpShowUI:Refresh()
  self:RefreshIntervalTime()
  self:CloseTimer()
  self:ShowExpPanel()
  self:AddData()
  self:InitData()
end

function Exp_ExpShowUI:InitData()
  self.MonsterConfigId = 0
  self.playerId = 0
end

function Exp_ExpShowUI:RefreshIntervalTime()
  ExpAddData.refreshTime = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(1180001, "id").effect)
  ExpAddData.refreshHurtTime = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(1180002, "id").effect)
  ExpAddData.refreshUITime = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(1180003, "id").effect)
end

function Exp_ExpShowUI:RefreshExpShow()
  local expNum = 0
  local expText = ""
  local expTimeNum = #self.ExpDataTbl
  for i = 1, #self.ExpDataTbl do
    expNum = expNum + self.ExpDataTbl[i]
  end
  expNum = math.floor(expNum / expTimeNum) * 60
  if ExpAddData.AddAllExpNum == 0 then
    self.ExpDataTbl = {}
    self:CloseExpTime()
    expText = LocalizationUtility.GetContentByKey("main_exp")
    self.Panel_Tip:SetActive(false)
  elseif 0 < expNum then
    if 100000 < expNum then
      expNum = math.modf(expNum / 10000)
      expText = string.format(LocalizationUtility.GetContentByKey("main_dpsMinute2"), string.GetColorText(tostring(expNum) .. " v\225\186\161n", ItemQuality2ColorDic[EItemColorEnum.green]))
    elseif 10000 < expNum then
      local expNumS = string.format("%.2f", expNum / 10000)
      expText = string.format(LocalizationUtility.GetContentByKey("main_dpsMinute1"), string.GetColorText(tostring(expNumS) .. " v\225\186\161n", ItemQuality2ColorDic[EItemColorEnum.green]))
    else
      expText = string.format(LocalizationUtility.GetContentByKey("main_dpsMinute"), string.GetColorText(tostring(expNum), ItemQuality2ColorDic[EItemColorEnum.green]))
    end
    self.Panel_Tip:SetActive(true)
  else
    self.Panel_Tip:SetActive(false)
  end
  local tips = self:ComputeExpStandardsText()
  self.lab_expNum:SetText(tips .. " " .. expText)
  ExpAddData.AddAllExpNum = 0
end

function Exp_ExpShowUI:RefreshHurtShow()
  local hurtNum = 0
  local hurtText = ""
  local hurtTimeNum = #self.HurtDataTbl
  for i = 1, #self.HurtDataTbl do
    hurtNum = hurtNum + self.HurtDataTbl[i]
  end
  hurtNum = math.floor(hurtNum / hurtTimeNum)
  if ExpAddData.AddAllHurtNum == 0 then
    self.HurtDataTbl = {}
    self:CloseHurtTime()
    hurtText = LocalizationUtility.GetContentByKey("main_exp")
    self.Image_TipBgHurt:SetActive(false)
  elseif 0 < hurtNum then
    hurtText = self:ComputeHurtStandardsText(hurtNum)
    self.Image_TipBgHurt:SetActive(true)
  else
    self.Image_TipBgHurt:SetActive(false)
  end
  self.lab_damageNum:SetText(hurtText)
  ExpAddData.AddAllHurtNum = 0
end

function Exp_ExpShowUI:ComputeHurtStandardsText(hurtNum)
  local attackMonsterTab = ClientTable.cfg_Monster_monsterManager:TryGetValue(ExpAddData.MonsterConfigId)
  if attackMonsterTab ~= nil and attackMonsterTab.atkValueSwitch == 1 then
    local atkValueTab = string.split(attackMonsterTab.atkValue, "#")
    local index = #atkValueTab
    for i = 1, #atkValueTab do
      if hurtNum <= tonumber(atkValueTab[i]) then
        index = i
        break
      end
    end
    if index < 4 then
      self.Image_TipBgHurt.transform:GetComponent(typeof(CS.UnityEngine.UI.Button)).interactable = true
      local textTab = string.split(ClientTable.cfg_Ui_wordManager:TryGetValue("onHook_atk").content, "&")[index]
      return string.format(textTab, hurtNum)
    else
      self.Image_TipBgHurt.transform:GetComponent(typeof(CS.UnityEngine.UI.Button)).interactable = false
      local textTab = string.split(ClientTable.cfg_Ui_wordManager:TryGetValue("onHook_atk").content, "&")[index]
      if textTab then
        return string.format(textTab, hurtNum)
      else
        string.format(LocalizationUtility.GetContentByKey("main_dps"), string.GetColorText(tostring(hurtNum), ItemQuality2ColorDic[EItemColorEnum.green]))
      end
    end
  else
    return string.format(LocalizationUtility.GetContentByKey("main_dps"), string.GetColorText(tostring(hurtNum), ItemQuality2ColorDic[EItemColorEnum.green]))
  end
end

function Exp_ExpShowUI:ComputeExpStandardsText()
  local attackMonsterTab = ClientTable.cfg_Monster_monsterManager:TryGetValue(ExpAddData.MonsterConfigId)
  if attackMonsterTab ~= nil then
    return ClientTable.cfg_Character_levelManager:TryGetValue(attackMonsterTab.level).tips
  end
  return "EXP"
end

function Exp_ExpShowUI:ShowExpPanel()
  self.Panel_Tip:SetActive(false)
  self.Image_TipBgHurt:SetActive(false)
end

function Exp_ExpShowUI:CloseTimer()
  if self.addTime then
    Timer.Stop(self.addTime)
    self.addTime = nil
  end
  self:CloseExpTime()
  self:CloseHurtTime()
end

function Exp_ExpShowUI:CloseExpTime()
  if self.recTimer ~= nil then
    Timer.Stop(self.recTimer)
    self.recTimer = nil
  end
end

function Exp_ExpShowUI:CloseHurtTime()
  if self.recHurtTimer ~= nil then
    Timer.Stop(self.recHurtTimer)
    self.recHurtTimer = nil
  end
end

function Exp_ExpShowUI:SelectMonster(_, role)
  if role == nil then
    return
  end
  local BossidInfo = MonsterData.GetBossidInfo()
  if BossidInfo[role.data.configId] then
    self.Panel_Tip:SetActive(false)
  end
end

function Exp_ExpShowUI:CancelSelectMonster(_, role)
  if role == nil then
    return
  end
  local BossidInfo = MonsterData.GetBossidInfo()
  if BossidInfo[role.data.configId] then
  end
end

function Exp_ExpShowUI:AddNumData()
  self:EmptyLastHurtAndExp()
  local isAddExp = ExpAddData.AddExpNum <= 0 and table.count(self.ExpDataTbl) < 1
  local isAddHurt = 0 >= ExpAddData.AddHurtNum and 1 > table.count(self.HurtDataTbl)
  if isAddExp == false then
    if table.count(self.ExpDataTbl) == 0 and ExpAddData.AddExpNum > 0 then
      self:FirstShowExp(ExpAddData.AddExpNum)
    end
    if table.count(self.ExpDataTbl) == 60 then
      table.remove(self.ExpDataTbl, 1)
      table.insert(self.ExpDataTbl, ExpAddData.AddExpNum)
      ExpAddData.AddExpNum = 0
    elseif 60 > table.count(self.ExpDataTb) then
      table.insert(self.ExpDataTbl, ExpAddData.AddExpNum)
      ExpAddData.AddExpNum = 0
    end
    if self.recTimer == nil then
      self.recTimer = Timer.StartLoopForever(ExpAddData.refreshTime, self.RefreshExpShow, self)
    end
  end
  if isAddHurt == false then
    if table.count(self.HurtDataTbl) == 0 and 0 < ExpAddData.AddHurtNum then
      self:FirstShowHurt(ExpAddData.AddHurtNum)
    end
    if table.count(self.HurtDataTbl) == 60 then
      table.remove(self.HurtDataTbl, 1)
      table.insert(self.HurtDataTbl, ExpAddData.AddHurtNum)
      ExpAddData.AddHurtNum = 0
    elseif table.count(self.HurtDataTbl) < 60 then
      table.insert(self.HurtDataTbl, ExpAddData.AddHurtNum)
      ExpAddData.AddHurtNum = 0
    end
    if self.recHurtTimer == nil then
      self.recHurtTimer = Timer.StartLoopForever(ExpAddData.refreshHurtTime, self.RefreshHurtShow, self)
    end
  end
end

function Exp_ExpShowUI:EmptyLastHurtAndExp()
  local meID = 0
  if RoleManager.me ~= nil then
    meID = RoleManager.me.id
  end
  if self.MonsterConfigId ~= ExpAddData.MonsterConfigId or self.playerId ~= meID then
    self.MonsterConfigId = ExpAddData.MonsterConfigId
    self.playerId = meID
    local index = 0
    while index < table.count(self.ExpDataTbl) do
      index = index + 1
      if self.ExpDataTbl[index] then
        table.remove(self.ExpDataTbl, index)
        index = index - 1
      end
    end
    local index2 = 0
    while index2 < table.count(self.HurtDataTbl) do
      index2 = index2 + 1
      if self.HurtDataTbl[index2] then
        table.remove(self.HurtDataTbl, index2)
        index2 = index2 - 1
      end
    end
  end
end

function Exp_ExpShowUI:FirstShowExp(number)
  local num = number * 60
  local expText = ""
  local expNum
  if 10000 < num then
    expNum = math.modf(num / 10000)
    expText = string.format(LocalizationUtility.GetContentByKey("main_dpsMinute"), string.GetColorText(tostring(expNum) .. " v\225\186\161n", ItemQuality2ColorDic[EItemColorEnum.green]))
  else
    expText = string.format(LocalizationUtility.GetContentByKey("main_dpsMinute"), string.GetColorText(tostring(num), ItemQuality2ColorDic[EItemColorEnum.green]))
  end
  self.Panel_Tip:SetActive(true)
  local tips = self:ComputeExpStandardsText()
  self.lab_expNum:SetText(tips .. " " .. expText)
end

function Exp_ExpShowUI:FirstShowHurt(number)
  local num = number
  local hurtNum = self:ComputeHurtStandardsText(num)
  self.Image_TipBgHurt:SetActive(true)
  self.lab_damageNum:SetText(hurtNum)
end

function Exp_ExpShowUI:AddData()
  self.addTime = Timer.StartLoopForever(1, self.AddNumData, self)
end
