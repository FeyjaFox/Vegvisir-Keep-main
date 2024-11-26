//human treesbane

/datum/advclass/masterwoodcutter
	name = "Master Lumberjack"
	tutorial = "The strongest and wisest Lumberjack, trained in the art of both chopping and transforming wood. \
	With your mighty hands you chopped countless trees, Dendor fears you, the elves tell the children stories about you, \
	so they don't wander in the forest."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDSPLUS
	outfit = /datum/outfit/job/roguetown/adventurer/masterwoodcutter
	maximum_possible_slots = 1
	pickprob = 5

	category_tags = list(CTAG_DISABLED)
	
	
/datum/outfit/job/roguetown/adventurer/masterwoodcutter/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind.adjust_skillrank_up_to(/datum/skill/combat/axes, 6, TRUE) // AXE MEN! GIVE ME SPLINTERS!
	H.mind.adjust_skillrank_up_to(/datum/skill/misc/athletics, 4, TRUE) 
	H.mind.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 3, TRUE)
	H.mind.adjust_skillrank_up_to(/datum/skill/misc/swimming, 2, TRUE)
	H.mind.adjust_skillrank_up_to(/datum/skill/misc/climbing, 3, TRUE)
	H.mind.adjust_skillrank_up_to(/datum/skill/craft/crafting, 4, TRUE)
	H.mind.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 4, TRUE)
	H.mind.adjust_skillrank_up_to(/datum/skill/craft/engineering, 1, TRUE)
	H.mind.adjust_skillrank_up_to(/datum/skill/misc/sewing, 1, TRUE)
	H.mind.adjust_skillrank_up_to(/datum/skill/labor/butchering, 1, TRUE)
	H.mind.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, 6, TRUE)
	H.mind.adjust_skillrank_up_to(/datum/skill/craft/traps, 2, TRUE)
	H.mind.adjust_skillrank_up_to(/datum/skill/misc/medicine, 2, TRUE)
	belt = /obj/item/storage/belt/rogue/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	pants = /obj/item/clothing/under/roguetown/trou
	head = /obj/item/clothing/head/roguetown/hatfur
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backr = /obj/item/storage/backpack/rogue/backpack
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black 
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut
	beltl = /obj/item/rogueweapon/huntingknife
	backpack_contents = list(/obj/item/flint = 1)
	H.change_stat("strength", 3)
	H.change_stat("constitution", 1)
	H.change_stat("perception", 1)
	H.change_stat("intelligence", 2)
	H.change_stat("endurance", 1)
