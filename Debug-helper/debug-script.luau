local Main = {}

function Main:CurrentTime()
    return DateTime.now():FormatLocalTime("ss-mm-HH-d-MM-YYYY", "en-us")
end

function Main:RBX_Signal_Disable(RBXScriptSignal)
    -- WARNING : Disables ALL connections on the part TEMPORARILY.

    local Connections = getconnections(RBXScriptSignal)
    local Reenable = setmetatable({},{
        __call = function()
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

function Main:ChangeSignalStop(Object)
    -- WARNING : Disables Changed and discovered GetPropertyChangedSignal connections temporarily.
    -- NOTE : Does NOT disable attribute changes.
    local Changed = self:RBX_Signal_Disable(Object.Changed)
    local GetPropertyChangedSignals = {}

    for Property, Value in getproperties(Object) do
       pcall(function()  GetPropertyChangedSignals[Property] = self:RBX_Signal_Disable(Object:GetPropertyChangedSignal(Property)) end)
    end

    local Reenable = setmetatable({},{
        __call = function()
            Changed()
            
            for Property, RBXScriptSignal in GetPropertyChangedSignals do
                RBXScriptSignal()
            end
        end
    })

    return Reenable
end

function Main:SortAndLogFunctions()
    -- Sorts all functions found by filtergc
    local CurrentMillis = DateTime.now().UnixTimestampMillis
    local NameOfFile = `FUNCTION-LOG-{self:CurrentTime()}.txt`
    writefile(NameOfFile, "-- START OF LOG --")
    local SemiSortedFunctions = filtergc("function", {
        IgnoreExecutor = true,
    })

    for IndexNumber, Function in SemiSortedFunctions do
        local Debug_Info = debug.getinfo(Function)

        local ConcattedUpvalues, ConcattedConstants = debug.getupvalues(Function), debug.getconstants(Function)

        local function Concatter(Target)
            local Concatted = ""

            for Item1, Item2 in Target do
                Concatted = Concatted..`| {Item1} : {Item2} |`
            end

            return Concatted
        end

        ConcattedConstants, ConcattedUpvalues = Concatter(ConcattedConstants), Concatter(ConcattedUpvalues)

        local FunctionData = `\n{IndexNumber} : {Debug_Info.name}\nFull source : {Debug_Info.source:sub(2, #Debug_Info.source)}\nUpvalues : {ConcattedUpvalues}\nConstants : {ConcattedConstants}`

        appendfile(NameOfFile, FunctionData)
    end

    appendfile(NameOfFile, `-- END OF LOG --\nElapsed time : {DateTime.now().UnixTimestampMillis - CurrentMillis}ms`)
    
end

function Main:LogLoadedModules()
    -- Logs all required module and their env
    local CurrentMillis = DateTime.now().UnixTimestampMillis
    local NameOfFile = `MODULE-LOG-{self:CurrentTime()}.txt`
    writefile(NameOfFile, "-- START OF LOG --")

    for indx, module in pairs(getloadedmodules()) do
        appendfile(NameOfFile, `\n{indx} : {module:GetFullName()}\nsenv: {getsenv(module)}`)
    end

    appendfile(NameOfFile, `\n-- END OF LOG --\nElapsed time : {DateTime.now().UnixTimestampMillis - CurrentMillis}ms`)
end

function Main:FunctionDepthCheck(FUNCTION)
    local DB_INFO = debug.getinfo(FUNCTION)

    local Ups, Constants = debug.getupvalues(FUNCTION), debug.getconstants(FUNCTION)
    local F_Name, F_Source, F_Line = DB_INFO.name, DB_INFO.source, DB_INFO.currentline

    local function deepTree(obj, depth, visited)
        depth = depth or 0
        visited = visited or {}

        local function fmt(x)
            if type(x) == "string" then
                return '"' .. x .. '"'
            elseif type(x) == "function" then
                local info = debug.getinfo(x)
                return "function " .. (info.name or "[anonymous]")
            end

            return tostring(x)
        end

        if type(obj) ~= "table" then
            return string.rep(" - ", depth) .. fmt(obj)
        end

        if visited[obj] then
            return string.rep(" - ", depth) .. "[circular]"
        end

        visited[obj] = true

        local lines = {}

        for k, v in obj do
            local prefix = string.rep(" - ", depth)

            if type(v) == "table" then
                table.insert(lines, prefix .. fmt(k) .. " :")
                table.insert(lines, deepTree(v, depth + 1, visited))
            else
                table.insert(lines, prefix .. fmt(k) .. " : " .. fmt(v))
            end
        end

        return table.concat(lines, "\n")
    end

    local dat = `\n\nUP VALUES : {deepTree(Ups)}\n\nCONSTANTS : {deepTree(Constants)}`
    return dat
end

--[[ // Genuinely doesn't work rn, maybe fix later.
function Main:DEPTH_LogFunctions(Batch, Cooloff)
    -- WARNING: 
    local batchd=0
    local current = DateTime.now().UnixTimestampMillis
    local filename = `DEPTH-CHECK-{self:CurrentTime()}.txt`
    writefile(filename, "START OF DEPTH LOG")
    for item, item2 in filtergc("function", {IgnoreExecutor = true}) do
        local dat = self:FunctionDepthCheck(item2)
        appendfile(filename, dat)
        batchd += 1

        if batchd >= 50 then
            task.wait(Cooloff)
            batchd = 0
        end
    end
    appendfile(filename, `\nEND OF DEPTH LOG\nTOOK {DateTime.now().UnixTimestampMillis - current}`)
end

Main:DEPTH_LogFunctions(3, 0.5)
]]

return Main
