-- Require the InventoryUI module so we can use it.
local InventoryUI = require("Starlit/client/ui/InventoryUI")
local Colour = require("Starlit/utils/Colour")

local itemWeights = {
    ["PotOf"] = 1,
    ["PanFriedVegetables"] = 1.5,
    ["Sandwich"] = 0,
}
local itemWaterWeights = {
    ["PotOf"] = 2,
    ["PanFriedVegetables"] = 0,
    ["Sandwich"] = 0,
}
local itemCapacities = {
    ["PotOf"] = 1.5,
    ["PanFriedVegetables"] = 1.5,
    ["Sandwich"] = 1,
}


function round(num, precision)
    local mult = 10 ^ (precision or 0)
    return math.floor(num * mult + 0.5) / mult
end


-- Create the event listener.
-- If your IDE supports LuaCATS annotations, the following line tells it the function is an event listener.
-- @type Starlit.InventoryUI.Callback_OnFillItemTooltip
local function addAppleTooltip(tooltip, layout, item)
    --InventoryUI.addTooltipKeyValue(layout, "Class", tostring(item:getClass()))

    local itemType = item:getFullType()
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

    -- Get the stats of the item
    local itemBaseWeight = itemWeights[itemHandle]
    local itemWaterWeight = itemWaterWeights[itemHandle]
    local itemCapacity = itemCapacities[itemHandle]

    -- Adds the key-value pair "Grown at: Sweet Apple Acres" to every apple's tooltip.
    local weight = item:getActualWeight()
    local remaining = item:getHungChange() / item:getBaseHunger()

    local eatenPercent = 1 - remaining
    local waterWeight = (1 - eatenPercent) * itemWaterWeight
    local totalBaseWeight = itemBaseWeight + waterWeight

    --InventoryUI.addTooltipKeyValue(layout, "Spices", tostring(item:getSpices()))
    --InventoryUI.addTooltipKeyValue(layout, "Weight", tostring(round(item:getWeight(), 2)))
    --InventoryUI.addTooltipKeyValue(layout, "Actual Weight", tostring( round(item:getActualWeight(), 2) ))
    --InventoryUI.addTooltipKeyValue(layout, "Thirst Change Unmodified", tostring(item:getThirstChangeUnmodified()))
    --InventoryUI.addTooltipKeyValue(layout, "Eaten Percent", tostring(eatenPercent * 100) .. "%")
    --InventoryUI.addTooltipKeyValue(layout, "Water Weight", tostring(waterWeight))
    --InventoryUI.addTooltipKeyValue(layout, "Empty Weight", tostring(emptyWeight))
    --InventoryUI.addTooltipKeyValue(layout, "Total Base Weight", tostring(totalBaseWeight))
    --InventoryUI.addTooltipKeyValue(layout, "BaseHunger", tostring(item:getBaseHunger()))
    --InventoryUI.addTooltipKeyValue(layout, "Hung Change", tostring(item:getHungChange()))
    --InventoryUI.addTooltipKeyValue(layout, "Hunger Change", tostring(item:getHungerChange()))


    weight = weight - totalBaseWeight
    weight = round(weight, 2)
    InventoryUI.addTooltipKeyValue(layout, "Ingredient Capacity:", weight .. "/" .. itemCapacity)
    if weight >= itemCapacity then
        InventoryUI.addTooltipKeyValue(layout, "Ingredient Capacity:", "FULL", nil, nil) -- Colour.getRGBA(table.newarray(1, 1, 1, 1))
    else
        InventoryUI.addTooltipBar(layout, "Ingredient Capacity:", weight / itemCapacity)
    end

    InventoryUI.addTooltipKeyValue(layout, "Remaining:", tostring(remaining * 100) .. "%")

end

-- Adds the event listener to the event, so that it will be called when the event is triggered.
InventoryUI.onFillItemTooltip:addListener(addAppleTooltip)
