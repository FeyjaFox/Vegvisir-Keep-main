/proc/accuracy_check(zone, mob/living/user, mob/living/target, associated_skill, datum/intent/used_intent, obj/item/I)
	if(!zone)
		return
	if(user == target)
		return zone
	if(zone == BODY_ZONE_CHEST)
		return zone
	if(target.grabbedby == user)
		if(user.grab_state >= GRAB_AGGRESSIVE)
			return zone
	if(!(target.mobility_flags & MOBILITY_STAND))
		return zone
	if( (target.dir == turn(get_dir(target,user), 180)))
		return zone

	var/chance2hit = 0

	if(check_zone(zone) == zone)
		chance2hit += 10

	if(user.mind)
		chance2hit += (user.mind.get_skill_level(associated_skill) * 7)

	if(used_intent)
		if(used_intent.blade_class == BCLASS_STAB)
			chance2hit += user.STAPER
		if(used_intent.blade_class == BCLASS_CUT)
			chance2hit += round(user.STAPER/2)

	if(I)
		if(I.wlength == WLENGTH_SHORT)
			chance2hit += 10

		chance2hit += ((user.STAPER-10)*5)


	if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
		chance2hit += (user.STAPER)*2
	if(istype(user.rmb_intent, /datum/rmb_intent/swift))
		chance2hit -= 20

	chance2hit = CLAMP(chance2hit, 5, 99)

	if(prob(chance2hit))
		return zone
	else
		if(prob(chance2hit+5))
			if(check_zone(zone) == zone)
				return zone
			else
				if(user.client?.prefs.showrolls)
					to_chat(user, span_warning("Accuracy fail! [chance2hit]%"))
				return check_zone(zone)
		else
			if(user.client?.prefs.showrolls)
				to_chat(user, span_warning("Double accuracy fail! [chance2hit]%"))
			return BODY_ZONE_CHEST

/mob/proc/get_generic_parry_drain()
	return 30

/mob/living/proc/checkmiss(mob/living/user)
	if(user == src)
		return FALSE
	if(stat)
		return FALSE
	if(!(mobility_flags & MOBILITY_STAND))
		return FALSE
	if(user.badluck(4))
		var/list/usedp = list("Critical miss!", "Damn! Critical miss!", "No! Critical miss!", "It can't be! Critical miss!", "Betrayed by lady luck! Critical miss!", "Bad luck! Critical miss!", "Curse creation! Critical miss!", "What?! Critical miss!")
		to_chat(user, span_boldwarning("[pick(usedp)]"))
		flash_fullscreen("blackflash2")
		user.aftermiss()
		return TRUE


/mob/living/proc/checkdefense(datum/intent/intenty, mob/living/user)
	testing("begin defense")
	if(!cmode)
		return FALSE
	if(stat)
		return FALSE
	if(!canparry && !candodge) //mob can do neither of these
		return FALSE
	if(!cmode)
		return FALSE
	if(user == src)
		return FALSE
	if(!(mobility_flags & MOBILITY_MOVE))
		return FALSE

	if(client && used_intent)
		if(client.charging && used_intent.tranged && !used_intent.tshield)
			return FALSE

	var/prob2defend = user.defprob
	var/mob/living/H = src
	var/mob/living/U = user
	if(H && U)
		prob2defend = 0

	if(!can_see_cone(user))
		if(user.alpha < 15 && !HAS_TRAIT(src, TRAIT_BLINDFIGHTING))//For attacks from invisibility.
			return FALSE
		if(d_intent == INTENT_PARRY && !HAS_TRAIT(src, TRAIT_BLINDFIGHTING))
			return FALSE
		if(d_intent == INTENT_DODGE && !HAS_TRAIT(src, TRAIT_BLINDFIGHTING))
			prob2defend = max(prob2defend-15,0)

//	if(!cmode) // not currently used, see cmode check above
//		prob2defend = max(prob2defend-15,0)

	if(m_intent == MOVE_INTENT_RUN)
		prob2defend = max(prob2defend-15,0)

	switch(d_intent)
		if(INTENT_PARRY)
			if(HAS_TRAIT(src, TRAIT_CHUNKYFINGERS))
				return FALSE
			if(pulledby == user && pulledby.grab_state >= GRAB_AGGRESSIVE)
				return FALSE
			if(pulling == user && grab_state >= GRAB_AGGRESSIVE)
				return FALSE
			if(world.time < last_parry + setparrytime)
				if(!istype(rmb_intent, /datum/rmb_intent/riposte))
					return FALSE
			if(has_status_effect(/datum/status_effect/debuff/feinted))
				return FALSE
			if(has_status_effect(/datum/status_effect/debuff/riposted))
				return FALSE
			last_parry = world.time
			if(intenty && !intenty.canparry)
				return FALSE
			var/drained = user.defdrain
			var/draincoeff = 1 //
			var/weapon_parry = FALSE
			var/offhand_defense = 0
			var/mainhand_defense = 0
			var/highest_defense = 0
			var/obj/item/mainhand = get_active_held_item()
			var/obj/item/offhand = get_inactive_held_item()
			var/obj/item/used_weapon = mainhand
			var/obj/item/rogueweapon/shield/buckler/skiller = get_inactive_held_item()  // buckler code
			var/obj/item/rogueweapon/shield/buckler/skillerbuck = get_active_held_item()

			if(istype(offhand, /obj/item/rogueweapon/shield/buckler))
				skiller.bucklerskill(H)
			if(istype(mainhand, /obj/item/rogueweapon/shield/buckler))
				skillerbuck.bucklerskill(H)  //buckler code end

			if(mainhand)
				if(mainhand.can_parry)
					mainhand_defense += (H.mind ? (H.mind.get_skill_level(mainhand.associated_skill) * 20) : 20)
					mainhand_defense += (mainhand.wdefense * 10)
					draincoeff += H.mind.get_skill_level(mainhand.associated_skill)
			if(offhand)
				if(offhand.can_parry)
					offhand_defense += (H.mind ? (H.mind.get_skill_level(offhand.associated_skill) * 20) : 20)
					offhand_defense += (offhand.wdefense * 10)
					draincoeff += H.mind.get_skill_level(offhand.associated_skill)

			if(mainhand_defense >= offhand_defense)
				highest_defense += mainhand_defense
			else
				used_weapon = offhand
				highest_defense += offhand_defense

			var/defender_skill = 0
			var/attacker_skill = 0

			if(highest_defense <= (H.mind ? (H.mind.get_skill_level(/datum/skill/combat/unarmed) * 20) : 20))
				defender_skill = H.mind?.get_skill_level(/datum/skill/combat/unarmed)
				prob2defend += (defender_skill * 20)
				weapon_parry = FALSE
			else
				defender_skill = H.mind?.get_skill_level(used_weapon.associated_skill)
				prob2defend += highest_defense
				weapon_parry = TRUE

			if(U.mind)
				if(intenty.masteritem)
					attacker_skill = U.mind.get_skill_level(intenty.masteritem.associated_skill)
					prob2defend -= (attacker_skill * 20)
					if((intenty.masteritem.wbalance > 0) && (user.STASPD > src.STASPD)) //enemy weapon is quick, so get a bonus based on spddiff
						prob2defend -= ( intenty.masteritem.wbalance * ((user.STASPD - src.STASPD) * 10) )
				else
					attacker_skill = U.mind.get_skill_level(/datum/skill/combat/unarmed)
					prob2defend -= (attacker_skill * 20)

			// parrying while knocked down sucks ass
			if(!(mobility_flags & MOBILITY_STAND))
				prob2defend *= 0.65
			prob2defend = clamp(prob2defend, 5, 95)//The counter to parrying is feinting
			if(src.client?.prefs.showrolls)
				to_chat(src, span_info("Roll to parry... [prob2defend]%"))

			if(prob(prob2defend))
				if(intenty.masteritem)
					if(intenty.masteritem.wbalance < 0 && user.STASTR > src.STASTR) //enemy weapon is heavy, so get a bonus scaling on strdiff
						drained = drained + ( intenty.masteritem.wbalance * ((user.STASTR - src.STASTR) * -5) )
			else
				to_chat(src, span_warning("The enemy defeated my parry!"))
				return FALSE

			drained = (max(drained, 5) / draincoeff)//Two-weapon fighters armed with one-handed weapons they are skilled in can gain a steep defensive advantage. In riposte stance, they
			var/exp_multi = 1

			if(!U.mind)
				exp_multi = exp_multi/2
			if(istype(user.rmb_intent, /datum/rmb_intent/weak))
				exp_multi = exp_multi/2

			if(weapon_parry == TRUE)
				if(do_parry(used_weapon, drained, user)) //show message
					if((mobility_flags & MOBILITY_STAND) && can_train_combat_skill(src, used_weapon.associated_skill, attacker_skill - SKILL_LEVEL_NOVICE))
						mind.adjust_experience(used_weapon.associated_skill, max(round(STAINT/2), 0), FALSE)
					// defender skill gain
					if((mobility_flags & MOBILITY_STAND) && attacker_skill && (defender_skill < attacker_skill - SKILL_LEVEL_NOVICE))
						// No duping exp gains by attacking with a shield on active hand
						if(used_weapon == offhand && istype(used_weapon, /obj/item/rogueweapon/shield))
							// Most shield users aren't bright, let's not make it near impossible to learn
							H.mind?.adjust_experience(/datum/skill/combat/shields, max(round(STAINT - 3), 0), FALSE)
						else
							H.mind?.adjust_experience(used_weapon.associated_skill, max(round(STAINT), 0), FALSE)

					var/obj/item/AB = intenty.masteritem

					//attacker skill gain

					if(U.mind)
						var/attacker_skill_type
						if(AB)
							attacker_skill_type = AB.associated_skill
						else
							attacker_skill_type = /datum/skill/combat/unarmed
						if((U.mobility_flags & MOBILITY_STAND) && can_train_combat_skill(U, attacker_skill_type, defender_skill - SKILL_LEVEL_NOVICE))
							U.mind.adjust_experience(attacker_skill_type, max(round(STAINT/2), 0), FALSE)
						if((U.mobility_flags & MOBILITY_STAND) && defender_skill && (attacker_skill < defender_skill - SKILL_LEVEL_NOVICE))
							if(AB)
								U.mind.adjust_experience(AB.associated_skill, max(round(U.STAINT), 0), FALSE)
							else
								U.mind.adjust_experience(/datum/skill/combat/unarmed, max(round(STAINT), 0), FALSE)

					if(prob(66) && AB)
						if((used_weapon.flags_1 & CONDUCT_1) && (AB.flags_1 & CONDUCT_1))
							flash_fullscreen("whiteflash")
							user.flash_fullscreen("whiteflash")
							var/datum/effect_system/spark_spread/S = new()
							var/turf/front = get_step(src,src.dir)
							S.set_up(1, 1, front)
							S.start()
						else
							flash_fullscreen("blackflash2")
					else
						flash_fullscreen("blackflash2")

					var/dam2take = round((get_complex_damage(AB,user,used_weapon.blade_dulling)/2),1)
					if(dam2take)
						used_weapon.take_damage(max(dam2take,1), BRUTE, used_weapon.d_type)
					return TRUE
				else
					return FALSE

			if(weapon_parry == FALSE)
				if(do_unarmed_parry(drained, user))
					if((mobility_flags & MOBILITY_STAND) && can_train_combat_skill(H, /datum/skill/combat/unarmed, attacker_skill - SKILL_LEVEL_NOVICE))
						H.mind?.adjust_experience(/datum/skill/combat/unarmed, max(round(STAINT/2), 0), FALSE)
					if((mobility_flags & MOBILITY_STAND) && attacker_skill && (defender_skill < attacker_skill - SKILL_LEVEL_NOVICE))
						H.mind?.adjust_experience(/datum/skill/combat/unarmed, max(round(STAINT), 0), FALSE)
					flash_fullscreen("blackflash2")
					return TRUE
				else
					testing("failparry")
					return FALSE
		if(INTENT_DODGE)
			if(pulledby && pulledby.grab_state >= GRAB_AGGRESSIVE)
				return FALSE
			if(pulling == user)
				return FALSE
			if(world.time < last_dodge + dodgetime)
				if(!istype(rmb_intent, /datum/rmb_intent/riposte))
					return FALSE
			if(has_status_effect(/datum/status_effect/debuff/riposted))
				return FALSE
			last_dodge = world.time
			if(src.loc == user.loc)
				return FALSE
			if(intenty)
				if(!intenty.candodge)
					return FALSE
			if(candodge)
				var/list/dirry = list()
				var/dx = x - user.x
				var/dy = y - user.y
				if(abs(dx) < abs(dy))
					if(dy > 0)
						dirry += NORTH
						dirry += WEST
						dirry += EAST
					else
						dirry += SOUTH
						dirry += WEST
						dirry += EAST
				else
					if(dx > 0)
						dirry += EAST
						dirry += SOUTH
						dirry += NORTH
					else
						dirry += WEST
						dirry += NORTH
						dirry += SOUTH
				var/turf/turfy
				for(var/x in shuffle(dirry.Copy()))
					turfy = get_step(src,x)
					if(turfy)
						if(turfy.density)
							continue
						for(var/atom/movable/AM in turfy)
							if(AM.density)
								continue
						break
				if(pulledby)
					return FALSE
				if(!turfy)
					to_chat(src, span_boldwarning("There's nowhere to dodge to!"))
					return FALSE
				else
					if(do_dodge(user, turfy))
						flash_fullscreen("blackflash2")
						user.aftermiss()
						return TRUE
					else
						return FALSE
			else
				return FALSE

/mob/proc/do_parry(obj/item/W, parrydrain as num, mob/living/user)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.rogfat_add(parrydrain))
			if(W)
				playsound(get_turf(src), pick(W.parrysound), 100, FALSE)
			if(istype(rmb_intent, /datum/rmb_intent/riposte))
				src.visible_message(span_boldwarning("<b>[src]</b> ripostes [user] with [W]!"))
			else
				src.visible_message(span_boldwarning("<b>[src]</b> parries [user] with [W]!"))
			return TRUE
		else
			to_chat(src, span_warning("I'm too tired to parry!"))
			return FALSE //crush through
	else
		if(W)
			playsound(get_turf(src), pick(W.parrysound), 100, FALSE)
		return TRUE

/mob/proc/do_unarmed_parry(parrydrain as num, mob/living/user)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.rogfat_add(parrydrain))
			playsound(get_turf(src), pick(parry_sound), 100, FALSE)
			src.visible_message(span_warning("<b>[src]</b> parries [user]!"))
			return TRUE
		else
			to_chat(src, span_boldwarning("I'm too tired to parry!"))
			return FALSE
	else
		playsound(get_turf(src), pick(parry_sound), 100, FALSE)
		return TRUE


/mob/proc/do_dodge(mob/user, turf/turfy)
	if(dodgecd)
		return FALSE
	var/mob/living/L = src
	var/mob/living/U = user
	var/mob/living/carbon/human/H
	var/mob/living/carbon/human/UH
	var/obj/item/I
	var/drained = 10
	if(ishuman(src))
		H = src
	if(ishuman(user))
		UH = user
		I = UH.used_intent.masteritem
	var/prob2defend = U.defprob
	if(L.rogfat >= L.maxrogfat)
		return FALSE
	if(L)
		if(H?.check_dodge_skill())
			prob2defend = prob2defend + (L.STASPD * 15)
		else
			prob2defend = prob2defend + (L.STASPD * 10)
	if(U)
		prob2defend = prob2defend - (U.STASPD * 10)
	if(I)
		if(I.wbalance > 0 && U.STASPD > L.STASPD) //nme weapon is quick, so they get a bonus based on spddiff
			prob2defend = prob2defend - ( I.wbalance * ((U.STASPD - L.STASPD) * 10) )
		if(I.wbalance < 0 && L.STASPD > U.STASPD) //nme weapon is slow, so its easier to dodge if we're faster
			prob2defend = prob2defend + ( I.wbalance * ((U.STASPD - L.STASPD) * -10) )
		if(UH?.mind)
			prob2defend = prob2defend - (UH.mind.get_skill_level(I.associated_skill) * 10)
	if(H)
		if(!H?.check_armor_skill())
			H.Knockdown(1)
			return FALSE
//Dreamkeep Change -- Re-enabled alongside the addition of skill-based reduction of parry costs.
			if(H?.check_dodge_skill())
				drained = drained - 5

		if(I) //the enemy attacked us with a weapon
			if(!I.associated_skill) //the enemy weapon doesn't have a skill because its improvised, so penalty to attack
				prob2defend = prob2defend + 10
			else
				if(H.mind)
					prob2defend = prob2defend + (H.mind.get_skill_level(I.associated_skill) * 10)
				/* Commented out due to encumbrance being seemingly broken and nonfunctional
				var/thing = H.encumbrance
				if(thing > 0)
					drained = drained + (thing * 10)
				*/
		else //the enemy attacked us unarmed or is nonhuman
			if(UH)
				if(UH.used_intent.unarmed)
					if(UH.mind)
						prob2defend = prob2defend - (UH.mind.get_skill_level(/datum/skill/combat/unarmed) * 10)
					if(H.mind)
						prob2defend = prob2defend + (H.mind.get_skill_level(/datum/skill/combat/unarmed) * 10)
		// dodging while knocked down sucks ass
		if(!(L.mobility_flags & MOBILITY_STAND))
			prob2defend *= 0.25
		prob2defend = clamp(prob2defend, 5, 95)//The counter to Dodging is swift attacks to drain stamina
		if(client?.prefs.showrolls)
			to_chat(src, span_info("Roll to dodge... [prob2defend]%"))
		if(!prob(prob2defend))
			return FALSE
		if(!H.rogfat_add(max(drained,5)))
			to_chat(src, span_warning("I'm too tired to dodge!"))
			return FALSE
	else //we are a non human
		prob2defend = clamp(prob2defend, 5, 90)
		if(client?.prefs.showrolls)
			to_chat(src, span_info("Roll to dodge... [prob2defend]%"))
		if(!can_see_cone(user) || user.alpha <=15)
			if(!HAS_TRAIT(src, TRAIT_BLINDFIGHTING))
				prob2defend = 5//Have to roll a nat 20 to dodge an attack we can't sense coming.
		if(!prob(prob2defend))
			return FALSE
	dodgecd = TRUE
	playsound(src, 'sound/combat/dodge.ogg', 100, FALSE)
	throw_at(turfy, 1, 2, src, FALSE)
	if(drained > 0)
		src.visible_message(span_warning("<b>[src]</b> dodges [user]'s attack!"))
	else
		src.visible_message(span_warning("<b>[src]</b> easily dodges [user]'s attack!"))
	dodgecd = FALSE
//		if(H)
//			if(H.IsOffBalanced())
//				H.Knockdown(1)
//				to_chat(H, span_danger("I tried to dodge off-balance!"))
//		if(isturf(loc))
//			var/turf/T = loc
//			if(T.landsound)
//				playsound(T, T.landsound, 100, FALSE)
	return TRUE

/mob/proc/food_tempted(/obj/item/W, mob/user)
	return

/mob/proc/taunted(mob/user)
	return

/mob/proc/shood(mob/user)
	return

/mob/proc/beckoned(mob/user)
	return

/mob/proc/get_punch_dmg()
	return


/mob/proc/add_family_hud(antag_hud_type, antag_hud_name)
	var/datum/atom_hud/antag/hud = GLOB.huds[antag_hud_type]
	hud.join_hud(src)
	set_antag_hud(src, antag_hud_name)


/mob/proc/remove_family_hud(antag_hud_type)
	var/datum/atom_hud/antag/hud = GLOB.huds[antag_hud_type]
	hud.leave_hud(src)
	set_antag_hud(src, null)