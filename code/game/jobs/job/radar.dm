/datum/job/atmos
	title = "Communications Officer"
	flag = ATMOSTECH
	department_head = list("Lord General")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the Lord General"
	selection_color = "#ffeeee"

	default_pda = /obj/item/device/pda/security
	default_pda_slot = slot_l_store
	default_headset = /obj/item/device/radio/headset/headset_eng
	default_backpack = /obj/item/weapon/storage/backpack/security
	default_satchel = /obj/item/weapon/storage/backpack/satchel_sec
	default_id = /obj/item/weapon/card/id/dogtag

	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
									access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_atmospherics, access_maint_tunnels, access_emergency_storage, access_construction)

/datum/job/atmos/equip_items(var/mob/living/carbon/human/H)
	H.verbs += /mob/living/carbon/human/proc/renderaid									 //This is how we get the verb!
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/black, slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/imperialboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/imperialarmor(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/comm(H), slot_glasses)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/toolbox/electrical, slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/black(H), slot_head)
	H.faction = "RADARTECHS" //This allows them to use the radar machines

	if(H.backbag == 1)

		H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton/loaded(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/book/manual/radartech(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), slot_in_backpack)
	else

		H.equip_to_slot_or_del(new /obj/item/weapon/melee/baton/loaded(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/book/manual/radartech(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), slot_in_backpack)
