Puzzle_JH_QianghuaUI = class(BaseUI)
Puzzle_JH_QianghuaUI.layer = UILayer.Panel
Puzzle_JH_QianghuaUI.orderInLayer = 0
Puzzle_JH_QianghuaUI.hideType = UIHideType.WaitDestroy
Puzzle_JH_QianghuaUI.hideFunc = UIHideFunc.MoveOutOfScreen
Puzzle_JH_QianghuaUI.escClose = UIEscClose.DontClose

function Puzzle_JH_QianghuaUI:InitControls()
  self.img_Bg2 = self:GetControl("img_Bg2")
  self.bg_equip = self:GetControl("bg_equip")
  self.Image_icon = self:GetControl("bg_equip/Image_icon")
  self.frame_equip = self:GetControl("bg_equip/frame_equip")
  self.lab_successRate = self:GetControl("bg_equip/lab_successRate")
  self.text_successRate = self:GetControl("bg_equip/lab_successRate/text_successRate")
  self.lab_zhui_bg = self:GetControl("bg_equip/lab_zhui_bg")
  self.lab_success = self:GetControl("bg_equip/lab_zhui_bg/lab_success")
  self.img_addLevel = self:GetControl("bg_equip/lab_zhui_bg/img_addLevel")
  self.img_addLevelNext = self:GetControl("bg_equip/lab_zhui_bg/img_addLevelNext")
  self.content = self:GetControl("bg_equip/content")
  self.lab_physBaseDmg = self:GetControl("bg_equip/content/lab_physBaseDmg")
  self.lab_material = self:GetControl("bg_equip/lab_material")
  self.frame_item1 = self:GetControl("bg_equip/lab_material/frame_item1")
  self.img_material = self:GetControl("bg_equip/img_material")
  self.lab_item = self:GetControl("bg_equip/lab_item")
  self.btn_zhuijia = self:GetControl("bg_equip/btn_zhuijia")
  self.text_zhuijia = self:GetControl("bg_equip/btn_zhuijia/text_zhuijia")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.Img_maxlevel = self:GetControl("Img_maxlevel")
  self.descBtn = self:GetControl("descBtn")
  self.Img_noequip = self:GetControl("Img_noequip")
  self.plane_top = self:GetControl("Img_noequip/plane_top")
  self.Img_noequip1 = self:GetControl("Img_noequip/Img_noequip1")
  self.btn_close = self:GetControl("btn_close")
  self.Text = self:GetControl("Text")
end

function Puzzle_JH_QianghuaUI:Init()
end

function Puzzle_JH_QianghuaUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Puzzle_JH_QianghuaUI:InitUI()
  self.PUZZleCostTemplate = UIUtility.BindUIContainerTemp(self.frame_item1, LuaComponentTemplates.Puzzle_JH_CostTemplate, self)
  self.PUZZlePhysBaseDmgTemplate = UIUtility.BindUIContainerTemp(self.lab_physBaseDmg, LuaComponentTemplates.Puzzle_JH_PanelQiangHuaTemplate, self)
end

function Puzzle_JH_QianghuaUI:RegistUIEvents()
  self.frame_equip:SetOnClick(self, self.frame_equipOnClick)
  self.frame_item1:SetOnClick(self, self.frame_item1OnClick)
  self.btn_zhuijia:SetOnClick(self, self.btn_zhuijiaOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Puzzle_JH_QianghuaUI:frame_equipOnClick(control)
end

function Puzzle_JH_QianghuaUI:frame_item1OnClick(control)
end

function Puzzle_JH_QianghuaUI:btn_zhuijiaOnClick(control)
  if self.PuzzleCost then
    if BagInfoData.GetItemTotalCountByItemId(self.PuzzleCost[1].itemId) >= self.PuzzleCost[1].count then
      networkRequest.ReqNucleusDoLevelUp(self.item.data.m_ServerInfo.id)
      if UIManager.IsVisible(UIID.EffectTipUI) then
        EventManager.Dispatch(Event.TipEffect, {
          name = "Eff_UI_JHqianghuachenggong",
          time = 1
        })
      else
        UIManager.Show(UIID.EffectTipUI, {
          name = "Eff_UI_JHqianghuachenggong",
          effectTime = 1
        })
      end
    else
      local temp = {}
      temp.itemData = ItemUtility.GenerateItemData(self.PuzzleCost[1].itemId)
      UIManager.Show(UIID.ItemTipUI, {
        item = temp.itemData,
        rightOperate = EItemOperateType.Show,
        ctrl = temp,
        ShowObtain = true
      })
    end
  end
end

function Puzzle_JH_QianghuaUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Puzzle_JH_QianghuaUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Puzzle_JH_QianghuaUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Puzzle_JH_QianghuaUI)
end

function Puzzle_JH_QianghuaUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Puzzle_JH_QianghuaUI:RegistEvents()
  self:RegistEvent(Event.PuzzleItemDataModel, self.GetItemDataModel, self)
  self:RegistEvent(Event.CrystalNucleusItemInfoChange, self.GetItemDataModel, self)
end

function Puzzle_JH_QianghuaUI:GetItemDataModel(_, data)
  if not data then
    return
  end
  local itemData = data
  if data.data then
    if self.item == nil or self.item.data and data.data.m_ServerInfo.id ~= self.item.data.m_ServerInfo.id then
      if self.item then
        self.item:SetSelectState(false)
      end
      data:SetSelectState(true)
    end
    itemData = data.data
    self.item = data
  end
  self.Img_noequip:SetActive(false)
  self.lab_item:SetText("+" .. itemData.m_ServerInfo.nucleusLevel .. " " .. itemData.m_ItemConfig.name)
  self:SetSprite("Atlas_Common", itemData.m_ItemConfig.icon, self.Image_icon, true)
  self.nucleusLevel = itemData.m_ServerInfo.nucleusLevel
  self.PUZZlePhysBaseDmgTemplate:SetData(itemData.m_ServerInfo.nucleusAttr)
  local cost = ClientTable.cfg_puzzle_growupManager:GetItemDataLevelIDCost(itemData.m_ServerInfo.nucleusLevel + 1, itemData.m_ItemConfig.id)
  if not string.isNullOrEmpty(cost) then
    self:SetPuzzleUIActive(true)
    self.img_addLevel:SetText("+" .. itemData.m_ServerInfo.nucleusLevel)
    self.img_addLevelNext:SetText("+" .. itemData.m_ServerInfo.nucleusLevel + 1)
    local costInfo = ParseUtility.ParsShopSingleCost(cost)
    self.PuzzleCost = costInfo
    self.lab_material:SetActive(true)
    self.PUZZleCostTemplate:SetData(costInfo)
  else
    self:SetPuzzleUIActive(false)
    self.img_addLevel:SetText("+" .. itemData.m_ServerInfo.nucleusLevel)
    self.img_addLevelNext:SetText("")
  end
end

function Puzzle_JH_QianghuaUI:SetPuzzleUIActive(bool)
  self.btn_zhuijia:SetActive(bool)
  self.lab_success:SetActive(bool)
  self.lab_material:SetActive(bool)
  self.img_material:SetActive(bool)
  self.Img_maxlevel:SetActive(not bool)
end

function Puzzle_JH_QianghuaUI:Refresh()
  self.Img_noequip:SetActive(true)
  self.nucleusLevel = nil
end

function Puzzle_JH_QianghuaUI:OnHide()
end

function Puzzle_JH_QianghuaUI:OnDestroy()
end
