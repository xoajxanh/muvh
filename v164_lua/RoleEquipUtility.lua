RoleEquipConstantConfig = {}
RoleEquipConstantConfig.TaoZhuangStrID = StringPool.ToID("taozhuang_liudong")
RoleEquipConstantConfig.DaTianShiStrID = StringPool.ToID("datianshi")
RoleEquipConstantConfig.LiziStrID = StringPool.ToID("_lizi_")
RoleEquipConstantConfig.FuWentrID = StringPool.ToID("_fuwen_")
RoleEquipConstantConfig.CircleStrID = StringPool.ToID("Eff_zhuangbei_tuowei01")
RoleEquipConstantConfig.Circle2StrID = StringPool.ToID("Eff_taozhuang_siseguangquan")
RoleEquipConstantConfig.Circle3StrID = StringPool.ToID("taozhuang_quan")
RoleEquipConstantConfig.MaxShowEffectRoleCount = 5
RoleEquipConstantConfig.RoleWeaponRightParent = "Bip01 R Hand"
RoleEquipConstantConfig.RoleWeaponLeftParent = "Bip01 L Hand"
RoleEquipConstantConfig.RoleShieldLFingerParent = "ShieldLFingerParent"
RoleEquipConstantConfig.RoleWeaponLSpineParent = "WeaponLspineParent"
RoleEquipConstantConfig.RoleWeaponRSpineParent = "WeaponRspineParent"
RoleEquipConstantConfig.RoleWingSpineParent = "WingspineParent"
RoleEquipConstantConfig.RoleShieldspineParent = "ShieldspineParent"
RoleEquipConstantConfig.RolePetSpineParent = "PetspineParent"
RoleEquipConstantConfig.BuffSpineParent = "BuffspineParent"
RoleEquipConstantConfig.BodyspineParent = "BodyspineParent"
RoleEquipConstantConfig.RoleArmbandParent = "Bip01 R Armband"
RoleEquipConstantConfig.RoleCloakParent = "PiFengspineParent"
RoleEquipConstantConfig.RoleAvatarRoot = "Bip01"
RoleEquipConstantConfig.RoleAvatarHead = "Bip01 Head"
RoleEquipConstantConfig.RoleAvatarSpine1 = "Bip01 Spine1"
RoleEquipConstantConfig.RoleAvatarLeftUpperArm = "Bip01 L UpperArm"
RoleEquipConstantConfig.RoleAvatarRightUpperArm = "Bip01 R UpperArm"
RoleEquipConstantConfig.RoleAvatarLeftCalf = "Bip01 L Calf"
RoleEquipConstantConfig.RoleAvatarRightCalf = "Bip01 R Calf"
RoleEquipConstantConfig.RoleAvatarLeftForearm = "Bip01 L Forearm"
RoleEquipConstantConfig.RoleAvatarRightForearm = "Bip01 R Forearm"
RoleEquipConstantConfig.RoleAvatarLeftFoot = "Bip01 L Foot"
RoleEquipConstantConfig.RoleAvatarRightFoot = "Bip01 R Foot"
RoleEquipConstantConfig.RedEquipUpGradeRecordTime = nil
local RoleWeaponParentStringMap = {
  [ERoleEquipPosition.right_weapon] = RoleEquipConstantConfig.RoleWeaponRightParent,
  [ERoleEquipPosition.left_weapon] = RoleEquipConstantConfig.RoleWeaponLeftParent,
  [ERoleEquipPosition.wing] = RoleEquipConstantConfig.RoleWingSpineParent,
  [ERoleEquipPosition.armband] = RoleEquipConstantConfig.RoleArmbandParent
}

local function GetAttachModelParent(pos)
  return RoleWeaponParentStringMap[pos]
end

local weaponSubtype = {
  [1] = "OneHand",
  [2] = "TSword",
  [3] = "Spear",
  [4] = "OneHand",
  [5] = "TSword",
  [6] = "OneHand",
  [7] = "TStaff",
  [9] = "Bow",
  [10] = "Crossbow",
  [11] = "OneHand"
}
local EquipNameByIndex = {
  [-1] = "head",
  [2] = "helm",
  [3] = "wing",
  [4] = "right_weapon",
  [5] = "left_weapon",
  [6] = "armor",
  [7] = "nechushou",
  [8] = "glove",
  [9] = "pant",
  [10] = "boot",
  [11] = "right_ring",
  [12] = "left_ring",
  [16] = "flag",
  [100000] = "shadow",
  [ERoleEquipPosition.cloak] = "cloak"
}
local equipObjPosVector3Table = {
  [1] = {
    pos = Vector3(10, -25, -50),
    rota = Vector3(-70, -90, 0),
    scale = 30
  },
  [7] = {
    pos = Vector3(10, -25, -50),
    rota = Vector3(-70, -90, -90),
    scale = 30
  },
  [8] = {
    pos = Vector3(0, 0, -50),
    rota = Vector3(0, -90, 0),
    scale = 40
  },
  [9] = {
    pos = Vector3(0, -5, -50),
    rota = Vector3(-70, -90, 0),
    scale = 30
  },
  [10] = {
    pos = Vector3(15, -30, -50),
    rota = Vector3(0, 0, -160),
    scale = 40
  },
  [11] = {
    pos = Vector3(0, 0, -50),
    rota = Vector3(0, -90, 0),
    scale = 40
  },
  [12] = {
    pos = Vector3(0, 0, -50),
    rota = Vector3(0, -90, 0),
    scale = 40
  },
  [13] = {
    pos = Vector3(-2, -270, -50),
    rota = Vector3(0, -140, 0),
    scale = 60
  },
  [14] = {
    pos = Vector3(0, -165, -50),
    rota = Vector3(0, -180, 0),
    scale = 50
  },
  [15] = {
    pos = Vector3(-10, -110, -50),
    rota = Vector3(0, -180, 0),
    scale = 50
  },
  [16] = {
    pos = Vector3(-9, -120, -50),
    rota = Vector3(0, -180, 0),
    scale = 50
  },
  [17] = {
    pos = Vector3(0, -25, -80),
    rota = Vector3(0, -180, 0),
    scale = 45
  },
  [18] = {
    pos = Vector3(0, 0, -50),
    rota = Vector3(0, 235, 0),
    scale = 40
  },
  [19] = {
    pos = Vector3(0, 0, -50),
    rota = Vector3(90, 180, 0),
    scale = 40
  },
  [20] = {
    pos = Vector3(0, 0, -80),
    rota = Vector3(0, 0, 0),
    scale = 15
  },
  [21] = {
    pos = Vector3(-12, -10, -50),
    rota = Vector3(0, -90, 0),
    scale = 40
  },
  [22] = {
    pos = Vector3(0, 0, -50),
    rota = Vector3(0, -90, 0),
    scale = 40
  },
  [23] = {
    pos = Vector3(0, -25, -50),
    rota = Vector3(90, -90, 0),
    scale = 30
  },
  [24] = {
    pos = Vector3(0, -25, -50),
    rota = Vector3(-260, -90, 0),
    scale = 30
  },
  [25] = {
    pos = Vector3(0, -25, -50),
    rota = Vector3(-260, -90, 0),
    scale = 30
  },
  [26] = {
    pos = Vector3(0, -25, -50),
    rota = Vector3(0, 0, 0),
    scale = 65
  },
  [29] = {
    pos = Vector3(0, 0, -50),
    rota = Vector3(0, -90, 0),
    scale = 40
  }
}
local equipObj2BodyPos = {
  [1] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [2] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [3] = {
    pos = Vector3(-0.3, 0.1, -0.1),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [4] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [5] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [6] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [7] = {
    pos = Vector3(-0.2, 0.1, 0.1),
    rota = Vector3(3, -7, -108),
    posbody = Vector3(-0.17, -0.1, 0.69),
    rotabody = Vector3(0, 0, 45)
  },
  [8] = {
    pos = Vector3(-0.2, 0, -0.1),
    rota = Vector3(-4, 187, 102),
    posbody = Vector3(0, 0, -0.2),
    rotabody = Vector3(52, 56, 66)
  },
  [9] = {
    pos = Vector3(-0.4, 0.1, -0.28),
    rota = Vector3(11, 4, -99),
    posbody = Vector3(-0.3, 0.3, 1.2),
    rotabody = Vector3(175, -0.4, -48)
  },
  [10] = {
    pos = Vector3(-0.3, 0.13, 0.28),
    rota = Vector3(8, -9, -96),
    posbody = Vector3(-0.1, 0.2, 0.2),
    rotabody = Vector3(130, 76, -104)
  },
  [11] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [12] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [13] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [14] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [15] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [16] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [17] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [18] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [19] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [20] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [21] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [22] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [23] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [24] = {
    pos = Vector3(0.25, -0.4, 1),
    rota = Vector3(-35, -35, 46),
    posbody = Vector3(-0.1, 0, 0.8),
    rotabody = Vector3(0, 0, 45)
  },
  [25] = {
    pos = Vector3(0.25, -0.4, 1),
    rota = Vector3(-35, -35, 46),
    posbody = Vector3(-0.1, 0, 0.8),
    rotabody = Vector3(0, 0, 45)
  },
  [56] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 0),
    posbody = Vector3(-0.1, 0, 0.8),
    rotabody = Vector3(0, 0, 45)
  },
  [57] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 0),
    posbody = Vector3(-0.1, 0, 0.8),
    rotabody = Vector3(0, 0, 45)
  },
  [101] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [102] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [103] = {
    pos = Vector3(-0.3, 0.1, -0.1),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [104] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [105] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [106] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [107] = {
    pos = Vector3(-0.2, 0.1, 0.1),
    rota = Vector3(3, -7, -108),
    posbody = Vector3(-0.17, -0.1, 0.69),
    rotabody = Vector3(0, 0, 45)
  },
  [108] = {
    pos = Vector3(-0.2, 0, -0.1),
    rota = Vector3(-4, 187, 102),
    posbody = Vector3(0, 0, -0.2),
    rotabody = Vector3(52, 56, 66)
  },
  [109] = {
    pos = Vector3(-0.4, 0.1, -0.28),
    rota = Vector3(11, 4, -99),
    posbody = Vector3(-0.3, 0.3, 1.2),
    rotabody = Vector3(175, -0.4, -48)
  },
  [110] = {
    pos = Vector3(-0.3, 0.13, 0.28),
    rota = Vector3(8, -9, -96),
    posbody = Vector3(-0.1, 0.2, 0.2),
    rotabody = Vector3(130, 76, -104)
  },
  [111] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [112] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [113] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [114] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [115] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [116] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [117] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [118] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [119] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [120] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [121] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [122] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [123] = {
    pos = Vector3(0, 0, 0),
    rota = Vector3(0, 0, 45),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [124] = {
    pos = Vector3(0.25, -0.4, 1),
    rota = Vector3(-35, -35, 46),
    posbody = Vector3(-0.1, 0, 0.8),
    rotabody = Vector3(0, 0, 45)
  },
  [125] = {
    pos = Vector3(0.25, -0.4, 1),
    rota = Vector3(-35, -35, 46),
    posbody = Vector3(-0.1, 0, 0.8),
    rotabody = Vector3(0, 0, 45)
  },
  [181] = {
    pos = Vector3(-0.2, 0, -0.1),
    rota = Vector3(-4, 187, 102),
    posbody = Vector3(0, 0, -0.2),
    rotabody = Vector3(52, 56, 66)
  },
  [131] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [132] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [136] = {
    pos = Vector3(-0.3, 0, 0),
    rota = Vector3(0, 0, -100),
    posbody = Vector3(0, 0, 0),
    rotabody = Vector3(0, 0, 45)
  },
  [138] = {
    pos = Vector3(-0.2, 0, -0.1),
    rota = Vector3(-4, 187, 102),
    posbody = Vector3(0, 0, -0.2),
    rotabody = Vector3(52, 56, 66)
  },
  [139] = {
    pos = Vector3(-0.4, 0.1, -0.28),
    rota = Vector3(11, 4, -99),
    posbody = Vector3(-0.3, 0.3, 1.2),
    rotabody = Vector3(175, -0.4, -48)
  },
  [140] = {
    pos = Vector3(-0.3, 0.13, 0.28),
    rota = Vector3(8, -9, -96),
    posbody = Vector3(-0.1, 0.2, 0.2),
    rotabody = Vector3(130, 76, -104)
  },
  [154] = {
    pos = Vector3(0.25, -0.4, 1),
    rota = Vector3(-35, -35, 46),
    posbody = Vector3(-0.1, 0, 0.8),
    rotabody = Vector3(0, 0, 45)
  },
  [155] = {
    pos = Vector3(0.25, -0.4, 1),
    rota = Vector3(-35, -35, 46),
    posbody = Vector3(-0.1, 0, 0.8),
    rotabody = Vector3(0, 0, 45)
  }
}
local equipUIObj2ItemIDPos = {
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
  [2130010] = {
    pos = Vector3(-2, -260, -50),
    rota = Vector3(0, -140, 0),
    scale = 60
  },
  [2130011] = {
    pos = Vector3(-2, -260, -50),
    rota = Vector3(0, -140, 0),
    scale = 60
  },
  [2130100] = {
    pos = Vector3(0, -330, -50),
    rota = Vector3(0, -140, 0),
    scale = 80
  },
  [2130101] = {
    pos = Vector3(0, -330, -50),
    rota = Vector3(0, -140, 0),
    scale = 80
  },
  [2130020] = {
    pos = Vector3(-2, -240, -50),
    rota = Vector3(0, -140, 0),
    scale = 60
  },
  [2130021] = {
    pos = Vector3(-2, -240, -50),
    rota = Vector3(0, -140, 0),
    scale = 60
  }
}
local CareerInModel = {
  [11] = 100513,
  [12] = 100515,
  [13] = 100514,
  [14] = 111004,
  [16] = 500241
}

local function GetEquipObjPosandScale(index, itemId)
  if equipUIObj2ItemIDPos[itemId] then
    return equipUIObj2ItemIDPos[itemId]
  end
  if 1 <= index and index <= 6 or index == 11 then
    index = 1
  end
  return equipObjPosVector3Table[index]
end

local function GetEquipNameByIndex(index)
  local tempPosition = index
  if tonumber(index) and tonumber(index) > 0 then
    local cellTab = ClientTable.cfg_EquipCell_cellManager:TryGetValue(tempPosition, "index")
    if cellTab and RoleEquipUtility.IsAppearByCellType(cellTab.cellType) then
      tempPosition = tempPosition % 100
    end
  end
  local name = EquipNameByIndex[tempPosition] or tempPosition
  if type(name) == "number" then
    logError("function GetEquipNameByIndex returns error type!Got number but string expected!,name:", name)
    return nil
  end
  return name
end

local function GetEquipIndexByName(strindex)
  for k, v in pairs(EquipNameByIndex) do
    if v == strindex then
      return k
    end
  end
end

local function GetWeaponSubtype(index)
  return weaponSubtype[index]
end

local function GetEquipModelName(EquipData)
  local equipItem = EquipData.tblEquip
  local item = EquipData.tblItem
  if not item or not equipItem then
    return nil
  end
  return string.format("%s/%s", equipItem.route, item.model), equipItem.subType
end

local function GetEquipUIModelName(EquipData)
  local equipItem = EquipData.tblEquip
  local item = EquipData.tblItem
  if not item or not equipItem then
    return nil
  end
  local modelName = item.model
  local equipTab = ClientTable.cfg_Item_equipManager:TryGetValue(EquipData.itemId)
  if equipTab and equipTab.uiEquip == 1 then
    modelName = modelName .. "_ui"
  end
  if item.type == EItemType.Equipe then
    local cellIndex = tonumber(string.split(EquipData.tblEquip.equipPosition, "#")[1])
    if RoleEquipUtility.EquipTypeUtility(cellIndex, ERoleEquipCondition.Normal) and (item.subType == EItemSubtype.Ring or item.subType == EItemSubtype.Earrings or item.subType == EItemSubtype.Necklace) then
      local breachTable = MeEquipController.GetEquipBreachCfg(item.subType, EquipData.breach)
      if breachTable and not string.isNullOrEmpty(breachTable.model) and breachTable.model ~= modelName then
        modelName = breachTable.model
        return string.format("%s/%s", equipItem.route, modelName), equipItem.subtype
      end
    end
  end
  return string.format("%s/%s", equipItem.route, modelName), equipItem.subtype
end

local function EquipModelRotation(modelObj, spinAxis, speed)
  if IsNil(modelObj) then
    return
  end
  speed = speed or 5
  local X = modelObj.transform.localEulerAngles.x
  local Y = modelObj.transform.localEulerAngles.y
  local Z = modelObj.transform.localEulerAngles.z
  if spinAxis == 1 then
    modelObj.transform.localEulerAngles = Vector3.Lerp(Vector3(X, Y, Z), Vector3(X + speed, Y, Z), 1)
  elseif spinAxis == 2 then
    modelObj.transform.localEulerAngles = Vector3.Lerp(Vector3(X, Y, Z), Vector3(X, Y, Z + speed), 1)
  else
    modelObj.transform.localEulerAngles = Vector3.Lerp(Vector3(X, Y, Z), Vector3(X, Y + speed, Z), 1)
  end
end

local integerAttribute = {
  "minimumPhysBaseDmg",
  "maximumPhysBaseDmg",
  "attackSpeed",
  "durability",
  "defenseBase",
  "maximumHealth",
  "reducedFixedHealthPerSuccessfulAttack",
  "attackDistanceIncrease",
  "minimumWizBaseDmg",
  "maximumWizBaseDmg",
  "skillDamageBonus",
  "maximumShield",
  "shieldRecoveryAbsolute",
  "vitality",
  "criticalDamageBonus",
  "excellentDamageBonus",
  "client_physAndWizBaseDmgMax",
  "client_physAndWizBaseDmgMin",
  "client_physAndWizBaseDmg",
  "fight",
  "manaAfterMonsterKillAbsolute",
  "healthAfterMonsterKillAbsolute"
}
local percentageAttribute = {
  "minimumWizBaseDmg_mul",
  "maximumWizBaseDmg_mul",
  "petAttackDamageIncrease",
  "defenseRatePvm",
  "attackDamageIncrease",
  "damageReceiveDecrement",
  "iceResistance",
  "fireResistance",
  "waterResistance",
  "earthResistance",
  "windResistance",
  "poisonResistance",
  "lightningResistance",
  "defenseIgnoreChanceResistance",
  "shieldBypassChanceResistance",
  "doubleDamageChanceResistance",
  "excellentDamageChanceResistance",
  "criticalDamageBonusResistance",
  "abilityUsageReduction",
  "defenseIncreaseWithEquippedShield",
  "damageReflection",
  "attackRatePvm",
  "healthRecoveryMultiplier",
  "maximumHealth_mul",
  "maximumMana_mul",
  "manaRecoveryMultiplier",
  "excellentDamageChance",
  "criticalDamageChance",
  "doubleDamageChance",
  "defenseIgnoreChance",
  "defenseBase",
  "defenseRatePvm_mul"
}
local thousandDivide = {
  "healthAfterMonsterKillMultiplier",
  "manaAfterMonsterKillMultiplier",
  "client_physAndWizBaseDmgByLevel",
  "physBaseDmgByLevel",
  "wizBaseDmgByLevel"
}

local function GetEquipAtttribute(key, value, subtype)
  local word = AttributeWordUtil.GetUIWord(key, "equipeUI")
  for k, v in pairs(integerAttribute) do
    if key == v and word and value then
      return string.format(word, value)
    end
  end
  for k, v in pairs(percentageAttribute) do
    if key == v and word and value then
      return string.format(word, value / 100, "%")
    end
  end
  for k, v in pairs(thousandDivide) do
    if key == v and word and value then
      return string.format(word, 10000 / value)
    end
  end
end

local function GetEquipStoneCells(EquipData)
  local normalTbl = {}
  local cfg_EquipCell_cell = ClientTable.cfg_EquipCell_cellManager:GetDic()
  for k, v in pairs(cfg_EquipCell_cell) do
    if v.relationPosition == EquipData.bagGridIndex then
      table.insert(normalTbl, v.index)
    end
  end
  return normalTbl
end

local function GetStoneLight(lightTbl, keyid)
  local normalTbl, normalTblKey = {}, {}
  for k, v in pairs(lightTbl) do
    if not normalTbl[v[keyid]] then
      normalTbl[v[keyid]] = {}
      table.insert(normalTblKey, v[keyid])
    end
    local lightItenData = {}
    lightItenData.tbl = v
    table.insert(normalTbl[v[keyid]], lightItenData)
  end
  return normalTbl, normalTblKey
end

local function GetStoneLightIsActivate(stonelightData, StoneData)
  local isactive = true
  local condition = stonelightData.tbl.condition
  local spli1 = string.split(condition, "&")
  for k, v in pairs(spli1) do
    local split2 = string.split(v, "#")
    local cellId = tonumber(split2[1])
    local stoneType = tonumber(split2[2])
    local level = tonumber(split2[3])
    stonelightData.level = level
    if StoneData[cellId] and StoneData[cellId].valid then
      local tblItem = StoneData[cellId].tblItem
      if tblItem.type ~= stoneType then
        return false
      end
      if level > tblItem.quality then
        return false
      end
    else
      return false
    end
  end
  return isactive
end

local function GetEquipStoneLight(EquipData)
  if not EquipData then
    return
  end
  local type = EquipData.tblItem.type
  local lightTblKey
  local lightTbl = MeEquipController.GetStoneLightConfigDataBySubAndPosition(type, EquipData.itemId)
  lightTbl, lightTblKey = GetStoneLight(lightTbl, "lightId")
  local StoneData = ViewData.meData.equipsData.StoneData
  for k, v in pairs(lightTbl) do
    for kk, vv in pairs(v) do
      vv.isOpen = GetStoneLightIsActivate(vv, StoneData)
    end
  end
  return lightTbl, lightTblKey
end

local function GetStoneAllTypeTbl(StoneData)
  local normaltbl = {}
  for k, v in pairs(StoneData) do
    if v.valid then
      if not normaltbl[v.tblItem.type] then
        normaltbl[v.tblItem.type] = {}
      end
      table.insert(normaltbl[v.tblItem.type], v)
    end
  end
  return normaltbl
end

local function GetSingleConditionIsOk(typeStoneData, level)
  local num = 0
  for k, v in pairs(typeStoneData) do
    if level <= v.tblItem.quality then
      num = num + 1
    end
  end
  return num
end

local function GetStoneCombinIsActivate(stonelightData, StoneData)
  local isactive = true
  local condition = stonelightData.tbl.condition
  if not condition then
    return true
  end
  local spli1 = string.split(condition, "&")
  for k, v in pairs(spli1) do
    local split2 = string.split(v, "#")
    local stoneType = tonumber(split2[1])
    local tblnum = tonumber(split2[2])
    local level = tonumber(split2[3])
    local StoneData = GetStoneAllTypeTbl(StoneData)
    stonelightData.level = level
    if StoneData[stoneType] then
      local dataNum = #StoneData[stoneType]
      if tblnum > dataNum then
        return false
      else
        local ccNum = GetSingleConditionIsOk(StoneData[stoneType], level)
        if tblnum > ccNum then
          return false
        end
      end
    else
      return false
    end
  end
  return isactive
end

local function GetEquipStoneCombination()
  local StoneData = ViewData.meData.equipsData.StoneData
  local cfg = ClientTable.cfg_item_stone_combinationManager:GetDic()
  local lightTbl, lightTblKey = GetStoneLight(cfg, "combinationId")
  for k, v in pairs(lightTbl) do
    for kk, vv in pairs(v) do
      vv.isOpen = GetStoneCombinIsActivate(vv, StoneData)
    end
  end
  return lightTbl, lightTblKey
end

local tblEquipShield = {
  id = true,
  name = true,
  subType = true,
  route = true,
  haveHead = true,
  equipPosition = true
}
local stoneAttribute = {
  minimumPhysBaseDmg = "#N/A",
  minimumWizBaseDmg = "#N/A",
  minimumCurseBaseDmg = "\236\160\128\236\163\188#N/A",
  defenseBase = "Ph\195\178ng th\225\187\167: %d",
  maximumHealth = "T\196\131ng HP: %d"
}

local function GetEquipStoneFirstAttri(equipData)
  local str = ""
  local cfgItem = MeEquipController.GetStoneLightConfigDataBySubAndPosition(equipData.tblItem.type, equipData.itemId)[1]
  if cfgItem.maximumPhysBaseDmg ~= 0 then
    str = string.format(stoneAttribute.minimumPhysBaseDmg, cfgItem.minimumPhysBaseDmg, cfgItem.maximumPhysBaseDmg)
  elseif cfgItem.maximumWizBaseDmg ~= 0 then
    str = string.format(stoneAttribute.minimumWizBaseDmg, cfgItem.minimumWizBaseDmg, cfgItem.maximumWizBaseDmg)
  elseif cfgItem.maximumCurseBaseDmg ~= 0 then
    str = string.format(stoneAttribute.minimumCurseBaseDmg, cfgItem.minimumCurseBaseDmg, cfgItem.maximumCurseBaseDmg)
  elseif cfgItem.defenseBase ~= 0 then
    str = string.format(stoneAttribute.defenseBase, cfgItem.defenseBase)
  elseif cfgItem.maximumHealth ~= 0 then
    str = string.format(stoneAttribute.maximumHealth, cfgItem.maximumHealth)
  end
  return str
end

local WeaponCondition = {
  [EItemSubtype.OneHandedSword] = 1,
  [EItemSubtype.HongZhuang_OneHandedSword] = 1,
  [EItemSubtype.Suit_OneHandedSword] = 1,
  [EItemSubtype.Suit_OneHandedSword_Other] = 1,
  [EItemSubtype.OneHandedAxe] = 1,
  [EItemSubtype.OneHandedStick] = 1,
  [EItemSubtype.RedOneHandedStick] = 1,
  [EItemSubtype.Suit_OneHandedStick] = 1,
  [EItemSubtype.Shield] = 1,
  [EItemSubtype.RedShield] = 1,
  [EItemSubtype.RedmShield] = 1,
  [EItemSubtype.Suit_Shield] = 1,
  [EItemSubtype.Wand] = 1,
  [EItemSubtype.mShield] = 1,
  [EItemSubtype.Couture_right] = 1,
  [EItemSubtype.Couture_left] = 1,
  [EItemSubtype.Couture_OneHandedStick] = 1,
  [EItemSubtype.SummonerRightHandAtk] = 1,
  [EItemSubtype.SummonerRightHandDef] = 1,
  [EItemSubtype.SummonerRightHandAtk_Red] = 1,
  [EItemSubtype.SummonerRightHandDef_Red] = 1,
  [EItemSubtype.TwoHandedSword] = 2,
  [EItemSubtype.Spear] = 2,
  [EItemSubtype.TwoHandedAxe] = 2,
  [EItemSubtype.TwoHandedStick] = 2,
  [EItemSubtype.Arch] = 3,
  [EItemSubtype.Couture_Arch] = 3,
  [EItemSubtype.BowBag] = 3,
  [EItemSubtype.CrossBow] = 3,
  [EItemSubtype.CrossBowBag] = 3,
  [EItemSubtype.Suit_CrossBow] = 3,
  [EItemSubtype.Suit_CrossBowBag] = 3,
  [EItemSubtype.RedArch] = 3,
  [EItemSubtype.RedBowBag] = 3,
  [EItemSubtype.Couture_CrossBow] = 3,
  [EItemSubtype.Couture_BowBag] = 3,
  [EItemSubtype.Suit_Arch] = 3,
  [EItemSubtype.Suit_BowBag] = 3,
  [EItemSubtype.Suit_OneHandedBook] = 1
}
local singleWeapon = {
  EItemSubtype.TwoHandedSword,
  EItemSubtype.TwoHandedAxe,
  EItemSubtype.TwoHandedStick,
  EItemSubtype.Wand
}
local bowAndcrossbow = {
  EItemSubtype.Arch,
  EItemSubtype.CrossBow
}

local function WearWeaponsJudge(position)
  for k, v in pairs(singleWeapon) do
    if position == v then
      return true
    end
  end
  return false
end

local function WearWeaponsCondition(bodySubtype, subtype)
  local putWeaponCondition = WeaponCondition[bodySubtype]
  local bodyCondition = WeaponCondition[subtype]
  return putWeaponCondition == bodyCondition
end

local function GetStoneEquipPos(equipPos, stonePos)
  return equipPos * 100 + stonePos
end

local function GetStoneCellIsOpen(stoneCellIndex, excellentCount)
  return true
end

local ExcellenceTbl = {}

local function GetExcellenceTbl(key)
  if table.count(ExcellenceTbl) <= 0 then
    ExcellenceTbl = ClientTable.cfg_Global_enumManager:TryGetValue(3).effect
  end
  return ExcellenceTbl[key]
end

local ExcellenceToClientShowMap = {}

local function GetExcellenceToClientShowMap(key)
  if table.count(ExcellenceToClientShowMap) <= 0 then
    ExcellenceToClientShowMap = ClientTable.cfg_Global_enumManager:TryGetValue(2).effect
  end
  return ExcellenceToClientShowMap[key]
end

local excellentadditionalTable = {}

local function AddExcellenceAttribute(key, ...)
  local attributeStr = table.insert(excellentadditionalTable, attributeStr)
end

local function GetEquipExcellence(excellence, tblEquip)
  excellentadditionalTable = {}
  local excellenceTbls = EquipAttributeCalculator.GetMultiExcellenceOrLuckAttrMapTable(excellence, tblEquip)
  local excellenceAttr
  if excellenceTbls ~= nil then
    for key, value in pairs(excellenceTbls) do
      for k, v in pairs(value) do
        excellenceAttr = RoleEquipUtility.GetEquipExcellenceStrByTbl({
          attributeKey = k,
          _value = v,
          clientTbl = value
        })
        if excellenceAttr ~= nil and value.excellentWight ~= 0 then
          if value.mark ~= "" then
            table.insert(excellentadditionalTable, 1, excellenceAttr .. ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Newmark_1"))
          else
            table.insert(excellentadditionalTable, excellenceAttr)
          end
        end
      end
    end
  end
  return excellentadditionalTable
end

local function GetEquipExcellenceDesByServerInfo(serverInfo)
  local equipExcellenceList = RoleEquipUtility.GetEquipExcellenceByServerInfo(serverInfo)
  local excellentdesList = {}
  for k, v in pairs(equipExcellenceList) do
    table.insert(excellentdesList, v.des)
  end
  return excellentdesList
end

local function GetEquipExcellenceByServerInfo(serverInfo)
  excellentadditionalTable = {}
  if serverInfo == nil or next(serverInfo) == nil then
    return excellentadditionalTable
  end
  local excellenceAttrDes
  for k, info in pairs(serverInfo) do
    for i, attrInfo in pairs(info.excellentAttribute) do
      excellenceAttrDes = RoleEquipUtility.GetEquipExcellenceStrByTbl({
        attributeKey = attrInfo.attributeName,
        _value = attrInfo.attributeValue,
        isServerInfo = true
      })
      local excellenceAttrInfo = {
        des = excellenceAttrDes,
        id = info.configId,
        serverData = info.excellentAttribute
      }
      if excellenceAttrDes then
        table.insert(excellentadditionalTable, excellenceAttrInfo)
      end
    end
  end
  return excellentadditionalTable
end

local function GetEquipExcellenceStrByTbl(costomData)
  if costomData == nil then
    return nil
  end
  local clientShow = GetExcellenceToClientShowMap(costomData.attributeKey)
  local realAttributeKey = clientShow or costomData.attributeKey
  local calculateType = GetExcellenceTbl(costomData.attributeKey)
  if calculateType == nil then
    return nil
  end
  if costomData._value == nil or costomData._value == 0 or costomData._value == "" then
    return nil
  end
  local excellenceAttr, suffix, minValue
  local isInterval = false
  if calculateType == EquipAttributeCalculateType.Ratio then
    excellenceAttr = math.floor(tonumber(costomData._value) * 0.01)
    suffix = "%"
  elseif calculateType == EquipAttributeCalculateType.LevelFixed then
    excellenceAttr = 1 / tonumber(costomData._value) * 10000
    excellenceAttr = math.floor(excellenceAttr + 0.5)
    suffix = ""
  elseif calculateType == EquipAttributeCalculateType.Constant then
    excellenceAttr = costomData._value
    suffix = ""
  elseif calculateType == EquipAttributeCalculateType.RatioInterval then
    if costomData.isServerInfo == nil or not costomData.isServerInfo then
      minValue = costomData.clientTbl["min_" .. costomData.attributeKey]
      if minValue and minValue ~= "" then
        minValue = math.floor(tonumber(minValue) * 0.01)
      end
    end
    if costomData.isServerInfo then
      excellenceAttr = MathUtility.FormatFloat(costomData._value * 0.01, 1)
    else
      excellenceAttr = math.floor(costomData._value * 0.01)
    end
    suffix = "%"
    isInterval = true
  elseif calculateType == EquipAttributeCalculateType.LevelFixedInterval then
    if costomData.isServerInfo == nil or not costomData.isServerInfo then
      minValue = costomData.clientTbl["min_" .. costomData.attributeKey]
      if minValue and minValue ~= "" then
        minValue = 1 / tonumber(minValue) * 10000
        minValue = math.floor(minValue + 0.5)
      end
    end
    excellenceAttr = 1 / costomData._value * 10000
    if costomData.isServerInfo then
      excellenceAttr = MathUtility.FormatFloat(excellenceAttr, 1)
    else
      excellenceAttr = math.floor(excellenceAttr + 0.5)
    end
    suffix = ""
    isInterval = true
  elseif calculateType == EquipAttributeCalculateType.ConstantInterval then
    if costomData.isServerInfo == nil or not costomData.isServerInfo then
      minValue = costomData.clientTbl["attributeKey" .. costomData.attributeKey]
    end
    excellenceAttr = costomData._value
    suffix = ""
    isInterval = true
  else
    return ""
  end
  if not isInterval then
    return string.format(AttributeWordUtil.GetUIWord(realAttributeKey, "equipeExcellenceUI"), tostring(excellenceAttr), suffix)
  else
    return string.format(AttributeWordUtil.GetUIWord(realAttributeKey, "equipeExcellenceUI"), (minValue == nil or minValue == "") and tostring(excellenceAttr) or tostring(minValue) .. suffix .. "~" .. tostring(excellenceAttr), suffix)
  end
end

local function GetExcellenceShowById(excellenceId)
  local excellenceAttrs = ClientTable.cfg_Item_equip_excellenceManager:TryGetValue(excellenceId)
  if excellenceAttrs ~= nil then
    local tName = ""
    local tValue = ""
    for name, value in pairs(excellenceAttrs) do
      if name ~= "id" and name ~= "type" and name ~= "subType" and name ~= "excellentAddition" and name ~= "equipRating" and name ~= "attributeType" and name ~= "condition" and tonumber(value) > 0 and string.contains(name, "client_") then
        tName = name
        tValue = value
      end
    end
    if tName == "" then
      for name, value in pairs(excellenceAttrs) do
        if name ~= "id" and name ~= "type" and name ~= "subType" and name ~= "excellentAddition" and name ~= "equipRating" and name ~= "attributeType" and name ~= "condition" and tonumber(value) > 0 and not string.contains(name, "server_") then
          tName = name
          tValue = value
        end
      end
    end
    local name = tName
    local value = tonumber(tValue)
    if not string.isNullOrEmpty(name) and name ~= "equipRating" and 0 < value then
      return RoleEquipUtility.GetEquipExcellenceStrByTbl({
        attributeKey = name,
        _value = value,
        clientTbl = excellenceAttrs
      })
    end
  end
end

local function PromptTip(AttributeNums, ItemInfo, Bounce)
  local strTab = ""
  if ItemInfo.tblItem.needStrength ~= 0 then
    if AttributeNums[EAttributeType.strength] == 0 then
      strTab = strTab .. "S\225\187\169c M\225\186\161nh:" .. ItemInfo.tblItem.needStrength .. " \n"
      strTab = string.GetColorText(strTab, "#39FF00")
    else
      strTab = strTab .. "S\225\187\169c M\225\186\161nh:" .. ItemInfo.tblItem.needStrength .. "(C\195\178n thi\225\186\191u" .. AttributeNums[EAttributeType.strength] .. ")" .. " \n"
      strTab = string.GetColorText(strTab, "#FF000D")
    end
  end
  if ItemInfo.tblItem.needAgility ~= 0 then
    if AttributeNums[EAttributeType.agility] == 0 then
      strTab = strTab .. "Nhanh Nh\225\186\185n:" .. ItemInfo.tblItem.needAgility .. " \n"
      strTab = string.GetColorText(strTab, "#39FF00")
    else
      strTab = strTab .. "Nhanh Nh\225\186\185n:" .. ItemInfo.tblItem.needAgility .. "(C\195\178n thi\225\186\191u" .. AttributeNums[EAttributeType.agility] .. ")" .. " \n"
      strTab = string.GetColorText(strTab, "#FF000D")
    end
  end
  if ItemInfo.tblItem.needEnergy ~= 0 then
    if AttributeNums[EAttributeType.energy] == 0 then
      strTab = strTab .. "Tr\195\173 L\225\187\177c:" .. ItemInfo.tblItem.needStrength .. " \n"
      strTab = string.GetColorText(strTab, "#39FF00")
    else
      strTab = strTab .. "Tr\195\173 L\225\187\177c:" .. ItemInfo.tblItem.needEnergy .. "(C\195\178n thi\225\186\191u" .. AttributeNums[EAttributeType.energy] .. ")" .. " \n"
      strTab = string.GetColorText(strTab, "#FF000D")
    end
  end
  strTab = strTab .. "" .. " \n"
  strTab = strTab .. string.GetColorText("Kh\195\180ng \196\145\225\187\167 \196\145i\225\187\131m ph\195\162n ph\225\187\145i, h\195\163y \196\145\225\186\191n t\196\131ng c\225\186\165p", "#FFFFFF")
  local title = {
    title = string.GetColorText("M\225\186\183c Trang B\225\187\139 c\225\186\167n \196\145\225\186\161t", "#FFFFFF"),
    textContent = strTab,
    cancelText = "",
    okText = "",
    cancel = nil,
    ok = nil
  }
  UIManager.Show(UIID.PromptTipUI, title)
end

local function PromptEquipPutOn(AttributeNums, ItemInfo, Bounce)
  local newAttributeNums = {}
  local strTab = ""
  local strength = ViewData.meData:GetAttribute(EAttributeType.strength)
  local agility = ViewData.meData:GetAttribute(EAttributeType.agility)
  local energy = ViewData.meData:GetAttribute(EAttributeType.energy)
  for k, v in pairs(AttributeNums) do
    if 0 < v then
      newAttributeNums[k] = v
    end
  end
  if ItemInfo.tblItem.needStrength ~= 0 then
    if AttributeNums[EAttributeType.strength] == 0 then
      strTab = strTab .. "S\225\187\169c M\225\186\161nh:" .. ItemInfo.tblItem.needStrength .. " \n"
      strTab = string.GetColorText(strTab, "#39FF00")
    else
      strTab = strTab .. "S\225\187\169c M\225\186\161nh:" .. ItemInfo.tblItem.needStrength .. "(C\195\178n thi\225\186\191u" .. AttributeNums[EAttributeType.strength] .. ")" .. " \n"
      strTab = string.GetColorText(strTab, "#FF000D")
    end
  end
  if ItemInfo.tblItem.needAgility ~= 0 then
    if AttributeNums[EAttributeType.agility] == 0 then
      strTab = strTab .. "Nhanh Nh\225\186\185n:" .. ItemInfo.tblItem.needAgility .. " \n"
      strTab = string.GetColorText(strTab, "#39FF00")
    else
      strTab = strTab .. "Nhanh Nh\225\186\185n:" .. ItemInfo.tblItem.needAgility .. "(C\195\178n thi\225\186\191u" .. AttributeNums[EAttributeType.agility] .. ")" .. " \n"
      strTab = string.GetColorText(strTab, "#FF000D")
    end
  end
  if ItemInfo.tblItem.needEnergy ~= 0 then
    if AttributeNums[EAttributeType.energy] == 0 then
      strTab = strTab .. "Tr\195\173 L\225\187\177c:" .. ItemInfo.tblItem.needStrength .. " \n"
      strTab = string.GetColorText(strTab, "#39FF00")
    else
      strTab = strTab .. "Tr\195\173 L\225\187\177c:" .. ItemInfo.tblItem.needEnergy .. "(C\195\178n thi\225\186\191u" .. AttributeNums[EAttributeType.energy] .. ")" .. " \n"
      strTab = string.GetColorText(strTab, "#FF000D")
    end
  end
  strTab = strTab .. "Ph\195\161t hi\225\187\135n c\195\179 \196\145i\225\187\131m t\196\131ng c\225\186\165p c\195\179 th\225\187\131 ph\195\162n b\225\187\149, x\195\161c nh\225\186\173n ph\195\162n b\225\187\149 ngay"
  strTab = string.GetColorText(strTab, "#FFFFFF")
  
  local function PromptOK(okArgs)
    MeController.ReqAttributeModify(okArgs.attributes)
    if ItemUtility.IsEquipType(okArgs.itemInfo.tblItem.type) then
      RoleEquipUtility.OnWearEquip(okArgs.itemInfo)
      UIManager.Hide(UIID.ItemTipUI)
    end
    UIManager.Hide(UIID.PromptTipUI)
  end
  
  local title = {
    title = string.GetColorText("M\225\186\183c Trang B\225\187\139 c\225\186\167n \196\145\225\186\161t", "#FFFFFF"),
    textContent = strTab,
    cancelText = "",
    okText = "",
    cancel = nil,
    ok = PromptOK,
    okArgs = {attributes = newAttributeNums, itemInfo = ItemInfo}
  }
  if Bounce == CheckUseItemWay.AddPointTip then
    UIManager.Show(UIID.PromptTipUI, title)
  else
    MeController.ReqAttributeModify(newAttributeNums)
  end
end

local function RegenerateEquipInfo(tips)
  local regenerate = tips.RegenerateAttributeList
  if regenerate == nil then
    regenerate = tips.serverInfo
    if regenerate ~= nil then
      regenerate = tips.serverInfo.RegenerateAttributeList
    end
  end
  return regenerate
end

local function JobUseItem(item)
  local ItemInfo = item
  if ItemInfo.tblItem.career ~= "0" then
    local careerEnough = false
    local careers = string.split(ItemInfo.tblItem.career, "#")
    local career = ViewData.meData.career
    for _, v in pairs(careers) do
      if RoleUtility.CareerJudge(career, tonumber(v)) then
        careerEnough = true
        break
      end
    end
    return careerEnough
  end
  return true
end

local function CheckUseItem(item, Bounce)
  local ItemInfo = item
  local AttributeCheckUse = true
  local AttributeNumstrength = 0
  local AttributeNumagility = 0
  local AttributeNumEnergy = 0
  if ItemInfo.tblItem.career ~= "0" then
    local careerEnough = 0
    local meetRequirement = false
    local careers = string.split(ItemInfo.tblItem.career, "#")
    local career = ViewData.meData.career
    local targetCareer
    if 0 < table.count(careers) then
      for _, v in pairs(careers) do
        local compatibiltyNum = RoleUtility.JudgeWardCompatibilty(career, tonumber(v))
        if compatibiltyNum ~= 0 then
          careerEnough = compatibiltyNum
          if careerEnough == 2 then
            targetCareer = tonumber(v)
          end
          break
        end
      end
    else
      careerEnough = 1
    end
    if careerEnough == 0 then
      if Bounce == CheckUseItemWay.AddPointTip then
        UIManager.Show(UIID.PromptTipUI, {
          title = LocalizationUtility.GetContentByKey("tishi"),
          textContent = string.GetColorText(LocalizationUtility.GetContentByKey("zhiyebufuhe"), "#dcele5"),
          cancelText = "",
          okText = "",
          cancel = nil,
          ok = nil
        })
      end
      return false, ItemUseCheckState.careerUnEnough
    end
    if careerEnough == 2 then
      if Bounce == CheckUseItemWay.AddPointTip then
        local transferName = RoleUtility.GteCareerNameByType(targetCareer)
        local str = string.GetColorText(string.format("Chuy\225\187\131n Ch\225\187\169c th\195\160nh %s c\195\179 th\225\187\131 s\225\187\173 d\225\187\165ng", transferName), "#dcele5")
        RoleEquipUtility.UIManagerShow(str)
      end
      return false, ItemUseCheckState.transferUnEnough
    end
  end
  if ItemInfo.tblItem.needLevel ~= 0 then
    local levelEnough = false
    local levelbol
    local level = ItemInfo.tblItem.needLevel
    local regenerate = RegenerateEquipInfo(ItemInfo)
    if regenerate ~= nil then
      for i, v in pairs(regenerate) do
        if v.RegenerateAttribute[1].attributeName == "levelEnergyReduce" then
          level = level - v.RegenerateAttribute[1].attributeValue
          levelbol = true
        end
      end
    end
    if levelbol then
      levelEnough = level <= ViewData.meData.level and true or false
    else
      levelEnough = ItemInfo.tblItem.needLevel <= ViewData.meData.level and true or false
    end
    if not levelEnough then
      if Bounce == CheckUseItemWay.AddPointTip then
        local cLevelTbl
        if levelbol then
          cLevelTbl = ClientTable.cfg_Character_levelManager:TryGetValue(level)
        else
          cLevelTbl = ClientTable.cfg_Character_levelManager:TryGetValue(ItemInfo.tblItem.needLevel)
        end
        local str = string.GetColorText(string.format(LocalizationUtility.GetContentByKey("dengjibufuhe"), cLevelTbl.name), "#dcele5")
        RoleEquipUtility.UIManagerShow(str)
      end
      return false, ItemUseCheckState.levelUnEnough
    end
  end
  if ItemInfo.tblItem.needHolyspirit ~= nil and Bounce == CheckUseItemWay.AddPointTip then
    local needRandom = TableParse:SplitStringToIntList(ItemInfo.tblItem.needHolyspirit, "#")
    if needRandom[1] ~= nil and needRandom[1] ~= 0 then
      local needEnergy
      local wordTable = ClientTable.cfg_Ui_wordManager:TryGetValue("Shenghun_" .. needRandom[1])
      if wordTable ~= nil then
        needEnergy = wordTable.content
      end
      local energy = HolySpiritPointData.GetNowTypeActivePointCount(needRandom[1])
      if energy < needRandom[2] then
        local str = string.GetColorText(string.format("C\225\186\167n Th\195\161nh H\225\187\147n %s c\195\179 th\225\187\131 s\225\187\173 d\225\187\165ng", needEnergy .. needRandom[2]), "#dcele5")
        RoleEquipUtility.UIManagerShow(str)
      end
    end
  end
  if ItemInfo.tblItem.needStrength ~= 0 then
    local strengthEnough = false
    local strength = ViewData.meData:GetAttribute(EAttributeType.strength)
    strengthEnough = strength >= ItemInfo.tblItem.needStrength and true or false
    if not strengthEnough then
      AttributeCheckUse = false
      AttributeNumstrength = ItemInfo.tblItem.needStrength - strength
    end
  end
  if ItemInfo.tblItem.needAgility ~= 0 then
    local agilityEnough = false
    local agility = ViewData.meData:GetAttribute(EAttributeType.agility)
    agilityEnough = agility >= ItemInfo.tblItem.needAgility and true or false
    if not agilityEnough then
      AttributeCheckUse = false
      AttributeNumagility = ItemInfo.tblItem.needAgility - agility
    end
  end
  if ItemInfo.tblItem.needEnergy ~= 0 then
    local energyEnough = false
    local energy = ViewData.meData:GetAttribute(EAttributeType.energy)
    energyEnough = energy >= ItemInfo.tblItem.needEnergy and true or false
    if not energyEnough then
      AttributeCheckUse = false
      AttributeNumEnergy = ItemInfo.tblItem.needEnergy - energy
    end
  end
  local state = ItemUseCheckState.None
  if not AttributeCheckUse then
    local AttributeNums = {
      [EAttributeType.strength] = AttributeNumstrength,
      [EAttributeType.agility] = AttributeNumagility,
      [EAttributeType.energy] = AttributeNumEnergy
    }
    if ViewData.meData.validAttributePoint >= AttributeNumstrength + AttributeNumagility + AttributeNumEnergy then
      state = ItemUseCheckState.attrPointEnough
      if Bounce ~= CheckUseItemWay.NotAddPoint then
        PromptEquipPutOn(AttributeNums, ItemInfo, Bounce)
      end
    else
      state = ItemUseCheckState.attrPointUnEnough
      if Bounce == CheckUseItemWay.AddPointTip then
        PromptTip(AttributeNums, ItemInfo, Bounce)
      end
    end
  end
  if ItemInfo.tblEquip and ItemInfo.tblEquip.cellType == EEquipCellType.HolySpirit then
    AttributeCheckUse = ConditionManager.Check4D(ItemInfo.tblItem.transCondition)
    if AttributeCheckUse then
      state = ItemUseCheckState.None
    else
      state = ItemUseCheckState.attrPointUnEnough
    end
  end
  return AttributeCheckUse, state
end

local function UIManagerShow(str)
  UIManager.Show(UIID.PromptTipUI, {
    ttitle = LocalizationUtility.GetContentByKey("tishi"),
    textContent = str,
    cancelText = "",
    okText = "",
    cancel = nil,
    ok = nil
  })
end

function GetEquipDataRating(equipData)
  local fightLogicLevel = tonumber(GlobalConfig.GetGlobalConfig(1130001))
  if fightLogicLevel < ViewData.meData:GetAttribute(EAttributeType.level) then
    return ViewData.meData:EquipWearFightCaululator(equipData)
  else
    return equipData:GetAllAttributes().equipRating
  end
end

local function CanUp(equipData)
  if QuickFind.LuaMainPlayerEquipData():GetJewelryData():IsJewelry_ItemData(equipData) then
    return QuickFind.LuaMainPlayerEquipData():GetJewelryData():IsBetter(equipData)
  end
  local fightLogicLevel = tonumber(GlobalConfig.GetGlobalConfig(1130001))
  if fightLogicLevel < ViewData.meData:GetAttribute(EAttributeType.level) then
    return ViewData.meData:EquipItemFightCalculator(equipData)
  else
    return ViewData.meData:EquipEntryRatingCompare(equipData)
  end
end

local function GetRecommendIndex(ItemInfo)
  local positionTbl = string.split(ItemInfo.tblEquip.equipPosition, "#")
  local canPosition = tonumber(positionTbl[1])
  if 1 < table.count(positionTbl) or WeaponCondition[ItemInfo.tblEquip.subType] then
    local pos1 = tonumber(positionTbl[1])
    local pos2 = tonumber(positionTbl[2])
    local equip2Pos = pos2 and pos2 or pos1 == ERoleEquipPosition.right_weapon and ERoleEquipPosition.left_weapon or ERoleEquipPosition.right_weapon
    local equip1 = ViewData.meData.equipsData:GetEquipByIndex(pos1)
    local equip2 = ViewData.meData.equipsData:GetEquipByIndex(equip2Pos)
    local a = pos1 % 100
    if a == ERoleEquipPosition.right_weapon or a == ERoleEquipPosition.left_weapon then
      if not equip1 and not equip2 then
        canPosition = pos1
      elseif equip1 and not equip2 then
        canPosition = pos1
        if RoleEquipUtility.WearWeaponsCondition(equip1.tblEquip.subType, ItemInfo.tblEquip.subType) and table.count(positionTbl) == 2 and RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.SwordMan then
          canPosition = pos2
        end
      elseif not equip1 and equip2 then
        if RoleEquipUtility.WearWeaponsCondition(equip2.tblEquip.subType, ItemInfo.tblEquip.subType) then
          canPosition = pos1
        else
          canPosition = equip2Pos
        end
      elseif RoleEquipUtility.WearWeaponsCondition(equip1.tblEquip.subType, ItemInfo.tblEquip.subType) then
        if table.count(positionTbl) == 2 then
          canPosition = GetEquipDataRating(equip1) <= GetEquipDataRating(equip2) and pos1 or pos2
        else
          canPosition = pos1
        end
      else
        canPosition = GetEquipDataRating(equip1) >= GetEquipDataRating(equip2) and pos1 or equip2Pos
      end
    elseif not equip1 then
      canPosition = pos1
    elseif not equip2 then
      canPosition = pos2
    else
      canPosition = GetEquipDataRating(equip1) >= GetEquipDataRating(equip2) and pos1 or pos2
    end
  end
  return canPosition
end

local function WearEquipIndex(ItemInfo)
  local positionTbl = string.split(ItemInfo.tblEquip.equipPosition, "#")
  local canPosition = tonumber(positionTbl[1])
  local equip1 = ViewData.meData.equipsData.Data[tonumber(positionTbl[1])]
  local equip2 = ViewData.meData.equipsData.Data[tonumber(positionTbl[2])]
  if RoleUtility.GetBasicCareer(RoleManager.me.career) ~= ERoleCareer.SwordMan and RoleUtility.GetBasicCareer(RoleManager.me.career) ~= ERoleCareer.SpellSword and (canPosition == ERoleEquipPosition.right_weapon or canPosition == ERoleEquipPosition.left_weapon) and equip1 and equip2 and table.count(positionTbl) == 2 and WeaponCondition[ItemInfo.tblItem.subType] == 1 then
    return ERoleEquipPosition.right_weapon
  end
  for _, index in pairs(positionTbl) do
    local equip = ViewData.meData.equipsData:GetEquipByIndex(tonumber(index))
    if equip and RoleEquipUtility.WearWeaponsJudge(equip.tblEquip.subType) and table.count(positionTbl) == 2 then
      canPosition = tonumber(ERoleEquipPosition.right_weapon)
      break
    end
    if equip and table.count(positionTbl) == 2 then
      if equip1 and equip2 then
        if GetEquipDataRating(equip1) > GetEquipDataRating(equip2) then
          canPosition = tonumber(positionTbl[2])
          break
        end
        canPosition = tonumber(positionTbl[1])
        break
      elseif equip1 and not equip2 then
        canPosition = tonumber(positionTbl[2])
        break
      elseif not equip1 and equip2 then
        canPosition = tonumber(positionTbl[1])
        break
      end
    end
    if not equip then
      if tonumber(index) == ERoleEquipPosition.right_weapon or tonumber(index) == ERoleEquipPosition.left_weapon then
        if RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.SwordMan or RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.SpellSword then
          canPosition = tonumber(index)
          break
        end
      else
        canPosition = tonumber(index)
        break
      end
    end
  end
  local equip = ViewData.meData.equipsData:GetWeaponEquips()
  local canPositionWeapon = canPosition == tonumber(ERoleEquipPosition.right_weapon) or canPosition == tonumber(ERoleEquipPosition.left_weapon)
  local isNormalEquip = RoleEquipUtility.EquipTypeUtility(canPosition, ERoleEquipCondition.Normal)
  if table.count(equip) > 0 and canPositionWeapon and isNormalEquip then
    for k, v in pairs(equip) do
      if not RoleEquipUtility.WearWeaponsCondition(v.tblEquip.subType, ItemInfo.tblEquip.subType) and table.count(positionTbl) == 2 then
        canPosition = ERoleEquipPosition.right_weapon
        break
      end
    end
  end
  return canPosition
end

local function WearCultureEquipIndex(ItemInfo)
  local positionTbl = string.split(ItemInfo.tblEquip.equipPosition, "#")
  local canPosition = tonumber(positionTbl[1])
  local nowSelectData = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():GetNowSelectGuarItem()
  if nowSelectData ~= nil and nowSelectData.nowtable ~= nil then
    local petType = nowSelectData.nowtable.petType
    for i, v in ipairs(positionTbl) do
      local position = tonumber(v)
      local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(position)
      if cellTbl and cellTbl.relationGuardType and cellTbl.relationGuardType == petType then
        canPosition = position
        break
      end
    end
  end
  return canPosition
end

local function GetWearEquipPosition(ItemInfo)
  local equip = ViewData.meData.equipsData.Data[ItemInfo.bagGridIndex]
  if equip and equip.id == ItemInfo.id then
    return ItemInfo.bagGridIndex
  else
    return WearEquipIndex(ItemInfo)
  end
end

local function OnWearEquip(ItemInfo)
  local canPosition
  if ItemInfo.tblEquip then
    local isCultureEquip = ItemInfo.tblEquip.subType == 41
    if isCultureEquip then
      canPosition = WearCultureEquipIndex(ItemInfo)
    else
      canPosition = WearEquipIndex(ItemInfo)
    end
    local equip = ViewData.meData.equipsData:GetWeaponEquips()
    local canPositionWeapon = (canPosition == tonumber(ERoleEquipPosition.right_weapon) or canPosition == tonumber(ERoleEquipPosition.left_weapon)) and true
    if table.count(equip) > 0 and canPositionWeapon then
      if equip[ERoleEquipPosition.left_weapon] then
        local v = equip[ERoleEquipPosition.left_weapon]
        if not RoleEquipUtility.WearWeaponsCondition(v.tblEquip.subType, ItemInfo.tblEquip.subType) then
          MeEquipController.ReqTakeOffTheEquip(ERoleEquipPosition.left_weapon, true)
        end
      end
      if equip[ERoleEquipPosition.right_weapon] then
        local v = equip[ERoleEquipPosition.right_weapon]
        local equipData = RoleManager.me.data.equipsData.Data
        if not RoleEquipUtility.WearWeaponsCondition(v.tblEquip.subType, ItemInfo.tblEquip.subType) and not MeEquipController.IsCanTransfer(equipData[canPosition], ItemInfo) then
          MeEquipController.ReqTakeOffTheEquip(ERoleEquipPosition.right_weapon, true)
        end
      end
    end
    MeEquipController.ReqPutOnTheEquip(canPosition, ItemInfo)
  end
  if ItemInfo.tblItem.auctionType == 54 then
    EventManager.Dispatch(Event.HolyRingEquip)
  end
end

local function DoJudgeWearFightState(itemData, enoughCondition)
  local state = EquipUpState.None
  local wearIndex = GetRecommendIndex(itemData, true)
  local wearble
  if itemData.subType == EItemSubtype.Mount then
    wearble = RoleManager.me.data.mountData:GetMountData(itemData.itemId)
  else
    wearble = RoleManager.me.data.equipsData.Data[wearIndex]
  end
  if wearble then
    if wearble.tblItem.dropLevle == itemData.tblItem.dropLevle and not RoleEquipUtility.WearWeaponsCondition(wearble.tblItem.subType, itemData.tblItem.subType) then
      state = EquipUpState.cantUpFight
    elseif GetEquipDataRating(wearble) < GetEquipDataRating(itemData) then
      state = enoughCondition and EquipUpState.CanWearUpFight or EquipUpState.CantWearUpFight
    else
      state = EquipUpState.cantUpFight
    end
  else
    state = enoughCondition and EquipUpState.CanWearUpFight or EquipUpState.CantWearUpFight
  end
  return state
end

local function CanUpFight(itemData)
  local state = EquipUpState.None
  local canUse, checkState = CheckUseItem(itemData, CheckUseItemWay.NotAddPoint)
  local curCantWear = not canUse and checkState == ItemUseCheckState.attrPointEnough
  if canUse or curCantWear then
    if CanUp(itemData) then
      state = EquipUpState.CanWearUpFight
    end
  elseif checkState == ItemUseCheckState.levelUnEnough or checkState == ItemUseCheckState.attrPointUnEnough or checkState == ItemUseCheckState.transferUnEnough then
    if CanUp(itemData) then
      state = EquipUpState.CantWearUpFight
    end
  else
    state = EquipUpState.CantWear
  end
  return state
end

local function CheckCareerEquip(itemId, career)
  if type(itemId) ~= "number" then
    return false
  end
  local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
  if itemTbl == nil then
    return false
  end
  local curCareer = career == nil and RoleManager.me.career or career
  if type(curCareer) ~= "number" then
    return false
  end
  local itemTblCareer = string.isNullOrEmpty(itemTbl.career) and 0 or tonumber(itemTbl.career)
  if type(itemTblCareer) ~= "number" then
    return false
  end
  local careerType, itemTblCareerType = curCareer % 10, itemTblCareer % 10
  return itemTblCareer == ERoleCareer.ItemTblAll or careerType == itemTblCareerType
end

local function GetCareerModelData(career)
  local globalID, globalData, EquipPos, EquipPosData
  local careerModelData = {}
  for k, v in pairs(CareerInModel) do
    if k == career then
      globalID = v
      break
    end
  end
  globalData = ClientTable.cfg_Activity_globalManager:TryGetValue(globalID)
  EquipPos = string.split(globalData.effect, "&")
  for i = 1, table.count(EquipPos) do
    EquipPosData = string.split(EquipPos[i], "#")
    local bagGridIndex = tonumber(EquipPosData[1])
    careerModelData[bagGridIndex] = ItemUtility.GenerateServerItemInfo(tonumber(EquipPosData[2]))
    careerModelData[bagGridIndex].bagGridIndex = bagGridIndex
  end
  return careerModelData
end

local function EquipTypeUtility(bagGridIndex, condition)
  if not bagGridIndex or not tonumber(bagGridIndex) then
    return false
  end
  local cellTab
  if 0 < bagGridIndex then
    cellTab = ClientTable.cfg_EquipCell_cellManager:TryGetValue(bagGridIndex, "index")
  end
  if condition == ERoleEquipCondition.Equip then
    if cellTab and (RoleEquipUtility.IsAppearByCellType(cellTab.cellType) or cellTab.cellType == 14) then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.Archangel then
    if cellTab and cellTab.cellType == 6 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.Normal then
    if cellTab and cellTab.cellType == 1 and bagGridIndex ~= ERoleEquipPosition.cloak then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.Title then
    if cellTab and cellTab.cellType == 8 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.Foot then
    if cellTab and cellTab.cellType == 10 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.RingChange then
    if cellTab and cellTab.cellType == 13 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.timeEquip then
    if cellTab and cellTab.cellType == 11 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.Pet then
    if cellTab and cellTab.cellType == 12 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.HongZhuang then
    if cellTab and cellTab.cellType == 15 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.ShouHu then
    if cellTab and cellTab.cellType == 16 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.BlessArchangel then
    if cellTab and cellTab.cellType == 17 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.Shenghun then
    if cellTab and cellTab.cellType == 18 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.ChristmaSuit then
    if cellTab and cellTab.cellType == 20 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.Couture then
    if cellTab and cellTab.cellType == 30 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.BingJianSpringFestival then
    if cellTab and cellTab.cellType == 21 then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.DianYiSuit then
    if cellTab and cellTab.cellType == EquipCellType.BINGJIAN_DianYi then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.BingJianBeachParty then
    if cellTab and cellTab.cellType == EquipCellType.BINGJIAN_BeachParty then
      return true
    end
    return false
  elseif condition == ERoleEquipCondition.BingJianYuanTianYueBai then
    if cellTab and cellTab.cellType == EquipCellType.BINGJIAN_YuanTianYueBai then
      return true
    end
    return false
  end
end

local function GetConditionEquipData(data, condition, otherParams)
  local tab = {}
  if not data then
    return tab
  end
  if condition == ERoleEquipCondition.Normal then
    for i, v in pairs(data) do
      if v then
        local cellTab = ClientTable.cfg_EquipCell_cellManager:TryGetValue(i, "index")
        if cellTab and cellTab.cellType == 1 then
          tab[i] = v
        end
      end
    end
  elseif condition == ERoleEquipCondition.Archangel then
    for i, v in pairs(data) do
      if v then
        local cellTab = ClientTable.cfg_EquipCell_cellManager:TryGetValue(i, "index")
        if cellTab and cellTab.cellType == 6 then
          tab[i] = v
        end
      end
    end
  elseif condition == ERoleEquipCondition.InputCellType and type(otherParams) == "table" then
    for i, v in pairs(data) do
      if v then
        local cellTab = ClientTable.cfg_EquipCell_cellManager:TryGetValue(i, "index")
        if cellTab and table.contains(otherParams, cellTab.cellType) then
          tab[i] = v
        end
      end
    end
  elseif condition == ERoleEquipCondition.Equip then
    for i, v in pairs(data) do
      if v then
        local cellTab = ClientTable.cfg_EquipCell_cellManager:TryGetValue(i, "index")
        if cellTab and RoleEquipUtility.IsAppearByCellType(cellTab.cellType) then
          tab[i] = v
        end
      end
    end
  end
  return tab
end

local function HandleAppearData(id, data)
  local Tab = {}
  if not ForgeData.appearData[id] or string.isNullOrEmpty(ForgeData.appearData[id]) then
    ForgeData.appearData[id] = "{}"
  end
  local temp = json.decode(ForgeData.appearData[id])
  for i, v in pairs(temp) do
    if data then
      if data[v] then
        Tab[i] = v
      end
    else
      Tab[i] = v
    end
  end
  return Tab
end

local function GetEquipShowTab(data)
  local totalBagIndex = {}
  local isHaveArch = false
  for i, v in pairs(data) do
    if v and RoleEquipUtility.IsEquipAppearData(v.bagGridIndex) then
      if EquipTypeUtility(i, ERoleEquipCondition.Archangel) then
        isHaveArch = true
      end
      if not totalBagIndex[i % 100] then
        totalBagIndex[i % 100] = {}
        table.insert(totalBagIndex[i % 100], i)
      else
        table.insert(totalBagIndex[i % 100], i)
      end
    end
  end
  for i, v in pairs(totalBagIndex) do
    table.sort(v, function(a, b)
      return b < a
    end)
  end
  return totalBagIndex, isHaveArch
end

local function DefaultShowAppearEquip(id, data)
  local dataTab, isHaveArch = GetEquipShowTab(data)
  local equipShowTab = {}
  local reqTab = HandleAppearData(id, data)
  local tempT = {}
  for _, v in pairs(reqTab) do
    table.insert(tempT, v % 100)
  end
  for index, tab in pairs(dataTab) do
    if not table.contains(tempT, index) then
      if index == ERoleEquipPosition.pet then
        reqTab.equip_pet = tab[1]
      elseif index == ERoleEquipPosition.right_weapon then
        if not isHaveArch or EquipTypeUtility(tab[1], ERoleEquipCondition.Archangel) then
          reqTab.equip_right = tab[1]
          if isHaveArch then
            table.insert(tempT, index)
          end
        end
      elseif index == ERoleEquipPosition.left_weapon then
        if not isHaveArch or EquipTypeUtility(tab[1], ERoleEquipCondition.Archangel) then
          reqTab.equip_left = tab[1]
          if isHaveArch then
            table.insert(tempT, index)
          end
        end
      elseif index == ERoleEquipPosition.helm then
        reqTab.equip_helm = tab[1]
      elseif index == ERoleEquipPosition.armor then
        reqTab.equip_armor = tab[1]
      elseif index == ERoleEquipPosition.glove then
        reqTab.equip_glove = tab[1]
      elseif index == ERoleEquipPosition.pant then
        reqTab.equip_pant = tab[1]
      elseif index == ERoleEquipPosition.boot then
        reqTab.equip_boot = tab[1]
      elseif index == ERoleEquipPosition.footPrintIndex then
        reqTab.equip_foot = tab[1]
      elseif index == ERoleEquipPosition.flag then
        reqTab.equip_flag = tab[1]
      elseif index == ERoleEquipPosition.cloak then
        reqTab.equip_cloak = tab[1]
      end
    end
  end
  for k, v in pairs(reqTab) do
    table.insert(equipShowTab, v)
  end
  local appear = json.encode(reqTab)
  ForgeData.appearData[id] = appear
  return equipShowTab
end

local function UpdateAppearSaveData(bagGridIndex, isRemove, reason)
  if not RoleEquipUtility.IsEquipAppearData(bagGridIndex) then
    return
  end
  local reqTab = HandleAppearData(RoleManager.me.id)
  local indexTab = {}
  for _, v in pairs(reqTab) do
    if v then
      table.insert(indexTab, v)
    end
  end
  if isRemove then
    if table.contains(indexTab, bagGridIndex) then
      local tab = {}
      for i, v in pairs(reqTab) do
        if v and v ~= bagGridIndex then
          tab[i] = v
        end
      end
      reqTab = tab
    end
  elseif bagGridIndex % 100 == ERoleEquipPosition.helm then
    reqTab.equip_helm = bagGridIndex
  elseif bagGridIndex % 100 == ERoleEquipPosition.pet then
    reqTab.equip_pet = bagGridIndex
  elseif bagGridIndex % 100 == ERoleEquipPosition.right_weapon then
    reqTab.equip_right = bagGridIndex
  elseif bagGridIndex % 100 == ERoleEquipPosition.left_weapon then
    reqTab.equip_left = bagGridIndex
  elseif bagGridIndex % 100 == ERoleEquipPosition.armor then
    reqTab.equip_armor = bagGridIndex
  elseif bagGridIndex % 100 == ERoleEquipPosition.glove then
    reqTab.equip_glove = bagGridIndex
  elseif bagGridIndex % 100 == ERoleEquipPosition.pant then
    reqTab.equip_pant = bagGridIndex
  elseif bagGridIndex % 100 == ERoleEquipPosition.boot then
    reqTab.equip_boot = bagGridIndex
  elseif bagGridIndex % 100 == ERoleEquipPosition.footPrintIndex then
    reqTab.equip_foot = bagGridIndex
  elseif bagGridIndex % 100 == ERoleEquipPosition.flag then
    reqTab.equip_flag = bagGridIndex
  elseif bagGridIndex % 100 == ERoleEquipPosition.cloak then
    reqTab.equip_cloak = bagGridIndex
  end
  local appear = json.encode(reqTab)
  ForgeData.appearData[RoleManager.me.id] = appear
  if reason ~= 2 then
    MeEquipController.ReqSaveAppear(appear)
  end
end

local function UpdatePlayerAppearData(id, appear)
  if id == RoleManager.me.id then
    return
  end
  if ForgeData.appearData[id] then
    ForgeData.appearData[id] = appear
  elseif string.isNullOrEmpty(appear) then
    ForgeData.appearData[id] = "{}"
  else
    ForgeData.appearData[id] = appear
  end
end

local EquipAppearIndex = {
  ERoleEquipPosition.pet,
  ERoleEquipPosition.helm,
  ERoleEquipPosition.right_weapon,
  ERoleEquipPosition.left_weapon,
  ERoleEquipPosition.armor,
  ERoleEquipPosition.glove,
  ERoleEquipPosition.pant,
  ERoleEquipPosition.boot,
  ERoleEquipPosition.footPrintIndex,
  ERoleEquipPosition.ringChange,
  ERoleEquipPosition.yongDragon,
  ERoleEquipPosition.cloak
}

local function IsAppearByCellType(cellType)
  local bingJianCellTypes = ClientTable.cfg_Item_equip_bingjianManager:GetAllCellTypeList()
  if table.contains(EAppearCellType, cellType) or table.contains(bingJianCellTypes, cellType) then
    return true
  end
  return false
end

local function IsEquipAppearData(bagGridIndex)
  local cellTab = ClientTable.cfg_EquipCell_cellManager:TryGetValue(bagGridIndex, "index")
  if cellTab and IsAppearByCellType(cellTab.cellType) and table.contains(EquipAppearIndex, bagGridIndex % 100) then
    return true
  end
  return false
end

local function IsDotShowAppearData(bagGridIndex)
  local cellTab = ClientTable.cfg_EquipCell_cellManager:TryGetValue(bagGridIndex, "index")
  if cellTab.cellType == 30 then
    return false
  end
  return true
end

local function IsVipEquipData(bagGridIndex)
  return bagGridIndex == ERoleEquipPosition.vipIndex
end

local function IsHaveAutoPickEquip()
  for i, v in pairs(RoleManager.me.data.equipsData.Data) do
    if v and v.tblEquip.autoPickOpen == 1 then
      return true
    end
  end
  for i, v in pairs(RoleManager.me.data.equipsData.StoneData) do
    if v and v.tblEquip.autoPickOpen == 1 then
      return true
    end
  end
  return false
end

local function GetEquipNameColor(titleStr, ItemInfo)
  local subType = ItemInfo.tblItem.subType
  if 1 <= subType and subType <= 17 or subType == 24 or subType == 25 then
    if ItemInfo.isSuit then
      titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.cRed])
    elseif table.count(ItemInfo.excellence) > 0 then
      titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.green])
    elseif 0 < table.count(ItemInfo.luckIds) then
      titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.bBlue])
    elseif ItemInfo.tblEquip.excellentNumber ~= "" then
      titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.green])
    else
      titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.white])
    end
  elseif subType == 18 or subType == 19 or subType == 26 then
    titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.green])
  elseif subType == 20 then
    titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.green])
  elseif subType == 21 then
    titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.green])
  elseif subType == 27 or subType == 28 then
    titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.gold])
  elseif subType == 29 then
    titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.gold])
  elseif subType == 22 then
    titleStr = string.GetColorText(titleStr, ItemQuality2ColorDic[EItemColorEnum.bBlue])
  end
  return titleStr
end

local function GetOrnamentsLevel()
  local equipData = RoleManager.me.data.equipsData.Data
  local totalLevel = 0
  if equipData and 0 < table.count(equipData) then
    for k, v in pairs(equipData) do
      if v and (k == ERoleEquipPosition.nechushou or k == ERoleEquipPosition.right_ring or k == ERoleEquipPosition.left_ring or k == ERoleEquipPosition.right_Earring or k == ERoleEquipPosition.left_Earring) then
        local level = v.level or 0
        totalLevel = totalLevel + level
      end
    end
  end
  return totalLevel
end

local function IsHaveRelativePositionData(bagGridIndex)
  local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Equip)
  if equipData and table.count(equipData) > 0 then
    for k, v in pairs(equipData) do
      if v and k % 100 == bagGridIndex % 100 and k ~= bagGridIndex then
        return true
      end
    end
  end
  return false
end

local function IsReachIntensifyLevel(equipData, totalLevel)
  local IsReach = true
  local level = 0
  if equipData and 0 < table.count(equipData) then
    for k, v in pairs(equipData) do
      if v and v.intensify then
        level = level + v.intensify
      end
    end
    if totalLevel <= level then
      IsReach = false
    end
  end
  return IsReach
end

local function IsEquipCanOverlap(main, side)
  local isCan = false
  local cfg_table, mExcellence, sExcellence
  if main.tblItem.subType == EItemSubtype.Wing then
    mExcellence = main.wingAttr
    sExcellence = side.wingAttr
  else
    mExcellence = main.excellence
    sExcellence = side.excellence
  end
  if table.count(mExcellence) == main.tblEquip.overlapMax then
    cfg_table = MeEquipController.GetEquipOverlapReplaceCostCfg(main, 0)
  else
    cfg_table = MeEquipController.GetEquipOverlapCostCfg(main)
  end
  if not cfg_table then
    return false
  end
  if table.count(sExcellence) == 0 then
    return isCan
  end
  local mainItemInfo = table.metatableCopy(nil, mExcellence)
  local secondItemInfo = table.metatableCopy(nil, sExcellence)
  if cfg_table.overlapNum == 1 then
    for k, v in pairs(mExcellence) do
      for kk, vv in pairs(secondItemInfo) do
        if v == vv then
          table.remove(secondItemInfo, kk)
        end
      end
    end
    isCan = table.count(secondItemInfo) > 0
  else
    for k, v in pairs(mExcellence) do
      for kk, vv in pairs(secondItemInfo) do
        if v == vv then
          table.remove(secondItemInfo, kk)
        end
      end
    end
    isCan = table.count(secondItemInfo) > 0
    if not isCan then
      for k, v in pairs(sExcellence) do
        local num = 0
        for kk, vv in pairs(mainItemInfo) do
          if v == vv then
            num = num + 1
          end
        end
        if num < cfg_table.overlapNum then
          isCan = true
          break
        end
      end
    end
  end
  return isCan
end

local function EffectOrderLayerSet(go, layer)
  local particles = go.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  if particles then
    for i = 0, particles.Length - 1 do
      local renderer = particles[i].gameObject:GetComponent(typeof(CS.UnityEngine.Renderer))
      if renderer then
        renderer.sortingOrder = layer
      end
    end
  end
end

local function GetCurEquipShowData(appear, data, position)
  local equipData = data[position]
  if string.isNullOrEmpty(appear) then
    return equipData
  end
  local temp = json.decode(appear)
  for i, v in pairs(temp) do
    if data[v] and v % 100 == position % 100 then
      equipData = data[v]
      break
    end
  end
  return equipData
end

local function GetCurPlayerModelName(appear, data, modelScale)
  local defaultName = ERoleModelName.default
  local defaultScale = modelScale and modelScale or PlayerModelDefaultScale
  if string.isNullOrEmpty(appear) then
    return defaultName, defaultScale
  end
  local temp = json.decode(appear)
  for name, v in pairs(temp) do
    if name == "equip_datianshibianshen" then
      return ERoleModelName.datianshibianshen, PlayerModelDefaultScale
    elseif name == "equip_model" and data[v] then
      return data[v].tblEquip.transformation, tonumber(data[v].tblEquip.transformationSize)
    end
  end
  if defaultName == ERoleModelName.default then
    defaultScale = PlayerModelDefaultScale
  end
  return defaultName, defaultScale
end

local function GetCareerHP(hpString, career)
  local nowCareer = career
  if nowCareer == nil then
    if ViewData.meData ~= nil then
      nowCareer = ViewData.meData.career
    else
      return 0
    end
  end
  local hp = 0
  if type(hpString) == "table" then
    for i = 1, #hpString do
      if 1 < #hpString[i] then
        if hpString[i][1] == nowCareer then
          return hpString[i][2]
        end
        if math.fmod(hpString[i][1], 10) == math.fmod(nowCareer, 10) then
          hp = hpString[i][2]
        end
      end
    end
  end
  return hp
end

local function CheckItemCanOverlap(itemData)
  local itemTbl = itemData.tblItem
  if itemTbl == nil or itemTbl.type ~= EItemType.Equipe or itemTbl.subType == EItemSubtype.Guards or itemTbl.subType == EItemSubtype.Mount then
    return false
  end
  local equipTbl = itemData.tblEquip
  if equipTbl == nil then
    return false
  end
  local cellIndex = tonumber(string.split(equipTbl.equipPosition, "#")[1])
  if RoleEquipUtility.EquipTypeUtility(cellIndex, ERoleEquipCondition.Archangel) then
    return false
  end
  if ForgeData.FilterCanUseEquip and RoleEquipUtility.CanUpFight(itemData) == EquipUpState.CantWear then
    return false
  end
  if ForgeData.EquipOverlapMain then
    if ForgeData.EquipOverlapMain.tblEquip.overlap == equipTbl.overlap and ForgeData.EquipOverlapMain.id ~= itemData.id and RoleEquipUtility.IsEquipCanOverlap(ForgeData.EquipOverlapMain, itemData) then
      return true
    end
    if ForgeData.EquipOverlapMain.tblItem.subType == EItemSubtype.Wing and itemTbl.type == EItemType.Material and itemTbl.subType == EItemSubtype.wingOverlap and ForgeData.EquipOverlapMain.tblItem.quality == itemTbl.quality then
      return true
    end
  end
  if equipTbl.overlap ~= 0 then
    return true
  end
  return false
end

local function CheckCanIntensify(itemId)
  if type(itemId) ~= "number" then
    return false
  end
  local itemTbl = ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
  if itemTbl == nil or string.isNullOrEmpty(itemTbl.equipPosition) then
    return false
  end
  local equipPositionList = string.split(itemTbl.equipPosition, "#")
  if #equipPositionList <= 0 then
    return false
  end
  for k, v in pairs(equipPositionList) do
    local position = tonumber(v)
    local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(position)
    if cellTbl ~= nil and cellTbl.intensifyLimit == 1 then
      return true
    end
  end
  return false
end

local function CheckCanZhuiJia(itemId)
  if type(itemId) ~= "number" then
    return false
  end
  local itemTbl = ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
  if itemTbl == nil or string.isNullOrEmpty(itemTbl.equipPosition) then
    return false
  end
  local equipPositionList = string.split(itemTbl.equipPosition, "#")
  if #equipPositionList <= 0 then
    return false
  end
  for k, v in pairs(equipPositionList) do
    local position = tonumber(v)
    local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(position)
    if cellTbl ~= nil and cellTbl.addToLimit == 1 then
      return true
    end
  end
  return false
end

local function CheckRedEquipCanUpGrade()
  local intervalTime, hintDes = ClientTable.cfg_Global_globalManager:GetRedEquipUpGradeConfig()
  if intervalTime == nil or hintDes == nil then
    return true
  end
  if RoleEquipConstantConfig.RedEquipUpGradeRecordTime ~= nil and RoleEquipConstantConfig.RedEquipUpGradeRecordTime + intervalTime > Time.GetServerTime() then
    FloatingTipUtility.QuickMsg(hintDes)
    return false
  end
  RoleEquipConstantConfig.RedEquipUpGradeRecordTime = Time.GetServerTime()
  return true
end

local function GetEquipType(equipTbl)
  if equipTbl == nil then
    return
  end
  local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(equipTbl.id)
  if itemTbl == nil then
    return
  end
  local cellTbl = ClientTable.cfg_EquipCell_cellManager:GetCellTblByPosition(equipTbl.equipPosition)
  if cellTbl.cellType == EquipCellType.NORMAL then
    if itemTbl.type == EItemType.Equipe and (itemTbl.subType == EItemSubtype.Flag or itemTbl.subType == EItemSubtype.Bugle) then
      return EquipType.Normal_FlagOrBugle
    end
    return EquipType.Normal
  elseif cellTbl.cellType == EquipCellType.HONGZHUANG then
    if itemTbl.subType >= EItemSubtype.Suit_Earring and itemTbl.subType <= EItemSubtype.Suit_RingRight then
      return EquipType.HongZhuang_Jewel
    else
      return EquipType.HongZhuang_NoJewel
    end
  end
end

local function GetEquipRegenerateAttribute(attributeInfo)
  if attributeInfo == nil then
    return
  end
  local needAttributeTabList = {}
  local attributeAttrDes
  local excellentLevel = 1
  for i, attributeItem in ipairs(attributeInfo) do
    for i, attrInfo in pairs(attributeItem.RegenerateAttribute) do
      attributeAttrDes = RoleEquipUtility.GetRegenerateAttributeStr({
        attributeName = attrInfo.attributeName,
        value = attrInfo.attributeValue,
        configId = attributeItem.configId
      })
      excellentLevel = ClientTable.cfg_Item_equip_regenerateManager:GetExcellentLevel(attributeItem.configId)
      if not string.isNullOrEmpty(attributeAttrDes) then
        table.insert(needAttributeTabList, {
          attributeInfo = attributeAttrDes,
          configId = attributeItem.configId,
          excellentLevel = excellentLevel
        })
        break
      end
    end
  end
  return needAttributeTabList
end

local function GetRegenerateAttributeStr(attributeData)
  if attributeData == nil then
    return nil
  end
  local attributeStr
  local suffix = "%"
  local convertFormat = ClientTable.cfg_Item_equip_regenerateManager:GetKeyWord(attributeData.configId, "showName")
  if convertFormat == nil or convertFormat == "" then
    logError(attributeData.attributeName .. "Tr\225\187\145ng")
    return nil
  end
  local convertType = ClientTable.cfg_Item_equip_regenerateManager:GetKeyWord(attributeData.configId, "equipConstant")
  if convertType == nil or convertType == "" then
    logError(attributeData.attributeName .. "equipConstant tr\225\187\145ng")
    return nil
  end
  if convertType == EquipAttributeCalculateType.Ratio then
    local integer, decimals = math.modf(attributeData.value * 0.01)
    attributeStr = decimals == 0 and tostring(integer) or tostring(attributeData.value * 0.01)
    local num = tonumber(attributeStr * 100)
    if math.floor(tostring(num):gsub("%.0$", "")) % 100 == 0 then
      attributeStr = attributeStr .. ".00"
    elseif math.floor(tostring(num):gsub("%.0$", "")) % 10 == 0 then
      attributeStr = attributeStr .. "0"
    end
    return string.format(convertFormat, attributeStr, suffix)
  elseif convertType == EquipAttributeCalculateType.Constant then
    attributeStr = attributeData.value
    return string.format(convertFormat, attributeStr, "")
  elseif convertType == EquipAttributeCalculateType.ConstantLevel then
    attributeStr = math.floor(tonumber(attributeData.value))
    return string.format(convertFormat, attributeStr, "")
  else
    logError(attributeData.attributeName .. "\196\144\225\187\139nh d\225\186\161ng chuy\225\187\131n \196\145\225\187\149i kh\195\180ng ph\225\186\163i ph\225\186\167n ch\225\187\165c ngh\195\172n c\197\169ng kh\195\180ng ph\225\186\163i h\225\186\177ng s\225\187\145")
    return nil
  end
end

local function GetEquipattributeStrByTbl(attributeData, wordType)
  if attributeData == nil then
    return nil
  end
  local attributeStr
  local suffix = "%"
  local convertFormat = ClientTable.cfg_Ui_word_attributeManager:GetKeyWord(attributeData.attributeName, wordType)
  if convertFormat == nil or convertFormat == "" then
    logError(attributeData.attributeName .. "Tr\225\187\145ng")
    return nil
  end
  local convertType = ClientTable.cfg_Ui_word_attributeManager:GetKeyWord(attributeData.attributeName, "equipConstant")
  if convertType == nil or convertType == "" then
    logError(attributeData.attributeName .. "equipConstant tr\225\187\145ng")
    return nil
  end
  if convertType == EquipAttributeCalculateType.Ratio then
    local integer, decimals = math.modf(attributeData.value * 0.01)
    attributeStr = decimals == 0 and tostring(integer) or tostring(attributeData.value * 0.01)
    return string.format(convertFormat, attributeStr, suffix)
  elseif convertType == EquipAttributeCalculateType.Constant then
    attributeStr = attributeData.value
    return string.format(convertFormat, attributeStr, "")
  elseif convertType == EquipAttributeCalculateType.ConstantLevel then
    attributeStr = math.floor(tonumber(attributeData.value))
    return string.format(convertFormat, attributeStr, "")
  else
    logError(attributeData.attributeName .. "\196\144\225\187\139nh d\225\186\161ng chuy\225\187\131n \196\145\225\187\149i kh\195\180ng ph\225\186\163i ph\225\186\167n ch\225\187\165c ngh\195\172n c\197\169ng kh\195\180ng ph\225\186\163i h\225\186\177ng s\225\187\145")
    return nil
  end
end

local function IsShowEquipIndexObjByCarrer(pos, isSuit, career)
  local basicCareer
  if career then
    basicCareer = RoleUtility.GetBasicCareer(career)
  else
    basicCareer = RoleManager.me and RoleUtility.GetBasicCareer(RoleManager.me.career)
  end
  local isMeetCareer = basicCareer == ERoleCareer.SpellSword
  if pos == ERoleEquipPosition.helm then
    if isMeetCareer then
      return isSuit
    end
  elseif pos == ERoleEquipPosition.cloak then
    if isMeetCareer then
      return isSuit
    else
      return false
    end
  end
  return true
end

local function IsRecommendEquipByCareer(itemId, career)
  if type(itemId) ~= "number" or type(career) ~= "number" then
    return false
  end
  local configRecommendCareer = ClientTable.cfg_Item_itemManager:GetRecommendCareerList(itemId)
  if configRecommendCareer == nil or next(configRecommendCareer) == nil then
    return true
  end
  local baseCareer = Mathf.Floor(career * 0.1)
  for k, v in pairs(configRecommendCareer) do
    if v == career or v == baseCareer then
      return true
    end
  end
  return false
end

RoleEquipUtility = {
  GetAttachModelParent = GetAttachModelParent,
  GetWeaponSubtype = GetWeaponSubtype,
  GetEquipModelName = GetEquipModelName,
  GetEquipObjPosandScale = GetEquipObjPosandScale,
  GetEquipNameByIndex = GetEquipNameByIndex,
  GetEquipIndexByName = GetEquipIndexByName,
  GetEquipUIModelName = GetEquipUIModelName,
  EquipModelRotation = EquipModelRotation,
  GetEquipAtttribute = GetEquipAtttribute,
  GetEquipStoneLight = GetEquipStoneLight,
  GetEquipStoneFirstAttri = GetEquipStoneFirstAttri,
  GetEquipStoneCombination = GetEquipStoneCombination,
  GetStoneAllTypeTbl = GetStoneAllTypeTbl,
  GetSingleConditionIsOk = GetSingleConditionIsOk,
  GetStoneCombinIsActivate = GetStoneCombinIsActivate,
  GetStoneEquipPos = GetStoneEquipPos,
  GetStoneCellIsOpen = GetStoneCellIsOpen,
  GetEquipExcellence = GetEquipExcellence,
  JobUseItem = JobUseItem,
  CheckUseItem = CheckUseItem,
  UIManagerShow = UIManagerShow,
  WearEquipIndex = WearEquipIndex,
  OnWearEquip = OnWearEquip,
  CanUpFight = CanUpFight,
  GetCareerModelData = GetCareerModelData,
  integerAttribute = integerAttribute,
  percentageAttribute = percentageAttribute,
  thousandDivide = thousandDivide,
  equipObj2BodyPos = equipObj2BodyPos,
  WearWeaponsJudge = WearWeaponsJudge,
  WearWeaponsCondition = WearWeaponsCondition,
  EquipTypeUtility = EquipTypeUtility,
  GetConditionEquipData = GetConditionEquipData,
  IsEquipAppearData = IsEquipAppearData,
  DefaultShowAppearEquip = DefaultShowAppearEquip,
  UpdateAppearSaveData = UpdateAppearSaveData,
  UpdatePlayerAppearData = UpdatePlayerAppearData,
  IsVipEquipData = IsVipEquipData,
  GetExcellenceShowById = GetExcellenceShowById,
  IsHaveAutoPickEquip = IsHaveAutoPickEquip,
  GetEquipNameColor = GetEquipNameColor,
  GetOrnamentsLevel = GetOrnamentsLevel,
  IsHaveRelativePositionData = IsHaveRelativePositionData,
  IsReachIntensifyLevel = IsReachIntensifyLevel,
  IsEquipCanOverlap = IsEquipCanOverlap,
  EffectOrderLayerSet = EffectOrderLayerSet,
  GetCurEquipShowData = GetCurEquipShowData,
  GetCurPlayerModelName = GetCurPlayerModelName,
  GetCareerHP = GetCareerHP,
  CheckItemCanOverlap = CheckItemCanOverlap,
  CheckCareerEquip = CheckCareerEquip,
  CheckCanIntensify = CheckCanIntensify,
  CheckCanZhuiJia = CheckCanZhuiJia,
  GetExcellenceTbl = GetExcellenceTbl,
  CheckRedEquipCanUpGrade = CheckRedEquipCanUpGrade,
  GetEquipExcellenceDesByServerInfo = GetEquipExcellenceDesByServerInfo,
  GetEquipExcellenceStrByTbl = GetEquipExcellenceStrByTbl,
  GetEquipExcellenceByServerInfo = GetEquipExcellenceByServerInfo,
  GetEquipType = GetEquipType,
  GetEquipattributeStrByTbl = GetEquipattributeStrByTbl,
  GetEquipRegenerateAttribute = GetEquipRegenerateAttribute,
  RegenerateEquipInfo = RegenerateEquipInfo,
  GetRegenerateAttributeStr = GetRegenerateAttributeStr,
  IsShowEquipIndexObjByCarrer = IsShowEquipIndexObjByCarrer,
  IsRecommendEquipByCareer = IsRecommendEquipByCareer,
  IsDotShowAppearData = IsDotShowAppearData,
  GetWearEquipPosition = GetWearEquipPosition,
  IsAppearByCellType = IsAppearByCellType
}
