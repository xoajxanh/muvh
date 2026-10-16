# -*- coding: utf-8 -*-
import sys
sys.stdout.reconfigure(encoding='utf-8')

fpath = r"D:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"

with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
    for idx, line in enumerate(f, 1):
        if "PlayerPrefs.Get" in line:
            print(f"{idx}: {line.strip()[:100]}")
