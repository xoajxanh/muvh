import os
import sys
import subprocess

if sys.stdout.encoding != 'utf-8':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

PROJECT_DIR = r"D:\MUVH\android\mu-decompiled"
FINAL_DIR = os.path.join(PROJECT_DIR, "final")
DEV_FARM_LUA = os.path.join(FINAL_DIR, "modified_lua_dev_farm", "EmmyluaDebug.lua")
TEST_DIR = os.path.join(FINAL_DIR, "excute_test")
INPUT_TXT = os.path.join(TEST_DIR, "input.txt")
TEMP_LUAC = os.path.join(TEST_DIR, "input.luac")
LUAC_EXE = os.path.join(PROJECT_DIR, "lua53", "luac53.exe")
CONVERT_SCRIPT = os.path.join(PROJECT_DIR, "convert_64_to_32.py")
ADB_EXE = os.path.join(PROJECT_DIR, "adb.exe")
ANDROID_PATH = "/storage/emulated/0/Android/data/com.vnyh.gp/files/input.luac"
DEVICE_ID = "emulator-5554"

def step1_gen_input():
    print("1. Đang sinh file input.txt từ Dev Farm...")
    with open(DEV_FARM_LUA, "r", encoding="utf-8", errors="ignore") as f:
        full_content = f.read()
    
    marker = "-- [MODULE BOT FARM INTEGRATION"
    idx = full_content.find(marker)
    if idx == -1:
        print("LỖI: Không tìm thấy marker", marker)
        sys.exit(1)
    
    body = full_content[idx:]
    with open(INPUT_TXT, "w", encoding="utf-8") as f:
        f.write(body)
    print("-> Đã tạo file input.txt thành công!")

def step2_compile():
    print("2. Đang biên dịch sang Bytecode...")
    cmd = [LUAC_EXE, "-s", "-o", TEMP_LUAC, INPUT_TXT]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        print("LỖI Biên dịch:", res.stderr)
        sys.exit(1)

def step3_convert_32():
    print("3. Chuyển đổi 64-bit sang 32-bit...")
    cmd = [sys.executable, CONVERT_SCRIPT, TEMP_LUAC, TEMP_LUAC]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        print("LỖI Chuyển đổi 32-bit:", res.stderr)
        sys.exit(1)

def step4_patch_header():
    print("4. Patching header...")
    with open(TEMP_LUAC, "rb") as f:
        data = bytearray(f.read())
    
    if data[0:4] == b'\x1bLua':
        data[5] = 0x01
        del data[14]
    
    with open(TEMP_LUAC, "wb") as f:
        f.write(data)
    print("-> Đã patch header Lua 5.3 32-bit thành công!")

def step5_push_adb():
    print("5. Đẩy file input.luac vào thiết bị Android...")
    subprocess.run([ADB_EXE, "-s", DEVICE_ID, "shell", "rm -f /storage/emulated/0/Android/data/com.vnyh.gp/files/output.txt"], capture_output=True)
    cmd = [ADB_EXE, "-s", DEVICE_ID, "push", TEMP_LUAC, ANDROID_PATH]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        print("LỖI ADB Push:", res.stderr)
        sys.exit(1)
    print(res.stdout.strip())
    print("\n=== HOÀN TẤT BUILD & PUSH THÀNH CÔNG 100%! ===")

if __name__ == "__main__":
    step1_gen_input()
    step2_compile()
    step3_convert_32()
    step4_patch_header()
    step5_push_adb()
