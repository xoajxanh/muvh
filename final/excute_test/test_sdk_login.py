import urllib.parse
import urllib.request
import hashlib
import time
import json
import base64
import struct

SIGNATURE = "YhAY9FjSeo2WC7oeyhhoGZupa8g"
SALT = "oxKddFw0opc2ayAqm-WJCfzwdukeFwMFxPy6ClJWe_s"

def md5(s):
    if isinstance(s, str):
        s = s.encode('utf-8')
    return hashlib.md5(s).hexdigest()

def to_int_array(b, is_include_length=False):
    length = len(b)
    n = (length >> 2) if (length & 3) == 0 else (length >> 2) + 1
    if is_include_length:
        result = [0] * (n + 1)
        result[n] = length
    else:
        result = [0] * n
    for i in range(length):
        result[i >> 2] |= (b[i] & 0xFF) << ((i & 3) << 3)
    return result

def to_byte_array(ints, is_include_length=False):
    length = len(ints) << 2
    if is_include_length:
        m = ints[-1]
        length = m
    b = bytearray(length)
    for i in range(length):
        b[i] = (ints[i >> 2] >> ((i & 3) << 3)) & 0xFF
    return bytes(b)

def fix_key(k):
    if len(k) == 16:
        return k
    b = bytearray(16)
    if len(k) < 16:
        b[:len(k)] = k
    else:
        b[:16] = k[:16]
    return bytes(b)

def xxtea_encrypt(data_bytes, key_bytes):
    if len(data_bytes) == 0:
        return data_bytes
    v = to_int_array(data_bytes, True)
    k = to_int_array(fix_key(key_bytes), False)
    
    n = len(v) - 1
    if n < 1:
        return data_bytes
    
    z = v[n]
    y = v[0]
    DELTA = 0x9E3779B9 # -1640531527 in unsigned 32-bit
    q = 6 + 52 // (n + 1)
    sum_val = 0
    
    MASK = 0xFFFFFFFF
    
    while q > 0:
        sum_val = (sum_val + DELTA) & MASK
        e = (sum_val >> 2) & 3
        for p in range(n):
            y = v[p + 1]
            mx = (((z >> 5 ^ y << 2) + (y >> 3 ^ z << 4)) ^ ((sum_val ^ y) + (k[(p & 3) ^ e] ^ z))) & MASK
            v[p] = (v[p] + mx) & MASK
            z = v[p]
        y = v[0]
        mx = (((z >> 5 ^ y << 2) + (y >> 3 ^ z << 4)) ^ ((sum_val ^ y) + (k[(n & 3) ^ e] ^ z))) & MASK
        v[n] = (v[n] + mx) & MASK
        z = v[n]
        q -= 1
        
    return to_byte_array(v, False)

def get_safe_sign_for_signature(params):
    items = []
    for k in sorted(params.keys()):
        items.append(f"{urllib.parse.quote(k, safe='')}={urllib.parse.quote(str(params[k]), safe='')}")
    return "&".join(items)

def get_sign_params(params):
    items = []
    for k in sorted(params.keys()):
        if k != "sign" and "__" not in k:
            items.append(f"{k}={urllib.parse.quote(str(params[k]), safe='')}")
    raw_str = SALT + "&".join(items)
    return md5(raw_str)

def test_login(username, password):
    equip = md5("test_device_uuid_123456789")
    params = {
        "username": username,
        "pass": md5(password),
        "appid": "300270",
        "equip": equip,
        "device_id": equip,
        "device_name": "SM-G975F",
        "reg_from": "1",
        "reg_type": "0",
        "ad_id": "0",
        "app_version": "1.0.0",
        "sdk_version": "1.0.7",
        "token": "",
        "package_name": "com.vnyh.gp",
        "_af": urllib.parse.quote("appid=300270&gps_adid=&appsflyer_id="),
        "_dana_v2": urllib.parse.quote(f"terminal=android&bundle_name=MU Vĩnh Hằng&bundle_id=com.vnyh.gp&appid=300270&did={equip}"),
        "__hw": urllib.parse.quote(f"_res=1920*1080&bundle_name=MU Vĩnh Hằng&did={equip}")
    }
    
    params["sign"] = get_sign_params(params)
    
    t = str(int(time.time()))
    key_str = md5(SIGNATURE + t)
    
    safe_sign_str = get_safe_sign_for_signature(params)
    encrypted_bytes = xxtea_encrypt(safe_sign_str.encode('utf-8'), key_str.encode('utf-8'))
    o_b64 = base64.b64encode(encrypted_bytes).decode('utf-8')
    
    body_data = urllib.parse.urlencode({"t": t, "o": o_b64}).encode('utf-8')
    
    req = urllib.request.Request(
        "https://user.muvh.vn/vie/user_login",
        data=body_data,
        headers={
            "User-Agent": "okhttp/3.12.0",
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
            "encrypt-type": "xxtea"
        }
    )
    
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            resp_body = resp.read().decode('utf-8')
            print("Response Status:", resp.status)
            print("Response Body:", resp_body)
            return resp_body
    except Exception as e:
        print("Request Failed:", e)
        if hasattr(e, 'read'):
            print("Error details:", e.read().decode('utf-8', errors='ignore'))
        return None

if __name__ == "__main__":
    print("Testing SDK Login for dongsam14@gmail.com...")
    test_login("dongsam14@gmail.com", "12345ZXC")
