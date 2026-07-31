local Instance_ClimbTowerTower_SpecialTemplate = {}
Instance_ClimbTowerTower_SpecialTemplate.PrivilegeObj = nil

function Instance_ClimbTowerTower_SpecialTemplate:Init(data)
  self:InitControls()
  self:InitUI()
  self:InitData(data)
  self:BindUIEvent()
end

function Instance_ClimbTowerTower_SpecialTemplate:InitUI()
end

function Instance_ClimbTowerTower_SpecialTemplate:InitControls()
  self.img_Bg = self:GetControl("img_Bg")
  self.img_Select = self:GetControl("img_Select")
  self.img_currentFloor = self:GetControl("img_currentFloor")
  self.lab_floorNum = self:GetControl("lab_floorNum")
  self.lab_floorNum_lock = self:GetControl("lab_floorNum_lock")
  self.img_finish = self:GetControl("img_finish")
  self.img_redPoint = self:GetControl("img_redPoint")
end

function Instance_ClimbTowerTower_SpecialTemplate:InitData(data)
  if data then
    self.clickCallBack = data.clickCallBack
    self.baseUI = data.baseUI
    self.nowCtr = data.nowCtr
  end
end

function Instance_ClimbTowerTower_SpecialTemplate:BindUIEvent()
  if self.nowCtr then
    self.nowCtr:SetOnClick(self, self.OnPageToggleValueChanged)
  end
end

function Instance_ClimbTowerTower_SpecialTemplate:OnPageToggleValueChanged(control)
  if self.data and self.data.head then
    return
  end
  if self.clickCallBack and self.baseUI then
    self.clickCallBack(self.baseUI, control)
  end
end

function Instance_ClimbTowerTower_SpecialTemplate:Refresh(data)
end

function Instance_ClimbTowerTower_SpecialTemplate:onShowPanel(data, index, parentui)
  self.data = data
  if data then
    self.selectIndex = 1
    self.dataTemp = data
    if parentui then
      self.parentui = parentui
    end
    if self.bgSpriteCol ~= nil then
      Coroutine.Stop(self.bgSpriteCol)
      self.bgSpriteCol = nil
    end
    if data.islock == 1 then
      self.bgSpriteCol = self.parentui:SetSprite("Atlas_Common", data.climbTower, self.img_Bg, true)
      self.lab_floorNum:SetActive(true)
      self.lab_floorNum:SetText(data.id)
      self.img_currentFloor:SetActive(true)
      self.lab_floorNum_lock:SetActive(false)
      self.img_finish:SetActive(false)
      self.img_redPoint:SetActive(false)
    elseif data.islock == 2 then
      self.bgSpriteCol = self.parentui:SetSprite("Atlas_Common", data.climbTowerLock, self.img_Bg, true)
      self.lab_floorNum_lock:SetActive(true)
      self.lab_floorNum_lock:SetText(data.id)
      self.img_currentFloor:SetActive(false)
      self.lab_floorNum:SetActive(false)
      self.img_redPoint:SetActive(false)
      self.img_finish:SetActive(false)
    elseif data.islock == 3 then
      self.bgSpriteCol = self.parentui:SetSprite("Atlas_Common", data.climbTower, self.img_Bg, true)
      self.lab_floorNum_lock:SetActive(false)
      self.lab_floorNum:SetText(data.id)
      self.lab_floorNum:SetActive(true)
      self.img_finish:SetActive(true)
      self.img_redPoint:SetActive(not data.isreward)
      self.img_currentFloor:SetActive(false)
    else
      self.bgSpriteCol = self.parentui:SetSprite("Atlas_Common", "img_ClimbTower_Top", self.img_Bg, true)
      self.img_currentFloor:SetActive(false)
      self.lab_floorNum:SetActive(false)
      self.lab_floorNum_lock:SetActive(false)
      self.img_finish:SetActive(false)
      self.img_redPoint:SetActive(false)
    end
    if index == data.id then
      self:OnPageToggleValueChanged(self.nowCtr)
    else
      self.img_Select:SetActive(false)
    end
  end
end

function Instance_ClimbTowerTower_SpecialTemplate:DoSetSprite(imageTable)
  if not string.isNullOrEmpty(imageTable.atlasName) then
    local atlasPath = string.format("Texture/%s.spriteatlas", imageTable.atlasName)
    local request = self:LoadAssetAsync(atlasPath, typeof(CS.UnityEngine.U2D.SpriteAtlas))
    if request ~= nil then
      Coroutine.Yield(request)
      if request.isError then
        Coroutine.Break()
      end
      local spriteAtlas = request.res
      local sprite = spriteAtlas:GetSprite(tostring(imageTable.IconName))
      if sprite ~= nil and imageTable.IconName ~= nil then
        sprite.name = tostring(imageTable.IconName)
      end
      imageTable.Image:SetSprite(sprite)
      if self:onGetSelectIndex() > 1 then
        imageTable.Image:SetActive(true)
      else
        imageTable.Image:SetActive(false)
      end
      if imageTable.NativeSize then
        imageTable.Image:SetNativeSize()
      end
      imageTable.Image.loader = nil
    end
  else
    imageTable.Image:SetActive(false)
  end
end

function Instance_ClimbTowerTower_SpecialTemplate:LoadAssetAsync(path, type, callback)
  local request = self:GetAssetGroup():LoadAssetAsync(path, type)
  if callback then
    request:AddCallback(callback)
  end
  return request
end

function Instance_ClimbTowerTower_SpecialTemplate:GetAssetGroup()
  if not self.assetGroup then
    self.assetGroup = CS.Framework.AssetGroup()
  end
  return self.assetGroup
end

function Instance_ClimbTowerTower_SpecialTemplate:onGetSelectIndex()
  return self.selectIndex
end

function Instance_ClimbTowerTower_SpecialTemplate:onNoSelelct(data)
  self.img_Select:SetActive(false)
end

function Instance_ClimbTowerTower_SpecialTemplate:onSelelct(data)
  self.parentui:SetSprite("Atlas_Common", self.data.climbTowerSelect, self.img_Select, true)
end

function Instance_ClimbTowerTower_SpecialTemplate:onSetRedpoint(data)
  self.img_redPoint:SetActive(data)
end

function Instance_ClimbTowerTower_SpecialTemplate:Destroy()
  self.dataTemp = {}
end

return Instance_ClimbTowerTower_SpecialTemplate
