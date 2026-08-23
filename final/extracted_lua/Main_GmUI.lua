Main_GmUI = class(BaseUI)
Main_GmUI.layer = UILayer.Panel
Main_GmUI.orderInLayer = 0
Main_GmUI.hideType = UIHideType.Destroy
Main_GmUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_GmUI.escClose = UIEscClose.DontClose

function Main_GmUI:InitControls()
  self.img_GM = self:GetControl("img_GM")
  self.btn_inputSkillInfo = self:GetControl("img_GM/btn_inputSkillInfo")
  self.lab_inputSkill = self:GetControl("img_GM/btn_inputSkillInfo/lab_inputSkill")
  self.InputField_speed = self:GetControl("img_GM/InputField_speed")
  self.btn_editSpeed = self:GetControl("img_GM/btn_editSpeed")
  self.Dropdown_LearSkill = self:GetControl("img_GM/Dropdown_LearSkill")
  self.btn_learSkill = self:GetControl("img_GM/btn_learSkill")
  self.lab_curSpeed = self:GetControl("img_GM/lab_curSpeed")
  self.btn_refresh = self:GetControl("img_GM/btn_refresh")
  self.lab_curMoveSpeed = self:GetControl("img_GM/lab_curMoveSpeed")
  self.InputField_MoveSpeed = self:GetControl("img_GM/InputField_MoveSpeed")
  self.btn_editMoveSpeed = self:GetControl("img_GM/btn_editMoveSpeed")
end

function Main_GmUI:OnPreLoad()
end

function Main_GmUI:Init()
  self.career = -1
  self.skillTbl = {}
  self.skillIndex = 1
end

function Main_GmUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_GmUI:InitUI()
end

function Main_GmUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_GmUI:OnHide()
  self.career = -1
  self.skillTbl = {}
  self.skillIndex = 1
end

function Main_GmUI:OnDestroy()
end

function Main_GmUI:Update()
end

function Main_GmUI:RegistUIEvents()
  self.btn_inputSkillInfo:SetOnClick(self, self.OnInputSkillInfo)
  self.btn_editSpeed:SetOnClick(self, self.OnEditSpeed)
  self.btn_editMoveSpeed:SetOnClick(self, self.OnEditMoveSpeed)
  self.Dropdown_LearSkill:SetOnDropDownValueChanged(self, self.dp_LearSkill)
  self.btn_learSkill:SetOnClick(self, self.OnLearSkill)
  self.btn_refresh:SetOnClick(self, self.OnBtnRefresh)
end

function Main_GmUI:OnInputSkillInfo()
  if SkillData.needInputSkillInfo then
    EventManager.Dispatch(Event.Skill_SkillInfoInput)
  end
  SkillData.needInputSkillInfo = not SkillData.needInputSkillInfo
  local str = SkillData.needInputSkillInfo and "Th\195\180ng tin thi tri\225\187\131n k\225\187\185 n\196\131ng" or "B\225\186\175t \196\145\225\186\167u ghi ch\195\169p K\225\187\185 N\196\131ng"
  self.lab_inputSkill:SetText(str)
end

function Main_GmUI:OnEditSpeed()
  local attackSpeedIncrease = self.InputField_speed:GetInputText()
  if not tonumber(attackSpeedIncrease) then
    return
  end
  attackSpeedIncrease = string.trim(attackSpeedIncrease)
  local gmStr = "@18 157#" .. attackSpeedIncrease
  NetManager.Send(ChatMessage.ReqGM, {info = gmStr})
  ViewData.meData.attributeMap[EAttributeType.attackSpeedIncrease] = tonumber(attackSpeedIncrease)
  ViewData.meData.attributeMap[EAttributeType.attackSpeedUI] = ViewData.meData.attributeMap[EAttributeType.attackSpeedIncrease] * 0.01
  ViewData.meData.attributeMap[EAttributeType.attackSpeedCalculateValue] = ViewData.meData.attributeMap[EAttributeType.attackSpeedIncrease] * 1.0E-4
  self.InputField_speed:SetInputText("")
  self:ShowSpeed()
end

function Main_GmUI:OnEditMoveSpeed()
  local targetSpeed = self.InputField_MoveSpeed:GetInputText()
  if not tonumber(targetSpeed) then
    return
  end
  targetSpeed = string.trim(targetSpeed)
  local currentSpeed = ViewData.meData.attributeMap[EAttributeType.moveSpeed]
  local gmStr = string.format("@39 %s", targetSpeed)
  NetManager.Send(ChatMessage.ReqGM, {info = gmStr})
  
  function RoleManager.me.GetMoveSpeed()
    return (currentSpeed + targetSpeed) * 0.01
  end
  
  self.InputField_MoveSpeed:SetInputText("")
  self.lab_curMoveSpeed:SetText(string.format("T\225\187\145c \196\145\225\187\153 di chuy\225\187\131n hi\225\187\135n t\225\186\161i %s", currentSpeed + targetSpeed))
end

function Main_GmUI:dp_LearSkill(control, value)
  self.skillIndex = value + 1
end

function Main_GmUI:OnLearSkill()
  local gmStr = "@6 " .. self.skillTbl[self.skillIndex].id
  NetManager.Send(ChatMessage.ReqGM, {info = gmStr})
end

function Main_GmUI:OnBtnRefresh()
  self:Refresh()
end

function Main_GmUI:RegistEvents()
end

function Main_GmUI:Refresh()
  self.career = ViewData.meData.career
  self.skillTbl = {}
  local cfgSkill = ClientTable.cfg_Skill_skillManager:GetDic()
  for _, skillInfo in pairs(cfgSkill) do
    if string.contains(skillInfo.career, tostring(self.career)) and skillInfo.level == 1 then
      table.insert(self.skillTbl, skillInfo)
    end
  end
  self.Dropdown_LearSkill.dropdown:ClearOptions()
  for _, skill in pairs(self.skillTbl) do
    self.Dropdown_LearSkill.dropdown:AddOption(skill.name)
  end
  self:ShowSpeed()
end

function Main_GmUI:ShowSpeed()
  local a = string.GetColorText(tostring(ViewData.meData.attributeMap[EAttributeType.attackSpeedCalculateValue]), "#FF7300")
  self.lab_curSpeed:SetText("C\195\180ng T\225\187\145c hi\225\187\135n t\225\186\161i: " .. a)
end
