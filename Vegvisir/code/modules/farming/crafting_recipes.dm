/datum/crafting_recipe/roguetown/structure/composter
	name = "composter"
	result = /obj/structure/composter
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "build"
	verbage = "builds"
	craftdiff = 0
	time = 2 SECONDS

/datum/crafting_recipe/roguetown/wheatflour
	name = "flour (wheat)"
	result = /obj/item/reagent_containers/powder/flour
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)
	structurecraft = /obj/structure/fluff/millstone
	verbage_simple = "mill"
	verbage = "mills"
	craftdiff = -2
	time = 3

/datum/crafting_recipe/roguetown/oatflour
	name = "flour (oat)"
	result = /obj/item/reagent_containers/powder/flour
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/oat = 1)
	structurecraft = /obj/structure/fluff/millstone
	verbage_simple = "mill"
	verbage = "mills"
	craftdiff = -2
	time = 3

/*/datum/crafting_recipe/roguetown/sugar
	name = "sugar"
	result = /obj/item/reagent_containers/powder/sugar
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/sugarcane = 1)
	structurecraft = /obj/structure/fluff/millstone
	verbage_simple = "mill"
	verbage = "mills"
	craftdiff = -2
	time = 3

 /datum/crafting_recipe/roguetown/saltpowder
	name = "ground salt"
	result = /obj/item/reagent_containers/powder/salt
	reqs = list(/obj/item/natural/stone = 1)
	structurecraft = /obj/structure/fluff/millstone
	verbage_simple = "mill"
	verbage = "mills"
	craftdiff = -2
	time = 4 */

/datum/crafting_recipe/roguetown/sandpowder
	name = "ground sand"
	result = /obj/item/rogueore/sand
	reqs = list(/obj/item/natural/stone = 1)
	structurecraft = /obj/structure/fluff/millstone
	verbage_simple = "mill"
	verbage = "mills"
	craftdiff = -2
	time = 4


/datum/crafting_recipe/roguetown/structure/plough
	name = "plough"
	result = /obj/structure/plough
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/iron = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	skillcraft = /datum/skill/craft/carpentry
	time = 4 SECONDS

/datum/crafting_recipe/roguetown/dryleaf
	name = "dry swampweed"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/sweetleafdry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/sweetleaf = 1)
	structurecraft = /obj/structure/fluff/dryingrack
	time = 2 SECONDS
	verbage_simple = "dry"
	verbage = "dries"
	craftsound = null
	skillcraft = null

/datum/crafting_recipe/roguetown/sigsweet
	name = "swampweed zig"
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/sweetleafdry = 1,
				/obj/item/paper/scroll = 1)
	req_table = TRUE
	time = 10 SECONDS
	verbage_simple = "roll"
	verbage = "rolls"
	craftdiff = 0

/datum/crafting_recipe/roguetown/dryweed
	name = "dry westleach leaf"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	structurecraft = /obj/structure/fluff/dryingrack
	time = 2 SECONDS
	verbage_simple = "dry"
	verbage = "dries"
	craftsound = null
	skillcraft = null

/datum/crafting_recipe/roguetown/sigdry
	name = "westleach zig"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
				/obj/item/paper/scroll = 1)
	req_table = TRUE
	time = 10 SECONDS
	verbage_simple = "roll"
	verbage = "rolls"
	craftdiff = 0