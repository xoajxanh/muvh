$luaFile = "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_farm\Main.lua"
$text = [System.IO.File]::ReadAllText($luaFile, [System.Text.Encoding]::UTF8)

$sb = New-Object System.Text.StringBuilder
$i = 0
$n = $text.Length
while ($i -lt $n) {
    if ($i + 3 -lt $n -and $text.Substring($i, 4) -eq "--[[") {
        $end = $text.IndexOf("]]", $i + 4)
        if ($end -eq -1) { break }
        for ($k = $i; $k -lt $end + 2; $k++) {
            if ($text[$k] -eq "`n") { [void]$sb.Append("`n") }
        }
        $i = $end + 2
    }
    elseif ($i + 1 -lt $n -and $text.Substring($i, 2) -eq "--") {
        $end = $text.IndexOf("`n", $i + 2)
        if ($end -eq -1) { break }
        $i = $end
    }
    elseif ($text[$i] -eq '"' -or $text[$i] -eq "'") {
        $q = $text[$i]
        $i++
        while ($i -lt $n -and $text[$i] -ne $q) {
            if ($text[$i] -eq '\') { $i += 2 } else { $i++ }
        }
        $i++
    }
    elseif ($i + 1 -lt $n -and $text.Substring($i, 2) -eq "[[") {
        $end = $text.IndexOf("]]", $i + 2)
        if ($end -eq -1) { break }
        for ($k = $i; $k -lt $end + 2; $k++) {
            if ($text[$k] -eq "`n") { [void]$sb.Append("`n") }
        }
        $i = $end + 2
    }
    else {
        [void]$sb.Append($text[$i])
        $i++
    }
}

$clean = $sb.ToString()
$matchesList = [regex]::Matches($clean, '\b(?:function|if|for|while|repeat|do|end|until)\b')
$stack = New-Object System.Collections.Generic.List[string]
for ($m = 0; $m -lt $matchesList.Count; $m++) {
    $t = $matchesList[$m].Value
    if ($t -eq "function" -or $t -eq "if" -or $t -eq "repeat") {
        $stack.Add($t)
    }
    elseif ($t -eq "for" -or $t -eq "while") {
        $stack.Add($t)
        if ($m + 1 -lt $matchesList.Count -and $matchesList[$m + 1].Value -eq "do") {
            $m++
        }
    }
    elseif ($t -eq "do") {
        $stack.Add("do")
    }
    elseif ($t -eq "end") {
        if ($stack.Count -eq 0 -or $stack[$stack.Count - 1] -eq "repeat") {
            throw "MISMATCH AT end"
        }
        $stack.RemoveAt($stack.Count - 1)
    }
    elseif ($t -eq "until") {
        if ($stack.Count -eq 0 -or $stack[$stack.Count - 1] -ne "repeat") {
            throw "MISMATCH AT until"
        }
        $stack.RemoveAt($stack.Count - 1)
    }
}
if ($stack.Count -ne 0) {
    throw "Unclosed blocks: $($stack -join ', ')"
}
$lineCount = ($text -split "`n").Count
Write-Output "LUA_BLOCK_BALANCE_OK | Total lines: $lineCount | Unclosed stack: $($stack.Count)"
