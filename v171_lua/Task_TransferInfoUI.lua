Task_TransferInfoUI = class(BaseUI)
Task_TransferInfoUI.layer = UILayer.Panel
Task_TransferInfoUI.orderInLayer = 0
Task_TransferInfoUI.hideType = UIHideType.WaitDestroy
Task_TransferInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Task_TransferInfoUI.escClose = UIEscClose.DontClose

function Task_TransferInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Panel_Task = self:GetControl("Panel_Task")
  self.btn_close = self:GetControl("Panel_Task/btn_close")
  self.img_taskName = self:GetControl("Panel_Task/img_taskName")
  self.text_taskName = self:GetControl("Panel_Task/img_taskName/text_taskName")
  self.successful_transfer_info = self:GetControl("Panel_Task/background/successful_transfer_info")
  self.transfer_text1 = self:GetControl("Panel_Task/background/successful_transfer_info/transfer_text1")
  self.transfer_suc = self:GetControl("Panel_Task/background/successful_transfer_info/transfer_suc")
  self.attribute = self:GetControl("Panel_Task/background/attribute")
  self.content = self:GetControl("Panel_Task/background/attribute/content")
  self.lab_atkP = self:GetControl("Panel_Task/background/attribute/content/lab_atkP")
  self.lockskill = self:GetControl("Panel_Task/background/lockskill")
  self.lab_unlockskill = self:GetControl("Panel_Task/background/lockskill/lab_unlockskill")
  self.SkillContent = self:GetControl("Panel_Task/background/lockskill/SkillContent")
  self.temp_skillFrame = self:GetControl("Panel_Task/background/lockskill/SkillContent/temp_skillFrame")
  self.ItemContent = self:GetControl("Panel_Task/background/lockskill/ItemContent")
  self.skill_item = self:GetControl("Panel_Task/background/lockskill/ItemContent/skill_item")
  self.unlockequip = self:GetControl("Panel_Task/background/unlockequip")
  self.lab_unlockequip = self:GetControl("Panel_Task/background/unlockequip/img_titleico/lab_unlockequip")
  self.skillTips = self:GetControl("Panel_Task/background/unlockequip/img_titleico/skillTips")
  self.sv_equiplShow = self:GetControl("Panel_Task/background/unlockequip/sv_equiplShow")
  self.EquipContent = self:GetControl("Panel_Task/background/unlockequip/sv_equiplShow/Viewport/EquipContent")
  self.frame_item1 = self:GetControl("Panel_Task/background/unlockequip/sv_equiplShow/Viewport/EquipContent/frame_item1")
  self.skill_tips = self:GetControl("Panel_Task/background/unlockequip/skill_tips")
end

function Task_TransferInfoUI:OnPreLoad()
end

function Task_TransferInfoUI:Init()
end

function Task_TransferInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function InitZhuanZhiItemControls(ctr)
  ctr.lab_atk = UIControl(ctr.transform, "lab_atk")
  ctr.text_atk = UIControl(ctr.transform, "lab_atk/text_atk")
  ctr.text_atkArrow = UIControl(ctr.transform, "lab_atk/text_atkArrow")
  ctr.text_atknext = UIControl(ctr.transform, "lab_atk/text_atknext")
  ctr.text_atkimg = UIControl(ctr.transform, "lab_atk/text_atkimg")
end

local function ItemZhuanZhiRefresh(ctr, _, data, ui)
  ctr.lab_atk:SetText(data)
end

local function InitSkillItemControls(ctr)
  ctr.img_skillIcon = UIControl(ctr.transform, "img_skillIcon")
  ctr.lab_skillName = UIControl(ctr.transform, "lab_skillName")
  ctr.img_selection = UIControl(ctr.transform, "img_selection")
end

local function ItemSkillRefresh(ctr, _, data, ui)
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(tonumber(data))
  if cfg_skill ~= nil then
    ui:SetSprite("Atlas_Skill", cfg_skill.icon, ctr.img_skillIcon)
    ctr.lab_skillName:SetText(cfg_skill.name)
  end
  ctr.img_selection:SetActive(true)
end

local function InitControls(ctr)
  if ctr.itemCellData then
    ctr.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    ctr.itemCellData = itemCellData
  end
end

local function ItemRefresh(ctr, _, data, ui)
  local itemInfo = ItemUtility.GenerateItemData(tonumber(data))
  itemInfo.count = 1
  ctr.itemCellData:Reset()
  ctr.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

local function InitEquipItemControls(ctr)
  if ctr.itemCellData then
    ctr.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    ctr.itemCellData = itemCellData
  end
end

local function ItemEquipRefresh(ctr, _, equip, ui)
  local itemInfo = ItemUtility.GenerateItemData(tonumber(equip))
  itemInfo.count = 1
  ctr.itemCellData:Reset()
  ctr.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

function Task_TransferInfoUI:InitContent()
  self.zhuanZhiItemTemp = UIContainer(self.lab_atkP, self, InitZhuanZhiItemControls, ItemZhuanZhiRefresh)
  self.skillTemp = UIContainer(self.temp_skillFrame, self, InitSkillItemControls, ItemSkillRefresh)
  self.skillItemTemp = UIContainer(self.skill_item, self, InitControls, ItemRefresh)
  self.equipItemTemp = UIContainer(self.frame_item1, self, InitEquipItemControls, ItemEquipRefresh)
end

function Task_TransferInfoUI:InitUI()
  self.EquipContent.layoutGroup.enabled = true
  self:InitContent()
end

function Task_TransferInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Task_TransferInfoUI:OnHide()
end

function Task_TransferInfoUI:OnDestroy()
end

function Task_TransferInfoUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.temp_skillFrame:SetOnClick(self, self.temp_skillFrameOnClick)
  self.frame_item1:SetOnClick(self, self.frame_item1OnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Task_TransferInfoUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Task_TransferInfoUI)
end

function Task_TransferInfoUI:temp_skillFrameOnClick(control)
end

function Task_TransferInfoUI:frame_item1OnClick(control)
end

function Task_TransferInfoUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Task_TransferInfoUI)
end

function Task_TransferInfoUI:RegistEvents()
end

function Task_TransferInfoUI:Refresh()
  local task = TaskData.GetTaskById(self.args.subPosition)
  if task then
    self.img_taskName:SetActive(true)
    self.text_taskName:SetText(task:GetName())
  else
    self.img_taskName:SetActive(false)
  end
  if self.args ~= nil and self.args.openFirstTab == ERoleSchema.Transfer then
    local careerTbl = ProfessionalUtility.GetTblType(self.args.openFirstTab, nil, CareerChange.BeforeCareer)
    if careerTbl then
      self:RefushAttribute(careerTbl.pointsGrow)
      local skill = ProfessionalUtility.GetCurSkill(careerTbl)
      self:RefushSkill(skill)
      local equip = ProfessionalUtility.GetCurEquip(careerTbl)
      self:RefushItem(equip)
      self.successful_transfer_info:SetActive(true)
      self.transfer_text1:SetText(RoleUtility.GteCareerNameByType(careerTbl.previewId))
      self.transfer_suc:SetText(RoleUtility.GteCareerNameByType(careerTbl.id))
    end
  end
  if self.args ~= nil and self.args.openFirstTab == ERoleSchema.DivineBounds then
    local divineTbl = ProfessionalUtility.GetTblType(self.args.openFirstTab)
    if divineTbl then
      self:RefushAttribute(divineTbl.pointsGrow)
      local skill = ProfessionalUtility.GetCurSkill(divineTbl)
      self:RefushSkill(skill)
      local skillTips = ProfessionalUtility.GetSkillTips(divineTbl)
      self:RefushSkillTips(skillTips)
      self.successful_transfer_info:SetActive(false)
    end
  end
  if self.args ~= nil and self.args.openFirstTab == ERoleSchema.DoubleHit then
    local doubleTbl = ProfessionalUtility.GetTblType(self.args.openFirstTab)
    if doubleTbl then
      self:RefushAttribute(doubleTbl.pointsGrow)
      local skill = ProfessionalUtility.GetCurSkill(doubleTbl)
      self:RefushSkill(skill)
      local skillTips = ProfessionalUtility.GetSkillTips(doubleTbl)
      self:RefushSkillTips(skillTips)
      self.successful_transfer_info:SetActive(false)
    end
  end
end

function Task_TransferInfoUI:RefushAttribute(pointsGrow)
  if not string.isNullOrEmpty(pointsGrow) then
    self.attribute:SetActive(true)
    local showTitle = string.split(pointsGrow, "&")
    self.zhuanZhiItemTemp:SetData(showTitle)
  else
    self.attribute:SetActive(false)
  end
end

function Task_TransferInfoUI:RefushSkill(unlockSkill)
  if not string.isNullOrEmpty(unlockSkill) then
    self.lockskill:SetActive(true)
    self.SkillContent:SetActive(true)
    self.ItemContent:SetActive(false)
    self.skillTemp:SetData(unlockSkill)
  else
    self.lockskill:SetActive(false)
    self.skillTemp:SetActive(false)
  end
end

function Task_TransferInfoUI:RefushSkillItem(item)
  if not string.isNullOrEmpty(item) then
    self.lockskill:SetActive(true)
    self.SkillContent:SetActive(false)
    self.ItemContent:SetActive(true)
    self.skillItemTemp:SetData(item)
  else
    self.lockskill:SetActive(false)
    self.SkillContent:SetActive(false)
  end
end

function Task_TransferInfoUI:RefushItem(unlockEquip)
  if not string.isNullOrEmpty(unlockEquip) then
    self.unlockequip:SetActive(true)
    self.sv_equiplShow:SetActive(true)
    self.EquipContent:SetActive(true)
    self.skillTips:SetActive(false)
    self.lab_unlockequip:SetActive(true)
    self.skill_tips:SetActive(false)
    self.EquipContent.transform.localPosition = Vector3(0, 0, 0)
    self.equipItemTemp:SetData(unlockEquip)
  else
    self.unlockequip:SetActive(false)
    self.EquipContent:SetActive(false)
  end
end

function Task_TransferInfoUI:RefushSkillTips(skillTips)
  self.sv_equiplShow:SetActive(false)
  if not string.isNullOrEmpty(skillTips) then
    self.unlockequip:SetActive(true)
    self.skillTips:SetActive(true)
    self.lab_unlockequip:SetActive(false)
    self.skill_tips:SetActive(true)
    self.skill_tips:SetText(skillTips)
  else
    self.unlockequip:SetActive(false)
  end
end
