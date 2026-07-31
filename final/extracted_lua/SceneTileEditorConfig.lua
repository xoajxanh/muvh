require("UtilityCommon/bit")
require("GamePlay/Scene/SceneTileEnum")
SceneTileTypeConfig = {
  {
    SceneTileType.Block,
    "Ng\196\131n c\225\186\163n",
    {
      {
        SceneTileType.Block,
        "Block"
      }
    }
  },
  {
    SceneTileType.BornPoint,
    "\196\144i\225\187\131m sinh",
    {
      {
        SceneTileType.BornPoint,
        "Revive"
      }
    }
  },
  {
    SceneTileType.Ignore,
    "Khu v\225\187\177c kh\195\180ng h\225\187\163p l\225\187\135",
    {
      {
        SceneTileType.Ignore,
        "Stall"
      }
    }
  },
  {
    SceneTileType.Safe,
    "Khu an to\195\160n",
    {
      {
        SceneTileType.Safe,
        "Safe"
      }
    }
  },
  {
    SceneTileType.Sit,
    "Ng\225\187\147i",
    {
      {
        SceneTileSitType.None,
        "",
        "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i"
      },
      {
        SceneTileSitType.Up,
        "SitUp",
        "Tr\195\170n"
      },
      {
        SceneTileSitType.RightUp,
        "SitRightUp",
        "Tr\195\170n ph\225\186\163i"
      },
      {
        SceneTileSitType.Right,
        "SitRight",
        "Ph\225\186\163i"
      },
      {
        SceneTileSitType.RightDown,
        "SitRightDown",
        "D\198\176\225\187\155i ph\225\186\163i"
      },
      {
        SceneTileSitType.Down,
        "SitDown",
        "D\198\176\225\187\155i"
      },
      {
        SceneTileSitType.LeftDown,
        "SitLeftDown",
        "D\198\176\225\187\155i tr\195\161i"
      },
      {
        SceneTileSitType.Left,
        "SitLeft",
        "Tr\195\161i"
      },
      {
        SceneTileSitType.LeftUp,
        "SitLeftUp",
        "Tr\195\170n tr\195\161i"
      },
      {
        SceneTileSitType.All,
        "SitAll",
        "H\198\176\225\187\155ng b\225\186\165t k\225\187\179"
      }
    }
  },
  {
    SceneTileType.LeanOn,
    "D\225\187\177a l\198\176ng",
    {
      {
        SceneLeanOnType.None,
        "",
        "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i"
      },
      {
        SceneLeanOnType.Up,
        "LeanOnUp",
        "Tr\195\170n"
      },
      {
        SceneLeanOnType.RightUp,
        "LeanOnRightUp",
        "Tr\195\170n ph\225\186\163i"
      },
      {
        SceneLeanOnType.Right,
        "LeanOnRight",
        "Ph\225\186\163i"
      },
      {
        SceneLeanOnType.RightDown,
        "LeanOnRightDown",
        "D\198\176\225\187\155i ph\225\186\163i"
      },
      {
        SceneLeanOnType.Down,
        "LeanOnDown",
        "D\198\176\225\187\155i"
      },
      {
        SceneLeanOnType.LeftDown,
        "LeanOnLeftDown",
        "D\198\176\225\187\155i tr\195\161i"
      },
      {
        SceneLeanOnType.Left,
        "LeanOnLeft",
        "Tr\195\161i"
      },
      {
        SceneLeanOnType.LeftUp,
        "LeanOnLeftUp",
        "Tr\195\170n tr\195\161i"
      }
    }
  },
  {
    SceneTileType.FlyUp,
    "Phi th\196\131ng",
    {
      {
        SceneTileType.FlyUp,
        "FlyUp"
      }
    }
  },
  {
    SceneTileType.Material,
    "Ch\225\186\165t li\225\187\135u",
    {
      {
        SceneMaterialType.None,
        "",
        "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i"
      },
      {
        SceneMaterialType.Stone,
        "MaterialStone",
        "\196\144\195\161"
      },
      {
        SceneMaterialType.Grass,
        "MaterialGrass",
        "C\225\187\143"
      },
      {
        SceneMaterialType.Snow,
        "MaterialSnow",
        "Tuy\225\186\191t"
      },
      {
        SceneMaterialType.Land,
        "MaterialLand",
        "Th\225\187\149"
      },
      {
        SceneMaterialType.Water,
        "MaterialWater",
        "Th\225\187\167y"
      },
      {
        SceneMaterialType.Wood,
        "MaterialWood",
        "G\225\187\151"
      },
      {
        SceneMaterialType.Sand,
        "MaterialSand",
        "C\195\161t"
      },
      {
        SceneMaterialType.Swamp,
        "MaterialSwamp",
        "\196\144\225\186\167m l\225\186\167y"
      }
    }
  },
  {
    SceneTileType.GuidePoint,
    "\196\144i\225\187\131m D\225\186\171n \196\144\198\176\225\187\157ng",
    {
      {
        SceneTileType.GuidePoint,
        "GuidePoint"
      }
    }
  },
  {
    SceneTileType.OnHookPoint,
    "\196\144i\225\187\131m treo m\195\161y",
    {
      {
        SceneTileType.OnHookPoint,
        "onHook"
      }
    }
  },
  {
    SceneTileType.HideGrass,
    "C\225\187\143 \225\186\168n Th\195\162n",
    {
      {
        SceneTileType.HideGrass,
        "HideGrass"
      }
    }
  }
}
