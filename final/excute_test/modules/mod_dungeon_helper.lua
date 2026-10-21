-- =========================================================================
-- [MODULE]: mod_dungeon_helper.lua
-- Mục đích: Nhận diện, kiểm tra vé/lượt, bỏ qua 30s chờ & điều phối Auto Phó Bản (HL & QTQ)
-- Tham chiếu code gốc:
--   - TranScriptData.lua, RefreshData.lua, networkRequest.lua
--   - EmmyluaDebug.lua lines 9670-9940 (AutoDungeonMonitorStep)
-- =========================================================================

local ModDungeonHelper = {}

--- Kiểm tra nhân vật có đang ở trong Huyết Lâu (Blood Castle) không
-- @return boolean, number: inBC, mapId
function ModDungeonHelper.IsInBloodCastle()
    local cMap = (_G.SceneData and (_G.SceneData.mapId or _G.SceneData.groupId)) or 0
    local inBC = (cMap >= 1012000 and cMap <= 1012099)
    return inBC, cMap
end

--- Kiểm tra nhân vật có đang ở trong Quảng Trường Quỷ (Demon Plaza) không
-- @return boolean, number: inDS, mapId
function ModDungeonHelper.IsInDemonPlaza()
    local cMap = (_G.SceneData and (_G.SceneData.mapId or _G.SceneData.groupId)) or 0
    local inDS = (cMap >= 1010000 and cMap <= 1010099)
    return inDS, cMap
end

--- Kiểm tra nhân vật có đang trong bất kỳ phó bản mục tiêu nào (HL hoặc QTQ)
-- @return boolean, string: isIn, dungeonType ("BloodCastle" | "DemonPlaza" | "None")
function ModDungeonHelper.IsInTargetDungeon()
    local inBC = ModDungeonHelper.IsInBloodCastle()
    if inBC then return true, "BloodCastle" end
    local inDS = ModDungeonHelper.IsInDemonPlaza()
    if inDS then return true, "DemonPlaza" end
    return false, "None"
end

--- Bấm nút [Mở Ngay] (ReqSkipWait) bỏ qua 30 giây chờ đợi khi mới vào phó bản
-- @return boolean: true nếu đã gửi lệnh
function ModDungeonHelper.TriggerSkipWait()
    local sent = false
    if _G.networkRequest and _G.networkRequest.ReqSkipWait then
        pcall(function()
            _G.networkRequest.ReqSkipWait()
            sent = true
        end)
    end
    if not sent and _G.NetManager and _G.NetManager.Send and _G.TranScriptMessage and _G.TranScriptMessage.ReqSkipWait then
        pcall(function()
            _G.NetManager.Send(_G.TranScriptMessage.ReqSkipWait, {})
            sent = true
        end)
    end
    return sent
end

--- Tắt các bảng popup phó bản cản trở tầm nhìn của người chơi
function ModDungeonHelper.DismissDungeonPopups()
    if not _G.UIManager then return end
    pcall(function()
        if _G.UIID then
            if _G.UIID.Instance_BloodCastleUI then _G.UIManager.Hide(_G.UIID.Instance_BloodCastleUI) end
            if _G.UIID.Instance_DemonPlazaUI then _G.UIManager.Hide(_G.UIID.Instance_DemonPlazaUI) end
            if _G.UIID.PromptTipUI then _G.UIManager.Hide(_G.UIID.PromptTipUI) end
        end
    end)
end

--- Kiểm tra điều kiện vào phó bản (Số lượt còn lại, ID vé, số vé hiện có trong túi)
-- @param dungeonType string: "BloodCastle" hoặc "DemonPlaza"
-- @param curLvl number|nil: Cấp độ người chơi (tự lấy nếu nil)
-- @return table: { canEnter = bool, leftCount = number, ticketId = number, haveTicket = number, needTicket = number, targetMapId = number }
function ModDungeonHelper.CheckDungeonEligibility(dungeonType, curLvl)
    if not curLvl then
        local pMe = _G.RoleManager and _G.RoleManager.me
        curLvl = tonumber((_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.level) or (pMe and pMe.level) or 1)
    end

    local cfg = nil
    if dungeonType == "BloodCastle" then
        cfg = {
            name = "Huyết Lâu",
            subType = 2203,
            condId = 100414,
            maxNumId = 100404,
            globalCountId = 60000001
        }
    else
        cfg = {
            name = "Quảng Trường Quỷ",
            subType = 2204,
            condId = 100408,
            maxNumId = 100702,
            globalCountId = 60000002
        }
    end

    local enterData = nil
    pcall(function()
        if _G.TranScriptData and _G.TranScriptData.GetEnterConditionData then
            enterData = _G.TranScriptData.GetEnterConditionData(cfg.subType, cfg.condId, cfg.maxNumId, curLvl)
        end
    end)

    local targetMapId = enterData and enterData.id or 0
    local leftCount = 0
    pcall(function()
        local gTbl = _G.ClientTable and _G.ClientTable.cfg_Global_globalManager and _G.ClientTable.cfg_Global_globalManager:TryGetValue(cfg.globalCountId)
        if gTbl and gTbl.effect and _G.RefreshData and _G.RefreshData.GetInstanceCount then
            leftCount = _G.RefreshData.GetInstanceCount(tonumber(gTbl.effect)) or 0
        end
    end)

    local ticketId = 0
    local needTicket = 1
    if enterData and enterData.cost then
        local cParts = string.split(enterData.cost, "#")
        ticketId = tonumber(cParts[1]) or 0
        needTicket = tonumber(cParts[2]) or 1
    end

    local haveTicket = 0
    pcall(function()
        if ticketId > 0 and _G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId then
            haveTicket = _G.BagInfoData.GetItemTotalCountByItemId(ticketId) or 0
        end
    end)

    local canEnter = (targetMapId > 0) and (leftCount > 0) and (haveTicket >= needTicket)

    return {
        canEnter = canEnter,
        targetMapId = targetMapId,
        leftCount = leftCount,
        ticketId = ticketId,
        haveTicket = haveTicket,
        needTicket = needTicket
    }
end

--- Kiểm tra lịch trình phó bản hiện tại theo giờ
-- Quy tắc chuẩn:
--   - Giờ lẻ (1h, 3h, 5h, 7h...): Huyết Lâu (Blood Castle)
--   - Giờ chẵn (0h, 2h, 4h, 6h...): Quảng Trường Quỷ (Demon Plaza)
--   - Phút 00 -> 14: Cửa phó bản đang mở tiếp nhận người chơi
-- @return table: { isDungeonTime = bool, scheduledDungeon = "BloodCastle" | "DemonPlaza", curHour = number, curMinute = number }
function ModDungeonHelper.GetDungeonSchedule()
    local curHour = tonumber(os.date("%H")) or 0
    local curMinute = tonumber(os.date("%M")) or 0

    local isDungeonTime = (curMinute < 15)
    local scheduled = (curHour % 2 == 1) and "BloodCastle" or "DemonPlaza"

    return {
        isDungeonTime = isDungeonTime,
        scheduledDungeon = scheduled,
        curHour = curHour,
        curMinute = curMinute
    }
end

return ModDungeonHelper
