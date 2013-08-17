local _, ns = ...

local hook
local _E

local bankUpdate = function(self)
	for _, bag in self:GetVisibleBags() do
		if Bagnon:IsBank(bag) or Bagnon:IsBankBag(bag) then
			local bagSize = self:GetBagSize(bag)
			for slot = 1, bagSize do
				local itemSlot = self:GetItemSlot(bag, slot)
				SyLevel:CallFilters('Bagnonbags', itemSlot, _E and itemSlot:GetItem())
			end
		end
	end
end

local slotUpdate = function(self, bag, slot)
	local itemSlot = self:GetItemSlot(bag, slot)
	if not itemSlot or not itemSlot:IsBankSlot() then return end
	SyLevel:CallFilters('Bagnonbags', itemSlot, _E and itemSlot:GetItem())
end


local update = function(self)
	bankUpdate(self)
end

local enable = function(self)
	_E = true

	if(not hook) then
		if Bagnon.Bag then
			-- hooksecurefunc(Bagnon.Bag, "Update", bagUpdate)
			hooksecurefunc(Bagnon.ItemFrame, "Layout", bankUpdate)
			hooksecurefunc(Bagnon.ItemFrame, "UpdateItemSlot", slotUpdate)
			hook = true
		end
	end
end

local disable = function(self)
	_E = nil
end

ns.SL_BAGNON.Bagnonbank = function()
	SyLevel:RegisterPipe('Bagnonbank', enable, disable, update, 'Bagnon Bank Window', nil)
end
