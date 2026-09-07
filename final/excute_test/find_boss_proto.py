import os

dir_path = r"d:\MUVH\android\mu-decompiled\final\extracted_lua"
for root, dirs, files in os.walk(dir_path):
    for f in files:
        if f.endswith(".lua"):
            p = os.path.join(root, f)
            with open(p, "r", encoding="utf-8", errors="ignore") as file:
                for i, line in enumerate(file):
                    if "ResGetBossMapAndCount" in line or "ReqGetBossMapAndCount" in line:
                        print(f"{f}:{i+1}: {line.strip()}")
