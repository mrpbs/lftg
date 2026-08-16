-- Ultimate Roblox Workspace Metadata Engine & Layered Clothing Scanner (Updated)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")

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
    CreatorLabel.Size = UDim2.new(1, -115, 0, 15)
    CreatorLabel.Position = UDim2.new(0, 110, 0, 42)
    CreatorLabel.Text = "Creator: Fetching..."
    CreatorLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
    CreatorLabel.Font = Enum.Font.SourceSansItalic
    CreatorLabel.TextSize = 12
    CreatorLabel.TextXAlignment = Enum.TextXAlignment.Left
    CreatorLabel.BackgroundTransparency = 1
    CreatorLabel.Parent = CardFrame

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

    local success, description = pcall(function()
        return humanoid:GetAppliedDescription()
    end)

    if not success or not description then return end

    -- 1. Scan Classic 2D Clothing & Faces
    if description.Shirt ~= 0 then createDetailedAssetCard("Classic Shirt", description.Shirt, "HumanoidDesc.Shirt") end
    if description.Pants ~= 0 then createDetailedAssetCard("Classic Pants", description.Pants, "HumanoidDesc.Pants") end
    if description.GraphicTShirt ~= 0 then createDetailedAssetCard("T-Shirt Graphic", description.GraphicTShirt, "HumanoidDesc.GraphicTShirt") end
    if description.Face ~= 0 then createDetailedAssetCard("Face Texture", description.Face, "HumanoidDesc.Face") end

    -- 2. Scan 3D Accessories and Layered Clothing
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

        local AvatarImg = Instance.new("ImageLabel")
        AvatarImg.Size = UDim2.new(0, 40, 0, 40)
        AvatarImg.Position = UDim2.new(0, 5, 0, 5)
        AvatarImg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
        AvatarImg.Parent = PlayerBtn

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
