loadstring([[
--[[
    Script MVSD Completo - Edición Venezuela 🇻🇪
    Compatible con Delta Executor
]]

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Config = {
    ESP = false, Hitbox = false, HitboxSize = 5, Aimbot = false,
    AutoGun = false, AutoKnife = false, GunCooldown = 0.15, KnifeCooldown = 0.35,
    KillAura = false, AutoGrabGun = false, AutoThrowKnife = false, TeamCheck = true,
    AutoFarm = false, AutoCollectCoins = false, AutoTeleportDuel = false, AutoWin = false,
    WalkSpeed = 16, JumpPower = 50, InfiniteJump = false, NoClip = false,
    Fly = false, FlySpeed = 50, Fullbright = false, XRay = false, AntiAFK = true,
}

local Window = Rayfield:CreateWindow({
    Name = "Script MVSD",
    LoadingTitle = "Script MVSD",
    LoadingSubtitle = "por un pana",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

local function esEnemigo(jugador)
    if jugador == LocalPlayer then return false end
    if not Config.TeamCheck then return true end
    if jugador.Team and LocalPlayer.Team then
        return jugador.Team ~= LocalPlayer.Team
    end
    return true
end

local function crearESP(jugador)
    if not esEnemigo(jugador) then return end
    local char = jugador.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local caja = Instance.new("BoxHandleAdornment")
    caja.Name = "ESP_" .. jugador.Name
    caja.Size = Vector3.new(3, 5, 3)
    caja.Adornee = hrp
    caja.AlwaysOnTop = true
    caja.ZIndex = 10
    caja.Transparency = 0.5
    caja.Color3 = Color3.fromRGB(255, 0, 0)
    caja.Parent = hrp
end

local function quitarESP(jugador)
    local char = jugador.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local viejo = hrp:FindFirstChild("ESP_" .. jugador.Name)
            if viejo then viejo:Destroy() end
        end
    end
end

local function aplicarHitbox(jugador)
    if not esEnemigo(jugador) then return end
    local char = jugador.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
        hrp.Transparency = 0.7
        hrp.BrickColor = BrickColor.new("Really red")
        hrp.Material = Enum.Material.Neon
        hrp.CanCollide = false
    end
end

local function resetearHitbox(jugador)
    local char = jugador.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Size = Vector3.new(2, 2, 1)
        hrp.Transparency = 1
        hrp.Material = Enum.Material.Plastic
    end
end

RunService.RenderStepped:Connect(function()
    if not Config.Aimbot then return end
    local miChar = LocalPlayer.Character
    if not miChar then return end
    local miHum = miChar:FindFirstChild("Humanoid")
    if not miHum or miHum.Health <= 0 then return end
    local miHRP = miChar:FindFirstChild("HumanoidRootPart")
    if not miHRP then return end
    local cam = workspace.CurrentCamera
    local masCercano, distMinima = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if not esEnemigo(plr) then continue end
        local char = plr.Character
        if not char then continue end
        local hum = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health <= 0 then continue end
        local dist = (hrp.Position - miHRP.Position).Magnitude
        if dist < distMinima then distMinima = dist; masCercano = hrp end
    end
    if masCercano then cam.CFrame = CFrame.new(cam.CFrame.Position, masCercano.Position) end
end)

local function obtenerHerramienta()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Tool")
end

task.spawn(function()
    while task.wait(0.05) do
        if not (Config.AutoGun or Config.AutoKnife) then continue end
        local tool = obtenerHerramienta()
        if not tool then continue end
        local nombre = tool.Name:lower()
        local esArma = nombre:find("gun") or nombre:find("revolver") or nombre:find("pistol") or nombre:find("sheriff")
        local esCuchillo = nombre:find("knife") or nombre:find("sword") or nombre:find("blade") or nombre:find("dagger")
        if Config.AutoGun and esArma then
            pcall(function() tool:Activate() end)
            task.wait(Config.GunCooldown)
        elseif Config.AutoKnife and esCuchillo then
            pcall(function() tool:Activate() end)
            task.wait(Config.KnifeCooldown)
        end
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if not Config.KillAura then continue end
        local miChar = LocalPlayer.Character
        if not miChar then continue end
        local miHRP = miChar:FindFirstChild("HumanoidRootPart")
        if not miHRP then continue end
        local tool = obtenerHerramienta()
        for _, plr in pairs(Players:GetPlayers()) do
            if not esEnemigo(plr) then continue end
            local char = plr.Character
            if not char then continue end
            local hum = char:FindFirstChild("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp or hum.Health <= 0 then continue end
            if (hrp.Position - miHRP.Position).Magnitude < 15 and tool then
                pcall(function() tool:Activate() end)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if not Config.AutoGrabGun then continue end
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and (obj.Name:lower():find("gun") or obj.Name:lower():find("revolver") or obj.Name:lower():find("pistol")) then
                if (obj.Position - hrp.Position).Magnitude < 50 then
                    pcall(function() obj.Parent = char end)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if not Config.AutoThrowKnife then continue end
        local tool = obtenerHerramienta()
        if tool and tool.Name:lower():find("knife") then
            pcall(function() tool:Activate() end)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if not Config.InfiniteJump then return end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    if not Config.NoClip then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end)

local flyConnection
local function activarFly()
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunService.RenderStepped:Connect(function()
        if not Config.Fly then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local cam = workspace.CurrentCamera
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        hrp.Velocity = dir * Config.FlySpeed
    end)
end

task.spawn(function()
    while task.wait(0.5) do
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if Config.WalkSpeed > 16 then hum.WalkSpeed = Config.WalkSpeed end
                if Config.JumpPower > 50 then hum.JumpPower = Config.JumpPower end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Config.Fullbright then
            game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 12
        else
            game.Lighting.Ambient = Color3.fromRGB(70, 70, 70)
            game.Lighting.Brightness = 1
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if Config.XRay then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Transparency ~= 1 then
                    obj.LocalTransparencyModifier = 0.5
                end
            end
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if not Config.AutoCollectCoins then continue end
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("gem") or obj.Name:lower():find("token")) then
                if (obj.Position - hrp.Position).Magnitude < 100 then
                    pcall(function()
                        firetouchinterest(hrp, obj, 0)
                        firetouchinterest(hrp, obj, 1)
                    end)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if not Config.AutoTeleportDuel then continue end
        for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if gui:IsA("TextButton") and (gui.Text:lower():find("duel") or gui.Text:lower():find("play") or gui.Text:lower():find("queue")) then
                pcall(function() gui:Activate() end)
                break
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if not Config.AutoWin then continue end
        local char = LocalPlayer.Character
        if not char then continue end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then continue end
        for _, plr in pairs(Players:GetPlayers()) do
            if not esEnemigo(plr) then continue end
            local target = plr.Character
            if not target then continue end
            local targetHum = target:FindFirstChild("Humanoid")
            local targetHRP = target:FindFirstChild("HumanoidRootPart")
            if targetHum and targetHRP and targetHum.Health > 0 then
                pcall(function()
                    targetHRP.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    tool:Activate()
                end)
            end
        end
    end
end)

local MainTab = Window:CreateTab("Combate", 4483362458)
MainTab:CreateSection("Funciones de Combate")
MainTab:CreateToggle({ Name = "ESP", CurrentValue = false, Flag = "ESP", Callback = function(v)
    Config.ESP = v
    if v then for _, p in pairs(Players:GetPlayers()) do if esEnemigo(p) and p.Character then crearESP(p) end end
    else for _, p in pairs(Players:GetPlayers()) do quitarESP(p) end end
end })
MainTab:CreateToggle({ Name = "Expandir Hitbox", CurrentValue = false, Flag = "Hitbox", Callback = function(v)
    Config.Hitbox = v
    if v then for _, p in pairs(Players:GetPlayers()) do aplicarHitbox(p) end
    else for _, p in pairs(Players:GetPlayers()) do resetearHitbox(p) end end
end })
MainTab:CreateSlider({ Name = "Tamaño del Hitbox", Range = {1, 20}, Increment = 1, Suffix = " studs", CurrentValue = 5, Flag = "HitboxSize", Callback = function(v)
    Config.HitboxSize = v
    if Config.Hitbox then for _, p in pairs(Players:GetPlayers()) do aplicarHitbox(p) end end
end })
MainTab:CreateToggle({ Name = "Aimbot", CurrentValue = false, Flag = "Aimbot", Callback = function(v) Config.Aimbot = v end })
MainTab:CreateToggle({ Name = "Auto Shoot (Arma)", CurrentValue = false, Flag = "AutoGun", Callback = function(v) Config.AutoGun = v end })
MainTab:CreateToggle({ Name = "Auto Shoot (Cuchillo)", CurrentValue = false, Flag = "AutoKnife", Callback = function(v) Config.AutoKnife = v end })
MainTab:CreateToggle({ Name = "Kill Aura", CurrentValue = false, Flag = "KillAura", Callback = function(v) Config.KillAura = v end })
MainTab:CreateToggle({ Name = "Auto Grab Gun", CurrentValue = false, Flag = "AutoGrabGun", Callback = function(v) Config.AutoGrabGun = v end })
MainTab:CreateToggle({ Name = "Auto Throw Knife", CurrentValue = false, Flag = "AutoThrowKnife", Callback = function(v) Config.AutoThrowKnife = v end })
MainTab:CreateToggle({ Name = "Team Check", CurrentValue = true, Flag = "TeamCheck", Callback = function(v) Config.TeamCheck = v end })

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
FarmTab:CreateSection("Farmeo")
FarmTab:CreateToggle({ Name = "Auto Recoger Monedas", CurrentValue = false, Flag = "AutoCollectCoins", Callback = function(v) Config.AutoCollectCoins = v end })
FarmTab:CreateToggle({ Name = "Auto Teleport a Duelo", CurrentValue = false, Flag = "AutoTeleportDuel", Callback = function(v) Config.AutoTeleportDuel = v end })
FarmTab:CreateToggle({ Name = "Auto Win (Mata a Todos)", CurrentValue = false, Flag = "AutoWin", Callback = function(v) Config.AutoWin = v end })

local MoveTab = Window:CreateTab("Movimiento", 4483362458)
MoveTab:CreateSection("Movimiento")
MoveTab:CreateSlider({ Name = "Velocidad", Range = {16, 200}, Increment = 1, Suffix = " studs/s", CurrentValue = 16, Flag = "WalkSpeed", Callback = function(v) Config.WalkSpeed = v end })
MoveTab:CreateSlider({ Name = "Salto", Range = {50, 300}, Increment = 1, Suffix = " power", CurrentValue = 50, Flag = "JumpPower", Callback = function(v) Config.JumpPower = v end })
MoveTab:CreateToggle({ Name = "Salto Infinito", CurrentValue = false, Flag = "InfiniteJump", Callback = function(v) Config.InfiniteJump = v end })
MoveTab:CreateToggle({ Name = "No Clip", CurrentValue = false, Flag = "NoClip", Callback = function(v) Config.NoClip = v end })
MoveTab:CreateToggle({ Name = "Volar (Fly)", CurrentValue = false, Flag = "Fly", Callback = function(v) Config.Fly = v; if v then activarFly() end end })
MoveTab:CreateSlider({ Name = "Velocidad de Vuelo", Range = {10, 200}, Increment = 1, Suffix = " studs/s", CurrentValue = 50, Flag = "FlySpeed", Callback = function(v) Config.FlySpeed = v end })

local VisualTab = Window:CreateTab("Visuales", 4483362458)
VisualTab:CreateSection("Visuales")
VisualTab:CreateToggle({ Name = "Fullbright", CurrentValue = false, Flag = "Fullbright", Callback = function(v) Config.Fullbright = v end })
VisualTab:CreateToggle({ Name = "XRay (Ver a Través)", CurrentValue = false, Flag = "XRay", Callback = function(v) Config.XRay = v end })

local UtilTab = Window:CreateTab("Utilidades", 4483362458)
UtilTab:CreateSection("Utilidades")
UtilTab:CreateToggle({ Name = "Anti-AFK", CurrentValue = true, Flag = "AntiAFK", Callback = function(v) Config.AntiAFK = v end })

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if Config.ESP then crearESP(plr) end
        if Config.Hitbox then aplicarHitbox(plr) end
    end)
end)

Rayfield:Notify({ Title = "Script MVSD", Content = "Cargado completo, pana 🇻🇪", Duration = 5 })
]])()
