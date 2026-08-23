local GameBook_RaidersTemplates = {}

function GameBook_RaidersTemplates:Init()
  self:InitControls()
  self:InitData()
end

function GameBook_RaidersTemplates:InitControls()
  self.lab_desContainer = self:GetControl("lab_des")
end

function GameBook_RaidersTemplates:InitData()
  self.hyperlinkInfo = {}
  self:InitDrawVertices()
end

function GameBook_RaidersTemplates:InitDrawVertices()
  local emojiTextHyper = self.lab_desContainer.transform:GetComponent("EmojiTextHyper")
  if emojiTextHyper == nil then
    return
  end
  emojiTextHyper.isParseRaidersDes = true
  
  function emojiTextHyper.onDrawVerticesEnd(_info)
    local mainCount = self.lab_desContainer.Top_gridContainer.MaxCount
    if mainCount <= 0 then
      return
    end
    local index = 1
    for i = 1, _info.Count do
      local boxes = _info[i - 1].boxes
      if 0 < boxes.Count then
        local box
        if 1 < boxes.Count then
          box = boxes[boxes.Count - 1]
        else
          box = boxes[0]
        end
        local pos = Vector2(box.center.x, box.center.y)
        local obj = self.lab_desContainer:GetTopGridObjectList()[index - 1].transform
        local type = self.hyperlinkInfo[index].key
        if type == HyperlinkType.image then
          obj.transform.localPosition = pos
        elseif type == HyperlinkType.item then
          obj.transform.localPosition = Vector2(pos.x, pos.y + 7)
        end
        index = index + 1
      else
      end
    end
  end
end

function GameBook_RaidersTemplates:Refresh(_templateData)
  self.templateData = _templateData
  local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(_templateData.cfg_uIWordId)
  local panelData = gameMgr:GetGameBookMgr():ParseRaidersDes(content)
  self.hyperlinkInfo = panelData.info
  self.lab_desContainer:SetOnTextPointerClick(self, self.OnHyperlinkOnClick)
  self.lab_desContainer.inputData = panelData.inputData
  local count = table.count(panelData.allItems)
  self.lab_desContainer:SetTopGridMaxCount(count)
  for i = 1, count do
    local go = self.lab_desContainer:GetTopGridObjectList()[i - 1].transform
    local Img_des = UIControl(go, "Img_des")
    local btn_3DItem = UIControl(go, "btn_3DItem")
    local itemData = ItemUtility.GenerateItemData(tonumber(panelData.allItems[i]))
    itemData.count = 1
    local itemCellData = ItemCellData()
    itemCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(btn_3DItem, itemCellData, self.templateData.ui, true)
    local type = self.hyperlinkInfo[i].key
    local value = self.hyperlinkInfo[i].value
    if type == HyperlinkType.image then
      Img_des:SetActive(true)
      btn_3DItem:SetActive(false)
      local array = string.split(value, "_")
      self.templateData.ui:SetSprite("Atlas_GameBook", array[1], Img_des, false)
      local Img_desRectTrans = Img_des.transform:GetComponent("RectTransform")
      Img_desRectTrans.sizeDelta = Vector2(tonumber(array[2]), tonumber(array[3]))
    elseif type == HyperlinkType.item then
      Img_des:SetActive(false)
      btn_3DItem:SetActive(true)
    end
  end
  self.lab_desContainer:SetText(panelData.desTextStr)
end

function GameBook_RaidersTemplates:OnHyperlinkOnClick(control, eventData, key)
  local itemData = control.inputData.itemDatas[key]
  if itemData then
    local pos = eventData.pressEventCamera:ScreenToWorldPoint(Vector3(eventData.position.x, eventData.position.y, 0))
    local itemInfo = ItemUtility.GenerateItemData(tonumber(itemData.cfg_Item.id))
    UIManager.Show(UIID.ItemTipUI, {
      item = itemInfo,
      rightOperate = EItemOperateType.Show,
      inputMousePos = pos
    })
  end
end

return GameBook_RaidersTemplates
