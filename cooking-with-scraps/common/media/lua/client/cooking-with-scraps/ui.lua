-- Require the InventoryUI module so we can use it.
local InventoryUI = require("Starlit/client/ui/InventoryUI")
local Utils = require("cooking-with-scraps/utils")


local itemCapacities = {
    ["Pancakes"] = 0.3,
    ["Pot"] = 1.5,
    ["Pan"] = 1.5,
    ["Bucket"] = 10,
    ["HotDrink"] = 0.5,
    ["Sandwich"] = 0.5,
    ["BaguetteSandwich"] = 1,
    ["Burger"] = 1,
    ["Pie"] = 1.5,
    ["Cake"] = 1.5,
    ["Salad"] = 1.5,
    ["Taco"] = 0.5,
    ["Burrito"] = 1,
    ["Waffles"] = 0.3,
    ["Omelette"] = 0.6,
    ["Muffin"] = 0.2,
    ["Cone"] = 0.2,
    ["Bread"] = 0.3,
    ["Beverage"] = 0.5,
    ["Toast"] = 0.2,
    ["Oatmeal"] = 0.5,
    ["Beer"] = 1,
    ["Wine"] = 1,
    ["Pizza"] = 1,
    ["Bagel"] = 0.5,
    ["Hotdog"] = 0.5,
}


local function getBaseItemType(itemType)
    local recipes = getEvolvedRecipes()
    local baseItem = nil

    -- Find the corresponding base item for the item type
    for i = 0, recipes:size() - 1 do
        local recipe = recipes:get(i)
        local resultItemField = Utils.getField(recipe, "resultItem")

        local resultItem = resultItemField:get(recipe)
        if resultItem == itemType then
            local baseItemfield = Utils.getField(recipe, "baseItem")
            baseItem = baseItemfield:get(recipe)
            break
        end
    end

    return baseItem
end


-- Create the event listener.
-- If your IDE supports LuaCATS annotations, the following line tells it the function is an event listener.
-- @type Starlit.InventoryUI.Callback_OnFillItemTooltip
local function addCookingTooltip(tooltip, layout, item)
    --InventoryUI.addTooltipKeyValue(layout, "Class", tostring(item:getClass()))

    local itemType = item:getType()
    local itemHandle = nil

    -- Check if the itemType contains any of the keys in the itemWeights table
    for key, value in pairs(itemCapacities) do
        if string.find(itemType, key) then
            itemHandle = key
            break
        end
    end

    -- Check if the item is in the itemWeights table
    if not itemHandle then
        return
    end

    -- Get the base item type
    local baseItemType = getBaseItemType(itemType)
    if not baseItemType then
        return
    end

    -- Get base item from type
    local sm = getScriptManager()
    local baseItem = sm:FindItem(("Base." .. baseItemType)) -- Script item (ItemScript)

    -- Get the base weight of the item
    local baseItemWeight = baseItem:getActualWeight()
    -- If the base item is edible, the base weight is 0, because all of the item will be eaten
    if baseItem:getDaysFresh() < 1000000 then
        baseItemWeight = 0
    end

    -- Get the water weight from the item type
    local cookableItem = sm:FindItem(("Base." .. itemType))
    -- Get the full weight of the item
    local cookableItemWeight = cookableItem:getActualWeight()
    if baseItem:getDaysFresh() < 1000000 then
        cookableItemWeight = 0
    end

    -- Calculate the water weight of the item
    local cookableItemWaterWeight = cookableItemWeight - baseItemWeight

    -- Get the stats of the item
    local itemBaseWeight = baseItemWeight
    local itemWaterWeight = cookableItemWaterWeight
    local itemCapacity = itemCapacities[itemHandle]

    -- Adds the key-value pair "Grown at: Sweet Apple Acres" to every apple's tooltip.
    local weight = item:getActualWeight()
    local remaining = item:getHungChange() / item:getBaseHunger()

    local eatenPercent = 1 - remaining
    local waterWeight = (1 - eatenPercent) * itemWaterWeight
    local totalBaseWeight = itemBaseWeight + waterWeight

    --InventoryUI.addTooltipKeyValue(layout, "Spices", tostring(item:getSpices()))
    --InventoryUI.addTooltipKeyValue(layout, "Weight", tostring(Utils.round(item:getWeight(), 2)))
    --InventoryUI.addTooltipKeyValue(layout, "Actual Weight", tostring( Utils.round(item:getActualWeight(), 2) ))
    --InventoryUI.addTooltipKeyValue(layout, "Thirst Change Unmodified", tostring(item:getThirstChangeUnmodified()))
    --InventoryUI.addTooltipKeyValue(layout, "Eaten Percent", tostring(eatenPercent * 100) .. "%")
    --InventoryUI.addTooltipKeyValue(layout, "Water Weight", tostring(waterWeight))
    --InventoryUI.addTooltipKeyValue(layout, "Empty Weight", tostring(emptyWeight))
    --InventoryUI.addTooltipKeyValue(layout, "Total Base Weight", tostring(totalBaseWeight))
    --InventoryUI.addTooltipKeyValue(layout, "BaseHunger", tostring(item:getBaseHunger()))
    --InventoryUI.addTooltipKeyValue(layout, "Hung Change", tostring(item:getHungChange()))
    --InventoryUI.addTooltipKeyValue(layout, "Hunger Change", tostring(item:getHungerChange()))

    InventoryUI.addTooltipLabel(layout, "-----------------------------------------------------------")

    weight = weight - totalBaseWeight
    weight = Utils.round(weight, 2)
    InventoryUI.addTooltipKeyValue(layout, "Ingredient Capacity:", weight .. "/" .. itemCapacity)
    if weight >= itemCapacity then
        InventoryUI.addTooltipKeyValue(layout, "Ingredient Capacity:", "FULL", nil, nil) -- Colour.getRGBA(table.newarray(1, 1, 1, 1))
    else
        InventoryUI.addTooltipBar(layout, "Ingredient Capacity:", weight / itemCapacity)
    end

    InventoryUI.addTooltipKeyValue(layout, "Remaining:", tostring(round(remaining * 100)) .. "%")

end

-- Adds the event listener to the event, so that it will be called when the event is triggered.
InventoryUI.onFillItemTooltip:addListener(addCookingTooltip)
