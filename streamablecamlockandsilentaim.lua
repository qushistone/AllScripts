-- note from qushi: the following is to make it so it doesnt kick you to join a roblox group.
-- id remove it but the camlock script wasnt made by ChaseSYNX and it was made by tenaki

local niggy = getrawmetatable(game)
setreadonly(niggy , false)
local niggy2  = niggy .__namecall
niggy .__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "IsInGroup" then
        return true
    end
    return niggy2(self, ...)
end)
setreadonly(niggy, true)

getgenv().RecurringPoint = "UpperTorso"
getgenv().Hitbox = "UpperTorso"
getgenv().Keybind = "q" -- lock keybind
getgenv().AimbotStrengthAmount = 0.0421
getgenv().PredictionAmount = 11
getgenv().Radius = 25
getgenv().UsePrediction = true
getgenv().AimbotStrength = true
getgenv().FirstPerson = true
getgenv().ThirdPerson = true
getgenv().TeamCheck = false
getgenv().Enabled = true


-- main script use with silent aim

loadstring(game:HttpGet("https://raw.githubusercontent.com/ChaseSYNX/Scripts/main/Streamable-Camlock"))()

                               local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/qushistone/camlockaiminghandler/main/aiming.lua", true))()
                            Aiming.TeamCheck(false)
                             
                            
                            local Workspace = game:GetService("Workspace")
                            local Players = game:GetService("Players")
                            local RunService = game:GetService("RunService")
                            local UserInputService = game:GetService("UserInputService")
                            
                            
                            local LocalPlayer = Players.LocalPlayer
                            local Mouse = LocalPlayer:GetMouse()
                            local CurrentCamera = Workspace.CurrentCamera
                            
                            local DaHoodSettings = {
                                SilentAim = true,
                                AimLock = false,
                                Prediction = 0.14,
                                AimLockKeybind = Enum.KeyCode.Z
                            }
                            getgenv().DaHoodSettings = DaHoodSettings
                            
                            
                            function Aiming.Check()
                            -------------
                                if not (Aiming.Enabled == true and Aiming.Selected ~= LocalPlayer and Aiming.SelectedPart ~= nil) then
                                    return false
                                end
                            
                                -- // Check if downed
                                local Character = Aiming.Character(Aiming.Selected)
                                local KOd = Character:WaitForChild("BodyEffects")["K.O"].Value
                                local Grabbed = Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                            
                                -- // Check B
                                if (KOd or Grabbed) then
                                    return false
                                end
                            
                                -- //
                                return true
                            end
                            
                            -- // Hook
                            local __index
                            __index = hookmetamethod(game, "__index", function(t, k)
                                -- // Check if it trying to get our mouse's hit or target and see if we can use it
                                if (t:IsA("Mouse") and (k == "Hit" or k == "Target") and Aiming.Check()) then
                                    local SelectedPart = Aiming.SelectedPart
                            
                                    -- // Hit/Target
                                    if (DaHoodSettings.SilentAim and (k == "Hit" or k == "Target")) then
                                        -- // Hit to account prediction
                                        local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)
                            
                                        -- // Return modded val
                                        return (k == "Hit" and Hit or SelectedPart)
                                    end
                                end
                            
                                -- // Return
                                return __index(t, k)
                            end)
                            
                            -- // Aimlock
                            RunService:BindToRenderStep("AimLock", 0, function()
                                if (DaHoodSettings.AimLock and Aiming.Check() and UserInputService:IsKeyDown(DaHoodSettings.AimLockKeybind)) then
                                    -- // Vars
                                    local SelectedPart = Aiming.SelectedPart
                            
                                    -- // Hit to account prediction
                                    local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)
                            
                                    CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, Hit.Position)
                                end
                                end)
