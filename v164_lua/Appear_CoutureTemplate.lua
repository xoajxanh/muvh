local Appear_CoutureTemplate = {}

function Appear_CoutureTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:InitContainer()
  self:InitTimeLoop()
end

function Appear_CoutureTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.toggle = self:GetControl("toggle")
  self.CoutureItem = self:GetControl("Scroll_Item/Viewport/Content/CoutureItem")
  self.lab = self:GetControl("IntensifyAttribute/lab_attributegrow/img_titleico/content/lab")
  self.frame_item = self:GetControl("needMaterial/sw_Material/Viewport/materialParent/frame_item1")
  self.btn_Intensify = self:GetControl("btn_Intensify")
  self.text_Intensify = self:GetControl("btn_Intensify/text_Intensify")
  self.panel_weaponL = self:GetControl("toggle/panel_weaponL/btn_weaponL")
  self.panel_weaponR = self:GetControl("toggle/panel_weaponR/btn_weaponL")
  self.panel_armor = self:GetControl("toggle/panel_armor/btn_weaponL")
  self.img_NoEquip = self:GetControl("img_NoEquip")
  self.IntensifyAttribute = self:GetControl("IntensifyAttribute")
  self.needMaterial = self:GetControl("needMaterial")
  self.img_MaxActive = self:GetControl("img_MaxActive")
end

function Appear_CoutureTemplate:InitContainer()
  self.panel_weaponL:SetOnToggleChanged(self, self.panel_weaponLOnToggleChanged)
  self.panel_weaponR:SetOnToggleChanged(self, self.panel_weaponROnToggleChanged)
  self.panel_armor:SetOnToggleChanged(self, self.panel_armorOnToggleChanged)
  self.btn_Intensify:SetOnClick(self, self.btn_IntensifyOnClick)
  self.CoutureItemTemplate = UIUtility.BindUIContainerTemp(self.CoutureItem, LuaComponentTemplates.Appear_Couture_CoutureItemTemplate, self.rootUI)
  self.AttributeTemplate = UIUtility.BindUIContainerTemp(self.lab, LuaComponentTemplates.Appear_Couture_AttributeTemplate, self.rootUI)
  self.StrengthenTemplate = UIUtility.BindUIContainerTemp(self.frame_item, LuaComponentTemplates.ConsumableUnitTemplate, self.rootUI)
end

function Appear_CoutureTemplate:InitTimeLoop()
  if self.TimeLoop ~= nil then
    Timer.Stop(self.TimeLoop)
  end
  self.TimeLoop = Timer.StartLoopForever(0.1, function()
    if gameMgr:GetAvatarManager() ~= nil and gameMgr:GetAvatarManager():GetMainPlayer() ~= nil and gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager() ~= nil then
      gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():RefreshTimeLoop()
    end
  end)
end

function Appear_CoutureTemplate:RefreshAll(togIndex)
  networkRequest.ReqRoleEquipNormalPos()
  if togIndex == nil then
    togIndex = self:GetShowIndex()
  end
  if togIndex then
    local toggles = {
      [Appear_CoutureFashionTypeEnum.WeaponL] = self.panel_weaponL,
      [Appear_CoutureFashionTypeEnum.WeaponR] = self.panel_weaponR,
      [Appear_CoutureFashionTypeEnum.Armor] = self.panel_armor
    }
    for i, v in pairs(toggles) do
      v.toggle.isOn = togIndex == i
      if togIndex == i then
        self:RefreshCoutureItem(i)
      end
    end
  end
end

function Appear_CoutureTemplate:GetShowIndex()
  local togglesList = {
    Appear_CoutureFashionTypeEnum.WeaponL,
    Appear_CoutureFashionTypeEnum.WeaponR,
    Appear_CoutureFashionTypeEnum.Armor
  }
  for i, v in pairs(togglesList) do
    local data = gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():GetFashionInfo(v)
    if data ~= nil and 0 < #data then
      return v
    end
  end
end

function Appear_CoutureTemplate:panel_weaponLOnToggleChanged(control, isOn)
  if isOn == true then
    self:RefreshCoutureItem(Appear_CoutureFashionTypeEnum.WeaponL)
  end
end

function Appear_CoutureTemplate:panel_weaponROnToggleChanged(control, isOn)
  if isOn == true then
    self:RefreshCoutureItem(Appear_CoutureFashionTypeEnum.WeaponR)
  end
end

function Appear_CoutureTemplate:panel_armorOnToggleChanged(control, isOn)
  if isOn == true then
    self:RefreshCoutureItem(Appear_CoutureFashionTypeEnum.Armor)
  end
end

function Appear_CoutureTemplate:btn_IntensifyOnClick()
  if self.selectFashionInfoData == nil then
    return
  end
  if self.selectFashionInfoData.isNeedActive then
    local bagData = BagInfoData.GetItemByConfigID(self.selectFashionInfoData.itemId)
    if bagData ~= nil then
      networkRequest.ReqUseItem(1, bagData.id)
    end
  else
    networkRequest.ReqOperationFashion(self.selectFashionInfoData.showType, self.selectFashionInfoData.fashionId, 2)
  end
end

function Appear_CoutureTemplate:RefreshCoutureItem(Type)
  if Type ~= nil then
    self.selectType = Type
  end
  if self.selectType == nil then
    return
  end
  local CoutureInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetAppear_CoutureManager():GetFashionInfo(self.selectType)
  self.CoutureItemTemplate:SetData(CoutureInfo)
  if CoutureInfo == nil or #CoutureInfo == 0 then
    EventManager.Dispatch(Event.Appear_CoutureSelectChange)
  else
    local refreshData = CoutureInfo[1]
    if self.selectFashionInfoData ~= nil then
      for i, v in pairs(CoutureInfo) do
        if v.fashionId == self.selectFashionInfoData.fashionId then
          refreshData = v
        end
      end
    end
    EventManager.Dispatch(Event.Appear_CoutureSelectChange, refreshData)
  end
  self:RefreshActive(CoutureInfo)
end

function Appear_CoutureTemplate:RefreshActive(CoutureInfo)
  local isshow = CoutureInfo == nil or #CoutureInfo == 0
  self.img_NoEquip:SetActive(isshow)
  self.IntensifyAttribute:SetActive(not isshow)
end

function Appear_CoutureTemplate:AttributeInfoChange(data)
  self.selectFashionInfoData = data
  self:btn_IntensifyShowChange(data)
  self:RefreshAttributTemplate(data)
  self:RefreshStrengthenTemplate(data)
  self.CoutureItemTemplate:SetTemplateData(data, self.SetCoutureItemDataCallBack)
end

function Appear_CoutureTemplate:btn_IntensifyShowChange(data)
  self.btn_Intensify:SetActive(data ~= nil and data.nextTable ~= nil)
  self.img_MaxActive:SetActive(data ~= nil and data.nextTable == nil)
  self.needMaterial:SetActive(data ~= nil and data.nextTable ~= nil)
  if data ~= nil then
    local showText = data.isNeedActive == true and "K\195\173ch ho\225\186\161t" or "N\195\162ng c\225\186\165p"
    self.text_Intensify:SetText(showText)
  end
end

function Appear_CoutureTemplate:RefreshStrengthenTemplate(data)
  if data == nil then
    self.AttributeTemplate:SetData({})
  else
    self.AttributeTemplate:SetData(data.AttributeInfoList)
  end
end

function Appear_CoutureTemplate:RefreshAttributTemplate(data)
  if data == nil or data.nextTable == nil then
    self.StrengthenTemplate:SetData({})
  else
    local costData = TableParse:SpliteStringToItemCountList(data.nextTable.cost)
    self.StrengthenTemplate:SetData(costData)
  end
end

function Appear_CoutureTemplate.SetCoutureItemDataCallBack(templat, data)
  local selectID = -1
  if data ~= nil then
    selectID = data.fashionId
  end
  templat:RefreshSelectEffect(selectID)
end

return Appear_CoutureTemplate
