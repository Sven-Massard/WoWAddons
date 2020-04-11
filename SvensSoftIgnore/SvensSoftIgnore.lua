local _,ns = ...
SSIL = ns

-- Function for event filter for CHAT_MSG_SYSTEM to suppress message of player on whisper list being offline when being whispered to
function SSIL_suppressWhisperMessage(self, event, msg, author, ...)
	-- TODO Suppression only works for Portugese, English, German and French because they have the same naming format.
	-- See https://www.townlong-yak.com/framexml/live/GlobalStrings.lua
	


	local ignored = "Shatterstorm-"..GetRealmName()

	if(author == ignored) then

		return true
	
	else

		return false
	end

end

function SSIL:OnLoad(self)

	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", SSIL_suppressWhisperMessage)
	
end