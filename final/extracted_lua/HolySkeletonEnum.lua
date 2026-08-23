HolySkeletonPageType = {
  HolySkeletonIntensify = enum(1),
  HolySkeletonInlay = enum(2)
}
HolySkeletonHoleType = {
  Big = enum(1),
  Small = enum(2)
}
HolySkeletonPlace = {
  Head = enum(1),
  ProtectHand = enum(),
  MasterHand = enum(),
  DeputyHand = enum(),
  Chest = enum(),
  Leg = enum(),
  Shoes = enum()
}
HolySkeletonPlaceName = {
  [1] = "\196\144\225\186\167u",
  [2] = "Bao Tay",
  [3] = "V\197\169 kh\195\173 ch\195\173nh",
  [4] = "V\197\169 kh\195\173 ph\225\187\165",
  [5] = "Kh\225\186\163i Gi\195\161p",
  [6] = "Bao Ch\195\162n",
  [7] = "Gi\195\160y"
}
HolySkeletonIntensifyAttribute = {
  [1] = {
    attributeName = "T\225\186\165n c\195\180ng",
    attributeConfigName = {
      "career_minimumPhysBaseDmg",
      "career_maximumPhysBaseDmg"
    }
  },
  [2] = {
    attributeName = "C\195\180ng ph\195\169p ",
    attributeConfigName = {
      "career_minimumWizBaseDmg",
      "career_maximumWizBaseDmg"
    }
  },
  [3] = {
    attributeName = "Ph\195\178ng Ng\225\187\177",
    attributeConfigName = {
      "career_defenseBase"
    }
  },
  [4] = {
    attributeName = "HP t\225\187\145i thi\225\187\131u",
    attributeConfigName = {
      "career_maximumHealth"
    }
  },
  [5] = {
    attributeName = "T\225\186\165n C\195\180ng Nguy\225\187\129n R\225\187\167a",
    attributeConfigName = {
      "career_minimumCurseBaseDmg",
      "career_maximumCurseBaseDmg"
    }
  }
}
