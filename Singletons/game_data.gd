extends Node

# rate_of_fire - how many times per second the tower can fire
var tower_data = {
	"GunT1": {
		"damage": 20,
		"rate_of_fire": 0.3,
		"range": 350,
		"category": "bullet",
	},
	"GunT2": {
		"damage": 40,
		"rate_of_fire": 1,
		"range": 450,
		"category": "bullet",
	},
	"MissileT1": {
		"damage": 100,
		"rate_of_fire": 3,
		"range": 550,
		"category": "missile",
	},
}
