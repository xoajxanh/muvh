Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;

public class LuaChecker {
    public static void Verify(string path) {
        string code = File.ReadAllText(path, Encoding.UTF8);
        int i = 0, n = code.Length, line = 1;
        StringBuilder sb = new StringBuilder(n);
        while (i < n) {
            char c = code[i];
            if (c == '\n') { line++; sb.Append('\n'); i++; continue; }
            if (c == '-' && i + 1 < n && code[i + 1] == '-') {
                var m = Regex.Match(code.Substring(i, Math.Min(20, n - i)), @"^--\[(=*)\[");
                if (m.Success) {
                    string endPat = "]" + m.Groups[1].Value + "]";
                    int idx = code.IndexOf(endPat, i + m.Length);
                    if (idx < 0) throw new Exception(path + ":" + line + ": Unclosed long comment");
                    for (int k = i; k < idx + endPat.Length; k++) if (code[k] == '\n') { line++; sb.Append('\n'); }
                    i = idx + endPat.Length;
                    continue;
                } else {
                    int idx = code.IndexOf('\n', i);
                    if (idx < 0) break;
                    i = idx;
                    continue;
                }
            }
            if (c == '[') {
                var m = Regex.Match(code.Substring(i, Math.Min(20, n - i)), @"^\[(=*)\[");
                if (m.Success) {
                    string endPat = "]" + m.Groups[1].Value + "]";
                    int idx = code.IndexOf(endPat, i + m.Length);
                    if (idx < 0) throw new Exception(path + ":" + line + ": Unclosed long string");
                    sb.Append("\"\"");
                    for (int k = i; k < idx + endPat.Length; k++) if (code[k] == '\n') { line++; sb.Append('\n'); }
                    i = idx + endPat.Length;
                    continue;
                }
            }
            if (c == '"' || c == '\'') {
                char q = c; i++;
                while (i < n) {
                    if (code[i] == '\\') {
                        if (i + 1 < n && code[i + 1] == '\n') { line++; sb.Append('\n'); }
                        i += 2; continue;
                    }
                    if (code[i] == '\n') throw new Exception(path + ":" + line + ": Unclosed string");
                    if (code[i] == q) { i++; break; }
                    i++;
                }
                sb.Append("\"\"");
                continue;
            }
            sb.Append(c);
            i++;
        }
        string clean = sb.ToString();
        var stack = new Stack<Tuple<char, int>>();
        int curLine = 1;
        foreach (char ch in clean) {
            if (ch == '\n') curLine++;
            else if (ch == '(' || ch == '{' || ch == '[') stack.Push(Tuple.Create(ch, curLine));
            else if (ch == ')' || ch == '}' || ch == ']') {
                if (stack.Count == 0) throw new Exception(path + ":" + curLine + ": Unexpected " + ch);
                var top = stack.Pop();
                if ((top.Item1 == '(' && ch != ')') || (top.Item1 == '{' && ch != '}') || (top.Item1 == '[' && ch != ']'))
                    throw new Exception(path + ":" + curLine + ": Mismatched " + top.Item1 + " (line " + top.Item2 + ") and " + ch);
            }
        }
        if (stack.Count > 0) throw new Exception(path + ":" + stack.Peek().Item2 + ": Unclosed " + stack.Peek().Item1);

        var bstack = new Stack<Tuple<string, int>>();
        string expectLoopDo = null;
        int scanLine = 1;
        int lastPos = 0;
        foreach (Match m in Regex.Matches(clean, @"(?<![.\w])(function|if|while|for|do|repeat|end|until)(?![.\w])")) {
            for (int k = lastPos; k < m.Index; k++) if (clean[k] == '\n') scanLine++;
            lastPos = m.Index;
            string kw = m.Groups[1].Value;
            if (kw == "while" || kw == "for") expectLoopDo = kw;
            else if (kw == "do") {
                if (expectLoopDo != null) { bstack.Push(Tuple.Create(expectLoopDo + "_do", scanLine)); expectLoopDo = null; }
                else bstack.Push(Tuple.Create("do", scanLine));
            }
            else if (kw == "function" || kw == "if" || kw == "repeat") bstack.Push(Tuple.Create(kw, scanLine));
            else if (kw == "end") {
                if (bstack.Count == 0) throw new Exception(path + ":" + scanLine + ": Extra end");
                var top = bstack.Pop();
                if (top.Item1 == "repeat") throw new Exception(path + ":" + scanLine + ": Expected until for repeat at line " + top.Item2);
            }
            else if (kw == "until") {
                if (bstack.Count == 0) throw new Exception(path + ":" + scanLine + ": Extra until");
                var top = bstack.Pop();
                if (top.Item1 != "repeat") throw new Exception(path + ":" + scanLine + ": until does not match " + top.Item1 + " at line " + top.Item2);
            }
        }
        if (bstack.Count > 0) throw new Exception(path + ":" + bstack.Peek().Item2 + ": Unclosed block " + bstack.Peek().Item1);
        Console.WriteLine("[OK] Verified syntax & blocks: " + path + " (" + line + " lines)");
    }
}
"@

$files = @(
    "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_farm\EmmyluaDebug.lua",
    "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_farm\Main.lua"
)
foreach ($f in $files) {
    [LuaChecker]::Verify($f)
}
