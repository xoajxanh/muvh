-- =========================================================================
-- [MODULE]: mod_movement_combat.lua
-- Mục đích: Điều khiển Di Chuyển (MoveTo), Dừng Đánh Khi Chạy & Bật/Tắt AutoFight
-- Tham chiếu code gốc:
--   - Me.lua (lines 138-142: StopAutoFight), MeAutoFight.lua, MeMoveContext.lua
--   - Event.lua (Role_StopAutoFight)
--   - EmmyluaDebug.lua lines 2191-2192, 9775-9795
-- =========================================================================

local ModMovementCombat = {}

--- Tính khoảng cách Euclid 2D giữa 2 điểm
-- @param x1 number, y1 number, x2 number, y2 number
-- @return number: Khoảng cách
function ModMovementCombat.GetDistance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end

--- Lấy tọa độ hiện tại của Me (serverCoord hoặc cellPos)
-- @return number, number: curX, curY
function ModMovementCombat.GetMeCoord()
    local me = _G.RoleManager and _G.RoleManager.me
    if not me then return 0, 0 end
    local cx = (me.serverCoord and me.serverCoord.x) or (me.cellPos and me.cellPos.x) or (me.Position and me.Position.x) or 0
    local cy = (me.serverCoord and me.serverCoord.y) or (me.cellPos and me.cellPos.y) or (me.Position and me.Position.y) or 0
    return cx, cy
end

--- Dừng tuyệt đối chế độ AutoFight và hủy khóa mục tiêu quái
-- CỰC KỲ QUAN TRỌNG: Khi bot cần di chuyển đến bãi train hoặc phó bản,
-- bắt buộc phải gọi hàm này để nhân vật "cắm đầu chạy không được đánh",
-- tránh bị quái bên đường kéo lại đánh làm chậm hành trình.
function ModMovementCombat.StopFightAndClearTarget()
    local me = _G.RoleManager and _G.RoleManager.me
    if not me then return end

    -- 1. Tắt cờ AutoFight
    if me.isAutoFight then
        if me.StopAutoFight then
            pcall(function() me:StopAutoFight() end)
        end
        if _G.EventManager and _G.Event and _G.Event.Role_StopAutoFight then
            pcall(function() _G.EventManager.Dispatch(_G.Event.Role_StopAutoFight) end)
        end
    end

    -- 2. Hủy mục tiêu đang lock (TargetAvatar)
    me.TargetAvatar = nil
    if me.SetTarget then
        pcall(function() me:SetTarget(nil) end)
    end
end

--- Ra lệnh cho nhân vật chạy thẳng tới tọa độ ô lưới (Cell Coordinate)
-- @param tx number: Tọa độ X
-- @param ty number: Tọa độ Y
-- @param stopRadius number: Bán kính dừng (mặc định = 0)
function ModMovementCombat.MoveToCoord(tx, ty, stopRadius)
    local me = _G.RoleManager and _G.RoleManager.me
    if not me or me.isDead then return false end
    stopRadius = stopRadius or 0

    if me.MoveTo then
        pcall(function() me:MoveTo({ x = tx, y = ty }, stopRadius) end)
        return true
    end
    return false
end

--- Kích hoạt chế độ AutoFight (Tự động đánh quái)
function ModMovementCombat.StartAutoFight()
    local me = _G.RoleManager and _G.RoleManager.me
    if not me or me.isDead then return false end

    if not me.isAutoFight and me.SetAutoFight then
        local fightKey = (_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight) or "AutoFight"
        pcall(function() me:SetAutoFight(fightKey) end)
        return true
    end
    return false
end

--- Di chuyển có kiểm soát khoảng cách đến điểm hẹn (Rush to Target)
-- Quy tắc:
--   - Khi khoảng cách > threshold (mặc định 1.5m): Dừng đánh, hủy mục tiêu, cắm đầu chạy thẳng.
--   - Khi khoảng cách <= threshold: Bật AutoFight, kích hoạt callback nếu có.
-- @param tx number, ty number: Tọa độ đích
-- @param threshold number: Khoảng cách ngưỡng (mặc định = 1.5m)
-- @param onArrived function|nil: Callback khi đã tới nơi
-- @return boolean: true nếu đang chạy dở (> threshold), false nếu đã tới nơi (<= threshold)
function ModMovementCombat.RushToCoord(tx, ty, threshold, onArrived)
    local me = _G.RoleManager and _G.RoleManager.me
    if not me or me.isDead then return false end
    threshold = threshold or 1.5

    local cx, cy = ModMovementCombat.GetMeCoord()
    local dist = ModMovementCombat.GetDistance(cx, cy, tx, ty)

    if dist > threshold then
        -- Chưa tới gần vị trí -> Cắm đầu chạy không đánh
        ModMovementCombat.StopFightAndClearTarget()
        ModMovementCombat.MoveToCoord(tx, ty, 0)
        return true -- Đang trên đường chạy
    else
        -- Đã tới cự ly cho phép -> Bật AutoFight
        ModMovementCombat.StartAutoFight()
        if onArrived then
            pcall(onArrived)
        end
        return false -- Đã tới nơi
    end
end

--- Kiểm tra xem role có phải là "Rồng Con-Vàng" (ID 164001..164099, 100113) hay không
-- @param role table: Đối tượng quái
-- @return boolean
function ModMovementCombat.IsGoldenBabyDragon(role)
    if not role then return false end
    local rType = role.RoleType
    local monsterRoleType = (_G.ERoleType and _G.ERoleType.Monster) or 2
    if rType ~= nil and rType ~= monsterRoleType then
        return false
    end

    local cfgId = tonumber(
        (role.GetConfigId and role:GetConfigId())
        or role.configId
        or (role.data and (role.data.configId or (role.data.configData and role.data.configData.id) or (role.data.config_Monster and role.data.config_Monster.id)))
        or 0
    ) or 0

    if (cfgId >= 164001 and cfgId <= 164099) or cfgId == 100113 then
        return true
    end

    local roleName = tostring(
        role.name
        or (role.data and (role.data.name or (role.data.configData and role.data.configData.name) or (role.data.config_Monster and role.data.config_Monster.name)))
        or ""
    )
    if roleName == "" and cfgId > 0 and _G.ClientTable and _G.ClientTable.cfg_Monster_monsterManager then
        local okCfg, mCfg = pcall(function()
            return _G.ClientTable.cfg_Monster_monsterManager:TryGetValue(cfgId, "id")
                or _G.ClientTable.cfg_Monster_monsterManager:TryGetValue(cfgId)
        end)
        if okCfg and mCfg and mCfg.name then
            roleName = tostring(mCfg.name)
        end
    end

    if roleName ~= "" then
        if string.find(roleName, "Rồng Con-Vàng", 1, true)
            or string.find(roleName, "Rồng Con Vàng", 1, true)
            or string.find(roleName, "Rong Con-Vang", 1, true)
            or string.find(roleName, "Rong Con Vang", 1, true) then
            return true
        end
    end

    return false
end

--- Hook RoleTargetManager & Me.SetTarget để chặn chọn mục tiêu Rồng Con-Vàng khi _G.Bot_Running == true
function ModMovementCombat.EnsureGoldenDragonTargetFilterHooked()
    pcall(function()
        local rtm = _G.RoleTargetManager
        if rtm and not rtm._modHookedGoldenDragonFilter then
            rtm._modHookedGoldenDragonFilter = true
            local origIsCanAttackMonster = rtm.IsCanAttackMonster
            if type(origIsCanAttackMonster) == "function" then
                rtm.IsCanAttackMonster = function(role)
                    if _G.Bot_Running and ModMovementCombat.IsGoldenBabyDragon(role) then return false end
                    return origIsCanAttackMonster(role)
                end
            end
            local origGetCanAttackRole = rtm.GetCanAttackRole
            if type(origGetCanAttackRole) == "function" then
                rtm.GetCanAttackRole = function(role)
                    if _G.Bot_Running and ModMovementCombat.IsGoldenBabyDragon(role) then return false end
                    return origGetCanAttackRole(role)
                end
            end
            local origGetCanAttackRoleOnHookTime = rtm.GetCanAttackRoleOnHookTime
            if type(origGetCanAttackRoleOnHookTime) == "function" then
                rtm.GetCanAttackRoleOnHookTime = function(role)
                    if _G.Bot_Running and ModMovementCombat.IsGoldenBabyDragon(role) then return false end
                    return origGetCanAttackRoleOnHookTime(role)
                end
            end
        end

        local meClass = _G.Me
        if meClass and not meClass._modHookedGoldenDragonTarget then
            meClass._modHookedGoldenDragonTarget = true
            local origSetTarget = meClass.SetTarget
            if type(origSetTarget) == "function" then
                meClass.SetTarget = function(self, avatar, ...)
                    if _G.Bot_Running and avatar ~= nil and ModMovementCombat.IsGoldenBabyDragon(avatar) then return end
                    return origSetTarget(self, avatar, ...)
                end
            end
            local origSetTargetAvatar = meClass.SetTargetAvatar
            if type(origSetTargetAvatar) == "function" then
                meClass.SetTargetAvatar = function(self, avatar, ...)
                    if _G.Bot_Running and avatar ~= nil and ModMovementCombat.IsGoldenBabyDragon(avatar) then return end
                    return origSetTargetAvatar(self, avatar, ...)
                end
            end
        end

        if _G.Bot_Running then
            local me = _G.RoleManager and _G.RoleManager.me
            if me and me.TargetAvatar and ModMovementCombat.IsGoldenBabyDragon(me.TargetAvatar) then
                if me.CloseTarget then pcall(function() me:CloseTarget() end) end
                me.TargetAvatar = nil
                if _G.RoleTargetManager and _G.RoleTargetManager.ClearSelectMonsterTarget then
                    pcall(_G.RoleTargetManager.ClearSelectMonsterTarget)
                end
            end
        end
    end)
end

return ModMovementCombat
