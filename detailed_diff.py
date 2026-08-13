import os
import difflib

dir_165 = r"d:\MUVH\android\mu-decompiled\v165_lua"
dir_171 = r"d:\MUVH\android\mu-decompiled\v171_lua"

target_files = [
    "GlobalConfig.lua",
    "TranScriptController.lua",
    "Instance_GoalUI.lua",
    "GoalUI_AncientBossTemp.lua",
    "Activity_CommercialHoliday_PetInvestPage.lua",
    "TransferCareerEnum.lua",
    "cfg_Global_global.lua"
]

out_diff_path = r"d:\MUVH\android\mu-decompiled\detailed_diffs.txt"

with open(out_diff_path, "w", encoding="utf-8") as out:
    for f in target_files:
        p165 = os.path.join(dir_165, f)
        p171 = os.path.join(dir_171, f)
        if not os.path.exists(p165) or not os.path.exists(p171):
            out.write(f"File {f} missing in one dir\n\n")
            continue
        
        with open(p165, "r", encoding="utf-8", errors="ignore") as f1:
            lines1 = f1.readlines()
        with open(p171, "r", encoding="utf-8", errors="ignore") as f2:
            lines2 = f2.readlines()
            
        diff = list(difflib.unified_diff(lines1, lines2, fromfile=f"v165/{f}", tofile=f"v171/{f}"))
        
        out.write(f"========================================\n")
        out.write(f"DIFF FOR FILE: {f}\n")
        out.write(f"========================================\n")
        if not diff:
            out.write("No differences.\n\n")
        else:
            for line in diff:
                out.write(line)
            out.write("\n\n")

print("Detailed diff written to", out_diff_path)
