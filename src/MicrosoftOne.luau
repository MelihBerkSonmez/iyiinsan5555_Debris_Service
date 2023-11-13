-- Custom Debris Module
-- Author: Assistant

-- Module table
local CustomDebris = {}

-- Module constants
local DEFAULT_LIFETIME = 10 -- The default number of seconds before an item is removed
local MIN_LIFETIME = 0.1 -- The minimum number of seconds before an item is removed
local MAX_ITEMS = 1000 -- The maximum number of items that can be added to the module

-- Module variables
local items = {} -- A table to store the items and their lifetimes
local itemCount = 0 -- A counter to keep track of the number of items

-- Module functions

-- Adds an item to the module for removal after the specified lifetime
-- @param item: Instance - The item to be removed
-- @param lifetime: number (optional) - The number of seconds before the item is removed
function CustomDebris:AddItem(item, lifetime)
    -- Check the arguments
    assert(typeof(item) == "Instance", "Invalid argument #1 (Instance expected)")
    assert(lifetime == nil or typeof(lifetime) == "number", "Invalid argument #2 (number or nil expected)")
    -- Check the item count
    if itemCount >= MAX_ITEMS then
        warn("CustomDebris: Item limit reached, cannot add more items")
        return
    end
    -- Check the lifetime
    lifetime = lifetime or DEFAULT_LIFETIME -- Use the default lifetime if none is given
    lifetime = math.max(lifetime, MIN_LIFETIME) -- Clamp the lifetime to the minimum value
    -- Add the item to the table
    items[item] = lifetime
    itemCount = itemCount + 1
    -- Schedule the removal of the item
    task.delay(lifetime, function()
        self:RemoveItem(item)
    end)
end

-- Removes an item from the module and destroys it
-- @param item: Instance - The item to be removed
function CustomDebris:RemoveItem(item)
    -- Check the arguments
    assert(typeof(item) == "Instance", "Invalid argument #1 (Instance expected)")
    -- Check if the item is in the table
    if not items[item] then
        warn("CustomDebris: Item not found, cannot remove it")
        return
    end
    -- Remove the item from the table
    items[item] = nil
    itemCount = itemCount - 1
    -- Destroy the item
    item:Destroy()
end

-- Returns the number of items in the module
-- @return number - The number of items
function CustomDebris:GetItemCount()
    return itemCount
end

-- Returns the lifetime of an item in the module
-- @param item: Instance - The item to query
-- @return number or nil - The lifetime of the item, or nil if not found
function CustomDebris:GetItemLifetime(item)
    -- Check the arguments
    assert(typeof(item) == "Instance", "Invalid argument #1 (Instance expected)")
    -- Return the lifetime from the table
    return items[item]
end

-- Clears all the items in the module and destroys them
function CustomDebris:ClearAll()
    -- Loop through the items and destroy them
    for item, _ in pairs(items) do
        item:Destroy()
    end
    -- Reset the table and the counter
    items = {}
    itemCount = 0
end

-- Return the module table
return CustomDebris
