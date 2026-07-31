local LuaTemplateManager = {}
LuaComponentTemplates = {}
local GetLuaStateBehaviourFunction = CS.LuaStateBehaviour.Get

function LuaTemplateManager:Initialize()
  self.templateBase = require("LuaCore/LuaTemplate/Base/TemplateBase")
  self:RegisterLuaComponents()
  self:SetAllLuaComponentMetaTable()
end

function LuaTemplateManager:SetAllLuaComponentMetaTable()
  for k, v in pairs(LuaComponentTemplates) do
    if getmetatable(v) == nil then
      setmetatable(v, self.templateBase)
    end
    v.__index = v
    v.chunkName = k
    v.__gc = LuaTemplateManager.OnTemplateGetGCed
  end
  for k, v in pairs(LuaComponentTemplates) do
    v.__UnityFunctionExist = v.Start ~= nil or v.OnEnable ~= nil or v.OnDisable ~= nil or v.OnDestroy ~= nil
  end
end

function LuaTemplateManager.OnTemplateGetGCed(template)
  if template == nil then
    return
  end
  if template.OnDestruct ~= nil then
    template:OnDestruct()
  end
  for i, v in pairs(template) do
    template[i] = nil
  end
end

function LuaTemplateManager.GetNewTemplate(go, templateTable, ...)
  if go ~= nil then
    go = go.gameObject
  end
  if go == nil or IsNil(go) or templateTable == nil then
    return nil
  end
  local hasUnityFunction = templateTable.__UnityFunctionExist
  local newTable, stateBehaviour
  if hasUnityFunction then
    local isCreateNewComp = false
    stateBehaviour, isCreateNewComp = GetLuaStateBehaviourFunction(go, templateTable.chunkName)
    if isCreateNewComp == false and stateBehaviour ~= nil then
      stateBehaviour:Dispose()
    end
    newTable = stateBehaviour.ChunkTable
  else
    newTable = {}
  end
  setmetatable(newTable, templateTable)
  if hasUnityFunction and stateBehaviour ~= nil then
    if newTable.Start and stateBehaviour.isStartHasDone == false then
      function stateBehaviour.onStart()
        if newTable then
          newTable:Start()
        end
      end
    end
    if newTable.OnEnable then
      function stateBehaviour.onEnabled()
        if newTable then
          newTable:OnEnable()
        end
      end
    end
    if newTable.OnDisable then
      function stateBehaviour.onDisabled()
        if newTable then
          newTable:OnDisable()
        end
      end
    end
    if newTable.OnDestroy then
      function stateBehaviour.onDestroyed()
        if newTable then
          newTable:OnDestroy()
          
          newTable.go = nil
          newTable = nil
        end
      end
    end
  end
  newTable.go = go
  if newTable.Init then
    newTable:Init(...)
  end
  if newTable.Start and stateBehaviour.isStartHasDone == true then
    newTable:Start()
  end
  stateBehaviour = nil
  return newTable
end

function LuaTemplateManager:RegisterLuaComponents()
  LuaComponentTemplates.UIItemTemplate = require("GameUI/TemplateUI/UtilityTemplates/UIItemTemplate")
  LuaComponentTemplates.AttributeUnitTemplate = require("GameUI/TemplateUI/UtilityTemplates/AttributeUnitTemplate")
  LuaComponentTemplates.ConsumableUnitTemplate = require("GameUI/TemplateUI/UtilityTemplates/ConsumableUnitTemplate")
  LuaComponentTemplates.UIExchangeUnitTemplate = require("GameUI/TemplateUI/UtilityTemplates/UIExchangeUnitTemplate")
  LuaComponentTemplates.UISkillPreViewTemplate = require("GameUI/TemplateUI/UtilityTemplates/UISkillPreViewTemplate")
  LuaComponentTemplates.UIBuffPreviewTemplate = require("GameUI/TemplateUI/UtilityTemplates/UIBuffPreviewTemplate")
  LuaComponentTemplates.AmountChooseTemplate = require("GameUI/TemplateUI/UtilityTemplates/AmountChooseTemplate")
  LuaComponentTemplates.Actibity_EveryDayGrid = require("GameUI/TemplateUI/Activity_IndexUI_Templates/Actibity_EveryDayGrid")
  LuaComponentTemplates.Equip_GuardTopItemTemplate = require("GameUI/TemplateUI/Equip_GuardTemplate/Equip_GuardTopItemTemplate")
  LuaComponentTemplates.Equip_GuardAttributesTemplate = require("GameUI/TemplateUI/Equip_GuardTemplate/Equip_GuardAttributesTemplate")
  LuaComponentTemplates.Equip_GuardConsumeTemplate = require("GameUI/TemplateUI/Equip_GuardTemplate/Equip_GuardConsumeTemplate")
  LuaComponentTemplates.Tips_GuardAttributesTemplate = require("GameUI/TemplateUI/TipsTemplate/Tips_GuardAttributesTemplate")
  LuaComponentTemplates.Tip_TrinketTipTemplate = require("GameUI/TemplateUI/TipsTemplate/Tip_TrinketTipTemplate")
  LuaComponentTemplates.BossUI_TitleTogTemp = require("GameUI/TemplateUI/BossUITemplates/BossUI_TitleTogTemp")
  LuaComponentTemplates.BossUI_dropListTemp = require("GameUI/TemplateUI/BossUITemplates/BossUI_dropListTemp")
  LuaComponentTemplates.BossUI_dropItemTemp = require("GameUI/TemplateUI/BossUITemplates/BossUI_dropItemTemp")
  LuaComponentTemplates.BossUI_WildBossTemp = require("GameUI/TemplateUI/BossUITemplates/BossUI_WildBossTemp")
  LuaComponentTemplates.BossUI_SecretBossTemp = require("GameUI/TemplateUI/BossUITemplates/BossUI_SecretBossTemp")
  LuaComponentTemplates.BossUI_ReinBossTemp = require("GameUI/TemplateUI/BossUITemplates/BossUI_ReinBossTemp")
  LuaComponentTemplates.BossUI_AngelBossTemp = require("GameUI/TemplateUI/BossUITemplates/BossUI_AngelBossTemp")
  LuaComponentTemplates.BossUI_RegenerateBossTemp = require("GameUI/TemplateUI/BossUITemplates/BossUI_RegenerateBossTemp")
  LuaComponentTemplates.BossUI_HolySkeletonBossTemp = require("GameUI/TemplateUI/BossUITemplates/BossUI_HolySkeletonBossTemp")
  LuaComponentTemplates.BossUI_RunesNewBossTemp = require("GameUI/TemplateUI/BossUITemplates/BossUI_RunesNewBossTemp")
  LuaComponentTemplates.BossUI_EnchantSmeltBossTemp = require("GameUI/TemplateUI/BossUITemplates/BossUI_EnchantSmeltBossTemp")
  LuaComponentTemplates.NightFightRankTemplate = require("GameUI/TemplateUI/Activity_NightFightRankUITemplates/NightFightRankTemplate")
  LuaComponentTemplates.NightFightMeRankTemplate = require("GameUI/TemplateUI/Activity_NightFightRankUITemplates/NightFightMeRankTemplate")
  LuaComponentTemplates.GoalUI_KalunteRuinsTemp = require("GameUI/TemplateUI/GoalUITemplates/GoalUI_KalunteRuinsTemp")
  LuaComponentTemplates.GoalUI_AncientBossTemp = require("GameUI/TemplateUI/GoalUITemplates/GoalUI_AncientBossTemp")
  LuaComponentTemplates.GoalUI_KSBattleTemp = require("GameUI/TemplateUI/GoalUITemplates/GoalUI_KSBattleTemplates/GoalUI_KSBattleTemp")
  LuaComponentTemplates.GoalUI_KSBattleRankTemp = require("GameUI/TemplateUI/GoalUITemplates/GoalUI_KSBattleTemplates/GoalUI_KSBattleRankTemp")
  LuaComponentTemplates.GoalUI_KSBattleMeRankTemp = require("GameUI/TemplateUI/GoalUITemplates/GoalUI_KSBattleTemplates/GoalUI_KSBattleMeRankTemp")
  LuaComponentTemplates.ZoomSecretRealmInstanceTemplate = require("GameUI/TemplateUI/GoalUITemplates/ZoomSecretRealmInstanceTemplate")
  LuaComponentTemplates.Vip_MemberPageTemplat = require("GameUI/TemplateUI/Vip_MemberTemplates/Vip_MemberPageTemplat")
  LuaComponentTemplates.Vip_MemberDesTemplate = require("GameUI/TemplateUI/Vip_MemberTemplates/Vip_MemberDesTemplate")
  LuaComponentTemplates.Vip_MemberMissionTemplat = require("GameUI/TemplateUI/Vip_MemberTemplates/Vip_MemberMissionTemplat")
  LuaComponentTemplates.Vip_TaskMemberItemTemplate = require("GameUI/TemplateUI/Vip_MemberTemplates/Vip_TaskPanel/Vip_TaskMemberItemTemplate")
  LuaComponentTemplates.Vip_MemberDailyMissionTemplat = require("GameUI/TemplateUI/Vip_MemberTemplates/Vip_TaskPanel/Vip_MemberDailyMissionTemplat")
  LuaComponentTemplates.onHookTemplate = require("GameUI/TemplateUI/onHookTemplate/onHookTemplate")
  LuaComponentTemplates.OnHookBossTemplate = require("GameUI/TemplateUI/onHookTemplate/OnHookBoss/OnHookBossTemplate")
  LuaComponentTemplates.OnHookBossPosTemplate = require("GameUI/TemplateUI/onHookTemplate/OnHookBoss/OnHookBossPosTemplate")
  LuaComponentTemplates.OnHookPointTemplate = require("GameUI/TemplateUI/onHookTemplate/OnHookPoint/OnHookPointTemplate")
  LuaComponentTemplates.OnHookMainTblTemplate = require("GameUI/TemplateUI/onHookTemplate/OnHookTbl/OnHookMainTblTemplate")
  LuaComponentTemplates.OnHookSubTblTemplate = require("GameUI/TemplateUI/onHookTemplate/OnHookTbl/OnHookSubTblTemplate")
  LuaComponentTemplates.Toggle_SingleToggleTemplate = require("GameUI/TemplateUI/Toggle/SingleToggle")
  LuaComponentTemplates.MessagePanelTemplate = require("GameUI/TemplateUI/GM_ToolTemplates/MessagePanelTemplate")
  LuaComponentTemplates.MessageItemTemplate = require("GameUI/TemplateUI/GM_ToolTemplates/MessageItemTemplate")
  LuaComponentTemplates.CommandPanelTemplate = require("GameUI/TemplateUI/GM_ToolTemplates/CommandPanelTemplate")
  LuaComponentTemplates.WarReportPanelTemplate = require("GameUI/TemplateUI/GM_ToolTemplates/WarReportPanelTemplate")
  LuaComponentTemplates.RightMonsterListTemplate = require("GameUI/TemplateUI/Main_MainMenuUITemplate/RightMonsterListTemplate/RightMonsterListTemplate")
  LuaComponentTemplates.RightMonsterList_SingleTemplate = require("GameUI/TemplateUI/Main_MainMenuUITemplate/RightMonsterListTemplate/RightMonsterList_SingleTemplate")
  LuaComponentTemplates.ExperienceBonusViewTemplate = require("GameUI/TemplateUI/Main_MainMenuUITemplate/ExperienceBonusTemplates/ExperienceBonusViewTemplate")
  LuaComponentTemplates.ExperienceBonusViewUnitTemplate = require("GameUI/TemplateUI/Main_MainMenuUITemplate/ExperienceBonusTemplates/ExperienceBonusViewUnitTemplate")
  LuaComponentTemplates.BossExpTemplate = require("GameUI/TemplateUI/Main_MainMenuUITemplate/BossExpTemplates/BossExpTemplate")
  LuaComponentTemplates.MapExpTeleportTemplate = require("GameUI/TemplateUI/Main_MapDetailUITemplate/MapExpTeleportTemplate")
  LuaComponentTemplates.MapTeleportTemplate = require("GameUI/TemplateUI/Main_MapDetailUITemplate/MapTeleportTemplate")
  LuaComponentTemplates.BossLocationTemplate = require("GameUI/TemplateUI/Main_MapDetailUITemplate/BossLocationTemplate")
  LuaComponentTemplates.OnHookTemplate = require("GameUI/TemplateUI/Main_MapDetailUITemplate/OnHookTemplate")
  LuaComponentTemplates.MapBuffTemplate = require("GameUI/TemplateUI/Main_MapDetailUITemplate/MapBuffTemplate")
  LuaComponentTemplates.SingleDeadStrengthenPromptTemplate = require("GameUI/TemplateUI/PromptTemplate/DeadStrengthenPromptTemplate/SingleDeadStrengthenPromptTemplate")
  LuaComponentTemplates.BuffItem_BaseTemplate = require("GameUI/TemplateUI/Main_BuffUITemplates/BuffItem_BaseTemplate")
  LuaComponentTemplates.BuffItem_MemberCardTemplate = require("GameUI/TemplateUI/Main_BuffUITemplates/BuffItem_MemberCardTemplate")
  LuaComponentTemplates.BuffItem_AdvanceMonthCardTemplate = require("GameUI/TemplateUI/Main_BuffUITemplates/BuffItem_AdvanceMonthCardTemplate")
  LuaComponentTemplates.BuffItem_NormalTemplate = require("GameUI/TemplateUI/Main_BuffUITemplates/BuffItem_NormalTemplate")
  LuaComponentTemplates.ExtraBuffItemsTemplate = require("GameUI/TemplateUI/Main_BuffUITemplates/ExtraBuffItemsTemplate")
  LuaComponentTemplates.Arrest_BossTemplates = require("GameUI/TemplateUI/Arrest_BossTemplates/Arrest_BossTemplates")
  LuaComponentTemplates.Equip_SignetLevelUnitTemplate = require("GameUI/TemplateUI/Equip_SignetTemplates/Equip_SignetLevelUnitTemplate")
  LuaComponentTemplates.Equip_SignetLevelTipsTemplate = require("GameUI/TemplateUI/Equip_SignetTemplates/Equip_SignetLevelTipsTemplate")
  LuaComponentTemplates.GameBook_PlayFeatureTemplates = require("GameUI/TemplateUI/GameBookTemplates/GameBook_PlayFeatureTemplates")
  LuaComponentTemplates.GameBook_CombineWayTemplates = require("GameUI/TemplateUI/GameBookTemplates/GameBook_CombineWayTemplates")
  LuaComponentTemplates.GameBook_CombineWaySecondTemplates = require("GameUI/TemplateUI/GameBookTemplates/GameBook_CombineWaySecondTemplates")
  LuaComponentTemplates.GameBook_RaidersTemplates = require("GameUI/TemplateUI/GameBookTemplates/GameBook_RaidersTemplates")
  LuaComponentTemplates.UILiftLimitBuy = require("GameUI/TemplateUI/RechargePackageTemplates/UILiftLimitPackage")
  LuaComponentTemplates.LiftLimitBuyTemps = require("GameUI/TemplateUI/RechargePackageTemplates/LiftLimitPackageTemp")
  LuaComponentTemplates.LuckyStarTemp = require("GameUI/TemplateUI/Recharge_Welfare/LuckyStarTemp")
  LuaComponentTemplates.LuckyStarType1Temp = require("GameUI/TemplateUI/Recharge_Welfare/LuckyStarType1Temp")
  LuaComponentTemplates.GoldDiamondRechargeTemp = require("GameUI/TemplateUI/Recharge_Welfare/GoldDiamondRechargeTemp")
  LuaComponentTemplates.TokenRechargeTemplate = require("GameUI/TemplateUI/TokenRechargeBenefits/TokenRechargeTemplate")
  LuaComponentTemplates.GemCombineEffectTemplate = require("GameUI/TemplateUI/Equip_GemTemplates/GemCombineEffectTemplate")
  LuaComponentTemplates.MasterSkillTemplate = require("GameUI/TemplateUI/MasterTemplates/SkillTemplate")
  LuaComponentTemplates.MasterTabTalentTemplate = require("GameUI/TemplateUI/MasterTemplates/TabTalentTemplate")
  LuaComponentTemplates.Instance_KalimaCastlePageTemplate = require("GameUI/TemplateUI/Instance_KalimaCastleUITemplate/Instance_KalimaCastlePageTemplate")
  LuaComponentTemplates.RegenerateEntrysTemplate = require("GameUI/TemplateUI/Equip_RegenerateUI/RegenerateEntrysTemplate")
  LuaComponentTemplates.RegenerateNewEntrysTemplate = require("GameUI/TemplateUI/Equip_RegenerateUI/RegenerateNewEntrysTemplate")
  LuaComponentTemplates.RegenerateNewElouEntryTemplate = require("GameUI/TemplateUI/Equip_RegenerateUI/RegenerateNewElouEntryTemplate")
  LuaComponentTemplates.RegenrateNewElouEntryTempateEvo = require("GameUI/TemplateUI/Equip_RegenerateUI/RegenrateNewElouEntryTempateEvo")
  LuaComponentTemplates.SuitSwitchTemplate = require("GameUI/TemplateUI/Equip_SuitTemplate/SuitSwitchTemplate")
  LuaComponentTemplates.HolySpiritPointTemplate = require("GameUI/TemplateUI/Equip_HolySpiritTemplates/HolySpiritPointTemplate")
  LuaComponentTemplates.AllHolySpiritAttributeTemplate = require("GameUI/TemplateUI/Equip_HolySpiritTemplates/AllHolySpiritAttributeTemplate")
  LuaComponentTemplates.CurHolySpiritAttributeTemplates = require("GameUI/TemplateUI/Equip_HolySpiritTemplates/CurHolySpiritAttributeTemplates")
  LuaComponentTemplates.MasterSkillCareerViewTemplate = require("GameUI/TemplateUI/MasterSkill_NewMainUITemplates/MasterSkillCareerViewTemplate")
  LuaComponentTemplates.MasterSkillItemTemplate = require("GameUI/TemplateUI/MasterSkill_NewMainUITemplates/MasterSkillItemTemplate")
  LuaComponentTemplates.MasterSkillLineViewTemplate = require("GameUI/TemplateUI/MasterSkill_NewMainUITemplates/MasterSkillLineViewTemplate")
  LuaComponentTemplates.MasterSkillLineItemTemplate = require("GameUI/TemplateUI/MasterSkill_NewMainUITemplates/MasterSkillLineItemTemplate")
  LuaComponentTemplates.BuffTipInfoTemplate = require("GameUI/TemplateUI/BuffTemplates/BuffTipTemplate")
  LuaComponentTemplates.panel_KaLunTeCrossgomainTemplate = require("GameUI/TemplateUI/CrossServerKalunte/CrossServerKalunteGomainTemplate")
  LuaComponentTemplates.panel_KunShouCrossTemplate = require("GameUI/TemplateUI/CrossServerDesperateFight/CrossServerDesperateFightTemplate")
  LuaComponentTemplates.CrossServerDesRewardTemplate = require("GameUI/TemplateUI/CrossServerDesperateFight/CrossServerDesRewardTemplate")
  LuaComponentTemplates.panel_ThreeVsThreeCrossTemplate = require("GameUI/TemplateUI/CrossServerThreeVsThree/CrossServerThreeVsThreeGomainTemplate")
  LuaComponentTemplates.SportMatch3V3Template = require("GameUI/TemplateUI/CrossServerThreeVsThree/SportMatch3V3Template")
  LuaComponentTemplates.SportTeam3V3Template = require("GameUI/TemplateUI/CrossServerThreeVsThree/SportTeam3V3Template")
  LuaComponentTemplates.RewardRankTemplate = require("GameUI/TemplateUI/CrossServerThreeVsThree/RewardRankTemplate")
  LuaComponentTemplates.RoomPlayerTemplate = require("GameUI/TemplateUI/CrossServerThreeVsThree/RoomPlayerTemplate")
  LuaComponentTemplates.InvitablePlayerTemplate = require("GameUI/TemplateUI/CrossServerThreeVsThree/InvitablePlayerTemplate")
  LuaComponentTemplates.panel_DuoQiCrossTemplate = require("GameUI/TemplateUI/DuoQiCrossTemplates/DuoQiCrossGomainTemplate")
  LuaComponentTemplates.panel_ZhengBaTemplate = require("GameUI/TemplateUI/DuoQiCrossTemplates/panel_ZhengBaTemplate")
  LuaComponentTemplates.panel_ZhangBaTeamTemplate = require("GameUI/TemplateUI/DuoQiCrossTemplates/panel_ZhangBaTeamTemplate")
  LuaComponentTemplates.panel_ZhangBaGoodTeamTemplate = require("GameUI/TemplateUI/DuoQiCrossTemplates/panel_ZhangBaGoodTeamTemplate")
  LuaComponentTemplates.panel_ZhangBaRankTemplate = require("GameUI/TemplateUI/DuoQiCrossTemplates/panel_ZhangBaRankTemplate")
  LuaComponentTemplates.MiniMap_KaLunTeVirusCircle = require("GameUI/TemplateUI/Mu2_KLTRuinsTemplate/VirusCircleTemplates/MiniMapVirusCircleTemplate")
  LuaComponentTemplates.OutMiniMapVirusCircleTemplate = require("GameUI/TemplateUI/Mu2_KLTRuinsTemplate/VirusCircleTemplates/OutMiniMapVirusCircleTemplate")
  LuaComponentTemplates.TurntableUI_Templates = require("GameUI/TemplateUI/Activity_TurntableUI/TurntableUI_Templates")
  LuaComponentTemplates.Activity_CommercialHoliday_Page = require("GameUI/TemplateUI/Activity_CommercialHoliday_PageTemplate/Activity_CommercialHoliday_Page")
  LuaComponentTemplates.Activity_CommercialTimeLimited_Page = require("GameUI/TemplateUI/Activity_CommercialTimeLimitedTemplates/Activity_CommercialTimeLimited_Page")
  LuaComponentTemplates.HolidayLuckyTurntableTemplate = require("GameUI/TemplateUI/HolidayActivityTemplates/HolidayLuckyTurntableTemplate")
  LuaComponentTemplates.TurntableGiftPropTemplate = require("GameUI/TemplateUI/HolidayActivityTemplates/TurntableGiftPropTemplate")
  LuaComponentTemplates.WorldCupGuessTemplate = require("GameUI/TemplateUI/Activity_WorldCupGuessTemplates/WorldCupGuessTemplate")
  LuaComponentTemplates.WorldCupRaceTemplate = require("GameUI/TemplateUI/Activity_WorldCupGuessTemplates/WorldCupRaceTemplate")
  LuaComponentTemplates.returnRewardTemplate = require("GameUI/TemplateUI/Activity_CommercialReturn_PageTemplate/RetrunActivityLandingPage")
  LuaComponentTemplates.Activity_CommercialReturn_Page = require("GameUI/TemplateUI/Activity_CommercialReturn_PageTemplate/Activity_CommercialReturn_Page")
  LuaComponentTemplates.SevenDayGiftTemplate = require("GameUI/TemplateUI/Activity_SevenDayGiftTemplates/SevenDayGiftTemplate")
  LuaComponentTemplates.SevenDayGiftDayGiftTemplate = require("GameUI/TemplateUI/Activity_SevenDayGiftTemplates/SevenDayGift_DayGiftTemplate")
  LuaComponentTemplates.SevenDayGiftTargetRewardTemplate = require("GameUI/TemplateUI/Activity_SevenDayGiftTemplates/SevenDayGift_TargetRewardTemplate")
  LuaComponentTemplates.FirecrackerTreasureHuntingTemplate = require("GameUI/TemplateUI/HolidayActivityTemplates/FirecrackerTreasureHuntingTemplate")
  LuaComponentTemplates.FTHCumulativeRewardsTemplate = require("GameUI/TemplateUI/HolidayActivityTemplates/FTHCumulativeRewardsTemplate")
  LuaComponentTemplates.FTHDrawRewardsTemplate = require("GameUI/TemplateUI/HolidayActivityTemplates/FTHDrawRewardsTemplate")
  LuaComponentTemplates.Appear_CoutureTemplate = require("GameUI/TemplateUI/AppearTemplates/Appear_Couture/Appear_CoutureTemplate")
  LuaComponentTemplates.Appear_Couture_AttributeTemplate = require("GameUI/TemplateUI/AppearTemplates/Appear_Couture/Appear_Couture_AttributeTemplate")
  LuaComponentTemplates.Appear_Couture_CoutureItemTemplate = require("GameUI/TemplateUI/AppearTemplates/Appear_Couture/Appear_Couture_CoutureItemTemplate")
  LuaComponentTemplates.Appear_Couture_StrengthenTemplate = require("GameUI/TemplateUI/AppearTemplates/Appear_Couture/Appear_Couture_StrengthenTemplate")
  LuaComponentTemplates.GiftShowTemplate = require("GameUI/TemplateUI/SpellSwordGiftTemplates/GiftShowTemplate")
  LuaComponentTemplates.CoalitionTemplate = require("GameUI/TemplateUI/Activity_LeagueSiegeUITemplates/CoalitionPanel/CoalitionTemplate")
  LuaComponentTemplates.SingleCoalitionTemplate = require("GameUI/TemplateUI/Activity_LeagueSiegeUITemplates/CoalitionPanel/SingleCoalitionTemplate")
  LuaComponentTemplates.SingleUnionTemplate = require("GameUI/TemplateUI/Tip_LeagueSiegeInfoTipUI_Templates/SingleUnionTemplate")
  LuaComponentTemplates.Coalition_SiegeTemplate = require("GameUI/TemplateUI/Activity_LeagueSiegeUITemplates/Coalition_SiegePanel/Coalition_SiegeTemplate")
  LuaComponentTemplates.LianChongFanLiViewTemplate = require("GameUI/TemplateUI/Activity_LianChongFanLi_UITemplates/LianChongFanLiViewTemplate")
  LuaComponentTemplates.LianChongFanLiGearUnitTemplate = require("GameUI/TemplateUI/Activity_LianChongFanLi_UITemplates/LianChongFanLiGearUnitTemplate")
  LuaComponentTemplates.LianChongFanLiTaskUnitTemplate = require("GameUI/TemplateUI/Activity_LianChongFanLi_UITemplates/LianChongFanLiTaskUnitTemplate")
  LuaComponentTemplates.EquipRuneTemplate = require("GameUI/TemplateUI/Equip_RuneTemplate/EquipRuneTemplate")
  LuaComponentTemplates.EquipBagRuneTemplate = require("GameUI/TemplateUI/Equip_RuneTemplate/EquipBagRuneTemplate")
  LuaComponentTemplates.EquipRuneAttributeTemplate = require("GameUI/TemplateUI/Equip_RuneTemplate/EquipRuneAttributeTemplate")
  LuaComponentTemplates.Bag_SellInfoConfigItemTemplate = require("GameUI/TemplateUI/Bag_SellInfoConfigUITemplates/Bag_SellInfoConfigItemTemplate")
  LuaComponentTemplates.HolyRingItemDataTemplate = require("GameUI/TemplateUI/HolyRingEquipDataTemplate/HolyRingItemDataTemplate")
  LuaComponentTemplates.HolyRingHoleDataTemplate = require("GameUI/TemplateUI/HolyRingEquipDataTemplate/HolyRingHoleDataTemplate")
  LuaComponentTemplates.HolyRingCombineOtherViewTemp = require("GameUI/TemplateUI/HolyRingEquipDataTemplate/HolyRingCombineOtherViewTemp")
  LuaComponentTemplates.HolyRingCombineBagTemplate = require("GameUI/TemplateUI/HolyRingEquipDataTemplate/HolyRingCombineBagTemplate")
  LuaComponentTemplates.HolyRingInformationAttributeTemp = require("GameUI/TemplateUI/HolyRingEquipDataTemplate/HolyRingInformationAttributeTemp")
  LuaComponentTemplates.HolyRingPowerAttributeTemp = require("GameUI/TemplateUI/HolyRingEquipDataTemplate/HolyRingPowerAttributeTemp")
  LuaComponentTemplates.Activity_CommercialCombine_Page = require("GameUI/TemplateUI/Activity_CommercialCombine/Page/Activity_CommercialCombine_Page")
  LuaComponentTemplates.WarOrderPassTemplate = require("GameUI/TemplateUI/Activity_WarOrderPassTemplates/WarOrderPassTemplate")
  LuaComponentTemplates.WarOrderPassRewardTemplate = require("GameUI/TemplateUI/Activity_WarOrderPassTemplates/WarOrderPassRewardTemplate")
  LuaComponentTemplates.WarOrderPassTaskTemplate = require("GameUI/TemplateUI/Activity_WarOrderPassTemplates/WarOrderPassTaskTemplate")
  LuaComponentTemplates.Activity_CommercialRankingTemplate = require("GameUI/TemplateUI/Activity_CommercialCombine/Page/CommercialRankingTemplate")
  LuaComponentTemplates.Activity_CommercialRankTemplate = require("GameUI/TemplateUI/Activity_CommercialCombine/Page/Activity_CommercialRankTemplate")
  LuaComponentTemplates.LianChongFanLiViewTemplate = require("GameUI/TemplateUI/Activity_LianChongFanLi_UITemplates/LianChongFanLiViewTemplate")
  LuaComponentTemplates.LianChongFanLiGearUnitTemplate = require("GameUI/TemplateUI/Activity_LianChongFanLi_UITemplates/LianChongFanLiGearUnitTemplate")
  LuaComponentTemplates.LianChongFanLiTaskUnitTemplate = require("GameUI/TemplateUI/Activity_LianChongFanLi_UITemplates/LianChongFanLiTaskUnitTemplate")
  LuaComponentTemplates.Activity_CombineFirstGift_MainTemplates = require("GameUI/TemplateUI/Activity_CombineFirstGiftTemplates/Activity_CombineFirstGift_MainTemplates")
  LuaComponentTemplates.Activity_CombineFirstGift_ItemTemplates = require("GameUI/TemplateUI/Activity_CombineFirstGiftTemplates/Activity_CombineFirstGift_ItemTemplates")
  LuaComponentTemplates.Activity_GoodFiftsEveryDay_MainTemplates = require("GameUI/TemplateUI/Activity_GoodFiftsEveryDay_ItemTemplates/Activity_GoodFiftsEveryDay_MainTemplates")
  LuaComponentTemplates.Skill_SkillPreviewPageViewTemplate = require("GameUI/TemplateUI/Skill_SkillPreviewUITemplates/Skill_SkillPreviewPageViewTemplate")
  LuaComponentTemplates.Skill_SkillPreviewMenuTemplate = require("GameUI/TemplateUI/Skill_SkillPreviewUITemplates/Skill_SkillPreviewMenuTemplate")
  LuaComponentTemplates.OnHookGetExpTemplate = require("GameUI/TemplateUI/onHookTemplate/OnHookGetExp/OnHookGetExpTemplate")
  LuaComponentTemplates.holidayPetInvestTemplate = require("GameUI/TemplateUI/Activity_CommercialHoliday_PageTemplate/Activity_CommercialHoliday_PetInvestPage")
  LuaComponentTemplates.WarAllianceRedEnvelopeTemplate = require("GameUI/TemplateUI/Activity_WarAllianceRedEnvelope/WarAllianceRedEnvelopeTemplate")
  LuaComponentTemplates.SpringFestivalTemp = require("GameUI/TemplateUI/SpringFestivalTemp/SpringFestivalTemp")
  LuaComponentTemplates.SpringPanelUITemp = require("GameUI/TemplateUI/SpringFestivalTemp/SpringPanelUITemp")
  LuaComponentTemplates.ShoppingSpreeTemp = require("GameUI/TemplateUI/Activity_CommercialHoliday_PageTemplate/ShoppingSpreeTemp")
  LuaComponentTemplates.ConnectionGiftPanelUITemp = require("GameUI/TemplateUI/HolidayActivityTemplates/ConnectionGiftUI/ConnectionGiftPanelUITemp")
  LuaComponentTemplates.ConnectionGiftUITemp = require("GameUI/TemplateUI/HolidayActivityTemplates/ConnectionGiftUI/ConnectionGiftUITemp")
  LuaComponentTemplates.Tip_taskPanelTemp = require("GameUI/TemplateUI/HolidayActivityTemplates/ConnectionGiftUI/Tip_taskPanelTemp")
  LuaComponentTemplates.ConnectionGiftOpenTipsUITemp = require("GameUI/TemplateUI/HolidayActivityTemplates/ConnectionGiftUI/ConnectionGiftOpenTipsUITemp")
  LuaComponentTemplates.Commercial_RechargeAndReceiveTemp = require("GameUI/TemplateUI/Commercial_Niudan/Commercial_RechargeAndReceiveTemp")
  LuaComponentTemplates.Commercial_CommerceNiudanTemp = require("GameUI/TemplateUI/Commercial_Niudan/Commercial_CommerceNiudanTemp")
  LuaComponentTemplates.CrossServer_PreviewTemplate = require("GameUI/TemplateUI/CrossServer_PreviewTemplates/CrossServer_PreviewTemplate")
  LuaComponentTemplates.CrossServer_Preview_PageTemplate = require("GameUI/TemplateUI/CrossServer_PreviewTemplates/CrossServer_Preview_PageTemplate")
  LuaComponentTemplates.CrossServer_Preview_PlaneTemplate = require("GameUI/TemplateUI/CrossServer_PreviewTemplates/CrossServer_Preview_PlaneTemplate")
  LuaComponentTemplates.OpenServerInvestTemplate = require("GameUI/TemplateUI/Activity_OpenServerInvestmentTemplates/OpenServerInvestTemplate")
  LuaComponentTemplates.OpenServerInvestGradeTemplate = require("GameUI/TemplateUI/Activity_OpenServerInvestmentTemplates/OpenServerInvestGradeTemplate")
  LuaComponentTemplates.OpenServerInvestGiftTemplate = require("GameUI/TemplateUI/Activity_OpenServerInvestmentTemplates/OpenServerInvestGiftTemplate")
  LuaComponentTemplates.Activity_CommercialCombineTaskTemplate = require("GameUI/TemplateUI/Activity_CommercialCombine/Page/Activity_CommercialCombineTaskTemplate")
  LuaComponentTemplates.HolySkeletonBagUITemplates = require("GameUI/TemplateUI/Equip_HolySkeletonInlayTemplates/HolySkeletonBagUITemplates")
  LuaComponentTemplates.BigHolySkeletonIntensifyTemp = require("GameUI/TemplateUI/Equip_HolySkeletonTemplates/BigHolySkeletonIntensifyTemp")
  LuaComponentTemplates.SmallHolySkeletonIntensifyTemp = require("GameUI/TemplateUI/Equip_HolySkeletonTemplates/SmallHolySkeletonIntensifyTemp")
  LuaComponentTemplates.HolySkeletonCombineOtherViewTemplate = require("GameUI/TemplateUI/Equip_HolySkeletonTemplates/HolySkeletonCombineOtherViewTemplate")
  LuaComponentTemplates.HolySkeletonCombineSoulBagTemplate = require("GameUI/TemplateUI/Equip_HolySkeletonTemplates/HolySkeletonCombineSoulBagTemplate")
  LuaComponentTemplates.RechargeSurprisePageTemplate = require("GameUI/TemplateUI/Recharge_SurpriseTemplates/RechargeSurprisePageTemplate")
  LuaComponentTemplates.HolidayInvestTemplate = require("GameUI/TemplateUI/Activity_HolidayInvestTemplate/HolidayInvestTemplate")
  LuaComponentTemplates.HolidayInvestPageTemplate = require("GameUI/TemplateUI/Activity_HolidayInvestTemplate/HolidayInvestPageTemplate")
  LuaComponentTemplates.HolidayInvestTaskTemplate = require("GameUI/TemplateUI/Activity_HolidayInvestTemplate/HolidayInvestTaskTemplate")
  LuaComponentTemplates.LuckyRebateTemplate = require("GameUI/TemplateUI/Activity_LuckyRebateTemplates/LuckyRebateTemplate")
  LuaComponentTemplates.LuckyRebateDesTemplate = require("GameUI/TemplateUI/Activity_LuckyRebateTemplates/LuckyRebateDesTemplate")
  LuaComponentTemplates.LuckyRebateScrollTemplate = require("GameUI/TemplateUI/Activity_LuckyRebateTemplates/LuckyRebateScrollTemplate")
  LuaComponentTemplates.KillNoticeTemplate = require("GameUI/TemplateUI/Main_NoticeUITemplates/KillNoticeTemplate")
  LuaComponentTemplates.ScoreNoticeTemplate = require("GameUI/TemplateUI/Main_NoticeUITemplates/ScoreNoticeTemplate")
  LuaComponentTemplates.RefreshRankTemplate = require("GameUI/TemplateUI/Commercial_RewriteServer/RefreshRankTemplate")
  LuaComponentTemplates.ScoreCompareTemplate = require("GameUI/TemplateUI/Activity_3V3Template/ActivityExpandPanelTemplate/ScoreCompareTemplate/ScoreCompareTemplate")
  LuaComponentTemplates.EnemyListTemplate = require("GameUI/TemplateUI/Activity_3V3Template/ActivityExpandPanelTemplate/EnemyListTemplate/EnemyListTemplate")
  LuaComponentTemplates.SingleEnemyListTemplate = require("GameUI/TemplateUI/Activity_3V3Template/ActivityExpandPanelTemplate/EnemyListTemplate/SingleEnemyListTemplate")
  LuaComponentTemplates.HeadTemplate = require("GameUI/TemplateUI/Activity_3V3Template/ActivityExpandPanelTemplate/EnemyListTemplate/HeadTemplate")
  LuaComponentTemplates.PlayerPointTemplate = require("GameUI/TemplateUI/Activity_3V3Template/ActivityExpandPanelTemplate/EnemyListTemplate/PlayerPointTemplate")
  LuaComponentTemplates.SayCommandListTemplate = require("GameUI/TemplateUI/Activity_3V3Template/ActivityExpandPanelTemplate/AnnouncementCommandTemplate/SayCommandListTemplate")
  LuaComponentTemplates.SurrenderTemplate = require("GameUI/TemplateUI/Activity_3V3Template/ActivityExpandPanelTemplate/SurrenderTemplate/SurrenderTemplate")
  LuaComponentTemplates.SurrenderChunkTemplate = require("GameUI/TemplateUI/Activity_3V3Template/ActivityExpandPanelTemplate/SurrenderTemplate/SurrenderChunkTemplate")
  LuaComponentTemplates.RewardRank_AllPanelTemplate = require("GameUI/TemplateUI/DemonHunt_ListInfoUI/RewardRank_AllPanelTemplate")
  LuaComponentTemplates.ThreeVSThreeTemplate = require("GameUI/TemplateUI/Activity_3V3Template/ActivityExpandPanelTemplate/ThreeVSThreeTemplate/ThreeVSThreeTemplate")
  LuaComponentTemplates.ClimbTowerViewTemplate = require("GameUI/TemplateUI/Instance_ClimbTowerTemplates/ClimbTowerViewTemplate")
  LuaComponentTemplates.Instance_ClimbTowerTower_SpecialTemplate = require("GameUI/TemplateUI/Instance_ClimbTowerTemplates/Instance_ClimbTowerTower_SpecialTemplate")
  LuaComponentTemplates.RuneHoleTemplate = require("GameUI/TemplateUI/Equip_NewRuneTemplate/RuneHoleTemplate")
  LuaComponentTemplates.EquipBagNewRuneTemplate = require("GameUI/TemplateUI/Equip_NewRuneTemplate/EquipBagNewRuneTemplate")
  LuaComponentTemplates.NewRuneCombinationAttributeTemplate = require("GameUI/TemplateUI/Equip_NewRuneTemplate/NewRuneCombinationAttributeTemplate")
  LuaComponentTemplates.FirstLoginTemplate = require("GameUI/TemplateUI/PCActivityTemplates/FirstLoginTemplate")
  LuaComponentTemplates.DailyRegistrationTemplate = require("GameUI/TemplateUI/PCActivityTemplates/DailyRegistrationTemplate")
  LuaComponentTemplates.CumulativeRechargeTemplate = require("GameUI/TemplateUI/PCActivityTemplates/CumulativeRechargeTemplate")
  LuaComponentTemplates.CrystalNucleusBagItemTemplate = require("GameUI/TemplateUI/CrystalNucleus/CrystalNucleusBagItemTemplate")
  LuaComponentTemplates.Puzzle_JH_CostTemplate = require("GameUI/TemplateUI/Puzzle_JH_PanelTemplate/Puzzle_JH_CostTemplate")
  LuaComponentTemplates.Puzzle_JH_PanelQiangHuaTemplate = require("GameUI/TemplateUI/Puzzle_JH_PanelTemplate/Puzzle_JH_PanelQiangHuaTemplate")
  LuaComponentTemplates.CrystalNucleusPedestalItemPointTemplate = require("GameUI/TemplateUI/CrystalNucleus/CrystalNucleusPedestalItemPointTemplate")
  LuaComponentTemplates.CrystalNucleusPedestalAdvancedItemPointTemplate = require("GameUI/TemplateUI/CrystalNucleus/CrystalNucleusPedestalAdvancedItemPointTemplate")
  LuaComponentTemplates.PandoraActivityRewardShowTemplate = require("GameUI/TemplateUI/PandoraActivity/PandoraActivityRewardShowTemplate")
  LuaComponentTemplates.PandoraActivityMiningTemplate = require("GameUI/TemplateUI/PandoraActivity/PandoraActivityMiningTemplate")
  LuaComponentTemplates.PandoraActivityShopTemplate = require("GameUI/TemplateUI/PandoraActivity/PandoraActivityShopTemplate")
  LuaComponentTemplates.SpaceCrackActivityTemplate = require("GameUI/TemplateUI/SpaceCrack/SpaceCrackActivityTemplate")
  LuaComponentTemplates.EnchantEquipBagItemTemplate = require("GameUI/TemplateUI/EnchantEquip/EnchantEquipBagItemTemplate")
  LuaComponentTemplates.AnniversaryActivityPageTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityPageTemplate")
  LuaComponentTemplates.AnniversaryActivitySignInTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivitySignInTemplate")
  LuaComponentTemplates.AnniversaryActivityStoreTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityStoreTemplate")
  LuaComponentTemplates.AnniversaryActivityNpcTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityNpcTemplate")
  LuaComponentTemplates.AnniversaryActivityNpcDailyTaskTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityNpcDailyTaskTemplate")
  LuaComponentTemplates.AnniversaryActivityNpcActivityTaskTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityNpcActivityTaskTemplate")
  LuaComponentTemplates.AnniversaryActivityBattleOrderTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityBattleOrderTemplate")
  LuaComponentTemplates.AnniversaryActivityBattleOrderDailyTaskTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityBattleOrderDailyTaskTemplate")
  LuaComponentTemplates.AnniversaryActivityBattleOrderActivityTaskTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityBattleOrderActivityTaskTemplate")
  LuaComponentTemplates.AnniversaryActivityNewCharacterTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityNewCharacterTemplate")
  LuaComponentTemplates.AnniversaryActivityNewCharacterTaskTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityNewCharacterTaskTemplate")
  LuaComponentTemplates.AnniversaryActivityMonsterTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityMonsterTemplate")
  LuaComponentTemplates.AnniversaryActivityBattleOrderPanelTemplate = require("GameUI/TemplateUI/AnniversaryActivityTemplates/AnniversaryActivityBattleOrderPanelTemplate")
  LuaComponentTemplates.Go_itemTemplate = require("GameUI/TemplateUI/Activity_Task_EarlyGoldGameplayTemplates/Go_itemTemplate")
  LuaComponentTemplates.GoldenTicketTemplate = require("GameUI/TemplateUI/Activity_Task_EarlyGoldGameplayTemplates/GoldenTicketTemplate")
  LuaComponentTemplates.InviteReward_ItemTemplate = require("GameUI/TemplateUI/Activity_Task_EarlyGoldGameplayTemplates/InviteReward_ItemTemplate")
  LuaComponentTemplates.img_daTaranKBgTemplate = require("GameUI/TemplateUI/Activity_Task_EarlyGoldGameplayTemplates/img_daTaranKBgTemplate")
  LuaComponentTemplates.GoodReviewRewardTemplate = require("GameUI/TemplateUI/Activity_OtherWelfareTemplates/GoodReviewRewardTemplate")
  LuaComponentTemplates.panel_SiFangCrossTemplate = require("GameUI/TemplateUI/SiFangCrossTemplates/panel_SiFangCrossTemplate")
end

return LuaTemplateManager
