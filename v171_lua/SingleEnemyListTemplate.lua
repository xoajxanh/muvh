local SingleEnemyListTemplate = {}
SingleEnemyListTemplate.IsDirty = nil
SingleEnemyListTemplate._baseTemplate = nil
SingleEnemyListTemplate._data = nil

function SingleEnemyListTemplate:Init()
  self:InitComponent()
  self:BindClick()
  self:ShowStage(false)
end

function SingleEnemyListTemplate:InitComponent()
  self.Content = self:GetControl("Content")
  self.EnemyHead = self:GetControl("Content/EnemyHead")
  self.btn_activty_qiehuan = self:GetControl("btn_activty_qiehuan")
end

function SingleEnemyListTemplate:InitContainer()
  if self.EnemyHeadContainer == nil then
    self.EnemyHeadContainer = UIUtility.BindUIContainerTemp(self.EnemyHead, LuaComponentTemplates.HeadTemplate, self._baseTemplate._baseUI)
  end
end

function SingleEnemyListTemplate:BindClick()
end

function SingleEnemyListTemplate:btn_activty_qiehuanOnClick()
  if self._baseTemplate ~= nil then
    self:ShowStage(false)
    self._baseTemplate:ChangeCallBack()
  end
end

function SingleEnemyListTemplate:Refresh(data, baseTemplate)
  if self.IsDirty then
    self._baseTemplate = baseTemplate
    self._data = data[1]
    self.IsDirty = false
    self:InitContainer()
    local playerList = {}
    for i, v in pairs(self._data:GetPlayerInfoList()) do
      if v._serverData.id ~= RoleManager.me.id then
        table.insert(playerList, v)
      end
    end
    self.EnemyHeadContainer:SetData(playerList)
    self:RefreshChangeBtnPos()
  else
    self:RefreshSimpleData()
  end
  self:ShowStage(true)
end

function SingleEnemyListTemplate:RefreshChangeBtnPos()
  if self.EnemyHeadContainer == nil or next(self.EnemyHeadContainer.items) == nil then
    return
  end
  local offsetX = 10
  local isRightTemplate = self._baseTemplate._refreshRightEnemyList
  local totalW, totalH = self.Content:GetSizeDelta()
  local headW, headH = self.EnemyHead:GetSizeDelta()
  local changeBtnW, changeBtnH = self.btn_activty_qiehuan:GetSizeDelta()
  local count = #self.EnemyHeadContainer.items
  local length = headW * count + changeBtnW * 0.5 + offsetX
  local x, y = length, -50
  if isRightTemplate then
    x = totalW - length
  end
  self.btn_activty_qiehuan:SetAnchoredPosition(x, y)
end

function SingleEnemyListTemplate:RefreshSinglePlayer(data)
  if self.EnemyHeadContainer == nil then
    return
  end
  local enemyHeadContainerItems = self.EnemyHeadContainer.items
  if table.count(enemyHeadContainerItems) > 0 then
    for i, v in pairs(enemyHeadContainerItems) do
      if v.itemTemp.CampPlayerInfo and v.itemTemp.CampPlayerInfo:GetId() == data:GetId() then
        v.itemTemp:RefreshSimple(data)
        return
      end
    end
  end
end

function SingleEnemyListTemplate:RefreshSimpleData()
  if self.EnemyHeadContainer == nil then
    return
  end
  local enemyHeadContainerItems = self.EnemyHeadContainer.items
  if table.count(enemyHeadContainerItems) > 0 then
    for i, v in pairs(enemyHeadContainerItems) do
      v.itemTemp:RefreshState()
      v.itemTemp:RefreshChoose()
    end
  end
end

function SingleEnemyListTemplate:RefreshChoose()
  if self.EnemyHeadContainer == nil then
    return
  end
  local enemyHeadContainerItems = self.EnemyHeadContainer.items
  if table.count(enemyHeadContainerItems) > 0 then
    for i, v in pairs(enemyHeadContainerItems) do
      v.itemTemp:RefreshChoose()
    end
  end
end

function SingleEnemyListTemplate:ShowStage(show)
  self:UIControl():SetActive(show)
end

function SingleEnemyListTemplate:Update()
  if self.EnemyHeadContainer ~= nil then
    local enemyHeadContainerItems = self.EnemyHeadContainer.items
    for k, v in pairs(enemyHeadContainerItems) do
      v.itemTemp:Update()
    end
  end
end

return SingleEnemyListTemplate
