/datum/job/roguetown/beggar
	title = "Low-life"
	flag = BEGGAR
	department_flag = PEASANTS
	faction = "Station"
	total_positions = -1
	spawn_positions = -1

	allowed_races = RACES_ALL_KINDSPLUS
	allowed_ages = ALL_AGES_LIST
	outfit = /datum/outfit/job/roguetown/vagrant
	bypass_lastclass = TRUE
	banned_leprosy = FALSE
	min_pq = -30
	max_pq = null

	tutorial = "The stench of your piss-laden clothes dont bug you anymore, the glances of disgust and loathing others give you is just a friendly greeting; the only reason you've not been killed already is because Volfs are known to be repelled by decaying flesh. You're going to be a solemn reminder what happens when something unwanted is born into this world."
	display_order = JDO_VAGRANT
	show_in_credits = FALSE
	can_random = FALSE

	cmode_music = 'sound/music/combat_bum.ogg'

	/// Chance to become a wise beggar, if we still have space for more wise beggars
	var/wise_chance = 10
	/// Amount of wise beggars spawned as of now
	var/wise_amount = 0
	/// Maximum amount of wise beggars that can be spawned
	var/wise_max = 3
	/// Outfit to use when wise beggar triggers
	var/wise_outfit = /datum/outfit/job/roguetown/vagrant/wise

/datum/job/roguetown/beggar/New()
	. = ..()
	peopleknowme = list()

/datum/job/roguetown/beggar/get_outfit(mob/living/carbon/human/wearer, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, preference_source = null)
	if((wise_amount < wise_max) && prob(wise_chance))
		wise_amount++
		return wise_outfit
	return ..()

/datum/outfit/job/roguetown/vagrant/pre_equip(mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NASTY_EATER, TRAIT_GENERIC)
	// wise beggar!!!
	// guaranteed full beggar gear + random stats
	if(is_wise)
		head = /obj/item/clothing/head/roguetown/wizhat/gen/wise //wise hat
		backr = /obj/item/storage/backpack/rogue/satchel
		belt = /obj/item/storage/belt/rogue/leather
		beltr = /obj/item/reagent_containers/powder/moondust
		beltl = /obj/item/clothing/mask/cigarette/rollie/cannabis
		cloak = /obj/item/clothing/cloak/raincloak/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		shoes = /obj/item/clothing/shoes/roguetown/shalal // wise boots
		r_hand = /obj/item/rogueweapon/woodstaff/wise // dog beating staff
		l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/special // dog butchering knife
		if(H.mind)
			H.mind.adjust_skillrank_up_to(/datum/skill/misc/sneaking, rand(4,5), TRUE)
			H.mind.adjust_skillrank_up_to(/datum/skill/misc/stealing, 5, TRUE)
			H.mind.adjust_skillrank_up_to(/datum/skill/misc/climbing, rand(4,5), TRUE)
			H.mind.adjust_skillrank_up_to(/datum/skill/misc/reading, 4, TRUE) //very good reading he is wise
			H.mind.adjust_skillrank_up_to(/datum/skill/combat/polearms, rand(4,5), TRUE) // dog beating staff
			H.STASTR = rand(9, 20)
			H.STAINT = rand(9, 20)
			H.STALUC = rand(9, 20)
		H.real_name = "[H.real_name] the Wise"
		H.name = "[H.name] the Wise"
		H.facial_hairstyle = "Knowledge"
		H.update_hair()
		H.age = AGE_OLD
		return
	if(prob(20))
		head = /obj/item/clothing/head/roguetown/knitcap
	else
		head = null
	if(prob(5))
		beltr = /obj/item/reagent_containers/powder/moondust
	else
		beltr = null
	if(prob(10))
		beltl = /obj/item/clothing/mask/cigarette/rollie/cannabis
	else
		beltl = null
	if(prob(10))
		cloak = /obj/item/clothing/cloak/raincloak/brown
	else
		cloak = null
	if(prob(10))
		gloves = /obj/item/clothing/gloves/roguetown/fingerless
	else
		gloves = null
	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else
		armor = null
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	if(H.mind)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/sneaking, rand(3,5), TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/stealing, 5, TRUE)
		H.mind.adjust_skillrank_up_to(/datum/skill/misc/climbing, rand(3,5), TRUE)
		H.STALUC = rand(9, 20)
	if(prob(5))
		r_hand = /obj/item/rogueweapon/mace/woodclub
	else
		r_hand = null
	if(prob(5))
		l_hand = /obj/item/rogueweapon/mace/woodclub
	else
		l_hand = null
	H.mind?.adjust_skillrank(/datum/skill/misc/lockpicking, pick(1,2,3,4,5), TRUE) //random lockpicking skill cool.
	H.change_stat("strength", 1)
	H.change_stat("constitution", 2) // look I get it human garbage. but no ones playing this shit with that.
	H.change_stat("endurance", 1)
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	backpack_contents = list(/obj/item/lockpickring/mundane)
	ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NASTY_EATER, TRAIT_GENERIC)
	H.grant_language(/datum/language/thievescant)

/datum/outfit/job/roguetown/vagrant
	name = "Low Life"
	/// Whether or not we get wise gear and stats
	var/is_wise = FALSE

/datum/outfit/job/roguetown/vagrant/wise
	name = "Wise Beggar"
	is_wise = TRUE