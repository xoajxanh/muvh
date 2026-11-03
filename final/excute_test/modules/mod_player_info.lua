-- =========================================================================
-- [MODULE]: mod_player_info.lua
-- Mục đích: Đọc đầy đủ thông tin người chơi (Role / Player / Guild / Position)
-- Tham chiếu code gốc:
--   - RoleManager.lua, Me.lua, ViewData.lua, WarAllianceData.lua
--   - EmmyluaDebug.lua lines 640-690, 1660-1670, 2180-2195, 6770-6775
-- =========================================================================

local ModPlayerInfo = {}

--- Lấy object Me hiện tại
function ModPlayerInfo.GetMe()
    return _G.RoleManager and _G.RoleManager.me
end

--- Lấy dữ liệu cơ bản nhân vật (ID, Tên, Cấp độ, Lực chiến)
function ModPlayerInfo.GetBasicInfo()
    local me = ModPlayerInfo.GetMe()
    local meData = _G.ViewData and _G.ViewData.meData

    local id = (me and me.id) or (meData and meData.id) or 0
    local name = (me and me.name) or (meData and meData.name) or "Unknown"
    local level = tonumber((meData and meData.level) or (me and me.level) or 1)
    local masterLevel = tonumber((meData and meData.masterLevel) or (me and me.masterLevel) or 0)
    local fight = tonumber((meData and meData.fight) or 0)
    local career = (me and me.career) or (meData and meData.career) or 0

    local careerName = "Unknown"
    if _G.RoleUtility and _G.RoleUtility.GetCareerName then
        pcall(function() careerName = _G.RoleUtility.GetCareerName(career) end)
    end

    local basicCareer = 0
    if _G.RoleUtility and _G.RoleUtility.GetBasicCareer then
        pcall(function() basicCareer = _G.RoleUtility.GetBasicCareer(career) end)
    end

    return {
        id = id,
        name = name,
        level = level,
        masterLevel = masterLevel,
        fight = fight,
        career = career,
        careerName = careerName,
        basicCareer = basicCareer,
        isDead = (me and me.isDead) or false
    }
end

--- Lấy thông tin máu & mana hiện tại
function ModPlayerInfo.GetHpMp()
    local me = ModPlayerInfo.GetMe()
    if not me then return { hp = 0, maxHp = 1, mp = 0, maxMp = 1, hpPercent = 0, mpPercent = 0 } end

    local hp = tonumber(me.hp) or 0
    local maxHp = tonumber(me.maxHp) or 1
    local mp = tonumber(me.mp) or 0
    local maxMp = tonumber(me.maxMp) or 1

    return {
        hp = hp,
        maxHp = maxHp,
        mp = mp,
        maxMp = maxMp,
        hpPercent = (hp / maxHp) * 100,
        mpPercent = (mp / maxMp) * 100
    }
end

--- Lấy tọa độ nhân vật (Ưu tiên: ServerCoord -> CellPos -> Position 3D)
function ModPlayerInfo.GetPosition()
    local me = ModPlayerInfo.GetMe()
    if not me then return { x = 0, y = 0, z = 0, cellX = 0, cellY = 0 } end

    local sX = (me.serverCoord and me.serverCoord.x) or (me.cellPos and me.cellPos.x) or 0
    local sY = (me.serverCoord and me.serverCoord.y) or (me.cellPos and me.cellPos.y) or 0
    local cX = (me.cellPos and me.cellPos.x) or sX
    local cY = (me.cellPos and me.cellPos.y) or sY
    local pX = (me.Position and me.Position.x) or cX
    local pY = (me.Position and me.Position.y) or cY
    local pZ = (me.Position and me.Position.z) or 0

    return {
        serverX = sX,
        serverY = sY,
        cellX = cX,
        cellY = cY,
        worldX = pX,
        worldY = pY,
        worldZ = pZ
    }
end

--- Lấy thông tin bản đồ hiện tại (MapId, MapName, GroupId)
function ModPlayerInfo.GetCurrentMap()
    local mapId = (_G.SceneData and (_G.SceneData.mapId or _G.SceneData.groupId)) or 0
    local groupId = (_G.SceneData and _G.SceneData.groupId) or mapId
    local mapName = "Unknown Map"

    if mapId > 0 and _G.ClientTable and _G.ClientTable.cfg_Map_mapManager then
        pcall(function()
            local mapTbl = _G.ClientTable.cfg_Map_mapManager:TryGetValue(mapId, "id")
            if mapTbl and mapTbl.name then
                mapName = mapTbl.name
            end
        end)
    end

    return {
        mapId = mapId,
        groupId = groupId,
        mapName = mapName
    }
end

--- Lấy thông tin bang hội (Guild / WarAlliance)
function ModPlayerInfo.GetGuildInfo()
    local hasGuild = (_G.WarAllianceData and _G.WarAllianceData.IsHaveUnion) or false
    local guildData = (_G.WarAllianceData and _G.WarAllianceData.MyWarAllianceData) or {}

    local guildId = guildData.id or 0
    local guildName = guildData.name or (hasGuild and "Có bang" or "Chưa vào bang")
    local isLeader = false
    if _G.WarAllianceData and _G.WarAllianceData.IsLeader then
        pcall(function() isLeader = _G.WarAllianceData.IsLeader() end)
    end

    return {
        hasGuild = hasGuild,
        guildId = guildId,
        guildName = guildName,
        isLeader = isLeader
    }
end

--- Kiểm tra một nhân vật khác có cùng bang với mình không
function ModPlayerInfo.IsSameGuild(targetRoleId)
    if not targetRoleId then return false end
    if _G.WarAllianceData and _G.WarAllianceData.GetIsSameUnion then
        local isSame = false
        pcall(function() isSame = _G.WarAllianceData.GetIsSameUnion(targetRoleId) end)
        return isSame
    end
    return false
end

--- Lấy chế độ PK hiện tại (0: Hòa bình, 1: Toàn thể, 2: Tổ đội, 3: Bang...)
function ModPlayerInfo.GetPKMode()
    local me = ModPlayerInfo.GetMe()
    return (me and me.PKMode) or 0
end

--- Quét danh sách người chơi khác xung quanh tọa độ (refX, refY) trong bán kính ô gạch maxTileRadius (Chebyshev)
--- Tham chiếu: Auto PK / Auto Buff trong modified_lua_dev_client\EmmyluaDebug.lua (RoleManager.GetRolesByType(1))
function ModPlayerInfo.GetNearbyPlayers(maxTileRadius, refX, refY)
    maxTileRadius = tonumber(maxTileRadius) or 12
    local me = ModPlayerInfo.GetMe()
    local meId = (me and me.data and me.data.id) or (me and me.id) or 0
    local myPos = ModPlayerInfo.GetPosition()
    local centerX = tonumber(refX) or myPos.serverX or myPos.cellX or 0
    local centerY = tonumber(refY) or myPos.serverY or myPos.cellY or 0

    local results = {}
    local allPlayers = _G.RoleManager and _G.RoleManager.GetRolesByType and _G.RoleManager.GetRolesByType(1)
    if not allPlayers then return results end

    for _, p in pairs(allPlayers) do
        if p and not p.isDead and (not p.hp or p.hp > 0) then
            local pId = (p.data and p.data.id) or p.id or 0
            if pId ~= 0 and pId ~= meId then
                local pCell = p.serverCoord or (p.cellPos and { x = p.cellPos.x, y = p.cellPos.y })
                if pCell and pCell.x and pCell.y then
                    local px = tonumber(pCell.x) or 0
                    local py = tonumber(pCell.y) or 0
                    local dist = math.max(math.abs(px - centerX), math.abs(py - centerY))
                    if dist <= maxTileRadius then
                        table.insert(results, {
                            role = p,
                            id = pId,
                            name = (p.data and p.data.name) or p.name or tostring(pId),
                            x = px,
                            y = py,
                            dist = dist
                        })
                    end
                end
            end
        end
    end

    if #results > 1 then
        table.sort(results, function(a, b) return a.dist < b.dist end)
    end
    return results
end

--- Kiểm tra nhanh có người chơi khác đứng trong phạm vi <= maxTileRadius (mặc định 2 ô) quanh tọa độ (spotX, spotY) không
function ModPlayerInfo.HasOtherPlayerNearSpot(spotX, spotY, maxTileRadius)
    local list = ModPlayerInfo.GetNearbyPlayers(maxTileRadius or 2, spotX, spotY)
    if #list > 0 then
        return true, list[1].name, list[1].dist, list[1]
    end
    return false, nil, nil, nil
end

--- Lấy số lượng Kim Cương Khóa (ID 1000050 / bindDiamond), tuyệt đối không cộng gộp KC không khóa (1000040)
function ModPlayerInfo.GetBoundDiamonds()
    local curDiamonds = 0
    pcall(function()
        if _G.BagInfoData and _G.BagInfoData.CoinInfos and _G.BagInfoData.CoinInfos[1000050] ~= nil then
            curDiamonds = tonumber(_G.BagInfoData.CoinInfos[1000050]) or 0
        end
        if curDiamonds <= 0 and _G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId then
            curDiamonds = tonumber(_G.BagInfoData.GetItemTotalCountByItemId(1000050)) or 0
        end
        if curDiamonds <= 0 and _G.ViewData and _G.ViewData.meData and _G.ViewData.meData.GetAttribute then
            curDiamonds = tonumber(_G.EAttributeType and _G.ViewData.meData:GetAttribute(_G.EAttributeType.bindDiamond)) or 0
        end
        if curDiamonds <= 0 and _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.data then
            curDiamonds = tonumber(_G.RoleManager.me.data.diamond_bind) or 0
        end
    end)
    return curDiamonds
end

--- Tự động cộng điểm tiềm năng theo mốc Level:
--- + Trước Lv 120 (curLvl < 120): Tỷ lệ 7/3 (70% Trí Lực - energy, 30% Nhanh Nhẹn - agility)
--- + Từ Lv 120 trở đi (curLvl >= 120): Tỷ lệ 50/50 (50% Trí Lực - energy, 50% Nhanh Nhẹn - agility)
function ModPlayerInfo.AllocateAttributePointsByLevel()
    local added = 0
    pcall(function()
        local viewAttr = (_G.QuickFind and _G.QuickFind.LuaMainPlayerViewAttrData and _G.QuickFind.LuaMainPlayerViewAttrData())
        local validPoints = (viewAttr and viewAttr.validAttributePoint) or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.validAttributePoint) or 0
        if validPoints > 0 and _G.EAttributeType then
            local basic = ModPlayerInfo.GetBasicInfo()
            local curLvl = tonumber(basic and basic.level) or 1
            local agiRatio = (curLvl < 120) and 0.3 or 0.5
            local agiPts = math.floor(validPoints * agiRatio)
            local enePts = validPoints - agiPts
            local attrMap = {}
            if agiPts > 0 then attrMap[_G.EAttributeType.agility] = agiPts end
            if enePts > 0 then attrMap[_G.EAttributeType.energy] = enePts end
            if _G.MeController and _G.MeController.ReqAttributeModify then
                _G.MeController.ReqAttributeModify(attrMap)
            elseif _G.NetManager and _G.NetManager.Send and _G.RoleMessage and _G.RoleMessage.ReqAttributeModify then
                local req = {}
                for k, v in pairs(attrMap) do
                    table.insert(req, { choose = k, num = v })
                end
                _G.NetManager.Send(_G.RoleMessage.ReqAttributeModify, { modify = req })
            end
            added = validPoints
        end
    end)
    return added
end
ModPlayerInfo.AllocateAttributePoints5050 = ModPlayerInfo.AllocateAttributePointsByLevel

return ModPlayerInfo
