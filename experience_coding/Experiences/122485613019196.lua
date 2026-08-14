if not game:IsLoaded() then
   local msg_instance = Instance.new("Message")
   local hint_instance = Instance.new("Hint")
   msg_instance.Text = "Flames Hub is waiting for the current experience to load fully."
   hint_instance.Text = "Flames Hub is currently waiting for the game to load."
   msg_instance.Parent = workspace
   hint_instance.Parent = workspace
   game.Loaded:Wait()
   task.wait(0.1)
   msg_instance:Destroy()
   hint_instance:Destroy()
end
wait(0.25)
local g = getgenv()
local Raw_Version = "V1.1.4"
g.Script_Version = tostring(Raw_Version).."-DubaiRP"
if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://pastebin.com/raw/T25mDhBZ"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end

local low_level_client = g.low_level_executor()
if low_level_client then return g.notify("Error", "Your executor does not have the correct permissions to run this script!", 15) end
local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local ReplicatedStorage = g.ReplicatedStorage or cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
local ReplicatedFirst = g.ReplicatedFirst or cloneref and cloneref(game:GetService("ReplicatedFirst")) or game:GetService("ReplicatedFirst")
local Workspace = g.Workspace or cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
local TextChatService = g.TextChatService or cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")
local Lighting = g.Lighting or cloneref and cloneref(game:GetService("Lighting")) or game:GetService("Lighting")
local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local StarterGui = g.StarterGui or cloneref and cloneref(game:GetService("StarterGui")) or game:GetService("StarterGui")
local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local UserInputService = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local TweenService = g.TweenService or cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
local LocalPlayer = g.LocalPlayer or Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local FlamesLibrary = g.FlamesLibrary or getgenv().FlamesLibrary or g.blank
local FL = FlamesLibrary
g.rainbow_skin_toggled = g.rainbow_skin_toggled or false
g.time_flasher_toggled = g.time_flasher_toggled or false
g.Rainbow_Car_FE = g.Rainbow_Car_FE or false
local function make_time_buf(tod_string) local buf = buffer.fromstring(tod_string) return buf end
local function find_zap_Remote_Event_Folder_main()
   local cache = g.Zap_Folder_Main_For_Remote_Event
   if cache and cache.Parent and cache:IsA("Folder") then return cache end
   for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
      if v:IsA("Folder") and string.find(string.lower(v.Name), "zap", 1, true) then
         g.Zap_Folder_Main_For_Remote_Event = v
         return v
      end
   end

   return nil
end
wait(0.1)
if not g.Zap_Folder_Main_For_Remote_Event then pcall(function() find_zap_Remote_Event_Folder_main() end) end

local function find_zap_Reliable_Remote_Event_main()
   local cache = g.Zap_Reliable_Remote_Event_Main
   if cache and cache.Parent and cache:IsA("RemoteEvent") then return cache end
   for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
      if v:IsA("RemoteEvent") and string.find(string.lower(v.Name), "reliable", 1, true) then
         g.Zap_Reliable_Remote_Event_Main = v
         return v
      end
   end
   
   return nil
end
wait(0.1)
if not g.Zap_Reliable_Remote_Event_Main then pcall(function() find_zap_Reliable_Remote_Event_main() end) end

local function find_vehicles_Folder_Dubai_RP()
   local cache = g.found_Vehicles_Folder_Dubai_RP
   if cache and cache.Parent and cache:IsA("Folder") then return cache end
   for _, v in ipairs(Workspace:GetChildren()) do
      if v:IsA("Folder") and v.Name:lower():find("vehicles") and not v.Name:lower():find("spawn") then
         g.found_Vehicles_Folder_Dubai_RP = v
         return v
      end
   end

   return nil
end
wait(0.1)
if not g.found_Vehicles_Folder_Dubai_RP then pcall(function() find_vehicles_Folder_Dubai_RP() end) end

local function find_zap_client_Module_Script()
   local cache = g.zap_client_Module_Script_Found
   if cache and cache:IsA("ModuleScript") then return cache end

   for _, v in ipairs(ReplicatedFirst:GetDescendants()) do
      if v:IsA("ModuleScript") and v.Name:lower():find("zap") and v.Name:lower():find("client") then
         g.zap_client_Module_Script_Found = v
         return v
      end
   end

   return nil
end
wait(0.1)
if not g.zap_client_Module_Script_Found then pcall(function() find_zap_client_Module_Script() end) end

local ZAP_Folder = g.Zap_Folder_Main_For_Remote_Event or find_zap_Remote_Event_Folder_main()
local Zap_RE = g.Zap_Reliable_Remote_Event_Main or find_zap_Reliable_Remote_Event_main()
local Zap_Client = g.zap_client_Module_Script_Found or find_zap_client_Module_Script()
local Vehicles = g.found_Vehicles_Folder_Dubai_RP or find_vehicles_Folder_Dubai_RP()
wait(0.25)
local function get_vehicle()
   for i, v in pairs(Vehicles:GetChildren()) do
      if v:IsA("Model") and v:GetAttribute("Owner") == LocalPlayer.Name then
         return v
      end
   end

   return nil
end

g.zap_state = {
   client = nil,
   event_map = {},
   type_writers = {},
   last_hash = nil,
   healthy = false,
}

g.zap_crawl = function()
   if not require or type(require) ~= "function" then return false, "require_missing" end
   local ok, zap = pcall(function() return require(Zap_Client) end)
   if not ok or type(zap) ~= "table" then
      g.zap_state.healthy = false
      return false, "require_failed: " .. tostring(zap)
   end

   local fingerprint = 0
   for k, v in pairs(zap) do
      local key_contribution = 0
      for i = 1, #k do
         key_contribution = (key_contribution * 31 + string.byte(k, i)) % 2^32
      end
      fingerprint = (fingerprint + key_contribution) % 2^32
   end

   if fingerprint == g.zap_state.last_hash then return true, "cache_hit" end
   g.zap_state.last_hash = fingerprint
   g.zap_state.client = zap
   g.zap_state.event_map = {}
   g.zap_state.type_writers = {}
   for event_name, event_obj in pairs(zap) do
      if type(event_obj) == "table" then
         local entry = {
            name = event_name,
            has_fire = type(event_obj.Fire) == "function",
            has_call = type(event_obj.Call) == "function",
            has_on = type(event_obj.On) == "function",
            has_set = type(event_obj.SetCallback) == "function",
            ref = event_obj,
         }

         if getupvalues and typeof(getupvalues) == "function" and entry.has_fire then
            local upvals = getupvalues(event_obj.Fire)
            for i, v in pairs(upvals) do
               if type(v) == "number" and v > 0 and v < 512 then
                  entry.inferred_id = v
                  break
               end
            end
         end

         g.zap_state.event_map[event_name] = entry
      end
   end

   g.zap_state.healthy = true
   return true, "remapped"
end

g.zap_ensure = function() if not g.zap_state.healthy or not g.zap_state.client then return g.zap_crawl() end return true, "already_healthy" end
g.zap_fire = function(event_name, payload)
   local ok, reason = g.zap_ensure()
   if not ok then
      if g.AllClipboards and typeof(g.AllClipboards) == "function" then
         g.AllClipboards("zap_fire_fail|ensure|" .. tostring(reason))
      end
      return false, reason
   end

   local entry = g.zap_state.event_map[event_name]
   if not entry then
      g.zap_crawl()
      entry = g.zap_state.event_map[event_name]
      if not entry then
         return false, "event_not_found_post_remap"
      end
   end

   if not entry.has_fire then
      return false, "no_fire_on_event"
   end

   local fire_ok, fire_err = pcall(function()
      if payload ~= nil then
         entry.ref.Fire(payload)
      else
         entry.ref.Fire()
      end
   end)

   if not fire_ok then
      g.zap_state.healthy = false
      g.zap_crawl()

      local retry_entry = g.zap_state.event_map[event_name]
      if retry_entry and retry_entry.has_fire then
         local retry_ok, retry_err = pcall(function()
            if payload ~= nil then
               retry_entry.ref.Fire(payload)
            else
               retry_entry.ref.Fire()
            end
         end)
         if not retry_ok then
            if g.AllClipboards and typeof(g.AllClipboards) == "function" then
               g.AllClipboards("zap_fire_fail|retry|" .. event_name .. "|" .. tostring(retry_err))
            end
            return false, retry_err
         end
         return true, "recovered"
      end
      return false, fire_err
   end

   return true, "ok"
end

g.zap_call = function(event_name, payload)
   local ok, reason = g.zap_ensure()
   if not ok then return false, reason end
   local entry = g.zap_state.event_map[event_name]
   if not entry then
      g.zap_crawl()
      entry = g.zap_state.event_map[event_name]
      if not entry then return false, "event_not_found" end
   end

   if not entry.has_call then return false, "no_call_on_event" end
   local result
   local call_ok, call_err = pcall(function()
      if payload ~= nil then
         result = entry.ref.Call(payload)
      else
         result = entry.ref.Call()
      end
   end)

   if not call_ok then
      g.zap_state.healthy = false
      g.zap_crawl()
      local retry = g.zap_state.event_map[event_name]
      if retry and retry.has_call then
         local rok, rerr = pcall(function()
            result = payload ~= nil and retry.ref.Call(payload) or retry.ref.Call()
         end)
         if not rok then
            if g.AllClipboards and typeof(g.AllClipboards) == "function" then g.AllClipboards("zap_call_fail|" .. event_name .. "|" .. tostring(rerr)) end
            return false, rerr
         end
         return true, result
      end
      return false, call_err
   end

   return true, result
end

g.fire_skin = function(color) return g.zap_fire("AvatarEditor_UpdateSkinTone", color) end
g.fire_height = function(height)
   height = math.clamp(height, 0.025, 1.0)
   local v = math.floor(height * 100)
   return g.zap_fire("AvatarEditor_SetBodyScale", {
      BodyDepthScale      = v,
      BodyHeightScale     = v,
      BodyProportionScale = v,
      BodyTypeScale       = v,
      BodyWidthScale      = v,
      HeadScale           = v,
   })
end

g.fire_rp_name = function(name)
   if type(name) ~= "string" or #name == 0 or #name > 255 then
      return false, "invalid_name"
   end
   return g.zap_fire("AvatarEditor_SaveRoleplayInformation", { Name = name })
end

g.fire_unseat = function() return g.zap_fire("Vehicle_UnseatRequest") end
FlamesLibrary.connect("zap_remap_watcher", ReplicatedFirst.ChildAdded:Connect(function(child)
   if child.Name:lower() == "zapclient" then
      g.zap_state.healthy = false
      g.zap_crawl()
   end
end))

g.set_time_of_day = function(time)
   local valid = { Dawn = true, Day = true, Dusk = true, Night = true }
   if not valid[time] then return false, "invalid_time: " .. tostring(time) end
   return g.zap_fire("PrivateAdminPanel_RequestTimeOfDay", time)
end

g.make_skin_buf = function(color)
   if typeof(color) ~= "Color3" then return false, "bad_color" end
   return g.zap_fire("AvatarEditor_UpdateSkinTone", color)
end

g.make_unseat_buffer = function(seat)
   if typeof(seat) ~= "Instance" then return false, "bad_seat" end
   return g.zap_fire("Vehicle_UnseatRequest")
end

g.make_roleplay_name_buffer = function(name)
   if type(name) ~= "string" or #name == 0 or #name > 255 then return false, "invalid_name" end
   return g.zap_fire("AvatarEditor_SaveRoleplayInformation", { Name = name })
end

g.make_height_buffer = function(height)
   if type(height) ~= "number" then return false, "bad_height" end
   height = math.clamp(height, 0.025, 1.0)
   local v = math.floor(height * 100)
   return g.zap_fire("AvatarEditor_SetBodyScale", {
      BodyDepthScale      = v,
      BodyHeightScale     = v,
      BodyProportionScale = v,
      BodyTypeScale       = v,
      BodyWidthScale      = v,
      HeadScale           = v,
   })
end

g.make_roleplay_job_buffer = function(job_name)
   if type(job_name) ~= "string" or #job_name == 0 then return false, "invalid_job_name" end
   return g.zap_fire("AvatarEditor_SaveRoleplayInformation", { Job = job_name })
end

local function Fire_Buffer(buf, args) if buf then Zap_RE:FireServer(buf, args) end end
-- [[ These are just test buffers, if you uncomment them, they may change your settings because they run automatically, their mainly used for debugging. ]] --
--[[
   Fire_Buffer(g.make_roleplay_name_buffer("yo"))
   Fire_Buffer(g.make_roleplay_job_buffer("Accountant"))
   Fire_Buffer(g.make_height_buffer(1.0))
--]]

g.name_spammer_enabled = g.name_spammer_enabled or false
g.name_spammer_func = function(state)
	g.name_spammer_enabled = state
	if not state then
		FlamesLibrary.disconnect("name_spammer")
		return
	end

	FlamesLibrary.spawn("name_spammer", "spawn", function()
		local idx = 1
		while g.name_spammer_enabled do
			local word = g.words_tbl[idx]
			if word then
				local ok, reason = g.fire_rp_name(word)
				if not ok then
					g.notify("Error", "Flames Hub | name_spammer_func() Error: "..tostring(reason), 5)
					if g.name_spammer_func and typeof(g.name_spammer_func) == "function" then g.name_spammer_func(false) end
					if g.NameSpammer_Toggle_UI then g.NameSpammer_Toggle_UI:Set(false, false) end
					break
				end
			end
			idx = (idx % #g.words_tbl) + 1
			FlamesLibrary.wait(0)
		end
	end)
end

local function cache_pre_rainbow_skin_tone()
	local character = g.Character or g.LocalPlayer.Character or g.get_char(g.LocalPlayer, 5)
	if not character then return end
	local body_colors = character:FindFirstChildOfClass("BodyColors")
	if not body_colors then return end
	g.rainbow_skin_pre_cache = body_colors.HeadColor3
end

local function restore_skin_tone_post_rainbow()
	FlamesLibrary.spawn("rainbow_skin_restore_watcher", "spawn", function()
		while FlamesLibrary.is_thread_alive("rainbow_skin") do task.wait(0) end
		task.wait(1)
		g.rainbow_skin_toggled = false
		task.wait(0.35)
		local cached = g.rainbow_skin_pre_cache
		if not cached then
			g.rainbow_skin_busy = false
			return
		end
		if Zap_RE then pcall(function() Zap_RE:FireServer(make_skin_buf(cached), {}) end) end
		g.rainbow_skin_pre_cache = nil
		g.rainbow_skin_busy = false
	end)
end

g.rainbow_skin_busy = g.rainbow_skin_busy or false
g.rainbow_skin_enabled = function(state)
	if g.rainbow_skin_busy then
		if g.RainbowSkin_FE then g.RainbowSkin_FE:Set(false, false) end
		return
	end
	g.rainbow_skin_toggled = state
	if not state then
		g.rainbow_skin_busy = true
		FlamesLibrary.disconnect("rainbow_skin")
		restore_skin_tone_post_rainbow()
		return
	end
	cache_pre_rainbow_skin_tone()
	local idx = 1
	local last_fire = 0
	FlamesLibrary.connect("rainbow_skin", RunService.Heartbeat:Connect(function(dt)
		if not g.rainbow_skin_toggled then FlamesLibrary.disconnect("rainbow_skin") return end
		local now = os.clock()
		if now - last_fire >= 0.75 then
			last_fire = now
			local color = g.colors[idx]
			if Zap_RE and color then pcall(function() Zap_RE:FireServer(make_skin_buf(color), {}) end) end
			idx = (idx % #g.colors) + 1
		end
	end))
end

g.find_body_orientation_module_cache = function()
   local cache = g.body_orientation_module_found
   if cache and cache.Parent and cache:IsA("ModuleScript") then return cache end
   for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
      if v:IsA("ModuleScript") and v.Name:lower():find("body") and v.Name:lower():find("orientation") then
         g.body_orientation_module_found = v
         return v
      end
   end

   return nil
end
wait(0.1)
if not g.body_orientation_module_found then pcall(function() g.find_body_orientation_module_cache() end) end

g.find_body_orientation_Remote_Event = function()
   local cache = g.Orientation_Body_Remote_Event
   if cache and cache.Parent and cache:IsA("RemoteEvent") then return cache end
   for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
      if v:IsA("RemoteEvent") and v.Name:lower():find("body") and v.Name:lower():find("orientation") and v.Name:lower():find("update") then
         g.Orientation_Body_Remote_Event = v
         return v
      end
   end

   return nil
end
wait(0.1)
if not g.Orientation_Body_Remote_Event then pcall(function() g.find_body_orientation_Remote_Event() end) end

g.Orientable_Body_Module_Script = function()
   local cache = g.Orientable_Body_Module_Script_Found
   if cache and cache.Parent and cache:IsA("ModuleScript") then return cache end
   for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
      if v:IsA("ModuleScript") and v.Name:lower():find("body") and v.Name:lower():find("orientable") then
         g.Orientable_Body_Module_Script_Found = v
         return v
      end
   end

   return nil
end
wait(0.1)
if not g.Orientable_Body_Module_Script_Found then pcall(function() g.Orientable_Body_Module_Script() end) end

g.Find_Roleplay_Jobs_Module_Script = function()
   local cache = g.Roleplay_Jobs_Module_Script_Found
   if cache and cache.Parent and cache:IsA("ModuleScript") then return cache end
   for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
      if v:IsA("ModuleScript") and v.Name:lower():find("roleplay") and v.Name:lower():find("jobs") then
         g.Roleplay_Jobs_Module_Script_Found = v
         return v
      end
   end
   return nil
end
wait(0.1)
if not g.Roleplay_Jobs_Module_Script_Found then pcall(function() g.Find_Roleplay_Jobs_Module_Script() end) end

g.extract_available_jobs = function()
	local mod = g.Roleplay_Jobs_Module_Script_Found or g.Find_Roleplay_Jobs_Module_Script()
	if not mod then return end
	local success, role_play_jobs = pcall(require, mod)
	if not success or type(role_play_jobs) ~= "table" then return end
	g.all_available_jobs = {}
	for key, job_data in pairs(role_play_jobs) do
		if type(job_data) == "table" and job_data.HideInRoleSelection == false then
			table.insert(g.all_available_jobs, key)
		end
	end
	table.sort(g.all_available_jobs)
end
pcall(g.extract_available_jobs)

g.job_spammer_enabled = g.job_spammer_enabled or false
g.job_spammer_func = function(state)
	g.job_spammer_enabled = state
	if not state then
		FlamesLibrary.disconnect("job_spammer")
		return
	end

	local idx = 1
	local last_fire = 0
	FlamesLibrary.connect("job_spammer", RunService.Heartbeat:Connect(function()
		if not g.job_spammer_enabled then
			FlamesLibrary.disconnect("job_spammer")
			return
		end
		local now = os.clock()
		if now - last_fire < 0.01 then return end
		last_fire = now
		if not g.all_available_jobs or #g.all_available_jobs == 0 then
			g.notify("Error", "Flames Hub | job_spammer_func() Error: all_available_jobs is empty or nil.", 5)
			g.job_spammer_func(false)
			if g.JobSpammer_Toggle_UI then g.JobSpammer_Toggle_UI:Set(false, false) end
			return
		end
		local job = g.all_available_jobs[idx]
		if job then
			local ok, reason = g.zap_call("NameTags_SetRoleplayJob", job)
			if not ok then
				g.notify("Error", "Flames Hub | job_spammer_func() Error: "..tostring(reason), 5)
				g.job_spammer_func(false)
				if g.JobSpammer_Toggle_UI then g.JobSpammer_Toggle_UI:Set(false, false) end
				return
			end
		end
		idx = (idx % #g.all_available_jobs) + 1
	end))
end

g.vehicle_fly = g.vehicle_fly or false
g.vehicle_fly_speed = g.vehicle_fly_speed or 3
g.vehiclefly_conns = g.vehiclefly_conns or {}
g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
g.vehiclefly_noclip = g.vehiclefly_noclip or false
g.vehiclefly_collisions = g.vehiclefly_collisions or {}
g.vehiclefly_last_yaw = g.vehiclefly_last_yaw or 0

local controlModule
if UserInputService.TouchEnabled then
   controlModule = require(g.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
end

g.cleanup = g.cleanup or function()
   for _, c in pairs(g.vehiclefly_conns) do
      pcall(function() c:Disconnect() end)
   end
   g.vehiclefly_conns = {}
   if g.vehiclefly_bv then
      pcall(function() g.vehiclefly_bv.Velocity = Vector3.zero end)
      pcall(function() g.vehiclefly_bv:Destroy() end)
      g.vehiclefly_bv = nil
   end
   if g.vehiclefly_bg then
      pcall(function() g.vehiclefly_bg:Destroy() end)
      g.vehiclefly_bg = nil
   end
end

g.get_vehicle_base = g.get_vehicle_base or function(car)
   return car.PrimaryPart
      or car:FindFirstChild("Base")
      or car:FindFirstChildWhichIsA("VehicleSeat", true)
      or car:FindFirstChildWhichIsA("Seat", true)
      or car:FindFirstChildWhichIsA("BasePart", true)
end

g.enable_vehicle_noclip = g.enable_vehicle_noclip or function()
   if g.vehiclefly_noclip then return end
   g.vehiclefly_noclip = true
   g.vehiclefly_collisions = {}
   local car = get_vehicle()
   if not car then return end
   if g.ToggleNoclip and typeof(g.ToggleNoclip) == "function" then g.ToggleNoclip(true) end
   for _, v in ipairs(car:GetDescendants()) do
      if v:IsA("BasePart") then
         g.vehiclefly_collisions[v] = v.CanCollide
         v.CanCollide = false
      end
   end
   local local_humanoid = g.get_human(g.LocalPlayer, 5)
   for _, seat in ipairs(car:GetDescendants()) do
      if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
         local occupant = seat.Occupant
         if occupant and occupant.Parent and occupant ~= local_humanoid then
            for _, part in ipairs(occupant.Parent:GetDescendants()) do
               if part:IsA("BasePart") then
                  g.vehiclefly_collisions[part] = part.CanCollide
                  part.CanCollide = false
               end
            end
         end
      end
   end
end

g.disable_vehicle_noclip = g.disable_vehicle_noclip or function()
   if not g.vehiclefly_noclip then return end
   g.vehiclefly_noclip = false
   if g.ToggleNoclip and typeof(g.ToggleNoclip) == "function" then g.ToggleNoclip(false) end
   for part, state in pairs(g.vehiclefly_collisions) do
      if part and part.Parent then
         pcall(function() part.CanCollide = state end)
      end
   end
   g.vehiclefly_collisions = {}
end

g.start_vehicle_fly = function()
   if g.vehiclefly_bg or g.vehiclefly_bv then return end
   local car = get_vehicle()
   if not car then
      g.disable_vehicle_noclip()
      task.wait()
      g.cleanup()
      getgenv().notify("Error", "You do not have a Vehicle spawned.", 5)
      return
   end
   local base = g.get_vehicle_base(car)
   if not base then
      g.notify("Error", "We were not able to locate a PrimaryPart for your Vehicle to activate Fly! (patched?).", 5)
      return
   end

   local bg = Instance.new("BodyGyro")
   bg.P = 3e4
   bg.D = 1e3
   bg.MaxTorque = Vector3.new(0, 9e9, 0)
   bg.CFrame = CFrame.new(base.Position) * CFrame.Angles(0, g.vehiclefly_last_yaw, 0)
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
         if not base.Parent then
            if g.Vehicle_Fly_Flag_Toggle_UI then g.Vehicle_Fly_Flag_Toggle_UI:Set(false, false) end
            if g.stop_vehicle_fly then g.stop_vehicle_fly() else g.cleanup() end
         end
         return
      end

      base.AssemblyAngularVelocity = Vector3.zero
      local cam = workspace.CurrentCamera

      if isMobile then
         local mv = controlModule:GetMoveVector()
         local vel = Vector3.zero
         if mv.magnitude > 0.01 then
            local look = cam.CFrame.LookVector
            local yaw = math.atan2(-look.X, -look.Z)
            g.vehiclefly_last_yaw = yaw
            bg.CFrame = CFrame.new(base.Position) * CFrame.Angles(0, yaw, 0)
            if mv.X ~= 0 then vel = vel + cam.CFrame.RightVector * (mv.X * (45 * g.vehicle_fly_speed)) end
            if mv.Z ~= 0 then vel = vel - cam.CFrame.LookVector * (mv.Z * (45 * g.vehicle_fly_speed)) end
         end
         bv.Velocity = vel
      else
         local c = g.vehiclefly_control
         local forward = (c.f or 0) + (c.b or 0)
         local right = (c.l or 0) + (c.r or 0)
         local up = (c.q or 0) + (c.e or 0)
         local is_moving = forward ~= 0 or right ~= 0 or up ~= 0

         if is_moving then
            local look = cam.CFrame.LookVector
            local yaw = math.atan2(-look.X, -look.Z)
            g.vehiclefly_last_yaw = yaw
            bg.CFrame = CFrame.new(base.Position) * CFrame.Angles(0, yaw, 0)
         else
            bg.CFrame = CFrame.new(base.Position) * CFrame.Angles(0, g.vehiclefly_last_yaw, 0)
         end

         bv.Velocity = (cam.CFrame.LookVector * forward + cam.CFrame.RightVector * right + Vector3.new(0, up, 0)) * (45 * g.vehicle_fly_speed)
      end
   end)

   if not isMobile then
      g.vehiclefly_conns.down = UserInputService.InputBegan:Connect(function(i, game_processed)
         if game_processed then return end
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

g.time_flasher_enabled = function(state)
	g.time_flasher_toggled = state
	if not state then
		FlamesLibrary.disconnect("time_flasher")
		return
	end
	local keys = {"Dawn", "Day", "Dusk", "Night"}
	local idx = 1
	local last_fire = 0
	FlamesLibrary.connect("time_flasher", RunService.Heartbeat:Connect(function(dt)
		if not g.time_flasher_toggled then FlamesLibrary.disconnect("time_flasher") return end
		local now = os.clock()
		if now - last_fire >= 0.75 then
			last_fire = now
			local tod = keys[idx]
			if Zap_RE then pcall(function() Zap_RE:FireServer(make_time_buf(TIME_OF_DAY[tod]), {}) end) end
			idx = (idx % #keys) + 1
		end
	end))
end

g.make_vehicle_color_buf = function(color)
   if typeof(color) ~= "Color3" then return false, "bad_color" end
   return g.zap_fire("Vehicles_ApplyBodyColor", {
      R = math.clamp(math.round(color.R * 255), 0, 255),
      G = math.clamp(math.round(color.G * 255), 0, 255),
      B = math.clamp(math.round(color.B * 255), 0, 255),
   })
end

g.rainbow_car_enabled = function(state)
	g.Rainbow_Car_FE = state
	if not state then
		FlamesLibrary.disconnect("rainbow_car_loop")
		return
	end
	local hue = 0
	FlamesLibrary.connect("rainbow_car_loop", RunService.Heartbeat:Connect(function(dt)
		if not g.Rainbow_Car_FE then FlamesLibrary.disconnect("rainbow_car_loop") return end
		hue = (hue + dt * 0.5) % 1
		local color = Color3.fromHSV(hue, 1, 1)
		if Zap_RE then pcall(function() Zap_RE:FireServer(make_vehicle_color_buf(color), {}) end) end
	end))
end

local Atlas = loadstring(game:HttpGet("https://gitlab.com/greatest-group/experience_coding/-/raw/main/UIs/Atlas.lua?ref_type=heads", true))()
local UI = Atlas.new({
	Name = "Flames Hub | "..tostring(g.Script_Version),
	ConfigFolder = "Flames_Hub_Menu_Configuration",
	Color = Color3.fromRGB(21, 103, 251),
	Credit = "Flames Hub",
	Bind = "RightShift",
})
wait(0.25)
g.create_ui_element = g.create_ui_element or function(element_type, parent, config, global_name, flag)
	local creators = {
		Tab         = function() return parent:CreateTab(config) end,
		Section     = function() return parent:CreateSection(config) end,
		Toggle      = function() return parent:CreateToggle(config, flag) end,
		Slider      = function() return parent:CreateSlider(config, flag) end,
		Button      = function() return parent:CreateButton(config, flag) end,
		ColorPicker = function() return parent:CreateColorPicker(config, flag) end,
		Input       = function() return parent:CreateTextBox(config, flag) end,
		Dropdown    = function() return parent:CreateDropdown(config, flag) end,
		Label       = function() return parent:CreateLabel(config, flag) end,
	}

	local creator = creators[element_type]
	if not creator then return g.notify("Error", "Unknown element type: " .. tostring(element_type), 10) end
	local element = creator()
	if global_name then g[global_name] = element end
	return element
end

local Main_Page = UI:CreatePage("🏡 Main 🏡", 0)
local Home_Section = Main_Page:CreateSection("| 🏡 Home 🏡 |")
Home_Section.holder.LayoutOrder = 1
local Local_Player_Section = Main_Page:CreateSection("| 🧍 LocalPlayer 🧍 |")
Local_Player_Section.holder.LayoutOrder = 2
local Vehicle_Section = Main_Page:CreateSection("| 🏎️ Vehicle 🏎️ |")
Vehicle_Section.holder.LayoutOrder = 3
local Extras_Section = Main_Page:CreateSection("| ⭐ Extras ⭐ |")
Extras_Section.holder.LayoutOrder = 4
local page_scroll = Main_Page.contents.ScrollingFrame
local page_scroll = Main_Page.contents.ScrollingFrame
local page_scroll = Main_Page.contents.ScrollingFrame
for _, v in pairs(page_scroll:GetChildren()) do
   if v:IsA("UIListLayout") then
      v.SortOrder = Enum.SortOrder.LayoutOrder
      break
   end
end
wait(0.25)
function fire_remote(str)
   local arg_1 = buffer.fromstring(tostring(str))
   local arg_2 = {}
   local args = {
      [1] = arg_1;
      [2] = arg_2;
   }

   if Zap_RE and Zap_RE.Parent and Zap_RE:IsA("RemoteEvent") then Zap_RE:FireServer(unpack(args)) end
end
wait(0.25)
local Old_Skintone = g.Character:FindFirstChildOfClass("BodyColors").TorsoColor3
local colors = {
   ["Black"] = "\028\000\000\000",
   ["Grey"] = "\028ccc",
   ["White"] = "\028\255\255\255",
   ["Red"] = "\028\255\000\r",
   ["Orange"] = "\028\255\165\000",
   ["Green"] = "\028f\255\000",
   ["Purple"] = "\028\191@\191",
   ["Yellow"] = "\028\255\234\000",
   ["Pink"] = "\028\255i\180",
   ["Blue"] = "\028\000\150\255"
}

local vehicles = {
   ["BMWi8"] = "\020\000\005\000BMWi8",
   ["Audi"] = "\020\000\006\000AudiR8",
   ["Ambulance"] = "\020\000\f\000AmbulanceVan",
   ["Jetski"] = "\020\004\v\000JetskiGreen",
   ["Buick"] = "\020\000\b\000BuickGNX",
   ["Bicycle"] = "\020\002\v\000BlueBicycle",
   ["BMWE36"] = "\020\000\006\000BMWE36",
   ["BMWM3E30"] = "\020\000\b\000BMWM3E30",
   ["BMWM3E46"] = "\020\000\b\000BMWM3E46",
   ["BMWM4"] = "\020\000\005\000BMWM4",
}

g.toggle_body_orientation_system = function(state)
   if low_level_executor() == true then
      g.notify("Error", "This feature is not available on this executor! (insufficient 'require' permissions).", 10)
      return
   end
   local Body_Orientation_Module_Found = g.body_orientation_module_found or g.find_body_orientation_module_cache()
   if not Body_Orientation_Module_Found or not Body_Orientation_Module_Found:IsA("ModuleScript") then return g.notify("Error", "ModuleScript: BodyOrientation not found or does not exist.", 5) end
   local Require_Module_Body_Orientation = require and require(Body_Orientation_Module_Found)
   if not Require_Module_Body_Orientation or typeof(Require_Module_Body_Orientation) ~= "table" then return g.notify("Error", "Could not call: 'require' on ModuleScript: " .. tostring(Body_Orientation_Module_Found:GetFullName()), 10) end
   local fn_enable = Require_Module_Body_Orientation.enable
   local fn_disable = Require_Module_Body_Orientation.disable
   if typeof(fn_enable) ~= "function" or typeof(fn_disable) ~= "function" then return g.notify("Error", "BodyOrientation module missing enable/disable — wrong module cached.", 10) end
   if state == true then
      g.head_movement_system_enabled = false
      fn_disable()
   else
      g.head_movement_system_enabled = true
      fn_enable()
   end
end

function spawn_vehicle(buffer_input) fire_remote(buffer_input) end

g.create_ui_element("Toggle", Vehicle_Section, {
Name = "Rainbow Car (SMOOTH!) (FE)",
Default = g.Rainbow_Car_FE or false,
Flag = "FlashingRainbowCarFE",
Callback = function(rainbow_car_enabled)
	g.rainbow_car_enabled(rainbow_car_enabled)
end,}, "RainbowCar_FEToggle")

g.create_ui_element("Toggle", Local_Player_Section, {
Name = "Rainbow Skin (FE)",
Default = g.rainbow_skin_toggled or false,
Flag = "RainbowSkin_FE",
Callback = function(rainbow_skin_on)
	g.rainbow_skin_enabled(rainbow_skin_on)
end,}, "RainbowSkin_FE")

g.Toggle_Body_Orientation_UI = Local_Player_Section:CreateButton({
Name = "Disable Head Movement (FE)",
Callback = function(state)
	g.toggle_body_orientation_system(true)
	local ZapClient = g.zap_client_Module_Script_Found or find_zap_client_Module_Script()
	if not ZapClient or not ZapClient:IsA("ModuleScript") then return g.notify("Error", "ModuleScript: ZapClient not found or does not exist.", 3) end
	local Req_Zap_Client = require and require(ZapClient)
	if not Req_Zap_Client then return g.notify("Error", "ModuleScript: ZapClient could not be required properly.", 3) end
	if hookfunction and typeof(hookfunction) == "function" then hookfunction(Req_Zap_Client.LookAt_Send.Fire, newcclosure(function(...) end)) end
	local orientable_body_class
	if g.Orientable_Body_Module_Script_Found and g.Orientable_Body_Module_Script_Found:IsA("ModuleScript") then
		if require and typeof(require) == "function" then orientable_body_class = require(g.Orientable_Body_Module_Script_Found) end
	end
	wait(0.10)
	if hookfunction and newcclosure and typeof(hookfunction) == "function" and typeof(newcclosure) == "function" then
		if orientable_body_class and typeof(orientable_body_class) == "table" and typeof(orientable_body_class.applyAngle) == "function" then
			local old_apply_angle
			old_apply_angle = hookfunction(orientable_body_class.applyAngle, newcclosure(function(self, motor, h_angle, v_angle)
				return old_apply_angle(self, motor, 0, 0)
			end))
		end
	end
	wait(0.10)
	local update_remote = g.Orientation_Body_Remote_Event or g.find_body_orientation_Remote_Event()
	if hookmetamethod and newcclosure and typeof(hookmetamethod) == "function" and typeof(newcclosure) == "function" then
		local old_namecall
		old_namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
			if self == update_remote and getnamecallmethod() == "FireServer" then return end
			return old_namecall(self, ...)
		end))
	end
   local character = g.Character or g.LocalPlayer.Character or g.get_char(g.LocalPlayer, 5)
   if character and character:IsDescendantOf(workspace) and character:IsDescendantOf(game) then
      character:SetAttribute("HeadMovementDisabled", true)
      local humanoid = g.Humanoid or character and character:FindFirstChildOfClass("Humanoid") or g.get_human(LocalPlayer, 5)
      if humanoid then
         humanoid:SetAttribute("HeadMovementDisabled", true)
         humanoid:SetAttribute("OrientationDisabled", true)
      end
   end
end,})

g.create_ui_element("Toggle", Local_Player_Section, {
Name = "Job Spammer (FE)",
Default = g.job_spammer_enabled or false,
Flag = "JobSpammer_Toggle_UI",
Callback = function(state)
	g.job_spammer_func(state)
end,}, "JobSpammer_Toggle_UI")

g.create_ui_element("Toggle", Local_Player_Section, {
Name = "Name Spammer (FE)",
Default = g.name_spammer_enabled or false,
Flag = "NameSpammer_Toggle_UI",
Callback = function(state)
   g.name_spammer_func(state)
end,}, "NameSpammer_Toggle_UI")

g.make_lock_buf = function(locked)
   if type(locked) ~= "boolean" then return false, "bad_locked" end
   return g.zap_fire("Vehicles_Car_LockUnlock", { Locked = locked })
end

g.create_ui_element("Toggle", Vehicle_Section, {
Name = "Lock Vehicle (FE)",
Default = g.locked_car or false,
Flag = "LockVehicleFE",
Callback = function(locking_car)
   if locking_car then
      FlamesLibrary.spawn("lock_car_action", "spawn", function()
         local ok = pcall(function()
            local vehicle = get_vehicle()
            if not vehicle then
               if g.LockVehicleFE then g.LockVehicleFE:Set(false, false) end
               g.notify("Error", "You do not have a vehicle spawned!", 3)
               return
            end
            if vehicle:GetAttribute("Locked") == nil then vehicle:SetAttribute("Locked", false) end
            task.wait(0.2)
            g.locked_car = true
            g.make_lock_buf(true)
            task.wait(0.4)
            if vehicle:GetAttribute("Locked") == true then
               g.notify("Success", "Locked vehicle: "..tostring(vehicle.Name), 1)
            else
               g.locked_car = false
               if g.LockVehicleFE then g.LockVehicleFE:Set(false, false) end
               g.notify("Error", "An error occurred while locking your vehicle.", 3)
            end
         end)
         if not ok then
            g.locked_car = false
            if g.LockVehicleFE then g.LockVehicleFE:Set(false, false) end
         end
      end)
   else
      FlamesLibrary.spawn("unlock_car_action", "spawn", function()
         local ok = pcall(function()
            local vehicle = get_vehicle()
            if not vehicle then
               if g.LockVehicleFE then g.LockVehicleFE:Set(false, false) end
               g.notify("Error", "You do not have a vehicle spawned!", 3)
               return
            end
            if vehicle:GetAttribute("Locked") == nil then
               vehicle:SetAttribute("Locked", true)
            end
            g.locked_car = false
            task.wait(0.2)
            g.make_lock_buf(false)
            task.wait(0.4)
            if vehicle:GetAttribute("Locked") == false then
               g.notify("Success", "Unlocked vehicle: "..tostring(vehicle.Name), 1)
            else
               if g.LockVehicleFE then g.LockVehicleFE:Set(false, false) end
               g.notify("Error", "An error occurred while unlocking your vehicle.", 3)
            end
         end)
         if not ok then
            g.locked_car = false
            if g.LockVehicleFE then g.LockVehicleFE:Set(false, false) end
         end
      end)
   end
end,}, "LockVehicleFE")

g.create_ui_element("Toggle", Vehicle_Section, {
Name = "Vehicle Fly (FE)",
Default = g.vehicle_fly or false,
Flag = "Vehicle_Fly_Flag_Toggle_UI",
Callback = function(state)
   g.toggle_vehicle_fly()
end,}, "Vehicle_Fly_Flag_Toggle_UI")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Fly Speed",
Min = 1,
Max = 50,
Default = g.vehicle_fly_speed or 3,
Flag = "VehicleFlySpeed",
Callback = function(new_speed)
   g.vehicle_fly_speed = new_speed
end,}, "VehicleFlySpeed")
task.wait(0)
local low_level_executor_result = low_level_executor()
if low_level_executor_result == false then
	local function get_vehicle_config()
		local Vehicle = get_vehicle()
		if not Vehicle then return nil end
		local config_ms = Vehicle:FindFirstChild("Configuration")
		if not config_ms or not config_ms:IsA("ModuleScript") then return nil end
		local ok, config = pcall(function() return require(config_ms) end)
		if not ok or type(config) ~= "table" then return nil end
		return config
	end

	g.create_ui_element("Button", Vehicle_Section, {
	Name = "Instant Acceleration",
	Callback = function()
		local config = get_vehicle_config()
		if not config then return g.notify("Error", "No vehicle or config found.", 3) end
		config.Acceleration = 100
		config.ReverseMaxSpeed = 125
	end}, "Instant_Accel")

	g.create_ui_element("Slider", Vehicle_Section, {
	Name = "Vehicle Speed",
	Min = 10,
	Max = 500,
	Default = 75,
	Flag = "EditSpeedForVehicle",
	Callback = function(new_vehicle_speed)
		local config = get_vehicle_config()
		if not config then return g.notify("Error", "No vehicle or config found.", 3) end
		config.MaxSpeed = new_vehicle_speed
	end}, "Mod_VehicleSpeed")

	g.create_ui_element("Slider", Vehicle_Section, {
	Name = "Vehicle Acceleration",
	Min = 10,
	Max = 300,
	Default = 30,
	Flag = "EditAccelerationForVehicle",
	Callback = function(new_vehicle_accel)
		local config = get_vehicle_config()
		if not config then return g.notify("Error", "No vehicle or config found.", 3) end
		config.Acceleration = new_vehicle_accel
	end}, "Mod_VehicleAccel")

	g.create_ui_element("Slider", Vehicle_Section, {
	Name = "Vehicle Reverse Speed",
	Min = 5,
	Max = 300,
	Default = 50,
	Flag = "EditReverseSpeedForVehicle",
	Callback = function(new_vehicle_reverse_speed)
		local config = get_vehicle_config()
		if not config then return g.notify("Error", "No vehicle or config found.", 3) end
		config.ReverseMaxSpeed = new_vehicle_reverse_speed
	end}, "Mod_VehicleReverseSpeed")
else
	g.notify("Error", "This executor does not properly support vehicle modifications.", 5)
end

--[[g.create_ui_element("Toggle", Extras_Section, {
Name = "",
Default = g.flag or false,
Flag = "toggle_flag",
Callback = function(state)

end}, "")--]]