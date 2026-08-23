Mount_AttributeCollectUI = class(BaseUI)
Mount_AttributeCollectUI.layer = UILayer.Dialog
Mount_AttributeCollectUI.orderInLayer = 2
Mount_AttributeCollectUI.hideType = UIHideType.WaitDestroy
Mount_AttributeCollectUI.hideFunc = UIHideFunc.MoveOutOfScreen
Mount_AttributeCollectUI.escClose = UIEscClose.DontClose

function Mount_AttributeCollectUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.bg_attributeCollect = self:GetControl("bg_attributeCollect")
  self.btn_closeAttributeCollectUI = self:GetControl("btn_closeAttributeCollectUI")
  self.lab_fightCount = self:GetControl("lab_fightCount")
  self.lab_attributeValue = self:GetControl("lab_attribute/lab_attributeValue")
  self.lab_attributeName = self:GetControl("lab_attribute/lab_attributeName")
  self.lab_skillCount = self:GetControl("lab_skillCount")
  self.Iconskill = self:GetControl("lab_skillCount/sv_skill/Viewport/Content/Iconskill")
end

function Mount_AttributeCollectUI:Init()
  self.skillContainer = {}
end

function Mount_AttributeCollectUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Mount_AttributeCollectUI:InitUI()
  local transform = self.root.transform
  local x, y = transform:GetAnchoredPosition()
  transform.anchoredPosition3D = Vector3.New(x, y, -1000)
  self:SkillContainerInit()
end

local function IconOnCreate(ctr)
  ctr.img_skillName = UIControl(ctr.transform, "img_skillName")
  ctr.img_skillMount = UIControl(ctr.transform, "img_skillMount")
end

local function IconRefresh(ctr, _, skillInfo, ui)
  ctr.img_skillName:SetText(skillInfo.name)
  ctr.img_skillMount:SetText(skillInfo.skillName)
end

function Mount_AttributeCollectUI:SkillContainerInit()
  self.skillContainer = UIContainer(self.Iconskill, self, IconOnCreate, IconRefresh)
end

function Mount_AttributeCollectUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Mount_AttributeCollectUI:OnHide()
end

function Mount_AttributeCollectUI:OnDestroy()
end

function Mount_AttributeCollectUI:RegistUIEvents()
  self.btn_closeAttributeCollectUI:SetOnClick(self, self.btn_closeAttributeCollectUIOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeAttributeCollectUIOnClick)
end

function Mount_AttributeCollectUI:btn_closeAttributeCollectUIOnClick(control)
  UIManager.Hide(UIID.MountAttributeCollectUI)
end

function Mount_AttributeCollectUI:RegistEvents()
end

function Mount_AttributeCollectUI:Refresh()
  self:RefreshAttribute()
end

function Mount_AttributeCollectUI:RefreshAttribute()
  self.lab_fightCount:SetText(string.format("T\225\187\149ng l\225\187\177c chi\225\186\191n th\195\186 c\198\176\225\187\161i: %d", MountUtility.GetMainPlayerFightProperty()))
  local tblDesc = MountUtility.GetMainPlayerAllProperty()
  local s = ""
  for i = 1, #tblDesc do
    if i == #tblDesc then
      s = string.format("%s%s", s, tblDesc[i])
    else
      s = string.format("%s%s\n", s, tblDesc[i])
    end
  end
  self.lab_attributeValue:SetText(s)
  self:RefreshAllSkill()
end

function Mount_AttributeCollectUI:RefreshAllSkill()
  local skillList = MountUtility.GetMainPlayerMountSkill()
  self.skillContainer:SetDataKTable(skillList)
end
