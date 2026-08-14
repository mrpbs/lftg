if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players and game.Players.LocalPlayer
local g = getgenv()
if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://pastebin.com/raw/T25mDhBZ"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end
wait(0.25)
local Workspace, VirtualUser, HttpService, AssetService, Players, SoundService, ReplicatedStorage, Teams, vc_internal, vc_service
local Raw_Version = "V2.2.9"
getgenv().Script_Version = tostring(Raw_Version).."-SWFL"
getgenv().ConstantUpdate_Checker_Live = true
if getgenv().SouthwestFlorida_Hub_Executed then return end
getgenv().SouthwestFlorida_Hub_Executed = true
local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local ReplicatedStorage = cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer
local function find_color_scrollframe(timeout)
    local start = os.clock()
    while os.clock() - start < timeout do
        for _, v in ipairs(PlayerGui:GetDescendants()) do
            if v:IsA("ScrollingFrame") and v.Name:lower():find("paint") and v.Name:lower():find("scroll") and v:FindFirstChild("color1", true) then
                return v
            end
        end
        task.wait(0.2)
    end
    return nil
end

g.tested_car_colors = g.tested_car_colors or {}
local scroll_frame = find_color_scrollframe(5)
local seen = {}
if scroll_frame and scroll_frame:IsA("ScrollingFrame") and scroll_frame.Parent then
    table.clear(g.tested_car_colors)
    for _, v in ipairs(scroll_frame:GetDescendants()) do
        if v:IsA("GuiObject") then
            local c = v.BackgroundColor3
            local r = math.floor(c.R * 255 + 0.5)
            local gg = math.floor(c.G * 255 + 0.5)
            local b = math.floor(c.B * 255 + 0.5)
            local key = r.."|"..gg.."|"..b
            if not seen[key] then
                seen[key] = true
                table.insert(g.tested_car_colors, {name = v.Name, c = Color3.fromRGB(r, gg, b)})
            end
        end
    end
    print("[Cache] Stored " .. #g.tested_car_colors .. " colors into g.tested_car_colors")
else
    print("[Cache] Could not find color scrolling frame — paint UI may not be open.")
end

local function find_owned_vehicles_frame()
    local cache = getgenv().owned_vehicles_scrolling_frame
    if cache and cache:IsA("ScrollingFrame") and cache.Parent then
        return cache
    end

    for _, v in ipairs(PlayerGui:GetDescendants()) do
        if v:IsA("ScrollingFrame") and v.Name:lower():find("list") and v.Parent.Name:lower():find("vehicle") and v.Parent.Name:lower():find("frame") then
            getgenv().owned_vehicles_scrolling_frame = v
            return v
        end
    end

    return nil
end

if not getgenv().owned_vehicles_scrolling_frame then pcall(function() find_owned_vehicles_frame() end) end
local function getExecutor()
    local name
    if identifyexecutor then
        name = identifyexecutor()
    end
    return { Name = name or "Unknown Executor"}
end

local function detectExecutor()
    local executorDetails = getExecutor()
    return string.format("%s", executorDetails.Name)
end

local executor_Name = detectExecutor()
local Service_Map = {
	Workspace = "Workspace",
	VirtualUser = "VirtualUser",
	HttpService = "HttpService",
	AssetService = "AssetService",
	Players = "Players",
	SoundService = "SoundService",
	ReplicatedStorage = "ReplicatedStorage",
	Teams = "Teams",
	VoiceChatInternal = "vc_internal",
	VoiceChatService = "vc_service",
}

for name, var_name in pairs(Service_Map) do g[var_name] = g[var_name] or cloneref and cloneref(game:GetService(name)) or game:GetService(name) end
if not Players then Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players") or game.Players end
if not g.LocalPlayer then g.LocalPlayer = Players.LocalPlayer or game.Players.LocalPlayer end
local LocalPlayer = g.LocalPlayer or game.Players.LocalPlayer
g.get_char = g.get_char or function(Player)
    if not Player or not Player:IsA("Player") then return nil end
    local current_char
    local diedconn
    local added_conn
    local function hookchar(char)
        current_char = char
        if diedconn then diedconn:Disconnect() end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            diedconn = hum.Died:Once(function()
                current_char = nil
            end)
        end
    end

    if Player.Character and Player.Character.Parent then
        hookchar(Player.Character)
    end

    added_conn = Player.CharacterAdded:Connect(hookchar)

    while not current_char do
        task.wait()
        local char = Player.Character
        if char and char.Parent then
            hookchar(char)
        end
    end

    return current_char
end
wait(0.5)
if not g.get_human then
    g.get_human = function(Player)
        local char = g.get_char(Player)
        if not char then return nil end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then return hum end

        local hum_conn
        hum_conn = char.ChildAdded:Connect(function(c)
            if c:IsA("Humanoid") then
                hum = c
                hum_conn:Disconnect()
            end
        end)

        local died = false
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then
            h.Died:Connect(function()
                died = true
            end)
        end

        while not hum and not died do
            task.wait()
        end

        if hum_conn then hum_conn:Disconnect() end

        return (not died) and hum or nil
    end
end

if not g.get_root then
    g.get_root = function(Player)
        local char = g.get_char(Player)
        if not char then return nil end
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if root then return root end
        local targets = {
            HumanoidRootPart = true,
            UpperTorso = true,
            Torso = true
        }

        local died = false
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function() died = true end)
        end

        local added_conn
        added_conn = char.ChildAdded:Connect(function(c)
            if targets[c.Name] then
                root = c
                added_conn:Disconnect()
            end
        end)

        while not root and not died do task.wait() end
        if added_conn then added_conn:Disconnect() end
        return (not died) and root or nil
    end
end

if not g.get_head then
    g.get_head = function(Player)
        local char = g.get_char(Player)
        if not char then return nil end

        local head = char:FindFirstChild("Head")
        if head then return head end

        local died = false
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function() died = true end)
        end

        local added_conn
        added_conn = char.ChildAdded:Connect(function(c)
            if c.Name == "Head" then
                head = c
                added_conn:Disconnect()
            end
        end)

        while not head and not died do
            task.wait()
        end

        if added_conn then added_conn:Disconnect() end
        return (not died) and head or nil
    end
end
wait(0.1)
g.Service_Wrap = g.Service_Wrap or function(name)
    name = tostring(name)
    if setmetatable then
        if not g._service_cache then
            g._service_cache = setmetatable({}, {
                __index = function(self, index)
                    local svc = game:GetService(index)

                    if cloneref and svc then
                        svc = cloneref(svc)
                    end

                    self[index] = svc
                    return svc
                end
            })
        end

        return g._service_cache[name]
    end

    local svc = game:GetService(name)

    if cloneref and svc then
        svc = cloneref(svc)
    end

    return svc
end

local special_colors = {
    {167.00000524520874, 42.000001296401024, 43.00000123679638},
    {213.00000250339508, 213.00000250339508, 213.00000250339508},
    {57.00000040233135, 64.00000378489494, 72.00000330805779},
    {0, 0, 0},
    {14.000000115484, 75.00000312924385, 130.0000074505806},
}

local function lerp(a, b, t) return a + (b - a) * t end
local function generate_steps(from, to, steps)
    local out = {}
    for i = 0, steps do
        local t = i / steps
        table.insert(out, {
            lerp(from[1], to[1], t),
            lerp(from[2], to[2], t),
            lerp(from[3], to[3], t),
        })
    end
    return out
end

getgenv().free_colors = getgenv().free_colors or {}
for i = 1, #special_colors do
    local a = special_colors[i]
    local b = special_colors[(i % #special_colors) + 1]
    local steps = generate_steps(a, b, 20)
    for _, c in ipairs(steps) do
        table.insert(getgenv().free_colors, c)
    end
end

local colors = {
    {0,0,0},
    {87.00000241398811,53.00000064074993,115.00000074505806},
    {194.00000363588333,0,36.00000165402889},
    {229.00000154972076,233.00000131130219,229.00000154972076},
    {227.00000166893005,91.00000217556953,1.0000000591389835},
    {137.00000703334808,1.0000000591389835,1.0000000591389835},
    {232.00000137090683,232.00000137090683,232.00000137090683},
    {33.00000183284283,75.00000312924385,152.0000061392784},
    {103.0000014603138,106.00000128149986,111.00000098347664},
    {255,0,225.8773899078369},
    {83.81617605686188,255,0},
    {254.2897117137909,255,0},
}

local function find_RE(name, place)
    name = name:lower()

    if not place then
        place = game.ReplicatedStorage
    end

    local function scan_for_re(obj)
        for _, v in ipairs(obj:GetChildren()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find(name) then
                return v
            end

            local found = scan_for_re(v)
            if found then
                return found
            end
        end
    end

    return scan_for_re(place)
end

local function find_RF(name, place)
    name = name:lower()

    if not place then
        place = game.ReplicatedStorage
    end

    local function scan_for_rf(obj)
        for _, v in ipairs(obj:GetChildren()) do
            if v:IsA("RemoteFunction") and v.Name:lower():find(name) then
                return v
            end

            local found = scan_for_rf(v)
            if found then
                return found
            end
        end
    end

    return scan_for_rf(place)
end

getgenv().get_FE_ColorPart = function(vehicle)
    local prop_fe = vehicle:FindFirstChild("Prop_FE", true)
    if not prop_fe then
        return nil, nil
    end

    local color_part = vehicle:FindFirstChild("Color", true)
    return color_part, prop_fe
end

local function find_folder(name, place)
    name = tostring(name):lower()
    place = place or workspace

    local function scan(obj)
        for _, v in ipairs(obj:GetChildren()) do
            if v:IsA("Folder") and v.Name:lower():find(name) then
                return v
            end
            local found = scan(v)
            if found then
                return found
            end
        end
    end

    return scan(place)
end

function low_level_executor()
    if executor_Name == "Solara" or string.find(executor_Name, "JJSploit") or executor_Name == "Xeno" then
        return true
    else
        return false
    end
end

local WAIT = wait
local Wait = wait
local Cars = find_folder("Cars")
local Player_Cars = find_folder("PlayerCars", ReplicatedStorage or game.ReplicatedStorage)
local loadCharRemote = find_RE("loadChar")
local TeamEvent = find_RE('TeamEvent')
local SpawnCar = find_RE('SpawnCar')
local Settings_Remote = find_RE("settings")
local Song_Control_Event = find_RE("songcontrol")
local LocalPlayer = g.LocalPlayer or game.Players.LocalPlayer
local Character = g.Character or LocalPlayer.Character or g.get_char(LocalPlayer, 10)
local Humanoid = g.Humanoid or g.Character and g.Character:FindFirstChildWhichIsA("Humanoid") or g.get_human(LocalPlayer, 10)
local Head = g.Head or g.Character and g.Character:FindFirstChild("Head") or g.get_head(LocalPlayer, 10)
local HumanoidRootPart = g.HumanoidRootPart or g.Character and g.Character:FindFirstChild("HumanoidRootPart") or g.get_root(LocalPlayer, 10)
local PlayerGui = g.PlayerGui or LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
local PlayerScripts = LocalPlayer:FindFirstChildOfClass('PlayerScripts') or LocalPlayer:WaitForChild("PlayerScripts", 5)
local GC = getconnections or get_signal_cons
get_or_set("SoundService", g.SoundService or cloneref and cloneref(game:GetService("SoundService")) or game:GetService("SoundService"))
http_req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
if not getgenv().GunModsSecureBypassInitialized then
    local function try_hookfunction()
        if not hookfunction then return false end
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Modules = ReplicatedStorage:WaitForChild("Modules")
        local RemoteHandler = require(Modules:WaitForChild("RemoteHandler"))
        local RemoteHandler__Fire; RemoteHandler__Fire = hookfunction(RemoteHandler.Fire, function(name, ...)
            if name == "SecureSettings" then return end
            return RemoteHandler__Fire(name, ...)
        end)
        return true
    end

    local function try_getgc()
        if not getgc or not debug or not debug.getinfo then
            return false
        end

        local targets = { "RemoteHandler" }
        local found_table

        for _, target in ipairs(targets) do
            for _, obj in ipairs(getgc(true)) do
                if typeof(obj) == "table" then
                    local any_func
                    for _, v in pairs(obj) do
                        if typeof(v) == "function" then
                            any_func = v
                            break
                        end
                    end

                    if any_func then
                        local info = debug.getinfo(any_func)
                        if info and info.source and info.source:find(target) then
                            found_table = obj
                            break
                        end
                    end
                end
            end
            if found_table then break end
        end

        if not found_table then
            return false
        end

        if typeof(found_table.Fire) == "function" then
            found_table.Fire = function(...)
                return
            end
        end

        if typeof(found_table.Invoke) == "function" then
            found_table.Invoke = function(...)
                return
            end
        end

        return true
    end

    local function try_mt_hook()
        if not getrawmetatable or not setreadonly then return false end
        local meta = getrawmetatable(game)
        if not meta then return false end
        local backup = meta.__namecall
        setreadonly(meta, false)
        local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
        local target_remote = remotes:FindFirstChild("SecureSettings")

        meta.__namecall = function(self, ...)
            local method = getnamecallmethod()

            if self == target_remote and (method == "FireServer" or method == "InvokeServer") then
                return
            end

            return backup(self, ...)
        end

        setreadonly(meta, true)
        return true
    end

    if not try_hookfunction() and not try_getgc() then try_mt_hook() end
    getgenv().GunModsSecureBypassInitialized = true
end

local function footstep_sounds()
    if not SoundService then
        getgenv().notify("Error", "SoundService not found.", 5)
        return nil
    end

    for _, v in ipairs(SoundService:GetDescendants()) do
        if v:IsA("SoundGroup") and v.Name:lower():find("foot") then
            return v
        end
    end

    return nil
end

wait()
getgenv().All_Teams = getgenv().All_Teams or {}

for _, team in pairs(Teams:GetChildren()) do
    table.insert(getgenv().All_Teams, team.Name)
end
wait(0.3)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
getgenv().job_hooked = getgenv().job_hooked or false
getgenv().job_hook_map = getgenv().job_hook_map or {}
getgenv().job_respawn_conn = getgenv().job_respawn_conn or nil
getgenv().job_humanoid_died_conn = getgenv().job_humanoid_died_conn or nil
getgenv().job_disabled_ref = getgenv().job_disabled_ref or nil

local players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local local_player = players.LocalPlayer
local get_conns_func = getconnections or get_signal_cons

local function get_char_local(plr)
    return plr.Character or plr:FindFirstChild("pChar") or plr:WaitForChild("Character", 3)
end

local function disable_script_fallback(char)
    if not char then return end
    local sc = char:FindFirstChild("jobCheck")
    if sc and sc:IsA("LocalScript") and not getgenv().job_disabled_ref then
        sc:SetAttribute("job_toggle_disabled", true)
        sc.Disabled = true
        getgenv().job_disabled_ref = sc
    end
end

local function restore_script_fallback(char)
    if not char then return end
    for _, s in ipairs(char:GetChildren()) do
        if s.Name == "jobCheck" and s:IsA("LocalScript") then
            if s:GetAttribute("job_toggle_disabled") then
                local c = s:Clone()
                c:SetAttribute("job_toggle_disabled", nil)
                c.Parent = char
                c.Disabled = false
                s:Destroy()
                getgenv().job_disabled_ref = nil
                return
            end
        end
    end
end

local function apply_hooks()
    if getgenv().job_hooked then return end
    local char = get_char_local(local_player)
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if get_conns_func then
        getgenv().job_hook_map = {}

        for _, con in ipairs(get_conns_func(hrp.Touched)) do
            if con and con.Function then
                local o = hookfunction(con.Function, function(...)
                    return o(...)
                end)
                getgenv().job_hook_map[con] = o
            end
        end

        for _, con in ipairs(get_conns_func(hrp.TouchEnded)) do
            if con and con.Function then
                local o = hookfunction(con.Function, function(...)
                    return o(...)
                end)
                getgenv().job_hook_map[con] = o
            end
        end

        for _, con in ipairs(get_conns_func(hum.HealthChanged)) do
            if con and con.Function then
                local o = hookfunction(con.Function, function(...)
                    return o(...)
                end)
                getgenv().job_hook_map[con] = o
            end
        end
    else
        disable_script_fallback(char)
    end

    getgenv().job_hooked = true
end

local function remove_hooks()
    if not getgenv().job_hooked then return end

    if get_conns_func then
        for con, original in pairs(getgenv().job_hook_map) do
            pcall(function()
                hookfunction(con.Function, original)
            end)
        end
        getgenv().job_hook_map = {}
    else
        local char = get_char_local(local_player)
        restore_script_fallback(char)
    end

    getgenv().job_hooked = false
    if getgenv().job_humanoid_died_conn then
        pcall(function() getgenv().job_humanoid_died_conn:Disconnect() end)
        getgenv().job_humanoid_died_conn = nil
    end
end

getgenv().job_toggle = getgenv().job_toggle or function(state)
    if state then
        apply_hooks()

        if getgenv().job_respawn_conn then
            pcall(function() getgenv().job_respawn_conn:Disconnect() end)
            getgenv().job_respawn_conn = nil
        end

        getgenv().job_respawn_conn = local_player.CharacterAdded:Connect(function()
            wait(0.1)
            if getgenv().job_hooked then
                apply_hooks()
            end
        end)
    else
        remove_hooks()

        if getgenv().job_respawn_conn then
            pcall(function() getgenv().job_respawn_conn:Disconnect() end)
            getgenv().job_respawn_conn = nil
        end
    end
end

local vc_internal = cloneref and cloneref(game:GetService('VoiceChatInternal')) or game:GetService('VoiceChatInternal')
local vc_service = cloneref and cloneref(game:GetService('VoiceChatService')) or game:GetService('VoiceChatService')

if not getgenv().voiceChat_Check then
    getgenv().voiceChat_Check = true
    local reconnecting = false
    local retryDuration = 4
    local maxAttempts = 500

    local function unsuspend()
        if reconnecting then
            return 
        end
        reconnecting = true

        local attempts = 0
        while attempts < maxAttempts do
            local VoiceChatInternal = cloneref and cloneref(game:GetService('VoiceChatInternal')) or game:GetService('VoiceChatInternal')
            local VoiceChatService = cloneref and cloneref(game:GetService('VoiceChatService')) or game:GetService('VoiceChatService')

            VoiceChatInternal:Leave()
            wait(0.2)
            VoiceChatService:rejoinVoice()
            wait(0.1)
            VoiceChatService:joinVoice()
            wait(0.3)
            VoiceChatInternal:Leave()
            task.wait(0.3)
            VoiceChatService:rejoinVoice()
            VoiceChatService:joinVoice()
            wait(0.5)
            if vc_internal.StateChanged ~= Enum.VoiceChatState.Ended then
                reconnecting = false
                return
            end

            attempts = attempts + 1
            wait(retryDuration)
        end

        reconnecting = false
    end

    local function onVoiceChatStateChanged(_, newState)
        if newState == Enum.VoiceChatState.Ended and not reconnecting then
            unsuspend()
        end
    end

    vc_internal.StateChanged:Connect(onVoiceChatStateChanged)
end

local IMAGE_ID = 0

if vc_internal.StateChanged == Enum.VoiceChatState.Ended then
    vc_internal:Leave()
    vc_internal:Leave()
    task.wait(0.1)
    vc_service:rejoinVoice()
    vc_service:joinVoice()
    wait()
    vc_internal:Leave()
    wait(0.2)
    vc_service:rejoinVoice()
    vc_service:joinVoice()
    task.wait(0.2)
    vc_service:rejoinVoice()
end

local function FindInChassisInterface(targetName)
    local screenGui = PlayerGui:FindFirstChild("A-Chassis Interface")
    if not screenGui then return nil end

    targetName = tostring(targetName):lower()

    local function scan(obj)
        for _, child in ipairs(obj:GetChildren()) do
            if child.Name:lower():find(targetName) then
                return child
            end
            local found = scan(child)
            if found then return found end
        end
    end

    return scan(screenGui)
end

local function request_vehicle()
    local lp = LocalPlayer

    if Player_Cars then
        for _, v in ipairs(Player_Cars:GetChildren()) do
            if v.Name == lp.Name and v.Value then
                return v.Value
            end
        end
    end

    if Cars and #Cars:GetChildren() > 0 then
        for _, v in ipairs(Cars:GetChildren()) do
            local pl = v:FindFirstChild("PlayerLoc")
            if pl and pl.Value == lp then
                return v
            end
        end
    end

    return nil
end

local function is_car_locked()
    local val = g.LocalPlayer:FindFirstChild("Locked") or game.Players.LocalPlayer:FindFirstChild("Locked")

    if val and val.Value == true then
        return true
    elseif val and val.Value == false then
        return false
    else
        return "error"
    end
end

local function get_body_from_vehicle()
    local main_vehicle = request_vehicle()
    if not main_vehicle then return nil end
    local target = "body"

    local function scan_car(obj)
        for _, v in ipairs(obj:GetChildren()) do
            if v.Name:lower():find(target) then
                return v
            end
            local found = scan_car(v)
            if found then return found end
        end
    end

    return scan_car(main_vehicle)
end

local function get_part_from_vehicle(part)
    local car = request_vehicle()
    if not car then return nil end

    part = part:lower()

    for _, v in ipairs(car:GetDescendants()) do
        if v.Name:lower():find(part) then
            return v
        end
    end

    return nil
end

local Window = Rayfield:CreateWindow({
    Name = 'Flames Hub | SWFL Hub | '..tostring(Script_Version)..' | '..tostring(executor_Name),
    LoadingTitle = 'Enjoy, '..tostring(LocalPlayer),
    LoadingSubtitle = 'SWFL Hub.',
    ConfigurationSaving = {
        Enabled = false,
        FolderName = 'Config-SWFL',
        FileName = 'Config-SWFLScriptHub',
    },
    Discord = {
        Enabled = false,
        Invite = '',
        RememberJoins = false,
    },
    KeySystem = false,
    KeySettings = {
        Title = 'None',
        Subtitle = 'No key system is provided.',
        Note = '...',
        FileName = 'Key',
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = { 'None' },
    },
})
wait()
function notify_rf(title, content, duration)
    Rayfield:Notify({
        Title = tostring(title),
        Content = tostring(content),
        Duration = tonumber(duration),
        Image = tonumber(IMAGE_ID),
        Actions = {
            Ignore = {
                Name = 'Okay.',
                Callback = function()
                    print('...')
                end,
            },
        },
    })
end
wait()
local Tab1 = Window:CreateTab('🏡 Home 🏡', IMAGE_ID)
local Section1 = Tab1:CreateSection('||| 🏡 Home 🏡 Section |||')
local Tab2 = Window:CreateTab('🧍 LocalPlayer 🧍', IMAGE_ID)
local Section2 = Tab2:CreateSection('||| 🧍 LocalPlayer 🧍 Section |||')
local Tab3 = Window:CreateTab('🚗 Vehicle 🚗', IMAGE_ID)
local Section3 = Tab3:CreateSection('||| 🚗 Vehicle 🚗 Section |||')
local Tab4 = Window:CreateTab('🔥‍ Car Mods 🔥', IMAGE_ID)
local Section4 = Tab4:CreateSection('||| 🔥‍ Modifications 🔥‍ Section |||')
local Tab5 = Window:CreateTab('🤖‍ Exploits 🤖', IMAGE_ID)
local Section5 = Tab5:CreateSection('||| 🤖‍ Exploits 🤖‍ Section |||')
local Tab6 = Window:CreateTab('🦿 Teleports 🦿', IMAGE_ID)
local Section6 = Tab6:CreateSection('||| 🦿 Teleports 🦿 Section |||')

if PlayerScripts:FindFirstChild("TireSmokeHandler") and PlayerScripts:FindFirstChild("TireSmokeHandler"):IsA("LocalScript") then
    if PlayerScripts:FindFirstChild("TireSmokeHandler").Disabled == false then
        getgenv().notify("Info", "Disabling LocalScript...", 5)
        PlayerScripts:FindFirstChild("TireSmokeHandler").Disabled = true
        wait(1)
        if PlayerScripts:FindFirstChild("TireSmokeHandler") and PlayerScripts:FindFirstChild("TireSmokeHandler"):IsA("LocalScript") and PlayerScripts:FindFirstChild("TireSmokeHandler").Disabled then
            getgenv().notify("Success", "Disabled TireSmokeHandler (not needed).", 5)
        end
    end
end

getgenv().vehicle_speed_boost_toggle = function(toggled)
    if toggled == true then
        if getgenv().vehicle_speed_boost_active then return end
        local current_vehicle = request_vehicle()
        if not current_vehicle then
            if getgenv().Apply_Best_Vehicle_Settings then getgenv().Apply_Best_Vehicle_Settings:Set(false) end
            return getgenv().notify("Error", "No vehicle found.", 5)
        end
        local DriveSeat = current_vehicle:FindFirstChildOfClass("VehicleSeat")
        if not DriveSeat then
            if getgenv().Apply_Best_Vehicle_Settings then getgenv().Apply_Best_Vehicle_Settings:Set(false) end
            return getgenv().notify("Error", "No VehicleSeat found.", 5)
        end
        local Player = cloneref(game:GetService("Players")).LocalPlayer
        local Current_Speed = 0
        local S_Hold_Start = nil
        local Is_Mobile = cloneref(game:GetService("UserInputService")).TouchEnabled
        local BV = DriveSeat:FindFirstChild("FlamesSpeedBoost") or Instance.new("BodyVelocity")
        BV.Name = "FlamesSpeedBoost"
        BV.MaxForce = Vector3.new(9e9, 0, 9e9)
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.Parent = DriveSeat
        local BG = DriveSeat:FindFirstChild("FlamesSpeedGyro") or Instance.new("BodyGyro")
        BG.Name = "FlamesSpeedGyro"
        BG.P = 9e4
        BG.MaxTorque = Vector3.new(0, 9e9, 0)
        BG.CFrame = DriveSeat.CFrame
        BG.Parent = DriveSeat
        getgenv().vehicle_speed_boost_active = true
        getgenv().vehicle_speed_boost_max_forward = getgenv().vehicle_speed_boost_max_forward or 425
        getgenv().vehicle_speed_boost_max_backward = getgenv().vehicle_speed_boost_max_backward or 125
        getgenv().vehicle_speed_boost_acceleration = getgenv().vehicle_speed_boost_acceleration or 10
        getgenv().notify("Success", "Vehicle Speed Boost is now enabled.", 1.5)
        getgenv().FlamesLibrary.spawn("vehicle_speed_boost_loop", "spawn", function()
            while getgenv().vehicle_speed_boost_active do
                if not current_vehicle or not current_vehicle.Parent then
                    getgenv().vehicle_speed_boost_active = false
                    if getgenv().Apply_Best_Vehicle_Settings then getgenv().Apply_Best_Vehicle_Settings:Set(false) end
                    break
                end
                local Max_Forward_Speed = getgenv().vehicle_speed_boost_max_forward or 425
                local Max_Backward_Speed = getgenv().vehicle_speed_boost_max_backward or 125
                local Acceleration = getgenv().vehicle_speed_boost_acceleration or 10
                local Throttle = DriveSeat.Throttle
                if Is_Mobile then
                    local ControlModule = require(Player.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
                    local Direction = ControlModule:GetMoveVector()
                    Throttle = -Direction.Z
                end
                if Throttle > 0 then
                    S_Hold_Start = nil
                    Current_Speed = math.min(Current_Speed + Acceleration, Max_Forward_Speed)
                    BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
                    BG.CFrame = DriveSeat.CFrame
                elseif Throttle < 0 then
                    if not S_Hold_Start then S_Hold_Start = tick() end
                    if tick() - S_Hold_Start >= 0.45 then
                        Current_Speed = math.max(Current_Speed - Acceleration, -Max_Backward_Speed)
                        BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
                    else
                        Current_Speed = math.max(Current_Speed - Acceleration * 3, 0)
                        BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
                    end
                else
                    S_Hold_Start = nil
                    Current_Speed = math.max(Current_Speed - Acceleration * 2, 0)
                    BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
                end
                task.wait(0.03)
            end
            BV:Destroy()
            BG:Destroy()
        end)
    elseif toggled == false then
        getgenv().vehicle_speed_boost_active = false
        local current_vehicle = request_vehicle()
        if not current_vehicle then return end
        local DriveSeat = current_vehicle:FindFirstChildOfClass("VehicleSeat")
        if not DriveSeat then return end
        local BV = DriveSeat:FindFirstChild("FlamesSpeedBoost")
        local BG = DriveSeat:FindFirstChild("FlamesSpeedGyro")
        if BV then BV:Destroy() end
        if BG then BG:Destroy() end
        getgenv().notify("Success", "Vehicle Speed Boost is now disabled.", 1.5)
    end
end

getgenv().antiAFK_Toggle = Tab1:CreateToggle({
Name = 'Anti AFK',
CurrentValue = getgenv().anti_afk_toggle_enabled or false,
Flag = 'AntiAFKToggleIdling',
Callback = function(toggleTheAntiAFK)
    if toggleTheAntiAFK then
        if getgenv().AntiAFK_Connection then
            getgenv().AntiAFK_Connection:Disconnect()
            getgenv().AntiAFK_Connection = nil
        end

        if getgenv().AntiAFK_Connections then
            for _, conn in pairs(getgenv().AntiAFK_Connections) do
                conn:Disconnect()
            end
            getgenv().AntiAFK_Connections = nil
        end

        getgenv().anti_afk_toggle_enabled = true
        getgenv().Use_GetConnections = not getgenv().Use_GetConnections
        getgenv().Use_VirtualUser = not getgenv().Use_VirtualUser
        local function disableAFKUsingGetConnections()
            if GC then
                getgenv().Use_GetConnections = true
                getgenv().Use_VirtualUser = false
                getgenv().AntiAFK_Connections = {}
                for _, v in pairs(GC(LocalPlayer.Idled)) do
                    if v.Disable then
                        v:Disable()
                    elseif v.Disconnect then
                        v:Disconnect()
                    end
                    table.insert(getgenv().AntiAFK_Connections, v)
                end
            end
        end

        local function disableAFKUsingVirtualUser()
            getgenv().Use_VirtualUser = true
            getgenv().Use_GetConnections = false
            wait()
            getgenv().AntiAFK_Connection = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end

        if ReplicatedStorage:FindFirstChild('AfkEvent') then
            ReplicatedStorage:FindFirstChild('AfkEvent').Parent = SoundService
        end
        if PlayerScripts:FindFirstChild('afkEnable') then
            PlayerScripts:FindFirstChild('afkEnable').Disabled = true
            PlayerScripts:FindFirstChild('afkEnable'):FindFirstChild('afkCheck2').Disabled = true
            PlayerScripts:FindFirstChild('afkEnable'):FindFirstChild('afkCheck3').Disabled = true
            wait(0.3)
            PlayerScripts:FindFirstChild('afkEnable').Parent = SoundService
        end
        if GC then
            disableAFKUsingGetConnections()
        else
            disableAFKUsingVirtualUser()
        end
    else
        if getgenv().AntiAFK_Connection then
            getgenv().AntiAFK_Connection:Disconnect()
            getgenv().AntiAFK_Connection = nil
        end

        if getgenv().AntiAFK_Connections then
            for _, conn in pairs(getgenv().AntiAFK_Connections) do
                if typeof(conn) ~= "table" then
                    conn:Disconnect()
                end
            end
            getgenv().AntiAFK_Connections = nil
        end
        if SoundService:FindFirstChild('AfkEvent') then
            SoundService:FindFirstChild('AfkEvent').Parent = ReplicatedStorage
        end
        if SoundService:FindFirstChild("afkEnable") then
            SoundService:FindFirstChild('afkEnable').Parent = PlayerScripts
        end
        getgenv().anti_afk_toggle_enabled = false
    end
end,})

if getgenv().Use_GetConnections or getgenv().Use_VirtualUser then
    getgenv().antiAFK_Toggle:Set(false)
end

local footsteps_sound = footstep_sounds()
getgenv().footsteps_set_volume_sound = getgenv().footsteps_set_volume_sound or 1
getgenv().WalkingAndJumpingSounds = Tab2:CreateSlider({
Name = 'Footstep Sounds Volume',
Range = {0, 10},
Increment = 0.1,
Suffix = "",
CurrentValue = getgenv().footsteps_set_volume_sound or 1,
Flag = "FootstepSoundSlider",
Callback = function(vol)
    local group = footstep_sounds()
    if not group then
        getgenv().WalkingAndJumpingSounds:Set(1)
        return getgenv().notify("Error", "Footsteps SoundGroup not found.", 5)
    end

    if not footsteps_sound then
        return getgenv().notify("Warning", tostring(footsteps_sound).." was not found.", 5)
    end

    for _, v in ipairs(footsteps_sound:GetChildren()) do
        if v:IsA("Sound") then
            v.Volume = tonumber(vol) or vol
        end
    end
end,})

if footsteps_sound and footsteps_sound:FindFirstChild("Basalt").Volume == 0 then
    getgenv().WalkingAndJumpingSounds:Set(1)
    wait(0.2)
    footsteps_sound.Volume = 1
    for _, v in ipairs(footsteps_sound:GetDescendants()) do
        if v:IsA("Sound") then
            v.Volume = 1
        end
    end
elseif not footsteps_sound then
    getgenv().WalkingAndJumpingSounds:Set(1)
elseif not footsteps_sound:FindFirstChild("Basalt") then
    getgenv().WalkingAndJumpingSounds:Set(1)
end

getgenv()._jumpcd_disabled_refs = getgenv()._jumpcd_disabled_refs or {}

if not getgenv().InitializedCharAddedCheckJumpCooldown then
    local get_conn_func = getconnections or get_signal_cons

    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(1)
        if not char then
            repeat task.wait() until char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart")
        end
        getgenv().notify("Info", "Got new character: "..tostring(char), 5)
        if get_conn_func then
            if getgenv().JumpCooldown_Disabled_Check then
                for _, c in pairs(get_conn_func(get_human(LocalPlayer):GetPropertyChangedSignal("FloorMaterial"))) do
                    c:Disable()
                end
            end
        else
            if getgenv().JumpCooldown_Disabled_Check then
                local new_char_main = char or get_char(LocalPlayer)
                if new_char_main then
                    local main_localscript = new_char_main:FindFirstChild("JumpCooldown2")
                    if main_localscript and main_localscript:IsA("LocalScript") and main_localscript.Disabled == false then
                        main_localscript:SetAttribute("ez_disabled_by_toggle", true)
                        main_localscript.Disabled = true
                        getgenv()._jumpcd_disabled_refs[main_localscript] = true
                    end
                end
            end
        end
    end)
    wait(0.2)
    getgenv().InitializedCharAddedCheckJumpCooldown = true
end

local function restore_jump_script_if_needed(char)
    if not char then return end
    for _, child in pairs(char:GetChildren()) do
        if child.Name == "JumpCooldown2" and child:IsA("LocalScript") then
            if child and child:GetAttribute("ez_disabled_by_toggle") then
                local clone = child:Clone()
                clone:SetAttribute("ez_disabled_by_toggle", nil)
                clone.Parent = char
                clone.Disabled = false
                child:Destroy()
            end
        end
    end
end

getgenv().NoJumpCooldownToggle = Tab2:CreateToggle({
Name = 'Disable Jump Cooldown (FE)',
CurrentValue = getgenv().JumpCooldown_Disabled_Check or false,
Flag = 'ezBypassJumpCooldowns',
Callback = function(bypassingJumpCooldown)
    if bypassingJumpCooldown then
        getgenv().JumpCooldown_Disabled_Check = true
        local get_conn_func = getconnections or get_signal_cons
        local main_char = get_char(LocalPlayer) or game.Players.LocalPlayer.Character

        if get_conn_func then
            for _, c in pairs(get_conn_func(get_human(LocalPlayer):GetPropertyChangedSignal("FloorMaterial"))) do
                c:Disable()
            end
        else
            if main_char and main_char:FindFirstChild("JumpCooldown2") then
                local Main_LS = main_char:FindFirstChild("JumpCooldown2")
                if Main_LS and Main_LS:IsA("LocalScript") then
                    Main_LS:SetAttribute("ez_disabled_by_toggle", true)
                    Main_LS.Disabled = true
                    getgenv()._jumpcd_disabled_refs[Main_LS] = true
                end
            end
        end
    else
        getgenv().JumpCooldown_Disabled_Check = false
        local get_conn_func = getconnections or get_signal_cons

        if get_conn_func then
            for _, c in pairs(get_conn_func(get_human(LocalPlayer):GetPropertyChangedSignal("FloorMaterial"))) do
                c:Enable()
            end
        else
            local main_char = get_char(LocalPlayer) or game.Players.LocalPlayer.Character
            restore_jump_script_if_needed(main_char)
        end
    end
end,})

getgenv().RespawnCharacterFast = Tab2:CreateButton({
Name = 'Respawn (FE)',
Callback = function()
    loadCharRemote:FireServer()
end,})

getgenv().ChooseADifferentTeam = Tab1:CreateDropdown({
Name = 'Change Team (FE)',
Options = getgenv().All_Teams,
CurrentOption = 'Team',
MultipleOptions = false,
Flag = 'chooseAnotherTeamRemote',
Callback = function(theTeamChosen)
    local another_team = theTeamChosen and theTeamChosen[1] or theTeamChosen
    local Get_Team = Teams:FindFirstChild(another_team)

    TeamEvent:FireServer(Get_Team.TeamColor)
end,})

getgenv().TeleportToPurchaseCarMenu = Tab6:CreateButton({
Name = 'TP To Purchase Vehicle Menu',
Callback = function()
    local DealershipPart = Workspace:FindFirstChild('DealershipPart')
    if not DealershipPart then return end

    Character:PivotTo(DealershipPart:GetPivot())
end,})

getgenv().MakeJobMoneyAnywhere = Tab2:CreateToggle({
Name = "Make money anywhere from your job (FE).",
CurrentValue = getgenv().job_hooked or false,
Flag = "MakeMoneyAnywhereFromJob",
Callback = function(ez_job_keeper)
    if ez_job_keeper then
        getgenv().job_toggle(true)
    else
        getgenv().job_toggle(false)
    end
end,})

getgenv().LockVehicleToggle = Tab3:CreateToggle({
Name = "Lock Vehicle (FE)",
CurrentValue = false,
Flag = "LockCurrentVehicleToggle",
Callback = function(locked_vehicle)
    if locked_vehicle then
        if Settings_Remote and Settings_Remote:IsA("RemoteEvent") then
            local args = {
                "Setting",
                "Locked",
                true
            }
            
            Settings_Remote:FireServer(unpack(args))
        end
    else
        if Settings_Remote and Settings_Remote:IsA("RemoteEvent") then
            local args = {
                "Setting",
                "Locked",
                false
            }
            
            Settings_Remote:FireServer(unpack(args))
        end
    end
end,})

if is_car_locked() == true then
    getgenv().LockVehicleToggle:Set(false)
end

--[[getgenv().MoreRainbowCarColors = Tab3:CreateToggle({
Name = "Full Rainbow Vehicle (FE, Needs GamePass)",
CurrentValue = false,
Flag = "MainFullCarColoring",
Callback = function(full_rainbow_fe_car)
    local Player_Vehicle = request_vehicle()
    if not Player_Vehicle then
        getgenv().Full_RGB_Car_Colors = false
        getgenv().MoreRainbowCarColors:Set(false)
        return getgenv().notify("Error", "You have not spawned a vehicle, spawn one!", 5)
    end

    local Vehicle_Color_Part = get_part_from_vehicle("Color")
    local M5_Part = get_part_from_vehicle("M5")
    local Remote = get_part_from_vehicle("Prop_FE")

    if not Vehicle_Color_Part or not M5_Part or not Remote then
        getgenv().Full_RGB_Car_Colors = false
        getgenv().MoreRainbowCarColors:Set(false)
        return getgenv().notify("Error", "Vehicle missing Color, M5, or Prop_FE!", 5)
    end

    if full_rainbow_fe_car then
        getgenv().Full_RGB_Car_Colors = true

        if getgenv().FullRGB_Vehicle_Task then
            pcall(task.cancel, getgenv().FullRGB_Vehicle_Task)
        end

        getgenv().FullRGB_Vehicle_Task = task.spawn(function()
            while task.wait() and getgenv().Full_RGB_Car_Colors == true do
                local veh = request_vehicle()
                if not veh then break end

                local ColorP = get_part_from_vehicle("Color")
                local M5 = get_part_from_vehicle("M5")
                local Remote = get_part_from_vehicle("Prop_FE")

                if not ColorP or not M5 or not Remote then break end

                for _, rgb in ipairs(colors) do
                    if not getgenv().Full_RGB_Car_Colors then
                        break
                    end

                    Remote:FireServer("UpdateColor", ColorP, rgb[1], rgb[2], rgb[3])
                    Remote:FireServer("UpdateColor", M5, rgb[1], rgb[2], rgb[3])
                    task.wait(0.01)
                end
            end

            getgenv().Full_RGB_Car_Colors = false
            pcall(function() getgenv().MoreRainbowCarColors:Set(false) end)
        end)
    else
        getgenv().Full_RGB_Car_Colors = false

        if getgenv().FullRGB_Vehicle_Task then
            pcall(task.cancel, getgenv().FullRGB_Vehicle_Task)
        end

        getgenv().FullRGB_Vehicle_Task = nil
    end
end,})

if getgenv().Full_RGB_Car_Colors then
    getgenv().Full_RGB_Car_Colors = false
    getgenv().MoreRainbowCarColors:Set(false)
end--]]

g.tested_car_colors = g.tested_car_colors or {}
g._rainbow_lock = g._rainbow_lock or false
g.Rainbow_Vehicle = g.Rainbow_Vehicle or false
local function colors_close(a, b, tolerance)
    tolerance = tolerance or 0.01
    return math.abs(a.R - b.R) < tolerance and math.abs(a.G - b.G) < tolerance and math.abs(a.B - b.B) < tolerance
end

local function find_color_scrollframe(timeout)
    local start = os.clock()
    while os.clock() - start < timeout do
        for _, v in ipairs(PlayerGui:GetDescendants()) do
            if v:IsA("ScrollingFrame") and v:FindFirstChild("color1", true) then
                return v
            end
        end
        task.wait(0.2)
    end
    return nil
end

local function scan_factory_colors()
    local scrollFrame = find_color_scrollframe(5)
    if not scrollFrame then
        return false
    end

    table.clear(g.tested_car_colors)
    local seen = {}
    for _, v in ipairs(scrollFrame:GetDescendants()) do
        if v:IsA("GuiObject") then
            local c = v.BackgroundColor3
            local r = math.floor(c.R * 255 + 0.5)
            local gg = math.floor(c.G * 255 + 0.5)
            local b = math.floor(c.B * 255 + 0.5)
            local key = r.."|"..gg.."|"..b
            if not seen[key] then
                seen[key] = true
                table.insert(g.tested_car_colors, {name = v.Name, c = Color3.fromRGB(r, gg, b)})
            end
        end
    end

    return #g.tested_car_colors > 0
end

local function start_rainbow(propFE, colorPart)
    g.Rainbow_Vehicle = true
    task.spawn(function()
        while g.Rainbow_Vehicle do
            for _, entry in ipairs(g.tested_car_colors) do
                if not g.Rainbow_Vehicle then break end
                local r, gg, b = entry.c.R * 255, entry.c.G * 255, entry.c.B * 255
                propFE:FireServer("UpdateColor", colorPart, r, gg, b)
                task.wait(0)
            end
            task.wait()
        end
    end)
end

local function stop_rainbow() g.Rainbow_Vehicle = false end
getgenv().RainbowCarFE = Tab3:CreateToggle({
Name = "Rainbow Vehicle (FE, No GamePass needed!)",
CurrentValue = g.Rainbow_Vehicle or false,
Flag = "rainbowCarFEScript",
Callback = function(toggle)
    if g._rainbow_lock then return end
    local vehicle = request_vehicle()
    if not toggle or not vehicle then
        stop_rainbow()
        g._rainbow_lock = true
        g.RainbowCarFE:Set(false)
        g._rainbow_lock = false
        return
    end

    local colorPart, propFE = get_FE_ColorPart(vehicle)

    if not colorPart or not propFE then
        stop_rainbow()
        g._rainbow_lock = true
        g.RainbowCarFE:Set(false)
        g._rainbow_lock = false
        return g.notify("Error", "Vehicle missing Color part or Prop_FE!", 6)
    end

    if not scan_factory_colors() then
        g._rainbow_lock = true
        g.RainbowCarFE:Set(false)
        g._rainbow_lock = false
        return g.notify("Error", "Could not find factory color list — open the paint shop UI first!", 6)
    end

    start_rainbow(propFE, colorPart)
end,})

getgenv().RemoveRain = Tab1:CreateToggle({
Name = "Remove Rain",
CurrentValue = getgenv().swapped_rain_stuff or false,
Flag = "temporarilyRemoveRainToggle",
Callback = function(theRainGone)
    local move_to_where
    local items = {"thunder1","thunder2","thunder3","thunder4","thunder5","thunder6","rainStorage"}
    
    if theRainGone then
        getgenv().swapped_rain_stuff = true
        move_to_where = AssetService

        for _, name in ipairs(items) do
            local obj = Workspace:FindFirstChild(name)
            if obj then obj.Parent = move_to_where end
        end

        local rain_local_script = PlayerScripts:FindFirstChild("RainScript")
        if rain_local_script then rain_local_script.Parent = move_to_where end

        local miscs = ReplicatedStorage:FindFirstChild("Miscs")
        if miscs and miscs:FindFirstChild("Rain") then
            miscs.Rain.Parent = move_to_where
        end
    else
        getgenv().swapped_rain_stuff = false
        wait(0.1)
        move_to_parents = {
            Workspace = Workspace,
            PlayerScripts = PlayerScripts,
            Miscs = ReplicatedStorage:FindFirstChild("Miscs")
        }

        for _, name in ipairs(items) do
            local obj = AssetService:FindFirstChild(name)
            if obj then obj.Parent = move_to_parents.Workspace end
        end

        local rain_script = AssetService:FindFirstChild("RainScript")
        if rain_script then rain_script.Parent = move_to_parents.PlayerScripts end

        local rain = AssetService:FindFirstChild("Rain")
        if rain and move_to_parents.Miscs then rain.Parent = move_to_parents.Miscs end
    end
end,})

getgenv().playable_audio_id = "1"
wait(0.1)
getgenv().PlayAnAudioID = Tab3:CreateInput({
Name = "Set Audio ID",
CurrentValue = getgenv().playable_audio_id and tostring(getgenv().playable_audio_id) or "ID Here",
PlaceholderText = "ID Here",
RemoveTextAfterFocusLost = true,
Flag = "audioIDInput",
Callback = function(theAudioID)
    local Player_Vehicle = request_vehicle()
    if not Player_Vehicle then
        getgenv().PlayAnAudioID:Set("ID Here")
        return getgenv().notify("Error", "Please spawn a Vehicle first.", 6)
    end

    getgenv().playable_audio_id = tostring(theAudioID)
    local OwnID_TextLabel = FindInChassisInterface("ownID")
    if not OwnID_TextLabel then return end
    local Body = get_body_from_vehicle()
    if not Body then return end
    local radio_tog = get_part_from_vehicle("radioTog")
    if not radio_tog then return end
    OwnID_TextLabel.Text = getgenv().playable_audio_id
    radio_tog.Value = true
end,})

getgenv().PlayAudioID = Tab3:CreateToggle({
Name = "Play Set Audio",
CurrentValue = getgenv().ok_boys_lets_play or false,
Flag = "TheAudioPlaying",
Callback = function(whatAudioWePlaying)
    local Player_Vehicle = request_vehicle()
    if not Player_Vehicle then
        getgenv().PlayAudioID:Set(false)
        return getgenv().notify("Error", "Please spawn a Vehicle first.", 6)
    end

    local Body = get_body_from_vehicle()
    if not Body then
        getgenv().PlayAudioID:Set(false)
        return getgenv().notify("Error", "Vehicle missing Body part!", 6)
    end

    local ownIDConfirm = FindInChassisInterface("ownIDConfirm")
    local radio_tog = get_part_from_vehicle("radioTog")

    if whatAudioWePlaying then
        getgenv().ok_boys_lets_play = true
        if ownIDConfirm then
            Song_Control_Event:FireServer(Player_Vehicle, ownIDConfirm, getgenv().playable_audio_id)
        end
    else
        getgenv().ok_boys_lets_play = false
        if radio_tog then radio_tog.Value = false end
        wait(0.1)
        if ownIDConfirm then
            Song_Control_Event:FireServer(Player_Vehicle, ownIDConfirm, "stop")
        end
    end
end,})

getgenv().HornToggledOn = Tab3:CreateToggle({
Name = "Toggle Horn",
CurrentValue = getgenv().car_horn or false,
Flag = "hornUpdatingToggle",
Callback = function(theHornEnabled)
    local Player_Vehicle = request_vehicle()

    if theHornEnabled then
        if not Player_Vehicle then
            getgenv().HornToggledOn:Set(false)
            return getgenv().notify("Error", "Please spawn a Vehicle first.", 6)
        end
        
        local horn = get_part_from_vehicle("HornUpdate")

        getgenv().car_horn = true
        if horn and horn:IsA("RemoteEvent") then
            horn:FireServer(true)
        else
            getgenv().car_horn = false
            getgenv().HornToggledOn:Set(false)
            return getgenv().notify("Error", "Horn RemoteEvent not found inside Vehicle.", 5)
        end
    else
        local horn = get_part_from_vehicle("HornUpdate")

        getgenv().car_horn = false
        if horn and horn:IsA("RemoteEvent") then
            horn:FireServer(false)
        end
    end
end,})

local horn_upd = get_part_from_vehicle("HornUpdate")

if getgenv().car_horn or getgenv().car_horn == true then
    getgenv().car_horn = false
    getgenv().HornToggledOn:Set(false)
    wait(0.1)
    if horn_upd and horn_upd:IsA("RemoteEvent") then
        horn_upd:FireServer(false)
    end
end

local Wait_Time
local FuelAmount

getgenv().ModifyFuelAmountToBeRefilled = Tab3:CreateInput({
Name = "Fuel Amount (For Loop)",
CurrentValue = "Fuel",
PlaceholderText = "Amount",
RemoveTextAfterFocusLost = true,
Flag = "ModifyingFuelAmountLooping",
Callback = function(the_fuel_amount)
    FuelAmount = tonumber(the_fuel_amount)
end,})

getgenv().WaitTimeForFuelLoop = Tab3:CreateInput({
Name = "Wait Time (To Refill Fuel)",
CurrentValue = "Number",
PlaceholderText = "Wait Time",
RemoveTextAfterFocusLost = true,
Flag = "ModifyWaitTimeForLoop",
Callback = function(wait_time_here)
    Wait_Time = tonumber(wait_time_here)
end,})

getgenv().RefillCarFuelLoop = Tab3:CreateToggle({
Name = "Refill Car Fuel Loop (Cost Money)",
CurrentValue = getgenv().refilling_my_vehicle_fuel or false,
Flag = "RefillingVehicleFuelLoop",
Callback = function(refilling_car)
    local Player_Vehicle = request_vehicle()

    if not Player_Vehicle then
        getgenv().RefillCarFuelLoop:Set(false)
        return getgenv().notify("Error", "Could not find your Vehicle, spawn a vehicle.", 5)
    end

    if not ReplicatedStorage:FindFirstChild("fuelEvent") then
        return getgenv().notify("Error", "This might be patched?: FuelEvent does not exist in ReplicatedStorage!", 10)
    end

    if not ReplicatedStorage:FindFirstChild("PetrolPrice") then
        return getgenv().notify("Error", "PetrolPrice does not exist in RepliatedStorage (broken)!", 5)
    end

    if not ReplicatedStorage:FindFirstChild("DieselPrice") then
        return getgenv().notify("Error", "DieselPrice does not exist in ReplicatedStorage (broken)!", 5) 
    end
    wait()
    if refilling_car and request_vehicle() then
        getgenv().refilling_my_vehicle_fuel = true
        while getgenv().refilling_my_vehicle_fuel == true do
        task.wait(0.3)
            local args = {
                [1] = "requestPurchase",
                [2] = request_vehicle(),
                [3] = tonumber(FuelAmount),
                [4] = ReplicatedStorage:WaitForChild("PetrolPrice"),
                [5] = ReplicatedStorage:WaitForChild("DieselPrice")
            }

            find_RE("fuel"):FireServer(unpack(args))
        end
    elseif not request_vehicle() then
        getgenv().refilling_my_vehicle_fuel = false
    elseif not refilling_car or refilling_car == false then
        getgenv().notify("Info", "Shutting down refilling loop...", 5)
        getgenv().refilling_my_vehicle_fuel = false
        wait(0.5)
        if not getgenv().refilling_my_vehicle_fuel then
            notify("Success", "Successfully shut down refilling loop...", 5)
        end
    end
end,})

getgenv().FuelCarTank = Tab3:CreateInput({
Name = "Car Fuel",
CurrentValue = "Fuel",
PlaceholderText = "Fuel Amount",
RemoveTextAfterFocusLost = true,
Flag = "GetFuelForVehicle",
Callback = function(fuelYouWant)
    if not tonumber(fuelYouWant) then
        return getgenv().notify("Error", "You did not enter in a number.", 6)
    end

    local Player_Vehicle = request_vehicle()
    local fuel_remote = find_RE("fuel")

    if not Player_Vehicle then
        return notify("Error", "You do not have a vehicle spawned!", 5)
    end
    if not fuel_remote then
        return notify("Error", "Fuel RemoteEvent does not exist in ReplicatedStorage!", 5)
    end
    
    if fuel_remote and fuel_remote:IsA("RemoteEvent") then
        local args = {
            [1] = "requestPurchase",
            [2] = Player_Vehicle,
            [3] = tonumber(fuelYouWant),
            [4] = ReplicatedStorage:WaitForChild("PetrolPrice"),
            [5] = ReplicatedStorage:WaitForChild("DieselPrice")
        }

        find_RE("fuel"):FireServer(unpack(args))
    end
end,})

getgenv().StopAllAudios = Tab3:CreateButton({
Name = "Stop All Car Audios",
Callback = function()
    local Player_Vehicle = request_vehicle()

    if not Player_Vehicle then
        return getgenv().notify("Error", "Please spawn a Vehicle first.", 6)
    end

    local ownID_TextLabel = FindInChassisInterface("ownID")

    if Song_Control_Event and Song_Control_Event:IsA("RemoteEvent") then
        local args = {
            [1] = Player_Vehicle,
            [2] = get_part_from_vehicle("ownIDConfirm"),
            [3] = "stop"
        }

        Song_Control_Event:FireServer(unpack(args))
    end
    
    if ownID_TextLabel and ownID_TextLabel.Text then
        ownID_TextLabel.Text = ""
    end
end,})

getgenv().Radio_Volume = Tab3:CreateSlider({
Name = "Radio Volume Controller",
Range = {0, 0.9},
Increment = 0.1,
Suffix = "",
CurrentValue = 0.5,
Flag = "radioVolumeSliderControl",
Callback = function(Radio_Volume_Here)
    local Player_Vehicle = request_vehicle()

    if not Player_Vehicle then
        return 
    end

    if Song_Control_Event and Song_Control_Event:IsA("RemoteEvent") then
        local args = {
            [1] = Player_Vehicle,
            [2] = get_part_from_vehicle("lastVol"),
            [3] = Radio_Volume_Here
        }

        Song_Control_Event:FireServer(unpack(args))
    end
end,})

getgenv().all_lights = getgenv().all_lights or {}

function table_lights()
    local vehicle = request_vehicle()

    if vehicle then
        local lights = get_part_from_vehicle("Lights")

        if lights then
            for _, light in ipairs(lights:GetChildren()) do
                if light:IsA("MeshPart") then
                    table.insert(getgenv().all_lights, light)
                end
            end
        end
    end
end

local function change_light_colors(color)
    local Player_Vehicle = request_vehicle()
    
    for _, light in ipairs(getgenv().all_lights) do
        local args = {
            [1] = "UpdateLight",
            [2] = light,
            [3] = Enum.Material.SmoothPlastic,
            [4] = BrickColor.new(tonumber(color)),
            [5] = 0.015,
            [6] = true,
            [7] = 10,
            [8] = "rbxassetid://8615996420"
        }

        Player_Vehicle:WaitForChild("Lights_FE"):FireServer(unpack(args))
    end
end

getgenv().TheRainbowLights = Tab3:CreateToggle({
Name = "Rainbow Lights (FE)",
CurrentValue = getgenv().spamming_rgb_car_lights or false,
Flag = "UltimateRGBLights",
Callback = function(EnableRainbowLights)
    local Player_Vehicle = request_vehicle()
    local Body = Player_Vehicle:FindFirstChild("Body")
    if not Body then return notify("Error", "'Body' was not found inside Vehicle: "..tostring(request_vehicle().Name).."!", 5) end

    if EnableRainbowLights then
        if not Player_Vehicle then
            getgenv().spamming_rgb_car_lights = false
            getgenv().TheRainbowLights:Set(false)
            return getgenv().notify("Error", "Please spawn a Vehicle first.", 6)
        end
        wait()
        getgenv().spamming_rgb_car_lights = true
        while getgenv().spamming_rgb_car_lights == true do
        wait()
            for _, v in ipairs(Body.Lights:GetDescendants()) do
                if v:IsA("MeshPart") then
                    change_light_colors(1)
                    wait()
                    change_light_colors(21)
                    wait()
                    change_light_colors(23)
                    wait()
                    change_light_colors(26)
                    wait()
                    change_light_colors(22)
                    wait()
                    change_light_colors(25)
                    wait()
                    change_light_colors(37)
                    wait()
                    change_light_colors(104)
                    wait()
                    change_light_colors(193)
                    wait()
                    change_light_colors(327)
                end
            end
        end
    else
        getgenv().spamming_rgb_car_lights = false
        wait()
        getgenv().spamming_rgb_car_lights = false
    end
end,})

if getgenv().spamming_rgb_car_lights or getgenv().spamming_rgb_car_lights == true then
    getgenv().TheRainbowLights:Set(false)
end

getgenv().GetInCar = Tab3:CreateButton({
Name = "Get In Car (from anywhere, spawn vehicle first)",
Callback = function()
    local Player_Vehicle = request_vehicle()
    local prompt_re = find_RE("prompt")

    if not prompt_re then
        return notify("Error", "PromptEvent doesn't exist in ReplicatedStorage! (Patched?)", 5)
    end
    if not Player_Vehicle then
        return getgenv().notify("Error", "Please spawn a Vehicle first.", 6)
    end

    if Character and Character:FindFirstChild("Humanoid") then
        Character:PivotTo(Player_Vehicle:GetPivot())
    else
        notify("Info", "It seems as if your character has not loaded yet!", 5)
        repeat task.wait() until Character and Character:FindFirstChild("Humanoid") and Character:FindFirstChild("HumanoidRootPart")
        wait(0.3)
        Character:PivotTo(Player_Vehicle:GetPivot())
    end

    local args = {
        [1] = "DriveRequest",
        [2] = Player_Vehicle:FindFirstChild("DriveSeat") or Player_Vehicle:WaitForChild("DriveSeat")
    }

    prompt_re:FireServer(unpack(args))
    wait(0.3)
    local args = {
        "TurnOn",
        "Car"
    }

    Player_Vehicle:WaitForChild("IgnitionSoundUpdate", 10):FireServer(unpack(args))
end,})

getgenv().PVPEnabler = Tab2:CreateToggle({
Name = "PVP Switch",
CurrentValue = getgenv().is_pvp_on or false,
Flag = "ThePVPSwitchToggle",
Callback = function(pvpEnabled)
    if pvpEnabled then
        local pvp_manager_re = find_RE("pvpmanager")
        local pvp_gui = PlayerGui:FindFirstChild("pvpUI", true) or PlayerGui:WaitForChild("pvpUI", 5)
        local pvp_b

        if pvp_gui and pvp_gui:IsA("ScreenGui") then
            for _, v in ipairs(pvp_gui:GetDescendants()) do
                if v:IsA("TextButton") then
                    pvp_b = v
                end
            end
        else
            getgenv().is_pvp_on = false
            getgenv().PVPEnabler:Set(false)
            return getgenv().notify("Error", "pvpB TextButton not found, try rejoining (patched?).", 7)
        end

        if not HumanoidRootPart:FindFirstChild("jobCharUI") then
            getgenv().PVPEnabler:Set(false)
            return getgenv().notify("Error", "jobCharUI not found, try resetting.", 5)
        end

        if not HumanoidRootPart:FindFirstChild("jobCharUI"):FindFirstChild("Frame") then
            return notify("Error", "Frame was not found inside jobCharUI! (Patched?)", 5)
        end

        if not pvp_manager_re then
            return notify("Error", "'pvpManagerEvent' RemoteEvent was not found in ReplicatedStorage! (Patched?)", 5)
        end

        if not PlayerGui:FindFirstChild("pvpUI") then
            return notify("Error", "pvpUI was not found in PlayerGui! (Patched?)", 5)
        end

        if not PlayerGui:FindFirstChild("pvpUI"):FindFirstChild("pvpF") then
            return notify("Error", "pvpF was not found inside pvpUI! (Patched?)", 5)
        end
        getgenv().is_pvp_on = true

        if pvp_manager_re and pvp_manager_re:IsA("RemoteEvent") then
            local pvp_check

            for _, v in ipairs(HumanoidRootPart:GetDescendants()) do
                if v.Name:lower():find("pvpcheck") then
                    pvp_check = v
                end
            end
            wait(0.2)
            local args = {
                [1] = pvp_check
            }

            pvp_manager_re:FireServer(unpack(args))
        end
        wait()
        pvp_b.Text = "DISABLE PVP"
    else
        local pvp_manager_re = find_RE("pvpmanager")
        local pvp_gui = PlayerGui:FindFirstChild("pvpUI", true) or PlayerGui:WaitForChild("pvpUI", 5)
        local pvp_b

        if pvp_gui and pvp_gui:IsA("ScreenGui") then
            for _, v in ipairs(pvp_gui:GetDescendants()) do
                if v:IsA("TextButton") then
                    pvp_b = v
                end
            end
        else
            getgenv().is_pvp_on = false
            return getgenv().notify("Error", "pvpB TextButton not found, try rejoining (patched?).", 7)
        end

        getgenv().is_pvp_on = false
        if pvp_manager_re and pvp_manager_re:IsA("RemoteEvent") then
            local pvp_check

            for _, v in ipairs(HumanoidRootPart:GetDescendants()) do
                if v.Name:lower():find("pvpcheck") then
                    pvp_check = v
                end
            end
            wait(0.3)
            local args = {
                [1] = pvp_check
            }

            pvp_manager_re:FireServer(unpack(args))
        end
        wait(0.1)
        pvp_b.Text = "ENABLE PVP"
    end
end,})

getgenv().TPToCar = Tab6:CreateButton({
Name = "Teleport To Car",
Callback = function()
    local Player_Vehicle = request_vehicle()

    if not Player_Vehicle then
        return getgenv().notify("Error", "Please spawn a Vehicle first.", 5)
    end

    if Character and Character:FindFirstChild("HumanoidRootPart") then
        Character:PivotTo(request_vehicle():GetPivot())
    end
end,})

local isMobile = UserInputService.TouchEnabled
g.vehicle_fly = g.vehicle_fly or false
g.vehicle_fly_speed = g.vehicle_fly_speed or 3
g.vehiclefly_conns = g.vehiclefly_conns or {}
g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
g.vehiclefly_noclip = g.vehiclefly_noclip or false
g.vehiclefly_collisions = g.vehiclefly_collisions or {}
local controlModule
if UserInputService.TouchEnabled then controlModule = require(g.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")) end
g.cleanup = function()
    for _, c in pairs(g.vehiclefly_conns) do pcall(function() c:Disconnect() end) end
    g.vehiclefly_conns = {}
    if g.vehiclefly_bv then
        g.vehiclefly_bv.Velocity = Vector3.zero
        g.vehiclefly_bv:Destroy()
        g.vehiclefly_bv = nil
    end

    if g.vehiclefly_bg then
        g.vehiclefly_bg:Destroy()
        g.vehiclefly_bg = nil
    end
end

g.enable_vehicle_noclip = function()
    if g.vehiclefly_noclip then return end
    g.vehiclefly_noclip = true
    g.vehiclefly_collisions = {}
    local car = request_vehicle()
    local wheels_model = car:FindFirstChild("Wheels")

    for _, v in ipairs(car:GetDescendants()) do
        if v:IsA("BasePart") then
            if wheels_model and v:IsDescendantOf(wheels_model) then continue end
            g.vehiclefly_collisions[v] = v.CanCollide
            v.CanCollide = false
        end
    end
end

g.disable_vehicle_noclip = function()
    if not g.vehiclefly_noclip then return end
    g.vehiclefly_noclip = false
    for part, state in pairs(g.vehiclefly_collisions) do if part and part.Parent then part.CanCollide = state end end
    g.vehiclefly_collisions = {}
end

g.start_vehicle_fly = function()
    if g.vehiclefly_bg or g.vehiclefly_bv then return end
    local car = request_vehicle()
    local base = car:FindFirstChild("DriveSeat") or car:FindFirstChildWhichIsA("BasePart")
    if not base then return end
    local bg = Instance.new("BodyGyro")
    bg.P = 3e4
    bg.D = 1e3
    bg.MaxTorque = Vector3.new(0, 9e9, 0)
    bg.CFrame = base.CFrame
    bg.Parent = base

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = base
    g.vehiclefly_bg = bg
    g.vehiclefly_bv = bv
    g.vehiclefly_conns.render = RunService.Heartbeat:Connect(function()
        if not g.vehicle_fly or not base.Parent then
            bv.Velocity = Vector3.zero
            g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
            return
        end

        base.AssemblyAngularVelocity = Vector3.zero
        local cam = workspace.CurrentCamera

        if isMobile then
            bg.CFrame = cam.CFrame
            local mv = controlModule:GetMoveVector()
            local vel = Vector3.zero
            if mv.X ~= 0 then vel = vel + cam.CFrame.RightVector * (mv.X * (45 * g.vehicle_fly_speed)) end
            if mv.Z ~= 0 then vel = vel - cam.CFrame.LookVector * (mv.Z * (45 * g.vehicle_fly_speed)) end
            bv.Velocity = vel
        else
            local look = cam.CFrame.LookVector
            local yaw = math.atan2(-look.X, -look.Z)
            bg.CFrame = CFrame.new(base.Position) * CFrame.Angles(0, yaw, 0)
            local c = g.vehiclefly_control
            local forward = (c.f or 0) + (c.b or 0)
            local right = (c.l or 0) + (c.r or 0)
            local up = (c.q or 0) + (c.e or 0)
            bv.Velocity = (cam.CFrame.LookVector * forward + cam.CFrame.RightVector * right + Vector3.new(0, up, 0)) * (45 * g.vehicle_fly_speed)
        end
    end)

    if not isMobile then
        g.vehiclefly_conns.down = UserInputService.InputBegan:Connect(function(i, gameProcessed)
            if gameProcessed then return end
            if i.KeyCode == Enum.KeyCode.W then g.vehiclefly_control.f = 1  end
            if i.KeyCode == Enum.KeyCode.S then g.vehiclefly_control.b = -1 end
            if i.KeyCode == Enum.KeyCode.A then g.vehiclefly_control.l = -1 end
            if i.KeyCode == Enum.KeyCode.D then g.vehiclefly_control.r = 1  end
            if i.KeyCode == Enum.KeyCode.E then g.vehiclefly_control.q = 1  end
            if i.KeyCode == Enum.KeyCode.Q then g.vehiclefly_control.e = -1 end
        end)

        g.vehiclefly_conns.up = UserInputService.InputEnded:Connect(function(i)
            if i.KeyCode == Enum.KeyCode.W then g.vehiclefly_control.f = 0 end
            if i.KeyCode == Enum.KeyCode.S then g.vehiclefly_control.b = 0 end
            if i.KeyCode == Enum.KeyCode.A then g.vehiclefly_control.l = 0 end
            if i.KeyCode == Enum.KeyCode.D then g.vehiclefly_control.r = 0 end
            if i.KeyCode == Enum.KeyCode.E then g.vehiclefly_control.q = 0 end
            if i.KeyCode == Enum.KeyCode.Q then g.vehiclefly_control.e = 0 end
        end)
    end
end

g.stop_vehicle_fly = function()
    g.vehicle_fly = false
    g.disable_vehicle_noclip()
    g.cleanup()
    g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
end

g.toggle_vehicle_fly = function()
    if g.vehicle_fly then
        g.stop_vehicle_fly()
    else
        g.vehicle_fly = true
        g.enable_vehicle_noclip()
        g.start_vehicle_fly()
    end
end

getgenv().ApplyBestModSettings = Tab4:CreateButton({
Name = "Apply Fastest/Best Car Mods",
Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LegoGameSploit/Roblox_Scripts/main/swflrel.lua"))()
end,})

getgenv().Apply_Best_Vehicle_Settings = Tab4:CreateToggle({
Name = "Better Speed System (FE)",
CurrentValue = getgenv().vehicle_speed_boost_active or false,
Flag = "BetterSpeedSystemToggledUI",
Callback = function(toggled)
    if toggled then
        getgenv().vehicle_speed_boost_toggle(true)
    else
        getgenv().vehicle_speed_boost_toggle(false)
    end
end,})

getgenv().Set_System_Forward_Speed = Tab4:CreateSlider({
Name = "Set 'Better System' Forward Speed (FE)",
Range = {50, 550},
Increment = 10,
Suffix = "",
CurrentValue = getgenv().vehicle_speed_boost_max_forward or 300,
Flag = "Slider_Value_Forward_Speed",
Callback = function(new_forward_speed)
    getgenv().vehicle_speed_boost_max_forward = new_forward_speed
end,})

getgenv().Set_System_Backward_Speed = Tab4:CreateSlider({
Name = "Set 'Better System' Backward Speed (FE)",
Range = {50, 175},
Increment = 10,
Suffix = "",
CurrentValue = getgenv().vehicle_speed_boost_max_backward or 125,
Flag = "Slider_Value_Backward_Speed",
Callback = function(new_backward_speed)
    getgenv().vehicle_speed_boost_max_backward = new_backward_speed
end,})

getgenv().Set_System_Acceleration = Tab4:CreateSlider({
Name = "Set 'Better System' Acceleration (FE)",
Range = {10, 100},
Increment = 10,
Suffix = "",
CurrentValue = getgenv().vehicle_speed_boost_acceleration or 10,
Flag = "Slider_Value_Acceleration",
Callback = function(new_boost_acceleration)
    getgenv().vehicle_speed_boost_acceleration = new_boost_acceleration
end,})

getgenv().Vehicle_Fly_Toggle = Tab4:CreateToggle({
Name = "Vehicle Fly (FE)",
Description = "Allows you to fly your Vehicle, other people will see.",
CurrentValue = getgenv().vehicle_fly or false,
Callback = function(vehicle_fly_enabled_system)
    if vehicle_fly_enabled_system then
        local vehicle = request_vehicle()
        if not vehicle then
            if getgenv().Vehicle_Fly_Toggle then getgenv().Vehicle_Fly_Toggle:Set(false) end
            notify("Error", "No Vehicle spawned, please spawn one.", 5)
            return 
        end
        getgenv().toggle_vehicle_fly()
    else
        getgenv().toggle_vehicle_fly()
    end
end,})

getgenv().Infinite_Yield_Premium = Tab5:CreateButton({
Name = "Infinite Yield Premium",
Callback = function()
    if getgenv().GET_LOADED_IY then return getgenv().notify("Error", "You already have Infinite Premium running, you cannot run this.", 10) end
    if getgenv().IY_LOADED then return getgenv().notify("Error", "You already have Infinite Yield running, you cannot run this.", 10) end

    loadstring(game:HttpGet('https://pastefy.app/b052AUgc/raw'))()
end,})

getgenv().FOV_Slider = Tab5:CreateSlider({
Name = "Field Of View (FOV)",
Range = {5, 120},
Increment = 1,
Suffix = "",
CurrentValue = 75,
Flag = "theFOVValueEditor",
Callback = function(New_FOV_Value)
    if Workspace then
        Workspace.CurrentCamera.FieldOfView = New_FOV_Value
    end
end,})

if LocalPlayer.CameraMaxZoomDistance <= 99999 then
    getgenv().notify("Info", "Setting CameraMaxZoomDistance...", 5)
    LocalPlayer.CameraMaxZoomDistance = 999999
    wait(1)
    if LocalPlayer.CameraMaxZoomDistance >= 99999 then
        getgenv().notify("Success", "CameraMaxZoomDistance has been maximized.", 5)
    end
end