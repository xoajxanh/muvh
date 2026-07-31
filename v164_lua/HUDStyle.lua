HUDTitleStyle = {
  PlayerName = enum(0),
  Blood = enum(),
  TeamIcon = enum(),
  MonsterName = enum(),
  GoldMonsterName = enum()
}
HUDBloodType = {
  Blood_None = enum(0),
  Blood_Red = enum(),
  Blood_Green = enum(),
  Blood_Blue = enum()
}
HUDSettingRotationXYZ = {
  X = 42,
  Y = -45,
  Z = 0
}
HUDSetting = {
  Rotation = CS.UnityEngine.Quaternion.Euler(HUDSettingRotationXYZ.X, HUDSettingRotationXYZ.Y, HUDSettingRotationXYZ.Z),
  YOffset = 2,
  IconInitY = 0.7,
  LabelCountDown = 0.4,
  Sprites = {
    siege_atk = {res = "siege_atk", height = 0.56},
    siege_atkBig = {
      res = "siege_atkBig",
      height = 0.56
    },
    siege_def = {res = "siege_def", height = 0.56},
    siege_defBig = {
      res = "siege_defBig",
      height = 0.56
    },
    first_ad = {res = "900010041", height = 0.6},
    first_f = {res = "90001004", height = 0.6},
    first_z = {res = "90001003", height = 0.6},
    king = {res = "900010071", height = 0.6},
    monopoly = {res = "900010061", height = 0.6},
    kill_king = {res = "90001006", height = 0.6},
    roland_king = {res = "90001007", height = 0.6},
    qiJiComing = {res = "90001008", height = 0.6},
    yongShiComing = {res = "90001009", height = 0.6},
    qiJiGoodMan = {res = "90001010", height = 0.6},
    dafuweng = {res = "900010061", height = 0.6},
    yonghengzhidian = {res = "90001017", height = 0.6},
    Blood_Red = {res = "blood_red2", height = 0.1},
    Blood_Red_Layer2 = {res = "blood_red2", height = 0.1},
    Blood_Green = {
      res = "blood_green",
      height = 0.1
    },
    Blood_Green_Layer2 = {res = "blood_red4", height = 0.1},
    Blood_Bg = {res = "black", height = 0.1},
    Blood_Yellow = {
      res = "ArmorYellow",
      height = 0.1
    }
  },
  NameColor = {
    PlayerName = Color.New(1, 1, 1, 1),
    MonsterName = Color.New(1, 0.137, 0.137, 1),
    GoldMonsterName = Color.New(1, 0.839, 0.086, 1)
  }
}
