# -*- coding: utf-8 -*-
import os
import subprocess

luac_exe = r'd:\MUVH\android\mu-decompiled\lua53\luac53.exe'
convert_script = r'd:\MUVH\android\mu-decompiled\convert_64_to_32.py'
temp_luac = r'd:\MUVH\android\mu-decompiled\final\excute_test\input.luac'
input_file = r'd:\MUVH\android\mu-decompiled\final\excute_test\input.txt'

# 1. Compile to luac
res1 = subprocess.run([luac_exe, "-s", "-o", temp_luac, input_file], capture_output=True, text=True)
if res1.returncode != 0:
    print("LOI COMPILE:", res1.stderr)
    exit(1)

# 2. Convert to 32-bit
res2 = subprocess.run(["python", convert_script, temp_luac, temp_luac], capture_output=True, text=True)
if res2.returncode != 0:
    print("LOI CONVERT:", res2.stderr)
    exit(1)

# 3. Patch header
with open(temp_luac, 'rb') as f:
    data = bytearray(f.read())
if data[0:4] == b'\x1bLua':
    data[5] = 0x01
    del data[14]
    with open(temp_luac, 'wb') as f:
        f.write(data)

print("SUCCESS: 32-bit bytecode compiled and patched successfully! Size:", len(data))
