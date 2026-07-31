WarAlliance_Rank = class(BaseUI)
WarAlliance_Rank.layer = UILayer.Panel
WarAlliance_Rank.orderInLayer = 2
WarAlliance_Rank.hideType = UIHideType.Destroy
WarAlliance_Rank.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_Rank.escClose = UIEscClose.DontClose

function WarAlliance_Rank:InitControls()
  self.panel_left = self:GetControl("panel_left")
  self.btn_closeBg = self:GetControl("panel_left/btn_closeBg")
  self.bg_frame = self:GetControl("panel_left/bg_frame")
  self.CloseBtn = self:GetControl("panel_left/bg_frame/CloseBtn")
  self.WarAllianceList = self:GetControl("panel_left/WarAllianceList")
  self.Button_WarAllianceItem = self:GetControl("panel_left/WarAllianceList/WarAllianceListScr/bg_WarAlliancePanel/Viewport/Content/Button_WarAllianceItem")
  self.lab_enemy = self:GetControl("panel_left/WarAllianceList/WarAllianceListScr/bg_WarAlliancePanel/Viewport/Content/Button_WarAllianceItem/lab_enemy")
  self.btn_enemy = self:GetControl("panel_left/WarAllianceList/WarAllianceListScr/bg_WarAlliancePanel/Viewport/Content/Button_WarAllianceItem/btn_enemy")
  self.panel_relation = self:GetControl("panel_relation")
  self.btn_yes = self:GetControl("panel_relation/btn_yes")
  self.btn_no = self:GetControl("panel_relation/btn_no")
  self.lab_tip = self:GetControl("panel_relation/txt_tip/lab_tip")
  self.lab_tip2 = self:GetControl("panel_relation/txt_tip2/lab_tip2")
  self.txt_count = self:GetControl("panel_relation/txt_cost/bg/txt_count")
  self.btn_3DItem = self:GetControl("panel_relation/txt_cost/btn_3DItem")
end

function WarAlliance_Rank:OnPreLoad()
end

function WarAlliance_Rank:Init()
  self.listSelect = {}
end

function WarAlliance_Rank:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_Rank:InitUI()
  self:InitContent()
end

function WarAlliance_Rank:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_Rank:OnHide()
end

function WarAlliance_Rank:OnDestroy()
end

function WarAlliance_Rank:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.CloseBtnOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.btn_yes:SetOnClick(self, self.btn_yesOnClick)
  self.btn_no:SetOnClick(self, self.btn_noOnClick)
end

function WarAlliance_Rank:CloseBtnOnClick(control)
  UIManager.Hide(UIID.WarAlliance_Rank)
end

function WarAlliance_Rank:btn_noOnClick()
  self.panel_relation:SetActive(false)
end

function WarAlliance_Rank:btn_yesOnClick()
  local count = BagInfoData.GetItemCountByItemConfigId(self.enemyItemId)
  if count < self.enemyCount then
    count = BagInfoData.GetItemTotalCountByItemId(self.enemyItemId)
  end
  if count < self.enemyCount then
    FloatingTipUtility.QuickMsg("Ti\225\187\129n kh\195\180ng \196\145\225\187\167")
    return
  end
  local limitCount = WarAllianceData.MyWarAllianceData.announceLeftTimes or 0
  if limitCount <= 0 then
    FloatingTipUtility.QuickMsg("L\198\176\225\187\163t tuy\195\170n chi\225\186\191n c\195\178n l\225\186\161i kh\195\180ng \196\145\225\187\167 ")
    return
  end
  NetManager.Send(UnionMessage.ReqAnnounceEnemy, {
    unionId = self.EnemyId
  })
  self:btn_noOnClick()
end

function WarAlliance_Rank:RegistEvents()
  self:RegistEvent(Event.WarAlliance_InitWarAllianceList, self.InitWarAllianceList, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshTextCount, self)
end

function WarAlliance_Rank:Refresh()
  self.panel_relation:SetActive(false)
  NetManager.Send(UnionMessage.ReqUnionList)
end

local function Button_WarAllianceItemCreate(control)
  control.lab_rank = UIControl(control.transform, "lab_rank")
  control.lab_name = UIControl(control.transform, "lab_name")
  control.lab_number = UIControl(control.transform, "lab_number")
  control.lab_level = UIControl(control.transform, "lab_level")
  control.lab_enemy = UIControl(control.transform, "lab_enemy")
  control.btn_enemy = UIControl(control.transform, "btn_enemy")
  control.lab_enemyState = UIControl(control.transform, "btn_enemy/lab_enemyState")
end

function WarAlliance_Rank:InitContent()
  self.Button_WarAllianceItemTemp = UIContainer(self.Button_WarAllianceItem, self, Button_WarAllianceItemCreate)
end

local function WarAllianceListSort(data1, data2)
  if data1.level ~= data2.level then
    return data1.level > data2.level
  end
  return data1.unionFight > data2.unionFight
end

function WarAlliance_Rank:InitWarAllianceList()
  for k, v in pairs(self.listSelect) do
    v:SetActive(false)
  end
  local data = table.DeepCopy(WarAllianceData.WarAllianceDataList)
  table.sort(data, WarAllianceListSort)
  local medata = WarAllianceData.MyWarAllianceData
  if 0 < #data then
    for i = 1, #data do
      local isMe = data[i].id == medata.id
      local obj = self.Button_WarAllianceItemTemp:GetOrCreateItem(i)
      obj.lab_rank:SetText(i)
      obj.lab_name:SetText(data[i].name)
      local unionMax = ClientTable.cfg_union_unionLevelManager:TryGetValue(data[i].level, "unionLevel").unionMax
      obj.lab_number:SetText(data[i].count .. "/" .. unionMax)
      obj.lab_level:SetText(data[i].level)
      local txtColor = isMe and string.format("0x%sFF", string.sub(ItemQuality2ColorDic[5], 2)) or string.format("0x%sFF", string.sub(ItemQuality2ColorDic[0], 2))
      obj.lab_rank:SetColor(txtColor)
      obj.lab_name:SetColor(txtColor)
      obj.lab_number:SetColor(txtColor)
      obj.lab_level:SetColor(txtColor)
      local memberCfg = ClientTable.cfg_union_memberManager:TryGetValue(medata.position, "id")
      if data[i].isEnemy then
        obj.lab_enemy:SetText(string.GetColorText("\196\144\225\187\145i \196\145\225\187\139ch", ItemQuality2ColorDic[7]))
      else
        obj.lab_enemy:SetText(string.GetColorText("Th\195\162n thi\225\187\135n", ItemQuality2ColorDic[5]))
      end
      if data[i].isEnemy then
        obj.lab_enemyState:SetText(string.GetColorText("\196\144\225\187\145i \196\145\225\187\139ch", ItemQuality2ColorDic[7]))
      else
        obj.lab_enemyState:SetText("Tuy\195\170n chi\225\186\191n")
      end
      if isMe then
        obj.lab_enemyState:SetText(string.GetColorText("Guild", ItemQuality2ColorDic[6]))
        obj.lab_enemy:SetText(string.GetColorText("Guild", ItemQuality2ColorDic[6]))
      end
      obj.btn_enemy:SetInteractable(not data[i].isEnemy)
      obj.btn_enemy:SetActive(memberCfg.makeEnemy == 1)
      obj.btn_enemy:SetOnClick(self, function()
        self:initiateEnemy(data[i].id, data[i].name)
      end)
      obj:SetOnClick(self, function()
        self:Button_WarAllianceListOnClick(data[i].id, obj)
      end)
      obj:SetActive(true)
      table.insert(self.listSelect, obj)
    end
    local RandomNum = Mathf.Random(1, #data)
    self:Button_WarAllianceListOnClick(data[RandomNum].id, self.listSelect[RandomNum])
  end
end

function WarAlliance_Rank:initiateEnemy(unionID, unionName)
  if unionID == ViewData.meData.unionId then
    FloatingTipUtility.QuickMsg("Guild Tuy\195\170n chi\225\186\191n \235\182\136\234\176\128")
    return
  end
  self.EnemyId = unionID
  self.lab_tip:SetText(unionName)
  local needItem = ClientTable.cfg_Global_globalManager:TryGetValue(10000024, "id").effect
  self.enemyItemId = tonumber(string.split(needItem, "#")[1])
  self.enemyCount = tonumber(string.split(needItem, "#")[2])
  local itemData = ItemUtility.GenerateItemData(self.enemyItemId)
  itemData.count = self.enemyCount
  self.btn_3DItem.itemCellData = self.btn_3DItem.itemCellData or ItemCellData()
  self.btn_3DItem.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.btn_3DItem.itemCellData, self, true)
  self.lab_tip2:SetText(WarAllianceData.MyWarAllianceData.announceLeftTimes or 0)
  self:RefreshTextCount()
  self.panel_relation:SetActive(true)
end

function WarAlliance_Rank:RefreshTextCount()
  local count = BagInfoData.GetItemCountByItemConfigId(self.enemyItemId)
  if self.enemyCount ~= nil and count < self.enemyCount then
    count = BagInfoData.GetItemTotalCountByItemId(self.enemyItemId)
  end
  if count < self.enemyCount then
    self.txt_count:SetText(string.GetColorText(self.enemyCount, ItemQuality2ColorDic[7]))
  else
    self.txt_count:SetText(string.GetColorText(self.enemyCount, ItemQuality2ColorDic[5]))
  end
end

function WarAlliance_Rank:Button_WarAllianceListOnClick(id, obj)
  NetManager.Send(UnionMessage.ReqUnionSimpleInfo, {id = id})
  self:SetButtonPitchOn(self.listSelect, obj)
end

function WarAlliance_Rank:SetButtonPitchOn(ObjTab, Control)
  for k, v in pairs(ObjTab) do
    if v == Control then
      v:GetChild("img_clickeffect"):SetActive(true)
    else
      v:GetChild("img_clickeffect"):SetActive(false)
    end
  end
end
