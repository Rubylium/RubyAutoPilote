-- Config

local marker = true -- Allow to display or not marker on other cars when auto pilote is ON. This DO take some MS ( Around 0.30 ~ ), it's nice to see but take some ressource. Set it to false if you don't want it





function Notification(title, subject, msg, icon, iconType)
	AddTextEntry('notifAutoPilote', msg)
	SetNotificationTextEntry('notifAutoPilote')
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