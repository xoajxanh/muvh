Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Collections.Generic;
using System.Text.RegularExpressions;

public class LuaBalanceChecker {
    public static void Check(string path) {
        string text = File.ReadAllText(path);
        var tokens = new List<Tuple<string, int>>();
        int i = 0, n = text.Length, line = 1;
        while (i < n) {
            if (text[i] == '\n') { line++; i++; continue; }
            if (char.IsWhiteSpace(text[i])) { i++; continue; }
            if (i + 1 < n && text[i] == '-' && text[i+1] == '-') {
                i += 2;
                if (i + 1 < n && text[i] == '[' && (text[i+1] == '[' || text[i+1] == '=')) {
                    int eq = 0; i++;
                    while (i < n && text[i] == '=') { eq++; i++; }
                    if (i < n && text[i] == '[') {
                        i++;
                        string close = "]" + new string('=', eq) + "]";
                        int idx = text.IndexOf(close, i);
                        if (idx == -1) break;
                        for (int k = i; k < idx + close.Length; k++) if (text[k] == '\n') line++;
                        i = idx + close.Length;
                        continue;
                    }
                }
                while (i < n && text[i] != '\n') i++;
                continue;
            }
            if (text[i] == '"' || text[i] == '\'') {
                char q = text[i++];
                while (i < n && text[i] != q) {
                    if (text[i] == '\\') i++;
                    if (i < n && text[i] == '\n') line++;
                    i++;
                }
                if (i < n) i++;
                continue;
            }
            if (i + 1 < n && text[i] == '[' && (text[i+1] == '[' || text[i+1] == '=')) {
                int eq = 0; i++;
                while (i < n && text[i] == '=') { eq++; i++; }
                if (i < n && text[i] == '[') {
                    i++;
                    string close = "]" + new string('=', eq) + "]";
                    int idx = text.IndexOf(close, i);
                    if (idx == -1) break;
                    for (int k = i; k < idx + close.Length; k++) if (text[k] == '\n') line++;
                    i = idx + close.Length;
                    continue;
                }
            }
            if (char.IsLetter(text[i]) || text[i] == '_') {
                int start = i;
                while (i < n && (char.IsLetterOrDigit(text[i]) || text[i] == '_')) i++;
                string w = text.Substring(start, i - start);
                bool afterDot = (start > 0 && (text[start-1] == '.' || text[start-1] == ':'));
                if (!afterDot) {
                    if (w == "function" || w == "if" || w == "do" || w == "repeat" || w == "end" || w == "until" || w == "for" || w == "while") {
                        tokens.Add(Tuple.Create(w, line));
                    }
                }
                continue;
            }
            i++;
        }
        var stack = new Stack<Tuple<string, int>>();
        for (int idx = 0; idx < tokens.Count; idx++) {
            string w = tokens[idx].Item1;
            int ln = tokens[idx].Item2;
            if (w == "for" || w == "while") {
                // their 'do' will be pushed, except wait: in Lua 'for ... do ... end' and 'while ... do ... end' use 'do' as the opener!
                continue;
            }
            if (w == "function" || w == "if" || w == "do" || w == "repeat") {
                stack.Push(tokens[idx]);
            } else if (w == "end") {
                if (stack.Count == 0) {
                    Console.WriteLine("Extra 'end' at line " + ln);
                    return;
                }
                var top = stack.Pop();
                if (top.Item1 == "repeat") {
                    Console.WriteLine("Mismatch 'end' at line " + ln + " for 'repeat' at line " + top.Item2);
                    return;
                }
            } else if (w == "until") {
                if (stack.Count == 0 || stack.Peek().Item1 != "repeat") {
                    Console.WriteLine("Invalid 'until' at line " + ln);
                    return;
                }
                stack.Pop();
            }
        }
        if (stack.Count > 0) {
            var top = stack.Peek();
            Console.WriteLine("Unclosed '" + top.Item1 + "' at line " + top.Item2 + " (remaining: " + stack.Count + ")");
        } else {
            Console.WriteLine("[OK] " + path + " balanced (" + line + " lines, " + tokens.Count + " block tokens)");
        }
    }
}
"@
[LuaBalanceChecker]::Check("d:\MUVH\android\mu-decompiled\final\modified_lua_dev_farm\Main.lua")
