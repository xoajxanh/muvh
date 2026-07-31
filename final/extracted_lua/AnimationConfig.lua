DEFAULT_ANIMATION = "idle"
DEFAULT_WEAPON_PREFIX = nil
local WrapMode = CS.UnityEngine.WrapMode
BaseAnimationConfig = {
  idle = {
    layer = 0,
    speed = 0.1,
    loop = true,
    fadeLength = 0.3
  },
  showstand = {
    layer = 0,
    speed = 0.1,
    loop = true,
    fadeLength = 0.3
  },
  walk = {
    layer = 0,
    speed = 0.27,
    loop = true,
    fadeLength = 0
  },
  run = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  dead = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  alive = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  swim = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  FastSwim = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  swimidle = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  sit = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  AllSit = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  leanOn = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  flyUp = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  OneHand_idle = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  OneHand_walk = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  OneHand_run = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  TSword_idle = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  TSword_walk = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  TSword_run = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Spear_idle = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Spear_walk = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Spear_run = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  TStaff_idle = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  TStaff_walk = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  TStaff_run = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Bow_idle = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Bow_walk = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Bow_run = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Crossbow_idle = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Crossbow_walk = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Crossbow_run = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Dweapon_idle = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Dweapon_walk = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Dweapon_run = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  },
  Wing_Bow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Bow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Bow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Crossbow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Crossbow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Crossbow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Dweapon_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Dweapon_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Dweapon_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_OneHand_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_OneHand_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_OneHand_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Spear_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Spear_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Spear_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TStaff_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TStaff_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TStaff_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TSword_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TSword_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TSword_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Wing_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Bow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Bow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Bow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Crossbow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Crossbow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Crossbow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Dweapon_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Dweapon_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Dweapon_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_OneHand_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_OneHand_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_OneHand_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Spear_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Spear_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Spear_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TStaff_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TStaff_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TStaff_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TSword_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TSword_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TSword_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Bow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Bow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Bow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Crossbow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Crossbow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Crossbow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Dweapon_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Dweapon_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Dweapon_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_OneHand_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_OneHand_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_OneHand_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Spear_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Spear_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Spear_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TStaff_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TStaff_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TStaff_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TSword_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TSword_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TSword_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Bow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Bow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Bow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Crossbow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Crossbow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Crossbow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Spear_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Spear_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Spear_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TSword_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TSword_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TSword_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Bow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Bow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Bow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Crossbow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Crossbow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Crossbow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Spear_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Spear_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Spear_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TSword_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TSword_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TSword_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Bow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Bow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Bow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Crossbow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Crossbow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Crossbow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Spear_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Spear_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Spear_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TSword_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TSword_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TSword_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Bow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Bow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Bow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Crossbow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Crossbow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Crossbow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Spear_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Spear_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Spear_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TSword_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TSword_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TSword_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Bow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Bow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Bow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Crossbow_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Crossbow_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Crossbow_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Dweapon_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Dweapon_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Dweapon_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_OneHand_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_OneHand_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_OneHand_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Spear_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Spear_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Spear_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TStaff_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TStaff_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TStaff_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TSword_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TSword_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TSword_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_idle = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_walk = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_run = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  attack = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  attack2 = {
    layer = 0,
    speed = 0.7,
    loop = false,
    fadeLength = 0.3
  },
  attack3 = {
    layer = 0,
    speed = 0.7,
    loop = true,
    fadeLength = 0.3
  }
}
setmetatable(BaseAnimationConfig, {
  __index = function()
    return {
      layer = 0,
      speed = 0.7,
      loop = false,
      fadeLength = 0.3
    }
  end
})
AttackAnimationConfig = {
  attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  TSword_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TSword_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TSword_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TSword_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TSword_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TSword_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TSword_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TSword_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TSword_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_TSword_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  TSword_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TSword_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TSword_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TSword_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TSword_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TSword_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TSword_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TSword_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TSword_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_TSword_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  TSword_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TSword_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TSword_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TSword_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TSword_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TSword_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TSword_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TSword_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TSword_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_TSword_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  OneHand_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_OneHand_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_OneHand_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_OneHand_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_OneHand_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_OneHand_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  TStaff_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TStaff_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TStaff_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TStaff_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TStaff_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_TStaff_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Dweapon_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Dweapon_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Dweapon_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Dweapon_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Dweapon_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Dweapon_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  OneHand_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_OneHand_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_OneHand_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_OneHand_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_OneHand_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_OneHand_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  TStaff_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TStaff_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TStaff_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TStaff_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TStaff_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_TStaff_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Dweapon_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Dweapon_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Dweapon_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Dweapon_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Dweapon_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Dweapon_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  OneHand_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_OneHand_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_OneHand_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_OneHand_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_OneHand_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_OneHand_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  TStaff_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TStaff_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TStaff_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TStaff_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TStaff_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_TStaff_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Dweapon_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Dweapon_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Dweapon_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Dweapon_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Dweapon_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Dweapon_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  OneHand_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_OneHand_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_OneHand_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_OneHand_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_OneHand_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_OneHand_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  TStaff_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TStaff_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TStaff_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TStaff_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TStaff_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_TStaff_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Dweapon_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Dweapon_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Dweapon_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Dweapon_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Dweapon_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Dweapon_attack04 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Spear_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Spear_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Spear_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Spear_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Spear_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Spear_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Spear_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Spear_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Spear_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Spear_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Spear_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Spear_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Spear_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Spear_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Spear_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Spear_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Spear_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Spear_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Spear_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Spear_attack02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Spear_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Spear_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Spear_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Spear_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Spear_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Spear_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Spear_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Spear_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Spear_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Spear_attack03 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Bow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Bow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Bow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Bow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Bow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Bow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Bow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Bow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Bow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Bow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Crossbow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Crossbow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Crossbow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Crossbow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Crossbow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Crossbow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Crossbow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Crossbow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Crossbow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Crossbow_attack01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  shenglongji = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  diliezhan = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  xuanfengzhan = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  yatuci = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  tiandishizijian01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  tiandishizijian02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  shengdunfangyu = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  pilihuixuanzhan = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TSword_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TSword_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TSword_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TSword_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Spear_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Spear_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Spear_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Spear_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Bow_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Bow_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Bow_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Bow_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Crossbow_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Crossbow_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Crossbow_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Crossbow_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_zuanyunqiang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  liuxingyan = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  shengmingzhiguang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  xifengci = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  leitinglieshan = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  zhimingyiji = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  banyuezhan = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_OneHand_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_OneHand_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_OneHand_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TSword_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TSword_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TSword_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TSword_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TSword_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TSword_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TSword_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Spear_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Spear_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Spear_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Spear_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Spear_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Spear_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Spear_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TStaff_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TStaff_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TStaff_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Bow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Bow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Bow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Bow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Bow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Bow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Bow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Crossbow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Crossbow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Crossbow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Crossbow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Crossbow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Crossbow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Crossbow_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Dweapon_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Dweapon_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Dweapon_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_nengliangqiu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_OneHand_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_OneHand_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_OneHand_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TSword_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TSword_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TSword_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TSword_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TSword_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TSword_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TSword_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Spear_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Spear_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Spear_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Spear_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Spear_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Spear_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Spear_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TStaff_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TStaff_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TStaff_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Bow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Bow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Bow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Bow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Bow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Bow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Bow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Crossbow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Crossbow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Crossbow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Crossbow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Crossbow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Crossbow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Crossbow_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Dweapon_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Dweapon_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Dweapon_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_nengliangqiu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  shunjianyidong = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  diyuhuo = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  jiguang = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  huimielieyan = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  xingchenyinu02 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  xingchenyinu01 = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  fashenfuti = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_OneHand_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_OneHand_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_OneHand_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_OneHand_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_OneHand_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TSword_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TSword_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TSword_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TSword_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TSword_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TSword_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TSword_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TSword_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_TSword_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Spear_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Spear_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Spear_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Spear_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Spear_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Spear_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Spear_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Spear_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Spear_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TStaff_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TStaff_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TStaff_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_TStaff_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_TStaff_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Bow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Bow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Bow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Bow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Bow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Bow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Bow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Bow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Bow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Crossbow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Crossbow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Crossbow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Crossbow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Crossbow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Crossbow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Crossbow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Crossbow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Crossbow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Crossbow_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Dweapon_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Dweapon_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Dweapon_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Wing_Dweapon_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Swim_Dweapon_duochongjian = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_OneHand_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_OneHand_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_OneHand_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_OneHand_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_OneHand_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_OneHand_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_OneHand_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TSword_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TSword_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TSword_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TSword_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TSword_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TSword_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TSword_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Spear_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Spear_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Spear_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Spear_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Spear_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Spear_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Spear_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_TStaff_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_TStaff_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_TStaff_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_TStaff_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_TStaff_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_TStaff_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_TStaff_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Bow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Bow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Bow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Bow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Bow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Bow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Bow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Crossbow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Crossbow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Crossbow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Crossbow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Crossbow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Crossbow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Crossbow_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider01_Dweapon_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Rider02_Dweapon_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  DarkHorse_Dweapon_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblack_Dweapon_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilblue_Dweapon_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilgold_Dweapon_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  },
  Fenrilred_Dweapon_zhiliao = {
    layer = 0,
    speed = 0.2,
    loop = false,
    fadeLength = 0.3
  }
}
setmetatable(AttackAnimationConfig, {
  __index = function()
    return {
      layer = 0,
      speed = 0.2,
      loop = false,
      fadeLength = 0.3
    }
  end
})
BasicMoveSpeedConfig = {run = 4}
AnimationNameConfig = {
  NoMount_NoWing_NoSwim_NoWeapon_idle = "idle",
  NoMount_NoWing_NoSwim_NoWeapon_walk = "walk",
  NoMount_NoWing_NoSwim_NoWeapon_run = "run",
  NoMount_NoWing_NoSwim_OneHand_idle = "OneHand_idle",
  NoMount_NoWing_NoSwim_OneHand_walk = "OneHand_walk",
  NoMount_NoWing_NoSwim_OneHand_run = "OneHand_run",
  NoMount_NoWing_NoSwim_TSword_idle = "TSword_idle",
  NoMount_NoWing_NoSwim_TSword_walk = "TSword_walk",
  NoMount_NoWing_NoSwim_TSword_run = "TSword_run",
  NoMount_NoWing_NoSwim_Spear_idle = "Spear_idle",
  NoMount_NoWing_NoSwim_Spear_walk = "Spear_walk",
  NoMount_NoWing_NoSwim_Spear_run = "Spear_run",
  NoMount_NoWing_NoSwim_TStaff_idle = "TStaff_idle",
  NoMount_NoWing_NoSwim_TStaff_walk = "TStaff_walk",
  NoMount_NoWing_NoSwim_TStaff_run = "TStaff_run",
  NoMount_NoWing_NoSwim_Bow_idle = "Bow_idle",
  NoMount_NoWing_NoSwim_Bow_walk = "Bow_walk",
  NoMount_NoWing_NoSwim_Bow_run = "Bow_run",
  NoMount_NoWing_NoSwim_Crossbow_idle = "Crossbow_idle",
  NoMount_NoWing_NoSwim_Crossbow_walk = "Crossbow_walk",
  NoMount_NoWing_NoSwim_Crossbow_run = "Crossbow_run",
  NoMount_NoWing_NoSwim_Dweapon_idle = "Dweapon_idle",
  NoMount_NoWing_NoSwim_Dweapon_walk = "Dweapon_walk",
  NoMount_NoWing_NoSwim_Dweapon_run = "Dweapon_run",
  NoMount_NoWing_Swim_NoWeapon_idle = "swimidle",
  NoMount_NoWing_Swim_NoWeapon_walk = "swim",
  NoMount_NoWing_Swim_NoWeapon_run = "fastswim",
  NoMount_NoWing_Swim_OneHand_idle = "swimidle",
  NoMount_NoWing_Swim_OneHand_walk = "swim",
  NoMount_NoWing_Swim_OneHand_run = "fastswim",
  NoMount_NoWing_Swim_TSword_idle = "swimidle",
  NoMount_NoWing_Swim_TSword_walk = "swim",
  NoMount_NoWing_Swim_TSword_run = "fastswim",
  NoMount_NoWing_Swim_Spear_idle = "swimidle",
  NoMount_NoWing_Swim_Spear_walk = "swim",
  NoMount_NoWing_Swim_Spear_run = "fastswim",
  NoMount_NoWing_Swim_TStaff_idle = "swimidle",
  NoMount_NoWing_Swim_TStaff_walk = "swim",
  NoMount_NoWing_Swim_TStaff_run = "fastswim",
  NoMount_NoWing_Swim_Bow_idle = "swimidle",
  NoMount_NoWing_Swim_Bow_walk = "swim",
  NoMount_NoWing_Swim_Bow_run = "fastswim",
  NoMount_NoWing_Swim_Crossbow_idle = "Wing_Crossbow_idle",
  NoMount_NoWing_Swim_Crossbow_walk = "swim",
  NoMount_NoWing_Swim_Crossbow_run = "fastswim",
  NoMount_NoWing_Swim_Dweapon_idle = "swimidle",
  NoMount_NoWing_Swim_Dweapon_walk = "swim",
  NoMount_NoWing_Swim_Dweapon_run = "fastswim",
  NoMount_Wing_NoWeapon_idle = "Wing_idle",
  NoMount_Wing_NoWeapon_walk = "Wing_run",
  NoMount_Wing_NoWeapon_run = "Wing_run",
  NoMount_Wing_OneHand_idle = "Wing_idle",
  NoMount_Wing_OneHand_walk = "Wing_run",
  NoMount_Wing_OneHand_run = "Wing_run",
  NoMount_Wing_TSword_idle = "Wing_idle",
  NoMount_Wing_TSword_walk = "Wing_run",
  NoMount_Wing_TSword_run = "Wing_run",
  NoMount_Wing_Spear_idle = "Wing_idle",
  NoMount_Wing_Spear_walk = "Wing_run",
  NoMount_Wing_Spear_run = "Wing_run",
  NoMount_Wing_TStaff_idle = "Wing_idle",
  NoMount_Wing_TStaff_walk = "Wing_run",
  NoMount_Wing_TStaff_run = "Wing_run",
  NoMount_Wing_Bow_idle = "Wing_idle",
  NoMount_Wing_Bow_walk = "Wing_run",
  NoMount_Wing_Bow_run = "Wing_run",
  NoMount_Wing_Crossbow_idle = "Wing_Crossbow_idle",
  NoMount_Wing_Crossbow_walk = "Wing_Crossbow_run",
  NoMount_Wing_Crossbow_run = "Wing_Crossbow_run",
  NoMount_Wing_Dweapon_idle = "Wing_idle",
  NoMount_Wing_Dweapon_walk = "Wing_run",
  NoMount_Wing_Dweapon_run = "Wing_run",
  Rider02_AllWeapon_idle = "Rider_AllWeapon_idle",
  Rider02_AllWeapon_walk = "Rider_AllWeapon_run",
  Rider02_AllWeapon_run = "Rider_AllWeapon_run",
  Rider02_NoWeapon_idle = "Rider_idle",
  Rider02_NoWeapon_walk = "Rider_run",
  Rider02_NoWeapon_run = "Rider_run",
  Rider01_AllWeapon_idle = "Rider_AllWeapon_idle",
  Rider01_AllWeapon_walk = "Rider_AllWeapon_run",
  Rider01_AllWeapon_run = "Rider_AllWeapon_run",
  Rider01_NoWeapon_idle = "Rider_idle",
  Rider01_NoWeapon_walk = "Rider_run",
  Rider01_NoWeapon_run = "Rider_run",
  Fenrilred_NoWeapon_idle = "Fenril_idle",
  Fenrilred_NoWeapon_walk = "Fenril_walk",
  Fenrilred_NoWeapon_run = "Fenril_run",
  Fenrilred_OneHand_idle = "Fenril_OneHand_idle",
  Fenrilred_OneHand_walk = "Fenril_OneHand_walk",
  Fenrilred_OneHand_run = "Fenril_OneHand_run",
  Fenrilred_TSword_idle = "Fenril_OneHand_idle",
  Fenrilred_TSword_walk = "Fenril_OneHand_walk",
  Fenrilred_TSword_run = "Fenril_OneHand_run",
  Fenrilred_Spear_idle = "Fenril_OneHand_idle",
  Fenrilred_Spear_walk = "Fenril_OneHand_walk",
  Fenrilred_Spear_run = "Fenril_OneHand_run",
  Fenrilred_TStaff_idle = "Fenril_OneHand_idle",
  Fenrilred_TStaff_walk = "Fenril_OneHand_walk",
  Fenrilred_TStaff_run = "Fenril_OneHand_run",
  Fenrilred_Bow_idle = "Fenril_Bow_idle",
  Fenrilred_Bow_walk = "Fenril_Bow_walk",
  Fenrilred_Bow_run = "Fenril_Bow_run",
  Fenrilred_Crossbow_idle = "Fenril_OneHand_idle",
  Fenrilred_Crossbow_walk = "Fenril_OneHand_walk",
  Fenrilred_Crossbow_run = "Fenril_OneHand_run",
  Fenrilred_Dweapon_idle = "Fenril_Dweapon_idle",
  Fenrilred_Dweapon_walk = "Fenril_Dweapon_walk",
  Fenrilred_Dweapon_run = "Fenril_Dweapon_run",
  Fenrilgold_NoWeapon_idle = "Fenril_idle",
  Fenrilgold_NoWeapon_walk = "Fenril_walk",
  Fenrilgold_NoWeapon_run = "Fenril_run",
  Fenrilgold_OneHand_idle = "Fenril_OneHand_idle",
  Fenrilgold_OneHand_walk = "Fenril_OneHand_walk",
  Fenrilgold_OneHand_run = "Fenril_OneHand_run",
  Fenrilgold_TSword_idle = "Fenril_OneHand_idle",
  Fenrilgold_TSword_walk = "Fenril_OneHand_walk",
  Fenrilgold_TSword_run = "Fenril_OneHand_run",
  Fenrilgold_Spear_idle = "Fenril_OneHand_idle",
  Fenrilgold_Spear_walk = "Fenril_OneHand_walk",
  Fenrilgold_Spear_run = "Fenril_OneHand_run",
  Fenrilgold_TStaff_idle = "Fenril_OneHand_idle",
  Fenrilgold_TStaff_walk = "Fenril_OneHand_walk",
  Fenrilgold_TStaff_run = "Fenril_OneHand_run",
  Fenrilgold_Bow_idle = "Fenril_Bow_idle",
  Fenrilgold_Bow_walk = "Fenril_Bow_walk",
  Fenrilgold_Bow_run = "Fenril_Bow_run",
  Fenrilgold_Crossbow_idle = "Fenril_OneHand_idle",
  Fenrilgold_Crossbow_walk = "Fenril_OneHand_walk",
  Fenrilgold_Crossbow_run = "Fenril_OneHand_run",
  Fenrilgold_Dweapon_idle = "Fenril_Dweapon_idle",
  Fenrilgold_Dweapon_walk = "Fenril_Dweapon_walk",
  Fenrilgold_Dweapon_run = "Fenril_Dweapon_run",
  Fenrilblue_NoWeapon_idle = "Fenril_idle",
  Fenrilblue_NoWeapon_walk = "Fenril_walk",
  Fenrilblue_NoWeapon_run = "Fenril_run",
  Fenrilblue_OneHand_idle = "Fenril_OneHand_idle",
  Fenrilblue_OneHand_walk = "Fenril_OneHand_walk",
  Fenrilblue_OneHand_run = "Fenril_OneHand_run",
  Fenrilblue_TSword_idle = "Fenril_OneHand_idle",
  Fenrilblue_TSword_walk = "Fenril_OneHand_walk",
  Fenrilblue_TSword_run = "Fenril_OneHand_run",
  Fenrilblue_Spear_idle = "Fenril_OneHand_idle",
  Fenrilblue_Spear_walk = "Fenril_OneHand_walk",
  Fenrilblue_Spear_run = "Fenril_OneHand_run",
  Fenrilblue_TStaff_idle = "Fenril_OneHand_idle",
  Fenrilblue_TStaff_walk = "Fenril_OneHand_walk",
  Fenrilblue_TStaff_run = "Fenril_OneHand_run",
  Fenrilblue_Bow_idle = "Fenril_Bow_idle",
  Fenrilblue_Bow_walk = "Fenril_Bow_walk",
  Fenrilblue_Bow_run = "Fenril_Bow_run",
  Fenrilblue_Crossbow_idle = "Fenril_OneHand_idle",
  Fenrilblue_Crossbow_walk = "Fenril_OneHand_walk",
  Fenrilblue_Crossbow_run = "Fenril_OneHand_run",
  Fenrilblue_Dweapon_idle = "Fenril_Dweapon_idle",
  Fenrilblue_Dweapon_walk = "Fenril_Dweapon_walk",
  Fenrilblue_Dweapon_run = "Fenril_Dweapon_run",
  Fenrilblack_NoWeapon_idle = "Fenril_idle",
  Fenrilblack_NoWeapon_walk = "Fenril_walk",
  Fenrilblack_NoWeapon_run = "Fenril_run",
  Fenrilblack_OneHand_idle = "Fenril_OneHand_idle",
  Fenrilblack_OneHand_walk = "Fenril_OneHand_walk",
  Fenrilblack_OneHand_run = "Fenril_OneHand_run",
  Fenrilblack_TSword_idle = "Fenril_OneHand_idle",
  Fenrilblack_TSword_walk = "Fenril_OneHand_walk",
  Fenrilblack_TSword_run = "Fenril_OneHand_run",
  Fenrilblack_Spear_idle = "Fenril_OneHand_idle",
  Fenrilblack_Spear_walk = "Fenril_OneHand_walk",
  Fenrilblack_Spear_run = "Fenril_OneHand_run",
  Fenrilblack_TStaff_idle = "Fenril_OneHand_idle",
  Fenrilblack_TStaff_walk = "Fenril_OneHand_walk",
  Fenrilblack_TStaff_run = "Fenril_OneHand_run",
  Fenrilblack_Bow_idle = "Fenril_Bow_idle",
  Fenrilblack_Bow_walk = "Fenril_Bow_walk",
  Fenrilblack_Bow_run = "Fenril_Bow_run",
  Fenrilblack_Crossbow_idle = "Fenril_OneHand_idle",
  Fenrilblack_Crossbow_walk = "Fenril_OneHand_walk",
  Fenrilblack_Crossbow_run = "Fenril_OneHand_run",
  Fenrilblack_Dweapon_idle = "Fenril_Dweapon_idle",
  Fenrilblack_Dweapon_walk = "Fenril_Dweapon_walk",
  Fenrilblack_Dweapon_run = "Fenril_Dweapon_run",
  DarkHorse_NoWeapon_idle = "Fenril_idle",
  DarkHorse_NoWeapon_walk = "Fenril_walk",
  DarkHorse_NoWeapon_run = "Fenril_run",
  DarkHorse_OneHand_idle = "Fenril_OneHand_idle",
  DarkHorse_OneHand_walk = "Fenril_OneHand_walk",
  DarkHorse_OneHand_run = "Fenril_OneHand_run",
  DarkHorse_TSword_idle = "Fenril_OneHand_idle",
  DarkHorse_TSword_walk = "Fenril_OneHand_walk",
  DarkHorse_TSword_run = "Fenril_OneHand_run",
  DarkHorse_Spear_idle = "Fenril_OneHand_idle",
  DarkHorse_Spear_walk = "Fenril_OneHand_walk",
  DarkHorse_Spear_run = "Fenril_OneHand_run",
  DarkHorse_TStaff_idle = "Fenril_OneHand_idle",
  DarkHorse_TStaff_walk = "Fenril_OneHand_walk",
  DarkHorse_TStaff_run = "Fenril_OneHand_run",
  DarkHorse_Bow_idle = "Fenril_Bow_idle",
  DarkHorse_Bow_walk = "Fenril_Bow_walk",
  DarkHorse_Bow_run = "Fenril_Bow_run",
  DarkHorse_Crossbow_idle = "Fenril_OneHand_idle",
  DarkHorse_Crossbow_walk = "Fenril_OneHand_walk",
  DarkHorse_Crossbow_run = "Fenril_OneHand_run",
  DarkHorse_Dweapon_idle = "Fenril_Dweapon_idle",
  DarkHorse_Dweapon_walk = "Fenril_Dweapon_walk",
  DarkHorse_Dweapon_run = "Fenril_Dweapon_run",
  NoMount_NoWing_NoWeapon_swimidle = "swimidle",
  NoMount_NoWing_NoWeapon_swim = "swim",
  NoMount_NoWing_NoWeapon_fastswim = "fastswim",
  NoMount_NoWing_OneHand_swimidle = "swimidle",
  NoMount_NoWing_OneHand_swim = "swim",
  NoMount_NoWing_OneHand_fastswim = "fastswim",
  NoMount_NoWing_TSword_swimidle = "swimidle",
  NoMount_NoWing_TSword_swim = "swim",
  NoMount_NoWing_TSword_fastswim = "fastswim",
  NoMount_NoWing_Spear_swimidle = "swimidle",
  NoMount_NoWing_Spear_swim = "swim",
  NoMount_NoWing_Spear_fastswim = "fastswim",
  NoMount_NoWing_TStaff_swimidle = "swimidle",
  NoMount_NoWing_TStaff_swim = "swim",
  NoMount_NoWing_TStaff_fastswim = "fastswim",
  NoMount_NoWing_Bow_swimidle = "swimidle",
  NoMount_NoWing_Bow_swim = "swim",
  NoMount_NoWing_Bow_fastswim = "fastswim",
  NoMount_NoWing_Crossbow_swimidle = "Wing_Crossbow_idle",
  NoMount_NoWing_Crossbow_swim = "swim",
  NoMount_NoWing_Crossbow_fastswim = "fastswim",
  NoMount_NoWing_Dweapon_swimidle = "swimidle",
  NoMount_NoWing_Dweapon_swim = "swim",
  NoMount_NoWing_Dweapon_fastswim = "fastswim",
  sit = "sit",
  allSit = "allSit",
  leanOn = "leanOn",
  flyUp = "flyUp",
  showstand = "showstand",
  dead = "dead",
  alive = "alive",
  NoMount_NoWing_NoSwim_NoWeapon_attack01 = "attack01",
  Rider01_NoWeapon_attack01 = "Rider01_attack01",
  Rider02_NoWeapon_attack01 = "Rider01_attack01",
  DarkHorse_NoWeapon_attack01 = "DarkHorse_attack01",
  Fenrilblack_NoWeapon_attack01 = "Fenrilblack_attack01",
  Fenrilblue_NoWeapon_attack01 = "Fenrilblack_attack01",
  Fenrilgold_NoWeapon_attack01 = "Fenrilblack_attack01",
  Fenrilred_NoWeapon_attack01 = "Fenrilblack_attack01",
  NoMount_Wing_NoWeapon_attack01 = "attack01",
  NoMount_NoWing_Swim_NoWeapon_attack01 = "attack01",
  NoMount_NoWing_NoSwim_TSword_attack01 = "TSword_attack01",
  Rider01_TSword_attack01 = "Rider01_TSword_attack01",
  Rider02_TSword_attack01 = "Rider01_TSword_attack01",
  DarkHorse_TSword_attack01 = "DarkHorse_attack01",
  Fenrilblack_TSword_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilblue_TSword_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilgold_TSword_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilred_TSword_attack01 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_TSword_attack01 = "TSword_attack01",
  NoMount_NoWing_Swim_TSword_attack01 = "TSword_attack01",
  NoMount_NoWing_NoSwim_TSword_attack02 = "TSword_attack02",
  Rider01_TSword_attack02 = "Rider01_TSword_attack01",
  Rider02_TSword_attack02 = "Rider01_TSword_attack01",
  DarkHorse_TSword_attack02 = "DarkHorse_attack01",
  Fenrilblack_TSword_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilblue_TSword_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilgold_TSword_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilred_TSword_attack02 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_TSword_attack02 = "TSword_attack02",
  NoMount_NoWing_Swim_TSword_attack02 = "TSword_attack02",
  NoMount_NoWing_NoSwim_TSword_attack03 = "TSword_attack03",
  Rider01_TSword_attack03 = "Rider01_TSword_attack01",
  Rider02_TSword_attack03 = "Rider01_TSword_attack01",
  DarkHorse_TSword_attack03 = "DarkHorse_attack01",
  Fenrilblack_TSword_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilblue_TSword_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilgold_TSword_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilred_TSword_attack03 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_TSword_attack03 = "TSword_attack03",
  NoMount_NoWing_Swim_TSword_attack03 = "TSword_attack03",
  NoMount_NoWing_NoSwim_OneHand_attack01 = "OneHand_attack01",
  Rider01_OneHand_attack01 = "Rider01_attack01",
  Rider02_OneHand_attack01 = "Rider01_attack01",
  DarkHorse_OneHand_attack01 = "DarkHorse_attack01",
  Fenrilblack_OneHand_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilblue_OneHand_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilgold_OneHand_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilred_OneHand_attack01 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_OneHand_attack01 = "OneHand_attack01",
  NoMount_NoWing_Swim_OneHand_attack01 = "OneHand_attack01",
  NoMount_NoWing_NoSwim_TStaff_attack01 = "TStaff_attack01",
  Rider01_TStaff_attack01 = "Rider01_TSword_attack01",
  Rider02_TStaff_attack01 = "Rider01_TSword_attack01",
  DarkHorse_TStaff_attack01 = "DarkHorse_attack01",
  Fenrilblack_TStaff_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilblue_TStaff_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilgold_TStaff_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilred_TStaff_attack01 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_TStaff_attack01 = "TStaff_attack01",
  NoMount_NoWing_Swim_TStaff_attack01 = "TStaff_attack01",
  NoMount_NoWing_NoSwim_Dweapon_attack01 = "OneHand_attack01",
  Rider01_Dweapon_attack01 = "Rider01_attack01",
  Rider02_Dweapon_attack01 = "Rider01_attack01",
  DarkHorse_Dweapon_attack01 = "DarkHorse_attack01",
  Fenrilblack_Dweapon_attack01 = "Fenrilblack_attack01",
  Fenrilblue_Dweapon_attack01 = "Fenrilblack_attack01",
  Fenrilgold_Dweapon_attack01 = "Fenrilblack_attack01",
  Fenrilred_Dweapon_attack01 = "Fenrilblack_attack01",
  NoMount_Wing_Dweapon_attack01 = "OneHand_attack01",
  NoMount_NoWing_Swim_Dweapon_attack01 = "OneHand_attack01",
  NoMount_NoWing_NoSwim_OneHand_attack02 = "OneHand_attack02",
  Rider01_OneHand_attack02 = "Rider01_attack01",
  Rider02_OneHand_attack02 = "Rider01_attack01",
  DarkHorse_OneHand_attack02 = "DarkHorse_attack01",
  Fenrilblack_OneHand_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilblue_OneHand_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilgold_OneHand_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilred_OneHand_attack02 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_OneHand_attack02 = "OneHand_attack02",
  NoMount_NoWing_Swim_OneHand_attack02 = "OneHand_attack02",
  NoMount_NoWing_NoSwim_TStaff_attack02 = "TStaff_attack02",
  Rider01_TStaff_attack02 = "Rider01_TSword_attack01",
  Rider02_TStaff_attack02 = "Rider01_TSword_attack01",
  DarkHorse_TStaff_attack02 = "DarkHorse_attack01",
  Fenrilblack_TStaff_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilblue_TStaff_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilgold_TStaff_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilred_TStaff_attack02 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_TStaff_attack02 = "TStaff_attack02",
  NoMount_NoWing_Swim_TStaff_attack02 = "TStaff_attack02",
  NoMount_NoWing_NoSwim_Dweapon_attack02 = "Dweapon_attack02",
  Rider01_Dweapon_attack02 = "Rider01_attack01",
  Rider02_Dweapon_attack02 = "Rider01_attack01",
  DarkHorse_Dweapon_attack02 = "DarkHorse_attack01",
  Fenrilblack_Dweapon_attack02 = "Fenrilblack_attack01",
  Fenrilblue_Dweapon_attack02 = "Fenrilblack_attack01",
  Fenrilgold_Dweapon_attack02 = "Fenrilblack_attack01",
  Fenrilred_Dweapon_attack02 = "Fenrilblack_attack01",
  NoMount_Wing_Dweapon_attack02 = "Dweapon_attack02",
  NoMount_NoWing_Swim_Dweapon_attack02 = "Dweapon_attack02",
  NoMount_NoWing_NoSwim_OneHand_attack03 = "OneHand_attack01",
  Rider01_OneHand_attack03 = "Rider01_attack01",
  Rider02_OneHand_attack03 = "Rider01_attack01",
  DarkHorse_OneHand_attack03 = "DarkHorse_attack01",
  Fenrilblack_OneHand_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilblue_OneHand_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilgold_OneHand_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilred_OneHand_attack03 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_OneHand_attack03 = "OneHand_attack01",
  NoMount_NoWing_Swim_OneHand_attack03 = "OneHand_attack01",
  NoMount_NoWing_NoSwim_TStaff_attack03 = "TStaff_attack01",
  Rider01_TStaff_attack03 = "Rider01_TSword_attack01",
  Rider02_TStaff_attack03 = "Rider01_TSword_attack01",
  DarkHorse_TStaff_attack03 = "DarkHorse_attack01",
  Fenrilblack_TStaff_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilblue_TStaff_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilgold_TStaff_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilred_TStaff_attack03 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_TStaff_attack03 = "TStaff_attack01",
  NoMount_NoWing_Swim_TStaff_attack03 = "TStaff_attack01",
  NoMount_NoWing_NoSwim_Dweapon_attack03 = "OneHand_attack02",
  Rider01_Dweapon_attack03 = "Rider01_attack01",
  Rider02_Dweapon_attack03 = "Rider01_attack01",
  DarkHorse_Dweapon_attack03 = "DarkHorse_attack01",
  Fenrilblack_Dweapon_attack03 = "Fenrilblack_attack01",
  Fenrilblue_Dweapon_attack03 = "Fenrilblack_attack01",
  Fenrilgold_Dweapon_attack03 = "Fenrilblack_attack01",
  Fenrilred_Dweapon_attack03 = "Fenrilblack_attack01",
  NoMount_Wing_Dweapon_attack03 = "OneHand_attack02",
  NoMount_NoWing_Swim_Dweapon_attack03 = "OneHand_attack02",
  NoMount_NoWing_NoSwim_OneHand_attack04 = "OneHand_attack02",
  Rider01_OneHand_attack04 = "Rider01_attack01",
  Rider02_OneHand_attack04 = "Rider01_attack01",
  DarkHorse_OneHand_attack04 = "DarkHorse_attack01",
  Fenrilblack_OneHand_attack04 = "Fenrilblack_TSword_attack01",
  Fenrilblue_OneHand_attack04 = "Fenrilblack_TSword_attack01",
  Fenrilgold_OneHand_attack04 = "Fenrilblack_TSword_attack01",
  Fenrilred_OneHand_attack04 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_OneHand_attack04 = "OneHand_attack02",
  NoMount_NoWing_Swim_OneHand_attack04 = "OneHand_attack02",
  NoMount_NoWing_NoSwim_TStaff_attack04 = "TStaff_attack02",
  Rider01_TStaff_attack04 = "Rider01_TSword_attack01",
  Rider02_TStaff_attack04 = "Rider01_TSword_attack01",
  DarkHorse_TStaff_attack04 = "DarkHorse_attack01",
  Fenrilblack_TStaff_attack04 = "Fenrilblack_TSword_attack01",
  Fenrilblue_TStaff_attack04 = "Fenrilblack_TSword_attack01",
  Fenrilgold_TStaff_attack04 = "Fenrilblack_TSword_attack01",
  Fenrilred_TStaff_attack04 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_TStaff_attack04 = "TStaff_attack02",
  NoMount_NoWing_Swim_TStaff_attack04 = "TStaff_attack02",
  NoMount_NoWing_NoSwim_Dweapon_attack04 = "Dweapon_attack04",
  Rider01_Dweapon_attack04 = "Rider01_attack01",
  Rider02_Dweapon_attack04 = "Rider01_attack01",
  DarkHorse_Dweapon_attack04 = "DarkHorse_attack01",
  Fenrilblack_Dweapon_attack04 = "Fenrilblack_attack01",
  Fenrilblue_Dweapon_attack04 = "Fenrilblack_attack01",
  Fenrilgold_Dweapon_attack04 = "Fenrilblack_attack01",
  Fenrilred_Dweapon_attack04 = "Fenrilblack_attack01",
  NoMount_Wing_Dweapon_attack04 = "Dweapon_attack04",
  NoMount_NoWing_Swim_Dweapon_attack04 = "Dweapon_attack04",
  NoMount_NoWing_NoSwim_Spear_attack01 = "Spear_attack01",
  Rider01_Spear_attack01 = "Rider01_Spear_attack01",
  Rider02_Spear_attack01 = "Rider01_Spear_attack01",
  DarkHorse_Spear_attack01 = "DarkHorse_attack01",
  Fenrilblack_Spear_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilblue_Spear_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilgold_Spear_attack01 = "Fenrilblack_TSword_attack01",
  Fenrilred_Spear_attack01 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_Spear_attack01 = "Spear_attack01",
  NoMount_NoWing_Swim_Spear_attack01 = "Spear_attack01",
  NoMount_NoWing_NoSwim_Spear_attack02 = "Spear_attack02",
  Rider01_Spear_attack02 = "Rider01_Spear_attack01",
  Rider02_Spear_attack02 = "Rider01_Spear_attack01",
  DarkHorse_Spear_attack02 = "DarkHorse_attack01",
  Fenrilblack_Spear_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilblue_Spear_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilgold_Spear_attack02 = "Fenrilblack_TSword_attack01",
  Fenrilred_Spear_attack02 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_Spear_attack02 = "Spear_attack02",
  NoMount_NoWing_Swim_Spear_attack02 = "Spear_attack02",
  NoMount_NoWing_NoSwim_Spear_attack03 = "Spear_attack03",
  Rider01_Spear_attack03 = "Rider01_Spear_attack01",
  Rider02_Spear_attack03 = "Rider01_Spear_attack01",
  DarkHorse_Spear_attack03 = "DarkHorse_attack01",
  Fenrilblack_Spear_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilblue_Spear_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilgold_Spear_attack03 = "Fenrilblack_TSword_attack01",
  Fenrilred_Spear_attack03 = "Fenrilblack_TSword_attack01",
  NoMount_Wing_Spear_attack03 = "Spear_attack03",
  NoMount_NoWing_Swim_Spear_attack03 = "Spear_attack03",
  NoMount_NoWing_NoSwim_Bow_attack01 = "Bow_attack01",
  Rider01_Bow_attack01 = "Rider01_Bow_attack01",
  Rider02_Bow_attack01 = "Rider01_Bow_attack01",
  DarkHorse_Bow_attack01 = "DarkHorse_attack01",
  Fenrilblack_Bow_attack01 = "Fenrilblack_Bow_attack01",
  Fenrilblue_Bow_attack01 = "Fenrilblack_Bow_attack01",
  Fenrilgold_Bow_attack01 = "Fenrilblack_Bow_attack01",
  Fenrilred_Bow_attack01 = "Fenrilblack_Bow_attack01",
  NoMount_Wing_Bow_attack01 = "Wing_Bow_attack01",
  NoMount_NoWing_Swim_Bow_attack01 = "Wing_Bow_attack01",
  NoMount_NoWing_NoSwim_Crossbow_attack01 = "Crossbow_attack01",
  Rider01_Crossbow_attack01 = "Rider01_Crossbow_attack01",
  Rider02_Crossbow_attack01 = "Rider01_Crossbow_attack01",
  DarkHorse_Crossbow_attack01 = "DarkHorse_attack01",
  Fenrilblack_Crossbow_attack01 = "Fenrilblack_Crossbow_attack01",
  Fenrilblue_Crossbow_attack01 = "Fenrilblack_Crossbow_attack01",
  Fenrilgold_Crossbow_attack01 = "Fenrilblack_Crossbow_attack01",
  Fenrilred_Crossbow_attack01 = "Fenrilblack_Crossbow_attack01",
  NoMount_Wing_Crossbow_attack01 = "Wing_Crossbow_attack01",
  NoMount_NoWing_Swim_Crossbow_attack01 = "Wing_Crossbow_attack01",
  NoMount_NoWing_NoSwim_NoWeapon_shenglongji = "shenglongji",
  Rider01_NoWeapon_shenglongji = "shenglongji",
  Rider02_NoWeapon_shenglongji = "shenglongji",
  DarkHorse_NoWeapon_shenglongji = "shenglongji",
  Fenrilblack_NoWeapon_shenglongji = "shenglongji",
  Fenrilblue_NoWeapon_shenglongji = "shenglongji",
  Fenrilgold_NoWeapon_shenglongji = "shenglongji",
  Fenrilred_NoWeapon_shenglongji = "shenglongji",
  NoMount_Wing_NoWeapon_shenglongji = "shenglongji",
  NoMount_NoWing_Swim_NoWeapon_shenglongji = "shenglongji",
  NoMount_NoWing_NoSwim_OneHand_shenglongji = "shenglongji",
  Rider01_OneHand_shenglongji = "shenglongji",
  Rider02_OneHand_shenglongji = "shenglongji",
  DarkHorse_OneHand_shenglongji = "shenglongji",
  Fenrilblack_OneHand_shenglongji = "shenglongji",
  Fenrilblue_OneHand_shenglongji = "shenglongji",
  Fenrilgold_OneHand_shenglongji = "shenglongji",
  Fenrilred_OneHand_shenglongji = "shenglongji",
  NoMount_Wing_OneHand_shenglongji = "shenglongji",
  NoMount_NoWing_Swim_OneHand_shenglongji = "shenglongji",
  NoMount_NoWing_NoSwim_TSword_shenglongji = "shenglongji",
  Rider01_TSword_shenglongji = "shenglongji",
  Rider02_TSword_shenglongji = "shenglongji",
  DarkHorse_TSword_shenglongji = "shenglongji",
  Fenrilblack_TSword_shenglongji = "shenglongji",
  Fenrilblue_TSword_shenglongji = "shenglongji",
  Fenrilgold_TSword_shenglongji = "shenglongji",
  Fenrilred_TSword_shenglongji = "shenglongji",
  NoMount_Wing_TSword_shenglongji = "shenglongji",
  NoMount_NoWing_Swim_TSword_shenglongji = "shenglongji",
  NoMount_NoWing_NoSwim_Spear_shenglongji = "shenglongji",
  Rider01_Spear_shenglongji = "shenglongji",
  Rider02_Spear_shenglongji = "shenglongji",
  DarkHorse_Spear_shenglongji = "shenglongji",
  Fenrilblack_Spear_shenglongji = "shenglongji",
  Fenrilblue_Spear_shenglongji = "shenglongji",
  Fenrilgold_Spear_shenglongji = "shenglongji",
  Fenrilred_Spear_shenglongji = "shenglongji",
  NoMount_Wing_Spear_shenglongji = "shenglongji",
  NoMount_NoWing_Swim_Spear_shenglongji = "shenglongji",
  NoMount_NoWing_NoSwim_TStaff_shenglongji = "shenglongji",
  Rider01_TStaff_shenglongji = "shenglongji",
  Rider02_TStaff_shenglongji = "shenglongji",
  DarkHorse_TStaff_shenglongji = "shenglongji",
  Fenrilblack_TStaff_shenglongji = "shenglongji",
  Fenrilblue_TStaff_shenglongji = "shenglongji",
  Fenrilgold_TStaff_shenglongji = "shenglongji",
  Fenrilred_TStaff_shenglongji = "shenglongji",
  NoMount_Wing_TStaff_shenglongji = "shenglongji",
  NoMount_NoWing_Swim_TStaff_shenglongji = "shenglongji",
  NoMount_NoWing_NoSwim_Bow_shenglongji = "shenglongji",
  Rider01_Bow_shenglongji = "shenglongji",
  Rider02_Bow_shenglongji = "shenglongji",
  DarkHorse_Bow_shenglongji = "shenglongji",
  Fenrilblack_Bow_shenglongji = "shenglongji",
  Fenrilblue_Bow_shenglongji = "shenglongji",
  Fenrilgold_Bow_shenglongji = "shenglongji",
  Fenrilred_Bow_shenglongji = "shenglongji",
  NoMount_Wing_Bow_shenglongji = "shenglongji",
  NoMount_NoWing_Swim_Bow_shenglongji = "shenglongji",
  NoMount_NoWing_NoSwim_Crossbow_shenglongji = "shenglongji",
  Rider01_Crossbow_shenglongji = "shenglongji",
  Rider02_Crossbow_shenglongji = "shenglongji",
  DarkHorse_Crossbow_shenglongji = "shenglongji",
  Fenrilblack_Crossbow_shenglongji = "shenglongji",
  Fenrilblue_Crossbow_shenglongji = "shenglongji",
  Fenrilgold_Crossbow_shenglongji = "shenglongji",
  Fenrilred_Crossbow_shenglongji = "shenglongji",
  NoMount_Wing_Crossbow_shenglongji = "shenglongji",
  NoMount_NoWing_Swim_Crossbow_shenglongji = "shenglongji",
  NoMount_NoWing_NoSwim_Dweapon_shenglongji = "shenglongji",
  Rider01_Dweapon_shenglongji = "shenglongji",
  Rider02_Dweapon_shenglongji = "shenglongji",
  DarkHorse_Dweapon_shenglongji = "shenglongji",
  Fenrilblack_Dweapon_shenglongji = "shenglongji",
  Fenrilblue_Dweapon_shenglongji = "shenglongji",
  Fenrilgold_Dweapon_shenglongji = "shenglongji",
  Fenrilred_Dweapon_shenglongji = "shenglongji",
  NoMount_Wing_Dweapon_shenglongji = "shenglongji",
  NoMount_NoWing_Swim_Dweapon_shenglongji = "shenglongji",
  NoMount_NoWing_NoSwim_NoWeapon_diliezhan = "diliezhan",
  Rider01_NoWeapon_diliezhan = "diliezhan",
  Rider02_NoWeapon_diliezhan = "diliezhan",
  DarkHorse_NoWeapon_diliezhan = "diliezhan",
  Fenrilblack_NoWeapon_diliezhan = "diliezhan",
  Fenrilblue_NoWeapon_diliezhan = "diliezhan",
  Fenrilgold_NoWeapon_diliezhan = "diliezhan",
  Fenrilred_NoWeapon_diliezhan = "diliezhan",
  NoMount_Wing_NoWeapon_diliezhan = "diliezhan",
  NoMount_NoWing_Swim_NoWeapon_diliezhan = "diliezhan",
  NoMount_NoWing_NoSwim_OneHand_diliezhan = "diliezhan",
  Rider01_OneHand_diliezhan = "diliezhan",
  Rider02_OneHand_diliezhan = "diliezhan",
  DarkHorse_OneHand_diliezhan = "diliezhan",
  Fenrilblack_OneHand_diliezhan = "diliezhan",
  Fenrilblue_OneHand_diliezhan = "diliezhan",
  Fenrilgold_OneHand_diliezhan = "diliezhan",
  Fenrilred_OneHand_diliezhan = "diliezhan",
  NoMount_Wing_OneHand_diliezhan = "diliezhan",
  NoMount_NoWing_Swim_OneHand_diliezhan = "diliezhan",
  NoMount_NoWing_NoSwim_TSword_diliezhan = "diliezhan",
  Rider01_TSword_diliezhan = "diliezhan",
  Rider02_TSword_diliezhan = "diliezhan",
  DarkHorse_TSword_diliezhan = "diliezhan",
  Fenrilblack_TSword_diliezhan = "diliezhan",
  Fenrilblue_TSword_diliezhan = "diliezhan",
  Fenrilgold_TSword_diliezhan = "diliezhan",
  Fenrilred_TSword_diliezhan = "diliezhan",
  NoMount_Wing_TSword_diliezhan = "diliezhan",
  NoMount_NoWing_Swim_TSword_diliezhan = "diliezhan",
  NoMount_NoWing_NoSwim_Spear_diliezhan = "diliezhan",
  Rider01_Spear_diliezhan = "diliezhan",
  Rider02_Spear_diliezhan = "diliezhan",
  DarkHorse_Spear_diliezhan = "diliezhan",
  Fenrilblack_Spear_diliezhan = "diliezhan",
  Fenrilblue_Spear_diliezhan = "diliezhan",
  Fenrilgold_Spear_diliezhan = "diliezhan",
  Fenrilred_Spear_diliezhan = "diliezhan",
  NoMount_Wing_Spear_diliezhan = "diliezhan",
  NoMount_NoWing_Swim_Spear_diliezhan = "diliezhan",
  NoMount_NoWing_NoSwim_TStaff_diliezhan = "diliezhan",
  Rider01_TStaff_diliezhan = "diliezhan",
  Rider02_TStaff_diliezhan = "diliezhan",
  DarkHorse_TStaff_diliezhan = "diliezhan",
  Fenrilblack_TStaff_diliezhan = "diliezhan",
  Fenrilblue_TStaff_diliezhan = "diliezhan",
  Fenrilgold_TStaff_diliezhan = "diliezhan",
  Fenrilred_TStaff_diliezhan = "diliezhan",
  NoMount_Wing_TStaff_diliezhan = "diliezhan",
  NoMount_NoWing_Swim_TStaff_diliezhan = "diliezhan",
  NoMount_NoWing_NoSwim_Bow_diliezhan = "diliezhan",
  Rider01_Bow_diliezhan = "diliezhan",
  Rider02_Bow_diliezhan = "diliezhan",
  DarkHorse_Bow_diliezhan = "diliezhan",
  Fenrilblack_Bow_diliezhan = "diliezhan",
  Fenrilblue_Bow_diliezhan = "diliezhan",
  Fenrilgold_Bow_diliezhan = "diliezhan",
  Fenrilred_Bow_diliezhan = "diliezhan",
  NoMount_Wing_Bow_diliezhan = "diliezhan",
  NoMount_NoWing_Swim_Bow_diliezhan = "diliezhan",
  NoMount_NoWing_NoSwim_Crossbow_diliezhan = "diliezhan",
  Rider01_Crossbow_diliezhan = "diliezhan",
  Rider02_Crossbow_diliezhan = "diliezhan",
  DarkHorse_Crossbow_diliezhan = "diliezhan",
  Fenrilblack_Crossbow_diliezhan = "diliezhan",
  Fenrilblue_Crossbow_diliezhan = "diliezhan",
  Fenrilgold_Crossbow_diliezhan = "diliezhan",
  Fenrilred_Crossbow_diliezhan = "diliezhan",
  NoMount_Wing_Crossbow_diliezhan = "diliezhan",
  NoMount_NoWing_Swim_Crossbow_diliezhan = "diliezhan",
  NoMount_NoWing_NoSwim_Dweapon_diliezhan = "diliezhan",
  Rider01_Dweapon_diliezhan = "diliezhan",
  Rider02_Dweapon_diliezhan = "diliezhan",
  DarkHorse_Dweapon_diliezhan = "diliezhan",
  Fenrilblack_Dweapon_diliezhan = "diliezhan",
  Fenrilblue_Dweapon_diliezhan = "diliezhan",
  Fenrilgold_Dweapon_diliezhan = "diliezhan",
  Fenrilred_Dweapon_diliezhan = "diliezhan",
  NoMount_Wing_Dweapon_diliezhan = "diliezhan",
  NoMount_NoWing_Swim_Dweapon_diliezhan = "diliezhan",
  NoMount_NoWing_NoSwim_NoWeapon_xuanfengzhan = "xuanfengzhan",
  Rider01_NoWeapon_xuanfengzhan = "xuanfengzhan",
  Rider02_NoWeapon_xuanfengzhan = "xuanfengzhan",
  DarkHorse_NoWeapon_xuanfengzhan = "xuanfengzhan",
  Fenrilblack_NoWeapon_xuanfengzhan = "xuanfengzhan",
  Fenrilblue_NoWeapon_xuanfengzhan = "xuanfengzhan",
  Fenrilgold_NoWeapon_xuanfengzhan = "xuanfengzhan",
  Fenrilred_NoWeapon_xuanfengzhan = "xuanfengzhan",
  NoMount_Wing_NoWeapon_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_Swim_NoWeapon_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_NoSwim_OneHand_xuanfengzhan = "xuanfengzhan",
  Rider01_OneHand_xuanfengzhan = "xuanfengzhan",
  Rider02_OneHand_xuanfengzhan = "xuanfengzhan",
  DarkHorse_OneHand_xuanfengzhan = "xuanfengzhan",
  Fenrilblack_OneHand_xuanfengzhan = "xuanfengzhan",
  Fenrilblue_OneHand_xuanfengzhan = "xuanfengzhan",
  Fenrilgold_OneHand_xuanfengzhan = "xuanfengzhan",
  Fenrilred_OneHand_xuanfengzhan = "xuanfengzhan",
  NoMount_Wing_OneHand_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_Swim_OneHand_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_NoSwim_TSword_xuanfengzhan = "xuanfengzhan",
  Rider01_TSword_xuanfengzhan = "xuanfengzhan",
  Rider02_TSword_xuanfengzhan = "xuanfengzhan",
  DarkHorse_TSword_xuanfengzhan = "xuanfengzhan",
  Fenrilblack_TSword_xuanfengzhan = "xuanfengzhan",
  Fenrilblue_TSword_xuanfengzhan = "xuanfengzhan",
  Fenrilgold_TSword_xuanfengzhan = "xuanfengzhan",
  Fenrilred_TSword_xuanfengzhan = "xuanfengzhan",
  NoMount_Wing_TSword_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_Swim_TSword_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_NoSwim_Spear_xuanfengzhan = "xuanfengzhan",
  Rider01_Spear_xuanfengzhan = "xuanfengzhan",
  Rider02_Spear_xuanfengzhan = "xuanfengzhan",
  DarkHorse_Spear_xuanfengzhan = "xuanfengzhan",
  Fenrilblack_Spear_xuanfengzhan = "xuanfengzhan",
  Fenrilblue_Spear_xuanfengzhan = "xuanfengzhan",
  Fenrilgold_Spear_xuanfengzhan = "xuanfengzhan",
  Fenrilred_Spear_xuanfengzhan = "xuanfengzhan",
  NoMount_Wing_Spear_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_Swim_Spear_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_NoSwim_TStaff_xuanfengzhan = "xuanfengzhan",
  Rider01_TStaff_xuanfengzhan = "xuanfengzhan",
  Rider02_TStaff_xuanfengzhan = "xuanfengzhan",
  DarkHorse_TStaff_xuanfengzhan = "xuanfengzhan",
  Fenrilblack_TStaff_xuanfengzhan = "xuanfengzhan",
  Fenrilblue_TStaff_xuanfengzhan = "xuanfengzhan",
  Fenrilgold_TStaff_xuanfengzhan = "xuanfengzhan",
  Fenrilred_TStaff_xuanfengzhan = "xuanfengzhan",
  NoMount_Wing_TStaff_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_Swim_TStaff_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_NoSwim_Bow_xuanfengzhan = "xuanfengzhan",
  Rider01_Bow_xuanfengzhan = "xuanfengzhan",
  Rider02_Bow_xuanfengzhan = "xuanfengzhan",
  DarkHorse_Bow_xuanfengzhan = "xuanfengzhan",
  Fenrilblack_Bow_xuanfengzhan = "xuanfengzhan",
  Fenrilblue_Bow_xuanfengzhan = "xuanfengzhan",
  Fenrilgold_Bow_xuanfengzhan = "xuanfengzhan",
  Fenrilred_Bow_xuanfengzhan = "xuanfengzhan",
  NoMount_Wing_Bow_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_Swim_Bow_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_NoSwim_Crossbow_xuanfengzhan = "xuanfengzhan",
  Rider01_Crossbow_xuanfengzhan = "xuanfengzhan",
  Rider02_Crossbow_xuanfengzhan = "xuanfengzhan",
  DarkHorse_Crossbow_xuanfengzhan = "xuanfengzhan",
  Fenrilblack_Crossbow_xuanfengzhan = "xuanfengzhan",
  Fenrilblue_Crossbow_xuanfengzhan = "xuanfengzhan",
  Fenrilgold_Crossbow_xuanfengzhan = "xuanfengzhan",
  Fenrilred_Crossbow_xuanfengzhan = "xuanfengzhan",
  NoMount_Wing_Crossbow_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_Swim_Crossbow_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_NoSwim_Dweapon_xuanfengzhan = "xuanfengzhan",
  Rider01_Dweapon_xuanfengzhan = "xuanfengzhan",
  Rider02_Dweapon_xuanfengzhan = "xuanfengzhan",
  DarkHorse_Dweapon_xuanfengzhan = "xuanfengzhan",
  Fenrilblack_Dweapon_xuanfengzhan = "xuanfengzhan",
  Fenrilblue_Dweapon_xuanfengzhan = "xuanfengzhan",
  Fenrilgold_Dweapon_xuanfengzhan = "xuanfengzhan",
  Fenrilred_Dweapon_xuanfengzhan = "xuanfengzhan",
  NoMount_Wing_Dweapon_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_Swim_Dweapon_xuanfengzhan = "xuanfengzhan",
  NoMount_NoWing_NoSwim_NoWeapon_yatuci = "yatuci",
  Rider01_NoWeapon_yatuci = "yatuci",
  Rider02_NoWeapon_yatuci = "yatuci",
  DarkHorse_NoWeapon_yatuci = "yatuci",
  Fenrilblack_NoWeapon_yatuci = "yatuci",
  Fenrilblue_NoWeapon_yatuci = "yatuci",
  Fenrilgold_NoWeapon_yatuci = "yatuci",
  Fenrilred_NoWeapon_yatuci = "yatuci",
  NoMount_Wing_NoWeapon_yatuci = "yatuci",
  NoMount_NoWing_Swim_NoWeapon_yatuci = "yatuci",
  NoMount_NoWing_NoSwim_OneHand_yatuci = "yatuci",
  Rider01_OneHand_yatuci = "yatuci",
  Rider02_OneHand_yatuci = "yatuci",
  DarkHorse_OneHand_yatuci = "yatuci",
  Fenrilblack_OneHand_yatuci = "yatuci",
  Fenrilblue_OneHand_yatuci = "yatuci",
  Fenrilgold_OneHand_yatuci = "yatuci",
  Fenrilred_OneHand_yatuci = "yatuci",
  NoMount_Wing_OneHand_yatuci = "yatuci",
  NoMount_NoWing_Swim_OneHand_yatuci = "yatuci",
  NoMount_NoWing_NoSwim_TSword_yatuci = "yatuci",
  Rider01_TSword_yatuci = "yatuci",
  Rider02_TSword_yatuci = "yatuci",
  DarkHorse_TSword_yatuci = "yatuci",
  Fenrilblack_TSword_yatuci = "yatuci",
  Fenrilblue_TSword_yatuci = "yatuci",
  Fenrilgold_TSword_yatuci = "yatuci",
  Fenrilred_TSword_yatuci = "yatuci",
  NoMount_Wing_TSword_yatuci = "yatuci",
  NoMount_NoWing_Swim_TSword_yatuci = "yatuci",
  NoMount_NoWing_NoSwim_Spear_yatuci = "yatuci",
  Rider01_Spear_yatuci = "yatuci",
  Rider02_Spear_yatuci = "yatuci",
  DarkHorse_Spear_yatuci = "yatuci",
  Fenrilblack_Spear_yatuci = "yatuci",
  Fenrilblue_Spear_yatuci = "yatuci",
  Fenrilgold_Spear_yatuci = "yatuci",
  Fenrilred_Spear_yatuci = "yatuci",
  NoMount_Wing_Spear_yatuci = "yatuci",
  NoMount_NoWing_Swim_Spear_yatuci = "yatuci",
  NoMount_NoWing_NoSwim_TStaff_yatuci = "yatuci",
  Rider01_TStaff_yatuci = "yatuci",
  Rider02_TStaff_yatuci = "yatuci",
  DarkHorse_TStaff_yatuci = "yatuci",
  Fenrilblack_TStaff_yatuci = "yatuci",
  Fenrilblue_TStaff_yatuci = "yatuci",
  Fenrilgold_TStaff_yatuci = "yatuci",
  Fenrilred_TStaff_yatuci = "yatuci",
  NoMount_Wing_TStaff_yatuci = "yatuci",
  NoMount_NoWing_Swim_TStaff_yatuci = "yatuci",
  NoMount_NoWing_NoSwim_Bow_yatuci = "yatuci",
  Rider01_Bow_yatuci = "yatuci",
  Rider02_Bow_yatuci = "yatuci",
  DarkHorse_Bow_yatuci = "yatuci",
  Fenrilblack_Bow_yatuci = "yatuci",
  Fenrilblue_Bow_yatuci = "yatuci",
  Fenrilgold_Bow_yatuci = "yatuci",
  Fenrilred_Bow_yatuci = "yatuci",
  NoMount_Wing_Bow_yatuci = "yatuci",
  NoMount_NoWing_Swim_Bow_yatuci = "yatuci",
  NoMount_NoWing_NoSwim_Crossbow_yatuci = "yatuci",
  Rider01_Crossbow_yatuci = "yatuci",
  Rider02_Crossbow_yatuci = "yatuci",
  DarkHorse_Crossbow_yatuci = "yatuci",
  Fenrilblack_Crossbow_yatuci = "yatuci",
  Fenrilblue_Crossbow_yatuci = "yatuci",
  Fenrilgold_Crossbow_yatuci = "yatuci",
  Fenrilred_Crossbow_yatuci = "yatuci",
  NoMount_Wing_Crossbow_yatuci = "yatuci",
  NoMount_NoWing_Swim_Crossbow_yatuci = "yatuci",
  NoMount_NoWing_NoSwim_Dweapon_yatuci = "yatuci",
  Rider01_Dweapon_yatuci = "yatuci",
  Rider02_Dweapon_yatuci = "yatuci",
  DarkHorse_Dweapon_yatuci = "yatuci",
  Fenrilblack_Dweapon_yatuci = "yatuci",
  Fenrilblue_Dweapon_yatuci = "yatuci",
  Fenrilgold_Dweapon_yatuci = "yatuci",
  Fenrilred_Dweapon_yatuci = "yatuci",
  NoMount_Wing_Dweapon_yatuci = "yatuci",
  NoMount_NoWing_Swim_Dweapon_yatuci = "yatuci",
  NoMount_NoWing_NoSwim_NoWeapon_tiandishizijian01 = "tiandishizijian01",
  Rider01_NoWeapon_tiandishizijian01 = "tiandishizijian01",
  Rider02_NoWeapon_tiandishizijian01 = "tiandishizijian01",
  DarkHorse_NoWeapon_tiandishizijian01 = "tiandishizijian01",
  Fenrilblack_NoWeapon_tiandishizijian01 = "tiandishizijian01",
  Fenrilblue_NoWeapon_tiandishizijian01 = "tiandishizijian01",
  Fenrilgold_NoWeapon_tiandishizijian01 = "tiandishizijian01",
  Fenrilred_NoWeapon_tiandishizijian01 = "tiandishizijian01",
  NoMount_Wing_NoWeapon_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_Swim_NoWeapon_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_NoSwim_OneHand_tiandishizijian01 = "tiandishizijian01",
  Rider01_OneHand_tiandishizijian01 = "tiandishizijian01",
  Rider02_OneHand_tiandishizijian01 = "tiandishizijian01",
  DarkHorse_OneHand_tiandishizijian01 = "tiandishizijian01",
  Fenrilblack_OneHand_tiandishizijian01 = "tiandishizijian01",
  Fenrilblue_OneHand_tiandishizijian01 = "tiandishizijian01",
  Fenrilgold_OneHand_tiandishizijian01 = "tiandishizijian01",
  Fenrilred_OneHand_tiandishizijian01 = "tiandishizijian01",
  NoMount_Wing_OneHand_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_Swim_OneHand_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_NoSwim_TSword_tiandishizijian01 = "tiandishizijian01",
  Rider01_TSword_tiandishizijian01 = "tiandishizijian01",
  Rider02_TSword_tiandishizijian01 = "tiandishizijian01",
  DarkHorse_TSword_tiandishizijian01 = "tiandishizijian01",
  Fenrilblack_TSword_tiandishizijian01 = "tiandishizijian01",
  Fenrilblue_TSword_tiandishizijian01 = "tiandishizijian01",
  Fenrilgold_TSword_tiandishizijian01 = "tiandishizijian01",
  Fenrilred_TSword_tiandishizijian01 = "tiandishizijian01",
  NoMount_Wing_TSword_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_Swim_TSword_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_NoSwim_Spear_tiandishizijian01 = "tiandishizijian01",
  Rider01_Spear_tiandishizijian01 = "tiandishizijian01",
  Rider02_Spear_tiandishizijian01 = "tiandishizijian01",
  DarkHorse_Spear_tiandishizijian01 = "tiandishizijian01",
  Fenrilblack_Spear_tiandishizijian01 = "tiandishizijian01",
  Fenrilblue_Spear_tiandishizijian01 = "tiandishizijian01",
  Fenrilgold_Spear_tiandishizijian01 = "tiandishizijian01",
  Fenrilred_Spear_tiandishizijian01 = "tiandishizijian01",
  NoMount_Wing_Spear_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_Swim_Spear_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_NoSwim_TStaff_tiandishizijian01 = "tiandishizijian01",
  Rider01_TStaff_tiandishizijian01 = "tiandishizijian01",
  Rider02_TStaff_tiandishizijian01 = "tiandishizijian01",
  DarkHorse_TStaff_tiandishizijian01 = "tiandishizijian01",
  Fenrilblack_TStaff_tiandishizijian01 = "tiandishizijian01",
  Fenrilblue_TStaff_tiandishizijian01 = "tiandishizijian01",
  Fenrilgold_TStaff_tiandishizijian01 = "tiandishizijian01",
  Fenrilred_TStaff_tiandishizijian01 = "tiandishizijian01",
  NoMount_Wing_TStaff_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_Swim_TStaff_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_NoSwim_Bow_tiandishizijian01 = "tiandishizijian01",
  Rider01_Bow_tiandishizijian01 = "tiandishizijian01",
  Rider02_Bow_tiandishizijian01 = "tiandishizijian01",
  DarkHorse_Bow_tiandishizijian01 = "tiandishizijian01",
  Fenrilblack_Bow_tiandishizijian01 = "tiandishizijian01",
  Fenrilblue_Bow_tiandishizijian01 = "tiandishizijian01",
  Fenrilgold_Bow_tiandishizijian01 = "tiandishizijian01",
  Fenrilred_Bow_tiandishizijian01 = "tiandishizijian01",
  NoMount_Wing_Bow_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_Swim_Bow_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_NoSwim_Crossbow_tiandishizijian01 = "tiandishizijian01",
  Rider01_Crossbow_tiandishizijian01 = "tiandishizijian01",
  Rider02_Crossbow_tiandishizijian01 = "tiandishizijian01",
  DarkHorse_Crossbow_tiandishizijian01 = "tiandishizijian01",
  Fenrilblack_Crossbow_tiandishizijian01 = "tiandishizijian01",
  Fenrilblue_Crossbow_tiandishizijian01 = "tiandishizijian01",
  Fenrilgold_Crossbow_tiandishizijian01 = "tiandishizijian01",
  Fenrilred_Crossbow_tiandishizijian01 = "tiandishizijian01",
  NoMount_Wing_Crossbow_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_Swim_Crossbow_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_NoSwim_Dweapon_tiandishizijian01 = "tiandishizijian01",
  Rider01_Dweapon_tiandishizijian01 = "tiandishizijian01",
  Rider02_Dweapon_tiandishizijian01 = "tiandishizijian01",
  DarkHorse_Dweapon_tiandishizijian01 = "tiandishizijian01",
  Fenrilblack_Dweapon_tiandishizijian01 = "tiandishizijian01",
  Fenrilblue_Dweapon_tiandishizijian01 = "tiandishizijian01",
  Fenrilgold_Dweapon_tiandishizijian01 = "tiandishizijian01",
  Fenrilred_Dweapon_tiandishizijian01 = "tiandishizijian01",
  NoMount_Wing_Dweapon_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_Swim_Dweapon_tiandishizijian01 = "tiandishizijian01",
  NoMount_NoWing_NoSwim_NoWeapon_tiandishizijian02 = "TSword_attack03",
  Rider01_NoWeapon_tiandishizijian02 = "TSword_attack03",
  Rider02_NoWeapon_tiandishizijian02 = "TSword_attack03",
  DarkHorse_NoWeapon_tiandishizijian02 = "TSword_attack03",
  Fenrilblack_NoWeapon_tiandishizijian02 = "TSword_attack03",
  Fenrilblue_NoWeapon_tiandishizijian02 = "TSword_attack03",
  Fenrilgold_NoWeapon_tiandishizijian02 = "TSword_attack03",
  Fenrilred_NoWeapon_tiandishizijian02 = "TSword_attack03",
  NoMount_Wing_NoWeapon_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_Swim_NoWeapon_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_NoSwim_OneHand_tiandishizijian02 = "TSword_attack03",
  Rider01_OneHand_tiandishizijian02 = "TSword_attack03",
  Rider02_OneHand_tiandishizijian02 = "TSword_attack03",
  DarkHorse_OneHand_tiandishizijian02 = "TSword_attack03",
  Fenrilblack_OneHand_tiandishizijian02 = "TSword_attack03",
  Fenrilblue_OneHand_tiandishizijian02 = "TSword_attack03",
  Fenrilgold_OneHand_tiandishizijian02 = "TSword_attack03",
  Fenrilred_OneHand_tiandishizijian02 = "TSword_attack03",
  NoMount_Wing_OneHand_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_Swim_OneHand_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_NoSwim_TSword_tiandishizijian02 = "TSword_attack03",
  Rider01_TSword_tiandishizijian02 = "TSword_attack03",
  Rider02_TSword_tiandishizijian02 = "TSword_attack03",
  DarkHorse_TSword_tiandishizijian02 = "TSword_attack03",
  Fenrilblack_TSword_tiandishizijian02 = "TSword_attack03",
  Fenrilblue_TSword_tiandishizijian02 = "TSword_attack03",
  Fenrilgold_TSword_tiandishizijian02 = "TSword_attack03",
  Fenrilred_TSword_tiandishizijian02 = "TSword_attack03",
  NoMount_Wing_TSword_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_Swim_TSword_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_NoSwim_Spear_tiandishizijian02 = "TSword_attack03",
  Rider01_Spear_tiandishizijian02 = "TSword_attack03",
  Rider02_Spear_tiandishizijian02 = "TSword_attack03",
  DarkHorse_Spear_tiandishizijian02 = "TSword_attack03",
  Fenrilblack_Spear_tiandishizijian02 = "TSword_attack03",
  Fenrilblue_Spear_tiandishizijian02 = "TSword_attack03",
  Fenrilgold_Spear_tiandishizijian02 = "TSword_attack03",
  Fenrilred_Spear_tiandishizijian02 = "TSword_attack03",
  NoMount_Wing_Spear_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_Swim_Spear_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_NoSwim_TStaff_tiandishizijian02 = "TSword_attack03",
  Rider01_TStaff_tiandishizijian02 = "TSword_attack03",
  Rider02_TStaff_tiandishizijian02 = "TSword_attack03",
  DarkHorse_TStaff_tiandishizijian02 = "TSword_attack03",
  Fenrilblack_TStaff_tiandishizijian02 = "TSword_attack03",
  Fenrilblue_TStaff_tiandishizijian02 = "TSword_attack03",
  Fenrilgold_TStaff_tiandishizijian02 = "TSword_attack03",
  Fenrilred_TStaff_tiandishizijian02 = "TSword_attack03",
  NoMount_Wing_TStaff_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_Swim_TStaff_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_NoSwim_Bow_tiandishizijian02 = "TSword_attack03",
  Rider01_Bow_tiandishizijian02 = "TSword_attack03",
  Rider02_Bow_tiandishizijian02 = "TSword_attack03",
  DarkHorse_Bow_tiandishizijian02 = "TSword_attack03",
  Fenrilblack_Bow_tiandishizijian02 = "TSword_attack03",
  Fenrilblue_Bow_tiandishizijian02 = "TSword_attack03",
  Fenrilgold_Bow_tiandishizijian02 = "TSword_attack03",
  Fenrilred_Bow_tiandishizijian02 = "TSword_attack03",
  NoMount_Wing_Bow_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_Swim_Bow_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_NoSwim_Crossbow_tiandishizijian02 = "TSword_attack03",
  Rider01_Crossbow_tiandishizijian02 = "TSword_attack03",
  Rider02_Crossbow_tiandishizijian02 = "TSword_attack03",
  DarkHorse_Crossbow_tiandishizijian02 = "TSword_attack03",
  Fenrilblack_Crossbow_tiandishizijian02 = "TSword_attack03",
  Fenrilblue_Crossbow_tiandishizijian02 = "TSword_attack03",
  Fenrilgold_Crossbow_tiandishizijian02 = "TSword_attack03",
  Fenrilred_Crossbow_tiandishizijian02 = "TSword_attack03",
  NoMount_Wing_Crossbow_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_Swim_Crossbow_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_NoSwim_Dweapon_tiandishizijian02 = "TSword_attack03",
  Rider01_Dweapon_tiandishizijian02 = "TSword_attack03",
  Rider02_Dweapon_tiandishizijian02 = "TSword_attack03",
  DarkHorse_Dweapon_tiandishizijian02 = "TSword_attack03",
  Fenrilblack_Dweapon_tiandishizijian02 = "TSword_attack03",
  Fenrilblue_Dweapon_tiandishizijian02 = "TSword_attack03",
  Fenrilgold_Dweapon_tiandishizijian02 = "TSword_attack03",
  Fenrilred_Dweapon_tiandishizijian02 = "TSword_attack03",
  NoMount_Wing_Dweapon_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_Swim_Dweapon_tiandishizijian02 = "TSword_attack03",
  NoMount_NoWing_NoSwim_NoWeapon_shengdunfangyu = "shengdunfangyu",
  Rider01_NoWeapon_shengdunfangyu = "shengdunfangyu",
  Rider02_NoWeapon_shengdunfangyu = "shengdunfangyu",
  DarkHorse_NoWeapon_shengdunfangyu = "shengdunfangyu",
  Fenrilblack_NoWeapon_shengdunfangyu = "shengdunfangyu",
  Fenrilblue_NoWeapon_shengdunfangyu = "shengdunfangyu",
  Fenrilgold_NoWeapon_shengdunfangyu = "shengdunfangyu",
  Fenrilred_NoWeapon_shengdunfangyu = "shengdunfangyu",
  NoMount_Wing_NoWeapon_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_Swim_NoWeapon_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_NoSwim_OneHand_shengdunfangyu = "shengdunfangyu",
  Rider01_OneHand_shengdunfangyu = "shengdunfangyu",
  Rider02_OneHand_shengdunfangyu = "shengdunfangyu",
  DarkHorse_OneHand_shengdunfangyu = "shengdunfangyu",
  Fenrilblack_OneHand_shengdunfangyu = "shengdunfangyu",
  Fenrilblue_OneHand_shengdunfangyu = "shengdunfangyu",
  Fenrilgold_OneHand_shengdunfangyu = "shengdunfangyu",
  Fenrilred_OneHand_shengdunfangyu = "shengdunfangyu",
  NoMount_Wing_OneHand_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_Swim_OneHand_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_NoSwim_TSword_shengdunfangyu = "shengdunfangyu",
  Rider01_TSword_shengdunfangyu = "shengdunfangyu",
  Rider02_TSword_shengdunfangyu = "shengdunfangyu",
  DarkHorse_TSword_shengdunfangyu = "shengdunfangyu",
  Fenrilblack_TSword_shengdunfangyu = "shengdunfangyu",
  Fenrilblue_TSword_shengdunfangyu = "shengdunfangyu",
  Fenrilgold_TSword_shengdunfangyu = "shengdunfangyu",
  Fenrilred_TSword_shengdunfangyu = "shengdunfangyu",
  NoMount_Wing_TSword_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_Swim_TSword_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_NoSwim_Spear_shengdunfangyu = "shengdunfangyu",
  Rider01_Spear_shengdunfangyu = "shengdunfangyu",
  Rider02_Spear_shengdunfangyu = "shengdunfangyu",
  DarkHorse_Spear_shengdunfangyu = "shengdunfangyu",
  Fenrilblack_Spear_shengdunfangyu = "shengdunfangyu",
  Fenrilblue_Spear_shengdunfangyu = "shengdunfangyu",
  Fenrilgold_Spear_shengdunfangyu = "shengdunfangyu",
  Fenrilred_Spear_shengdunfangyu = "shengdunfangyu",
  NoMount_Wing_Spear_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_Swim_Spear_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_NoSwim_TStaff_shengdunfangyu = "shengdunfangyu",
  Rider01_TStaff_shengdunfangyu = "shengdunfangyu",
  Rider02_TStaff_shengdunfangyu = "shengdunfangyu",
  DarkHorse_TStaff_shengdunfangyu = "shengdunfangyu",
  Fenrilblack_TStaff_shengdunfangyu = "shengdunfangyu",
  Fenrilblue_TStaff_shengdunfangyu = "shengdunfangyu",
  Fenrilgold_TStaff_shengdunfangyu = "shengdunfangyu",
  Fenrilred_TStaff_shengdunfangyu = "shengdunfangyu",
  NoMount_Wing_TStaff_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_Swim_TStaff_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_NoSwim_Bow_shengdunfangyu = "shengdunfangyu",
  Rider01_Bow_shengdunfangyu = "shengdunfangyu",
  Rider02_Bow_shengdunfangyu = "shengdunfangyu",
  DarkHorse_Bow_shengdunfangyu = "shengdunfangyu",
  Fenrilblack_Bow_shengdunfangyu = "shengdunfangyu",
  Fenrilblue_Bow_shengdunfangyu = "shengdunfangyu",
  Fenrilgold_Bow_shengdunfangyu = "shengdunfangyu",
  Fenrilred_Bow_shengdunfangyu = "shengdunfangyu",
  NoMount_Wing_Bow_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_Swim_Bow_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_NoSwim_Crossbow_shengdunfangyu = "shengdunfangyu",
  Rider01_Crossbow_shengdunfangyu = "shengdunfangyu",
  Rider02_Crossbow_shengdunfangyu = "shengdunfangyu",
  DarkHorse_Crossbow_shengdunfangyu = "shengdunfangyu",
  Fenrilblack_Crossbow_shengdunfangyu = "shengdunfangyu",
  Fenrilblue_Crossbow_shengdunfangyu = "shengdunfangyu",
  Fenrilgold_Crossbow_shengdunfangyu = "shengdunfangyu",
  Fenrilred_Crossbow_shengdunfangyu = "shengdunfangyu",
  NoMount_Wing_Crossbow_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_Swim_Crossbow_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_NoSwim_Dweapon_shengdunfangyu = "shengdunfangyu",
  Rider01_Dweapon_shengdunfangyu = "shengdunfangyu",
  Rider02_Dweapon_shengdunfangyu = "shengdunfangyu",
  DarkHorse_Dweapon_shengdunfangyu = "shengdunfangyu",
  Fenrilblack_Dweapon_shengdunfangyu = "shengdunfangyu",
  Fenrilblue_Dweapon_shengdunfangyu = "shengdunfangyu",
  Fenrilgold_Dweapon_shengdunfangyu = "shengdunfangyu",
  Fenrilred_Dweapon_shengdunfangyu = "shengdunfangyu",
  NoMount_Wing_Dweapon_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_Swim_Dweapon_shengdunfangyu = "shengdunfangyu",
  NoMount_NoWing_NoSwim_NoWeapon_pilihuixuanzhan = "pilihuixuanzhan",
  Rider01_NoWeapon_pilihuixuanzhan = "pilihuixuanzhan",
  Rider02_NoWeapon_pilihuixuanzhan = "pilihuixuanzhan",
  DarkHorse_NoWeapon_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblack_NoWeapon_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblue_NoWeapon_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilgold_NoWeapon_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilred_NoWeapon_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_Wing_NoWeapon_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_Swim_NoWeapon_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_NoSwim_OneHand_pilihuixuanzhan = "pilihuixuanzhan",
  Rider01_OneHand_pilihuixuanzhan = "pilihuixuanzhan",
  Rider02_OneHand_pilihuixuanzhan = "pilihuixuanzhan",
  DarkHorse_OneHand_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblack_OneHand_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblue_OneHand_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilgold_OneHand_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilred_OneHand_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_Wing_OneHand_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_Swim_OneHand_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_NoSwim_TSword_pilihuixuanzhan = "pilihuixuanzhan",
  Rider01_TSword_pilihuixuanzhan = "pilihuixuanzhan",
  Rider02_TSword_pilihuixuanzhan = "pilihuixuanzhan",
  DarkHorse_TSword_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblack_TSword_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblue_TSword_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilgold_TSword_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilred_TSword_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_Wing_TSword_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_Swim_TSword_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_NoSwim_Spear_pilihuixuanzhan = "pilihuixuanzhan",
  Rider01_Spear_pilihuixuanzhan = "pilihuixuanzhan",
  Rider02_Spear_pilihuixuanzhan = "pilihuixuanzhan",
  DarkHorse_Spear_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblack_Spear_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblue_Spear_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilgold_Spear_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilred_Spear_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_Wing_Spear_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_Swim_Spear_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_NoSwim_TStaff_pilihuixuanzhan = "pilihuixuanzhan",
  Rider01_TStaff_pilihuixuanzhan = "pilihuixuanzhan",
  Rider02_TStaff_pilihuixuanzhan = "pilihuixuanzhan",
  DarkHorse_TStaff_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblack_TStaff_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblue_TStaff_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilgold_TStaff_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilred_TStaff_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_Wing_TStaff_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_Swim_TStaff_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_NoSwim_Bow_pilihuixuanzhan = "pilihuixuanzhan",
  Rider01_Bow_pilihuixuanzhan = "pilihuixuanzhan",
  Rider02_Bow_pilihuixuanzhan = "pilihuixuanzhan",
  DarkHorse_Bow_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblack_Bow_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblue_Bow_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilgold_Bow_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilred_Bow_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_Wing_Bow_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_Swim_Bow_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_NoSwim_Crossbow_pilihuixuanzhan = "pilihuixuanzhan",
  Rider01_Crossbow_pilihuixuanzhan = "pilihuixuanzhan",
  Rider02_Crossbow_pilihuixuanzhan = "pilihuixuanzhan",
  DarkHorse_Crossbow_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblack_Crossbow_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblue_Crossbow_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilgold_Crossbow_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilred_Crossbow_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_Wing_Crossbow_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_Swim_Crossbow_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_NoSwim_Dweapon_pilihuixuanzhan = "pilihuixuanzhan",
  Rider01_Dweapon_pilihuixuanzhan = "pilihuixuanzhan",
  Rider02_Dweapon_pilihuixuanzhan = "pilihuixuanzhan",
  DarkHorse_Dweapon_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblack_Dweapon_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilblue_Dweapon_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilgold_Dweapon_pilihuixuanzhan = "pilihuixuanzhan",
  Fenrilred_Dweapon_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_Wing_Dweapon_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_Swim_Dweapon_pilihuixuanzhan = "pilihuixuanzhan",
  NoMount_NoWing_NoSwim_NoWeapon_zuanyunqiang = "zuanyunqiang",
  Rider01_NoWeapon_zuanyunqiang = "zuanyunqiang",
  Rider02_NoWeapon_zuanyunqiang = "zuanyunqiang",
  DarkHorse_NoWeapon_zuanyunqiang = "zuanyunqiang",
  Fenrilblack_NoWeapon_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilblue_NoWeapon_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilgold_NoWeapon_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilred_NoWeapon_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  NoMount_Wing_NoWeapon_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_Swim_NoWeapon_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_NoSwim_OneHand_zuanyunqiang = "zuanyunqiang",
  Rider01_OneHand_zuanyunqiang = "zuanyunqiang",
  Rider02_OneHand_zuanyunqiang = "zuanyunqiang",
  DarkHorse_OneHand_zuanyunqiang = "zuanyunqiang",
  Fenrilblack_OneHand_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilblue_OneHand_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilgold_OneHand_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilred_OneHand_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  NoMount_Wing_OneHand_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_Swim_OneHand_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_NoSwim_TSword_zuanyunqiang = "zuanyunqiang",
  Rider01_TSword_zuanyunqiang = "zuanyunqiang",
  Rider02_TSword_zuanyunqiang = "zuanyunqiang",
  DarkHorse_TSword_zuanyunqiang = "zuanyunqiang",
  Fenrilblack_TSword_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilblue_TSword_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilgold_TSword_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilred_TSword_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  NoMount_Wing_TSword_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_Swim_TSword_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_NoSwim_Spear_zuanyunqiang = "zuanyunqiang",
  Rider01_Spear_zuanyunqiang = "zuanyunqiang",
  Rider02_Spear_zuanyunqiang = "zuanyunqiang",
  DarkHorse_Spear_zuanyunqiang = "zuanyunqiang",
  Fenrilblack_Spear_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilblue_Spear_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilgold_Spear_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilred_Spear_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  NoMount_Wing_Spear_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_Swim_Spear_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_NoSwim_TStaff_zuanyunqiang = "zuanyunqiang",
  Rider01_TStaff_zuanyunqiang = "zuanyunqiang",
  Rider02_TStaff_zuanyunqiang = "zuanyunqiang",
  DarkHorse_TStaff_zuanyunqiang = "zuanyunqiang",
  Fenrilblack_TStaff_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilblue_TStaff_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilgold_TStaff_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilred_TStaff_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  NoMount_Wing_TStaff_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_Swim_TStaff_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_NoSwim_Bow_zuanyunqiang = "zuanyunqiang",
  Rider01_Bow_zuanyunqiang = "zuanyunqiang",
  Rider02_Bow_zuanyunqiang = "zuanyunqiang",
  DarkHorse_Bow_zuanyunqiang = "zuanyunqiang",
  Fenrilblack_Bow_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilblue_Bow_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilgold_Bow_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilred_Bow_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  NoMount_Wing_Bow_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_Swim_Bow_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_NoSwim_Crossbow_zuanyunqiang = "zuanyunqiang",
  Rider01_Crossbow_zuanyunqiang = "zuanyunqiang",
  Rider02_Crossbow_zuanyunqiang = "zuanyunqiang",
  DarkHorse_Crossbow_zuanyunqiang = "zuanyunqiang",
  Fenrilblack_Crossbow_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilblue_Crossbow_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilgold_Crossbow_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilred_Crossbow_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  NoMount_Wing_Crossbow_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_Swim_Crossbow_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_NoSwim_Dweapon_zuanyunqiang = "zuanyunqiang",
  Rider01_Dweapon_zuanyunqiang = "zuanyunqiang",
  Rider02_Dweapon_zuanyunqiang = "zuanyunqiang",
  DarkHorse_Dweapon_zuanyunqiang = "zuanyunqiang",
  Fenrilblack_Dweapon_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilblue_Dweapon_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilgold_Dweapon_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  Fenrilred_Dweapon_zuanyunqiang = "Fenrilblack_zuanyunqiang",
  NoMount_Wing_Dweapon_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_Swim_Dweapon_zuanyunqiang = "zuanyunqiang",
  NoMount_NoWing_NoSwim_NoWeapon_liuxingyan = "liuxingyan",
  Rider01_NoWeapon_liuxingyan = "liuxingyan",
  Rider02_NoWeapon_liuxingyan = "liuxingyan",
  DarkHorse_NoWeapon_liuxingyan = "liuxingyan",
  Fenrilblack_NoWeapon_liuxingyan = "liuxingyan",
  Fenrilblue_NoWeapon_liuxingyan = "liuxingyan",
  Fenrilgold_NoWeapon_liuxingyan = "liuxingyan",
  Fenrilred_NoWeapon_liuxingyan = "liuxingyan",
  NoMount_Wing_NoWeapon_liuxingyan = "liuxingyan",
  NoMount_NoWing_Swim_NoWeapon_liuxingyan = "liuxingyan",
  NoMount_NoWing_NoSwim_OneHand_liuxingyan = "liuxingyan",
  Rider01_OneHand_liuxingyan = "liuxingyan",
  Rider02_OneHand_liuxingyan = "liuxingyan",
  DarkHorse_OneHand_liuxingyan = "liuxingyan",
  Fenrilblack_OneHand_liuxingyan = "liuxingyan",
  Fenrilblue_OneHand_liuxingyan = "liuxingyan",
  Fenrilgold_OneHand_liuxingyan = "liuxingyan",
  Fenrilred_OneHand_liuxingyan = "liuxingyan",
  NoMount_Wing_OneHand_liuxingyan = "liuxingyan",
  NoMount_NoWing_Swim_OneHand_liuxingyan = "liuxingyan",
  NoMount_NoWing_NoSwim_TSword_liuxingyan = "liuxingyan",
  Rider01_TSword_liuxingyan = "liuxingyan",
  Rider02_TSword_liuxingyan = "liuxingyan",
  DarkHorse_TSword_liuxingyan = "liuxingyan",
  Fenrilblack_TSword_liuxingyan = "liuxingyan",
  Fenrilblue_TSword_liuxingyan = "liuxingyan",
  Fenrilgold_TSword_liuxingyan = "liuxingyan",
  Fenrilred_TSword_liuxingyan = "liuxingyan",
  NoMount_Wing_TSword_liuxingyan = "liuxingyan",
  NoMount_NoWing_Swim_TSword_liuxingyan = "liuxingyan",
  NoMount_NoWing_NoSwim_Spear_liuxingyan = "liuxingyan",
  Rider01_Spear_liuxingyan = "liuxingyan",
  Rider02_Spear_liuxingyan = "liuxingyan",
  DarkHorse_Spear_liuxingyan = "liuxingyan",
  Fenrilblack_Spear_liuxingyan = "liuxingyan",
  Fenrilblue_Spear_liuxingyan = "liuxingyan",
  Fenrilgold_Spear_liuxingyan = "liuxingyan",
  Fenrilred_Spear_liuxingyan = "liuxingyan",
  NoMount_Wing_Spear_liuxingyan = "liuxingyan",
  NoMount_NoWing_Swim_Spear_liuxingyan = "liuxingyan",
  NoMount_NoWing_NoSwim_TStaff_liuxingyan = "liuxingyan",
  Rider01_TStaff_liuxingyan = "liuxingyan",
  Rider02_TStaff_liuxingyan = "liuxingyan",
  DarkHorse_TStaff_liuxingyan = "liuxingyan",
  Fenrilblack_TStaff_liuxingyan = "liuxingyan",
  Fenrilblue_TStaff_liuxingyan = "liuxingyan",
  Fenrilgold_TStaff_liuxingyan = "liuxingyan",
  Fenrilred_TStaff_liuxingyan = "liuxingyan",
  NoMount_Wing_TStaff_liuxingyan = "liuxingyan",
  NoMount_NoWing_Swim_TStaff_liuxingyan = "liuxingyan",
  NoMount_NoWing_NoSwim_Bow_liuxingyan = "liuxingyan",
  Rider01_Bow_liuxingyan = "liuxingyan",
  Rider02_Bow_liuxingyan = "liuxingyan",
  DarkHorse_Bow_liuxingyan = "liuxingyan",
  Fenrilblack_Bow_liuxingyan = "liuxingyan",
  Fenrilblue_Bow_liuxingyan = "liuxingyan",
  Fenrilgold_Bow_liuxingyan = "liuxingyan",
  Fenrilred_Bow_liuxingyan = "liuxingyan",
  NoMount_Wing_Bow_liuxingyan = "liuxingyan",
  NoMount_NoWing_Swim_Bow_liuxingyan = "liuxingyan",
  NoMount_NoWing_NoSwim_Crossbow_liuxingyan = "liuxingyan",
  Rider01_Crossbow_liuxingyan = "liuxingyan",
  Rider02_Crossbow_liuxingyan = "liuxingyan",
  DarkHorse_Crossbow_liuxingyan = "liuxingyan",
  Fenrilblack_Crossbow_liuxingyan = "liuxingyan",
  Fenrilblue_Crossbow_liuxingyan = "liuxingyan",
  Fenrilgold_Crossbow_liuxingyan = "liuxingyan",
  Fenrilred_Crossbow_liuxingyan = "liuxingyan",
  NoMount_Wing_Crossbow_liuxingyan = "liuxingyan",
  NoMount_NoWing_Swim_Crossbow_liuxingyan = "liuxingyan",
  NoMount_NoWing_NoSwim_Dweapon_liuxingyan = "liuxingyan",
  Rider01_Dweapon_liuxingyan = "liuxingyan",
  Rider02_Dweapon_liuxingyan = "liuxingyan",
  DarkHorse_Dweapon_liuxingyan = "liuxingyan",
  Fenrilblack_Dweapon_liuxingyan = "liuxingyan",
  Fenrilblue_Dweapon_liuxingyan = "liuxingyan",
  Fenrilgold_Dweapon_liuxingyan = "liuxingyan",
  Fenrilred_Dweapon_liuxingyan = "liuxingyan",
  NoMount_Wing_Dweapon_liuxingyan = "liuxingyan",
  NoMount_NoWing_Swim_Dweapon_liuxingyan = "liuxingyan",
  NoMount_NoWing_NoSwim_NoWeapon_shengmingzhiguang = "shengmingzhiguang",
  Rider01_NoWeapon_shengmingzhiguang = "shengmingzhiguang",
  Rider02_NoWeapon_shengmingzhiguang = "shengmingzhiguang",
  DarkHorse_NoWeapon_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblack_NoWeapon_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblue_NoWeapon_shengmingzhiguang = "shengmingzhiguang",
  Fenrilgold_NoWeapon_shengmingzhiguang = "shengmingzhiguang",
  Fenrilred_NoWeapon_shengmingzhiguang = "shengmingzhiguang",
  NoMount_Wing_NoWeapon_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_Swim_NoWeapon_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_NoSwim_OneHand_shengmingzhiguang = "shengmingzhiguang",
  Rider01_OneHand_shengmingzhiguang = "shengmingzhiguang",
  Rider02_OneHand_shengmingzhiguang = "shengmingzhiguang",
  DarkHorse_OneHand_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblack_OneHand_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblue_OneHand_shengmingzhiguang = "shengmingzhiguang",
  Fenrilgold_OneHand_shengmingzhiguang = "shengmingzhiguang",
  Fenrilred_OneHand_shengmingzhiguang = "shengmingzhiguang",
  NoMount_Wing_OneHand_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_Swim_OneHand_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_NoSwim_TSword_shengmingzhiguang = "shengmingzhiguang",
  Rider01_TSword_shengmingzhiguang = "shengmingzhiguang",
  Rider02_TSword_shengmingzhiguang = "shengmingzhiguang",
  DarkHorse_TSword_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblack_TSword_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblue_TSword_shengmingzhiguang = "shengmingzhiguang",
  Fenrilgold_TSword_shengmingzhiguang = "shengmingzhiguang",
  Fenrilred_TSword_shengmingzhiguang = "shengmingzhiguang",
  NoMount_Wing_TSword_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_Swim_TSword_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_NoSwim_Spear_shengmingzhiguang = "shengmingzhiguang",
  Rider01_Spear_shengmingzhiguang = "shengmingzhiguang",
  Rider02_Spear_shengmingzhiguang = "shengmingzhiguang",
  DarkHorse_Spear_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblack_Spear_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblue_Spear_shengmingzhiguang = "shengmingzhiguang",
  Fenrilgold_Spear_shengmingzhiguang = "shengmingzhiguang",
  Fenrilred_Spear_shengmingzhiguang = "shengmingzhiguang",
  NoMount_Wing_Spear_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_Swim_Spear_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_NoSwim_TStaff_shengmingzhiguang = "shengmingzhiguang",
  Rider01_TStaff_shengmingzhiguang = "shengmingzhiguang",
  Rider02_TStaff_shengmingzhiguang = "shengmingzhiguang",
  DarkHorse_TStaff_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblack_TStaff_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblue_TStaff_shengmingzhiguang = "shengmingzhiguang",
  Fenrilgold_TStaff_shengmingzhiguang = "shengmingzhiguang",
  Fenrilred_TStaff_shengmingzhiguang = "shengmingzhiguang",
  NoMount_Wing_TStaff_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_Swim_TStaff_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_NoSwim_Bow_shengmingzhiguang = "shengmingzhiguang",
  Rider01_Bow_shengmingzhiguang = "shengmingzhiguang",
  Rider02_Bow_shengmingzhiguang = "shengmingzhiguang",
  DarkHorse_Bow_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblack_Bow_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblue_Bow_shengmingzhiguang = "shengmingzhiguang",
  Fenrilgold_Bow_shengmingzhiguang = "shengmingzhiguang",
  Fenrilred_Bow_shengmingzhiguang = "shengmingzhiguang",
  NoMount_Wing_Bow_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_Swim_Bow_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_NoSwim_Crossbow_shengmingzhiguang = "shengmingzhiguang",
  Rider01_Crossbow_shengmingzhiguang = "shengmingzhiguang",
  Rider02_Crossbow_shengmingzhiguang = "shengmingzhiguang",
  DarkHorse_Crossbow_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblack_Crossbow_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblue_Crossbow_shengmingzhiguang = "shengmingzhiguang",
  Fenrilgold_Crossbow_shengmingzhiguang = "shengmingzhiguang",
  Fenrilred_Crossbow_shengmingzhiguang = "shengmingzhiguang",
  NoMount_Wing_Crossbow_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_Swim_Crossbow_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_NoSwim_Dweapon_shengmingzhiguang = "shengmingzhiguang",
  Rider01_Dweapon_shengmingzhiguang = "shengmingzhiguang",
  Rider02_Dweapon_shengmingzhiguang = "shengmingzhiguang",
  DarkHorse_Dweapon_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblack_Dweapon_shengmingzhiguang = "shengmingzhiguang",
  Fenrilblue_Dweapon_shengmingzhiguang = "shengmingzhiguang",
  Fenrilgold_Dweapon_shengmingzhiguang = "shengmingzhiguang",
  Fenrilred_Dweapon_shengmingzhiguang = "shengmingzhiguang",
  NoMount_Wing_Dweapon_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_Swim_Dweapon_shengmingzhiguang = "shengmingzhiguang",
  NoMount_NoWing_NoSwim_NoWeapon_xifengci = "xifengci",
  Rider01_NoWeapon_xifengci = "xifengci",
  Rider02_NoWeapon_xifengci = "xifengci",
  DarkHorse_NoWeapon_xifengci = "xifengci",
  Fenrilblack_NoWeapon_xifengci = "xifengci",
  Fenrilblue_NoWeapon_xifengci = "xifengci",
  Fenrilgold_NoWeapon_xifengci = "xifengci",
  Fenrilred_NoWeapon_xifengci = "xifengci",
  NoMount_Wing_NoWeapon_xifengci = "xifengci",
  NoMount_NoWing_Swim_NoWeapon_xifengci = "xifengci",
  NoMount_NoWing_NoSwim_OneHand_xifengci = "xifengci",
  Rider01_OneHand_xifengci = "xifengci",
  Rider02_OneHand_xifengci = "xifengci",
  DarkHorse_OneHand_xifengci = "xifengci",
  Fenrilblack_OneHand_xifengci = "xifengci",
  Fenrilblue_OneHand_xifengci = "xifengci",
  Fenrilgold_OneHand_xifengci = "xifengci",
  Fenrilred_OneHand_xifengci = "xifengci",
  NoMount_Wing_OneHand_xifengci = "xifengci",
  NoMount_NoWing_Swim_OneHand_xifengci = "xifengci",
  NoMount_NoWing_NoSwim_TSword_xifengci = "xifengci",
  Rider01_TSword_xifengci = "xifengci",
  Rider02_TSword_xifengci = "xifengci",
  DarkHorse_TSword_xifengci = "xifengci",
  Fenrilblack_TSword_xifengci = "xifengci",
  Fenrilblue_TSword_xifengci = "xifengci",
  Fenrilgold_TSword_xifengci = "xifengci",
  Fenrilred_TSword_xifengci = "xifengci",
  NoMount_Wing_TSword_xifengci = "xifengci",
  NoMount_NoWing_Swim_TSword_xifengci = "xifengci",
  NoMount_NoWing_NoSwim_Spear_xifengci = "xifengci",
  Rider01_Spear_xifengci = "xifengci",
  Rider02_Spear_xifengci = "xifengci",
  DarkHorse_Spear_xifengci = "xifengci",
  Fenrilblack_Spear_xifengci = "xifengci",
  Fenrilblue_Spear_xifengci = "xifengci",
  Fenrilgold_Spear_xifengci = "xifengci",
  Fenrilred_Spear_xifengci = "xifengci",
  NoMount_Wing_Spear_xifengci = "xifengci",
  NoMount_NoWing_Swim_Spear_xifengci = "xifengci",
  NoMount_NoWing_NoSwim_TStaff_xifengci = "xifengci",
  Rider01_TStaff_xifengci = "xifengci",
  Rider02_TStaff_xifengci = "xifengci",
  DarkHorse_TStaff_xifengci = "xifengci",
  Fenrilblack_TStaff_xifengci = "xifengci",
  Fenrilblue_TStaff_xifengci = "xifengci",
  Fenrilgold_TStaff_xifengci = "xifengci",
  Fenrilred_TStaff_xifengci = "xifengci",
  NoMount_Wing_TStaff_xifengci = "xifengci",
  NoMount_NoWing_Swim_TStaff_xifengci = "xifengci",
  NoMount_NoWing_NoSwim_Bow_xifengci = "xifengci",
  Rider01_Bow_xifengci = "xifengci",
  Rider02_Bow_xifengci = "xifengci",
  DarkHorse_Bow_xifengci = "xifengci",
  Fenrilblack_Bow_xifengci = "xifengci",
  Fenrilblue_Bow_xifengci = "xifengci",
  Fenrilgold_Bow_xifengci = "xifengci",
  Fenrilred_Bow_xifengci = "xifengci",
  NoMount_Wing_Bow_xifengci = "xifengci",
  NoMount_NoWing_Swim_Bow_xifengci = "xifengci",
  NoMount_NoWing_NoSwim_Crossbow_xifengci = "xifengci",
  Rider01_Crossbow_xifengci = "xifengci",
  Rider02_Crossbow_xifengci = "xifengci",
  DarkHorse_Crossbow_xifengci = "xifengci",
  Fenrilblack_Crossbow_xifengci = "xifengci",
  Fenrilblue_Crossbow_xifengci = "xifengci",
  Fenrilgold_Crossbow_xifengci = "xifengci",
  Fenrilred_Crossbow_xifengci = "xifengci",
  NoMount_Wing_Crossbow_xifengci = "xifengci",
  NoMount_NoWing_Swim_Crossbow_xifengci = "xifengci",
  NoMount_NoWing_NoSwim_Dweapon_xifengci = "xifengci",
  Rider01_Dweapon_xifengci = "xifengci",
  Rider02_Dweapon_xifengci = "xifengci",
  DarkHorse_Dweapon_xifengci = "xifengci",
  Fenrilblack_Dweapon_xifengci = "xifengci",
  Fenrilblue_Dweapon_xifengci = "xifengci",
  Fenrilgold_Dweapon_xifengci = "xifengci",
  Fenrilred_Dweapon_xifengci = "xifengci",
  NoMount_Wing_Dweapon_xifengci = "xifengci",
  NoMount_NoWing_Swim_Dweapon_xifengci = "xifengci",
  NoMount_NoWing_NoSwim_NoWeapon_leitinglieshan = "leitinglieshan",
  Rider01_NoWeapon_leitinglieshan = "leitinglieshan",
  Rider02_NoWeapon_leitinglieshan = "leitinglieshan",
  DarkHorse_NoWeapon_leitinglieshan = "leitinglieshan",
  Fenrilblack_NoWeapon_leitinglieshan = "leitinglieshan",
  Fenrilblue_NoWeapon_leitinglieshan = "leitinglieshan",
  Fenrilgold_NoWeapon_leitinglieshan = "leitinglieshan",
  Fenrilred_NoWeapon_leitinglieshan = "leitinglieshan",
  NoMount_Wing_NoWeapon_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_Swim_NoWeapon_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_NoSwim_OneHand_leitinglieshan = "leitinglieshan",
  Rider01_OneHand_leitinglieshan = "leitinglieshan",
  Rider02_OneHand_leitinglieshan = "leitinglieshan",
  DarkHorse_OneHand_leitinglieshan = "leitinglieshan",
  Fenrilblack_OneHand_leitinglieshan = "leitinglieshan",
  Fenrilblue_OneHand_leitinglieshan = "leitinglieshan",
  Fenrilgold_OneHand_leitinglieshan = "leitinglieshan",
  Fenrilred_OneHand_leitinglieshan = "leitinglieshan",
  NoMount_Wing_OneHand_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_Swim_OneHand_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_NoSwim_TSword_leitinglieshan = "leitinglieshan",
  Rider01_TSword_leitinglieshan = "leitinglieshan",
  Rider02_TSword_leitinglieshan = "leitinglieshan",
  DarkHorse_TSword_leitinglieshan = "leitinglieshan",
  Fenrilblack_TSword_leitinglieshan = "leitinglieshan",
  Fenrilblue_TSword_leitinglieshan = "leitinglieshan",
  Fenrilgold_TSword_leitinglieshan = "leitinglieshan",
  Fenrilred_TSword_leitinglieshan = "leitinglieshan",
  NoMount_Wing_TSword_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_Swim_TSword_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_NoSwim_Spear_leitinglieshan = "leitinglieshan",
  Rider01_Spear_leitinglieshan = "leitinglieshan",
  Rider02_Spear_leitinglieshan = "leitinglieshan",
  DarkHorse_Spear_leitinglieshan = "leitinglieshan",
  Fenrilblack_Spear_leitinglieshan = "leitinglieshan",
  Fenrilblue_Spear_leitinglieshan = "leitinglieshan",
  Fenrilgold_Spear_leitinglieshan = "leitinglieshan",
  Fenrilred_Spear_leitinglieshan = "leitinglieshan",
  NoMount_Wing_Spear_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_Swim_Spear_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_NoSwim_TStaff_leitinglieshan = "leitinglieshan",
  Rider01_TStaff_leitinglieshan = "leitinglieshan",
  Rider02_TStaff_leitinglieshan = "leitinglieshan",
  DarkHorse_TStaff_leitinglieshan = "leitinglieshan",
  Fenrilblack_TStaff_leitinglieshan = "leitinglieshan",
  Fenrilblue_TStaff_leitinglieshan = "leitinglieshan",
  Fenrilgold_TStaff_leitinglieshan = "leitinglieshan",
  Fenrilred_TStaff_leitinglieshan = "leitinglieshan",
  NoMount_Wing_TStaff_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_Swim_TStaff_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_NoSwim_Bow_leitinglieshan = "leitinglieshan",
  Rider01_Bow_leitinglieshan = "leitinglieshan",
  Rider02_Bow_leitinglieshan = "leitinglieshan",
  DarkHorse_Bow_leitinglieshan = "leitinglieshan",
  Fenrilblack_Bow_leitinglieshan = "leitinglieshan",
  Fenrilblue_Bow_leitinglieshan = "leitinglieshan",
  Fenrilgold_Bow_leitinglieshan = "leitinglieshan",
  Fenrilred_Bow_leitinglieshan = "leitinglieshan",
  NoMount_Wing_Bow_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_Swim_Bow_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_NoSwim_Crossbow_leitinglieshan = "leitinglieshan",
  Rider01_Crossbow_leitinglieshan = "leitinglieshan",
  Rider02_Crossbow_leitinglieshan = "leitinglieshan",
  DarkHorse_Crossbow_leitinglieshan = "leitinglieshan",
  Fenrilblack_Crossbow_leitinglieshan = "leitinglieshan",
  Fenrilblue_Crossbow_leitinglieshan = "leitinglieshan",
  Fenrilgold_Crossbow_leitinglieshan = "leitinglieshan",
  Fenrilred_Crossbow_leitinglieshan = "leitinglieshan",
  NoMount_Wing_Crossbow_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_Swim_Crossbow_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_NoSwim_Dweapon_leitinglieshan = "leitinglieshan",
  Rider01_Dweapon_leitinglieshan = "leitinglieshan",
  Rider02_Dweapon_leitinglieshan = "leitinglieshan",
  DarkHorse_Dweapon_leitinglieshan = "leitinglieshan",
  Fenrilblack_Dweapon_leitinglieshan = "leitinglieshan",
  Fenrilblue_Dweapon_leitinglieshan = "leitinglieshan",
  Fenrilgold_Dweapon_leitinglieshan = "leitinglieshan",
  Fenrilred_Dweapon_leitinglieshan = "leitinglieshan",
  NoMount_Wing_Dweapon_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_Swim_Dweapon_leitinglieshan = "leitinglieshan",
  NoMount_NoWing_NoSwim_NoWeapon_zhimingyiji = "zhimingyiji",
  Rider01_NoWeapon_zhimingyiji = "zhimingyiji",
  Rider02_NoWeapon_zhimingyiji = "zhimingyiji",
  DarkHorse_NoWeapon_zhimingyiji = "zhimingyiji",
  Fenrilblack_NoWeapon_zhimingyiji = "zhimingyiji",
  Fenrilblue_NoWeapon_zhimingyiji = "zhimingyiji",
  Fenrilgold_NoWeapon_zhimingyiji = "zhimingyiji",
  Fenrilred_NoWeapon_zhimingyiji = "zhimingyiji",
  NoMount_Wing_NoWeapon_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_Swim_NoWeapon_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_NoSwim_OneHand_zhimingyiji = "zhimingyiji",
  Rider01_OneHand_zhimingyiji = "zhimingyiji",
  Rider02_OneHand_zhimingyiji = "zhimingyiji",
  DarkHorse_OneHand_zhimingyiji = "zhimingyiji",
  Fenrilblack_OneHand_zhimingyiji = "zhimingyiji",
  Fenrilblue_OneHand_zhimingyiji = "zhimingyiji",
  Fenrilgold_OneHand_zhimingyiji = "zhimingyiji",
  Fenrilred_OneHand_zhimingyiji = "zhimingyiji",
  NoMount_Wing_OneHand_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_Swim_OneHand_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_NoSwim_TSword_zhimingyiji = "zhimingyiji",
  Rider01_TSword_zhimingyiji = "zhimingyiji",
  Rider02_TSword_zhimingyiji = "zhimingyiji",
  DarkHorse_TSword_zhimingyiji = "zhimingyiji",
  Fenrilblack_TSword_zhimingyiji = "zhimingyiji",
  Fenrilblue_TSword_zhimingyiji = "zhimingyiji",
  Fenrilgold_TSword_zhimingyiji = "zhimingyiji",
  Fenrilred_TSword_zhimingyiji = "zhimingyiji",
  NoMount_Wing_TSword_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_Swim_TSword_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_NoSwim_Spear_zhimingyiji = "zhimingyiji",
  Rider01_Spear_zhimingyiji = "zhimingyiji",
  Rider02_Spear_zhimingyiji = "zhimingyiji",
  DarkHorse_Spear_zhimingyiji = "zhimingyiji",
  Fenrilblack_Spear_zhimingyiji = "zhimingyiji",
  Fenrilblue_Spear_zhimingyiji = "zhimingyiji",
  Fenrilgold_Spear_zhimingyiji = "zhimingyiji",
  Fenrilred_Spear_zhimingyiji = "zhimingyiji",
  NoMount_Wing_Spear_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_Swim_Spear_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_NoSwim_TStaff_zhimingyiji = "zhimingyiji",
  Rider01_TStaff_zhimingyiji = "zhimingyiji",
  Rider02_TStaff_zhimingyiji = "zhimingyiji",
  DarkHorse_TStaff_zhimingyiji = "zhimingyiji",
  Fenrilblack_TStaff_zhimingyiji = "zhimingyiji",
  Fenrilblue_TStaff_zhimingyiji = "zhimingyiji",
  Fenrilgold_TStaff_zhimingyiji = "zhimingyiji",
  Fenrilred_TStaff_zhimingyiji = "zhimingyiji",
  NoMount_Wing_TStaff_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_Swim_TStaff_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_NoSwim_Bow_zhimingyiji = "zhimingyiji",
  Rider01_Bow_zhimingyiji = "zhimingyiji",
  Rider02_Bow_zhimingyiji = "zhimingyiji",
  DarkHorse_Bow_zhimingyiji = "zhimingyiji",
  Fenrilblack_Bow_zhimingyiji = "zhimingyiji",
  Fenrilblue_Bow_zhimingyiji = "zhimingyiji",
  Fenrilgold_Bow_zhimingyiji = "zhimingyiji",
  Fenrilred_Bow_zhimingyiji = "zhimingyiji",
  NoMount_Wing_Bow_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_Swim_Bow_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_NoSwim_Crossbow_zhimingyiji = "zhimingyiji",
  Rider01_Crossbow_zhimingyiji = "zhimingyiji",
  Rider02_Crossbow_zhimingyiji = "zhimingyiji",
  DarkHorse_Crossbow_zhimingyiji = "zhimingyiji",
  Fenrilblack_Crossbow_zhimingyiji = "zhimingyiji",
  Fenrilblue_Crossbow_zhimingyiji = "zhimingyiji",
  Fenrilgold_Crossbow_zhimingyiji = "zhimingyiji",
  Fenrilred_Crossbow_zhimingyiji = "zhimingyiji",
  NoMount_Wing_Crossbow_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_Swim_Crossbow_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_NoSwim_Dweapon_zhimingyiji = "zhimingyiji",
  Rider01_Dweapon_zhimingyiji = "zhimingyiji",
  Rider02_Dweapon_zhimingyiji = "zhimingyiji",
  DarkHorse_Dweapon_zhimingyiji = "zhimingyiji",
  Fenrilblack_Dweapon_zhimingyiji = "zhimingyiji",
  Fenrilblue_Dweapon_zhimingyiji = "zhimingyiji",
  Fenrilgold_Dweapon_zhimingyiji = "zhimingyiji",
  Fenrilred_Dweapon_zhimingyiji = "zhimingyiji",
  NoMount_Wing_Dweapon_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_Swim_Dweapon_zhimingyiji = "zhimingyiji",
  NoMount_NoWing_NoSwim_NoWeapon_banyuezhan = "banyuezhan",
  Rider01_NoWeapon_banyuezhan = "banyuezhan",
  Rider02_NoWeapon_banyuezhan = "banyuezhan",
  DarkHorse_NoWeapon_banyuezhan = "banyuezhan",
  Fenrilblack_NoWeapon_banyuezhan = "banyuezhan",
  Fenrilblue_NoWeapon_banyuezhan = "banyuezhan",
  Fenrilgold_NoWeapon_banyuezhan = "banyuezhan",
  Fenrilred_NoWeapon_banyuezhan = "banyuezhan",
  NoMount_Wing_NoWeapon_banyuezhan = "banyuezhan",
  NoMount_NoWing_Swim_NoWeapon_banyuezhan = "banyuezhan",
  NoMount_NoWing_NoSwim_OneHand_banyuezhan = "banyuezhan",
  Rider01_OneHand_banyuezhan = "banyuezhan",
  Rider02_OneHand_banyuezhan = "banyuezhan",
  DarkHorse_OneHand_banyuezhan = "banyuezhan",
  Fenrilblack_OneHand_banyuezhan = "banyuezhan",
  Fenrilblue_OneHand_banyuezhan = "banyuezhan",
  Fenrilgold_OneHand_banyuezhan = "banyuezhan",
  Fenrilred_OneHand_banyuezhan = "banyuezhan",
  NoMount_Wing_OneHand_banyuezhan = "banyuezhan",
  NoMount_NoWing_Swim_OneHand_banyuezhan = "banyuezhan",
  NoMount_NoWing_NoSwim_TSword_banyuezhan = "banyuezhan",
  Rider01_TSword_banyuezhan = "banyuezhan",
  Rider02_TSword_banyuezhan = "banyuezhan",
  DarkHorse_TSword_banyuezhan = "banyuezhan",
  Fenrilblack_TSword_banyuezhan = "banyuezhan",
  Fenrilblue_TSword_banyuezhan = "banyuezhan",
  Fenrilgold_TSword_banyuezhan = "banyuezhan",
  Fenrilred_TSword_banyuezhan = "banyuezhan",
  NoMount_Wing_TSword_banyuezhan = "banyuezhan",
  NoMount_NoWing_Swim_TSword_banyuezhan = "banyuezhan",
  NoMount_NoWing_NoSwim_Spear_banyuezhan = "banyuezhan",
  Rider01_Spear_banyuezhan = "banyuezhan",
  Rider02_Spear_banyuezhan = "banyuezhan",
  DarkHorse_Spear_banyuezhan = "banyuezhan",
  Fenrilblack_Spear_banyuezhan = "banyuezhan",
  Fenrilblue_Spear_banyuezhan = "banyuezhan",
  Fenrilgold_Spear_banyuezhan = "banyuezhan",
  Fenrilred_Spear_banyuezhan = "banyuezhan",
  NoMount_Wing_Spear_banyuezhan = "banyuezhan",
  NoMount_NoWing_Swim_Spear_banyuezhan = "banyuezhan",
  NoMount_NoWing_NoSwim_TStaff_banyuezhan = "banyuezhan",
  Rider01_TStaff_banyuezhan = "banyuezhan",
  Rider02_TStaff_banyuezhan = "banyuezhan",
  DarkHorse_TStaff_banyuezhan = "banyuezhan",
  Fenrilblack_TStaff_banyuezhan = "banyuezhan",
  Fenrilblue_TStaff_banyuezhan = "banyuezhan",
  Fenrilgold_TStaff_banyuezhan = "banyuezhan",
  Fenrilred_TStaff_banyuezhan = "banyuezhan",
  NoMount_Wing_TStaff_banyuezhan = "banyuezhan",
  NoMount_NoWing_Swim_TStaff_banyuezhan = "banyuezhan",
  NoMount_NoWing_NoSwim_Bow_banyuezhan = "banyuezhan",
  Rider01_Bow_banyuezhan = "banyuezhan",
  Rider02_Bow_banyuezhan = "banyuezhan",
  DarkHorse_Bow_banyuezhan = "banyuezhan",
  Fenrilblack_Bow_banyuezhan = "banyuezhan",
  Fenrilblue_Bow_banyuezhan = "banyuezhan",
  Fenrilgold_Bow_banyuezhan = "banyuezhan",
  Fenrilred_Bow_banyuezhan = "banyuezhan",
  NoMount_Wing_Bow_banyuezhan = "banyuezhan",
  NoMount_NoWing_Swim_Bow_banyuezhan = "banyuezhan",
  NoMount_NoWing_NoSwim_Crossbow_banyuezhan = "banyuezhan",
  Rider01_Crossbow_banyuezhan = "banyuezhan",
  Rider02_Crossbow_banyuezhan = "banyuezhan",
  DarkHorse_Crossbow_banyuezhan = "banyuezhan",
  Fenrilblack_Crossbow_banyuezhan = "banyuezhan",
  Fenrilblue_Crossbow_banyuezhan = "banyuezhan",
  Fenrilgold_Crossbow_banyuezhan = "banyuezhan",
  Fenrilred_Crossbow_banyuezhan = "banyuezhan",
  NoMount_Wing_Crossbow_banyuezhan = "banyuezhan",
  NoMount_NoWing_Swim_Crossbow_banyuezhan = "banyuezhan",
  NoMount_NoWing_NoSwim_Dweapon_banyuezhan = "banyuezhan",
  Rider01_Dweapon_banyuezhan = "banyuezhan",
  Rider02_Dweapon_banyuezhan = "banyuezhan",
  DarkHorse_Dweapon_banyuezhan = "banyuezhan",
  Fenrilblack_Dweapon_banyuezhan = "banyuezhan",
  Fenrilblue_Dweapon_banyuezhan = "banyuezhan",
  Fenrilgold_Dweapon_banyuezhan = "banyuezhan",
  Fenrilred_Dweapon_banyuezhan = "banyuezhan",
  NoMount_Wing_Dweapon_banyuezhan = "banyuezhan",
  NoMount_NoWing_Swim_Dweapon_banyuezhan = "banyuezhan",
  NoMount_NoWing_NoSwim_NoWeapon_nengliangqiu01 = "nengliangqiu01",
  Rider01_NoWeapon_nengliangqiu01 = "Rider01_nengliangqiu01",
  Rider02_NoWeapon_nengliangqiu01 = "Rider01_nengliangqiu01",
  DarkHorse_NoWeapon_nengliangqiu01 = "DarkHorse_nengliangqiu01",
  Fenrilblack_NoWeapon_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilblue_NoWeapon_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilgold_NoWeapon_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilred_NoWeapon_nengliangqiu01 = "Fenrilblack_attack01",
  NoMount_Wing_NoWeapon_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_Swim_NoWeapon_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_NoSwim_OneHand_nengliangqiu01 = "nengliangqiu01",
  Rider01_OneHand_nengliangqiu01 = "Rider01_nengliangqiu01",
  Rider02_OneHand_nengliangqiu01 = "Rider01_nengliangqiu01",
  DarkHorse_OneHand_nengliangqiu01 = "DarkHorse_nengliangqiu01",
  Fenrilblack_OneHand_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilblue_OneHand_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilgold_OneHand_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilred_OneHand_nengliangqiu01 = "Fenrilblack_attack01",
  NoMount_Wing_OneHand_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_Swim_OneHand_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_NoSwim_TSword_nengliangqiu01 = "nengliangqiu01",
  Rider01_TSword_nengliangqiu01 = "Rider01_nengliangqiu01",
  Rider02_TSword_nengliangqiu01 = "Rider01_nengliangqiu01",
  DarkHorse_TSword_nengliangqiu01 = "DarkHorse_nengliangqiu01",
  Fenrilblack_TSword_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilblue_TSword_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilgold_TSword_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilred_TSword_nengliangqiu01 = "Fenrilblack_attack01",
  NoMount_Wing_TSword_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_Swim_TSword_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_NoSwim_Spear_nengliangqiu01 = "nengliangqiu01",
  Rider01_Spear_nengliangqiu01 = "Rider01_nengliangqiu01",
  Rider02_Spear_nengliangqiu01 = "Rider01_nengliangqiu01",
  DarkHorse_Spear_nengliangqiu01 = "DarkHorse_nengliangqiu01",
  Fenrilblack_Spear_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilblue_Spear_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilgold_Spear_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilred_Spear_nengliangqiu01 = "Fenrilblack_attack01",
  NoMount_Wing_Spear_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_Swim_Spear_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_NoSwim_TStaff_nengliangqiu01 = "nengliangqiu01",
  Rider01_TStaff_nengliangqiu01 = "Rider01_nengliangqiu01",
  Rider02_TStaff_nengliangqiu01 = "Rider01_nengliangqiu01",
  DarkHorse_TStaff_nengliangqiu01 = "DarkHorse_nengliangqiu01",
  Fenrilblack_TStaff_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilblue_TStaff_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilgold_TStaff_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilred_TStaff_nengliangqiu01 = "Fenrilblack_attack01",
  NoMount_Wing_TStaff_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_Swim_TStaff_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_NoSwim_Bow_nengliangqiu01 = "nengliangqiu01",
  Rider01_Bow_nengliangqiu01 = "Rider01_nengliangqiu01",
  Rider02_Bow_nengliangqiu01 = "Rider01_nengliangqiu01",
  DarkHorse_Bow_nengliangqiu01 = "DarkHorse_nengliangqiu01",
  Fenrilblack_Bow_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilblue_Bow_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilgold_Bow_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilred_Bow_nengliangqiu01 = "Fenrilblack_attack01",
  NoMount_Wing_Bow_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_Swim_Bow_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_NoSwim_Crossbow_nengliangqiu01 = "nengliangqiu01",
  Rider01_Crossbow_nengliangqiu01 = "Rider01_nengliangqiu01",
  Rider02_Crossbow_nengliangqiu01 = "Rider01_nengliangqiu01",
  DarkHorse_Crossbow_nengliangqiu01 = "DarkHorse_nengliangqiu01",
  Fenrilblack_Crossbow_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilblue_Crossbow_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilgold_Crossbow_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilred_Crossbow_nengliangqiu01 = "Fenrilblack_attack01",
  NoMount_Wing_Crossbow_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_Swim_Crossbow_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_NoSwim_Dweapon_nengliangqiu01 = "nengliangqiu01",
  Rider01_Dweapon_nengliangqiu01 = "Rider01_nengliangqiu01",
  Rider02_Dweapon_nengliangqiu01 = "Rider01_nengliangqiu01",
  DarkHorse_Dweapon_nengliangqiu01 = "DarkHorse_nengliangqiu01",
  Fenrilblack_Dweapon_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilblue_Dweapon_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilgold_Dweapon_nengliangqiu01 = "Fenrilblack_attack01",
  Fenrilred_Dweapon_nengliangqiu01 = "Fenrilblack_attack01",
  NoMount_Wing_Dweapon_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_Swim_Dweapon_nengliangqiu01 = "nengliangqiu01",
  NoMount_NoWing_NoSwim_NoWeapon_nengliangqiu02 = "nengliangqiu02",
  Rider01_NoWeapon_nengliangqiu02 = "Rider01_nengliangqiu01",
  Rider02_NoWeapon_nengliangqiu02 = "Rider01_nengliangqiu01",
  DarkHorse_NoWeapon_nengliangqiu02 = "DarkHorse_nengliangqiu01",
  Fenrilblack_NoWeapon_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilblue_NoWeapon_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilgold_NoWeapon_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilred_NoWeapon_nengliangqiu02 = "Fenrilblack_attack01",
  NoMount_Wing_NoWeapon_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_Swim_NoWeapon_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_NoSwim_OneHand_nengliangqiu02 = "nengliangqiu02",
  Rider01_OneHand_nengliangqiu02 = "Rider01_nengliangqiu01",
  Rider02_OneHand_nengliangqiu02 = "Rider01_nengliangqiu01",
  DarkHorse_OneHand_nengliangqiu02 = "DarkHorse_nengliangqiu01",
  Fenrilblack_OneHand_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilblue_OneHand_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilgold_OneHand_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilred_OneHand_nengliangqiu02 = "Fenrilblack_attack01",
  NoMount_Wing_OneHand_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_Swim_OneHand_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_NoSwim_TSword_nengliangqiu02 = "nengliangqiu02",
  Rider01_TSword_nengliangqiu02 = "Rider01_nengliangqiu01",
  Rider02_TSword_nengliangqiu02 = "Rider01_nengliangqiu01",
  DarkHorse_TSword_nengliangqiu02 = "DarkHorse_nengliangqiu01",
  Fenrilblack_TSword_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilblue_TSword_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilgold_TSword_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilred_TSword_nengliangqiu02 = "Fenrilblack_attack01",
  NoMount_Wing_TSword_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_Swim_TSword_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_NoSwim_Spear_nengliangqiu02 = "nengliangqiu02",
  Rider01_Spear_nengliangqiu02 = "Rider01_nengliangqiu01",
  Rider02_Spear_nengliangqiu02 = "Rider01_nengliangqiu01",
  DarkHorse_Spear_nengliangqiu02 = "DarkHorse_nengliangqiu01",
  Fenrilblack_Spear_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilblue_Spear_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilgold_Spear_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilred_Spear_nengliangqiu02 = "Fenrilblack_attack01",
  NoMount_Wing_Spear_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_Swim_Spear_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_NoSwim_TStaff_nengliangqiu02 = "nengliangqiu02",
  Rider01_TStaff_nengliangqiu02 = "Rider01_nengliangqiu01",
  Rider02_TStaff_nengliangqiu02 = "Rider01_nengliangqiu01",
  DarkHorse_TStaff_nengliangqiu02 = "DarkHorse_nengliangqiu01",
  Fenrilblack_TStaff_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilblue_TStaff_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilgold_TStaff_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilred_TStaff_nengliangqiu02 = "Fenrilblack_attack01",
  NoMount_Wing_TStaff_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_Swim_TStaff_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_NoSwim_Bow_nengliangqiu02 = "nengliangqiu02",
  Rider01_Bow_nengliangqiu02 = "Rider01_nengliangqiu01",
  Rider02_Bow_nengliangqiu02 = "Rider01_nengliangqiu01",
  DarkHorse_Bow_nengliangqiu02 = "DarkHorse_nengliangqiu01",
  Fenrilblack_Bow_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilblue_Bow_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilgold_Bow_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilred_Bow_nengliangqiu02 = "Fenrilblack_attack01",
  NoMount_Wing_Bow_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_Swim_Bow_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_NoSwim_Crossbow_nengliangqiu02 = "nengliangqiu02",
  Rider01_Crossbow_nengliangqiu02 = "Rider01_nengliangqiu01",
  Rider02_Crossbow_nengliangqiu02 = "Rider01_nengliangqiu01",
  DarkHorse_Crossbow_nengliangqiu02 = "DarkHorse_nengliangqiu01",
  Fenrilblack_Crossbow_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilblue_Crossbow_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilgold_Crossbow_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilred_Crossbow_nengliangqiu02 = "Fenrilblack_attack01",
  NoMount_Wing_Crossbow_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_Swim_Crossbow_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_NoSwim_Dweapon_nengliangqiu02 = "nengliangqiu02",
  Rider01_Dweapon_nengliangqiu02 = "Rider01_nengliangqiu01",
  Rider02_Dweapon_nengliangqiu02 = "Rider01_nengliangqiu01",
  DarkHorse_Dweapon_nengliangqiu02 = "DarkHorse_nengliangqiu01",
  Fenrilblack_Dweapon_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilblue_Dweapon_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilgold_Dweapon_nengliangqiu02 = "Fenrilblack_attack01",
  Fenrilred_Dweapon_nengliangqiu02 = "Fenrilblack_attack01",
  NoMount_Wing_Dweapon_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_Swim_Dweapon_nengliangqiu02 = "nengliangqiu02",
  NoMount_NoWing_NoSwim_NoWeapon_shunjianyidong = "shunjianyidong",
  Rider01_NoWeapon_shunjianyidong = "shunjianyidong",
  Rider02_NoWeapon_shunjianyidong = "shunjianyidong",
  DarkHorse_NoWeapon_shunjianyidong = "shunjianyidong",
  Fenrilblack_NoWeapon_shunjianyidong = "shunjianyidong",
  Fenrilblue_NoWeapon_shunjianyidong = "shunjianyidong",
  Fenrilgold_NoWeapon_shunjianyidong = "shunjianyidong",
  Fenrilred_NoWeapon_shunjianyidong = "shunjianyidong",
  NoMount_Wing_NoWeapon_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_Swim_NoWeapon_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_NoSwim_OneHand_shunjianyidong = "shunjianyidong",
  Rider01_OneHand_shunjianyidong = "shunjianyidong",
  Rider02_OneHand_shunjianyidong = "shunjianyidong",
  DarkHorse_OneHand_shunjianyidong = "shunjianyidong",
  Fenrilblack_OneHand_shunjianyidong = "shunjianyidong",
  Fenrilblue_OneHand_shunjianyidong = "shunjianyidong",
  Fenrilgold_OneHand_shunjianyidong = "shunjianyidong",
  Fenrilred_OneHand_shunjianyidong = "shunjianyidong",
  NoMount_Wing_OneHand_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_Swim_OneHand_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_NoSwim_TSword_shunjianyidong = "shunjianyidong",
  Rider01_TSword_shunjianyidong = "shunjianyidong",
  Rider02_TSword_shunjianyidong = "shunjianyidong",
  DarkHorse_TSword_shunjianyidong = "shunjianyidong",
  Fenrilblack_TSword_shunjianyidong = "shunjianyidong",
  Fenrilblue_TSword_shunjianyidong = "shunjianyidong",
  Fenrilgold_TSword_shunjianyidong = "shunjianyidong",
  Fenrilred_TSword_shunjianyidong = "shunjianyidong",
  NoMount_Wing_TSword_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_Swim_TSword_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_NoSwim_Spear_shunjianyidong = "shunjianyidong",
  Rider01_Spear_shunjianyidong = "shunjianyidong",
  Rider02_Spear_shunjianyidong = "shunjianyidong",
  DarkHorse_Spear_shunjianyidong = "shunjianyidong",
  Fenrilblack_Spear_shunjianyidong = "shunjianyidong",
  Fenrilblue_Spear_shunjianyidong = "shunjianyidong",
  Fenrilgold_Spear_shunjianyidong = "shunjianyidong",
  Fenrilred_Spear_shunjianyidong = "shunjianyidong",
  NoMount_Wing_Spear_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_Swim_Spear_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_NoSwim_TStaff_shunjianyidong = "shunjianyidong",
  Rider01_TStaff_shunjianyidong = "shunjianyidong",
  Rider02_TStaff_shunjianyidong = "shunjianyidong",
  DarkHorse_TStaff_shunjianyidong = "shunjianyidong",
  Fenrilblack_TStaff_shunjianyidong = "shunjianyidong",
  Fenrilblue_TStaff_shunjianyidong = "shunjianyidong",
  Fenrilgold_TStaff_shunjianyidong = "shunjianyidong",
  Fenrilred_TStaff_shunjianyidong = "shunjianyidong",
  NoMount_Wing_TStaff_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_Swim_TStaff_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_NoSwim_Bow_shunjianyidong = "shunjianyidong",
  Rider01_Bow_shunjianyidong = "shunjianyidong",
  Rider02_Bow_shunjianyidong = "shunjianyidong",
  DarkHorse_Bow_shunjianyidong = "shunjianyidong",
  Fenrilblack_Bow_shunjianyidong = "shunjianyidong",
  Fenrilblue_Bow_shunjianyidong = "shunjianyidong",
  Fenrilgold_Bow_shunjianyidong = "shunjianyidong",
  Fenrilred_Bow_shunjianyidong = "shunjianyidong",
  NoMount_Wing_Bow_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_Swim_Bow_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_NoSwim_Crossbow_shunjianyidong = "shunjianyidong",
  Rider01_Crossbow_shunjianyidong = "shunjianyidong",
  Rider02_Crossbow_shunjianyidong = "shunjianyidong",
  DarkHorse_Crossbow_shunjianyidong = "shunjianyidong",
  Fenrilblack_Crossbow_shunjianyidong = "shunjianyidong",
  Fenrilblue_Crossbow_shunjianyidong = "shunjianyidong",
  Fenrilgold_Crossbow_shunjianyidong = "shunjianyidong",
  Fenrilred_Crossbow_shunjianyidong = "shunjianyidong",
  NoMount_Wing_Crossbow_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_Swim_Crossbow_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_NoSwim_Dweapon_shunjianyidong = "shunjianyidong",
  Rider01_Dweapon_shunjianyidong = "shunjianyidong",
  Rider02_Dweapon_shunjianyidong = "shunjianyidong",
  DarkHorse_Dweapon_shunjianyidong = "shunjianyidong",
  Fenrilblack_Dweapon_shunjianyidong = "shunjianyidong",
  Fenrilblue_Dweapon_shunjianyidong = "shunjianyidong",
  Fenrilgold_Dweapon_shunjianyidong = "shunjianyidong",
  Fenrilred_Dweapon_shunjianyidong = "shunjianyidong",
  NoMount_Wing_Dweapon_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_Swim_Dweapon_shunjianyidong = "shunjianyidong",
  NoMount_NoWing_NoSwim_NoWeapon_diyuhuo = "diyuhuo",
  Rider01_NoWeapon_diyuhuo = "diyuhuo",
  Rider02_NoWeapon_diyuhuo = "diyuhuo",
  DarkHorse_NoWeapon_diyuhuo = "diyuhuo",
  Fenrilblack_NoWeapon_diyuhuo = "diyuhuo",
  Fenrilblue_NoWeapon_diyuhuo = "diyuhuo",
  Fenrilgold_NoWeapon_diyuhuo = "diyuhuo",
  Fenrilred_NoWeapon_diyuhuo = "diyuhuo",
  NoMount_Wing_NoWeapon_diyuhuo = "diyuhuo",
  NoMount_NoWing_Swim_NoWeapon_diyuhuo = "diyuhuo",
  NoMount_NoWing_NoSwim_OneHand_diyuhuo = "diyuhuo",
  Rider01_OneHand_diyuhuo = "diyuhuo",
  Rider02_OneHand_diyuhuo = "diyuhuo",
  DarkHorse_OneHand_diyuhuo = "diyuhuo",
  Fenrilblack_OneHand_diyuhuo = "diyuhuo",
  Fenrilblue_OneHand_diyuhuo = "diyuhuo",
  Fenrilgold_OneHand_diyuhuo = "diyuhuo",
  Fenrilred_OneHand_diyuhuo = "diyuhuo",
  NoMount_Wing_OneHand_diyuhuo = "diyuhuo",
  NoMount_NoWing_Swim_OneHand_diyuhuo = "diyuhuo",
  NoMount_NoWing_NoSwim_TSword_diyuhuo = "diyuhuo",
  Rider01_TSword_diyuhuo = "diyuhuo",
  Rider02_TSword_diyuhuo = "diyuhuo",
  DarkHorse_TSword_diyuhuo = "diyuhuo",
  Fenrilblack_TSword_diyuhuo = "diyuhuo",
  Fenrilblue_TSword_diyuhuo = "diyuhuo",
  Fenrilgold_TSword_diyuhuo = "diyuhuo",
  Fenrilred_TSword_diyuhuo = "diyuhuo",
  NoMount_Wing_TSword_diyuhuo = "diyuhuo",
  NoMount_NoWing_Swim_TSword_diyuhuo = "diyuhuo",
  NoMount_NoWing_NoSwim_Spear_diyuhuo = "diyuhuo",
  Rider01_Spear_diyuhuo = "diyuhuo",
  Rider02_Spear_diyuhuo = "diyuhuo",
  DarkHorse_Spear_diyuhuo = "diyuhuo",
  Fenrilblack_Spear_diyuhuo = "diyuhuo",
  Fenrilblue_Spear_diyuhuo = "diyuhuo",
  Fenrilgold_Spear_diyuhuo = "diyuhuo",
  Fenrilred_Spear_diyuhuo = "diyuhuo",
  NoMount_Wing_Spear_diyuhuo = "diyuhuo",
  NoMount_NoWing_Swim_Spear_diyuhuo = "diyuhuo",
  NoMount_NoWing_NoSwim_TStaff_diyuhuo = "diyuhuo",
  Rider01_TStaff_diyuhuo = "diyuhuo",
  Rider02_TStaff_diyuhuo = "diyuhuo",
  DarkHorse_TStaff_diyuhuo = "diyuhuo",
  Fenrilblack_TStaff_diyuhuo = "diyuhuo",
  Fenrilblue_TStaff_diyuhuo = "diyuhuo",
  Fenrilgold_TStaff_diyuhuo = "diyuhuo",
  Fenrilred_TStaff_diyuhuo = "diyuhuo",
  NoMount_Wing_TStaff_diyuhuo = "diyuhuo",
  NoMount_NoWing_Swim_TStaff_diyuhuo = "diyuhuo",
  NoMount_NoWing_NoSwim_Bow_diyuhuo = "diyuhuo",
  Rider01_Bow_diyuhuo = "diyuhuo",
  Rider02_Bow_diyuhuo = "diyuhuo",
  DarkHorse_Bow_diyuhuo = "diyuhuo",
  Fenrilblack_Bow_diyuhuo = "diyuhuo",
  Fenrilblue_Bow_diyuhuo = "diyuhuo",
  Fenrilgold_Bow_diyuhuo = "diyuhuo",
  Fenrilred_Bow_diyuhuo = "diyuhuo",
  NoMount_Wing_Bow_diyuhuo = "diyuhuo",
  NoMount_NoWing_Swim_Bow_diyuhuo = "diyuhuo",
  NoMount_NoWing_NoSwim_Crossbow_diyuhuo = "diyuhuo",
  Rider01_Crossbow_diyuhuo = "diyuhuo",
  Rider02_Crossbow_diyuhuo = "diyuhuo",
  DarkHorse_Crossbow_diyuhuo = "diyuhuo",
  Fenrilblack_Crossbow_diyuhuo = "diyuhuo",
  Fenrilblue_Crossbow_diyuhuo = "diyuhuo",
  Fenrilgold_Crossbow_diyuhuo = "diyuhuo",
  Fenrilred_Crossbow_diyuhuo = "diyuhuo",
  NoMount_Wing_Crossbow_diyuhuo = "diyuhuo",
  NoMount_NoWing_Swim_Crossbow_diyuhuo = "diyuhuo",
  NoMount_NoWing_NoSwim_Dweapon_diyuhuo = "diyuhuo",
  Rider01_Dweapon_diyuhuo = "diyuhuo",
  Rider02_Dweapon_diyuhuo = "diyuhuo",
  DarkHorse_Dweapon_diyuhuo = "diyuhuo",
  Fenrilblack_Dweapon_diyuhuo = "diyuhuo",
  Fenrilblue_Dweapon_diyuhuo = "diyuhuo",
  Fenrilgold_Dweapon_diyuhuo = "diyuhuo",
  Fenrilred_Dweapon_diyuhuo = "diyuhuo",
  NoMount_Wing_Dweapon_diyuhuo = "diyuhuo",
  NoMount_NoWing_Swim_Dweapon_diyuhuo = "diyuhuo",
  NoMount_NoWing_NoSwim_NoWeapon_jiguang = "jiguang",
  Rider01_NoWeapon_jiguang = "jiguang",
  Rider02_NoWeapon_jiguang = "jiguang",
  DarkHorse_NoWeapon_jiguang = "jiguang",
  Fenrilblack_NoWeapon_jiguang = "jiguang",
  Fenrilblue_NoWeapon_jiguang = "jiguang",
  Fenrilgold_NoWeapon_jiguang = "jiguang",
  Fenrilred_NoWeapon_jiguang = "jiguang",
  NoMount_Wing_NoWeapon_jiguang = "jiguang",
  NoMount_NoWing_Swim_NoWeapon_jiguang = "jiguang",
  NoMount_NoWing_NoSwim_OneHand_jiguang = "jiguang",
  Rider01_OneHand_jiguang = "jiguang",
  Rider02_OneHand_jiguang = "jiguang",
  DarkHorse_OneHand_jiguang = "jiguang",
  Fenrilblack_OneHand_jiguang = "jiguang",
  Fenrilblue_OneHand_jiguang = "jiguang",
  Fenrilgold_OneHand_jiguang = "jiguang",
  Fenrilred_OneHand_jiguang = "jiguang",
  NoMount_Wing_OneHand_jiguang = "jiguang",
  NoMount_NoWing_Swim_OneHand_jiguang = "jiguang",
  NoMount_NoWing_NoSwim_TSword_jiguang = "jiguang",
  Rider01_TSword_jiguang = "jiguang",
  Rider02_TSword_jiguang = "jiguang",
  DarkHorse_TSword_jiguang = "jiguang",
  Fenrilblack_TSword_jiguang = "jiguang",
  Fenrilblue_TSword_jiguang = "jiguang",
  Fenrilgold_TSword_jiguang = "jiguang",
  Fenrilred_TSword_jiguang = "jiguang",
  NoMount_Wing_TSword_jiguang = "jiguang",
  NoMount_NoWing_Swim_TSword_jiguang = "jiguang",
  NoMount_NoWing_NoSwim_Spear_jiguang = "jiguang",
  Rider01_Spear_jiguang = "jiguang",
  Rider02_Spear_jiguang = "jiguang",
  DarkHorse_Spear_jiguang = "jiguang",
  Fenrilblack_Spear_jiguang = "jiguang",
  Fenrilblue_Spear_jiguang = "jiguang",
  Fenrilgold_Spear_jiguang = "jiguang",
  Fenrilred_Spear_jiguang = "jiguang",
  NoMount_Wing_Spear_jiguang = "jiguang",
  NoMount_NoWing_Swim_Spear_jiguang = "jiguang",
  NoMount_NoWing_NoSwim_TStaff_jiguang = "jiguang",
  Rider01_TStaff_jiguang = "jiguang",
  Rider02_TStaff_jiguang = "jiguang",
  DarkHorse_TStaff_jiguang = "jiguang",
  Fenrilblack_TStaff_jiguang = "jiguang",
  Fenrilblue_TStaff_jiguang = "jiguang",
  Fenrilgold_TStaff_jiguang = "jiguang",
  Fenrilred_TStaff_jiguang = "jiguang",
  NoMount_Wing_TStaff_jiguang = "jiguang",
  NoMount_NoWing_Swim_TStaff_jiguang = "jiguang",
  NoMount_NoWing_NoSwim_Bow_jiguang = "jiguang",
  Rider01_Bow_jiguang = "jiguang",
  Rider02_Bow_jiguang = "jiguang",
  DarkHorse_Bow_jiguang = "jiguang",
  Fenrilblack_Bow_jiguang = "jiguang",
  Fenrilblue_Bow_jiguang = "jiguang",
  Fenrilgold_Bow_jiguang = "jiguang",
  Fenrilred_Bow_jiguang = "jiguang",
  NoMount_Wing_Bow_jiguang = "jiguang",
  NoMount_NoWing_Swim_Bow_jiguang = "jiguang",
  NoMount_NoWing_NoSwim_Crossbow_jiguang = "jiguang",
  Rider01_Crossbow_jiguang = "jiguang",
  Rider02_Crossbow_jiguang = "jiguang",
  DarkHorse_Crossbow_jiguang = "jiguang",
  Fenrilblack_Crossbow_jiguang = "jiguang",
  Fenrilblue_Crossbow_jiguang = "jiguang",
  Fenrilgold_Crossbow_jiguang = "jiguang",
  Fenrilred_Crossbow_jiguang = "jiguang",
  NoMount_Wing_Crossbow_jiguang = "jiguang",
  NoMount_NoWing_Swim_Crossbow_jiguang = "jiguang",
  NoMount_NoWing_NoSwim_Dweapon_jiguang = "jiguang",
  Rider01_Dweapon_jiguang = "jiguang",
  Rider02_Dweapon_jiguang = "jiguang",
  DarkHorse_Dweapon_jiguang = "jiguang",
  Fenrilblack_Dweapon_jiguang = "jiguang",
  Fenrilblue_Dweapon_jiguang = "jiguang",
  Fenrilgold_Dweapon_jiguang = "jiguang",
  Fenrilred_Dweapon_jiguang = "jiguang",
  NoMount_Wing_Dweapon_jiguang = "jiguang",
  NoMount_NoWing_Swim_Dweapon_jiguang = "jiguang",
  NoMount_NoWing_NoSwim_NoWeapon_huimielieyan = "huimielieyan",
  Rider01_NoWeapon_huimielieyan = "huimielieyan",
  Rider02_NoWeapon_huimielieyan = "huimielieyan",
  DarkHorse_NoWeapon_huimielieyan = "huimielieyan",
  Fenrilblack_NoWeapon_huimielieyan = "huimielieyan",
  Fenrilblue_NoWeapon_huimielieyan = "huimielieyan",
  Fenrilgold_NoWeapon_huimielieyan = "huimielieyan",
  Fenrilred_NoWeapon_huimielieyan = "huimielieyan",
  NoMount_Wing_NoWeapon_huimielieyan = "huimielieyan",
  NoMount_NoWing_Swim_NoWeapon_huimielieyan = "huimielieyan",
  NoMount_NoWing_NoSwim_OneHand_huimielieyan = "huimielieyan",
  Rider01_OneHand_huimielieyan = "huimielieyan",
  Rider02_OneHand_huimielieyan = "huimielieyan",
  DarkHorse_OneHand_huimielieyan = "huimielieyan",
  Fenrilblack_OneHand_huimielieyan = "huimielieyan",
  Fenrilblue_OneHand_huimielieyan = "huimielieyan",
  Fenrilgold_OneHand_huimielieyan = "huimielieyan",
  Fenrilred_OneHand_huimielieyan = "huimielieyan",
  NoMount_Wing_OneHand_huimielieyan = "huimielieyan",
  NoMount_NoWing_Swim_OneHand_huimielieyan = "huimielieyan",
  NoMount_NoWing_NoSwim_TSword_huimielieyan = "huimielieyan",
  Rider01_TSword_huimielieyan = "huimielieyan",
  Rider02_TSword_huimielieyan = "huimielieyan",
  DarkHorse_TSword_huimielieyan = "huimielieyan",
  Fenrilblack_TSword_huimielieyan = "huimielieyan",
  Fenrilblue_TSword_huimielieyan = "huimielieyan",
  Fenrilgold_TSword_huimielieyan = "huimielieyan",
  Fenrilred_TSword_huimielieyan = "huimielieyan",
  NoMount_Wing_TSword_huimielieyan = "huimielieyan",
  NoMount_NoWing_Swim_TSword_huimielieyan = "huimielieyan",
  NoMount_NoWing_NoSwim_Spear_huimielieyan = "huimielieyan",
  Rider01_Spear_huimielieyan = "huimielieyan",
  Rider02_Spear_huimielieyan = "huimielieyan",
  DarkHorse_Spear_huimielieyan = "huimielieyan",
  Fenrilblack_Spear_huimielieyan = "huimielieyan",
  Fenrilblue_Spear_huimielieyan = "huimielieyan",
  Fenrilgold_Spear_huimielieyan = "huimielieyan",
  Fenrilred_Spear_huimielieyan = "huimielieyan",
  NoMount_Wing_Spear_huimielieyan = "huimielieyan",
  NoMount_NoWing_Swim_Spear_huimielieyan = "huimielieyan",
  NoMount_NoWing_NoSwim_TStaff_huimielieyan = "huimielieyan",
  Rider01_TStaff_huimielieyan = "huimielieyan",
  Rider02_TStaff_huimielieyan = "huimielieyan",
  DarkHorse_TStaff_huimielieyan = "huimielieyan",
  Fenrilblack_TStaff_huimielieyan = "huimielieyan",
  Fenrilblue_TStaff_huimielieyan = "huimielieyan",
  Fenrilgold_TStaff_huimielieyan = "huimielieyan",
  Fenrilred_TStaff_huimielieyan = "huimielieyan",
  NoMount_Wing_TStaff_huimielieyan = "huimielieyan",
  NoMount_NoWing_Swim_TStaff_huimielieyan = "huimielieyan",
  NoMount_NoWing_NoSwim_Bow_huimielieyan = "huimielieyan",
  Rider01_Bow_huimielieyan = "huimielieyan",
  Rider02_Bow_huimielieyan = "huimielieyan",
  DarkHorse_Bow_huimielieyan = "huimielieyan",
  Fenrilblack_Bow_huimielieyan = "huimielieyan",
  Fenrilblue_Bow_huimielieyan = "huimielieyan",
  Fenrilgold_Bow_huimielieyan = "huimielieyan",
  Fenrilred_Bow_huimielieyan = "huimielieyan",
  NoMount_Wing_Bow_huimielieyan = "huimielieyan",
  NoMount_NoWing_Swim_Bow_huimielieyan = "huimielieyan",
  NoMount_NoWing_NoSwim_Crossbow_huimielieyan = "huimielieyan",
  Rider01_Crossbow_huimielieyan = "huimielieyan",
  Rider02_Crossbow_huimielieyan = "huimielieyan",
  DarkHorse_Crossbow_huimielieyan = "huimielieyan",
  Fenrilblack_Crossbow_huimielieyan = "huimielieyan",
  Fenrilblue_Crossbow_huimielieyan = "huimielieyan",
  Fenrilgold_Crossbow_huimielieyan = "huimielieyan",
  Fenrilred_Crossbow_huimielieyan = "huimielieyan",
  NoMount_Wing_Crossbow_huimielieyan = "huimielieyan",
  NoMount_NoWing_Swim_Crossbow_huimielieyan = "huimielieyan",
  NoMount_NoWing_NoSwim_Dweapon_huimielieyan = "huimielieyan",
  Rider01_Dweapon_huimielieyan = "huimielieyan",
  Rider02_Dweapon_huimielieyan = "huimielieyan",
  DarkHorse_Dweapon_huimielieyan = "huimielieyan",
  Fenrilblack_Dweapon_huimielieyan = "huimielieyan",
  Fenrilblue_Dweapon_huimielieyan = "huimielieyan",
  Fenrilgold_Dweapon_huimielieyan = "huimielieyan",
  Fenrilred_Dweapon_huimielieyan = "huimielieyan",
  NoMount_Wing_Dweapon_huimielieyan = "huimielieyan",
  NoMount_NoWing_Swim_Dweapon_huimielieyan = "huimielieyan",
  NoMount_NoWing_NoSwim_NoWeapon_xingchenyinu02 = "xingchenyinu02",
  Rider01_NoWeapon_xingchenyinu02 = "xingchenyinu02",
  Rider02_NoWeapon_xingchenyinu02 = "xingchenyinu02",
  DarkHorse_NoWeapon_xingchenyinu02 = "xingchenyinu02",
  Fenrilblack_NoWeapon_xingchenyinu02 = "xingchenyinu02",
  Fenrilblue_NoWeapon_xingchenyinu02 = "xingchenyinu02",
  Fenrilgold_NoWeapon_xingchenyinu02 = "xingchenyinu02",
  Fenrilred_NoWeapon_xingchenyinu02 = "xingchenyinu02",
  NoMount_Wing_NoWeapon_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_Swim_NoWeapon_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_NoSwim_OneHand_xingchenyinu02 = "xingchenyinu02",
  Rider01_OneHand_xingchenyinu02 = "xingchenyinu02",
  Rider02_OneHand_xingchenyinu02 = "xingchenyinu02",
  DarkHorse_OneHand_xingchenyinu02 = "xingchenyinu02",
  Fenrilblack_OneHand_xingchenyinu02 = "xingchenyinu02",
  Fenrilblue_OneHand_xingchenyinu02 = "xingchenyinu02",
  Fenrilgold_OneHand_xingchenyinu02 = "xingchenyinu02",
  Fenrilred_OneHand_xingchenyinu02 = "xingchenyinu02",
  NoMount_Wing_OneHand_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_Swim_OneHand_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_NoSwim_TSword_xingchenyinu02 = "xingchenyinu02",
  Rider01_TSword_xingchenyinu02 = "xingchenyinu02",
  Rider02_TSword_xingchenyinu02 = "xingchenyinu02",
  DarkHorse_TSword_xingchenyinu02 = "xingchenyinu02",
  Fenrilblack_TSword_xingchenyinu02 = "xingchenyinu02",
  Fenrilblue_TSword_xingchenyinu02 = "xingchenyinu02",
  Fenrilgold_TSword_xingchenyinu02 = "xingchenyinu02",
  Fenrilred_TSword_xingchenyinu02 = "xingchenyinu02",
  NoMount_Wing_TSword_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_Swim_TSword_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_NoSwim_Spear_xingchenyinu02 = "xingchenyinu02",
  Rider01_Spear_xingchenyinu02 = "xingchenyinu02",
  Rider02_Spear_xingchenyinu02 = "xingchenyinu02",
  DarkHorse_Spear_xingchenyinu02 = "xingchenyinu02",
  Fenrilblack_Spear_xingchenyinu02 = "xingchenyinu02",
  Fenrilblue_Spear_xingchenyinu02 = "xingchenyinu02",
  Fenrilgold_Spear_xingchenyinu02 = "xingchenyinu02",
  Fenrilred_Spear_xingchenyinu02 = "xingchenyinu02",
  NoMount_Wing_Spear_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_Swim_Spear_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_NoSwim_TStaff_xingchenyinu02 = "xingchenyinu02",
  Rider01_TStaff_xingchenyinu02 = "xingchenyinu02",
  Rider02_TStaff_xingchenyinu02 = "xingchenyinu02",
  DarkHorse_TStaff_xingchenyinu02 = "xingchenyinu02",
  Fenrilblack_TStaff_xingchenyinu02 = "xingchenyinu02",
  Fenrilblue_TStaff_xingchenyinu02 = "xingchenyinu02",
  Fenrilgold_TStaff_xingchenyinu02 = "xingchenyinu02",
  Fenrilred_TStaff_xingchenyinu02 = "xingchenyinu02",
  NoMount_Wing_TStaff_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_Swim_TStaff_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_NoSwim_Bow_xingchenyinu02 = "xingchenyinu02",
  Rider01_Bow_xingchenyinu02 = "xingchenyinu02",
  Rider02_Bow_xingchenyinu02 = "xingchenyinu02",
  DarkHorse_Bow_xingchenyinu02 = "xingchenyinu02",
  Fenrilblack_Bow_xingchenyinu02 = "xingchenyinu02",
  Fenrilblue_Bow_xingchenyinu02 = "xingchenyinu02",
  Fenrilgold_Bow_xingchenyinu02 = "xingchenyinu02",
  Fenrilred_Bow_xingchenyinu02 = "xingchenyinu02",
  NoMount_Wing_Bow_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_Swim_Bow_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_NoSwim_Crossbow_xingchenyinu02 = "xingchenyinu02",
  Rider01_Crossbow_xingchenyinu02 = "xingchenyinu02",
  Rider02_Crossbow_xingchenyinu02 = "xingchenyinu02",
  DarkHorse_Crossbow_xingchenyinu02 = "xingchenyinu02",
  Fenrilblack_Crossbow_xingchenyinu02 = "xingchenyinu02",
  Fenrilblue_Crossbow_xingchenyinu02 = "xingchenyinu02",
  Fenrilgold_Crossbow_xingchenyinu02 = "xingchenyinu02",
  Fenrilred_Crossbow_xingchenyinu02 = "xingchenyinu02",
  NoMount_Wing_Crossbow_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_Swim_Crossbow_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_NoSwim_Dweapon_xingchenyinu02 = "xingchenyinu02",
  Rider01_Dweapon_xingchenyinu02 = "xingchenyinu02",
  Rider02_Dweapon_xingchenyinu02 = "xingchenyinu02",
  DarkHorse_Dweapon_xingchenyinu02 = "xingchenyinu02",
  Fenrilblack_Dweapon_xingchenyinu02 = "xingchenyinu02",
  Fenrilblue_Dweapon_xingchenyinu02 = "xingchenyinu02",
  Fenrilgold_Dweapon_xingchenyinu02 = "xingchenyinu02",
  Fenrilred_Dweapon_xingchenyinu02 = "xingchenyinu02",
  NoMount_Wing_Dweapon_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_Swim_Dweapon_xingchenyinu02 = "xingchenyinu02",
  NoMount_NoWing_NoSwim_NoWeapon_xingchenyinu01 = "xingchenyinu01",
  Rider01_NoWeapon_xingchenyinu01 = "xingchenyinu01",
  Rider02_NoWeapon_xingchenyinu01 = "xingchenyinu01",
  DarkHorse_NoWeapon_xingchenyinu01 = "xingchenyinu01",
  Fenrilblack_NoWeapon_xingchenyinu01 = "xingchenyinu01",
  Fenrilblue_NoWeapon_xingchenyinu01 = "xingchenyinu01",
  Fenrilgold_NoWeapon_xingchenyinu01 = "xingchenyinu01",
  Fenrilred_NoWeapon_xingchenyinu01 = "xingchenyinu01",
  NoMount_Wing_NoWeapon_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_Swim_NoWeapon_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_NoSwim_OneHand_xingchenyinu01 = "xingchenyinu01",
  Rider01_OneHand_xingchenyinu01 = "xingchenyinu01",
  Rider02_OneHand_xingchenyinu01 = "xingchenyinu01",
  DarkHorse_OneHand_xingchenyinu01 = "xingchenyinu01",
  Fenrilblack_OneHand_xingchenyinu01 = "xingchenyinu01",
  Fenrilblue_OneHand_xingchenyinu01 = "xingchenyinu01",
  Fenrilgold_OneHand_xingchenyinu01 = "xingchenyinu01",
  Fenrilred_OneHand_xingchenyinu01 = "xingchenyinu01",
  NoMount_Wing_OneHand_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_Swim_OneHand_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_NoSwim_TSword_xingchenyinu01 = "xingchenyinu01",
  Rider01_TSword_xingchenyinu01 = "xingchenyinu01",
  Rider02_TSword_xingchenyinu01 = "xingchenyinu01",
  DarkHorse_TSword_xingchenyinu01 = "xingchenyinu01",
  Fenrilblack_TSword_xingchenyinu01 = "xingchenyinu01",
  Fenrilblue_TSword_xingchenyinu01 = "xingchenyinu01",
  Fenrilgold_TSword_xingchenyinu01 = "xingchenyinu01",
  Fenrilred_TSword_xingchenyinu01 = "xingchenyinu01",
  NoMount_Wing_TSword_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_Swim_TSword_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_NoSwim_Spear_xingchenyinu01 = "xingchenyinu01",
  Rider01_Spear_xingchenyinu01 = "xingchenyinu01",
  Rider02_Spear_xingchenyinu01 = "xingchenyinu01",
  DarkHorse_Spear_xingchenyinu01 = "xingchenyinu01",
  Fenrilblack_Spear_xingchenyinu01 = "xingchenyinu01",
  Fenrilblue_Spear_xingchenyinu01 = "xingchenyinu01",
  Fenrilgold_Spear_xingchenyinu01 = "xingchenyinu01",
  Fenrilred_Spear_xingchenyinu01 = "xingchenyinu01",
  NoMount_Wing_Spear_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_Swim_Spear_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_NoSwim_TStaff_xingchenyinu01 = "xingchenyinu01",
  Rider01_TStaff_xingchenyinu01 = "xingchenyinu01",
  Rider02_TStaff_xingchenyinu01 = "xingchenyinu01",
  DarkHorse_TStaff_xingchenyinu01 = "xingchenyinu01",
  Fenrilblack_TStaff_xingchenyinu01 = "xingchenyinu01",
  Fenrilblue_TStaff_xingchenyinu01 = "xingchenyinu01",
  Fenrilgold_TStaff_xingchenyinu01 = "xingchenyinu01",
  Fenrilred_TStaff_xingchenyinu01 = "xingchenyinu01",
  NoMount_Wing_TStaff_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_Swim_TStaff_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_NoSwim_Bow_xingchenyinu01 = "xingchenyinu01",
  Rider01_Bow_xingchenyinu01 = "xingchenyinu01",
  Rider02_Bow_xingchenyinu01 = "xingchenyinu01",
  DarkHorse_Bow_xingchenyinu01 = "xingchenyinu01",
  Fenrilblack_Bow_xingchenyinu01 = "xingchenyinu01",
  Fenrilblue_Bow_xingchenyinu01 = "xingchenyinu01",
  Fenrilgold_Bow_xingchenyinu01 = "xingchenyinu01",
  Fenrilred_Bow_xingchenyinu01 = "xingchenyinu01",
  NoMount_Wing_Bow_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_Swim_Bow_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_NoSwim_Crossbow_xingchenyinu01 = "xingchenyinu01",
  Rider01_Crossbow_xingchenyinu01 = "xingchenyinu01",
  Rider02_Crossbow_xingchenyinu01 = "xingchenyinu01",
  DarkHorse_Crossbow_xingchenyinu01 = "xingchenyinu01",
  Fenrilblack_Crossbow_xingchenyinu01 = "xingchenyinu01",
  Fenrilblue_Crossbow_xingchenyinu01 = "xingchenyinu01",
  Fenrilgold_Crossbow_xingchenyinu01 = "xingchenyinu01",
  Fenrilred_Crossbow_xingchenyinu01 = "xingchenyinu01",
  NoMount_Wing_Crossbow_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_Swim_Crossbow_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_NoSwim_Dweapon_xingchenyinu01 = "xingchenyinu01",
  Rider01_Dweapon_xingchenyinu01 = "xingchenyinu01",
  Rider02_Dweapon_xingchenyinu01 = "xingchenyinu01",
  DarkHorse_Dweapon_xingchenyinu01 = "xingchenyinu01",
  Fenrilblack_Dweapon_xingchenyinu01 = "xingchenyinu01",
  Fenrilblue_Dweapon_xingchenyinu01 = "xingchenyinu01",
  Fenrilgold_Dweapon_xingchenyinu01 = "xingchenyinu01",
  Fenrilred_Dweapon_xingchenyinu01 = "xingchenyinu01",
  NoMount_Wing_Dweapon_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_Swim_Dweapon_xingchenyinu01 = "xingchenyinu01",
  NoMount_NoWing_NoSwim_NoWeapon_fashenfuti = "fashenfuti",
  Rider01_NoWeapon_fashenfuti = "fashenfuti",
  Rider02_NoWeapon_fashenfuti = "fashenfuti",
  DarkHorse_NoWeapon_fashenfuti = "fashenfuti",
  Fenrilblack_NoWeapon_fashenfuti = "fashenfuti",
  Fenrilblue_NoWeapon_fashenfuti = "fashenfuti",
  Fenrilgold_NoWeapon_fashenfuti = "fashenfuti",
  Fenrilred_NoWeapon_fashenfuti = "fashenfuti",
  NoMount_Wing_NoWeapon_fashenfuti = "fashenfuti",
  NoMount_NoWing_Swim_NoWeapon_fashenfuti = "fashenfuti",
  NoMount_NoWing_NoSwim_OneHand_fashenfuti = "fashenfuti",
  Rider01_OneHand_fashenfuti = "fashenfuti",
  Rider02_OneHand_fashenfuti = "fashenfuti",
  DarkHorse_OneHand_fashenfuti = "fashenfuti",
  Fenrilblack_OneHand_fashenfuti = "fashenfuti",
  Fenrilblue_OneHand_fashenfuti = "fashenfuti",
  Fenrilgold_OneHand_fashenfuti = "fashenfuti",
  Fenrilred_OneHand_fashenfuti = "fashenfuti",
  NoMount_Wing_OneHand_fashenfuti = "fashenfuti",
  NoMount_NoWing_Swim_OneHand_fashenfuti = "fashenfuti",
  NoMount_NoWing_NoSwim_TSword_fashenfuti = "fashenfuti",
  Rider01_TSword_fashenfuti = "fashenfuti",
  Rider02_TSword_fashenfuti = "fashenfuti",
  DarkHorse_TSword_fashenfuti = "fashenfuti",
  Fenrilblack_TSword_fashenfuti = "fashenfuti",
  Fenrilblue_TSword_fashenfuti = "fashenfuti",
  Fenrilgold_TSword_fashenfuti = "fashenfuti",
  Fenrilred_TSword_fashenfuti = "fashenfuti",
  NoMount_Wing_TSword_fashenfuti = "fashenfuti",
  NoMount_NoWing_Swim_TSword_fashenfuti = "fashenfuti",
  NoMount_NoWing_NoSwim_Spear_fashenfuti = "fashenfuti",
  Rider01_Spear_fashenfuti = "fashenfuti",
  Rider02_Spear_fashenfuti = "fashenfuti",
  DarkHorse_Spear_fashenfuti = "fashenfuti",
  Fenrilblack_Spear_fashenfuti = "fashenfuti",
  Fenrilblue_Spear_fashenfuti = "fashenfuti",
  Fenrilgold_Spear_fashenfuti = "fashenfuti",
  Fenrilred_Spear_fashenfuti = "fashenfuti",
  NoMount_Wing_Spear_fashenfuti = "fashenfuti",
  NoMount_NoWing_Swim_Spear_fashenfuti = "fashenfuti",
  NoMount_NoWing_NoSwim_TStaff_fashenfuti = "fashenfuti",
  Rider01_TStaff_fashenfuti = "fashenfuti",
  Rider02_TStaff_fashenfuti = "fashenfuti",
  DarkHorse_TStaff_fashenfuti = "fashenfuti",
  Fenrilblack_TStaff_fashenfuti = "fashenfuti",
  Fenrilblue_TStaff_fashenfuti = "fashenfuti",
  Fenrilgold_TStaff_fashenfuti = "fashenfuti",
  Fenrilred_TStaff_fashenfuti = "fashenfuti",
  NoMount_Wing_TStaff_fashenfuti = "fashenfuti",
  NoMount_NoWing_Swim_TStaff_fashenfuti = "fashenfuti",
  NoMount_NoWing_NoSwim_Bow_fashenfuti = "fashenfuti",
  Rider01_Bow_fashenfuti = "fashenfuti",
  Rider02_Bow_fashenfuti = "fashenfuti",
  DarkHorse_Bow_fashenfuti = "fashenfuti",
  Fenrilblack_Bow_fashenfuti = "fashenfuti",
  Fenrilblue_Bow_fashenfuti = "fashenfuti",
  Fenrilgold_Bow_fashenfuti = "fashenfuti",
  Fenrilred_Bow_fashenfuti = "fashenfuti",
  NoMount_Wing_Bow_fashenfuti = "fashenfuti",
  NoMount_NoWing_Swim_Bow_fashenfuti = "fashenfuti",
  NoMount_NoWing_NoSwim_Crossbow_fashenfuti = "fashenfuti",
  Rider01_Crossbow_fashenfuti = "fashenfuti",
  Rider02_Crossbow_fashenfuti = "fashenfuti",
  DarkHorse_Crossbow_fashenfuti = "fashenfuti",
  Fenrilblack_Crossbow_fashenfuti = "fashenfuti",
  Fenrilblue_Crossbow_fashenfuti = "fashenfuti",
  Fenrilgold_Crossbow_fashenfuti = "fashenfuti",
  Fenrilred_Crossbow_fashenfuti = "fashenfuti",
  NoMount_Wing_Crossbow_fashenfuti = "fashenfuti",
  NoMount_NoWing_Swim_Crossbow_fashenfuti = "fashenfuti",
  NoMount_NoWing_NoSwim_Dweapon_fashenfuti = "fashenfuti",
  Rider01_Dweapon_fashenfuti = "fashenfuti",
  Rider02_Dweapon_fashenfuti = "fashenfuti",
  DarkHorse_Dweapon_fashenfuti = "fashenfuti",
  Fenrilblack_Dweapon_fashenfuti = "fashenfuti",
  Fenrilblue_Dweapon_fashenfuti = "fashenfuti",
  Fenrilgold_Dweapon_fashenfuti = "fashenfuti",
  Fenrilred_Dweapon_fashenfuti = "fashenfuti",
  NoMount_Wing_Dweapon_fashenfuti = "fashenfuti",
  NoMount_NoWing_Swim_Dweapon_fashenfuti = "fashenfuti",
  NoMount_NoWing_NoSwim_NoWeapon_duochongjian = "Bow_attack01",
  Rider01_NoWeapon_duochongjian = "Rider01_Bow_attack01",
  Rider02_NoWeapon_duochongjian = "Rider01_Bow_attack01",
  DarkHorse_NoWeapon_duochongjian = "DarkHorse_nengliangqiu01",
  Fenrilblack_NoWeapon_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilblue_NoWeapon_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilgold_NoWeapon_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilred_NoWeapon_duochongjian = "Fenrilblack_Bow_attack01",
  NoMount_Wing_NoWeapon_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_Swim_NoWeapon_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_NoSwim_OneHand_duochongjian = "Bow_attack01",
  Rider01_OneHand_duochongjian = "Rider01_Bow_attack01",
  Rider02_OneHand_duochongjian = "Rider01_Bow_attack01",
  DarkHorse_OneHand_duochongjian = "DarkHorse_nengliangqiu01",
  Fenrilblack_OneHand_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilblue_OneHand_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilgold_OneHand_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilred_OneHand_duochongjian = "Fenrilblack_Bow_attack01",
  NoMount_Wing_OneHand_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_Swim_OneHand_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_NoSwim_TSword_duochongjian = "Bow_attack01",
  Rider01_TSword_duochongjian = "Rider01_Bow_attack01",
  Rider02_TSword_duochongjian = "Rider01_Bow_attack01",
  DarkHorse_TSword_duochongjian = "DarkHorse_nengliangqiu01",
  Fenrilblack_TSword_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilblue_TSword_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilgold_TSword_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilred_TSword_duochongjian = "Fenrilblack_Bow_attack01",
  NoMount_Wing_TSword_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_Swim_TSword_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_NoSwim_Spear_duochongjian = "Bow_attack01",
  Rider01_Spear_duochongjian = "Rider01_Bow_attack01",
  Rider02_Spear_duochongjian = "Rider01_Bow_attack01",
  DarkHorse_Spear_duochongjian = "DarkHorse_nengliangqiu01",
  Fenrilblack_Spear_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilblue_Spear_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilgold_Spear_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilred_Spear_duochongjian = "Fenrilblack_Bow_attack01",
  NoMount_Wing_Spear_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_Swim_Spear_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_NoSwim_TStaff_duochongjian = "Bow_attack01",
  Rider01_TStaff_duochongjian = "Rider01_Bow_attack01",
  Rider02_TStaff_duochongjian = "Rider01_Bow_attack01",
  DarkHorse_TStaff_duochongjian = "DarkHorse_nengliangqiu01",
  Fenrilblack_TStaff_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilblue_TStaff_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilgold_TStaff_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilred_TStaff_duochongjian = "Fenrilblack_Bow_attack01",
  NoMount_Wing_TStaff_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_Swim_TStaff_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_NoSwim_Bow_duochongjian = "Bow_attack01",
  Rider01_Bow_duochongjian = "Rider01_Bow_attack01",
  Rider02_Bow_duochongjian = "Rider01_Bow_attack01",
  DarkHorse_Bow_duochongjian = "DarkHorse_attack01",
  Fenrilblack_Bow_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilblue_Bow_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilgold_Bow_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilred_Bow_duochongjian = "Fenrilblack_Bow_attack01",
  NoMount_Wing_Bow_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_Swim_Bow_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_NoSwim_Crossbow_duochongjian = "Crossbow_attack01",
  Rider01_Crossbow_duochongjian = "Rider01_Crossbow_attack01",
  Rider02_Crossbow_duochongjian = "Rider01_Crossbow_attack01",
  DarkHorse_Crossbow_duochongjian = "DarkHorse_attack01",
  Fenrilblack_Crossbow_duochongjian = "Fenrilblack_Crossbow_attack01",
  Fenrilblue_Crossbow_duochongjian = "Fenrilblack_Crossbow_attack01",
  Fenrilgold_Crossbow_duochongjian = "Fenrilblack_Crossbow_attack01",
  Fenrilred_Crossbow_duochongjian = "Fenrilblack_Crossbow_attack01",
  NoMount_Wing_Crossbow_duochongjian = "Wing_Crossbow_attack01",
  NoMount_NoWing_Swim_Crossbow_duochongjian = "Wing_Crossbow_attack01",
  NoMount_NoWing_NoSwim_Dweapon_duochongjian = "Bow_attack01",
  Rider01_Dweapon_duochongjian = "Rider01_Bow_attack01",
  Rider02_Dweapon_duochongjian = "Rider01_Bow_attack01",
  DarkHorse_Dweapon_duochongjian = "DarkHorse_nengliangqiu01",
  Fenrilblack_Dweapon_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilblue_Dweapon_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilgold_Dweapon_duochongjian = "Fenrilblack_Bow_attack01",
  Fenrilred_Dweapon_duochongjian = "Fenrilblack_Bow_attack01",
  NoMount_Wing_Dweapon_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_Swim_Dweapon_duochongjian = "Wing_Bow_attack01",
  NoMount_NoWing_NoSwim_NoWeapon_zhiliao = "zhiliao",
  Rider01_NoWeapon_zhiliao = "Rider01_nengliangqiu01",
  Rider02_NoWeapon_zhiliao = "Rider01_nengliangqiu01",
  DarkHorse_NoWeapon_zhiliao = "DarkHorse_nengliangqiu01",
  Fenrilblack_NoWeapon_zhiliao = "Fenrilblack_attack01",
  Fenrilblue_NoWeapon_zhiliao = "Fenrilblack_attack01",
  Fenrilgold_NoWeapon_zhiliao = "Fenrilblack_attack01",
  Fenrilred_NoWeapon_zhiliao = "Fenrilblack_attack01",
  NoMount_Wing_NoWeapon_zhiliao = "zhiliao",
  NoMount_NoWing_Swim_NoWeapon_zhiliao = "zhiliao",
  NoMount_NoWing_NoSwim_OneHand_zhiliao = "zhiliao",
  Rider01_OneHand_zhiliao = "Rider01_nengliangqiu01",
  Rider02_OneHand_zhiliao = "Rider01_nengliangqiu01",
  DarkHorse_OneHand_zhiliao = "DarkHorse_nengliangqiu01",
  Fenrilblack_OneHand_zhiliao = "Fenrilblack_attack01",
  Fenrilblue_OneHand_zhiliao = "Fenrilblack_attack01",
  Fenrilgold_OneHand_zhiliao = "Fenrilblack_attack01",
  Fenrilred_OneHand_zhiliao = "Fenrilblack_attack01",
  NoMount_Wing_OneHand_zhiliao = "zhiliao",
  NoMount_NoWing_Swim_OneHand_zhiliao = "zhiliao",
  NoMount_NoWing_NoSwim_TSword_zhiliao = "zhiliao",
  Rider01_TSword_zhiliao = "Rider01_nengliangqiu01",
  Rider02_TSword_zhiliao = "Rider01_nengliangqiu01",
  DarkHorse_TSword_zhiliao = "DarkHorse_nengliangqiu01",
  Fenrilblack_TSword_zhiliao = "Fenrilblack_attack01",
  Fenrilblue_TSword_zhiliao = "Fenrilblack_attack01",
  Fenrilgold_TSword_zhiliao = "Fenrilblack_attack01",
  Fenrilred_TSword_zhiliao = "Fenrilblack_attack01",
  NoMount_Wing_TSword_zhiliao = "zhiliao",
  NoMount_NoWing_Swim_TSword_zhiliao = "zhiliao",
  NoMount_NoWing_NoSwim_Spear_zhiliao = "zhiliao",
  Rider01_Spear_zhiliao = "Rider01_nengliangqiu01",
  Rider02_Spear_zhiliao = "Rider01_nengliangqiu01",
  DarkHorse_Spear_zhiliao = "DarkHorse_nengliangqiu01",
  Fenrilblack_Spear_zhiliao = "Fenrilblack_attack01",
  Fenrilblue_Spear_zhiliao = "Fenrilblack_attack01",
  Fenrilgold_Spear_zhiliao = "Fenrilblack_attack01",
  Fenrilred_Spear_zhiliao = "Fenrilblack_attack01",
  NoMount_Wing_Spear_zhiliao = "zhiliao",
  NoMount_NoWing_Swim_Spear_zhiliao = "zhiliao",
  NoMount_NoWing_NoSwim_TStaff_zhiliao = "zhiliao",
  Rider01_TStaff_zhiliao = "Rider01_nengliangqiu01",
  Rider02_TStaff_zhiliao = "Rider01_nengliangqiu01",
  DarkHorse_TStaff_zhiliao = "DarkHorse_nengliangqiu01",
  Fenrilblack_TStaff_zhiliao = "Fenrilblack_attack01",
  Fenrilblue_TStaff_zhiliao = "Fenrilblack_attack01",
  Fenrilgold_TStaff_zhiliao = "Fenrilblack_attack01",
  Fenrilred_TStaff_zhiliao = "Fenrilblack_attack01",
  NoMount_Wing_TStaff_zhiliao = "zhiliao",
  NoMount_NoWing_Swim_TStaff_zhiliao = "zhiliao",
  NoMount_NoWing_NoSwim_Bow_zhiliao = "zhiliao",
  Rider01_Bow_zhiliao = "Rider01_nengliangqiu01",
  Rider02_Bow_zhiliao = "Rider01_nengliangqiu01",
  DarkHorse_Bow_zhiliao = "DarkHorse_nengliangqiu01",
  Fenrilblack_Bow_zhiliao = "Fenrilblack_attack01",
  Fenrilblue_Bow_zhiliao = "Fenrilblack_attack01",
  Fenrilgold_Bow_zhiliao = "Fenrilblack_attack01",
  Fenrilred_Bow_zhiliao = "Fenrilblack_attack01",
  NoMount_Wing_Bow_zhiliao = "zhiliao",
  NoMount_NoWing_Swim_Bow_zhiliao = "zhiliao",
  NoMount_NoWing_NoSwim_Crossbow_zhiliao = "zhiliao",
  Rider01_Crossbow_zhiliao = "Rider01_nengliangqiu01",
  Rider02_Crossbow_zhiliao = "Rider01_nengliangqiu01",
  DarkHorse_Crossbow_zhiliao = "DarkHorse_nengliangqiu01",
  Fenrilblack_Crossbow_zhiliao = "Fenrilblack_attack01",
  Fenrilblue_Crossbow_zhiliao = "Fenrilblack_attack01",
  Fenrilgold_Crossbow_zhiliao = "Fenrilblack_attack01",
  Fenrilred_Crossbow_zhiliao = "Fenrilblack_attack01",
  NoMount_Wing_Crossbow_zhiliao = "zhiliao",
  NoMount_NoWing_Swim_Crossbow_zhiliao = "zhiliao",
  NoMount_NoWing_NoSwim_Dweapon_zhiliao = "zhiliao",
  Rider01_Dweapon_zhiliao = "Rider01_nengliangqiu01",
  Rider02_Dweapon_zhiliao = "Rider01_nengliangqiu01",
  DarkHorse_Dweapon_zhiliao = "DarkHorse_nengliangqiu01",
  Fenrilblack_Dweapon_zhiliao = "Fenrilblack_attack01",
  Fenrilblue_Dweapon_zhiliao = "Fenrilblack_attack01",
  Fenrilgold_Dweapon_zhiliao = "Fenrilblack_attack01",
  Fenrilred_Dweapon_zhiliao = "Fenrilblack_attack01",
  NoMount_Wing_Dweapon_zhiliao = "zhiliao",
  NoMount_NoWing_Swim_Dweapon_zhiliao = "zhiliao"
}
