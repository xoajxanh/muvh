# 🏰 MODULE 7: PHÓ BẢN HUYẾT LÂU & QUẢNG TRƯỜNG QUỶ (DUNGEON HELPER)

## 📌 File Code: [`mod_dungeon_helper.lua`](./mod_dungeon_helper.lua)

Module này chuyên trách việc nhận diện bản đồ phó bản, kiểm tra lịch trình giờ mở cửa, điều kiện vé và lượt, cũng như tự động bấm bỏ qua 30 giây chờ đợi.

---

### 📍 Các Đoạn Code Đã Dùng Trong Mod Nguồn

1. **Dải Map ID Nhận Diện**:
   * *Huyết Lâu (Blood Castle)*: `cMap >= 1012000 and cMap <= 1012099`.
   * *Quảng Trường Quỷ (Demon Plaza)*: `cMap >= 1010000 and cMap <= 1010099`.

2. **Lệnh Bỏ Qua 30s Chờ (`TriggerSkipWait`)**:
   * *Nguồn gốc: `EmmyluaDebug.lua` lines 8954, 9693*:
     ```lua
     _G.networkRequest.ReqSkipWait()
     -- Fallback:
     _G.NetManager.Send(_G.TranScriptMessage.ReqSkipWait, {})
     ```

3. **Kiểm Tra Điều Kiện & Vé Vào Phó Bản**:
   * *Nguồn gốc: `EmmyluaDebug.lua` lines 9880-9905*:
     * Lấy map đích phù hợp cấp độ:
       `enterData = TranScriptData.GetEnterConditionData(subType, condId, maxNumId, curLvl)`
     * Lấy số lượt đi còn lại trong ngày:
       `leftCount = RefreshData.GetInstanceCount(effectId)`
     * Kiểm tra vé trong túi:
       `haveTicket = BagInfoData.GetItemTotalCountByItemId(ticketId)`

4. **Khung Giờ Mở Cửa**:
   * **Giờ lẻ (1h, 3h, 5h, 7h...)**: Huyết Lâu (Blood Castle).
   * **Giờ chẵn (0h, 2h, 4h, 6h...)**: Quảng Trường Quỷ (Demon Plaza).
   * **Phút 00 -> 14**: Cửa phó bản mở, bot ưu tiên vào phó bản trước bãi train.

5. **Mua Vé Huyết Lâu / Quảng Trường Quỷ Bằng 75 Kim Cương Khóa (`cfg_Item_buy.lua`)**:
   * **Vé Huyết Lâu (`Áo Choàng Trong Suốt`)**:
     * Item ID: `8000050` (không khóa) / `8000057` (khóa).
     * Shop `goodId`: **`30107`** | Giá: **`1000050#75`** (75 Kim Cương Khóa).
   * **Vé Quảng Trường Quỷ (`Vé Thông Hành Quảng Trường Quỷ`)**:
     * Item ID: `8000040` (không khóa) / `8000047` (khóa).
     * Shop `goodId`: **`30106`** | Giá: **`1000050#75`** (75 Kim Cương Khóa).
   * **Gửi lệnh mua trực tiếp**:
     ```lua
     _G.networkRequest.ReqBuy(30107, 1) -- Mua Áo Choàng Trong Suốt (HL)
     _G.networkRequest.ReqBuy(30106, 1) -- Mua Vé Thông Hành QTQ
     ```

6. **Cơ Chế Sảnh Chờ 10 Giây Huyết Lâu & Xếp Hàng Solo (`FirstPlayer` Anti-Overlap)**:
   * *Tham chiếu `Instance_GoalUI.lua` lines 140-146, 1114-1126*:
     * Giai đoạn 1 (`BloodCastleStage.INIT == 1`, panel `self.wait`): Đứng ở sảnh chờ **10 giây** (`initWaitTime`), đếm ngược `totalTime = math.floor(self.args.basic.nextStateTime - Time.GetServerTime() / 1000)` trên `lab_prepareTimeValue`. Lúc này nút `[Mở Ngay]` (`btn_rightnow`) **chưa hiển thị**.
     * Giai đoạn 2 (`BloodCastleStage.WAITING == 2`, panel `self.prepare`): Sau 10 giây, nút `[Mở Ngay]` (`btn_rightnow` / `ReqSkipWait`) mới xuất hiện.
     * Giai đoạn 3 (`BloodCastleStage.RUNNING == 3`, panel `self.underway`): Khi bấm `[Mở Ngay]`, phó bản bắt đầu tính điểm đánh quái và đóng sảnh chờ (người vào sau sẽ được xếp sang phòng mới).
   * **Quy tắc xếp hàng nhiều Acc (`FirstPlayer`)**:
     * Ngay khi vào sảnh HL (`0.5s .. 1.0s`), quét người chơi xung quanh (`ModPlayerInfo.GetNearbyPlayers()`).
     * Nếu **không có ai (`#otherPlayers == 0`)**: Đánh dấu `isFirstPlayer = true`, đứng chờ hết 10s `INIT` rồi bấm `[Mở Ngay]` (`ReqSkipWait`) và cắm đầu chạy thẳng lên `14#30` (chỉ khi `dist <= 1.5m` mới bật `AutoFight`).
     * Nếu **thấy có người chơi khác (`#otherPlayers > 0` và chưa phải `isFirstPlayer`)**: Ghi nhớ thời gian đếm ngược còn lại (`nextStateTime - Time.GetServerTime()/1000 + 2s`), lập tức thoát HL (`ReqExitInstance()`, thoát ở sảnh không mất vé/lượt), chờ bên ngoài cho người đầu tiên mở phòng xong rồi mới vào lại.

7. **Hang Động Vàng (Gold Cave - Auto Kim Phiếu)**:
   * **Map ID**: `260001`
   * **Vé vào cổng**: `1000193` (Kim Phiếu)
   * **Boss**: `20220001` (Thần Rồng Vàng)
   * **Vàng rơi**: `1000021` (Vàng Khóa - `Type = 103`, `SL = 50000`)
   * **Lệnh vào hang**: `_G.networkRequest.ReqJoinGoldCaves(1, 1)`
   * **Lệnh thoát phó bản**: `_G.TranScriptController.ReqExitInstance()` (hoặc `_G.NetManager.Send(_G.MapMessage.ReqExitInstance)`)
   * ⚠️ **Bẫy bắt mục tiêu Rồng Vàng**: Không dùng `role:CanSelect()` khi kiểm tra Rồng sống vì 1–2s đầu lúc Rồng đang đáp từ trên trời xuống `CanSelect()` trả về `false` gây trễ. Chỉ kiểm tra `not role.isDead and hp > 0` và tách riêng biến `LastJoinTime` (chỉ chặn khi đứng ngoài map) để vào hang là đánh tức thì ở 0ms.
