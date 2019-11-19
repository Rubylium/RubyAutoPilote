function Notification(title, subject, msg, icon, iconType)
	AddTextEntry('showAdNotification', msg)
	SetNotificationTextEntry('showAdNotification')
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end





AutoPiloteActif = false
function AutoPilote(Conduite)
	local style
	local speed
	if Conduite == "ConduiteNormal" then
		style = 786603
		speed = 25.0
	elseif Conduite == "ConduiteRapide" then
		style = 1074528293
		speed = 450.0
	elseif Conduite == "ConduiteRapideSafe" then
		style = 2883621
		speed = 25.0
	end
	-- Conduite
	local way = IsWaypointActive()
	if way then
		local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
		local retval, coords = GetClosestVehicleNode(waypointCoords.x, waypointCoords.y, waypointCoords.z, 1)
		local PlayerPed = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(PlayerPed, false)
        local hash = GetHashKey(veh)
        local distance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), destination, true), 0)

        TaskVehicleDriveToCoord(PlayerPed, veh, coords.x, coords.y, coords.z, speed, 1.0, hash, style, 5.0, true)

        PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
        Notification("AutoPilote", "~b~Information", "Auto pilote ~g~Activé.~w~\nDistance: ~g~"..distance.."m", "CHAR_LS_TOURIST_BOARD", 8)

        destination = coords
        AutoPiloteActif = true
	else
		Notification("AutoPilote", "~b~Information", "Auto pilote ~r~OFF.\nAucun point GPS", "CHAR_LS_TOURIST_BOARD", 8)
	end
end


VehList = {}
Citizen.CreateThread(function()
    while true do
        if AutoPiloteActif then
            VehList = {}
            local voiture = ESX.Game.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(-1), true), 30) -- Changer ça si trop de MS utilisé
            for _, voiture in pairs(voiture) do
                if voiture ~= GetVehiclePedIsIn(GetPlayerPed(-1), 0) then
                    table.insert(VehList, voiture)
                end
            end
        end
        Citizen.Wait(1000)
    end
end)


Citizen.CreateThread(function()
    while true do
        for _, voiture in pairs(VehList) do
            local coords = GetEntityCoords(voiture, true)
            local distanceChemin = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), destination, true), 0)
            if distanceChemin <= 10.0 then
                ClearPedTasks(GetPlayerPed(-1))
                AutoPiloteActif = false
                VehList = {}
                
            else
                local distance = ESX.Math.Round(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), true), coords, true), 0)
                if distance >= 10 then
                    DrawMarker(36, coords.x, coords.y, coords.z+1.7, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 170, 0, 0, 2, 1, nil, nil, 0)
                else
                    DrawMarker(36, coords.x, coords.y, coords.z+1.7, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 170, 0, 0, 2, 1, nil, nil, 0)
                end
            end
        end
        Citizen.Wait(1)
    end
end)