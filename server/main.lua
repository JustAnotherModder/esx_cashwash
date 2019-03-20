local tax = 0.80 -- 80 cents return to every dollar.

RegisterServerEvent("esx_cashwash:CleanMoney")
AddEventHandler("esx_cashwash:CleanMoney", function(amount)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local cash = tonumber(user:getMoney())
		local dcash = tonumber(user:getDirty_Money())
		local washeddirty = amount

		if(dcash <=0 or washedcash) then
			TriggerClientEvent("es_freeroam:notify", source, "CHAR_LESTER", 1, "Cash Wash", false, "You don't have any dirty money to launder.")
		else
			local washedcash = washeddirty * tax
			local total = cash + washedcash
			local totald = dcash - washeddirty
			user:setMoney(total)
			user:setDirty_Money(totald)
	    	TriggerClientEvent("es_freeroam:notify", source, "CHAR_LESTER", 1, "Cash Wash", false, "You cleaned $".. tonumber(washeddirty) .." for a return of $".. tonumber(total))	    
	    end
	end)
end)