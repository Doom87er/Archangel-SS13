/mob/living/carbon/human/dummy/goosemarine
	name = "GooseMarine"
	real_name = "GooseMarine"
	universal_speak = 1
	gender = "male"
	icon = 'icons/mob/mob.dmi'
	icon_state = "goosemarine"

/mob/living/carbon/human/dummy/goosemarine/New()
	..()
	equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/BPMP, slot_l_hand)

/mob/living/carbon/human/dummy/goosemarine/ex_act(severity)
	return

/mob/living/carbon/human/dummy/goosemarine/Life()
	..()
	if(prob(1))
		playsound(loc, 'sound/voice/dreet2.ogg', 75, 0)
	if(prob(1))
		if(wings)
			playsound(loc, 'sound/voice/gooselaugh.ogg', 75, 0)
			return
		else
			visible_message("\red <b>[src]</b> spreads his wings to challenge all the non geese in the area!", 1)
			wings = 1
			regenerate_icons()