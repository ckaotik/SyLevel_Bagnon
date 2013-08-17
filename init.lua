local _, ns = ...
local SL_BAGNON = ns.SL_BAGNON

local f = CreateFrame'frame'
f:RegisterEvent("ADDON_LOADED")

function f:UpdatePipeStates()
	for pipe in next, SyLevelDB.EnabledPipes do
		SyLevel:EnablePipe(pipe)
		for filter, enabledPipes in next, SyLevelDB.EnabledFilters do
			if(enabledPipes[pipe]) then
				SyLevel:RegisterFilterOnPipe(pipe, filter)
				break
			end
		end
	end
end

function f:CreatePipes()
	if not SyLevel_BagnonDB then SyLevel_BagnonDB = {}; SyLevel_BagnonDB.initialized = true end
	local pipes = {
		"Bagnonbags",
		"Bagnonbank"
		--"Bagnongbank"
	}
	local filter = "Item level text"
	for i=1,#pipes do
		SL_BAGNON[pipes[i]]() -- Registers pipes
		SyLevel:EnablePipe(pipes[i]) -- Automatically Sets the SyLevelDB value for us
		SyLevelDB.EnabledFilters[filter][pipes[i]] = true -- Enable the filter for SyLevelDB
	end
	self:UpdatePipeStates()
end


f:SetScript("OnEvent", function(self,event,arg1)
	if arg1 == "SyLevel_Bagnon" then
		self:UnregisterEvent(event)
		-- Bagnon:IsFrameEnabled("inventory")
		self:CreatePipes()
	end
end)
