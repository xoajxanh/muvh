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

-- =========================================================================
-- [MOD FEATURE]: TỰ ĐỘNG THAM GIA PHÓ BẢN HUYẾT LÂU (AUTO HL) & QUẢNG TRƯỜNG QUỶ (AUTO QTQ)
-- Mô tả:
--   1. Điều kiện cấp độ: Chỉ kích hoạt khi nhân vật đã đạt `curLvl >= Lv Bỏ NH` (mặc định 145)
--      để Nữ Hoàng và HL/QTQ không chạy song song.
--   2. Tách độc lập 2 nút cấu hình: `AUTO HL` (`_G.Mod_AutoBCActive`) và `AUTO QTQ` (`_G.Mod_AutoDSActive`).
--   3. Tự động mua vé bằng 75 Kim Cương Khóa (1000050) nếu túi chưa có vé:
--      - Huyết Lâu (`Áo Choàng Trong Suốt` 8000050/8000057): `ReqBuy(30107, 1)` (75 KC Khóa).
--      - Quảng Trường Quỷ (`Vé Thông Hành QTQ` 8000040/8000047): `ReqBuy(30106, 1)` (75 KC Khóa).
--      - Nếu `< 75 KC Khóa`: Bỏ qua phó bản và tiếp tục farm quái.
--   4. Chống trùng Huyết Lâu nhiều tài khoản (`FirstPlayer` 10s Lobby Queue):
--      - Khi vào sảnh chờ 10s của Huyết Lâu (`1012000..1012099`), quét người chơi xung quanh (`GetRolesByType(1)`).
--      - Nếu không có ai (`otherPlayerCount == 0`): Đánh dấu `FirstPlayer = true`, đứng chờ hết 10s sảnh
--        rồi bấm `[Mở Ngay]` (`ReqSkipWait`) và cắm đầu chạy thẳng lên `14#30` (chỉ bật AutoFight khi cách `<= 1.5m`).
--      - Nếu phát hiện có người chơi khác đang chờ sẵn trong sảnh: Thoát Huyết Lâu ngay (`ReqExitInstance`,
--        không mất vé/lượt), ghi nhớ thời gian đếm ngược còn lại + 2s (`_G.Mod_BC_NextRetryTime`) để chờ
--        `FirstPlayer` mở xong rồi mới vào lại.
--   5. Ngắt tức thì khi đạt cấp độ mục tiêu (Lv 200): Kiểm tra mỗi 0.5s ngay trong phó bản, đạt cấp mục tiêu
--      lập tức thoát phó bản và chuyển tài khoản ngay.
-- =========================================================================
_G.Mod_InstanceMonitorTimer = _G.Mod_InstanceMonitorTimer or nil
_G.Mod_IsRunningInstance = _G.Mod_IsRunningInstance or false
_G.Mod_BC_AllowSkipWait = _G.Mod_BC_AllowSkipWait or false
_G.Mod_BC_NextRetryTime = _G.Mod_BC_NextRetryTime or 0

local function GetConfiguredStopQueenLevel()
	local stopLv = tonumber(_G.Mod_StopQueenLevel)
	if not stopLv or stopLv <= 0 then
		pcall(function()
			if CS and CS.UnityEngine and CS.UnityEngine.PlayerPrefs then
				stopLv = tonumber(CS.UnityEngine.PlayerPrefs.GetInt("Mod_Farm_StopQueenLevel", 145))
			end
		end)
	end
	stopLv = tonumber(stopLv) or 145
	if stopLv < 1 then stopLv = 1 end
	_G.Mod_StopQueenLevel = stopLv
	return stopLv
end
_G.GetConfiguredStopQueenLevel = GetConfiguredStopQueenLevel

local function GetCurrentBoundDiamonds()
	local kc = 0
	pcall(function()
		if _G.RoleUtility and _G.RoleUtility.GetCoinNum then
			local c = _G.RoleUtility.GetCoinNum(1000050)
			if c and tonumber(c) then kc = tonumber(c); return end
		end
		if _G.BagInfoData and _G.BagInfoData.GetCoinNum then
			local c = _G.BagInfoData.GetCoinNum(1000050)
			if c and tonumber(c) then kc = tonumber(c); return end
		end
		if _G.ViewData and _G.ViewData.meData and _G.ViewData.meData.boundIngot then
			kc = tonumber(_G.ViewData.meData.boundIngot) or 0
		end
	end)
	return kc
end
_G.GetCurrentBoundDiamonds = GetCurrentBoundDiamonds

-- Lắng nghe sự kiện cập nhật trạng thái phó bản:
-- Riêng Huyết Lâu (1012000..1012099) chỉ bấm Mở Ngay khi đã xác nhận FirstPlayer và hết 10s sảnh chờ
pcall(function()
	if _G.EventManager and _G.Event and _G.Event.UpdateCopyDataInfo then
		_G.EventManager.RegistEvent(_G.Event.UpdateCopyDataInfo, function(id, msg)
			if not _G.Bot_Running or _G.Bot_PauseTask then return end
			local cMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
			local inBC = (cMap >= 1012000 and cMap <= 1012099)
			if inBC and not _G.Mod_BC_AllowSkipWait then
				return
			end
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
	if not _G.Mod_AutoBCActive and not _G.Mod_AutoDSActive then
		if onFinished then onFinished() end
		return
	end
	if not _G.Bot_Running or _G.Bot_PauseTask then
		if onFinished then onFinished() end
		return
	end
	local pMe = _G.RoleManager and _G.RoleManager.me
	local curLvl = (_G.GetAccuratePlayerLevel and _G.GetAccuratePlayerLevel())
		or tonumber((pMe and pMe.level) or (pMe and pMe.data and pMe.data.level) or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.level) or 1)
	local stopQueenLvl = GetConfiguredStopQueenLevel()
	local targetLvl = (_G.GetConfiguredTargetLevel and _G.GetConfiguredTargetLevel()) or 200

	-- Nếu đã đạt cấp mục tiêu (Lv 200) -> Ngắt ngay để đổi tài khoản
	if curLvl >= targetLvl then
		if _G.OnAccountReachLevelGoal then
			_G.OnAccountReachLevelGoal(curLvl, targetLvl)
		end
		return
	end

	-- Điều kiện kích hoạt HL/QTQ: Nhân vật phải đạt từ `Lv Bỏ NH` trở lên (không chạy song song với Nữ Hoàng)
	if curLvl < stopQueenLvl or curLvl < 100 then
		if onFinished then onFinished() end
		return
	end

	local curMapId = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
	local isCurInBC = (curMapId >= 1012000 and curMapId <= 1012099)
	local isCurInDS = (curMapId >= 1010000 and curMapId <= 1010099)
	local isInInstance = isCurInBC or isCurInDS or (_G.TranScriptData and _G.TranScriptData.InTranscript)

	local function StartInstanceMonitorLoop()
		if _G.Mod_InstanceMonitorTimer then
			pcall(function() Timer.Stop(_G.Mod_InstanceMonitorTimer) end)
			_G.Mod_InstanceMonitorTimer = nil
		end
		_G.Mod_IsRunningInstance = true
		_G.Mod_BC_AllowSkipWait = false
		Log("[Phó Bản] : Đang giám sát phó bản (Kiểm tra sảnh chờ & mục tiêu cấp độ)...", true)
		SaveOutput()
		local monitorTicks = 0
		local hasSkippedWait = false
		local bcLobbyChecked = false
		local bcIsFirstPlayer = false
		local bcEntryRealTime = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()

		-- Hàm dừng đánh & xóa mục tiêu chuẩn bản Client (để nhân vật cắm đầu chạy thẳng tới điểm hẹn không bị quái/cổng kéo lại)
		local function StopFightAndClearTargetInDungeon()
			pcall(function()
				local me = _G.RoleManager and _G.RoleManager.me
				if not me then return end
				if me.isAutoFight then
					if me.StopAutoFight then me:StopAutoFight() end
					if _G.EventManager and _G.Event and _G.Event.Role_StopAutoFight then
						_G.EventManager.Dispatch(_G.Event.Role_StopAutoFight)
					end
				end
				if me.SetAutoHookFight then me:SetAutoHookFight(false) end
				if me.meAutoFight and me.meAutoFight.SetAutoFightHookStart then
					me.meAutoFight:SetAutoFightHookStart(false)
				end
				if _G.QiJiHelperData and _G.QiJiHelperData.isAutoFight and _G.QiJiHelperData.SetAutoFightData then
					_G.QiJiHelperData.SetAutoFightData(false)
				end
				me.TargetAvatar = nil
				if me.SetTarget then me:SetTarget(nil) end
			end)
		end

		-- Hàm chạy thẳng tới tọa độ đích (RushToCoord chuẩn bản Client):
		-- Khi khoảng cách > 1.5m: Dừng AutoFight, xóa mục tiêu, cắm đầu chạy thẳng.
		-- Chỉ khi khoảng cách <= 1.5m: Mới bật AutoFight đánh quái!
		local function RushToDungeonCoordAndFight(tx, ty, threshold)
			threshold = tonumber(threshold) or 1.5
			pcall(function()
				local me = _G.RoleManager and _G.RoleManager.me
				if not me or me.isDead then return end
				local curX = (me.serverCoord and me.serverCoord.x) or (me.cellPos and me.cellPos.x) or (me.Position and me.Position.x) or 0
				local curY = (me.serverCoord and me.serverCoord.y) or (me.cellPos and me.cellPos.y) or (me.Position and me.Position.y) or 0
				local dist = math.sqrt((curX - tx)^2 + (curY - ty)^2)
				if dist > threshold then
					-- CẮM ĐẦU CHẠY KHÔNG ĐƯỢC ĐÁNH
					StopFightAndClearTargetInDungeon()
					if me.MoveTo then
						me:MoveTo({ x = tx, y = ty }, 0)
					end
				else
					-- ĐÃ TIẾP CẬN VỊ TRÍ <= 1.5m -> BẬT AUTOFIGHT
					if me.SetAutoFight and not me.isAutoFight then
						me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight")
					end
					if _G.QiJiHelperData and not _G.QiJiHelperData.isAutoFight and _G.QiJiHelperData.SetAutoFightData then
						_G.QiJiHelperData.SetAutoFightData(true)
					end
				end
			end)
		end

		-- Quét 0.5s/lần để kiểm tra cấp mục tiêu, quét sảnh chờ 10s Huyết Lâu và giám sát chiến đấu
		_G.Mod_InstanceMonitorTimer = Timer.StartLoop(0.5, -1, function()
			if not _G.Bot_Running or _G.Bot_PauseTask then return end
			monitorTicks = monitorTicks + 1

			local liveMe = _G.RoleManager and _G.RoleManager.me
			local liveLvl = (_G.GetAccuratePlayerLevel and _G.GetAccuratePlayerLevel())
				or tonumber((liveMe and liveMe.level) or (liveMe and liveMe.data and liveMe.data.level) or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.level) or curLvl)
			local liveTargetLvl = (_G.GetConfiguredTargetLevel and _G.GetConfiguredTargetLevel()) or 200

			-- 1. KIỂM TRA ĐẠT CẤP ĐỘ MỤC TIÊU (LV 200) NGAY TRONG PHÓ BẢN -> LẬP TỨC NGẮT & ĐỔI ACC
			if liveLvl >= liveTargetLvl then
				if _G.Mod_InstanceMonitorTimer then
					pcall(function() Timer.Stop(_G.Mod_InstanceMonitorTimer) end)
					_G.Mod_InstanceMonitorTimer = nil
				end
				_G.Mod_IsRunningInstance = false
				_G.Mod_BC_AllowSkipWait = false
				Log(string.format("[Phó Bản] : Đạt cấp mục tiêu (%d/%d) ngay trong phó bản -> Lập tức thoát phó bản và đổi tài khoản!", liveLvl, liveTargetLvl), true)
				SaveOutput()
				pcall(function()
					if _G.TranScriptController and _G.TranScriptController.ReqExitInstance then
						_G.TranScriptController.ReqExitInstance()
					elseif _G.networkRequest and _G.networkRequest.ReqExitInstance then
						_G.networkRequest.ReqExitInstance()
					end
				end)
				if _G.OnAccountReachLevelGoal then
					_G.OnAccountReachLevelGoal(liveLvl, liveTargetLvl)
				end
				return
			end

			local cMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
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
				_G.Mod_BC_AllowSkipWait = false
				Log("[Phó Bản] : Đã rời phó bản! Tiếp tục chu trình...", true)
				SaveOutput()
				DismissBlockers()
				if onFinished then onFinished() end
				return
			end

			if inTrans then
				if inBC then
					-- =========================================================================
					-- [MOD FEATURE]: CHỐNG TRÙNG HUYẾT LÂU NHIỀU ACC (FIRSTPLAYER 10S LOBBY CHECK)
					-- =========================================================================
					local bcState = 0
					local bcRemainCountdown = 10
					pcall(function()
						local basic = _G.TranScriptData and _G.TranScriptData.InTranscriptData and _G.TranScriptData.InTranscriptData.basic
						if basic then
							bcState = tonumber(basic.state) or 0
							local srvMs = (_G.Time and _G.Time.GetServerTime and _G.Time.GetServerTime()) or 0
							if basic.nextStateTime and srvMs > 0 then
								local diff = math.ceil((tonumber(basic.nextStateTime) - tonumber(srvMs)) / 1000)
								if diff >= 0 and diff <= 60 then
									bcRemainCountdown = diff
								end
							end
						end
					end)

					-- Quét người chơi khác trong sảnh chờ ngay sau khi load map (monitorTicks >= 2 ~ 1.0s)
					if not bcLobbyChecked and monitorTicks >= 2 then
						bcLobbyChecked = true
						local otherPlayerCount = 0
						local otherPlayerName = nil
						local minOtherRoleId = nil
						local myRoleId = (liveMe and liveMe.data and liveMe.data.id) or (liveMe and liveMe.id) or 0
						pcall(function()
							local allPlayers = _G.RoleManager and _G.RoleManager.GetRolesByType and _G.RoleManager.GetRolesByType(1)
							if allPlayers then
								for _, p in pairs(allPlayers) do
									if p and not p.isDead then
										local pId = (p.data and p.data.id) or p.id or 0
										if pId ~= 0 and pId ~= myRoleId then
											otherPlayerCount = otherPlayerCount + 1
											if not otherPlayerName then
												otherPlayerName = (p.data and p.data.name) or p.name or tostring(pId)
											end
											if not minOtherRoleId or pId < minOtherRoleId then
												minOtherRoleId = pId
											end
										end
									end
								end
							end
						end)

						if otherPlayerCount == 0 or (bcRemainCountdown >= 9 and myRoleId > 0 and minOtherRoleId and myRoleId < minOtherRoleId) then
							bcIsFirstPlayer = true
							bcEntryRealTime = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
							Log(string.format("[Huyết Lâu] : Quét sảnh không có người vào trước -> Đánh dấu [FirstPlayer]! Đứng chờ %ds sảnh rồi bấm [Mở Ngay]...", bcRemainCountdown), true)
							SaveOutput()
						else
							-- Phát hiện có người chơi khác đã ở trong sảnh trước -> Thoát ngay và chờ họ mở xong
							local waitSec = math.max(4, math.min(12, bcRemainCountdown)) + 2
							local nowSec = os.time()
							_G.Mod_BC_NextRetryTime = nowSec + waitSec
							if _G.Mod_InstanceMonitorTimer then
								pcall(function() Timer.Stop(_G.Mod_InstanceMonitorTimer) end)
								_G.Mod_InstanceMonitorTimer = nil
							end
							_G.Mod_IsRunningInstance = false
							_G.Mod_BC_AllowSkipWait = false
							Log(string.format("[Huyết Lâu] : Phát hiện người chơi \"%s\" đang ở trong sảnh -> Thoát Huyết Lâu, chờ %ds để FirstPlayer mở xong rồi vào lại!",
								tostring(otherPlayerName or "Player"), waitSec), true)
							SaveOutput()
							pcall(function()
								if _G.TranScriptController and _G.TranScriptController.ReqExitInstance then
									_G.TranScriptController.ReqExitInstance()
								elseif _G.networkRequest and _G.networkRequest.ReqExitInstance then
									_G.networkRequest.ReqExitInstance()
								end
							end)
							Timer.Start(1.0, function()
								DismissBlockers()
								if onFinished then onFinished() end
							end)
							return
						end
					end

					-- Nếu là FirstPlayer: Chờ hết 10s đếm ngược sảnh (bcState >= 2 hoặc đủ 10s) rồi mới bấm Mở Ngay và chạy thẳng lên 14#30
					if bcIsFirstPlayer then
						local nowReal = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
						local waitedLobbySec = nowReal - bcEntryRealTime
						if bcState >= 2 or waitedLobbySec >= 10.2 then
							_G.Mod_BC_AllowSkipWait = true
							TriggerDungeonSkipWait()
							if not hasSkippedWait then
								hasSkippedWait = true
								Log("[Huyết Lâu - FirstPlayer] : Đã hết 10s chờ sảnh -> Kích hoạt [Mở Ngay] và chạy thẳng tới 14#30 mới đánh!", true)
								SaveOutput()
							end
							-- =========================================================================
							-- [MOD FEATURE]: CHẠY THẲNG TỚI TỌA ĐỘ 14#30 TRONG HUYẾT LÂU MỚI BẬT ĐÁNH
							-- Mô tả: Áp dụng quy tắc chuẩn bản Client (dist > 1.5m tắt đánh & xóa mục tiêu,
							--        chỉ khi tiếp cận 14#30 với dist <= 1.5m mới bật AutoFight).
							-- =========================================================================
							RushToDungeonCoordAndFight(14, 30, 1.5)
						else
							-- Đang trong 10s chờ sảnh: Giữ trạng thái dừng AutoFight
							StopFightAndClearTargetInDungeon()
						end
					end
				elseif inDS then
					-- Quảng Trường Quỷ: Bấm [Mở Ngay] và chạy thẳng tới tâm phó bản mới bật đánh
					TriggerDungeonSkipWait()
					if not hasSkippedWait and monitorTicks >= 2 then
						hasSkippedWait = true
						Log("[Quảng Trường Quỷ] : Đã bấm [Mở Ngay] bỏ qua chờ đợi!", true)
					end
					local cx, cy = 137, 167
					if liveLvl >= 150 then cx, cy = 135, 97 end
					RushToDungeonCoordAndFight(cx, cy, 1.5)
				end
			end
		end)
	end

	if isInInstance then
		Log(string.format("[Phó Bản] : Đang ở trong phó bản (Map %s)!", tostring(curMapId)), true)
		if isCurInDS then TriggerDungeonSkipWait() end
		StartInstanceMonitorLoop()
		return
	end

	-- Kiểm tra khung giờ mở phó bản: Chỉ mở trong 15 phút đầu mỗi khung giờ (phút 00 -> 14)
	local curHour = tonumber(os.date("%H")) or 0
	local curMinute = tonumber(os.date("%M")) or 0
	if curMinute >= 15 then
		if onFinished then onFinished() end
		return
	end

	-- QUY TẮC KHUNG GIỜ & NÚT BẬT/TẮT ĐỘC LẬP:
	-- - GIỜ LẺ (1h, 3h, 5h, ...): HUYẾT LÂU (Blood Castle) -> Kiểm tra `_G.Mod_AutoBCActive`
	-- - GIỜ CHẴN (0h, 2h, 4h, ...): QUẢNG TRƯỜNG QUỶ (Demon Plaza) -> Kiểm tra `_G.Mod_AutoDSActive`
	local checkList = {}
	if curHour % 2 == 1 then
		if not _G.Mod_AutoBCActive then
			if onFinished then onFinished() end
			return
		end
		local nowSec = os.time()
		if _G.Mod_BC_NextRetryTime and nowSec < _G.Mod_BC_NextRetryTime then
			if onFinished then onFinished() end
			return
		end
		table.insert(checkList, {
			name = "Huyết Lâu",
			subType = _G.TranScriptData.TranScriptSubType.BloodCastle,
			condId = 100414,
			maxNumId = 100404,
			globalCountId = 60000001,
			shopGoodId = 30107,
			altTicketIds = { 8000050, 8000057 }
		})
	else
		if not _G.Mod_AutoDSActive then
			if onFinished then onFinished() end
			return
		end
		table.insert(checkList, {
			name = "Quảng Trường Quỷ",
			subType = _G.TranScriptData.TranScriptSubType.DemonPlaza,
			condId = 100408,
			maxNumId = 100702,
			globalCountId = 60000002,
			shopGoodId = 30106,
			altTicketIds = { 8000040, 8000047 }
		})
	end

	local targetInst = nil
	local targetEnterData = nil
	local needBuyTicketGoodId = nil

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
					if _G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId then
						if ticketId > 0 then
							haveTicketCount = _G.BagInfoData.GetItemTotalCountByItemId(ticketId) or 0
						end
						if haveTicketCount < needCount and inst.altTicketIds then
							local sumAlt = 0
							for _, altId in ipairs(inst.altTicketIds) do
								sumAlt = sumAlt + (_G.BagInfoData.GetItemTotalCountByItemId(altId) or 0)
							end
							if sumAlt > haveTicketCount then haveTicketCount = sumAlt end
						end
					end
				end)
				if haveTicketCount >= needCount then
					targetInst = inst
					targetEnterData = enterData
					Log(string.format("[Phó Bản] : Tìm thấy %s (Lượt: %d | Vé có sẵn: %d/%d)",
						inst.name, leftCount, haveTicketCount, needCount), true)
					break
				else
					-- Chưa có vé trong túi -> Kiểm tra nếu đủ 75 KC Khóa thì tự động mua vé trong Shop
					local curKC = GetCurrentBoundDiamonds()
					if curKC >= 75 and inst.shopGoodId then
						targetInst = inst
						targetEnterData = enterData
						needBuyTicketGoodId = inst.shopGoodId
						Log(string.format("[Phó Bản] : Chưa có vé %s nhưng đủ %d KC Khóa (>= 75 KC) -> Tự động mua vé (goodId=%d) để vào phó bản!",
							inst.name, curKC, inst.shopGoodId), true)
						break
					else
						local nowT = os.time()
						if (nowT - (_G.Mod_LastNoTicketKCLogTime or 0)) >= 30 then
							_G.Mod_LastNoTicketKCLogTime = nowT
							Log(string.format("[Phó Bản] : Chưa có vé %s và không đủ 75 KC Khóa (Hiện có: %d KC) -> Bỏ qua phó bản, tiếp tục farm!",
								inst.name, curKC), true)
						end
					end
				end
			end
		end
	end

	if not targetInst or not targetEnterData then
		if onFinished then onFinished() end
		return
	end

	local function DoEnterTargetInstance()
		Log(string.format("[Phó Bản] : Tiến vào %s (MapId: %s)", targetInst.name, tostring(targetEnterData.id)), true)
		SaveOutput()
		_G.Mod_IsRunningInstance = true
		_G.Mod_BC_AllowSkipWait = false
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
		Timer.Start(2.0, function()
			DismissBlockers()
			if targetInst.subType == (_G.TranScriptData and _G.TranScriptData.TranScriptSubType and _G.TranScriptData.TranScriptSubType.DemonPlaza) then
				TriggerDungeonSkipWait()
			end
			StartInstanceMonitorLoop()
		end)
	end

	if needBuyTicketGoodId then
		_G.Mod_IsRunningInstance = true
		pcall(function()
			if _G.networkRequest and _G.networkRequest.ReqBuy then
				_G.networkRequest.ReqBuy(needBuyTicketGoodId, 1)
			elseif _G.NetManager and _G.ShopMessage and _G.ShopMessage.ReqBuy then
				_G.NetManager.Send(_G.ShopMessage.ReqBuy, { goodId = needBuyTicketGoodId, count = 1 })
			end
		end)
		Timer.Start(1.0, function()
			DoEnterTargetInstance()
		end)
	else
		DoEnterTargetInstance()
	end
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
-- [MOD FEATURE]: BỘ ĐẾM THỜI GIAN XỬ LÝ ACCOUNT, LƯU LOG THEO SERVER & PANEL KQ + PANEL PHỤ CHI TIẾT SAU LV 120
-- Mô tả:
--   1. Ghi nhận thời gian xử lý từng cặp S<Server>-<Email> kèm số lượng Boss Nữ Hoàng Tân Thủ đã farm [NH:x]
--      (ví dụ: S515-accvutmuvh0001@gmail.com-lv200 [NH:35]: 35p13s(done)).
--   2. Nếu S<Server>-<Email> đã mark (done) và bị quét lại thì bỏ qua không ghi đè; nếu chưa (done) thì cộng dồn.
--   3. Sắp xếp: Server giảm dần (S515 -> S514...), Email tăng dần (0001 -> 0002...).
--   4. Hiển thị thông báo giữa màn hình mỗi 5s/lần theo style thông báo Kundun xuất hiện bên bản Client.
--   5. Đo thời gian từng Level từ sau Lv 120 (lưu vào account_level_details.json), tổng hợp theo cả mốc 5 Lv
--      (120-125, 125-130...) và chi tiết từng 1 Lv (120->121, 121->122...).
--   6. Ấn vào bất kỳ bản ghi nào trong Panel KQ sẽ mở Panel phụ bên phải (ModKqDetailPanel, dạng Context Menu
--      có ScrollView riêng) để xem chi tiết thời gian từng mốc 5 Lv và từng 1 Lv sau Lv 120 của Account đó.
-- =========================================================================
_G.Mod_AccTimeRecords = _G.Mod_AccTimeRecords or {}
_G.Mod_AccTimeLoaded = _G.Mod_AccTimeLoaded or false
_G.Mod_AccLevelDetails = _G.Mod_AccLevelDetails or {}
_G.Mod_AccLevelDetailsLoaded = _G.Mod_AccLevelDetailsLoaded or false
_G.Mod_CurrentTrackingKey = _G.Mod_CurrentTrackingKey or ""
_G.Mod_CurrentSessionSec = _G.Mod_CurrentSessionSec or 0
_G.Mod_KqPanelVisible = _G.Mod_KqPanelVisible or false
_G.Mod_KqDetailPanelVisible = _G.Mod_KqDetailPanelVisible or false
_G.Mod_SelectedKqKey = _G.Mod_SelectedKqKey or ""

local function GetPersistentFilesDir()
	local dir = "/storage/emulated/0/Android/data/com.vnyh.gp/files"
	pcall(function()
		if CS and CS.UnityEngine and CS.UnityEngine.Application and CS.UnityEngine.Application.persistentDataPath then
			local p = tostring(CS.UnityEngine.Application.persistentDataPath)
			if p ~= "" then dir = p end
		end
	end)
	return dir
end

local function GetAccTimeLogFilePath()
	return GetPersistentFilesDir() .. "/account_time_log.txt"
end

local function GetAccLevelDetailsJsonPath()
	return GetPersistentFilesDir() .. "/account_level_details.json"
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

local function EscapeJsonString(str)
	local s = tostring(str or "")
	s = s:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\r", "\\r"):gsub("\n", "\\n")
	return s
end

local function EnsureAccountLevelDetailRecord(key, srvId, email)
	if not key or key == "" then return nil end
	local d = _G.Mod_AccLevelDetails[key]
	if not d then
		d = {
			key = key,
			serverId = tonumber(srvId) or 0,
			email = tostring(email or ""),
			queenCount = 0,
			curTrackingLv = 0,
			curLvAccumSec = 0,
			levelTimes = {},
		}
		_G.Mod_AccLevelDetails[key] = d
	else
		if tonumber(srvId) and tonumber(srvId) > 0 then d.serverId = tonumber(srvId) end
		if email and email ~= "" then d.email = tostring(email) end
		d.levelTimes = d.levelTimes or {}
	end
	return d
end

local function LoadAccountLevelDetailsJson(forceReload)
	if _G.Mod_AccLevelDetailsLoaded and not forceReload then return end
	_G.Mod_AccLevelDetailsLoaded = true
	pcall(function()
		local path = GetAccLevelDetailsJsonPath()
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

		for keyStr, bodyStr in string.gmatch(content, '"([^"]+)"%s*:%s*(%b{})') do
			if string.match(keyStr, "^[Ss]%d+%-") then
				local normKey = string.gsub(keyStr, "^([Ss]%d+%-)(.+)$", function(p, e)
					return string.upper(p) .. string.lower(e)
				end)
				local srvId = tonumber(string.match(bodyStr, '"serverId"%s*:%s*(%d+)'))
					or tonumber(string.match(normKey, "^S(%d+)%-"))
					or 0
				local email = string.match(bodyStr, '"email"%s*:%s*"([^"]*)"')
					or string.match(normKey, "^S%d+%-(.+)$")
					or ""
				local qCount = tonumber(string.match(bodyStr, '"queenCount"%s*:%s*(%d+)')) or 0
				local curTrackLv = tonumber(string.match(bodyStr, '"curTrackingLv"%s*:%s*(%d+)')) or 0
				local curAccum = tonumber(string.match(bodyStr, '"curLvAccumSec"%s*:%s*(%d+)')) or 0

				local d = EnsureAccountLevelDetailRecord(normKey, srvId, email)
				if d then
					if qCount > (tonumber(d.queenCount) or 0) then d.queenCount = qCount end
					if curTrackLv > (tonumber(d.curTrackingLv) or 0) then d.curTrackingLv = curTrackLv end
					if curAccum > (tonumber(d.curLvAccumSec) or 0) then d.curLvAccumSec = curAccum end
					local lvBlock = string.match(bodyStr, '"levelTimes"%s*:%s*(%b{})')
					if lvBlock then
						for lvStr, secStr in string.gmatch(lvBlock, '"(%d+)"%s*:%s*(%d+)') do
							local lvNum = tonumber(lvStr)
							local secNum = tonumber(secStr)
							if lvNum and secNum and secNum > 0 then
								local oldSec = tonumber(d.levelTimes[lvNum]) or 0
								if secNum > oldSec then
									d.levelTimes[lvNum] = secNum
								end
							end
						end
					end
				end
			end
		end
	end)
end

local function SaveAccountLevelDetailsJson()
	pcall(function()
		LoadAccountLevelDetailsJson(false)
		local keys = {}
		for k, d in pairs(_G.Mod_AccLevelDetails) do
			if type(k) == "string" and k ~= "" and type(d) == "table" then
				table.insert(keys, k)
			end
		end
		table.sort(keys)

		local lines = { "{" }
		for idx, k in ipairs(keys) do
			local d = _G.Mod_AccLevelDetails[k]
			local lvKeys = {}
			if d.levelTimes then
				for lvNum, secVal in pairs(d.levelTimes) do
					local nLv = tonumber(lvNum)
					local nSec = tonumber(secVal)
					if nLv and nSec and nSec > 0 then
						table.insert(lvKeys, nLv)
					end
				end
			end
			table.sort(lvKeys)

			local lvParts = {}
			for _, nLv in ipairs(lvKeys) do
				table.insert(lvParts, string.format('      "%d": %d', nLv, math.floor(tonumber(d.levelTimes[nLv]) or 1)))
			end
			local lvJson = "{}"
			if #lvParts > 0 then
				lvJson = "{\r\n" .. table.concat(lvParts, ",\r\n") .. "\r\n    }"
			end

			local comma = (idx < #keys) and "," or ""
			local entryStr = string.format(
				'  "%s": {\r\n    "serverId": %d,\r\n    "email": "%s",\r\n    "queenCount": %d,\r\n    "curTrackingLv": %d,\r\n    "curLvAccumSec": %d,\r\n    "levelTimes": %s\r\n  }%s',
				EscapeJsonString(k),
				tonumber(d.serverId) or 0,
				EscapeJsonString(d.email or ""),
				math.max(0, math.floor(tonumber(d.queenCount) or 0)),
				math.max(0, math.floor(tonumber(d.curTrackingLv) or 0)),
				math.max(0, math.floor(tonumber(d.curLvAccumSec) or 0)),
				lvJson,
				comma
			)
			table.insert(lines, entryStr)
		end
		table.insert(lines, "}")
		local fullJson = table.concat(lines, "\r\n") .. "\r\n"

		local path = GetAccLevelDetailsJsonPath()
		if CS and CS.System and CS.System.IO and CS.System.IO.File then
			CS.System.IO.File.WriteAllText(path, fullJson, CS.System.Text.Encoding.UTF8)
		else
			local f = io.open(path, "w")
			if f then
				f:write(fullJson)
				f:close()
			end
		end
	end)
end

local function GetCurrentAccountLevel()
	local lv = 0
	pcall(function()
		local meData = _G.ViewData and _G.ViewData.meData
		local pMe = _G.RoleManager and _G.RoleManager.me
		local baseLv = 0
		if meData and tonumber(meData.level or 0) and tonumber(meData.level or 0) > baseLv then
			baseLv = tonumber(meData.level)
		end
		if pMe and tonumber(pMe.level or 0) and tonumber(pMe.level or 0) > baseLv then
			baseLv = tonumber(pMe.level)
		end
		if pMe and pMe.data and tonumber(pMe.data.level or 0) and tonumber(pMe.data.level or 0) > baseLv then
			baseLv = tonumber(pMe.data.level)
		end
		if _G.QuickFind and _G.QuickFind.LuaMainPlayerData then
			local pData = _G.QuickFind.LuaMainPlayerData()
			if pData then
				if tonumber(pData.level or 0) and tonumber(pData.level or 0) > baseLv then
					baseLv = tonumber(pData.level)
				end
				if pData.TryGetAttrValue and _G.EAttributeType and _G.EAttributeType.level then
					local attrLv = tonumber(pData:TryGetAttrValue(_G.EAttributeType.level) or 0) or 0
					if attrLv > baseLv then baseLv = attrLv end
				end
			end
		end
		local masterLv = tonumber((meData and meData.masterLevel) or (pMe and pMe.masterLevel) or (pMe and pMe.data and pMe.data.masterLevel) or 0) or 0
		if baseLv > 0 then
			lv = baseLv + (masterLv > 0 and masterLv or 0)
		end
		if lv <= 0 and _G.LoginData and tonumber(_G.LoginData.roleLevel or 0) and tonumber(_G.LoginData.roleLevel) > 0 then
			lv = tonumber(_G.LoginData.roleLevel)
		end
	end)
	return lv
end
_G.GetCurrentAccountLevel = GetCurrentAccountLevel

local function FormatAccountTimeRecordLine(rec)
	local srvId = tonumber(rec and rec.serverId) or 0
	local email = tostring((rec and rec.email) or "")
	local recLv = tonumber(rec and rec.level) or 0
	local qCount = tonumber(rec and rec.queenCount) or 0
	if rec and rec.key and _G.Mod_AccLevelDetails and _G.Mod_AccLevelDetails[rec.key] then
		local dQ = tonumber(_G.Mod_AccLevelDetails[rec.key].queenCount) or 0
		if dQ > qCount then
			qCount = dQ
			rec.queenCount = dQ
		end
	end
	if rec and not rec.done and not rec.failed and rec.key and rec.key == _G.Mod_CurrentTrackingKey then
		local liveLv = GetCurrentAccountLevel()
		if liveLv > recLv then
			recLv = liveLv
			rec.level = liveLv
		end
		local liveQ = tonumber(_G.Mod_FarmKCCount) or 0
		if liveQ > qCount then
			qCount = liveQ
			rec.queenCount = liveQ
		end
	end
	local lv = math.max(1, recLv > 0 and recLv or GetCurrentAccountLevel() or 1)
	local suffix = ""
	if rec and rec.failed then
		suffix = "(failed)"
	elseif rec and rec.done then
		suffix = "(done)"
	end
	return string.format("S%d-%s-lv%d [NH:%d]: %s%s",
		srvId,
		email,
		lv,
		math.max(0, qCount),
		FormatAccDuration(rec and rec.elapsedSec or 1),
		suffix)
end

local function LoadAccountTimeRecords(forceReload)
	LoadAccountLevelDetailsJson(forceReload)
	if _G.Mod_AccTimeLoaded and not forceReload then return end
	_G.Mod_AccTimeLoaded = true
	pcall(function()
		-- Dọn sạch các bản ghi bị lỗi key có chứa "[nh" hoặc "-lv" trong bộ nhớ (nếu có)
		if _G.Mod_AccTimeRecords then
			for k, _ in pairs(_G.Mod_AccTimeRecords) do
				if string.find(k, "%[") or string.find(k, "%-[ll][vv]%d+") then
					_G.Mod_AccTimeRecords[k] = nil
				end
			end
		end

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

		local hadCorruptedLines = false
		for line in string.gmatch(content, "[^\r\n]+") do
			if string.find(line, "%[[Nn][Hh]%-[Ll][Vv]") then
				hadCorruptedLines = true
			end
			-- Tách số lượng Nữ Hoàng [NH:x] TRƯỚC KHI tách dấu hai chấm ":" để không bị vướng dấu ":" bên trong [NH:0]
			local parsedQueen = tonumber(string.match(line, "%[[Nn][Hh]%s*[:%-]%s*(%d+)%]")) or 0
			local lineWithoutNh = tostring(line):gsub("%s*%[[Nn][Hh][^%]]*%]", "")
			-- Loại bỏ luôn các chuỗi rác "[NH-lv..." nếu file cũ từng bị nối lặp
			lineWithoutNh = lineWithoutNh:gsub("%s*%[[Nn][Hh].-(:%s*%d+)", "%1")

			local srvStr, lhsRaw, rhs = string.match(lineWithoutNh, "^%s*[Ss](%d+)%-(.-)%s*[:;]%s*(.-)%s*$")
			if srvStr and lhsRaw and rhs then
				local srvId = tonumber(srvStr) or 0
				local trimmedLhs = tostring(lhsRaw):gsub("%s*%[.*$", ""):gsub("^%s+", ""):gsub("%s+$", "")
				local emailPart, lvStr = string.match(trimmedLhs, "^(.-)%-[Ll][Vv](%d+)")
				local email = emailPart and (tostring(emailPart):gsub("^%s+", ""):gsub("%s+$", "")) or trimmedLhs
				-- Đảm bảo email tinh khiết 100%, cắt bỏ mọi hậu tố "-lv..." hoặc "[..." nếu còn sót
				email = email:gsub("%-[Ll][Vv]%d+.*$", ""):gsub("%s*%[.*$", ""):gsub("^%s+", ""):gsub("%s+$", "")
				local parsedLv = tonumber(lvStr) or 0
				if srvId > 0 and email ~= "" then
					local lowRhs = string.lower(rhs)
					local isFailed = (string.find(lowRhs, "%(failed%)") ~= nil)
					local isDone = (not isFailed) and (string.find(lowRhs, "%(done%)") ~= nil)
					local sec = ParseAccDurationStr(rhs)
					local key = string.format("S%d-%s", srvId, string.lower(email))
					local dRec = EnsureAccountLevelDetailRecord(key, srvId, email)
					local detailQ = tonumber(dRec and dRec.queenCount) or 0
					local bestQueen = math.max(parsedQueen, detailQ)
					if dRec and bestQueen > detailQ then
						dRec.queenCount = bestQueen
					end
					local existing = _G.Mod_AccTimeRecords[key]
					if not existing or (not existing.done and not existing.failed) then
						local bestLv = math.max(parsedLv, tonumber(existing and existing.level) or 0)
						local bestSec = math.max(sec, tonumber(existing and existing.elapsedSec) or 0)
						local bestQ = math.max(bestQueen, tonumber(existing and existing.queenCount) or 0)
						_G.Mod_AccTimeRecords[key] = {
							key = key,
							serverId = srvId,
							email = email,
							level = bestLv > 0 and bestLv or 1,
							queenCount = bestQ,
							elapsedSec = bestSec,
							done = isDone,
							failed = isFailed,
						}
					else
						if parsedLv > (tonumber(existing.level) or 0) then
							existing.level = parsedLv
						end
						if bestQueen > (tonumber(existing.queenCount) or 0) then
							existing.queenCount = bestQueen
						end
						if sec > (tonumber(existing.elapsedSec) or 0) then
							existing.elapsedSec = sec
						end
						if isFailed then
							existing.failed = true
							existing.done = false
						elseif isDone and not existing.failed then
							existing.done = true
						end
					end
				end
			end
		end

		-- Nếu file cũ có dòng bị lặp "[NH-lv1...", tự động ghi đè lại file sạch 1 dòng / 1 account ngay lập tức
		if hadCorruptedLines then
			pcall(function()
				local cleanList = {}
				for _, r in pairs(_G.Mod_AccTimeRecords) do
					if r and r.serverId and r.email and r.email ~= "" then
						table.insert(cleanList, r)
					end
				end
				table.sort(cleanList, function(a, b)
					local sa = tonumber(a.serverId) or 0
					local sb = tonumber(b.serverId) or 0
					if sa ~= sb then return sa > sb end
					return string.lower(tostring(a.email)) < string.lower(tostring(b.email))
				end)
				local outLines = {}
				for _, r in ipairs(cleanList) do
					table.insert(outLines, FormatAccountTimeRecordLine(r))
				end
				local fullText = table.concat(outLines, "\r\n")
				if #outLines > 0 then fullText = fullText .. "\r\n" end
				if CS and CS.System and CS.System.IO and CS.System.IO.File then
					CS.System.IO.File.WriteAllText(path, fullText, CS.System.Text.Encoding.UTF8)
				end
			end)
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
			table.insert(lines, FormatAccountTimeRecordLine(rec))
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
	SaveAccountLevelDetailsJson()
	if _G.Mod_KqPanelVisible and _G.Mod_RefreshKqPanelUI then
		pcall(_G.Mod_RefreshKqPanelUI)
	end
	if _G.Mod_KqDetailPanelVisible and _G.Mod_RefreshKqDetailPanelUI then
		pcall(_G.Mod_RefreshKqDetailPanelUI)
	end
end

local function FlashAccTimeCenterAlert(msg, colorHex)
	pcall(function()
		local cHex = tostring(colorHex or "#FFFF00")
		local alertText = "<size=22><b><color=" .. cHex .. ">⚠️ " .. tostring(msg) .. " ⚠️</color></b></size>"
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

local function FinalizeAccountLevelDetailOnEnd(key, srvId, email, finalLv, queenCount)
	pcall(function()
		local d = EnsureAccountLevelDetailRecord(key, srvId, email)
		if not d then return end
		if queenCount and queenCount > (tonumber(d.queenCount) or 0) then
			d.queenCount = queenCount
		end
		local prevLv = tonumber(d.curTrackingLv) or 0
		if prevLv >= 120 and finalLv and finalLv > prevLv then
			local spent = math.max(1, tonumber(d.curLvAccumSec) or 1)
			local gain = finalLv - prevLv
			local basePerLv = math.max(1, math.floor(spent / gain))
			local rem = spent - (basePerLv * gain)
			for lvStep = prevLv, finalLv - 1 do
				local addRem = (lvStep == prevLv and rem > 0) and rem or 0
				if not d.levelTimes[lvStep] or d.levelTimes[lvStep] <= 0 then
					d.levelTimes[lvStep] = math.max(1, basePerLv + addRem)
				end
			end
			d.curTrackingLv = finalLv
			d.curLvAccumSec = 0
		end
	end)
end

_G.FinalizeAccountTimeOnGoal = function(emailArg, srvArg, lvlArg)
	pcall(function()
		LoadAccountTimeRecords(false)
		local defSrv, defEmail = ResolveCurrentSessionServerAndEmail()
		local srvId = tonumber(srvArg) or defSrv
		local email = tostring((emailArg and emailArg ~= "" and emailArg) or defEmail)
		if srvId <= 0 or email == "" or email == "Unknown" then return end

		local curLv = math.max(1, tonumber(lvlArg) or GetCurrentAccountLevel() or 1)
		local key = string.format("S%d-%s", srvId, string.lower(email))
		local liveQueen = tonumber(_G.Mod_FarmKCCount) or 0
		FinalizeAccountLevelDetailOnEnd(key, srvId, email, curLv, liveQueen)

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
				level = curLv,
				queenCount = liveQueen,
				elapsedSec = math.max(2, tonumber(_G.Mod_CurrentSessionSec) or 2),
				done = true,
				failed = false,
			}
			_G.Mod_AccTimeRecords[key] = rec
		else
			rec.level = math.max(curLv, tonumber(rec.level) or 1)
			rec.queenCount = math.max(liveQueen, tonumber(rec.queenCount) or 0)
			rec.elapsedSec = math.max(2, tonumber(rec.elapsedSec) or 0, tonumber(_G.Mod_CurrentSessionSec) or 2)
			rec.done = true
			rec.failed = false
		end
		SaveAccountTimeRecords()
		FlashAccTimeCenterAlert(FormatAccountTimeRecordLine(rec), "#00FF88")
	end)
end

-- =========================================================================
-- [MOD FEATURE]: ĐÁNH DẤU ACCOUNT FAILED TRONG LOG KQ (MÀU ĐỎ BUTTON #D93838)
-- Mô tả: Khi quá trình Bug NV Nữ Hoàng Tân Thủ thất bại sau 2 lần thử hoặc bị lag
--        quay lại trạng thái Hoàn Thành, đánh dấu (failed) với màu đỏ button #D93838.
-- =========================================================================
_G.FinalizeAccountTimeOnFailed = function(emailArg, srvArg, lvlArg)
	pcall(function()
		LoadAccountTimeRecords(false)
		local defSrv, defEmail = ResolveCurrentSessionServerAndEmail()
		local srvId = tonumber(srvArg) or defSrv
		local email = tostring((emailArg and emailArg ~= "" and emailArg) or defEmail)
		if srvId <= 0 or email == "" or email == "Unknown" then return end

		local curLv = math.max(1, tonumber(lvlArg) or GetCurrentAccountLevel() or 1)
		local key = string.format("S%d-%s", srvId, string.lower(email))
		local liveQueen = tonumber(_G.Mod_FarmKCCount) or 0
		FinalizeAccountLevelDetailOnEnd(key, srvId, email, curLv, liveQueen)

		local rec = _G.Mod_AccTimeRecords[key]
		if rec and rec.done then
			return
		end
		if not rec then
			rec = {
				key = key,
				serverId = srvId,
				email = email,
				level = curLv,
				queenCount = liveQueen,
				elapsedSec = math.max(2, tonumber(_G.Mod_CurrentSessionSec) or 2),
				done = false,
				failed = true,
			}
			_G.Mod_AccTimeRecords[key] = rec
		else
			rec.level = math.max(curLv, tonumber(rec.level) or 1)
			rec.queenCount = math.max(liveQueen, tonumber(rec.queenCount) or 0)
			rec.elapsedSec = math.max(2, tonumber(rec.elapsedSec) or 0, tonumber(_G.Mod_CurrentSessionSec) or 2)
			rec.done = false
			rec.failed = true
		end
		SaveAccountTimeRecords()
		FlashAccTimeCenterAlert(FormatAccountTimeRecordLine(rec), "#D93838")
	end)
end

-- Tắt nút EXEC trên bản Farm và tự động đẩy nút [KQ] xuống Y=140 (ngay trên nút [VỤT] Y=60)
_G.Mod_ExecBtn_Visible = false
pcall(function()
	if _G.EmmyluaDebug and _G.EmmyluaDebug.InitEmmyluaDebug and not _G.EmmyluaDebug._Orig_InitEmmyluaDebug then
		_G.EmmyluaDebug._Orig_InitEmmyluaDebug = _G.EmmyluaDebug.InitEmmyluaDebug
		_G.EmmyluaDebug.InitEmmyluaDebug = function(obj)
			local res = _G.EmmyluaDebug._Orig_InitEmmyluaDebug(obj)
			_G.Mod_ExecBtn_Visible = false
			return res
		end
	end
end)

-- Khởi tạo giao diện Nút [KQ], Panel Kết Quả chính (ModKqResultPanel) và Panel Phụ Chi Tiết Level (ModKqDetailPanel)
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

		local execBtnTr = modRoot.transform:Find("FloatingExecBtn")
		if execBtnTr and execBtnTr.gameObject then
			execBtnTr.gameObject:SetActive(_G.Mod_ExecBtn_Visible == true)
		end
		local isExecVisible = (_G.Mod_ExecBtn_Visible == true) and (execBtnTr ~= nil and execBtnTr.gameObject.activeSelf)
		local targetKqPosY = isExecVisible and 220 or 140

		local existingBtn = modRoot.transform:Find("FloatingKqBtn")
		local existingPanel = modRoot.transform:Find("ModKqResultPanel")
		local existingDetailPanel = modRoot.transform:Find("ModKqDetailPanel")
		if existingBtn and existingPanel and existingPanel:Find("BtnClearAllKq") and existingDetailPanel then
			pcall(function()
				local rt = existingBtn:GetComponent(typeof(RectTransform))
				if rt then
					rt.anchoredPosition = Vector2(1, targetKqPosY)
				end
			end)
			return
		end
		if existingBtn then pcall(function() GameObject.Destroy(existingBtn.gameObject) end) end
		if existingPanel then
			_G.Mod_KqRowPool = {}
			pcall(function() GameObject.Destroy(existingPanel.gameObject) end)
		end
		if existingDetailPanel then
			_G.Mod_KqDetailRowPool = {}
			pcall(function() GameObject.Destroy(existingDetailPanel.gameObject) end)
		end

		local defaultFont = Resources.GetBuiltinResource(typeof(Font), "Arial.ttf")

		-- 1. Nút nổi [KQ] bên trái màn hình (Tự động đẩy xuống Y=140 ngay trên nút VỤT khi tắt EXEC, hoặc Y=220 nếu bật EXEC)
		local kqBtnGo = GameObject("FloatingKqBtn")
		kqBtnGo.transform:SetParent(modRoot.transform, false)
		local kqBtnRt = kqBtnGo:AddComponent(typeof(RectTransform))
		kqBtnRt.anchorMin = Vector2(0, 0)
		kqBtnRt.anchorMax = Vector2(0, 0)
		kqBtnRt.pivot = Vector2(0, 0)
		kqBtnRt.anchoredPosition = Vector2(1, targetKqPosY)
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
		kqPanelRt.sizeDelta = Vector2(530, 1200)
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
		headerTitleTxt.text = "KẾT QUẢ XỬ LÝ (Ấn dòng xem chi tiết)"
		headerTitleTxt.color = Color(1, 0.88, 0.15, 1)
		headerTitleTxt.fontSize = 17
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

		-- ScrollView hiển thị danh sách kết quả (đẩy đáy lùi lên 64px để nhường chỗ cho nút XÓA TOÀN BỘ KQ)
		local scrollGo = GameObject("KqScrollView")
		scrollGo.transform:SetParent(kqPanelGo.transform, false)
		local sRt = scrollGo:AddComponent(typeof(RectTransform))
		sRt.anchorMin = Vector2(0, 0)
		sRt.anchorMax = Vector2(1, 1)
		sRt.offsetMin = Vector2(10, 64)
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
		contentRt.sizeDelta = Vector2(0, 1082)

		scrollRect.viewport = vpRt
		scrollRect.content = contentRt

		-- Nút [XÓA TOÀN BỘ KQ] neo ở đáy Panel
		local clearBtnGo = GameObject("BtnClearAllKq")
		clearBtnGo.transform:SetParent(kqPanelGo.transform, false)
		local clrRt = clearBtnGo:AddComponent(typeof(RectTransform))
		clrRt.anchorMin = Vector2(0, 0)
		clrRt.anchorMax = Vector2(1, 0)
		clrRt.pivot = Vector2(0.5, 0)
		clrRt.offsetMin = Vector2(10, 10)
		clrRt.offsetMax = Vector2(-10, 56)
		local clrImg = clearBtnGo:AddComponent(typeof(Image))
		clrImg.color = Color(0.75, 0.16, 0.16, 1.0)
		clrImg.raycastTarget = true

		local clrTxtGo = GameObject("Text")
		clrTxtGo.transform:SetParent(clearBtnGo.transform, false)
		local clrtRt = clrTxtGo:AddComponent(typeof(RectTransform))
		clrtRt.anchorMin = Vector2(0, 0)
		clrtRt.anchorMax = Vector2(1, 1)
		clrtRt.sizeDelta = Vector2(0, 0)
		local clrTxt = clrTxtGo:AddComponent(typeof(Text))
		clrTxt.text = "XÓA TOÀN BỘ KQ"
		clrTxt.color = Color.white
		clrTxt.fontSize = 18
		clrTxt.fontStyle = CS.UnityEngine.FontStyle.Bold
		clrTxt.alignment = TextAnchor.MiddleCenter
		clrTxt.raycastTarget = false
		if defaultFont then clrTxt.font = defaultFont end

		-- =========================================================================
		-- 3. PANEL PHỤ CHI TIẾT BÊN PHẢI PANEL KQ (ModKqDetailPanel - Context Menu Style)
		-- Mô tả: Hiển thị khi ấn vào 1 dòng kết quả trong Panel KQ, nằm sát bên phải Panel KQ,
		--        có ScrollView riêng hiển thị mốc 5 Lv (120-125, 125-130...) & từng 1 Lv sau Lv 120.
		-- =========================================================================
		local detailPanelGo = GameObject("ModKqDetailPanel")
		detailPanelGo.transform:SetParent(modRoot.transform, false)
		local dpRt = detailPanelGo:AddComponent(typeof(RectTransform))
		dpRt.anchorMin = Vector2(0, 0.5)
		dpRt.anchorMax = Vector2(0, 0.5)
		dpRt.pivot = Vector2(0, 0.5)
		dpRt.anchoredPosition = Vector2(538, 0) -- Sát mép phải của ModKqResultPanel (66 + 530*0.88 = 532.4)
		dpRt.sizeDelta = Vector2(430, 1200)
		detailPanelGo.transform.localScale = Vector3(0.88, 0.88, 1)

		local dpImg = detailPanelGo:AddComponent(typeof(Image))
		dpImg.color = Color(0.07, 0.09, 0.12, 0.97)
		dpImg.raycastTarget = true
		detailPanelGo:SetActive(false)

		local dpHeaderGo = GameObject("KqDetailHeader")
		dpHeaderGo.transform:SetParent(detailPanelGo.transform, false)
		local dphRt = dpHeaderGo:AddComponent(typeof(RectTransform))
		dphRt.anchorMin = Vector2(0, 1)
		dphRt.anchorMax = Vector2(1, 1)
		dphRt.pivot = Vector2(0.5, 1)
		dphRt.anchoredPosition = Vector2(0, 0)
		dphRt.sizeDelta = Vector2(0, 48)
		local dphImg = dpHeaderGo:AddComponent(typeof(Image))
		dphImg.color = Color(0.14, 0.22, 0.30, 1.0)
		dphImg.raycastTarget = false

		local dpTitleGo = GameObject("KqDetailHeaderTitle")
		dpTitleGo.transform:SetParent(dpHeaderGo.transform, false)
		local dptRt = dpTitleGo:AddComponent(typeof(RectTransform))
		dptRt.anchorMin = Vector2(0, 0)
		dptRt.anchorMax = Vector2(1, 1)
		dptRt.offsetMin = Vector2(12, 0)
		dptRt.offsetMax = Vector2(-52, 0)
		local dpTitleTxt = dpTitleGo:AddComponent(typeof(Text))
		dpTitleTxt.text = "CHI TIẾT TỐC ĐỘ LEVEL (SAU LV 120)"
		dpTitleTxt.color = Color(0.35, 0.95, 1.0, 1)
		dpTitleTxt.fontSize = 16
		dpTitleTxt.fontStyle = CS.UnityEngine.FontStyle.Bold
		dpTitleTxt.alignment = TextAnchor.MiddleLeft
		dpTitleTxt.raycastTarget = false
		if defaultFont then dpTitleTxt.font = defaultFont end

		local dpCloseBtnGo = GameObject("BtnCloseKqDetailPanel")
		dpCloseBtnGo.transform:SetParent(dpHeaderGo.transform, false)
		local dpcbRt = dpCloseBtnGo:AddComponent(typeof(RectTransform))
		dpcbRt.anchorMin = Vector2(1, 0.5)
		dpcbRt.anchorMax = Vector2(1, 0.5)
		dpcbRt.pivot = Vector2(1, 0.5)
		dpcbRt.anchoredPosition = Vector2(-6, 0)
		dpcbRt.sizeDelta = Vector2(40, 36)
		local dpcbImg = dpCloseBtnGo:AddComponent(typeof(Image))
		dpcbImg.color = Color(0.82, 0.18, 0.18, 1)
		dpcbImg.raycastTarget = true

		local dpcbTxtGo = GameObject("Text")
		dpcbTxtGo.transform:SetParent(dpCloseBtnGo.transform, false)
		local dpcbtRt = dpcbTxtGo:AddComponent(typeof(RectTransform))
		dpcbtRt.anchorMin = Vector2(0, 0)
		dpcbtRt.anchorMax = Vector2(1, 1)
		dpcbtRt.sizeDelta = Vector2(0, 0)
		local dpcbTxt = dpcbTxtGo:AddComponent(typeof(Text))
		dpcbTxt.text = "X"
		dpcbTxt.color = Color.white
		dpcbTxt.fontSize = 18
		dpcbTxt.fontStyle = CS.UnityEngine.FontStyle.Bold
		dpcbTxt.alignment = TextAnchor.MiddleCenter
		dpcbTxt.raycastTarget = false
		if defaultFont then dpcbTxt.font = defaultFont end

		local dpScrollGo = GameObject("KqDetailScrollView")
		dpScrollGo.transform:SetParent(detailPanelGo.transform, false)
		local dpsRt = dpScrollGo:AddComponent(typeof(RectTransform))
		dpsRt.anchorMin = Vector2(0, 0)
		dpsRt.anchorMax = Vector2(1, 1)
		dpsRt.offsetMin = Vector2(10, 12)
		dpsRt.offsetMax = Vector2(-10, -54)

		local dpScrollRect = dpScrollGo:AddComponent(typeof(ScrollRect))
		dpScrollRect.horizontal = false
		dpScrollRect.vertical = true
		dpScrollRect.movementType = ScrollRect.MovementType.Clamped
		dpScrollRect.scrollSensitivity = 35

		local dpViewportGo = GameObject("Viewport")
		dpViewportGo.transform:SetParent(dpScrollGo.transform, false)
		local dpVpRt = dpViewportGo:AddComponent(typeof(RectTransform))
		dpVpRt.anchorMin = Vector2(0, 0)
		dpVpRt.anchorMax = Vector2(1, 1)
		dpVpRt.pivot = Vector2(0, 1)
		dpVpRt.sizeDelta = Vector2(0, 0)
		local dpVpImg = dpViewportGo:AddComponent(typeof(Image))
		dpVpImg.color = Color(0, 0, 0, 0.28)
		dpVpImg.raycastTarget = true
		dpViewportGo:AddComponent(typeof(RectMask2D))

		local dpContentGo = GameObject("Content")
		dpContentGo.transform:SetParent(dpViewportGo.transform, false)
		local dpContentRt = dpContentGo:AddComponent(typeof(RectTransform))
		dpContentRt.anchorMin = Vector2(0, 1)
		dpContentRt.anchorMax = Vector2(1, 1)
		dpContentRt.pivot = Vector2(0, 1)
		dpContentRt.anchoredPosition = Vector2(0, 0)
		dpContentRt.sizeDelta = Vector2(0, 1130)

		dpScrollRect.viewport = dpVpRt
		dpScrollRect.content = dpContentRt

		_G.Mod_KqRowPool = _G.Mod_KqRowPool or {}
		_G.Mod_KqDetailRowPool = _G.Mod_KqDetailRowPool or {}

		local function SetKqDetailPanelVisible(visible)
			_G.Mod_KqDetailPanelVisible = (visible == true)
			if detailPanelGo and not detailPanelGo:Equals(nil) then
				detailPanelGo:SetActive(_G.Mod_KqDetailPanelVisible)
				if _G.Mod_KqDetailPanelVisible then
					detailPanelGo.transform:SetAsLastSibling()
					if _G.Mod_RefreshKqDetailPanelUI then
						_G.Mod_RefreshKqDetailPanelUI()
					end
				end
			end
		end
		_G.Mod_SetKqDetailPanelVisible = SetKqDetailPanelVisible

		_G.Mod_RefreshKqDetailPanelUI = function()
			pcall(function()
				if not detailPanelGo or detailPanelGo:Equals(nil) or not _G.Mod_KqDetailPanelVisible then return end
				LoadAccountTimeRecords(false)
				local selKey = tostring(_G.Mod_SelectedKqKey or "")
				local rec = (selKey ~= "") and _G.Mod_AccTimeRecords[selKey] or nil
				local detail = (selKey ~= "") and _G.Mod_AccLevelDetails[selKey] or nil

				local detailLines = {}
				if not rec then
					if dpTitleTxt and not dpTitleTxt:Equals(nil) then
						dpTitleTxt.text = "CHI TIẾT TỐC ĐỘ LEVEL"
					end
					table.insert(detailLines, "<color=#AAAAAA>Hãy ấn vào 1 tài khoản bên bảng KQ để xem chi tiết.</color>")
				else
					local srvId = tonumber(rec.serverId) or 0
					local email = tostring(rec.email or "")
					local recLv = tonumber(rec.level) or 1
					local qCount = tonumber(rec.queenCount) or 0
					if detail and (tonumber(detail.queenCount) or 0) > qCount then
						qCount = tonumber(detail.queenCount) or 0
					end
					if not rec.done and not rec.failed and rec.key == _G.Mod_CurrentTrackingKey then
						local liveLv = GetCurrentAccountLevel()
						if liveLv > recLv then recLv = liveLv end
						local liveQ = tonumber(_G.Mod_FarmKCCount) or 0
						if liveQ > qCount then qCount = liveQ end
					end

					if dpTitleTxt and not dpTitleTxt:Equals(nil) then
						dpTitleTxt.text = string.format("CHI TIẾT: S%d - %s", srvId, email)
					end

					local stateLabel = rec.failed and "<color=#D93838>FAILED</color>"
						or (rec.done and "<color=#00FF88>DONE</color>" or "<color=#FFFF00>ĐANG CHẠY</color>")

					table.insert(detailLines, "<color=#FFD700><b>[THÔNG TIN TỔNG QUAN]</b></color>")
					table.insert(detailLines, string.format("• Tài khoản: <color=#00FFFF>S%d - %s</color>", srvId, email))
					table.insert(detailLines, string.format("• Cấp độ: <color=#00FF88>Lv %d</color> | Tổng TG: <color=#FFFF00>%s</color> (%s)",
						recLv, FormatAccDuration(rec.elapsedSec or 1), stateLabel))
					table.insert(detailLines, string.format("• Boss Nữ Hoàng Tân Thủ đã farm: <color=#FF9933><b>%d con</b></color>", qCount))
					table.insert(detailLines, "<color=#445566>--------------------------------------------------</color>")

					local lvMap = (detail and detail.levelTimes) or {}
					local maxRecordedLv = recLv
					for kLv, _ in pairs(lvMap) do
						local nLv = tonumber(kLv) or 0
						if nLv + 1 > maxRecordedLv then maxRecordedLv = nLv + 1 end
					end

					table.insert(detailLines, "<color=#00FF88><b>[THỜI GIAN MỖI 5 LEVEL (SAU LV 120)]</b></color>")
					if maxRecordedLv <= 120 and next(lvMap) == nil then
						table.insert(detailLines, string.format("  <color=#AAAAAA>(Nhân vật đang ở Lv %d - Chưa qua mốc Lv 120)</color>", recLv))
					else
						local topBracketEnd = math.max(125, math.ceil(math.max(maxRecordedLv, 121) / 5) * 5)
						local hasAny5Lv = false
						for bStart = 120, topBracketEnd - 5, 5 do
							local bEnd = bStart + 5
							local sumSec = 0
							local countedLevels = 0
							for lvStep = bStart, bEnd - 1 do
								local sVal = tonumber(lvMap[lvStep]) or tonumber(lvMap[tostring(lvStep)]) or 0
								if sVal > 0 then
									sumSec = sumSec + sVal
									countedLevels = countedLevels + 1
								end
							end
							if countedLevels > 0 then
								hasAny5Lv = true
								if recLv >= bEnd then
									table.insert(detailLines, string.format("  • Lv %d ➔ %d: <color=#00FF88><b>%s</b></color>",
										bStart, bEnd, FormatAccDuration(sumSec)))
								else
									table.insert(detailLines, string.format("  • Lv %d ➔ %d <color=#AAAAAA>(đang Lv%d)</color>: <color=#FFFF00>%s</color>",
										bStart, bEnd, recLv, FormatAccDuration(sumSec)))
								end
							end
						end
						if not hasAny5Lv then
							table.insert(detailLines, "  <color=#AAAAAA>(Chưa có dữ liệu mốc 5 Level sau Lv 120)</color>")
						end
					end

					table.insert(detailLines, "<color=#445566>--------------------------------------------------</color>")
					table.insert(detailLines, "<color=#00FFFF><b>[CHI TIẾT TỪNG 1 LEVEL (SAU LV 120)]</b></color>")
					local lvList = {}
					for kLv, sVal in pairs(lvMap) do
						local nLv = tonumber(kLv)
						local nSec = tonumber(sVal)
						if nLv and nLv >= 120 and nSec and nSec > 0 then
							table.insert(lvList, { lv = nLv, sec = nSec })
						end
					end
					table.sort(lvList, function(a, b) return a.lv < b.lv end)

					if #lvList == 0 then
						table.insert(detailLines, "  <color=#AAAAAA>(Chưa có dữ liệu từng Level sau Lv 120)</color>")
					else
						for _, item in ipairs(lvList) do
							local isCurrentFarmingLv = (not rec.done and not rec.failed and item.lv == recLv)
							if isCurrentFarmingLv then
								table.insert(detailLines, string.format("  • Lv %d ➔ %d (đang cày): <color=#FFFF00>%s</color>",
									item.lv, item.lv + 1, FormatAccDuration(item.sec)))
							else
								table.insert(detailLines, string.format("  • Lv %d ➔ %d: <color=#FFFFFF>%s</color>",
									item.lv, item.lv + 1, FormatAccDuration(item.sec)))
							end
						end
					end
				end

				local dRowH = 28
				local dTotalH = math.max(1130, (#detailLines * dRowH) + 16)
				dpContentRt.sizeDelta = Vector2(0, dTotalH)

				for i = 1, #detailLines do
					local dTxt = _G.Mod_KqDetailRowPool[i]
					if not dTxt or dTxt:Equals(nil) then
						local dGo = GameObject("KqDetailRow_" .. i)
						dGo.transform:SetParent(dpContentGo.transform, false)
						local dRt = dGo:AddComponent(typeof(RectTransform))
						dRt.anchorMin = Vector2(0, 1)
						dRt.anchorMax = Vector2(1, 1)
						dRt.pivot = Vector2(0, 1)
						dRt.anchoredPosition = Vector2(8, -6 - (i - 1) * dRowH)
						dRt.sizeDelta = Vector2(-16, dRowH)

						dTxt = dGo:AddComponent(typeof(Text))
						dTxt.fontSize = 15
						dTxt.alignment = TextAnchor.MiddleLeft
						dTxt.raycastTarget = false
						if defaultFont then dTxt.font = defaultFont end
						_G.Mod_KqDetailRowPool[i] = dTxt
					end
					dTxt.gameObject:SetActive(true)
					dTxt.text = detailLines[i]
				end

				for i = #detailLines + 1, #_G.Mod_KqDetailRowPool do
					local dTxt = _G.Mod_KqDetailRowPool[i]
					if dTxt and not dTxt:Equals(nil) then
						dTxt.gameObject:SetActive(false)
					end
				end
			end)
		end

		_G.Mod_ClearAllAccountTimeRecords = function()
			pcall(function()
				_G.Mod_AccTimeRecords = {}
				_G.Mod_AccLevelDetails = {}
				_G.Mod_CurrentSessionSec = 0
				_G.Mod_SelectedKqKey = ""
				SetKqDetailPanelVisible(false)
				SaveAccountTimeRecords()
				if _G.Mod_RefreshKqPanelUI then
					_G.Mod_RefreshKqPanelUI()
				end
				if _G.FloatingWordUtility and _G.FloatingWordUtility.QuickMsg then
					_G.FloatingWordUtility.QuickMsg("<color=#00FF88>Đã xóa toàn bộ kết quả xử lý!</color>")
				end
			end)
		end

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
					headerTitleTxt.text = string.format("KẾT QUẢ (%d/%d done) - Ấn dòng xem chi tiết", doneCount, #list)
				end

				local rowH = 32
				local totalH = math.max(1082, (#list * rowH) + 16)
				contentRt.sizeDelta = Vector2(0, totalH)

				local count = math.max(#list, 1)
				for i = 1, count do
					local rowEntry = _G.Mod_KqRowPool[i]
					if not rowEntry or not rowEntry.go or rowEntry.go:Equals(nil) then
						local rGo = GameObject("KqRow_" .. i)
						rGo.transform:SetParent(contentGo.transform, false)
						local rRt = rGo:AddComponent(typeof(RectTransform))
						rRt.anchorMin = Vector2(0, 1)
						rRt.anchorMax = Vector2(1, 1)
						rRt.pivot = Vector2(0, 1)
						rRt.anchoredPosition = Vector2(4, -6 - (i - 1) * rowH)
						rRt.sizeDelta = Vector2(-8, rowH - 2)

						local rBgImg = rGo:AddComponent(typeof(Image))
						rBgImg.color = Color(1, 1, 1, 0.02)
						rBgImg.raycastTarget = true

						local rTxtGo = GameObject("RowText")
						rTxtGo.transform:SetParent(rGo.transform, false)
						local rTxtRt = rTxtGo:AddComponent(typeof(RectTransform))
						rTxtRt.anchorMin = Vector2(0, 0)
						rTxtRt.anchorMax = Vector2(1, 1)
						rTxtRt.offsetMin = Vector2(6, 0)
						rTxtRt.offsetMax = Vector2(-6, 0)

						local rowTxt = rTxtGo:AddComponent(typeof(Text))
						rowTxt.fontSize = 15
						rowTxt.alignment = TextAnchor.MiddleLeft
						rowTxt.raycastTarget = false
						if defaultFont then rowTxt.font = defaultFont end

						rowEntry = {
							go = rGo,
							bg = rBgImg,
							txt = rowTxt,
							recordKey = "",
						}
						_G.Mod_KqRowPool[i] = rowEntry

						local rBtn = rGo:AddComponent(typeof(Button))
						rBtn.targetGraphic = rBgImg
						rBtn.onClick:AddListener(function()
							local clickedKey = tostring(rowEntry.recordKey or "")
							if clickedKey == "" then return end
							if _G.Mod_KqDetailPanelVisible and _G.Mod_SelectedKqKey == clickedKey then
								SetKqDetailPanelVisible(false)
							else
								_G.Mod_SelectedKqKey = clickedKey
								SetKqDetailPanelVisible(true)
							end
							if _G.Mod_RefreshKqPanelUI then
								_G.Mod_RefreshKqPanelUI()
							end
						end)
					end

					rowEntry.go:SetActive(true)
					if #list == 0 then
						rowEntry.recordKey = ""
						rowEntry.bg.color = Color(1, 1, 1, 0.0)
						rowEntry.txt.text = "<color=#AAAAAA>Chưa có dữ liệu log thời gian xử lý...</color>"
					else
						local rec = list[i]
						rowEntry.recordKey = tostring(rec.key or "")
						local isSelected = (_G.Mod_KqDetailPanelVisible and _G.Mod_SelectedKqKey == rowEntry.recordKey)
						if isSelected then
							rowEntry.bg.color = Color(0.18, 0.32, 0.48, 0.85)
						elseif i % 2 == 0 then
							rowEntry.bg.color = Color(1, 1, 1, 0.04)
						else
							rowEntry.bg.color = Color(1, 1, 1, 0.01)
						end

						local lineStr = FormatAccountTimeRecordLine(rec)
						if rec.failed then
							-- Màu đỏ như các button trong Mod (#D93838), không dùng màu Red (#FF0000)
							rowEntry.txt.text = "<color=#D93838>" .. lineStr .. "</color>"
						elseif rec.done then
							rowEntry.txt.text = "<color=#00FF88>" .. lineStr .. "</color>"
						else
							rowEntry.txt.text = "<color=#FFFF00>" .. lineStr .. "</color>"
						end
					end
				end

				for i = count + 1, #_G.Mod_KqRowPool do
					local rowEntry = _G.Mod_KqRowPool[i]
					if rowEntry and rowEntry.go and not rowEntry.go:Equals(nil) then
						rowEntry.go:SetActive(false)
					end
				end

				if _G.Mod_KqDetailPanelVisible and _G.Mod_RefreshKqDetailPanelUI then
					_G.Mod_RefreshKqDetailPanelUI()
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
				else
					SetKqDetailPanelVisible(false)
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

		local dpcbBtnComp = dpCloseBtnGo:AddComponent(typeof(Button))
		dpcbBtnComp.targetGraphic = dpcbImg
		dpcbBtnComp.onClick:AddListener(function()
			SetKqDetailPanelVisible(false)
			if _G.Mod_RefreshKqPanelUI then _G.Mod_RefreshKqPanelUI() end
		end)

		local clrBtnComp = clearBtnGo:AddComponent(typeof(Button))
		clrBtnComp.targetGraphic = clrImg
		clrBtnComp.onClick:AddListener(function()
			if _G.Mod_ClearAllAccountTimeRecords then
				_G.Mod_ClearAllAccountTimeRecords()
			end
		end)
	end)
end
EnsureKqResultPanelUI()
LoadAccountTimeRecords(false)

-- =========================================================================
-- [MOD FEATURE]: ẨN TOÀN BỘ LOG QUICKMSG MÀU XANH Ở GÓC TRÁI DƯỚI MÀN HÌNH
-- Mô tả: Tắt hiển thị FloatingWordUtility.QuickMsg / Tip_FloatTipUI ở góc trái dưới
--        nhưng vẫn giữ nguyên thông báo bộ đếm thời gian giữa màn hình (FloatingTipUtility).
-- =========================================================================
_G.Mod_DisableQuickMsg = true
local function SilenceBottomLeftQuickMsg()
	pcall(function()
		if _G.FloatingWordUtility then
			if not _G.FloatingWordUtility._Orig_QuickMsg then
				_G.FloatingWordUtility._Orig_QuickMsg = _G.FloatingWordUtility.QuickMsg
			end
			_G.FloatingWordUtility.QuickMsg = function(...)
				if _G.Mod_DisableQuickMsg ~= false then return end
				return _G.FloatingWordUtility._Orig_QuickMsg(...)
			end
			if _G.FloatingWordUtility.MaxMsgFilterList then
				if not _G.FloatingWordUtility._Orig_MaxMsgFilterList then
					_G.FloatingWordUtility._Orig_MaxMsgFilterList = _G.FloatingWordUtility.MaxMsgFilterList
				end
				_G.FloatingWordUtility.MaxMsgFilterList = function(...)
					if _G.Mod_DisableQuickMsg ~= false then return end
					return _G.FloatingWordUtility._Orig_MaxMsgFilterList(...)
				end
			end
			if _G.FloatingWordUtility.Update then
				if not _G.FloatingWordUtility._Orig_Update then
					_G.FloatingWordUtility._Orig_Update = _G.FloatingWordUtility.Update
				end
				_G.FloatingWordUtility.Update = function(...)
					if _G.Mod_DisableQuickMsg ~= false then
						if _G.FloatingWordUtility.msgQueue and _G.FloatingWordUtility.msgQueue.Clear then
							_G.FloatingWordUtility.msgQueue:Clear()
						end
						return
					end
					return _G.FloatingWordUtility._Orig_Update(...)
				end
			end
			if _G.FloatingWordUtility.msgQueue and _G.FloatingWordUtility.msgQueue.Clear then
				_G.FloatingWordUtility.msgQueue:Clear()
			end
		end
		if _G.UIManager and _G.UIID and _G.UIID.TipFloatTipUI then
			local tipUi = _G.UIManager.GetUiByName and _G.UIManager.GetUiByName(_G.UIID.TipFloatTipUI)
			if tipUi and tipUi.activeSelf then
				tipUi:SetActive(false)
			end
		end
	end)
end
_G.SilenceBottomLeftQuickMsg = SilenceBottomLeftQuickMsg
SilenceBottomLeftQuickMsg()

-- =========================================================================
-- [MOD FEATURE]: TỰ ĐỘNG ĐÓNG MÀN HÌNH UPDATE / LOADING KHI ĐÃ VÀO GAME HOẶC LOGIN
-- Mô tả:
--   1. Ở lần đầu cài game hoặc sau khi tải hot-update / restart, CS.LauncherUI không được
--      Scene.EnterLogin() hay Login_LoginCreateRoleUI:OnShow() đóng lại -> Tự động gọi
--      CS.LauncherUI.Close() và MuInterfaceLua.Instance:HideView() ngay khi vào Login/Role/Game.
--   2. Khi nhảy cóc qua màn hình chọn/tạo nhân vật để vào thẳng bối cảnh game, PreloadResourceData
--      chưa chạy đủ 6 UI (resProcess < 0.99) khiến Loading_LoadingUI ("Thợ Rèn đang chế tạo trang bị")
--      kẹt ở 100% dù nhân vật và map phía sau đã load xong -> Tự động đồng bộ tiến độ Preload,
--      bắn Event.Load_PreLoadEnd để kích hoạt Camera/MainMenuUI và ẩn Loading_LoadingUI.
-- =========================================================================
_G.Mod_LoadingStuckTicks = _G.Mod_LoadingStuckTicks or 0

local function CloseStuckUpdateAndLoadingScreens(forceCloseLoading)
	pcall(function()
		local isInGameWorld = false
		local pMe = _G.RoleManager and _G.RoleManager.me
		local curMapId = tonumber(_G.SceneData and _G.SceneData.mapId or 0) or 0
		local isMapLoaded = (_G.SceneData and _G.SceneData.mapLoaded == true) or false

		-- CHỈ coi là đã vào thế giới game khi thực sự có bản đồ hợp lệ (curMapId > 0) và đã có nhân vật hoặc đã load map
		if curMapId > 0 and (pMe ~= nil or isMapLoaded) then
			isInGameWorld = true
		end

		local isLoginOrRoleVisible = false
		if _G.UIManager then
			if (_G.UIManager.IsVisible and (
				_G.UIManager.IsVisible("Login_LoginUI")
				or _G.UIManager.IsVisible("Login_LoginRoleUI")
				or _G.UIManager.IsVisible("Login_LoginCreateRoleUI")
				or (_G.UIID and _G.UIID.LoginUI and _G.UIManager.IsVisible(_G.UIID.LoginUI))
				or (_G.UIID and _G.UIID.LoginRoleUI and _G.UIManager.IsVisible(_G.UIID.LoginRoleUI))
				or (_G.UIID and _G.UIID.LoginCreateRoleUI and _G.UIManager.IsVisible(_G.UIID.LoginCreateRoleUI))
			)) then
				isLoginOrRoleVisible = true
			elseif _G.UIManager.GetUiByName and (
				_G.UIManager.GetUiByName("Login_LoginUI") ~= nil
				or _G.UIManager.GetUiByName("Login_LoginRoleUI") ~= nil
				or _G.UIManager.GetUiByName("Login_LoginCreateRoleUI") ~= nil
			) then
				isLoginOrRoleVisible = true
			end
		end

		local isLoginOrRoleReady = isInGameWorld or isLoginOrRoleVisible

		-- 1. Ngay khi đã tải xong Update và vào Scene Login / Role / Game -> Đóng CS.LauncherUI
		if isLoginOrRoleReady then
			pcall(function()
				if CS and CS.LauncherUI and CS.LauncherUI.Close then
					CS.LauncherUI.Close()
				end
			end)
			pcall(function()
				if _G.MuInterfaceLua and _G.MuInterfaceLua.Instance and _G.MuInterfaceLua.Instance.HideView then
					_G.MuInterfaceLua.Instance:HideView()
				end
			end)
		end

		-- Nếu đang ở màn hình Login/Role (curMapId == 0) mà Loading_LoadingUI bị kẹt đè lên Login_LoginUI:
		-- Chỉ ẩn Loading_LoadingUI, TUYỆT ĐỐI KHÔNG bắn Event.Load_PreLoadEnd (tránh bật Main_MainMenuUI ở Map 0)
		if not isInGameWorld and curMapId <= 0 and isLoginOrRoleVisible and not (_G.LoginData and _G.LoginData.InGame) then
			pcall(function()
				if _G.UIManager and _G.UIManager.IsVisible and _G.UIManager.Hide then
					if _G.UIManager.IsVisible("Loading_LoadingUI") or (_G.UIID and _G.UIID.LoadingUI and _G.UIManager.IsVisible(_G.UIID.LoadingUI)) then
						_G.Mod_LoadingStuckTicks = (_G.Mod_LoadingStuckTicks or 0) + 1
						if _G.Mod_LoadingStuckTicks >= 2 then
							_G.Mod_LoadingStuckTicks = 0
							if _G.UIID and _G.UIID.LoadingUI then
								_G.UIManager.Hide(_G.UIID.LoadingUI)
							end
							_G.UIManager.Hide("Loading_LoadingUI")
						end
					else
						_G.Mod_LoadingStuckTicks = 0
					end
				end
			end)
			return
		end

		-- 2. Khi đã vào bối cảnh game thực sự (curMapId > 0) -> Giải phóng Loading_LoadingUI bị kẹt ở 100%
		if isInGameWorld then
			pcall(function()
				if _G.PreloadResourceData then
					local total = tonumber(_G.PreloadResourceData.totalCount) or 6
					if total <= 0 then
						total = 6
						_G.PreloadResourceData.totalCount = 6
					end
					if (tonumber(_G.PreloadResourceData.preCount) or 0) < total then
						_G.PreloadResourceData.preCount = total
					end
				end
			end)

			local isLoadingVisible = false
			pcall(function()
				if _G.UIManager and _G.UIManager.IsVisible then
					if _G.UIManager.IsVisible("Loading_LoadingUI") or (_G.UIID and _G.UIID.LoadingUI and _G.UIManager.IsVisible(_G.UIID.LoadingUI)) then
						isLoadingVisible = true
					end
				end
				if not isLoadingVisible and _G.UIManager and _G.UIManager.GetUiByName then
					local lUi = _G.UIManager.GetUiByName("Loading_LoadingUI")
					if lUi and lUi.activeSelf then
						isLoadingVisible = true
					end
				end
			end)

			if isLoadingVisible then
				_G.Mod_LoadingStuckTicks = (_G.Mod_LoadingStuckTicks or 0) + 1
				if (forceCloseLoading and pMe ~= nil and isMapLoaded) or (pMe ~= nil and isMapLoaded and _G.Mod_LoadingStuckTicks >= 2) or _G.Mod_LoadingStuckTicks >= 4 then
					_G.Mod_LoadingStuckTicks = 0
					pcall(function()
						if _G.SceneData then _G.SceneData.mapLoaded = true end
						if _G.EventManager and _G.Event and _G.Event.Load_PreLoadEnd then
							_G.EventManager.Dispatch(_G.Event.Load_PreLoadEnd)
						end
					end)
					pcall(function()
						if _G.UIManager and _G.UIManager.Hide then
							if _G.UIID and _G.UIID.LoadingUI then
								_G.UIManager.Hide(_G.UIID.LoadingUI)
							end
							_G.UIManager.Hide("Loading_LoadingUI")
						end
					end)
				end
			else
				_G.Mod_LoadingStuckTicks = 0
			end
		else
			_G.Mod_LoadingStuckTicks = 0
		end
	end)
end
_G.CloseStuckUpdateAndLoadingScreens = CloseStuckUpdateAndLoadingScreens

-- Hook bổ sung vào DismissBlockers và các hàm chuyển cảnh Scene
local orig_DismissBlockers = DismissBlockers or _G.DismissBlockers
DismissBlockers = function(...)
	if orig_DismissBlockers then pcall(orig_DismissBlockers, ...) end
	CloseStuckUpdateAndLoadingScreens(false)
end
_G.DismissBlockers = DismissBlockers

pcall(function()
	if _G.Scene then
		if _G.Scene.EnterLogin and not _G.Scene._ModOrigEnterLogin then
			_G.Scene._ModOrigEnterLogin = _G.Scene.EnterLogin
			_G.Scene.EnterLogin = function(...)
				local ret = _G.Scene._ModOrigEnterLogin(...)
				Timer.Start(0.5, function() CloseStuckUpdateAndLoadingScreens(false) end)
				Timer.Start(1.5, function() CloseStuckUpdateAndLoadingScreens(false) end)
				return ret
			end
		end
		if _G.Scene.OnEnterRole and not _G.Scene._ModOrigOnEnterRole then
			_G.Scene._ModOrigOnEnterRole = _G.Scene.OnEnterRole
			_G.Scene.OnEnterRole = function(...)
				local curMapId = tonumber(_G.SceneData and _G.SceneData.mapId or 0) or 0
				if _G.Bot_IsInGameWorld or (_G.LoginData and _G.LoginData.InGame == true) or curMapId > 0 then
					return
				end
				local ret = _G.Scene._ModOrigOnEnterRole(...)
				Timer.Start(0.3, function() CloseStuckUpdateAndLoadingScreens(false) end)
				return ret
			end
		end
		if _G.Scene.OnEnterCreateRole and not _G.Scene._ModOrigOnEnterCreateRole then
			_G.Scene._ModOrigOnEnterCreateRole = _G.Scene.OnEnterCreateRole
			_G.Scene.OnEnterCreateRole = function(...)
				local curMapId = tonumber(_G.SceneData and _G.SceneData.mapId or 0) or 0
				if _G.Bot_IsInGameWorld or (_G.LoginData and _G.LoginData.InGame == true) or curMapId > 0 then
					return
				end
				local ret = _G.Scene._ModOrigOnEnterCreateRole(...)
				Timer.Start(0.3, function() CloseStuckUpdateAndLoadingScreens(false) end)
				return ret
			end
		end
	end
end)

-- Khởi chạy bộ đếm thời gian phiên 1s/lần & thông báo giữa màn hình 5s/lần (Style Kundun)
if _G.Mod_AccSessionTimer then
	pcall(function() Timer.Stop(_G.Mod_AccSessionTimer) end)
	_G.Mod_AccSessionTimer = nil
end
_G.Mod_AccSessionTimer = Timer.StartLoop(1.0, -1, function()
	pcall(function()
		SilenceBottomLeftQuickMsg()
		CloseStuckUpdateAndLoadingScreens(false)
		EnsureKqResultPanelUI()
		if _G.SyncFarmNHBtnUI then _G.SyncFarmNHBtnUI() end
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

		local curLv = GetCurrentAccountLevel()
		local liveQueen = tonumber(_G.Mod_FarmKCCount) or 0
		local detail = EnsureAccountLevelDetailRecord(key, srvId, email)
		if detail and liveQueen > (tonumber(detail.queenCount) or 0) then
			detail.queenCount = liveQueen
		end

		local rec = _G.Mod_AccTimeRecords[key]
		if not (rec and (rec.done or rec.failed)) then
			if not rec then
				rec = {
					key = key,
					serverId = srvId,
					email = email,
					level = curLv > 0 and curLv or 1,
					queenCount = math.max(liveQueen, tonumber(detail and detail.queenCount) or 0),
					elapsedSec = 0,
					done = false,
					failed = false,
				}
				_G.Mod_AccTimeRecords[key] = rec
			else
				if curLv > 0 then
					rec.level = curLv
				elseif not rec.level or rec.level <= 0 then
					rec.level = 1
				end
				if liveQueen > (tonumber(rec.queenCount) or 0) then
					rec.queenCount = liveQueen
				end
			end
			rec.elapsedSec = (tonumber(rec.elapsedSec) or 0) + 1

			-- Theo dõi thời gian từng Level từ sau Lv 120 (lưu vào account_level_details.json)
			if detail and curLv >= 120 then
				local prevTrackLv = tonumber(detail.curTrackingLv) or 0
				if prevTrackLv < 120 then
					detail.curTrackingLv = curLv
					detail.curLvAccumSec = 1
					detail.levelTimes[curLv] = math.max(tonumber(detail.levelTimes[curLv]) or 0, 1)
				elseif curLv == prevTrackLv then
					detail.curLvAccumSec = (tonumber(detail.curLvAccumSec) or 0) + 1
					detail.levelTimes[curLv] = math.max(tonumber(detail.levelTimes[curLv]) or 0, detail.curLvAccumSec)
				elseif curLv > prevTrackLv then
					local spent = math.max(1, tonumber(detail.curLvAccumSec) or 1)
					local gain = curLv - prevTrackLv
					local basePerLv = math.max(1, math.floor(spent / gain))
					local rem = spent - (basePerLv * gain)
					for lvStep = prevTrackLv, curLv - 1 do
						local addRem = (lvStep == prevTrackLv and rem > 0) and rem or 0
						detail.levelTimes[lvStep] = math.max(1, basePerLv + addRem)
					end
					detail.curTrackingLv = curLv
					detail.curLvAccumSec = 0
					SaveAccountLevelDetailsJson()
				end
			end

			if _G.Mod_KqPanelVisible and _G.Mod_RefreshKqPanelUI and (_G.Mod_CurrentSessionSec % 2 == 0) then
				_G.Mod_RefreshKqPanelUI()
			end
		elseif curLv > (tonumber(rec.level) or 0) and not rec.failed then
			rec.level = curLv
		end

		-- Hiển thị bộ đếm thời gian ra giữa màn hình mỗi 5s/lần (style thông báo Kundun xuất hiện)
		if _G.Mod_CurrentSessionSec % 5 == 0 then
			if rec and not rec.done and not rec.failed then
				SaveAccountTimeRecords()
			end
			local displayRec = rec or {
				serverId = srvId,
				email = email,
				level = curLv > 0 and curLv or 1,
				queenCount = liveQueen,
				elapsedSec = _G.Mod_CurrentSessionSec,
				done = false,
				failed = false,
			}
			local alertColor = (displayRec.failed and "#D93838") or (displayRec.done and "#00FF88") or "#FFFF00"
			FlashAccTimeCenterAlert(FormatAccountTimeRecordLine(displayRec), alertColor)
		end
	end)
end)

-- ====================================
-- [MOD FEATURE]: BỘ CHUYỂN TÀI KHOẢN TỰ ĐỘNG KHI ĐẠT LEVEL MỤC TIÊU HOẶC FAILED
-- Mô tả: Ghi nhận acc hoàn thành (done) hoặc thất bại (failed - màu đỏ button #D93838),
--        reset bộ đếm Farm NH (N) về 0 và tự động gọi quy trình Clear + Login như nút LOGIN.
-- ====================================
local function GetConfiguredTargetLevel()
	local tLvl = 200
	pcall(function()
		if CS and CS.UnityEngine and CS.UnityEngine.PlayerPrefs then
			tLvl = CS.UnityEngine.PlayerPrefs.GetInt("Mod_Farm_TargetLevel", 200)
		end
	end)
	tLvl = tonumber(tLvl) or tonumber(_G.Mod_TargetLevel) or 200
	if tLvl <= 0 then tLvl = 200 end
	return tLvl
end
_G.GetConfiguredTargetLevel = GetConfiguredTargetLevel

_G.IsSwitchingAccount = false
_G.OnAccountReachLevelGoal = function(lvl, targetLvl)
	if _G.IsSwitchingAccount then return end
	_G.IsSwitchingAccount = true
	if _G.StopFarmKCRoutine then pcall(_G.StopFarmKCRoutine) end
	if _G.Mod_InstanceMonitorTimer then
		pcall(function() Timer.Stop(_G.Mod_InstanceMonitorTimer) end)
		_G.Mod_InstanceMonitorTimer = nil
	end
	_G.Mod_IsRunningInstance = false
	_G.Mod_BC_AllowSkipWait = false
	_G.Mod_BC_NextRetryTime = 0
	pcall(function()
		local cMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
		if (_G.TranScriptData and _G.TranScriptData.InTranscript) or cMap >= 1000000 then
			if _G.TranScriptController and _G.TranScriptController.ReqExitInstance then
				_G.TranScriptController.ReqExitInstance()
			elseif _G.networkRequest and _G.networkRequest.ReqExitInstance then
				_G.networkRequest.ReqExitInstance()
			end
		end
	end)
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
	local finishedQueenCount = tonumber(_G.Mod_FarmKCCount) or 0
	if _G.FinalizeAccountTimeOnGoal then
		_G.FinalizeAccountTimeOnGoal(curAccEmail, sId, lvl)
	end
	-- Sau khi đã chốt số Nữ Hoàng vào Log KQ của acc cũ -> Reset bộ đếm Farm NH về 0
	_G.Mod_FarmKCActive = false
	_G.Mod_FarmKCCount = 0
	if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
	if _G.SyncFarmNHBtnUI then pcall(_G.SyncFarmNHBtnUI) end

	Log("=========================================================================", true)
	Log(string.format(">>> [HOÀN THÀNH MỤC TIÊU]: TÀI KHOẢN [%d/%d] %s ĐẠT LEVEL %d/%d [NH:%d] TRÊN %s! <<<",
		curAccIdx, totalAccs, curAccEmail, lvl, targetLvl, finishedQueenCount, tostring(sName)), true)
	Log("=========================================================================", true)
	SaveOutput()
	if _G.FloatingWordUtility and _G.FloatingWordUtility.QuickMsg then
		_G.FloatingWordUtility.QuickMsg(string.format("Hoàn tất %s (Lv %d | NH:%d)! Chuyển sang acc kế tiếp...", curAccEmail, lvl, finishedQueenCount))
	end
	-- Ghi nhật ký vào file thành công
	pcall(function()
		local Application = CS.UnityEngine.Application
		local File = CS.System.IO.File
		local nowStr = os.date("%Y-%m-%d %H:%M:%S")
		local logLine = string.format("%s | STT: %04d | Email: %s | Server: %s | Level: %d | NH: %d\r\n",
			nowStr, curAccIdx, curAccEmail, tostring(sName), lvl, finishedQueenCount)
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
		Timer.Start(1.0, function()
			_G.IsSwitchingAccount = false
			if _G.LoginCurrentSelectedAccount then
				_G.LoginCurrentSelectedAccount()
			else
				ForceLogoutToLogin()
				Timer.Start(2.5, function()
					DismissBlockers()
					StartFullLoginProcess()
				end)
			end
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

_G.OnAccountFailedAndSkip = function(reason)
	if _G.IsSwitchingAccount then return end
	_G.IsSwitchingAccount = true
	if _G.StopFarmKCRoutine then pcall(_G.StopFarmKCRoutine) end
	if _G.BotQuestMonitorTimer then
		pcall(function() Timer.Stop(_G.BotQuestMonitorTimer) end)
		_G.BotQuestMonitorTimer = nil
	end
	if _G.Global30sUpgradeTimer then
		pcall(function() Timer.Stop(_G.Global30sUpgradeTimer) end)
		_G.Global30sUpgradeTimer = nil
	end
	local curLv = GetCurrentAccountLevel()
	if curLv <= 0 then curLv = 80 end
	local targetLvl = GetConfiguredTargetLevel()
	local curAcc = GetCurrentAccount()
	local curAccEmail = curAcc.account or "Unknown"
	local curAccIdx = _G.CurrentAccountIndex or 1
	local totalAccs = (_G.BotAccounts and #_G.BotAccounts) or 1
	local sId, sName = _G.GetActualCurrentServerInfo()
	local finishedQueenCount = tonumber(_G.Mod_FarmKCCount) or 0
	if _G.FinalizeAccountTimeOnFailed then
		_G.FinalizeAccountTimeOnFailed(curAccEmail, sId, curLv)
	end
	-- Sau khi đã chốt số Nữ Hoàng vào Log KQ của acc cũ -> Reset bộ đếm Farm NH về 0
	_G.Mod_FarmKCActive = false
	_G.Mod_FarmKCCount = 0
	if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
	if _G.SyncFarmNHBtnUI then pcall(_G.SyncFarmNHBtnUI) end

	Log("=========================================================================", true)
	Log(string.format(">>> [SKIP ACC FAILED]: TÀI KHOẢN [%d/%d] %s (Lv %d | NH:%d) TRÊN %s -> FAILED (%s)! <<<",
		curAccIdx, totalAccs, curAccEmail, curLv, finishedQueenCount, tostring(sName), tostring(reason or "Bug NV Nữ Hoàng thất bại")), true)
	Log("=========================================================================", true)
	SaveOutput()
	pcall(function()
		local Application = CS.UnityEngine.Application
		local File = CS.System.IO.File
		local nowStr = os.date("%Y-%m-%d %H:%M:%S")
		local logLine = string.format("%s | STT: %04d | Email: %s | Server: %s | Level: %d | NH: %d | FAILED: %s\r\n",
			nowStr, curAccIdx, curAccEmail, tostring(sName), curLv, finishedQueenCount, tostring(reason or "Bug NV Nữ Hoàng thất bại"))
		local outDir = Application.persistentDataPath
		File.AppendAllText(outDir .. "/farm_failed_accounts.txt", logLine, CS.System.Text.Encoding.UTF8)
	end)
	local nextAccIdx = curAccIdx + 1
	if nextAccIdx <= totalAccs then
		_G.CurrentAccountIndex = nextAccIdx
		CS.UnityEngine.PlayerPrefs.SetInt("Mod_Farm_CurAccIndex", nextAccIdx)
		CS.UnityEngine.PlayerPrefs.Save()
		local nextAcc = GetCurrentAccount()
		Log(string.format(">>> [SKIP -> CHUYỂN TIẾP TÀI KHOẢN]: Chuyển sang Acc [%d/%d]: %s (Server: %s) <<<",
			nextAccIdx, totalAccs, nextAcc.account, tostring(sName)), true)
		SaveOutput()
		_G.CurrentRoleIndex = 1
		_G.TargetRoleIndex = 1
		_G.HasCreatedRoleForTarget = false
		_G.IsRoleCreating = false
		_G.Bot_IsInGameWorld = false
		Timer.Start(1.0, function()
			_G.IsSwitchingAccount = false
			if _G.LoginCurrentSelectedAccount then
				_G.LoginCurrentSelectedAccount()
			else
				ForceLogoutToLogin()
				Timer.Start(2.5, function()
					DismissBlockers()
					StartFullLoginProcess()
				end)
			end
		end)
	else
		Log("=========================================================================", true)
		Log(string.format(">>> ĐÃ XỬ LÝ XONG TẤT CẢ %d TÀI KHOẢN TRÊN MÁY CHỦ %s! <<<", totalAccs, tostring(sName)), true)
		Log("=========================================================================", true)
		SaveOutput()
		_G.IsSwitchingAccount = false
		_G.StopAutoFarmBot()
	end
end

-- =========================================================================
-- [MOD FEATURE]: ĐỒNG BỘ NÚT "FARM NH" (DISABLE KHI VÒNG LẶP CHÍNH ĐANG CHẠY)
-- Mô tả:
--   - Đổi tên nút "Farm KC" thành "Farm NH" ("Farm NH (%d)").
--   - Khi vòng lặp chính (_G.Bot_Running) bắt đầu chạy, nút "Farm NH" bị disable
--     (interactable = false), không cho phép người dùng tự ý bật/tắt thủ công.
-- =========================================================================
local function SyncFarmNHBtnUI()
	pcall(function()
		local GameObject = CS.UnityEngine.GameObject
		local Color = CS.UnityEngine.Color
		local Button = CS.UnityEngine.UI.Button
		local Image = CS.UnityEngine.UI.Image
		local Text = CS.UnityEngine.UI.Text

		-- Hiển thị lại cụm UI chỉnh Delay Nữ Hoàng: [-] Delay Nữ Hoàng: Xs [+]
		local panelGo = GameObject.Find("ModMenuPanel")
		local showNames = { "QueenDelayLabel", "BtnQueenDelayMinus", "BtnQueenDelayPlus" }
		for _, sName in ipairs(showNames) do
			local sGo = nil
			if panelGo and not IsNil(panelGo) then
				local sTr = panelGo.transform:Find(sName)
				if sTr and not IsNil(sTr) then
					sGo = sTr.gameObject
				end
			end
			if not sGo or IsNil(sGo) then
				sGo = GameObject.Find(sName)
			end
			if sGo and not IsNil(sGo) then
				if not sGo.activeSelf then
					sGo:SetActive(true)
				end
				if sName == "QueenDelayLabel" then
					local qTxt = sGo:GetComponent(typeof(Text))
					if qTxt and not IsNil(qTxt) then
						qTxt.text = "Delay Nữ Hoàng: " .. tostring(tonumber(_G.Mod_QueenDelaySec) or 20) .. "s"
					end
				end
			end
		end

		local btnGo = GameObject.Find("BtnFarmKC")
		if not btnGo or IsNil(btnGo) then return end

		local btnComp = btnGo:GetComponent(typeof(Button))
		local imgComp = btnGo:GetComponent(typeof(Image))
		local txtGo = btnGo.transform:Find("Text")
		local txtComp = txtGo and txtGo.gameObject:GetComponent(typeof(Text))

		local isBotRunning = (_G.Bot_Running == true)
		if btnComp and not IsNil(btnComp) then
			btnComp.interactable = not isBotRunning
		end

		if txtComp and not IsNil(txtComp) then
			if _G.Mod_FarmKCActive and (_G.Mod_FarmKCCount or 0) > 0 then
				txtComp.text = string.format("Farm NH (%d)", _G.Mod_FarmKCCount)
			else
				txtComp.text = "Farm NH"
			end
			txtComp.color = isBotRunning and Color(0.85, 0.85, 0.85, 0.85) or Color.white
		end

		if imgComp and not IsNil(imgComp) then
			if _G.Mod_FarmKCActive then
				imgComp.color = isBotRunning and Color(0.10, 0.50, 0.35, 0.72) or Color(0.12, 0.65, 0.45, 1)
			else
				imgComp.color = isBotRunning and Color(0.42, 0.32, 0.18, 0.65) or Color(0.85, 0.50, 0.05, 1)
			end
		end
	end)
end
_G.SyncFarmNHBtnUI = SyncFarmNHBtnUI

local orig_UpdateFarmKCBtnUI = _G.UpdateFarmKCBtnUI
_G.UpdateFarmKCBtnUI = function()
	if orig_UpdateFarmKCBtnUI then pcall(orig_UpdateFarmKCBtnUI) end
	SyncFarmNHBtnUI()
end

local orig_ModUpdatePanelBotBtn = _G.ModUpdatePanelBotBtn
_G.ModUpdatePanelBotBtn = function()
	if orig_ModUpdatePanelBotBtn then pcall(orig_ModUpdatePanelBotBtn) end
	SyncFarmNHBtnUI()
end

-- =========================================================================
-- [MOD FEATURE]: BẢO VỆ TRANG BỊ XỊN, MẶC ĐỒ & CƯỜNG HÓA TIMER (CHỐNG KẸT KHI FARM NỮ HOÀNG)
-- Mô tả:
--   1. Khắc phục lỗi Coroutine bị ngắt khi chuyển map liên tục (2101000 <-> bãi farm)
--      khiến _G.AutoEvenEnhanceRunning bị kẹt true vĩnh viễn: Chuyển toàn bộ chu trình
--      AutoEvenEnhanceEquipments sang Timer.StartLoop độc lập với Scene + Watchdog 12s.
--   2. Bảo vệ tuyệt đối trang bị cùng hệ có Bậc (equipClass) cao hơn, Đồ Bộ (suitId > 0),
--      Phẩm chất (quality) cao hơn hoặc nhiều dòng Trác Việt hơn khỏi bị thu hồi nhầm
--      khi đồ cũ trên người đang có cấp cường hóa cao (+7..+15).
--   3. Chu trình 30s phân bổ điểm -> chờ 1.5s đồng bộ chỉ số -> mặc đồ & kế thừa cường hóa ->
--      chờ 3.5s đồng bộ trang bị -> thu hồi rác -> đập đồ đều lên +30.
-- =========================================================================
local function ResolveItemAndEquipTables(item)
	if not item then return nil, nil, 0 end
	local tblItem = item.tblItem or (item.data and item.data.tblItem) or (item.GetTblItem and item:GetTblItem())
	local itemId = tonumber(item.itemId or (tblItem and tblItem.id) or (item.data and item.data.itemId) or 0) or 0
	if not tblItem and itemId > 0 and _G.ClientTable and _G.ClientTable.cfg_Item_itemManager then
		pcall(function() tblItem = _G.ClientTable.cfg_Item_itemManager:TryGetValue(itemId) end)
	end
	local tblEquip = item.tblEquip or (item.data and item.data.tblEquip)
	if (not tblEquip or not tblEquip.id) and itemId > 0 and _G.ClientTable and _G.ClientTable.cfg_Item_equipManager then
		pcall(function()
			local eq = _G.ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
			if eq then tblEquip = eq end
		end)
	end
	return tblItem, tblEquip, itemId
end

local function IsItemMatchingMyCareer(tblItem, itemId)
	if not tblItem or not tblItem.career or tblItem.career == "0" or tostring(tblItem.career) == "0" or tblItem.career == "" then
		return true
	end
	local pMe = _G.RoleManager and _G.RoleManager.me
	local myCareer = tonumber((pMe and pMe.career) or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.career) or 0) or 0
	if myCareer <= 0 then return true end

	local matchCareer = false
	if _G.RoleEquipUtility and _G.RoleEquipUtility.CheckCareerEquip and itemId > 0 then
		pcall(function() matchCareer = _G.RoleEquipUtility.CheckCareerEquip(itemId, myCareer) end)
	end
	if not matchCareer then
		pcall(function()
			local myBasic = (_G.RoleUtility and _G.RoleUtility.GetBasicCareer and _G.RoleUtility.GetBasicCareer(myCareer)) or (myCareer % 10)
			local cList = string.split(tostring(tblItem.career), "#")
			for _, cIdStr in ipairs(cList) do
				local cId = tonumber(cIdStr)
				if cId and cId > 0 then
					if _G.RoleUtility and _G.RoleUtility.CareerJudge and _G.RoleUtility.CareerJudge(myCareer, cId) then
						matchCareer = true
						break
					end
					local targetBasic = (_G.RoleUtility and _G.RoleUtility.GetBasicCareer and _G.RoleUtility.GetBasicCareer(cId)) or (cId % 10)
					if myBasic == targetBasic then
						matchCareer = true
						break
					end
				end
			end
		end)
	end
	return matchCareer
end

local function GetEquipExcellenceLineCount(item, tblEquip)
	local count = 0
	pcall(function()
		local sInfo = item.serverInfo or item.serverData or {}
		local rawExc = item.excellence or sInfo.excellentList or sInfo.excellentInfo or sInfo.excellentAttrs
		if type(rawExc) == "table" then
			for _ in pairs(rawExc) do count = count + 1 end
		end
		if count == 0 and _G.RoleEquipUtility then
			local excDesList = nil
			if rawExc and _G.RoleEquipUtility.GetEquipExcellence then
				excDesList = _G.RoleEquipUtility.GetEquipExcellence(rawExc, tblEquip or {})
			end
			if (not excDesList or #excDesList == 0) and _G.RoleEquipUtility.GetEquipExcellenceDesByServerInfo then
				excDesList = _G.RoleEquipUtility.GetEquipExcellenceDesByServerInfo(sInfo)
			end
			if excDesList then count = #excDesList end
		end
		if count == 0 and item.GetEquipExcellenceDesList then
			local list = item:GetEquipExcellenceDesList()
			if list then count = #list end
		end
	end)
	return count
end

local function GetTargetSlotForEquip(item, tblItem)
	local canPos = nil
	pcall(function()
		if _G.RoleEquipUtility and _G.RoleEquipUtility.WearEquipIndex then
			canPos = _G.RoleEquipUtility.WearEquipIndex(item)
		end
	end)
	if not canPos and tblItem and tblItem.subType then
		local st = tonumber(tblItem.subType) or 0
		if st == 13 then canPos = 3
		elseif st == 14 then canPos = 4
		elseif st == 15 then canPos = 6
		elseif st == 16 then canPos = 7
		elseif st == 17 then canPos = 8
		elseif st >= 1 and st <= 12 then canPos = 1
		elseif (st >= 23 and st <= 25) or st == 56 or st == 57 or st == 81 then canPos = 5
		end
	end
	return canPos
end

local function IsBagEquipStrictlyBetterThanEquipped(item, tblItem, tblEquip, oldEquip)
	if not tblEquip then return false end
	if not oldEquip then return true end

	local canUpFight = false
	pcall(function()
		if _G.RoleEquipUtility and _G.RoleEquipUtility.CanUpFight then
			local st = _G.RoleEquipUtility.CanUpFight(item)
			if st == ((_G.EquipUpState and _G.EquipUpState.CanWearUpFight) or 1) then
				canUpFight = true
			end
		end
	end)
	if canUpFight then return true end

	local oldTblItem, oldTblEquip = ResolveItemAndEquipTables(oldEquip)
	local newClass = tonumber(tblEquip.equipClass or 0) or 0
	local oldClass = tonumber((oldTblEquip and oldTblEquip.equipClass) or 0) or 0
	if newClass ~= oldClass then
		return newClass > oldClass
	end

	local newSuit = ((tonumber(tblEquip.suitId or 0) or 0) > 0) and 1 or 0
	local oldSuit = ((tonumber((oldTblEquip and oldTblEquip.suitId) or 0) or 0) > 0) and 1 or 0
	if newSuit ~= oldSuit then
		return newSuit > oldSuit
	end

	local newQuality = tonumber((tblItem and tblItem.quality) or 0) or 0
	local oldQuality = tonumber((oldTblItem and oldTblItem.quality) or 0) or 0
	if newQuality ~= oldQuality then
		return newQuality > oldQuality
	end

	local newExc = GetEquipExcellenceLineCount(item, tblEquip)
	local oldExc = GetEquipExcellenceLineCount(oldEquip, oldTblEquip)
	if newExc ~= oldExc then
		return newExc > oldExc
	end

	return false
end

local function CompareTwoBagEquips(aItem, bItem)
	local aTblItem, aTblEquip = ResolveItemAndEquipTables(aItem)
	local bTblItem, bTblEquip = ResolveItemAndEquipTables(bItem)

	local aClass = tonumber((aTblEquip and aTblEquip.equipClass) or 0) or 0
	local bClass = tonumber((bTblEquip and bTblEquip.equipClass) or 0) or 0
	if aClass ~= bClass then return aClass > bClass end

	local aSuit = ((tonumber((aTblEquip and aTblEquip.suitId) or 0) or 0) > 0) and 1 or 0
	local bSuit = ((tonumber((bTblEquip and bTblEquip.suitId) or 0) or 0) > 0) and 1 or 0
	if aSuit ~= bSuit then return aSuit > bSuit end

	local aQual = tonumber((aTblItem and aTblItem.quality) or 0) or 0
	local bQual = tonumber((bTblItem and bTblItem.quality) or 0) or 0
	if aQual ~= bQual then return aQual > bQual end

	local aExc = GetEquipExcellenceLineCount(aItem, aTblEquip)
	local bExc = GetEquipExcellenceLineCount(bItem, bTblEquip)
	if aExc ~= bExc then return aExc > bExc end

	local aInt = tonumber(aItem.intensify or 0) or 0
	local bInt = tonumber(bItem.intensify or 0) or 0
	if aInt ~= bInt then return aInt > bInt end

	return tostring(aItem.id or "") < tostring(bItem.id or "")
end

local function GetPlayerPrimaryStatValue(attrEnum, fieldName)
	local val = 0
	pcall(function()
		if _G.QuickFind and _G.QuickFind.LuaMainPlayerData and attrEnum then
			local pData = _G.QuickFind.LuaMainPlayerData()
			if pData and pData.TryGetAttrValue then
				local v = tonumber(pData:TryGetAttrValue(attrEnum) or 0) or 0
				if v > val then val = v end
			end
		end
		if _G.QuickFind and _G.QuickFind.LuaMainPlayerViewAttrData and fieldName then
			local vAttr = _G.QuickFind.LuaMainPlayerViewAttrData()
			if vAttr and vAttr[fieldName] then
				local v = tonumber(vAttr[fieldName]) or 0
				if v > val then val = v end
			end
		end
		if _G.ViewData and _G.ViewData.meData then
			if _G.ViewData.meData.GetAttribute and attrEnum then
				local v = tonumber(_G.ViewData.meData:GetAttribute(attrEnum) or 0) or 0
				if v > val then val = v end
			end
			if fieldName and _G.ViewData.meData[fieldName] then
				local v = tonumber(_G.ViewData.meData[fieldName]) or 0
				if v > val then val = v end
			end
		end
		if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.data then
			local rData = _G.RoleManager.me.data
			if rData.GetAttribute and attrEnum then
				local v = tonumber(rData:GetAttribute(attrEnum) or 0) or 0
				if v > val then val = v end
			end
		end
	end)
	return val
end

local function CanPlayerWearEquipNow(item, tblItem, itemId)
	if not IsItemMatchingMyCareer(tblItem, itemId) then return false end
	local pMe = _G.RoleManager and _G.RoleManager.me
	local curLvl = tonumber((pMe and pMe.level) or (pMe and pMe.data and pMe.data.level) or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.level) or 1) or 1
	local needLv = tonumber((tblItem and (tblItem.needLevel or tblItem.level)) or 0) or 0
	if needLv > 0 and curLvl < needLv then return false end

	if _G.RoleEquipUtility and _G.RoleEquipUtility.CheckUseItem then
		local okCheck = false
		pcall(function()
			local ok, _ = _G.RoleEquipUtility.CheckUseItem(item, (_G.CheckUseItemWay and _G.CheckUseItemWay.NotAddPoint) or 1)
			if ok == true then okCheck = true end
		end)
		if okCheck then return true end
	end

	if tblItem and _G.EAttributeType then
		local myStr = GetPlayerPrimaryStatValue(_G.EAttributeType.strength, "strength")
		local myAgi = GetPlayerPrimaryStatValue(_G.EAttributeType.agility, "agility")
		local myEne = GetPlayerPrimaryStatValue(_G.EAttributeType.energy, "energy")
		if (myStr > 0 or myAgi > 0 or myEne > 0) then
			local reqStr = tonumber(tblItem.needStrength or 0) or 0
			local reqAgi = tonumber(tblItem.needAgility or 0) or 0
			local reqEne = tonumber(tblItem.needEnergy or 0) or 0
			if (reqStr <= 0 or myStr >= reqStr) and (reqAgi <= 0 or myAgi >= reqAgi) and (reqEne <= 0 or myEne >= reqEne) then
				return true
			end
		end
	end
	return false
end

local orig_IsRecyclableEquipment = _G.IsRecyclableEquipment
_G.IsRecyclableEquipment = function(item)
	if not item or not item.id then return false end
	if orig_IsRecyclableEquipment and not orig_IsRecyclableEquipment(item) then
		return false
	end

	-- Bảo vệ bổ sung: Không bao giờ thu hồi món đồ cùng hệ tốt nhất trong túi cho mỗi vị trí nếu nó xịn hơn đồ đang mặc
	local keepItem = false
	pcall(function()
		local tblItem, tblEquip, itemId = ResolveItemAndEquipTables(item)
		if not tblItem or not tblEquip then return end
		if not IsItemMatchingMyCareer(tblItem, itemId) then return end

		local canPos = GetTargetSlotForEquip(item, tblItem)
		if not canPos then return end

		local equipsData = (_G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.data and _G.RoleManager.me.data.equipsData and _G.RoleManager.me.data.equipsData.Data)
			or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.equipsData and _G.ViewData.meData.equipsData.Data)
		local oldEquip = equipsData and equipsData[canPos]

		if not IsBagEquipStrictlyBetterThanEquipped(item, tblItem, tblEquip, oldEquip) then
			return
		end

		-- Chỉ giữ lại duy nhất 1 ứng viên tốt nhất trong túi cho slot canPos để không làm đầy túi
		local bagList = (_G.BagInfoData and _G.BagInfoData.TotalItems) or (_G.BagInfoData and _G.BagInfoData.GetTotalBag and _G.BagInfoData.GetTotalBag())
		if bagList then
			for _, other in pairs(bagList) do
				if other and other.id and other.id ~= item.id then
					local oTblItem, oTblEquip, oItemId = ResolveItemAndEquipTables(other)
					if oTblItem and oTblEquip and IsItemMatchingMyCareer(oTblItem, oItemId) then
						local oPos = GetTargetSlotForEquip(other, oTblItem)
						if oPos == canPos and IsBagEquipStrictlyBetterThanEquipped(other, oTblItem, oTblEquip, oldEquip) then
							if CompareTwoBagEquips(other, item) then
								return
							end
						end
					end
				end
			end
		end

		keepItem = true
	end)

	if keepItem then
		return false
	end
	return true
end

_G.Mod_AutoEquipBetterItems = function()
	pcall(function()
		if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.id and _G.PlayerPrefs then
			_G.PlayerPrefs.SetString(tostring(_G.RoleManager.me.id), "noFirst")
			_G.PlayerPrefs.Save()
		end

		if AutoAddAttributePoints then
			pcall(AutoAddAttributePoints)
		end

		local tipUI = _G.UIManager and _G.UIID and _G.UIID.Equip_TIpsUI and _G.UIManager.GetUiByName(_G.UIID.Equip_TIpsUI)
		if tipUI and tipUI.Btn_quickequip then
			pcall(function() tipUI:Btn_quickequip() end)
		end

		local bag = (_G.BagInfoData and _G.BagInfoData.GetTotalBag and _G.BagInfoData.GetTotalBag())
			or (_G.BagInfoData and _G.BagInfoData.TotalItems)
		if not bag then return end

		local equipsData = (_G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.data and _G.RoleManager.me.data.equipsData and _G.RoleManager.me.data.equipsData.Data)
			or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.equipsData and _G.ViewData.meData.equipsData.Data)

		-- Chọn ứng viên mặc được tốt nhất cho từng vị trí trang bị (canPos)
		local bestCandidateBySlot = {}
		for _, item in pairs(bag) do
			if item and item.id and (not item.bagGridIndex or item.bagGridIndex < 100) then
				local tblItem, tblEquip, itemId = ResolveItemAndEquipTables(item)
				if tblItem and tblEquip then
					local canPos = GetTargetSlotForEquip(item, tblItem)
					if canPos and CanPlayerWearEquipNow(item, tblItem, itemId) then
						local oldEquip = equipsData and equipsData[canPos]
						if IsBagEquipStrictlyBetterThanEquipped(item, tblItem, tblEquip, oldEquip) then
							local curBest = bestCandidateBySlot[canPos]
							if not curBest or CompareTwoBagEquips(item, curBest.item) then
								bestCandidateBySlot[canPos] = {
									item = item,
									tblItem = tblItem,
									tblEquip = tblEquip,
									itemId = itemId,
									oldEquip = oldEquip,
									canPos = canPos
								}
							end
						end
					end
				end
			end
		end

		for canPos, entry in pairs(bestCandidateBySlot) do
			local item = entry.item
			local oldEquip = entry.oldEquip
			local iName = tostring((entry.tblItem and entry.tblItem.name) or item.name or item.id)

			local isNeedTransfer = false
			if oldEquip and ((tonumber(oldEquip.intensify or 0) or 0) > 0 or (tonumber(oldEquip.additional or 0) or 0) > 0) then
				isNeedTransfer = true
				if _G.MeEquipController and _G.MeEquipController.IsCanTransfer then
					pcall(function()
						local okTrans = _G.MeEquipController.IsCanTransfer(oldEquip, item, canPos)
						if okTrans ~= nil then isNeedTransfer = okTrans end
					end)
				end
			end

			if isNeedTransfer and oldEquip and _G.NetManager and _G.EquipMessage then
				local intensifyMaxLevel, addMaxLevel = 30, 15
				pcall(function()
					if _G.MeEquipController and _G.MeEquipController.GetEquipIntensifyAndAddMaxLevel then
						intensifyMaxLevel, addMaxLevel = _G.MeEquipController.GetEquipIntensifyAndAddMaxLevel(item)
					end
				end)
				Log(string.format("[Trang Bị] : Kế thừa cường hóa (%s +%d -> %s) & Mặc lên người (Slot %d)!",
					tostring((oldEquip.tblItem and oldEquip.tblItem.name) or oldEquip.name or "Đồ cũ"),
					tonumber(oldEquip.intensify or 0) or 0, iName, canPos), true)
				_G.NetManager.Send(_G.EquipMessage.ReqEquipTransfer, {
					equipId = item.id,
					traEquipId = oldEquip.id,
					type = { 1, 2, 3 },
					maxIntensify = intensifyMaxLevel or 30,
					maxAdditional = addMaxLevel or 15
				})
				_G.NetManager.Send(_G.EquipMessage.ReqPutOnTheEquip, {
					position = canPos,
					equipId = item.id
				})
			else
				Log(string.format("[Trang Bị] : Mặc trang bị tốt hơn [%s] vào Slot %d!", iName, canPos), true)
				if _G.NetManager and _G.EquipMessage and _G.EquipMessage.ReqPutOnTheEquip then
					_G.NetManager.Send(_G.EquipMessage.ReqPutOnTheEquip, {
						position = canPos,
						equipId = item.id
					})
				end
				if _G.BagInfoController and _G.BagInfoController.UseItemReq then
					pcall(function() _G.BagInfoController.UseItemReq(1, item.id, nil, entry.itemId) end)
				end
			end

			if _G.RoleEquipUtility and _G.RoleEquipUtility.OnWearEquip then
				pcall(function() _G.RoleEquipUtility.OnWearEquip(item) end)
			end
			SaveOutput()
		end

		-- Xác nhận đóng popup Kế thừa cường hóa nếu đang hiện
		local transferUI = _G.UIManager and _G.UIID and _G.UIID.Equip_ZhuanyiFastUI and _G.UIManager.GetUiByName(_G.UIID.Equip_ZhuanyiFastUI)
		if transferUI then
			pcall(function()
				if transferUI.btn_confirmOnClick and transferUI.btn_confirm then
					transferUI:btn_confirmOnClick(transferUI.btn_confirm)
				end
				if _G.UIManager and _G.UIID and _G.UIID.Equip_ZhuanyiFastUI and _G.UIManager.IsVisible(_G.UIID.Equip_ZhuanyiFastUI) then
					_G.UIManager.Hide(_G.UIID.Equip_ZhuanyiFastUI)
				end
			end)
		end
	end)
end
AutoEquipBetterItems = _G.Mod_AutoEquipBetterItems
_G.AutoEquipBetterItems = _G.Mod_AutoEquipBetterItems

-- Chu trình Cường Hóa Đều bằng Timer (Không bao giờ bị ngắt hay kẹt biến khi chuyển cảnh 2101000 <-> Bãi Farm)
-- =========================================================================
-- [MOD FEATURE]: CƯỜNG HÓA ĐỀU TRANG BỊ CHÀY CỐI TỚI +30 (KHÔNG NGẮT KHI RỚT CẤP)
-- Mô tả:
--   - Chỉ lọc các trang bị chuẩn dùng Đá Chúc Phúc (6000091) / Đá Linh Hồn (6000101),
--     loại bỏ Cánh (subType 20), Dây Chuyền (18), Nhẫn (19), Bông Tai (26), Thú Cưỡi/Thủ Hộ (21, 22).
--   - Loại bỏ giới hạn số lần đập cùng cấp (attemptTracker): Khi đập từ +15 lên +16 bị xịt
--     rớt 2 cấp về +13, bot vẫn tiếp tục giã liên tục cho tới khi đạt mốc chỉ định (+30)
--     hoặc hết sạch đá/vàng trong túi.
-- =========================================================================
_G.GetEquippedItemsForEnhance = function()
	local equips = {}
	local equipsData = nil
	pcall(function()
		if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.data and _G.RoleManager.me.data.equipsData then
			equipsData = _G.RoleManager.me.data.equipsData.Data
		end
		if not equipsData and _G.ViewData and _G.ViewData.meData and _G.ViewData.meData.equipsData then
			equipsData = _G.ViewData.meData.equipsData.Data
		end
	end)
	if not equipsData then return equips end

	local excludedSubTypes = {
		[18] = true, -- Dây chuyền (Necklace)
		[19] = true, -- Nhẫn (Ring)
		[20] = true, -- Cánh (Wing)
		[21] = true, -- Thủ hộ / Pet (Guards)
		[22] = true, -- Thú cưỡi (Mount)
		[26] = true, -- Bông tai (Earrings)
	}

	for slot, eq in pairs(equipsData) do
		if eq and eq.id and (eq.tblEquip or eq.tblItem) then
			local subType = tonumber((eq.tblItem and eq.tblItem.subType) or (eq.tblEquip and eq.tblEquip.subType) or 0) or 0
			if not excludedSubTypes[subType] then
				local intensifyCfg = nil
				local nextCfg = nil
				local curLvl = tonumber(eq.intensify or 0) or 0
				pcall(function()
					if _G.MeEquipController and _G.MeEquipController.GetEquipIntensifyCfgByEquipData then
						intensifyCfg = _G.MeEquipController.GetEquipIntensifyCfgByEquipData(eq)
					end
					if _G.MeEquipController and _G.MeEquipController.GetEquipIntensifyCfg then
						local itemId = tonumber(eq.itemId or (eq.tblItem and eq.tblItem.id) or 0) or 0
						nextCfg = _G.MeEquipController.GetEquipIntensifyCfg(itemId, curLvl + 1)
						if not nextCfg and subType > 0 then
							nextCfg = _G.MeEquipController.GetEquipIntensifyCfg(subType, curLvl + 1)
						end
					end
				end)
				local costStr = tostring((intensifyCfg and intensifyCfg.cost) or "")
				local usesBlessOrSoul = (string.find(costStr, "6000091", 1, true) ~= nil)
					or (string.find(costStr, "6000101", 1, true) ~= nil)
				if intensifyCfg and usesBlessOrSoul and (nextCfg ~= nil or curLvl < 30) then
					local itemName = (eq.tblItem and eq.tblItem.name) or ("Slot_" .. tostring(slot))
					table.insert(equips, {
						slot = tonumber(slot) or 0,
						item = eq,
						id = eq.id,
						name = itemName,
						intensify = curLvl,
						cfg = intensifyCfg
					})
				end
			end
		end
	end

	table.sort(equips, function(a, b) return a.slot < b.slot end)
	return equips
end

_G.Mod_EnhanceLoopTimer = _G.Mod_EnhanceLoopTimer or nil
_G.AutoEvenEnhanceStartTime = _G.AutoEvenEnhanceStartTime or 0

_G.Mod_TimerEnhanceEquipments = function(maxTargetLvl, onFinished)
	local nowTime = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
	if _G.AutoEvenEnhanceRunning then
		if (nowTime - (_G.AutoEvenEnhanceStartTime or 0)) < 12.0 and _G.Mod_EnhanceLoopTimer ~= nil then
			return
		end
		-- Watchdog tự động mở khóa nếu phiên trước bị kẹt quá 12s
		if _G.Mod_EnhanceLoopTimer then
			pcall(function() Timer.Stop(_G.Mod_EnhanceLoopTimer) end)
			_G.Mod_EnhanceLoopTimer = nil
		end
		_G.AutoEvenEnhanceRunning = false
	end

	if not _G.Bot_Running or _G.Bot_PauseTask then
		if onFinished then pcall(onFinished) end
		return
	end

	_G.AutoEvenEnhanceRunning = true
	_G.AutoEvenEnhanceStartTime = nowTime
	maxTargetLvl = tonumber(maxTargetLvl) or 30

	local targetTiers = { 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 30 }
	local activeTiers = {}
	for _, t in ipairs(targetTiers) do
		if t <= maxTargetLvl then
			table.insert(activeTiers, t)
		end
	end
	if #activeTiers == 0 or activeTiers[#activeTiers] < maxTargetLvl then
		table.insert(activeTiers, maxTargetLvl)
	end

	local curTierIdx = 1
	local totalEnhancedCount = 0
	local tickCount = 0
	local maxTotalTicks = 1000
	local skippedIds = {}

	local function StopEnhanceLoop()
		if _G.Mod_EnhanceLoopTimer then
			pcall(function() Timer.Stop(_G.Mod_EnhanceLoopTimer) end)
			_G.Mod_EnhanceLoopTimer = nil
		end
		_G.AutoEvenEnhanceRunning = false
		_G.Bot_HasDoneEnhanceAfterSnowBug = true
		if totalEnhancedCount > 0 then
			Log(string.format(">>> [CƯỜNG HÓA ĐỀU]: Đã đập đồ %d lần (Mục tiêu: +%d)! <<<", totalEnhancedCount, maxTargetLvl), true)
			SaveOutput()
		end
		if onFinished then pcall(onFinished) end
	end

	if _G.Mod_EnhanceLoopTimer then
		pcall(function() Timer.Stop(_G.Mod_EnhanceLoopTimer) end)
		_G.Mod_EnhanceLoopTimer = nil
	end

	_G.Mod_EnhanceLoopTimer = Timer.StartLoop(0.18, -1, function()
		pcall(function()
			tickCount = tickCount + 1
			_G.AutoEvenEnhanceStartTime = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()

			if not _G.Bot_Running or _G.Bot_PauseTask or tickCount > maxTotalTicks or curTierIdx > #activeTiers then
				StopEnhanceLoop()
				return
			end

			local equips = _G.GetEquippedItemsForEnhance and _G.GetEquippedItemsForEnhance()
			if not equips or #equips == 0 then
				StopEnhanceLoop()
				return
			end

			while curTierIdx <= #activeTiers do
				local currentTier = activeTiers[curTierIdx]
				local candidate = nil
				local minLvl = 999

				for _, eq in ipairs(equips) do
					local curLvl = tonumber(eq.item.intensify or 0) or 0
					if curLvl < currentTier and curLvl < minLvl and not skippedIds[eq.id] then
						minLvl = curLvl
						candidate = eq
					end
				end

				if not candidate then
					local anyEnhanceableRemaining = false
					for _, eq in ipairs(equips) do
						local curLvl = tonumber(eq.item.intensify or 0) or 0
						if curLvl < maxTargetLvl and (_G.CanEnhanceItem and _G.CanEnhanceItem(eq.item)) then
							anyEnhanceableRemaining = true
							break
						end
					end
					if not anyEnhanceableRemaining then
						-- Hết nguyên liệu cho toàn bộ trang bị hoặc tất cả đã đạt maxTargetLvl -> kết thúc gọn gàng
						StopEnhanceLoop()
						return
					else
						skippedIds = {}
						curTierIdx = curTierIdx + 1
					end
				else
					local canDo = _G.CanEnhanceItem and _G.CanEnhanceItem(candidate.item)
					if not canDo then
						skippedIds[candidate.id] = true
					else
						local curLvl = tonumber(candidate.item.intensify or 0) or 0
						totalEnhancedCount = totalEnhancedCount + 1
						local curBless = (_G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId and _G.BagInfoData.GetItemTotalCountByItemId(6000091)) or 0
						local curSoul = (_G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId and _G.BagInfoData.GetItemTotalCountByItemId(6000101)) or 0
						Log(string.format("-> [ĐẬP ĐỒ]: %s (Slot %d | +%d -> +%d | Mốc +%d | Bless: %d | Soul: %d)",
							tostring(candidate.name), tonumber(candidate.slot) or 0, curLvl, curLvl + 1, currentTier, curBless, curSoul), false)
						if _G.MeEquipController and _G.MeEquipController.ReqEquipIntensify then
							_G.MeEquipController.ReqEquipIntensify(candidate.id)
						elseif _G.networkRequest and _G.networkRequest.ReqEquipIntensify then
							_G.networkRequest.ReqEquipIntensify(candidate.id)
						elseif _G.NetManager and _G.EquipMessage and _G.EquipMessage.ReqEquipIntensify then
							_G.NetManager.Send(_G.EquipMessage.ReqEquipIntensify, { equipId = candidate.id })
						end
						return
					end
				end
			end

			StopEnhanceLoop()
		end)
	end)
end
AutoEvenEnhanceEquipments = _G.Mod_TimerEnhanceEquipments
_G.AutoEvenEnhanceEquipments = _G.Mod_TimerEnhanceEquipments

-- Chu trình Nâng Cấp Định Kỳ 30s (Phối hợp chuẩn thứ tự: Cộng điểm -> Chờ 1.5s -> Mặc đồ & Kế thừa -> Chờ 3.5s -> Thu hồi rác -> Đập đồ +30)
_G.LastPeriodicUpgradeCycleTime = _G.LastPeriodicUpgradeCycleTime or 0

_G.RunPeriodicUpgradeCycle = function()
	if not _G.Bot_Running or _G.Bot_PauseTask then return end

	local pMe = _G.RoleManager and _G.RoleManager.me
	local curLvl = tonumber((pMe and pMe.level) or (pMe and pMe.data and pMe.data.level) or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.level) or 1) or 1
	if curLvl < 20 then return end

	_G.LastPeriodicUpgradeCycleTime = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()

	pcall(function()
		Log(string.format("[Chu Kỳ Nâng Cấp 30s - Lv %d]: Cộng điểm, Mặc đồ xịn, Thu hồi rác & Cường hóa (+30)!", curLvl), true)

		-- 1. Nhận thư và quà đính kèm định kỳ
		pcall(function()
			if _G.NetManager and _G.MailMessage then
				if _G.MailMessage.ReqGetMailList then _G.NetManager.Send(_G.MailMessage.ReqGetMailList, {}) end
				if _G.MailMessage.ReqGetMailItems then _G.NetManager.Send(_G.MailMessage.ReqGetMailItems) end
			end
			if _G.MailController and _G.MailController.ReqGetMailItems then
				_G.MailController.ReqGetMailItems()
			end
		end)

		-- 2. Mua 100 Đá Chúc Phúc Shop Vàng & Gói Quà KC Khóa & Bình Máu/Mana & Buff EXP
		if _G.AutoBuyDailyBlessStonesFromShop then _G.AutoBuyDailyBlessStonesFromShop() end
		if AutoBuyDailyDiamondGiftPacks then AutoBuyDailyDiamondGiftPacks() end
		if AutoBuyPotionsIfLow then AutoBuyPotionsIfLow(50, 200) end
		if AutoUsePrivilegeCard then AutoUsePrivilegeCard() end
		if AutoUseExpMedicine then AutoUseExpMedicine() end
		if AutoBuyNewServerExpMedicinePack then AutoBuyNewServerExpMedicinePack() end
		if AutoClaimNewServerRewards then AutoClaimNewServerRewards() end
		if AutoClaimDailyWelfare then AutoClaimDailyWelfare() end
		if AutoClaimCommunityWelfareAndMail then AutoClaimCommunityWelfareAndMail() end

		-- 3. Phân bổ điểm tiềm năng ngay lập tức (0s) và quét mặc đồ đợt 1
		if AutoAddAttributePoints then AutoAddAttributePoints() end
		if _G.Mod_AutoEquipBetterItems then _G.Mod_AutoEquipBetterItems() end
		if DismissBlockers then DismissBlockers() end

		-- 4. Sau 1.5s (khi Server đã đồng bộ điểm tiềm năng mới): Quét mặc đồ xịn & kế thừa cường hóa đợt 2
		Timer.Start(1.5, function()
			if not _G.Bot_Running or _G.Bot_PauseTask then return end
			pcall(function()
				if AutoAddAttributePoints then AutoAddAttributePoints() end
				if _G.Mod_AutoEquipBetterItems then _G.Mod_AutoEquipBetterItems() end
				if DismissBlockers then DismissBlockers() end
			end)
		end)

		-- 5. Sau 5.0s (khi Server đã hoàn tất mặc đồ mới & kế thừa cường hóa): Thu hồi đồ cũ/rác & Đập đồ đều lên +30
		Timer.Start(5.0, function()
			if not _G.Bot_Running or _G.Bot_PauseTask then return end
			pcall(function()
				if DismissBlockers then DismissBlockers() end
				if _G.Mod_AutoEquipBetterItems then _G.Mod_AutoEquipBetterItems() end

				local meNow = _G.RoleManager and _G.RoleManager.me
				local lvlNow = tonumber((meNow and meNow.level) or (meNow and meNow.data and meNow.data.level) or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.level) or 1) or 1
				if lvlNow >= 50 and AutoRecycleBagItems then
					AutoRecycleBagItems()
				end

				if SolveBranchAndRewardsTasks then
					SolveBranchAndRewardsTasks()
				end

				if _G.Mod_TimerEnhanceEquipments then
					_G.Mod_TimerEnhanceEquipments(30)
				end

				Timer.Start(2.5, function()
					if not _G.Bot_Running or _G.Bot_PauseTask then return end
					pcall(function()
						local m2 = _G.RoleManager and _G.RoleManager.me
						local l2 = tonumber((m2 and m2.level) or (m2 and m2.data and m2.data.level) or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.level) or 1) or 1
						if l2 >= 60 and AutoEvenUpgradeGems then
							-- Reset cờ nếu bị kẹt từ lần chuyển map trước
							local nowT = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
							if _G.AutoEvenUpgradeGemsRunning and (nowT - (_G.AutoEvenUpgradeGemsStartTime or 0)) > 15.0 then
								_G.AutoEvenUpgradeGemsRunning = false
							end
							if not _G.AutoEvenUpgradeGemsRunning then
								_G.AutoEvenUpgradeGemsStartTime = nowT
								AutoEvenUpgradeGems(30)
							end
						end
					end)
				end)

				if DismissBlockers then DismissBlockers() end
			end)
		end)
	end)
end
RunPeriodicUpgradeCycle = _G.RunPeriodicUpgradeCycle
-- =========================================================================
-- [MOD FEATURE]: TỰ ĐỘNG MUA & HỌC ĐÁ KỸ NĂNG TẠI LV 80 VÀ LV 150
-- Mô tả:
--   1. Tại Lv >= 80:
--      - "Thuật Thiên Thạch Lv.1" (Kỹ năng đơn mục tiêu đánh Boss Nữ Hoàng: goodId=20423, itemId=4000610/4000110, skillId=12070101).
--      - "Thuật Hồn Thủ Hộ Lv.1" (goodId=20432, itemId=4000690/4000190, skillId=12150101).
--   2. Tại Lv >= 150:
--      - "Thuật Hồn Thủ Hộ Lv.2" (goodId=204211, itemId=4001690/4001190, skillId=12150102 - yêu cầu đã học Lv.1 12150101).
--      - "Thuật Thiên Thạch Lv.2" (goodId=204091, itemId=4001610/4001110, skillId=12070102 - yêu cầu đã học Lv.1 12070101).
--      - "Thuật Sóng Rồng Đen Lv.2" (goodId=204161, itemId=4001660/4001160, skillId=12120102 - yêu cầu đã học Lv.1 12120101).
-- =========================================================================
local function ActivateSkillInQiJiHelper(skillId)
	pcall(function()
		if _G.QiJiHelperData and skillId and skillId > 0 then
			if _G.QiJiHelperData.AddSelfSelectSkill then _G.QiJiHelperData.AddSelfSelectSkill(skillId) end
			if _G.QiJiHelperData.AddAutoSkill then _G.QiJiHelperData.AddAutoSkill(skillId, true) end
		end
	end)
end

local function HasLearnedTargetSkill(targetSkillId, targetGroupId, targetLevel)
	local learned = false
	pcall(function()
		local me = _G.RoleManager and _G.RoleManager.me
		local skills = me and me.skills
		if not skills then return end
		local fullGroupId = math.floor((tonumber(targetSkillId) or 0) / 100) * 100
		local prefix6 = math.floor((tonumber(targetSkillId) or 0) / 100)

		-- Kiểm tra trực tiếp theo key fullGroupId (cấu trúc chuẩn RoleManager.me.skills[groupId].sid)
		if fullGroupId > 0 and skills[fullGroupId] then
			local entry = skills[fullGroupId]
			local curSid = tonumber(entry.sid or entry.id or entry.skillId or (entry.cfg and entry.cfg.id) or 0) or 0
			if curSid >= targetSkillId then
				learned = true
				ActivateSkillInQiJiHelper(curSid)
				return
			end
		end

		for k, v in pairs(skills) do
			if type(v) == "table" then
				local sId = tonumber(v.sid or v.id or v.skillId or (v.cfg and v.cfg.id) or 0) or 0
				local gId = tonumber((v.cfg and v.cfg.groupId) or v.groupId or math.floor(sId / 10000)) or 0
				local sLv = tonumber(v.level or (v.cfg and v.cfg.level) or (sId % 100)) or 0
				if sId == targetSkillId
					or (math.floor(sId / 100) == prefix6 and sId >= targetSkillId)
					or ((gId == targetGroupId or gId == fullGroupId) and sLv >= targetLevel) then
					learned = true
					ActivateSkillInQiJiHelper(sId > 0 and sId or targetSkillId)
					break
				end
			elseif tonumber(v) == targetSkillId or tonumber(k) == targetSkillId then
				learned = true
				ActivateSkillInQiJiHelper(targetSkillId)
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

local function UseSkillStoneFromBag(item, skillLabel, targetSkillId)
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
	if targetSkillId and Timer and Timer.Start then
		Timer.Start(0.8, function()
			ActivateSkillInQiJiHelper(targetSkillId)
		end)
	end
	return true
end

local function BuyAndUseSkillStone(goodId, boundItemId, unboundItemId, skillLabel, onUsedFlagKey, targetSkillId)
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
			if stone and UseSkillStoneFromBag(stone, skillLabel, targetSkillId) and onUsedFlagKey then
				_G[onUsedFlagKey] = true
			end
		end)
	end
end

local function RegisterLearnedSkillToAutoFight(targetSkillId)
	if not targetSkillId or targetSkillId <= 0 then return end
	pcall(function()
		if _G.QiJiHelperData then
			if _G.QiJiHelperData.AddSelfSelectSkill then
				_G.QiJiHelperData.AddSelfSelectSkill(targetSkillId)
			end
			if _G.QiJiHelperData.AddAutoSkill then
				_G.QiJiHelperData.AddAutoSkill(targetSkillId)
			end
		end
	end)
end

local function EnsureSingleSkillLearned(cfg)
	if _G[cfg.doneKey] then return end
	if HasLearnedTargetSkill(cfg.skillId, cfg.groupId, cfg.level) then
		RegisterLearnedSkillToAutoFight(cfg.skillId)
		_G[cfg.doneKey] = true
		return
	end
	-- Nếu kỹ năng Lv.2 yêu cầu phải học Lv.1 trước:
	if cfg.prereqSkillId and not HasLearnedTargetSkill(cfg.prereqSkillId, cfg.groupId, 1) then
		local stoneLv1 = FindSkillStoneInBag(cfg.prereqBoundItemId, cfg.prereqUnboundItemId)
		if stoneLv1 then
			UseSkillStoneFromBag(stoneLv1, cfg.prereqLabel, cfg.prereqSkillId)
		elseif (_G[cfg.prereqBuyCountKey] or 0) < 3 then
			_G[cfg.prereqBuyCountKey] = (_G[cfg.prereqBuyCountKey] or 0) + 1
			BuyAndUseSkillStone(cfg.prereqGoodId, cfg.prereqBoundItemId, cfg.prereqUnboundItemId, cfg.prereqLabel, nil, cfg.prereqSkillId)
		end
		return
	end

	local stone = FindSkillStoneInBag(cfg.boundItemId, cfg.unboundItemId)
	if stone then
		UseSkillStoneFromBag(stone, cfg.label, cfg.skillId)
		_G[cfg.usedKey] = true
	elseif _G[cfg.usedKey] and HasLearnedTargetSkill(cfg.skillId, cfg.groupId, cfg.level) then
		RegisterLearnedSkillToAutoFight(cfg.skillId)
		_G[cfg.doneKey] = true
	elseif (_G[cfg.buyCountKey] or 0) < 3 then
		_G[cfg.buyCountKey] = (_G[cfg.buyCountKey] or 0) + 1
		BuyAndUseSkillStone(cfg.goodId, cfg.boundItemId, cfg.unboundItemId, cfg.label, cfg.usedKey, cfg.skillId)
	end
end

local function ResetAutoLearnSkillFlags()
	_G.Bot_HasLearnedMeteor80 = false
	_G.Bot_UsedMeteorStone80 = false
	_G.Bot_BuyMeteorCount80 = 0
	_G.Bot_HasLearnedSoulBarrier100 = false
	_G.Bot_UsedSoulBarrierStone = false
	_G.Bot_BuySoulBarrierCount = 0
	_G.Bot_HasLearnedSoulBarrierLv2_150 = false
	_G.Bot_UsedSoulBarrierLv2Stone = false
	_G.Bot_BuySoulBarrierLv2Count = 0
	_G.Bot_HasLearnedMeteorLv2_150 = false
	_G.Bot_UsedMeteorLv2Stone = false
	_G.Bot_BuyMeteorLv2Count = 0
	_G.Bot_HasLearnedEvilSpiritLv2_150 = false
	_G.Bot_UsedEvilSpiritLv2Stone = false
	_G.Bot_BuyEvilSpiritLv2Count = 0
	_G.Bot_BuyEvilSpiritLv1Count = 0
end
_G.ResetAutoLearnSkillFlags = ResetAutoLearnSkillFlags

local function CheckAndAutoBuyLearnSkills(curLvl)
	if not _G.Bot_Running or _G.Bot_PauseTask then return end
	curLvl = tonumber(curLvl) or 1
	if curLvl < 80 then return end

	local curRoleKey = tostring((_G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.id) or "") .. "_" .. tostring(_G.CurrentAccountIndex or 0)
	if _G.Mod_LastSkillCheckRoleKey ~= curRoleKey then
		_G.Mod_LastSkillCheckRoleKey = curRoleKey
		ResetAutoLearnSkillFlags()
	end

	local nowTime = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
	if _G.Bot_LastSkillStoneBuyUseTime and (nowTime - _G.Bot_LastSkillStoneBuyUseTime) < 2.0 then
		return
	end
	_G.Bot_LastSkillStoneBuyUseTime = nowTime

	-- 1. Tại Lv >= 80: Kiểm tra & học "Thuật Thiên Thạch Lv.1" (Đánh đơn mục tiêu Nữ Hoàng) và "Thuật Hồn Thủ Hộ Lv.1"
	if curLvl >= 80 then
		EnsureSingleSkillLearned({
			skillId = 12070101,
			groupId = 1207,
			level = 1,
			goodId = 20423,
			boundItemId = 4000610,
			unboundItemId = 4000110,
			label = "Thuật Thiên Thạch Lv.1 (Đơn Mục Tiêu)",
			doneKey = "Bot_HasLearnedMeteor80",
			usedKey = "Bot_UsedMeteorStone80",
			buyCountKey = "Bot_BuyMeteorCount80",
		})
		EnsureSingleSkillLearned({
			skillId = 12150101,
			groupId = 1215,
			level = 1,
			goodId = 20432,
			boundItemId = 4000690,
			unboundItemId = 4000190,
			label = "Thuật Hồn Thủ Hộ Lv.1 (Lv80)",
			doneKey = "Bot_HasLearnedSoulBarrier100",
			usedKey = "Bot_UsedSoulBarrierStone",
			buyCountKey = "Bot_BuySoulBarrierCount",
		})
	end

	-- 2. Tại Lv >= 150: Kiểm tra & học "Thuật Hồn Thủ Hộ Lv.2", "Thuật Thiên Thạch Lv.2" và "Thuật Sóng Rồng Đen Lv.2"
	if curLvl >= 150 then
		EnsureSingleSkillLearned({
			skillId = 12150102,
			groupId = 1215,
			level = 2,
			goodId = 204211,
			boundItemId = 4001690,
			unboundItemId = 4001190,
			label = "Thuật Hồn Thủ Hộ Lv.2 (Lv150)",
			doneKey = "Bot_HasLearnedSoulBarrierLv2_150",
			usedKey = "Bot_UsedSoulBarrierLv2Stone",
			buyCountKey = "Bot_BuySoulBarrierLv2Count",
			prereqSkillId = 12150101,
			prereqGoodId = 20432,
			prereqBoundItemId = 4000690,
			prereqUnboundItemId = 4000190,
			prereqLabel = "Thuật Hồn Thủ Hộ Lv.1",
			prereqBuyCountKey = "Bot_BuySoulBarrierCount",
		})
		EnsureSingleSkillLearned({
			skillId = 12070102,
			groupId = 1207,
			level = 2,
			goodId = 204091,
			boundItemId = 4001610,
			unboundItemId = 4001110,
			label = "Thuật Thiên Thạch Lv.2 (Lv150)",
			doneKey = "Bot_HasLearnedMeteorLv2_150",
			usedKey = "Bot_UsedMeteorLv2Stone",
			buyCountKey = "Bot_BuyMeteorLv2Count",
			prereqSkillId = 12070101,
			prereqGoodId = 20423,
			prereqBoundItemId = 4000610,
			prereqUnboundItemId = 4000110,
			prereqLabel = "Thuật Thiên Thạch Lv.1",
			prereqBuyCountKey = "Bot_BuyMeteorCount80",
		})
		EnsureSingleSkillLearned({
			skillId = 12120102,
			groupId = 1212,
			level = 2,
			goodId = 204161,
			boundItemId = 4001660,
			unboundItemId = 4001160,
			label = "Thuật Sóng Rồng Đen Lv.2 (Lv150)",
			doneKey = "Bot_HasLearnedEvilSpiritLv2_150",
			usedKey = "Bot_UsedEvilSpiritLv2Stone",
			buyCountKey = "Bot_BuyEvilSpiritLv2Count",
			prereqSkillId = 12120101,
			prereqGoodId = 20428,
			prereqBoundItemId = 4000660,
			prereqUnboundItemId = 4000160,
			prereqLabel = "Thuật Sóng Rồng Đen Lv.1",
			prereqBuyCountKey = "Bot_BuyEvilSpiritLv1Count",
		})
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
-- [MOD FEATURE]: CHỌN BÃI FARM QUÁI NGON NHẤT CHUẨN THEO CẢ LEVEL MỞ MAP & PHÒNG THỦ
-- Mô tả:
--   1. Lấy cấp độ nhân vật chính xác tuyệt đối từ mọi nguồn (ViewData.meData.level, RoleManager.me, MainRole).
--   2. Kiểm tra khóa 2 lớp điều kiện vào bản đồ (CanPlayerEnterMap):
--      - Cấp độ nhân vật >= Cấp độ mở map chuẩn trong cfg_Map_map (Devias Lv20, Dungeon Lv40, Lost Tower 1 Lv60,
--        Lost Tower 2..7 Lv80, Atlantis Lv100, Tarkan Lv150, Aida Lv200, Icarus Lv250, Kanturu Lv300/350).
--      - Kiểm tra trực tiếp ConditionManager.Check4D(mapCfg.enterCondition) để không bao giờ bị báo đỏ
--        "Chưa đạt điều kiện vào bản đồ mục tiêu".
--   3. Quét toàn bộ các bãi quái thuộc những bản đồ ĐÃ ĐỦ CẤP ĐỘ VÀO, lọc các bãi mà Phòng thủ (myDef)
--      đáp ứng đủ (myDef >= defenseReq) và chọn ra bãi có EXP / Cấp độ quái cao nhất!
--   4. Khi thoát phó bản Nữ Hoàng (2101000), tách nhịp gửi ReqExitInstance() trước và đợi thoát khỏi
--      phó bản mới bắn lệnh ReqCallFlag/ReqTransmit về bãi farm.
-- =========================================================================
local MAP_MIN_LEVEL_REQ = {
	[1001]   = 1,   -- Lorencia
	[1004]   = 1,   -- Noria
	[1003]   = 20,  -- Devias
	[100201] = 40,  -- Dungeon 1
	[100202] = 40,  -- Dungeon 2
	[100203] = 40,  -- Dungeon 3
	[100501] = 60,  -- Lost Tower 1
	[100502] = 80,  -- Lost Tower 2
	[100503] = 80,  -- Lost Tower 3
	[100504] = 80,  -- Lost Tower 4
	[100505] = 80,  -- Lost Tower 5
	[100506] = 80,  -- Lost Tower 6
	[100507] = 80,  -- Lost Tower 7
	[1008]   = 100, -- Atlantis
	[100801] = 100, -- Atlantis VIP
	[1009]   = 150, -- Tarkan
	[100901] = 150, -- Tarkan VIP
	[1034]   = 200, -- Aida
	[103401] = 200, -- Aida VIP
	[1011]   = 250, -- Icarus 1
	[101101] = 250, -- Icarus 2
	[101102] = 250, -- Icarus VIP
	[1038]   = 300, -- Phế Tích Kanturu 1
	[103801] = 300, -- Phế Tích Kanturu 2
	[1039]   = 350, -- Di Chỉ Kanturu 1
	[103901] = 350, -- Di Chỉ Kanturu 2
}

local function GetAccuratePlayerLevel()
	local maxLvl = 0
	pcall(function()
		if _G.ViewData and _G.ViewData.meData and _G.ViewData.meData.level then
			local l = tonumber(_G.ViewData.meData.level) or 0
			if l > maxLvl then maxLvl = l end
		end
		local me = _G.RoleManager and _G.RoleManager.me
		if me then
			local l1 = tonumber(me.level) or 0
			local l2 = tonumber(me.data and me.data.level) or 0
			if l1 > maxLvl then maxLvl = l1 end
			if l2 > maxLvl then maxLvl = l2 end
		end
		if CS and CS.Qui and CS.Qui.MainRole and CS.Qui.MainRole.Instance then
			local l3 = tonumber(CS.Qui.MainRole.Instance.Level) or 0
			if l3 > maxLvl then maxLvl = l3 end
		end
	end)
	if maxLvl <= 0 then maxLvl = 1 end
	return maxLvl
end
_G.GetAccuratePlayerLevel = GetAccuratePlayerLevel

local function CanPlayerEnterMap(mapId, myLvl)
	mapId = tonumber(mapId) or 0
	if mapId <= 0 or mapId >= 1000000 then return false end
	myLvl = tonumber(myLvl) or GetAccuratePlayerLevel()
	local minReq = MAP_MIN_LEVEL_REQ[mapId]
	if minReq and myLvl < minReq then
		return false
	end
	local canEnter = true
	pcall(function()
		local mapCfg = nil
		if _G.ClientTable and _G.ClientTable.cfg_Map_mapManager and _G.ClientTable.cfg_Map_mapManager.TryGetValue then
			mapCfg = _G.ClientTable.cfg_Map_mapManager:TryGetValue(mapId)
		end
		if not mapCfg and _G.ConfigManager and _G.ConfigManager.GetConfig then
			mapCfg = _G.ConfigManager.GetConfig("cfg_Map_map", mapId, "id")
		end
		if mapCfg and mapCfg.enterCondition and type(mapCfg.enterCondition) == "table" then
			for _, group in ipairs(mapCfg.enterCondition) do
				if type(group) == "table" then
					for _, cond in ipairs(group) do
						if type(cond) == "table" and tonumber(cond[1]) == 101 then
							local reqLv = tonumber(cond[2]) or 0
							if myLvl < reqLv then
								canEnter = false
								return
							end
						end
					end
				end
			end
			if _G.ConditionManager and _G.ConditionManager.Check4D then
				if not _G.ConditionManager.Check4D(mapCfg.enterCondition) then
					canEnter = false
					return
				end
			end
		end
	end)
	return canEnter
end
_G.CanPlayerEnterMap = CanPlayerEnterMap

-- =========================================================================
-- [MOD FEATURE]: BẢNG TỌA ĐỘ BÃI QUÁI CHUẨN CFG_MAP_MINIMAP & XOAY VÒNG ĐA BÃI/ĐA KÊNH (LV 145+)
-- Mô tả:
--   1. Cấu hình % Vượt Thủ (`_G.Mod_OverDefPct`, mặc định 10%): Từ Lv 145 trở đi, cộng thêm % Vượt Thủ
--      vào phòng thủ nhân vật (`effectiveDef = math.floor(myDef * (1 + overDefPct / 100))`) trước khi tìm bãi.
--   2. Tọa độ bãi quái:
--      - Giữ nguyên các bãi đôi hardcode ở cấp thấp (Dungeon 1, Lost Tower 1, Lost Tower 2, Atlantis Lv130).
--      - Atlantis Lv140 & Lv145 (1008) và toàn bộ 6 mức quái Tarkan Lv150..Lv195 (1009): Dùng 100% danh sách
--        tâm bãi chuẩn từ `cfg_Map_minimap.lua` (5-8 bãi/mức × 3 kênh = 15-24 vị trí).
--   3. Chống trùng bãi từ Lv 145 -> Lv 200:
--      - Khi dịch chuyển đến vị trí đầu tiên của danh sách (Kênh 1 - Bãi 1), quét người chơi xung quanh qua
--        `_G.RoleManager.GetRolesByType(1)` (chuẩn Auto PK client).
--      - Nếu phát hiện có người chơi khác đứng trong phạm vi <= 2 ô, tự động dịch chuyển sang vị trí tiếp theo
--        (xoay vòng qua các bãi và chuyển kênh 1 -> 2 -> 3 qua `ReqCallFlag` / `ReqChangeLine`).
--      - Nếu đã đi hết toàn bộ 15-18 vị trí của mức quái đó mà đều có người, chấp nhận đứng yên farm tại vị trí cuối.
-- =========================================================================
local function GetConfiguredOverDefPct()
	local pct = tonumber(_G.Mod_OverDefPct)
	if pct == nil then
		pcall(function()
			pct = tonumber(CS.UnityEngine.PlayerPrefs.GetInt("Mod_Farm_OverDefPct", 10))
		end)
	end
	pct = tonumber(pct) or 10
	if pct < 0 then pct = 0 end
	if pct > 100 then pct = 100 end
	_G.Mod_OverDefPct = pct
	return pct
end
_G.GetConfiguredOverDefPct = GetConfiguredOverDefPct

local function GetEffectiveMonsterDefense(myLvl)
	local rawDef = (GetPlayerMonsterDefense and GetPlayerMonsterDefense()) or 0
	myLvl = tonumber(myLvl) or GetAccuratePlayerLevel()
	if myLvl >= 145 then
		local pct = GetConfiguredOverDefPct()
		return math.floor(rawDef * (1 + pct / 100)), rawDef, pct
	end
	return rawDef, rawDef, 0
end
_G.GetEffectiveMonsterDefense = GetEffectiveMonsterDefense

local ALL_PROGRESSION_FARM_SPOTS = {
	-- 10. Di Chỉ Kanturu 1 (1039 - Yêu cầu Lv 350)
	{ mapId = 1039,   minLvl = 350, x = 148, y = 145, name = "Di Chỉ Kanturu (Quái Lv395 EXP x4.0: 148#145)", monsterLvl = 395, defenseReq = 3156, expScore = 395 },
	{ mapId = 1039,   minLvl = 350, x = 173, y = 129, name = "Di Chỉ Kanturu (Quái Lv390 EXP x3.0: 173#129)", monsterLvl = 390, defenseReq = 2869, expScore = 390 },
	{ mapId = 1039,   minLvl = 350, x = 155, y = 115, name = "Di Chỉ Kanturu (Quái Lv380 EXP x2.5: 155#115)", monsterLvl = 380, defenseReq = 2582, expScore = 380 },
	{ mapId = 1039,   minLvl = 350, x = 135, y = 98,  name = "Di Chỉ Kanturu (Quái Lv370 EXP x2.0: 135#98)",  monsterLvl = 370, defenseReq = 2295, expScore = 370 },
	{ mapId = 1039,   minLvl = 350, x = 122, y = 79,  name = "Di Chỉ Kanturu (Quái Lv360 EXP x1.5: 122#79)",  monsterLvl = 360, defenseReq = 2008, expScore = 360 },
	{ mapId = 1039,   minLvl = 350, x = 98,  y = 106, name = "Di Chỉ Kanturu (Quái Lv350 EXP x1.0: 98#106)",  monsterLvl = 350, defenseReq = 1721, expScore = 350 },

	-- 9. Phế Tích Kanturu 1 (1038 - Yêu cầu Lv 300)
	{ mapId = 1038,   minLvl = 300, x = 58,  y = 82,  name = "Phế Tích Kanturu (Quái Lv345 EXP x4.0: 58#82)",   monsterLvl = 345, defenseReq = 1721, expScore = 345 },
	{ mapId = 1038,   minLvl = 300, x = 97,  y = 66,  name = "Phế Tích Kanturu (Quái Lv340 EXP x3.0: 97#66)",   monsterLvl = 340, defenseReq = 1549, expScore = 340 },
	{ mapId = 1038,   minLvl = 300, x = 152, y = 61,  name = "Phế Tích Kanturu (Quái Lv330 EXP x2.5: 152#61)",  monsterLvl = 330, defenseReq = 1378, expScore = 330 },
	{ mapId = 1038,   minLvl = 300, x = 230, y = 106, name = "Phế Tích Kanturu (Quái Lv320 EXP x2.0: 230#106)", monsterLvl = 320, defenseReq = 1206, expScore = 320 },
	{ mapId = 1038,   minLvl = 300, x = 178, y = 178, name = "Phế Tích Kanturu (Quái Lv310 EXP x1.5: 178#178)", monsterLvl = 310, defenseReq = 1035, expScore = 310 },
	{ mapId = 1038,   minLvl = 300, x = 133, y = 224, name = "Phế Tích Kanturu (Quái Lv300 EXP x1.0: 133#224)", monsterLvl = 300, defenseReq = 863,  expScore = 300 },

	-- 8. Icarus 1 (1011 - Yêu cầu Lv 250)
	{ mapId = 1011,   minLvl = 250, x = 48,  y = 204, name = "Icarus (Quái Lv295 EXP x4.0: 48#204)", monsterLvl = 295, defenseReq = 863, expScore = 295 },
	{ mapId = 1011,   minLvl = 250, x = 42,  y = 163, name = "Icarus (Quái Lv290 EXP x3.0: 42#163)", monsterLvl = 290, defenseReq = 792, expScore = 290 },
	{ mapId = 1011,   minLvl = 250, x = 31,  y = 101, name = "Icarus (Quái Lv280 EXP x2.5: 31#101)", monsterLvl = 280, defenseReq = 721, expScore = 280 },
	{ mapId = 1011,   minLvl = 250, x = 59,  y = 69,  name = "Icarus (Quái Lv270 EXP x2.0: 59#69)",  monsterLvl = 270, defenseReq = 651, expScore = 270 },
	{ mapId = 1011,   minLvl = 250, x = 82,  y = 32,  name = "Icarus (Quái Lv260 EXP x1.5: 82#32)",  monsterLvl = 260, defenseReq = 580, expScore = 260 },
	{ mapId = 1011,   minLvl = 250, x = 54,  y = 29,  name = "Icarus (Quái Lv250 EXP x1.0: 54#29)",  monsterLvl = 250, defenseReq = 509, expScore = 250 },

	-- 7. Aida (1034 - Yêu cầu Lv 200)
	{ mapId = 1034,   minLvl = 200, x = 116, y = 75,  name = "Aida (Quái Lv245 EXP x4.0: 116#75)",  monsterLvl = 245, defenseReq = 509, expScore = 245 },
	{ mapId = 1034,   minLvl = 200, x = 168, y = 117, name = "Aida (Quái Lv240 EXP x3.0: 168#117)", monsterLvl = 240, defenseReq = 485, expScore = 240 },
	{ mapId = 1034,   minLvl = 200, x = 220, y = 93,  name = "Aida (Quái Lv230 EXP x2.5: 220#93)",  monsterLvl = 230, defenseReq = 461, expScore = 230 },
	{ mapId = 1034,   minLvl = 200, x = 198, y = 109, name = "Aida (Quái Lv220 EXP x2.0: 198#109)", monsterLvl = 220, defenseReq = 438, expScore = 220 },
	{ mapId = 1034,   minLvl = 200, x = 194, y = 38,  name = "Aida (Quái Lv210 EXP x1.5: 194#38)",  monsterLvl = 210, defenseReq = 414, expScore = 210 },
	{ mapId = 1034,   minLvl = 200, x = 146, y = 35,  name = "Aida (Quái Lv200 EXP x1.0: 146#35)",  monsterLvl = 200, defenseReq = 390, expScore = 200 },

	-- 6. Tarkan (1009 - Yêu cầu Lv 150 | 6 bãi chuẩn cfg_Map_minimap × 3 Kênh = 18 vị trí mỗi mức)
	{
		mapId = 1009, minLvl = 150, x = 166, y = 196, maxLines = 3,
		name = "Tarkan (Quái Lv195 EXP x4.0)", monsterLvl = 195, defenseReq = 390, expScore = 195,
		coords = {
			{ x = 166, y = 196 }, { x = 123, y = 186 }, { x = 91, y = 202 },
			{ x = 75,  y = 181 }, { x = 51,  y = 170 }, { x = 35, y = 226 }
		}
	},
	{
		mapId = 1009, minLvl = 150, x = 37, y = 148, maxLines = 3,
		name = "Tarkan (Quái Lv190 EXP x3.0)", monsterLvl = 190, defenseReq = 372, expScore = 190,
		coords = {
			{ x = 37,  y = 148 }, { x = 59,  y = 149 }, { x = 68, y = 121 },
			{ x = 88,  y = 138 }, { x = 110, y = 138 }, { x = 105, y = 169 }
		}
	},
	{
		mapId = 1009, minLvl = 150, x = 28, y = 125, maxLines = 3,
		name = "Tarkan (Quái Lv180 EXP x2.5)", monsterLvl = 180, defenseReq = 355, expScore = 180,
		coords = {
			{ x = 28, y = 125 }, { x = 37, y = 96 }, { x = 33, y = 73 },
			{ x = 63, y = 89  }, { x = 65, y = 70 }, { x = 94, y = 91 }
		}
	},
	{
		mapId = 1009, minLvl = 150, x = 105, y = 77, maxLines = 3,
		name = "Tarkan (Quái Lv170 EXP x2.0)", monsterLvl = 170, defenseReq = 337, expScore = 170,
		coords = {
			{ x = 105, y = 77  }, { x = 104, y = 61 }, { x = 87,  y = 46 },
			{ x = 118, y = 100 }, { x = 126, y = 24 }, { x = 110, y = 43 }
		}
	},
	{
		mapId = 1009, minLvl = 150, x = 128, y = 57, maxLines = 3,
		name = "Tarkan (Quái Lv160 EXP x1.5)", monsterLvl = 160, defenseReq = 320, expScore = 160,
		coords = {
			{ x = 128, y = 57 }, { x = 127, y = 74 }, { x = 137, y = 93 },
			{ x = 149, y = 43 }, { x = 148, y = 62 }, { x = 157, y = 81 }
		}
	},
	{
		mapId = 1009, minLvl = 150, x = 162, y = 102, maxLines = 3,
		name = "Tarkan (Quái Lv150 EXP x1.0)", monsterLvl = 150, defenseReq = 260, expScore = 150,
		coords = {
			{ x = 162, y = 102 }, { x = 182, y = 112 }, { x = 201, y = 106 },
			{ x = 150, y = 119 }, { x = 164, y = 139 }, { x = 155, y = 151 }
		}
	},

	-- 5. Atlantis (1008 - Yêu cầu Lv 100 | Lv140 & Lv145 dùng 100% tâm bãi chuẩn cfg_Map_minimap × 3 Kênh)
	{
		mapId = 1008, minLvl = 100, x = 39, y = 211, maxLines = 3,
		name = "Atlantis (Quái Lv145 EXP x4.0)", monsterLvl = 145, defenseReq = 302, expScore = 145,
		coords = {
			{ x = 39,  y = 211 }, { x = 68,  y = 220 }, { x = 103, y = 212 },
			{ x = 134, y = 206 }, { x = 156, y = 197 }
		}
	},
	{
		mapId = 1008, minLvl = 100, x = 230, y = 173, maxLines = 3,
		name = "Atlantis (Quái Lv140 EXP x3.0)", monsterLvl = 140, defenseReq = 277, expScore = 140,
		coords = {
			{ x = 230, y = 173 }, { x = 224, y = 143 }, { x = 227, y = 118 }, { x = 231, y = 94 },
			{ x = 199, y = 106 }, { x = 169, y = 145 }, { x = 152, y = 162 }, { x = 114, y = 182 }
		}
	},
	{ mapId = 1008,   minLvl = 100, x = 34,  y = 162, name = "Atlantis (Bãi Đôi Lv130 EXP x2.5: 34#162)",  monsterLvl = 130, defenseReq = 252, expScore = 130 },
	{ mapId = 1008,   minLvl = 100, x = 185, y = 54,  name = "Atlantis (Quái Lv120 EXP x2.0: 185#54)",     monsterLvl = 120, defenseReq = 226, expScore = 120 },
	{ mapId = 1008,   minLvl = 100, x = 112, y = 40,  name = "Atlantis (Quái Lv110 EXP x1.5: 112#40)",     monsterLvl = 110, defenseReq = 201, expScore = 110 },
	{ mapId = 1008,   minLvl = 100, x = 48,  y = 46,  name = "Atlantis (Quái Lv100 EXP x1.0: 48#46)",      monsterLvl = 100, defenseReq = 176, expScore = 100 },

	-- 4. Lost Tower 2 (100502 - Yêu cầu Lv 80 | EXP 2.40K/phút gấp đôi Lost Tower 1)
	{ mapId = 100502, minLvl = 80,  x = 171, y = 231, name = "Lost Tower 2 (Bãi Đôi Lv90 EXP x3.0: 171#231)", monsterLvl = 95, defenseReq = 170, expScore = 98 },
	{ mapId = 100502, minLvl = 80,  x = 185, y = 210, name = "Lost Tower 2 (Bãi Đôi Lv75 EXP x2.0: 185#210)", monsterLvl = 88, defenseReq = 140, expScore = 88 },
	{ mapId = 100502, minLvl = 80,  x = 214, y = 217, name = "Lost Tower 2 (Bãi Đôi Lv60 EXP x1.0: 214#217)", monsterLvl = 78, defenseReq = 110, expScore = 78 },

	-- 3. Lost Tower 1 (100501 - Yêu cầu Lv 60)
	{ mapId = 100501, minLvl = 60,  x = 194, y = 106, name = "Lost Tower 1 (Giữa 2 Bãi Lv90: 194#106)", monsterLvl = 85, defenseReq = 105, expScore = 85 },
	{ mapId = 100501, minLvl = 60,  x = 199, y = 80,  name = "Lost Tower 1 (Bãi Đôi Lv75: 199#80)",     monsterLvl = 72, defenseReq = 90,  expScore = 72 },
	{ mapId = 100501, minLvl = 60,  x = 193, y = 42,  name = "Lost Tower 1 (Quái Lv60: 193#42)",        monsterLvl = 60, defenseReq = 80,  expScore = 60 },

	-- 2. Dungeon 1 (100201 - Yêu cầu Lv 40)
	{ mapId = 100201, minLvl = 40,  x = 66,  y = 236, name = "Dungeon 1 (Bãi Đôi Lv50: 66#236)", monsterLvl = 50, defenseReq = 75, expScore = 55 },
	{ mapId = 100201, minLvl = 40,  x = 96,  y = 189, name = "Dungeon 1 (Quái Lv45: 96#189)",    monsterLvl = 45, defenseReq = 55, expScore = 45 },
	{ mapId = 100201, minLvl = 40,  x = 99,  y = 235, name = "Dungeon 1 (Quái Lv40: 99#235)",    monsterLvl = 40, defenseReq = 40, expScore = 40 },

	-- 1. Devias (1003 - Yêu cầu Lv 20) & Lorencia (1001 - Yêu cầu Lv 1)
	{ mapId = 1003,   minLvl = 20,  x = 140, y = 230, name = "Devias (Kẻ Ám Sát Lv30: 140#230)", monsterLvl = 30, defenseReq = 25, expScore = 30 },
	{ mapId = 1003,   minLvl = 20,  x = 215, y = 45,  name = "Devias (Bọ Tuyết Lv20: 215#45)",   monsterLvl = 20, defenseReq = 0,  expScore = 20 },
	{ mapId = 1001,   minLvl = 1,   x = 134, y = 206, name = "Lorencia (Khô Lâu Binh: 134#206)", monsterLvl = 15, defenseReq = 0,  expScore = 15 },
}

_G.Mod_TierRotationState = _G.Mod_TierRotationState or {}

local function BuildTierCandidates(spot)
	local candidates = {}
	if spot and spot.coords and #spot.coords > 0 then
		local maxLines = tonumber(spot.maxLines) or 3
		for line = 1, maxLines do
			for idx, pt in ipairs(spot.coords) do
				table.insert(candidates, {
					line = line,
					x = pt.x,
					y = pt.y,
					spotIdx = idx,
					totalSpotsInLine = #spot.coords
				})
			end
		end
	else
		table.insert(candidates, {
			line = (_G.SceneData and _G.SceneData.line) or 1,
			x = spot and spot.x or 0,
			y = spot and spot.y or 0,
			spotIdx = 1,
			totalSpotsInLine = 1
		})
	end
	return candidates
end

local function ResolveSpotWithRotation(chosenSpot, myLvl)
	if not chosenSpot then return nil end
	local tierKey = tostring(chosenSpot.mapId) .. "_" .. tostring(chosenSpot.monsterLvl)
	local selX = chosenSpot.x
	local selY = chosenSpot.y
	local selLine = tonumber((_G.SceneData and (_G.SceneData.line or _G.SceneData.cline or _G.SceneData.lineIndex)) or 1) or 1
	local candIdx = 1
	local totalCands = 1
	local isExhausted = false

	-- Từ Lv 145 trở đi: Nếu bãi quái có danh sách coords & đa kênh, lấy vị trí theo bộ xoay vòng chống trùng bãi
	if myLvl >= 145 and chosenSpot.coords and #chosenSpot.coords > 0 then
		local candidates = BuildTierCandidates(chosenSpot)
		totalCands = #candidates
		_G.Mod_TierRotationState = _G.Mod_TierRotationState or {}
		local st = _G.Mod_TierRotationState[tierKey]
		if not st then
			st = { idx = 1, exhausted = false, lastTeleTime = 0 }
			_G.Mod_TierRotationState[tierKey] = st
		end
		if st.idx < 1 then st.idx = 1 end
		if st.idx > totalCands then
			st.idx = totalCands
			st.exhausted = true
		end
		local cand = candidates[st.idx] or candidates[totalCands]
		if cand then
			selX = cand.x
			selY = cand.y
			selLine = cand.line
			candIdx = st.idx
			isExhausted = (st.exhausted == true)
		end
	end

	return {
		id = chosenSpot.mapId,
		name = string.format("%s [Kênh %d - %d#%d (%d/%d)]", tostring(chosenSpot.name), selLine, selX, selY, candIdx, totalCands),
		baseName = chosenSpot.name,
		x = selX,
		y = selY,
		line = selLine,
		tierKey = tierKey,
		candidateIdx = candIdx,
		totalCandidates = totalCands,
		exhausted = isExhausted,
		defenseReq = chosenSpot.defenseReq,
		monsterLvl = chosenSpot.monsterLvl,
		efficiency = 6,
		mapId = chosenSpot.mapId,
		rawSpot = chosenSpot
	}
end

-- Quét người chơi khác đứng trong phạm vi <= maxTileRadius (mặc định 2 ô) quanh tọa độ (spotX, spotY)
-- Sử dụng chuẩn `_G.RoleManager.GetRolesByType(1)` từ Auto PK Client & `modules/mod_player_info.lua`
local function HasOtherPlayerNearSpot(spotX, spotY, maxTileRadius)
	maxTileRadius = tonumber(maxTileRadius) or 2
	local me = _G.RoleManager and _G.RoleManager.me
	local meId = (me and me.data and me.data.id) or (me and me.id) or 0
	local allPlayers = _G.RoleManager and _G.RoleManager.GetRolesByType and _G.RoleManager.GetRolesByType(1)
	if not allPlayers then return false, nil, nil end

	for _, p in pairs(allPlayers) do
		if p and not p.isDead and (not p.hp or p.hp > 0) then
			local pId = (p.data and p.data.id) or p.id or 0
			if pId ~= 0 and pId ~= meId then
				local pCell = p.serverCoord or (p.cellPos and { x = p.cellPos.x, y = p.cellPos.y })
				if pCell and pCell.x and pCell.y then
					local px = tonumber(pCell.x) or 0
					local py = tonumber(pCell.y) or 0
					local dist = math.max(math.abs(px - spotX), math.abs(py - spotY))
					if dist <= maxTileRadius then
						local pName = (p.data and p.data.name) or p.name or tostring(pId)
						return true, pName, dist
					end
				end
			end
		end
	end
	return false, nil, nil
end
_G.HasOtherPlayerNearSpot = HasOtherPlayerNearSpot

GetBestMonsterFarmPoint = function(requestedMap, strictSingleMap)
	local myLvl = GetAccuratePlayerLevel()
	local effectiveDef = GetEffectiveMonsterDefense(myLvl)
	local reqMapNum = tonumber(requestedMap) or 0

	-- Nếu được yêu cầu tìm bãi trong đúng 1 map cụ thể (ví dụ nhiệm vụ CS1 tại Tarkan 1009 khi đã đủ Lv 150)
	if strictSingleMap and reqMapNum > 0 and reqMapNum < 1000000 and CanPlayerEnterMap(reqMapNum, myLvl) then
		local bestInMap = nil
		local fallbackInMap = nil
		for _, spot in ipairs(ALL_PROGRESSION_FARM_SPOTS) do
			if spot.mapId == reqMapNum then
				if not fallbackInMap or spot.defenseReq < fallbackInMap.defenseReq then
					fallbackInMap = spot
				end
				if effectiveDef >= spot.defenseReq then
					bestInMap = spot
					break
				end
			end
		end
		local chosen = bestInMap or fallbackInMap
		if chosen then
			return ResolveSpotWithRotation(chosen, myLvl), chosen.mapId
		end
	end

	-- Quét toàn bộ danh sách bãi quái từ cao xuống thấp:
	-- Chọn bãi có expScore cao nhất mà nhân vật ĐỦ LEVEL VÀO MAP (myLvl >= spot.minLvl & CanPlayerEnterMap)
	-- VÀ ĐỦ PHÒNG THỦ HIỆU DỤNG (effectiveDef >= spot.defenseReq)
	local bestSpot = nil
	local lowestDefValidMapSpot = nil
	for _, spot in ipairs(ALL_PROGRESSION_FARM_SPOTS) do
		if myLvl >= (spot.minLvl or 1) and CanPlayerEnterMap(spot.mapId, myLvl) then
			if not lowestDefValidMapSpot or spot.defenseReq < lowestDefValidMapSpot.defenseReq then
				lowestDefValidMapSpot = spot
			end
			if effectiveDef >= (spot.defenseReq or 0) then
				if not bestSpot or (spot.expScore or 0) > (bestSpot.expScore or 0) then
					bestSpot = spot
				end
			end
		end
	end

	local finalSpot = bestSpot or lowestDefValidMapSpot or ALL_PROGRESSION_FARM_SPOTS[#ALL_PROGRESSION_FARM_SPOTS]
	return ResolveSpotWithRotation(finalSpot, myLvl), finalSpot.mapId
end
_G.GetBestMonsterFarmPoint = GetBestMonsterFarmPoint

local function SendTeleportWithLine(targetMap, targetLine, targetX, targetY)
	local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
	local curLine = tonumber((_G.SceneData and (_G.SceneData.line or _G.SceneData.cline or _G.SceneData.lineIndex)) or 1) or 1
	targetLine = tonumber(targetLine) or curLine or 1

	pcall(function()
		-- Nếu đang ở cùng bản đồ nhưng khác Kênh (Line), gửi thêm ReqChangeLine để ép chuyển kênh chính xác
		if curMap == targetMap and curLine ~= targetLine then
			if _G.networkRequest and _G.networkRequest.ReqChangeLine then
				pcall(function() _G.networkRequest.ReqChangeLine(targetLine) end)
			end
			if _G.NetManager and _G.MapMessage and _G.MapMessage.ReqChangeLine then
				pcall(function() _G.NetManager.Send(_G.MapMessage.ReqChangeLine, { line = targetLine }) end)
			end
		end
		if _G.networkRequest and _G.networkRequest.ReqCallFlag then
			_G.networkRequest.ReqCallFlag(1, 0, targetMap, targetLine, targetX, targetY, 0)
		end
		if _G.NetManager and _G.MapMessage and _G.MapMessage.ReqCallFlag then
			_G.NetManager.Send(_G.MapMessage.ReqCallFlag, {
				type = 1,
				rid = 0,
				mapId = targetMap,
				line = targetLine,
				x = targetX,
				y = targetY,
				hostId = 0
			})
		end
		if curMap ~= targetMap and _G.networkRequest and _G.networkRequest.ReqTransmit then
			_G.networkRequest.ReqTransmit(targetMap, targetLine, targetX, targetY)
		end
		-- Nếu vừa đổi kênh trên cùng map, bắn bồi lại ReqCallFlag sau 0.6s để đáp chuẩn vào tâm bãi của kênh mới
		if curMap == targetMap and curLine ~= targetLine and Timer and Timer.Start then
			Timer.Start(0.6, function()
				pcall(function()
					if _G.networkRequest and _G.networkRequest.ReqCallFlag then
						_G.networkRequest.ReqCallFlag(1, 0, targetMap, targetLine, targetX, targetY, 0)
					end
					if _G.NetManager and _G.MapMessage and _G.MapMessage.ReqCallFlag then
						_G.NetManager.Send(_G.MapMessage.ReqCallFlag, {
							type = 1,
							rid = 0,
							mapId = targetMap,
							line = targetLine,
							x = targetX,
							y = targetY,
							hostId = 0
						})
					end
				end)
			end)
		end
	end)
end
_G.SendTeleportWithLine = SendTeleportWithLine

-- Kiểm tra nếu có người chơi khác đứng trong phạm vi <= 2 ô tại bãi farm (chỉ áp dụng từ Lv 145+)
-- thì xoay sang vị trí/kênh tiếp theo; nếu hết danh sách (15-18 vị trí) thì chấp nhận đứng ở vị trí cuối.
local function CheckAndRotateSpotIfPlayerNearby(bestPt, targetMap)
	local myLvl = GetAccuratePlayerLevel()
	if myLvl < 145 then return false end
	if not bestPt or not bestPt.rawSpot or not bestPt.rawSpot.coords or #bestPt.rawSpot.coords <= 1 then
		return false
	end
	local tierKey = bestPt.tierKey
	if not tierKey then return false end

	_G.Mod_TierRotationState = _G.Mod_TierRotationState or {}
	local st = _G.Mod_TierRotationState[tierKey]
	if not st or st.exhausted then
		return false
	end

	local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
	local curLine = tonumber((_G.SceneData and (_G.SceneData.line or _G.SceneData.cline or _G.SceneData.lineIndex)) or 1) or 1
	if curMap ~= targetMap or curLine ~= (bestPt.line or 1) then
		return false
	end

	-- Chỉ kiểm tra khi nhân vật đã đứng gần tâm bãi (<= 5 ô) và đã qua ít nhất 1.6s từ lần dịch chuyển trước
	local nowTime = (CS and CS.UnityEngine and CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
	if (nowTime - (st.lastTeleTime or 0)) < 1.6 then
		return false
	end

	local me = _G.RoleManager and _G.RoleManager.me
	local myPos = (me and me.serverCoord) or (me and me.cellPos)
	if not myPos or not myPos.x or not myPos.y then return false end
	local myDistToSpot = math.max(math.abs((tonumber(myPos.x) or 0) - bestPt.x), math.abs((tonumber(myPos.y) or 0) - bestPt.y))
	if myDistToSpot > 5 then
		return false
	end

	local hasPlayer, pName, pDist = HasOtherPlayerNearSpot(bestPt.x, bestPt.y, 2)
	if not hasPlayer then
		return false
	end

	local candidates = BuildTierCandidates(bestPt.rawSpot)
	local totalCands = #candidates
	if st.idx < totalCands then
		st.idx = st.idx + 1
		st.lastTeleTime = nowTime
		local nextCand = candidates[st.idx]
		Log(string.format("-> [TRÁNH TRÙNG BÃI LV%d]: Phát hiện người chơi \"%s\" cách tâm bãi (%d#%d Kênh %d) %d ô (<= 2 ô) -> Dịch chuyển sang vị trí [%d/%d]: Kênh %d (%d#%d)!",
			myLvl, tostring(pName), bestPt.x, bestPt.y, bestPt.line or 1, tonumber(pDist) or 0, st.idx, totalCands, nextCand.line, nextCand.x, nextCand.y), true)
		SaveOutput()
		SendTeleportWithLine(targetMap, nextCand.line, nextCand.x, nextCand.y)
		return true
	else
		st.exhausted = true
		Log(string.format("-> [TRÁNH TRÙNG BÃI LV%d]: Đã kiểm tra hết %d/%d vị trí (3 Kênh) của %s đều có người -> Chấp nhận đứng farm tại vị trí cuối Kênh %d (%d#%d)!",
			myLvl, totalCands, totalCands, tostring(bestPt.baseName or bestPt.name), bestPt.line or 1, bestPt.x, bestPt.y), true)
		SaveOutput()
		return false
	end
end
_G.CheckAndRotateSpotIfPlayerNearby = CheckAndRotateSpotIfPlayerNearby
_G.CheckAndSwitchSpotIfPlayerNearby = CheckAndRotateSpotIfPlayerNearby

TeleportToBestFarmPoint = function(forcedMap)
	local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
	local bestPt, targetMap = GetBestMonsterFarmPoint(forcedMap, false)
	if not bestPt or not targetMap or targetMap <= 0 then
		return false
	end
	local myLvl = GetAccuratePlayerLevel()
	if not CanPlayerEnterMap(targetMap, myLvl) then
		bestPt, targetMap = GetBestMonsterFarmPoint(0, false)
		if not bestPt or not targetMap or not CanPlayerEnterMap(targetMap, myLvl) then
			return false
		end
	end
	local lineId = tonumber(bestPt.line) or (_G.SceneData and _G.SceneData.line) or 1
	if bestPt.tierKey and _G.Mod_TierRotationState and _G.Mod_TierRotationState[bestPt.tierKey] then
		_G.Mod_TierRotationState[bestPt.tierKey].lastTeleTime = (CS and CS.UnityEngine and CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
	end
	local effDef, rawDef, overPct = GetEffectiveMonsterDefense(myLvl)
	if targetMap ~= curMap then
		Log(string.format("-> [CHUYỂN MAP FARM 0ms]: Lv %d | Thủ %d (Hiệu dụng %d, +%d%%) -> Bay thẳng tới Map %d (%s)!",
			myLvl, rawDef, effDef, overPct, targetMap, tostring(bestPt.name)), true)
		SaveOutput()
	else
		Log(string.format("-> [BAY BÃI QUÁI 0ms]: Lv %d | Thủ %d (Hiệu dụng %d, +%d%%) -> Dịch chuyển tới %s!",
			myLvl, rawDef, effDef, overPct, tostring(bestPt.name)), true)
		SaveOutput()
	end
	SendTeleportWithLine(targetMap, lineId, bestPt.x, bestPt.y)
	if _G.Mod_PerformStopMoveJiggle then
		if Timer and Timer.Start then
			Timer.Start(0.4, function() _G.Mod_PerformStopMoveJiggle(bestPt.x, bestPt.y) end)
		else
			_G.Mod_PerformStopMoveJiggle(bestPt.x, bestPt.y)
		end
	end
	return true
end
_G.TeleportToBestFarmPoint = TeleportToBestFarmPoint

TeleportToTrainMapAndFarm = function(onFinished)
	if ApplyFovAndSpeed then ApplyFovAndSpeed() end
	local bestPt, targetMap = GetBestMonsterFarmPoint(0, false)
	local curLvl = GetAccuratePlayerLevel()
	local effDef, rawDef, overPct = GetEffectiveMonsterDefense(curLvl)
	Log(string.format("[Luyện Cấp] : Chọn bãi quái tối ưu tại Map %d (%s) (Cấp nhân vật: %d | Thủ: %d | Hiệu dụng: %d [+%d%%])",
		tonumber(targetMap) or 0, tostring(bestPt and bestPt.name or ""), curLvl, rawDef, effDef, overPct), true)
	SaveOutput()
	TeleportToBestFarmPoint(targetMap)
	if Timer and Timer.Start then
		Timer.Start(1.5, function()
			pcall(function()
				local me = _G.RoleManager and _G.RoleManager.me
				if me and me.SetAutoFight then
					me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight")
				end
				if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then
					_G.QiJiHelperData.SetAutoFightData(true)
				end
			end)
			Timer.Start(2.0, function()
				Log("[Luyện Cấp] : Nhân vật đã vào trạng thái tự động đánh quái ổn định tại bãi farm!", true)
				SaveOutput()
				if onFinished then
					onFinished()
				elseif SwitchToNextRoleOrAccount then
					SwitchToNextRoleOrAccount()
				end
			end)
		end)
	end
end
_G.TeleportToTrainMapAndFarm = TeleportToTrainMapAndFarm

local function TeleportToQueenFarmSpot(bestPt, targetMap)
	if not bestPt or not targetMap or targetMap <= 0 then return false end
	local myLvl = GetAccuratePlayerLevel()
	if not CanPlayerEnterMap(targetMap, myLvl) then
		bestPt, targetMap = GetBestMonsterFarmPoint(0, false)
		if not bestPt or not targetMap or not CanPlayerEnterMap(targetMap, myLvl) then
			return false
		end
	end
	local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
	-- Không gửi lệnh chuyển map khi nhân vật vẫn đang ở trong phòng phó bản Nữ Hoàng (2101000)
	if curMap == 2101000 or curMap == 2101001 or (_G.TranScriptData and _G.TranScriptData.InTranscript) then
		return false
	end
	local lineId = tonumber(bestPt.line) or (_G.SceneData and _G.SceneData.line) or 1
	if bestPt.tierKey and _G.Mod_TierRotationState and _G.Mod_TierRotationState[bestPt.tierKey] then
		_G.Mod_TierRotationState[bestPt.tierKey].lastTeleTime = (CS and CS.UnityEngine and CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
	end
	SendTeleportWithLine(targetMap, lineId, bestPt.x, bestPt.y)
	return true
end

-- =========================================================================
-- [MOD FEATURE]: HỆ THỐNG 2 BIẾN ĐẾM HỒI SINH NỮ HOÀNG TÂN THỦ (2-SLOT GRAVE TIMER)
-- Mô tả:
--   - Lưu mảng 2 biến hồi sinh `_G.Mod_QueenRespawnSlots = { nil, nil }` tương ứng 2 kênh/phòng Nữ Hoàng Tân Thủ (2101000).
--   - Khi Nữ Hoàng chết (hoặc khi vào phòng thấy quan tài), quét thời gian hồi sinh từ `_G.GraveManager.graveList`
--     (`(grave.data.reliveTime - Time.GetServerTime()) / 1000` hoặc label `MM: SS` trên quan tài) và cộng vào thời gian hiện tại.
--   - Nếu còn ít nhất 1 biến trong mảng là `nil`: Thoát phó bản hiện tại và lập tức tiến vào lại phó bản Nữ Hoàng Tân Thủ
--     để đánh/quét con thứ 2 (chưa bay đi farm quái).
--   - Khi cả 2 biến đều đã có thời gian hồi sinh: Lấy mốc hồi sinh sớm nhất `min(slot[1], slot[2])`, bay ra bãi farm quái
--     tối ưu theo cấp độ/phòng thủ cho đến đúng thời điểm hồi sinh đó thì bay vào đánh Nữ Hoàng và cập nhật lại biến của con đó.
-- =========================================================================
_G.Mod_QueenRespawnSlots = _G.Mod_QueenRespawnSlots or { nil, nil }
_G.Mod_QueenTargetSlotIdx = _G.Mod_QueenTargetSlotIdx or 1
_G.Mod_LastGraveReliveTimeMs = _G.Mod_LastGraveReliveTimeMs or 0
_G.Mod_LastGraveSeenAtSec = _G.Mod_LastGraveSeenAtSec or 0

local function GetNowSec()
	if _G.Time and _G.Time.GetServerTime then
		local ok, srvMs = pcall(_G.Time.GetServerTime)
		if ok and tonumber(srvMs) and tonumber(srvMs) > 0 then
			return math.floor(tonumber(srvMs) / 1000)
		end
	end
	if CS and CS.UnityEngine and CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup then
		return math.floor(CS.UnityEngine.Time.realtimeSinceStartup)
	end
	return os.time()
end

local function EnsureGraveManagerHook()
	pcall(function()
		if _G.GraveManager and not _G.Mod_HookedGraveManager then
			_G.Mod_HookedGraveManager = true
			local origCreatGrave = _G.GraveManager.CreatGrave
			if origCreatGrave then
				_G.GraveManager.CreatGrave = function(graveData, ...)
					pcall(function()
						if graveData and graveData.reliveTime then
							_G.Mod_LastGraveReliveTimeMs = tonumber(graveData.reliveTime) or 0
							_G.Mod_LastGraveSeenAtSec = GetNowSec()
						end
					end)
					return origCreatGrave(graveData, ...)
				end
			end
		end
	end)
end
EnsureGraveManagerHook()

local function ResetQueenRespawnSlots()
	_G.Mod_QueenRespawnSlots = { nil, nil }
	_G.Mod_QueenTargetSlotIdx = 1
	_G.Mod_LastGraveReliveTimeMs = 0
	_G.Mod_LastGraveSeenAtSec = 0
end
_G.ResetQueenRespawnSlots = ResetQueenRespawnSlots

-- =========================================================================
-- [MOD FEATURE]: DỌN SẠCH TRẠNG THÁI NHIỆM VỤ, QUÁI MỤC TIÊU & ĐĂNG XUẤT SẠCH SẼ KHI ĐỔI ACC / BẤM LOGIN
-- Mô tả:
--   1. Thực thi đầy đủ các hàm Reset của những Controller trong game chỉ lắng nghe gói ResLogout
--      (MapMonsterLockManager.SwitchRole, FightMonsterManager.OnReset, MapMonsterConfigInfo.OnRet,
--       LookForTask.SwitchRole, DirectTask.SwitchRole, TaskManager.SwitchRole, AutoTaskManage.OnReset,
--       PathFinderManager.ResetData, BagInfoData.BagReSet, SceneData.ResetData) để nhân vật mới ở Acc 2
--      không bao giờ bị kẹt khóa mục tiêu hoặc lag nhiệm vụ đầu tiên.
--   2. Đặt LoginData.InGame = false, LoginData.reconnectState = false, LoginData.needReconnect = false
--      và dừng các timer ReconnectManager TRƯỚC khi đóng NetManager.Close().
--   3. Xóa sạch RoleManager.me = nil và ViewData.meData = nil để không kích hoạt nhầm Load_PreLoadEnd ở Map 0.
--   4. Ghi đè CreateRoleAndEnterGame / SelectRoleByIndex để không gửi trùng ReqGetRoleList khi tạo nhân vật
--      (tránh việc LoginController.OnResGetRoleList gọi Scene.OnEnterRole() đè cảnh Pedestal lên cảnh trong game).
-- =========================================================================
ClearAllTaskDataAndState = function()
	Log("-> [CLEAN TASK]: Đang xóa sạch toàn bộ thông tin nhiệm vụ & mục tiêu cũ trước khi đổi tài khoản...", true)
	ResetQueenRespawnSlots()

	-- 1. Dọn sạch hệ thống TaskData phía Client
	pcall(function()
		if _G.TaskData then
			if _G.TaskData.SwitchRole then pcall(_G.TaskData.SwitchRole) end
			if _G.TaskData.Reset then pcall(_G.TaskData.Reset) end
			_G.TaskData.AllTasks = {}
			_G.TaskData.mainTasks = {}
			_G.TaskData.branchTasks = {}
			_G.TaskData.rewardsTasks = {}
			_G.TaskData.activeTasks = {}
			_G.TaskData.monsterTasks = {}
			_G.TaskData.starTasks = {}
			_G.TaskData.counterpartTask = {}
			_G.TaskData.skillBooksTasks = {}
			_G.TaskData.periodicalTasks = {}
			_G.TaskData.transferTask = {}
			_G.TaskData.completedTasksCount = {}
			_G.TaskData.allMonsterLevel = {}
			_G.TaskData.allUnionTasks = {}
			_G.TaskData.levelBossTaskId = nil
			_G.TaskData.StarTaskCount = nil
		end
	end)

	-- 2. Dọn sạch TaskManager, AutoTaskManage, DirectTask, LookForTask, MapMonsterLockManager, FightMonsterManager
	pcall(function()
		if _G.AutoTaskManage then
			if _G.AutoTaskManage.StopAutoTask then pcall(_G.AutoTaskManage.StopAutoTask) end
			if _G.AutoTaskManage.OnReset then pcall(_G.AutoTaskManage.OnReset) end
			_G.AutoTaskManage.taskChange = false
			_G.AutoTaskManage.autoTask = false
			_G.AutoTaskManage.curRoleOperate = false
			_G.AutoTaskManage.curAutoTask = nil
			_G.AutoTaskManage.curAutoTaskState = nil
			_G.AutoTaskManage.autoTaskStack = {}
			if _G.AutoTaskManage.RemoveAutoTask then pcall(_G.AutoTaskManage.RemoveAutoTask, true) end
		end
		if _G.TaskManager then
			if _G.TaskManager.SwitchRole then pcall(_G.TaskManager.SwitchRole) end
			if _G.TaskManager.TaskPathStop then pcall(_G.TaskManager.TaskPathStop) end
			_G.TaskManager.curTask = nil
			_G.TaskManager.clickTask = nil
		end
		if _G.DirectTask and _G.DirectTask.SwitchRole then pcall(_G.DirectTask.SwitchRole) end
		if _G.LookForTask and _G.LookForTask.SwitchRole then pcall(_G.LookForTask.SwitchRole) end
		if _G.MapMonsterLockManager and _G.MapMonsterLockManager.SwitchRole then pcall(_G.MapMonsterLockManager.SwitchRole) end
		if _G.FightMonsterManager and _G.FightMonsterManager.OnReset then pcall(_G.FightMonsterManager.OnReset) end
		if _G.MapMonsterConfigInfo then
			if _G.MapMonsterConfigInfo.OnRet then pcall(_G.MapMonsterConfigInfo.OnRet) end
			if _G.MapMonsterConfigInfo.RemoveTime then pcall(_G.MapMonsterConfigInfo.RemoveTime) end
		end
		if _G.MapMonster and _G.MapMonster.Init then pcall(_G.MapMonster.Init) end
		if _G.TaskController then
			if _G.TaskController.OnGamePlayLeave then pcall(_G.TaskController.OnGamePlayLeave) end
			_G.TaskController.curTask = nil
		end
	end)

	-- 3. Reset tìm đường và dừng nhân vật
	pcall(function()
		if _G.PathFinderManager then
			if _G.PathFinderManager.ResetData then pcall(_G.PathFinderManager.ResetData) end
			if _G.PathFinderManager.pathFinding and _G.PathFinderManager.pathFinding.Reset then
				pcall(_G.PathFinderManager.pathFinding.Reset)
			end
		end
		if _G.RoleManager and _G.RoleManager.me then
			if _G.RoleManager.me.StopMove then pcall(function() _G.RoleManager.me:StopMove() end) end
			if _G.RoleManager.me.SetAutoTaskFight and _G.AutoFightStrKey then
				pcall(function() _G.RoleManager.me:SetAutoTaskFight(_G.AutoFightStrKey.UnAutoFight) end)
			end
		end
	end)

	-- 4. Xóa trắng HUD Task_TaskUI (chỉ bắn Task_Update khi đang có RoleManager.me hợp lệ)
	pcall(function()
		local taskUI = _G.UIManager and _G.UIManager.GetUiByName and (_G.UIManager.GetUiByName("Task_TaskUI") or (_G.UIID and _G.UIID.TaskUI and _G.UIManager.GetUiByName(_G.UIID.TaskUI)))
		if taskUI then
			if taskUI.CleanTaskReminder then pcall(function() taskUI:CleanTaskReminder() end) end
			if taskUI.RemoveTime then pcall(function() taskUI:RemoveTime() end) end
			if taskUI.RemoveNaviGuideTime then pcall(function() taskUI:RemoveNaviGuideTime() end) end
			if taskUI.taskItemTemp and taskUI.taskItemTemp.RemoveKTable then
				pcall(function() taskUI.taskItemTemp:RemoveKTable() end)
			end
		end
		if _G.RoleManager and _G.RoleManager.me ~= nil and _G.EventManager and _G.EventManager.Dispatch and _G.Event then
			if _G.Event.Task_Update then _G.EventManager.Dispatch(_G.Event.Task_Update, nil) end
			if _G.Event.TaskData_Update then _G.EventManager.Dispatch(_G.Event.TaskData_Update, nil) end
		end
	end)

	-- 5. Xóa toàn bộ bộ đệm nhiệm vụ & trạng thái của Bot
	_G.Bot_QueenBugAttemptCount = 0
	_G.Bot_QueenBugHadSucceeded = false
	_G.Bot_Under80LagStartTime = nil
	_G.Bot_Under80LagTaskKey = nil
	_G.Mod_TierRotationState = {}
	_G.Mod_CurrentSpotCoordIdx = {}
	_G.Mod_LastSwitchSpotForPlayerTime = 0
	_G.Mod_FarmKCActive = false
	_G.Mod_FarmKCCount = 0
	_G.Mod_IsRunningInstance = false
	_G.Mod_BC_AllowSkipWait = false
	_G.Mod_BC_NextRetryTime = 0
	_G.Bot_CurrentTaskId = nil
	_G.Bot_LastTaskNavTime = 0
	_G.Bot_LastTaskAcceptTime = 0
	_G.Bot_LastFarmTeleportTime = 0
	_G.Bot_LastMapTravelTime = 0
	_G.Bot_LastShopNavTime = 0
	_G.Bot_LastShopBuyTime = 0
	_G.Bot_LastRecycleTaskTime = 0
	_G.Bot_LastCS1TeleTime = 0
	_G.Bot_TaskRetryCount = 0
	_G.ClaimedTaskCooldown = {}
	_G.BranchTaskCooldown = {}
	_G.ClaimedOpeningGiftsCache = {}
	_G.Bot_LevelMilestonesClaimed = {}
	_G.ClaimedDailyWelfareIds = {}
	_G.Mod_HasPurchasedDailyPackToday = false
	_G.Mod_HasPurchasedExpPotion = false
	_G.Mod_Count180Bought = 0
	_G.Bot_HasDoneEnhanceAfterSnowBug = nil
	_G.Bot_HasEnteredGiftcodes = false
	_G.AutoGiftCodeRunning = false
	_G.Bot_ClaimedCommunityLvl60 = false
	_G.Bot_ClaimedOpenServerPackLvl60 = false
	_G.Bot_ClaimedDiamondPackLvl65 = false
	_G.Bot_ClaimedCommunityLvl100 = false
	_G.Bot_ClaimedUpgradePacksLvl101 = false
	_G.Bot_LastSnowBeetleTeleTime = 0
	_G.Bot_AllowClaimTask3108 = false
	_G.Bot_AllowClaimTask3103 = false
	_G.Bot_AllowClaimTask5024 = false
	_G.Bot_AllowClaimTask50007 = false
	_G.Bot_HasAttemptedClaim5024 = false
	_G.Bot_HasClaimed50007Once = false
	_G.Bot_HasLearnedSoulBarrier100 = false
	_G.Bot_UsedSoulBarrierStone = false
	_G.Bot_BuySoulBarrierCount = 0
	_G.Bot_HasLearnedEvilSpiritLv2_150 = false
	_G.Bot_UsedEvilSpiritLv2Stone = false
	_G.Bot_BuyEvilSpiritLv2Count = 0
	_G.Bot_LastSkillStoneBuyUseTime = 0
	_G.Bot_QueenBugUnavailable = false
	_G.Bot_QueenBugState = "IDLE"
	_G.Bot_QueenBugStateTime = 0
	_G.Bot_NormalQueenKillCount = 0
	_G.Bot_NormalQueenSpotIdx = 1
	_G.Bot_QueenBugActiveBoss = nil
	if _G.ResetAutoLearnSkillFlags then pcall(_G.ResetAutoLearnSkillFlags) end
	if _G.StopFarmKCRoutine then pcall(_G.StopFarmKCRoutine) end
	if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
	if _G.SyncFarmNHBtnUI then pcall(_G.SyncFarmNHBtnUI) end
	SaveOutput()
end
_E.ClearAllTaskDataAndState = ClearAllTaskDataAndState
_G.ClearAllTaskDataAndState = ClearAllTaskDataAndState

ForceLogoutToLogin = function()
	Log("--- [CLEAN LOGOUT] ĐĂNG XUẤT SẠCH SẼ RA MÀN HÌNH LOGIN ---", true)
	_G.Bot_IsInGameWorld = false
	_G.IsRoleCreating = false
	_G.HasCreatedRoleForTarget = false
	_G.IsSwitchingAccount = false
	_G.AutoEvenEnhanceRunning = false
	_G.Mod_FarmKCRunning = false
	_G.Bot_Under80LagStartTime = nil
	_G.Bot_Under80LagTaskKey = nil

	-- 1. Dừng toàn bộ các timer đang chạy của Bot
	pcall(function()
		if _G.BotQuestMonitorTimer then Timer.Stop(_G.BotQuestMonitorTimer); _G.BotQuestMonitorTimer = nil end
		if _G.Global30sUpgradeTimer then Timer.Stop(_G.Global30sUpgradeTimer); _G.Global30sUpgradeTimer = nil end
		if _G.Bot_FarmMonitorTimer then Timer.Stop(_G.Bot_FarmMonitorTimer); _G.Bot_FarmMonitorTimer = nil end
		if _G.Mod_InstanceMonitorTimer then Timer.Stop(_G.Mod_InstanceMonitorTimer); _G.Mod_InstanceMonitorTimer = nil end
		if _G.Mod_FarmKCTimer then Timer.Stop(_G.Mod_FarmKCTimer); _G.Mod_FarmKCTimer = nil end
		if _G.Mod_EnhanceLoopTimer then Timer.Stop(_G.Mod_EnhanceLoopTimer); _G.Mod_EnhanceLoopTimer = nil end
	end)

	-- 2. Gỡ sạch dữ liệu & trạng thái nhiệm vụ / mục tiêu cũ
	pcall(ClearAllTaskDataAndState)

	-- 3. Khóa cờ ReconnectManager TRƯỚC khi gửi ReqLogout / đóng NetManager
	pcall(function()
		if _G.LoginData then
			_G.LoginData.InGame = false
			_G.LoginData.reconnectState = false
			_G.LoginData.needReconnect = false
		end
		if _G.ReconnectManager then
			if _G.ReconnectManager.autoReconnect then
				pcall(function() Timer.Stop(_G.ReconnectManager.autoReconnect) end)
				_G.ReconnectManager.autoReconnect = nil
			end
			if _G.ReconnectManager.autoClose then
				pcall(function() Timer.Stop(_G.ReconnectManager.autoClose) end)
				_G.ReconnectManager.autoClose = nil
			end
		end
	end)

	-- 4. Gửi ReqLogout chính thức lên Server nếu đang kết nối
	pcall(function()
		if _G.NetManager and _G.NetManager.IsConnect and _G.NetManager.IsConnect() then
			local reason = (_G.ELogoutType and _G.ELogoutType.LogOut) or 5
			_G.NetManager.Send(_G.UserMessage.ReqLogout, { reason = reason })
		end
	end)

	-- 5. Thực thi đầy đủ ResetRoleInfo giống LoginController.OnResLogout
	pcall(function()
		if _G.BagInfoData then
			if _G.BagInfoData.BagReSet then pcall(_G.BagInfoData.BagReSet) end
			if _G.BagInfoData.StorageReSet then pcall(_G.BagInfoData.StorageReSet) end
			if _G.BagInfoData.PandoraReSet then pcall(_G.BagInfoData.PandoraReSet) end
		end
		if _G.AuctionData and _G.AuctionData.AuctionDataReSet then pcall(_G.AuctionData.AuctionDataReSet) end
		if _G.SceneData then
			if _G.SceneData.ResetData then pcall(_G.SceneData.ResetData) end
			_G.SceneData.mapId = 0
			_G.SceneData.mapLoaded = false
		end
		if _G.ExpAddData and _G.ExpAddData.ResetData then pcall(_G.ExpAddData.ResetData) end
		if _G.TeamController and _G.TeamController.OnGamePlayLeave then pcall(_G.TeamController.OnGamePlayLeave) end
		if _G.TeamUpQuicklyController and _G.TeamUpQuicklyController.CleanTeamUpData then pcall(_G.TeamUpQuicklyController.CleanTeamUpData) end
		if _G.RoleDeclareManager and _G.RoleDeclareManager.ResLogout then pcall(_G.RoleDeclareManager.ResLogout) end
	end)

	-- 6. Dọn Avatar & thông báo rời thế giới game (GamePlay_Leave tự gọi RoleManager.OnLeaveGame & Scene.EnterLogin)
	pcall(function()
		if _G.gameMgr and _G.gameMgr.GetAvatarManager then
			local avMgr = _G.gameMgr:GetAvatarManager()
			if avMgr and avMgr.RemoveAllAvatar then avMgr:RemoveAllAvatar() end
		end
	end)
	pcall(function()
		if _G.EventManager and _G.EventManager.Dispatch and _G.Event and _G.Event.GamePlay_Leave then
			_G.EventManager.Dispatch(_G.Event.GamePlay_Leave)
		end
	end)

	-- 7. Xóa triệt để RoleManager.me và ViewData.meData (do ViewData.Clear() của game bỏ sót meData)
	pcall(function()
		if _G.RoleManager then
			if _G.RoleManager.DestroyRoles then pcall(_G.RoleManager.DestroyRoles) end
			_G.RoleManager.me = nil
		end
		if _G.ViewData then
			if _G.ViewData.Clear then pcall(_G.ViewData.Clear) end
			_G.ViewData.meData = nil
		end
	end)

	-- 8. Đóng kết nối socket và khóa lại ReconnectManager lần nữa
	pcall(function()
		if _G.NetManager and _G.NetManager.Close then
			_G.NetManager.Close()
		end
		if _G.LoginData then
			_G.LoginData.InGame = false
			_G.LoginData.reconnectState = false
			_G.LoginData.needReconnect = false
			_G.LoginData.roleId = 0
			_G.LoginData.accessToken = ""
			_G.LoginData.sign = ""
			_G.LoginData.equipmentList = nil
			_G.LoginData.roleList = {}
		end
		if _G.ReconnectManager then
			if _G.ReconnectManager.autoReconnect then
				pcall(function() Timer.Stop(_G.ReconnectManager.autoReconnect) end)
				_G.ReconnectManager.autoReconnect = nil
			end
			if _G.ReconnectManager.autoClose then
				pcall(function() Timer.Stop(_G.ReconnectManager.autoClose) end)
				_G.ReconnectManager.autoClose = nil
			end
		end
	end)

	-- 9. Ẩn các UI trong game / chọn nhân vật / màn hình loading kẹt để về sạch màn hình Login
	pcall(function()
		if _G.UIManager then
			if _G.UIID then
				if _G.UIID.MainMenuUI then _G.UIManager.Hide(_G.UIID.MainMenuUI) end
				if _G.UIID.LoginCreateRoleUI then _G.UIManager.Hide(_G.UIID.LoginCreateRoleUI) end
				if _G.UIID.LoginRoleUI then _G.UIManager.Hide(_G.UIID.LoginRoleUI) end
				if _G.UIID.LoadingUI then _G.UIManager.Hide(_G.UIID.LoadingUI) end
				if _G.UIID.WaitingUI then _G.UIManager.Hide(_G.UIID.WaitingUI) end
			end
			_G.UIManager.Hide("Main_MainMenuUI")
			_G.UIManager.Hide("Login_LoginRoleUI")
			_G.UIManager.Hide("Login_LoginCreateRoleUI")
			_G.UIManager.Hide("Loading_LoadingUI")
		end
	end)
	SaveOutput()
end
_E.ForceLogoutToLogin = ForceLogoutToLogin
_G.ForceLogoutToLogin = ForceLogoutToLogin

local ModRoleNamePrefixes = {
	"Rex", "Leo", "Kai", "Ken", "Zin", "Max", "Vut", "Roy", "Ben", "Sam", "Tom", "Zen", "Lux", "Fox", "Dan", "Jin",
	"Jay", "Ron", "Ace", "Neo", "Sky", "Ray", "Taj", "Kev", "Ian", "Eli", "Guy", "Lee", "Ted", "Val", "Zak"
}

local function GenerateUniqueRoleNameSafe()
	local realTime = 0
	pcall(function() realTime = CS.UnityEngine.Time.realtimeSinceStartup end)
	local seed = os.time() + math.floor(realTime * 1000)
	math.randomseed(seed)
	local p = ModRoleNamePrefixes[math.random(1, #ModRoleNamePrefixes)]
	local t = (os.time() + math.random(1, 999)) % 46656
	local b36 = "0123456789abcdefghijklmnopqrstuvwxyz"
	local s = ""
	for _ = 1, 3 do
		local rem = t % 36
		s = string.sub(b36, rem + 1, rem + 1) .. s
		t = math.floor(t / 36)
	end
	return p .. s
end

CreateRoleAndEnterGame = function(targetIdx)
	targetIdx = tonumber(targetIdx) or 1
	if _G.IsRoleCreating or _G.HasCreatedRoleForTarget then
		Log(string.format("-> [BỎ QUA] Đang hoặc đã hoàn thành tạo nhân vật cho slot [%d]...", targetIdx))
		return
	end
	_G.IsRoleCreating = true
	_G.HasCreatedRoleForTarget = true

	local newName = GenerateUniqueRoleNameSafe()
	local targetCareer = 12 -- Pháp Sư (Dark Wizard - DW)
	local careerName = "Pháp Sư (Dark Wizard - DW)"
	local targetSex = 1

	Log("=========================================================================")
	Log(string.format(">>> [TẠO NHÂN VẬT] PHÁT HIỆN SLOT [%d/4] CHƯA CÓ NHÂN VẬT! <<<", targetIdx))
	Log(string.format(">>> ĐANG TẠO MỚI NHÂN VẬT: Tên = %s | Hệ = %s <<<", newName, careerName))
	Log("=========================================================================")
	SaveOutput()

	-- 1. Lắng nghe event tạo nhân vật thành công từ Server (KHÔNG gửi lại ReqGetRoleList tránh load đè Scene/createrole.unity)
	if _G.TestEventContainer then
		_G.TestEventContainer:Regist(Event.Login_CreateRole, function()
			Log("[EVENT] Login_CreateRole -> TẠO NHÂN VẬT THÀNH CÔNG!")
			SaveOutput()
			_G.IsRoleCreating = false
			Timer.Start(1.2, function()
				local curMapId = tonumber(_G.SceneData and _G.SceneData.mapId or 0) or 0
				if _G.Bot_IsInGameWorld or (_G.LoginData and _G.LoginData.InGame) or curMapId > 0 then
					return
				end
				local roles = (_G.LoginData and _G.LoginData.roleList) or {}
				Log(string.format("-> Danh sách nhân vật sau khi tạo: %d nhân vật. Tiến hành chọn nhân vật %d...", #roles, targetIdx))
				SelectRoleByIndex(targetIdx)
			end)
		end)
	end

	if _G.LoginData then
		_G.LoginData.playerCreateName = newName
	end

	local createUI = nil
	pcall(function()
		if _G.UIManager and _G.UIManager.GetUiByName then
			createUI = _G.UIManager.GetUiByName("Login_LoginCreateRoleUI")
		end
	end)

	local usedCreateUI = false
	if createUI then
		pcall(function()
			if createUI.root and createUI.root.gameObject and createUI.root.gameObject.activeInHierarchy then
				if createUI.SelectCareer then createUI:SelectCareer(targetCareer) end
				if createUI.tog_magic and createUI.tog_magic.SetIsOn then createUI.tog_magic:SetIsOn(true) end
				if createUI.InputField_Name and createUI.InputField_Name.SetInputText then
					createUI.InputField_Name:SetInputText(newName)
				end
				if createUI.Button_OkOnClick then
					Log("-> Kích hoạt Button_OkOnClick trên giao diện LoginCreateRoleUI...", true)
					createUI:Button_OkOnClick()
					usedCreateUI = true
				end
			end
		end)
	end

	if not usedCreateUI then
		Log("-> Gửi gói tin ReqCreateRole trực tiếp tới server...", true)
		pcall(function()
			if _G.networkRequest and _G.networkRequest.ReqCreateRole then
				_G.networkRequest.ReqCreateRole(newName, targetSex, targetCareer)
			elseif _G.NetManager and _G.NetManager.Send and _G.UserMessage and _G.UserMessage.ReqCreateRole then
				_G.NetManager.Send(_G.UserMessage.ReqCreateRole, { roleName = newName, sex = targetSex, career = targetCareer })
			end
		end)
	end

	-- Bộ đệm an toàn tự động thử lại sau 6 giây nếu chưa có phản hồi
	Timer.Start(6.0, function()
		local curMapId = tonumber(_G.SceneData and _G.SceneData.mapId or 0) or 0
		if _G.Bot_IsInGameWorld or (_G.LoginData and _G.LoginData.InGame) or curMapId > 0 then return end
		local roles = (_G.LoginData and _G.LoginData.roleList) or {}
		if #roles == 0 then
			_G.IsRoleCreating = false
			_G.HasCreatedRoleForTarget = false
			Log("-> [RETRY]: Sau 6s chưa thấy phản hồi tạo nhân vật, tự động thử lại...", true)
			CreateRoleAndEnterGame(targetIdx)
		else
			_G.IsRoleCreating = false
			SelectRoleByIndex(targetIdx)
		end
	end)
end
_E.CreateRoleAndEnterGame = CreateRoleAndEnterGame
_G.CreateRoleAndEnterGame = CreateRoleAndEnterGame

SelectRoleByIndex = function(targetIdx)
	local curMapId = tonumber(_G.SceneData and _G.SceneData.mapId or 0) or 0
	if _G.Bot_IsInGameWorld or (_G.LoginData and _G.LoginData.InGame) or curMapId > 0 then
		return
	end

	local roles = (_G.LoginData and _G.LoginData.roleList) or {}
	targetIdx = tonumber(targetIdx) or 1
	if targetIdx < 1 then targetIdx = 1 end

	if not roles or #roles == 0 then
		Log("-> [TÀI KHOẢN MỚI]: Chưa có nhân vật nào trên máy chủ này (#roles == 0) -> Tự động tạo mới nhân vật ở Slot 1!", true)
		CreateRoleAndEnterGame(1)
		return
	end

	if targetIdx > #roles then
		if not _G.HasCreatedRoleForTarget then
			Log(string.format("Tài khoản hiện có %d nhân vật. Slot [%d] chưa có -> Bắt đầu tạo mới nhân vật!", #roles, targetIdx))
			CreateRoleAndEnterGame(targetIdx)
		else
			Log(string.format("-> [ĐANG ĐỒNG BỘ] Đang chờ server nạp slot [%d] (Hiện có: %d)...", targetIdx, #roles))
			Timer.Start(1.0, function()
				SelectRoleByIndex(targetIdx)
			end)
		end
		return
	end

	_G.IsRoleCreating = false
	local targetRole = roles[targetIdx]
	local info = targetRole.info or targetRole.data or targetRole
	local roleId = tonumber(info.roleId or info.id or targetRole.roleId or targetRole.id)
	local roleName = tostring(info.name or info.roleName or targetRole.name or ("Role_" .. targetIdx))
	local roleLevel = tonumber(info.level or info.roleLevel or targetRole.level or 1)
	local createTime = tonumber(info.createTime or targetRole.createTime or 1)

	_G.ActiveRoleIndex = targetIdx
	if _G.GetCurrentRoleConfig then
		pcall(function() _G.ActiveRoleConfig = _G.GetCurrentRoleConfig(targetIdx, roleName) end)
	end
	_G.ActiveRoleConfig = _G.ActiveRoleConfig or { maxChestBatches = 3, keepGoodLines = true }

	Log("=========================================================================")
	Log(string.format(">>> ĐANG CHỌN NHÂN VẬT [%d/%d] TRÊN PEDESTAL: %s (ID: %s | Level: %s) <<<",
		targetIdx, #roles, tostring(roleName), tostring(roleId), tostring(roleLevel)))
	Log("=========================================================================")
	SaveOutput()

	if _G.LoginData then
		_G.LoginData.roleId = roleId
		_G.LoginData.roleName = roleName
		_G.LoginData.roleLevel = roleLevel
		_G.LoginData.createTime = createTime
		_G.LoginData.InGame = false
	end

	pcall(function()
		local curRoleUI = _G.UIManager and _G.UIManager.GetUiByName and _G.UIManager.GetUiByName("Login_LoginRoleUI")
		if curRoleUI then
			curRoleUI.loadingPanelIsLoaded = true
			if curRoleUI.RoleModelInfoTbl and curRoleUI.RoleModelInfoTbl[targetIdx] then
				curRoleUI.curRole = curRoleUI.RoleModelInfoTbl[targetIdx]
				if curRoleUI.ShowSelectEffect then curRoleUI:ShowSelectEffect() end
				if curRoleUI.ShowDeleteBtn then curRoleUI:ShowDeleteBtn() end
				if curRoleUI.ShowRoleState then curRoleUI:ShowRoleState() end
			end
		end
	end)

	Timer.Start(DELAY or 1.0, function()
		local mapNow = tonumber(_G.SceneData and _G.SceneData.mapId or 0) or 0
		if _G.Bot_IsInGameWorld or (_G.LoginData and _G.LoginData.InGame) or mapNow > 0 then
			return
		end
		Log(string.format("-> GỬI LỆNH ReqChooseRole: roleId = %s (Tên: %s)...", tostring(roleId), tostring(roleName)))
		SaveOutput()
		if _G.networkRequest and _G.networkRequest.ReqChooseRole then
			_G.networkRequest.ReqChooseRole(roleId)
		elseif _G.NetManager and _G.NetManager.Send and _G.UserMessage and _G.UserMessage.ReqChooseRole then
			_G.NetManager.Send(_G.UserMessage.ReqChooseRole, { roleId = roleId })
		end
	end)
end
_E.SelectRoleByIndex = SelectRoleByIndex
_G.SelectRoleByIndex = SelectRoleByIndex

_G.LoginCurrentSelectedAccount = function()
	local totalAccs = (_G.BotAccounts and #_G.BotAccounts) or 1
	local curAccIdx = _G.CurrentAccountIndex or 1
	local targetAcc = (_G.BotAccounts and _G.BotAccounts[curAccIdx]) or (GetCurrentAccount and GetCurrentAccount()) or {}
	local email = targetAcc.account or "Unknown"
	local targetSrv = tonumber(_G.TARGET_SERVER_ID or targetAcc.targetServer or CS.UnityEngine.PlayerPrefs.GetInt("Mod_Farm_TargetServer", 492)) or 492

	_G.Bot_ActiveSessionEmail = tostring(email)
	_G.Bot_ActiveSessionServer = targetSrv
	_G.Bot_NeedReloginNewConfig = false
	_G.Bot_Under80LagTaskKey = nil
	_G.Bot_Under80LagStartTime = nil
	if _G.Mod_UpdateServerStatusUI then pcall(_G.Mod_UpdateServerStatusUI) end

	_G.CurrentRoleIndex = 1
	_G.TargetRoleIndex = 1
	_G.HasCreatedRoleForTarget = false
	_G.IsRoleCreating = false
	_G.Bot_IsInGameWorld = false
	_G.IsSwitchingAccount = false

	ForceLogoutToLogin()
	Timer.Start(2.5, function()
		_G.IsSwitchingAccount = false
		DismissBlockers()
		StartFullLoginProcess()
	end)
end

local function FormatRemainMMSS(sec)
	sec = math.max(0, math.floor(tonumber(sec) or 0))
	return string.format("%02d:%02d", math.floor(sec / 60), sec % 60)
end

local function ScanQueenGraveRemainSec()
	EnsureGraveManagerHook()
	local bestRemain = nil
	pcall(function()
		local srvMs = (_G.Time and _G.Time.GetServerTime and _G.Time.GetServerTime()) or 0
		if _G.GraveManager and _G.GraveManager.graveList then
			for _, grave in pairs(_G.GraveManager.graveList) do
				if grave then
					local gData = grave.data
					if gData and gData.reliveTime and srvMs > 0 then
						local diffSec = math.ceil((tonumber(gData.reliveTime) - tonumber(srvMs)) / 1000)
						if diffSec > 0 and diffSec <= 300 then
							if not bestRemain or diffSec < bestRemain then
								bestRemain = diffSec
							end
						end
					end
					if not bestRemain and grave.Head and grave.Head.nameLabel and grave.Head.nameLabel.text then
						local txt = tostring(grave.Head.nameLabel.text or "")
						local m, s = string.match(txt, "(%d+)%s*:%s*(%d+)")
						if m and s then
							local parsed = (tonumber(m) or 0) * 60 + (tonumber(s) or 0)
							if parsed > 0 and parsed <= 300 then
								bestRemain = parsed
							end
						end
					end
				end
			end
		end
		-- Fallback từ gói CreatGrave mới nhất (nếu vừa xuất hiện trong vòng 10s)
		if not bestRemain and _G.Mod_LastGraveReliveTimeMs and _G.Mod_LastGraveReliveTimeMs > 0 and srvMs > 0 then
			if (GetNowSec() - (_G.Mod_LastGraveSeenAtSec or 0)) <= 10 then
				local diffSec = math.ceil((_G.Mod_LastGraveReliveTimeMs - tonumber(srvMs)) / 1000)
				if diffSec > 0 and diffSec <= 300 then
					bestRemain = diffSec
				end
			end
		end
	end)
	return bestRemain
end
_G.ScanQueenGraveRemainSec = ScanQueenGraveRemainSec

local function GetConfiguredQueenDelaySec()
	local d = tonumber(_G.Mod_QueenDelaySec)
	if not d or d <= 0 then
		pcall(function()
			d = tonumber(CS.UnityEngine.PlayerPrefs.GetInt("Mod_Farm_QueenDelaySec_v2", 20))
		end)
	end
	d = tonumber(d) or 20
	if d < 1 then d = 20 end
	return d
end
_G.GetConfiguredQueenDelaySec = GetConfiguredQueenDelaySec

local function ExitQueenAndGoFarmSpot(waitSec)
	_G.Bot_LastQueenFarmTeleTime = -10
	local myLvl = GetAccuratePlayerLevel()
	local myDef = (GetPlayerMonsterDefense and GetPlayerMonsterDefense()) or 0
	local bestPt, targetMap = GetBestMonsterFarmPoint(0, false)
	local remainWait = math.max(1, math.floor(tonumber(waitSec) or GetConfiguredQueenDelaySec()))
	if bestPt and targetMap then
		Log(string.format("[Farm NH] Thoát phòng Nữ Hoàng -> Bay ra bãi farm tối ưu (Lv %d | Thủ %d): Map %d (%s) train %ds (%s) rồi bay lên kiểm tra lại!",
			myLvl, myDef, tonumber(targetMap) or 0, tostring(bestPt.name or ""), remainWait, FormatRemainMMSS(remainWait)), true)
	else
		Log(string.format("[Farm NH] Thoát phó bản -> Bay ra bãi farm quái trong %ds (%s) rồi bay lên kiểm tra Nữ Hoàng...",
			remainWait, FormatRemainMMSS(remainWait)), true)
	end
	SaveOutput()

	local wasInInstance = false
	pcall(function()
		local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0
		if (_G.TranScriptData and _G.TranScriptData.InTranscript) or curMap == 2101000 or curMap == 2101001 then
			wasInInstance = true
			if _G.TranScriptController and _G.TranScriptController.ReqExitInstance then
				_G.TranScriptController.ReqExitInstance()
			elseif _G.networkRequest and _G.networkRequest.ReqExitInstance then
				_G.networkRequest.ReqExitInstance()
			end
		end
	end)

	if not wasInInstance and bestPt and targetMap then
		TeleportToQueenFarmSpot(bestPt, targetMap)
	elseif wasInInstance and Timer and Timer.Start then
		Timer.Start(0.75, function()
			local bPt, tMap = GetBestMonsterFarmPoint(0, false)
			if bPt and tMap then
				TeleportToQueenFarmSpot(bPt, tMap)
			end
		end)
	end
end
_G.ExitQueenAndGoFarmSpot = ExitQueenAndGoFarmSpot

local function TickFarmBetweenQueenRuns(farmKcStateTime, remainWaitSec)
	pcall(function()
		if VacuumAllMapDropItems then VacuumAllMapDropItems() end
		local t = tonumber(farmKcStateTime) or 0
		local remSec = tonumber(remainWaitSec) or GetConfiguredQueenDelaySec()

		-- Đảm bảo vòng lặp nâng cấp 30s luôn hoạt động xuyên suốt khi đang Farm Nữ Hoàng
		if not _G.Global30sUpgradeTimer and StartGlobal30sUpgradePipeline then
			StartGlobal30sUpgradePipeline()
		end
		local nowTime = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
		if (nowTime - (_G.LastPeriodicUpgradeCycleTime or 0)) >= 30.0 and _G.RunPeriodicUpgradeCycle then
			_G.RunPeriodicUpgradeCycle()
		elseif t >= 1.2 and t < 1.8 then
			-- Ngay khi vừa hạ gục Nữ Hoàng và bay ra bãi farm: Cộng điểm + mặc đồ xịn vừa rớt ngay
			if AutoAddAttributePoints then AutoAddAttributePoints() end
			if _G.Mod_AutoEquipBetterItems then _G.Mod_AutoEquipBetterItems() end
		end

		-- Trước khi hết thời gian Delay Nữ Hoàng 0.8s: Tắt HookAutoFight ngoài bãi để bay lên phòng khóa mục tiêu Boss mượt mà
		if remSec <= 0.8 then
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
		if curMap == 2101000 or curMap == 2101001 or (_G.TranScriptData and _G.TranScriptData.InTranscript) then
			if t >= 1.0 then
				if _G.TranScriptController and _G.TranScriptController.ReqExitInstance then
					_G.TranScriptController.ReqExitInstance()
				elseif _G.networkRequest and _G.networkRequest.ReqExitInstance then
					_G.networkRequest.ReqExitInstance()
				end
			end
			return
		end

		local bestPt, targetMap = GetBestMonsterFarmPoint(0, false)
		if not bestPt or not targetMap or targetMap <= 0 then return end

		local curLine = tonumber((_G.SceneData and (_G.SceneData.line or _G.SceneData.cline or _G.SceneData.lineIndex)) or 1) or 1
		local targetLine = tonumber(bestPt.line) or curLine or 1

		local me = _G.RoleManager and _G.RoleManager.me
		local pos = (me and me.cellPos) or (me and me.serverCoord)
		local dist = 999
		if curMap == targetMap and pos and pos.x and pos.y then
			dist = math.sqrt((tonumber(pos.x) - bestPt.x)^2 + (tonumber(pos.y) - bestPt.y)^2)
		end

		if curMap ~= targetMap or curLine ~= targetLine or dist > 10 then
			if t >= 0.6 and (t - (_G.Bot_LastQueenFarmTeleTime or -10)) >= 1.5 then
				if TeleportToQueenFarmSpot(bestPt, targetMap) then
					_G.Bot_LastQueenFarmTeleTime = t
				end
			end
		else
			-- Từ Lv 145+: Nếu phát hiện người chơi khác trong phạm vi <= 2 ô tại tâm bãi thì xoay sang bãi/kênh tiếp theo
			if _G.CheckAndRotateSpotIfPlayerNearby and _G.CheckAndRotateSpotIfPlayerNearby(bestPt, targetMap) then
				_G.Bot_LastQueenFarmTeleTime = t
				return
			end
			-- Đã đứng tại bãi farm tối ưu: Bật AutoFight đánh quái (chỉ bật nếu chưa đánh để không ngắt chiêu)
			EnsureAutoFightBossOnce()
			if _G.QiJiHelperData and not _G.QiJiHelperData.isAutoFight and _G.QiJiHelperData.SetAutoFightData then
				_G.QiJiHelperData.SetAutoFightData(true)
			end
		end
	end)
end
_G.TickFarmBetweenQueenRuns = TickFarmBetweenQueenRuns

-- =========================================================================
-- [MOD FEATURE]: VÒNG LẶP AUTO FARM NỮ HOÀNG TÂN THỦ THEO DELAY KIỂM TRA (MOD_QUEENDELAYSEC)
-- Mô tả:
--   - Vào phòng Nữ Hoàng (2101000) kiểm tra:
--     + Nếu có Nữ Hoàng sống -> Tiêu diệt -> Chờ 2.0s hút đồ -> Ra bãi quái tối ưu train đúng Delay Nữ Hoàng giây -> Lên kiểm tra tiếp.
--     + Nếu phòng trống (chỉ có bia mộ): Nếu bia mộ còn <= 5s thì đứng đợi đánh luôn; nếu > 5s thì ra bãi quái tối ưu train Delay Nữ Hoàng giây rồi lên kiểm tra lại.
-- =========================================================================
local farmKcTimer = nil
local farmKcState = "IDLE"
local farmKcStateTime = 0
local farmKcActiveBoss = nil

local function StopFarmKCRoutine()
	_G.Mod_FarmKCRunning = false
	farmKcState = "IDLE"
	farmKcActiveBoss = nil
	if farmKcTimer then
		pcall(function() Timer.Stop(farmKcTimer) end)
		farmKcTimer = nil
	end
	Log("[Farm NH] Đã dừng chu trình Auto Farm Nữ Hoàng.", true)
	SaveOutput()
end
_G.StopFarmKCRoutine = StopFarmKCRoutine

local function TransitionToFarmDelayAfterQueen()
	local delaySec = GetConfiguredQueenDelaySec()
	ExitQueenAndGoFarmSpot(delaySec)
	farmKcState = "FARM_WAIT_RESPAWN"
	farmKcStateTime = 0
end

local function FarmKCStepLoop()
	if not _G.Mod_FarmKCActive or not _G.Mod_FarmKCRunning then
		StopFarmKCRoutine()
		return
	end
	if _G.Mod_IsRunningInstance then
		return
	end

	-- Kiểm tra nếu đã đạt cấp độ mục tiêu (Target Level lấy chuẩn từ cấu hình UI PlayerPrefs) thì bàn giao về luồng chính để chuyển acc
	local myLvl = GetAccuratePlayerLevel()
	local targetLvl = GetConfiguredTargetLevel()
	local stopQueenLvl = GetConfiguredStopQueenLevel()
	if _G.CheckAndAutoBuyLearnSkills then
		_G.CheckAndAutoBuyLearnSkills(myLvl)
	end
	if _G.Bot_Running and myLvl >= targetLvl then
		Log(string.format("[Farm NH] Nhân vật đã đạt cấp mục tiêu (%d/%d) -> Dừng Farm NH để chuyển tài khoản!", myLvl, targetLvl), true)
		_G.Mod_FarmKCActive = false
		if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
		if _G.SyncFarmNHBtnUI then pcall(_G.SyncFarmNHBtnUI) end
		StopFarmKCRoutine()
		if _G.OnAccountReachLevelGoal then
			_G.OnAccountReachLevelGoal(myLvl, targetLvl)
		end
		return
	end
	-- Kiểm tra cấu hình `Lv Bỏ NH`: Khi đạt `myLvl >= stopQueenLvl`, lập tức ngắt Farm Nữ Hoàng để chuyển sang chu trình Farm & HL/QTQ
	if _G.Bot_Running and myLvl >= stopQueenLvl then
		Log(string.format("[Farm NH] Nhân vật đã đạt Lv Bỏ NH (%d/%d) -> Dừng Farm Nữ Hoàng, chuyển sang chu trình Farm & Phó bản HL/QTQ!", myLvl, stopQueenLvl), true)
		SaveOutput()
		_G.Mod_FarmKCActive = false
		if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
		if _G.SyncFarmNHBtnUI then pcall(_G.SyncFarmNHBtnUI) end
		StopFarmKCRoutine()
		ExitQueenAndGoFarmSpot(0)
		return
	end

	-- Kiểm tra nếu game bị lag/vào lại khiến nhiệm vụ Nữ Hoàng Tân Thủ (3103) hết lag và quay lại trạng thái Hoàn Thành (state == 2)
	-- -> Đánh dấu FAILED và skip tài khoản ngay!
	if _G.Bot_Running and _G.GetQueenBranchTaskInfo then
		local qTask, _, qState = _G.GetQueenBranchTaskInfo()
		if qTask ~= nil and qState == 2 then
			Log("[Farm NH] Phát hiện NV Nữ Hoàng Tân Thủ (3103) hết lag quay về Hoàn Thành (state=2) -> Đánh dấu FAILED và skip tài khoản!", true)
			SaveOutput()
			_G.Mod_FarmKCActive = false
			if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
			StopFarmKCRoutine()
			if _G.OnAccountFailedAndSkip then
				_G.OnAccountFailedAndSkip("Game lag/vào lại làm NV Nữ Hoàng Tân Thủ quay về Hoàn Thành")
			end
			return
		end
	end

	local dt = 0.25
	farmKcStateTime = farmKcStateTime + dt
	local curMap = tonumber((_G.SceneData and _G.SceneData.mapId) or 0) or 0

	if farmKcState == "INIT" then
		-- Nếu đang đứng sẵn trong phòng Nữ Hoàng Tân Thủ (2101000) ngay sau khi Bug xong:
		if curMap == 2101000 then
			local boss = _G.FindBossNuHoangBangGia and _G.FindBossNuHoangBangGia()
			if boss and boss.hp and boss.hp > 0 then
				farmKcActiveBoss = boss
				farmKcState = "FIGHTING"
				farmKcStateTime = 0
				EnsureAutoFightBossOnce()
				return
			else
				TransitionToFarmDelayAfterQueen()
				return
			end
		end

		farmKcState = "WAIT_MAP"
		farmKcStateTime = 0
		if _G.DoEnterSecretRoom then _G.DoEnterSecretRoom() end

	elseif farmKcState == "WAIT_MAP" then
		if curMap == 2101000 then
			farmKcState = "CHECK_BOSS"
			farmKcStateTime = 0
		elseif farmKcStateTime >= 6.0 then
			Log("[Farm NH] Quá 6s chưa vào được Map 2101000 -> Gửi lại lệnh tiến vào Mật Thất Nữ Hoàng...", true)
			farmKcStateTime = 0
			if _G.DoEnterSecretRoom then _G.DoEnterSecretRoom() end
		end

	elseif farmKcState == "CHECK_BOSS" then
		local boss = _G.FindBossNuHoangBangGia and _G.FindBossNuHoangBangGia()
		if boss and boss.hp and boss.hp > 0 then
			_G.Mod_FarmKCCount = (_G.Mod_FarmKCCount or 0) + 1
			if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
			Log(string.format("[Farm NH] Đã tìm thấy %s (HP: %s) -> Bắt đầu tiêu diệt (Lượt #%d)!",
				tostring(boss.name or "Nữ Hoàng Băng Giá"), tostring(boss.hp), _G.Mod_FarmKCCount), true)
			SaveOutput()
			farmKcActiveBoss = boss
			farmKcState = "FIGHTING"
			farmKcStateTime = 0
			EnsureAutoFightBossOnce()
		elseif farmKcStateTime >= 2.2 then
			local graveSec = ScanQueenGraveRemainSec()
			-- Nếu bia mộ chỉ còn <= 5s nữa là hồi sinh: Đứng chờ luôn trong phòng để Boss hiện ra đánh ngay!
			if graveSec and graveSec > 0 and graveSec <= 5 and farmKcStateTime < 8.0 then
				return
			end
			TransitionToFarmDelayAfterQueen()
		end

	elseif farmKcState == "FIGHTING" then
		if curMap ~= 2101000 then
			farmKcState = "WAIT_MAP"
			farmKcStateTime = 0
			if _G.DoEnterSecretRoom then _G.DoEnterSecretRoom() end
			return
		end
		local isAlive = false
		local curBoss = _G.FindBossNuHoangBangGia and _G.FindBossNuHoangBangGia()
		if curBoss and curBoss.hp and curBoss.hp > 0 then
			isAlive = true
			farmKcActiveBoss = curBoss
		elseif farmKcActiveBoss then
			pcall(function()
				if farmKcActiveBoss.hp and farmKcActiveBoss.hp > 0 and not farmKcActiveBoss.isDead then
					isAlive = true
				end
			end)
		end

		if isAlive then
			EnsureAutoFightBossOnce()
		else
			Log("[Farm NH] Đã tiêu diệt Nữ Hoàng Tân Thủ! Chờ 2.0s hút sạch KC & vật phẩm...", true)
			SaveOutput()
			if VacuumAllMapDropItems then VacuumAllMapDropItems() end
			farmKcState = "LOOTING"
			farmKcStateTime = 0
		end

	elseif farmKcState == "LOOTING" then
		if VacuumAllMapDropItems then VacuumAllMapDropItems() end
		if farmKcStateTime >= 2.0 then
			TransitionToFarmDelayAfterQueen()
		end

	elseif farmKcState == "FARM_WAIT_RESPAWN" then
		local delaySec = GetConfiguredQueenDelaySec()
		local remainSec = math.max(0, delaySec - farmKcStateTime)
		TickFarmBetweenQueenRuns(farmKcStateTime, remainSec)

		if remainSec <= 0 then
			Log(string.format("[Farm NH] Đã train bãi quái đủ %ds (Delay Nữ Hoàng) -> Bay lên Mật Thất Nữ Hoàng Tân Thủ kiểm tra!",
				delaySec), true)
			SaveOutput()
			farmKcState = "WAIT_MAP"
			farmKcStateTime = 0
			if _G.DoEnterSecretRoom then _G.DoEnterSecretRoom() end
		end
	end
end

local function StartFarmKCRoutine()
	if _G.Mod_FarmKCRunning then return end
	_G.Mod_FarmKCRunning = true
	farmKcState = "INIT"
	farmKcStateTime = 0
	farmKcActiveBoss = nil
	if farmKcTimer then
		pcall(function() Timer.Stop(farmKcTimer) end)
		farmKcTimer = nil
	end
	Log("=========================================================================", true)
	Log(string.format("[Farm NH] BẮT ĐẦU CHU TRÌNH AUTO FARM NỮ HOÀNG TÂN THỦ (DELAY KIỂM TRA: %ds)!", GetConfiguredQueenDelaySec()), true)
	Log("=========================================================================", true)
	SaveOutput()
	farmKcTimer = Timer.StartLoop(0.25, -1, FarmKCStepLoop)
end
_G.StartFarmKCRoutine = StartFarmKCRoutine
_E.StartFarmKCRoutine = StartFarmKCRoutine
_E.StopFarmKCRoutine = StopFarmKCRoutine

local function CheckAndRunQueenBossBugLv80(curLvl, targetLvl)
	local stopQueenLvl = GetConfiguredStopQueenLevel()
	if (tonumber(curLvl) or 0) >= stopQueenLvl then
		if _G.Mod_FarmKCActive or _G.Mod_FarmKCRunning then
			_G.Mod_FarmKCActive = false
			if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
			if _G.SyncFarmNHBtnUI then pcall(_G.SyncFarmNHBtnUI) end
			StopFarmKCRoutine()
		end
		return false
	end
	if not _G.Mod_BugQuestActive or _G.Bot_QueenBugUnavailable or (tonumber(curLvl) or 0) < 80 then
		return false
	end

	if _G.CheckAndAutoBuyLearnSkills then _G.CheckAndAutoBuyLearnSkills(curLvl) end

	local qTask, qTaskId, qState = nil, nil, nil
	if _G.GetQueenBranchTaskInfo then
		qTask, qTaskId, qState = _G.GetQueenBranchTaskInfo()
	end
	local t50007, id50007, s50007 = GetBountyTask50007Info()
	local t5024, id5024, s5024 = GetWearSetTask5024Info()

	if _G.Bot_QueenBugState == "DONE" then
		-- Nếu game bị lag/vào lại làm nhiệm vụ Nữ Hoàng Tân Thủ (3103) hết lag quay về Hoàn Thành (qState == 2)
		-- -> Tính luôn là FAILED và skip tài khoản đó!
		if qTask ~= nil and qState == 2 then
			Log("=========================================================================", true)
			Log(">>> [BUG NỮ HOÀNG FAILED]: Game lag/vào lại làm NV Nữ Hoàng Tân Thủ (3103) quay về Hoàn Thành (state=2) -> Đánh dấu FAILED và skip acc! <<<", true)
			Log("=========================================================================", true)
			SaveOutput()
			if _G.OnAccountFailedAndSkip then
				_G.OnAccountFailedAndSkip("Game lag/vào lại làm NV Nữ Hoàng Tân Thủ quay về Hoàn Thành")
			end
			return true
		end
		_G.Mod_FarmKCActive = true
		if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
		if not _G.Mod_FarmKCRunning and _G.StartFarmKCRoutine then
			_G.StartFarmKCRoutine()
		end
		return true
	end

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
			_G.Bot_QueenBugHadSucceeded = true
			_G.Bot_QueenBugAttemptCount = 0
			_G.Bot_QueenBugState = "DONE"
			_G.Mod_FarmKCActive = true
			if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
			if _G.StartFarmKCRoutine then _G.StartFarmKCRoutine() end
			return true
		end

		-- Trường hợp game bị lag phải vào lại (hoặc đã dùng hết NV mồi 50007 & 5024) mà NV Nữ Hoàng Tân Thủ (3103)
		-- hết lag quay lại trạng thái Hoàn Thành (qState == 2) -> Tính luôn là FAILED và skip tài khoản!
		local isBait5024Consumed = (t5024 == nil or s5024 == 3)
		local isBait50007Consumed = (t50007 == nil or s50007 == 3)
		if qTask ~= nil and qState == 2 and (_G.Bot_QueenBugHadSucceeded or (_G.Bot_QueenBugAttemptCount or 0) >= 2 or (isBait5024Consumed and isBait50007Consumed)) then
			Log("=========================================================================", true)
			Log(">>> [BUG NỮ HOÀNG FAILED]: NV Nữ Hoàng Tân Thủ (3103) ở trạng thái Hoàn Thành (state=2) sau khi hết lag/vào lại hoặc đã hết NV mồi 5024 -> Đánh dấu FAILED và skip acc! <<<", true)
			Log("=========================================================================", true)
			SaveOutput()
			if _G.OnAccountFailedAndSkip then
				_G.OnAccountFailedAndSkip("NV Nữ Hoàng Tân Thủ quay về Hoàn Thành sau khi lag/vào lại")
			end
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
			if (_G.Mod_FarmKCCount or 0) == 0 then
				_G.Mod_FarmKCCount = 1
				if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
				if _G.SyncFarmNHBtnUI then pcall(_G.SyncFarmNHBtnUI) end
			end
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
					if (_G.Mod_FarmKCCount or 0) == 0 then
						_G.Mod_FarmKCCount = 1
						if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
						if _G.SyncFarmNHBtnUI then pcall(_G.SyncFarmNHBtnUI) end
					end
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
			_G.Bot_QueenBugHadSucceeded = true
			_G.Bot_QueenBugAttemptCount = 0
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

		-- =========================================================================
		-- [MOD FEATURE]: GIỚI HẠN THỬ TỐI ĐA 2 LẦN QUY TRÌNH BUG NỮ HOÀNG TÂN THỦ
		-- Mô tả: Nếu thử 2 lần quy trình bug mà NV Nữ Hoàng Tân Thủ (3103) vẫn Hoàn Thành (không sang Đang Tiến Hành),
		--        tính luôn là failed (log KQ màu đỏ #D93838) và skip acc đó.
		-- =========================================================================
		_G.Bot_QueenBugAttemptCount = tonumber(_G.Bot_QueenBugAttemptCount) or 0
		if _G.Bot_QueenBugAttemptCount >= 2 and (_G.Bot_QueenBugStateTime - (_G.Bot_LastClaim3103AttemptTime or 0)) >= 2.0 then
			if qState ~= 1 then
				_G.Bot_AllowClaimTask3103 = false
				_G.Bot_AllowClaimTask5024 = false
				_G.Bot_AllowClaimTask50007 = false
				if _G.OnAccountFailedAndSkip then
					_G.OnAccountFailedAndSkip("Đã thử 2 lần quy trình bug nhưng NV Nữ Hoàng Tân Thủ vẫn Hoàn Thành")
				end
				return true
			end
		end

		if _G.Bot_QueenBugAttemptCount < 2 and (_G.Bot_QueenBugStateTime - (_G.Bot_LastClaim3103AttemptTime or -10)) >= 2.5 then
			_G.Bot_LastClaim3103AttemptTime = _G.Bot_QueenBugStateTime
			_G.Bot_QueenBugAttemptCount = _G.Bot_QueenBugAttemptCount + 1
			local target3103Id = qTaskId or 3103
			Log("=========================================================================", true)
			Log(string.format(">>> [BƯỚC 4 - BUG BOSS PHÚC LỢI TÂN THỦ (LẦN %d/2)]: Ấn hoàn thành NV Boss Phúc Lợi Tân Thủ (ID %s) theo kiểu gây lag và kiểm tra tính bug... <<<", _G.Bot_QueenBugAttemptCount, tostring(target3103Id)), true)
			Log("=========================================================================", true)
			SaveOutput()

			-- Ở lần thử thứ 2, nếu NV 5024 chưa kịp kẹt lag thì bồi lại mồi lag 5024 trước khi bấm 3103
			if _G.Bot_QueenBugAttemptCount >= 2 and not IsTask5024LagSubmitted() then
				_G.Bot_AllowClaimTask5024 = true
				TriggerLagQuestClaim(5024)
			end
			_G.Bot_AllowClaimTask3103 = true
			TriggerLagQuestClaim(target3103Id)
			if Timer and Timer.Start then
				Timer.Start(0.25, function()
					_G.Bot_AllowClaimTask3103 = false
					_G.Bot_AllowClaimTask5024 = false
				end)
			else
				_G.Bot_AllowClaimTask3103 = false
				_G.Bot_AllowClaimTask5024 = false
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
			-- BẮT BUỘC đợi Map thế giới thực (curSceneMapId > 0) và nhân vật (RoleManager.me) tải xong hoàn toàn
			-- Tuyệt đối không chạy bất kỳ lệnh tìm đường hay train bãi nào khi đang ở Map 0 (màn hình Login/Tạo nhân vật)!
			local curSceneMapId = tonumber(_G.SceneData and _G.SceneData.mapId or 0) or 0
			local me = _G.RoleManager and _G.RoleManager.me
			if curSceneMapId <= 0 or me == nil then
				return
			end
			-- Luôn quét dọn popup và tự động bấm nhận thưởng tức thì (<0.3s, không chờ đếm ngược 5s)
			DismissBlockers()
			local lvl = GetAccuratePlayerLevel()
			local targetLvl = GetConfiguredTargetLevel()
			local stopQueenLvl = GetConfiguredStopQueenLevel()
			-- KIỂM TRA MỤC TIÊU CẤP ĐỘ FARM BOT (THEO CẤU HÌNH MENU MOD, MẶC ĐỊNH LV 200):
			if lvl >= targetLvl then
				_G.OnAccountReachLevelGoal(lvl, targetLvl)
				return
			end
			-- Khi nhân vật đạt `Lv Bỏ NH` (mặc định 145): Ngắt chu trình Farm Nữ Hoàng để chuyển sang chu trình Farm & HL/QTQ
			if _G.Mod_FarmKCActive and lvl >= stopQueenLvl then
				Log(string.format("[Farm NH] Nhân vật đã đạt Lv Bỏ NH (%d/%d) -> Ngắt chu trình Farm Nữ Hoàng, chuyển sang chu trình Farm & HL/QTQ!", lvl, stopQueenLvl), true)
				SaveOutput()
				_G.Mod_FarmKCActive = false
				if _G.UpdateFarmKCBtnUI then pcall(_G.UpdateFarmKCBtnUI) end
				if _G.SyncFarmNHBtnUI then pcall(_G.SyncFarmNHBtnUI) end
				StopFarmKCRoutine()
				if curSceneMapId == 2101000 or curSceneMapId == 2101001 then
					ExitQueenAndGoFarmSpot(0)
					return
				end
			end
			-- ====================================
			-- [MOD FEATURE]: ƯU TIÊN TUYỆT ĐỐI CHẾ ĐỘ FARM KIM CƯƠNG KHI BẬT NÚT FARM KC
			-- Mô tả: Tạm dừng toàn bộ chu trình làm quest chính để tập trung săn Boss Phúc Lợi Tầng 1
			-- ====================================
			if _G.Mod_FarmKCActive then
				if lvl >= 20 and not _G.Global30sUpgradeTimer then
					StartGlobal30sUpgradePipeline()
				end
				local nowT = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
				if lvl >= 20 and (nowT - (_G.LastPeriodicUpgradeCycleTime or 0)) >= 32.0 and _G.RunPeriodicUpgradeCycle then
					_G.RunPeriodicUpgradeCycle()
				end
				if AutoAddAttributePoints then AutoAddAttributePoints() end
				if lvl >= 80 and CheckAndAutoBuyLearnSkills then
					CheckAndAutoBuyLearnSkills(lvl)
				end
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
			if (_G.Mod_AutoBCActive or _G.Mod_AutoDSActive) and lvl >= stopQueenLvl and (loopTickCount % 15 == 1) and not _G.Mod_IsRunningInstance then
				CheckAndRunBloodCastleOrDemonPlaza()
				if _G.Mod_IsRunningInstance then
					return
				end
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

				-- =========================================================================
				-- [MOD FEATURE]: CƠ CHẾ THOÁT CHỦ ĐỘNG NHIỆM VỤ LAG DƯỚI LV 80 (AUTO RELOG SAU 10S)
				-- Mô tả:
				--   - Chỉ hoạt động khi nhân vật ở dưới Lv 80 (lvl < 80) để tuyệt đối không ảnh hưởng
				--     tới quy trình bug Nữ Hoàng Băng Giá tại Lv 80.
				--   - Nhận diện nhiệm vụ bị lag "Đang tiến hành 1/1" (state == 1 nhưng IsTaskGoalFinished == true
				--     hoặc GetTaskGola() == nil) hoặc nhiệm vụ Đối thoại / Hoàn thành bị treo đứng im một chỗ.
				--   - Nếu trạng thái lag kéo dài quá 10 giây (>= 10s), tự động gọi LoginCurrentSelectedAccount()
				--     (y hệt khi bấm nút LOGIN: Clean sạch + Logout + Đăng nhập lại đúng tài khoản hiện tại)
				--     để Server reset trạng thái nhiệm vụ lag về Hoàn thành và chạy tiếp!
				-- =========================================================================
				if lvl < 80 then
					local nowReal = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
					local lagTaskObj = nil
					local lagTaskId = 0
					local lagReason = nil

					-- 1. Kiểm tra trực tiếp curTask (Nhiệm vụ chính tuyến hiện tại)
					if curTask then
						local cId = tonumber(curTask.taskId or (curTask.GetId and curTask:GetId()) or 0) or 0
						local cState = tonumber((curTask.GetState and curTask:GetState()) or curTask.state or 0) or 0
						if cId > 0 and cId ~= 80101 and not IsTaskBlockedFromAutoClaim(cId, curTask) then
							local cType = (curTask.GetTaskTypeID and curTask:GetTaskTypeID()) or curTask.type or 0
							local cGoal = curTask.GetTaskGola and curTask:GetTaskGola()
							local cGType = (cGoal and cGoal.goalTbl and cGoal.goalTbl.type) or 0
							local cName = tostring((curTask.GetName and curTask:GetName()) or "")
							local lowCName = string.lower(cName)
							local isLvlUpTask = (TASK_CONFIG_BY_ID[cId] == TASK_BEHAVIOR.LEVEL_UP)
								or cType == 15 or cGType == 301 or cGType == 3101
								or lowCName:find("cấp đạt") or lowCName:find("cap dat") or lowCName:find("đạt cấp") or lowCName:find("dat cap")
								or lowCName:find("tăng cấp") or lowCName:find("tang cap") or lowCName:find("luyện cấp")
							local isKillTask = (TASK_CONFIG_BY_ID[cId] == TASK_BEHAVIOR.MONSTER_KILL)
								or cGType == 101 or cGType == 103 or cGType == 113
								or lowCName:find("diệt") or lowCName:find("đánh") or cName:find("Diệt") or cName:find("Đánh")

							if cState == 1 and IsTaskGoalFinished(curTask) then
								lagTaskObj = curTask
								lagTaskId = cId
								lagReason = "Đang tiến hành 1/1 (state=1, goal=1/1)"
							elseif cState == 2 or cState == 3 then
								lagTaskObj = curTask
								lagTaskId = cId
								lagReason = "Kẹt trạng thái Hoàn thành chưa trả được (state=" .. tostring(cState) .. ")"
							elseif not isLvlUpTask and not isKillTask then
								local meMoving = false
								pcall(function()
									if me and me.IsMoving and me:IsMoving() then meMoving = true end
								end)
								if not meMoving then
									lagTaskObj = curTask
									lagTaskId = cId
									lagReason = "Đứng im kẹt nhiệm vụ tân thủ (state=" .. tostring(cState) .. ")"
								end
							end
						end
					end

					-- 2. Quét bổ sung trong activeTasks xem có nhiệm vụ nào bị kẹt "Đang tiến hành 1/1" không
					if not lagTaskObj and _G.TaskData.activeTasks then
						for tId, tObj in pairs(_G.TaskData.activeTasks) do
							local numId = tonumber(tId or (tObj and (tObj.taskId or (tObj.GetId and tObj:GetId())))) or 0
							if tObj and numId > 0 and numId ~= 80101 and not IsTaskBlockedFromAutoClaim(numId, tObj) then
								local tState = tonumber((tObj.GetState and tObj:GetState()) or tObj.state or 0) or 0
								if tState == 1 and IsTaskGoalFinished(tObj) then
									lagTaskObj = tObj
									lagTaskId = numId
									lagReason = "ActiveTask Đang tiến hành 1/1 (state=1, goal=1/1)"
									break
								end
							end
						end
					end

					if lagTaskObj and lagTaskId > 0 then
						local lagState = tonumber((lagTaskObj.GetState and lagTaskObj:GetState()) or lagTaskObj.state or 0) or 0
						local lagKey = string.format("%d_%d_%d", lagTaskId, lagState, lvl)
						if _G.Bot_Under80LagTaskKey ~= lagKey then
							_G.Bot_Under80LagTaskKey = lagKey
							_G.Bot_Under80LagStartTime = nowReal
						end

						local stuckSec = nowReal - (_G.Bot_Under80LagStartTime or nowReal)
						-- Trong lúc chờ đủ 10s, nếu là lỗi Đang tiến hành 1/1 thì thử gửi gói ReqSubmitTask (4005) mỗi 2s
						if lagState == 1 and IsTaskGoalFinished(lagTaskObj) and stuckSec >= 2.0 then
							_G.Bot_LastUnder80NudgeTime = _G.Bot_LastUnder80NudgeTime or 0
							if (nowReal - _G.Bot_LastUnder80NudgeTime) >= 2.0 then
								_G.Bot_LastUnder80NudgeTime = nowReal
								pcall(function()
									if _G.networkRequest and _G.networkRequest.ReqSubmitTask then
										_G.networkRequest.ReqSubmitTask(lagTaskId)
									end
									if _G.NetManager and _G.TaskMessage and _G.TaskMessage.ReqSubmitTask then
										_G.NetManager.Send(_G.TaskMessage.ReqSubmitTask, { taskId = lagTaskId, id = lagTaskId })
									end
									if _G.EventManager and _G.Event and _G.Event.Task_BtnSubmitClick then
										_G.EventManager.Dispatch(_G.Event.Task_BtnSubmitClick, lagTaskId)
									end
								end)
							end
						end

						-- Nếu đã treo/lag quá 10 giây -> Thoát chủ động bằng cách gọi thẳng LoginCurrentSelectedAccount() (như nút LOGIN)
						local sinceLastRelog = nowReal - (_G.Bot_LastUnder80RelogTime or -999)
						if stuckSec >= 10.0 and sinceLastRelog >= 20.0 then
							local lagName = tostring((lagTaskObj.GetName and lagTaskObj:GetName()) or ("Task_" .. tostring(lagTaskId)))
							_G.Bot_Under80LagTaskKey = nil
							_G.Bot_Under80LagStartTime = nil
							_G.Bot_LastUnder80RelogTime = nowReal
							Log("=========================================================================", true)
							Log(string.format(">>> [THOÁT CHỦ ĐỘNG NHIỆM VỤ LAG < LV80]: Nhiệm vụ [%d] \"%s\" bị treo %.1fs (%s) tại Lv %d -> Tự động Clean & Relogin lại tài khoản hiện tại (như bấm nút LOGIN)! <<<",
								lagTaskId, lagName, stuckSec, tostring(lagReason), lvl), true)
							Log("=========================================================================", true)
							SaveOutput()
							_G.Bot_Running = true
							_G.Bot_PauseTask = false
							if _G.LoginCurrentSelectedAccount then
								_G.LoginCurrentSelectedAccount()
							else
								ForceLogoutToLogin()
								Timer.Start(2.5, function()
									DismissBlockers()
									StartFullLoginProcess()
								end)
							end
							return
						end
					else
						_G.Bot_Under80LagTaskKey = nil
						_G.Bot_Under80LagStartTime = nil
					end
				else
					_G.Bot_Under80LagTaskKey = nil
					_G.Bot_Under80LagStartTime = nil
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
							if isCS1Task and CanPlayerEnterMap(1009, lvl) then
								_G.Bot_LastCS1TeleTime = _G.Bot_LastCS1TeleTime or 0
								-- [MOD FEATURE]: CHỌN BÃI TỐT NHẤT TRONG TARKAN THEO PHÒNG THỦ HIỆU DỤNG & ĐA KÊNH
								local bestPt, _ = GetBestMonsterFarmPoint(1009, true)
								local targetX = (bestPt and bestPt.x) or 166
								local targetY = (bestPt and bestPt.y) or 196
								local targetLine = tonumber(bestPt and bestPt.line) or (_G.SceneData and _G.SceneData.line) or 1
								local curLine = tonumber((_G.SceneData and (_G.SceneData.line or _G.SceneData.cline or _G.SceneData.lineIndex)) or 1) or 1
								local spotName = (bestPt and bestPt.name) or "Tarkan (Quái Lv195 - EXP x4.0)"
								local defReq = (bestPt and bestPt.defenseReq) or 390
								-- 1. Nếu đang ở sai map (ví dụ Lost Tower 7 do cổng dịch chuyển): Lập tức bay sang Tarkan
								if curSceneMap ~= 1009 and (nowSec - _G.Bot_LastCS1TeleTime >= 3) then
									_G.Bot_LastCS1TeleTime = nowSec
									_G.Bot_CurrentTaskId = taskId
									_G.Bot_LastTaskNavTime = nowSec
									if bestPt and bestPt.tierKey and _G.Mod_TierRotationState and _G.Mod_TierRotationState[bestPt.tierKey] then
										_G.Mod_TierRotationState[bestPt.tierKey].lastTeleTime = (CS and CS.UnityEngine and CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
									end
									Log(string.format("-> [CHUYỂN MAP CS1 TASK %d]: Thủ %d -> ReqCallFlag bay thẳng tới bãi tối ưu Tarkan: %s (Tọa độ: %d#%d Kênh %d | Thủ req: %d) để farm EXP & Sách Đế Vương!",
										taskId, GetPlayerMonsterDefense(), spotName, targetX, targetY, targetLine, defReq), true)
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
										-- Gửi lệnh dịch chuyển có hỗ trợ đổi Kênh (Line)
										SendTeleportWithLine(1009, targetLine, targetX, targetY)
									end)
								elseif curSceneMap == 1009 then
									-- 2. Đã ở Tarkan: Kiểm tra khoảng cách/kênh tới bãi tối ưu, nếu cách xa > 20 ô hoặc lệch kênh thì bay lại
									local pMe = _G.RoleManager and _G.RoleManager.me
									local myPos = (pMe and pMe.cellPos) or (pMe and pMe.serverCoord)
									local isFar = (curLine ~= targetLine)
									if not isFar and myPos and myPos.x and myPos.y then
										local dist = math.sqrt((myPos.x - targetX)^2 + (myPos.y - targetY)^2)
										if dist > 20 then isFar = true end
									end
									if (isFar or isNewTask) and (nowSec - _G.Bot_LastCS1TeleTime >= 6) then
										_G.Bot_LastCS1TeleTime = nowSec
										_G.Bot_CurrentTaskId = taskId
										if bestPt and bestPt.tierKey and _G.Mod_TierRotationState and _G.Mod_TierRotationState[bestPt.tierKey] then
											_G.Mod_TierRotationState[bestPt.tierKey].lastTeleTime = (CS and CS.UnityEngine and CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.time()
										end
										Log(string.format("-> [TARKAN CS1]: Thủ %d -> Bay về bãi tối ưu: %s (Tọa độ: %d#%d Kênh %d | Thủ req: %d)...",
											GetPlayerMonsterDefense(), spotName, targetX, targetY, targetLine, defReq), true)
										SaveOutput()
										SendTeleportWithLine(1009, targetLine, targetX, targetY)
									else
										-- Nếu đã đứng tại bãi Tarkan: Kiểm tra người chơi khác <= 2 ô để xoay bãi/kênh
										if _G.CheckAndRotateSpotIfPlayerNearby and bestPt then
											_G.CheckAndRotateSpotIfPlayerNearby(bestPt, 1009)
										end
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
								-- Nếu là nhiệm vụ ĐỐI THOẠI NPC ở giai đoạn tân thủ (Lv < 20): Tắt AutoFight để tránh kẹt đánh quái không chạy tới NPC
								if behavior == TASK_BEHAVIOR.DIALOGUE and lvl < 20 then
									pcall(function()
										local me = _G.RoleManager and _G.RoleManager.me
										if me and me.SetAutoFight then
											me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.UnAutoFight or "UnAutoFight")
										end
										if me and me.SetAutoHookFight then me:SetAutoHookFight(false) end
										if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then
											_G.QiJiHelperData.SetAutoFightData(false)
										end
									end)
									isFighting = false
								end
								-- Thời gian watchdog chống kẹt: Nhiệm vụ diệt quái chờ 60s, đối thoại NPC chờ 3s (để thử lại ngay nếu lúc mới spawn chưa CanMove)
								local timeoutSec = (behavior == TASK_BEHAVIOR.MONSTER_KILL) and 60 or ((behavior == TASK_BEHAVIOR.DIALOGUE) and 3 or 20)
								local isStuckTooLong = (nowSec - _G.Bot_LastTaskNavTime >= timeoutSec)
								local canRetryNav = (behavior == TASK_BEHAVIOR.DIALOGUE and not isMoving) or (not isMoving and not isFighting)
								-- Kích hoạt tìm đường khi nhận nhiệm vụ mới hoặc bị đứng yên kẹt quá timeoutSec
								if isNewTask or (isStuckTooLong and canRetryNav) then
									_G.Bot_CurrentTaskId = taskId
									_G.Bot_LastTaskNavTime = nowSec
									Log(string.format("-> [ĐIỀU HƯỚNG TASK %s]: Bắt đầu di chuyển tới \"%s\"... ", tostring(taskId), tostring(taskName)), true)
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
					-- KHÔNG CÓ NHIỆM VỤ CHÍNH:
					-- Lưu ý: Ở cấp độ tân thủ (Lv < 20), khi vừa vào game TaskData có thể mất 0.5-1s để đồng bộ từ Server.
					-- TUYỆT ĐỐI KHÔNG tự ý bay đi train bãi hay bật AutoFight khi Lv < 20 để tránh kéo nhân vật đi xa NPC nhiệm vụ đầu tiên!
					local curMap = tonumber(_G.SceneData and _G.SceneData.mapId or 0) or 0
					if curMap > 0 and lvl >= 20 then
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
								local bestPt, targetMap = GetBestMonsterFarmPoint(curMap, false)
								if bestPt and targetMap and _G.CheckAndRotateSpotIfPlayerNearby and _G.CheckAndRotateSpotIfPlayerNearby(bestPt, targetMap) then
									return
								end
								local hasTele = TeleportToBestFarmPoint(curMap)
								if hasTele then
									Log(string.format("[Luyện Cấp] : Chưa có nhiệm vụ mới -> Tự động train bãi tối ưu tại Map %d!", curMap), true)
									SaveOutput()
								end
							end)
						elseif lvl >= 145 and _G.CheckAndRotateSpotIfPlayerNearby then
							pcall(function()
								local bestPt, targetMap = GetBestMonsterFarmPoint(curMap, false)
								if bestPt and targetMap then
									_G.CheckAndRotateSpotIfPlayerNearby(bestPt, targetMap)
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
					elseif curMap > 0 then
						-- Giai đoạn tân thủ Lv < 20 đang chờ gói tin nhiệm vụ đầu tiên: Kích nhẹ AutoTaskManage
						local nowSec = os.time()
						_G.Bot_LastNewbieWaitTaskKick = _G.Bot_LastNewbieWaitTaskKick or 0
						if nowSec - _G.Bot_LastNewbieWaitTaskKick >= 2 then
							_G.Bot_LastNewbieWaitTaskKick = nowSec
							pcall(function()
								if _G.AutoTaskManage then
									if _G.AutoTaskManage.SetAutoTask then _G.AutoTaskManage.SetAutoTask(true) end
									if _G.AutoTaskManage.StartCurAutoTask then _G.AutoTaskManage.StartCurAutoTask(true) end
								end
							end)
						end
					end
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
		-- Tuyệt đối không gửi lại ReqGetRoleList nếu đang trong quá trình tạo nhân vật (IsRoleCreating)
		Timer.Start(3.5, function()
			if not _G.Bot_IsInGameWorld and not (_G.LoginData and _G.LoginData.InGame) and not _G.IsRoleCreating and not _G.HasCreatedRoleForTarget then
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
	if _G.Mod_EnhanceLoopTimer then
		pcall(function() Timer.Stop(_G.Mod_EnhanceLoopTimer) end)
		_G.Mod_EnhanceLoopTimer = nil
	end
	_G.AutoEvenEnhanceRunning = false
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
