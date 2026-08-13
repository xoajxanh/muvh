import os
import filecmp
import re

dir_165 = r"d:\MUVH\android\mu-decompiled\v165_lua"
dir_171 = r"d:\MUVH\android\mu-decompiled\v171_lua"
report_file = r"d:\MUVH\android\mu-decompiled\diff_report.txt"

if not os.path.exists(dir_165) or not os.path.exists(dir_171):
    print("One or both directories do not exist yet!")
    exit(1)

files_165 = {f: os.path.join(dir_165, f) for f in os.listdir(dir_165) if f.endswith('.lua')}
files_171 = {f: os.path.join(dir_171, f) for f in os.listdir(dir_171) if f.endswith('.lua')}

set_165 = set(files_165.keys())
set_171 = set(files_171.keys())

added = sorted(list(set_171 - set_165))
removed = sorted(list(set_165 - set_171))
common = sorted(list(set_165 & set_171))

modified = []
identical = []

for f in common:
    p165 = files_165[f]
    p171 = files_171[f]
    if not filecmp.cmp(p165, p171, shallow=False):
        modified.append(f)
    else:
        identical.append(f)

# Keywords to look for suspicious / security / tracking / monitoring changes
security_keywords = [
    'report', 'track', 'cheat', 'illegal', 'abnormal', 'detect', 'ban',
    'verify', 'verification', 'inspect', 'hook', 'monitor', 'anti', 'hash',
    'md5', 'crc', 'signature', 'plugin', 'inject', 'mod', 'valid', 'check_pack',
    'device', 'sdk', 'telemetry', 'log'
]

keyword_matches = {}

for f in modified + added:
    filepath = files_171[f]
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as fp:
            content = fp.read()
            lines = content.splitlines()
            matches_in_file = []
            for idx, line in enumerate(lines, 1):
                line_lower = line.lower()
                for kw in security_keywords:
                    if kw in line_lower:
                        # Exclude common benign strings like 'dialog', 'packet', 'target', etc if too noisy, but keep raw line snippet
                        matches_in_file.append((idx, kw, line.strip()))
                        break
            if matches_in_file:
                keyword_matches[f] = matches_in_file
    except Exception as e:
        pass

with open(report_file, 'w', encoding='utf-8') as out:
    out.write(f"=== V165 VS V171 COMPARISON REPORT ===\n")
    out.write(f"Total files in v165: {len(set_165)}\n")
    out.write(f"Total files in v171: {len(set_171)}\n")
    out.write(f"Identical files: {len(identical)}\n")
    out.write(f"Added files in v171: {len(added)}\n")
    out.write(f"Removed files in v171: {len(removed)}\n")
    out.write(f"Modified files: {len(modified)}\n\n")

    out.write("--- ADDED FILES IN V171 ---\n")
    for f in added:
        out.write(f" + {f}\n")
    out.write("\n")

    out.write("--- REMOVED FILES IN V171 ---\n")
    for f in removed:
        out.write(f" - {f}\n")
    out.write("\n")

    out.write("--- MODIFIED FILES IN V171 ---\n")
    for f in modified:
        out.write(f" M {f}\n")
    out.write("\n")

    out.write("--- SECURITY & TRACKING & LOGGING KEYWORD MATCHES IN NEW/MODIFIED FILES ---\n")
    for f, matches in keyword_matches.items():
        out.write(f"File: {f} (Matches: {len(matches)})\n")
        for line_num, kw, line_text in matches[:20]: # top 20 per file
            out.write(f"  Line {line_num} [{kw}]: {line_text[:120]}\n")
        if len(matches) > 20:
            out.write(f"  ... and {len(matches) - 20} more matches.\n")
        out.write("\n")

print(f"Comparison report written to {report_file}")
