Skill_SkillPreviewUI = class(BaseUI)
Skill_SkillPreviewUI.layer = UILayer.Tip
Skill_SkillPreviewUI.orderInLayer = 0
Skill_SkillPreviewUI.hideType = UIHideType.WaitDestroy
Skill_SkillPreviewUI.hideFunc = UIHideFunc.MoveOutOfScreen
Skill_SkillPreviewUI.escClose = UIEscClose.DontClose

function Skill_SkillPreviewUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Button_CloseBag = self:GetControl("SkillShowPanel/img_background/Button_CloseBag")
  self.img_title = self:GetControl("SkillShowPanel/img_background/img_title")
  self.ListBtn = self:GetControl("SkillShowPanel/ListBtn")
  self.ContentMain = self:GetControl("SkillShowPanel/ListBtn/sw_subTwo/Viewport/ContentMain")
  self.SkillShow = self:GetControl("SkillShowPanel/SkillShow")
  self.SoulShow = self:GetControl("SkillShowPanel/RoleShow")
end

function Skill_SkillPreviewUI:Init()
end

function Skill_SkillPreviewUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Skill_SkillPreviewUI:InitUI()
  self:InitParam()
  self:InitTemplates()
  self:InitData()
end

function Skill_SkillPreviewUI:InitParam()
  self.openType = ESkillPreviewUIType.Rune
end

function Skill_SkillPreviewUI:InitTemplates()
  self.pageViewTemplate = luaTemplateManager.GetNewTemplate(self.ListBtn, LuaComponentTemplates.Skill_SkillPreviewPageViewTemplate, {
    pageChangeCallBack = self.PageChangeCallBack,
    ui = self
  })
  self.skillPreviewTemplate = luaTemplateManager.GetNewTemplate(self.SkillShow, LuaComponentTemplates.UISkillPreViewTemplate, {isLoop = true})
  self.buffPreviewTemplate = luaTemplateManager.GetNewTemplate(self.SoulShow, LuaComponentTemplates.UIBuffPreviewTemplate)
end

function Skill_SkillPreviewUI:InitData()
  self.posX, self.posY = self:GetControl():GetAnchoredPosition()
end

function Skill_SkillPreviewUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.Button_CloseBag:SetOnClick(self, self.Button_CloseBagOnClick)
end

function Skill_SkillPreviewUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Skill_SkillPreviewUI)
end

function Skill_SkillPreviewUI:Button_CloseBagOnClick(control)
  UIManager.Hide(UIID.Skill_SkillPreviewUI)
end

function Skill_SkillPreviewUI:PageChangeCallBack(data)
  if data == nil then
    return
  end
  if self.openType == ESkillPreviewUIType.Rune then
    if self.skillPreviewTemplate then
      self.skillPreviewTemplate:Refresh(data, self)
    end
  elseif self.openType == ESkillPreviewUIType.HolySkeleton and self.buffPreviewTemplate then
    self.buffPreviewTemplate:Refresh(data, self)
  end
end

function Skill_SkillPreviewUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Skill_SkillPreviewUI:RegistEvents()
end

function Skill_SkillPreviewUI:Refresh()
  if self.args and self.args.openFirstTab then
    self.openType = self.args.openFirstTab
  end
  self:RefreshViewState()
  self:RefreshPageView()
  self:RefreshPosition()
end

function Skill_SkillPreviewUI:RefreshPageView()
  if self.pageViewTemplate == nil then
    return
  end
  self.pageViewTemplate:Refresh(self.openType, self.args and self.args.skillId or nil)
end

function Skill_SkillPreviewUI:RefreshViewState()
  if self.skillPreviewTemplate then
    self.skillPreviewTemplate:ChangeViewState(self.openType == ESkillPreviewUIType.Rune)
  end
  if self.buffPreviewTemplate then
    self.buffPreviewTemplate:ChangeViewState(self.openType == ESkillPreviewUIType.HolySkeleton)
  end
  if self.img_title then
    self:SetSprite("Atlas_Language", "txt_SkillPreview_" .. self.openType, self.img_title)
  end
end

function Skill_SkillPreviewUI:RefreshPosition()
  if self.openType == ESkillPreviewUIType.Rune then
    self:GetControl():SetAnchoredPosition(-187, self.posY)
  elseif self.openType == ESkillPreviewUIType.HolySkeleton then
    self:GetControl():SetAnchoredPosition(-187, self.posY)
  end
end

function Skill_SkillPreviewUI:OnHide()
  self:ResetPosition()
  self:ResetPreview()
  self:TryCloseTip_CommonTipsUI()
end

function Skill_SkillPreviewUI:ResetPosition()
  self:GetControl():SetAnchoredPosition(self.posX, self.posY)
end

function Skill_SkillPreviewUI:TryCloseTip_CommonTipsUI()
  if self.openType == ESkillPreviewUIType.Rune then
    UIManager.Hide(UIID.Tip_CommonTipsUI)
  end
end

function Skill_SkillPreviewUI:ResetPreview()
  if self.skillPreviewTemplate and self.openType == ESkillPreviewUIType.Rune then
    self.skillPreviewTemplate:ChangeViewState(false)
  end
  if self.buffPreviewTemplate and self.openType == ESkillPreviewUIType.HolySkeleton then
    self.buffPreviewTemplate:ChangeViewState(false)
  end
end

function Skill_SkillPreviewUI:OnDestroy()
end
