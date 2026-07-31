Main_MainSkillUI = class(BaseUI)
Main_MainSkillUI.layer = UILayer.Background
Main_MainSkillUI.orderInLayer = 2
Main_MainSkillUI.hideType = UIHideType.Hide
Main_MainSkillUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_MainSkillUI.escClose = UIEscClose.DontClose

function Main_MainSkillUI:InitControls()
  self.Zone = self:GetControl("Zone")
  self.BtnCommon = self:GetControl("Zone/BtnCommon")
  self.killPerson = self:GetControl("Zone/BtnCommon/killPerson")
  self.killMonster = self:GetControl("Zone/BtnCommon/killMonster")
  self.BtnChange = self:GetControl("Zone/BtnCommon/BtnChange")
  self.Img_player = self:GetControl("Zone/Img_player")
  self.Img_player1 = self:GetControl("Zone/Img_player/Img_player1")
  self.ani_player1 = self:GetControl("Zone/Img_player/ani_player1")
  self.Img_monster = self:GetControl("Zone/Img_monster")
  self.Img_monster2 = self:GetControl("Zone/Img_monster/Img_monster2")
  self.ani_monster2 = self:GetControl("Zone/Img_monster/ani_monster2")
  self.SkillStruct = self:GetControl("SkillStruct")
  self.BtnSkill1 = self:GetControl("SkillStruct/BtnSkill1")
  self.BtnSkill2 = self:GetControl("SkillStruct/BtnSkill2")
  self.BtnSkill3 = self:GetControl("SkillStruct/BtnSkill3")
  self.BtnSkill4 = self:GetControl("SkillStruct/BtnSkill4")
  self.BtnSkill5 = self:GetControl("SkillStruct/BtnSkill5")
  self.BtnSkill6 = self:GetControl("SkillStruct/BtnSkill6")
  self.BtnSkill7 = self:GetControl("SkillStruct/BtnSkill7")
  self.SummonerBtnSkill = self:GetControl("SummonerBtnSkill")
  self.SummonerBtnForbidSkillImg = self:GetControl("SummonerBtnSkill/ForbidSkillImg")
  self.ForbidSkillImg1 = self:GetControl("SkillStruct/BtnSkill1/ForbidSkillImg")
  self.ForbidSkillImg2 = self:GetControl("SkillStruct/BtnSkill2/ForbidSkillImg")
  self.ForbidSkillImg3 = self:GetControl("SkillStruct/BtnSkill3/ForbidSkillImg")
  self.ForbidSkillImg4 = self:GetControl("SkillStruct/BtnSkill4/ForbidSkillImg")
  self.ForbidSkillImg5 = self:GetControl("SkillStruct/BtnSkill5/ForbidSkillImg")
  self.ForbidSkillImg6 = self:GetControl("SkillStruct/BtnSkill6/ForbidSkillImg")
  self.ForbidSkillImg7 = self:GetControl("SkillStruct/BtnSkill7/ForbidSkillImg")
  self.SkillTurnStruct = self:GetControl("mask_skill/SkillTurnStruct")
  self.BtnTurnSkill1 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill1")
  self.BtnTurnSkill2 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill2")
  self.BtnTurnSkill3 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill3")
  self.BtnTurnSkill4 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill4")
  self.BtnTurnSkill5 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill5")
  self.BtnTurnSkill6 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill6")
  self.BtnTurnSkill7 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill7")
  self.BtnTurnSkill8 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill8")
  self.BtnTurnSkill9 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill9")
  self.TurnForbidSkillImg1 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill1/ForbidSkillImg")
  self.TurnForbidSkillImg2 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill2/ForbidSkillImg")
  self.TurnForbidSkillImg3 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill3/ForbidSkillImg")
  self.TurnForbidSkillImg4 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill4/ForbidSkillImg")
  self.TurnForbidSkillImg5 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill5/ForbidSkillImg")
  self.TurnForbidSkillImg6 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill6/ForbidSkillImg")
  self.TurnForbidSkillImg7 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill7/ForbidSkillImg")
  self.TurnForbidSkillImg8 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill8/ForbidSkillImg")
  self.TurnForbidSkillImg9 = self:GetControl("mask_skill/SkillTurnStruct/BtnTurnSkill9/ForbidSkillImg")
  self.mount_btn = self:GetControl("mount_btn")
  self.go_fake = self:GetControl("go_fake")
  self.ComboBtnSkill = self:GetControl("ComboSkill/ComboBtnSkill")
  self.ComboTurnBtnSkill = self:GetControl("ComboSkill/ComboTurnBtnSkill")
end

local skillBtnSkill = {}
local skillBtnTurnSkill = {}
local isDragCommon = false
local pointDownPos = Vector3(0, 0, 0)

function Main_MainSkillUI:Init()
  self.BtnCommonPos = Vector3.zero
  self.mainSkillActive = true
  self:InitSilenceBuff()
end

function Main_MainSkillUI:OnCreate()
  self:InitControls()
  self:InitChargingCd()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_MainSkillUI:InitChargingCd()
  local data1 = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2110005), "&")
  self.atkSpeedIncreaseRate = {}
  for i = 1, #data1 do
    local data2 = string.split(data1[i], "#")
    local career = tonumber(data2[1])
    self.atkSpeedIncreaseRate[career] = tonumber(data2[2])
  end
end

function Main_MainSkillUI:InitUI()
  table.insert(skillBtnSkill, {
    btn = self.BtnSkill1,
    pos = self.BtnSkill1.transform.localPosition
  })
  table.insert(skillBtnSkill, {
    btn = self.BtnSkill2,
    pos = self.BtnSkill2.transform.localPosition
  })
  table.insert(skillBtnSkill, {
    btn = self.BtnSkill3,
    pos = self.BtnSkill3.transform.localPosition
  })
  table.insert(skillBtnSkill, {
    btn = self.BtnSkill4,
    pos = self.BtnSkill4.transform.localPosition
  })
  table.insert(skillBtnSkill, {
    btn = self.BtnSkill5,
    pos = self.BtnSkill5.transform.localPosition
  })
  table.insert(skillBtnSkill, {
    btn = self.BtnSkill6,
    pos = self.BtnSkill6.transform.localPosition
  })
  table.insert(skillBtnSkill, {
    btn = self.BtnSkill7,
    pos = self.BtnSkill7.transform.localPosition
  })
  table.insert(skillBtnTurnSkill, {
    btn = self.BtnTurnSkill1,
    pos = self.BtnTurnSkill1.transform.localPosition
  })
  table.insert(skillBtnTurnSkill, {
    btn = self.BtnTurnSkill2,
    pos = self.BtnTurnSkill2.transform.localPosition
  })
  table.insert(skillBtnTurnSkill, {
    btn = self.BtnTurnSkill3,
    pos = self.BtnTurnSkill3.transform.localPosition
  })
  table.insert(skillBtnTurnSkill, {
    btn = self.BtnTurnSkill4,
    pos = self.BtnTurnSkill4.transform.localPosition
  })
  table.insert(skillBtnTurnSkill, {
    btn = self.BtnTurnSkill5,
    pos = self.BtnTurnSkill5.transform.localPosition
  })
  table.insert(skillBtnTurnSkill, {
    btn = self.BtnTurnSkill6,
    pos = self.BtnTurnSkill6.transform.localPosition
  })
  table.insert(skillBtnTurnSkill, {
    btn = self.BtnTurnSkill7,
    pos = self.BtnTurnSkill7.transform.localPosition
  })
  table.insert(skillBtnTurnSkill, {
    btn = self.BtnTurnSkill8,
    pos = self.BtnTurnSkill8.transform.localPosition
  })
  self.ComboBtnSkill.pos = self.ComboBtnSkill.transform.localPosition
  self.SummonerBtnSkill.pos = self.SummonerBtnSkill.transform.localPosition
  self.ComboTurnBtnSkill.pos = self.ComboTurnBtnSkill.transform.localPosition
  self.mount_btn.pos = self.mount_btn.transform.localPosition
  for i = 1, #skillBtnTurnSkill do
    local skillBtn = skillBtnTurnSkill[i].btn
    skillBtn:SetOnBeginDrag(self, self.OnBeginDrag)
    skillBtn:SetOnDrag(self, self.OnDragEvent)
    skillBtn:SetOnEndDrag(self, self.OnDragEventEnd)
  end
  self.BtnCommonPos = self.Zone.transform.localPosition
  self:MainModeInit()
  self.Mountswitch = false
end

function Main_MainSkillUI:MainModeInit()
  self:OnMainModeChanged()
end

function Main_MainSkillUI:OnShow()
  self:RegistEvents()
  self:SetSummonerBuffInfo()
  self:Refresh()
end

function Main_MainSkillUI:OnHide()
  self.Mountswitch = false
  self.SummonerBtnSkill.skillId = 0
  self.SummonerBtnSkill.groupId = 0
end

function Main_MainSkillUI:OnDestroy()
end

local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode
local inputKey = -1

function Main_MainSkillUI:Update()
  if not self.mainSkillActive or SkillData.MainMode ~= EMainModeType.Skill or UIManager.IsVisible(UIID.ChatUI) or UIManager.IsVisible(UIID.GmUI) then
    return
  end
  if Input.anyKeyDown then
    local index = tonumber(Input.inputString)
    if index then
      local skillBtn = SkillData.MainMode == EMainModeType.Skill and skillBtnSkill or skillBtnTurnSkill
      if skillBtn[index] and skillBtn[index].btn.skillId then
        self:Button_OnSkillPointDown(skillBtn[index].btn)
      end
    end
  end
  if Input.GetKeyUp(KeyCode.Keypad1) or Input.GetKeyUp(KeyCode.Alpha1) then
    inputKey = 1
  elseif Input.GetKeyUp(KeyCode.Keypad2) or Input.GetKeyUp(KeyCode.Alpha2) then
    inputKey = 2
  elseif Input.GetKeyUp(KeyCode.Keypad3) or Input.GetKeyUp(KeyCode.Alpha3) then
    inputKey = 3
  elseif Input.GetKeyUp(KeyCode.Keypad4) or Input.GetKeyUp(KeyCode.Alpha4) then
    inputKey = 4
  elseif Input.GetKeyUp(KeyCode.Keypad5) or Input.GetKeyUp(KeyCode.Alpha5) then
    inputKey = 5
  elseif Input.GetKeyUp(KeyCode.Keypad6) or Input.GetKeyUp(KeyCode.Alpha6) then
    inputKey = 6
  elseif Input.GetKeyUp(KeyCode.Keypad7) or Input.GetKeyUp(KeyCode.Alpha7) then
    inputKey = 7
  elseif Input.GetKeyUp(KeyCode.Keypad8) or Input.GetKeyUp(KeyCode.Alpha8) then
    inputKey = 8
  elseif Input.GetKeyUp(KeyCode.Keypad9) or Input.GetKeyUp(KeyCode.Alpha9) then
    local comboSkillBtn = SkillSettingData.curmode == EPanModeType.All and self.ComboBtnSkill or self.ComboTurnBtnSkill
    if comboSkillBtn.skillId and comboSkillBtn.skillId ~= 0 then
      self:Button_OnSkillClick(comboSkillBtn)
    end
  end
  if 1 <= inputKey and inputKey <= 8 then
    local skillBtn = SkillSettingData.curmode == EPanModeType.All and skillBtnSkill or skillBtnTurnSkill
    if skillBtn[inputKey] and skillBtn[inputKey].btn.skillId then
      self:Button_OnSkillPointExit(skillBtn[inputKey].btn)
      self:Button_OnSkillPointUp(skillBtn[inputKey].btn)
      self:Button_OnSkillClick(skillBtn[inputKey].btn)
    end
    inputKey = -1
  end
end

function Main_MainSkillUI:RegistUIEvents()
  self.BtnCommon:SetOnPointerClick(self, self.CommonBtnClick)
  self.BtnCommon:SetOnBeginDrag(self, self.OnBeginDragCommon)
  self.BtnCommon:SetOnDrag(self, self.OnDragEventCommon)
  self.BtnCommon:SetOnEndDrag(self, self.OnDragEventEndCommon)
  self.Img_monster:SetOnClick(self, self.LookForMonster)
  self.Img_player:SetOnClick(self, self.LookForPlayer)
  self.mount_btn:SetOnClick(self, self.SetMountOnclick)
  self.SummonerBtnSkill:SetOnClick(self, self.SummonerSkillClick)
end

function Main_MainSkillUI:LookForMonster(control)
  local range = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390014))
  local monster = RoleTargetManager.GetNearestMonsterTarget(true, range)
  if monster then
    RoleTargetManager.ClearSelectPlayerTarget()
    RoleManager.me:SetTarget(monster)
  else
    local tipsStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Switch_target_monster")
    FloatingTipUtility.QuickMsg(tipsStr)
    RoleManager.me:ShowLookEnemyCircleEffect("yellow")
  end
  local effect = UIEffectUtility.SetUIEffectParent("Eff_UI_yuan", control.gameObject, false, Vector3(5, 5, 5))
  effect:SetActive(true)
  self.ani_monster2:SetActive(false)
  self.ani_monster2:SetActive(true)
end

function Main_MainSkillUI:LookForPlayer(control)
  local range = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390014))
  local player = RoleTargetManager.GetNearestPlayerTarget(true, range)
  if player then
    RoleTargetManager.ClearSelectMonsterTarget()
    RoleManager.me:SetTarget(player)
  else
    local tipsStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Switch_target_player")
    FloatingTipUtility.QuickMsg(tipsStr)
    RoleManager.me:ShowLookEnemyCircleEffect("red")
  end
  local effect = UIEffectUtility.SetUIEffectParent("Eff_UI_yuan", control.gameObject, false, Vector3(5, 5, 5))
  effect:SetActive(true)
  self.ani_player1:SetActive(false)
  self.ani_player1:SetActive(true)
end

function Main_MainSkillUI:OnBeginDragCommon(control, eventData)
  isDragCommon = true
  pointDownPos = eventData.position
end

function Main_MainSkillUI:DragJoystick(backGroundPos, eventData)
  local direction = Vector2(eventData.position.x - backGroundPos.x, eventData.position.y - backGroundPos.y)
  local distance = Vector2.Magnitude(direction)
  local radius = Mathf.Clamp(distance, 0, 10)
  local res = direction.normalized * radius
  local pos = Vector3(res.y, res.y, res.z)
  self.BtnCommon.transform.localPosition = pos
end

function Main_MainSkillUI:OnDragEventCommon(control, eventData)
  local backGroundPos
  if eventData == nil or eventData.pressEventCamera == nil then
    backGroundPos = self.Zone.transform.position
  else
    backGroundPos = eventData.pressEventCamera:WorldToScreenPoint(self.Zone.transform.position)
  end
  self:DragJoystick(backGroundPos, eventData)
  if eventData.position.y > pointDownPos.y then
    self.killPerson:GetChild("red1"):SetActive(true)
    self.killPerson:GetChild("red2"):SetActive(true)
    self.killPerson:SetParent(self.BtnCommon)
    self.BtnChange.transform:SetAsLastSibling()
    self.killMonster:SetParent(self.Zone)
    self.killMonster:SetAnchoredPosition(0, 0)
    self.killMonster:GetChild("yellow1"):SetActive(false)
    self.killMonster:GetChild("yellow2"):SetActive(false)
    self:SetSprite("Atlas_Main", "img_btn_new_persona_2", self.Img_player1, false)
    self:SetSprite("Atlas_Main", "img_btn_new_monster_1", self.Img_monster2, false)
  else
    self.killMonster:GetChild("yellow1"):SetActive(true)
    self.killMonster:GetChild("yellow2"):SetActive(true)
    self.killMonster:SetParent(self.BtnCommon)
    self.BtnChange.transform:SetAsLastSibling()
    self.killPerson:SetParent(self.Zone)
    self.killPerson:SetAnchoredPosition(0, 0)
    self.killPerson:GetChild("red1"):SetActive(false)
    self.killPerson:GetChild("red2"):SetActive(false)
    self:SetSprite("Atlas_Main", "img_btn_new_persona_1", self.Img_player1, false)
    self:SetSprite("Atlas_Main", "img_btn_new_monster_2", self.Img_monster2, false)
  end
end

function Main_MainSkillUI:OnDragEventEndCommon(control, eventData)
  isDragCommon = false
  local range = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390014))
  if eventData.position.y > pointDownPos.y then
    if eventData.position.y - pointDownPos.y > 5 then
      local player = RoleTargetManager.GetNearestPlayerTarget(true, range)
      if player then
        RoleTargetManager.ClearSelectMonsterTarget()
        ThreeVsThreeUtility.SetChooseEnemyLid(player.id, true)
        RoleManager.me:SetTarget(player)
      else
        RoleManager.me:ShowLookEnemyCircleEffect("red")
        local tipsStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Switch_target_player")
        FloatingTipUtility.QuickMsg(tipsStr)
      end
    end
  elseif pointDownPos.y - eventData.position.y > 5 then
    local monster = RoleTargetManager.GetNearestMonsterTarget(true, range)
    if monster then
      RoleTargetManager.ClearSelectPlayerTarget()
      RoleManager.me:SetTarget(monster)
    else
      local tipsStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Switch_target_monster")
      FloatingTipUtility.QuickMsg(tipsStr)
      RoleManager.me:ShowLookEnemyCircleEffect("yellow")
    end
  end
  self.BtnCommon.transform.localPosition = Vector2.zero
  self.killMonster:SetParent(self.Zone)
  self.killPerson:SetParent(self.Zone)
  self.killMonster:SetAnchoredPosition(0, 0)
  self.killPerson:SetAnchoredPosition(0, 0)
  self.killMonster:GetChild("yellow1"):SetActive(false)
  self.killMonster:GetChild("yellow2"):SetActive(false)
  self.killPerson:GetChild("red1"):SetActive(false)
  self.killPerson:GetChild("red2"):SetActive(false)
  self:SetSprite("Atlas_Main", "img_btn_new_persona_1", self.Img_player1, false)
  self:SetSprite("Atlas_Main", "img_btn_new_monster_1", self.Img_monster2, false)
end

function Main_MainSkillUI:CommonBtnClick(control)
  RiskSpotManager.RiskSpotPlaceType(RiskSpotType.ClickGeneralAttack)
  EventManager.Dispatch(Event.CloseKillMonsterCard)
  self:isSecretBossCountKey()
  if isDragCommon or Scene.IsSafeZone(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y) then
    if Scene.IsSafeZone(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y) then
      FloatingTipUtility.QuickMsg("Trong Khu An To\195\160n kh\195\180ng th\225\187\131 t\225\186\165n c\195\180ng")
    end
    return
  end
  RoleManager.me:SetAutoFight(AutoFightStrKey.ReleaseSkill)
  local effectAnchor = control:GetChild("effectAnchor")
  local effect = UIEffectUtility.SetUIEffectParent("Eff_UI_yuan", effectAnchor.gameObject, false, Vector3(20, 20, 20))
  effect:SetActive(true)
  EventManager.Dispatch(Event.BreakSitState)
end

function Main_MainSkillUI:ShowSkillBtn(control)
  for i = 1, #skillBtnSkill do
    skillBtnSkill[i].btn:SetOnClick(self, self.Button_DontDoAnyThing)
  end
  for i, skillId in pairs(SkillSettingData.skill_pan_all) do
    if i <= #skillBtnSkill then
      local skillBtn = skillBtnSkill[i].btn
      if skillId ~= 0 then
        skillBtn:SetActive(true)
        local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
        skillBtn:GetChild("frame"):SetActive(true)
        self:SetSprite("Atlas_Skill", cfg_skill.icon, skillBtn:GetChild("frame"))
        skillBtn.groupId = cfg_skill.groupId
      else
        skillBtn:GetChild("frame"):SetActive(false)
        skillBtn.groupId = nil
      end
      skillBtn.skillId = skillId
      self:UpdateCdAnim(skillBtn)
      skillBtn:SetOnClick(self, self.Button_OnSkillClick)
      skillBtn:SetOnPointerDown(self, self.Button_OnSkillPointDown)
      skillBtn:SetOnPointerExit(self, self.Button_OnSkillPointExit)
      skillBtn:SetOnPointerUp(self, self.Button_OnSkillPointUp)
    end
  end
  self:SetSpriteByCareer()
end

function Main_MainSkillUI:SetSpriteByCareer()
  local iconName = "btn_AttackChange_11"
  local mCareer = RoleUtility.GetBasicCareer(ViewData.meData.career)
  if mCareer == ERoleCareer.SwordMan or mCareer == ERoleCareer.SpellSword then
    iconName = "btn_AttackChange_11"
  elseif mCareer == ERoleCareer.Magic or mCareer == ERoleCareer.SummonMagician then
    iconName = "btn_AttackChange_12"
  elseif mCareer == ERoleCareer.Archer then
    iconName = "btn_AttackChange_13"
  end
  self:SetSprite("Atlas_Main", iconName, self.BtnChange, false)
end

function Main_MainSkillUI:ShowTurnSkillBtn(control)
  for i = 1, #skillBtnTurnSkill do
    skillBtnTurnSkill[i].btn:SetOnClick(self, self.Button_DontDoAnyThing)
  end
  for i, skillId in pairs(SkillSettingData.skill_pan_turn) do
    if i <= #skillBtnTurnSkill then
      local skillBtn = skillBtnTurnSkill[i].btn
      if skillId ~= 0 then
        skillBtn:SetActive(true)
        local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
        skillBtn:GetChild("frame"):SetActive(true)
        self:SetSprite("Atlas_Skill", tostring(cfg_skill.icon), skillBtn:GetChild("frame"))
        skillBtn.groupId = cfg_skill.groupId
      else
        skillBtn:GetChild("frame"):SetActive(false)
        skillBtn.groupId = nil
      end
      skillBtn.skillId = skillId
      self:UpdateCdAnim(skillBtn)
      skillBtn:SetOnClick(self, self.Button_OnSkillClick)
      skillBtn:SetOnPointerDown(self, self.Button_OnSkillPointDown)
      skillBtn:SetOnPointerExit(self, self.Button_OnSkillPointExit)
      skillBtn:SetOnPointerUp(self, self.Button_OnSkillPointUp)
    end
  end
end

function Main_MainSkillUI:UpdateComboSkillBtn(btn, cfg_skill)
  btn:GetChild("frame"):SetActive(true)
  self:SetSprite("Atlas_Skill", cfg_skill.icon, btn:GetChild("frame"))
  btn.groupId = cfg_skill.groupId
  btn.skillId = cfg_skill.id
  self:UpdateCdAnim(btn)
  btn:SetOnClick(self, self.Button_OnSkillClick)
end

function Main_MainSkillUI:SetComboSkillBtn(btn)
  self:SetSprite("Atlas_Skill", nil, btn:GetChild("frame"))
  btn.groupId = nil
  btn.skillId = 0
  self:UpdateCdAnim(btn)
  btn:SetOnClick(self, self.Button_DontDoAnyThing)
end

function Main_MainSkillUI:ShowMountBtn()
  if not self.Mountswitch then
    local tblMountList = ItemUtility.GetItemByTypeAndSubType(2, 22)
    for i = 1, #tblMountList do
      if ParseUtility:IsCareerIn(tblMountList[i].career, RoleManager.me.data.career) then
        local mountData = RoleManager.me.data.mountData:GetMountData(tblMountList[i].id)
        if mountData ~= nil then
          self.Mountswitch = true
        end
      end
    end
  end
  self.mount_btn:SetActive(self.Mountswitch)
end

function Main_MainSkillUI:UpdateBtnSkillId(id, skillId)
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  for k, v in pairs(skillBtnSkill) do
    if v.btn.groupId and v.btn.groupId == cfg_skill.groupId then
      skillBtnSkill[k].btn.skillId = cfg_skill.id
      SkillSettingData.SetPanAllSkill(k, cfg_skill.id)
    end
  end
  for k, v in pairs(skillBtnTurnSkill) do
    if v.btn.groupId and v.btn.groupId == cfg_skill.groupId then
      skillBtnTurnSkill[k].btn.skillId = cfg_skill.id
      SkillSettingData.SetPanTurnSkill(k, cfg_skill.id)
    end
  end
end

function Main_MainSkillUI:Button_DontDoAnyThing(control)
end

function Main_MainSkillUI:Button_OnSkillPointDown(control)
  self.PointDown = true
  if control.skillId ~= 0 then
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(control.skillId)
    local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
    if tblaction and tblaction.previousSkill and tblaction.previousSkill ~= 0 then
      SkillMgr.RequestPreviousSkill(control.skillId)
    end
  end
  EventManager.Dispatch(Event.Role_StopAutoFight)
end

function Main_MainSkillUI:Button_OnSkillPointUp(control)
  self.PointDown = false
  EventManager.Dispatch(Event.Role_RefreshAutoFight)
end

function Main_MainSkillUI:Button_OnSkillPointExit(control)
  if self.PointDown and control.skillId ~= 0 then
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(control.skillId)
    local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
    if tblaction and tblaction.previousSkill and tblaction.previousSkill ~= 0 then
      NetManager.Send(FightMessage.ReqTerminationCastSkill, {
        skillId = control.skillId
      })
    end
  end
end

function Main_MainSkillUI:CheckUseSkill(skillId)
  local meId = RoleManager.me.id
  local hasHunShuiBuff = BuffData.IsHasBuffStateByGroupId(meId, 16030100)
  if hasHunShuiBuff then
    return false
  end
  local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if string.isNullOrEmpty(skillData.skillForm) or skillData.skillForm == "0" then
    return true
  end
  local buff = BuffData.IsHasBuff(meId, self.SummonerBuffId[tonumber(skillData.skillForm)])
  return buff
end

function Main_MainSkillUI:Button_OnSkillClick(control)
  if control:GetChild("ForbidSkillImg").gameObject.activeSelf then
    return
  end
  self:isSecretBossCountKey()
  if self.ScrollDraged == true then
    self.ScrollDraged = false
    return
  end
  if control.skillId == 0 then
    UIManager.Show(UIID.Skill_SetSkillUI)
  else
    if not self:CheckUseSkill(control.skillId) then
      return
    end
    QiJiHelperData.SetPressSkill(control.skillId)
    if QiJiHelperData.isAutoFight then
      RoleManager.me:MainUIOpenAutoFightStart()
    else
      AutoTaskManage.SetCurRoleOperate(AutoTaskOperateType.SkillAttack)
      RoleManager.me:StartPressSkillAutoFight()
    end
    EventManager.Dispatch(Event.CloseKillMonsterCard)
  end
  local effect = UIEffectUtility.SetUIEffectParent("Eff_UI_yuan", control.gameObject, false, Vector3(14, 14, 14))
  effect:SetActive(true)
  EventManager.Dispatch(Event.BreakSitState)
end

function Main_MainSkillUI:GetSkillEndTime(skillId)
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local cdMsg = RoleManager.me.cd[tblSkill.groupId]
  local endTime = cdMsg and cdMsg.endTime or 0
  return endTime
end

function Main_MainSkillUI:GetSkillCdTime(skillId)
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local cdMsg = RoleManager.me.cd[tblSkill.groupId]
  local endTime = cdMsg and cdMsg.endTime or 0
  local publicCdMsg = RoleManager.me.cd[1]
  local publicEndTime = publicCdMsg and publicCdMsg.endTime or 0
  local finalEndTime = endTime >= publicEndTime and endTime or publicEndTime
  return 0 < finalEndTime - Time.GetServerTime() and (finalEndTime - Time.GetServerTime()) / 1000 or 0
end

function Main_MainSkillUI:GetSkillPastTimePercent(cdTime)
  local surplusTime = cdTime
  if surplusTime <= 0 then
    return 1
  else
    local cdPercent = 1 - surplusTime / cdTime
    return cdPercent
  end
end

function Main_MainSkillUI:RunSkillCdAnim(cdPercent, control, cdTime)
  local surplusTime = cdTime
  local skillCd = cdTime
  local surplusPercent = 1 - cdPercent
  
  local function StartCountDown()
    local countDown = 0
    local startTime = 0
    while true do
      startTime = startTime + Time.deltaTime
      countDown = startTime / skillCd < surplusPercent and startTime / skillCd or surplusPercent
      self:SetImgCdTimeFillAmount(control, surplusPercent - countDown)
      if surplusTime - startTime <= 0.001 then
        self:SetImgCdTimeFillAmount(control, 0)
        control.dgAnim = nil
        local effect = UIEffectUtility.SetUIEffectParent("Eff_UI_shanshuo", control.gameObject, false, Vector3(1, 1, 1))
        effect:SetActive(true)
        Coroutine.Break()
      end
      Coroutine.WaitForEndOfFrame()
    end
  end
  
  local function StartCountDownSeverTime()
    local countDown = 0
    local startTime = 0
    local timeserver = Time.GetServerTime() + cdTime * 1000
    while true do
      startTime = surplusTime - (timeserver - Time.GetServerTime()) / 1000
      countDown = startTime / skillCd < surplusPercent and startTime / skillCd or surplusPercent
      self:SetImgCdTimeFillAmount(control, surplusPercent - countDown)
      if surplusTime - startTime <= 0.001 then
        self:SetImgCdTimeFillAmount(control, 0)
        control.dgAnim = nil
        local effect = UIEffectUtility.SetUIEffectParent("Eff_UI_shanshuo", control.gameObject, false, Vector3(1, 1, 1))
        effect:SetActive(true)
        Coroutine.Break()
      end
      Coroutine.WaitForEndOfFrame()
    end
  end
  
  if control.dgAnim then
    Coroutine.Stop(control.dgAnim)
    control.dgAnim = nil
  end
  if control.groupId and (control.groupId == 26040100 or control.groupId == 16130100) then
    control.dgAnim = Coroutine.Start(StartCountDownSeverTime)
  else
    control.dgAnim = Coroutine.Start(StartCountDown)
  end
end

function Main_MainSkillUI:RunSkillCdAnim_Update(control, cdPercent, remainingCd, allCd)
  local surplusTime = remainingCd
  local skillCd = allCd
  local surplusPercent = cdPercent
  
  local function StartCountDown_Update()
    local countDown = 0
    local startTime = 0
    while true do
      startTime = startTime + Time.deltaTime
      countDown = startTime / skillCd < surplusPercent and startTime / skillCd or surplusPercent
      self:SetImgCdTimeFillAmount(control, surplusPercent - countDown)
      if surplusTime - startTime <= 0.001 then
        self:SetImgCdTimeFillAmount(control, 0)
        control.dgAnim = nil
        local effect = UIEffectUtility.SetUIEffectParent("Eff_UI_shanshuo", control.gameObject, false, Vector3(1, 1, 1))
        effect:SetActive(true)
        Coroutine.Break()
      end
      Coroutine.WaitForEndOfFrame()
    end
  end
  
  if control.dgAnim then
    Coroutine.Stop(control.dgAnim)
    control.dgAnim = nil
  end
  control.dgAnim = Coroutine.Start(StartCountDown_Update)
end

function Main_MainSkillUI:SetImgCdTimeFillAmount(skillBtn, amount)
  local imgCdTime
  if not skillBtn.imgCdTime then
    skillBtn.imgCdTime = skillBtn:GetChild("Img_cdTime")
    imgCdTime = skillBtn.imgCdTime
  else
    imgCdTime = skillBtn.imgCdTime
  end
  imgCdTime:SetFillAmount(amount)
  imgCdTime:SetActive(amount ~= 0)
end

function Main_MainSkillUI:IsShowCd(skillId)
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if RoleManager.me.cd[tblSkill.groupId] then
    if RoleManager.me.cd[tblSkill.groupId].endTime <= Time.GetServerTime() then
      return false
    else
      return true
    end
  else
    return false
  end
end

function Main_MainSkillUI:CountDownCd(skillBtn)
  if skillBtn.dgAnim then
    return
  end
  if not self:IsShowCd(skillBtn.skillId) then
    return
  end
  local cdTime = self:GetSkillCdTime(skillBtn.skillId)
  if cdTime == 0 then
    return
  end
  local cdPercent = self:GetSkillPastTimePercent(cdTime)
  self:SetImgCdTimeFillAmount(skillBtn, 1 - cdPercent)
  self:RunSkillCdAnim(cdPercent, skillBtn, cdTime)
end

function Main_MainSkillUI:CdAnim(skillBtn)
  if not skillBtn.groupId or not RoleManager.me.skills[skillBtn.groupId] then
    return
  end
  self:CountDownCd(skillBtn)
end

function Main_MainSkillUI:StartComboSkillCd(comboSkillBtn)
  if comboSkillBtn.skillId == 0 then
    self:CdAnim(comboSkillBtn)
  end
end

function Main_MainSkillUI:StartSkillCdAnim(_, skillId)
  for i, v in ipairs(skillBtnSkill) do
    if v.btn.skillId ~= 0 and v.btn.skillId == skillId then
      local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(v.btn.skillId)
      local chargingTimes = SkillUtility.GetChargingTimes(skillConfig)
      if 0 < chargingTimes then
        self:SetChargeSkill(v.btn)
        v.btn:GetChild("lab_chargeCount"):SetActive(true)
      else
        self:CdAnim(v.btn)
        v.btn:GetChild("lab_chargeCount"):SetActive(false)
      end
    end
  end
  for i, v in ipairs(skillBtnTurnSkill) do
    if v.btn.skillId ~= 0 and v.btn.skillId == skillId then
      local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(v.btn.skillId)
      local chargingTimes = SkillUtility.GetChargingTimes(skillConfig)
      if 0 < chargingTimes then
        self:SetChargeSkill(v.btn)
        v.btn:GetChild("lab_chargeCount"):SetActive(true)
      else
        self:CdAnim(v.btn)
        v.btn:GetChild("lab_chargeCount"):SetActive(false)
      end
    end
  end
  if self.SummonerBtnSkill.skillId and self.SummonerBtnSkill.skillId == skillId then
    local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(self.SummonerBtnSkill.skillId)
    local chargingTimes = SkillUtility.GetChargingTimes(skillConfig)
    if 0 < chargingTimes then
      self:SetChargeSkill(self.SummonerBtnSkill)
      self.SummonerBtnSkill:GetChild("lab_chargeCount"):SetActive(true)
    else
      self:CdAnim(self.SummonerBtnSkill)
      self.SummonerBtnSkill:GetChild("lab_chargeCount"):SetActive(false)
    end
  end
end

function Main_MainSkillUI:UpdateCdAnim(control)
  if control.dgAnim then
    Coroutine.Stop(control.dgAnim)
    control.dgAnim = nil
  end
  if control.chargingAnim then
    Coroutine.Stop(control.chargingAnim)
    control.chargingAnim = nil
  end
  self:SetImgCdTimeFillAmount(control, 0)
  if control.skillId ~= 0 then
    local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(control.skillId)
    local chargingTimes = SkillUtility.GetChargingTimes(skillConfig)
    if 0 < chargingTimes then
      self:SetChargeSkill(control)
      control:GetChild("lab_chargeCount"):SetActive(true)
    else
      self:CdAnim(control)
      control:GetChild("lab_chargeCount"):SetActive(false)
    end
  else
    control:GetChild("lab_chargeCount"):SetActive(false)
  end
end

function Main_MainSkillUI:SetChargeSkill(control)
  local lab_chargeCount = control:GetChild("lab_chargeCount")
  if control.skillId ~= 0 then
    local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(control.skillId)
    local chargingTimes = SkillUtility.GetChargingTimes(skillConfig)
    if 0 < chargingTimes then
      lab_chargeCount:SetActive(true)
      local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(control.skillId)
      local chargeEndTime = RoleManager.me.cd[tblSkill.groupId] and RoleManager.me.cd[tblSkill.groupId].endTime
      if chargeEndTime then
        local resCdTime = Mathf.Floor(SkillUtility.GetRealSkillCd(skillConfig, QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.attackSpeedIncrease) / 10000))
        if skillConfig.cdTimeType == 1 then
          resCdTime = SkillUtility.GetCdTime(skillConfig)
        end
        local chargingStartTime = Time.GetServerTime() - (chargingTimes - 1) * resCdTime
        if chargeEndTime > chargingStartTime then
          local intervalTime = chargeEndTime - chargingStartTime
          local counts = Mathf.Ceil(intervalTime / resCdTime)
          lab_chargeCount:SetText(0 <= chargingTimes - counts and chargingTimes - counts or 0)
          self:StartChargingAnim(lab_chargeCount, intervalTime, resCdTime, chargingTimes, control)
        else
          lab_chargeCount:SetText(chargingTimes)
        end
      else
        lab_chargeCount:SetText(chargingTimes)
      end
    else
      lab_chargeCount:SetActive(false)
    end
  else
    lab_chargeCount:SetActive(false)
  end
end

function Main_MainSkillUI:StartChargingAnim(chargingLab, intervalTime, resCdTime, chargingTimes, control)
  if control.chargingAnim then
    Coroutine.Stop(control.chargingAnim)
    control.chargingAnim = nil
  end
  
  local function ChargingAnim()
    local counts = Mathf.Ceil(intervalTime / resCdTime)
    local startIntervalTime = intervalTime
    while true do
      intervalTime = intervalTime - Time.deltaTime * 1000
      local tempCount = Mathf.Ceil(intervalTime / resCdTime)
      self:SetImgCdTimeFillAmount(control, intervalTime / startIntervalTime)
      if tempCount ~= counts then
        counts = tempCount
        chargingLab:SetText(chargingTimes - counts)
      end
      if intervalTime <= 0.001 then
        self:SetImgCdTimeFillAmount(control, 0)
        chargingLab:SetText(chargingTimes)
        Coroutine.Break()
      end
      Coroutine.WaitForEndOfFrame()
    end
  end
  
  control.chargingAnim = Coroutine.Start(ChargingAnim)
end

function Main_MainSkillUI:RegistEvents()
  self:RegistEvent(Event.Skill_Pan_Changed, self.OnSkillChanged, self)
  self:RegistEvent(Event.Skill_Id_Changed, self.UpdateBtnSkillId, self)
  self:RegistEvent(Event.UpdateSkillCd, self.StartSkillCdAnim, self)
  self:RegistEvent(Event.Main_MainModeChanged, self.OnMainModeChanged, self)
  self:RegistEvent(Event.Logic_ActiveMainUI, self.UpdateMainSkillActive, self)
  self:RegistEvent(Event.Mount_Change, self.ShowMountBtn, self)
  self:RegistEvent(Event.Skill_SkillTips, self.ShowTipsOnBtn, self)
  self:RegistEvent(Event.Skill_CdSpeedUpdate, self.Skill_CdSpeedUpdate, self)
  self:RegistEvent(Event.SkillViewModelChange, self.SkillViewModelChangeFunc, self)
  self:RegistEvent(Event.SkillBuffChange, self.SetBtnSkill, self)
end

function Main_MainSkillUI:ShowTipsOnBtn(_, skillId, tipsMsg)
  if QiJiHelperData.isAutoFight then
    return
  end
  for i, v in ipairs(skillBtnSkill) do
    if v.btn.skillId == skillId then
      FloatingWordUtility.QuickBtnMsg({
        parent = v.btn,
        msgStr = tipsMsg
      })
    end
  end
  for i, v in ipairs(skillBtnTurnSkill) do
    if v.btn.skillId == skillId then
      FloatingWordUtility.QuickBtnMsg({
        parent = v.btn,
        msgStr = tipsMsg
      })
    end
  end
end

function Main_MainSkillUI:UpdateMainSkillActive(_, state)
  self.mainSkillActive = state
  if not self.mainSkillActive then
    UIEffectUtility.DestroyAllEffect()
  end
end

function Main_MainSkillUI:OnMainModeChanged(_)
  local skillTurnBtns = skillBtnTurnSkill
  local comboTurnSkillBtn = self.ComboTurnBtnSkill
  local skillBtns = skillBtnSkill
  local comboSkillBtn = self.ComboBtnSkill
  local mount_btn = self.mount_btn
  local SummonerBtnSkill = self.SummonerBtnSkill
  if SkillData.MainMode == EMainModeType.Skill then
    for _, skillInfo in pairs(skillBtns) do
      local quence = DOTween.Sequence()
      quence:Append(skillInfo.btn.transform:DOScale(Vector3.one, C_UISettings.SkillUIScaleTime))
      quence:Insert(0, skillInfo.btn.transform:DOLocalMove(skillInfo.pos, C_UISettings.SkillUIMoveTime):SetEase(Ease.OutBack))
    end
    for _, skillInfo in pairs(skillTurnBtns) do
      local quence = DOTween.Sequence()
      quence:Append(skillInfo.btn.transform:DOScale(Vector3.one, C_UISettings.SkillUIScaleTime))
      quence:Insert(0, skillInfo.btn.transform:DOLocalMove(skillInfo.pos, C_UISettings.SkillUIMoveTime):SetEase(Ease.OutBack))
    end
    local quence1 = DOTween.Sequence()
    quence1:Append(comboSkillBtn.transform:DOScale(Vector3.one, C_UISettings.SkillUIScaleTime))
    quence1:Insert(0, comboSkillBtn.transform:DOLocalMove(comboSkillBtn.pos, C_UISettings.SkillUIMoveTime):SetEase(Ease.OutBack))
    local quence2 = DOTween.Sequence()
    quence2:Append(comboTurnSkillBtn.transform:DOScale(Vector3.one, C_UISettings.SkillUIScaleTime))
    quence2:Insert(0, comboTurnSkillBtn.transform:DOLocalMove(comboTurnSkillBtn.pos, C_UISettings.SkillUIMoveTime):SetEase(Ease.OutBack))
    local quence3 = DOTween.Sequence()
    quence3:Append(self.Zone.transform:DOScale(Vector3.one, C_UISettings.SkillUIScaleTime))
    quence3:Insert(0, self.Zone.transform:DOLocalMove(self.BtnCommonPos, C_UISettings.SkillUIMoveTime):SetEase(Ease.OutBack))
    local quence4 = DOTween.Sequence()
    quence4:Append(mount_btn.transform:DOScale(Vector3.one, C_UISettings.SkillUIScaleTime))
    quence4:Insert(0, mount_btn.transform:DOLocalMove(mount_btn.pos, C_UISettings.SkillUIMoveTime):SetEase(Ease.OutBack))
    local quence5 = DOTween.Sequence()
    quence5:Append(SummonerBtnSkill.transform:DOScale(Vector3.one, C_UISettings.SkillUIScaleTime))
    quence5:Insert(0, SummonerBtnSkill.transform:DOLocalMove(SummonerBtnSkill.pos, C_UISettings.SkillUIMoveTime):SetEase(Ease.OutBack))
  else
    for _, skillInfo in pairs(skillBtns) do
      local quence = DOTween.Sequence()
      quence:Append(skillInfo.btn.transform:DOMove(self.go_fake.transform.position, C_UISettings.SkillUIMoveTime))
      quence:Insert(C_UISettings.SkillUIDelayScaleTime, skillInfo.btn.transform:DOScale(Vector3.zero, C_UISettings.SkillUIScaleTime))
    end
    for _, skillInfo in pairs(skillTurnBtns) do
      local quence = DOTween.Sequence()
      quence:Append(skillInfo.btn.transform:DOMove(self.go_fake.transform.position, C_UISettings.SkillUIMoveTime))
      quence:Insert(C_UISettings.SkillUIDelayScaleTime, skillInfo.btn.transform:DOScale(Vector3.zero, C_UISettings.SkillUIScaleTime))
    end
    local quence1 = DOTween.Sequence()
    quence1:Append(comboSkillBtn.transform:DOMove(self.go_fake.transform.position, C_UISettings.SkillUIMoveTime))
    quence1:Insert(C_UISettings.SkillUIDelayScaleTime, comboSkillBtn.transform:DOScale(Vector3.zero, C_UISettings.SkillUIScaleTime))
    local quence2 = DOTween.Sequence()
    quence2:Append(comboTurnSkillBtn.transform:DOMove(self.go_fake.transform.position, C_UISettings.SkillUIMoveTime))
    quence2:Insert(C_UISettings.SkillUIDelayScaleTime, comboTurnSkillBtn.transform:DOScale(Vector3.zero, C_UISettings.SkillUIScaleTime))
    local quence3 = DOTween.Sequence()
    quence3:Append(self.Zone.transform:DOMove(self.go_fake.transform.position, C_UISettings.SkillUIMoveTime))
    quence3:Insert(C_UISettings.SkillUIDelayScaleTime, self.Zone.transform:DOScale(Vector3.zero, C_UISettings.SkillUIScaleTime))
    local quence4 = DOTween.Sequence()
    quence4:Append(mount_btn.transform:DOMove(self.go_fake.transform.position, C_UISettings.SkillUIMoveTime))
    quence4:Insert(C_UISettings.SkillUIDelayScaleTime, mount_btn.transform:DOScale(Vector3.zero, C_UISettings.SkillUIScaleTime))
    local quence5 = DOTween.Sequence()
    quence5:Append(SummonerBtnSkill.transform:DOMove(self.go_fake.transform.position, C_UISettings.SkillUIMoveTime))
    quence5:Insert(C_UISettings.SkillUIDelayScaleTime, SummonerBtnSkill.transform:DOScale(Vector3.zero, C_UISettings.SkillUIScaleTime))
  end
end

function Main_MainSkillUI:OnSkillChanged(id, msg)
  self:Refresh()
end

local function Mounttip(str)
  UIManager.Show(UIID.PromptTipUI, {
    tile = "Nh\225\186\175c nh\225\187\159",
    textContent = str
  })
end

function Main_MainSkillUI:SetMountOnclick()
  if RoleManager.me.hp <= 0 then
    return
  end
  if Scene.sitPos then
    FloatingWordUtility.QuickMsg("Tr\225\186\161ng th\195\161i ng\225\187\147i xu\225\187\145ng kh\195\180ng th\225\187\131 c\198\176\225\187\161i th\195\186 c\198\176\225\187\161i")
    return
  end
  if MountData.DefaultMount ~= 0 then
    if RoleManager.me.data.rideMount and MountData.DefaultMount == RoleManager.me.data.rideMount.id then
      NetManager.Send(EquipMessage.ReqChangeHorseState, {
        position = RoleManager.me.data.rideMount.bagGridIndex,
        ride = false
      })
      return
    end
    local mountData = RoleManager.me.data.mountData:GetidMountData(MountData.DefaultMount)
    if not mountData then
      local str = "\196\144\195\163 h\225\187\167y m\225\186\183c \196\145\225\187\139nh c\198\176\225\187\161i th\195\186 c\198\176\225\187\161i, h\195\163y ch\225\187\141n c\198\176\225\187\161i l\225\186\161i"
      Mounttip(str)
      return
    end
    if RoleManager.me:IsCurSafeZone() and mountData.cityride ~= 1 then
      local str = "Trong khu an to\195\160n kh\195\180ng th\225\187\131 c\198\176\225\187\161i th\195\186 c\198\176\225\187\161i"
      Mounttip(str)
      return
    end
    local mapTable = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
    if mapTable ~= nil then
      if mapTable.mountType == 1 then
        local str = "B\225\186\163n \196\145\225\187\147 hi\225\187\135n t\225\186\161i kh\195\180ng th\225\187\131 c\198\176\225\187\161i Th\195\186 C\198\176\225\187\161i n\195\160y"
        Mounttip(str)
        return
      elseif mapTable.mountType == 2 and ClientTable.cfg_Map_mapManager:IsNowMapChangeHorseState(mapTable, mountData.itemId) == false then
        local str = "B\225\186\163n \196\145\225\187\147 hi\225\187\135n t\225\186\161i kh\195\180ng th\225\187\131 c\198\176\225\187\161i Th\195\186 C\198\176\225\187\161i n\195\160y"
        Mounttip(str)
        return
      end
    end
    NetManager.Send(EquipMessage.ReqChangeHorseState, {
      position = mountData.bagGridIndex,
      ride = true
    })
  else
    local str = "Ch\198\176a ch\225\187\141n m\225\186\183c \196\145\225\187\139nh c\198\176\225\187\161i"
    Mounttip(str)
  end
end

function Main_MainSkillUI:TurnOrAllActive()
  if SkillSettingData.curmode == EPanModeType.Turn then
    self.SkillTurnStruct:SetActive(true)
    self.SkillStruct:SetActive(false)
  elseif SkillSettingData.curmode == EPanModeType.All then
    self.SkillTurnStruct:SetActive(false)
    self.SkillStruct:SetActive(true)
  end
  UIEffectUtility.DestroyAllEffect()
end

function Main_MainSkillUI:Refresh()
  self:ShowSkillBtn()
  self:ShowTurnSkillBtn()
  self:TurnOrAllActive()
  self:OnDragEventEnd(nil, nil)
  self:ShowMountBtn()
  self:RefreshForbidSkillImg()
  self:SetBtnSkill()
end

function Main_MainSkillUI:OnRefresh()
end

function Main_MainSkillUI:OnBeginDrag(control, eventData)
  self.ScrollDraged = true
end

function Main_MainSkillUI:InitSilenceBuff()
  self.silenceBuff = {}
  local globalEffect = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2430019)
  local info = string.split(globalEffect, "#")
  for i, v in pairs(info) do
    self.silenceBuff[tonumber(v)] = tonumber(v)
  end
end

function Main_MainSkillUI:RefreshForbidSkillImg()
  self.isSilence = false
  if table.count(self.silenceBuff) > 0 then
    for i, v in pairs(self.silenceBuff) do
      if BuffData.IsHasBuffStateByGroupId(RoleManager.me.id, v) then
        self.isSilence = true
        break
      end
    end
  end
  local skillBtn = SkillSettingData.curmode == EPanModeType.All and skillBtnSkill or skillBtnTurnSkill
  for i, v in pairs(skillBtn) do
    if v.btn.skillId and v.btn.skillId ~= 0 then
      v.btn:GetChild("ForbidSkillImg").gameObject:SetActive(self.isSilence)
    else
      v.btn:GetChild("ForbidSkillImg").gameObject:SetActive(false)
    end
  end
  if QuickFind.LuaMainPlayerViewAttrData():GetBaseCareer() == ERoleCareer.SummonMagician then
    self.SummonerBtnForbidSkillImg:SetActive(self.isSilence)
  end
  if self.isSilence then
    return
  end
  if QuickFind.LuaMainPlayerViewAttrData():GetBaseCareer() == ERoleCareer.SummonMagician then
    local skillForm = self.CurrStaeChangeSkill and self.CurrStaeChangeSkill or nil
    if skillForm then
      for i, v in ipairs(skillBtn) do
        if v.btn.skillId and v.btn.skillId ~= 0 then
          local configSkillForm = ClientTable.cfg_Skill_skillManager:TryGetValue(v.btn.skillId).skillForm
          if configSkillForm and configSkillForm ~= "" then
            v.btn:GetChild("ForbidSkillImg").gameObject:SetActive(skillForm ~= tonumber(configSkillForm))
          elseif not configSkillForm or configSkillForm == "" then
            v.btn:GetChild("ForbidSkillImg").gameObject:SetActive(false)
          end
        end
      end
    end
  end
end

function Main_MainSkillUI:SetSummonerBuffInfo()
  local buffInfo = ClientTable.cfg_Global_globalManager:TryGetValue(16010101).effect
  self.SummonerBuffId = {}
  local buffs = string.split(buffInfo, "&")
  for i, v in pairs(buffs) do
    local skillForm = string.split(v, "#")
    self.SummonerBuffId[tonumber(skillForm[1])] = tonumber(skillForm[2])
  end
  local img = {
    [1] = ClientTable.cfg_Skill_skillManager:TryGetValue(16090101).icon,
    [2] = ClientTable.cfg_Skill_skillManager:TryGetValue(16020101).icon
  }
  self.SummonerBtnSkillImg = img
end

function Main_MainSkillUI:SetBtnSkill()
  if QuickFind.LuaMainPlayerViewAttrData():GetBaseCareer() == ERoleCareer.SummonMagician then
    local buff1 = BuffData.IsHasBuff(RoleManager.me.id, self.SummonerBuffId[1])
    local buff2 = BuffData.IsHasBuff(RoleManager.me.id, self.SummonerBuffId[2])
    local skillInfo1 = ViewData.meData.skills[ClientTable.cfg_Skill_skillManager:TryGetValue(16090101).groupId]
    local skillInfo2 = ViewData.meData.skills[ClientTable.cfg_Skill_skillManager:TryGetValue(16020101).groupId]
    if buff1 then
      self.SummonerBtnSkill:SetActive(true)
      self.CurrStaeChangeSkill = 1
      self.ShoudShowState = skillInfo2 and 2 or 1
      self:SetSummonerBtnIcon(self.ShoudShowState)
    elseif buff2 then
      self.SummonerBtnSkill:SetActive(true)
      self.CurrStaeChangeSkill = 2
      self.ShoudShowState = skillInfo1 and 1 or 2
      self:SetSummonerBtnIcon(self.ShoudShowState)
    else
      self.SummonerBtnSkill:SetActive(false)
    end
    self:RefreshForbidSkillImg()
  else
    self.SummonerBtnSkill:SetActive(false)
    self:RefreshForbidSkillImg()
  end
end

function Main_MainSkillUI:SetSummonerBtnIcon(SkillForm)
  if self.SummonerBtnSkillImg[SkillForm] then
    if self.spriteCol then
      Coroutine.Stop(self.spriteCol)
      self.spriteCol = nil
    end
    self.spriteCol = self:SetSprite("Atlas_Skill", self.SummonerBtnSkillImg[SkillForm], self.SummonerBtnSkill:GetChild("frame"))
  end
end

function Main_MainSkillUI:SummonerSkillClick()
  if self.SummonerBtnSkill:GetChild("Img_cdTime") and self.SummonerBtnSkill:GetChild("Img_cdTime").gameObject.activeSelf then
    return
  end
  local skillInfo1 = ViewData.meData.skills[ClientTable.cfg_Skill_skillManager:TryGetValue(16090101).groupId]
  local skillInfo2 = ViewData.meData.skills[ClientTable.cfg_Skill_skillManager:TryGetValue(16020101).groupId]
  if BuffData.IsHasBuff(RoleManager.me.id, self.SummonerBuffId[1]) or BuffData.IsHasBuff(RoleManager.me.id, self.SummonerBuffId[2]) then
    local useSkill = {
      [1] = skillInfo1,
      [2] = skillInfo2
    }
    self.SummonerBtnSkill.skillId = useSkill[self.ShoudShowState].sid
    self.SummonerBtnSkill.groupId = ClientTable.cfg_Skill_skillManager:TryGetValue(self.SummonerBtnSkill.skillId).groupId
    self:Button_OnSkillClick(self.SummonerBtnSkill)
  end
end

function Main_MainSkillUI:IsLearnSkill(skillId)
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if RoleManager.me.skills[cfg_skill.groupId] and RoleManager.me.skills[cfg_skill.groupId].sid == skillId then
    return true
  end
  return false
end

function Main_MainSkillUI:OnDragEvent(control, eventData)
  local angle = self.SkillTurnStruct.transform.localEulerAngles
  if angle.z ~= 0 and angle.z < 200 or angle.z > 360 then
    return
  end
  local nor = eventData.delta.y
  if Mathf.Abs(eventData.delta.x) > Mathf.Abs(eventData.delta.y) then
    nor = eventData.delta.x
  end
  local mag = Vector2.Magnitude(eventData.delta)
  if nor < 0 then
    angle.z = angle.z + mag * 0.4
  else
    angle.z = angle.z - mag * 0.4
  end
  if angle.z > 0 and angle.z < 100 or angle.z > 360 then
    angle.z = 0
  end
  if angle.z > 100 and angle.z < 200 then
    angle.z = 200
  end
  self.SkillTurnStruct.transform.localEulerAngles = angle
  for i, v in pairs(skillBtnSkill) do
    v.btn.transform:SetEulerAngles(0, 0, 0)
  end
  for i, v in pairs(skillBtnTurnSkill) do
    v.btn.transform:SetEulerAngles(0, 0, 0)
  end
end

function Main_MainSkillUI:OnDragEventEnd(control, eventData)
  self.ScrollDraged = false
  local angle = self.SkillTurnStruct.transform.localEulerAngles
  local delta = 0
  local tmp1, tmp2 = math.modf(angle.z / 40)
  if tmp2 < 0.5 then
    angle.z = tmp1 * 40 - delta
  else
    angle.z = (tmp1 + 1) * 40 - delta
  end
  if 0 < angle.z and angle.z < 100 or angle.z > 360 then
    angle.z = 0
  end
  if angle.z > 100 and angle.z < 200 then
    angle.z = 200
  end
  self.SkillTurnStruct.transform.localEulerAngles = angle
  for _, v in pairs(skillBtnSkill) do
    v.btn.transform:SetEulerAngles(0, 0, 0)
  end
  for _, v in pairs(skillBtnTurnSkill) do
    v.btn.transform:SetEulerAngles(0, 0, 0)
  end
end

function Main_MainSkillUI:isSecretBossCountKey()
  if TranScriptData.InTranscript and TranScriptData.InTranscriptType == TranScriptType.SecretBoss and TranScriptData.InTranscriptData.instanceType == 1106 then
    local levelRestrict = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.groupId, "id").enterCondition
    local countKey = levelRestrict[1][2][2][1]
    local count = RefreshData.GetInstanceCount(tonumber(countKey))
    if count <= 0 then
      FloatingTipUtility.QuickMsg("S\225\187\145 l\225\186\167n c\195\178n l\225\186\161i kh\195\180ng \196\145\225\187\167, kh\195\180ng th\225\187\131 g\195\162y s\195\161t th\198\176\198\161ng")
    end
  end
end

function Main_MainSkillUI:Skill_CdSpeedUpdate(_, data)
  if data == nil then
    return
  end
  for i, v in ipairs(skillBtnSkill) do
    if v.btn.skillId ~= 0 and v.btn.skillId == data.skillId then
      local skillBtn = v.btn
      self:SetImgCdTimeFillAmount(skillBtn, data.schedule)
      self:RunSkillCdAnim_Update(skillBtn, data.schedule, data.remainingCd / 1000, data.allCd / 1000)
    end
  end
  for i, v in ipairs(skillBtnTurnSkill) do
    if v.btn.skillId ~= 0 and v.btn.skillId == data.skillId then
      local skillBtn = v.btn
      self:SetImgCdTimeFillAmount(skillBtn, data.schedule)
      self:RunSkillCdAnim_Update(skillBtn, data.schedule, data.remainingCd / 1000, data.allCd / 1000)
    end
  end
end

function Main_MainSkillUI:SkillViewModelChangeFunc()
  if SkillData.MainMode == EMainModeType.Func then
    SkillData.MainMode = EMainModeType.Skill
    EventManager.Dispatch(Event.Main_MainModeChanged)
  end
end
