@'
import re

def isMatchSingleToken(p, token):
    cleanToken = token.strip()
    if not cleanToken: return False
    
    m1 = re.match(r'^[Ss](\d+)\.?$', cleanToken)
    m2 = re.match(r'^(\d+)$', cleanToken)
    sId = m1.group(1) if m1 else (m2.group(1) if m2 else None)
    
    if sId:
        targetNum = int(sId)
        pSid = p.get('serverId') or (p.get('data', {}).get('serverId'))
        if pSid and int(pSid) == targetNum:
            return True
            
    strList = []
    pName = p.get('name') or p.get('data', {}).get('name') or ''
    if pName: strList.append(pName)
    pSid = p.get('serverId') or (p.get('data', {}).get('serverId'))
    if pSid:
        strList.extend(['S' + str(pSid) + '.', 'S' + str(pSid), str(pSid)])
        if pName:
            strList.extend(['S' + str(pSid) + '.' + pName, 'S' + str(pSid) + ' ' + pName, '[S' + str(pSid) + ']' + pName])
            
    if sId:
        for s in strList:
            sLower = s.lower()
            if f's{sId}.' in sLower or f's{sId}_' in sLower or f's{sId}' in sLower:
                return True
    else:
        lowerInput = cleanToken.lower()
        for s in strList:
            if lowerInput in s.lower():
                return True
    return False

def isMatchLockTarget(p, lockInput):
    if not lockInput: return True
    if p.get('isDead') or p.get('isProtected'): return False
    tokens = [t.strip() for t in re.split(r'[;,|\r\n]+', lockInput) if t.strip()]
    for t in tokens:
        if isMatchSingleToken(p, t):
            return True
    return False

roles = {
    'A (S393, LucMac)': {'serverId': 393, 'name': 'LucMac'},
    'B (S395, Dino)': {'serverId': 395, 'name': 'Dino'},
    'C (S393, Dino)': {'serverId': 393, 'name': 'Dino'},
    'D (S100, Noob)': {'serverId': 100, 'name': 'Noob'},
    'E (S393, Dino - Protected)': {'serverId': 393, 'name': 'Dino', 'isProtected': True}
}

test_queries = ['S393.;Dino', 'S393.', 'Dino', 's393.; dino', 'S393.Dino', 'S395.; S393.']

for q in test_queries:
    print(f'=== Query: \"{q}\" ===')
    for r_name, r_obj in roles.items():
        res = isMatchLockTarget(r_obj, q)
        print(f'  {r_name} -> {res}')
'@ | Out-File -FilePath "d:\MUVH\android\mu-decompiled\final\test_target_logic.py" -Encoding utf8
python "d:\MUVH\android\mu-decompiled\final\test_target_logic.py"
Remove-Item "d:\MUVH\android\mu-decompiled\final\test_target_logic.py" -Force
