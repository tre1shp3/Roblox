local MainHooker = {}
local oldindex, oldnewindex, mt, oldInfo
local readspoofs = {}
local hookstuff = {}
local realhookvalues = {}

local Disabler = loadstring(game:HttpGet("https://raw.githubusercontent.com/tre1shp3/Roblox/refs/heads/main/Debug-helper/debug-script.luau"))()

local function newindexhook(obj, prop, val)
    if hookstuff[obj] and hookstuff[obj][prop] ~= nil then
        local ok, err = pcall(oldindex, obj, prop)
        if not ok then
            error(err, 2)
        end
        hookstuff[obj][prop] = val
        return
    end

    oldnewindex(obj, prop, val)
end

local function indexhook(obj, prop)
    if readspoofs[obj] and readspoofs[obj][prop] ~= nil then
        return readspoofs[obj][prop]
    end
    
    if hookstuff[obj] and hookstuff[obj][prop] ~= nil then
        return hookstuff[obj][prop]
    end

    return oldindex(obj, prop)
end

function MainHooker:InitializeHooks()
    if getgenv().ishookinit then return false, "Failed to initialize. Already initialized!!" end
    getgenv().ishookinit = true
    mt = getrawmetatable(game)
    setreadonly(mt, false)
    oldindex = mt.__index 
    oldnewindex = mt.__newindex
    oldInfo = debug.info

    setstackhidden(newindexhook, true)
    setstackhidden(indexhook, true)

    setreadonly(debug, false)

    debug.info = function(level, what)
        if not what then
            return oldInfo(level)
        end

        if not string.find(what, "f") then
            return oldInfo(level, what)
        end

        local results = {oldInfo(level, what)}

        local fIndex = string.find(what, "f")
        if fIndex then
            local f = results[fIndex]

            if f == newindexhook then
                results[fIndex] = oldnewindex
            elseif f == indexhook then
                results[fIndex] = oldindex
            end
        end

        return unpack(results)
    end

    setreadonly(debug, true)

    mt.__index = newcclosure(indexhook)
    mt.__newindex = newcclosure(newindexhook)

    setreadonly(mt, true)

    for obj, props in hookstuff do
        for prop in props do
            local currentVal = oldindex(obj, prop) -- read real value while hooks are off
            hookstuff[obj][prop] = currentVal
            self:ChangeObjectValue(obj, prop, currentVal)
        end
    end

    return true, "Successfully initialized hooks globally."
end

function MainHooker:RemoveHooks()
    if not getgenv().ishookinit then return false, "Hooks aren't initialized yet!!" end
    setreadonly(mt, false)
    setreadonly(debug, false)
    mt.__index = oldindex
    mt.__newindex = oldnewindex
    debug.info = oldInfo
    setreadonly(mt, true)
    setreadonly(debug, true)
    getgenv().ishookinit = false
    return true, "Successfully removed hooks globally."
end

function MainHooker:ChangeObjectValue(Object, Property, Value)
    if not getgenv().ishookinit then return end
    if not hookstuff[Object] or hookstuff[Object][Property] == nil then
        return false, "Property is not hooked."
    end

    local First = Disabler:RBX_Signal_Disable(Object.Changed)
    local Second = Disabler:RBX_Signal_Disable(Object:GetPropertyChangedSignal(Property))

    if realhookvalues[Object] then
        realhookvalues[Object][Property] = Value
    else
        realhookvalues[Object] = {}
        realhookvalues[Object][Property] = Value
    end

    oldnewindex(Object, Property, Value)

    First()
    Second()
end

function MainHooker:SpoofRead(Object, Property, Value)
    if not getgenv().ishookinit then return end

    if not readspoofs[Object] then readspoofs[Object] = {} end

    readspoofs[Object][Property] = Value
end

function MainHooker:UnspoofRead(Object, Property)
    if not getgenv().ishookinit then return end
    if readspoofs[Object] and readspoofs[Object][Property] ~= nil then   
        readspoofs[Object][Property] = nil

        if next(readspoofs[Object]) == nil then
            readspoofs[Object] = nil
        end
    else
        return
    end
end

function MainHooker:IsReadSpoofed(Object, Property)
    return (readspoofs[Object] and readspoofs[Object][Property] ~= nil)
end

function MainHooker:RemoveSingular(Object, Property)
    if not getgenv().ishookinit then return end
    if realhookvalues[Object] then
        realhookvalues[Object][Property] = nil

        if next(realhookvalues[Object]) == nil then
            realhookvalues[Object] = nil
        end
    end

    if hookstuff[Object] then
        hookstuff[Object][Property] = nil

        if next(hookstuff[Object]) == nil then
            hookstuff[Object] = nil
        end
    end
end

function MainHooker:IsHooked(Object, Property)
    if not getgenv().ishookinit then return false end
    if hookstuff[Object] and hookstuff[Object][Property] ~= nil then
        return true
    else
        return false
    end
end

function MainHooker:Hook(Object, Property)
    if not getgenv().ishookinit then return end
    if hookstuff[Object] then
        hookstuff[Object][Property] = Object[Property]
    else
        hookstuff[Object] = {}
        hookstuff[Object][Property] = Object[Property]
    end

    self:ChangeObjectValue(Object, Property, Object[Property])
end

function MainHooker:RealValue(Object, Property)
    if realhookvalues[Object] and realhookvalues[Object][Property] ~= nil then
        return realhookvalues[Object][Property]
    else
        return false
    end
end

return MainHooker
