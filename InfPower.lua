local MaxPwr = math.huge
local HwrLength = game.Workspace.GameSettings.Settings.HourLength.Value

local Power = Instance.new("IntValue")
Power.Name = "Power"
Power.Value = MaxPwr
Power.Parent = game.Workspace.GameSettings.MainSystem

local Power_usage = Instance.new("IntValue")
Power_usage.Name = "Power_usage"
Power_usage.Value = 1
Power_usage.Parent = game.Workspace.GameSettings.MainSystem

local PwrRun = false
local RoundOver = false

function Pwr_start()
    local Power_run = coroutine.wrap(function()
        local PwrOutAttempt = 0    

        game.Workspace.GameSettings.MainSystem.PwrUsage.Value = 1
        
        while not RoundOver do
            if PwrRun then
                local DrainTime = (8 - ((Power_usage.Value * 1.25)))
                wait(DrainTime)
            end
            wait()
        end
        
        while Power.Value < 1 do        
            if PwrOutAttempt > 0 then
                PwrOutAttempt = PwrOutAttempt + 1

                for _, i in pairs(game.ReplicatedStorage.KeyBindEvent:GetChildren()) do
                    if string.find(i.Name, "LightOff") then
                        i:FireAllClients()
                    end
                end    

                remotes.OpenDoors:Fire()
                Power_usage.Value = 1 
            end
            wait()
        end
    end)
    Power_run()
end

remotes.GameStart.OnServerEvent:Connect(function()
    Power.Value = MaxPwr
    Pwr_start()
    task.wait()
    PwrRun = true    
end)
