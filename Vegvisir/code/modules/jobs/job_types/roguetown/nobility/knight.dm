/datum/job/roguetown/knight
	title = "Knight"
	flag = KNIGHT
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	allowed_races = RACES_ALL_KINDSPLUS
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	allowed_patrons = ALL_DIVINE_PATRONS
	tutorial = "A knight with expert training; Born in a far away land and raised as a squire from a young age, now you make Stone Hedge your home. It is up to you to decide what path you will take, and who you may call your Lord."
	display_order = JDO_KNIGHT
	whitelist_req = FALSE
	outfit = /datum/outfit/job/roguetown/knight
	give_bank_account = 22
	min_pq = 0
	max_pq = null

	cmode_music = 'sound/music/combat_guard2.ogg'

/datum/job/roguetown/knight/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/knight/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "knight tabard ([index])"
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Sir"
		if(H.gender == FEMALE)
			honorary = "Dame"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

/datum/outfit/job/roguetown/knight/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/platelegs
	cloak = /obj/item/clothing/cloak/tabard/knight/guard
	neck = /obj/item/clothing/neck/roguetown/bervor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	beltr = /obj/item/rogueweapon/sword/long
	beltl = /obj/item/storage/keyring/guardcastle
	belt = /obj/item/storage/belt/rogue/leather/hand
	backr = /obj/item/storage/backpack/rogue/satchel/black
	if(prob(50))
		r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
	else
		r_hand = /obj/item/rogueweapon/mace/goden/steel
	if(H.mind)
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE) //Knight should NOT be 1 skill level away from Legenedary skills across fucking 3 weapon skills.
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 3, TRUE) //Already Expert at Swords, polearms and crossbows. 5 - master, 4 - Expert.
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/maces, 3, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 4, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 4, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 4, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/combat/bows, 3, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/climbing, 1, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/reading, 3, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/riding, 4, TRUE)
		H.change_stat("strength", 4)
		H.change_stat("perception", 1)
		H.change_stat("intelligence", 2)
		H.change_stat("constitution", 3)
		H.change_stat("endurance", 2)
		H.change_stat("speed", -1)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC) //These traits are fine? Needs a reducation else where. Likely equipment could do with a reduction.