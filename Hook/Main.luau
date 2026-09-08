local MainHooker = {}
local oldindex, oldnewindex, mt, oldInfo
local readspoofs = {}
local hookstuff = {}
local realhookvalues = {}
local indexhook, newindexhook

if getgenv().Hooking_Library then
    return getgenv().Hooking_Library
end

function RBX_Signal_Disable(RBXScriptSignal)
    -- ported from disabler to avoid double loadstring

    local Connections = getconnections(RBXScriptSignal)
    local Reenable = setmetatable({},{
        __call = function(self)
            for _, Item in Connections do
                Item:Enable()
            end
        end
    })

    for _, Item in Connections do
        Item:Disable()
    end

    return Reenable
end

indexhook = function(...)
    local n = select("#", ...)
    if n == 2 then
        local obj, prop = ...
        if type(obj) == "userdata" and type(prop) == "string" then
            if readspoofs[obj] and readspoofs[obj][prop] ~= nil then
                return readspoofs[obj][prop]
            end
            if hookstuff[obj] and hookstuff[obj][prop] ~= nil then
                return hookstuff[obj][prop]
            end
        end
    end
    return oldindex(...)
end

newindexhook = function(...)
    local n = select("#", ...)
    if n == 3 then
        local obj, prop, val = ...
        if type(obj) == "userdata" and type(prop) == "string" then
            if hookstuff[obj] and hookstuff[obj][prop] ~= nil then
                hookstuff[obj][prop] = val
                return
            end
        end
    end
    return oldnewindex(...)
end

function MainHooker:InitializeHooks()
    if getgenv().ishookinit then return false, "Failed to initialize. Already initialized!!" end
    getgenv().ishookinit = true
    mt = getrawmetatable(game)
    setreadonly(mt, false)
    oldindex = mt.__index
    oldnewindex = mt.__newindex

    setstackhidden(indexhook, true)
    setstackhidden(newindexhook, true)

    mt.__index = indexhook
    mt.__newindex = newindexhook
    setreadonly(mt, true)

    for obj, props in hookstuff do
        for prop in props do
            local currentVal = oldindex(obj, prop)
            hookstuff[obj][prop] = currentVal
            self:ChangeObjectValue(obj, prop, currentVal)
        end
    end

    return true, "Successfully initialized hooks globally."
end

function MainHooker:RemoveHooks()
    if not getgenv().ishookinit then return false, "Hooks aren't initialized yet!!" end
    mt = getrawmetatable(game)
    setreadonly(mt, false)
    mt.__index = oldindex
    mt.__newindex = oldnewindex
    setreadonly(mt, true)
    getgenv().ishookinit = false
    return true, "Successfully removed hooks globally."
end

function MainHooker:ChangeObjectValue(Object, Property, Value)
    if not getgenv().ishookinit then return end
    if not hookstuff[Object] or hookstuff[Object][Property] == nil then
        return false, "Property is not hooked."
    end
    local First = RBX_Signal_Disable(Object.Changed)
    local Second = RBX_Signal_Disable(Object:GetPropertyChangedSignal(Property))
    if realhookvalues[Object] then
        realhookvalues[Object][Property] = Value
    else
        realhookvalues[Object] = {[Property] = Value}
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
        if next(readspoofs[Object]) == nil then readspoofs[Object] = nil end
    end
end

function MainHooker:IsReadSpoofed(Object, Property)
    return (readspoofs[Object] and readspoofs[Object][Property] ~= nil) and true or false
end

function MainHooker:RemoveSingular(Object, Property)
    if not getgenv().ishookinit then return end
    if realhookvalues[Object] then
        realhookvalues[Object][Property] = nil
        if next(realhookvalues[Object]) == nil then realhookvalues[Object] = nil end
    end
    if hookstuff[Object] then
        hookstuff[Object][Property] = nil
        if next(hookstuff[Object]) == nil then hookstuff[Object] = nil end
    end
end

function MainHooker:IsHooked(Object, Property)
    if not getgenv().ishookinit then return false end
    return (hookstuff[Object] and hookstuff[Object][Property] ~= nil) and true or false
end

function MainHooker:Hook(Object, Property)
    if not getgenv().ishookinit then return end
    if hookstuff[Object] then
        hookstuff[Object][Property] = Object[Property]
    else
        hookstuff[Object] = {[Property] = Object[Property]}
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

getgenv().Hooking_Library = MainHooker

return MainHooker
