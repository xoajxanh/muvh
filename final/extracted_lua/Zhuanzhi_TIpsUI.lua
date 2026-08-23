Zhuanzhi_TIpsUI = class(BaseUI)
Zhuanzhi_TIpsUI.layer = UILayer.Dialog
Zhuanzhi_TIpsUI.orderInLayer = 0
Zhuanzhi_TIpsUI.hideType = UIHideType.WaitDestroy
Zhuanzhi_TIpsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Zhuanzhi_TIpsUI.escClose = UIEscClose.DontClose

function Zhuanzhi_TIpsUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.txtTitle = self:GetControl("img_Bg/txtTitle")
  self.desc_transfer = self:GetControl("img_Bg/desc_transfer")
  self.btn_close = self:GetControl("img_Bg/btn_close")
  self.txt = self:GetControl("img_Bg/btn_close/txt")
  self.successful_transfer_info = self:GetControl("img_Bg/successful_transfer_info")
  self.transfer_text1 = self:GetControl("img_Bg/successful_transfer_info/transfer_text1")
  self.transfer_suc = self:GetControl("img_Bg/successful_transfer_info/transfer_suc")
  self.attribute = self:GetControl("img_Bg/background/attribute")
  self.content = self:GetControl("img_Bg/background/attribute/content")
  self.lab_atkP = self:GetControl("img_Bg/background/attribute/content/lab_atkP")
  self.lockskill = self:GetControl("img_Bg/background/lockskill")
  self.lab_unlockskill = self:GetControl("img_Bg/background/lockskill/lab_unlockskill")
  self.SkillContent = self:GetControl("img_Bg/background/lockskill/SkillContent")
  self.temp_skillFrame = self:GetControl("img_Bg/background/lockskill/SkillContent/temp_skillFrame")
  self.ItemContent = self:GetControl("img_Bg/background/lockskill/ItemContent")
  self.skill_item = self:GetControl("img_Bg/background/lockskill/ItemContent/skill_item")
  self.unlockequip = self:GetControl("img_Bg/background/unlockequip")
  self.lab_unlockequip = self:GetControl("img_Bg/background/unlockequip/img_titleico/lab_unlockequip")
  self.skillTips = self:GetControl("img_Bg/background/unlockequip/img_titleico/skillTips")
  self.sv_equiplShow = self:GetControl("img_Bg/background/unlockequip/sv_equiplShow")
  self.EquipContent = self:GetControl("img_Bg/background/unlockequip/sv_equiplShow/Viewport/EquipContent")
  self.frame_item1 = self:GetControl("img_Bg/background/unlockequip/sv_equiplShow/Viewport/EquipContent/frame_item1")
  self.skill_tips = self:GetControl("img_Bg/background/unlockequip/skill_tips")
  self.plane_left = self:GetControl("plane_left")
  self.plane_right = self:GetControl("plane_right")
end

function Zhuanzhi_TIpsUI:OnPreLoad()
end

function Zhuanzhi_TIpsUI:Init()
end

function Zhuanzhi_TIpsUI:OnCreate()
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

function Zhuanzhi_TIpsUI:InitContent()
  self.zhuanZhiItemTemp = UIContainer(self.lab_atkP, self, InitZhuanZhiItemControls, ItemZhuanZhiRefresh)
  self.skillTemp = UIContainer(self.temp_skillFrame, self, InitSkillItemControls, ItemSkillRefresh)
  self.skillItemTemp = UIContainer(self.skill_item, self, InitControls, ItemRefresh)
  self.equipItemTemp = UIContainer(self.frame_item1, self, InitEquipItemControls, ItemEquipRefresh)
end

function Zhuanzhi_TIpsUI:InitUI()
  self.EquipContent.layoutGroup.enabled = true
  self:InitContent()
  local tbl = ConfigManager.GetConfig("cfg_Global_global", 2180002, "id")
  self.autoTime = tbl and Mathf.Floor(tonumber(tbl.effect) / 1000) or 10
  self.coolTime = self.autoTime
  local tbl1 = ConfigManager.GetConfig("cfg_Ui_word", "CareerTransfer3")
  self.loginOut = tbl1 and tbl1.content or "\196\144\196\131ng nh\225\186\173p l\225\186\161i"
  local tbl2 = ConfigManager.GetConfig("cfg_Ui_word", "queding")
  self.sure = tbl2 and tbl2.content or "X\195\161c nh\225\186\173n"
end

function Zhuanzhi_TIpsUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Zhuanzhi_TIpsUI:OnHide()
  self:CleanCoolDown()
end

function Zhuanzhi_TIpsUI:CoolDown()
  self:CleanCoolDown()
  if self.autoTime and tonumber(self.autoTime) > 0 then
    self.coolTime = self.autoTime
    self.txt:SetText(self.loginOut .. self.coolTime .. "s")
    
    local function CoolDownTime()
      self.coolTime = self.coolTime - 1
      if self.coolTime <= 0 then
        self:CloseZhuanZhiTIpsUI()
      end
      self.txt:SetText(self.loginOut .. self.coolTime .. "s")
    end
    
    self.countDownTimer = Timer.StartLoop(1, self.autoTime, CoolDownTime)
  end
end

function Zhuanzhi_TIpsUI:CleanCoolDown()
  if self.countDownTimer then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
end

function Zhuanzhi_TIpsUI:OnDestroy()
end

function Zhuanzhi_TIpsUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.CloseZhuanZhiTIpsUI)
  self.btn_closeBg:SetOnClick(self, self.CloseZhuanZhiTIpsUI)
end

function Zhuanzhi_TIpsUI:CloseZhuanZhiTIpsUI()
  UIManager.Hide(UIID.Zhuanzhi_TIpsUI)
end

function Zhuanzhi_TIpsUI:btn_3DItemOnClick(control)
end

function Zhuanzhi_TIpsUI:frame_item1OnClick(control)
end

function Zhuanzhi_TIpsUI:RegistEvents()
end

function Zhuanzhi_TIpsUI:Refresh()
  self.desc_transfer:SetActive(false)
  self.txt:SetText(self.sure)
  if self.args ~= nil and self.args.type ~= nil and self.args.type == ERoleSchema.Transfer then
    self:SetSprite("Atlas_Language", "zhuanZhiChengGong", self.txtTitle)
    if self.args.oldCareer ~= nil and self.args.newCareer ~= nil then
      local careerTbl = {}
      if Mathf.Floor(self.args.oldCareer / 10) == Mathf.Floor(self.args.newCareer / 10) then
        careerTbl = ProfessionalUtility.GetTblType(ERoleSchema.TransferCard, tonumber(self.args.newCareer))
      else
        careerTbl = ProfessionalUtility.GetTblType(ERoleSchema.Transfer, tonumber(self.args.newCareer))
      end
      if careerTbl then
        self:RefushAttribute(careerTbl.pointsGrow)
        local skill = ProfessionalUtility.GetCurSkill(careerTbl, self.args.newCareer)
        self:RefushSkill(skill)
        local equip = ProfessionalUtility.GetCurEquip(careerTbl, self.args.newCareer)
        self:RefushItem(equip)
        self.successful_transfer_info:SetActive(true)
        self.transfer_text1:SetText(RoleUtility.GteCareerNameByType(self.args.oldCareer))
        self.transfer_suc:SetText(RoleUtility.GteCareerNameByType(self.args.newCareer))
      end
    end
  end
  if self.args ~= nil and self.args.type ~= nil and self.args.type == ERoleSchema.DivineBounds then
    local divineTbl = ProfessionalUtility.GetTblType(self.args.type)
    self:SetSprite("Atlas_Language", "jiHuoSD", self.txtTitle)
    if divineTbl then
      self:RefushAttribute(divineTbl.pointsGrow)
      local skill = ProfessionalUtility.GetCurSkill(divineTbl)
      self:RefushSkillItem(skill)
      local skillTips = ProfessionalUtility.GetSkillTips(divineTbl)
      self:RefushSkillTips(skillTips)
      self.successful_transfer_info:SetActive(false)
    end
  end
  if self.args ~= nil and self.args.type ~= nil and self.args.type == ERoleSchema.DoubleHit then
    local doubleTbl = ProfessionalUtility.GetTblType(self.args.type)
    self:SetSprite("Atlas_Language", "jiHuoLianJi", self.txtTitle)
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

function Zhuanzhi_TIpsUI:RefushAttribute(pointsGrow)
  if not string.isNullOrEmpty(pointsGrow) then
    self.attribute:SetActive(true)
    self.content:SetActive(true)
    local showTitle = string.split(pointsGrow, "&")
    self.zhuanZhiItemTemp:SetData(showTitle)
  else
    self.attribute:SetActive(false)
    self.content:SetActive(false)
  end
end

function Zhuanzhi_TIpsUI:RefushSkill(unlockSkill)
  if not string.isNullOrEmpty(unlockSkill) then
    self.lockskill:SetActive(true)
    self.SkillContent:SetActive(true)
    self.ItemContent:SetActive(false)
    self.skillTemp:SetData(unlockSkill)
  else
    self.lockskill:SetActive(false)
    self.SkillContent:SetActive(false)
  end
end

function Zhuanzhi_TIpsUI:RefushSkillItem(item)
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

function Zhuanzhi_TIpsUI:RefushItem(unlockEquip)
  if not string.isNullOrEmpty(unlockEquip) then
    self.unlockequip:SetActive(true)
    self.EquipContent:SetActive(true)
    self.sv_equiplShow:SetActive(true)
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

function Zhuanzhi_TIpsUI:RefushSkillTips(skillTips)
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
