DropItemHead = class()

function DropItemHead:ctor(item, data)
  self.data = data
  self.avatar = item
  self:RefreshData(item, true)
end

function DropItemHead:RefreshData(item, showName)
  if item then
    self.avatar = item
  end
  self:ShowHead(showName)
end

function DropItemHead:Update()
end

function DropItemHead:ShowHead(showName)
  if self.mTitleIns == nil then
    self.mTitleIns = CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:RegisterTitle(self.avatar.transform, 1.8, self.avatar.isMe)
  end
  self.mTitle = CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:GetTitle(self.mTitleIns)
  if self.mTitle ~= nil then
    self.mTitle:Clear()
    self.mTitle:SetOffsetY(-1.5)
    self.mTitle:ShowTitle(true)
    if showName then
      self:SetActorName()
    end
  end
end

function DropItemHead:SetActorName()
  self.mTitle:BeginTitle()
  self.HudStyle = self.HudStyle == nil and HUDTitleStyle.PlayerName or self.HudStyle
  local fontColorTab, bgColorTab = self:ChangeColorByLevel()
  self.titleIndex = self.mTitle:PushCustomColorTitle(self.data.item.headItemName, self.HudStyle, fontColorTab, 0)
  self.mTitle:PushTitleBg(self.titleIndex, bgColorTab)
  self.mTitle:EndTitle()
end

function DropItemHead:ChangeColorByLevel()
  if self.data.type == EItemType.Equipe then
    local fontColor, bgColor = DropItemUtility.GetDropItemLevelColor(self.data.item.rarity)
    local fontColorTab = {
      r = math.ceil(fontColor.r * 255),
      g = math.ceil(fontColor.g * 255),
      b = math.ceil(fontColor.b * 255),
      a = 255
    }
    return fontColorTab, bgColor
  else
    local fontColor = ItemQuality2RGBDic[self.data.showColor]
    local bgColor = Color.black
    local fontColorTab = {
      r = math.ceil(fontColor.r * 255),
      g = math.ceil(fontColor.g * 255),
      b = math.ceil(fontColor.b * 255),
      a = 255
    }
    return fontColorTab, bgColor
  end
end

function DropItemHead:Destroy()
  if not self.mTitleIns then
    logError("Kh\195\180ng c\195\179 \196\145\225\187\145i t\198\176\225\187\163ng r\198\161i tr\195\170n \196\145\225\186\167u")
  end
  if self.mTitleIns ~= nil then
    CS.Framework.HUDTitleInfo.HUDTitleRender.Instance:ReleaseTitle(self.mTitleIns)
    self.mTitleIns = nil
  end
  self.mTitle = nil
end
