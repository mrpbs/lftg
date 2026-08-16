-- Ultimate Roblox Workspace Metadata Engine & Layered Clothing Scanner (Updated)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")
local HttpService = game:GetService("HttpService")

-- Prevent duplicate GUIs
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DeepMetadataScanner") then
    LocalPlayer.PlayerGui.DeepMetadataScanner:Destroy()
end

-- Create Layout Screen UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeepMetadataScanner"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Drag Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 450)
MainFrame.Position = UDim2.new(0.5, -180, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

-- Top Title Bar Frame
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "🧬 Deep Live Outfit Scanner"
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -70, 0, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TopBar

-- Back Button (Hidden by default)
local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 60, 0, 25)
BackBtn.Position = UDim2.new(0, 10, 0, 45)
BackBtn.Text = "◀ Back"
BackBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackBtn.Font = Enum.Font.SourceSansBold
BackBtn.TextSize = 14
BackBtn.BorderSizePixel = 0
BackBtn.Visible = false
BackBtn.Parent = MainFrame

-- Refresh Button
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, -20, 0, 25)
RefreshBtn.Position = UDim2.new(0, 10, 0, 45)
RefreshBtn.Text = "Refresh Player List"
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 14
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Parent = MainFrame

-- Containers for Views
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -80)
ContentContainer.Position = UDim2.new(0, 0, 0, 80)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Player List Scroll Context
local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -20, 1, -10)
PlayerScroll.Position = UDim2.new(0, 10, 0, 0)
PlayerScroll.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
PlayerScroll.ScrollBarThickness = 6
PlayerScroll.Parent = ContentContainer

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Parent = PlayerScroll
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 6)

PlayerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, PlayerListLayout.AbsoluteContentSize.Y + 10)
end)

-- Asset Scan Scroll Context (Hidden initially)
local AssetScroll = Instance.new("ScrollingFrame")
AssetScroll.Size = UDim2.new(1, -20, 1, -10)
AssetScroll.Position = UDim2.new(0, 10, 0, 0)
AssetScroll.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
AssetScroll.ScrollBarThickness = 6
AssetScroll.Visible = false
AssetScroll.Parent = ContentContainer

local AssetListLayout = Instance.new("UIListLayout")
AssetListLayout.Parent = AssetScroll
AssetListLayout.SortOrder = Enum.SortOrder.LayoutOrder
AssetListLayout.Padding = UDim.new(0, 6)

AssetListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    AssetScroll.CanvasSize = UDim2.new(0, 0, 0, AssetListLayout.AbsoluteContentSize.Y + 10)
end)

-- Window Controls Logic
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 360, 0, 35)
    else
        MainFrame.Size = UDim2.new(0, 360, 0, 450)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Navigation Logic
BackBtn.MouseButton1Click:Connect(function()
    AssetScroll.Visible = false
    PlayerScroll.Visible = true
    BackBtn.Visible = false
    RefreshBtn.Visible = true
    Title.Text = "🧬 Deep Live Outfit Scanner"
end)

-- Function to create Asset Cards
local function createDetailedAssetCard(categoryName, assetId, rawPropertySource)
    local numericId = tonumber(assetId)
    if not numericId then return end

    local CardFrame = Instance.new("Frame")
    CardFrame.Size = UDim2.new(1, -5, 0, 105)
    CardFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    CardFrame.BorderSizePixel = 0
    CardFrame.Parent = AssetScroll

    local PreviewImg = Instance.new("ImageLabel")
    PreviewImg.Size = UDim2.new(0, 95, 0, 95)
    PreviewImg.Position = UDim2.new(0, 5, 0, 5)
    PreviewImg.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    PreviewImg.Image = "rbxthumb://type=Asset&id=" .. tostring(numericId) .. "&w=150&h=150"
    PreviewImg.Parent = CardFrame

    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Size = UDim2.new(1, -115, 0, 15)
    CategoryLabel.Position = UDim2.new(0, 110, 0, 6)
    CategoryLabel.Text = "[" .. categoryName:upper() .. "]"
    CategoryLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    CategoryLabel.Font = Enum.Font.SourceSansBold
    CategoryLabel.TextSize = 13
    CategoryLabel.TextXAlignment = Enum.TextXAlignment.Left
    CategoryLabel.BackgroundTransparency = 1
    CategoryLabel.Parent = CardFrame

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -115, 0, 18)
    NameLabel.Position = UDim2.new(0, 110, 0, 22)
    NameLabel.Text = "Querying item database..."
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.Font = Enum.Font.SourceSans
    NameLabel.TextSize = 14
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.BackgroundTransparency = 1
    NameLabel.Parent = CardFrame

    local CreatorLabel = Instance.new("TextLabel")
    CreatorLabel.Size = UDim2.new(1, -155, 0, 15)
    CreatorLabel.Position = UDim2.new(0, 110, 0, 42)
    CreatorLabel.Text = "Creator: Fetching..."
    CreatorLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
    CreatorLabel.Font = Enum.Font.SourceSansItalic
    CreatorLabel.TextSize = 12
    CreatorLabel.TextXAlignment = Enum.TextXAlignment.Left
    CreatorLabel.BackgroundTransparency = 1
    CreatorLabel.Parent = CardFrame

    -- Small creator icon (will be populated if we get a creator id)
    local CreatorIcon = Instance.new("ImageLabel")
    CreatorIcon.Size = UDim2.new(0, 28, 0, 28)
    CreatorIcon.Position = UDim2.new(1, -40, 0, 38)
    CreatorIcon.BackgroundTransparency = 1
    CreatorIcon.Parent = CardFrame

    local SourceLabel = Instance.new("TextLabel")
    SourceLabel.Size = UDim2.new(1, -115, 0, 15)
    SourceLabel.Position = UDim2.new(0, 110, 0, 58)
    SourceLabel.Text = "Source: " .. rawPropertySource
    SourceLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
    SourceLabel.Font = Enum.Font.Code
    SourceLabel.TextSize = 11
    SourceLabel.TextXAlignment = Enum.TextXAlignment.Left
    SourceLabel.BackgroundTransparency = 1
    SourceLabel.Parent = CardFrame

    local IdBox = Instance.new("TextBox")
    IdBox.Size = UDim2.new(1, -115, 0, 22)
    IdBox.Position = UDim2.new(0, 110, 0, 76)
    IdBox.Text = tostring(numericId)
    IdBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    IdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    IdBox.Font = Enum.Font.Code
    IdBox.TextSize = 12
    IdBox.ClearTextOnFocus = false
    IdBox.TextEditable = true
    IdBox.Parent = CardFrame

    task.spawn(function()
        local success, info = pcall(function()
            return MarketplaceService:GetProductInfo(numericId, Enum.InfoType.Asset)
        end)
        
        if not success or not info or info.Name == "" then
            pcall(function()
                local collection = InsertService:GetInboundExtensionIds(numericId)
                if collection and #collection > 0 then
                    local alternativeId = collection[1]
                    local altSuccess, altInfo = pcall(function()
                        return MarketplaceService:GetProductInfo(alternativeId, Enum.InfoType.Asset)
                    end)
                    if altSuccess and altInfo then info = altInfo success = true end
                end
            end)
        end

        if success and info then
            NameLabel.Text = info.Name ~= "" and info.Name or "Unnamed Asset Component"
            CreatorLabel.Text = "By: " .. (info.Creator and info.Creator.Name or "Roblox")
            -- Try to fetch creator's profile image if Creator.Id exists
            if info.Creator and info.Creator.Id and type(info.Creator.Id) == "number" then
                local ok, thumb = pcall(function()
                    return Players:GetUserThumbnailAsync(info.Creator.Id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                end)
                if ok and thumb then
                    CreatorIcon.Image = thumb
                end
            end
        else
            NameLabel.Text = "Layered Mesh Component"
            CreatorLabel.Text = "Creator: Engine Hidden"
        end
    end)
end

-- Scan Logic (Now accepts Player object directly)
local function deepScanPlayerOutfit(targetPlayer)
    -- Clear previous assets
    for _, child in pairs(AssetScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    -- Update UI state
    Title.Text = "🧬 Scanning: " .. targetPlayer.DisplayName
    PlayerScroll.Visible = false
    AssetScroll.Visible = true
    RefreshBtn.Visible = false
    BackBtn.Visible = true

    local liveChar = targetPlayer.Character or Workspace:FindFirstChild(targetPlayer.Name)
    if not liveChar then return end

    local humanoid = liveChar:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    -- === BIG IN-GAME VIEWPORT RENDER ===
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(1, -5, 0, 250)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    avatarFrame.BorderSizePixel = 1
    avatarFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
    avatarFrame.Parent = AssetScroll

    local bigViewport = Instance.new("ViewportFrame")
    bigViewport.Size = UDim2.new(1, 0, 1, 0)
    bigViewport.BackgroundTransparency = 1
    bigViewport.Parent = avatarFrame

    task.spawn(function()
        -- 1. Temporarily allow the character to be cloned
        local prevArchivable = liveChar.Archivable
        liveChar.Archivable = true
        local charClone = liveChar:Clone()
        liveChar.Archivable = prevArchivable

        if charClone then
            -- 2. Destroy scripts so they don't run in the UI, but KEEP the Humanoid so clothes render
            for _, v in pairs(charClone:GetDescendants()) do
                if v:IsA("Script") or v:IsA("LocalScript") then
                    v:Destroy()
                end
            end
            
            charClone.Parent = bigViewport
            local camera = Instance.new("Camera")
            camera.Parent = bigViewport
            
            local hrp = charClone:FindFirstChild("HumanoidRootPart") or charClone:FindFirstChild("Torso") or charClone:FindFirstChild("UpperTorso")
            if hrp then
                -- Position camera directly in front of the avatar looking back at them
                camera.CFrame = hrp.CFrame * CFrame.new(0, 0.5, -6) * CFrame.Angles(0, math.pi, 0)
                camera.Focus = hrp.CFrame
            end
            
            bigViewport.CurrentCamera = camera
        end
    end)
    -- ===================================

    local success, description = pcall(function()
        return humanoid:GetAppliedDescription()
    end)

    if not success or not description then return end

    -- Add a top "body info" card showing rig type and scales
    do
        local infoFrame = Instance.new("Frame")
        infoFrame.Size = UDim2.new(1, -5, 0, 80)
        infoFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        infoFrame.BorderSizePixel = 0
        infoFrame.Parent = AssetScroll

        local infoTitle = Instance.new("TextLabel")
        infoTitle.Size = UDim2.new(1, -10, 0, 20)
        infoTitle.Position = UDim2.new(0, 5, 0, 6)
        infoTitle.Text = "Avatar Info"
        infoTitle.BackgroundTransparency = 1
        infoTitle.TextColor3 = Color3.fromRGB(0, 255, 200)
        infoTitle.Font = Enum.Font.SourceSansBold
        infoTitle.TextSize = 14
        infoTitle.TextXAlignment = Enum.TextXAlignment.Left
        infoTitle.Parent = infoFrame

        local rigLabel = Instance.new("TextLabel")
        rigLabel.Size = UDim2.new(1, -10, 0, 16)
        rigLabel.Position = UDim2.new(0, 5, 0, 28)
        local rigText = "Rig: "
        pcall(function()
            rigText = rigText .. tostring(humanoid.RigType and tostring(humanoid.RigType):gsub("Enum.HumanoidRigType.", "") or "Unknown")
        end)
        rigLabel.Text = rigText
        rigLabel.BackgroundTransparency = 1
        rigLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        rigLabel.Font = Enum.Font.SourceSans
        rigLabel.TextSize = 12
        rigLabel.TextXAlignment = Enum.TextXAlignment.Left
        rigLabel.Parent = infoFrame

        -- show some scales from the HumanoidDescription if available
        local function safeGet(prop)
            local ok, val = pcall(function() return description[prop] end)
            if ok and val ~= nil then return val else return nil end
        end

        local headScale = safeGet("HeadScale")
        local heightScale = safeGet("HeightScale")
        local widthScale = safeGet("WidthScale")
        local bodyTypeScale = safeGet("BodyTypeScale")
        local proportionScale = safeGet("ProportionScale")

        local scalesText = "HeadScale: " .. tostring(headScale or "N/A")
                        .. "  HeightScale: " .. tostring(heightScale or "N/A")
                        .. "\nWidthScale: " .. tostring(widthScale or "N/A")
                        .. "  BodyTypeScale: " .. tostring(bodyTypeScale or "N/A")
                        .. "  ProportionScale: " .. tostring(proportionScale or "N/A")

        local scalesLabel = Instance.new("TextLabel")
        scalesLabel.Size = UDim2.new(1, -10, 0, 34)
        scalesLabel.Position = UDim2.new(0, 5, 0, 44)
        scalesLabel.Text = scalesText
        scalesLabel.BackgroundTransparency = 1
        scalesLabel.TextColor3 = Color3.fromRGB(190, 190, 200)
        scalesLabel.Font = Enum.Font.Code
        scalesLabel.TextSize = 12
        scalesLabel.TextXAlignment = Enum.TextXAlignment.Left
        scalesLabel.TextWrapped = true
        scalesLabel.Parent = infoFrame

        -- Build a structured outfit data table to show full description (JSON-like)
        local outfitData = {}
        local function getVal(prop)
            local ok, val = pcall(function() return description[prop] end)
            if not ok or val == nil then return nil end
            return val
        end

        local function colorToArray(c)
            if typeof(c) == "Color3" then
                return {c.R, c.G, c.B}
            end
            return c
        end

        outfitData.SwimAnimation = getVal("SwimAnimation")
        outfitData.SkinTone = colorToArray(getVal("SkinTone"))
        outfitData.Face = getVal("Face")
        outfitData.JumpAnimation = getVal("JumpAnimation")
        outfitData.ClimbAnimation = getVal("ClimbAnimation")
        outfitData.Shirt = getVal("Shirt")
        outfitData.Pants = getVal("Pants")
        outfitData.RightArm = getVal("RightArm")
        outfitData.WalkAnimation = getVal("WalkAnimation")
        outfitData.Head = getVal("Head")
        outfitData.WidthScale = widthScale
        outfitData.GraphicTShirt = getVal("GraphicTShirt")
        outfitData.Age = getVal("Age")
        outfitData.RunAnimation = getVal("RunAnimation")
        outfitData.FallAnimation = getVal("FallAnimation")
        outfitData.IdleAnimation = getVal("IdleAnimation")
        outfitData.Accessories = {}

        -- Accessories list
        pcall(function()
            local accs = description:GetAccessories(true)
            if accs and type(accs) == "table" then
                for _, a in pairs(accs) do
                    table.insert(outfitData.Accessories, {
                        AssetId = a.AssetId,
                        IsLayered = a.IsLayered,
                        AccessoryType = a.AccessoryType and tostring(a.AccessoryType):gsub("Enum.AccessoryType.", "") or a.AccessoryType
                    })
                end
            end
        end)

        outfitData.LeftArm = getVal("LeftArm")
        outfitData.RightLeg = getVal("RightLeg")
        outfitData.HeightScale = heightScale
        outfitData.Torso = getVal("Torso")
        outfitData.LeftLeg = getVal("LeftLeg")

        -- Encode to JSON-safe table: ensure no userdata remains (Color3 handled)
        local safeOutfit = {}
        for k, v in pairs(outfitData) do
            -- convert enums and userdata to strings or arrays
            if typeof(v) == "Instance" or typeof(v) == "EnumItem" then
                safeOutfit[k] = tostring(v)
            else
                safeOutfit[k] = v
            end
        end

        local ok, jsonText = pcall(function()
            return HttpService:JSONEncode(safeOutfit)
        end)

        -- Raw data display box with copy button
        local rawFrame = Instance.new("Frame")
        rawFrame.Size = UDim2.new(1, -5, 0, 160)
        rawFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        rawFrame.BorderSizePixel = 0
        rawFrame.Parent = AssetScroll

        local rawTitle = Instance.new("TextLabel")
        rawTitle.Size = UDim2.new(1, -10, 0, 18)
        rawTitle.Position = UDim2.new(0, 5, 0, 6)
        rawTitle.Text = "Raw Outfit Data"
        rawTitle.BackgroundTransparency = 1
        rawTitle.TextColor3 = Color3.fromRGB(0, 255, 200)
        rawTitle.Font = Enum.Font.SourceSansBold
        rawTitle.TextSize = 13
        rawTitle.TextXAlignment = Enum.TextXAlignment.Left
        rawTitle.Parent = rawFrame

        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(0, 50, 0, 18)
        copyBtn.Position = UDim2.new(1, -60, 0, 6)
        copyBtn.Text = "Copy"
        copyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.Font = Enum.Font.SourceSansBold
        copyBtn.TextSize = 11
        copyBtn.BorderSizePixel = 0
        copyBtn.Parent = rawFrame

        local rawBox = Instance.new("TextBox")
        rawBox.Size = UDim2.new(1, -10, 0, 130)
        rawBox.Position = UDim2.new(0, 5, 0, 26)
        rawBox.Text = ok and jsonText or "{}"
        rawBox.TextWrapped = true
        rawBox.TextXAlignment = Enum.TextXAlignment.Left
        rawBox.TextYAlignment = Enum.TextYAlignment.Top
        rawBox.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        rawBox.TextColor3 = Color3.fromRGB(220, 220, 220)
        rawBox.Font = Enum.Font.Code
        rawBox.TextSize = 11
        rawBox.ClearTextOnFocus = false
        rawBox.TextEditable = false
        rawBox.TextScaled = false
        rawBox.MultiLine = true
        rawBox.Parent = rawFrame

        -- Copy button functionality
        copyBtn.MouseButton1Click:Connect(function()
            setclipboard(rawBox.Text)
            copyBtn.Text = "Copied!"
            copyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            task.wait(2)
            copyBtn.Text = "Copy"
            copyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        end)

    end

    -- 1. Scan Classic 2D Clothing & Faces
    if description.Shirt ~= 0 then createDetailedAssetCard("Classic Shirt", description.Shirt, "HumanoidDesc.Shirt") end
    if description.Pants ~= 0 then createDetailedAssetCard("Classic Pants", description.Pants, "HumanoidDesc.Pants") end
    if description.GraphicTShirt ~= 0 then createDetailedAssetCard("T-Shirt Graphic", description.GraphicTShirt, "HumanoidDesc.GraphicTShirt") end
    if description.Face ~= 0 then createDetailedAssetCard("Face Texture", description.Face, "HumanoidDesc.Face") end

    -- 2. Scan Body Parts
    local bodyParts = {
        "Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"
    }
    for _, part in ipairs(bodyParts) do
        local partId = tonumber(description[part]) or 0
        if partId ~= 0 then
            createDetailedAssetCard("Body: " .. part, partId, "HumanoidDesc." .. part)
        end
    end

    -- 3. Scan Animations
    local animations = {
        "IdleAnimation", "RunAnimation", "WalkAnimation", "JumpAnimation",
        "ClimbAnimation", "FallAnimation", "SwimAnimation"
    }
    for _, anim in ipairs(animations) do
        local animId = tonumber(description[anim]) or 0
        if animId ~= 0 then
            createDetailedAssetCard("Anim: " .. anim:gsub("Animation", ""), animId, "HumanoidDesc." .. anim)
        end
    end

    -- 4. Scan 3D Accessories and Layered Clothing
    local accessories = description:GetAccessories(true)
    for _, acc in pairs(accessories) do
        local accType = tostring(acc.AccessoryType):gsub("Enum.AccessoryType.", "")
        local label = acc.IsLayered and ("Layered " .. accType) or accType
        createDetailedAssetCard(label, acc.AssetId, "HumanoidDesc." .. accType)
    end
end

-- Load All Users into Player List
local function populatePlayerList()
    -- Clear current list
    for _, child in pairs(PlayerScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, player in pairs(Players:GetPlayers()) do
        local PlayerBtn = Instance.new("TextButton")
        PlayerBtn.Size = UDim2.new(1, -5, 0, 50)
        PlayerBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
        PlayerBtn.BorderSizePixel = 0
        PlayerBtn.Text = ""
        PlayerBtn.Parent = PlayerScroll

        -- Use a ViewportFrame directly instead of ImageLabel so it actually renders the 3D model
        local SmallViewport = Instance.new("ViewportFrame")
        SmallViewport.Size = UDim2.new(0, 40, 0, 40)
        SmallViewport.Position = UDim2.new(0, 5, 0, 5)
        SmallViewport.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        SmallViewport.BorderSizePixel = 0
        SmallViewport.Parent = PlayerBtn

        task.spawn(function()
            local char = player.Character
            if char then
                -- Temporarily make Archivable true so we can clone it
                local oldArchivable = char.Archivable
                char.Archivable = true
                local headClone = char:Clone()
                char.Archivable = oldArchivable

                if headClone then
                    headClone.Parent = SmallViewport
                    local camera = Instance.new("Camera")
                    camera.Parent = SmallViewport
                    
                    local head = headClone:FindFirstChild("Head")
                    if head then
                        -- Position camera right in front of the face
                        camera.CFrame = head.CFrame * CFrame.new(0, 0, -2.5) * CFrame.Angles(0, math.pi, 0)
                        camera.Focus = head.CFrame
                    end
                    SmallViewport.CurrentCamera = camera
                end
            end
        end)

        local DisplayName = Instance.new("TextLabel")
        DisplayName.Size = UDim2.new(1, -60, 0, 20)
        DisplayName.Position = UDim2.new(0, 55, 0, 5)
        DisplayName.Text = player.DisplayName
        DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
        DisplayName.Font = Enum.Font.SourceSansBold
        DisplayName.TextSize = 16
        DisplayName.TextXAlignment = Enum.TextXAlignment.Left
        DisplayName.BackgroundTransparency = 1
        DisplayName.Parent = PlayerBtn

        local Username = Instance.new("TextLabel")
        Username.Size = UDim2.new(1, -60, 0, 20)
        Username.Position = UDim2.new(0, 55, 0, 25)
        Username.Text = "@" .. player.Name
        Username.TextColor3 = Color3.fromRGB(150, 150, 150)
        Username.Font = Enum.Font.SourceSans
        Username.TextSize = 14
        Username.TextXAlignment = Enum.TextXAlignment.Left
        Username.BackgroundTransparency = 1
        Username.Parent = PlayerBtn

        -- Click to scan
        PlayerBtn.MouseButton1Click:Connect(function()
            deepScanPlayerOutfit(player)
        end)
    end
end

-- Initialize
RefreshBtn.MouseButton1Click:Connect(populatePlayerList)
populatePlayerList()
