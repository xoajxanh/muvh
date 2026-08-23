Puzzle_JH_XiangqianUI = class(BaseUI)
Puzzle_JH_XiangqianUI.layer = UILayer.Panel
Puzzle_JH_XiangqianUI.orderInLayer = 0
Puzzle_JH_XiangqianUI.hideType = UIHideType.WaitDestroy
Puzzle_JH_XiangqianUI.hideFunc = UIHideFunc.MoveOutOfScreen
Puzzle_JH_XiangqianUI.escClose = UIEscClose.DontClose

function Puzzle_JH_XiangqianUI:InitControls()
  self.btn_Close = self:GetControl("Button_CloseBag")
  self.btn_attribute = self:GetControl("btn_attribute")
  self.btn_skill = self:GetControl("btn_skill")
  self.btn_Detach = self:GetControl("btn_detach")
  self.btn_index = self:GetControl("btn_index")
  self.Img_TipBg = self:GetControl("crystalNucleusSkill/TipMask/Img_TipBg")
  self.btn_closeTip = self:GetControl("crystalNucleusSkill/btn_closeTip")
  self.Tip_ModelShow = self:GetControl("crystalNucleusSkill/TipMask/Img_TipBg/sv_center/Viewport/Content/Tip_ModelShow")
end

function Puzzle_JH_XiangqianUI:Init()
  self.lastHitPointTab = {}
end

function Puzzle_JH_XiangqianUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnItemCrystalNucleusSkillOnRefresh(ctr, _, data, ui)
  if data == nil then
    return
  end
  local color = ItemQuality2ColorDic[10]
  local skill = ClientTable.cfg_Skill_skillManager:TryGetValue(data.skillid)
  if skill and skill.level <= ui.skillLevel then
    color = ItemQuality2ColorDic[5]
  end
  ctr.lab_skill:SetText(string.GetColorText(data.skillName, color))
  local skillDes = ClientTable.cfg_Item_tipsManager:TryGetValue(data.skillid)
  if skillDes then
    ctr.lab_skillDescription:SetText(string.GetColorText(skillDes.content, color))
  end
  ui:SetSprite("Atlas_Skill", skill.icon, ctr.img_skill)
end

local function OnItemCrystalNucleusSkillInit(control)
  control.lab_skill = UIControl(control.transform, "img_skill_ground/lab_skill")
  control.lab_skillDescription = UIControl(control.transform, "lab_skillDescription")
  control.img_skill = UIControl(control.transform, "img_skill")
end

function Puzzle_JH_XiangqianUI:InitUI()
  self:InitControlList()
  self.WhetherToExpandTip = false
  self.dataCount = 1
  self.startPos = self.Img_TipBg.transform.localPosition
  self.finishPos = nil
  self.itemCrystalNucleusSkill = UIContainer(self.Tip_ModelShow, self, OnItemCrystalNucleusSkillInit, OnItemCrystalNucleusSkillOnRefresh)
end

function Puzzle_JH_XiangqianUI:InitControlList()
  self.pedestalPointTemplateTab = {}
  local pedestalPointTab = CrystalNucleusManager:GetPedestalPointTab()
  if pedestalPointTab == nil or next(pedestalPointTab) == nil then
    return
  end
  for i = 1, #pedestalPointTab do
    for j = 1, #pedestalPointTab[i] do
      local point, pointIndex = pedestalPointTab[i][j], pedestalPointTab[i][j].m_Index
      if point == nil then
        return
      end
      local control, template = (self:GetControl(string.format("OtherView/CrystalNucleus/crystalNucleus_%s", pointIndex)))
      if control then
        template = luaTemplateManager.GetNewTemplate(control, LuaComponentTemplates.CrystalNucleusPedestalItemPointTemplate, self)
      end
      self.pedestalPointTemplateTab[pointIndex] = template
    end
  end
end

function Puzzle_JH_XiangqianUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
  self.btn_skill:SetOnClick(self, self.btn_skillOnClick)
  self.btn_attribute:SetOnClick(self, self.btn_attributeOnClick)
  self.btn_Detach:SetOnClick(self, self.btn_DetachOnClick)
  self.btn_index:SetOnClick(self, self.btn_indexOnClick)
  self.btn_closeTip:SetOnClick(self, self.btn_closeTipOnClick)
end

function Puzzle_JH_XiangqianUI:btn_closeTipOnClick()
  self.btn_index:SetInteractable(false)
  if self.panelTween then
    self.panelTween:Kill()
    self.panelTween = nil
  end
  self.WhetherToExpandTip = false
  self.btn_closeTip:SetActive(false)
  self.btn_index:SetLocalEulerAnglesZ(0)
  local nowPosY = self.Img_TipBg.transform.localPosition.y
  self.panelTween = DOTween.To(function(value)
    local x = self.Img_TipBg.transform.localPosition.x
    local z = self.Img_TipBg.transform.localPosition.z
    self.Img_TipBg.transform.localPosition = Vector3(x, value, z)
  end, nowPosY, nowPosY - Mathf.Abs(nowPosY) * (self.dataCount - 1), 0.2):SetEase(Ease.OutQuad):OnComplete(function()
    self.btn_index:SetInteractable(true)
    self.Img_TipBg.transform.localPosition = self.startPos
  end)
end

function Puzzle_JH_XiangqianUI:btn_indexOnClick()
  self.btn_index:SetInteractable(false)
  if self.panelTween then
    self.panelTween:Kill()
    self.panelTween = nil
  end
  if self.WhetherToExpandTip == false then
    self.btn_index:SetLocalEulerAnglesZ(180)
    local nowPosY = self.Img_TipBg.transform.localPosition.y
    self.panelTween = DOTween.To(function(value)
      local x = self.Img_TipBg.transform.localPosition.x
      local z = self.Img_TipBg.transform.localPosition.z
      self.Img_TipBg.transform.localPosition = Vector3(x, value, z)
    end, nowPosY, nowPosY + Mathf.Abs(nowPosY) * (self.dataCount - 1), 0.2):SetEase(Ease.OutQuad):OnComplete(function()
      self.btn_index:SetInteractable(true)
      self.btn_closeTip:SetActive(true)
      if self.finishPos == nil then
        self.finishPos = self.Img_TipBg.transform.localPosition
      else
        self.Img_TipBg.transform.localPosition = self.finishPos
      end
    end)
  else
    self.btn_closeTip:SetActive(false)
    self.btn_index:SetLocalEulerAnglesZ(0)
    local nowPosY = self.Img_TipBg.transform.localPosition.y
    self.panelTween = DOTween.To(function(value)
      local x = self.Img_TipBg.transform.localPosition.x
      local z = self.Img_TipBg.transform.localPosition.z
      self.Img_TipBg.transform.localPosition = Vector3(x, value, z)
    end, nowPosY, nowPosY - Mathf.Abs(nowPosY) * (self.dataCount - 1), 0.2):SetEase(Ease.OutQuad):OnComplete(function()
      self.btn_index:SetInteractable(true)
      self.Img_TipBg.transform.localPosition = self.startPos
    end)
  end
  self.WhetherToExpandTip = not self.WhetherToExpandTip
end

function Puzzle_JH_XiangqianUI:btn_CloseOnClick()
  UIManager.Hide(UIID.Puzzle_JH_NavUI)
end

function Puzzle_JH_XiangqianUI:btn_skillOnClick()
  UIManager.Show(UIID.Tip_CommonTipsUI, {
    showType = CommonTipsEnum.CrystalNucleusSkill
  })
end

function Puzzle_JH_XiangqianUI:btn_attributeOnClick()
  UIManager.Show(UIID.Tip_CommonTipsUI, {
    showType = CommonTipsEnum.CrystalNucleusAttribute
  })
end

function Puzzle_JH_XiangqianUI:btn_DetachOnClick()
  CrystalNucleusPointController.ReqTakeOffNucleus(nil, true)
end

function Puzzle_JH_XiangqianUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Puzzle_JH_XiangqianUI:RegistEvents()
  self:RegistEvent(Event.CrystalNucleusPedestalChange, self.Refresh, self)
  self:RegistEvent(Event.CrystalNucleusHitResultRefresh, self.CrystalNucleusHitResultRefresh, self)
  self:RegistEvent(Event.CrystalNucleusHitResultReset, self.ResetAllHitResult, self)
end

function Puzzle_JH_XiangqianUI:Refresh()
  self:RefreshCrystalNucleusPedestal()
  self:RefreshCrystalNucleusSkill()
  self.btn_closeTip:SetActive(false)
end

function Puzzle_JH_XiangqianUI:RefreshCrystalNucleusSkill()
  self.skillLevel = 0
  local skillData = ClientTable.cfg_puzzle_skillManager:GetDic()
  if skillData then
    for i, v in ipairs(skillData) do
      local isSkill = false
      for j, k in ipairs(ViewData.meData.allSkills) do
        if k.sid == v.skillid then
          self.skillLevel = k.level
          isSkill = true
          break
        end
      end
      if isSkill then
        break
      end
    end
  end
  local data = {}
  local count = 0
  if self.skillLevel + 3 >= table.count(skillData) then
    count = table.count(skillData)
  else
    count = self.skillLevel + 3
  end
  for i = self.skillLevel, count do
    table.insert(data, skillData[i])
  end
  self.btn_index:SetActive(true)
  if #data == 1 then
    self.btn_index:SetActive(false)
  else
    self.dataCount = #data
  end
  self.itemCrystalNucleusSkill:SetData(data)
end

function Puzzle_JH_XiangqianUI:RefreshCrystalNucleusPedestal()
  if self.pedestalPointTemplateTab == nil then
    return
  end
  for index, v in ipairs(self.pedestalPointTemplateTab) do
    v:Refresh(CrystalNucleusManager:GetPedestalPointByIndex(index), self)
  end
end

function Puzzle_JH_XiangqianUI:CrystalNucleusHitResultRefresh(_, _msg)
  if self.lastHitPointTab and table.count(self.lastHitPointTab) > 0 then
    self:ResetAppointHitPointTab(self.lastHitPointTab)
    self.lastHitPointTab = {}
  end
  if table.count(_msg) == 0 or self.pedestalPointTemplateTab == nil then
    return
  end
  for i, v in pairs(_msg) do
    local template = self.pedestalPointTemplateTab[v.m_Index]
    if template then
      template:RefreshHitResult()
      table.insert(self.lastHitPointTab, template)
    end
  end
end

function Puzzle_JH_XiangqianUI:ResetAppointHitPointTab(_pointTemplateTab)
  if _pointTemplateTab == nil then
    return
  end
  for i, v in pairs(_pointTemplateTab) do
    if v and v.ResetHitResult then
      v:ResetHitResult()
    end
  end
end

function Puzzle_JH_XiangqianUI:ResetAllHitResult()
  if self.pedestalPointTemplateTab == nil then
    return
  end
  self:ResetAppointHitPointTab(self.pedestalPointTemplateTab)
end

function Puzzle_JH_XiangqianUI:OnHide()
  if self.panelTween then
    self.panelTween:Kill()
    self.panelTween = nil
  end
  self.Img_TipBg.transform.localPosition = self.startPos
  self.WhetherToExpandTip = false
  self.btn_index:SetLocalEulerAnglesZ(0)
  self.btn_closeTip:SetActive(true)
end

function Puzzle_JH_XiangqianUI:OnDestroy()
end
