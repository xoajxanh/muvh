Zhuansheng_TIpsUI = class(BaseUI)
Zhuansheng_TIpsUI.layer = UILayer.Panel
Zhuansheng_TIpsUI.orderInLayer = 0
Zhuansheng_TIpsUI.hideType = UIHideType.WaitDestroy
Zhuansheng_TIpsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Zhuansheng_TIpsUI.escClose = UIEscClose.DontClose

function Zhuansheng_TIpsUI:InitControls()
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
  self.ItemContent = self:GetControl("img_Bg/background/lockskill/ItemContent")
  self.lab_level = self:GetControl("img_Bg/background/lockskill/lab_level")
  self.unlockequip = self:GetControl("img_Bg/background/unlockequip")
  self.lab_unlockequip = self:GetControl("img_Bg/background/unlockequip/img_titleico/lab_unlockequip")
  self.skillTips = self:GetControl("img_Bg/background/unlockequip/img_titleico/skillTips")
  self.sv_equiplShow = self:GetControl("img_Bg/background/unlockequip/sv_equiplShow")
  self.EquipContent = self:GetControl("img_Bg/background/unlockequip/sv_equiplShow/Viewport/EquipContent")
  self.frame_item1 = self:GetControl("img_Bg/background/unlockequip/sv_equiplShow/Viewport/EquipContent/frame_item1")
  self.plane_left = self:GetControl("plane_left")
  self.plane_right = self:GetControl("plane_right")
end

function Zhuansheng_TIpsUI:Init()
end

function Zhuansheng_TIpsUI:OnCreate()
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

function Zhuansheng_TIpsUI:InitUI()
  self:InitContent()
  local tbl = ClientTable.cfg_Global_globalManager:TryGetValue(2180002)
  self.autoTime = tbl and Mathf.Floor(tonumber(tbl.effect) / 1000) or 10
  self.coolTime = self.autoTime
  local tbl1 = ClientTable.cfg_Ui_wordManager:TryGetValue("CareerTransfer3")
  self.loginOut = tbl1 and tbl1.content or "\196\144\196\131ng nh\225\186\173p l\225\186\161i"
  local tbl2 = ClientTable.cfg_Ui_wordManager:TryGetValue("queding")
  self.sure = tbl2 and tbl2.content or "X\195\161c nh\225\186\173n"
end

function Zhuansheng_TIpsUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Zhuansheng_TIpsUI:InitContent()
  self.zhuanZhiItemTemp = UIContainer(self.lab_atkP, self, InitZhuanZhiItemControls, ItemZhuanZhiRefresh)
  self.equipItemTemp = UIContainer(self.frame_item1, self, InitEquipItemControls, ItemEquipRefresh)
end

function Zhuansheng_TIpsUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Zhuansheng_TIpsUI)
end

function Zhuansheng_TIpsUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Zhuansheng_TIpsUI)
end

function Zhuansheng_TIpsUI:temp_skillFrameOnClick(control)
end

function Zhuansheng_TIpsUI:skill_itemOnClick(control)
end

function Zhuansheng_TIpsUI:frame_item1OnClick(control)
end

function Zhuansheng_TIpsUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Zhuansheng_TIpsUI:RegistEvents()
end

function Zhuansheng_TIpsUI:Refresh()
  self.desc_transfer:SetActive(false)
  self.txt:SetText(self.sure)
  local rein = ClientTable.cfg_Character_levelManager:TryGetValue(QuickFind.LuaMainPlayerViewAttrData().level)
  local careerTbl = ClientTable.cfg_Level_reincarnationManager:TryGetValue(QuickFind.LuaMainPlayerViewAttrData():GetBaseCareer() * 100 + rein.reincarnationLevel)
  if careerTbl then
    self:RefushAttribute(careerTbl.pointsGrow)
    local equip = ProfessionalUtility.GetCurEquip(careerTbl)
    self:RefushItem(equip)
    self.transfer_text1:SetText(string.format("Chuy\225\187\131n %d", careerTbl.reLevel))
    self.transfer_suc:SetText(string.format("Chuy\225\187\131n %d", careerTbl.nextReLevel))
    self.lab_level:SetText(careerTbl.tipsLevel)
  end
end

function Zhuansheng_TIpsUI:RefushAttribute(pointsGrow)
  if not string.isNullOrEmpty(pointsGrow) then
    self.attribute:SetActive(true)
    local showTitle = string.split(pointsGrow, "&")
    self.zhuanZhiItemTemp:SetData(showTitle)
  else
    self.attribute:SetActive(false)
  end
end

function Zhuansheng_TIpsUI:RefushItem(unlockEquip)
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

function Zhuansheng_TIpsUI:OnHide()
  self:CleanCoolDown()
  RoleManager.me:AddReinEffect()
  EventManager.Dispatch(Event.PopAutoPopUI)
end

function Zhuansheng_TIpsUI:OnDestroy()
end

function Zhuansheng_TIpsUI:CoolDown()
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

function Zhuansheng_TIpsUI:CleanCoolDown()
  if self.countDownTimer then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
end
