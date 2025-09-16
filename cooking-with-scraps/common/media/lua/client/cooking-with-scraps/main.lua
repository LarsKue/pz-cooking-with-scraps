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

local function main()
    print("===== Cooking With Scraps =====")
    local recipes = getEvolvedRecipes()

    for i = 0, recipes:size() - 1 do
        local recipe = recipes:get(i)
        local field = getField(recipe, "maxItems")
        if field then
            field:setAccessible(true)
            field:setInt(recipe, 9999)
        end
    end

    print("===============================")
end

main()
