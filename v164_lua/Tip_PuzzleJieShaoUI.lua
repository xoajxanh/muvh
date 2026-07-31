Tip_PuzzleJieShaoUI = class(BaseUI)
Tip_PuzzleJieShaoUI.layer = UILayer.Tip
Tip_PuzzleJieShaoUI.orderInLayer = 8
Tip_PuzzleJieShaoUI.hideType = UIHideType.WaitDestroy
Tip_PuzzleJieShaoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_PuzzleJieShaoUI.escClose = UIEscClose.DontClose

function Tip_PuzzleJieShaoUI:InitControls()
  self.btn_Close = self:GetControl("btn_Close")
  self.Img_TipBg = self:GetControl("Img_TipBg")
  self.sv_center = self:GetControl("Img_TipBg/sv_center")
  self.lab_TipTitle = self:GetControl("Img_TipBg/sv_center/lab_TipTitle")
  self.lab_TipTopInfo = self:GetControl("Img_TipBg/sv_center/lab_TipTopInfo")
  self.img_item = self:GetControl("Img_TipBg/sv_center/Tip_ModelShow/img_item/img_item")
  self.mainScroll = self:GetControl("Img_TipBg/sv_center/Viewport/Content/lab_attribute/Scroll_view")
  self.mainContent = self:GetControl("Img_TipBg/sv_center/Viewport/Content/lab_attribute/Scroll_view/Viewport/Content")
  self.lab_TipAttribute = self:GetControl("Img_TipBg/sv_center/Viewport/Content/lab_attribute/Scroll_view/Viewport/Content/lab_TipAttribute")
  self.deputyScroll = self:GetControl("Img_TipBg/sv_center/Viewport/Content/lab_excellent/Scroll View")
  self.deputyContent = self:GetControl("Img_TipBg/sv_center/Viewport/Content/lab_excellent/Scroll View/Viewport/Content")
  self.lab_TipStoneLightAdditional = self:GetControl("Img_TipBg/sv_center/Viewport/Content/lab_excellent/Scroll View/Viewport/Content/lab_TipStoneLightAdditional")
  self.lab_TipItemTips = self:GetControl("Img_TipBg/go_bottom/Scroll_DownTips/Viewport/Content/lab_TipItemTips")
  self.go_btns = self:GetControl("Img_TipBg/go_bottom/go_btns")
  self.btn_RightClick = self:GetControl("Img_TipBg/go_bottom/go_btns/btn_RightClick")
  self.btn_LeftClick = self:GetControl("Img_TipBg/go_bottom/go_btns/btn_LeftClick")
end

function Tip_PuzzleJieShaoUI:Init()
end

function Tip_PuzzleJieShaoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_PuzzleJieShaoUI:InitUI()
  self.itemSize = self.img_item.transform.localScale
end

function Tip_PuzzleJieShaoUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
end

function Tip_PuzzleJieShaoUI:btn_CloseOnClick(control)
  UIManager.Hide(UIID.Tip_PuzzleJieShaoUI)
end

function Tip_PuzzleJieShaoUI:ShowPuzzleTip(itemData)
  local atttr = ClientTable.cfg_Puzzle_jieshaoManager:TryGetValue(itemData.id, "contentItemID")
  itemData.attributeOneTips = atttr.attributeOneTips
  local attributeOneTipsTbl = {}
  if string.contains(atttr.attributeOneTips, "&") then
    attributeOneTipsTbl = string.split(atttr.attributeOneTips, "&")
    for i, v in ipairs(attributeOneTipsTbl) do
      local careerAttribute = string.split(v, "#")
      local careerId = QuickFind.LuaMainPlayerViewAttrData():GetBaseCareer()
      if tonumber(careerAttribute[2]) == careerId then
        itemData.attributeOneTips = tonumber(careerAttribute[1])
        break
      end
    end
  else
    itemData.attributeOneTips = atttr.attributeOneTips
  end
  itemData.attributeSecTips = atttr.attributeSecTips
  itemData.intensifyLevel = atttr.intensifyLevel
  local levelStr = string.GetColorText("+" .. itemData.intensifyLevel, ItemQuality2ColorDic[itemData.titleColor])
  local ssStr = string.GetColorText(itemData.name, ItemQuality2ColorDic[itemData.titleColor])
  self.lab_TipTitle:SetText(levelStr .. " " .. ssStr)
  local inlayStr
  local inlayMaxCount = ClientTable.cfg_Item_equipManager:TryGetValue(itemData.id).inlayMax
  if inlayMaxCount == 1 then
    inlayStr = ClientTable.cfg_Global_globalManager:TryGetValue(64000010).effect
  else
    inlayStr = string.format(ClientTable.cfg_Global_globalManager:TryGetValue(64000009).effect, inlayMaxCount)
  end
  local skillLevel = ClientTable.cfg_Item_itemManager:TryGetValue(itemData.id).skillCrystalNucleus
  local skillLevelStr = string.format(ClientTable.cfg_Global_globalManager:TryGetValue(64000008).effect, skillLevel)
  local bind = ClientTable.cfg_Item_itemManager:TryGetValue(itemData.id).bind
  local bindStr
  if bind then
    if itemData.minAuctionPrice == "" then
      bindStr = string.GetColorText(ItemBind2Name[2], ItemQuality2ColorDic[EItemColorEnum.red])
    else
      bindStr = string.GetColorText(ItemBind2Name[bind], ItemQuality2ColorDic[EItemColorEnum.green])
    end
  end
  self.lab_TipTopInfo:SetText(bindStr .. "\n" .. inlayStr .. "\n" .. skillLevelStr)
  self:SetSprite("Atlas_Common", tostring(itemData.icon), self.img_item, true)
  self.img_item.transform.localScale = self.itemSize * (itemData.pngSize / 100)
  self.lab_TipItemTips:SetActive(false)
  self.go_btns:SetActive(false)
  local equipConfig = ClientTable.cfg_Item_equipManager:TryGetValue(itemData.id)
  local mainStr = string.format(ClientTable.cfg_Item_tipsManager:TryGetValue(itemData.attributeOneTips).content, string.split(equipConfig.excellJingHeOne, "#")[1])
  self.lab_TipAttribute:SetText(mainStr)
  self.lab_TipAttribute.transform.localPosition = Vector3(-5.7, 50, 0)
  local deputyStr = string.replace(ClientTable.cfg_Item_tipsManager:TryGetValue(itemData.attributeSecTips).content, "%s", string.split(equipConfig.excellJingHeSec, "#")[1])
  self.lab_TipStoneLightAdditional:SetText(deputyStr)
  local deputyStrTbl = string.split(deputyStr, "\n")
  local w, h
  w, h = self.lab_TipStoneLightAdditional:GetSizeDelta()
  self.deputyContent:SetSizeDelta(w, #deputyStrTbl * 25 + 20)
end

function Tip_PuzzleJieShaoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_PuzzleJieShaoUI:RegistEvents()
end

function Tip_PuzzleJieShaoUI:Refresh()
  if self.args and self.args.type == 1 then
    self:ShowPuzzleTip(self.args.data)
  end
end

function Tip_PuzzleJieShaoUI:OnHide()
end

function Tip_PuzzleJieShaoUI:OnDestroy()
end
