if not game:IsLoaded() then game.Loaded:Wait() end
local g = getgenv()
g.Game = cloneref and cloneref(game) or game
local http_requesting = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
local gitlab_base = "https://gitlab.com/greatest-group/experience_coding/-/raw/main/"
local codeberg_base = "https://codeberg.org/talkinboutlol/Flames_Hub/raw/branch/main/"
local function fetch_raw(url)
    if not url or typeof(url) ~= "string" then return nil end
    local ok, res = pcall(function()
        return http_requesting({ Url = url, Method = "GET" })
    end)
    if not ok or not res then return nil end
    local status = res.StatusCode or res.statusCode or res.status or res.Status
    local body = res.Body or res.body or res.Response or res.response or ""
    if status == 200 and body ~= "" then
        return body
    end
    return nil
end

local function try_chain(urls)
    for _, url in ipairs(urls) do
        local body = fetch_raw(url)
        if body then return body, url end
    end
    return nil, nil
end

local function loadstring_chain(chain, label)
    for _, url in ipairs(chain) do
        local fetch_ok, res = pcall(function()
            return http_requesting({ Url = url, Method = "GET" })
        end)
        if not fetch_ok or not res then
            warn(tostring(label) .. ": fetch failed for " .. url)
            continue
        end
        local status = res.StatusCode or res.statusCode or res.status or res.Status
        local src = res.Body or res.body or res.Response or res.response or ""
        if status ~= 200 or src == "" then
            warn(tostring(label) .. ": bad response from " .. url .. " status=" .. tostring(status))
            continue
        end
        local fn, compile_err = loadstring(src)
        if not fn then
            warn(tostring(label) .. ": compile error from " .. url .. " -> " .. tostring(compile_err))
            continue
        end
        local run_ok, result = pcall(fn)
        if not run_ok then
            warn(tostring(label) .. ": runtime error from " .. url .. " -> " .. tostring(result))
            continue
        end
        if result ~= nil then return result end
        warn(tostring(label) .. ": nil return from " .. url .. ", trying next")
    end
    warn(tostring(label) .. ": all sources exhausted")
    return nil
end

local function build_chain(relative_path, extras)
    local chain = {
        gitlab_base .. relative_path,
        codeberg_base .. relative_path,
    }
    if extras then
        for _, v in ipairs(extras) do
            chain[#chain + 1] = v
        end
    end
    return chain
end

local function load_str_chain(chain)
    local src, hit_url = try_chain(chain)
    if not src then
        if g.notify then g.notify("Error", "All sources failed for this script.", 6) end
        warn("load_str_chain: all sources exhausted")
        return
    end
    local fn, compile_err = loadstring(src)
    if not fn then
        if g.notify then g.notify("Error", "Compile error: " .. tostring(compile_err), 6) end
        warn("load_str_chain: compile error from " .. tostring(hit_url) .. " -> " .. tostring(compile_err))
        return
    end
    local run_ok, run_err = pcall(fn)
    if not run_ok then
        if g.notify then g.notify("Error", "Runtime error: " .. tostring(run_err), 6) end
        warn("load_str_chain: runtime error -> " .. tostring(run_err))
    end
end

local notify_chain = {
    "https://codeberg.org/talkinboutlol/Flames_Hub/raw/branch/main/Assets/Notification_Library.lua",
    "https://gitlab.com/greatest-group/experience_coding/-/raw/main/UIs/Notification_Library.lua?ref_type=heads",
    "https://pastebin.com/raw/tg4tu73Y",
}

local atlas_chain = {
    "https://gitlab.com/greatest-group/experience_coding/-/raw/main/UIs/Atlas.lua?ref_type=heads",
    "https://codeberg.org/talkinboutlol/Flames_Hub/raw/branch/main/UIs/Atlas.lua",
    "https://pastebin.com/raw/9Vs0Pq8k",
    "https://pastefy.app/gTPqx1DG/raw",
}

local NotifyLib = loadstring_chain(notify_chain, "NotifyLib")
wait(0.2)
g.Flames_Hub_Base_Loader_Currently_Shown = true
g.notify = g.notify or function(notif_type, msg, duration)
    if not NotifyLib then return warn("notify: NotifyLib not loaded") end
    NotifyLib:External_Notification(tostring(notif_type), tostring(msg), tonumber(duration))
end

local TeleportService = g.TeleportService or cloneref and cloneref(game:GetService("TeleportService")) or game:GetService("TeleportService")
local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local LocalPlayer = g.LocalPlayer or Players.LocalPlayer or game.Players.LocalPlayer
local UserInputService = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local MarketplaceService = g.MarketplaceService or cloneref and cloneref(game:GetService("MarketplaceService")) or game:GetService("MarketplaceService")
local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local function get_game_name_by_place_id(place_id)
    if not place_id then return end
    local conv_str = MarketplaceService:GetProductInfo(place_id)
    if conv_str and typeof(conv_str) == "table" and conv_str.Name then
        return conv_str.Name
    elseif conv_str and typeof(conv_str) == "string" then
        return conv_str.Name
    else
        if g.notify then
            return g.notify("Error", "The game either does not exist anymore or did not return anything from Roblox's API!", 5)
        else
            return warn("Game Name is not a string or was returned as nil!")
        end
    end
end

local scriptstoload = {
    ["Tower Of Misery"] = { id = 4954752502, path = "Experiences/4954752502.lua" },
    ["Ultimate Driving"] = { id = 54865335, path = "Experiences/54865335.lua" },
    ["Life Together RP"] = { id = {13967668166, 99644611200703, 99154507657228}, path = "Experiences/13967668166.lua" },
    ["Hide And Seek Extreme"] = { id = 205224386, path = "Experiences/205224386.lua" },
    ["Apartment Hangout Spot"] = { id = 108873247414429, path = "Experiences/108873247414429.lua" },
    ["The Lanes"] = { id = 1333478699, path = "Experiences/1333478699.lua" },
    ["Player or AI"] = { id = 95217169945642, path = "Experiences/95217169945642.lua" },
    ["Main Street RP"] = { id = 18753889337, path = "Experiences/18753889337.lua" },
    ["Southwest Florida Beta"] = { id = 5104202731, path = "Experiences/5104202731.lua" },
    ["Driving Empire"] = { id = 3351674303, path = "Experiences/3351674303.lua" },
    ["Berry Avenue RP"] = { id = 8481844229, path = "Experiences/8481844229.lua" },
    ["Mega Fun Obby"] = { id = 12996397, path = "Experiences/12996397.lua" },
    ["Catalog Avatar Creator"] = { id = 7041939546, path = "Experiences/7041939546.lua" },
    ["Tower Of Hell"] = { id = 1962086868, path = "Experiences/1962086868.lua" },
    ["Car Driving Ultimate"] = { id = 11145865512, path = "Experiences/11145865512.lua" },
    ["Southern Mudding"] = { id = 79480724066456, path = "Experiences/79480724066456.lua" },
    ["Car Zone"] = { id = 80200604311136, path = "Experiences/80200604311136.lua" },
    ["Redcliff City RP"] = { id = 8369888266, path = "Experiences/8369888266.lua" },
    ["Dreamville RP"] = { id = 74395953411817, path = "Experiences/74395953411817.lua" },
    ["NewSmith RP"] = { id = 16625391970, path = "Experiences/16625391970.lua" },
    ["Bilberry City RP"] = { id = 13972889842, path = "Experiences/13972889842.lua" },
    ["Catch A Fade"] = { id = 103820982596314, path = "Experiences/103820982596314.lua" },
    ["Speed Run 4"] = { id = 183364845, path = "Experiences/183364845.lua" },
    ["Dubai RP"] = {id = 122485613019196, path = "Experiences/122485613019196.lua"}
}

local function matcheswhat(tpplaces, togo)
    if typeof(tpplaces) == "number" then
        return tpplaces == togo
    elseif typeof(tpplaces) == "table" then
        for _, id in ipairs(tpplaces) do
            if id == togo then return true end
        end
    end
    return false
end

local function get_place_name(place_id)
    if not place_id then return end
    local id = type(place_id) == "table" and place_id[1] or place_id
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(id)
    end)
    if ok and info then return info.Name end
end

local function FormatCEFloatStr(value)
    if value == 0 then return "0.0000000E+0" end
    local abs_val = math.abs(value)
    local exponent = math.floor(math.log10(abs_val))
    local mantissa = value / (10 ^ exponent)
    while math.abs(mantissa) >= 10 do mantissa = mantissa / 10; exponent = exponent + 1 end
    while math.abs(mantissa) < 1 do mantissa = mantissa * 10; exponent = exponent - 1 end
    local formatted = string.format("%.7f", mantissa)
    if tonumber(formatted) >= 10 then
        mantissa = mantissa / 10
        exponent = exponent + 1
        formatted = string.format("%.7f", mantissa)
    end
    local exp_sign = exponent >= 0 and "+" or "-"
    return formatted .. "E" .. exp_sign .. math.abs(exponent)
end

local function GenerateRandomCEFloat(min_exp, max_exp)
    local mantissa = 1 + math.random() * 8.9999999
    local exponent = math.random(min_exp, max_exp)
    local formatted = string.format("%.7f", mantissa)
    local exp_sign = exponent >= 0 and "+" or "-"
    return formatted .. "E" .. exp_sign .. math.abs(exponent)
end

local flames_ui = loadstring_chain(atlas_chain, "Atlas")
if not flames_ui then
    warn("Menu.lua: Atlas failed to load from all sources, cannot continue.")
    return
end

local Window = flames_ui.new({
    Name = "Flames Hub | Script Loader",
    ConfigFolder = "Flames_Hub_Menu",
    Color = Color3.fromRGB(21, 103, 251),
    Bind = "RightShift",
})
g.Buttons = g.Buttons or {}
local Page1 = Window:CreatePage("Main")
local Section1 = Page1:CreateSection("Home")
local Section2 = Page1:CreateSection("Game TPs")
local Section3 = Page1:CreateSection("Extras")
local function destroy_current_ui()
    if not flames_ui then return end
    local atlas_main_ui = CoreGui:FindFirstChild("Atlas")
    if atlas_main_ui and atlas_main_ui:IsA("ScreenGui") then
        local Main = atlas_main_ui:FindFirstChild("Main")
        if Main and Main:IsA("Frame") then
            pcall(function() Main.Visible = false end)
        end
    end
    getgenv().Looping_Window_Name_On_Flames_Hubs_Loader = false
    getgenv().spawned_change_window_name_tasked_loop = false
    if getgenv().window_changing_main_automatic_loop_task then
        pcall(function() task.cancel(getgenv().window_changing_main_automatic_loop_task) end)
        getgenv().window_changing_main_automatic_loop_task = nil
    end
end

local function get_nameless_admin_loaded()
    local registry = getreg and getreg() or getgenv()
    local na_env = registry
        and registry["__nameless_admin_private"]
        and registry["__nameless_admin_private"]["testing"]
    if na_env and (na_env.ltseverydayyou_NA or na_env.NA_LOADED) then return true end
    return false
end
wait(0.25)
Section1:CreateButton({
Name = "Join the Flames Hub Discord server.",
Callback = function()
    local http_requesting_func = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
    local http_service = g.HttpService or cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
    local opened = false
    if http_requesting_func and typeof(http_requesting_func) == "function" then
        local success = pcall(function()
            http_requesting_func({
                Url = 'http://127.0.0.1:6463/rpc?v=1',
                Method = 'POST',
                Headers = { ['Content-Type'] = 'application/json', Origin = 'https://discord.com' },
                Body = http_service:JSONEncode({
                    cmd = 'INVITE_BROWSER',
                    nonce = http_service:GenerateGUID(false),
                    args = { code = 'MTYKxQfpNJ' }
                })
            })
        end)
        opened = success
    end
    wait(0.25)
    if not opened then
        if g.AllClipboards and typeof(g.AllClipboards) == "function" then g.AllClipboards("https://discord.gg/MTYKxQfpNJ") end
        if g.notify then g.notify("Success", "Successfully copied Discord server link to your Clipboard.", 5) end
    end
end,})

Section3:CreateButton({
Name = "Flames Hub (Universal)",
Description = "Loads the universal version of Flames Hub.",
Callback = function()
    destroy_current_ui()
    task.wait(0.5)
    load_str_chain(build_chain("Extra/Universal.lua", {
        "https://pastefy.app/hyOCu2WN/raw",
    }))
end,})

Section3:CreateButton({
Name = "Free Emotes GUI",
Description = "Loads the Flames Hub | Free Emotes GUI script.",
Callback = function()
    load_str_chain({
        "https://codeberg.org/talkinboutlol/Flames_Hub/raw/branch/main/Extra/FreeEmotes.lua",
        "https://gitlab.com/greatest-group/experience_coding/-/raw/main/Extra/FreeEmotes.lua?ref_type=heads",
        "https://pastebin.com/raw/RCj6RJtc",
    })
    if not UserInputService.TouchEnabled then
        if g.notify then g.notify("Success", "Press F to toggle.", 1) end
    else
        if g.notify then g.notify("Success", "Toggle with the 'F' button on the left side of your screen.", 3) end
    end
end})

Section3:CreateButton({
Name = "Condo Games Destroyer (OLD!)",
Description = "Loads the Condo Games Destroyer script.",
Callback = function()
    destroy_current_ui()
    task.wait(0.5)
    load_str_chain({
        "https://codeberg.org/talkinboutlol/Flames_Hub/raw/branch/main/Extra/Condo_GUI.lua",
        "https://gitlab.com/greatest-group/experience_coding/-/raw/main/Extra/Condo_GUI.lua?ref_type=heads",
        "https://pastefy.app/xhacR76C/raw",
    })
end,})

Section3:CreateButton({
Name = "Infinite Yield FE",
Description = "Loads Infinite Yield FE (normal version).",
Callback = function()
    if getgenv().IY_LOADED then return end
    if getgenv().GET_LOADED_IY then return end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end,})

Section3:CreateButton({
Name = "Infinite Premium FE",
Description = "Loads Infinite Premium FE (my version).",
Callback = function()
    if getgenv().IY_LOADED then return end
    if getgenv().GET_LOADED_IY then return end
    load_str_chain({
        "https://codeberg.org/talkinboutlol/Flames_Hub/raw/branch/main/Extra/InfinitePremium.lua",
        "https://gitlab.com/greatest-group/experience_coding/-/raw/main/Extra/InfinitePremium.lua?ref_type=heads",
        "https://pastefy.app/b052AUgc/raw",
    })
end,})

Section3:CreateButton({
Name = "Nameless Admin FE",
Description = "Loads Nameless Admin FE.",
Callback = function()
    if get_nameless_admin_loaded() then return end
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua'))()
end})

local Excluded_IDs = {99644611200703, 99154507657228}
local function is_excluded(id)
    local check = type(id) == "table" and id[1] or id
    for _, v in ipairs(Excluded_IDs) do
        if check == v then return true end
    end
    return false
end

for name, dude in pairs(scriptstoload) do
    if is_excluded(dude.id) then continue end
    local strname = name:gsub("%W", "_")
    local id_display = typeof(dude.id) == "table" and tostring(dude.id[1]) or tostring(dude.id)
    local id_for_name = typeof(dude.id) == "table" and dude.id[1] or dude.id

    g.Buttons[strname] = Section1:CreateButton({
    Name = name,
    Description = "Runs the " .. name .. " script. Place ID: " .. id_display,
    Callback = function()
        if not dude.id or not dude.path then return end
        if not matcheswhat(dude.id, game.PlaceId) then
            local proper = get_place_name(id_for_name)
            g.notify("Error", "You are not in: " .. tostring(proper) .. "!", 10)
            return
        end
        destroy_current_ui()
        task.wait(0.5)
        load_str_chain(build_chain(dude.path, nil))
    end,})
end

for name, schnawg in pairs(scriptstoload) do
    if is_excluded(schnawg.id) then continue end
    local id_for_lookup = typeof(schnawg.id) == "table" and schnawg.id[1] or schnawg.id
    local id_display = typeof(schnawg.id) == "table" and tostring(schnawg.id[1]) or tostring(schnawg.id)
    local lookup_ok, real_name = pcall(get_game_name_by_place_id, id_for_lookup)
    if not lookup_ok or not real_name or typeof(real_name) ~= "string" then real_name = name end
    g.Buttons[name] = Section2:CreateButton({
    Name = "Teleport To Game: " .. tostring(real_name),
    Description = "Teleports you to " .. tostring(real_name) .. ". Place ID: " .. tostring(id_display),
    Callback = function()
        local idkok = type(schnawg.id) == "table" and schnawg.id[1] or schnawg.id
        if not idkok then return end
        if matcheswhat(schnawg.id, game.PlaceId) then
            g.notify("Info", "You are already in: " .. tostring(real_name) .. "!", 5)
            return
        end
        TeleportService:Teleport(idkok, LocalPlayer)
    end,})
end