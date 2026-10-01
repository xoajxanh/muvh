# =========================================================================
# TOOL DANG KY HANG LOAT 4 LUONG PROXY CHAY SONG SONG (MULTI-THREADED)
# Co che:
#   1. Khoi tao 4 Luong (Thread) doc lap, moi luong quan ly 1 Proxy rieng biet.
#   2. Chia deu 4,000 tai khoan (tu 0001 den 4000) -> 1,000 acc / 1 Luong.
#   3. He thong tai khoan moi: accfangmuvh0001@gmail.com -> accfangmuvh4000@gmail.com
#   4. Moi luong tu dong luu ket qua vao file rieng:
#      - Luong 1 -> reg_success_fang_proxy1.txt (STT: 0001 -> 1000)
#      - Luong 2 -> reg_success_fang_proxy2.txt (STT: 1001 -> 2000)
#      - Luong 3 -> reg_success_fang_proxy3.txt (STT: 2001 -> 3000)
#      - Luong 4 -> reg_success_fang_proxy4.txt (STT: 3001 -> 4000)
#   5. Khi 1 luong bi chan (ret=10077) -> Chi luong do dung lai cho doi IP moi.
#      3 luong con lai VAN TIEP TUC CHAY BINH THUONG!
#   6. Bam Ctrl + C bat ky luc nao de DUNG tat ca cac luong.
# =========================================================================

# -------------------------------------------------------------------------
# [CAU HINH TOOL - THONG TIN 4 PROXY & DAI TAI KHOAN]
# -------------------------------------------------------------------------
$ACCOUNT_PREFIX = "accmuvhfang0"    # Tien to tai khoan moi
$EMAIL_DOMAIN = "gmail.com"      # Duoi email
$PASSWORD = "12345ZXC"       # Mat khau chung cho tat ca acc
$DELAY_SUCCESS = 3                # Thoi gian nghi sau moi lan tao thanh cong (giay, khuyen dung 3-5s)
$IP_CHECK_INTERVAL = 5                # Tan suat tham do doi IP moi khi bi chan (giay)

# Danh sach 4 Proxy & phan chia 1,000 acc / luong (Tong 4,000 acc):
$WORKERS = @(
    @{ Id = 1; Host = "160.250.166.21"; Port = 10824; StartIndex = 722;  EndIndex = 1000; OutputFile = "$PSScriptRoot\reg_success_fang0_proxy1.txt" },
    @{ Id = 2; Host = "160.250.166.37"; Port = 10846; StartIndex = 1958; EndIndex = 2000; OutputFile = "$PSScriptRoot\reg_success_fang0_proxy2.txt" },
    @{ Id = 3; Host = "160.250.166.13"; Port = 10373; StartIndex = 2936; EndIndex = 3000; OutputFile = "$PSScriptRoot\reg_success_fang0_proxy3.txt" },
    @{ Id = 4; Host = "160.250.166.25"; Port = 10458; StartIndex = 3950; EndIndex = 4000; OutputFile = "$PSScriptRoot\reg_success_fang0_proxy4.txt" }
)
# -------------------------------------------------------------------------

# Thiet lap UTF-8 cho Console de khong bi loi font Unicode tren Windows
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Bat ho tro giao thuc TLS 1.2 cho Windows PowerShell
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls

# Dinh nghia C# Engine Multi-threading (4 Luong chay song song doc lap)
$csharpEngine = @'
using System;
using System.IO;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Security.Cryptography;

public class ProxyWorkerConfig
{
    public int Id;
    public string Host;
    public int Port;
    public int StartIndex;
    public int EndIndex;
    public string OutputFile;
    public string AccountPrefix;
    public string EmailDomain;

    public ProxyWorkerConfig(int id, string host, int port, int startIdx, int endIdx, string outFile, string prefix = "accfangmuvh", string domain = "gmail.com")
    {
        Id = id;
        Host = host;
        Port = port;
        StartIndex = startIdx;
        EndIndex = endIdx;
        OutputFile = outFile;
        AccountPrefix = prefix;
        EmailDomain = domain;
    }
}

public class MuMultiRegEngine
{
    private const string SDK_SALT = "oxKddFw0opc2ayAqm-WJCfzwdukeFwMFxPy6ClJWe_s";
    private const string SDK_SIGNATURE = "YhAY9FjSeo2WC7oeyhhoGZupa8g";
    private const string REG_URL = "https://user.muvh.vn/vie/reg_by_email";
    private const int DELTA = unchecked((int)0x9E3779B9);

    private static readonly object consoleLock = new object();
    private static readonly object[] fileLocks = new object[] { new object(), new object(), new object(), new object(), new object() };

    public static void SafeLog(int workerId, ConsoleColor tagColor, string text, ConsoleColor textColor = ConsoleColor.White)
    {
        lock (consoleLock)
        {
            Console.ForegroundColor = tagColor;
            Console.Write("[LUONG " + workerId + "] ");
            Console.ForegroundColor = textColor;
            Console.WriteLine(text);
            Console.ResetColor();
        }
    }

    public static string MD5Hash(string input)
    {
        using (var md5 = MD5.Create())
        {
            byte[] inputBytes = Encoding.UTF8.GetBytes(input);
            byte[] hashBytes = md5.ComputeHash(inputBytes);
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < hashBytes.Length; i++)
            {
                sb.Append(hashBytes[i].ToString("x2"));
            }
            return sb.ToString();
        }
    }

    public static string UrlEncode(string value)
    {
        if (string.IsNullOrEmpty(value)) return "";
        return WebUtility.UrlEncode(value);
    }

    private static int[] ToIntArray(byte[] bytes, bool includeLength)
    {
        int length = (bytes.Length & 3) == 0 ? bytes.Length >> 2 : (bytes.Length >> 2) + 1;
        int[] result;
        if (includeLength)
        {
            result = new int[length + 1];
            result[length] = bytes.Length;
        }
        else
        {
            result = new int[length];
        }
        for (int i = 0; i < bytes.Length; i++)
        {
            int idx = i >> 2;
            int shift = (i & 3) << 3;
            result[idx] |= (bytes[i] & 0xFF) << shift;
        }
        return result;
    }

    private static byte[] ToByteArray(int[] ints, bool includeLength)
    {
        int length = ints.Length << 2;
        if (includeLength)
        {
            int m = ints[ints.Length - 1];
            int n = length - 4;
            if (m < length - 7 || m > n) return null;
            length = m;
        }
        byte[] bytes = new byte[length];
        for (int i = 0; i < length; i++)
        {
            bytes[i] = (byte)(ints[i >> 2] >> ((i & 3) << 3));
        }
        return bytes;
    }

    private static byte[] FixKey(byte[] key)
    {
        if (key.Length == 16) return key;
        byte[] fixedKey = new byte[16];
        int copyLen = Math.Min(key.Length, 16);
        Array.Copy(key, fixedKey, copyLen);
        return fixedKey;
    }

    private static int MX(int sum, int y, int z, int p, int e, int[] k)
    {
        return (int)((((uint)z >> 5) ^ ((uint)y << 2)) + (((uint)y >> 3) ^ ((uint)z << 4))) ^ ((sum ^ y) + (k[(p & 3) ^ e] ^ z));
    }

    public static byte[] XXTEA_Encrypt(byte[] data, byte[] key)
    {
        if (data.Length == 0) return data;
        int[] v = ToIntArray(data, true);
        int[] k = ToIntArray(FixKey(key), false);
        int n = v.Length - 1;
        if (n < 1) return data;

        int z = v[n];
        int y = v[0];
        int q = 6 + (52 / (n + 1));
        int sum = 0;

        while (q-- > 0)
        {
            sum = unchecked(sum + DELTA);
            int e = (sum >> 2) & 3;
            for (int p = 0; p < n; p++)
            {
                y = v[p + 1];
                v[p] = unchecked(v[p] + MX(sum, y, z, p, e, k));
                z = v[p];
            }
            y = v[0];
            v[n] = unchecked(v[n] + MX(sum, y, z, n, e, k));
            z = v[n];
        }
        return ToByteArray(v, false);
    }

    public static string GetCurrentProxyIp(string proxyHost, int proxyPort, int timeoutMs = 6000)
    {
        string[] ipServices = new string[]
        {
            "http://api.ipify.org",
            "http://icanhazip.com",
            "http://ifconfig.me/ip",
            "http://checkip.amazonaws.com"
        };

        foreach (var url in ipServices)
        {
            try
            {
                var request = (HttpWebRequest)WebRequest.Create(url);
                request.Method = "GET";
                request.Timeout = timeoutMs;
                request.ReadWriteTimeout = timeoutMs;
                request.UserAgent = "curl/7.88.1";
                request.KeepAlive = false;
                request.CachePolicy = new System.Net.Cache.HttpRequestCachePolicy(System.Net.Cache.HttpRequestCacheLevel.BypassCache);

                if (!string.IsNullOrEmpty(proxyHost) && proxyPort > 0)
                {
                    request.Proxy = new WebProxy(proxyHost, proxyPort);
                }
                else
                {
                    request.Proxy = null;
                }

                if (request.ServicePoint != null)
                {
                    request.ServicePoint.ConnectionLeaseTimeout = 0;
                    request.ServicePoint.MaxIdleTime = 0;
                }

                using (var response = (HttpWebResponse)request.GetResponse())
                using (var stream = response.GetResponseStream())
                using (var reader = new StreamReader(stream, Encoding.UTF8))
                {
                    string ip = reader.ReadToEnd().Trim();
                    if (!string.IsNullOrEmpty(ip) && ip.Length >= 7 && ip.Length <= 45 && !ip.Contains("<") && !ip.Contains("html"))
                    {
                        return ip;
                    }
                }
            }
            catch
            {
                // Thu tiep dich vu khac neu loi
            }
        }
        return null;
    }

    public static string Register(string username, string password, string fakeEquip, string proxyHost, int proxyPort, int timeoutMs = 15000)
    {
        var parameters = new Dictionary<string, string>
        {
            { "username", username },
            { "pass", MD5Hash(password) },
            { "upgrade_account", "0" },
            { "appid", "300270" },
            { "equip", fakeEquip },
            { "device_id", fakeEquip },
            { "device_name", "SM-G975F" },
            { "reg_from", "1" },
            { "reg_type", "0" },
            { "ad_id", "0" },
            { "app_version", "1.0.0" },
            { "sdk_version", "1.0.7" },
            { "token", "" },
            { "package_name", "com.vnyh.gp" },
            { "_af", UrlEncode("appid=300270&gps_adid=&appsflyer_id=") },
            { "_dana_v2", UrlEncode("terminal=android&bundle_name=MU Vĩnh Hằng&bundle_id=com.vnyh.gp&appid=300270&did=" + fakeEquip) },
            { "__hw", UrlEncode("_res=1920*1080&bundle_name=MU Vĩnh Hằng&did=" + fakeEquip) }
        };

        var signKeys = new List<string>();
        foreach (var k in parameters.Keys)
        {
            if (k != "sign" && !k.Contains("__"))
            {
                signKeys.Add(k);
            }
        }
        signKeys.Sort(StringComparer.Ordinal);

        var signItems = new List<string>();
        foreach (var k in signKeys)
        {
            signItems.Add(k + "=" + UrlEncode(parameters[k]));
        }
        string signPayload = SDK_SALT + string.Join("&", signItems.ToArray());
        parameters["sign"] = MD5Hash(signPayload);

        var allKeys = new List<string>(parameters.Keys);
        allKeys.Sort(StringComparer.Ordinal);

        var allItems = new List<string>();
        foreach (var k in allKeys)
        {
            allItems.Add(UrlEncode(k) + "=" + UrlEncode(parameters[k]));
        }
        string safeSignStr = string.Join("&", allItems.ToArray());

        long epochTime = (long)(DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalSeconds;
        string tStr = epochTime.ToString();
        string keyStr = MD5Hash(SDK_SIGNATURE + tStr);

        byte[] encBytes = XXTEA_Encrypt(Encoding.UTF8.GetBytes(safeSignStr), Encoding.UTF8.GetBytes(keyStr));
        string o_b64 = Convert.ToBase64String(encBytes);

        string postBody = "t=" + UrlEncode(tStr) + "&o=" + UrlEncode(o_b64);

        var request = (HttpWebRequest)WebRequest.Create(REG_URL);
        request.Method = "POST";
        request.ContentType = "application/x-www-form-urlencoded";
        request.Timeout = timeoutMs;
        request.ReadWriteTimeout = timeoutMs;
        request.Accept = "application/json";
        request.Headers["encrypt-type"] = "xxtea";
        request.UserAgent = "Mozilla/5.0 (Linux; U; Android 10; SM-G975F Build/QP1A.190711.020)";
        request.KeepAlive = false;
        request.CachePolicy = new System.Net.Cache.HttpRequestCachePolicy(System.Net.Cache.HttpRequestCacheLevel.BypassCache);

        if (!string.IsNullOrEmpty(proxyHost) && proxyPort > 0)
        {
            request.Proxy = new WebProxy(proxyHost, proxyPort);
        }
        else
        {
            request.Proxy = null;
        }

        if (request.ServicePoint != null)
        {
            request.ServicePoint.ConnectionLeaseTimeout = 0;
            request.ServicePoint.MaxIdleTime = 0;
        }

        byte[] bodyBytes = Encoding.UTF8.GetBytes(postBody);
        request.ContentLength = bodyBytes.Length;

        using (Stream reqStream = request.GetRequestStream())
        {
            reqStream.Write(bodyBytes, 0, bodyBytes.Length);
        }

        try
        {
            using (var response = (HttpWebResponse)request.GetResponse())
            using (var stream = response.GetResponseStream())
            using (var reader = new StreamReader(stream, Encoding.UTF8))
            {
                return reader.ReadToEnd();
            }
        }
        catch (WebException wex)
        {
            if (wex.Response != null)
            {
                using (var stream = wex.Response.GetResponseStream())
                using (var reader = new StreamReader(stream, Encoding.UTF8))
                {
                    return reader.ReadToEnd();
                }
            }
            throw;
        }
    }

    private static string ExtractJsonField(string json, string fieldName)
    {
        if (string.IsNullOrEmpty(json)) return "";
        string key = "\"" + fieldName + "\"";
        int idx = json.IndexOf(key);
        if (idx < 0) return "";
        int colonIdx = json.IndexOf(':', idx + key.Length);
        if (colonIdx < 0) return "";
        int startVal = colonIdx + 1;
        while (startVal < json.Length && (json[startVal] == ' ' || json[startVal] == '\"')) startVal++;
        int endVal = startVal;
        while (endVal < json.Length && json[endVal] != '\"' && json[endVal] != ',' && json[endVal] != '}' && json[endVal] != '\r' && json[endVal] != '\n') endVal++;
        return json.Substring(startVal, endVal - startVal).Trim();
    }

    public static void RunWorker(ProxyWorkerConfig config, string password, int delaySuccessSec, int ipCheckIntervalSec)
    {
        ConsoleColor tagColor = ConsoleColor.Cyan;
        if (config.Id == 1) tagColor = ConsoleColor.Green;
        else if (config.Id == 2) tagColor = ConsoleColor.Yellow;
        else if (config.Id == 3) tagColor = ConsoleColor.Magenta;
        else if (config.Id == 4) tagColor = ConsoleColor.Cyan;

        SafeLog(config.Id, tagColor, "Khoi dong: Proxy " + config.Host + ":" + config.Port + " | Dai STT: " + config.StartIndex + " -> " + config.EndIndex + " (Tong " + (config.EndIndex - config.StartIndex + 1) + " acc)", ConsoleColor.White);

        string currentIp = GetCurrentProxyIp(config.Host, config.Port);
        while (string.IsNullOrEmpty(currentIp))
        {
            SafeLog(config.Id, tagColor, "[CHO PROXY] Dang ket noi toi " + config.Host + ":" + config.Port + "...", ConsoleColor.DarkYellow);
            Thread.Sleep(ipCheckIntervalSec * 1000);
            currentIp = GetCurrentProxyIp(config.Host, config.Port);
        }

        SafeLog(config.Id, tagColor, "[KET NOI THANH CONG] IP hien tai: [" + currentIp + "]", ConsoleColor.Green);

        int idx = config.StartIndex;
        var rnd = new Random(Guid.NewGuid().GetHashCode());
        int successCount = 0;
        int totalAcc = config.EndIndex - config.StartIndex + 1;

        while (idx <= config.EndIndex)
        {
            string account = string.Format("{0}{1:D4}@{2}", config.AccountPrefix, idx, config.EmailDomain);
            int stepNum = idx - config.StartIndex + 1;

            long nowEpoch = (long)(DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalSeconds;
            string seedStr = string.Format("dev_reg_{0}_{1}_{2}_{3}", nowEpoch, rnd.Next(100000, 999999), rnd.Next(100000, 999999), idx);
            string fakeEquip = MD5Hash(seedStr);

            SafeLog(config.Id, tagColor, string.Format("[{0}/{1}] [STT {2}] Dang tao: {3} (IP: {4})...", stepNum, totalAcc, idx, account, currentIp), ConsoleColor.White);

            string respJson = null;
            try
            {
                respJson = Register(account, password, fakeEquip, config.Host, config.Port);
            }
            catch (Exception ex)
            {
                SafeLog(config.Id, tagColor, "[LOI KET NOI / TIMEOUT]: " + ex.Message + " -> Tam nghi 5s thu lai...", ConsoleColor.Red);
                Thread.Sleep(5000);
                continue;
            }

            string retStr = ExtractJsonField(respJson, "ret");
            string msgStr = ExtractJsonField(respJson, "msg");
            if (string.IsNullOrEmpty(msgStr)) msgStr = ExtractJsonField(respJson, "message");

            // TH1: THANH CONG
            if (retStr == "0")
            {
                string newUid = ExtractJsonField(respJson, "user_id");
                successCount++;
                SafeLog(config.Id, tagColor, string.Format("-> [THANH CONG!] {0} (UID: {1})", account, newUid), ConsoleColor.Green);

                string logLine = string.Format("{0:yyyy-MM-dd HH:mm:ss} | STT: {1:D4} | Email: {2} | Pass: {3} | UID: {4} | IP: {5}\r\n",
                    DateTime.Now, idx, account, password, newUid, currentIp);

                lock (fileLocks[config.Id % fileLocks.Length])
                {
                    File.AppendAllText(config.OutputFile, logLine, Encoding.UTF8);
                }

                Thread.Sleep(delaySuccessSec * 1000);
                idx++;
            }
            // TH2: TAI KHOAN DA TON TAI / NGUOI DUNG DA CO (SKIP VA GHI LOG RIENG)
            else if (retStr == "10032" ||
                     msgStr.IndexOf("bị dùng", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     msgStr.IndexOf("bi dung", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     msgStr.IndexOf("tồn tại", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     msgStr.IndexOf("ton tai", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     msgStr.IndexOf("đã có", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     msgStr.IndexOf("da co", StringComparison.OrdinalIgnoreCase) >= 0 ||
                     msgStr.IndexOf("exist", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                SafeLog(config.Id, ConsoleColor.Magenta, string.Format("-> [DA TON TAI / SKIP]: {0} (ret={1}, {2}) -> Bo qua va ghi nhan vao file rieng!", account, retStr, msgStr), ConsoleColor.Magenta);

                string skipLogLine = string.Format("{0:yyyy-MM-dd HH:mm:ss} | Luong: {1} | STT: {2:D4} | Email: {3} | Pass: {4} | Resp: {5}\r\n",
                    DateTime.Now, config.Id, idx, account, password, respJson);

                string skipFilePath = Path.Combine(Path.GetDirectoryName(config.OutputFile), "reg_skipped_existing_accounts.txt");
                lock (fileLocks[0])
                {
                    File.AppendAllText(skipFilePath, skipLogLine, Encoding.UTF8);
                }

                Thread.Sleep(500);
                idx++;
            }
            // TH3: BI CHAN 10077 (HET QUOTA IP NAY)
            else if (retStr == "10077" || msgStr.ToLower().Contains("thao t"))
            {
                SafeLog(config.Id, tagColor, string.Format("-> [CHAM HAN NGACH ret=10077] IP {0} da het luot tai {1}! Tam dung luong nay de cho doi IP moi...", currentIp, account), ConsoleColor.Yellow);

                int waitSec = 0;
                while (true)
                {
                    Thread.Sleep(ipCheckIntervalSec * 1000);
                    waitSec += ipCheckIntervalSec;

                    string newIp = GetCurrentProxyIp(config.Host, config.Port);
                    if (string.IsNullOrEmpty(newIp))
                    {
                        SafeLog(config.Id, tagColor, string.Format("   [Cho {0}s] Proxy dang reset / chua co ket noi...", waitSec), ConsoleColor.DarkGray);
                    }
                    else if (newIp != currentIp)
                    {
                        SafeLog(config.Id, tagColor, string.Format(">>> [DOI IP THANH CONG!] IP Cu: {0} -> IP Moi: {1} (Sau {2}s) -> Tiep tuc tao acc {3} (STT {4})! <<<", currentIp, newIp, waitSec, account, idx), ConsoleColor.Green);
                        currentIp = newIp;
                        break;
                    }
                    else
                    {
                        SafeLog(config.Id, tagColor, string.Format("   [Cho {0}s] IP lay duoc: {1} (Chua doi, van la IP cu)...", waitSec, newIp), ConsoleColor.DarkYellow);
                    }
                }
            }
            // TH4: CAC LOI KHAC
            else
            {
                SafeLog(config.Id, tagColor, string.Format("-> [LOI SERVER]: ret={0} ({1}) -> Tam nghi 5s thu lai...", retStr, msgStr), ConsoleColor.Red);
                Thread.Sleep(5000);
            }
        }

        SafeLog(config.Id, tagColor, string.Format("=== HOAN TAT LUONG {0}! Tao thanh cong {1}/{2} acc vao file: {3} ===", config.Id, successCount, totalAcc, config.OutputFile), ConsoleColor.Green);
    }

    public static void StartAll(List<ProxyWorkerConfig> configs, string password, int delaySuccessSec, int ipCheckIntervalSec)
    {
        Task[] tasks = new Task[configs.Count];
        for (int i = 0; i < configs.Count; i++)
        {
            var cfg = configs[i];
            tasks[i] = Task.Run(() => RunWorker(cfg, password, delaySuccessSec, ipCheckIntervalSec));
        }
        Task.WaitAll(tasks);
    }
}
'@

# Nap C# class vao PowerShell
if (-not ([System.Management.Automation.PSTypeName]'MuMultiRegEngine').Type) {
    Add-Type -TypeDefinition $csharpEngine
}

# =========================================================================
# GIAO DIEN KHOI DONG HE THONG 4 LUONG PROXY
# =========================================================================
Clear-Host
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host "   TOOL DANG KY TAI KHOAN MU VINH HANG - 4 LUONG PROXY CHAY SONG SONG   " -ForegroundColor Yellow
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host " [Phan chia 4 Luong - He thong $ACCOUNT_PREFIX (Tong 4,000 acc - 1,000 acc/luong)]:" -ForegroundColor White
foreach ($w in $WORKERS) {
    $c = switch ($w.Id) { 1 { 'Green' } 2 { 'Yellow' } 3 { 'Magenta' } 4 { 'Cyan' } }
    Write-Host "   - Luong $($w.Id): $($w.Host):$($w.Port) | STT: $($w.StartIndex.ToString('D4')) -> $($w.EndIndex.ToString('D4')) | File: $([System.IO.Path]::GetFileName($w.OutputFile))" -ForegroundColor $c
}
Write-Host " [Cac thong so]:" -ForegroundColor White
Write-Host "   - Mat khau chung:   $PASSWORD" -ForegroundColor White
Write-Host "   - Nghi thanh cong:  ${DELAY_SUCCESS}s" -ForegroundColor White
Write-Host "   - Co che:           Luong nao cham han ngach se tu dong cho doi IP moi." -ForegroundColor White
Write-Host "                       Cac luong con lai VAN TIEP TUC CHAY SONG SONG!" -ForegroundColor White
Write-Host " (Meo: Nhan Ctrl + C bat ky luc nao de DUNG TAT CA CAC LUONG)" -ForegroundColor DarkGray
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host ""

# Chuyen cau hinh sang C# Engine
$configs = New-Object 'System.Collections.Generic.List[ProxyWorkerConfig]'
foreach ($w in $WORKERS) {
    $cfg = New-Object ProxyWorkerConfig($w.Id, $w.Host, $w.Port, $w.StartIndex, $w.EndIndex, $w.OutputFile, $ACCOUNT_PREFIX, $EMAIL_DOMAIN)
    $configs.Add($cfg)
}

# Khoi chay tat ca cac luong dong thoi
[MuMultiRegEngine]::StartAll($configs, $PASSWORD, $DELAY_SUCCESS, $IP_CHECK_INTERVAL)

Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Green
Write-Host ">>> TAT CA 4 LUONG DA HOAN TAT CHU TRINH DANG KY! <<<" -ForegroundColor Green
Write-Host "==========================================================================" -ForegroundColor Green
