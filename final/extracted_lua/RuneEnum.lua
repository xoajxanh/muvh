EquipRuneTypeEnum = {
  Left = enum(1),
  Middle = enum(2),
  Right = enum(3)
}
RuneTypeEnum = {
  AttackRune = enum(1),
  DefenseRune = enum(2),
  LifeRune = enum(3)
}
RuneAttributeEnum = {
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
  }
}
RunSuitAttributeEnum = {
  holyAttackPVP = AttributeWordUtil.GetUIWord("holyAttackPVP", "equipeUI"),
  holyResistancePVP = AttributeWordUtil.GetUIWord("holyResistancePVP", "equipeUI"),
  holyDamageMultiplierPVP = AttributeWordUtil.GetUIWord("holyDamageMultiplierPVP", "equipeUI"),
  holyAttackPVE = AttributeWordUtil.GetUIWord("holyAttackPVE", "equipeUI"),
  holyResistancePVE = AttributeWordUtil.GetUIWord("holyResistancePVE", "equipeUI"),
  holyDamageMultiplierPVE = AttributeWordUtil.GetUIWord("holyDamageMultiplierPVE", "equipeUI")
}
