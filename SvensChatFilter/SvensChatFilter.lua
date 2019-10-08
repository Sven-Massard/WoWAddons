function SCF_OnLoad(self)
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

function eventHandler(self, event, arg1)
--print(arg1)
    if event == "CHAT_MSG_CHANNEL" then
        --print("Chat Nachricht gefunden!")
		
    elseif event == "ADDON_LOADED" and arg1 == "SvensChatFilter" then
        loadAddon() -- in SvensBamAddonConfig.lua
		print(arg1)
		print(event)
		print(self)
    end
end

function loadAddon()
	print("SCF LOADED!")
end