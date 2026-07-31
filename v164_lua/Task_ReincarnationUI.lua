Task_ReincarnationUI = class(BaseUI)
Task_ReincarnationUI.layer = UILayer.Panel
Task_ReincarnationUI.orderInLayer = 0
Task_ReincarnationUI.hideType = UIHideType.WaitDestroy
Task_ReincarnationUI.hideFunc = UIHideFunc.MoveOutOfScreen
Task_ReincarnationUI.escClose = UIEscClose.DontClose

function Task_ReincarnationUI:InitControls()
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
  self.lab_level = self:GetControl("Panel_Task/background/lockskill/lab_level")
  self.unlockequip = self:GetControl("Panel_Task/background/unlockequip")
  self.lab_unlockequip = self:GetControl("Panel_Task/background/unlockequip/img_titleico/lab_unlockequip")
  self.sv_equiplShow = self:GetControl("Panel_Task/background/unlockequip/sv_equiplShow")
  self.EquipContent = self:GetControl("Panel_Task/background/unlockequip/sv_equiplShow/Viewport/EquipContent")
  self.frame_item1 = self:GetControl("Panel_Task/background/unlockequip/sv_equiplShow/Viewport/EquipContent/frame_item1")
  self.skill_tips = self:GetControl("Panel_Task/background/unlockequip/skill_tips")
end

function Task_ReincarnationUI:Init()
end

local function InitZSItemControls(ctr)
  ctr.lab_atk = UIControl(ctr.transform, "lab_atk")
  ctr.text_atk = UIControl(ctr.transform, "lab_atk/text_atk")
  ctr.text_atkArrow = UIControl(ctr.transform, "lab_atk/text_atkArrow")
  ctr.text_atknext = UIControl(ctr.transform, "lab_atk/text_atknext")
  ctr.text_atkimg = UIControl(ctr.transform, "lab_atk/text_atkimg")
end

local function ItemZSRefresh(ctr, _, data, ui)
  ctr.lab_atk:SetText(data)
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

function Task_ReincarnationUI:InitContent()
  self.zhuanZhiItemTemp = UIContainer(self.lab_atkP, self, InitZSItemControls, ItemZSRefresh)
  self.equipItemTemp = UIContainer(self.frame_item1, self, InitEquipItemControls, ItemEquipRefresh)
end

function Task_ReincarnationUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Task_ReincarnationUI:InitUI()
  self:InitContent()
end

function Task_ReincarnationUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.frame_item1:SetOnClick(self, self.frame_item1OnClick)
end

function Task_ReincarnationUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Task_ReincarnationUI)
end

function Task_ReincarnationUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Task_ReincarnationUI)
end

function Task_ReincarnationUI:frame_item1OnClick(control)
end

function Task_ReincarnationUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Task_ReincarnationUI:RegistEvents()
end

function Task_ReincarnationUI:Refresh()
  local task = TaskData.GetTaskById(self.args.subPosition)
  if task then
    self.img_taskName:SetActive(true)
    self.text_taskName:SetText(task:GetName())
  else
    self.img_taskName:SetActive(false)
  end
  local rein = ClientTable.cfg_Character_levelManager:TryGetValue(QuickFind.LuaMainPlayerViewAttrData().level)
  local careerTbl = ClientTable.cfg_Level_reincarnationManager:TryGetValue(QuickFind.LuaMainPlayerViewAttrData().career * 100 + rein.reincarnationLevel)
  if careerTbl then
    self:RefushAttribute(careerTbl.pointsGrow)
    local equip = ProfessionalUtility.GetCurEquip(careerTbl)
    self:RefushItem(equip)
    self.transfer_text1:SetText(string.format("Chuy\225\187\131n %d", careerTbl.reLevel))
    self.transfer_suc:SetText(string.format("Chuy\225\187\131n %d", careerTbl.nextReLevel))
    self.lab_level:SetText(careerTbl.tipsLevel)
  end
end

function Task_ReincarnationUI:RefushAttribute(pointsGrow)
  if not string.isNullOrEmpty(pointsGrow) then
    self.attribute:SetActive(true)
    local showTitle = string.split(pointsGrow, "&")
    self.zhuanZhiItemTemp:SetData(showTitle)
  else
    self.attribute:SetActive(false)
  end
end

function Task_ReincarnationUI:RefushItem(unlockEquip)
  if not string.isNullOrEmpty(unlockEquip) then
    self.unlockequip:SetActive(true)
    self.sv_equiplShow:SetActive(true)
    self.EquipContent:SetActive(true)
    self.lab_unlockequip:SetActive(true)
    self.EquipContent.transform.localPosition = Vector3(0, 0, 0)
    self.equipItemTemp:SetData(unlockEquip)
  else
    self.unlockequip:SetActive(false)
    self.EquipContent:SetActive(false)
  end
end

function Task_ReincarnationUI:OnHide()
end

function Task_ReincarnationUI:OnDestroy()
end
