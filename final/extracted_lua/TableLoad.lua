local TableLoad = {}
ClientTable = {}
TableParse = require("Config/table/TableParse")
TableManagerBase = require("Config/table/TableManager")
registerAllClientTable = require("Config/table/registerAllClientTable")
registerAllClientTable.RequireTableManager()

function TableLoad:Init()
end

return TableLoad
