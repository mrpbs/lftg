-- Copy Avatar Menu Script
-- Single feature: Copy another player's avatar appearance
-- Uses the same logic from the main Flames Hub experience

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Helper function to find player by name or displayname
local function findplr(name)
    if not name or name == "" then return nil end
    local name_lower = name:lower()
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(name_lower, 1, true) or plr.DisplayName:lower():find(name_lower, 1, true) then
            return plr
        end
    end
    return nil
end

-- Helper function to calculate average skin tone
local function avgSkin(bc)
    local skin_tone_colors = {
        bc.HeadColor3,
        bc.LeftArmColor3,
        bc.RightArmColor3,
        bc.TorsoColor3,
        bc.LeftLegColor3,
        bc.RightLegColor3
    }

    local r, g, b = 0, 0, 0
    for _, c in ipairs(skin_tone_colors) do
        r = r + c.R
        g = g + c.G
        b = b + c.B
    end

    return Color3.new(r / 6, g / 6, b / 6)
end

-- Notify function
local function notify(title, message, duration)
    if game:GetService("StarterGui") then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title,
                Text = message,
                Duration = duration or 5
            })
        end)
    end
end

-- Global state for copy progress
local is_copying_avatar = false

-- UI Elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CopyAvatarMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 450)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Corner Radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Text = "Copy Avatar Tool"
title.BorderSizePixel = 0
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = title

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.BorderSizePixel = 0
closeBtn.Parent = mainFrame

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Instructions Label
local instructionLabel = Instance.new("TextLabel")
instructionLabel.Name = "Instructions"
instructionLabel.Size = UDim2.new(1, -20, 0, 60)
instructionLabel.Position = UDim2.new(0, 10, 0, 60)
instructionLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
instructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
instructionLabel.TextSize = 13
instructionLabel.Font = Enum.Font.Gotham
instructionLabel.Text = "Enter a player name below and click 'Copy Avatar' to copy their appearance."
instructionLabel.TextWrapped = true
instructionLabel.BorderSizePixel = 0
instructionLabel.Parent = mainFrame

local instrCorner = Instance.new("UICorner")
instrCorner.CornerRadius = UDim.new(0, 8)
instrCorner.Parent = instructionLabel

-- Player Input Label
local inputLabel = Instance.new("TextLabel")
inputLabel.Name = "InputLabel"
inputLabel.Size = UDim2.new(1, -20, 0, 25)
inputLabel.Position = UDim2.new(0, 10, 0, 130)
inputLabel.BackgroundTransparency = 1
inputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
inputLabel.TextSize = 14
inputLabel.Font = Enum.Font.GothamBold
inputLabel.Text = "Player Name:"
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Parent = mainFrame

-- TextBox for Player Input
local playerInput = Instance.new("TextBox")
playerInput.Name = "PlayerInput"
playerInput.Size = UDim2.new(1, -20, 0, 40)
playerInput.Position = UDim2.new(0, 10, 0, 160)
playerInput.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
playerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
playerInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
playerInput.PlaceholderText = "Enter player username..."
playerInput.TextSize = 14
playerInput.Font = Enum.Font.Gotham
playerInput.BorderSizePixel = 0
playerInput.ClearTextOnFocus = false
playerInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = playerInput

-- Copy Avatar Button
local copyBtn = Instance.new("TextButton")
copyBtn.Name = "CopyBtn"
copyBtn.Size = UDim2.new(1, -20, 0, 50)
copyBtn.Position = UDim2.new(0, 10, 0, 220)
copyBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.TextSize = 16
copyBtn.Font = Enum.Font.GothamBold
copyBtn.Text = "Copy Avatar"
copyBtn.BorderSizePixel = 0
copyBtn.Parent = mainFrame

local copyBtnCorner = Instance.new("UICorner")
copyBtnCorner.CornerRadius = UDim.new(0, 8)
copyBtnCorner.Parent = copyBtn

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, -20, 0, 80)
statusLabel.Position = UDim2.new(0, 10, 0, 285)
statusLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "Ready to copy avatar"
statusLabel.TextWrapped = true
statusLabel.TextYAlignment = Enum.TextYAlignment.Top
statusLabel.BorderSizePixel = 0
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- Copy Avatar Function (same logic as main experience file)
local function copy_plr_avatar(Player)
    if is_copying_avatar then
        return notify("Warning", "Copy avatar is already running!, wait a moment, until it's done.", 5)
    end
    is_copying_avatar = true

    if not Player or not Player.Character then
        is_copying_avatar = false
        return notify("Warning", "Target not found!", 5)
    end

    local hum = Player.Character:FindFirstChildWhichIsA("Humanoid")
    if not hum then
        is_copying_avatar = false
        return notify("Warning", "No humanoid!", 5)
    end

    local desc = hum:GetAppliedDescription()
    if not desc then
        is_copying_avatar = false
        return notify("Warning", "No description!", 5)
    end

    -- Get local player humanoid
    local localChar = localPlayer.Character
    if not localChar then
        is_copying_avatar = false
        return notify("Warning", "Your character not loaded!", 5)
    end

    local localHum = localChar:FindFirstChildWhichIsA("Humanoid")
    if not localHum then
        is_copying_avatar = false
        return notify("Warning", "Your humanoid not found!", 5)
    end

    -- Collect accessories
    local accessories = {}
    for _, acc in ipairs(desc:GetAccessories(true)) do
        table.insert(accessories, {
            Rotation = "  ",
            Position = "  ",
            Scale = "1 1 1",
            IsLayered = acc.IsLayered,
            AccessoryType = acc.AccessoryType.Name,
            AssetId = acc.AssetId,
            Order = acc.Order,
            Puffiness = acc.Puffiness
        })
    end

    -- Collect properties
    local properties = {
        Head = desc.Head or 0,
        Torso = desc.Torso or 0,
        LeftArm = desc.LeftArm or 0,
        RightArm = desc.RightArm or 0,
        LeftLeg = desc.LeftLeg or 0,
        RightLeg = desc.RightLeg or 0,
        Face = desc.Face or 0,
        Shirt = desc.Shirt or 0,
        Pants = desc.Pants or 0,
        GraphicTShirt = desc.GraphicTShirt or 0,
        RunAnimation = desc.RunAnimation or 0,
        WalkAnimation = desc.WalkAnimation or 0,
        JumpAnimation = desc.JumpAnimation or 0,
        FallAnimation = desc.FallAnimation or 0,
        ClimbAnimation = desc.ClimbAnimation or 0,
        IdleAnimation = desc.IdleAnimation or 0,
        SwimAnimation = desc.SwimAnimation or 0,
        HeightScale = desc.HeightScale or 1,
        WidthScale = desc.WidthScale or 1,
        DepthScale = desc.DepthScale or 1,
        HeadScale = desc.HeadScale or 1,
        BodyTypeScale = desc.BodyTypeScale or 0,
        ProportionScale = desc.ProportionScale or 0,
    }

    -- Apply description to local player
    pcall(function()
        localHum:ApplyDescription(desc)
    end)

    -- Apply skin tone
    local bodyColors = Player.Character:FindFirstChildOfClass("BodyColors")
    if Player.Character and bodyColors then
        local localBodyColors = localChar:FindFirstChildOfClass("BodyColors")
        if localBodyColors then
            pcall(function()
                local skin = avgSkin(bodyColors)
                localBodyColors.HeadColor3 = skin
                localBodyColors.TorsoColor3 = skin
                localBodyColors.LeftArmColor3 = skin
                localBodyColors.RightArmColor3 = skin
                localBodyColors.LeftLegColor3 = skin
                localBodyColors.RightLegColor3 = skin
            end)
        end
    end

    notify("Success", "Copied avatar from " .. Player.Name, 5)
    is_copying_avatar = false
end

-- Button Click Handler
copyBtn.MouseButton1Click:Connect(function()
    local playerName = playerInput.Text:match("^%s*(.-)%s*$")
    
    if playerName == "" then
        statusLabel.Text = "Error: Please enter a player name"
        return
    end

    local targetPlayer = findplr(playerName)
    if not targetPlayer then
        statusLabel.Text = "Error: Player '" .. playerName .. "' not found"
        return
    end

    if targetPlayer == localPlayer then
        statusLabel.Text = "Error: Cannot copy your own avatar"
        return
    end

    copy_plr_avatar(targetPlayer)
end)

-- Allow Enter key to trigger copy
playerInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        copyBtn:TriggerEvent("MouseButton1Click")
    end
end)

statusLabel.Text = "Ready to copy avatar"

print("Copy Avatar Menu loaded! Use the menu to copy avatars.")
