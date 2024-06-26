/obj/item/weapon/warrant
	name = "Warrant"
	desc = "By Order of The Emperor and the Inquisition..."
	gender = PLURAL
	icon = 'icons/obj/warrant.dmi'
	icon_state = "wpaper"
	throwforce = 0
	w_class = 1.0
	throw_range = 1
	throw_speed = 1
	layer = 4
	var/spam_flag = 0
	var/sphess_coke = 0
	var/cut = 0
	var/inqsigned = 0
	var/signed = 0
	var/signature = ""
	var/blank = 1
	var/onfire = 0

/obj/item/weapon/warrant/attack_self(mob/living/carbon/human/M, mob/user)
	if(sphess_coke)																//LOL!!!!! Thats some balls right there.
		if(!cut)
			M << "You need to cut the laserbrain dust first."
		else
			M << "You inhale the laserbrain dust."
			var/snort = pick('sound/items/snort1.ogg','sound/items/snort2.ogg', 'sound/items/snort3.ogg')
			playsound(M.loc, snort, 75, 0)
			M.reagents.add_reagent("stimulant", sphess_coke)
			sphess_coke = 0
			src.icon_state = initial(src.icon_state)
			cut = 0
			award(usr, "I'm Rick James Bitch! Baddest mother fucker alive")
			if(M.soundevent)
				return
			else
				cocainesong(M)
		return
	examine()



/obj/item/weapon/warrant/update_icon()
	if(onfire)
		icon_state = "wletter_burn"
		return
	if(blank)
		icon_state = "wpaper"
		return
	if(inqsigned)
		icon_state = "wletter"
		return
	if(signed)
		icon_state = "wletter"
		return
	else
		icon_state = "wpaper2"
		return



/obj/item/weapon/warrant/Topic(href, href_list)
	if(..())
		return

	if (usr.stat || usr.restrained()) return //Nope! We are either dead or restrained!
	if (href_list["signit"])
		usr << "\red You sign your name with a cold blooded flourish."
		inqsigned = 1
		update_icon()
		return

	if (href_list["wsignit"])
		usr << "\red You carefully sign your name."
		signed = 1
		signature = usr.name
		update_icon()
		return
	if (href_list["prep"])
		usr << "\red You draw up an accusation of heresy. Now you'll you'll need is some one credible to sign it. Some one with the word LORD before their name."
		blank = 0
		signature = usr.name
		update_icon()
		return

/obj/item/weapon/warrant/attackby(obj/item/weapon/P, mob/user)
	..()

	if(istype(P, /obj/item/weapon/reagent_containers/glass))
		var/obj/item/weapon/reagent_containers/glass/beaker/B = P
		if(B.reagents.has_reagent("stimulant", 1))
			user << "You pour the laserbrain dust onto the paper."
			var/amount = B.reagents.get_reagent_amount("stimulant")
			src.sphess_coke += amount
			src.icon_state = "lazerbrain"
			B.reagents.remove_reagent("stimulant", amount)
			return

	if(istype(P, /obj/item/weapon/card) || istype(P, /obj/item/toy/cards/singlecard))
		if(!cut && sphess_coke)
			user << "You cut the laserbrain with the card."
			cut = 1
			var/cutsound = 'sound/items/screwdriver.ogg'
			playsound(src.loc, cutsound, 75, 0)
			return
	if(is_hot(P))
		onfire = 1
		update_icon()
		sleep(30)
		qdel(src)


	if(is_blind(user))
		return

	if(istype(P, /obj/item/weapon/pen) || istype(P, /obj/item/toy/crayon))
		if(blank)
			if(user.faction == "Inquisitor")
				var/dat = "<A href='byond://?src=\ref[src];prep=1'>Prepare a witness statement accusing Bradigan of heresy.</A><BR>"
				user << browse(dat, "window=scroll")
				onclose(user, "scroll")
				return
			else
				usr << "\red Damn writters block! I think you'll need an inquisitor for this."
				return
		if(user.faction == "Inquisitor")

			var/dat = "<B>In the name of the God Emperor of Mankind and the Inquisition. Attesting before me, the undersigned authority in and for The Ordo Hereticus personally appeared- who is known to me and who being first by me duly sworn, confesses and says as follows: He/She has witnessed or been coerced into cooperating with the heretical and/or traitorious activites of LORD ACHAR BRADIGAN, ORDO XENOS.</B><BR>"
			dat += "The confessor further states that he/she will testify to this charge if called before tribunal.<BR>"
			if (!signed)
				dat += "(unsigned)<BR>"
			if (signed)
				dat += "[signature]<BR>"
			if (!inqsigned)
				dat += "<A href='byond://?src=\ref[src];signit=1'>Sign as the Inquisitor who recieved the confession.</A><BR>"
			user << browse(dat, "window=scroll")
			onclose(user, "scroll")
			return
		if(user.job == "Lord General")
			var/dat = "<B>In the name of the God Emperor of Mankind and the Inquisition. Attesting before me, the undersigned authority in and for The Ordo Hereticus personally appeared- who is known to me and who being first by me duly sworn, confesses and says as follows: He/She has witnessed or been coerced into cooperating with the heretical and/or traitorious activites of LORD ACHAR BRADIGAN, ORDO XENOS.</B><BR>"
			dat += "The confessor further states that he/she will testify to this charge if called before tribunal.<BR>"
			if (!signed)
				dat += "(unsigned)<BR>"
			if (signed)
				dat += "[signature]<BR>"
			if (!signed)
				dat += "<A href='byond://?src=\ref[src];wsignit=1'>Sign as the witness who saw this heretical act.</A><BR>"
			user << browse(dat, "window=scroll")
			onclose(user, "scroll")
			return
		if(user.job == "Seneschal")
			var/dat = "<B>In the name of the God Emperor of Mankind and the Inquisition. Attesting before me, the undersigned authority in and for The Ordo Hereticus personally appeared- who is known to me and who being first by me duly sworn, confesses and says as follows: He/She has witnessed or been coerced into cooperating with the heretical and/or traitorious activites of LORD ACHAR BRADIGAN, ORDO XENOS.</B><BR>"
			dat += "The confessor further states that he/she will testify to this charge if called before tribunal.<BR>"
			if (!signed)
				dat += "(unsigned)<BR>"
			if (signed)
				dat += "[signature]<BR>"
			if (!signed)
				dat += "<A href='byond://?src=\ref[src];signit=1'>Sign as the witness who saw this heretical act.</A><BR>"
			user << browse(dat, "window=scroll")
			onclose(user, "scroll")
			return
		if(user.job == "Lord Inquisitor, Ordo Xenos")
			var/dat = "<B>In the name of the God Emperor of Mankind and the Inquisition. Attesting before me, the undersigned authority in and for The Ordo Hereticus personally appeared- who is known to me and who being first by me duly sworn, confesses and says as follows: He/She has witnessed or been coerced into cooperating with the heretical and/or traitorious activites of LORD ACHAR BRADIGAN, ORDO XENOS.</B><BR>"
			dat += "The confessor further states that he/she will testify to this charge if called before tribunal.<BR>"
			if (!signed)
				dat += "(unsigned)<BR>"
			if (signed)
				dat += "[signature]<BR>"
			if (!signed)
				dat += "<A href='byond://?src=\ref[src];signit=1'>Sign as the witness who saw this heretical act.</A><BR>"
			user << browse(dat, "window=scroll")
			onclose(user, "scroll")
			return
		else
			user << "This document appears to have been prepared for a Seneschal, Lord Inquisitor or a Lord General. You dare not touch it."
			return
	add_fingerprint(user)


/obj/item/weapon/warrant/proc/cocainesong(mob/living/carbon/human/M, mob/user)
	M.soundevent = 1
	usr << "<span class='notice'>You are no longer human. The power of a thousand stars burn inside of you. You can run faster, hit harder, shoot better and you are COMPLETELY INDESTRUCTABLE!!</span>"
	usr << 'sound/effects/cocaine.ogg'
	sleep(300)
	M.soundevent = 0
	return