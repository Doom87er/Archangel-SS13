
var/global/list/roundevents = list() //yet another root level list which keeps track of major round events. This one will be more useful to us than any of the others however. -da norc




/obj/machinery/EWradar			//This will be our template
	name = "EW template"
	desc = "This is not supposed to exist."
	icon = 'icons/obj/machines/electronicwarfare.dmi'				//I figured I would replace this later
	icon_state = "null"
	var/icon_on = "null"
	density = 1
	var/on = 0									//very important button
	anchored = 0
	use_power = 1
	idle_power_usage = 1
	active_power_usage = 1						//Currently in the off position. More to follow later
	var/effect = "This is a placeholder effect"		//This is for display screen purposes.
	var/powercost = 0								//indevidual to each machine
	var/health = 100
	var/localpower = 0

	proc/checkWirePower()
		var/obj/structure/cable/attached = null
		var/turf/T = loc
		if(isturf(T))
			attached = locate() in T
		if(!attached)
			return 0
		var/datum/powernet/PN = attached.get_powernet()
		if(!PN)
			return 0
		var/tempz = PN.avail
		if(tempz < powercost)
			return 0
		return 1

/obj/machinery/EWradar/proc/purpose()

/obj/machinery/EWradar/proc/sit_idle()

/obj/machinery/EWradar/power_change()
	if (powered() && anchored && on)
		purpose()					//each machine will have a purpose and a walk down from that purpose
	else
		sit_idle()
	src.updateUsrDialog()

/obj/machinery/EWradar/interact(mob/user)	//No idea what we have a middleman proc right here
	if(..())
		return
	regular_win(user)
	return

/obj/machinery/EWradar/attack_paw(mob/user)		//tyranids can easilly turn this off for some reason. I kinda like it.
	return attack_hand(user)

/obj/machinery/EWradar/attack_hand(mob/user)
	if(..())
		return
	if(user.faction != "RADARTECHS")								//Not a radar tech- we don't want to hear it.
		usr << "\red You have like... no idea. I mean what even is this thing?"
		return
	interact(user)

/obj/machinery/EWradar/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/weapon/wrench))
		if(on)
			on = 0
			power_change()
		if(!anchored && !isinspace())
			user << "\blue You secure the generator to the floor."
			anchored = 1
		else if(anchored)
			user << "\blue You unsecure the generator from the floor."
			anchored = 0
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)

	src.updateUsrDialog()

/obj/machinery/EWradar/Topic(href, href_list)
	if(..())
		return

	if(href_list["poweron"])
		active_power_usage = powercost
		on = 1
		power_change()



	if(href_list["poweroff"])
		active_power_usage = 1
		on = 0
		power_change()

	src.updateUsrDialog()
	return

/obj/machinery/EWradar/proc/regular_win(mob/user)
	if(anchored)
		if(!checkWirePower())
			localpower = "Insufficiant power"
		else
			localpower = "Sufficiant Power"
	var/dat
	dat += "Self diagnostic complete. [name] is funtional.<BR>"
	dat += "[localpower] is available. This device requires [powercost]<BR>"
	if(anchored)
		dat += "Device is bolter to the floor.<BR>"
	if(!anchored)
		dat += "Device is unbolted and ready to be moved.<BR>"
	if(on)
		dat += "Power is currently: <A href='byond://?src=\ref[src];poweroff=1'>On</A><BR>"
		dat += "<b>[effect]</b><BR>"
		dat += "<br>"
		dat += "</span>"
	else
		dat += "Power is currently: <A href='byond://?src=\ref[src];poweron=1'>Off</A><BR>"

	var/datum/browser/popup = new(user, "autolathe", name, 400, 500)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/EWradar/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	if(health <=0)
		visible_message("\red The [src] detonates!")
		on = 0
		power_change()
		sleep(10)
		explosion(src.loc, 1, 1, 1, 1)
		return

/*
Stealth Jammer
*/

/obj/machinery/EWradar/scanner
	name = "Monocular Retrograde"
	desc = "A device which ionizes and deionizes particulars in a large area causing tachyon disperal."
	icon_state = "sjammer"
	icon_on = "sjammeron"
	effect = "In range stealth modules: Painted."		//This is for display screen purposes.
	powercost = 150000								//indevidual to each machine
	var/listword = "STEALTHJAMMED"

	purpose()
		icon_state = icon_on
		roundevents.Add(listword)
		radarintercept("<font color='red'> 60hz cycle artifact</font>")

	sit_idle()
		icon_state = "sjammer"
		roundevents.Remove(listword)


/*
Exterminatus Jammer
*/

/obj/machinery/EWradar/jammer
	name = "Digital Channel Alternation"
	desc = "A device which rapidly cycles through FOF frequencies in order to confuse self guided ordinance."
	icon_state = "fc"
	icon_on = "fc_on"
	effect = "Orbital Weaponry: Delayed."
	powercost = 200000
	var/listword = "EXTERMJAMMED"

	purpose()
		icon_state = icon_on
		roundevents.Add(listword)
		radarintercept("<font color='red'>Dull clicking sound</font>")


	sit_idle()
		icon_state = "fc"
		roundevents.Remove(listword)

/*
Exterminatus Jammer
*/

/obj/machinery/EWradar/transmitter
	name = "Long Range Echo Collector"
	desc = "A device which adopts local relays in order to greatly extend distress signals."
	icon_state = "re"
	icon_on = "re_on"
	effect = "Solar Assets: Alerted to sitution."
	powercost = 500000


	purpose()
		icon_state = icon_on
		availfaction += "RAVENGUARD"
		radarintercept("<font color='red'>AA4, Shots on the ground, AA4, Shots on the ground, Flag Company, Shots on the ground.</font>")


	sit_idle()
		icon_state = "re"
		availfaction -= "RAVENGUARD"

//place "EXTERMJAMMED" check in exterminatus

//manuals for radar opperators (detailing proper use)

/obj/item/weapon/book/manual/radartech
	name = "IEW field opperations manual"
	icon_state = "combat"
	author = "Segmentum Command"
	title = "IEW field opperations manual"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
        h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>

				<h1>Imperial Electronic Warfare Field Opperations Manual: IEWFOM</h1>

				<h2>Chapters</h2>

				<ol>
					<li><a href="#Start">EYES ONLY</a></li>
					<li><a href="#LLA">Stipulations</a></li>
					<li><a href="#likethem">Power Consumption</a></li>
					<li><a href="#castout">Monocular Retrograde</a></li>
					<li><a href="#revenge">Digital Channel Alternation</a></li>
					<li><a href="#revolution">Long Range Echo Collector</a></li>
				</ol>


				<h2><a name="Start">EYES ONLY</h2>

				This document is approved by Segmentum Command; Sectorus Mechanicum; for proper use and limited opperation of assets EW33M - EW92K. This document can not be copied or unsecured with out direct authority from Callium Opperations Assignment.All opperators must hold a K7 license or above. Failure to comply with these guidelines will result in review and termination of any/all license(s) issued. Other penalties may be applied by Mechanicus representatives.

				<h2><a name="LLA">Stipulations</h2>
				All devices which are labelled SL-19 or superceding are assigned, not alotted to the regiment. Limited maintenace may be performed including (but may not exceed) cleaning of the case, cycling power and use of administrator account. At no time is the case to be opened or altered. If damage occurs to the device, the device MUST be returned to Uniform31 personel for repair. The device will not be repaired in the field. The device will not be sold, traded, altered or stored in unsecured facilities. If stolen, the theft MUST be reported to Sectorus Machanicum immediately.


				<h2><a name="likethem">Power Consumption</h2>
				These devices require a substantial amount of power in order to opperate. Every Liscensee will be equipped and trained in the use of a crowbar, gloves and multitool to better facilitate the opperation of these devices. Understanding your power requirements and running cable to your (strategically located) devices is essential for proper use. Once you have a wire that is prepared to deliver the proper amount of power, place the device over it's location and wrench the device into place.

				<h2><a name="castout">Monocular Retrograde</h2>
				The Monocular Retrograde destabilizes ionized tachyons in the environment cuasing an electromagnetic drain field on commonly use XenoTechnology. The magnectic charge of these particals has the added benifit of outlining all organic intruders and making it harder for them to use stealth tactics.

				<h2><a name="revenge">Digital Channel Alternation</h2>
				Commonly used in Naval battles- The Digital Channel Alternation Device cycles through all digital radio frequencies at 1per 1/10th microsecond, broadcasting fake FOF 'friend or foe' signals which contain random range and motion data. This makes it difficult for large 'self guided' ordinance to target and track your location from any extended distance and forces the enemy to retrofit their weaponry.

				<h2><a name="revolution">Long Range Echo Collector</h2>
				The Long Range Echo Collector distributes and analyzes small subspace bursts of data in order to find open radio transceivers. Building from a map of contacts, the device is then able to increase it's transmission range anywhere from 10% to 640% depending on the size of the transmission and availability of contacts.

        </body>
		</html>
		"}
