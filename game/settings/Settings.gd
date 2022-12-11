extends MarginContainer

var settings_file : String = "user://settings.cfg"

signal back

var _sort_folder_line_edit : LineEdit
var _target_folder_line_edit : LineEdit
var _shrink_override_cb : CheckButton
var _shrink_override_value_slider : HSlider

func load_settings() -> void:
	var config_file : ConfigFile = ConfigFile.new()
	
	var error : int = config_file.load(settings_file)
	
	if error != OK:
#		print("Failed to load the settings file! Error code %s" % error)
		return
	
	var sort_folder : String = config_file.get_value("default", "sort_folder", "")
	var target_folder : String = config_file.get_value("default", "target_folder", "")
	var shrink_override : bool = config_file.get_value("default", "shrink_override", false)
	var shrink_override_value : float = config_file.get_value("default", "shrink_override_value", 1)
	
	ProjectSettings.set("application/config/sort_folder", sort_folder)
	ProjectSettings.set("application/config/target_folder", target_folder)
	ProjectSettings.set("display/window/stretch/shrink_override", shrink_override)
	ProjectSettings.set("display/window/stretch/shrink_override_value", shrink_override_value)
	
	_sort_folder_line_edit.text = sort_folder
	_target_folder_line_edit.text = target_folder
	_shrink_override_cb.pressed = shrink_override
	_shrink_override_value_slider.value = shrink_override_value
	
	get_parent().apply_shink()
	
	
func save_settings() -> void:
	var config_file : ConfigFile = ConfigFile.new()
	
	var sort_folder : String = _sort_folder_line_edit.text
	var target_folder : String = _target_folder_line_edit.text
	var shrink_override : bool = _shrink_override_cb.pressed
	var shrink_override_value : float = _shrink_override_value_slider.value
	
	config_file.set_value("default", "sort_folder", sort_folder)
	config_file.set_value("default", "target_folder", target_folder)
	config_file.set_value("default", "shrink_override", shrink_override)
	config_file.set_value("default", "shrink_override_value", shrink_override_value)

	ProjectSettings.set("application/config/sort_folder", sort_folder)
	ProjectSettings.set("application/config/target_folder", target_folder)
	ProjectSettings.set("display/window/stretch/shrink_override", shrink_override)
	ProjectSettings.set("display/window/stretch/shrink_override_value", shrink_override_value)
	
	var error : int = config_file.save(settings_file)
	
	if error != OK:
#		print("Failed to load the settings file! Error code %s" % error)
		return
		
	get_parent().apply_shink()

func _on_Button_pressed() -> void:
	save_settings()
	emit_signal("back")

func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		_sort_folder_line_edit = get_node("VBoxContainer/SortFolder") as LineEdit
		_target_folder_line_edit = get_node("VBoxContainer/TargetFolder") as LineEdit
		_shrink_override_cb = get_node("VBoxContainer/ShrinkOverride") as CheckButton
		_shrink_override_value_slider = get_node("VBoxContainer/ShrinkOverrideValue") as HSlider

		load_settings()
