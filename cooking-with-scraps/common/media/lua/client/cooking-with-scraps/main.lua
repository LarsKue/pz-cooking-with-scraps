
local InventoryUI = require("Starlit/client/ui/InventoryUI")
local Utils = require("cooking-with-scraps/utils")


local function main()
    print("===== Cooking With Scraps =====")
    local recipes = getEvolvedRecipes()

    for i = 0, recipes:size() - 1 do
        local recipe = recipes:get(i)
        local field = Utils.getField(recipe, "maxItems")
        if field then
            field:setAccessible(true)
            field:setInt(recipe, 9999)
        end
    end

    print("===============================")
end

main()
