local FirecrackerTreasureHuntingTemplate = {}

function FirecrackerTreasureHuntingTemplate:Init(root)
  self:InitControls(root)
  self:InitUI()
end

function FirecrackerTreasureHuntingTemplate:InitControls(root)
  self.root = root
  self.cumulativeRewardScrollView = self:GetControl("go_Treasure/sw_Treasure")
  self.descBtnBaoZhuTreasure = self:GetControl("descBtnBaoZhuTreasure")
  self.cumulativeRewardScrollViewItemParent = self:GetControl("go_Treasure/sw_Treasure/Viewport/Content/progressGroup/pro_Treasure")
  self.lab_materialCount = self:GetControl("bg/lab_holidayBaoZhu")
  self.txt_BaoZhuTreasure_lastTime = self:GetControl("lab_Time/txt_BaoZhuTreasure_lastTime")
  self.drawRewardScrollView = self:GetControl("sw_TreasureReward")
  self.drawRewardScrollViewItemParent = self:GetControl("sw_TreasureReward/Viewport/Content/Reward")
  self.go_mission = self:GetControl("sw_Mission/Viewport/grid_mission/go_mission")
end

function FirecrackerTreasureHuntingTemplate:InitUI()
  self.cumulativeRewardsContainer = UIUtility.BindUIContainerTemp(self.cumulativeRewardScrollViewItemParent, LuaComponentTemplates.FTHCumulativeRewardsTemplate, self.root)
  self.drawRewardsContainer = UIUtility.BindUIContainerTemp(self.drawRewardScrollViewItemParent, LuaComponentTemplates.FTHDrawRewardsTemplate, self.root)
  self.getCostMaterialWayContainer = UIContainer(self.go_mission, self, self.OnGoMissionCreate, self.OnGoMissionRefresh)
end

function FirecrackerTreasureHuntingTemplate.OnGoMissionCreate(ctr)
  ctr.lab_mission = UIControl(ctr.transform, "lab_mission")
  ctr.lab_num = UIControl(ctr.transform, "lab_num")
  ctr.lab_finish = UIControl(ctr.transform, "lab_finish")
  ctr.lab_unfinish = UIControl(ctr.transform, "lab_unfinish")
  ctr.btn_go = UIControl(ctr.transform, "btn_go")
  ctr.lab_go = UIControl(ctr.transform, "btn_go/lab_go")
end

function FirecrackerTreasureHuntingTemplate.OnGoMissionRefresh(ctr, _, data, ui)
  if data == nil or next(data) == nil then
    return
  end
  ctr.lab_mission:SetText(data.des)
  ctr.lab_num:SetText(data.num)
  ctr.lab_go:SetText(data.btnDes)
  ctr.btn_go:SetOnClick(ui, data.callBack)
end

function FirecrackerTreasureHuntingTemplate:btn_gotoOnClick()
  UIManager.Hide(UIID.Commercial_HolidayActivityUI)
  UIManager.Show(UIID.Instance_BossUI)
end

function FirecrackerTreasureHuntingTemplate:btn_goRechargeOnClick()
  UIManager.Hide(UIID.Commercial_HolidayActivityUI)
  RechargeData.BuyDiamond()
end

function FirecrackerTreasureHuntingTemplate:Refresh()
  self:RefreshTopView()
  self:RefreshCenterView()
  self:RefreshDownView()
  self.descBtnBaoZhuTreasure:SetOnClick(self, self.descBtnBaoZhuTreasureOnClick)
end

function FirecrackerTreasureHuntingTemplate:descBtnBaoZhuTreasureOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1118})
end

function FirecrackerTreasureHuntingTemplate:RefreshTopView()
  self:RefreshCumulativeRewards()
  self:RefreshCostMaterialCount()
  self:RefreshSurplusTime()
end

function FirecrackerTreasureHuntingTemplate:RefreshCumulativeRewards()
  self.cumulativeRewardsContainer:SetData(QuickFind:GetFirecrackerTreasureHuntingDataMgr():GetCumulativeRewardsWithState())
end

function FirecrackerTreasureHuntingTemplate:RefreshCostMaterialCount()
  self.lab_materialCount:SetText(QuickFind:GetFirecrackerTreasureHuntingDataMgr():GetCostMaterialItemCount())
end

function FirecrackerTreasureHuntingTemplate:RefreshSurplusTime()
  if self.remainTimeLoop then
    Timer.Stop(self.remainTimeLoop)
    self.remainTimeLoop = nil
  end
  self.txt_BaoZhuTreasure_lastTime:SetText(QuickFind:GetFirecrackerTreasureHuntingDataMgr():GetRemainTimeDes())
  self.remainTimeLoop = Timer.StartLoopForever(1, function()
    self.txt_BaoZhuTreasure_lastTime:SetText(QuickFind:GetFirecrackerTreasureHuntingDataMgr():GetRemainTimeDes())
  end)
end

function FirecrackerTreasureHuntingTemplate:RefreshCenterView()
  self:RefreshDrawableRewards()
end

function FirecrackerTreasureHuntingTemplate:RefreshDrawableRewards()
  self.drawRewardsContainer:SetData(QuickFind:GetFirecrackerTreasureHuntingDataMgr():GetDrawableRewardsWithState())
end

function FirecrackerTreasureHuntingTemplate:RefreshDownView()
  self:RefreshGetMaterialWay()
end

function FirecrackerTreasureHuntingTemplate:RefreshGetMaterialWay()
  local getWayData = {
    {
      des = "X\195\161c su\225\186\165t nh\225\186\173n Ph\195\161o Hoa khi \196\145\195\161nh b\225\186\161i BOSS ",
      num = string.format("Gi\225\187\155i h\225\186\161n h\195\180m nay (%d/%d)", QuickFind:GetFirecrackerTreasureHuntingDataMgr():GetTodayGetCountByBoss(), ClientTable.cfg_Commerce_globalManager:GetEveryDayLimitFirecrackerCountByBoss()),
      btnDes = "\196\144\225\186\191n ngay",
      callBack = self.btn_gotoOnClick
    },
    {
      des = string.format("M\225\187\151i t\195\173ch n\225\186\161p %d, s\225\186\189 nh\225\186\173n \196\145\198\176\225\187\163c %d Ph\195\161o", ClientTable.cfg_Commerce_globalManager:GetExchangeRateForFirecracker()),
      num = string.format("Gi\225\187\155i h\225\186\161n h\195\180m nay (%d/%d)", QuickFind:GetFirecrackerTreasureHuntingDataMgr():GetTodayGetCountByRecharge(), ClientTable.cfg_Commerce_globalManager:GetEveryDayLimitFirecrackerCountByRecharge()),
      btnDes = "N\225\186\161p",
      callBack = self.btn_goRechargeOnClick
    }
  }
  self.getCostMaterialWayContainer:SetData(getWayData)
end

function FirecrackerTreasureHuntingTemplate:OnHide()
  self.cumulativeRewardScrollView:SetNormalizedPosition(0, 1)
  self.drawRewardScrollView:SetNormalizedPosition(0, 1)
  if self.remainTimeLoop then
    Timer.Stop(self.remainTimeLoop)
    self.remainTimeLoop = nil
  end
  for i, v in pairs(self.drawRewardsContainer.items) do
    if v.itemTemp then
      v.itemTemp:OnHide()
    end
  end
end

return FirecrackerTreasureHuntingTemplate
