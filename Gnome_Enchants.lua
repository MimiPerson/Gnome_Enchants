
SLASH_ToolTip1 = '/tt'
SLASH_ToolTip2 = '/Tooltip'

-- Searchs Auction House and Sorts by lowest price --
function searchAH(EI) 
    QueryAuctionItems(EI)
    SortAuctionSetSort("list", "bid", false)

end

-- On Slash Command or Hotkey Press --
function altClick()
    EnumerateTooltipLines(GameTooltip)
    
end

-- Run the Control Click Function on Slash Command --
SlashCmdList['ToolTip'] = altClick
    
-- Helper Function for Looping Through each Line of Text in the Tooltip Object --
local function EnumerateTooltipLines_helper(...)
    local TTContent = ''
    for i = 1, select("#", ...) do
        local region = select(i, ...)
        if region and region:GetObjectType() == "FontString" then
            local text = region:GetText() -- string or nil
            if(text ~= nil) then
                TTContent = TTContent .. '\n' .. text 
            end
        end
    end
    OnTooltipText(TTContent)
end

-- Loop Through each Line of Text in the Tooltip Object --
function EnumerateTooltipLines(tooltip) -- good for script handlers that pass the tooltip as the first argument.
    EnumerateTooltipLines_helper(tooltip:GetRegions())
end

-- Split Function (String to Array)
function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

-- Runs when Tooltip Text has been Collected
function OnTooltipText(TTContent)
    local enchantInfo = GetEnchant(TTContent)
   -- print(enchantInfo)
    searchAH(enchantInfo)
end

-- Gets Enchant Info from the TTContent
function GetEnchant(TTContent) 
    local TTArray = split(TTContent, '\n')
    local EnchantInfo = ''

    for i in pairs(TTArray) do
        if string.find(TTArray[i], "Equip: ") then
            local tempArray = split(TTArray[i], '\:')
            if(tempArray[2] ~= nil) then
                tempArray = split(tempArray[2], '\-')
                if(tempArray[2]) then
                    EnchantInfo = tempArray[1]
                end
            end
        end
    end

    return EnchantInfo
end