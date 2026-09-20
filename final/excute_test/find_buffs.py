# -*- coding: utf-8 -*-
import sys, re
sys.stdout.reconfigure(encoding='utf-8')

with open(r"d:\MUVH\android\mu-decompiled\final\extracted_lua\cfg_Skill_skill.lua", "r", encoding="latin1") as f:
    text = f.read()

m = re.search(r'\{\s*(?:--[^\n]*\n\s*)*id\s*=\s*410702\b(.*?)\},', text, re.DOTALL)
if m:
    print("SKILL 410702:")
    print("id = 410702" + m.group(1))
m1 = re.search(r'\{\s*(?:--[^\n]*\n\s*)*id\s*=\s*410701\b(.*?)\},', text, re.DOTALL)
if m1:
    print("SKILL 410701:")
    print("id = 410701" + m1.group(1))