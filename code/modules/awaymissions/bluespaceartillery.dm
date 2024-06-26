
/obj/machinery/computer/artillerycontrol
	var/reload = 180
	name = "Orbital Uplink"
	desc = "It appears to be a long range communication device."
	icon_state = "ob1"
	icon = 'icons/obj/machines/Orbitalcomand.dmi'
	density = 1
	anchored = 1
	var/reinfo = 1
	var/warrantactive = 0

/obj/machinery/computer/artillerycontrol/process()
	if(src.reload<180)
		src.reload++

/obj/structure/artilleryplaceholder
	name = "artillery"
	icon = 'icons/obj/machines/artillery.dmi'
	anchored = 1
	density = 1

/obj/structure/artilleryplaceholder/decorative
	density = 0

/obj/machinery/computer/artillerycontrol/attack_hand(mob/user as mob)
	user.set_machine(src)
	var/dat = "<B>Stargazer Communication Console:</B><BR>"
	dat += "Locked on<BR>"
	dat += "<B>Charge progress: [reload]/180:</B><BR>"
	dat += "<A href='byond://?src=\ref[src];fire=1'>Surgical Strike</A><BR>"
	dat += "<A href='byond://?src=\ref[src];submit=1'>Submit statement implicating Lord Achar Bradigan.</A><BR>"
	if(reinfo)
		dat += "<A href='byond://?src=\ref[src];reinfo=1'>Request Reinforcements</A><BR>"
	dat += "Imperial Inquisition Lunar Class Cruiser 'Stargazer' awaiting your request. <br>We will hold position until you need us.<br><br>The Emperor Protects!<HR>"
	user << browse(dat, "window=scroll")
	onclose(user, "scroll")
	return

/obj/machinery/computer/artillerycontrol/Topic(href, href_list)
	if(..())
		return
	if (usr.stat || usr.restrained()) return
	if (href_list["reinfo"])
		reinfo = 0
		usr << "REINFORCEMENTS MOBILIZING."
		availfaction += "STORMTROOPERS"
		for(var/mob/dead/G in world)
			G << "\red \b Distress Signal Sent. Inquisitorial Stormtroopers now available to deploy."

	if (href_list["fire"])
		var/A
		A = input("Area to bombard", "Open Fire", A) in teleportlocs
		var/area/thearea = teleportlocs[A]
		if(src.reload < 180)
			usr << "\red The stargazer is reloading."
			return
		if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
			priority_announce("Imperial Inquisition Lunar Class Cruiser 'Stargazer'. Orders recieved. Firing on your location.")
			message_admins("[key_name_admin(usr)] has launched an orbital strike.", 1)
			var/list/L = list()
			for(var/turf/T in get_area_turfs(thearea.type))
				L+=T
			var/loc = pick(L)
			explosion(loc,2,5,11)
			reload = 0
	if (href_list["submit"])

		if(istype(usr.l_hand, /obj/item/weapon/warrant))
			inspectwarrant(usr)

		else if(istype(usr.r_hand, /obj/item/weapon/warrant))
			inspectwarrant(usr)
		else
			usr << text("<span class='notice'>Hold the warrant in your hand. You'll be asked to press it against the glass.</span>")

/obj/machinery/computer/artillerycontrol/proc/inspectwarrant(mob/user as mob)
	var/satisfied = 0
	if(warrantactive)
		user << text("<span class='notice'>We've already seen the confession. We'll get back to you after we have reviewed the options. Keep an ear to the radio.</span>")
		return
	for(var/obj/item/weapon/warrant/X in user.contents)
		if(X.signed)
			if(X.inqsigned)
				user << text("<span class='notice'>That is just what we need. We'll get back to you after we have reviewed the options. Keep an ear to the radio.</span>")
				satisfied = 1
				warrantactive = 1
				for(var/mob/dead/G in world)
					G << "\red \b Formal accusation against Bradigan completed. Inquisitors now available to decide his fate."
					availfaction += "ORDOHERETICUS"
				return

	if(!satisfied)
		user << text("<span class='notice'>This will not do. You need a signed affidavit implicating Bradigan of heretical acts. Go find us one that is signed by both you and some one credible.</span>")
	return