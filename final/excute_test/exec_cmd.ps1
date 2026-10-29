$file = "d:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"
$lines = [System.IO.File]::ReadAllLines($file)
        $targets = @(
            'if bDist > 3.0 then',
            'if dist > 2.0 then',
            'if (tdx * tdx + tdy * tdy) > 4.0 then',
            'if bDist > 3.5 and me then'
        )
        foreach ($t in $targets) {
            $m = @()
            for ($i = 0; $i -lt $lines.Length; $i++) {
                if ($lines[$i].Contains($t)) {
                    $m += ($i + 1)
                }
            }
            Write-Output "Target: $t => Lines: $($m -join ', ')"
        }
