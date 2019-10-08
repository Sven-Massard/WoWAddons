local _, ns = ...
SCF = ns

SCF_filterList = {}

function SCF:OnLoad(self)
    SlashCmdList["SCF"] = function(cmd)
        local params = {}
        local i = 1
        for arg in string.gmatch(cmd, "%S+") do
            params[i] = arg
            i = i + 1
        end
        scf_cmd(params)
    end
    SLASH_SCF1 = '/scf'
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("CHAT_MSG_CHANNEL")
end

function SCF:eventHandler(self, event, arg1, ...)
    if event == "CHAT_MSG_CHANNEL" then
		local message = arg1
		local charName, _, _, channelNumber, channelName = select(4, ...)
		for _, v in pairs(SCF_filterList) do
			if string.match(message, v) then
				print(message)
			end
		end
	elseif event == "ADDON_LOADED" and arg1 == "SvensChatFilter" then
		SCF:saveFilterList("Kraul Kloster SM")
		print("Svens chat filter loaded!")
    end
end

function SCF:saveFilterList(arg)
    SCF_filterList = {}
    for arg in string.gmatch(arg, "%S+") do
        table.insert(SCF_filterList, arg)
    end
end