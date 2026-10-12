import sys
sys.stdout.reconfigure(encoding='utf-8')

import os, re

for root, _, files in os.walk('d:/MUVH/android/mu-decompiled/final/extracted_lua'):
    for f in files:
        if f.endswith('.lua'):
            p = os.path.join(root, f)
            with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
                c = fp.read()
            if 'TaskStateType.Completed' in c or 'ReqCompleteTask' in c:
                for line in c.splitlines():
                    if 'TaskStateType.Completed' in line or 'ReqCompleteTask' in line:
                        print(f'{f}: {line.strip()[:100]}')
