extends Node2D

var easy = 1.4
var normal = 2
var hard = 2.2
var insane = 2.3
var impossible = 2.5
var unlocked_levels = 1

func aventureExist() -> bool:
	return(FileAccess.file_exists("user://aventure.txt"))

func createaventureFile(unlocked_levels):
	var file = FileAccess.open("user://aventure.txt", FileAccess.WRITE)
	var json_to_save = JSON.stringify({"unlocked_levels":unlocked_levels})
	file.store_line(json_to_save)
	file.close()
	
func loadaventureFile():
	var file = FileAccess.open("user://aventure.txt", FileAccess.READ)
	return (JSON.parse_string(file.get_line()))["unlocked_levels"] 

func _ready():
	if not aventureExist():
		createaventureFile(1)
	unlocked_levels = loadaventureFile()
	
	for i in range (unlocked_levels):
		get_node("ScrollContainer/VBoxContainer").get_child(i).visible = true

func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")


func _on_button_pressed():
	GlobalVARS.song = "My Chemical Romance - Helena (8-bit Cover).mp3"
	GlobalVARS.json_file_name = "My Chemical Romance - Helena (8-bit Cover).json"
	GlobalVARS.diff = normal
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
	
func _on_button_2_pressed():
	GlobalVARS.song = "Teenage Mutant Ninja Turtles Theme Song 8 Bit Remix Cover Version 8 Bit Universe.mp3"
	GlobalVARS.json_file_name = "Teenage Mutant Ninja Turtles Theme Song 8 Bit Remix Cover Version 8 Bit Universe.json"
	GlobalVARS.diff = normal
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


func _on_button_3_pressed():
	GlobalVARS.song = "te rickrollearon en 8bit.mp3"
	GlobalVARS.json_file_name = "te rickrollearon en 8bit.json"
	GlobalVARS.diff = normal
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
	
func _on_button_4_pressed():
	GlobalVARS.song = "Warriors 8 Bit Remix Cover Version Tribute to Imagine Dragons 8 Bit Universe.mp3"
	GlobalVARS.json_file_name = "Warriors 8 Bit Remix Cover Version Tribute to Imagine Dragons 8 Bit Universe.json"
	GlobalVARS.diff = hard
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


func _on_button_5_pressed():
	GlobalVARS.song = "Gravity Falls Theme 8 Bit Tribute to Gravity Falls 8 Bit Universe.mp3"
	GlobalVARS.json_file_name = "Gravity Falls Theme 8 Bit Tribute to Gravity Falls 8 Bit Universe.json"
	GlobalVARS.diff = normal
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")

func _on_button_6_pressed():
	GlobalVARS.song = "At Dooms Gate 8 Bit Cover Tribute to Doom 8 Bit Universe.mp3"
	GlobalVARS.json_file_name = "At Dooms Gate 8 Bit Cover Tribute to Doom 8 Bit Universe.json"
	GlobalVARS.diff = easy
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


func _on_button_7_pressed():
	GlobalVARS.song = "Megalovania Undertale 8 Bit Universe Version.mp3"
	GlobalVARS.json_file_name = "Megalovania Undertale 8 Bit Universe Version.json"
	GlobalVARS.diff = insane
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


func _on_button_8_pressed():
	GlobalVARS.song = "Through The Fire and Flames 8 Bit Cover Tribute to Dragonforce 8 Bit Universe.mp3"
	GlobalVARS.json_file_name = "Through The Fire and Flames 8 Bit Cover Tribute to Dragonforce 8 Bit Universe.json"
	GlobalVARS.diff = impossible
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
