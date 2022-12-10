extends MarginContainer

var settings_file : String = "user://settings.cfg"

signal back

var _sort_folder_line_edit : LineEdit
var _target_folder_line_edit : LineEdit

func load_settings() -> void:
	var config_file : ConfigFile = ConfigFile.new()
	
	var error : int = config_file.load(settings_file)
	
	if error != OK:
#		print("Failed to load the settings file! Error code %s" % error)
		return
	
	var sort_folder : String = config_file.get_value("default", "sort_folder", "")
	var target_folder : String = config_file.get_value("default", "target_folder", "")
	
	ProjectSettings.set("application/config/sort_folder", sort_folder)
	ProjectSettings.set("application/config/target_folder", target_folder)
	
	_sort_folder_line_edit.text = sort_folder
	_target_folder_line_edit.text = target_folder
	
	
func save_settings() -> void:
	var config_file : ConfigFile = ConfigFile.new()
	
	var sort_folder : String = _sort_folder_line_edit.text
	var target_folder : String = _target_folder_line_edit.text
	
	config_file.set_value("default", "sort_folder", sort_folder)
	config_file.set_value("default", "target_folder", target_folder)
	
	ProjectSettings.set("application/config/sort_folder", sort_folder)
	ProjectSettings.set("application/config/target_folder", target_folder)
	
	var error : int = config_file.save(settings_file)
	
	if error != OK:
#		print("Failed to load the settings file! Error code %s" % error)
		return

func _on_Button_pressed() -> void:
	save_settings()
	emit_signal("back")

func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		_sort_folder_line_edit = get_node("VBoxContainer/SortFolder") as LineEdit
		_target_folder_line_edit = get_node("VBoxContainer/TargetFolder") as LineEdit
		load_settings()
