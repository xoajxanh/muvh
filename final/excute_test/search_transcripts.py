import os, json

brain_dir = r"C:\Users\xoajx\.gemini\antigravity-ide\brain"
for root, dirs, files in os.walk(brain_dir):
    for f in files:
        if f == "transcript.jsonl":
            path = os.path.join(root, f)
            with open(path, "r", encoding="utf-8", errors="ignore") as file:
                for line in file:
                    try:
                        data = json.loads(line)
                        if data.get("type") == "USER_INPUT":
                            content = data.get("content", "")
                            if any(k in content.lower() for k in ["làm mới", "timer", "đếm ngược", "resbossicon", "bossstate"]):
                                print("="*50)
                                print(f"Conv: {os.path.basename(os.path.dirname(root))}")
                                print(content[:500])
                    except:
                        pass
