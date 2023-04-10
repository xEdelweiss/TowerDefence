extends Node

func _ready():
	load_main_menu()

func load_main_menu():
	get_node("MainMenu/MarginContainer/VBoxContainer/NewGame").connect("pressed", self.on_new_game_pressed)
	get_node("MainMenu/MarginContainer/VBoxContainer/Quit").connect("pressed", self.on_quit_pressed)

func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = (load("res://Scenes/MainScenes/game_scene.tscn") as PackedScene).instantiate() as GameScene
	game_scene.on_game_finished.connect(self.unload_game)
	add_child(game_scene)

func on_quit_pressed():
	get_tree().quit()

func unload_game(win: bool):
	get_node("GameScene").queue_free()
	var main_menu = load("res://Scenes/UIScenes/main_menu.tscn").instantiate()
	add_child(main_menu)
	load_main_menu()
