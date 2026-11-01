MAIN = true
require("UnityEngine/UnityEngine")
require("UtilityCommon/Common")
require("CSScripts/CSScripts")
TableLoad = require("Config/table/TableLoad")
require("GameConst/AcquireGameConst")
require("Utility/Utility")
require("Config/ConfigManager")
require("Config/GlobalConfig")
require("Localization/Localization")
require("LuaCore/AcquireLuaCore")
require("GamePlay/PoolManager/TableDataPool")
require("GameController/GameLogic")
require("GamePlay/GamePlay")
require("EmmyluaDebug")
-- =========================================================================
-- [MOD FEATURE]: PIPELINE PHÓ BẢN, NHIỆM VỤ CHÍNH TUYẾN & ĐĂNG NHẬP TỰ ĐỘNG
-- Mô tả: Tách phần cuối của EmmyluaDebug sang Main.lua để giữ EmmyluaDebug.lua < 500KB.
-- =========================================================================
do
	local _E = _G._ModFarmEnv or {}
	local ApplyFovAndSpeed, AutoAddAttributePoints, AutoBuyDailyDiamondGiftPacks, AutoBuyNewServerExpMedicinePack, AutoBuyPotionsIfLow, AutoClaimCommunityWelfareAndMail, AutoClaimDailyWelfare, AutoClaimNewServerRewards, AutoEquipBetterItems, AutoEvenEnhanceEquipments, AutoEvenUpgradeGems, AutoRecycleBagItems, AutoUseExpMedicine, AutoUsePrivilegeCard, Base64Encode, CheckAndRunQueenBossBug, ClearAllTaskDataAndState, CreateRoleAndEnterGame, DELAY, DismissBlockers, ForceLogoutToLogin, GetBestMonsterFarmPoint, GetCurrentAccount, GetPlayerActualDefense, GetPlayerMonsterDefense, IsTaskBlockedFromAutoClaim, Log, MAP_TRAVEL_TASKS, MD5, RecordQuestFlow, RunAutoGiftcode, RunPeriodicUpgradeCycle, SaveOutput, SDK_SALT, SDK_SIGNATURE, SelectRoleByIndex, SolveBranchAndRewardsTasks, StartGlobal30sUpgradePipeline, StartStep5_MailAndUpgrade, TeleportToBestFarmPoint, TriggerDungeonSkipWait, UrlEncode, VacuumAllMapDropItems, XXTEA_Encrypt =
		_E.ApplyFovAndSpeed, _E.AutoAddAttributePoints, _E.AutoBuyDailyDiamondGiftPacks, _E.AutoBuyNewServerExpMedicinePack, _E.AutoBuyPotionsIfLow, _E.AutoClaimCommunityWelfareAndMail, _E.AutoClaimDailyWelfare, _E.AutoClaimNewServerRewards, _E.AutoEquipBetterItems, _E.AutoEvenEnhanceEquipments, _E.AutoEvenUpgradeGems, _E.AutoRecycleBagItems, _E.AutoUseExpMedicine, _E.AutoUsePrivilegeCard, _E.Base64Encode, _E.CheckAndRunQueenBossBug, _E.ClearAllTaskDataAndState, _E.CreateRoleAndEnterGame, _E.DELAY, _E.DismissBlockers, _E.ForceLogoutToLogin, _E.GetBestMonsterFarmPoint, _E.GetCurrentAccount, _E.GetPlayerActualDefense, _E.GetPlayerMonsterDefense, _E.IsTaskBlockedFromAutoClaim, _E.Log, _E.MAP_TRAVEL_TASKS, _E.MD5, _E.RecordQuestFlow, _E.RunAutoGiftcode, _E.RunPeriodicUpgradeCycle, _E.SaveOutput, _E.SDK_SALT, _E.SDK_SIGNATURE, _E.SelectRoleByIndex, _E.SolveBranchAndRewardsTasks, _E.StartGlobal30sUpgradePipeline, _E.StartStep5_MailAndUpgrade, _E.TeleportToBestFarmPoint, _E.TriggerDungeonSkipWait, _E.UrlEncode, _E.VacuumAllMapDropItems, _E.XXTEA_Encrypt
	local CheckAndRunBloodCastleOrDemonPlaza, StartNewbieQuestPipeline, ConnectToTargetServer, EnsureServerListLoaded, StartFullLoginProcess

-- ====================================
-- [MOD FEATURE]: TỰ ĐỘNG THAM GIA PHÓ BẢN HUYẾT LÂU & QUẢNG TRƯỜNG QUỶ (LV 110 - 199)
-- ====================================
_G.Mod_InstanceMonitorTimer = _G.Mod_InstanceMonitorTimer or nil
_G.Mod_IsRunningInstance = _G.Mod_IsRunningInstance or false
-- Lắng nghe sự kiện cập nhật trạng thái phó bản để bấm Mở Ngay ngay khi đếm 10s xong
pcall(function()
	if _G.EventManager and _G.Event and _G.Event.UpdateCopyDataInfo then
		_G.EventManager.RegistEvent(_G.Event.UpdateCopyDataInfo, function(id, msg)
			if not _G.Bot_Running or _G.Bot_PauseTask then return end
			pcall(function()
				if _G.networkRequest and _G.networkRequest.ReqSkipWait then
					_G.networkRequest.ReqSkipWait()
				elseif _G.NetManager and _G.MapMessage and _G.MapMessage.ReqSkipWait then
					_G.NetManager.Send(_G.MapMessage.ReqSkipWait)
				end
				local goalUI = _G.UIManager and _G.UIID and _G.UIID.Instance_GoalUI and _G.UIManager.GetUiByName(_G.UIID.Instance_GoalUI)
				if goalUI and goalUI.btn_rightnowOnClick then
					goalUI:btn_rightnowOnClick()
				end
			end)
		end, nil)
	end
end)
CheckAndRunBloodCastleOrDemonPlaza = function(onFinished)
	if not _G.Mod_AutoBCDSActive then
		if onFinished then onFinished() end
		return
	end
	if not _G.Bot_Running or _G.Bot_PauseTask then
		if onFinished then onFinished() end
		return
	end
	local pMe = _G.RoleManager and _G.RoleManager.me
	local curLvl = tonumber((pMe and pMe.level) or (pMe and pMe.data and pMe.data.level) or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.level) or 1)
	if curLvl < 100 then
		if onFinished then onFinished() end
		return
	end
	local curMapId = (_G.SceneData and _G.SceneData.mapId) or 0
	local isCurInBC = (curMapId >= 1012000 and curMapId <= 1012099)
	local isCurInDS = (curMapId >= 1010000 and curMapId <= 1010099)
	local isInInstance = isCurInBC or isCurInDS or (_G.TranScriptData and _G.TranScriptData.InTranscript)
	local function StartInstanceMonitorLoop()
		if _G.Mod_InstanceMonitorTimer then
			pcall(function() Timer.Stop(_G.Mod_InstanceMonitorTimer) end)
			_G.Mod_InstanceMonitorTimer = nil
		end
		_G.Mod_IsRunningInstance = true
		Log("[Phó Bản] : Đang giám sát chiến đấu & sẵn sàng bấm [Mở Ngay]...", true)
		SaveOutput()
		local monitorTicks = 0
		local hasSkippedWait = false
		-- Quét 0.5s/lần để kích hoạt [Mở Ngay] và giám sát chiến đấu trong phó bản
		_G.Mod_InstanceMonitorTimer = Timer.StartLoop(0.5, -1, function()
			if not _G.Bot_Running or _G.Bot_PauseTask then return end
			monitorTicks = monitorTicks + 1
			local cMap = (_G.SceneData and _G.SceneData.mapId) or 0
			local inBC = (cMap >= 1012000 and cMap <= 1012099)
			local inDS = (cMap >= 1010000 and cMap <= 1010099)
			local inTrans = inBC or inDS or (_G.TranScriptData and _G.TranScriptData.InTranscript)
			-- Khoảng ân hạn: Chờ ít nhất 6 tick (~3 giây) để client load xong map phó bản trước khi check thoát
			if not inTrans and monitorTicks > 6 then
				if _G.Mod_InstanceMonitorTimer then
					Timer.Stop(_G.Mod_InstanceMonitorTimer)
					_G.Mod_InstanceMonitorTimer = nil
				end
				_G.Mod_IsRunningInstance = false
				Log("[Phó Bản] : Đã hoàn thành phó bản! Tiếp tục làm nhiệm vụ chính...", true)
				SaveOutput()
				DismissBlockers()
				if onFinished then onFinished() end
				return
			end
			-- CHỈ KHI THỰC SỰ Ở TRONG PHÓ BẢN MỚI BẤM SKIPWAIT VÀ DI CHUYỂN AUTO
			if inTrans then
				-- 1. TỰ ĐỘNG BẤM [MỞ NGAY] (REQSKIPWAIT) BỎ QUA 30s CHỜ ĐỢI
				TriggerDungeonSkipWait()
				if not hasSkippedWait and monitorTicks >= 2 then
					hasSkippedWait = true
					Log("[Phó Bản] : Đã bấm [Mở Ngay] bỏ qua 30s chờ đợi!", true)
				end
				-- 2. Tự động di chuyển tới tâm phó bản & bật Auto Fight
				pcall(function()
					local me = _G.RoleManager and _G.RoleManager.me
					if me then
						local mx, my = 0, 0
						if me.Position then mx, my = me.Position.x or 0, me.Position.y or 0 end
						if inBC then
							-- ====================================
							-- [MOD FEATURE]: TỌA ĐỘ TÂM CHIẾN ĐẤU HUYẾT LÂU (BLOOD CASTLE: 14#25)
							-- Mô tả: Di chuyển tới vị trí 14#25 để phá cổng và đánh quái tối ưu
							-- ====================================
							local dist = math.sqrt((mx - 14)^2 + (my - 25)^2)
							if dist > 3 and me.MoveTo then me:MoveTo({ x = 14, y = 25 }, 0) end
						elseif inDS then
							local cx, cy = 137, 167
							if curLvl >= 150 then cx, cy = 135, 97 end
							local dist = math.sqrt((mx - cx)^2 + (my - cy)^2)
							if dist > 5 and me.MoveTo then me:MoveTo({ x = cx, y = cy }, 0) end
						end
						if me.SetAutoFight then me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight") end
						if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then _G.QiJiHelperData.SetAutoFightData(true) end
					end
				end)
			end
		end)
	end
	if isInInstance then
		Log(string.format("[Phó Bản] : Đang ở trong phó bản (Map %s)!", tostring(curMapId)), true)
		TriggerDungeonSkipWait()
		StartInstanceMonitorLoop()
		return
	end
	-- Kiểm tra khung giờ mở phó bản: Chỉ mở trong 10 phút đầu mỗi khung giờ (phút 00 -> 09)
	local curHour = tonumber(os.date("%H")) or 0
	local curMinute = tonumber(os.date("%M")) or 0
	if curMinute >= 15 then
		Log(string.format("[Phó Bản] : Hiện tại là %02d:%02d (Phó bản chỉ mở 10 phút đầu mỗi giờ: 00-09) -> Bỏ qua phó bản!", curHour, curMinute), false)
		if onFinished then onFinished() end
		return
	end
	-- QUY TẮC KHUNG GIỜ:
	-- - GIỜ LẺ (1h, 3h, 5h, 7h, 9h, 11h, 13h, 15h, 17h, 19h, 21h, 23h): CHỈ MỞ HUYẾT LÂU (Blood Castle)
	-- - GIỜ CHẴN (0h, 2h, 4h, 6h, 8h, 10h, 12h, 14h, 16h, 18h, 20h, 22h): CHỈ MỞ QUẢNG TRƯỜNG QUỶ (Demon Plaza)
	local checkList = {}
	if curHour % 2 == 1 then
		table.insert(checkList, { name = "Huyết Lâu", subType = _G.TranScriptData.TranScriptSubType.BloodCastle, condId = 100414, maxNumId = 100404, globalCountId = 60000001 })
	else
		table.insert(checkList, { name = "Quảng Trường Quỷ", subType = _G.TranScriptData.TranScriptSubType.DemonPlaza, condId = 100408, maxNumId = 100702, globalCountId = 60000002 })
	end
	local targetInst = nil
	local targetEnterData = nil
	for _, inst in ipairs(checkList) do
		local enterData, lvlNum = nil, nil
		pcall(function()
			if _G.TranScriptData and _G.TranScriptData.GetEnterConditionData then
				enterData, lvlNum = _G.TranScriptData.GetEnterConditionData(inst.subType, inst.condId, inst.maxNumId, curLvl)
			end
		end)
		if enterData and enterData.id then
			local leftCount = 0
			pcall(function()
				local gTbl = _G.ClientTable.cfg_Global_globalManager:TryGetValue(inst.globalCountId)
				if gTbl and gTbl.effect and _G.RefreshData and _G.RefreshData.GetInstanceCount then
					leftCount = _G.RefreshData.GetInstanceCount(tonumber(gTbl.effect)) or 0
				end
			end)
			if leftCount > 0 then
				local ticketId = 0
				local needCount = 1
				if enterData.cost then
					local cParts = string.split(enterData.cost, "#")
					ticketId = tonumber(cParts[1]) or 0
					needCount = tonumber(cParts[2]) or 1
				end
				local haveTicketCount = 0
				pcall(function()
					if ticketId > 0 and _G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId then
						haveTicketCount = _G.BagInfoData.GetItemTotalCountByItemId(ticketId) or 0
					end
				end)
				if haveTicketCount >= needCount then
					targetInst = inst
					targetEnterData = enterData
					Log(string.format("[Phó Bản] : Tìm thấy %s (Lượt: %d | Vé: %d/%d)",
						inst.name, leftCount, haveTicketCount, needCount), true)
					break
				end
			end
		end
	end
	if not targetInst or not targetEnterData then
		if onFinished then onFinished() end
		return
	end
	Log(string.format("[Phó Bản] : Tiến vào %s (MapId: %s)", targetInst.name, tostring(targetEnterData.id)), true)
	SaveOutput()
	-- KHÓA NGAY LẬP TỨC TIẾN TRÌNH NHIỆM VỤ ĐỂ TRÁNH BỊ TASK KHÁC TRUYỀN TỐNG VĂNG RA MAP KHÁC
	_G.Mod_IsRunningInstance = true
	pcall(function()
		if _G.EventManager and _G.Event and _G.Event.Map_ChangeMap then
			_G.EventManager.Dispatch(_G.Event.Map_ChangeMap, { mapId = targetEnterData.id })
		end
		if _G.UIManager then
			if _G.UIID and _G.UIID.Instance_BloodCastleUI then _G.UIManager.Hide(_G.UIID.Instance_BloodCastleUI) end
			if _G.UIID and _G.UIID.Instance_DemonPlazaUI then _G.UIManager.Hide(_G.UIID.Instance_DemonPlazaUI) end
			if _G.UIID and _G.UIID.PromptTipUI then _G.UIManager.Hide(_G.UIID.PromptTipUI) end
		end
	end)
	Timer.Start(2.5, function()
		DismissBlockers()
		TriggerDungeonSkipWait()
		StartInstanceMonitorLoop()
	end)
end
_G.CheckAndRunBloodCastleOrDemonPlaza = CheckAndRunBloodCastleOrDemonPlaza

-- ====================================
-- BẢNG PHÂN LOẠI HÀNH VI NHIỆM VỤ CHUẨN XÁC THEO TASK ID (DETERMINISTIC FLOW)
-- ====================================
local TASK_BEHAVIOR = {
	LEVEL_UP     = 1, -- Nhiệm vụ Cấp đạt X / Cày cấp -> Truyền tống bãi quái tối ưu & Bật AutoFight
	MONSTER_KILL = 2, -- Nhiệm vụ Diệt quái cụ thể (Bọ Tuyết...) -> GoTask 1 lần, chờ đánh đủ số lượng
	MAP_TRAVEL   = 3, -- Nhiệm vụ Chuyển map (Đến Devias, Dungeon...) -> Truyền tống tức thì
	SKILL_SHOP   = 4, -- Nhiệm vụ Mua & Học kỹ năng Shop
	EQUIP_WEAR   = 5, -- Nhiệm vụ Mặc trang bị
	RECYCLE      = 6, -- Nhiệm vụ Thu hồi rác
	CRAFT_ITEM   = 7, -- Nhiệm vụ Ghép vé
	DIALOGUE     = 8, -- Nhiệm vụ Đối thoại NPC -> GoTask tới NPC
}
local TASK_CONFIG_BY_ID = {
	-- 1. LEVEL UP TASKS (Cấp đạt ...) -> Teleport to best farm point & AutoFight
	[3000] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 20
	[3001] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 20
	[3102] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 60
	[3104] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 80
	[3108] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 100
	[3109] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 150
	[3150] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 150 mở CS1
	[3220] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 200
	[3230] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 250
	[3240] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 300
	[3250] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 350
	[3260] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt Chuyển 1
	[3267] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 450
	[3274] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 500
	[3281] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 550
	[3288] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 600
	[3295] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 650
	-- [MOD FEATURE]: NHIỆM VỤ CHUYỂN CHỨC (CS1, CS2, CS3 - TARKAN SÁCH ĐẾ VƯƠNG 20 CUỐN...)
	-- Mô tả: Chuyển sang MONSTER_KILL để bot tự động truyền tống đến bãi quái map nhiệm vụ và cắm auto đánh rơi vật phẩm
	[21001] = TASK_BEHAVIOR.MONSTER_KILL, -- Chuyển Chức - Chuyển 1 (Đến Tarkan Nhận Sách Đế Vương 0/20)
	[21002] = TASK_BEHAVIOR.MONSTER_KILL, -- Chuyển Chức - Kiếm Sư Chuyển 1
	[21003] = TASK_BEHAVIOR.MONSTER_KILL, -- Chuyển Chức - Ma Pháp Sư Chuyển 1
	[21004] = TASK_BEHAVIOR.MONSTER_KILL, -- Chuyển Chức - Cung Thủ Chuyển 1
	[21005] = TASK_BEHAVIOR.MONSTER_KILL, -- Chuyển Chức - Chuyển 2-Giai đoạn 1
	[210051] = TASK_BEHAVIOR.MONSTER_KILL, -- Chuyển Chức - Chuyển 2-Giai đoạn 2
	[21006] = TASK_BEHAVIOR.MONSTER_KILL, -- Chuyển Chức - Chuyển 3
	[21007] = TASK_BEHAVIOR.MONSTER_KILL,
	[21008] = TASK_BEHAVIOR.MONSTER_KILL,
	[21009] = TASK_BEHAVIOR.MONSTER_KILL,
	[21010] = TASK_BEHAVIOR.MONSTER_KILL,
	[21011] = TASK_BEHAVIOR.MONSTER_KILL,
	[21012] = TASK_BEHAVIOR.MONSTER_KILL,
	[21013] = TASK_BEHAVIOR.MONSTER_KILL, -- Mở Chuyển 1
	[21014] = TASK_BEHAVIOR.MONSTER_KILL, -- Mở Chuyển 2
	[21015] = TASK_BEHAVIOR.MONSTER_KILL, -- Mở Chuyển 3
	[21016] = TASK_BEHAVIOR.MONSTER_KILL,
	[21017] = TASK_BEHAVIOR.MONSTER_KILL,
	[21023] = TASK_BEHAVIOR.MONSTER_KILL, -- Ma Kiếm Sư CS1
	[21024] = TASK_BEHAVIOR.MONSTER_KILL, -- Triệu Hồi Sư CS1
	-- 2. MONSTER KILL TASKS -> GoTask 1 lần, đánh đủ số lượng
	[3060] = TASK_BEHAVIOR.MONSTER_KILL, -- Diệt Bọ Tuyết
	[3070] = TASK_BEHAVIOR.MONSTER_KILL, -- Diệt Hàn Băng Ma
	[3080] = TASK_BEHAVIOR.MONSTER_KILL, -- Diệt Lam Ma Quái
	[3090] = TASK_BEHAVIOR.MONSTER_KILL, -- Diệt Kẻ Ám Sát
	[3100] = TASK_BEHAVIOR.MONSTER_KILL, -- Diệt Người Tuyết
	-- 3. MAP TRAVEL TASKS -> ReqTransmit
	[3050] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Devias
	[3101] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Dungeon
	[3106] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Lost Tower
	[3107] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Lost Tower 2
	[3200] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Atlantis
	[3224] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Aida
	[3234] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Icarus
	[3244] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Phế Tích Kanturu
	[3254] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Di Chỉ Kanturu
	-- 4. SKILL SHOP TASKS
	[3020] = TASK_BEHAVIOR.SKILL_SHOP,
	[3030] = TASK_BEHAVIOR.SKILL_SHOP,
	[3040] = TASK_BEHAVIOR.SKILL_SHOP,
	[3041] = TASK_BEHAVIOR.SKILL_SHOP,
	-- 5. RECYCLE TASKS
	[3010] = TASK_BEHAVIOR.RECYCLE,
	[3061] = TASK_BEHAVIOR.RECYCLE,
	-- 6. EQUIP WEAR TASKS
	[3051] = TASK_BEHAVIOR.EQUIP_WEAR,
	[3052] = TASK_BEHAVIOR.EQUIP_WEAR,
	[3053] = TASK_BEHAVIOR.EQUIP_WEAR,
	[3054] = TASK_BEHAVIOR.EQUIP_WEAR,
	[3206] = TASK_BEHAVIOR.EQUIP_WEAR,
	[3207] = TASK_BEHAVIOR.EQUIP_WEAR,
	[3208] = TASK_BEHAVIOR.EQUIP_WEAR,
	[3221] = TASK_BEHAVIOR.EQUIP_WEAR,
	[3222] = TASK_BEHAVIOR.EQUIP_WEAR,
	[3223] = TASK_BEHAVIOR.EQUIP_WEAR,
	-- 7. CRAFT ITEM TASKS
	[3120] = TASK_BEHAVIOR.CRAFT_ITEM,
}

-- =========================================================================
-- [MOD FEATURE]: BỘ ĐẾM THỜI GIAN XỬ LÝ ACCOUNT, LƯU LOG THEO SERVER & PANEL KQ
-- Mô tả:
--   1. Ghi nhận thời gian xử lý từng cặp S<Server>-<Email> (ví dụ: S515-accvutmuvh0001@gmail.com: 20s(done)).
--   2. Nếu S<Server>-<Email> đã mark (done) và bị quét lại thì bỏ qua không ghi đè; nếu chưa (done) thì cộng dồn.
--   3. Sắp xếp: Server giảm dần (S515 -> S514...), Email tăng dần (0001 -> 0002...).
--   4. Hiển thị thông báo giữa màn hình mỗi 5s/lần theo style thông báo Kundun xuất hiện bên bản Client.
--   5. Tạo nút [KQ] & Panel Kết Quả (ScrollView chiều cao 1200, bám mép trái màn hình, nút X để đóng) đọc trực tiếp từ file txt.
-- =========================================================================
_G.Mod_AccTimeRecords = _G.Mod_AccTimeRecords or {}
_G.Mod_AccTimeLoaded = _G.Mod_AccTimeLoaded or false
_G.Mod_CurrentTrackingKey = _G.Mod_CurrentTrackingKey or ""
_G.Mod_CurrentSessionSec = _G.Mod_CurrentSessionSec or 0
_G.Mod_KqPanelVisible = _G.Mod_KqPanelVisible or false

local function GetAccTimeLogFilePath()
	local dir = "/storage/emulated/0/Android/data/com.vnyh.gp/files"
	pcall(function()
		if CS and CS.UnityEngine and CS.UnityEngine.Application and CS.UnityEngine.Application.persistentDataPath then
			local p = tostring(CS.UnityEngine.Application.persistentDataPath)
			if p ~= "" then dir = p end
		end
	end)
	return dir .. "/account_time_log.txt"
end

local function FormatAccDuration(sec)
	local s = math.max(1, math.floor(tonumber(sec) or 0))
	if s < 60 then
		return string.format("%ds", s)
	end
	local m = math.floor(s / 60)
	local rem = s % 60
	return string.format("%dp%ds", m, rem)
end

local function ParseAccDurationStr(timeStr)
	local str = tostring(timeStr or "")
	local m = tonumber(string.match(str, "(%d+)%s*[pP]")) or 0
	local s = tonumber(string.match(str, "(%d+)%s*[sS]")) or 0
	if m == 0 and s == 0 then
		s = tonumber(string.match(str, "(%d+)")) or 0
	end
	return math.max(1, m * 60 + s)
end

local function LoadAccountTimeRecords(forceReload)
	if _G.Mod_AccTimeLoaded and not forceReload then return end
	_G.Mod_AccTimeLoaded = true
	pcall(function()
		local path = GetAccTimeLogFilePath()
		local content = nil
		if CS and CS.System and CS.System.IO and CS.System.IO.File and CS.System.IO.File.Exists(path) then
			content = CS.System.IO.File.ReadAllText(path, CS.System.Text.Encoding.UTF8)
		else
			local f = io.open(path, "r")
			if f then
				content = f:read("*a")
				f:close()
			end
		end
		if not content or content == "" then return end
		for line in string.gmatch(content, "[^\r\n]+") do
			local srvStr, emailRaw, rhs = string.match(line, "^%s*[Ss](%d+)%-(.-)%s*[:;]%s*(.-)%s*$")
			if srvStr and emailRaw and rhs then
				local srvId = tonumber(srvStr) or 0
				local email = tostring(emailRaw):gsub("^%s+", ""):gsub("%s+$", "")
				if srvId > 0 and email ~= "" then
					local isDone = (string.find(string.lower(rhs), "%(done%)") ~= nil)
					local sec = ParseAccDurationStr(rhs)
					local key = string.format("S%d-%s", srvId, string.lower(email))
					local existing = _G.Mod_AccTimeRecords[key]
					if not existing or not existing.done then
						_G.Mod_AccTimeRecords[key] = {
							key = key,
							serverId = srvId,
							email = email,
							elapsedSec = sec,
							done = isDone,
						}
					end
				end
			end
		end
	end)
end

local function GetSortedAccountTimeRecords()
	LoadAccountTimeRecords(false)
	local list = {}
	for _, rec in pairs(_G.Mod_AccTimeRecords) do
		if rec and rec.serverId and rec.email and rec.email ~= "" then
			table.insert(list, rec)
		end
	end
	table.sort(list, function(a, b)
		local sa = tonumber(a.serverId) or 0
		local sb = tonumber(b.serverId) or 0
		if sa ~= sb then
			return sa > sb -- Server giảm dần (S515 -> S514...)
		end
		return string.lower(tostring(a.email)) < string.lower(tostring(b.email)) -- Email tăng dần
	end)
	return list
end

local function SaveAccountTimeRecords()
	pcall(function()
		local list = GetSortedAccountTimeRecords()
		local lines = {}
		for _, rec in ipairs(list) do
			local line = string.format("S%d-%s: %s%s",
				tonumber(rec.serverId) or 0,
				tostring(rec.email),
				FormatAccDuration(rec.elapsedSec),
				rec.done and "(done)" or "")
			table.insert(lines, line)
		end
		local fullText = table.concat(lines, "\r\n")
		if #lines > 0 then fullText = fullText .. "\r\n" end
		local path = GetAccTimeLogFilePath()
		if CS and CS.System and CS.System.IO and CS.System.IO.File then
			CS.System.IO.File.WriteAllText(path, fullText, CS.System.Text.Encoding.UTF8)
		else
			local f = io.open(path, "w")
			if f then
				f:write(fullText)
				f:close()
			end
		end
	end)
	if _G.Mod_KqPanelVisible and _G.Mod_RefreshKqPanelUI then
		pcall(_G.Mod_RefreshKqPanelUI)
	end
end

local function FlashAccTimeCenterAlert(msg)
	pcall(function()
		local alertText = "<size=22><b><color=#FFFF00>⚠️ " .. tostring(msg) .. " ⚠️</color></b></size>"
		if _G.FloatingTipUtility and _G.FloatingTipUtility.QuickMsg then
			_G.FloatingTipUtility.QuickMsg(alertText)
		elseif _G.FloatingWordUtility and _G.FloatingWordUtility.QuickMsg then
			_G.FloatingWordUtility.QuickMsg(alertText)
		end
	end)
end

local function ResolveCurrentSessionServerAndEmail()
	local curAcc = (GetCurrentAccount and GetCurrentAccount()) or (_G.BotAccounts and _G.BotAccounts[_G.CurrentAccountIndex or 1]) or {}
	local email = tostring(_G.Bot_ActiveSessionEmail or curAcc.account or ""):gsub("^%s+", ""):gsub("%s+$", "")
	local srvId = tonumber(_G.Bot_ActiveSessionServer)
		or tonumber(_G.TARGET_SERVER_ID)
		or tonumber(curAcc.targetServer)
		or (CS and CS.UnityEngine and CS.UnityEngine.PlayerPrefs and CS.UnityEngine.PlayerPrefs.GetInt("Mod_Farm_TargetServer", 492))
		or 492
	return srvId, email
end

_G.FinalizeAccountTimeOnGoal = function(emailArg, srvArg)
	pcall(function()
		LoadAccountTimeRecords(false)
		local defSrv, defEmail = ResolveCurrentSessionServerAndEmail()
		local srvId = tonumber(srvArg) or defSrv
		local email = tostring((emailArg and emailArg ~= "" and emailArg) or defEmail)
		if srvId <= 0 or email == "" or email == "Unknown" then return end

		local key = string.format("S%d-%s", srvId, string.lower(email))
		local rec = _G.Mod_AccTimeRecords[key]
		-- Nếu S<Server>-<Email> đã mark (done) từ trước thì bỏ qua không log đè nữa
		if rec and rec.done then
			return
		end
		if not rec then
			rec = {
				key = key,
				serverId = srvId,
				email = email,
				elapsedSec = math.max(2, tonumber(_G.Mod_CurrentSessionSec) or 2),
				done = true,
			}
			_G.Mod_AccTimeRecords[key] = rec
		else
			rec.elapsedSec = math.max(2, tonumber(rec.elapsedSec) or 0, tonumber(_G.Mod_CurrentSessionSec) or 2)
			rec.done = true
		end
		SaveAccountTimeRecords()
		FlashAccTimeCenterAlert(string.format("S%d-%s: %s(done)", rec.serverId, rec.email, FormatAccDuration(rec.elapsedSec)))
	end)
end

-- Khởi tạo giao diện Nút [KQ] và Panel Kết Quả (ScrollView cao 1200 bám trái màn hình)
local function EnsureKqResultPanelUI()
	pcall(function()
		local GameObject = CS.UnityEngine.GameObject
		local RectTransform = CS.UnityEngine.RectTransform
		local Vector2 = CS.UnityEngine.Vector2
		local Vector3 = CS.UnityEngine.Vector3
		local Color = CS.UnityEngine.Color
		local Image = CS.UnityEngine.UI.Image
		local Text = CS.UnityEngine.UI.Text
		local Button = CS.UnityEngine.UI.Button
		local ScrollRect = CS.UnityEngine.UI.ScrollRect
		local RectMask2D = CS.UnityEngine.UI.RectMask2D
		local Font = CS.UnityEngine.Font
		local Resources = CS.UnityEngine.Resources
		local TextAnchor = CS.UnityEngine.TextAnchor

		local modRoot = GameObject.Find("MySuperModCanvas")
		if not modRoot then return end

		local existingBtn = modRoot.transform:Find("FloatingKqBtn")
		if existingBtn then return end

		local defaultFont = Resources.GetBuiltinResource(typeof(Font), "Arial.ttf")

		-- 1. Nút nổi [KQ] bên trái màn hình (X=1, Y=220, ngay trên nút EXEC)
		local kqBtnGo = GameObject("FloatingKqBtn")
		kqBtnGo.transform:SetParent(modRoot.transform, false)
		local kqBtnRt = kqBtnGo:AddComponent(typeof(RectTransform))
		kqBtnRt.anchorMin = Vector2(0, 0)
		kqBtnRt.anchorMax = Vector2(0, 0)
		kqBtnRt.pivot = Vector2(0, 0)
		kqBtnRt.anchoredPosition = Vector2(1, 220)
		kqBtnRt.sizeDelta = Vector2(60, 60)

		local kqBtnImg = kqBtnGo:AddComponent(typeof(Image))
		kqBtnImg.color = Color(0.12, 0.52, 0.78, 1.0)
		kqBtnImg.raycastTarget = true

		local kqBtnTxtGo = GameObject("KqTxt")
		kqBtnTxtGo.transform:SetParent(kqBtnGo.transform, false)
		local kqBtnTxtRt = kqBtnTxtGo:AddComponent(typeof(RectTransform))
		kqBtnTxtRt.anchorMin = Vector2(0, 0)
		kqBtnTxtRt.anchorMax = Vector2(1, 1)
		kqBtnTxtRt.sizeDelta = Vector2(0, 0)
		local kqBtnTxt = kqBtnTxtGo:AddComponent(typeof(Text))
		kqBtnTxt.text = "KQ"
		kqBtnTxt.color = Color.white
		kqBtnTxt.fontSize = 18
		kqBtnTxt.fontStyle = CS.UnityEngine.FontStyle.Bold
		kqBtnTxt.alignment = TextAnchor.MiddleCenter
		kqBtnTxt.raycastTarget = false
		if defaultFont then kqBtnTxt.font = defaultFont end

		-- 2. Panel Kết Quả bám mép trái màn hình (Chiều cao 1200, có ScrollView và nút X đóng)
		local kqPanelGo = GameObject("ModKqResultPanel")
		kqPanelGo.transform:SetParent(modRoot.transform, false)
		local kqPanelRt = kqPanelGo:AddComponent(typeof(RectTransform))
		kqPanelRt.anchorMin = Vector2(0, 0.5)
		kqPanelRt.anchorMax = Vector2(0, 0.5)
		kqPanelRt.pivot = Vector2(0, 0.5)
		kqPanelRt.anchoredPosition = Vector2(66, 0)
		kqPanelRt.sizeDelta = Vector2(500, 1200)
		kqPanelGo.transform.localScale = Vector3(0.88, 0.88, 1)

		local kqPanelImg = kqPanelGo:AddComponent(typeof(Image))
		kqPanelImg.color = Color(0.06, 0.07, 0.09, 0.96)
		kqPanelImg.raycastTarget = true
		kqPanelGo:SetActive(false)

		-- Header Bar
		local headerGo = GameObject("KqHeader")
		headerGo.transform:SetParent(kqPanelGo.transform, false)
		local headerRt = headerGo:AddComponent(typeof(RectTransform))
		headerRt.anchorMin = Vector2(0, 1)
		headerRt.anchorMax = Vector2(1, 1)
		headerRt.pivot = Vector2(0.5, 1)
		headerRt.anchoredPosition = Vector2(0, 0)
		headerRt.sizeDelta = Vector2(0, 48)
		local headerImg = headerGo:AddComponent(typeof(Image))
		headerImg.color = Color(0.12, 0.16, 0.22, 1.0)
		headerImg.raycastTarget = false

		local headerTitleGo = GameObject("KqHeaderTitle")
		headerTitleGo.transform:SetParent(headerGo.transform, false)
		local htRt = headerTitleGo:AddComponent(typeof(RectTransform))
		htRt.anchorMin = Vector2(0, 0)
		htRt.anchorMax = Vector2(1, 1)
		htRt.offsetMin = Vector2(14, 0)
		htRt.offsetMax = Vector2(-56, 0)
		local headerTitleTxt = headerTitleGo:AddComponent(typeof(Text))
		headerTitleTxt.text = "KẾT QUẢ XỬ LÝ ACCOUNT"
		headerTitleTxt.color = Color(1, 0.88, 0.15, 1)
		headerTitleTxt.fontSize = 18
		headerTitleTxt.fontStyle = CS.UnityEngine.FontStyle.Bold
		headerTitleTxt.alignment = TextAnchor.MiddleLeft
		headerTitleTxt.raycastTarget = false
		if defaultFont then headerTitleTxt.font = defaultFont end

		-- Nút [X] Đóng Panel ở góc trên bên phải
		local closeBtnGo = GameObject("BtnCloseKqPanel")
		closeBtnGo.transform:SetParent(headerGo.transform, false)
		local cbRt = closeBtnGo:AddComponent(typeof(RectTransform))
		cbRt.anchorMin = Vector2(1, 0.5)
		cbRt.anchorMax = Vector2(1, 0.5)
		cbRt.pivot = Vector2(1, 0.5)
		cbRt.anchoredPosition = Vector2(-6, 0)
		cbRt.sizeDelta = Vector2(40, 36)
		local cbImg = closeBtnGo:AddComponent(typeof(Image))
		cbImg.color = Color(0.82, 0.18, 0.18, 1)
		cbImg.raycastTarget = true

		local cbTxtGo = GameObject("Text")
		cbTxtGo.transform:SetParent(closeBtnGo.transform, false)
		local cbtRt = cbTxtGo:AddComponent(typeof(RectTransform))
		cbtRt.anchorMin = Vector2(0, 0)
		cbtRt.anchorMax = Vector2(1, 1)
		cbtRt.sizeDelta = Vector2(0, 0)
		local cbTxt = cbTxtGo:AddComponent(typeof(Text))
		cbTxt.text = "X"
		cbTxt.color = Color.white
		cbTxt.fontSize = 18
		cbTxt.fontStyle = CS.UnityEngine.FontStyle.Bold
		cbTxt.alignment = TextAnchor.MiddleCenter
		cbTxt.raycastTarget = false
		if defaultFont then cbTxt.font = defaultFont end

		-- ScrollView hiển thị danh sách kết quả
		local scrollGo = GameObject("KqScrollView")
		scrollGo.transform:SetParent(kqPanelGo.transform, false)
		local sRt = scrollGo:AddComponent(typeof(RectTransform))
		sRt.anchorMin = Vector2(0, 0)
		sRt.anchorMax = Vector2(1, 1)
		sRt.offsetMin = Vector2(10, 10)
		sRt.offsetMax = Vector2(-10, -54)

		local scrollRect = scrollGo:AddComponent(typeof(ScrollRect))
		scrollRect.horizontal = false
		scrollRect.vertical = true
		scrollRect.movementType = ScrollRect.MovementType.Clamped
		scrollRect.scrollSensitivity = 35

		local viewportGo = GameObject("Viewport")
		viewportGo.transform:SetParent(scrollGo.transform, false)
		local vpRt = viewportGo:AddComponent(typeof(RectTransform))
		vpRt.anchorMin = Vector2(0, 0)
		vpRt.anchorMax = Vector2(1, 1)
		vpRt.pivot = Vector2(0, 1)
		vpRt.sizeDelta = Vector2(0, 0)
		local vpImg = viewportGo:AddComponent(typeof(Image))
		vpImg.color = Color(0, 0, 0, 0.25)
		vpImg.raycastTarget = true
		viewportGo:AddComponent(typeof(RectMask2D))

		local contentGo = GameObject("Content")
		contentGo.transform:SetParent(viewportGo.transform, false)
		local contentRt = contentGo:AddComponent(typeof(RectTransform))
		contentRt.anchorMin = Vector2(0, 1)
		contentRt.anchorMax = Vector2(1, 1)
		contentRt.pivot = Vector2(0, 1)
		contentRt.anchoredPosition = Vector2(0, 0)
		contentRt.sizeDelta = Vector2(0, 1136)

		scrollRect.viewport = vpRt
		scrollRect.content = contentRt

		_G.Mod_KqRowPool = _G.Mod_KqRowPool or {}

		_G.Mod_RefreshKqPanelUI = function()
			pcall(function()
				if not kqPanelGo or kqPanelGo:Equals(nil) then return end
				LoadAccountTimeRecords(true)
				local list = GetSortedAccountTimeRecords()
				local doneCount = 0
				for _, r in ipairs(list) do
					if r.done then doneCount = doneCount + 1 end
				end
				if headerTitleTxt and not headerTitleTxt:Equals(nil) then
					headerTitleTxt.text = string.format("KẾT QUẢ XỬ LÝ (%d/%d done)", doneCount, #list)
				end

				local rowH = 30
				local totalH = math.max(1136, (#list * rowH) + 16)
				contentRt.sizeDelta = Vector2(0, totalH)

				local count = math.max(#list, 1)
				for i = 1, count do
					local rowTxt = _G.Mod_KqRowPool[i]
					if not rowTxt or rowTxt:Equals(nil) then
						local rGo = GameObject("KqRow_" .. i)
						rGo.transform:SetParent(contentGo.transform, false)
						local rRt = rGo:AddComponent(typeof(RectTransform))
						rRt.anchorMin = Vector2(0, 1)
						rRt.anchorMax = Vector2(1, 1)
						rRt.pivot = Vector2(0, 1)
						rRt.anchoredPosition = Vector2(8, -6 - (i - 1) * rowH)
						rRt.sizeDelta = Vector2(-16, rowH)

						rowTxt = rGo:AddComponent(typeof(Text))
						rowTxt.fontSize = 16
						rowTxt.alignment = TextAnchor.MiddleLeft
						rowTxt.raycastTarget = false
						if defaultFont then rowTxt.font = defaultFont end
						_G.Mod_KqRowPool[i] = rowTxt
					end
					rowTxt.gameObject:SetActive(true)
					if #list == 0 then
						rowTxt.text = "<color=#AAAAAA>Chưa có dữ liệu log thời gian xử lý...</color>"
					else
						local rec = list[i]
						local lineStr = string.format("S%d-%s: %s%s",
							tonumber(rec.serverId) or 0,
							tostring(rec.email),
							FormatAccDuration(rec.elapsedSec),
							rec.done and "(done)" or "")
						if rec.done then
							rowTxt.text = "<color=#00FF88>" .. lineStr .. "</color>"
						else
							rowTxt.text = "<color=#FFFF00>" .. lineStr .. "</color>"
						end
					end
				end

				for i = count + 1, #_G.Mod_KqRowPool do
					local rowTxt = _G.Mod_KqRowPool[i]
					if rowTxt and not rowTxt:Equals(nil) then
						rowTxt.gameObject:SetActive(false)
					end
				end
			end)
		end

		local function SetKqPanelVisible(visible)
			_G.Mod_KqPanelVisible = (visible == true)
			if kqPanelGo and not kqPanelGo:Equals(nil) then
				kqPanelGo:SetActive(_G.Mod_KqPanelVisible)
				if _G.Mod_KqPanelVisible then
					kqPanelGo.transform:SetAsLastSibling()
					if _G.Mod_RefreshKqPanelUI then _G.Mod_RefreshKqPanelUI() end
				end
			end
		end
		_G.Mod_ToggleKqPanel = function()
			SetKqPanelVisible(not _G.Mod_KqPanelVisible)
		end

		local kqBtnComp = kqBtnGo:AddComponent(typeof(Button))
		kqBtnComp.targetGraphic = kqBtnImg
		kqBtnComp.onClick:AddListener(function()
			_G.Mod_ToggleKqPanel()
		end)

		local cbBtnComp = closeBtnGo:AddComponent(typeof(Button))
		cbBtnComp.targetGraphic = cbImg
		cbBtnComp.onClick:AddListener(function()
			SetKqPanelVisible(false)
		end)
	end)
end
EnsureKqResultPanelUI()
LoadAccountTimeRecords(false)

-- Khởi chạy bộ đếm thời gian phiên 1s/lần & thông báo giữa màn hình 5s/lần (Style Kundun)
if _G.Mod_AccSessionTimer then
	pcall(function() Timer.Stop(_G.Mod_AccSessionTimer) end)
	_G.Mod_AccSessionTimer = nil
end
_G.Mod_AccSessionTimer = Timer.StartLoop(1.0, -1, function()
	pcall(function()
		EnsureKqResultPanelUI()
		if not _G.Bot_Running or _G.Bot_PauseTask then
			return
		end
		LoadAccountTimeRecords(false)
		local srvId, email = ResolveCurrentSessionServerAndEmail()
		if srvId <= 0 or email == "" or email == "Unknown" then
			return
		end

		local key = string.format("S%d-%s", srvId, string.lower(email))
		if _G.Mod_CurrentTrackingKey ~= key then
			_G.Mod_CurrentTrackingKey = key
			_G.Mod_CurrentSessionSec = 0
		end
		_G.Mod_CurrentSessionSec = (_G.Mod_CurrentSessionSec or 0) + 1

		local rec = _G.Mod_AccTimeRecords[key]
		if not (rec and rec.done) then
			if not rec then
				rec = {
					key = key,
					serverId = srvId,
					email = email,
					elapsedSec = 0,
					done = false,
				}
				_G.Mod_AccTimeRecords[key] = rec
			end
			rec.elapsedSec = (tonumber(rec.elapsedSec) or 0) + 1
			if _G.Mod_KqPanelVisible and _G.Mod_RefreshKqPanelUI and (_G.Mod_CurrentSessionSec % 2 == 0) then
				_G.Mod_RefreshKqPanelUI()
			end
		end

		-- Hiển thị bộ đếm thời gian ra giữa màn hình mỗi 5s/lần (style thông báo Kundun xuất hiện)
		if _G.Mod_CurrentSessionSec % 5 == 0 then
			if rec and not rec.done then
				SaveAccountTimeRecords()
			end
			local curElapsed = (rec and rec.elapsedSec) or _G.Mod_CurrentSessionSec
			local doneTag = (rec and rec.done) and "(done)" or ""
			FlashAccTimeCenterAlert(string.format("S%d-%s: %s%s", srvId, email, FormatAccDuration(curElapsed), doneTag))
		end
	end)
end)

-- ====================================
-- [MOD FEATURE]: BỘ CHUYỂN TÀI KHOẢN TỰ ĐỘNG KHI ĐẠT LEVEL MỤC TIÊU (50)
-- Mô tả: Ghi nhận acc hoàn thành, logout và đăng nhập tài khoản tiếp theo trong danh sách.
-- ====================================
_G.IsSwitchingAccount = false
_G.OnAccountReachLevelGoal = function(lvl, targetLvl)
	if _G.IsSwitchingAccount then return end
	_G.IsSwitchingAccount = true
	_G.Mod_FarmKCActive = false
	if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
	if _G.StopFarmKCRoutine then pcall(_G.StopFarmKCRoutine) end
	if _G.BotQuestMonitorTimer then
		pcall(function() Timer.Stop(_G.BotQuestMonitorTimer) end)
		_G.BotQuestMonitorTimer = nil
	end
	if _G.Global30sUpgradeTimer then
		pcall(function() Timer.Stop(_G.Global30sUpgradeTimer) end)
		_G.Global30sUpgradeTimer = nil
	end
	local curAcc = GetCurrentAccount()
	local curAccEmail = curAcc.account or "Unknown"
	local curAccIdx = _G.CurrentAccountIndex or 1
	local totalAccs = (_G.BotAccounts and #_G.BotAccounts) or 1
	local sId, sName = _G.GetActualCurrentServerInfo()
	if _G.FinalizeAccountTimeOnGoal then
		_G.FinalizeAccountTimeOnGoal(curAccEmail, sId)
	end
	Log("=========================================================================", true)
	Log(string.format(">>> [HOÀN THÀNH MỤC TIÊU]: TÀI KHOẢN [%d/%d] %s ĐẠT LEVEL %d/%d TRÊN %s! <<<",
		curAccIdx, totalAccs, curAccEmail, lvl, targetLvl, tostring(sName)), true)
	Log("=========================================================================", true)
	SaveOutput()
	if _G.FloatingWordUtility and _G.FloatingWordUtility.QuickMsg then
		_G.FloatingWordUtility.QuickMsg(string.format("Hoàn tất %s (Lv %d)! Chuyển sang acc kế tiếp...", curAccEmail, lvl))
	end
	-- Ghi nhật ký vào file thành công
	pcall(function()
		local Application = CS.UnityEngine.Application
		local File = CS.System.IO.File
		local nowStr = os.date("%Y-%m-%d %H:%M:%S")
		local logLine = string.format("%s | STT: %04d | Email: %s | Server: %s | Level: %d\r\n",
			nowStr, curAccIdx, curAccEmail, tostring(sName), lvl)
		local outDir = Application.persistentDataPath
		File.AppendAllText(outDir .. "/farm_success_accounts.txt", logLine, CS.System.Text.Encoding.UTF8)
	end)
	local nextAccIdx = curAccIdx + 1
	if nextAccIdx <= totalAccs then
		_G.CurrentAccountIndex = nextAccIdx
		CS.UnityEngine.PlayerPrefs.SetInt("Mod_Farm_CurAccIndex", nextAccIdx)
		CS.UnityEngine.PlayerPrefs.Save()
		local nextAcc = GetCurrentAccount()
		Log(string.format(">>> [CHUYỂN TIẾP TÀI KHOẢN]: Chuyển sang Acc [%d/%d]: %s (Server: %s) <<<",
			nextAccIdx, totalAccs, nextAcc.account, tostring(sName)), true)
		SaveOutput()
		_G.CurrentRoleIndex = 1
		_G.TargetRoleIndex = 1
		_G.HasCreatedRoleForTarget = false
		_G.IsRoleCreating = false
		_G.Bot_IsInGameWorld = false
		Timer.Start(1.5, function()
			if ClearAllTaskDataAndState then ClearAllTaskDataAndState() end
			ForceLogoutToLogin()
			Timer.Start(3.0, function()
				_G.IsSwitchingAccount = false
				DismissBlockers()
				StartFullLoginProcess()
			end)
		end)
	else
		Log("=========================================================================", true)
		Log(string.format(">>> HOÀN THÀNH TẤT CẢ %d TÀI KHOẢN LÊN LEVEL %d TRÊN MÁY CHỦ %s! <<<", totalAccs, targetLvl, tostring(sName)), true)
		Log("=========================================================================", true)
		SaveOutput()
		_G.IsSwitchingAccount = false
		_G.StopAutoFarmBot()
		if _G.FloatingWordUtility and _G.FloatingWordUtility.QuickMsg then
			_G.FloatingWordUtility.QuickMsg(string.format("ĐÃ HOÀN THÀNH TẤT CẢ %d ACC LÊN LV %d!", totalAccs, targetLvl))
		end
	end
end
-- =========================================================================
-- [MOD FEATURE]: TỰ ĐỘNG MUA & HỌC ĐÁ KỸ NĂNG TẠI LV 80 VÀ LV 150
-- Mô tả:
--   - Tại Lv >= 80: Tự động mua & sử dụng đá "Thuật Hồn Thủ Hộ" (goodId=20432, itemId=4000690/4000190, skillId=12150101).
--   - Tại Lv >= 150: Tự động mua & sử dụng đá "Thuật Sóng Rồng Đen Lv.2" (goodId=204161, itemId=4001660/4001160, skillId=12120102).
-- =========================================================================
local function HasLearnedTargetSkill(targetSkillId, targetGroupId, targetLevel)
	local learned = false
	pcall(function()
		local me = _G.RoleManager and _G.RoleManager.me
		local skills = me and me.skills
		if not skills then return end
		for k, v in pairs(skills) do
			if type(v) == "table" then
				local sId = tonumber(v.id or v.skillId or (v.cfg and v.cfg.id) or 0) or 0
				local gId = tonumber((v.cfg and v.cfg.groupId) or v.groupId or math.floor(sId / 10000)) or 0
				local sLv = tonumber(v.level or (v.cfg and v.cfg.level) or (sId % 100)) or 0
				if sId == targetSkillId or (gId == targetGroupId and sLv >= targetLevel) then
					learned = true
					break
				end
			elseif tonumber(v) == targetSkillId or tonumber(k) == targetSkillId then
				learned = true
				break
			end
		end
	end)
	return learned
end

local function FindSkillStoneInBag(boundItemId, unboundItemId)
	local found = nil
	pcall(function()
		if not (_G.BagInfoData and _G.BagInfoData.TotalItems) then return end
		for _, item in pairs(_G.BagInfoData.TotalItems) do
			if item and item.id and (tonumber(item.count) or 1) > 0 then
				local cfgId = tonumber(item.itemId or (item.tblItem and item.tblItem.id) or 0) or 0
				if cfgId == boundItemId or cfgId == unboundItemId then
					found = item
					break
				end
			end
		end
	end)
	return found
end

local function UseSkillStoneFromBag(item, skillLabel)
	if not item or not item.id then return false end
	local cfgId = item.itemId or (item.tblItem and item.tblItem.id)
	Log(string.format(">>> [HỌC KỸ NĂNG]: Sử dụng đá kỹ năng [%s] (bagId=%s, itemId=%s) để học ngay! <<<",
		tostring(skillLabel), tostring(item.id), tostring(cfgId)), true)
	SaveOutput()
	pcall(function()
		if _G.BagInfoController and _G.BagInfoController.UseItemReq then
			_G.BagInfoController.UseItemReq(1, item.id, nil, cfgId)
		end
		if _G.networkRequest and _G.networkRequest.ReqUseItem then
			_G.networkRequest.ReqUseItem(1, item.id)
		elseif _G.NetManager and _G.BagMessage and _G.BagMessage.ReqUseItem then
			_G.NetManager.Send(_G.BagMessage.ReqUseItem, { itemId = item.id, count = 1, clientParams = {} })
		end
	end)
	return true
end

local function BuyAndUseSkillStone(goodId, boundItemId, unboundItemId, skillLabel, onUsedFlagKey)
	Log(string.format(">>> [MUA ĐÁ KỸ NĂNG]: Gửi gói mua [%s] từ Tiệm (goodId=%d)... <<<", tostring(skillLabel), goodId), true)
	SaveOutput()
	pcall(function()
		if _G.networkRequest and _G.networkRequest.ReqBuy then
			_G.networkRequest.ReqBuy(goodId, 1)
		elseif _G.NetManager and _G.ItemBuyMessage and _G.ItemBuyMessage.ReqBuy then
			_G.NetManager.Send(_G.ItemBuyMessage.ReqBuy, { goodId = goodId, buyCount = 1 })
		end
	end)
	if Timer and Timer.Start then
		Timer.Start(0.8, function()
			local stone = FindSkillStoneInBag(boundItemId, unboundItemId)
			if stone and UseSkillStoneFromBag(stone, skillLabel) and onUsedFlagKey then
				_G[onUsedFlagKey] = true
			end
		end)
	end
end

local function CheckAndAutoBuyLearnSkills(curLvl)
	if not _G.Bot_Running or _G.Bot_PauseTask then return end
	curLvl = tonumber(curLvl) or 1
	if curLvl < 80 then return end

	local nowTime = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
	if _G.Bot_LastSkillStoneBuyUseTime and (nowTime - _G.Bot_LastSkillStoneBuyUseTime) < 2.5 then
		return
	end
	_G.Bot_LastSkillStoneBuyUseTime = nowTime

	-- 1. Tại Lv >= 80: Mua & học đá kỹ năng "Thuật Hồn Thủ Hộ" (goodId=20432, itemId=4000690/4000190, skillId=12150101)
	if curLvl >= 80 and not _G.Bot_HasLearnedSoulBarrier100 then
		if HasLearnedTargetSkill(12150101, 1215, 1) then
			_G.Bot_HasLearnedSoulBarrier100 = true
		else
			local stone80 = FindSkillStoneInBag(4000690, 4000190)
			if stone80 then
				UseSkillStoneFromBag(stone80, "Thuật Hồn Thủ Hộ (Lv80)")
				_G.Bot_UsedSoulBarrierStone = true
			elseif _G.Bot_UsedSoulBarrierStone then
				_G.Bot_HasLearnedSoulBarrier100 = true
			elseif (_G.Bot_BuySoulBarrierCount or 0) < 3 then
				_G.Bot_BuySoulBarrierCount = (_G.Bot_BuySoulBarrierCount or 0) + 1
				BuyAndUseSkillStone(20432, 4000690, 4000190, "Thuật Hồn Thủ Hộ (Lv80)", "Bot_UsedSoulBarrierStone")
			end
		end
	end

	-- 2. Tại Lv >= 150: Mua & học đá kỹ năng "Thuật Sóng Rồng Đen Lv.2" (goodId=204161, itemId=4001660/4001160, skillId=12120102)
	if curLvl >= 150 and not _G.Bot_HasLearnedEvilSpiritLv2_150 then
		if HasLearnedTargetSkill(12120102, 1212, 2) then
			_G.Bot_HasLearnedEvilSpiritLv2_150 = true
		else
			if not HasLearnedTargetSkill(12120101, 1212, 1) then
				local stoneLv1 = FindSkillStoneInBag(4000660, 4000160)
				if stoneLv1 then
					UseSkillStoneFromBag(stoneLv1, "Thuật Sóng Rồng Đen Lv.1")
				else
					BuyAndUseSkillStone(20428, 4000660, 4000160, "Thuật Sóng Rồng Đen Lv.1", nil)
				end
			end
			local stone150 = FindSkillStoneInBag(4001660, 4001160)
			if stone150 then
				UseSkillStoneFromBag(stone150, "Thuật Sóng Rồng Đen Lv.2 (Lv150)")
				_G.Bot_UsedEvilSpiritLv2Stone = true
			elseif _G.Bot_UsedEvilSpiritLv2Stone then
				_G.Bot_HasLearnedEvilSpiritLv2_150 = true
			elseif (_G.Bot_BuyEvilSpiritLv2Count or 0) < 3 then
				_G.Bot_BuyEvilSpiritLv2Count = (_G.Bot_BuyEvilSpiritLv2Count or 0) + 1
				BuyAndUseSkillStone(204161, 4001660, 4001160, "Thuật Sóng Rồng Đen Lv.2 (Lv150)", "Bot_UsedEvilSpiritLv2Stone")
			end
		end
	end
end
_G.CheckAndAutoBuyLearnSkills = CheckAndAutoBuyLearnSkills

-- =========================================================================
-- [MOD FEATURE]: QUY TRÌNH BUG NHIỆM VỤ BOSS PHÚC LỢI TÂN THỦ TẠI LV 80 (50007 -> 5024 -> 3103)
-- Mô tả:
--   1. Tại Lv >= 80 (sau khi mở khóa bộ 3 nhiệm vụ 3103, 50007, 5024), vào đánh Nữ Hoàng Tân Thủ (210100100 - Map 2101000)
--      bằng cách kích hoạt làm nhiệm vụ qua UI (3103 / 50007 -> Arrest_BossUI:btn_goKillOnClick -> EnterSecret).
--   2. Đánh chết Nữ Hoàng Tân Thủ -> Đứng nguyên trong Map 2101000, mở khóa và nhận thưởng nhiệm vụ Treo Thưởng đầu tiên
--      "BOSS Treo Thưởng 1 Sao Băng Hậu" (50007) để nhận Nón đồ Bộ (2110007).
--   3. Mặc Nón đồ Bộ vào người -> Nhiệm vụ nhánh "Mặc 1 món Bộ Trang Bị" (5024) hoàn thành (state=2).
--      Ấn nhận thưởng nhiệm vụ 5024 ngay trong Map 2101000 -> Kiểm tra 5024 bị lag sang "Đang tiến hành (1/1)" (state=1).
--   4. Khi 5024 đã bị lag (state=1), ấn nhận thưởng nhiệm vụ "Tiêu diệt BOSS Phúc Lợi-Nữ Hoàng Băng Giá" (3103) ->
--      Kiểm tra 3103 bị lag sang "Đang tiến hành (1/1)" (state=1) và bật ngay chu trình Auto Farm KC!
-- =========================================================================
local function DoEnterNewbieBossViaQuest(callback)
	if not _G.Bot_Running or _G.Bot_PauseTask then return end
	if DismissBlockers then DismissBlockers() end

	Log("[Bug Quest Lv80] Kích hoạt vào Nữ Hoàng Tân Thủ (2101000) qua luồng làm nhiệm vụ (3103 / 50007)...", true)
	pcall(function()
		if _G.networkRequest then
			if _G.networkRequest.ReqGetBossMapAndCount then _G.networkRequest.ReqGetBossMapAndCount() end
			if _G.networkRequest.ReqInstanceCoolDown then _G.networkRequest.ReqInstanceCoolDown(1106) end
			if _G.networkRequest.ReqBossStateByType and _G.MonsterBossType then
				_G.networkRequest.ReqBossStateByType(_G.MonsterBossType.secretBoss)
			end
		end
		if _G.TaskManager and _G.TaskManager.TaskGo then
			_G.TaskManager.TaskGo(3103, (_G.TaskTriggeringConditionType and _G.TaskTriggeringConditionType.OnClick) or 1)
		end
		local taskUI = _G.UIManager and _G.UIManager.GetUiByName and (
			_G.UIManager.GetUiByName("Task_TaskUI")
			or (_G.UIID and _G.UIID.TaskUI and _G.UIManager.GetUiByName(_G.UIID.TaskUI))
		)
		if taskUI and taskUI.TaskItemClick then
			taskUI:TaskItemClick(50007)
		elseif _G.TaskData and _G.TaskData.OpenRewardsTask and _G.TaskData.AllTasks and _G.TaskData.AllTasks[50007] then
			_G.TaskData:OpenRewardsTask(_G.IndexerEnum and _G.IndexerEnum.set, _G.TaskData.AllTasks[50007])
			if _G.UIManager and _G.UIID and _G.UIID.Arrest_BossUI then
				_G.UIManager.Show(_G.UIID.Arrest_BossUI)
			end
		end
	end)

	local timerObj = _G.Timer or Timer
	if timerObj and timerObj.Start then
		timerObj.Start(0.4, function()
			if not _G.Bot_Running or _G.Bot_PauseTask then return end
			pcall(function()
				local clickedGoKill = false
				local arrestUI = _G.UIManager and _G.UIManager.GetUiByName and (
					(_G.UIID and _G.UIID.Arrest_BossUI and _G.UIManager.GetUiByName(_G.UIID.Arrest_BossUI))
					or _G.UIManager.GetUiByName("Arrest_BossUI")
				)
				if arrestUI and arrestUI.allTaskTab then
					local tab1 = arrestUI.allTaskTab[1]
					if tab1 and tab1.btn_goKillOnClick then
						tab1:btn_goKillOnClick()
						clickedGoKill = true
					end
				end
				if not clickedGoKill and _G.UIManager and _G.UIID then
					if _G.UIID.Arrest_BossUI then _G.UIManager.Hide(_G.UIID.Arrest_BossUI) end
					if _G.UIID.Instance_BossUI then
						_G.UIManager.Show(_G.UIID.Instance_BossUI, { Monsterid = 210100100 })
					end
				end
			end)

			timerObj.Start(0.5, function()
				if not _G.Bot_Running or _G.Bot_PauseTask then return end
				pcall(function()
					local bossUI = _G.UIManager and _G.UIManager.GetUiByName and (
						(_G.UIID and _G.UIID.Instance_BossUI and _G.UIManager.GetUiByName(_G.UIID.Instance_BossUI))
						or _G.UIManager.GetUiByName("Instance_BossUI")
					)
					local secretTemp = bossUI and bossUI.secretBossTemplate
					if secretTemp and secretTemp.EnterSecret then
						secretTemp:EnterSecret(210100001, { "31", "222" })
					elseif _G.PathFinderManager and _G.PathFinderManager.FlyTransferScene then
						_G.PathFinderManager.FlyTransferScene(210100001)
					end
					if _G.UIManager and _G.UIID then
						if _G.UIID.Instance_BossUI then _G.UIManager.Hide(_G.UIID.Instance_BossUI) end
						if _G.UIID.Arrest_BossUI then _G.UIManager.Hide(_G.UIID.Arrest_BossUI) end
					end
				end)
				if callback then
					timerObj.Start(2.0, function()
						if _G.Bot_Running and not _G.Bot_PauseTask then callback() end
					end)
				end
			end)
		end)
	elseif _G.DoEnterSecretRoom then
		_G.DoEnterSecretRoom(callback)
	end
end
_G.DoEnterNewbieBossViaQuest = DoEnterNewbieBossViaQuest

local function GetBountyTask50007Info()
	local foundTask, foundId, foundState = nil, nil, nil
	pcall(function()
		if not _G.TaskData then return end
		local t = _G.TaskData.GetTaskById and _G.TaskData.GetTaskById(50007)
		if not t and _G.TaskData.AllTasks then t = _G.TaskData.AllTasks[50007] end
		if not t and _G.TaskData.activeTasks then t = _G.TaskData.activeTasks[50007] end
		if not t and _G.TaskData.GetRewardsTask then
			local rList = _G.TaskData.GetRewardsTask()
			if rList then
				for _, rt in ipairs(rList) do
					local rId = rt and tonumber(rt.taskId or (rt.GetId and rt:GetId()))
					local rName = tostring((rt and rt.GetName and rt:GetName()) or "")
					if rId == 50007 or string.find(rName, "Băng Hậu") then
						t = rt
						break
					end
				end
			end
		end
		if t then
			foundTask = t
			foundId = tonumber(t.taskId or (t.GetId and t:GetId()) or 50007)
			foundState = tonumber((t.GetState and t:GetState()) or t.state or 0)
		end
	end)
	return foundTask, foundId, foundState
end
_G.GetBountyTask50007Info = GetBountyTask50007Info

local function GetWearSetTask5024Info()
	local foundTask, foundId, foundState = nil, nil, nil
	pcall(function()
		if not _G.TaskData then return end
		local t = _G.TaskData.GetTaskById and _G.TaskData.GetTaskById(5024)
		if not t and _G.TaskData.AllTasks then t = _G.TaskData.AllTasks[5024] end
		if not t and _G.TaskData.activeTasks then t = _G.TaskData.activeTasks[5024] end
		if not t and _G.TaskData.GetBranchTask then
			local bList = _G.TaskData.GetBranchTask()
			if bList then
				for _, bt in ipairs(bList) do
					local bId = bt and tonumber(bt.taskId or (bt.GetId and bt:GetId()))
					local bName = tostring((bt and bt.GetName and bt:GetName()) or "")
					if bId == 5024 or string.find(bName, "Mặc 1 ") then
						t = bt
						break
					end
				end
			end
		end
		if t then
			foundTask = t
			foundId = tonumber(t.taskId or (t.GetId and t:GetId()) or 5024)
			foundState = tonumber((t.GetState and t:GetState()) or t.state or 0)
		end
	end)
	return foundTask, foundId, foundState
end
_G.GetWearSetTask5024Info = GetWearSetTask5024Info

local function IsTaskGoalFinished(task)
	if not task then return false end
	local finished = false
	pcall(function()
		if task.GetTaskGola then
			if task:GetTaskGola() == nil then
				finished = true
				return
			end
		end
		local goals = task.goals or task.taskGoals
		if type(goals) == "table" and #goals > 0 then
			local allDone = true
			for _, g in ipairs(goals) do
				local cur = (g.GetCurFinishCount and g:GetCurFinishCount()) or g.curCount or 0
				local max = (g.GetCount and g:GetCount()) or g.count or 1
				if cur < max then
					allDone = false
					break
				end
			end
			if allDone then finished = true end
		end
	end)
	return finished
end
_G.IsTaskGoalFinished = IsTaskGoalFinished

local function EquipSetHelmet2110007()
	pcall(function()
		if AutoEquipBetterItems then AutoEquipBetterItems() end
		if _G.RoleEquipUtility and _G.RoleEquipUtility.AutoWearAll then
			_G.RoleEquipUtility.AutoWearAll()
		end
		if _G.BagInfoData and _G.BagInfoData.TotalItems then
			for _, item in pairs(_G.BagInfoData.TotalItems) do
				if item and item.id then
					local cfgId = tonumber(item.itemId or (item.tblItem and item.tblItem.id) or 0) or 0
					if cfgId == 2110007 then
						if _G.BagInfoController and _G.BagInfoController.UseItemReq then
							_G.BagInfoController.UseItemReq(1, item.id, nil, cfgId)
						end
						if _G.NetManager and _G.EquipMessage and _G.EquipMessage.ReqPutOnTheEquip then
							_G.NetManager.Send(_G.EquipMessage.ReqPutOnTheEquip, { position = 3, equipId = item.id })
						end
						break
					end
				end
			end
		end
	end)
end

-- Chỉ gửi lệnh AutoFight khi chưa bật hoặc chưa có mục tiêu sống để tránh nhấp nháy thanh máu Boss
local function EnsureAutoFightBossOnce()
	pcall(function()
		local me = _G.RoleManager and _G.RoleManager.me
		if not me then return end
		local af = me.meAutoFight
		local isAlreadyAuto = af and _G.AutoFightStrKey and (af.autoKey == _G.AutoFightStrKey.AutoFight)
		local curTarget = me.TargetAvatar or (me.GetTarget and me:GetTarget())
		local hasLiveTarget = curTarget and not curTarget.isDead and (not curTarget.hp or curTarget.hp > 0)
		if isAlreadyAuto and hasLiveTarget then
			return
		end
		if me.SetAutoTaskFight and _G.AutoFightStrKey then
			me:SetAutoTaskFight(_G.AutoFightStrKey.AutoFight)
		end
	end)
end
_G.EnsureAutoFightBossOnce = EnsureAutoFightBossOnce

-- Hàm nhận nhiệm vụ theo đúng cơ chế gây Lag (Đang tiến hành 1/1):
-- Gọi TaskItemClick + chỉ gửi Event.Task_BtnRewardClick / ReqCompleteTask (4007), TUYỆT ĐỐI KHÔNG gửi ReqSubmitTask (4005)
local function TriggerLagQuestClaim(targetId)
	pcall(function()
		if _G.UIManager and _G.UIManager.GetUI and _G.UIID and _G.UIID.Task_TaskUI then
			local okUI, taskUI = pcall(_G.UIManager.GetUI, _G.UIID.Task_TaskUI)
			if okUI and taskUI and taskUI.TaskItemClick then
				pcall(function() taskUI:TaskItemClick(targetId) end)
			end
		end
		local taskUI2 = _G.UIManager and _G.UIManager.GetUiByName and (
			_G.UIManager.GetUiByName("Task_TaskUI")
			or (_G.UIID and _G.UIID.TaskUI and _G.UIManager.GetUiByName(_G.UIID.TaskUI))
		)
		if taskUI2 and taskUI2.TaskItemClick then
			pcall(function() taskUI2:TaskItemClick(targetId) end)
		end
		if _G.EventManager and _G.Event and _G.Event.Task_BtnRewardClick then
			_G.EventManager.Dispatch(_G.Event.Task_BtnRewardClick, targetId)
		end
		if _G.NetManager and _G.TaskMessage and _G.TaskMessage.ReqCompleteTask then
			_G.NetManager.Send(_G.TaskMessage.ReqCompleteTask, { taskId = targetId })
		end
	end)
end
_G.TriggerLagQuestClaim = TriggerLagQuestClaim

-- =========================================================================
-- [MOD FEATURE]: BAY THẲNG VỀ BÃI FARM QUÁI TỐI ƯU TRONG LÚC CHỜ HỒI NỮ HOÀNG (FARM KC TỐI ƯU)
-- Mô tả:
--   1. Ngay khi đánh xong Nữ Hoàng (hoặc phòng trống), thoát phó bản 2101000 và bay thẳng (0ms ReqCallFlag/ReqTransmit)
--      về bãi quái tối ưu phù hợp với Cấp độ & Phòng thủ hiện tại của nhân vật (Lost Tower 1/2/7, Atlantis, Tarkan...).
--   2. Tự động bật AutoFight đánh quái + nhặt đồ liên tục trong suốt thời gian chờ Delay Nữ Hoàng (mặc định 20s).
--   3. Đủ số giây chờ, tắt HookAutoFight và bay trực tiếp từ bãi farm vào lại phòng Nữ Hoàng!
-- =========================================================================
local function TeleportToQueenFarmSpot(bestPt, targetMap)
	if not bestPt or not targetMap or targetMap <= 0 then return end
	local lineId = (_G.SceneData and _G.SceneData.line) or 1
	pcall(function()
		if _G.networkRequest and _G.networkRequest.ReqCallFlag then
			_G.networkRequest.ReqCallFlag(1, 0, targetMap, lineId, bestPt.x, bestPt.y, 0)
		end
		if _G.NetManager and _G.MapMessage and _G.MapMessage.ReqCallFlag then
			_G.NetManager.Send(_G.MapMessage.ReqCallFlag, {
				type = 1,
				rid = 0,
				mapId = targetMap,
				line = lineId,
				x = bestPt.x,
				y = bestPt.y,
				hostId = 0
			})
		end
		local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
		if curMap ~= targetMap and _G.networkRequest and _G.networkRequest.ReqTransmit then
			_G.networkRequest.ReqTransmit(targetMap, lineId, bestPt.x, bestPt.y)
		end
	end)
end

local function ExitQueenAndGoFarmSpot()
	_G.Bot_LastQueenFarmTeleTime = -10
	local bestPt, targetMap = nil, nil
	if GetBestMonsterFarmPoint then
		bestPt, targetMap = GetBestMonsterFarmPoint(2101000)
	end
	local delaySec = tonumber(_G.Mod_QueenDelaySec) or 20
	if bestPt and targetMap then
		Log(string.format("[Farm KC] Thoát phó bản -> Bay thẳng về bãi farm tối ưu: Map %d (%s: %d#%d) cày quái trong %ds...",
			tonumber(targetMap) or 0, tostring(bestPt.name or ""), bestPt.x or 0, bestPt.y or 0, delaySec), true)
	else
		Log(string.format("[Farm KC] Thoát phó bản -> Bay về bãi farm quái trong %ds...", delaySec), true)
	end
	SaveOutput()

	pcall(function()
		local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
		if (_G.TranScriptData and _G.TranScriptData.InTranscript) or curMap == 2101000 or curMap == 2101001 then
			if _G.TranScriptController and _G.TranScriptController.ReqExitInstance then
				_G.TranScriptController.ReqExitInstance()
			elseif _G.networkRequest and _G.networkRequest.ReqExitInstance then
				_G.networkRequest.ReqExitInstance()
			end
		end
	end)

	if bestPt and targetMap then
		TeleportToQueenFarmSpot(bestPt, targetMap)
	end
end
_G.ExitQueenAndGoFarmSpot = ExitQueenAndGoFarmSpot

local function TickFarmBetweenQueenRuns(farmKcStateTime)
	pcall(function()
		if VacuumAllMapDropItems then VacuumAllMapDropItems() end
		local delaySec = tonumber(_G.Mod_QueenDelaySec) or 20
		local t = tonumber(farmKcStateTime) or 0

		-- Trước khi bay vào lại phòng Nữ Hoàng 0.6s: Tắt HookAutoFight ngoài bãi để vào phòng khóa mục tiêu Boss mượt mà
		if t >= (delaySec - 0.6) then
			local me = _G.RoleManager and _G.RoleManager.me
			if me then
				if me.SetAutoHookFight then me:SetAutoHookFight(false) end
			end
			if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then
				_G.QiJiHelperData.SetAutoFightData(false)
			end
			return
		end

		local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
		if (curMap == 2101000 or curMap == 2101001) and t >= 1.0 then
			if _G.TranScriptController and _G.TranScriptController.ReqExitInstance then
				_G.TranScriptController.ReqExitInstance()
			elseif _G.networkRequest and _G.networkRequest.ReqExitInstance then
				_G.networkRequest.ReqExitInstance()
			end
		end

		local bestPt, targetMap = nil, nil
		if GetBestMonsterFarmPoint then
			bestPt, targetMap = GetBestMonsterFarmPoint(2101000)
		end
		if not bestPt or not targetMap or targetMap <= 0 then return end

		local me = _G.RoleManager and _G.RoleManager.me
		local pos = (me and me.cellPos) or (me and me.serverCoord)
		local dist = 999
		if curMap == targetMap and pos and pos.x and pos.y then
			dist = math.sqrt((tonumber(pos.x) - bestPt.x)^2 + (tonumber(pos.y) - bestPt.y)^2)
		end

		if curMap ~= targetMap or dist > 10 then
			if t >= 0.8 and (t - (_G.Bot_LastQueenFarmTeleTime or -10)) >= 1.5 then
				_G.Bot_LastQueenFarmTeleTime = t
				TeleportToQueenFarmSpot(bestPt, targetMap)
			end
		else
			-- Đã đứng tại bãi farm tối ưu: Bật AutoFight đánh quái (chỉ bật nếu chưa đánh để không ngắt chiêu)
			EnsureAutoFightBossOnce()
			if _G.QiJiHelperData and not _G.QiJiHelperData.isAutoFight and _G.QiJiHelperData.SetAutoFightData then
				_G.QiJiHelperData.SetAutoFightData(true)
			end
		end
	end)
end
_G.TickFarmBetweenQueenRuns = TickFarmBetweenQueenRuns

local function CheckAndRunQueenBossBugLv80(curLvl, targetLvl)
	if not _G.Mod_BugQuestActive or _G.Bot_QueenBugUnavailable or (tonumber(curLvl) or 0) < 80 then
		return false
	end

	if _G.CheckAndAutoBuyLearnSkills then _G.CheckAndAutoBuyLearnSkills(curLvl) end

	if _G.Bot_QueenBugState == "DONE" then
		_G.Mod_FarmKCActive = true
		if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
		if not _G.Mod_FarmKCRunning and _G.StartFarmKCRoutine then
			_G.StartFarmKCRoutine()
		end
		return true
	end

	local qTask, qTaskId, qState = nil, nil, nil
	if _G.GetQueenBranchTaskInfo then
		qTask, qTaskId, qState = _G.GetQueenBranchTaskInfo()
	end
	local t50007, id50007, s50007 = GetBountyTask50007Info()
	local t5024, id5024, s5024 = GetWearSetTask5024Info()

	-- Khi vừa đạt Lv 80, chờ hoàn thành chuỗi nhiệm vụ chính tuyến đến 3107 (Đến Lost Tower 2) để mở khóa 3103, 50007, 5024
	if _G.Bot_QueenBugState == "IDLE" then
		if qTask == nil and t50007 == nil then
			if curLvl > 101 then
				Log(string.format(">>> [LV %d - KHÔNG CÓ NV BUG NỮ HOÀNG]: Không tìm thấy NV 3103/50007 -> Chuyển sang cày bãi quái tốt nhất đến Lv %d! <<<",
					curLvl, targetLvl), true)
				SaveOutput()
				_G.Bot_QueenBugUnavailable = true
			end
			return false
		end

		-- Nhận diện nhanh: Nếu NV 3103 đã ở trạng thái lag Đang tiến hành (1/1, state=1) -> Bật thẳng Auto Farm KC!
		if qTask ~= nil and qState == 1 and (IsTaskGoalFinished(qTask) or (t5024 ~= nil and s5024 == 1 and IsTaskGoalFinished(t5024))) then
			Log("=========================================================================", true)
			Log(string.format(">>> [PHÁT HIỆN NV NỮ HOÀNG ĐÃ BUG (ĐANG TIẾN HÀNH 1/1) TẠI LV %d]: Kích hoạt ngay AUTO FARM KC đến Lv %d! <<<", curLvl, targetLvl), true)
			Log("=========================================================================", true)
			_G.Bot_QueenBugState = "DONE"
			_G.Mod_FarmKCActive = true
			if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
			if _G.StartFarmKCRoutine then _G.StartFarmKCRoutine() end
			return true
		end

		-- Nếu NV 5024 đã bị lag (state=1, 1/1) và NV 3103 đang chờ nhận thưởng (state=2) -> Chuyển thẳng sang Bước 4!
		if t5024 ~= nil and s5024 == 1 and IsTaskGoalFinished(t5024) and qTask ~= nil and qState == 2 then
			Log(">>> [PHÁT HIỆN NV 5024 ĐÃ BUG (ĐANG TIẾN HÀNH 1/1) & NV 3103 CHỜ HOÀN THÀNH]: Chuyển thẳng sang Bước 4 ấn hoàn thành NV 3103! <<<", true)
			_G.Bot_AllowClaimTask5024 = false
			_G.Bot_QueenBugState = "PHASE4_CLAIM_3103_AND_VERIFY"
			_G.Bot_QueenBugStateTime = 0
			_G.Bot_LastClaim3103AttemptTime = -10
			return true
		end

		-- Tạm dừng đánh quái ngoài bãi và khởi động quy trình Bug tại Lv 80
		pcall(function()
			local me = _G.RoleManager and _G.RoleManager.me
			if me then
				if me.StopMove then me:StopMove() end
				if me.SetAutoTaskFight and _G.AutoFightStrKey then me:SetAutoTaskFight(_G.AutoFightStrKey.UnAutoFight) end
				if me.SetAutoHookFight then me:SetAutoHookFight(false) end
				if me.meAutoFight and me.meAutoFight.SetAutoFightHookStart then me.meAutoFight:SetAutoFightHookStart(false) end
			end
			if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then _G.QiJiHelperData.SetAutoFightData(false) end
		end)

		if qTask and qState == 0 and _G.networkRequest and _G.networkRequest.ReqAcceptTask then
			pcall(function() _G.networkRequest.ReqAcceptTask(qTaskId or 3103) end)
		end
		if t50007 and s50007 == 0 and _G.networkRequest and _G.networkRequest.ReqAcceptTask then
			pcall(function() _G.networkRequest.ReqAcceptTask(id50007 or 50007) end)
		end
		if t5024 and s5024 == 0 and _G.networkRequest and _G.networkRequest.ReqAcceptTask then
			pcall(function() _G.networkRequest.ReqAcceptTask(id5024 or 5024) end)
		end

		if qState == 2 then
			if t50007 ~= nil and s50007 == 2 then
				_G.Bot_QueenBugState = "PHASE2_CLAIM_BOUNTY_50007"
			else
				_G.Bot_QueenBugState = "PHASE3_WEAR_SET_AND_CLAIM_5024"
			end
		else
			_G.Bot_QueenBugState = "PHASE1_ENTER_NEWBIE_BOSS"
		end
		_G.Bot_QueenBugStateTime = 0
		_G.Bot_LastClaim50007AttemptTime = -10
		_G.Bot_LastClaim5024AttemptTime = -10
		_G.Bot_LastClaim3103AttemptTime = -10
		Log("=========================================================================", true)
		Log(string.format(">>> [BẮT ĐẦU BUG QUEST TẠI LV %d]: Chuyển sang trạng thái %s! <<<", curLvl, tostring(_G.Bot_QueenBugState)), true)
		Log("=========================================================================", true)
		SaveOutput()
		return true
	end

	-- Tạm dừng AutoTask mặc định của game trong lúc chạy kịch bản Bug Nữ Hoàng
	pcall(function()
		if _G.AutoTaskManage then
			if _G.AutoTaskManage.SetAutoTask then _G.AutoTaskManage.SetAutoTask(false) end
			if _G.AutoTaskManage.SetCurAutoTaskState then _G.AutoTaskManage.SetCurAutoTaskState(false) end
		end
		if _G.TaskManager and _G.TaskManager.TaskPathStop then
			_G.TaskManager.TaskPathStop()
		end
	end)

	local dt = 0.3
	_G.Bot_QueenBugStateTime = (_G.Bot_QueenBugStateTime or 0) + dt

	-- -------------------------------------------------------------------------
	-- BƯỚC 1: VÀO ĐÁNH NỮ HOÀNG TÂN THỦ (210100100 - MAP 2101000) QUA LUỒNG LÀM NHIỆM VỤ
	-- -------------------------------------------------------------------------
	if _G.Bot_QueenBugState == "PHASE1_ENTER_NEWBIE_BOSS" then
		_G.Bot_QueenBugState = "PHASE1_FIGHT_NEWBIE_BOSS"
		_G.Bot_QueenBugStateTime = 0
		_G.Bot_QueenBugActiveBoss = nil
		DoEnterNewbieBossViaQuest(function()
			pcall(function()
				if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.SetAutoTaskFight and _G.AutoFightStrKey then
					_G.RoleManager.me:SetAutoTaskFight(_G.AutoFightStrKey.AutoFight)
				end
			end)
		end)
		return true

	elseif _G.Bot_QueenBugState == "PHASE1_FIGHT_NEWBIE_BOSS" then
		if qState == 2 or (t50007 ~= nil and s50007 == 2) then
			if VacuumAllMapDropItems then VacuumAllMapDropItems() end
			Log(">>> [BƯỚC 1 HOÀN TẤT]: Đã tiêu diệt Nữ Hoàng Tân Thủ! Giữ nguyên trong Map 2101000 -> Nhận thưởng NV Treo Thưởng Băng Hậu (50007)! <<<", true)
			SaveOutput()
			_G.Bot_QueenBugState = "PHASE2_CLAIM_BOUNTY_50007"
			_G.Bot_QueenBugStateTime = 0
			_G.Bot_LastClaim50007AttemptTime = -10
			return true
		end

		local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
		if curMap == 2101000 then
			local boss = _G.FindBossNuHoangBangGia and _G.FindBossNuHoangBangGia()
			if boss and boss.hp and boss.hp > 0 then
				_G.Bot_QueenBugActiveBoss = boss
				EnsureAutoFightBossOnce()
			elseif _G.Bot_QueenBugActiveBoss then
				local isAlive = false
				pcall(function()
					if _G.Bot_QueenBugActiveBoss.hp and _G.Bot_QueenBugActiveBoss.hp > 0 and not _G.Bot_QueenBugActiveBoss.isDead then
						isAlive = true
					end
				end)
				if not isAlive then
					if VacuumAllMapDropItems then VacuumAllMapDropItems() end
					Log(">>> [BƯỚC 1 HOÀN TẤT]: Nữ Hoàng Tân Thủ (210100100) đã chết! Chuyển sang nhận thưởng NV Treo Thưởng Băng Hậu (50007)! <<<", true)
					SaveOutput()
					_G.Bot_QueenBugState = "PHASE2_CLAIM_BOUNTY_50007"
					_G.Bot_QueenBugStateTime = 0
					_G.Bot_LastClaim50007AttemptTime = -10
					return true
				end
			end
		elseif _G.Bot_QueenBugStateTime >= 10.0 then
			_G.Bot_QueenBugState = "PHASE1_ENTER_NEWBIE_BOSS"
			_G.Bot_QueenBugStateTime = 0
		end
		return true

	-- -------------------------------------------------------------------------
	-- BƯỚC 2: NHẬN THƯỞNG NHIỆM VỤ TREO THƯỞNG 1 SAO BĂNG HẬU (50007) ĐỂ LẤY NÓN ĐỒ BỘ (2110007)
	-- -------------------------------------------------------------------------
	elseif _G.Bot_QueenBugState == "PHASE2_CLAIM_BOUNTY_50007" then
		if VacuumAllMapDropItems then VacuumAllMapDropItems() end
		local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
		if curMap ~= 2101000 then
			if _G.Bot_QueenBugStateTime < 0.5 or _G.Bot_QueenBugStateTime >= 5.0 then
				_G.Bot_QueenBugStateTime = 0.5
				DoEnterNewbieBossViaQuest()
			end
			return true
		end

		-- Nếu đã nhận xong 50007 (50007 biến mất / chuyển sang 50008, hoặc s5024 đã hoàn thành 1/1)
		if s5024 == 2 or (t5024 ~= nil and IsTaskGoalFinished(t5024)) or t50007 == nil or s50007 == 3 or (_G.Bot_HasClaimed50007Once and s50007 ~= 2 and _G.Bot_QueenBugStateTime >= 3.0) then
			_G.Bot_AllowClaimTask50007 = false
			Log(">>> [BƯỚC 2 HOÀN TẤT]: Đã nhận thưởng NV Treo Thưởng 1 Sao Băng Hậu (50007) -> Mặc Nón đồ Bộ & Bug NV 5024! <<<", true)
			SaveOutput()
			_G.Bot_QueenBugState = "PHASE3_WEAR_SET_AND_CLAIM_5024"
			_G.Bot_QueenBugStateTime = 0
			_G.Bot_LastClaim5024AttemptTime = -10
			return true
		end

		if _G.Bot_QueenBugStateTime >= 1.2 and (_G.Bot_QueenBugStateTime - (_G.Bot_LastClaim50007AttemptTime or -10)) >= 2.0 then
			_G.Bot_LastClaim50007AttemptTime = _G.Bot_QueenBugStateTime
			local target50007Id = id50007 or 50007
			Log(string.format(">>> [BƯỚC 2 - NHẬN THƯỞNG TREO THƯỞNG]: Mở khóa & nhận thưởng NV Treo Thưởng Băng Hậu (ID %s) lấy Nón đồ Bộ (2110007)... <<<", tostring(target50007Id)), true)
			SaveOutput()

			_G.Bot_AllowClaimTask50007 = true
			_G.Bot_HasClaimed50007Once = true
			pcall(function()
				local taskUI = _G.UIManager and _G.UIManager.GetUiByName and (
					_G.UIManager.GetUiByName("Task_TaskUI")
					or (_G.UIID and _G.UIID.TaskUI and _G.UIManager.GetUiByName(_G.UIID.TaskUI))
				)
				if taskUI and taskUI.TaskItemClick then
					taskUI:TaskItemClick(target50007Id)
				end
				local arrestUI = _G.UIManager and _G.UIManager.GetUiByName and (
					(_G.UIID and _G.UIID.Arrest_BossUI and _G.UIManager.GetUiByName(_G.UIID.Arrest_BossUI))
					or _G.UIManager.GetUiByName("Arrest_BossUI")
				)
				if arrestUI and arrestUI.allTaskTab then
					for _, tab in pairs(arrestUI.allTaskTab) do
						if tab and tab.btn_getItemOnClick then
							pcall(function() tab:btn_getItemOnClick() end)
						end
					end
				end
				if _G.EventManager and _G.Event then
					if _G.Event.Task_BtnRewardClick then _G.EventManager.Dispatch(_G.Event.Task_BtnRewardClick, target50007Id) end
					if _G.Event.Task_BtnSubmitClick then _G.EventManager.Dispatch(_G.Event.Task_BtnSubmitClick, target50007Id) end
				end
				if _G.networkRequest then
					if _G.networkRequest.ReqCompleteTask then _G.networkRequest.ReqCompleteTask(target50007Id) end
					if _G.networkRequest.ReqSubmitTask then _G.networkRequest.ReqSubmitTask(target50007Id) end
				end
				if _G.NetManager and _G.TaskMessage then
					if _G.TaskMessage.ReqCompleteTask then _G.NetManager.Send(_G.TaskMessage.ReqCompleteTask, { taskId = target50007Id, id = target50007Id }) end
					if _G.TaskMessage.ReqSubmitTask then _G.NetManager.Send(_G.TaskMessage.ReqSubmitTask, { taskId = target50007Id, id = target50007Id }) end
				end
				if _G.UIManager and _G.UIID and _G.UIID.Arrest_BossUI then
					_G.UIManager.Hide(_G.UIID.Arrest_BossUI)
				end
			end)
			_G.Bot_AllowClaimTask50007 = false
		end
		return true

	-- -------------------------------------------------------------------------
	-- BƯỚC 3: MẶC NÓN ĐỒ BỘ (2110007), ẤN NHẬN THƯỞNG NV "MẶC 1 MÓN BỘ TRANG BỊ" (5024) & KIỂM TRA LAG (1/1)
	-- -------------------------------------------------------------------------
	elseif _G.Bot_QueenBugState == "PHASE3_WEAR_SET_AND_CLAIM_5024" then
		local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
		if curMap ~= 2101000 then
			if _G.Bot_QueenBugStateTime < 0.5 or _G.Bot_QueenBugStateTime >= 5.0 then
				_G.Bot_QueenBugStateTime = 0.5
				DoEnterNewbieBossViaQuest()
			end
			return true
		end

		EquipSetHelmet2110007()

		-- Kiểm tra tính bug của nhiệm vụ 5024: Sau khi ấn nhận thưởng, 5024 chuyển về state == 1 (Đang tiến hành 1/1)
		if _G.Bot_HasAttemptedClaim5024 and _G.Bot_QueenBugStateTime >= 1.2 and (s5024 == 1 or not t5024) then
			_G.Bot_AllowClaimTask5024 = false
			Log("=========================================================================", true)
			Log(string.format(">>> [BƯỚC 3 HOÀN TẤT - BUG NV MẶC 1 MÓN BỘ TRANG BỊ (5024) THÀNH CÔNG]: Trạng thái Đang Tiến Hành (1/1, state=%s)! Chuyển sang ấn hoàn thành NV Boss Phúc Lợi (3103)... <<<", tostring(s5024)), true)
			Log("=========================================================================", true)
			SaveOutput()
			_G.Bot_QueenBugState = "PHASE4_CLAIM_3103_AND_VERIFY"
			_G.Bot_QueenBugStateTime = 0
			_G.Bot_LastClaim3103AttemptTime = -10
			return true
		end

		local target5024Id = id5024 or 5024
		if s5024 == 2 or IsTaskGoalFinished(t5024) or _G.Bot_QueenBugStateTime >= 2.0 then
			if (_G.Bot_QueenBugStateTime - (_G.Bot_LastClaim5024AttemptTime or -10)) >= 2.0 then
				_G.Bot_LastClaim5024AttemptTime = _G.Bot_QueenBugStateTime
				Log("=========================================================================", true)
				Log(string.format(">>> [BƯỚC 3 - BUG NV MẶC 1 MÓN BỘ TRANG BỊ]: Đã mặc Nón đồ Bộ -> Ấn nhận thưởng NV 5024 (state=%s) tại Map 2101000 để gây lag! <<<", tostring(s5024)), true)
				Log("=========================================================================", true)
				SaveOutput()

				_G.Bot_AllowClaimTask5024 = true
				_G.Bot_HasAttemptedClaim5024 = true
				TriggerLagQuestClaim(target5024Id)
				if Timer and Timer.Start then
					Timer.Start(0.25, function() _G.Bot_AllowClaimTask5024 = false end)
				else
					_G.Bot_AllowClaimTask5024 = false
				end
			end
		end
		return true

	-- -------------------------------------------------------------------------
	-- BƯỚC 4: ẤN NHẬN THƯỞNG NV BOSS PHÚC LỢI TÂN THỦ (3103), KIỂM TRA LAG (1/1) & BẬT AUTO FARM KC
	-- -------------------------------------------------------------------------
	elseif _G.Bot_QueenBugState == "PHASE4_CLAIM_3103_AND_VERIFY" then
		if qState == 1 and _G.Bot_QueenBugStateTime >= 0.5 then
			_G.Bot_AllowClaimTask3103 = false
			_G.Bot_AllowClaimTask5024 = false
			_G.Bot_AllowClaimTask50007 = false
			_G.Bot_QueenBugState = "DONE"
			_G.Mod_FarmKCActive = true
			if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
			Log("=========================================================================", true)
			Log(string.format(">>> [BƯỚC 4 HOÀN TẤT - BUG NV BOSS PHÚC LỢI TÂN THỦ (3103) THÀNH CÔNG]: Trạng thái hiển thị Đang Tiến Hành (1/1, state=%s)! Bật quy trình AUTO FARM KC đến Lv %d! <<<", tostring(qState), targetLvl), true)
			Log("=========================================================================", true)
			SaveOutput()
			if _G.StartFarmKCRoutine then
				_G.StartFarmKCRoutine()
			end
			return true
		end

		if (_G.Bot_QueenBugStateTime - (_G.Bot_LastClaim3103AttemptTime or -10)) >= 2.5 then
			_G.Bot_LastClaim3103AttemptTime = _G.Bot_QueenBugStateTime
			local target3103Id = qTaskId or 3103
			Log("=========================================================================", true)
			Log(string.format(">>> [BƯỚC 4 - BUG BOSS PHÚC LỢI TÂN THỦ]: NV 5024 đã bị lag -> Ấn hoàn thành NV Boss Phúc Lợi Tân Thủ (ID %s) theo kiểu gây lag và kiểm tra tính bug... <<<", tostring(target3103Id)), true)
			Log("=========================================================================", true)
			SaveOutput()

			_G.Bot_AllowClaimTask3103 = true
			TriggerLagQuestClaim(target3103Id)
			if Timer and Timer.Start then
				Timer.Start(0.25, function() _G.Bot_AllowClaimTask3103 = false end)
			else
				_G.Bot_AllowClaimTask3103 = false
			end
		end
		return true
	end

	return false
end
_G.CheckAndRunQueenBossBugLv80 = CheckAndRunQueenBossBugLv80
CheckAndRunQueenBossBug = CheckAndRunQueenBossBugLv80
_G.CheckAndRunQueenBossBug = CheckAndRunQueenBossBugLv80

StartNewbieQuestPipeline = function()
	if not _G.Bot_Running or _G.Bot_PauseTask then
		return
	end
	local pMe = _G.RoleManager and _G.RoleManager.me
	local currentLevel = (pMe and pMe.level) or (pMe and pMe.data and pMe.data.level) or 1
	-- CHỈ KÍCH HOẠT CHU KỲ NÂNG CẤP & THU HỒI ĐỒ ĐỊNH KỲ SAU LEVEL 20:
	if currentLevel >= 20 then
		StartGlobal30sUpgradePipeline()
		if SolveBranchAndRewardsTasks then SolveBranchAndRewardsTasks() end
		RunPeriodicUpgradeCycle()
	end
	Log("=========================================================================")
	Log(string.format(">>> [VÒNG LẶP CHÍNH 1S/LẦN: LEVEL %s] ƯU TIÊN QUÉT VÀ HOÀN THÀNH TẤT CẢ QUEST! <<<", tostring(currentLevel)), true)
	Log("=========================================================================")
	SaveOutput()
	pcall(function()
		if _G.AutoTaskManage then
			_G.AutoTaskManage.SetAutoTask(true)
			_G.AutoTaskManage.StartCurAutoTask(true)
		end
	end)
	if _G.BotQuestMonitorTimer then
		pcall(function() Timer.Stop(_G.BotQuestMonitorTimer) end)
		_G.BotQuestMonitorTimer = nil
	end
	local loopTickCount = 0
	_G.BotQuestMonitorTimer = Timer.StartLoop(0.3, -1, function()
		pcall(function()
			if not _G.Bot_Running or _G.Bot_PauseTask or _G.Mod_IsRunningInstance then
				return
			end
			-- Luôn quét dọn popup và tự động bấm nhận thưởng tức thì (<0.3s, không chờ đếm ngược 5s)
			DismissBlockers()
			local me = _G.RoleManager and _G.RoleManager.me
			local lvl = (me and me.level) or (me and me.data and me.data.level) or 1
			local targetLvl = CS.UnityEngine.PlayerPrefs.GetInt("Mod_Farm_TargetLevel", 50)
			-- KIỂM TRA MỤC TIÊU CẤP ĐỘ FARM BOT (MẶC ĐỊNH LV 50):
			if lvl >= targetLvl then
				_G.OnAccountReachLevelGoal(lvl, targetLvl)
				return
			end
			-- ====================================
			-- [MOD FEATURE]: ƯU TIÊN TUYỆT ĐỐI CHẾ ĐỘ FARM KIM CƯƠNG KHI BẬT NÚT FARM KC
			-- Mô tả: Tạm dừng toàn bộ chu trình làm quest chính để tập trung săn Boss Phúc Lợi Tầng 1
			-- ====================================
			if _G.Mod_FarmKCActive then
				if SolveBranchAndRewardsTasks then SolveBranchAndRewardsTasks() end
				if not _G.Mod_FarmKCRunning and _G.StartFarmKCRoutine then
					_G.StartFarmKCRoutine()
				end
				return
			end
			-- ====================================
			-- [GIAI ĐOẠN TÂN THỦ LV 1 -> 9]:
			-- Tập trung bám sát chuỗi nhiệm vụ tân thủ (Main Quest) tự động tương tác NPC.
			-- Các tính năng nâng cao (Giftcode >= 10, Cường hóa >= 20, Phó bản >= 100)
			-- đều đã có điều kiện kiểm tra cấp độ riêng bên dưới.
			-- ====================================
			-- ====================================
			-- [GIAI ĐOẠN ĐẠT LEVEL 10+]:
			-- Kích hoạt nhập 14 mã Giftcode (chỉ chạy 1 lần khi đạt Lv 10)
			-- ====================================
			if lvl >= 10 and not _G.Bot_HasEnteredGiftcodes and not _G.AutoGiftCodeRunning then
				_G.Bot_HasEnteredGiftcodes = true
				_G.AutoGiftCodeRunning = true
				Log("=========================================================================")
				Log(string.format(">>> ĐẠT LEVEL %d: BẮT ĐẦU TỰ ĐỘNG NHẬP 14 MÃ GIFTCODE VÀ GHI BÁO CÁO <<<", lvl), true)
				Log("=========================================================================")
				SaveOutput()
				if RunAutoGiftcode then
					RunAutoGiftcode(function()
						_G.AutoGiftCodeRunning = false
					end)
				end
			end
			-- KÍCH HOẠT NÂNG CẤP 30S KHI ĐẠT LEVEL 20+:
			if lvl >= 20 and not _G.Global30sUpgradeTimer then
				StartGlobal30sUpgradePipeline()
			end
			loopTickCount = loopTickCount + 1
			if _G.Mod_AutoBCDSActive and loopTickCount % 50 == 0 and not _G.Mod_IsRunningInstance then
				CheckAndRunBloodCastleOrDemonPlaza()
			end
			AutoAddAttributePoints()
			if lvl >= 80 and CheckAndAutoBuyLearnSkills then
				CheckAndAutoBuyLearnSkills(lvl)
			end
			-- Quét dùng Thẻ Đặc Quyền & Thuốc Tăng EXP & Nhận Phúc Lợi Cộng Đồng mỗi 5s
			if loopTickCount % 5 == 0 then
				if _G.Mod_UpdateServerStatusUI then pcall(_G.Mod_UpdateServerStatusUI) end
				if AutoUsePrivilegeCard then AutoUsePrivilegeCard() end
				if AutoUseExpMedicine then AutoUseExpMedicine() end
				if lvl >= 30 and AutoClaimCommunityWelfareAndMail then
					AutoClaimCommunityWelfareAndMail()
				end
			end
			-- Kích hoạt nhận lại toàn bộ phúc lợi cộng đồng tại Level 60, 70 và 100
			if (lvl >= 60 and not _G.Bot_ClaimedCommunityLvl60) then
				_G.Bot_ClaimedCommunityLvl60 = true
				Log(">>> [MỐC LEVEL 60]: Quét nhận lại toàn bộ Phúc Lợi Cộng Đồng & Hòm Thư! <<<", true)
				if AutoClaimCommunityWelfareAndMail then AutoClaimCommunityWelfareAndMail() end
			end
			if (lvl >= 60 and not _G.Bot_ClaimedOpenServerPackLvl60) then
				_G.Bot_ClaimedOpenServerPackLvl60 = true
				Log(">>> [MỐC LEVEL 60]: Kích hoạt kiểm tra Quà Mở SV (Quà Thuốc 120 KC - Thuốc Tăng EXP 12h)! <<<", true)
				if AutoBuyNewServerExpMedicinePack then AutoBuyNewServerExpMedicinePack() end
				if AutoUseExpMedicine then AutoUseExpMedicine() end
			end
			if (lvl >= 65 and not _G.Bot_ClaimedDiamondPackLvl65) then
				_G.Bot_ClaimedDiamondPackLvl65 = true
				Log(">>> [MỐC LEVEL 65]: Kích hoạt kiểm tra Quà Phúc Lợi Kim Cương I (180 KC)! <<<", true)
				if AutoBuyDailyDiamondGiftPacks then AutoBuyDailyDiamondGiftPacks() end
			end
			if (lvl >= 100 and not _G.Bot_ClaimedCommunityLvl100) then
				_G.Bot_ClaimedCommunityLvl100 = true
				Log(">>> [MỐC LEVEL 100]: Quét nhận các mốc Phúc Lợi Cộng Đồng Cao Cấp (Theo dõi FB 250 KC, Tham gia Nhóm) & Hòm Thư! <<<", true)
				if AutoClaimCommunityWelfareAndMail then AutoClaimCommunityWelfareAndMail() end
			end
			if (lvl >= 101 and not _G.Bot_ClaimedUpgradePacksLvl101) then
				_G.Bot_ClaimedUpgradePacksLvl101 = true
				Log('>>> [MOC LEVEL 99]: Dung KC Khoa mua goi nang cap (Mo SV / Phuc Loi Ngay) & Dap do toi da truoc khi danh Nu Hoang! <<<', true)
				if AutoClaimCommunityWelfareAndMail then
					AutoClaimCommunityWelfareAndMail(function()
						if RunPeriodicUpgradeCycle then RunPeriodicUpgradeCycle() end
					end)
				elseif AutoBuyNewServerExpMedicinePack then
					AutoBuyNewServerExpMedicinePack(function()
						if AutoBuyDailyDiamondGiftPacks then AutoBuyDailyDiamondGiftPacks() end
						if RunPeriodicUpgradeCycle then RunPeriodicUpgradeCycle() end
					end)
				end
			end
			-- Chu trình nâng cấp chạy định kỳ qua Global Timer, không chặn pipeline làm quest
			if _G.Mod_IsRunningInstance then
				return
			end
			if SolveBranchAndRewardsTasks then SolveBranchAndRewardsTasks() end
			if _G.Mod_BugQuestActive and lvl >= 80 and CheckAndRunQueenBossBug then
				if CheckAndRunQueenBossBug(lvl, targetLvl) then
					return
				end
			end
			-- ====================================
			-- [CLAIM TẤT CẢ NHIỆM VỤ ĐÃ HOÀN THÀNH (CHÍNH, NHÁNH, THƯỞNG) 1S/LẦN]
			-- ====================================
			pcall(function()
				if _G.TaskData and _G.TaskData.activeTasks then
					local nowSec = os.time()
					_G.ClaimedTaskCooldown = _G.ClaimedTaskCooldown or {}
					for tId, task in pairs(_G.TaskData.activeTasks) do
						if task and tId ~= 80101 and not IsTaskBlockedFromAutoClaim(tId, task) then
							local tType = (task.GetTaskTypeID and task:GetTaskTypeID()) or 0
							if tType < 14 then
								local s = (task.GetState and task:GetState()) or task.state or 0
								if s == (_G.TaskStateType and _G.TaskStateType.Completed or 2) or s == 2 then
									if not _G.ClaimedTaskCooldown[tId] or (nowSec - _G.ClaimedTaskCooldown[tId] >= 8) then
										_G.ClaimedTaskCooldown[tId] = nowSec
										Log(string.format("-> [CLAIM TỨC THÌ TASK %s]: Đã hoàn thành! Nộp và nhận thưởng ngay...", tostring(tId)), true)
										if _G.networkRequest then
											if _G.networkRequest.ReqCompleteTask then _G.networkRequest.ReqCompleteTask(tId) end
											if _G.networkRequest.ReqSubmitTask then _G.networkRequest.ReqSubmitTask(tId) end
										end
										if _G.NetManager and _G.TaskMessage then
											if _G.TaskMessage.ReqCompleteTask then _G.NetManager.Send(_G.TaskMessage.ReqCompleteTask, { taskId = tId, id = tId }) end
											if _G.TaskMessage.ReqSubmitTask then _G.NetManager.Send(_G.TaskMessage.ReqSubmitTask, { taskId = tId, id = tId }) end
										end
										if _G.EventManager and _G.Event then
											if _G.Event.Task_BtnRewardClick then _G.EventManager.Dispatch(_G.Event.Task_BtnRewardClick, tId) end
											if _G.Event.Task_BtnSubmitClick then _G.EventManager.Dispatch(_G.Event.Task_BtnSubmitClick, tId) end
										end
										if _G.TaskManager and _G.TaskManager.TaskGo then
											_G.TaskManager.TaskGo(tId, _G.TaskTriggeringConditionType and _G.TaskTriggeringConditionType.OnClick or 0)
										end
										local taskUI = _G.UIManager and _G.UIManager.GetUiByName and (_G.UIManager.GetUiByName("Task_TaskUI") or (_G.UIID and _G.UIManager.GetUiByName(_G.UIID.TaskUI)))
										if taskUI and taskUI.TaskItemClick then
											taskUI:TaskItemClick(tId)
										end
									end
								end
							end
						end
					end
				end
			end)
			if _G.TaskData then
				local curTask = _G.TaskData.GetOrderMainTask and _G.TaskData.GetOrderMainTask()
				if not curTask and _G.TaskData.activeTasks then
					for _, t in pairs(_G.TaskData.activeTasks) do
						if t and t.GetTaskTypeID and (t:GetTaskTypeID() == (_G.RoleTaskType and _G.RoleTaskType.MainTask or 1) or t:GetTaskTypeID() == 15) then
							curTask = t
							break
						end
					end
				end
				if curTask then
					local taskId = curTask.taskId or (curTask.GetId and curTask:GetId()) or 0
					local state = (curTask.GetState and curTask:GetState()) or curTask.state or 0
					local taskDes = (curTask.GetDes and curTask:GetDes()) or ""
					local taskName = (curTask.GetName and curTask:GetName()) or ""
					if (state == (_G.TaskStateType and _G.TaskStateType.Completed or 2) or state == 2 or state == 3) and IsTaskBlockedFromAutoClaim(taskId, curTask) then
						state = (_G.TaskStateType and _G.TaskStateType.Accept) or 1
					end
					-- 1. TRẠNG THÁI HOÀN THÀNH (Completed = 2 hoặc 3): Nộp & Nhận thưởng ngay
					if state == (_G.TaskStateType and _G.TaskStateType.Completed or 2) or state == 2 or state == 3 then
						_G.Bot_CurrentTaskId = 0
						_G.Bot_LastTaskNavTime = 0
						Log(string.format("-> [TRẢ THƯỞNG TASK %s]: Đã hoàn thành! Nộp và nhận thưởng...", tostring(taskId)), true)
						pcall(function()
							if _G.networkRequest then
								if _G.networkRequest.ReqCompleteTask then _G.networkRequest.ReqCompleteTask(taskId) end
								if _G.networkRequest.ReqSubmitTask then _G.networkRequest.ReqSubmitTask(taskId) end
							end
							if _G.NetManager and _G.TaskMessage then
								if _G.TaskMessage.ReqCompleteTask then _G.NetManager.Send(_G.TaskMessage.ReqCompleteTask, { taskId = taskId, id = taskId }) end
								if _G.TaskMessage.ReqSubmitTask then _G.NetManager.Send(_G.TaskMessage.ReqSubmitTask, { taskId = taskId, id = taskId }) end
							end
							if _G.EventManager and _G.Event then
								if _G.Event.Task_BtnRewardClick then _G.EventManager.Dispatch(_G.Event.Task_BtnRewardClick, taskId) end
								if _G.Event.Task_BtnSubmitClick then _G.EventManager.Dispatch(_G.Event.Task_BtnSubmitClick, taskId) end
							end
							-- Tìm đường đến NPC nộp nếu cần
							if _G.TaskManager and _G.TaskManager.TaskGo then
								_G.TaskManager.TaskGo(taskId, _G.TaskTriggeringConditionType and _G.TaskTriggeringConditionType.OnClick or 0)
							end
							if _G.AutoTaskManage and _G.AutoTaskManage.StartCurAutoTask then
								_G.AutoTaskManage.StartCurAutoTask(true)
							end
						end)
						SaveOutput()
					-- 2. TRẠNG THÁI CÓ THỂ NHẬN (Acceptable = 0): Gửi gói nhận nhiệm vụ & Tìm đường đến NPC nhận nếu cần
					elseif state == (_G.TaskStateType and _G.TaskStateType.Acceptable or 0) or state == 0 then
						local nowSec = os.time()
						_G.Bot_LastTaskAcceptTime = _G.Bot_LastTaskAcceptTime or 0
						if nowSec - _G.Bot_LastTaskAcceptTime >= 2 then
							_G.Bot_LastTaskAcceptTime = nowSec
							pcall(function()
								if _G.networkRequest and _G.networkRequest.ReqAcceptTask then _G.networkRequest.ReqAcceptTask(taskId) end
								if _G.NetManager and _G.TaskMessage and _G.TaskMessage.ReqAcceptTask then _G.NetManager.Send(_G.TaskMessage.ReqAcceptTask, { taskId = taskId, id = taskId }) end
								if _G.EventManager and _G.Event and _G.Event.Task_BtnAcceptClick then _G.EventManager.Dispatch(_G.Event.Task_BtnAcceptClick, taskId) end
								if _G.TaskManager and _G.TaskManager.TaskGo then
									_G.TaskManager.TaskGo(taskId, _G.TaskTriggeringConditionType and _G.TaskTriggeringConditionType.OnClick or 0)
								end
								if _G.AutoTaskManage and _G.AutoTaskManage.SetAutoTask then
									_G.AutoTaskManage.SetAutoTask(true)
								end
								if _G.AutoTaskManage and _G.AutoTaskManage.StartCurAutoTask then
									_G.AutoTaskManage.StartCurAutoTask(true)
								end
								local taskUI = _G.UIManager and _G.UIManager.GetUiByName and (_G.UIManager.GetUiByName("Task_TaskUI") or (_G.UIID and _G.UIID.TaskUI and _G.UIManager.GetUiByName(_G.UIID.TaskUI)))
								if taskUI and taskUI.TaskItemClick then
									taskUI:TaskItemClick(taskId)
								end
							end)
						end
					-- 3. TRẠNG THÁI ĐANG TIẾN HÀNH (Accept = 1)
					elseif state == (_G.TaskStateType and _G.TaskStateType.Accept or 1) or state == 1 then
						local behavior = TASK_CONFIG_BY_ID[taskId]
						if not behavior then
							-- Fallback nhận diện nếu taskId chưa khai báo trong bảng
							local tType = (curTask.GetTaskTypeID and curTask:GetTaskTypeID()) or curTask.type or 0
							local goal = curTask.GetTaskGola and curTask:GetTaskGola()
							local gType = (goal and goal.goalTbl and goal.goalTbl.type) or 0
							local rawName = tostring(taskName or "")
							local rawDes = tostring(taskDes or "")
							local lowName = string.lower(rawName)
							local lowDes = string.lower(rawDes)
							-- Nhận diện nhiệm vụ Cày Cấp / Tăng Cấp Đến... (cả tiếng Việt có dấu/không dấu và hoa/thường)
							local isLevelTask = tType == 15 or gType == 301 or gType == 3101
								or lowName:find("cấp đạt") or lowName:find("cap dat") or lowName:find("đạt cấp") or lowName:find("dat cap")
								or lowName:find("tăng cấp") or lowName:find("tang cap") or lowName:find("luyện cấp")
								or rawName:find("Cấp Đạt") or rawName:find("Đạt Cấp") or rawName:find("Tăng Cấp")
								or (lowName:find("mở cs") or lowName:find("mở chuyển"))
							if isLevelTask then
								behavior = TASK_BEHAVIOR.LEVEL_UP
							elseif gType == 101 or gType == 103 or gType == 113 or lowName:find("diệt") or lowName:find("đánh") or rawName:find("Diệt") or rawName:find("Đánh") then
								behavior = TASK_BEHAVIOR.MONSTER_KILL
							elseif MAP_TRAVEL_TASKS and MAP_TRAVEL_TASKS[taskId] then
								behavior = TASK_BEHAVIOR.MAP_TRAVEL
							else
								behavior = TASK_BEHAVIOR.DIALOGUE
							end
						end
						-- A. NHIỆM VỤ CHUYỂN MAP (Đến Devias, Dungeon, Lost Tower...)
						if behavior == TASK_BEHAVIOR.MAP_TRAVEL or (MAP_TRAVEL_TASKS and MAP_TRAVEL_TASKS[taskId]) then
							local travelCfg = MAP_TRAVEL_TASKS and MAP_TRAVEL_TASKS[taskId]
							if travelCfg then
								local curMap = (_G.SceneData and _G.SceneData.mapId) or 0
								local isAlreadyInMap = (tonumber(curMap) == tonumber(travelCfg.targetMap))
								if not isAlreadyInMap and travelCfg.altMaps then
									for _, am in ipairs(travelCfg.altMaps) do
										if tonumber(curMap) == tonumber(am) then
											isAlreadyInMap = true
											break
										end
									end
								end
								if not isAlreadyInMap then
									_G.Bot_LastMapTravelTime = _G.Bot_LastMapTravelTime or 0
									local nowSec = os.time()
									if nowSec - _G.Bot_LastMapTravelTime >= 3 then
										_G.Bot_LastMapTravelTime = nowSec
										Log(string.format("-> [CHUYỂN MAP TASK %d]: Truyền tống sang %s (MapId: %s | Tọa độ: %d#%d)...", taskId, travelCfg.name, tostring(travelCfg.targetMap), travelCfg.x, travelCfg.y), true)
										pcall(function()
											if _G.networkRequest and _G.networkRequest.ReqTransmit then _G.networkRequest.ReqTransmit(travelCfg.targetMap, 1, travelCfg.x, travelCfg.y) end
											if _G.networkRequest and _G.networkRequest.ReqCallFlag then _G.networkRequest.ReqCallFlag(1, 0, travelCfg.targetMap, 1, travelCfg.x, travelCfg.y, 0) end
											if _G.TaskManager and _G.TaskManager.TaskGo then
												_G.TaskManager.TaskGo(taskId, _G.TaskTriggeringConditionType and _G.TaskTriggeringConditionType.OnClick or 0)
											end
										end)
									end
								else
									pcall(function()
										if _G.networkRequest and _G.networkRequest.ReqCompleteTask then _G.networkRequest.ReqCompleteTask(taskId) end
										if _G.networkRequest and _G.networkRequest.ReqSubmitTask then _G.networkRequest.ReqSubmitTask(taskId) end
										if _G.TaskManager and _G.TaskManager.TaskGo then
											_G.TaskManager.TaskGo(taskId, _G.TaskTriggeringConditionType and _G.TaskTriggeringConditionType.OnClick or 0)
										end
									end)
								end
							end
						-- ====================================
						-- [MOD FEATURE]: CHIẾN LƯỢC CÀY CẤP OFFLINE CHO LEVEL >= 100
						-- Mô tả: Khi gặp nhiệm vụ yêu cầu cày cấp (LEVEL_UP) mà nhân vật đã Lv >= 100,
						-- bot sẽ không tốn thời gian farm chay online mà vét phó bản, nâng cấp, mở rương,
						-- ====================================
						-- [MOD FEATURE]: DUY TRÌ VÒNG LẶP CÀY CẤP & CẮM BÃI FARM THEO MỤC TIÊU MENU MOD
						-- Mô tả: Cày cấp liên tục theo mục tiêu "Cày đến: xxx" trên Menu Mod.
						--        Không ngắt bất kỳ Timer nào khi chưa đạt Target Level!
						--        Tự động bay về bãi quái khi hồi sinh an toàn, tự động lùi map nếu quái quá mạnh.
						-- ====================================
						elseif behavior == TASK_BEHAVIOR.LEVEL_UP then
							local curMap = (_G.SceneData and _G.SceneData.mapId) or 0
							curMap = tonumber(curMap) or 0
							local bestPt, targetMap = GetBestMonsterFarmPoint(curMap)
							targetMap = targetMap or curMap
							local isNewTask = (_G.Bot_CurrentTaskId ~= taskId)
							local nowSec = os.time()
							_G.Bot_LastFarmTeleportTime = _G.Bot_LastFarmTeleportTime or 0
							local isFarFromSpot = false
							if targetMap ~= curMap and targetMap > 0 then
								isFarFromSpot = true
							elseif bestPt and bestPt.x and bestPt.y then
								local pMe = _G.RoleManager and _G.RoleManager.me
								local pos = (pMe and pMe.cellPos) or (pMe and pMe.serverCoord)
								if pos and pos.x and pos.y then
									local dist = math.sqrt((pos.x - bestPt.x)^2 + (pos.y - bestPt.y)^2)
									if dist > 15 then
										isFarFromSpot = true
									end
								end
							end
							-- Truyền tống đến bãi cày tối ưu: khi nhận quest mới, hoặc sau khi hồi sinh/bị văng xa (>15 ô sau 3s), hoặc sau 60s nếu bị kẹt
							if isNewTask or (isFarFromSpot and (nowSec - _G.Bot_LastFarmTeleportTime >= 3)) or (nowSec - _G.Bot_LastFarmTeleportTime >= 60) then
								_G.Bot_CurrentTaskId = taskId
								_G.Bot_LastFarmTeleportTime = nowSec
								pcall(function()
									local hasTele = TeleportToBestFarmPoint(targetMap)
									if hasTele then
										Log(string.format("[Luyện Cấp] : Nhiệm vụ [%d] \"%s\" -> Tiến vào bãi quái tối ưu Map %d (%s) để cày cấp!",
											taskId, tostring(taskName), targetMap, tostring(bestPt and bestPt.name or "")), true)
										SaveOutput()
									end
								end)
							end
							-- Vô hiệu hóa tìm đường của quest để giữ nhân vật đứng yên tại bãi cày
							pcall(function()
								if _G.AutoTaskManage then
									if _G.AutoTaskManage.SetAutoTask then _G.AutoTaskManage.SetAutoTask(false) end
									if _G.AutoTaskManage.SetCurAutoTaskState then _G.AutoTaskManage.SetCurAutoTaskState(false) end
									if _G.AutoTaskManage.RemoveAutoTask then _G.AutoTaskManage.RemoveAutoTask(true) end
								end
								if _G.TaskManager and _G.TaskManager.TaskPathStop then
									_G.TaskManager.TaskPathStop()
								end
							end)
							-- Bật AutoFight 1 lần nếu chưa bật (tránh spam lệnh SetAutoFight mỗi tick làm ngắt chiêu)
							pcall(function()
								local me = _G.RoleManager and _G.RoleManager.me
								local isAutoFightOpen = me and me.meAutoFight and me.meAutoFight.IsAutoFightOpen and me.meAutoFight:IsAutoFightOpen()
								if not isAutoFightOpen then
									if me and me.SetAutoFight then me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight") end
									if me and me.SetAutoHookFight then me:SetAutoHookFight(true) end
									if me and me.meAutoFight and me.meAutoFight.SetAutoFightHookStart then me.meAutoFight:SetAutoFightHookStart(true) end
								end
								if _G.QiJiHelperData and not _G.QiJiHelperData.isAutoFight and _G.QiJiHelperData.SetAutoFightData then
									_G.QiJiHelperData.SetAutoFightData(true)
								end
							end)
						-- ====================================
						-- [MOD FEATURE]: TỰ ĐỘNG MUA & HỌC KỸ NĂNG SHOP (ĐÁ TÊN ĐA TRÙNG, SÁCH...)
						-- ====================================
						elseif behavior == TASK_BEHAVIOR.SKILL_SHOP then
							local isShopOpen = false
							local shopUI = nil
							pcall(function()
								if _G.UIManager then
									if _G.UIManager.IsVisible then
										isShopOpen = _G.UIManager.IsVisible("Shop_ShopUI") or (_G.UIID and _G.UIID.Shop and _G.UIManager.IsVisible(_G.UIID.Shop))
									end
									shopUI = _G.UIManager.GetUiByName and (_G.UIManager.GetUiByName("Shop_ShopUI") or (_G.UIID and _G.UIManager.GetUiByName(_G.UIID.Shop)))
									if not isShopOpen and shopUI then
										isShopOpen = (shopUI.visible == true) or (shopUI.transform and shopUI.transform.gameObject and shopUI.transform.gameObject.activeInHierarchy)
									end
								end
							end)
							-- 1. Nếu Shop đang mở -> Quét tìm vật phẩm đề cử và mua ngay
							if isShopOpen then
								local targetGoodId = nil
								if shopUI and shopUI.args and shopUI.args.subPosition and shopUI.args.subPosition > 0 then
									targetGoodId = shopUI.args.subPosition
								end
								if not targetGoodId and shopUI and shopUI.shopCtrTbl and shopUI.shopCtrTbl.items then
									for _, itemCtr in pairs(shopUI.shopCtrTbl.items) do
										if itemCtr and itemCtr.buyCtr and itemCtr.buyCtr.shop then
											local sData = itemCtr.buyCtr.shop
											local hasEff = (itemCtr.eff_UI_annuikuang and itemCtr.eff_UI_annuikuang.gameObject and itemCtr.eff_UI_annuikuang.gameObject.activeSelf)
											local isRecommend = (itemCtr.img_is_recommend and itemCtr.img_is_recommend.gameObject and itemCtr.img_is_recommend.gameObject.activeSelf)
											local itemName = tostring((itemCtr.itemModelData and itemCtr.itemModelData.itemData and itemCtr.itemModelData.itemData.tblItem and itemCtr.itemModelData.itemData.tblItem.name) or "")
											if hasEff or itemCtr.buyCtr.taskType or (isRecommend and (string.find(itemName, "Đa Trùng") or string.find(itemName, "Kỹ Năng") or string.find(itemName, "Sách") or taskId == 3030)) then
												targetGoodId = sData.id
												break
											end
										end
									end
								end
								if not targetGoodId then
									if taskId == 3030 then targetGoodId = 20409 -- Đá Tên Đa Trùng (Cung Thủ)
									elseif taskId == 3020 then targetGoodId = 20401 -- Kỹ Năng Chiến Binh
									elseif taskId == 3040 then targetGoodId = 20410
									elseif taskId == 3041 then targetGoodId = 20411
									else
										targetGoodId = 20401 -- Fallback default
									end
								end
								if targetGoodId then
									local nowSec = os.time()
									_G.Bot_LastShopBuyTime = _G.Bot_LastShopBuyTime or 0
									if nowSec - _G.Bot_LastShopBuyTime >= 2 then
										_G.Bot_LastShopBuyTime = nowSec
										Log(string.format("-> [MUA KỸ NĂNG TASK %d]: Đang gửi lệnh mua vật phẩm (GoodId: %s)...", taskId, tostring(targetGoodId)), true)
										pcall(function()
											if _G.networkRequest and _G.networkRequest.ReqBuy then
												_G.networkRequest.ReqBuy(targetGoodId, 1)
											elseif _G.NetManager and _G.ItemBuyMessage and _G.ItemBuyMessage.ReqBuy then
												_G.NetManager.Send(_G.ItemBuyMessage.ReqBuy, {
													goodId = targetGoodId,
													buyCount = 1
												})
											end
										end)
										-- Đợi 1.5s sau khi mua mới đóng Shop
										Timer.Start(1.5, function()
											pcall(function()
												if _G.UIManager then
													if _G.UIID and _G.UIID.Shop then _G.UIManager.Hide(_G.UIID.Shop) end
													if _G.UIID and _G.UIID.ItemTipUI then _G.UIManager.Hide(_G.UIID.ItemTipUI) end
													_G.UIManager.Hide("Shop_ShopUI")
													_G.UIManager.Hide("ItemTipUI")
												end
											end)
										end)
									end
								end
							else
								-- Chưa mở Shop -> Điều hướng mở Shop
								local nowSec = os.time()
								_G.Bot_LastShopNavTime = _G.Bot_LastShopNavTime or 0
								if nowSec - _G.Bot_LastShopNavTime >= 4 then
									_G.Bot_LastShopNavTime = nowSec
									Log(string.format("-> [ĐIỀU HƯỚNG TASK %s]: Mở Shop để mua \"%s\"...", tostring(taskId), tostring(taskName)), true)
									pcall(function()
										if _G.DirectTask and _G.DirectTask.OpenNav then
											_G.DirectTask.OpenNav(curTask)
										elseif curTask.GetNavi and not string.isNullOrEmpty(curTask:GetNavi()) and _G.NavigationUtility and _G.NavigationUtility.ClickNavigation then
											_G.NavigationUtility.ClickNavigation(curTask:GetNavi())
										end
										if _G.TaskManager and _G.TaskManager.TaskGo then
											_G.TaskManager.TaskGo(taskId, _G.TaskTriggeringConditionType and _G.TaskTriggeringConditionType.OnClick or 0)
										end
									end)
								end
							end
							-- 2. Tự động dùng sách / đá kỹ năng trong túi để học skill (CHỈ DÙNG ĐÚNG ITEM KỸ NĂNG, KHÔNG DÙNG BỪA ĐÁ)
							pcall(function()
								if _G.BagInfoData and _G.BagInfoData.TotalItems then
									for _, item in pairs(_G.BagInfoData.TotalItems) do
										if item and item.id and item.tblItem then
											local name = tostring(item.tblItem.name or "")
											-- Type 3 SubType 302: Đá kỹ năng học skill (như Đá Tên Đa Trùng 4001000)
											-- Type 2 SubType 2/21: Sách kỹ năng học skill
											local isSkillItem = (item.tblItem.type == 3 and item.tblItem.subType == 302)
															 or (item.tblItem.type == 2 and (item.tblItem.subType == 2 or item.tblItem.subType == 21))
															 or (item.tblItem.rightOperate == 2 and (string.find(name, "Đa Trùng") or string.find(name, "Triệu Hồi") or string.find(name, "Kỹ Năng") or string.find(name, "Sách") or string.find(name, "Cuộn")))
											if isSkillItem and item.tblItem.type ~= 1 then
												if _G.networkRequest and _G.networkRequest.ReqUseItem then
													_G.networkRequest.ReqUseItem(1, item.id)
												elseif _G.NetManager and _G.BagMessage and _G.BagMessage.ReqUseItem then
													_G.NetManager.Send(_G.BagMessage.ReqUseItem, { itemId = item.id, count = 1, clientParams = {} })
												end
											end
										end
									end
								end
							end)
							-- 3. Nộp / Trả nhiệm vụ
							pcall(function()
								if _G.networkRequest then
									if _G.networkRequest.ReqCompleteTask then _G.networkRequest.ReqCompleteTask(taskId) end
									if _G.networkRequest.ReqSubmitTask then _G.networkRequest.ReqSubmitTask(taskId) end
								end
							end)
						-- ====================================
						-- [MOD FEATURE]: TỰ ĐỘNG THU HỒI ĐỒ TÂN THỦ (TASK 3010, 3061...)
						-- ====================================
						elseif behavior == TASK_BEHAVIOR.RECYCLE then
							local nowSec = os.time()
							_G.Bot_LastRecycleTaskTime = _G.Bot_LastRecycleTaskTime or 0
							if nowSec - _G.Bot_LastRecycleTaskTime >= 2 then
								_G.Bot_LastRecycleTaskTime = nowSec
								-- 1. Tìm 1 vật phẩm trong túi để thu hồi (ưu tiên trang bị rác, nếu không có thì lấy 1 bình mana/máu)
								local candidate = nil
								if _G.BagInfoData and _G.BagInfoData.TotalItems then
									for _, item in pairs(_G.BagInfoData.TotalItems) do
										if item and item.id and item.count and item.count > 0 and item.tblItem then
											if item.tblItem.type == 1 then
												candidate = item
												break
											end
										end
									end
									if not candidate then
										for _, item in pairs(_G.BagInfoData.TotalItems) do
											if item and item.id and item.count and item.count > 0 then
												candidate = item
												break
											end
										end
									end
								end
								local sellUI = nil
								pcall(function()
									if _G.UIManager and _G.UIManager.GetUiByName then
										sellUI = _G.UIManager.GetUiByName("Bag_SellInfoUI")
									end
								end)
								local wayType = (_G.RecycleWayType and _G.RecycleWayType.BlackSmith) or 2
								if sellUI and sellUI.GetRecycleWayType then
									pcall(function() wayType = sellUI:GetRecycleWayType() end)
								end
								if candidate then
									local sendMap = {}
									sendMap[candidate.id] = 1
									Log(string.format("-> [THU HỒI TASK %d]: Thu hồi 1 vật phẩm (%s) để hoàn thành nhiệm vụ!", taskId, tostring(candidate.tblItem and candidate.tblItem.name or candidate.id)), true)
									SaveOutput()
									if _G.networkRequest and _G.networkRequest.ReqItemRecycle then
										_G.networkRequest.ReqItemRecycle(sendMap, wayType)
									elseif _G.NetManager and _G.ItemRecycleMessage and _G.ItemRecycleMessage.ReqItemRecycle then
										_G.NetManager.Send(_G.ItemRecycleMessage.ReqItemRecycle, { recycleItems = sendMap, recycleType = wayType })
									end
								elseif sellUI and sellUI.btn_sellOnClick then
									sellUI:btn_sellOnClick()
								end
								-- 2. Nộp / Trả nhiệm vụ sau khi thu hồi và đóng UI
								Timer.Start(1.0, function()
									pcall(function()
										if _G.networkRequest then
											if _G.networkRequest.ReqCompleteTask then _G.networkRequest.ReqCompleteTask(taskId) end
											if _G.networkRequest.ReqSubmitTask then _G.networkRequest.ReqSubmitTask(taskId) end
										end
										if _G.UIManager then
											if _G.UIID and _G.UIID.Bag_SellInfoUI then _G.UIManager.Hide(_G.UIID.Bag_SellInfoUI) end
											if _G.UIID and _G.UIID.BagUI then _G.UIManager.Hide(_G.UIID.BagUI) end
											_G.UIManager.Hide("Bag_SellInfoUI")
											_G.UIManager.Hide("Bag_3DBagInfoUI")
										end
									end)
								end)
							end
						-- ====================================
						-- [MOD FEATURE]: NHIỆM VỤ DIỆT QUÁI (X/Y) & ĐỐI THOẠI NPC - ĐIỀU HƯỚNG 1 LẦN
						-- Mô tả: Kích hoạt TaskGo & StartCurAutoTask ĐÚNG 1 LẦN khi nhận nhiệm vụ mới.
						-- Khi đang đánh quái x/y, TUYỆT ĐỐI KHÔNG spam tìm đường để nhân vật tập trung đánh quái!
						-- ====================================
						else
							local nowSec = os.time()
							_G.Bot_CurrentTaskId = _G.Bot_CurrentTaskId or 0
							_G.Bot_LastTaskNavTime = _G.Bot_LastTaskNavTime or 0
							local isNewTask = (_G.Bot_CurrentTaskId ~= taskId)
							-- Kiểm tra trạng thái đang di chuyển hoặc đang đánh quái chuẩn xác qua API engine
							local isMoving = false
							local isFighting = false
							pcall(function()
								local me = _G.RoleManager and _G.RoleManager.me
								if me and me.IsMoving and me:IsMoving() then isMoving = true end
								if me and me.meAutoFight and me.meAutoFight.IsAutoFightOpen and me.meAutoFight:IsAutoFightOpen() then
									isFighting = true
								end
								if _G.QiJiHelperData and _G.QiJiHelperData.isAutoFight then
									isFighting = true
								end
							end)
							-- ====================================
							-- [MOD FEATURE]: TRUYỀN TỐNG TỨC THÌ CHO NHIỆM VỤ CHUYỂN SINH (CS1 - TARKAN)
							-- Mô tả: Dùng ReqCallFlag bay thẳng tới bãi quái Tarkan (1009: 162#102) để nhặt Sách Đế Vương.
							--        Nếu phát hiện nhân vật lạc sang Map khác (ví dụ Lost Tower 7), lập tức đóng popup và bay về Tarkan!
							-- ====================================
							local curSceneMap = (_G.SceneData and _G.SceneData.mapId) or 0
							curSceneMap = tonumber(curSceneMap) or 0
							local taskNameStr = tostring(taskName or "")
							local isCS1Task = (taskId == 21001 or (taskId >= 21000 and taskId <= 21024) or string.find(taskNameStr, "Sách Đế Vương") or string.find(taskNameStr, "Tarkan"))
							if isCS1Task then
								_G.Bot_LastCS1TeleTime = _G.Bot_LastCS1TeleTime or 0
								-- [MOD FEATURE]: CHỌN BÃI TỐT NHẤT TRONG TARKAN THEO PHÒNG THỦ THỰC TẾ
								local bestPt, _ = GetBestMonsterFarmPoint(1009)
								local targetX = (bestPt and bestPt.x) or 166
								local targetY = (bestPt and bestPt.y) or 196
								local spotName = (bestPt and bestPt.name) or "Tarkan (Quái Lv195 - EXP x4.0)"
								local defReq = (bestPt and bestPt.defenseReq) or 390
								-- 1. Nếu đang ở sai map (ví dụ Lost Tower 7 do cổng dịch chuyển): Lập tức bay sang Tarkan
								if curSceneMap ~= 1009 and (nowSec - _G.Bot_LastCS1TeleTime >= 3) then
									_G.Bot_LastCS1TeleTime = nowSec
									_G.Bot_CurrentTaskId = taskId
									_G.Bot_LastTaskNavTime = nowSec
									Log(string.format("-> [CHUYỂN MAP CS1 TASK %d]: Thủ %d -> ReqCallFlag bay thẳng tới bãi tối ưu Tarkan: %s (Tọa độ: %d#%d | Thủ req: %d) để farm EXP & Sách Đế Vương!",
										taskId, GetPlayerMonsterDefense(), spotName, targetX, targetY, defReq), true)
									SaveOutput()
									pcall(function()
										-- Đóng toàn bộ popup chặn đường
										if _G.DismissBlockers then _G.DismissBlockers() end
										if _G.UIManager then
											if _G.UIID and _G.UIID.PromptTipUI then _G.UIManager.Hide(_G.UIID.PromptTipUI) end
											_G.UIManager.Hide("PromptTipUI")
											_G.UIManager.Hide("Activity_EventListUI")
											_G.UIManager.Hide("Task_MonsterListUI")
											_G.UIManager.Hide("Main_MapDetailUI")
										end
										-- Dừng di chuyển cũ
										local me = _G.RoleManager and _G.RoleManager.me
										if me and me.StopMove then me:StopMove() end
										if _G.AutoTaskManage and _G.AutoTaskManage.SetAutoTask then _G.AutoTaskManage.SetAutoTask(false) end
										if _G.TaskManager and _G.TaskManager.TaskPathStop then _G.TaskManager.TaskPathStop() end
										-- Gửi lệnh ReqCallFlag bay thẳng vào tọa độ bãi quái tối ưu
										local lineId = (_G.SceneData and _G.SceneData.line) or 1
										if _G.networkRequest and _G.networkRequest.ReqCallFlag then
											_G.networkRequest.ReqCallFlag(1, 0, 1009, lineId, targetX, targetY, 0)
										end
										if _G.NetManager and _G.MapMessage and _G.MapMessage.ReqCallFlag then
											_G.NetManager.Send(_G.MapMessage.ReqCallFlag, { type = 1, rid = 0, mapId = 1009, line = lineId, x = targetX, y = targetY, hostId = 0 })
										end
										if _G.networkRequest and _G.networkRequest.ReqTransmit then
											_G.networkRequest.ReqTransmit(1009, lineId, targetX, targetY)
										end
									end)
								elseif curSceneMap == 1009 then
									-- 2. Đã ở Tarkan: Kiểm tra khoảng cách tới bãi tối ưu (targetX#targetY), nếu cách xa > 20 ô thì bay lại
									local pMe = _G.RoleManager and _G.RoleManager.me
									local myPos = (pMe and pMe.cellPos) or (pMe and pMe.serverCoord)
									local isFar = false
									if myPos and myPos.x and myPos.y then
										local dist = math.sqrt((myPos.x - targetX)^2 + (myPos.y - targetY)^2)
										if dist > 20 then isFar = true end
									end
									if (isFar or isNewTask) and (nowSec - _G.Bot_LastCS1TeleTime >= 6) then
										_G.Bot_LastCS1TeleTime = nowSec
										_G.Bot_CurrentTaskId = taskId
										Log(string.format("-> [TARKAN CS1]: Thủ %d -> Bay về bãi tối ưu: %s (Tọa độ: %d#%d | Thủ req: %d)...",
											GetPlayerMonsterDefense(), spotName, targetX, targetY, defReq), true)
										SaveOutput()
										pcall(function()
											local lineId = (_G.SceneData and _G.SceneData.line) or 1
											if _G.networkRequest and _G.networkRequest.ReqCallFlag then
												_G.networkRequest.ReqCallFlag(1, 0, 1009, lineId, targetX, targetY, 0)
											end
										end)
									end
									-- Luôn bật AutoFight để đánh quái gom 20 Sách Đế Vương
									pcall(function()
										local me = _G.RoleManager and _G.RoleManager.me
										if me then
											if me.SetAutoFight then me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight") end
											if me.SetAutoHookFight then me:SetAutoHookFight(true) end
											if me.meAutoFight and me.meAutoFight.SetAutoFightHookStart then me.meAutoFight:SetAutoFightHookStart(true) end
										end
										if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then
											_G.QiJiHelperData.SetAutoFightData(true)
										end
									end)
								end
							else
								local isSnowBeetleTask = (taskId == 3060)
								if isSnowBeetleTask then
									_G.Bot_LastSnowBeetleTeleTime = _G.Bot_LastSnowBeetleTeleTime or 0
									local targetMapId = 1003
									local targetX, targetY = 158, 29
									local pMe = _G.RoleManager and _G.RoleManager.me
									local myPos = (pMe and pMe.cellPos) or (pMe and pMe.serverCoord) or (pMe and pMe.Position)
									local isFar = (curSceneMap ~= 1003)
									if not isFar and myPos and myPos.x and myPos.y then
										local dist = math.sqrt((myPos.x - targetX)^2 + (myPos.y - targetY)^2)
										if dist > 8 then isFar = true end
									end
									if (isNewTask or isFar) and (nowSec - _G.Bot_LastSnowBeetleTeleTime >= 4) then
										_G.Bot_LastSnowBeetleTeleTime = nowSec
										_G.Bot_CurrentTaskId = taskId
										_G.Bot_LastTaskNavTime = nowSec
										Log(string.format('-> [NHIEM VU BO TUYET %d]: ReqCallFlag bay thang ra toa do %d#%d (Map Devias ID: %d) de diet 20 Bo Tuyet!', taskId, targetX, targetY, targetMapId), true)
										SaveOutput()
										pcall(function()
											local me = _G.RoleManager and _G.RoleManager.me
											if me and me.StopMove then me:StopMove() end
											if _G.AutoTaskManage and _G.AutoTaskManage.SetAutoTask then _G.AutoTaskManage.SetAutoTask(false) end
											if _G.TaskManager and _G.TaskManager.TaskPathStop then _G.TaskManager.TaskPathStop() end
											local lineId = (_G.SceneData and _G.SceneData.line) or 1
											if _G.networkRequest and _G.networkRequest.ReqCallFlag then _G.networkRequest.ReqCallFlag(1, 0, targetMapId, lineId, targetX, targetY, 0) end
											if _G.NetManager and _G.MapMessage and _G.MapMessage.ReqCallFlag then _G.NetManager.Send(_G.MapMessage.ReqCallFlag, { type = 1, rid = 0, mapId = targetMapId, line = lineId, x = targetX, y = targetY, hostId = 0 }) end
										end)
									end
									pcall(function()
										local me = _G.RoleManager and _G.RoleManager.me
										if me then
											if me.SetAutoFight then me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or 'AutoFight') end
											if me.SetAutoHookFight then me:SetAutoHookFight(true) end
											if me.meAutoFight and me.meAutoFight.SetAutoFightHookStart then me.meAutoFight:SetAutoFightHookStart(true) end
										end
										if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then _G.QiJiHelperData.SetAutoFightData(true) end
									end)
								else
								-- Thời gian watchdog chống kẹt: Nhiệm vụ diệt quái chờ 60s, đối thoại NPC chờ 20s
								local timeoutSec = (behavior == TASK_BEHAVIOR.MONSTER_KILL) and 60 or 20
								local isStuckTooLong = (nowSec - _G.Bot_LastTaskNavTime >= timeoutSec)
								-- CHỈ kích hoạt tìm đường ĐÚNG 1 LẦN khi nhận nhiệm vụ mới hoặc thực sự bị kẹt quá lâu
								if isNewTask or (isStuckTooLong and not isMoving and not isFighting) then
									_G.Bot_CurrentTaskId = taskId
									_G.Bot_LastTaskNavTime = nowSec
									Log(string.format("-> [ĐIỀU HƯỚNG TASK %s]: Bắt đầu di chuyển tới \"%s\" (1 LẦN DUY NHẤT)... ", tostring(taskId), tostring(taskName)), true)
									pcall(function()
										if _G.DirectTask and _G.DirectTask.OpenNav then
											_G.DirectTask.OpenNav(curTask)
										elseif curTask.GetNavi and not string.isNullOrEmpty(curTask:GetNavi()) and _G.NavigationUtility and _G.NavigationUtility.ClickNavigation then
											_G.NavigationUtility.ClickNavigation(curTask:GetNavi())
										end
									end)
									pcall(function()
										if _G.TaskManager and _G.TaskManager.TaskGo then
											_G.TaskManager.TaskGo(taskId, _G.TaskTriggeringConditionType and _G.TaskTriggeringConditionType.OnClick or 0)
										end
									end)
									pcall(function()
										if _G.AutoTaskManage and _G.AutoTaskManage.SetAutoTask then
											_G.AutoTaskManage.SetAutoTask(true)
										end
										if _G.AutoTaskManage and _G.AutoTaskManage.StartCurAutoTask then
											_G.AutoTaskManage.StartCurAutoTask(true)
										end
										local taskUI = _G.UIManager and _G.UIManager.GetUiByName and (_G.UIManager.GetUiByName("Task_TaskUI") or (_G.UIID and _G.UIID.TaskUI and _G.UIManager.GetUiByName(_G.UIID.TaskUI)))
										if taskUI and taskUI.TaskItemClick then
											taskUI:TaskItemClick(taskId)
										end
									end)
								end
								end
								-- Nếu là nhiệm vụ diệt quái: Bật AutoFight 1 lần nếu chưa bật
								if behavior == TASK_BEHAVIOR.MONSTER_KILL then
									pcall(function()
										local me = _G.RoleManager and _G.RoleManager.me
										local isAutoFightOpen = me and me.meAutoFight and me.meAutoFight.IsAutoFightOpen and me.meAutoFight:IsAutoFightOpen()
										if not isAutoFightOpen then
											if me and me.SetAutoFight then me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight") end
											if me and me.SetAutoHookFight then me:SetAutoHookFight(true) end
											if me and me.meAutoFight and me.meAutoFight.SetAutoFightHookStart then me.meAutoFight:SetAutoFightHookStart(true) end
										end
										if _G.QiJiHelperData and not _G.QiJiHelperData.isAutoFight and _G.QiJiHelperData.SetAutoFightData then
											_G.QiJiHelperData.SetAutoFightData(true)
										end
									end)
								end
							end
						end
					end
				else
					-- KHÔNG CÓ NHIỆM VỤ CHÍNH -> Tự động farm bãi tối ưu của Map hiện tại
					local curMap = (_G.SceneData and _G.SceneData.mapId) or 0
					local isMoving = false
					local isFighting = false
					pcall(function()
						local me = _G.RoleManager and _G.RoleManager.me
						if me and me.IsMoving and me:IsMoving() then isMoving = true end
						if me and (me.isFightState or (me.meAutoFight and me.meAutoFight.isAutoFight)) then isFighting = true end
						if _G.QiJiHelperData and _G.QiJiHelperData.isAutoFight then isFighting = true end
					end)
					_G.Bot_LastFarmTeleportTime = _G.Bot_LastFarmTeleportTime or 0
					local nowSec = os.time()
					if (not isMoving and not isFighting) or (nowSec - _G.Bot_LastFarmTeleportTime >= 8) then
						_G.Bot_LastFarmTeleportTime = nowSec
						pcall(function()
							local hasTele = TeleportToBestFarmPoint(curMap)
							if hasTele then
								Log(string.format("[Luyện Cấp] : Chưa có nhiệm vụ mới -> Tự động train bãi tối ưu tại Map %d!", curMap), true)
								SaveOutput()
							end
						end)
					end
					pcall(function()
						local me = _G.RoleManager and _G.RoleManager.me
						if me and me.SetAutoFight then me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight") end
						if me and me.SetAutoHookFight then me:SetAutoHookFight(true) end
						if me and me.meAutoFight and me.meAutoFight.SetAutoFightHookStart then me.meAutoFight:SetAutoFightHookStart(true) end
						if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then _G.QiJiHelperData.SetAutoFightData(true) end
					end)
				end
			end
		end)
	end)
end
_G.StartNewbieQuestPipeline = StartNewbieQuestPipeline

-- ====================================
-- 14. HÀM LẤY THÔNG TIN MÁY CHỦ FARM CHỈ ĐỊNH (TARGET SERVER FOR CLONE FARMING)
-- Mô tả: Cố định và lấy chính xác Server Farm đã được chỉ định (hoặc do Mod UI chọn):
--        Ưu tiên: _G.TARGET_SERVER_ID -> curAcc.targetServer -> 491
-- ====================================
local function GetActualCurrentServerInfo()
	local curAcc = (_G.BotAccounts and _G.BotAccounts[_G.CurrentAccountIndex or 1]) or (GetCurrentAccount and GetCurrentAccount())
	local targetSid = _G.TARGET_SERVER_ID
	if not targetSid and _G.GetSelectedServerList then
		local selList = _G.GetSelectedServerList()
		if selList and #selList > 0 then
			_G.CurrentServerListIndex = _G.CurrentServerListIndex or 1
			if _G.CurrentServerListIndex > #selList then _G.CurrentServerListIndex = 1 end
			targetSid = selList[_G.CurrentServerListIndex]
		end
	end
	if not targetSid then
		targetSid = (curAcc and curAcc.targetServer) or 491
	end
	targetSid = tonumber(targetSid) or 491
	local targetSName = _G.TARGET_SERVER_NAME or ("S" .. tostring(targetSid))
	pcall(function()
		if _G.LoginData then
			if _G.LoginData.server and tonumber(_G.LoginData.server[5]) == targetSid and _G.LoginData.server[1] then
				targetSName = _G.LoginData.server[1]
			elseif _G.LoginData.GetServer then
				local sData = _G.LoginData.GetServer(targetSid) or _G.LoginData.GetServer(tostring(targetSid))
				if sData and sData[1] then
					targetSName = sData[1]
				end
			end
		end
	end)
	return targetSid, targetSName
end
_G.GetActualCurrentServerInfo = GetActualCurrentServerInfo

local function GetCurrentServerId()
	local sId, _ = GetActualCurrentServerInfo()
	return sId
end
_G.GetCurrentServerId = GetCurrentServerId

local function ResolveActualTargetServer(callback)
	local curAcc = GetCurrentAccount()
	local targetSid = _G.TARGET_SERVER_ID or (curAcc and curAcc.targetServer) or 491
	targetSid = tonumber(targetSid) or 491
	local targetServerData = nil
	local detectedSource = "Target Server Config (S" .. tostring(targetSid) .. ")"
	-- 1. Tìm trong serverList / AndroidServerList
	local allLists = {
		(LoginData and LoginData.serverList) or {},
		(LoginData and LoginData.AndroidServerList) or {},
		(LoginData and LoginData.data and LoginData.data.server_lists) or {}
	}
	for _, list in ipairs(allLists) do
		for _, s in pairs(list) do
			if s and s[5] then
				local sidNum = tonumber(s[5])
				local sName = tostring(s[1] or "")
				local nameNum = string.match(sName, "[Ss](%d+)") or string.match(sName, "(%d+)")
				if (sidNum and sidNum == targetSid) or (nameNum and tonumber(nameNum) == targetSid) then
					targetServerData = s
					detectedSource = "serverList (" .. tostring(targetSid) .. " -> " .. sName .. ")"
					break
				end
			end
		end
		if targetServerData then break end
	end
	-- 2. Tìm qua LoginData.GetServer
	if not targetServerData and LoginData and LoginData.GetServer then
		targetServerData = LoginData.GetServer(targetSid) or LoginData.GetServer(tostring(targetSid))
		if targetServerData then
			detectedSource = "LoginData.GetServer(" .. tostring(targetSid) .. ")"
		end
	end
	-- 3. Nếu server đang chọn trong LoginData trùng targetSid
	if not targetServerData and LoginData and LoginData.server and LoginData.server[5] and tonumber(LoginData.server[5]) == targetSid then
		targetServerData = LoginData.server
		detectedSource = "LoginData.server Current Selected (" .. tostring(targetServerData[1] or targetServerData[5]) .. ")"
	end
	-- 4. Fallback tự tạo data chuẩn cho targetServer
	if not targetServerData then
		targetServerData = {
			[1] = "VĨNH HẰNG " .. tostring(targetSid),
			[2] = "",
			[3] = (EServerState and EServerState.NewServer) or 2,
			[4] = "",
			[5] = targetSid,
			[6] = ""
		}
		detectedSource = "Generated TargetServer (S" .. tostring(targetSid) .. ")"
	end
	Log(string.format("-> [CHỈ ĐỊNH MÁY CHỦ FARM]: %s (ID: %s) [Nguồn: %s]",
		tostring(targetServerData[1]), tostring(targetServerData[5]), tostring(detectedSource)))
	-- Đồng bộ lại targetServer trong account config
	curAcc.targetServer = targetServerData[5]
	if _G.BotAccounts and _G.BotAccounts[_G.CurrentAccountIndex or 1] then
		_G.BotAccounts[_G.CurrentAccountIndex or 1].targetServer = targetServerData[5]
	end
	if callback then callback(targetServerData) end
end
ConnectToTargetServer = function()
	ResolveActualTargetServer(function(targetServerData)
		if not targetServerData then
			Log("LỖI: Không tìm thấy máy chủ hợp lệ trong danh sách!")
			SaveOutput()
			return
		end
		local serverName = tostring(targetServerData[1] or ("Server " .. tostring(targetServerData[5])))
		local serverId = targetServerData[5]
		local curAccForSrv = GetCurrentAccount and GetCurrentAccount()
		if curAccForSrv and curAccForSrv.account then
			_G.Bot_ActiveSessionEmail = tostring(curAccForSrv.account)
		end
		if serverId then
			_G.Bot_ActiveSessionServer = tonumber(serverId)
		end
		_G.Bot_NeedReloginNewConfig = false
		if _G.Mod_UpdateServerStatusUI then pcall(_G.Mod_UpdateServerStatusUI) end
		Log(string.format("--- [BƯỚC 4] KẾT NỐI MÁY CHỦ %s (ID: %s) (ACC %d/%d: %s | ROLE %d/4) ---",
			serverName, tostring(serverId), _G.CurrentAccountIndex or 1, #_G.BotAccounts, tostring(GetCurrentAccount().account), _G.CurrentRoleIndex or 1))
		-- 1. Thiết lập Server trong LoginData
		LoginData.SetServer(targetServerData)
		LoginData.equipmentList = nil
		pcall(function()
			if LoginData.ChangeOftenServer then
				LoginData.ChangeOftenServer()
			end
		end)
		-- 2. Cập nhật Text & State hiển thị trên Login_LoginUI
		pcall(function()
			local loginUI = nil
			if UIManager and UIManager.GetUiByName then
				loginUI = UIManager.GetUiByName("Login_LoginUI")
			end
			if loginUI then
				if loginUI.lab_connectServerName and loginUI.lab_connectServerName.SetText then
					loginUI.lab_connectServerName:SetText(serverName)
				end
				if loginUI.img_connectServerState and loginUI.img_connectServerState.image and EServerStateColor and targetServerData[3] then
					loginUI.img_connectServerState.image.color = EServerStateColor[tonumber(targetServerData[3])]
				end
			end
		end)
		-- 3. Hủy đăng ký listener cũ trước khi đăng ký mới
		if _G.TestEventContainer then
			pcall(function() _G.TestEventContainer:UnRegistAll() end)
		end
		_G.TestEventContainer = EventContainer(EventManager)
		_G.TestEventContainer:Regist(Event.Net_ConnectSuccess, function()
			Log("[EVENT] Net_ConnectSuccess -> TCP Đã kết nối!")
			SaveOutput()
		end)
		_G.TestEventContainer:Regist(Event.Login_ConnectSuccess, function()
			Log("[EVENT] Login_ConnectSuccess -> Đăng nhập máy chủ thành công!")
			SaveOutput()
			-- BẮT BUỘC gửi yêu cầu lấy danh sách nhân vật
			Timer.Start(0.5, function()
				Log("-> Đang yêu cầu danh sách nhân vật (ReqGetRoleList)...")
				pcall(function()
					if _G.NetManager and _G.UserMessage and _G.UserMessage.ReqGetRoleList then
						_G.NetManager.Send(_G.UserMessage.ReqGetRoleList)
					end
				end)
			end)
		end)
		_G.TestEventContainer:Regist(Event.Login_ResGetRoleList, function()
			Log("[EVENT] Login_ResGetRoleList -> ĐÃ NHẬN DANH SÁCH NHÂN VẬT!")
			DismissBlockers()
			local roles = LoginData.roleList or {}
			_G.TotalRolesInCurrentAccount = #roles
			Log(">>> TỔNG SỐ NHÂN VẬT HIỆN CÓ TRONG TÀI KHOẢN: " .. tostring(#roles))
			for i, r in ipairs(roles) do
				local roleInfo = r.info or r.data or r or {}
				local rId = roleInfo.roleId or roleInfo.id or r.roleId or r.id
				Log(string.format("   [%d] ID: %s | Tên: %s | Level: %s", i, tostring(rId), tostring(roleInfo.name), tostring(roleInfo.level)))
			end
			SaveOutput()
			local targetIdx = _G.CurrentRoleIndex or 1
			Timer.Start(DELAY, function()
				SelectRoleByIndex(targetIdx)
			end)
		end)
		_G.TestEventContainer:Regist(Event.GamePlay_Enter, function()
			Log("[EVENT] GamePlay_Enter -> ĐÃ VÀO THẾ GIỚI TRONG GAME THÀNH CÔNG!")
			if _G.LoginData then _G.LoginData.InGame = true end
			pcall(function()
				if _G.UIManager then
					if _G.UIID and _G.UIID.LoginRoleUI then _G.UIManager.Hide(_G.UIID.LoginRoleUI) end
					if _G.UIID and _G.UIID.LoginCreateRoleUI then _G.UIManager.Hide(_G.UIID.LoginCreateRoleUI) end
					if _G.UIID and _G.UIID.LoginUI then _G.UIManager.Hide(_G.UIID.LoginUI) end
					_G.UIManager.Hide("Login_LoginRoleUI")
					_G.UIManager.Hide("Login_LoginCreateRoleUI")
					_G.UIManager.Hide("Login_LoginUI")
				end
			end)
			if _G.Bot_IsInGameWorld then
				ApplyFovAndSpeed()
				return
			end
			_G.Bot_IsInGameWorld = true
			-- Dừng bất kỳ Timer Quest cũ nào nếu có
			if _G.BotQuestMonitorTimer then
				pcall(function() Timer.Stop(_G.BotQuestMonitorTimer) end)
				_G.BotQuestMonitorTimer = nil
			end
			Timer.Start(DELAY, function()
				DismissBlockers()
				ApplyFovAndSpeed()
				if _G.Mod_UpdateServerStatusUI then pcall(_G.Mod_UpdateServerStatusUI) end
				local pMe = _G.RoleManager and _G.RoleManager.me
				local currentLevel = (pMe and pMe.level) or (pMe and pMe.data and pMe.data.level) or 1
				Log(string.format("-> Level nhân vật hiện tại: %s", tostring(currentLevel)), true)
				SaveOutput()
				-- NẾU BOT CHƯA ĐƯỢC BẬT (CHƯA BẤM START / BOT_RUNNING = FALSE) -> DỪNG TOÀN BỘ TIẾN TRÌNH TỰ ĐỘNG
				if not _G.Bot_Running then
					Log("-> [FARM BOT]: Bot đang ở trạng thái TẠM DỪNG (PAUSED / IDLE). Chờ bấm [START] trên Mod Menu để bắt đầu!", true)
					SaveOutput()
					return
				end
				-- ĐIỀU HƯỚNG THEO CẤP ĐỘ NHÂN VẬT KHI BOT ĐANG CHẠY:
				if currentLevel >= 20 then
					StartGlobal30sUpgradePipeline()
				end
				-- BỎ hoàn toàn điều kiện currentLevel >= 100 gây dừng sớm
				-- LUÔN LUÔN cho nhân vật chạy vòng lặp làm và claim nhiệm vụ liên tục!
				Log("=========================================================================")
				Log(string.format(">>> NHÂN VẬT LEVEL %s -> TIẾN HÀNH CHU TRÌNH LÀM VÀ QUÉT QUEST LIÊN TỤC (1s/LẦN)! <<<", tostring(currentLevel)), true)
				Log("=========================================================================")
				SaveOutput()
					-- Từ Lv 1 -> 10: Tĩnh lặng làm nhiệm vụ tân thủ thuần túy, chưa can thiệp gì
					-- Khi đạt Level 10+ sẽ tự động kích hoạt nhập 14 mã Giftcode bên trong StartNewbieQuestPipeline
					StartNewbieQuestPipeline()
			end)
		end)
		Log("2. Kích hoạt kết nối Server " .. serverName .. " (ID: " .. tostring(serverId) .. ")...")
		ReconnectManager.OnConnect()
		SaveOutput()
		-- Timer Fallback kiểm tra sau 3.5s nếu chưa vào game mà đã có roleList -> tự chọn role vào game
		Timer.Start(3.5, function()
			if not _G.Bot_IsInGameWorld then
				local roles = LoginData and LoginData.roleList
				if roles and #roles > 0 then
					Log("-> [FALLBACK] Phát hiện danh sách nhân vật đã sẵn sàng -> Vào game ngay!", true)
					SelectRoleByIndex(_G.CurrentRoleIndex or 1)
				else
					pcall(function()
						if _G.NetManager and _G.UserMessage and _G.UserMessage.ReqGetRoleList then
							_G.NetManager.Send(_G.UserMessage.ReqGetRoleList)
						end
					end)
				end
			end
		end)
	end)
end

-- ====================================
-- 14. ĐẢM BẢO DANH SÁCH SERVER & ROLEDATA
-- ====================================
EnsureServerListLoaded = function(onSuccess)
	local hasList = false
	if LoginData and LoginData.serverList and #LoginData.serverList > 0 then
		hasList = true
	elseif LoginData and LoginData.data and LoginData.data.server_lists and #LoginData.data.server_lists > 0 then
		hasList = true
	end
	local function OnListReady()
		pcall(function()
			if LoginData and LoginData.InitOftenServer then
				LoginData.InitOftenServer()
			end
			if RoleDeclareManager and RoleDeclareManager.GetRoleInformation then
				RoleDeclareManager.GetRoleInformation()
			end
		end)
		if onSuccess then onSuccess() end
	end
	if hasList then
		OnListReady()
		return
	end
	Log("--- [BƯỚC 3] Đang tải danh sách Server... ---")
	local url = LoginData.GetUrlByNet()
	Http.Request(url, function(text)
		if string.isNullOrEmpty(text) then
			Log("LỖI: Không thể tải danh sách server!")
			SaveOutput()
			return
		end
		local server_lists_initial = text
		if LoginData.isNeedDeEncrypConfig then
			server_lists_initial = CS.Encryption.ReplaceValue(text)
		end
		local parsed = json.decode(server_lists_initial)
		if parsed and parsed.server_lists then
			LoginData.data = parsed
			LoginData.SetServerList(parsed.server_lists)
			if parsed.recommend then LoginData.SetServiceRecommend(parsed.recommend) end
			if parsed.equipment_lists then LoginData.SetEquipmentList(parsed.equipment_lists) end
			LoginData.InitOftenServer()
			LoginData.SortOutServerList()
			Log("-> Đã tải xong danh sách (" .. tostring(#parsed.server_lists) .. " servers)!")
			Timer.Start(DELAY, function() OnListReady() end)
		else
			Log("LỖI: Định dạng danh sách server không hợp lệ!")
			SaveOutput()
		end
	end)
end

-- ====================================
-- 12. SDK AUTHENTICATION + GAME CHECK LOGIN
-- ====================================
StartFullLoginProcess = function()
	local curAcc = GetCurrentAccount()
	local username = curAcc.account or "accmuvh0001@gmail.com"
	local password = curAcc.password or "12345ZXC"
	local targetSrv = tonumber(_G.TARGET_SERVER_ID or curAcc.targetServer or CS.UnityEngine.PlayerPrefs.GetInt("Mod_Farm_TargetServer", 492)) or 492
	_G.Bot_ActiveSessionEmail = tostring(username)
	_G.Bot_ActiveSessionServer = targetSrv
	_G.Bot_NeedReloginNewConfig = false
	if _G.Mod_UpdateServerStatusUI then pcall(_G.Mod_UpdateServerStatusUI) end
	Log(string.format("--- [BƯỚC 2] GỬI SDK AUTH (ACC %d/%d: %s | SERVER %s | ROLE %d/4) ---",
		_G.CurrentAccountIndex or 1, #_G.BotAccounts, tostring(username), tostring(curAcc.targetServer or (_G.GetCurrentServerId and _G.GetCurrentServerId()) or 'Auto'), _G.CurrentRoleIndex or 1))
	local equip = MD5("muvh_bot_device_equip_uuid_001")
	local params = {
		username = username,
		pass = MD5(password),
		appid = "300270",
		equip = equip,
		device_id = equip,
		device_name = "SM-G975F",
		reg_from = "1",
		reg_type = "0",
		ad_id = "0",
		app_version = "1.0.0",
		sdk_version = "1.0.7",
		token = "",
		package_name = "com.vnyh.gp",
		_af = UrlEncode("appid=300270&gps_adid=&appsflyer_id="),
		_dana_v2 = UrlEncode("terminal=android&bundle_name=MU Vĩnh Hằng&bundle_id=com.vnyh.gp&appid=300270&did=" .. equip),
		__hw = UrlEncode("_res=1920*1080&bundle_name=MU Vĩnh Hằng&did=" .. equip)
	}
	local signKeys = {}
	for k, _ in pairs(params) do
		if k ~= "sign" and not string.find(k, "__") then
			table.insert(signKeys, k)
		end
	end
	table.sort(signKeys)
	local signItems = {}
	for _, k in ipairs(signKeys) do
		table.insert(signItems, k .. "=" .. UrlEncode(tostring(params[k])))
	end
	local signRaw = SDK_SALT .. table.concat(signItems, "&")
	params.sign = MD5(signRaw)
	local allKeys = {}
	for k, _ in pairs(params) do
		table.insert(allKeys, k)
	end
	table.sort(allKeys)
	local allItems = {}
	for _, k in ipairs(allKeys) do
		table.insert(allItems, UrlEncode(k) .. "=" .. UrlEncode(tostring(params[k])))
	end
	local safeSignStr = table.concat(allItems, "&")
	local t = tostring(os.time())
	local keyStr = MD5(SDK_SIGNATURE .. t)
	local encBytes = XXTEA_Encrypt(safeSignStr, keyStr)
	local o_b64 = Base64Encode(encBytes)
	local form = CS.UnityEngine.WWWForm()
	form:AddField("t", t)
	form:AddField("o", o_b64)
	local headers = {
		["encrypt-type"] = "xxtea",
		["Accept"] = "application/json"
	}
	Http.RequestHaveHandleArg("https://user.muvh.vn/vie/user_login", form, headers, function(text)
		if string.isNullOrEmpty(text) then
			Log("LỖI: Máy chủ SDK không phản hồi!")
			SaveOutput()
			return
		end
		local resp = json.decode(text)
		if not (resp and resp.ret == 0 and resp.data) then
			Log("LỖI: SDK Login thất bại: " .. tostring(resp and (resp.msg or resp.ret)))
			SaveOutput()
			return
		end
		Log("-> [SDK] Login Thành Công! UID: " .. tostring(resp.data.user_id))
		local sdkData = {
			userId = tostring(resp.data.user_id),
			name = tostring(resp.data.username or username),
			token = tostring(resp.data.access_token),
			time = tostring(resp.data.server_ts),
			gid = "1320",
			pid = "1320",
			ext = tostring(resp.data.login_verify_sign),
			opName = "v3koreagoogleyace_apk",
			serviceCode = "",
			loginType = "10"
		}
		LoginData.sdkUserId = sdkData.userId
		LoginData.neckName = sdkData.name
		LoginData.token = sdkData.token
		LoginData.gid = sdkData.gid
		LoginData.pId = sdkData.pid
		LoginData.loginExt = sdkData.ext
		LoginData.isSdkLogging = true
		LoginData.opName = sdkData.opName
		LoginData.loginType = sdkData.loginType
		LoginData.roleName = ""
		LoginData.roleLevel = 1
		LoginData.createTime = 1
		LoginData.equipmentList = nil
		local ckForm = CS.UnityEngine.WWWForm()
		ckForm:AddField("gid", tostring(LoginData.gid))
		ckForm:AddField("time", tostring(sdkData.time))
		ckForm:AddField("token", tostring(LoginData.token))
		ckForm:AddField("uid", tostring(LoginData.sdkUserId))
		ckForm:AddField("pid", tostring(LoginData.pId))
		ckForm:AddField("login_token", tostring(LoginData.token))
		ckForm:AddField("game_account_no", tostring(LoginData.sdkUserId))
		ckForm:AddField("username", tostring(LoginData.neckName))
		ckForm:AddField("login_verify_sign", tostring(LoginData.loginExt))
		local ckUrl = string.format(PlatformData.GetCKUrl(), LoginData.opName)
		Log("--- XÁC THỰC GAME CHECK LOGIN: " .. ckUrl .. " ---")
		Http.RequestHaveArg(ckUrl, ckForm, function(ckText)
			if string.isNullOrEmpty(ckText) then
				Log("LỖI: Game Auth Server không phản hồi!")
				SaveOutput()
				return
			end
			local backData = json.decode(ckText)
			if backData and not backData.errno then
				Log("-> [GAME AUTH] Thành Công!")
				Log("   - loginName: " .. tostring(backData.loginName))
				Log("   - sign: " .. tostring(backData.sign))
				LoginData.sign = backData.sign
				LoginData.userName = backData.loginName
				LoginData.time = backData.time
				LoginData.accessToken = backData.token
				local infos = string.split(backData.loginName, ":")
				LoginData.operId = tonumber(infos[1])
				LoginData.pId = tonumber(infos[2])
				LoginData.panelState = 3
				LoginData.equipmentList = nil
				if not string.isNullOrEmpty(LoginData.accessToken) and CS.MuInterface and CS.MuInterface.Instance then
					CS.MuInterface.Instance:SendToken(LoginData.accessToken)
				end
				EventManager.Dispatch(Event.Login_LoginSuccess)
				SaveOutput()
				Timer.Start(DELAY, function()
					EnsureServerListLoaded(function()
						Timer.Start(DELAY, function()
							ConnectToTargetServer()
						end)
					end)
				end)
			else
				Log("LỖI: Game Check Login thất bại: " .. tostring(backData and backData.msg))
				SaveOutput()
			end
		end)
	end)
end
_G.StartFullLoginProcess = StartFullLoginProcess

if _E.BindTailCallbacks then
	_E.BindTailCallbacks(CheckAndRunBloodCastleOrDemonPlaza, StartNewbieQuestPipeline, ConnectToTargetServer, EnsureServerListLoaded, StartFullLoginProcess)
end

-- ====================================
-- [MOD FEATURE]: BỘ ĐIỀU KHIỂN TRUNG TÂM BOT FARM & TEST TRIGGER (EXECUTE ADMIN)
-- ====================================
_G.Bot_Running = false
_G.Bot_PauseTask = false

_G.StartAutoFarmBot = function()
	_G.Bot_Running = true
	_G.Bot_PauseTask = false
	_G.IsSwitchingAccount = false
	_G.HasCreatedRoleForTarget = false
	_G.IsRoleCreating = false
	if _G.ModUpdatePanelBotBtn then pcall(_G.ModUpdatePanelBotBtn) end

	-- ====================================
	-- [MOD FEATURE]: ĐỐI CHIẾU EMAIL & SERVER KHI BẮT ĐẦU (AUTO RELOGIN ON NEW CONFIG)
	-- Mô tả: Khi bấm BẮT ĐẦU, lưu và đối chiếu Email + Server mục tiêu (targetEmail, targetSrv)
	--        với phiên đang chạy (_G.Bot_ActiveSessionEmail, _G.Bot_ActiveSessionServer).
	--        Nếu khác nhau (hoặc vừa ấn Lưu Cấu Hình với tài khoản/server mới), lập tức Logout
	--        và thực hiện lại toàn bộ chu trình đăng nhập mới từ đầu!
	-- ====================================
	local curAcc = GetCurrentAccount and GetCurrentAccount()
	local targetEmail = tostring((curAcc and curAcc.account) or "")
	local targetSrv = tonumber(_G.TARGET_SERVER_ID or (curAcc and curAcc.targetServer) or CS.UnityEngine.PlayerPrefs.GetInt("Mod_Farm_TargetServer", 492)) or 492
	local needReloginNewConfig = (_G.Bot_NeedReloginNewConfig == true)
	if _G.Bot_ActiveSessionEmail and _G.Bot_ActiveSessionEmail ~= "" and targetEmail ~= "" then
		if string.lower(tostring(_G.Bot_ActiveSessionEmail)) ~= string.lower(targetEmail) then
			needReloginNewConfig = true
		end
	end
	if _G.Bot_ActiveSessionServer and tonumber(_G.Bot_ActiveSessionServer) ~= targetSrv then
		needReloginNewConfig = true
	end

	local isInGame = false
	pcall(function()
		if _G.LoginData and _G.LoginData.InGame then
			isInGame = true
		end
		if _G.SceneData and _G.SceneData.mapId and tonumber(_G.SceneData.mapId) > 0 then
			isInGame = true
		end
		if _G.RoleManager and _G.RoleManager.me ~= nil then
			isInGame = true
		end
		if _G.ViewData and _G.ViewData.meData ~= nil then
			isInGame = true
		end
		if _G.UIManager and _G.UIManager.IsVisible and _G.UIManager.IsVisible("Main_MainMenuUI") then
			isInGame = true
		end
	end)

	-- Nếu phát hiện cấu hình Email hoặc Server đã thay đổi so với phiên hiện tại:
	if needReloginNewConfig then
		local prevEmail = tostring(_G.Bot_ActiveSessionEmail or "None")
		local prevSrv = tostring(_G.Bot_ActiveSessionServer or "None")
		_G.Bot_ActiveSessionEmail = targetEmail
		_G.Bot_ActiveSessionServer = targetSrv
		_G.Bot_NeedReloginNewConfig = false
		if _G.Mod_UpdateServerStatusUI then pcall(_G.Mod_UpdateServerStatusUI) end

		local hasActiveConnectionOrScene = isInGame
		pcall(function()
			if _G.NetManager and _G.NetManager.IsConnect and _G.NetManager.IsConnect() then
				hasActiveConnectionOrScene = true
			end
			if _G.LoginData and _G.LoginData.roleList and #_G.LoginData.roleList > 0 then
				hasActiveConnectionOrScene = true
			end
			if _G.UIManager and _G.UIManager.IsVisible then
				if _G.UIManager.IsVisible("Login_LoginRoleUI") or _G.UIManager.IsVisible("Login_LoginCreateRoleUI") then
					hasActiveConnectionOrScene = true
				end
			end
		end)

		if hasActiveConnectionOrScene then
			Log("=========================================================================", true)
			Log(string.format(">>> [CẤU HÌNH MỚI]: Đổi từ (%s | S%s) sang (%s | S%d) -> Đăng xuất & Bắt đầu chu trình mới! <<<",
				prevEmail, prevSrv, targetEmail, targetSrv), true)
			Log("=========================================================================", true)
			SaveOutput()
			_G.CurrentRoleIndex = 1
			_G.TargetRoleIndex = 1
			_G.HasCreatedRoleForTarget = false
			_G.IsRoleCreating = false
			_G.Bot_IsInGameWorld = false
			_G.IsSwitchingAccount = false
			if ClearAllTaskDataAndState then ClearAllTaskDataAndState() end
			ForceLogoutToLogin()
			Timer.Start(2.5, function()
				DismissBlockers()
				StartFullLoginProcess()
			end)
			return
		end
	else
		-- Lưu thông tin Email & Server của phiên hiện tại khi bắt đầu
		if targetEmail ~= "" then
			_G.Bot_ActiveSessionEmail = targetEmail
		end
		_G.Bot_ActiveSessionServer = targetSrv
		_G.Bot_NeedReloginNewConfig = false
		if _G.Mod_UpdateServerStatusUI then pcall(_G.Mod_UpdateServerStatusUI) end
	end

	if isInGame then
		if _G.LoginData then _G.LoginData.InGame = true end
		pcall(function()
			if _G.UIManager then
				if _G.UIID and _G.UIID.LoginRoleUI then _G.UIManager.Hide(_G.UIID.LoginRoleUI) end
				if _G.UIID and _G.UIID.LoginCreateRoleUI then _G.UIManager.Hide(_G.UIID.LoginCreateRoleUI) end
				if _G.UIID and _G.UIID.LoginUI then _G.UIManager.Hide(_G.UIID.LoginUI) end
				_G.UIManager.Hide("Login_LoginRoleUI")
				_G.UIManager.Hide("Login_LoginCreateRoleUI")
				_G.UIManager.Hide("Login_LoginUI")
			end
		end)
		local pMe = _G.RoleManager and _G.RoleManager.me
		local curLvl = 1
		pcall(function()
			if _G.ViewData and _G.ViewData.meData and _G.ViewData.meData.level then
				curLvl = tonumber(_G.ViewData.meData.level) or curLvl
			elseif pMe and pMe.data and pMe.data.level then
				curLvl = tonumber(pMe.data.level) or curLvl
			elseif pMe and pMe.level then
				curLvl = tonumber(pMe.level) or curLvl
			elseif _G.LoginData and _G.LoginData.roleLevel then
				curLvl = tonumber(_G.LoginData.roleLevel) or curLvl
			end
		end)
		local curRoleName = tostring((pMe and pMe.name) or (pMe and pMe.data and pMe.data.name) or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.name) or "Me")
		local curServerId, curServerName = nil, "S492"
		pcall(function()
			if _G.GetActualCurrentServerInfo then
				curServerId, curServerName = _G.GetActualCurrentServerInfo()
			end
		end)
		curServerName = curServerName or "VĨNH HẰNG 492"
		local execTime = os.date("%H:%M:%S")
		Log("=========================================================================")
		Log(string.format(">>> [EXEC ADMIN %s] NV: %s (Lv %d) - %s <<<", execTime, curRoleName, curLvl, curServerName), true)
		Log("=========================================================================")
		SaveOutput()
		ApplyFovAndSpeed()
		DismissBlockers()
		if curLvl >= 20 then
			if AutoBuyPotionsIfLow then
				AutoBuyPotionsIfLow(50, 200)
			end
			if AutoClaimNewServerRewards then
				AutoClaimNewServerRewards()
			end
			if AutoClaimDailyWelfare then
				AutoClaimDailyWelfare()
			end
		end
		-- BỎ hoàn toàn điều kiện curLvl >= 100 gây nhảy ra bãi farm dừng sớm
		-- LUÔN LUÔN kích hoạt StartNewbieQuestPipeline để chạy vòng lặp quét và claim nhiệm vụ 1s/lần!
		Log(string.format(">>> [CẤP ĐỘ %d] KHỞI CHẠY VÒNG LẶP CHÍNH QUÉT VÀ CLAIM NHIỆM VỤ (1s/LẦN)! <<<", curLvl), true)
		SaveOutput()
		-- Từ Lv 1 -> 10: Tĩnh lặng làm nhiệm vụ tân thủ thuần túy, chưa can thiệp gì
		-- Khi đạt Level 10+ sẽ tự động kích hoạt nhập 14 mã Giftcode bên trong StartNewbieQuestPipeline
		StartNewbieQuestPipeline()
	else
		-- Kiểm tra xem có đang ở màn hình Chọn Nhân Vật không
		local isAtSelectRole = false
		local curRoleCount = 0
		pcall(function()
			if _G.LoginData and _G.LoginData.roleList then
				curRoleCount = #_G.LoginData.roleList
				if curRoleCount > 0 then
					isAtSelectRole = true
				end
			end
			if _G.UIManager and _G.UIManager.IsVisible then
				if _G.UIManager.IsVisible("Login_LoginRoleUI") or (_G.UIID and _G.UIID.LoginRoleUI and _G.UIManager.IsVisible(_G.UIID.LoginRoleUI)) then
					isAtSelectRole = true
				end
			end
			local curRoleUI = _G.UIManager and _G.UIManager.GetUiByName and _G.UIManager.GetUiByName("Login_LoginRoleUI")
			if curRoleUI and curRoleUI.go_NameList and not IsNil(curRoleUI.go_NameList) and curRoleUI.go_NameList.activeInHierarchy then
				isAtSelectRole = true
			end
		end)
		-- Kiểm tra xem có đang ở màn hình Tạo Nhân Vật không (LoginCreateRoleUI)
		local isAtCreateRole = false
		pcall(function()
			if _G.UIManager and _G.UIManager.IsVisible then
				if _G.UIManager.IsVisible("Login_LoginCreateRoleUI") or (_G.UIID and _G.UIID.LoginCreateRoleUI and _G.UIManager.IsVisible(_G.UIID.LoginCreateRoleUI)) then
					isAtCreateRole = true
				end
			end
			local curCreateUI = _G.UIManager and _G.UIManager.GetUiByName and _G.UIManager.GetUiByName("Login_LoginCreateRoleUI")
			if curCreateUI and not IsNil(curCreateUI) then
				isAtCreateRole = true
			end
		end)
		if isAtCreateRole then
			Log(">>> [PHÁT HIỆN MÀN HÌNH TẠO NHÂN VẬT]: Đang ở LoginCreateRoleUI -> Tự động tạo nhân vật Pháp Sư (DW) ở Slot 1! <<<", true)
			SaveOutput()
			CreateRoleAndEnterGame(1)
			return
		end
		if isAtSelectRole then
			if curRoleCount > 0 then
				local targetIdx = _G.CurrentRoleIndex or 1
				Log(string.format(">>> [CHỌN NHÂN VẬT]: Phát hiện đang ở màn hình Chọn Nhân Vật (%d NV) -> Tự động chọn Slot %d để vào game! <<<", curRoleCount, targetIdx), true)
				SaveOutput()
				SelectRoleByIndex(targetIdx)
				return
			else
				Log(">>> [TÀI KHOẢN MỚI]: Bệ đá trống / Chưa có nhân vật nào -> Tự động tạo mới nhân vật ở Slot 1! <<<", true)
				SaveOutput()
				CreateRoleAndEnterGame(1)
				return
			end
		end
		-- ĐANG Ở MÀN HÌNH SPLASH / TITLE / LOGIN (chưa vào game, chưa ở SelectRole)
		Log(">>> [MÀN HÌNH LOGIN / SPLASH]: Bắt đầu tiến trình Đăng nhập tự động & Kết nối Server! <<<", true)
		SaveOutput()
		DismissBlockers()
		StartFullLoginProcess()
	end
end
_G.Bot_Start = _G.StartAutoFarmBot

_G.StopAutoFarmBot = function()
	_G.Bot_Running = false
	_G.Bot_PauseTask = true
	pcall(SaveAccountTimeRecords)
	if _G.ModUpdatePanelBotBtn then pcall(_G.ModUpdatePanelBotBtn) end
	if _G.BotQuestMonitorTimer then
		pcall(function() Timer.Stop(_G.BotQuestMonitorTimer) end)
		_G.BotQuestMonitorTimer = nil
	end
	if _G.Global30sUpgradeTimer then
		pcall(function() Timer.Stop(_G.Global30sUpgradeTimer) end)
		_G.Global30sUpgradeTimer = nil
	end
	if _G.Mod_InstanceMonitorTimer then
		pcall(function() Timer.Stop(_G.Mod_InstanceMonitorTimer) end)
		_G.Mod_InstanceMonitorTimer = nil
	end
	if _G.StopFarmKCRoutine then
		pcall(_G.StopFarmKCRoutine)
	end
	if _G.Mod_FarmKCTimer then
		pcall(function() Timer.Stop(_G.Mod_FarmKCTimer) end)
		_G.Mod_FarmKCTimer = nil
	end
	_G.Mod_FarmKCRunning = false
	pcall(function()
		local me = _G.RoleManager and _G.RoleManager.me
		if me then
			if me.StopMove then me:StopMove() end
			if me.SetAutoTaskFight and _G.AutoFightStrKey then me:SetAutoTaskFight(_G.AutoFightStrKey.UnAutoFight) end
			if me.SetAutoHookFight then me:SetAutoHookFight(false) end
		end
		if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then _G.QiJiHelperData.SetAutoFightData(false) end
		if _G.AutoTaskManage and _G.AutoTaskManage.SetAutoTask then _G.AutoTaskManage.SetAutoTask(false) end
		if _G.TaskManager and _G.TaskManager.TaskPathStop then _G.TaskManager.TaskPathStop() end
	end)
	Log(">>> ĐÃ DỪNG / TẠM DỪNG TOÀN BỘ CHU TRÌNH BOT FARM! <<<", true)
	SaveOutput()
end
_G.Bot_Pause = _G.StopAutoFarmBot
_G.Bot_Stop = _G.StopAutoFarmBot

_G.ToggleAutoFarmBot = function()
	if _G.Bot_Running then
		_G.StopAutoFarmBot()
	else
		_G.StartAutoFarmBot()
	end
end
_G.Bot_Toggle = _G.ToggleAutoFarmBot

-- ====================================
-- [MOD FEATURE]: TRẠNG THÁI CHỜ KÍCH HOẠT BOT FARM TỪ MENU VỤT
-- Mô tả: Mặc định không tự chạy khi vào game, chỉ khởi động khi người dùng bấm START trong Menu Mod.
-- ====================================
_G.Bot_Running = false
_G.Bot_PauseTask = true
if _G.ModUpdatePanelBotBtn then pcall(_G.ModUpdatePanelBotBtn) end

end
gameMgr = require("GameMgr")
luaClassManager = require("LuaCore/LuaClass/LuaClassManager")
luaTemplateManager = require("LuaCore/LuaTemplate/LuaTemplateManager")
RedPointLoader = require("GamePlay/RedPoint/Base/RedPointLoader")
QuickFind = require("QuickFind/QuickFind")
local Main = {}
local this = Main

function Main.Start()
  collectgarbage("setpause", 120)
  collectgarbage("setstepmul", 500)
  TableLoad:Init()
  CS.UnityEngine.Application.runInBackground = true
  Game.New():OnInit()
  Profiler.BeginSample("MAIN.Start")
  Coroutine.Start(Main.DoStart, Main)
  Profiler.BeginSample("MAIN.Start")
  EventManager.Regist(Event.Game_Restart, this.Destroy)
  EmmyluaDebug.InitEmmyluaDebug()
  luaClassManager:Initialize()
  luaTemplateManager:Initialize()
  gameMgr:Initialize()
  RedPointLoader:Initialize()
  QuickFind:Init()
end

function Main.DoStart()
  ConfigManager.Preload()
  this.InitCallback()
  this.InitScreen()
  LoginData.LoginLog("------------\229\136\157\229\167\139\229\140\150shader:::::" .. tostring(CS.System.DateTime.Now.Ticks))
  this.InitRes()
  LoginData.LoginLog("------------\229\136\157\229\167\139\229\140\150shader\229\174\140\230\136\144,\229\138\160\232\189\189\229\156\176\229\189\162\229\188\128\229\167\139:::::" .. tostring(CS.System.DateTime.Now.Ticks))
  Scene.EnterLogin()
  LoginData.LoginLog("------------\232\174\176\229\189\149\229\174\140\230\136\144:::::" .. tostring(CS.System.DateTime.Now.Ticks))
end

function Main.InitCallback()
  local main = CS.Main.instance
  main.updateWithTime = this.Update
  main.lateUpdate = this.LateUpdate
  main.onLowMemory = this.OnLowMemory
  main.onSceneLoaded = this.OnSceneLoaded
  main.onApplicationFocus = this.OnApplicationFocus
  main.onApplicationPause = this.OnApplicationPause
  main.onApplicationQuit = this.OnApplicationQuit
end

function Main.ClearCallback()
  local main = CS.Main.instance
  main.updateWithTime = nil
  main.lateUpdate = nil
  main.onLowMemory = nil
  main.onSceneLoaded = nil
  main.onApplicationFocus = nil
  main.onApplicationPause = nil
  main.onApplicationQuit = nil
end

function Main.InitScreen()
  this.settingFps = tonumber(GlobalConfig.GetGlobalConfig(2150001))
  this.fpsTime = tonumber(GlobalConfig.GetGlobalConfig(2150002))
end

function Main.InitRes()
  if not CS.Framework.ResourceManager.editorMode then
    this.InitShader()
  end
end

function Main.InitShader()
  local request = CS.Framework.ResourceManager.LoadAssetAsync("Shader/ShaderVariantCollection.shadervariants", typeof(CS.UnityEngine.ShaderVariantCollection))
  Coroutine.Yield(request)
  if request.isError then
    logError(request.error)
    Coroutine.Break()
  end
  request.res:WarmUp()
  CS.Framework.ShaderEx.Init(request.task.bundleRequest.res)
end

function Main.Destroy()
  this.ClearCallback()
  QuickFind:Destory()
end

function Main.Update(deltaTime, unscaledDeltaTime)
  Profiler.BeginSample("Timer.RedPointManager")
  RedPointManager:Update()
  Profiler.EndSample()
  Profiler.BeginSample("Timer.Update")
  this.UpdateTime(deltaTime, unscaledDeltaTime)
  Profiler.EndSample()
  Profiler.BeginSample("NetManager.Update")
  NetManager.Update()
  Profiler.EndSample()
  Profiler.BeginSample("GameLogic.Update")
  GameLogic.Update()
  Profiler.EndSample()
  Profiler.BeginSample("GamePlay.Update")
  GamePlay.Update()
  Profiler.EndSample()
  Profiler.BeginSample("UIManager.Update")
  UIManager.Update()
  Profiler.EndSample()
  Profiler.BeginSample("PoolManagerTest.Update")
  PoolManagerTest.Update()
  Profiler.EndSample()
  DelayRefreshManager:Update()
  Profiler.BeginSample("Utility.Update")
  Utility.Update()
  Profiler.EndSample()
  Profiler.BeginSample("GameMgr.Update")
  gameMgr:Update()
  Profiler.EndSample()
end

function Main.UpdateTime(time, unscaledTime)
  Time.Update(time, unscaledTime)
  Timer.Update()
  UnscaledTimer.Update()
end

function Main.LateUpdate()
  Profiler.BeginSample("GameLogic.LateUpdate")
  GameLogic.LateUpdate()
  Profiler.EndSample()
  Profiler.BeginSample("GamePlay.LateUpdate")
  GamePlay.LateUpdate()
  Profiler.EndSample()
  Profiler.BeginSample("UIManager.LateUpdate")
  UIManager.LateUpdate()
  Profiler.EndSample()
end

function Main.OnLowMemory()
  logPurple("Low memory reported!")
  PoolManagerTest.Destroy()
  EventManager.Dispatch(Event.Game_LowMemory)
  CS.Framework.ResourceManager.ClearMemory()
  collectgarbage("collect")
  CS.System.GC.Collect()
end

function Main.OnSceneLoaded(name)
  EventManager.Dispatch(Event.Game_SceneLoaded, name)
end

function Main.OnApplicationFocus(focus)
  EventManager.Dispatch(Event.Game_ApplicationFocus, focus)
end

function Main.OnApplicationPause(pause)
  EventManager.Dispatch(Event.Game_ApplicationPause, pause)
end

function Main.OnApplicationQuit()
  EventManager.Dispatch(Event.Game_ApplicationQuit)
end

local detailTime = 0
local totalTime = 0
local FpsTab = {}

function Main.FpsCheck()
  if GameSettingsData.perfermanceOption ~= EPerfermanceType.Low then
    detailTime = detailTime + 0.02
    totalTime = totalTime + 0.02
    if 1 <= detailTime then
      detailTime = 0
      if CS.DebugTool.FPSCounter.s_fps > 10 then
        table.insert(FpsTab, CS.DebugTool.FPSCounter.s_fps)
      end
    end
    if totalTime >= this.fpsTime then
      local totalCount = 0
      for i, v in ipairs(FpsTab) do
        totalCount = totalCount + v
      end
      if totalCount / table.count(FpsTab) < this.settingFps then
        GameSettingsController.SetPerfermanceLevel(EPerfermanceType.Low)
      else
        FpsTab = {}
        totalTime = 0
      end
    end
  end
end

Main.Start()
ModMenuUI = {}
