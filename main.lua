--==============================================================--
-- AwesomeAJ • GitHub Loader (Public)
-- Users MUST define: script_key & discord_id BEFORE running
--==============================================================--

if not script_key or not discord_id or script_key == "" or discord_id == "" then
    warn("[AwesomeAJ] Missing script_key or discord_id. Set them above the loadstring!")
    return
end

local HttpService = game:GetService("HttpService")
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

local url =
    "https://awesomeautojoiner.pythonanywhere.com/script/obl_loader"
    .. "?key=" .. script_key
    .. "&discord_id=" .. discord_id
    .. "&hwid=" .. hwid

-- Supports syn.request, http_request, request, or fallback to HttpGet
local function http_get(u)
    local req = request or http_request or (syn and syn.request)
    if req then
        local r = req({Url = u, Method = "GET"})
        return r.Body, r.StatusCode
    else
        return game:HttpGet(u), 200
    end
end

local body, status = http_get(url)

--==============================================================--
-- AUTH RESULTS
--==============================================================--
if status ~= 200 then
    warn("[AwesomeAJ] Authentication server error. Status:", status)
    warn("[AwesomeAJ] Response:", body)
    return
end

if body:find("Invalid")
or body:find("Expired")
or body:find("HWID")
or body:find("mismatch")
or body:find("403")
or body:find("<!DOCTYPE") then

    warn("[AwesomeAJ] Authentication failed: " .. body)
    return
end

print("[AwesomeAJ] Authentication successful.")
print("[AwesomeAJ] Loading protected script...")

--==============================================================--
-- LOAD THE PROTECTED SCRIPT RETURNED BY YOUR API
--==============================================================--
local success, err = pcall(function()
    loadstring(body)()
end)

if not success then
    warn("[AwesomeAJ] Fatal error inside protected script:", err)
end
