local RedPointLoader = {}
require("GamePlay/RedPoint/RedPointEnum")
RedPointManager = require("GamePlay/RedPoint/Base/RedPointManager")
RedPointDataManager = require("GamePlay/RedPoint/Base/RedPointDataManager")
RedPointGoManager = require("GamePlay/RedPoint/Base/RedPointGoManager")
RedPointChecker = require("GamePlay/RedPoint/RedPointChecker")
RedPointChecker_Ext = require("GamePlay/RedPoint/Ext/RedPointChecker_Ext")

function RedPointLoader:Initialize()
  RedPointManager:Initialize()
  RedPointGoManager:Initialize()
  RedPointDataManager:Initialize()
  RedPointChecker_Ext:Initialize()
end

return RedPointLoader
