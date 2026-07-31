require("GameConst/ActivityEnum")
require("Utility/ActivityUtility")
require("GamePlay/ActivityManager/Activity_SiegeManager")
require("GamePlay/ActivityManager/Activity_DragonAttackManager")
require("GamePlay/ActivityManager/Activity_RedFortManager")
require("GamePlay/ActivityManager/ActivityNoticeManager")
ActivityManager = {}
local this = ActivityManager

function ActivityManager.OnEnterGame()
  Activity_SiegeManager.OnEnterGame()
  Activity_DragonAttackManager.OnEnterGame()
  Activity_RedFortManager.OnEnterGame()
  ActivityNoticeManager.OnEnterGame()
end

function ActivityManager.OnLeaveGame()
  Activity_SiegeManager.OnLeaveGame()
  Activity_DragonAttackManager.OnLeaveGame()
  Activity_RedFortManager.OnLeaveGame()
  ActivityNoticeManager.OnLeaveGame()
end

function ActivityManager.UnRegistAll()
  Activity_SiegeManager.UnRegistAll()
  Activity_DragonAttackManager.UnRegistAll()
  ActivityNoticeManager.UnRegistAll()
  Activity_RedFortManager.UnRegistAll()
end

function ActivityManager.Update()
  Activity_SiegeManager.Update()
  Activity_DragonAttackManager.Update()
  ActivityNoticeManager.Update()
end
