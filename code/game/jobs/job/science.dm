/*
Research Director
*/
/datum/job/rd
	title = "Lord Inquisitor, Ordo Xenos"
	flag = RD
	department_head = list("Ordo Xenos")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Ordo Xenos"
	selection_color = "#ffddff"
	req_admin_notify = 1
	minimal_player_age = 7

	default_id = /obj/item/weapon/card/id/silver
	default_pda = /obj/item/device/pda/heads/rd
	default_headset = /obj/item/device/radio/headset/heads/rd
	default_satchel = /obj/item/weapon/storage/backpack/satchel
	default_backpack = /obj/item/weapon/storage/backpack/satchel

	access = list(access_rd, access_change_ids, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload,
			            access_RC_announce, access_keycard_auth, access_gateway, access_mineral_storeroom,
			            access_tech_storage, access_minisat, access_cent_inquisitor, access_cent_general)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload,
			            access_RC_announce, access_keycard_auth, access_gateway, access_mineral_storeroom,
			            access_tech_storage, access_minisat, access_cent_inquisitor, access_cent_general)

/datum/job/rd/equip_items(var/mob/living/carbon/human/H)
	H.verbs += /mob/living/carbon/human/proc/renderaid									 //This is how we get the verb!
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/research_director(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/LIOX(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/lordinquisitor(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/device/laser_pointer(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/liox(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/bpistol(H), slot_l_hand)
	H.faction = "Inquisitor"

	if(H.backbag != 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/paper/liox(H), slot_in_backpack)

/*
Scientist
*/
/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	department_head = list("Research Director")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#ffeeff"

	default_pda = /obj/item/device/pda/toxins
	default_headset = /obj/item/device/radio/headset/headset_sci
	default_satchel = /obj/item/weapon/storage/backpack/satchel_tox

	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_mineral_storeroom)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenobiology, access_mineral_storeroom)

/datum/job/scientist/equip_items(var/mob/living/carbon/human/H)
	H.verbs += /mob/living/carbon/human/proc/renderaid									 //This is how we get the verb!
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/white(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/science2(H), slot_wear_suit)

/*
Roboticist
*/
/datum/job/roboticist
	title = "Cybernetica Acolyte"
	flag = ROBOTICIST
	department_head = list("Ordo Xenos Inquisitor")
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "Ordo Xenos Inquisitor, Magos"
	selection_color = "#ffeeff"

	default_pda = /obj/item/device/pda/roboticist
	default_headset = /obj/item/device/radio/headset/headset_sci
	default_satchel = /obj/item/weapon/storage/backpack/satchel_robo

	access = list(access_robotics, access_tech_storage, access_morgue, access_research, access_tox, access_mineral_storeroom)
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research, access_mineral_storeroom)

/datum/job/roboticist/equip_items(var/mob/living/carbon/human/H)
	H.verbs += /mob/living/carbon/human/proc/renderaid									 //This is how we get the verb!
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/roboticist(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/labcoat/science(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/cybernetica(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/weapon/paper/roboto(H), slot_in_backpack)
