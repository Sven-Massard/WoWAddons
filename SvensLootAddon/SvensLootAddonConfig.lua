function SLA:loadAddon()
    local SLA_whisperFrame
    local SLA_Output_Message_Edit_Box
	local SLA_Item_List_Edit_Box
    local channelButtonList = {}
    local channelList = 
        {
            "Say",
            "Yell",
            "Print",
            "Guild",
            "Raid",
            "Emote",
            "Party",
            "Officer",
            "Raid_Warning",
            "Battleground",
            "Whisper",
        }


    if(SLA_color == nil) then
		SLA_color = "|cff".."94".."CF".."00"
    end

	local rgb =
		{
			{color = "Red",   value = SLA_color:sub(5, 6)},
			{color = "Green", value = SLA_color:sub(7, 8)},
			{color = "Blue",  value = SLA_color:sub(9, 10)}
		}

	if(SLA_itemList == nil) then
		SLA_itemList = {
		}
	end

    if(SLA_whisperList == nil) then
        SLA_whisperList = {}
    end

    if(SLA_output_message == nil) then
        SLA_output_message = "Found IN!"
    end

	if(SLA_outputChannelList == nil) then
        SLA_outputChannelList = {
			"Print",
		}
    end

    --Good Guide https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/InterfaceOptionsFrame.lua
    --Options Main Menu
    SvensLootAddonConfig = {};
    SvensLootAddonConfig.panel = CreateFrame( "Frame", "SvensLootAddonConfig", UIParent );    
    SvensLootAddonConfig.panel.name = "Svens Loot Addon";
    SvensLootAddonConfig.panel.title = SvensLootAddonConfig.panel:CreateFontString("SLAGeneralOptionsDescription", "OVERLAY");
    SvensLootAddonConfig.panel.title:SetFont(GameFontNormal:GetFont(), 14, "NONE");
    SvensLootAddonConfig.panel.title:SetPoint("TOPLEFT", 5, -5);
    SvensLootAddonConfig.panel.title:SetJustifyH("LEFT")

        
    --Channel Options SubMenu
    SvensLootAddonChannelOptions = {}
    SvensLootAddonChannelOptions.panel = CreateFrame( "Frame", "SvensLootAddonChannelOptions");
    SvensLootAddonChannelOptions.panel.name = "Channel options";
    SvensLootAddonChannelOptions.panel.parent = "Svens Loot Addon"
    SvensLootAddonChannelOptions.panel.okay = function()
        SLA:saveWhisperList()
    end
    SLA:populateChannelSubmenu(channelButtonList, channelList)
	
    --General Options SubMenu NEEDS TO BE LAST BECAUSE SLIDERS CHANGE FONTSTRINGS OF ALL MENUS
    SvensLootAddonGeneralOptions = {}
    SvensLootAddonGeneralOptions.panel = CreateFrame( "Frame", "SvensLootAddonGeneralOptions");
    SvensLootAddonGeneralOptions.panel.name = "General options";
    SvensLootAddonGeneralOptions.panel.parent = "Svens Loot Addon"
    SvensLootAddonGeneralOptions.panel.okay = function()
        SLA:saveOutputMessage()
		SLA:saveitemList()

    end
    SLA:populateGeneralSubmenu(eventButtonList, rgb)
	
	--Set order of Menus here
    InterfaceOptions_AddCategory(SvensLootAddonConfig.panel);
	InterfaceOptions_AddCategory(SvensLootAddonGeneralOptions.panel);
	InterfaceOptions_AddCategory(SvensLootAddonChannelOptions.panel);
	
    print(SLA_color.."Svens Loot Addon loaded! Type /sla help for options!")
end

function SLA:populateGeneralSubmenu(eventButtonList, rgb)
	local lineHeight = 16
	local boxHeight = 32
	local boxSpacing = 24 -- Even though a box is 32 high, it somehow takes only 24 of space
	local editBoxWidth = 400
	local categoriePadding = 16
	local baseYOffSet = 5
	
	local categorieNumber = 0 -- increase after each categorie
	local amountLinesWritten = 0 -- increase after each Font String
	local boxesPlaced = 0 -- increase after each edit box or check box placed
	
	--Item Box
	SvensLootAddonGeneralOptions.panel.title = SvensLootAddonGeneralOptions.panel:CreateFontString("Sla_item_description", "OVERLAY");
    SvensLootAddonGeneralOptions.panel.title:SetFont(GameFontNormal:GetFont(), 14, "NONE");
    SvensLootAddonGeneralOptions.panel.title:SetPoint("TOPLEFT", 5, -24*amountLinesWritten - baseYOffSet);
	amountLinesWritten = amountLinesWritten + 1
	
	SLA:createSLA_Item_List_Edit_Box(boxHeight, editBoxWidth, -(baseYOffSet + categorieNumber*categoriePadding + amountLinesWritten*lineHeight + boxesPlaced*boxSpacing))
	boxesPlaced = boxesPlaced +1
	categorieNumber = categorieNumber + 1
	
	-- Output Message
    SvensLootAddonGeneralOptions.panel.title = SvensLootAddonGeneralOptions.panel:CreateFontString("SLA_OutputMessageDescription", "OVERLAY");
    SvensLootAddonGeneralOptions.panel.title:SetFont(GameFontNormal:GetFont(), 14, "NONE");
    SvensLootAddonGeneralOptions.panel.title:SetPoint("TOPLEFT", 5, -(baseYOffSet + categorieNumber*categoriePadding + amountLinesWritten*lineHeight + boxesPlaced*boxSpacing));
	amountLinesWritten = amountLinesWritten + 1

    SLA:createSLA_Output_Message_Edit_Box(boxHeight, editBoxWidth, -(baseYOffSet + categorieNumber*categoriePadding + amountLinesWritten*lineHeight + boxesPlaced*boxSpacing))
	boxesPlaced = boxesPlaced +1
	categorieNumber = categorieNumber + 1

	-- Color changer 
    yOffSet = 3
	SvensLootAddonGeneralOptions.panel.title = SvensLootAddonGeneralOptions.panel:CreateFontString("FontColorDescription", "OVERLAY");
    SvensLootAddonGeneralOptions.panel.title:SetFont(GameFontNormal:GetFont(), 14, "NONE");
    SvensLootAddonGeneralOptions.panel.title:SetPoint("TOPLEFT", 5, -(baseYOffSet + categorieNumber*categoriePadding + amountLinesWritten*lineHeight + boxesPlaced*boxSpacing));
	amountLinesWritten = amountLinesWritten + 1
	amountLinesWritten = amountLinesWritten + 1 --Another Time, because the Sliders have on line above
	for i=1, 3 do
		SLA:createColorSlider(i, SvensLootAddonGeneralOptions.panel, rgb, -(baseYOffSet + categorieNumber*categoriePadding + amountLinesWritten*lineHeight + boxesPlaced*boxSpacing))
	end
	categorieNumber = categorieNumber + 1
	
    
end

function SLA:createSLA_Item_List_Edit_Box(height, width, y)
	SLA_Item_List_Edit_Box = SLA:createEditBox("SLA_Item_List_Edit_Box", SvensLootAddonGeneralOptions.panel, height, width)
    SLA_Item_List_Edit_Box:SetPoint("TOPLEFT", 40, y)
	for _, v in pairs(SLA_itemList) do
		SLA_Item_List_Edit_Box:Insert("\""..v.."\" ")
	end
	SLA_Item_List_Edit_Box:SetCursorPosition(0)
	
	SLA_Item_List_Edit_Box:SetScript( "OnEscapePressed", function(...)
		SLA_Item_List_Edit_Box:ClearFocus()
		SLA_Item_List_Edit_Box:SetText("")
		for _, v in pairs(SLA_itemList) do
			SLA_Item_List_Edit_Box:Insert("\""..v.."\" ")
		end
	end)
	SLA_Item_List_Edit_Box:SetScript( "OnEnterPressed", function(...)
		SLA_Item_List_Edit_Box:ClearFocus()
		SLA:saveitemList()
	end)
	SLA_Item_List_Edit_Box:SetScript( "OnEnter", function(...)            
		GameTooltip:SetOwner(SLA_Item_List_Edit_Box, "ANCHOR_BOTTOM");
		GameTooltip:SetText( "Write names of items in double quotes, separated by spaces.\n"
			.."Eg: \"Linen Cloth\" \"Arcane Crystal\"")
		GameTooltip:ClearAllPoints()
		GameTooltip:Show()
	end)
	SLA_Item_List_Edit_Box:SetScript( "OnLeave", function()
		GameTooltip:Hide()
	end)
end

function SLA:createSLA_Output_Message_Edit_Box(height, width, y)
    SLA_Output_Message_Edit_Box = SLA:createEditBox("SLA_Output_Message_Box", SvensLootAddonGeneralOptions.panel, height, width)
    SLA_Output_Message_Edit_Box:SetPoint("TOPLEFT", 40, y)
    SLA_Output_Message_Edit_Box:Insert(SLA_output_message)
    SLA_Output_Message_Edit_Box:SetCursorPosition(0)   
    SLA_Output_Message_Edit_Box:SetScript( "OnEscapePressed", function(...)
        SLA_Output_Message_Edit_Box:ClearFocus()
        SLA_Output_Message_Edit_Box:SetText(SLA_output_message)
        end)
    SLA_Output_Message_Edit_Box:SetScript( "OnEnterPressed", function(...)
        SLA_Output_Message_Edit_Box:ClearFocus()
        SLA:saveOutputMessage()
    end)
    SLA_Output_Message_Edit_Box:SetScript( "OnEnter", function(...)            
        GameTooltip:SetOwner(SLA_Output_Message_Edit_Box, "ANCHOR_BOTTOM");
        GameTooltip:SetText( "Insert your message here.\nIN will be replaced with item name.\n" )
        GameTooltip:ClearAllPoints()
        GameTooltip:Show()
    end)
    SLA_Output_Message_Edit_Box:SetScript( "OnLeave", function()
        GameTooltip:Hide()
    end)
end

function SLA:populateChannelSubmenu(channelButtonList, channelList)
    SvensLootAddonChannelOptions.panel.title = SvensLootAddonChannelOptions.panel:CreateFontString("SLA_Output_Channel_Description", "OVERLAY");
    SvensLootAddonChannelOptions.panel.title:SetFont(GameFontNormal:GetFont(), 14, "NONE");
    SvensLootAddonChannelOptions.panel.title:SetPoint("TOPLEFT", 5, -5);
    -- Checkboxes channels and Edit Box for whispers
    for i=1, # channelList do
        SLA:createCheckButtonChannel(i, 1, i, channelButtonList, channelList)
    end
    SLA:createResetChannelListButton(SvensLootAddonChannelOptions.panel, channelList, channelButtonList)
end

function SLA:createCheckButtonChannel(i, x, y, channelButtonList, channelList)
	local YOffset = y*-24
    local checkButton = CreateFrame("CheckButton", "SvensLootAddon_ChannelCheckButton" .. i, SvensLootAddonChannelOptions.panel, "UICheckButtonTemplate")
    channelButtonList[i] = checkButton
    checkButton:ClearAllPoints()
    checkButton:SetPoint("TOPLEFT", x * 32, YOffset)
    checkButton:SetSize(32, 32)
    
    _G[checkButton:GetName() .. "Text"]:SetText(channelList[i])
    _G[checkButton:GetName() .. "Text"]:SetFont(GameFontNormal:GetFont(), 14, "NONE")
    for j = 1, # SLA_outputChannelList do
        if(SLA_outputChannelList[j] == channelList[i]) then            
            channelButtonList[i]:SetChecked(true)
        end
    end
    
    channelButtonList[i]:SetScript("OnClick", function()   
        if channelButtonList[i]:GetChecked() then
            table.insert(SLA_outputChannelList, channelList[i])         
        else
            indexOfFoundValues = {}
            for j = 1, # SLA_outputChannelList do
                if(SLA_outputChannelList[j] == channelList[i]) then
                    table.insert(indexOfFoundValues, j)
                end
            end
            j = # indexOfFoundValues
            while (j>0) do   
                table.remove(SLA_outputChannelList, indexOfFoundValues[j])
                j = j-1;
            end
        end
    end)
    
    -- Create Edit Box for whispers
    if(channelList[i] == "Whisper") then
        SLA_whisperFrame = SLA:createEditBox("SLA_WhisperListEditBox", SvensLootAddonChannelOptions.panel, 32, 400)
        SLA_whisperFrame:SetPoint("TOP",50, -24*y)
        for _, v in pairs(SLA_whisperList) do
            SLA_whisperFrame:Insert(v.." ")
        end
        SLA_whisperFrame:SetCursorPosition(0)
        
        SLA_whisperFrame:SetScript( "OnEscapePressed", function(...)
            SLA_whisperFrame:ClearFocus()
            SLA_whisperFrame:SetText("")
            for _, v in pairs(SLA_whisperList) do
                SLA_whisperFrame:Insert(v.." ")
            end
        end)
        SLA_whisperFrame:SetScript( "OnEnterPressed", function(...)
            SLA_whisperFrame:ClearFocus()
            SLA:saveWhisperList()
        end)
        SLA_whisperFrame:SetScript( "OnEnter", function(...)            
            GameTooltip:SetOwner(SLA_whisperFrame, "ANCHOR_BOTTOM");
            GameTooltip:SetText( "Separate names of people you want to annoy with whispers" )
            GameTooltip:ClearAllPoints()
            GameTooltip:Show()
        end)
        SLA_whisperFrame:SetScript( "OnLeave", function()
            GameTooltip:Hide()
        end)
    end
end

function SLA:createResetChannelListButton(parentFrame, channelList, channelButtonList)
    resetChannelListButton = CreateFrame("Button", "ResetButtonChannels", parentFrame, "UIPanelButtonTemplate");
    resetChannelListButton:ClearAllPoints()
    resetChannelListButton:SetPoint("TOPLEFT", 32, ((# channelList) + 1)*-24 -8)
    resetChannelListButtonText = "Clear Channel List (May fix bugs after updating)"
    resetChannelListButton:SetSize(resetChannelListButtonText:len()*7, 32)
    resetChannelListButton:SetText(resetChannelListButtonText)
    resetChannelListButton:SetScript( "OnClick", function(...)
        for i = 1, # channelButtonList do
            channelButtonList[i]:SetChecked(false)
        end
            SLA_outputChannelList = {}
    end)
end

function SLA:createColorSlider(i, panel, rgb, yOffSet)
	local slider = CreateFrame("Slider", "SLA_Slider"..i, panel, "OptionsSliderTemplate")
	slider:ClearAllPoints()
	slider:SetPoint("TOPLEFT", 32, -16*2*(i-1)+yOffSet)
	slider:SetSize(256,16)
	slider:SetMinMaxValues(0, 255)
	slider:SetValueStep(1)
	_G[slider:GetName() .. "Low"]:SetText("|c00ffcc00Min:|r 0")
	_G[slider:GetName() .. "High"]:SetText("|c00ffcc00Max:|r 255")
	slider:SetScript("OnValueChanged", function(self, event, arg1)
		local value = floor(slider:GetValue())
		_G[slider:GetName() .. "Text"]:SetText("|c00ffcc00"..rgb[i].color.."|r "..value)
		_G[slider:GetName() .. "Text"]:SetFont(GameFontNormal:GetFont(), 14, "NONE")
		rgb[i].value = SLA:convertRGBDecimalToRGBHex(value)
		SLA_color = "|cff"..rgb[1].value..rgb[2].value..rgb[3].value
		SLA:setPanelTexts()
	end)
	slider:SetValue(tonumber("0x"..rgb[i].value))
	
end

function SLA:saveWhisperList()
    SLA_whisperList = {}
    for arg in string.gmatch(SLA_whisperFrame:GetText(), "%S+") do
        table.insert(SLA_whisperList, arg)
    end
end

	
function SLA:saveOutputMessage() --TODO
    SLA_output_message = SLA_Output_Message_Edit_Box:GetText()
end

    
function SLA:createEditBox(name, parentFrame, height, width)
    local eb = CreateFrame("EditBox", name, parentFrame, "InputBoxTemplate")
    eb:ClearAllPoints()
    eb:SetAutoFocus(false)
    eb:SetHeight(height)
    eb:SetWidth(width)
    eb:SetFontObject("ChatFontNormal")
    return eb
end

function SLA:saveitemList()
	SLA_itemList = {}
    for arg in string.gmatch(SLA_Item_List_Edit_Box:GetText(), '"(.-)"') do
        table.insert(SLA_itemList, arg)
    end
end

function SLA:convertRGBDecimalToRGBHex(decimal)
	local result
	local numbers = "0123456789ABCDEF"
	result = numbers:sub(1+(decimal/16), 1+(decimal/16))..numbers:sub(1+(decimal%16), 1+(decimal%16))
	return result
end

function SLA:setPanelTexts()
	SLAGeneralOptionsDescription:SetText(SLA_color.."Choose sub menu to change options")
	SLA_OutputMessageDescription:SetText(SLA_color.."Output Message")
	SvensLootAddonGeneralOptions.panel.title:SetText(SLA_color.."Change color of Font")
	FontColorDescription:SetText(SLA_color.."Change color of Font")
	SLA_Output_Channel_Description:SetText(SLA_color.."Output Channel")
	OtherOptionsDescription:SetText(SLA_color.."Other options:")
	Sla_item_description:SetText(SLA_color.."Item List:")
end





