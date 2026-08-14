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

local g = getgenv()
local Raw_Version = "V1.2.2"
g.Script_Version = tostring(Raw_Version).."-CatchAFade"
local Workspace = g.Workspace or cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local local_player = g.LocalPlayer or Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local UserInputService = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local PlayerGui = g.PlayerGui or local_player:FindFirstChildWhichIsA("PlayerGui") or local_player:FindFirstChildOfClass("PlayerGui") or local_player:FindFirstChild("PlayerGui") or local_player:WaitForChild("PlayerGui", 1)
local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local CollectionService = g.CollectionService or cloneref and cloneref(game:GetService("CollectionService")) or game:GetService("CollectionService")
local StarterPlayer = g.StarterPlayer or cloneref and cloneref(game:GetService("StarterPlayer")) or game:GetService("StarterPlayer")
local Camera = Workspace.CurrentCamera
local lib = getgenv().FlamesLibrary
g.LocalPlayer = g.LocalPlayer or local_player
if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://pastebin.com/raw/T25mDhBZ"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end

g.colors = g.colors or {
	Color3.fromRGB(255,255,255),
	Color3.fromRGB(128,128,128),
	Color3.fromRGB(0,0,0),
	Color3.fromRGB(0,0,255),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,255,255),
	Color3.fromRGB(255,165,0),
	Color3.fromRGB(139,69,19),
	Color3.fromRGB(255,255,0),
	Color3.fromRGB(50,205,50),
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(255,155,172),
	Color3.fromRGB(128,0,128),
}

g.colors_color_three = g.colors_color_three or {
	Color3.new(1, 1, 1),
	Color3.new(0.5019607843137255, 0.5019607843137255, 0.5019607843137255),
	Color3.new(0, 0, 0),
	Color3.new(0, 0, 1),
	Color3.new(0, 1, 0),
	Color3.new(0, 1, 1),
	Color3.new(1, 0.6470588235294118, 0),
	Color3.new(0.5450980392156862, 0.27058823529411763, 0.07450980392156863),
	Color3.new(1, 1, 0),
	Color3.new(0.19607843137254902, 0.803921568627451, 0.19607843137254902),
	Color3.new(1, 0, 0),
	Color3.new(1, 0.6078431372549019, 0.6745098039215686),
	Color3.new(0.5019607843137255, 0, 0.5019607843137255),
}

local has_gethui = (typeof(get_hui) == "function") or (typeof(g.get_hui) == "function")
local has_gethidden = (typeof(get_hidden_gui) == "function") or (typeof(g.get_hidden_gui) == "function")
if not has_gethui and not has_gethidden and not g.roblox_hidden_gui_location then
	g.roblox_hidden_gui_location = g.roblox_hidden_gui_location or nil
	if not g.roblox_hidden_gui_location then
		for _, v in ipairs(CoreGui:GetChildren()) do
			if v:IsA("ScreenGui") and v.Name == "RobloxGui" then
				g.roblox_hidden_gui_location = v
			end
		end
	end

	g.get_hui = function()
		if g.roblox_hidden_gui_location and g.roblox_hidden_gui_location:IsA("ScreenGui") then
			return g.roblox_hidden_gui_location
		else
			return CoreGui
		end
	end

	g.get_hidden_gui = function()
		if g.roblox_hidden_gui_location and g.roblox_hidden_gui_location:IsA("ScreenGui") then
			return g.roblox_hidden_gui_location
		else
			return CoreGui
		end
	end
end

local function find_remotes_Folder_path()
	local cache = g.remotes_folder_found
	if cache and cache:IsA("Folder") then return cache end

	for _, v in ipairs(ReplicatedStorage:GetChildren()) do
		if v:IsA("Folder") and v.Name:lower():find("remote") then
			g.remotes_folder_found = v
			return v
		end
	end

	return nil
end
wait(0.1)
if not g.remotes_folder_found then pcall(function() g.find_remotes_Folder_path() end) end
wait(0.25)
local function brick_main()
	if not g.catch_a_fade_anticheat_destroyed then
		pcall(function()
			task.wait(0.25)
			for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
				if v:IsA("RemoteEvent") and v.Name:lower():find("player") then
					local parent = v.Parent
					v:Destroy()
					wait(0.25)
					local decoy = Instance.new("RemoteEvent")
					decoy.Name = "Player"
					decoy.Parent = parent
					g.catch_a_fade_anticheat_destroyed = true
					g.notify("Success", "Anti-cheat bricked, decoy placed.", 3)
					return
				end
			end
			if not g.catch_a_fade_anticheat_destroyed then g.notify("Failed", "Anti-cheat remote not found.", 3) end
		end)
	end

	if not g.catch_a_fade_safereplication_destroyed then
		pcall(function()
			task.wait(0.25)
			for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
				if v:IsA("RemoteEvent") and v.Name:lower():find("safereplicat") then
					local parent = v.Parent
					v:Destroy()
					wait(0.25)
					local decoy = Instance.new("RemoteEvent")
					decoy.Name = "SafeReplicate"
					decoy.Parent = parent
					g.catch_a_fade_safereplication_destroyed = true
					g.notify("Success", "SafeReplicate bricked, decoy placed.", 3)
					return
				end
			end
			if not g.catch_a_fade_safereplication_destroyed then g.notify("Failed", "SafeReplicate remote not found.", 3) end
		end)
	end
end
wait(0.25)
brick_main()

function create_baseplate_part()
	if not workspace:FindFirstChild("FLAMES_HUB_PART") then
		local part = Instance.new("Part")
		part.Name = "FLAMES_HUB_PART"
		part.Size = Vector3.new(512, 4, 512)
		part.Position = Vector3.new(-2179, 626, 246)
		part.Anchored = true
		part.Material = Enum.Material.SmoothPlastic
		part.Color = Color3.fromRGB(106, 127, 63)
		part.Parent = workspace
		wait(0.25)
		g.Flames_Hub_Part = part
	end
end
wait(0.1)
pcall(function() create_baseplate_part() end)

g.find_left_buttons_Frame = function()
	local cache = g.found_left_buttons_Frame
	if cache and cache.Parent and cache:IsA("Frame") then return cache end
	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("Frame") and v.Name:lower():find("left") and v.Name:lower():find("button") then
			g.found_left_buttons_Frame = v
			return v
		end
	end

	return nil
end
wait(0.1)
if not g.found_left_buttons_Frame then pcall(function() g.find_left_buttons_Frame() end) end

g.toggle_annoying_guis_func = function(state)
	local cached_frame = g.found_left_buttons_Frame or g.find_left_buttons_Frame()
	if not cached_frame then return g.notify("Error", "LeftButtons frame not found.", 3) end
	g.annoying_guis_hidden = state

	for _, v in cached_frame:GetChildren() do
		if v:IsA("Frame") and not v.Name:lower():find("settings") and not v.Name:lower():find("inventory") then
			v.Visible = state
		end
	end
end

-- [[ Since people can use Shift-To-Run in this game, might as well add a loop-speed to change the speed. ]] --
g.LoopSpeed = function(state)
	g.LoopSpeed_Enabled = state
	g.LoopSpeed_Value = g.LoopSpeed_Value or 16
	g._wsCons = g._wsCons or {}

	if state then
		local char = g.Character or g.LocalPlayer.Character or g.get_char(g.LocalPlayer, 5)
		local human = g.Humanoid or (char and char:FindFirstChildWhichIsA("Humanoid")) or g.get_human(g.LocalPlayer, 5)

		local function enforce()
			if human and human.Parent then
				human.WalkSpeed = g.LoopSpeed_Value
			end
		end

		enforce()

		g._wsCons.loop = (g._wsCons.loop and g._wsCons.loop:Disconnect() and false) or human:GetPropertyChangedSignal("WalkSpeed"):Connect(enforce)

		g._wsCons.ca = (g._wsCons.ca and g._wsCons.ca:Disconnect() and false) or g.LocalPlayer.CharacterAdded:Connect(function(newChar)
			if not g.LoopSpeed_Enabled then return end
			char = newChar
			human = newChar:WaitForChild("Humanoid", 5)
			enforce()
			g._wsCons.loop = (g._wsCons.loop and g._wsCons.loop:Disconnect() and false) or human:GetPropertyChangedSignal("WalkSpeed"):Connect(enforce)
		end)
	else
		if g._wsCons then
			g._wsCons.loop = (g._wsCons.loop and g._wsCons.loop:Disconnect() and false) or nil
			g._wsCons.ca   = (g._wsCons.ca   and g._wsCons.ca:Disconnect()   and false) or nil
		end
		local char  = g.Character or g.LocalPlayer.Character or g.get_char(g.LocalPlayer, 5)
		local human = g.Humanoid or (char and char:FindFirstChildWhichIsA("Humanoid")) or g.get_human(g.LocalPlayer, 5)
		if human and human.Parent then human.WalkSpeed = 16 end
	end
end

g.SetLoopSpeed = function(speed)
	g.LoopSpeed_Value = speed or 16
	if not g.LoopSpeed_Enabled then return end
	local char  = g.Character or g.LocalPlayer.Character or g.get_char(g.LocalPlayer, 5)
	local human = g.Humanoid or (char and char:FindFirstChildWhichIsA("Humanoid")) or g.get_human(g.LocalPlayer, 5)
	if not human or not human.Parent then return false, "no_humanoid" end
	human.WalkSpeed = g.LoopSpeed_Value
end

g.LoopJump = function(state)
	g.LoopJump_Enabled = state
	g.LoopJump_Value = g.LoopJump_Value or 50
	g._wjCons = g._wjCons or {}

	if state then
		local char = g.Character or g.LocalPlayer.Character or g.get_char(g.LocalPlayer, 5)
		local human = g.Humanoid or (char and char:FindFirstChildWhichIsA("Humanoid")) or g.get_human(g.LocalPlayer, 5)

		local function enforce()
			if human and human.Parent then
				human.JumpPower = g.LoopJump_Value
			end
		end

		enforce()

		g._wjCons.loop = (g._wjCons.loop and g._wjCons.loop:Disconnect() and false) or human:GetPropertyChangedSignal("JumpPower"):Connect(enforce)

		g._wjCons.ca = (g._wjCons.ca and g._wjCons.ca:Disconnect() and false) or g.LocalPlayer.CharacterAdded:Connect(function(newChar)
			if not g.LoopJump_Enabled then return end
			char = newChar
			human = newChar:WaitForChild("Humanoid", 5)
			enforce()
			g._wjCons.loop = (g._wjCons.loop and g._wjCons.loop:Disconnect() and false) or human:GetPropertyChangedSignal("JumpPower"):Connect(enforce)
		end)
	else
		if g._wjCons then
			g._wjCons.loop = (g._wjCons.loop and g._wjCons.loop:Disconnect() and false) or nil
			g._wjCons.ca   = (g._wjCons.ca   and g._wjCons.ca:Disconnect()   and false) or nil
		end
		local char  = g.Character or g.LocalPlayer.Character or g.get_char(g.LocalPlayer, 5)
		local human = g.Humanoid or (char and char:FindFirstChildWhichIsA("Humanoid")) or g.get_human(g.LocalPlayer, 5)
		if human and human.Parent then human.JumpPower = 0 end
	end
end

g.SetLoopJump = function(power)
	g.LoopJump_Value = power or 50
	if not g.LoopJump_Enabled then return end
	local char  = g.Character or g.LocalPlayer.Character or g.get_char(g.LocalPlayer, 5)
	local human = g.Humanoid or (char and char:FindFirstChildWhichIsA("Humanoid")) or g.get_human(g.LocalPlayer, 5)
	if not human or not human.Parent then return false, "no_humanoid" end
	human.JumpPower = g.LoopJump_Value
end

g.AntiRagdoll = function(state)
	g.AntiRagdoll_Enabled = state
	g._arCons = g._arCons or {}

	local function disable_ragdoll_scripts(char)
		for _, v in char:GetDescendants() do
			if (v:IsA("LocalScript") or v:IsA("Script")) and v.Name:lower():find("ragdoll") then
				v.Disabled = true
			end
		end
	end

	local function lock_char(char)
		local human = char:FindFirstChildWhichIsA("Humanoid")
		if char:HasTag("KF_Should_Ragdoll") then char:RemoveTag("KF_Should_Ragdoll") end
		local trigger = char:FindFirstChild("RagdollTrigger")
		if trigger then trigger.Value = false end
		if human then
			human:SetAttribute("RagdollEnabled", nil)
			human.PlatformStand = false
			human.AutoRotate    = true
			if human:GetState() == Enum.HumanoidStateType.Physics then
				human:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end
		disable_ragdoll_scripts(char)
	end

	local function bind(char)
		local human  = char:FindFirstChildWhichIsA("Humanoid")
		local trigger = char:FindFirstChild("RagdollTrigger")

		if trigger then
			g._arCons.trigger = (g._arCons.trigger and g._arCons.trigger:Disconnect() and false)
				or trigger:GetPropertyChangedSignal("Value"):Connect(function()
					if not g.AntiRagdoll_Enabled then return end
					if trigger.Value then trigger.Value = false end
				end)
		end

		if human then
			g._arCons.attr = (g._arCons.attr and g._arCons.attr:Disconnect() and false)
				or human.AttributeChanged:Connect(function(attr)
					if not g.AntiRagdoll_Enabled then return end
					if attr == "RagdollEnabled" then
						human:SetAttribute("RagdollEnabled", nil)
					end
				end)

			g._arCons.state = (g._arCons.state and g._arCons.state:Disconnect() and false)
				or human.StateChanged:Connect(function(_, new)
					if not g.AntiRagdoll_Enabled then return end
					if new == Enum.HumanoidStateType.Physics then
						human.PlatformStand = false
						human.AutoRotate    = true
						human:ChangeState(Enum.HumanoidStateType.GettingUp)
					end
				end)
		end

		g._arCons.tag = (g._arCons.tag and g._arCons.tag:Disconnect() and false)
			or CollectionService:GetInstanceAddedSignal("KF_Should_Ragdoll"):Connect(function(instance)
				if not g.AntiRagdoll_Enabled then return end
				if instance == char then
					char:RemoveTag("KF_Should_Ragdoll")
					lock_char(char)
				end
			end)

		g._arCons.desc = (g._arCons.desc and g._arCons.desc:Disconnect() and false)
			or char.DescendantAdded:Connect(function(v)
				if not g.AntiRagdoll_Enabled then return end
				if (v:IsA("LocalScript") or v:IsA("Script")) and v.Name:lower():find("ragdoll") then
					v.Disabled = true
				end
			end)
	end

	if state then
		local char = g.Character or g.LocalPlayer.Character or g.get_char(g.LocalPlayer, 5)
		if not char then return false, "no_character" end
		lock_char(char)
		bind(char)
		g._arCons.ca = (g._arCons.ca and g._arCons.ca:Disconnect() and false)
			or g.LocalPlayer.CharacterAdded:Connect(function(newChar)
				if not g.AntiRagdoll_Enabled then return end
				char = newChar
				newChar:WaitForChild("Humanoid", 5)
				newChar:WaitForChild("RagdollTrigger", 5)
				lock_char(char)
				bind(char)
			end)
	else
		if g._arCons then
			g._arCons.trigger = (g._arCons.trigger and g._arCons.trigger:Disconnect() and false) or nil
			g._arCons.attr    = (g._arCons.attr    and g._arCons.attr:Disconnect()    and false) or nil
			g._arCons.state   = (g._arCons.state   and g._arCons.state:Disconnect()   and false) or nil
			g._arCons.tag     = (g._arCons.tag     and g._arCons.tag:Disconnect()     and false) or nil
			g._arCons.desc    = (g._arCons.desc    and g._arCons.desc:Disconnect()    and false) or nil
			g._arCons.ca      = (g._arCons.ca      and g._arCons.ca:Disconnect()      and false) or nil
		end
	end
end

g.Safe_Teleport_On_Low_Health = function(state)
	g.Safe_Teleport_Enabled = state
	g._sth_cons = g._sth_cons or {}
	if state then
		local char        = g.Character or g.LocalPlayer.Character or g.get_char(g.LocalPlayer, 5)
		local root        = g.HumanoidRootPart or (char and char:FindFirstChild("HumanoidRootPart")) or g.get_root(g.LocalPlayer, 5)
		local health_val  = g.LocalPlayer:WaitForChild("Health", 5)
		if not char or not root or not health_val then return false, "no_character" end
		local fired        = false
		local saved_cframe = nil
		local returned     = false
		local busy         = false
		local function check()
			if busy then return end
			if not g.Safe_Teleport_Enabled then return end
			if not (char and char.Parent and root and root.Parent) then return end
			local current_health = health_val.Value
			if current_health <= 15 and not fired then
				busy = true

				local ok_save, cf = pcall(function() return root.CFrame end)
				if ok_save and cf then
					saved_cframe = cf
				end

				local base_plate = workspace:FindFirstChild("FLAMES_HUB_PART")
				if not base_plate or not base_plate:IsA("Part") then
					create_baseplate_part()
					busy = false
					return
				end

				local ok_tp, tp_err = pcall(function()
					root.CFrame = base_plate.CFrame + Vector3.new(0, 5, 0)
				end)

				if ok_tp then
					fired    = true
					returned = false
				else
					g.notify("Error", "Bail teleport failed: " .. tostring(tp_err), 5)
				end
				busy = false
			elseif current_health >= 85 and fired and not returned and saved_cframe then
				busy = true
				local ok_ret, ret_err = pcall(function()
					root.CFrame = saved_cframe
				end)

				if ok_ret then
					returned     = true
					fired        = false
					saved_cframe = nil
					g.notify("Success", "Returned to saved position.", 3)
				else
					g.notify("Error", "Return teleport failed: " .. tostring(ret_err), 5)
				end

				busy = false
			end
		end

		g._sth_cons.health = (
			g._sth_cons.health and g._sth_cons.health:Disconnect() and false
		) or health_val:GetPropertyChangedSignal("Value"):Connect(check)

		g._sth_cons.ca = (
			g._sth_cons.ca and g._sth_cons.ca:Disconnect() and false
		) or g.LocalPlayer.CharacterAdded:Connect(function(new_char)
			if not g.Safe_Teleport_Enabled then return end
			task.spawn(function()
				char         = new_char
				root         = new_char:WaitForChild("HumanoidRootPart", 5)
				fired        = false
				returned     = false
				saved_cframe = nil
				busy         = false

				local new_health = g.LocalPlayer:WaitForChild("Health", 5)
				if new_health then
					health_val = new_health
					if g._sth_cons.health then g._sth_cons.health:Disconnect() end
					g._sth_cons.health = health_val:GetPropertyChangedSignal("Value"):Connect(check)
				end
			end)
		end)
	else
		if g._sth_cons then
			g._sth_cons.health = (
				g._sth_cons.health and g._sth_cons.health:Disconnect() and false
			) or nil
			g._sth_cons.ca = (
				g._sth_cons.ca and g._sth_cons.ca:Disconnect() and false
			) or nil
		end
	end
end

g.FlyJump = function(state)
	g.FlyJump_Enabled = state
	g._fj_cons = g._fj_cons or {}

	if state then
		local char  = g.Character or g.LocalPlayer.Character or g.get_char(g.LocalPlayer, 5)
		local human = g.Humanoid or (char and char:FindFirstChildWhichIsA("Humanoid")) or g.get_human(g.LocalPlayer, 5)
		if not char or not human then return false, "no_character" end

		g._fj_cons.jump = (g._fj_cons.jump and g._fj_cons.jump:Disconnect() and false)
			or UserInputService.JumpRequest:Connect(function()
				if not g.FlyJump_Enabled then return end
				if human and human.Parent then
					human:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)

		g._fj_cons.ca = (g._fj_cons.ca and g._fj_cons.ca:Disconnect() and false)
			or g.LocalPlayer.CharacterAdded:Connect(function(new_char)
				if not g.FlyJump_Enabled then return end
				char  = new_char
				human = new_char:WaitForChild("Humanoid", 5)
			end)
	else
		if g._fj_cons then
			g._fj_cons.jump = (g._fj_cons.jump and g._fj_cons.jump:Disconnect() and false) or nil
			g._fj_cons.ca   = (g._fj_cons.ca   and g._fj_cons.ca:Disconnect()   and false) or nil
		end
	end
end

g.decodeHTMLEntities = function(str) return str:gsub("&gt;", ">"):gsub("&lt;", "<"):gsub("&amp;", "&"):gsub("&quot;", '"'):gsub("&#39;", "'") end
g.Float_Running_In_Flames_Hub = g.Float_Running_In_Flames_Hub or false
local float_part
local inc = false
local dec = false
local float_name = "FlamesFloat_" .. tostring(math.random(1000, 9999))
local UIS = UserInputService
local isMobile = UIS.TouchEnabled
g.start_flames_float = function()
   if g.Float_Running_In_Flames_Hub then return g.notify("Warning", "Flames Float-V1 is already enabled.", 3) end
   local char = g.Character or LocalPlayer.Character or get_char(LocalPlayer, 5)
   local root = g.HumanoidRootPart or char and char:FindFirstChild("HumanoidRootPart") or get_root(LocalPlayer, 6)
   local hum = g.Humanoid or char and char:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer, 6)
   if not char or not root or not hum then return end
   g.Float_Running_In_Flames_Hub = true
   float_part = Instance.new("Part")
   float_part.Name = float_name
   float_part.Parent = workspace
   float_part.Size = Vector3.new(10, 2, 10)
   float_part.Transparency = 1
   float_part.Anchored = true
   float_part.CanCollide = true
   float_part.CastShadow = false

   local controlModule
   if isMobile then
      local ok, cm = pcall(function()
         return require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
      end)
      if ok then controlModule = cm end
   end

   if not isMobile then
      g.FlamesLibrary.connect("flames_float_input_began",
         UIS.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.KeyCode == Enum.KeyCode.E then inc = true end
            if i.KeyCode == Enum.KeyCode.Q then dec = true end
         end)
      )
      g.FlamesLibrary.connect("flames_float_input_ended",
         UIS.InputEnded:Connect(function(i)
            if i.KeyCode == Enum.KeyCode.E then inc = false end
            if i.KeyCode == Enum.KeyCode.Q then dec = false end
         end)
      )
   end

   local offset = 0

   if g.FlamesLibrary.is_alive("flames_float_heartbeat") then
      g.FlamesLibrary.disconnect("flames_float_heartbeat")
   end
   wait(0.1)
   g.FlamesLibrary.connect("flames_float_heartbeat", RunService.RenderStepped:Connect(function()
      if not float_part then return end
      local char_now = g.Character or LocalPlayer.Character
      if not char_now then return end
      local root_now = g.HumanoidRootPart or char_now:FindFirstChild("HumanoidRootPart")
      local hum_now = g.Humanoid or char_now:FindFirstChildOfClass("Humanoid")
      if not root_now or not hum_now then return end
      local hrp_half = (root_now.Size.Y or 2) * 0.5
      local part_half = float_part.Size.Y * 0.5
      local feet_from_root
      if hum_now.RigType == Enum.HumanoidRigType.R6 then
         feet_from_root = hrp_half + (hum_now.HipHeight > 0 and hum_now.HipHeight or 2)
      else
         feet_from_root = hrp_half + (hum_now.HipHeight or 2)
      end

      local base_offset = feet_from_root + part_half
      local moveUp = false
      local moveDown = false
      if isMobile and controlModule then
         local mv = controlModule:GetMoveVector()
         moveUp = hum_now:GetState() == Enum.HumanoidStateType.Jumping
         moveDown = mv.Z > 0.1
      else
         moveUp = inc
         moveDown = dec
      end

      local delta = (moveDown and 1.5) or (moveUp and -1.5) or 0
      offset = math.max(0, base_offset + delta)

      float_part.CFrame = CFrame.new(
         root_now.Position.X,
         root_now.Position.Y - offset,
         root_now.Position.Z
      )
   end))

   if isMobile then
      g.notify("Success", "Flames Float-V1 enabled (Jump = Up | Move Back = Down)", 7)
   else
      g.notify("Success", "Flames Float-V1 enabled (Hold E = Up | Hold Q = Down)", 7)
   end
end

g.stop_flames_float = g.stop_flames_float or function()
   g.Float_Running_In_Flames_Hub = false
   g.FlamesLibrary.disconnect("flames_float_input_began")
   g.FlamesLibrary.disconnect("flames_float_input_ended")
   g.FlamesLibrary.disconnect("flames_float_heartbeat")
   if float_part then
      float_part:Destroy()
      float_part = nil
   end

   inc = false
   dec = false
   g.notify("Success", "Flames Float-V1 is now disabled.", 3)
end

local esp_drawings = {}
local function is_supported(f) if f and typeof(f) == "function" then return f end end
local function drawing_supported() return Drawing and typeof(Drawing) == "table" end
local function get_viewport() return Camera.ViewportSize end
local function world_to_screen(pos) local screen, on_screen = Camera:WorldToViewportPoint(pos) return Vector2.new(screen.X, screen.Y), on_screen, screen.Z end
local function get_char_parts(char)
	return {
		head = char:FindFirstChild("Head"),
		root = char:FindFirstChild("HumanoidRootPart"),
		upper_torso = char:FindFirstChild("UpperTorso"),
		lower_torso = char:FindFirstChild("LowerTorso"),
		left_upper_arm = char:FindFirstChild("LeftUpperArm"),
		right_upper_arm = char:FindFirstChild("RightUpperArm"),
		left_lower_arm = char:FindFirstChild("LeftLowerArm"),
		right_lower_arm = char:FindFirstChild("RightLowerArm"),
		left_hand = char:FindFirstChild("LeftHand"),
		right_hand = char:FindFirstChild("RightHand"),
		left_upper_leg = char:FindFirstChild("LeftUpperLeg"),
		right_upper_leg = char:FindFirstChild("RightUpperLeg"),
		left_lower_leg = char:FindFirstChild("LeftLowerLeg"),
		right_lower_leg = char:FindFirstChild("RightLowerLeg"),
		left_foot = char:FindFirstChild("LeftFoot"),
		right_foot = char:FindFirstChild("RightFoot"),
	}
end

local skeleton_connections = {
	{"head", "upper_torso"},
	{"upper_torso", "lower_torso"},
	{"upper_torso", "left_upper_arm"},
	{"left_upper_arm", "left_lower_arm"},
	{"left_lower_arm", "left_hand"},
	{"upper_torso", "right_upper_arm"},
	{"right_upper_arm", "right_lower_arm"},
	{"right_lower_arm", "right_hand"},
	{"lower_torso", "left_upper_leg"},
	{"left_upper_leg", "left_lower_leg"},
	{"left_lower_leg", "left_foot"},
	{"lower_torso", "right_upper_leg"},
	{"right_upper_leg", "right_lower_leg"},
	{"right_lower_leg", "right_foot"},
}

local function make_drawing(type, props)
	if not drawing_supported() then return end
	local obj = Drawing.new(type)
	for k, v in pairs(props) do obj[k] = v end
	return obj
end

local function destroy_drawing(obj)
	if obj and is_supported(obj.Destroy) then
		local exists = is_supported(isrenderobj) and isrenderobj(obj)
		if exists ~= false then pcall(function() obj:Destroy() end) end
	end
end

local function init_player_drawings(player)
	if esp_drawings[player] then return end
	esp_drawings[player] = {
		box = {
			make_drawing("Square", {Visible = false, Color = Color3.fromRGB(255,255,255), Thickness = 1.5, Filled = false, ZIndex = 1}),
			make_drawing("Square", {Visible = false, Color = Color3.fromRGB(0,0,0), Thickness = 3, Filled = false, ZIndex = 0}),
		},
		name = make_drawing("Text", {Visible = false, Color = Color3.fromRGB(255,255,255), Size = 14, Center = true, Outline = true, OutlineColor = Color3.fromRGB(0,0,0), ZIndex = 2}),
		tracer = {
			make_drawing("Line", {Visible = false, Color = Color3.fromRGB(255,255,255), Thickness = 1, ZIndex = 1}),
			make_drawing("Line", {Visible = false, Color = Color3.fromRGB(0,0,0), Thickness = 2, ZIndex = 0}),
		},
		skeleton = {},
		highlight = nil,
	}

	for _ in ipairs(skeleton_connections) do
		table.insert(esp_drawings[player].skeleton, {
			make_drawing("Line", {Visible = false, Color = Color3.fromRGB(255,255,255), Thickness = 1, ZIndex = 1}),
			make_drawing("Line", {Visible = false, Color = Color3.fromRGB(0,0,0), Thickness = 2, ZIndex = 0}),
		})
	end
end

local function destroy_player_drawings(player)
	local d = esp_drawings[player]
	if not d then return end
	for _, obj in ipairs(d.box) do destroy_drawing(obj) end
	destroy_drawing(d.name)
	for _, obj in ipairs(d.tracer) do destroy_drawing(obj) end
	for _, pair in ipairs(d.skeleton) do for _, obj in ipairs(pair) do destroy_drawing(obj) end end
	if d.highlight and d.highlight.Parent then d.highlight:Destroy() end
	esp_drawings[player] = nil
end

local function get_box(char)
	local root = char:FindFirstChild("HumanoidRootPart")
	local head = char:FindFirstChild("Head")
	if not root or not head then return end
	local top_pos, top_on = world_to_screen(head.Position + Vector3.new(0, 0.75, 0))
	local bot_pos, bot_on = world_to_screen(root.Position - Vector3.new(0, 3, 0))
	if not top_on and not bot_on then return end
	local height = math.abs(top_pos.Y - bot_pos.Y)
	local width = height * 0.55
	return Vector2.new(top_pos.X - width / 2, top_pos.Y), Vector2.new(width, height)
end

local rainbow_hue = 0
local function get_rainbow_color() return Color3.fromHSV(rainbow_hue, 1, 1) end
local function update_esp()
	for _, player in ipairs(Players:GetPlayers()) do
		if player == Players.LocalPlayer then continue end
		local char = player.Character
		local d = esp_drawings[player]
		if not d or not char then
			if d then
				for _, obj in ipairs(d.box) do obj.Visible = false end
				d.name.Visible = false
				for _, obj in ipairs(d.tracer) do obj.Visible = false end
				for _, pair in ipairs(d.skeleton) do for _, obj in ipairs(pair) do obj.Visible = false end end
			end
			continue
		end

		local human = char:FindFirstChildWhichIsA("Humanoid")
		if not human or human.Health <= 0 then
			for _, obj in ipairs(d.box) do obj.Visible = false end
			d.name.Visible = false
			for _, obj in ipairs(d.tracer) do obj.Visible = false end
			for _, pair in ipairs(d.skeleton) do for _, obj in ipairs(pair) do obj.Visible = false end end
			continue
		end

		local esp_color = g.ESP_Rainbow_Enabled and get_rainbow_color() or Color3.fromRGB(255, 255, 255)
		local viewport = get_viewport()
		if g.ESP_Box_Enabled then
			local pos, size = get_box(char)
			if pos and size then
				d.box[1].Size = size d.box[1].Position = pos d.box[1].Color = esp_color d.box[1].Visible = true
				d.box[2].Size = size + Vector2.new(2, 2) d.box[2].Position = pos - Vector2.new(1, 1) d.box[2].Visible = true
			else
				for _, obj in ipairs(d.box) do obj.Visible = false end
			end
		else
			for _, obj in ipairs(d.box) do obj.Visible = false end
		end

		if g.ESP_Name_Enabled then
			local head = char:FindFirstChild("Head")
			if head then
				local screen_pos, on_screen = world_to_screen(head.Position + Vector3.new(0, 1.75, 0))
				if on_screen then
					d.name.Text = player.Name
					d.name.Position = screen_pos
					d.name.Color = esp_color
					d.name.Visible = true
				else
					d.name.Visible = false
				end
			end
		else
			d.name.Visible = false
		end

		if g.ESP_Tracer_Enabled then
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				local screen_pos, on_screen = world_to_screen(root.Position)
				if on_screen then
					local origin = Vector2.new(viewport.X / 2, viewport.Y)
					d.tracer[1].From = origin d.tracer[1].To = screen_pos d.tracer[1].Color = esp_color d.tracer[1].Visible = true
					d.tracer[2].From = origin d.tracer[2].To = screen_pos d.tracer[2].Visible = true
				else
					for _, obj in ipairs(d.tracer) do obj.Visible = false end
				end
			end
		else
			for _, obj in ipairs(d.tracer) do obj.Visible = false end
		end

		if g.ESP_Skeleton_Enabled then
			local parts = get_char_parts(char)
			for i, conn in ipairs(skeleton_connections) do
				local a = parts[conn[1]]
				local b = parts[conn[2]]
				local pair = d.skeleton[i]
				if a and b then
					local sa, oa = world_to_screen(a.Position)
					local sb, ob = world_to_screen(b.Position)
					if oa or ob then
						pair[1].From = sa pair[1].To = sb pair[1].Color = esp_color pair[1].Visible = true
						pair[2].From = sa pair[2].To = sb pair[2].Visible = true
					else
						for _, obj in ipairs(pair) do obj.Visible = false end
					end
				else
					for _, obj in ipairs(pair) do obj.Visible = false end
				end
			end
		else
			for _, pair in ipairs(d.skeleton) do for _, obj in ipairs(pair) do obj.Visible = false end end
		end

		if g.ESP_Highlight_Enabled then
			if not d.highlight or not d.highlight.Parent then
				local hl = Instance.new("Highlight")
				hl.FillTransparency = 0.5
				hl.OutlineTransparency = 0
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = char
				d.highlight = hl
			end
			d.highlight.FillColor = esp_color
			d.highlight.OutlineColor = esp_color
		else
			if d.highlight and d.highlight.Parent then
				d.highlight:Destroy()
				d.highlight = nil
			end
		end
	end
end

local function teardown_esp()
	FlamesLibrary.disconnect("esp_heartbeat")
	FlamesLibrary.disconnect("esp_rainbow")
	FlamesLibrary.disconnect("esp_player_added")
	FlamesLibrary.disconnect("esp_player_removing")
	FlamesLibrary.disconnect("esp_toggle_watcher")
	for _, player in ipairs(Players:GetPlayers()) do destroy_player_drawings(player) end
end

g.ESP_Enabled = g.ESP_Enabled or false
g.ESP_Box_Enabled = g.ESP_Box_Enabled or false
g.ESP_Name_Enabled = g.ESP_Name_Enabled or false
g.ESP_Tracer_Enabled = g.ESP_Tracer_Enabled or false
g.ESP_Skeleton_Enabled = g.ESP_Skeleton_Enabled or false
g.ESP_Highlight_Enabled = g.ESP_Highlight_Enabled or false
g.ESP_Rainbow_Enabled = g.ESP_Rainbow_Enabled or false
g.ESP = function(state)
	if not drawing_supported() then return g.notify("Error", "Drawing library not supported.", 3) end
	g.ESP_Enabled = state

	if state then
		for _, player in ipairs(Players:GetPlayers()) do if player ~= Players.LocalPlayer then init_player_drawings(player) end end
		FlamesLibrary.connect("esp_player_added", Players.PlayerAdded, function(player)
			if not g.ESP_Enabled then return end
			init_player_drawings(player)
		end)

		FlamesLibrary.connect("esp_player_removing", Players.PlayerRemoving, function(player)
			destroy_player_drawings(player)
		end)

		FlamesLibrary.connect("esp_heartbeat", RunService.Heartbeat, function()
			if not g.ESP_Enabled then return end
			update_esp()
		end)

		FlamesLibrary.connect("esp_rainbow", RunService.Heartbeat, function(dt)
			if not g.ESP_Rainbow_Enabled then return end
			rainbow_hue = (rainbow_hue + dt * 0.5) % 1
		end)

		FlamesLibrary.connect("esp_toggle_watcher", RunService.Heartbeat, function()
			if not g.ESP_Enabled then teardown_esp() end
		end)
	else
		teardown_esp()
	end
end

g.ESP_Box = function(state) g.ESP_Box_Enabled = state end
g.ESP_Name = function(state) g.ESP_Name_Enabled = state end
g.ESP_Tracer = function(state) g.ESP_Tracer_Enabled = state end
g.ESP_Skeleton = function(state) g.ESP_Skeleton_Enabled = state end
g.ESP_Highlight = function(state) g.ESP_Highlight_Enabled = state end
g.ESP_Rainbow = function(mode, state)
	if mode == "box" then g.ESP_Box_Rainbow = state
	elseif mode == "name" then g.ESP_Name_Rainbow = state
	elseif mode == "tracer" then g.ESP_Tracer_Rainbow = state
	elseif mode == "skeleton" then g.ESP_Skeleton_Rainbow = state
	elseif mode == "highlight" then g.ESP_Highlight_Rainbow = state
	elseif mode == "all" then
		g.ESP_Box_Rainbow = state
		g.ESP_Name_Rainbow = state
		g.ESP_Tracer_Rainbow = state
		g.ESP_Skeleton_Rainbow = state
		g.ESP_Highlight_Rainbow = state
		g.ESP_Rainbow_Enabled = state
	end
end

local Atlas = loadstring(game:HttpGet("https://gitlab.com/greatest-group/experience_coding/-/raw/main/UIs/Atlas.lua?ref_type=heads"))()
local UI = Atlas.new({
	Name = "Flames Hub | " .. tostring(getgenv().Script_Version),
	ConfigFolder = "Flames_Hub_Menu_Configuration",
	Color = Color3.fromRGB(21, 103, 251),
	Bind = "RightShift",
})
local Main_Page = UI:CreatePage("Main")
local Home_Section = Main_Page:CreateSection("Home")
local Local_Player_Section = Main_Page:CreateSection("LocalPlayer")
local Extras_Section = Main_Page:CreateSection("Extras")

g.Hide_Annoying_GUIs_Toggle_UI = Home_Section:CreateToggle({
Name = "Show Annoying GUIs",
Flag = "hiding_all_annoying_guis",
Default = getgenv().annoying_guis_hidden or false,
Callback = function(state)
	g.toggle_annoying_guis_func(state)
end}, "hiding_all_annoying_guis")

g.Loop_Speed_Toggle_UI = Local_Player_Section:CreateToggle({
Name = "Spoof Speed (FE)",
Flag = "Loop_Speed_Toggled_UI",
Default = getgenv().LoopSpeed_Enabled or false,
Callback = function(state)
	g.LoopSpeed(state)
end}, "Loop_Speed_Toggled_UI")

g.loop_speed_number_slider = Local_Player_Section:CreateSlider({
Name = "Set Speed",
Flag = "Speed_Setter_Slider_UI",
Min = StarterPlayer.CharacterWalkSpeed or 9,
Max = 300,
Default = g.LoopSpeed_Value or 9,
Callback = function(value)
	g.SetLoopSpeed(value)
end}, "Speed_Setter_Slider_UI")

g.Loop_Jump_Toggle_UI = Local_Player_Section:CreateToggle({
Name = "Spoof Jump Power (FE)",
Flag = "Loop_Jump_Toggled_UI",
Default = g.LoopJump_Enabled or false,
Callback = function(state)
	g.LoopJump(state)
end}, "Loop_Jump_Toggled_UI")

g.loop_jump_number_slider = Local_Player_Section:CreateSlider({
Name = "Set Jump Power",
Flag = "Jump_Power_Setter_Slider_UI",
Min = 0,
Max = 300,
Default = g.LoopJump_Value or 50,
Callback = function(value)
	g.SetLoopJump(value)
end}, "Jump_Power_Setter_Slider_UI")

g.FlyJump_Toggle_UI = Local_Player_Section:CreateToggle({
Name = "Fly Jump (FE)",
Flag = "FlyJump_Toggled_UI",
Default = g.FlyJump_Enabled or false,
Callback = function(state)
	g.FlyJump(state)
end}, "FlyJump_Toggled_UI")

g.Float_Toggle_UI = Local_Player_Section:CreateToggle({
Name = "Float (FE)",
Flag = "Float_Toggled_UI",
Default = g.Float_Running_In_Flames_Hub or false,
Callback = function(state)
	if state then
		g.start_flames_float()
	else
		g.stop_flames_float()
	end
end}, "Float_Toggled_UI")

g.ESP_Master_Toggle_UI = Extras_Section:CreateToggle({
Name = "ESP",
Flag = "ESP_Master_Toggled_UI",
Default = g.ESP_Enabled or false,
Callback = function(state)
	g.ESP(state)
end}, "ESP_Master_Toggled_UI")

g.ESP_Box_Toggle_UI = Extras_Section:CreateToggle({
Name = "Box ESP",
Flag = "ESP_Box_Toggled_UI",
Default = g.ESP_Box_Enabled or false,
Callback = function(state)
	g.ESP_Box(state)
end}, "ESP_Box_Toggled_UI")

g.ESP_Name_Toggle_UI = Extras_Section:CreateToggle({
Name = "Name ESP",
Flag = "ESP_Name_Toggled_UI",
Default = g.ESP_Name_Enabled or false,
Callback = function(state)
	g.ESP_Name(state)
end}, "ESP_Name_Toggled_UI")

g.ESP_Tracer_Toggle_UI = Extras_Section:CreateToggle({
Name = "Tracers",
Flag = "ESP_Tracer_Toggled_UI",
Default = g.ESP_Tracer_Enabled or false,
Callback = function(state)
	g.ESP_Tracer(state)
end}, "ESP_Tracer_Toggled_UI")

g.ESP_Skeleton_Toggle_UI = Extras_Section:CreateToggle({
Name = "Skeleton ESP",
Flag = "ESP_Skeleton_Toggled_UI",
Default = g.ESP_Skeleton_Enabled or false,
Callback = function(state)
	g.ESP_Skeleton(state)
end}, "ESP_Skeleton_Toggled_UI")

g.ESP_Highlight_Toggle_UI = Extras_Section:CreateToggle({
Name = "Highlight ESP",
Flag = "ESP_Highlight_Toggled_UI",
Default = g.ESP_Highlight_Enabled or false,
Callback = function(state)
	g.ESP_Highlight(state)
end}, "ESP_Highlight_Toggled_UI")

g.ESP_Rainbow_Toggle_UI = Extras_Section:CreateToggle({
Name = "Rainbow ESP (All)",
Flag = "ESP_Rainbow_Toggled_UI",
Default = g.ESP_Rainbow_Enabled or false,
Callback = function(state)
	g.ESP_Rainbow("all", state)
end}, "ESP_Rainbow_Toggled_UI")

g.Anti_Ragdoll_Toggle_UI = Local_Player_Section:CreateToggle({
Name = "Anti-Ragdoll",
Flag = "Anti_Ragdoll_Toggled_UI",
Default = g.AntiRagdoll_Enabled or false,
Callback = function(state)
	g.AntiRagdoll(state)
end}, "Anti_Ragdoll_Toggled_UI")

g.Safe_Teleport_Toggle_UI = Home_Section:CreateToggle({
Name = "Safe Teleport (Low Health)",
Flag = "Safe_Teleport_Toggled_UI",
Default = g.Safe_Teleport_Enabled or false,
Callback = function(state)
	g.Safe_Teleport_On_Low_Health(state)
end}, "Safe_Teleport_Toggled_UI")