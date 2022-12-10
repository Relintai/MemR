extends Control

var _menu : Control
var _settings : Control
var _sort : Control

func hide_all() -> void:
	_menu.hide()
	_settings.hide()
	_sort.hide()

func _on_Sort_pressed() -> void:
	hide_all()
	_sort.show()

func _on_Settings_pressed() -> void:
	hide_all()
	_settings.show()

func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		_menu = get_node("Menu")
		_settings = get_node("Settings")
		_sort = get_node("Sort")


func _on_Settings_back() -> void:
	hide_all()
	_menu.show()
