--==============================================================--
--  AWESOME AJ — GITHUB JSON KEY SYSTEM (HWID LOCK + ONE-TIME)
--==============================================================--

local HttpService = game:GetService("HttpService")
local Analytics = game:GetService("RbxAnalyticsService")

local USER_KEY = rawget(getfenv(), "script_key") or ""
local HWID = Analytics:GetClientId()

-- GitHub links
local KEYS_URL = "https://raw.githubusercontent.com/YOURNAME/YOURREPO/main/keys.json"
local AUTOJOINER_URL = "https://raw.githubusercontent.com/YOURNAME/YOURREPO/main/autojoiner.lua"

-- Local key save
local SAVE_NAME = "AJ_KEY_" .. tostring(HWID)

--==============================================================--
--  Load saved key (one-time system)
--==============================================================--

local function loadSaved()
    if isfile and isfile(SAVE_NAME) then
        return readfile(SAVE_NAME)
    end
end

local function saveKey(k)
    if writefile then
        writefile(SAVE_NAME, k)
    end
end

-- Pick saved > user-entered
local KEY = loadSaved() or USER_KEY

if KEY == "" then
    warn("[AwesomeAJ] ❌ No key provided.")
    return
end

--==============================================================--
--  Fetch keys.json from GitHub
--==============================================================--

local raw = game:HttpGet(KEYS_URL)
local keys = HttpService:JSONDecode(raw)

local entry = keys[KEY]

if not entry then
    warn("[AwesomeAJ] ❌ Invalid key.")
    return
end

-- Bind HWID if empty
if entry.hwid == "" then
    entry.hwid = HWID
    print("[AwesomeAJ] 🔒 HWID Bound")
else
    -- Must match stored HWID
    if entry.hwid ~= HWID then
        warn("[AwesomeAJ] ❌ HWID mismatch.")
        return
    end
end

-- Save one-time key
saveKey(KEY)

print("[AwesomeAJ] ✅ Key Validated!")

--==============================================================--
--  LOAD AUTO JOINER
--==============================================================--

local src = game:HttpGet(AUTOJOINER_URL)
local fn = loadstring(src)

if fn then
    fn()
else
    warn("[AwesomeAJ] ❌ Failed to load AutoJoiner.")
end
