DropItemHead3DMesh = class()

function DropItemHead3DMesh:ctor(item, data)
  self.data = data
  self.avatar = item
  self:RefreshData(item, true)
end

function DropItemHead3DMesh:RefreshData(item, showName)
  if item then
    self.avatar = item
  end
  self:ShowHead(showName)
end

function DropItemHead3DMesh:Update()
end

function DropItemHead3DMesh:ShowHead(showName)
  if self.trans == nil then
    self.gameObj = CS.Framework.ResourceManager.Instantiate("HUD/toplogoDropItem.prefab", Vector3.unity_vector3.zero, HUDSetting.Rotation, self.avatar.transform)
    self.trans = self.gameObj.transform
    self.trans:SetLocalPosition(0, 0.3, 0)
    self.trans.localScale = CS.UnityEngine.Vector3.one
  end
  if self.nameLabel == nil then
    self.nameLabel = self.trans:Find("Label", typeof(CS.CSLabel))
  end
  if self.bg == nil then
    self.bg = self.trans:Find("bg")
  end
  self.gameObj:SetActive(true)
  if showName then
    self:SetActorName()
  end
end

function DropItemHead3DMesh:SetActorName()
  local fontColorTab, bgColorTab = self:ChangeColorByLevel()
  if self.nameLabel ~= nil then
    local count = ""
    if self.data ~= nil and self.data.itemData ~= nil and DropItemUtility.IsNeedShowCount(self.data.itemData.itemId) then
      count = self.data.itemData.count
    end
    self.nameLabel.text = self.data.item.headItemName .. count
    self.nameLabel.color = fontColorTab
    self.nameLabel:Fill()
    if self.bg ~= nil then
      self.bg:SetLocalScale(self.nameLabel.halfWidth / 32, 2.62, 1)
    end
  end
end

function DropItemHead3DMesh:ChangeColorByLevel()
  if self.data.type == EItemType.Equipe then
    local fontColor, bgColor = DropItemUtility.GetDropItemLevelColor(self.data.item.rarity)
    return fontColor, bgColor
  else
    local fontColor = ItemQuality2RGBDic[self.data.showColor]
    local bgColor = Color.black
    return fontColor, bgColor
  end
end

function DropItemHead3DMesh:Destroy()
  if self.gameObj ~= nil then
    if self.nameLabel ~= nil then
      self.nameLabel.rightIndex = 0
    end
    CS.Framework.ResourceManager.Recycle(self.gameObj)
    self.gameObj = nil
    self.trans = nil
    self.nameLabel = nil
    self.bg = nil
  end
end
