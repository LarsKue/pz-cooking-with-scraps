
local function getField(instance, name)
    local offset = string.len(name)
    for i = 0, getNumClassFields(instance) - 1 do
        local field = getClassField(instance, i)
        if string.sub(tostring(field), -offset) == name then
            return field
        end
    end
    return nil
end


local function round(num, precision)
    local mult = 10 ^ (precision or 0)
    return math.floor(num * mult + 0.5) / mult
end


----------------------------------------------------------
-- Make the functions publicly accessible
local Utils = {
    getField = getField,
    round = round,
}
return Utils