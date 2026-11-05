-- =========================================================================
-- [MODULE]: mod_teleport_townscroll.lua
-- Mục đích: Sử dụng Bùa Về Thành (20000021), Đá Truyền Tống (20000022) & Dịch chuyển Map
-- Tham chiếu code gốc:
--   - EmmyluaDebug.lua lines 4182-4205 (Mod_UseTownPortalScroll)
--   - EmmyluaDebug.lua lines 19030-19065 (Mod_UseTransferStone)
--   - ItemUtility.lua lines 1508-1514 (Quy tắc kiểm tra map flyScroll)
--   - PathFinderManager.lua, MapMessage.lua
-- =========================================================================

local ModTeleport = {}

--- Sử dụng Bùa Về Thành Lorencia (ConfigId: 20000021)
-- Nếu trong túi không có bùa -> Tự động fallback dùng packet ReqCallFlag để về Lorencia (mapId 1001)
-- @return boolean: true nếu đã thực hiện lệnh
function ModTeleport.UseTownPortalScroll()
    local foundScroll = false

    -- 1. Tìm bùa về thành 20000021 trong túi đồ
    local items = _G.BagInfoData and _G.BagInfoData.TotalItems
    if items then
        for _, itemData in pairs(items) do
            if itemData then
                local cId = itemData.itemId or (itemData.data and itemData.data.itemId)
                local instanceId = itemData.id or (itemData.data and itemData.data.id)
                if cId == 20000021 and instanceId then
                    if _G.networkRequest and _G.networkRequest.ReqUseItem then
                        pcall(function() _G.networkRequest.ReqUseItem(1, instanceId) end)
                        foundScroll = true
                    elseif _G.BagInfoController and _G.BagInfoController.UseItemReq then
                        pcall(function() _G.BagInfoController.UseItemReq(1, instanceId, nil, 20000021) end)
                        foundScroll = true
                    elseif _G.NetManager and _G.NetManager.Send and _G.ItemMessage and _G.ItemMessage.ReqUseItem then
                        pcall(function() _G.NetManager.Send(_G.ItemMessage.ReqUseItem, { id = instanceId, count = 1 }) end)
                        foundScroll = true
                    end
                    break
                end
            end
        end
    end

    -- 2. Fallback nếu túi không có bùa: Dùng gói mạng gọi cờ về thành an toàn
    if not foundScroll then
        if _G.NetManager and _G.MapMessage and _G.MapMessage.ReqCallFlag then
            pcall(function()
                _G.NetManager.Send(_G.MapMessage.ReqCallFlag, { mapId = 1001, line = 1, x = 54, y = 63 })
                foundScroll = true
            end)
        end
    end

    return foundScroll
end

--- Sử dụng Đá Truyền Tống Ngẫu Nhiên (ConfigId: 20000022 - Phù bay ngẫu nhiên)
-- @return boolean: true nếu đã sử dụng thành công
function ModTeleport.UseRandomTransferStone()
    -- 1. Kiểm tra bản đồ hiện tại có cấm dùng phù ngẫu nhiên không (flyScroll ~= 0)
    local curMap = (_G.SceneData and (_G.SceneData.mapId or _G.SceneData.groupId)) or 0
    if curMap > 0 and _G.ClientTable and _G.ClientTable.cfg_Map_mapManager then
        local mapTab = nil
        pcall(function() mapTab = _G.ClientTable.cfg_Map_mapManager:TryGetValue(curMap, "id") end)
        if mapTab and mapTab.flyScroll and mapTab.flyScroll ~= 0 then
            -- Bản đồ cấm dùng phù ngẫu nhiên
            return false
        end
    end

    -- 2. Tìm đá truyền tống trong túi đồ
    local stoneBagId = nil
    local items = _G.BagInfoData and _G.BagInfoData.TotalItems
    if not items and _G.BagInfoData and _G.BagInfoData.GetTotalItems then
        pcall(function() items = _G.BagInfoData:GetTotalItems() end)
    end
    if items then
        for _, itemData in pairs(items) do
            if itemData then
                local cId = itemData.itemId or (itemData.data and itemData.data.itemId)
                local instanceId = itemData.id or (itemData.data and itemData.data.id)
                if cId == 20000022 and instanceId then
                    stoneBagId = instanceId
                    break
                end
            end
        end
    end

    -- 3. Gọi lệnh dùng đá
    if stoneBagId then
        local used = false
        if _G.BagInfoController and _G.BagInfoController.UseItemReq then
            pcall(function()
                _G.BagInfoController.UseItemReq(1, stoneBagId, nil, 20000022)
                used = true
            end)
        end
        if not used and _G.networkRequest and _G.networkRequest.ReqUseItem then
            pcall(function()
                _G.networkRequest.ReqUseItem(1, stoneBagId)
                used = true
            end)
        end
        return used
    end

    return false
end

--- Dịch chuyển nhanh tới bản đồ chỉ định (Fly Transfer Scene)
-- @param mapId number: ID bản đồ đích (ví dụ 1001: Lorencia, 1002: Devias, 1003: Noria...)
-- @param targetPos table|nil: Tọa độ đích { x = number, y = number }
function ModTeleport.FlyToMap(mapId, targetPos)
    if not mapId or mapId <= 0 then return false end

    -- Cách 1: PathFinderManager.FlyTransferScene (Chuẩn nhất của client)
    if _G.PathFinderManager and _G.PathFinderManager.FlyTransferScene then
        local ok = pcall(function()
            _G.PathFinderManager.FlyTransferScene(mapId, targetPos)
        end)
        if ok then return true end
    end

    -- Cách 2: Dispatch Event Map_ChangeMap
    if _G.EventManager and _G.Event and _G.Event.Map_ChangeMap then
        local ok = pcall(function()
            _G.EventManager.Dispatch(_G.Event.Map_ChangeMap, { mapId = mapId })
        end)
        if ok then return true end
    end

    return false
end

--- Lấy số Kênh (Tuyến 1..3) hiện tại của nhân vật chuẩn xác từ SceneData.cline
function ModTeleport.GetCurrentMapLine()
    if _G.SceneData then
        local cl = tonumber(_G.SceneData.cline)
        if cl and cl > 0 then return cl end
        local ln = tonumber(_G.SceneData.line or _G.SceneData.lineIndex)
        if ln and ln > 0 then return ln end
    end
    return 1
end

--- Dịch chuyển chính xác tới Bản đồ + Kênh (Line 1..3) + Tọa độ (x, y) bằng ReqCallFlag
-- Nếu đang cùng map nhưng khác kênh (line), tự động gửi thêm ReqTransferTransmit(transferId, lineId, true)
-- và cập nhật mỏ neo QiJiHelperData.meCellPos để AutoFight không kéo nhân vật chạy ngược về bãi cũ.
-- @param mapId number: ID bản đồ (ví dụ 1008: Atlantis, 1009: Tarkan)
-- @param lineId number: Kênh đích (1, 2, 3...)
-- @param x number: Tọa độ X tâm bãi quái (từ cfg_Map_minimap.lua)
-- @param y number: Tọa độ Y tâm bãi quái (từ cfg_Map_minimap.lua)
function ModTeleport.TeleportToSpotWithLine(mapId, lineId, x, y)
    mapId = tonumber(mapId) or 0
    local curLine = ModTeleport.GetCurrentMapLine()
    lineId = tonumber(lineId) or curLine or 1
    local sx = math.floor(tonumber(x) or 0)
    local sy = math.floor(tonumber(y) or 0)
    if mapId <= 0 or sx <= 0 or sy <= 0 then return false end

    local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0

    pcall(function()
        local me = _G.RoleManager and _G.RoleManager.me
        if me then
            if me.StopMove then me:StopMove() end
            me.TargetAvatar = nil
        end
        if _G.QiJiHelperData and CS and CS.UnityEngine and CS.UnityEngine.Vector2Int then
            _G.QiJiHelperData.meCellPos = CS.UnityEngine.Vector2Int(sx, sy)
        end

        if curMap == mapId and curLine ~= lineId then
            local groupId = (_G.SceneData and _G.SceneData.groupId) or mapId
            local transferId = _G.PathFinderManager and _G.PathFinderManager.GetTransIdByGroupId and _G.PathFinderManager.GetTransIdByGroupId(groupId)
            if transferId and _G.networkRequest and _G.networkRequest.ReqTransferTransmit then
                _G.networkRequest.ReqTransferTransmit(transferId, lineId, true)
            end
        end

        if _G.networkRequest and _G.networkRequest.ReqCallFlag then
            _G.networkRequest.ReqCallFlag(1, 0, mapId, lineId, sx, sy, 0)
        elseif _G.NetManager and _G.MapMessage and _G.MapMessage.ReqCallFlag then
            _G.NetManager.Send(_G.MapMessage.ReqCallFlag, {
                type = 1,
                rid = 0,
                mapId = mapId,
                line = lineId,
                x = sx,
                y = sy,
                hostId = 0
            })
        end
    end)
    return true
end

return ModTeleport
