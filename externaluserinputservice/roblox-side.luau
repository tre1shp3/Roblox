if getgenv().external_user_input_service_connected then return external_user_input_service end

local UserInputService = game:GetService("UserInputService")

local ws = websocket.connect("ws://localhost:8765")
local ex_uis = {}

getgenv().external_user_input_service_connected = true

ex_uis.InputStart = VoltSignal.new()
ex_uis.InputEnded = VoltSignal.new()
function ex_uis:DisconnectFromSocket()
    getgenv().external_user_input_service_connected = false
    ws:Disconnect()
end

local tabbed_in = true

UserInputService.WindowFocused:Connect(function()
    tabbed_in = true
end)

UserInputService.WindowFocusReleased:Connect(function()
    tabbed_in = false
end)

ws.OnMessage:Connect(function(json_encoded)
    local decoded = game:GetService('HttpService'):JSONDecode(json_encoded)
    
    for _, k in decoded do
        local key_name = k[1]
        local key_state = k[2] == 1 and "down" or "up"

        if key_state == "down" then
            ex_uis.InputStart:Fire(key_name, tabbed_in)
        else
            ex_uis.InputEnded:Fire(key_name, tabbed_in)
        end
    end
end)

getgenv().external_user_input_service = ex_uis

return ex_uis
