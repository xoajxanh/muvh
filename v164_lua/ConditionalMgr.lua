require("GamePlay/FightFramework/Conditional/BaseConditional")
require("GamePlay/FightFramework/Conditional/Conditional_Pet")
require("GamePlay/FightFramework/Conditional/Conditional_Weapon")
require("GamePlay/FightFramework/Conditional/Conditional_Target")
require("GamePlay/FightFramework/Conditional/Conditional_RoleState")
require("GamePlay/FightFramework/Conditional/Conditional_Area")
require("GamePlay/FightFramework/Conditional/Conditional_SkillState")
require("GamePlay/FightFramework/Conditional/Conditional_SkillRange")
require("GamePlay/FightFramework/Conditional/Conditional_Attribute")
require("GamePlay/FightFramework/Conditional/Conditional_SkillState2")
require("GamePlay/FightFramework/Conditional/Conditional_ItemCd")
require("GamePlay/FightFramework/Conditional/Conditional_ItemRoleState")
require("GamePlay/FightFramework/Conditional/Conditional_Ride")
require("GamePlay/FightFramework/Conditional/Conditional_PickBag")
require("GamePlay/FightFramework/Conditional/Conditional_PickupCount")
require("GamePlay/FightFramework/Conditional/Conditional_PickUpLimitCount")
require("GamePlay/FightFramework/Conditional/Conditional_AutoPickVipPower")
require("GamePlay/FightFramework/Conditional/Conditional_AutoPickBelongTo")
require("GamePlay/FightFramework/Conditional/Conditional_AutoPickSelect")
require("GamePlay/FightFramework/Conditional/Conditional_AutoPickType")
ConditionalMgr = {}

function ConditionalMgr:Init()
  self:InitSkillNode()
  self:InitSkillNoRangeNode()
  self:InitSkillNoMonsterNode()
  self:InitSkillNoMonsterNode2()
  self:InitSkillNoCdNode()
  self:InitItemNode()
  self:InitPickUpNode()
  self:InitAutoPickUpNode()
end

function ConditionalMgr:InitAutoPickUpNode()
  self.autoPickUpNode = Conditional_AutoPickVipPower()
  local lastNode = self.autoPickUpNode
  local temNode = Conditional_PickUpBag()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_AutoPickBelongTo()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_AutoPickSelect()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_AutoPickType()
  lastNode:SetChild(temNode)
  lastNode = temNode
end

function ConditionalMgr:InitPickUpNode()
  self.pickUpNode = Conditional_PickUpBag()
  local lastNode = self.pickUpNode
  local temNode = Conditional_PickUpLimitCount()
  lastNode:SetChild(temNode)
  lastNode = temNode
end

function ConditionalMgr:InitSkillNode()
  self.skillNode = Conditional_Pet()
  local lastNode = self.skillNode
  local temNode = Conditional_Weapon()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Target()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_RoleState()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Area()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_SkillState()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_SkillRange()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Ride()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Attribute()
  lastNode:SetChild(temNode)
  lastNode = temNode
end

function ConditionalMgr:InitSkillNoCdNode()
  self.skillNoCdNode = Conditional_Pet()
  local lastNode = self.skillNoCdNode
  local temNode = Conditional_Weapon()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Target()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_RoleState()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Area()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_SkillRange()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Ride()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Attribute()
  lastNode:SetChild(temNode)
  lastNode = temNode
end

function ConditionalMgr:InitSkillNoRangeNode()
  self.skillNoRangeNode = Conditional_Pet()
  local lastNode = self.skillNoRangeNode
  local temNode = Conditional_Weapon()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Target()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_RoleState()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Area()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_SkillState()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Ride()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Attribute()
  lastNode:SetChild(temNode)
  lastNode = temNode
end

function ConditionalMgr:InitSkillNoMonsterNode()
  self.skillNoMonsterNode = Conditional_Pet()
  local lastNode = self.skillNoMonsterNode
  local temNode
  temNode = Conditional_Weapon()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_RoleState()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Area()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_SkillState()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Ride()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Attribute()
  lastNode:SetChild(temNode)
  lastNode = temNode
end

function ConditionalMgr:InitSkillNoMonsterNode2()
  self.skillNoMonsterNode2 = Conditional_Pet()
  local lastNode = self.skillNoMonsterNode2
  local temNode
  temNode = Conditional_Weapon()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_RoleState()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Area()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_SkillState2()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Ride()
  lastNode:SetChild(temNode)
  lastNode = temNode
  temNode = Conditional_Attribute()
  lastNode:SetChild(temNode)
  lastNode = temNode
end

function ConditionalMgr:InitItemNode()
  self.itemNode = Conditional_ItemCd()
  local lastNode = self.itemNode
  local temNode = Conditional_ItemRoleState()
  lastNode:SetChild(temNode)
  lastNode = temNode
end

function ConditionalMgr:CanReleaseSkill(tblSkill, tblAction)
  if tblSkill == nil or tblAction == nil then
    return false
  end
  return self.skillNode:Exec(tblSkill, tblAction)
end

function ConditionalMgr:CanReleaseSkillShowTips(tblSkill, tblAction)
  if tblSkill == nil or tblAction == nil then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\195\185ng k\225\187\185 n\196\131ng")
    return false
  end
  return self.skillNode:ExecShowTips(tblSkill, tblAction)
end

function ConditionalMgr:CanReleaseSkillNoCd(tblSkill, tblAction)
  if tblSkill == nil or tblAction == nil then
    return false
  end
  return self.skillNoCdNode:Exec(tblSkill, tblAction)
end

function ConditionalMgr:CanReleaseSkillShowTipsNoCd(tblSkill, tblAction)
  if tblSkill == nil or tblAction == nil then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\195\185ng k\225\187\185 n\196\131ng")
    return false
  end
  return self.skillNoCdNode:ExecShowTips(tblSkill, tblAction)
end

function ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblAction)
  if tblSkill == nil or tblAction == nil then
    return false
  end
  return self.skillNoRangeNode:Exec(tblSkill, tblAction)
end

function ConditionalMgr:CanReleaseSkillNoSkillRangeTips(tblSkill, tblAction)
  if tblSkill == nil or tblAction == nil then
    return false
  end
  return self.skillNoRangeNode:ExecShowTips(tblSkill, tblAction)
end

function ConditionalMgr:CanReleaseSkillNoTarget(tblSkill, tblAction)
  if tblSkill == nil or tblAction == nil then
    return false
  end
  return self.skillNoMonsterNode:Exec(tblSkill, tblAction)
end

function ConditionalMgr:CanReleaseSkillNoTargetTips(tblSkill, tblAction)
  if tblSkill == nil or tblAction == nil then
    return false
  end
  return self.skillNoMonsterNode2:ExecShowTips(tblSkill, tblAction)
end

function ConditionalMgr:CanUseItem(itemInfo)
  if itemInfo == nil then
    return false
  end
  return self.itemNode:Exec(itemInfo)
end

function ConditionalMgr:CanPickUpDropItem(itemInfo)
  if itemInfo == nil then
    return false
  end
  return self.pickUpNode:Exec(itemInfo)
end

function ConditionalMgr:CanAutoPickUpDropItem(itemInfo)
  if itemInfo == nil then
    return false
  end
  return self.autoPickUpNode:Exec(itemInfo)
end

function ConditionalMgr:CanPickUpDropItemTip(itemInfo)
  if itemInfo == nil then
    return false
  end
  return self.pickUpNode:ExecShowTips(itemInfo)
end

ConditionalMgr:Init()
