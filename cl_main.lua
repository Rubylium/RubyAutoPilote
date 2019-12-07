ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObjectX', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)



_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("AutoPilote Menu", "~b~Menu Auto Pilote.")
_menuPool:Add(mainMenu)
_menuPool:WidthOffset(0)



local amount = {}
function menu(menu)
	local stop = NativeUI.CreateItem("Stoppé l'auto pilote.", " ")
    menu:AddItem(stop)
    local ConduiteNormal = NativeUI.CreateItem("Conduite normal", "~b~Active l'auto pilote ~g~normal ~b~jusqu'au point GPS (Respecte la plus part des feu tricolors)")
    menu:AddItem(ConduiteNormal)
    local ConduiteRapideSafe = NativeUI.CreateItem("Conduite Rapide Safe", "~b~Active l'auto pilote ~g~rapide ~b~jusqu'au point GPS (Ignore la plus part des feu tricolors)")
    menu:AddItem(ConduiteRapideSafe)
    local ConduiteRapide = NativeUI.CreateItem("Conduite Rapide", "~b~Active l'auto pilote ~g~rapide ~b~Conduite ~r~Dangereuse en ville")
    menu:AddItem(ConduiteRapide)

    
    local Description = "Permet de gèrer la vitesse de l'auto pilote aléatoire. ~b~10 = 35 ~ KmH"
    for i = 1, 100 do
       amount[i] = i
    end
    
    local ItemProgress = NativeUI.CreateProgressItem("Gestion Vitesse ", amount, 10, Description, true)
    menu:AddItem(ItemProgress)
    ItemProgress.OnProgressChanged = function(menu, item, newindex)
       if item == ItemProgress then
           vitesse = newindex + .0
           print(vitesse)
       end
    end
    local aleatoire = NativeUI.CreateItem("Conduite Aléatoire", "~b~Active l'auto pilote aléatoire, bien pour vous balader sans savoir ou aller")
    menu:AddItem(aleatoire)

	menu.OnItemSelect = function(sender, item, index)
		if item == stop then
            ClearPedTasks(GetPlayerPed(-1))
            AutoPiloteActif = false
            VehList = {}
        elseif item == ConduiteNormal then
			AutoPilote("ConduiteNormal")
		elseif item == ConduiteRapide then
			AutoPilote("ConduiteRapide")
		elseif item == ConduiteRapideSafe then
            AutoPilote("ConduiteRapideSafe")
        elseif item == aleatoire then
            TaskVehicleDriveWander(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), vitesse, 786603)
		end
	end
end








local count = 0
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
    end
    menu(mainMenu)
    while true do
        Citizen.Wait(0)
		_menuPool:ProcessMenus()
		if IsControlJustReleased(1, 344) then
			if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
				mainMenu:Clear()
				menu(mainMenu)
				Wait(100)
                mainMenu:Visible(not mainMenu:Visible())
                PlaySoundFrontend(-1, "Menu_Accept", "Phone_SoundSet_Default", 1)
            else
                PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 1)
                Notification("AutoPilote", "~b~Information", "Vous devez être en véhicule pour ouvrir le menu AutoPilote.", "CHAR_LS_TOURIST_BOARD", 8)
			end
		end
    end
end)


_menuPool:RefreshIndex()
_menuPool:MouseControlsEnabled (false);
_menuPool:MouseEdgeEnabled (false);
_menuPool:ControlDisablingEnabled(false);