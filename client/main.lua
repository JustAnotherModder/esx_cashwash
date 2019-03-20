ESX = nil

local PlayerData = {}
local showBlip = false -- Show blip on map.
local maxDirty = 100000 -- Max dirty money per laundry cycle.
local openKey = 51 -- Press [E] to open menu.

local emplacement = {
	{name="Cash Wash", id=108, colour=75, x=1269.73, y=-1710.25, z=54.7715},
}

local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Cash Wash",
    menu_subtitle = "Menu",
    color_r = 255, 
    color_g = 10, 
    color_b = 20,  
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

-- Show blip
Citizen.CreateThread(function()
 if (showBlip == true) then
    for _, item in pairs(emplacement) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipColour(item.blip, item.colour)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
 end
end)

--- Location
Citizen.CreateThread(
	function()
	--X, Y, Z coords 
		local x = 1269.73 
		local y = -1710.25
		local z = 54.7715
		while true do
			Citizen.Wait(0)
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) then
				DrawMarker(0, x, y, z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 255, 10, 10,165, 0, 0, 0,0)
				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 4.0) and (PlayerData.job.name == 'launderer') then						
					DisplayHelpText('Press ~INPUT_CONTEXT~ to launder your dirty money.')
					if (IsControlJustReleased(1, openKey)) then 
						LaundryMenu()
						Menu.hidden = not Menu.hidden
					end
					Menu.renderGUI(options) 
				end
			end
		end
end)


---- Functions ----
function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function LaundryMenu()
    options.menu_subtitle = "Cash Wash"
    ClearMenu()
	Menu.addButton("Clean Money", "Clean", -1)
	Menu.addButton("Close", "CloseMenu", nil)
end

function Clean(amount)
	if(amount == -1) then
		DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8S", "", "", "", "", "", 20)
		while (UpdateOnscreenKeyboard() == 0) do
			DisableAllControlActions(0);
			Wait(0);
		end
		if (GetOnscreenKeyboardResult()) then
			local res = tonumber(GetOnscreenKeyboardResult())
			if(res ~= nil and res ~= 0 and res <= maxDirty) then 
				amount = res		
            else
             Notify("You can only launder $100,000 at a time.")				
			end
		end
	end
	if(amount ~= -1) then
		TriggerServerEvent("esx_cashwash:CleanMoney", amount)
	end
end

function CloseMenu()
    Menu.hidden = true
end