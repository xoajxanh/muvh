ItemUtility = {}
local this = ItemUtility
local itemPos2TransInfo = {
  [EItemType.Equipe] = {
    [EItemSubtype.OneHandedSword] = {
      pos = Vector3(10, -40, -50),
      rota = Vector3(-80, -90, 0),
      scale = 30
    },
    [EItemSubtype.HongZhuang_OneHandedSword] = {
      pos = Vector3(10, -40, -50),
      rota = Vector3(-80, -90, 0),
      scale = 30
    },
    [EItemSubtype.Suit_OneHandedSword] = {
      pos = Vector3(10, -40, -50),
      rota = Vector3(-80, -90, 0),
      scale = 30
    },
    [EItemSubtype.Suit_OneHandedSword_Other] = {
      pos = Vector3(10, -40, -50),
      rota = Vector3(-80, -90, 0),
      scale = 30
    },
    [EItemSubtype.TwoHandedSword] = {
      pos = Vector3(10, -40, -50),
      rota = Vector3(-80, -90, 0),
      scale = 30
    },
    [EItemSubtype.Spear] = {
      pos = Vector3(10, -25, -50),
      rota = Vector3(-70, -90, 0),
      scale = 30
    },
    [EItemSubtype.OneHandedAxe] = {
      pos = Vector3(10, -25, -50),
      rota = Vector3(-80, -90, 0),
      scale = 30
    },
    [EItemSubtype.TwoHandedAxe] = {
      pos = Vector3(10, -25, -50),
      rota = Vector3(-80, -90, 0),
      scale = 30
    },
    [EItemSubtype.OneHandedStick] = {
      pos = Vector3(10, -25, -50),
      rota = Vector3(-70, -90, 0),
      scale = 30
    },
    [EItemSubtype.RedOneHandedStick] = {
      pos = Vector3(10, -25, -50),
      rota = Vector3(-70, -90, 0),
      scale = 30
    },
    [EItemSubtype.Suit_OneHandedStick] = {
      pos = Vector3(10, -25, -50),
      rota = Vector3(-70, -90, 0),
      scale = 30
    },
    [EItemSubtype.Suit_Summoner_MagicWand] = {
      pos = Vector3(10, -25, -50),
      rota = Vector3(-70, -90, 0),
      scale = 30
    },
    [EItemSubtype.TwoHandedStick] = {
      pos = Vector3(10, -25, -50),
      rota = Vector3(-70, -90, -90),
      scale = 30
    },
    [EItemSubtype.Shield] = {
      pos = Vector3(0, 0, -50),
      rota = Vector3(0, -90, 0),
      scale = 30
    },
    [EItemSubtype.RedShield] = {
      pos = Vector3(0, 0, -50),
      rota = Vector3(0, -90, 0),
      scale = 30
    },
    [EItemSubtype.Suit_Shield] = {
      pos = Vector3(0, 0, -50),
      rota = Vector3(0, -90, 0),
      scale = 30
    },
    [EItemSubtype.Suit_Summoner_MagicBook] = {
      pos = Vector3(0, 0, -50),
      rota = Vector3(0, -90, 0),
      scale = 30
    },
    [EItemSubtype.Arch] = {
      pos = Vector3(0, -5, -50),
      rota = Vector3(-70, -90, 0),
      scale = 30
    },
    [EItemSubtype.RedArch] = {
      pos = Vector3(0, -5, -50),
      rota = Vector3(-70, -90, 0),
      scale = 30
    },
    [EItemSubtype.Suit_Arch] = {
      pos = Vector3(0, -5, -50),
      rota = Vector3(-70, -90, 0),
      scale = 30
    },
    [EItemSubtype.CrossBow] = {
      pos = Vector3(15, -30, -50),
      rota = Vector3(0, 0, -160),
      scale = 40
    },
    [EItemSubtype.Suit_CrossBow] = {
      pos = Vector3(15, -30, -50),
      rota = Vector3(0, 0, -160),
      scale = 40
    },
    [EItemSubtype.Wand] = {
      pos = Vector3(7, -35, -50),
      rota = Vector3(-85, -90, 0),
      scale = 40
    },
    [EItemSubtype.Katar] = {
      pos = Vector3(0, 0, -50),
      rota = Vector3(0, -90, 0),
      scale = 40
    },
    [EItemSubtype.Helmet] = {
      pos = Vector3(0, -280, -50),
      rota = Vector3(0, -140, 0),
      scale = 60
    },
    [EItemSubtype.BreastPlate] = {
      pos = Vector3(0, -185, -50),
      rota = Vector3(0, -180, 0),
      scale = 50
    },
    [EItemSubtype.ShinGuards] = {
      pos = Vector3(0, -100, -50),
      rota = Vector3(0, -180, 0),
      scale = 45
    },
    [EItemSubtype.HandGuards] = {
      pos = Vector3(0, -120, -50),
      rota = Vector3(0, -180, 0),
      scale = 50
    },
    [EItemSubtype.Shoes] = {
      pos = Vector3(0, -35, -80),
      rota = Vector3(0, -180, 0),
      scale = 45
    },
    [EItemSubtype.Ring] = {
      pos = Vector3(0, 0, -50),
      rota = Vector3(0, 0, 0),
      scale = 45
    },
    [EItemSubtype.Necklace] = {
      pos = Vector3(0, 0, -50),
      rota = Vector3(0, -90, 0),
      scale = 40
    },
    [EItemSubtype.Wing] = {
      pos = Vector3(0, 0, -80),
      rota = Vector3(0, 0, 0),
      scale = 30
    },
    [EItemSubtype.Guards] = {
      pos = Vector3(-12, -10, -50),
      rota = Vector3(0, -90, 0),
      scale = 40
    },
    [EItemSubtype.Mount] = {
      pos = Vector3(0, 0, -50),
      rota = Vector3(0, -90, 0),
      scale = 40
    },
    [EItemSubtype.Other] = {
      pos = Vector3(0, -25, -50),
      rota = Vector3(90, -90, 0),
      scale = 30
    },
    [EItemSubtype.BowBag] = {
      pos = Vector3(0, -25, -50),
      rota = Vector3(-260, -90, 0),
      scale = 30
    },
    [EItemSubtype.Suit_BowBag] = {
      pos = Vector3(0, -25, -50),
      rota = Vector3(-260, -90, 0),
      scale = 30
    },
    [EItemSubtype.CrossBowBag] = {
      pos = Vector3(0, -25, -50),
      rota = Vector3(-260, -90, 0),
      scale = 30
    },
    [EItemSubtype.Suit_CrossBowBag] = {
      pos = Vector3(0, -25, -50),
      rota = Vector3(-260, -90, 0),
      scale = 30
    },
    [EItemSubtype.Earrings] = {
      pos = Vector3(0, -25, -50),
      rota = Vector3(-260, -90, 0),
      scale = 30
    }
  },
  [EItemType.Consumables] = {
    [0] = {
      pos = Vector3(0, -20, -50),
      rota = Vector3(0, 0, 0),
      scale = 45
    }
  },
  [EItemType.SkillBook] = {
    [0] = {
      pos = Vector3(0, 0, -50),
      rota = Vector3(0, -180, 0),
      scale = 25
    }
  },
  [EItemType.TreasureChest] = {
    [0] = {
      pos = Vector3(0, -12, -50),
      rota = Vector3(0, -90, 0),
      scale = 30
    }
  },
  [EItemType.Material] = {
    [0] = {
      pos = Vector3(0, 0, -50),
      rota = Vector3(0, -180, 0),
      scale = 30
    }
  },
  [EItemType.GemStone] = {
    [0] = {
      pos = Vector3(0, 0, -50),
      rota = Vector3(90, 90, -90),
      scale = 30
    }
  },
  [EItemType.Other] = {
    [0] = {
      pos = Vector3.zero,
      rota = Vector3(90, 90, -90),
      scale = 30
    }
  }
}
local specialItemPos2TransInfo = {
  [2080130] = {
    pos = Vector3(0, -30, -50),
    rota = Vector3(10, -90, 0),
    scale = 40
  },
  [2210050] = {
    pos = Vector3(0, -30, -50),
    rota = Vector3(0, -90, 0),
    scale = 40
  },
  [2210060] = {
    pos = Vector3(0, -50, -50),
    rota = Vector3(0, -90, 0),
    scale = 40
  },
  [2130040] = {
    pos = Vector3(0, -260, -50),
    rota = Vector3(0, -140, 0),
    scale = 60
  }
}

function ItemUtility.GetItemTransformInfo(itemData)
  local iType = itemData.tblItem.type
  local subtype = itemData.tblItem.subType
  local itemId = itemData.tblItem.id
  if specialItemPos2TransInfo[itemId] then
    return specialItemPos2TransInfo[itemId]
  end
  local subTypeTransInfo = itemPos2TransInfo[iType]
  local info
  if subTypeTransInfo == nil then
    info = {
      pos = Vector3.zero,
      rota = Vector3(90, 90, -90),
      scale = 30
    }
  else
    if iType == EItemType.Equipe then
      info = subTypeTransInfo[subtype]
    else
      info = subTypeTransInfo[0]
    end
    info = info or {
      pos = Vector3.zero,
      rota = Vector3(90, 90, -90),
      scale = 30
    }
  end
  return info
end

function ItemUtility.GetModelTransformInfo(itemData)
  local posInfos = {}
  local goConfig = {}
  if not string.isNullOrEmpty(itemData.tblItem.Position) then
    posInfos = string.split(itemData.tblItem.Position, "#")
    if table.count(posInfos) == 3 then
      local pos = string.split(posInfos[1], "|")
      local rota = string.split(posInfos[3], "|")
      goConfig = {
        pos = Vector3(tonumber(pos[1]), tonumber(pos[2]), -50),
        rota = Vector3(tonumber(rota[1]), tonumber(rota[2]), tonumber(rota[3])),
        scale = tonumber(posInfos[2])
      }
    else
      goConfig = this.GetItemTransformInfo(itemData)
    end
  else
    goConfig = this.GetItemTransformInfo(itemData)
  end
  return goConfig
end

function ItemUtility.SetModelTransform(go, parent, itemData, sizeRatio, orderLayer)
  if parent == nil then
    go.transform:SetParent(parent, false)
  end
  local goConfig = ItemUtility.GetModelTransformInfo(itemData)
  local pos = Vector3(goConfig.pos.x * sizeRatio, goConfig.pos.y * sizeRatio, goConfig.pos.z)
  go.transform.localPosition = pos
  go.transform.localEulerAngles = goConfig.rota
  local scale = goConfig.scale * sizeRatio
  go.transform.localScale = Vector3(scale, scale, scale)
  go:SetLayer(UI_LAYER)
  local renders = go.transform:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
  for i = 0, renders.Length - 1 do
    local rend = renders[i]
    rend.sortingOrder = orderLayer + 100
  end
  local sys = go.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  for i = 0, sys.Length - 1 do
    local par = sys[i]
    par.gameObject.layer = 5
    par:GetComponent(typeof(CS.UnityEngine.Renderer)).sortingOrder = orderLayer + 50
  end
  return go
end

function ItemUtility.InitItem(itemCtr)
  local itemTbl = itemCtr
  itemTbl.countCtr = UIControl(itemCtr.transform, "img_icon/num")
  itemTbl.iconCtr = UIControl(itemCtr.transform, "img_icon")
  itemTbl.iconCtr:SetActive(false)
  itemTbl.selectImageCtr = UIControl(itemCtr.transform, "img_select")
  itemTbl.redPointCtr = UIControl(itemCtr.transform, "img_redPoint")
  itemTbl.nameCtr = UIControl(itemCtr.transform, "lab_name")
  itemTbl.frameCtr = UIControl(itemCtr.transform, "img_Frame")
  itemTbl.additionalCtr = UIControl(itemCtr.transform, "item_additional/lab_additional")
  itemTbl.strengthenCtr = UIControl(itemCtr.transform, "item_strengthen/lab_strengthen")
  itemTbl.img_suitCtr = UIControl(itemCtr.transform, "img_suit")
  itemTbl.img_excellenceCtr = UIControl(itemCtr.transform, "img_excellence")
  itemTbl.inited = true
  return itemTbl
end

function ItemUtility.ShowItem(ui, itemCtr, itemData, bindClick)
  if not itemCtr.inited then
    itemCtr = this.InitItem(itemCtr)
  end
  if itemCtr.spriteCol then
    Coroutine.Stop(itemCtr.spriteCol)
    itemCtr.spriteCol = nil
  end
  if itemData ~= nil then
    this.SetIconGray(itemCtr, false)
    itemCtr.spriteCol = ui:SetSprite("Atlas_Common", itemData.tblItem.icon, itemCtr.iconCtr)
    if itemCtr.countCtr:GetActive() then
      local showCount = itemData ~= nil and itemData.tblItem.overlying ~= 1
      if not showCount then
        itemCtr.countCtr:SetText("")
      else
        itemCtr.countCtr:SetText(itemData.count)
        if itemData.count == 1 then
          itemCtr.countCtr:SetText("")
        end
      end
    end
    if itemCtr.nameCtr.transform and itemCtr.nameCtr:GetActive() then
      local name = itemData.tblItem.name
      local colorShow = itemData.tblItem.colorShow
      name = string.GetColorText(name, ItemQuality2ColorDic[colorShow])
      itemCtr.nameCtr:SetText(name)
    end
    if itemCtr.frameCtr.transform and itemCtr.frameCtr:GetActive() then
      local quality = itemData.tblItem.quality
      itemCtr.frameCtr:SetColor(ItemQuality2ColorDic[quality])
    end
    if itemCtr.additionalCtr.transform then
      if itemData.additional and itemData.additional > 0 then
        itemCtr.additionalCtr:SetActive(true)
        itemCtr.additionalCtr:SetText(string.format(LocalizationUtility.GetContentByKey("zhui"), itemData.additional))
      else
        itemCtr.additionalCtr:SetActive(false)
      end
    end
    if itemCtr.strengthenCtr.transform then
      if itemData.intensify and 0 < itemData.intensify then
        itemCtr.strengthenCtr:SetActive(true)
        itemCtr.strengthenCtr:SetText("+" .. itemData.intensify)
      else
        itemCtr.strengthenCtr:SetActive(false)
      end
    end
    if itemCtr.img_suitCtr.transform then
      if itemData.tblEquip and not string.isNullOrEmpty(itemData.tblEquip.suitId) then
        itemCtr.img_suitCtr:SetActive(true)
      else
        itemCtr.img_suitCtr:SetActive(false)
      end
    end
    if itemCtr.img_excellenceCtr.transform then
      if itemData.tblEquip and not string.isNullOrEmpty(itemData.tblEquip.excellentNumber) then
        itemCtr.img_excellenceCtr:SetActive(true)
      else
        itemCtr.img_excellenceCtr:SetActive(false)
      end
    end
    if bindClick then
      itemCtr.itemData = itemData
      itemCtr:SetOnClick(this, this.ClickItemBtn)
    end
  end
  if itemData == nil then
    itemCtr.iconCtr:SetActive(false)
    if itemCtr.strengthenCtr.transform and itemCtr.strengthenCtr:GetActive() then
      itemCtr.strengthenCtr:SetActive(false)
    end
    if itemCtr.additionalCtr.transform and itemCtr.additionalCtr:GetActive() then
      itemCtr.additionalCtr:SetActive(false)
    end
    if itemCtr.img_excellenceCtr.transform and itemCtr.img_excellenceCtr:GetActive() then
      itemCtr.img_excellenceCtr:SetActive(false)
    end
    if itemCtr.img_suitCtr.transform and itemCtr.img_suitCtr:GetActive() then
      itemCtr.img_suitCtr:SetActive(false)
    end
  end
  return itemCtr
end

function ItemUtility.InitDragCell(dragCtr)
  dragCtr.img_state = UIControl(dragCtr.transform, "img_state")
  dragCtr.inited = true
  return dragCtr
end

function ItemUtility.SetBackground(drag, dragCtr, itemCellData)
  if not dragCtr.inited then
    dragCtr = this.InitDragCell(dragCtr)
  end
  local name = itemCellData:GetBgSpriteName()
  if not string.isNullOrEmpty(name) then
    if drag.spriteAtlas then
      dragCtr.img_state:SetActive(true)
      local sprite = drag.spriteAtlas:GetSprite(tostring(name))
      dragCtr.img_state:SetSprite(sprite)
    else
      drag.ui:SetSprite("Atlas_Bag", name, dragCtr.img_state)
    end
  else
    dragCtr.img_state:SetActive(false)
  end
end

function ItemUtility.ShowDragCell(drag, dragCtr, itemCellData)
  if not dragCtr.inited then
    dragCtr = this.InitDragCell(dragCtr)
  end
  this.SetBackground(drag, dragCtr, itemCellData)
end

function ItemUtility.InitItemCell(itemCtr)
  local itemTbl = itemCtr
  itemTbl.countCtr = UIControl(itemCtr.transform, "lab_num")
  itemTbl.levelCtr = UIControl(itemCtr.transform, "level")
  itemTbl.redPointCtr = UIControl(itemCtr.transform, "img_redPoint")
  itemTbl.nameCtr = UIControl(itemCtr.transform, "lab_name")
  itemTbl.strengthenCtr = UIControl(itemCtr.transform, "lab_strengthen")
  itemTbl.additionalCtr = UIControl(itemCtr.transform, "lab_additional")
  itemTbl.grid_leftIcon = UIControl(itemCtr.transform, "grid_leftIcon")
  itemTbl.img_star = UIControl(itemCtr.transform, "grid_leftIcon/img_star")
  itemTbl.go_model = UIControl(itemCtr.transform, "go_model")
  itemTbl.selectImageCtr = UIControl(itemCtr.transform, "img_select")
  itemTbl.img_grrow = UIControl(itemCtr.transform, "img_grrow")
  itemTbl.img_isEquip = UIControl(itemCtr.transform, "img_isEquip")
  itemTbl.img_new = UIControl(itemCtr.transform, "img_new")
  itemTbl.img_dw = UIControl(itemCtr.transform, "img_dw")
  itemTbl.img_lock = UIControl(itemCtr.transform, "img_lock")
  itemTbl.img_is_recommend = UIControl(itemCtr.transform, "img_is_recommend")
  itemTbl.smeltingIcon = UIControl(itemCtr.transform, "smeltingIcon")
  itemTbl.inited = true
  return itemTbl
end

local function CalcCellSize(tblItem, w, h)
  if w == 0 or h == 0 then
    w = ForgeData.weight
    h = ForgeData.height
  end
  local x, y = w / BagInfoData.cellSize, h / BagInfoData.cellSize
  local xRatio = x / tblItem.xTranslate
  local yRatio = y / tblItem.yTranslate
  if tblItem.id == 1000020 or tblItem.id == 1000030 then
    xRatio = x
    yRatio = y
  end
  local a = Mathf.Min(xRatio, yRatio)
  if a < 1 then
    return a * 0.9
  else
    return 1
  end
end

local function DoOnComplete(itemCellData)
  itemCellData.isNeedShake = false
end

local pos1 = Vector3(-10, -10, 0)

local function ShakeItem(itemCellData)
  if itemCellData.isNeedShake and itemCellData.model.modelObject then
    itemCellData.model.modelObject.transform:DOPunchPosition(pos1, 0.2, 3, 0.1):SetAutoKill(true):OnComplete(function()
      DoOnComplete(itemCellData)
    end)
  end
end

function ItemUtility.ShakeEquipItem(modelObj)
  if modelObj then
    modelObj.transform:DOPunchPosition(pos1, 0.2, 3, -1):SetAutoKill(true)
  end
end

local function setIntensifyEffect(itemCellData, go)
  if this.IsEquipType(itemCellData.itemData.tblItem.type) and itemCellData.intensify ~= itemCellData.itemData.intensify then
    itemCellData.intensify = itemCellData.itemData.intensify
    EquipEffectSet:SetModelEffecByIntensify(itemCellData.itemData, go)
  elseif itemCellData.itemData.tblItem.type == EItemType.HolyRing and not itemCellData.meshTag then
    itemCellData.meshTag = true
    EquipEffectSet:SetModelEffecByIntensify(itemCellData.itemData, go)
  end
  ShakeItem(itemCellData)
end

local function SetItem(itemCtr, itemCellData, orderLayer, _Stencil, _maskType)
  local go = itemCellData.model and itemCellData.model.modelObject
  if go and IsNil(go) == false and itemCtr ~= nil then
    local sizeRatio = CalcCellSize(itemCellData.itemData.tblItem, itemCtr:GetSizeDelta())
    if sizeRatio < 0.01 then
      sizeRatio = 1
    end
    ItemUtility.SetModelTransform(go, itemCtr.go_model.transform, itemCellData.itemData, sizeRatio, orderLayer)
    if go.gameObject.activeSelf ~= true then
      go:SetActive(true)
    end
    setIntensifyEffect(itemCellData, go)
    if _Stencil ~= nil then
      itemCellData.isSetmaskInfo = true
      ItemUtility.NewSetShaderParamsValue(itemCellData.model, _Stencil, _maskType)
    else
      itemCellData.isSetmaskInfo = false
    end
  end
end

local function SetItemEffect(itemCtr, data, orderLayer)
  if data == nil or data.cellData == nil or data.effectTbl == nil then
    return
  end
  local go = data.cellData.effectModelLoader and data.cellData.effectModelLoader.modelObject
  if go == nil or IsNil(go) then
    return
  end
  local parent = data.cellData.effectModelLoader and data.cellData.effectModelLoader.transform
  if parent == nil or IsNil(parent) then
    return
  end
  if itemCtr.go_model and not IsNil(itemCtr.go_model.transform) then
    parent.localScale = itemCtr.go_model.transform.localScale
  end
  local sizeRatio = CalcCellSize(data.cellData.itemData.tblItem, itemCtr:GetSizeDelta())
  if sizeRatio < 0.01 then
    sizeRatio = 1
  end
  go.transform:SetParent(parent, false)
  local effectConfig = ItemUtility.GetEffectConfig(data.effectTbl, sizeRatio)
  go.transform.localPosition = effectConfig.pos
  go.transform.localEulerAngles = effectConfig.rota
  go.transform.localScale = effectConfig.scale
  go:SetLayer(UI_LAYER)
  local renders = go.transform:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
  for i = 0, renders.Length - 1 do
    local rend = renders[i]
    rend.sortingOrder = orderLayer + 100
  end
  local sys = go.transform:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  for i = 0, sys.Length - 1 do
    local par = sys[i]
    par.gameObject.layer = 5
    par:GetComponent(typeof(CS.UnityEngine.Renderer)).sortingOrder = orderLayer + 50
  end
  if go.gameObject.activeSelf ~= true then
    go:SetActive(true)
  end
  if itemCtr.go_effectModel == nil then
    itemCtr.go_effectModel = UIControl(itemCtr.transform, "go_effectModel")
    if itemCtr.go_effectModel.rectTransform == nil then
      parent.gameObject:AddComponent(typeof(CS.UnityEngine.RectTransform))
    end
  end
end

function ItemUtility.GetEffectConfig(effectTbl, sizeRatio)
  local pos = {
    x = 0,
    y = 0,
    z = 0
  }
  local scale = {
    x = 1,
    y = 1,
    z = 1
  }
  local rota = {
    x = 0,
    y = 0,
    z = 0
  }
  sizeRatio = sizeRatio or 1
  if effectTbl ~= nil then
    if not string.isNullOrEmpty(effectTbl.offset) then
      local posTbl = string.split(effectTbl.offset, "#")
      if table.count(posTbl) > 2 then
        pos = {
          x = tonumber(posTbl[1]) * sizeRatio,
          y = tonumber(posTbl[2]) * sizeRatio,
          z = tonumber(posTbl[3]) * sizeRatio
        }
      end
    end
    if not string.isNullOrEmpty(effectTbl.scale) then
      local scaleTbl = string.split(effectTbl.scale, "#")
      if table.count(scaleTbl) > 2 then
        scale = {
          x = tonumber(scaleTbl[1]) * sizeRatio,
          y = tonumber(scaleTbl[2]) * sizeRatio,
          z = tonumber(scaleTbl[3]) * sizeRatio
        }
      end
    end
  end
  return {
    pos = pos,
    scale = scale,
    rota = rota
  }
end

function ItemUtility.FadeOut(item, itemModer, time, recoverTime)
  item.matArray = {}
  item.defaultMat = {}
  if not itemModer then
    return
  end
  item.smrArray = itemModer.transform:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
  if not item.smrArray then
    return
  end
  for j = 0, item.smrArray.Length - 1 do
    local smr = item.smrArray[j]
    local mats = smr.materials
    for k = 0, mats.Length - 1 do
      local mat = mats[k]
      local defaultNumber = {}
      if mat:HasProperty("_Cull") then
        defaultNumber._Cull = mat:GetFloat("_Cull")
        mat:SetFloat("_Cull", 0)
      end
      if mat:HasProperty("_SrcBlend") then
        defaultNumber._SrcBlend = mat:GetFloat("_SrcBlend")
        mat:SetFloat("_SrcBlend", 5)
      end
      if mat:HasProperty("_DstBlend") then
        defaultNumber._DstBlend = mat:GetFloat("_DstBlend")
        mat:SetFloat("_DstBlend", 10)
      end
      if mat:HasProperty("_Color") then
        defaultNumber.color = mat.color
      end
      table.insert(item.matArray, mat)
      table.insert(item.defaultMat, defaultNumber)
    end
  end
  item.count = tonumber(time / 0.1)
  item.fadeOutTimer = Timer.StartLoop(0.1, item.count, function()
    for k, v in pairs(item.matArray) do
      if v:HasProperty("_Color") then
        local color = v.color
        color.a = color.a - 1 / item.count
        v.color = color
      end
    end
  end)
  item.recoverTimeHandle = Timer.StartLoop(recoverTime, 1, function()
    ItemUtility.RecoverModer(item)
  end)
end

function ItemUtility.RecoverModer(item)
  for k, v in pairs(item.matArray) do
    if v:HasProperty("_Cull") then
      v:SetFloat("_Cull", item.defaultMat[k]._Cull)
    end
    if v:HasProperty("_SrcBlend") then
      v:SetFloat("_SrcBlend", item.defaultMat[k]._SrcBlend)
    end
    if v:HasProperty("_DstBlend") then
      v:SetFloat("_DstBlend", item.defaultMat[k]._DstBlend)
    end
    if v:HasProperty("_Color") then
      v.color = item.defaultMat[k].color
    end
    if item.fadeOutTimer then
      Timer.Stop(item.fadeOutTimer)
      item.fadeOutTimer = nil
    end
    if item.recoverTimeHandle then
      Timer.Stop(item.recoverTimeHandle)
      item.recoverTimeHandle = nil
    end
  end
  item.matArray = {}
  item.defaultMat = {}
end

function ItemUtility.FadeIn(item, itemModer, time, recoverTime)
  item.matArray = {}
  item.defaultMat = {}
  if not itemModer then
    return
  end
  item.smrArray = itemModer.transform:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
  if not item.smrArray then
    return
  end
  for j = 0, item.smrArray.Length - 1 do
    local smr = item.smrArray[j]
    local mats = smr.materials
    for k = 0, mats.Length - 1 do
      local mat = mats[k]
      local defaultNumber = {}
      defaultNumber._Cull = mat:GetFloat("_Cull")
      defaultNumber._SrcBlend = mat:GetFloat("_SrcBlend")
      defaultNumber._DstBlend = mat:GetFloat("_DstBlend")
      defaultNumber.color = mat.color
      local color = mat.color
      color.a = 0
      if mat:HasProperty("_Color") then
        mat.color = color
      end
      if mat:HasProperty("_Cull") then
        mat:SetFloat("_Cull", 0)
      end
      if mat:HasProperty("_SrcBlend") then
        mat:SetFloat("_SrcBlend", 5)
      end
      if mat:HasProperty("_DstBlend") then
        mat:SetFloat("_DstBlend", 10)
      end
      table.insert(item.matArray, mat)
      table.insert(item.defaultMat, defaultNumber)
    end
  end
  item.count = tonumber(time / 0.1)
  item.fadeOutTimer = Timer.StartLoop(0.1, item.count, function()
    for K, v in pairs(item.matArray) do
      if v:HasProperty("_Color") then
        local color = v.color
        color.a = color.a + 1 / item.count
        v.color = color
      end
    end
  end)
  item.recoverTimeHandle = Timer.StartLoop(recoverTime, 1, function()
    ItemUtility.RecoverModer(item)
  end)
end

function ItemUtility.ShowModel(itemCtr, itemCellData, ui, _Stencil, _maskType, callback)
  local itemData = itemCellData.itemData
  local path = ResourceConfig.GetUIPathByItemData(itemData)
  if itemCellData.model and itemCellData.model.Path ~= path then
    itemCellData:RecycleRes()
  end
  if itemData.tblItem.subType == EItemSubtype.EffectTitle then
    return
  end
  local orderLayer = 500
  if ui then
    orderLayer = ui.root.canvas.sortingOrder
  end
  if not itemCellData.model then
    itemCellData.model = CS.Framework.GameModel(itemCtr.go_model.gameObject, function(go, name)
      SetItem(itemCtr, itemCellData, orderLayer, _Stencil, _maskType)
      if callback and callback.go_model ~= nil then
        callback.go_model(go)
      end
    end)
  end
  if itemCellData.model.modelObject then
    if not itemCellData.isDrag then
      SetItem(itemCtr, itemCellData, orderLayer, _Stencil, _maskType)
    end
  else
    local obj = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_UI, path)
    if obj then
      itemCellData.model:SetModelObj(path, obj)
    else
      itemCellData.model:LoadAsync(path)
      itemCellData.model:SetLayer(UI_LAYER)
    end
  end
end

local function ShowSmeltingIcon(itemCtr, itemCellData)
  if itemCtr.smeltingIcon.transform then
    if not table.isNullOrEmpty(itemCellData.itemData.serverInfo) then
      itemCtr.smeltingIcon:SetActive(itemCellData.itemData.serverInfo.canSmelt)
    else
      itemCtr.smeltingIcon:SetActive(false)
    end
  end
end

local function ShowCount(itemCtr, itemCellData)
  if itemCtr.countCtr.transform then
    local showCount = itemCellData.itemData ~= nil and itemCellData.itemData.tblItem.overlying ~= 1
    local countStr = ""
    if showCount then
      if type(itemCellData.itemData.count) == "number" then
        countStr = (itemCellData.itemData.count == 1 or itemCellData.itemData.count == 0) and "" or MathUtility.TransNumber(itemCellData.itemData.count, 1)
      else
        countStr = itemCellData.itemData.count
      end
    end
    itemCtr.countCtr:SetText(countStr)
    itemCtr.countCtr:SetActive(true)
  end
end

function ItemUtility.ShowName(itemCtr, itemCellData)
  if itemCtr.nameCtr.transform and itemCtr.nameCtr:GetActive() then
    local name = ""
    if itemCellData.customData ~= nil and string.isNullOrEmpty(itemCellData.customData.name) == false then
      name = itemCellData.customData.name
    else
      name = itemCellData.itemData.tblItem.name
      local colorShow = itemCellData.itemData.tblItem.colorShow
      name = string.GetColorText(name, ItemQuality2ColorDic[colorShow])
    end
    itemCtr.nameCtr:SetText(name)
  end
end

local function ShowLevel(itemCtr, itemCellData)
  if itemCtr.levelCtr.transform then
    if itemCellData.itemData.tblItem.type == EItemType.FireGem or itemCellData.itemData.tblItem.type == EItemType.WaterGem or itemCellData.itemData.tblItem.type == EItemType.IceGem or itemCellData.itemData.tblItem.type == EItemType.WindGem then
      local name = string.format("%dA", itemCellData.itemData.tblEquip.equipClass)
      itemCtr.levelCtr:SetText(name)
    else
      itemCtr.levelCtr:SetText("")
    end
  end
end

local function ShowAdditional(itemCtr, itemCellData)
  if itemCtr.additionalCtr.transform then
    if itemCellData.itemData.additional and itemCellData.itemData.additional > 0 then
      itemCtr.additionalCtr:SetActive(true)
      itemCtr.additionalCtr:SetText("+" .. itemCellData.itemData.additional)
    else
      itemCtr.additionalCtr:SetActive(false)
    end
  end
end

local function ShowStrengthen(itemCtr, itemCellData)
  if itemCtr.strengthenCtr.transform then
    if itemCellData.itemData.intensify and itemCellData.itemData.intensify > 0 then
      itemCtr.strengthenCtr:SetActive(true)
      itemCtr.strengthenCtr:SetText("+" .. itemCellData.itemData.intensify)
    else
      itemCtr.strengthenCtr:SetActive(false)
    end
  end
end

function ItemUtility.DoShowSelectImg(itemCtr, itemCellData)
  if itemCtr.selectImageCtr and itemCtr.selectImageCtr.transform then
    if itemCellData.selected or itemCellData.customData ~= nil and itemCellData.customData.selected then
      itemCtr.selectImageCtr:SetActive(true)
    else
      itemCtr.selectImageCtr:SetActive(false)
    end
  end
end

function ItemUtility.ShowSelectImg(dragTbl, itemCellData)
  local itemCtr = dragTbl:GetCtrByCellData(itemCellData)
  if itemCtr then
    ItemUtility.DoShowSelectImg(itemCtr, itemCellData)
  end
end

local function ShowLeftIcon(itemCtr, itemCellData)
  if itemCtr.grid_leftIcon.transform then
    local iconName = ""
    if itemCellData.itemData.tblItem.type == EItemType.Equipe then
      if itemCellData.itemData.isSuit then
        local isJewelry = gameMgr:GetAvatarManager():GetOtherPlayer():GetEquipManager():GetJewelryData():IsJewelryBySubtype(itemCellData.itemData.subType)
        if isJewelry then
          iconName = "ty_ico_excellence_N"
        else
          iconName = "ty_ico_suit_N"
        end
      elseif itemCellData.itemData.tblEquip.excellentNumber ~= "" then
        iconName = "ty_ico_excellence_N"
      end
    end
    if not string.isNullOrEmpty(iconName) then
      itemCtr.ui:SetSprite("Atlas_Common", iconName, itemCtr.grid_leftIcon)
      if not itemCtr.container then
        itemCtr.container = UIContainer(itemCtr.img_star, itemCtr.ui)
      end
      itemCtr.container:SetData(itemCellData.itemData:GetExcellenceCount())
    else
      itemCtr.grid_leftIcon:SetActive(false)
    end
  end
end

local function ShowIsEquiped(itemCtr, itemCellData)
  if itemCtr.img_isEquip.transform then
    if itemCellData.itemData.tblItem.type == EItemType.Equipe then
      local show = itemCellData.itemData:isEquiped()
      itemCtr.img_isEquip:SetActive(show)
    else
      itemCtr.img_isEquip:SetActive(false)
    end
  end
end

local function ShowGrrow(itemCtr, itemCellData)
  if itemCtr.img_grrow.transform then
    if not itemCellData.isShowArrow then
      itemCtr.img_grrow:SetActive(false)
      return
    end
    local iconName = ""
    if itemCellData.itemData ~= nil and itemCellData.itemData.tblItem.type == EItemType.Equipe then
      local state = RoleEquipUtility.CanUpFight(itemCellData.itemData)
      if state == EquipUpState.CanWearUpFight then
        iconName = "ty_bag_green"
      elseif state == EquipUpState.CantWearUpFight then
        iconName = "ty_bag_yellow"
      end
      if itemCellData.itemData.tblItem.subType == 21 then
        local isNeedUse, isStrengthenItem = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():IsNeedUsePopPrompt(itemCellData.itemData.tblItem.id)
        if isNeedUse then
          iconName = "ty_bag_green"
          itemCtr.img_grrow:SetActive(true)
        else
          itemCtr.img_grrow:SetActive(false)
        end
      end
      if itemCtr.img_new and itemCtr.img_new.transform then
        if state == EquipUpState.CantWearUpFight then
          if table.contains(BagInfoData.EquipItemIds, itemCellData.itemData.id) then
            itemCellData.isClicked = false
            itemCellData.isNewGet = true
            for i = 1, table.count(BagInfoData.EquipItemIds) do
              if BagInfoData.EquipItemIds[i] == itemCellData.itemData.id then
                table.remove(BagInfoData.EquipItemIds, i)
                break
              end
            end
          end
          if not itemCellData.isClicked and itemCellData.isNewGet and not itemCtr.img_new:GetActive() then
            itemCtr.img_new:SetActive(true)
          end
        elseif itemCtr.img_new:GetActive() then
          itemCtr.img_new:SetActive(false)
        end
      end
    elseif itemCellData.itemData ~= nil and itemCellData.itemData.tblItem.type == EItemType.Rune then
      return
    end
    if itemCtr.ui then
      itemCtr.ui:SetSprite("Atlas_Common", iconName, itemCtr.img_grrow)
    end
  end
end

function ItemUtility.HideItemCell(itemCtr, itemCellData)
  if itemCellData.model then
    itemCellData:RecycleRes()
  end
  this.HideItemCellUI(itemCtr)
end

function ItemUtility.HideItemCellUI(itemCtr)
  if itemCtr.countCtr and itemCtr.countCtr.transform and itemCtr.countCtr:GetActive() then
    itemCtr.countCtr:SetActive(false)
  end
  if itemCtr.nameCtr and itemCtr.nameCtr.transform and itemCtr.nameCtr:GetActive() then
    itemCtr.nameCtr:SetActive(false)
  end
  if itemCtr.additionalCtr and itemCtr.additionalCtr.transform and itemCtr.additionalCtr:GetActive() then
    itemCtr.additionalCtr:SetActive(false)
  end
  if itemCtr.strengthenCtr and itemCtr.strengthenCtr.transform and itemCtr.strengthenCtr:GetActive() then
    itemCtr.strengthenCtr:SetActive(false)
  end
  if itemCtr.grid_leftIcon and itemCtr.grid_leftIcon.transform and itemCtr.grid_leftIcon:GetActive() then
    itemCtr.grid_leftIcon:SetActive(false)
  end
  if itemCtr.smeltingIcon and itemCtr.smeltingIcon.transform and itemCtr.smeltingIcon:GetActive() then
    itemCtr.smeltingIcon:SetActive(false)
  end
  if itemCtr.selectImageCtr and itemCtr.selectImageCtr.transform and itemCtr.selectImageCtr:GetActive() then
    itemCtr.selectImageCtr:SetActive(false)
  end
  if itemCtr.img_grrow and itemCtr.img_grrow.transform and itemCtr.img_grrow:GetActive() then
    itemCtr.img_grrow:SetActive(false)
  end
  if itemCtr.img_isEquip and itemCtr.img_isEquip.transform and itemCtr.img_isEquip:GetActive() then
    itemCtr.img_isEquip:SetActive(false)
  end
  if itemCtr.img_new and itemCtr.img_new.transform and itemCtr.img_new:GetActive() then
    itemCtr.img_new:SetActive(false)
  end
end

function ItemUtility.ReleaseItemCell(itemCtr, itemCellData)
  itemCellData.itemData = nil
  ItemUtility.ShowItemCell(itemCtr, itemCellData)
end

function ItemUtility.ResetItemCell(itemCtr)
  if itemCtr == nil then
    return
  end
  if itemCtr.itemData then
    itemCtr.itemData = nil
  end
  if itemCtr.itemCellData then
    if itemCtr.itemCellData.itemData then
      itemCtr.itemCellData.itemData = nil
    end
    if itemCtr.itemCellData.customData then
      itemCtr.itemCellData.customData = nil
    end
    if itemCtr.itemCellData.model then
      itemCtr.itemCellData:RecycleRes()
    end
  end
  ItemUtility.HideItemCellUI(itemCtr)
end

function ItemUtility.ShowItemCellByItemId(itemId, itemCount, itemCtr, ui, bindClick, contrast, customClickCallData, _Stencil, _maskType)
  if itemId == nil or type(itemId) ~= "number" then
    return ""
  end
  local itemData = ItemUtility.GenerateItemData(itemId)
  if itemData == nil or itemData.tblItem == nil then
    return ""
  end
  itemData.count = itemCount or 0
  if not itemCtr.itemCellData then
    itemCtr.itemCellData = ItemCellData()
  elseif itemCtr.itemCellData.model then
    itemCtr.itemCellData:RecycleRes()
  end
  itemCtr.itemCellData:RefreshData(itemData, customClickCallData)
  ItemUtility.ShowItemCell(itemCtr, itemCtr.itemCellData, ui, bindClick, contrast, _Stencil, _maskType)
  return itemData.tblItem.name
end

function ItemUtility.ShowItemCell(itemCtr, itemCellData, ui, bindClick, contrast, _Stencil, _maskType, isNeedHideItemEffecet, callback)
  if not itemCtr.inited then
    itemCtr = this.InitItemCell(itemCtr)
  end
  if itemCellData.itemData ~= nil then
    if isNeedHideItemEffecet ~= true then
      ItemUtility.ShowEffect(itemCtr, itemCellData, ui, callback)
    end
    ItemUtility.ShowModel(itemCtr, itemCellData, ui, _Stencil, _maskType, callback)
    ShowCount(itemCtr, itemCellData)
    ItemUtility.ShowName(itemCtr, itemCellData)
    ShowLevel(itemCtr, itemCellData)
    ShowAdditional(itemCtr, itemCellData)
    ShowStrengthen(itemCtr, itemCellData)
    ItemUtility.DoShowSelectImg(itemCtr, itemCellData)
    ShowSmeltingIcon(itemCtr, itemCellData)
    ui = ui or itemCtr.ui
    if ui then
      itemCtr.ui = ui
      ShowLeftIcon(itemCtr, itemCellData)
      ShowGrrow(itemCtr, itemCellData)
    end
    ShowIsEquiped(itemCtr, itemCellData)
    if bindClick then
      itemCtr.itemCellData = itemCellData
      itemCtr.itemData = itemCellData.itemData
      itemCtr.contrast = contrast
      itemCtr:SetOnClick(this, this.ClickItemBtn)
    end
  else
    ItemUtility.HideItemCell(itemCtr, itemCellData)
  end
  return itemCtr
end

function ItemUtility.ShowBossItemBg(itemCtr, itemCellData)
  if itemCtr.transform then
    local iconName = ""
    if itemCellData.itemData.tblItem.type == EItemType.Equipe then
      if itemCellData.itemData.isSuit then
        iconName = "ty_black_60_60_hong"
      else
        iconName = "ty_black_60_60_lv"
      end
    end
    if not string.isNullOrEmpty(iconName) then
      itemCtr.ui:SetSprite("Atlas_Common", iconName, itemCtr)
      if not itemCtr.container then
        itemCtr.container = UIContainer(itemCtr.img_star, itemCtr.ui)
      end
    end
  end
end

function ItemUtility.RefreshShowGrrow(itemCtr, itemCellData)
  if not itemCtr.inited then
    itemCtr = this.InitItemCell(itemCtr)
  end
  ShowGrrow(itemCtr, itemCellData)
end

function ItemUtility.ClickItemBtn(_, control)
  if control.itemCellData ~= nil and control.itemCellData.customData ~= nil and control.itemCellData.customData.clickCallBack ~= nil then
    control.itemCellData.customData.clickCallBack(control.itemCellData, control.itemCellData.customData.clickCallBackParams)
  else
    UIManager.Show(UIID.ItemTipUI, {
      item = control.itemData,
      rightOperate = EItemOperateType.Show,
      ctrl = control,
      contrast = control.contrast
    })
  end
end

function ItemUtility.ClickObtainItemBtn(_, control)
  UIManager.Show(UIID.ItemTipUI, {
    item = control.itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control,
    ShowObtain = true,
    BusinessPay = control.BusinessPay,
    OpenWay = control.OpenTipsType,
    countDownTime = control.countDownTime
  })
end

function ItemUtility.TwoHandedArmsJudge(subtype)
  if subtype == EItemSubtype.TwoHandedSword or subtype == EItemSubtype.TwoHandedAxe or subtype == EItemSubtype.TwoHandedStick or subtype == EItemSubtype.Spear then
    return true
  end
  return false
end

function ItemUtility.IsEquipType(type)
  if type == EItemType.Equipe or type >= EItemType.FireGem and type <= EItemType.SoilGem then
    return true
  end
  if type == EItemType.NewRune then
    return true
  end
  return false
end

function ItemUtility.IsFakeEquipType(type)
  if type >= EItemType.FireGem and type <= EItemType.SoilGem then
    return true
  end
  return false
end

function ItemUtility.IsJewelry(itemInfo)
  if itemInfo.tblItem.subType == EItemSubtype.Ring or itemInfo.tblItem.subType == EItemSubtype.Necklace or itemInfo.tblItem.subType == EItemSubtype.Earrings then
    local cellIndex = tonumber(string.split(itemInfo.tblEquip.equipPosition, "#")[1])
    if RoleEquipUtility.EquipTypeUtility(cellIndex, ERoleEquipCondition.Normal) then
      return true
    end
  end
  return false
end

function ItemUtility.IsBasicArmor(subType)
  if subType == EItemSubtype.Helmet or subType == EItemSubtype.BreastPlate or subType == EItemSubtype.ShinGuards or subType == EItemSubtype.HandGuards or subType == EItemSubtype.Shoes then
    return true
  end
  return false
end

function ItemUtility.IsArms(subType)
  if subType >= EItemSubtype.OneHandedSword and subType <= EItemSubtype.Katar then
    return true
  end
  return false
end

function ItemUtility.IsBlessArchangelEquip(itemInfo)
  if itemInfo.tblEquip then
    local bagIndex = string.split(itemInfo.tblEquip.equipPosition, "#")[1]
    if RoleEquipUtility.EquipTypeUtility(tonumber(bagIndex), ERoleEquipCondition.BlessArchangel) then
      return true
    end
  end
  return false
end

function ItemUtility.IsRuneType(type)
  if type == 19 then
    return true
  end
  return false
end

function ItemUtility.SetIconGray(itemCtr, isGray)
  itemCtr.iconCtr.image.color = isGray and Color.black or Color.white
end

function ItemUtility.SetIconRed(itemCtr, isGray)
  itemCtr.iconCtr.image.color = Color.red
end

function ItemUtility.GenerateItemData(param)
  if param == nil then
    return nil
  end
  if type(param) == "number" then
    param = ClientTable.cfg_Item_itemManager:TryGetValue(param)
  end
  local result
  if ItemUtility.IsEquipType(param.type) then
    result = EquipData()
    result.itemId = param.id
    result.bind = param.bind
    result:SetEquipItemData()
    if param.subType == EItemSubtype.Wing then
      local wingAttributeTbl = {}
      local tbl = ClientTable.cfg_Item_equip_wingAttributeManager:GetDic()
      for _, v in pairs(tbl) do
        if v.id ~= param.id or v.type == 1 then
        elseif v.type == 2 then
        elseif v.type == 3 then
          wingAttributeTbl.damageBonus = v.fixedValue
        elseif v.type == 4 then
          wingAttributeTbl.damageAbsorption = v.fixedValue
        end
      end
      result:DoWingGenerateAttr(wingAttributeTbl)
      local excellenceIds = ParseUtility.ParseId(result.tblEquip.createFixedExcellent)
      result:SetWing(excellenceIds)
    elseif result.tblEquip.createFixedExcellent ~= "" then
      result.excellence = ParseUtility.ParseId(result.tblEquip.createFixedExcellent)
    end
  else
    result = ItemData()
    result.itemId = param.id
    result.tblItem = ClientTable.cfg_Item_itemManager:TryGetValue(param.id)
    result.bind = result.tblItem.bind
  end
  return result
end

function ItemUtility.GenerateServerItemInfo(param)
  local itemId = param
  if type(param) == "number" then
    param = ClientTable.cfg_Item_itemManager:TryGetValue(param)
  end
  local result = {}
  result.itemId = param.id
  result.count = 1
  if param.type == EItemType.Equipe or ItemUtility.IsFakeEquipType(param.type) then
    param = ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
    local equipPos = string.split(param.equipPosition, "#")
    result.bagGridIndex = tonumber(equipPos[1])
    result.intensify = 0
  else
    result.bagGridIndex = 1
  end
  return result
end

function ItemUtility.GenerateItemDataByServerData(itemInfo)
  local cfgItem = ClientTable.cfg_Item_itemManager:TryGetValue(itemInfo.itemId)
  local item
  if ItemUtility.IsEquipType(cfgItem.type) then
    item = EquipData(itemInfo)
  else
    item = ItemData(itemInfo)
  end
  return item
end

function ItemUtility.GenerateItemDataByServerData_serverInfo(itemInfo, isServerData)
  local cfgItem = ClientTable.cfg_Item_itemManager:TryGetValue(itemInfo.itemId)
  local item
  local serverData = isServerData and itemInfo or itemInfo.serverInfo
  if ItemUtility.IsEquipType(cfgItem.type) then
    item = EquipData(serverData)
  else
    item = ItemData(serverData)
  end
  return item
end

function ItemUtility.GetItemByTypeAndSubType(type, subType)
  local cfg_item = ClientTable.cfg_Item_itemManager:GetDic()
  local itemList = {}
  for k, v in pairs(cfg_item) do
    if v.type == type and v.subType == subType then
      table.insert(itemList, v)
    end
  end
  return itemList
end

function ItemUtility.GetEquipeLuckIds(isLuck)
  return isLuck and {10001, 10002} or {}
end

function ItemUtility.UseItem(useItemTab)
  MeController.UpdateClientItemCd(useItemTab.configId)
  local isClientDeal = false
  local params = {}
  if useItemTab.useParam then
    params = string.split(useItemTab.useParam, "#")
    if tonumber(params[1]) == ItemUseType.OpenUI or tonumber(params[1]) == ItemUseType.FindNpc or tonumber(params[1]) == ItemUseType.Navigation or tonumber(params[1]) == ItemUseType.DoubleTip or tonumber(params[1]) == ItemUseType.UseBatchBox then
      isClientDeal = true
    end
  end
  if isClientDeal then
    UIManager.Hide(UIID.ItemTipUI)
    if tonumber(params[1]) == ItemUseType.OpenUI then
      local uiLogicTbl = ClientTable.cfg_Ui_logicManager:TryGetValue(tonumber(params[2]), "id")
      local argsStr = string.split(useItemTab.useParamExtend, "=")
      local args
      if table.count(argsStr) > 0 then
        if argsStr[1] == "itemID" then
          args = {
            count = useItemTab.useCount,
            itemId = useItemTab.useItemId
          }
        else
          args = {
            [argsStr[1]] = argsStr[2]
          }
        end
      end
      if uiLogicTbl.mainUI ~= nil and uiLogicTbl.mainUI == "Tip_BagItemTipsUI" then
        UIManager.Show(UIID.BagItemTipsUI)
      elseif uiLogicTbl.mainUI ~= nil and uiLogicTbl.mainUI == "Equip_HolySpiritRightUI" then
        local transCondition = useItemTab.itemInfo.tblItem.transCondition
        if transCondition then
          if not ConditionManager.Check(transCondition) then
            FloatingWordUtility.QuickMsg("T\195\173nh n\196\131ng ch\198\176a m\225\187\159")
            return
          else
            UIManager.JumpShow(UIPanelType.SortAndHide, uiLogicTbl.mainUI, args)
          end
        end
      elseif uiLogicTbl.mainUI ~= nil and uiLogicTbl.mainUI == "Activity_WarAllianceRedBagUI" then
        if WarAllianceData.IsHaveUnion == false then
          FloatingTipUtility.QuickMsg("Ch\198\176a gia nh\225\186\173p Guild, h\195\163y gia nh\225\186\173p Guild tr\198\176\225\187\155c")
          return
        else
          UIManager.JumpShow(UIPanelType.SortAndHide, uiLogicTbl.mainUI, args)
        end
      elseif uiLogicTbl.mainUI ~= nil and uiLogicTbl.mainUI == "Activity_SeaChestUI" then
        local condition = ConditionManager.Check4D(useItemTab.itemInfo.tblItem.transCondition)
        if condition then
          args = {
            count = useItemTab.itemInfo.count,
            itemId = useItemTab.configId
          }
          UIManager.JumpShow(UIPanelType.SortAndHide, uiLogicTbl.mainUI, args)
        else
          local datatip = ClientTable.cfg_Ui_wordManager:TryGetValue("SeaChestLevelTips")
          if datatip and datatip.content then
            FloatingTipUtility.QuickMsg(datatip.content)
          end
        end
      elseif uiLogicTbl.mainUI ~= nil and uiLogicTbl.id >= 14515 and uiLogicTbl.id <= 14518 then
        local condition = ConditionManager.Check4D(useItemTab.itemInfo.tblItem.transCondition)
        if condition then
          args = {
            uiID = uiLogicTbl.mainUI
          }
          UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Enchant_NavUI, args)
        end
      else
        UIManager.JumpShow(UIPanelType.SortAndHide, uiLogicTbl.mainUI, args)
      end
    elseif tonumber(params[1]) == ItemUseType.FindNpc and 1 < table.count(params) then
      UIManager.UICloseType(UIPanelType.SortAndHide, true)
      local transferId = tonumber(params[2])
      local npcId = 2 < table.count(params) and tonumber(params[3]) or nil
      local promptId = table.count(params) > 3 and tonumber(params[4]) or nil
      local promptTbl
      if promptId then
        promptTbl = ClientTable.cfg_Ui_promptwordManager:TryGetValue(promptId)
      end
      if promptTbl then
        TipUtility.QuickShowPrompt({
          id = promptId,
          okArgs = {
            transferId = transferId,
            npcId = npcId,
            itemId = useItemTab.configId
          }
        })
      else
        PathFinderManager.FlyTransferScene(transferId, nil, {
          npcId = npcId,
          itemId = useItemTab.configId
        }, npcId ~= nil and npcId ~= 0 and Purpose.ClickNpc or Purpose.None)
      end
    elseif tonumber(params[1]) == ItemUseType.UseBatchBox then
      UIManager.Show(UIID.Item_ChooseBoxUI, {
        boxId = tonumber(params[2]),
        itemInfo = useItemTab.itemInfo
      })
    elseif tonumber(params[1]) == ItemUseType.UseSkill then
      UIManager.Show(UIID.Item_ChooseBoxUI, {
        boxId = tonumber(params[2]),
        itemInfo = useItemTab.itemInfo
      })
    elseif tonumber(params[1]) == ItemUseType.Navigation then
      local navTbl = ClientTable.cfg_Navigation_barManager:TryGetValue(tonumber(params[2]))
      if navTbl then
        NavigationUtility.OpenPanel(navTbl)
      end
    elseif tonumber(params[1]) == ItemUseType.DoubleTip and 1 < table.count(params) then
      local transferId = tonumber(params[2])
      local npcId = 2 < table.count(params) and tonumber(params[3]) or nil
      local promptId = table.count(params) > 3 and tonumber(params[4]) or nil
      local promptId_2 = table.count(params) > 4 and tonumber(params[5]) or nil
      local _listenEventID
      local IsNeedShowTipBossCount = ClientTable.cfg_Global_globalManager:IsNeedShowTipBossCount(useItemTab.configId)
      local _refreshCallBack
      if IsNeedShowTipBossCount then
        function _refreshCallBack()
          networkRequest.ReqGetRingBossCount(transferId, 1)
        end
        
        _listenEventID = Event.RefreshRingBossCountData
      end
      UIManager.UICloseType(UIPanelType.SortAndHide, true)
      
      local function callback()
        TipUtility.QuickShowPrompt({
          id = promptId_2,
          okArgs = {
            transferId = transferId,
            npcId = npcId,
            itemId = useItemTab.configId
          }
        })
      end
      
      TipUtility.QuickShowPrompt({
        id = promptId,
        okAction = callback,
        autoClose = true,
        listenEventID = _listenEventID,
        refreshCallBack = _refreshCallBack,
        itemId = useItemTab.configId
      })
    end
  else
    if ItemUtility.SpecialDeal(useItemTab.configId, tonumber(params[1]), tonumber(params[2])) then
      return
    end
    if useItemTab.configId == 20000022 then
      local mapTab = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId, "id")
      if mapTab.flyScroll ~= 0 then
        FloatingWordUtility.QuickMsg("B\225\186\163n \196\145\225\187\147 hi\225\187\135n t\225\186\161i kh\195\180ng th\225\187\131 d\195\185ng")
        return
      end
    end
    if useItemTab.itemInfo and useItemTab.itemInfo.tblItem.subType == EItemSubtype.Guards then
      UIManager.JumpShow(UIPanelType.SortAndHide, UIID.AppearBagInfoUI, {togIndex = 4})
    end
    BagInfoController.UseItemReq(useItemTab.useCount, useItemTab.useItemId, useItemTab.params, useItemTab.configId)
  end
end

function ItemUtility.SpecialDeal(itemId, paramsType, params)
  local str = ""
  local flag = false
  if itemId == SpecialItemIDEnum.BagStone then
    if BagInfoData.curBagCellCount == BagInfoData.bagCellCount then
      str = "Kh\195\180ng th\225\187\131 m\225\187\159 r\225\187\153ng th\195\170m T\195\186i"
      flag = true
    end
  elseif itemId == SpecialItemIDEnum.StoreHouseStone then
    if BagInfoData.storageCount == BagInfoData.curStorageCount then
      str = "Kh\195\180ng th\225\187\131 m\225\187\159 r\225\187\153ng th\195\170m Kho"
      flag = true
    end
  elseif paramsType == ItemUseType.UseSkill then
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(params)
    local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
    if not ConditionalMgr:CanReleaseSkillShowTips(tblSkill, tblaction) then
      flag = true
    end
  end
  if not string.isNullOrEmpty(str) then
    FloatingWordUtility.QuickMsg(str)
  end
  return flag
end

function ItemUtility.UseRoleSkill(item, levelup)
  if item.id == TipData.UpExpPropid then
    return false
  end
  local itemdata = ClientTable.cfg_Item_itemManager:TryGetValue(item.itemId)
  local fastUse = itemdata.fastUse
  if not string.isNullOrEmpty(fastUse) then
    local fastuseCond = string.split(fastUse, "&")
    local ConditionGrop = string.split(fastuseCond[2], "#")
    local MyLevel = RoleManager.me.level
    if not (MyLevel >= tonumber(ConditionGrop[1])) or not (MyLevel <= tonumber(ConditionGrop[2])) then
      return false
    end
    local Condition = string.split(fastuseCond[1], "#")
    local params = string.split(itemdata.useParam, "#")
    item.Condition = Condition
    item.params = params
    if tonumber(Condition[1]) == TipFastUse.Normal then
      if tonumber(Condition[2]) > 0 then
        if params[1] == "1" then
          local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(tonumber(params[2]))
          if not cfg_skill then
            logError("Kh\195\180ng c\195\179 ID k\225\187\185 n\196\131ng trong cfg_Skill_skill", params[2])
            return false
          end
          if RoleManager.me.skills[cfg_skill.groupId] and RoleManager.me.skills[cfg_skill.groupId].sid == tonumber(params[2]) then
            local level = RoleManager.me.skills[cfg_skill.groupId].level
            if level < item.level then
              TipData.PopUpData(TipShowSort.use, item)
              return item
            end
          elseif cfg_skill.level <= 1 then
            TipData.PopUpData(TipShowSort.use, item)
            return item
          end
        else
          TipData.PopUpData(TipShowSort.use, item)
          return item
        end
      else
        if levelup then
          TipData.PopUpData(TipShowSort.auction, item)
        end
        return item, true
      end
    elseif tonumber(Condition[1]) == TipFastUse.Other then
      local Global = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(tonumber(Condition[3]))
      local level = RoleManager.me.level
      local Grop = string.split(Global, "&")
      for i, v in pairs(Grop) do
        local Cond = string.split(v, "#")
        if level >= tonumber(Cond[1]) and level <= tonumber(Cond[2]) and BagInfoData.GetItemCountByItemConfigId(itemdata.id) >= tonumber(Cond[3]) then
          item.usecount = tonumber(Cond[3])
          if tonumber(Condition[2]) > 0 then
            TipData.PopUpData(TipShowSort.use, item)
            return item
          else
            TipData.PopUpData(TipShowSort.auction, item)
            return item, true
          end
        end
      end
    end
  end
  return false
end

function ItemUtility.UseRoleSkillII(item, levelup)
  if item.id == TipData.UpExpPropid then
    return false
  end
  local itemdata = ClientTable.cfg_Item_itemManager:TryGetValue(item.itemId)
  local fastUse = itemdata.fastUse
  if not string.isNullOrEmpty(fastUse) then
    local fastuseCond = string.split(fastUse, "&")
    local ConditionGrop = string.split(fastuseCond[2], "#")
    local MyLevel = RoleManager.me.level
    if not (MyLevel >= tonumber(ConditionGrop[1])) or not (MyLevel <= tonumber(ConditionGrop[2])) then
      return false
    end
    local Condition = string.split(fastuseCond[1], "#")
    local params = string.split(itemdata.useParam, "#")
    item.Condition = Condition
    item.params = params
    if tonumber(Condition[1]) == TipFastUse.Normal then
      if tonumber(Condition[2]) > 0 then
        if params[1] == "1" then
          local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(tonumber(params[2]))
          if not cfg_skill then
            logError("Kh\195\180ng c\195\179 ID k\225\187\185 n\196\131ng trong cfg_Skill_skill", params[2])
            return false
          end
          if RoleManager.me.skills[cfg_skill.groupId] and RoleManager.me.skills[cfg_skill.groupId].sid == tonumber(params[2]) then
            local level = RoleManager.me.skills[cfg_skill.groupId].level
            if level < item.level then
              return item
            end
          elseif cfg_skill.level <= 1 then
            return item
          end
        else
          return item
        end
      else
        if levelup then
          if item and item.itemId == 3003001 then
            if QuickFind.MasterDataMgr() then
              local exChangeInfo = QuickFind.MasterDataMgr():GetExChangeInfo()
              local todaySurplusExchangeCount = exChangeInfo and exChangeInfo.value or 1
              if todaySurplusExchangeCount <= 0 then
                return item, true
              else
                TipData.PopUpData(TipShowSort.auction, item)
              end
            end
          else
            TipData.PopUpData(TipShowSort.auction, item)
          end
        end
        return item, true
      end
    elseif tonumber(Condition[1]) == TipFastUse.Other then
      local Global = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(tonumber(Condition[3]))
      local level = RoleManager.me.level
      local Grop = string.split(Global, "&")
      for i, v in pairs(Grop) do
        local Cond = string.split(v, "#")
        if level >= tonumber(Cond[1]) and level <= tonumber(Cond[2]) and BagInfoData.GetItemCountByItemConfigId(itemdata.id) >= tonumber(Cond[3]) then
          item.usecount = tonumber(Cond[3])
          if tonumber(Condition[2]) > 0 then
            return item
          else
            TipData.PopUpData(TipShowSort.auction, item)
            return item, true
          end
        end
      end
    end
  end
  return false
end

function ItemUtility.IsCanUseItemCd(itemId)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
  if not itemConfig then
    return
  end
  local id = itemConfig.useCdGroup
  if RoleManager.me.cd[id] then
    return RoleManager.me.cd[id].endTime > Time.GetServerTime()
  else
    return false
  end
end

function ItemUtility.GetItemCd(itemId)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
  if not itemConfig then
    return 0
  end
  local id = itemConfig.useCdGroup
  if RoleManager.me.cd[id] then
    return RoleManager.me.cd[id].endTime
  else
    return 0
  end
end

function ItemUtility.JumpRechargeUIIntercept(type, name, args, BusinessPay, animation)
  local need = false
  if name == UIID.RechargeWelfareUI then
    need = RechargeData:NeedGotoFirstChargeUI(BusinessPay, true)
  end
  if not need then
    local argsTbl = {}
    argsTbl.PayType = BusinessPay
    if name ~= UIID.RechargeWelfareUI then
      argsTbl.type = args.type
    else
      argsTbl.openFirstTab = args.type
      argsTbl.rechargeID = args.buyid
    end
    UIManager.JumpShow(type, name, argsTbl)
  end
end

function ItemUtility.JumpRechargeShopJump(type, name, args, BusinessPay, animation)
  local need = false
  if name == UIID.Shop then
    need = RechargeData:NeedGotoFirstChargeUI(BusinessPay, true)
  end
  if not need then
    UIManager.JumpShow(type, name, args)
  end
end

function ItemUtility.IsJumpRecharge()
  local config = ClientTable.cfg_Function_functionManager:TryGetValue(4010104, "id")
  local istrue = ConditionManager.Check4D(config.condition)
  if istrue or string.isNullOrEmpty(config.condition) then
    return true
  else
    return false
  end
end

function ItemUtility.JumpRechargeOrShop(type, name, args, BusinessPay, animation)
  if ItemUtility.IsJumpRecharge() then
    local argsTbl = {}
    argsTbl.PayType = BusinessPay
    if name ~= UIID.RechargeWelfareUI then
      argsTbl.type = args.type
    else
      argsTbl.openFirstTab = args.type
      argsTbl.rechargeID = args.buyid
    end
    UIManager.JumpShow(type, name, argsTbl)
  else
    UIManager.Show(UIID.Shop, {
      type = 3,
      subtype = 2,
      subPosition = 30202
    })
  end
end

function ItemUtility.ShowEffect(itemCtr, itemCellData, ui, callback)
  local isShowEffect = false
  local effectTblId = 0
  local path = ""
  local effectTbl = {}
  if itemCellData ~= nil and itemCellData.itemData ~= nil and itemCellData.itemData.tblItem ~= nil then
    effectTblId = itemCellData.itemData.tblItem.modelEffect
    if effectTblId ~= " " and not string.isNullOrEmpty(effectTblId) then
      effectTbl = ClientTable.cfg_Item_equip_modeleffectManager:TryGetValue(tonumber(effectTblId))
      if effectTbl then
        isShowEffect = true
        path = ResourceConfig.GetUIEffectPathByItemData(effectTbl.name)
      end
    end
  end
  if itemCellData.effectModelLoader ~= nil then
    if itemCellData.effectModelLoader.Path ~= path then
      itemCellData:RecycleRes()
    else
      return
    end
  end
  if not isShowEffect or string.isNullOrEmpty(path) then
    return
  end
  if itemCellData.effectModelLoader == nil and itemCtr then
    local orderLayer = 500
    if ui then
      orderLayer = ui.root.canvas.sortingOrder
    end
    if itemCtr.go_effectModel then
      itemCellData.effectModelLoader = CS.Framework.GameModel(itemCtr.go_effectModel.gameObject, function(go)
        SetItemEffect(itemCtr, {cellData = itemCellData, effectTbl = effectTbl}, orderLayer)
        if callback and callback.go_effectModel ~= nil then
          callback.go_effectModel(go)
        end
      end)
    else
      itemCellData.effectModelLoader = CS.Framework.GameModel("go_effectModel", itemCtr.transform, function(go)
        SetItemEffect(itemCtr, {cellData = itemCellData, effectTbl = effectTbl}, orderLayer)
        if callback and callback.go_effectModel ~= nil then
          callback.go_effectModel(go)
        end
      end)
    end
  end
  if itemCellData.effectModelLoader then
    local obj = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_UI, path)
    if obj then
      itemCellData.effectModelLoader:SetModelObj(path, obj)
    else
      itemCellData.effectModelLoader:LoadAsync(path)
      itemCellData.effectModelLoader:SetLayer(UI_LAYER)
    end
  end
end

function ItemUtility:SwitchClientShowAttr(attrValue, attrType)
  if type(attrValue) ~= "number" then
    return attrValue
  end
  if type(tonumber(attrValue)) ~= "number" then
    return attrValue
  end
  local attrTemp = 0
  if attrType == EAttributeType.damageAbsorption then
    attrTemp = attrValue and attrValue * 0.01 or 0
    attrTemp = math.floor(attrTemp * 10000) / 10000
    attrTemp = attrTemp * 100
  end
  return attrTemp
end

function ItemUtility:IsSameTypeEquip(equipTbl, compareEquipTbl)
  if equipTbl == nil or compareEquipTbl == nil then
    return false
  end
  local equipType, compareEquipType = RoleEquipUtility.GetEquipType(equipTbl), RoleEquipUtility.GetEquipType(compareEquipTbl)
  if equipType == nil or compareEquipType == nil then
    return false
  end
  return equipType == compareEquipType
end

function ItemUtility:IsMeetCost(data)
  if data == nil then
    return false
  end
  local bagCount
  for i, v in pairs(data) do
    bagCount = BagInfoData.GetItemTotalCountByItemId(v.itemId)
    if bagCount < v.count then
      return false
    end
  end
  return true
end

function ItemUtility:IsEnoughCost(itemId, costNum)
  if itemId == nil or costNum == nil then
    return false
  end
  local bagCount = BagInfoData.GetItemTotalCountByItemId(itemId)
  return costNum <= bagCount
end

function ItemUtility:GetMaxCostNum(itemId, costNum)
  if itemId == nil or costNum == nil then
    return 0
  end
  local bagCount = BagInfoData.GetItemTotalCountByItemId(itemId)
  return math.floor(bagCount / costNum)
end

function ItemUtility.IsHolySpiritEquipType(equipSubType)
  local curHolySoirtType = gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():GetCurHolySpiritType()
  local subTypeTab = HolySpiritPointData.equipTab[curHolySoirtType]
  for suitType, subType in pairs(subTypeTab) do
    if equipSubType == subType then
      return true
    end
  end
  return false
end

function ItemUtility:GetItemDataByOldItem(itemId, oldItemData)
  local itemData = ItemUtility.GenerateItemData(itemId)
  if itemData and oldItemData then
    itemData.excellentInfoTbl = oldItemData.excellentInfoTbl
    itemData.additional = oldItemData.additional
    itemData.intensify = oldItemData.intensify
    itemData.excellenceDesList = oldItemData.excellenceDesList
    itemData.excellentInfoDesIsDirty = oldItemData.excellentInfoDesIsDirty
    itemData.excellentInfoTbl = oldItemData.excellentInfoTbl
  end
  return itemData
end

function ItemUtility.NewSetShaderParamsValue(go_model, paramsValue, maskType)
  if paramsValue == nil then
    paramsValue = 2
  end
  if maskType == nil then
    maskType = 5
  end
  local go = go_model
  if go == nil or go.transform == nil then
    return
  end
  local skinnedMeshArray = go.transform:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
  if skinnedMeshArray.Length <= 0 then
    return
  end
  for i = 0, skinnedMeshArray.Length - 1 do
    local skinnedMesh = skinnedMeshArray[i]
    for j = 0, skinnedMesh.materials.Length - 1 do
      skinnedMesh.materials[j]:SetInt("_Stencil", paramsValue)
      skinnedMesh.materials[j]:SetInt("_StencilComp", maskType)
      skinnedMesh.materials[j]:SetInt("_StencilPass", 0)
    end
  end
end

function ItemUtility.TrySetTipsLayer(layer, order)
  local itemTips = UIManager.GetUiByName(UIID.ItemTipUI)
  if itemTips and itemTips.layer ~= layer then
    if ItemUtility.orginTipsLayer == nil then
      ItemUtility.orginTipsLayer = itemTips.layer
    end
    if ItemUtility.orginTipsOrder == nil then
      ItemUtility.orginTipsOrder = itemTips.orderInLayer
    end
    itemTips:SetLayer(layer or UILayer.Tip)
    itemTips:SetOrderInLayer(order or 0)
  end
end

function ItemUtility.TryReSetTipLayer()
  local itemTips = UIManager.GetUiByName(UIID.ItemTipUI)
  if itemTips and ItemUtility.orginTipsLayer then
    itemTips:SetLayer(ItemUtility.orginTipsLayer)
    ItemUtility.orginTipsLayer = nil
  end
  if itemTips and ItemUtility.orginTipsOrder then
    itemTips:SetOrderInLayer(ItemUtility.orginTipsOrder or 0)
    ItemUtility.orginTipsOrder = nil
  end
end
