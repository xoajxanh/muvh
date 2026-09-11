import os
import sys
sys.stdout.reconfigure(encoding='utf-8')

filePath = r"D:\MUVH\android\mu-decompiled\final\modified_lua_client\EmmyluaDebug.lua"
with open(filePath, "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i in range(10890, 10940):
    print(f"{i+1}: {lines[i]}", end="")
