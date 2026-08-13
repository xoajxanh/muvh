Equip_HolySkeletonUI = class(BaseUI)
Equip_HolySkeletonUI.layer = UILayer.Panel
Equip_HolySkeletonUI.orderInLayer = 0
Equip_HolySkeletonUI.hideType = UIHideType.WaitDestroy
Equip_HolySkeletonUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolySkeletonUI.escClose = UIEscClose.DontClose

function Equip_HolySkeletonUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.frame_equip = self:GetControl("bg_equip/frame_equip")
  self.lab = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab")
  self.text_atk = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab/lab_atk/text_atk")
  self.text_atkArrow = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab/lab_atk/text_atkArrow")
  self.text_atknext = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab/lab_atk/text_atknext")
  self.text_atkimg = self:GetControl("bg_equip/lab_attributegrow/img_titleico/content/lab/lab_atk/text_atkimg")
  self.lab_material = self:GetControl("bg_equip/lab_material")
  self.text_gold = self:GetControl("bg_equip/lab_material/lab_gold/text_gold")
  self.text_successRate = self:GetControl("bg_equip/lab_material/text_successRate")
  self.btn_intensify = self:GetControl("bg_equip/btn_intensify")
  self.text_intensify = self:GetControl("bg_equip/btn_intensify/text_intensify")
  self.img_SkeletonLevel = self:GetControl("bg_equip/LevelUp/img_Skeletonlevel")
  self.img_SkeletonLevelNext = self:GetControl("bg_equip/LevelUp/img_Skeletonlevelnext")
  self.img_attributeArrow = self:GetControl("bg_equip/LevelUp/img_attributeArrow")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.frame_item = self:GetControl("bg_equip/lab_material/materialParent/frame_item")
  self.img_Max = self:GetControl("bg_equip/img_Max")
  self.itemModel_1 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_1")
  self.itemModel_2 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_2")
  self.itemModel_3 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_3")
  self.itemModel_4 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_4")
  self.itemModel_5 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_5")
  self.itemModel_6 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_6")
  self.itemModel_7 = self:GetControl("bg_equip/SkeletonShowModel/ItemModel_7")
end

function Equip_HolySkeletonUI:Init()
end

function Equip_HolySkeletonUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolySkeletonUI:InitUI()
  self.bigHoleTemplate = luaTemplateManager.GetNewTemplate(self.itemModel_1, LuaComponentTemplates.BigHolySkeletonIntensifyTemp)
  self.smallHoleTemplateList = {
    [2] = luaTemplateManager.GetNewTemplate(self.itemModel_2, LuaComponentTemplates.SmallHolySkeletonIntensifyTemp),
    [3] = luaTemplateManager.GetNewTemplate(self.itemModel_3, LuaComponentTemplates.SmallHolySkeletonIntensifyTemp),
    [4] = luaTemplateManager.GetNewTemplate(self.itemModel_4, LuaComponentTemplates.SmallHolySkeletonIntensifyTemp),
    [5] = luaTemplateManager.GetNewTemplate(self.itemModel_5, LuaComponentTemplates.SmallHolySkeletonIntensifyTemp),
    [6] = luaTemplateManager.GetNewTemplate(self.itemModel_6, LuaComponentTemplates.SmallHolySkeletonIntensifyTemp),
    [7] = luaTemplateManager.GetNewTemplate(self.itemModel_7, LuaComponentTemplates.SmallHolySkeletonIntensifyTemp)
  }
  self.attributesTemplate = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.AttributeUnitTemplate, self)
  self.materialTemplate = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.ConsumableUnitTemplate, self)
end

function Equip_HolySkeletonUI:RegistUIEvents()
  self.btn_intensify:SetOnClick(self, self.btn_intensifyOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Equip_HolySkeletonUI:btn_intensifyOnClick(control)
  local materialData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():GetHolySkeletonIntensifyPlaceDataList()[self.curSelectPlace]:GetPlaceMaterialData()
  local canIntensify = true
  for i, v in pairs(materialData) do
    if BagInfoData.GetItemTotalCountByItemId(v.itemId) < v.count then
      canIntensify = false
      break
    end
  end
  if canIntensify == true then
    local placeGrade = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():GetHolySkeletonIntensifyPlaceDataList()[self.curSelectPlace]:GetPlaceGrade() + 1
    for i, v in pairs(self.holySkeletonIntensifyHoleDataList) do
      if v.UnlockGrade == placeGrade then
        if UIManager.IsVisible(UIID.EffectTipUI) then
          EventManager.Dispatch(Event.TipEffect, {
            name = "Eff_UI_kongweijiesuo",
            time = 1
          })
          break
        end
        UIManager.Show(UIID.EffectTipUI, {
          name = "Eff_UI_kongweijiesuo",
          effectTime = 1
        })
        break
      end
    end
    networkRequest.ReqIntensifyHolyBone(self.curSelectPlace)
  else
    FloatingWordUtility.QuickMsg("Nguy\195\170n li\225\187\135u kh\195\180ng \196\145\225\187\167")
  end
end

function Equip_HolySkeletonUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_HolySkeletonUI")
  if lvCfg and table.count(lvCfg) > 0 then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Equip_HolySkeletonUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Equip_HolySkeletonUI)
end

function Equip_HolySkeletonUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolySkeletonUI:RegistEvents()
  self:RegistEvent(Event.RefreshHolySkeletonIntensify, self.RefreshHolySkeletonIntensify, self)
  self:RegistEvent(Event.SelectedHolySkeletonEquip, self.SelectedHolySkeletonEquip, self)
end

function Equip_HolySkeletonUI:Refresh()
end

function Equip_HolySkeletonUI:RefreshHolySkeletonIntensify()
  self.holySkeletonIntensifyHoleDataList = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():GetHolySkeletonIntensifyPlaceDataList()[self.curSelectPlace]:GetHolySkeletonIntensifyHoleDataList()
  self:RefreshBigHole()
  self:RefreshSmallHole()
  self:RefreshGradeUI()
  self:RefreshAttribute()
  self:RefreshMaterial()
  self:RefreshMaxUI()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.sacredBone_Equip
  })
end

function Equip_HolySkeletonUI:SelectedHolySkeletonEquip(_, data)
  if data == nil then
    return
  end
  self.curSelectPlace = data.modelIndex
  self:RefreshHolySkeletonIntensify()
end

function Equip_HolySkeletonUI:RefreshBigHole()
  if table.count(self.holySkeletonIntensifyHoleDataList) > 0 then
    for i, v in ipairs(self.holySkeletonIntensifyHoleDataList) do
      if v.HolyType == HolySkeletonHoleType.Big then
        self.bigHoleTemplate:Refresh(v, self)
        break
      end
    end
  end
end

function Equip_HolySkeletonUI:RefreshSmallHole()
  if table.count(self.holySkeletonIntensifyHoleDataList) > 0 then
    for i, v in ipairs(self.holySkeletonIntensifyHoleDataList) do
      if v.HolyType == HolySkeletonHoleType.Small then
        self.smallHoleTemplateList[v.Hole]:Refresh(v, self)
      end
    end
  end
end

function Equip_HolySkeletonUI:RefreshGradeUI()
  local isMax = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():GetHolySkeletonIntensifyPlaceDataList()[self.curSelectPlace]:CheckIsMax()
  local placeGrade = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():GetHolySkeletonIntensifyPlaceDataList()[self.curSelectPlace]:GetPlaceGrade()
  self.img_SkeletonLevel:SetText(placeGrade)
  self.img_SkeletonLevelNext:SetText(placeGrade + 1)
  self.img_SkeletonLevelNext:SetActive(not isMax)
  self.img_attributeArrow:SetActive(not isMax)
end

function Equip_HolySkeletonUI:RefreshAttribute()
  local attributeList = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():GetHolySkeletonIntensifyPlaceDataList()[self.curSelectPlace]:GetPlaceAttributeList()
  self.attributesTemplate:SetData(attributeList)
end

function Equip_HolySkeletonUI:RefreshMaterial()
  local materialData = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():GetHolySkeletonIntensifyPlaceDataList()[self.curSelectPlace]:GetPlaceMaterialData()
  self.materialTemplate:SetData(materialData)
end

function Equip_HolySkeletonUI:RefreshMaxUI()
  local isMax = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():GetHolySkeletonIntensifyPlaceDataList()[self.curSelectPlace]:CheckIsMax()
  self.lab_material:SetActive(not isMax)
  self.btn_intensify:SetActive(not isMax)
  self.img_Max:SetActive(isMax)
end

function Equip_HolySkeletonUI:OnHide()
end

function Equip_HolySkeletonUI:OnDestroy()
end
