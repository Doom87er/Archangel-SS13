/*
Automation!
This handles a lot of automated things. Right now I have it doling out bad luck against friendly fire.
*/

/mob/proc/get_role() //A slightly more program friendly way of accessing the special_role variable.
	if(mind)
		if(mind.special_role == "Changeling")
			return "imperial"
		if(isork(src))
			return "ork"  //We got a lot of factions here. It's a long proc of priorities to determine the player's ultimate allegiance. And yes, a player HAS to have a single allegiance. Not zero. Not two. Not anything that isn't one.
		if(isalien(src))
			return "tyranid"
		if(mind.special_role == "Genestealer Cult Member")
			return "tyranid"
		if(istype(src, /mob/living/carbon/human/tau))
			return "tau"
		if(istype(src, /mob/living/carbon/human/whitelisted/ksons))
			return "tzeench"
		if(mind.special_role == "Cultist") //Note that all the above groups are /immune/ to being in the cult.
			return "nurgle"
		if(mind.special_role == "Wizard")
			return "eldar"
		if(mind.special_role == "Syndicate")
			return "khorne"
		if(mind.special_role == "Heretic") //Generic chaos, a heretic is not really obligated to give special treatment to other chaos factions. However, it's still bad luck to kill an ally.
			return "chaos"
		if(mind.assigned_role == "Eldar Spy")
			return "eldar"
		if(ishuman(src)) //Purity is a human thing. No that wasn't a philosophical statement that was an assessment of object oriented inheritance :P
			if(mind.assigned_role == "Mime" && src:purity < -7) //At this point the mime fully realizes that he is eldar. So put him in that faction.
				return "eldar"
			if(mind.assigned_role == "Celebrity" && src:purity < -10) //If they hit the bit where they need to find a human heart, they are effectively a chaos worshipper.
				return "slaanesh"
		if(mind.assigned_role == "shade") //A non-cultist shade is more or less on their own.
			return "shade"
		return "imperial"
	else
		return "mindless"

/mob/var/list/retaliate_list = list() //The list of people where fighting them is just a retaliation.

/mob/proc/act_of_violence(var/mob/living/target, var/delivered_damage) //Called on any kind of violent act between two mobs, checks if it is legit and does something about it if not.
	//world << "[src] just tried to attack [target] for an estimated net damage of [delivered_damage]"
	if(src == target) return
	if(target.luck <= -100) return
	if(target in src.retaliate_list)
		return
	target.retaliate_list.Add(src)
	spawn(600) //If they have committed an act of aggression against you in the last minute, you can retaliate against them. If, say, the last time they critted you and your minute passes, than this will put their luck below -100 so you can still retaliate without incurring any bad luck.
		target.retaliate_list.Remove(src)
	if(target.maxHealth - (target.health-delivered_damage) < 15) return //Total damage after your attack is applied is minimal and won't count against your luck score.
	if(src.get_role() == target.get_role())
		if(src.mind)
			for(var/datum/objective/assassinate/A in src.mind.objectives) //Within factions, an assassinate objective will excuse violent acts, naturally.
				if(A.target.current == target)
					return
			for(var/datum/objective/debrain/D in src.mind.objectives)
				if(D.target.current == target)
					return
		src.luck -= delivered_damage
	return //Things that validate violence against same-faction: target's luck is -100 or less, target has recently comitted an act of violence against you, target is an objective, resultant target's health is above 85 (note that such an attack is still fair game for retaliation). Note that the health check only applies to direct violence, all explosions and poisonings are considered too deliberate to have such a check. This is mostly here just so that the comissar can whip someone or you can punch somebody and you don't suddenly have shitty luck.

/mob/proc/reagent_exposure(var/mob/living/target, var/datum/reagents/R, var/injected = 1) //Called when a mob exposes a mob to any reagents.
	//world << "[src] just exposed [target] to chemicals"
	if(src == target) return
	if(target.luck <= -100) return
	if(target in src.retaliate_list)
		return
	target.retaliate_list.Add(src)
	spawn(600) //If they have committed an act of aggression against you in the last minute, you can retaliate against them. If, say, the last time they critted you and your minute passes, than this will put their luck below -100 so you can still retaliate without incurring any bad luck.
		target.retaliate_list.Remove(src)
	var/poison_rating = R.net_effect(injected, target)
	if(poison_rating < 0)
		if(src.get_role() == target.get_role())
			if(src.mind)
				for(var/datum/objective/assassinate/A in src.mind.objectives) //Within factions, an assassinate objective will excuse violent acts, naturally.
					if(A.target.current == target)
						return
				for(var/datum/objective/debrain/D in src.mind.objectives)
					if(D.target.current == target)
						return
			src.luck += max(-150, poison_rating)
	return

/mob/proc/blast_exposure(var/mob/living/target, var/force) //Called when a mob exposes a mob to an explosion.
	//world << "[src] just exploded [target] with force [force]"
	if(src == target) return
	if(target.luck <= -100) return
	if(target in src.retaliate_list)
		return
	target.retaliate_list.Add(src)
	spawn(600) //If they have committed an act of aggression against you in the last minute, you can retaliate against them. If, say, the last time they critted you and your minute passes, than this will put their luck below -100 so you can still retaliate without incurring any bad luck.
		target.retaliate_list.Remove(src)
	if(src.get_role() == target.get_role())
		if(src.mind)
			for(var/datum/objective/assassinate/A in src.mind.objectives) //Within factions, an assassinate objective will excuse violent acts, naturally.
				if(A.target.current == target)
					return
			for(var/datum/objective/debrain/D in src.mind.objectives)
				if(D.target.current == target)
					return
		var/delivered_damage = 0
		switch(force)
			if(1)
				delivered_damage = 200
			if(2)
				delivered_damage = 100
			if(3)
				delivered_damage = 35
			if(4)
				delivered_damage = 10
		src.luck -= delivered_damage
	return