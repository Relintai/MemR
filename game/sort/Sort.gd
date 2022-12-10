extends VBoxContainer

var sort_folder : String
var target_folder : String

var _texture_rect : TextureRect
var _error_label : Label
var _categories_ob : OptionButton
var _sub_categories_ob : OptionButton

var _categories_popup : ConfirmationDialog
var _categories_popup_line_edit : LineEdit

var _sub_categories_popup : ConfirmationDialog
var _sub_categories_popup_line_edit : LineEdit

var _current_folder_index : int
var _folders : PoolStringArray

var _current_file_index : int
var _current_folder_files : PoolStringArray

func refresh_categories() -> void:
	_categories_ob.clear()
	
	var tf : Directory = Directory.new()
	if tf.open(target_folder) != OK:
		return
	
	var folders : PoolStringArray = PoolStringArray()
	
	tf.list_dir_begin(true)
	
	var f : String = tf.get_next()
	while !f.empty():
		if !tf.current_is_dir():
			f = tf.get_next()
			continue
			
		folders.push_back(f)
		f = tf.get_next()
	
	tf.list_dir_end()
	
	folders.sort()
	
	for i in range(folders.size()):
		_categories_ob.add_item(folders[i])

func refresh_sub_categories() -> void:
	_sub_categories_ob.clear()
	
	var tf : Directory = Directory.new()
	if tf.open(target_folder.append_path(_categories_ob.get_item_text(_categories_ob.selected))) != OK:
		return
	
	var folders : PoolStringArray = PoolStringArray()
	
	tf.list_dir_begin(true)
	
	var f : String = tf.get_next()
	while !f.empty():
		if !tf.current_is_dir():
			f = tf.get_next()
			continue
			
		folders.push_back(f)
		f = tf.get_next()
	
	tf.list_dir_end()
	
	folders.sort()

	for i in range(folders.size()):
		_sub_categories_ob.add_item(folders[i])

func validate_folders() -> bool:
	sort_folder = ProjectSettings.get("application/config/sort_folder")
	target_folder = ProjectSettings.get("application/config/target_folder")
	
	if sort_folder.empty() || target_folder.empty():
		return false
	
	var d1 : Directory = Directory.new()
	if d1.open(sort_folder) != OK:
		return false
		
	var d2 : Directory = Directory.new()
	if d2.open(target_folder) != OK:
		return false
	
	return true

func next_image() -> void:
	_current_file_index += 1
	
	if _current_file_index >= _current_folder_files.size():
		next_folder()
		return
	
	var img : Image = Image.new()
	if img.load(_current_folder_files[_current_file_index]) != OK:
		_error_label.text = "Error loading file: " + _current_folder_files[_current_file_index]
		_error_label.show()
		_texture_rect.hide()
	
		return
	
	_error_label.hide()
	_texture_rect.show()
	_texture_rect.texture.create_from_image(img, 0)
	
	

func evaluate_folders() -> void:
	_folders.clear()
	
	evaluate_folder(sort_folder)
	
	_folders.sort()
	
func evaluate_folder(folder : String) -> void:
	var d : Directory = Directory.new()
	
	if d.open(folder) != OK:
		return
		
	d.list_dir_begin(true)
	
	var f : String = d.get_next()
	while !f.empty():
		if !d.current_is_dir():
			f = d.get_next()
			continue
			
		var fp : String = folder.append_path(f)
		_folders.push_back(fp)
		evaluate_folder(fp)
		
		f = d.get_next()
	
	d.list_dir_end()

func next_folder() -> void:
	_current_folder_index += 1
	
	if _current_folder_index >= _folders.size():
		return
		
	_current_file_index = 0
	_current_folder_files.clear()
	
	var curr_path : String = _folders[_current_folder_index]
	
	var tf : Directory = Directory.new()
	if tf.open(curr_path) != OK:
		return
	
	tf.list_dir_begin(true)
	
	var f : String = tf.get_next()
	while !f.empty():
		if tf.current_is_dir():
			f = tf.get_next()
			continue
			
		_current_folder_files.push_back(curr_path.append_path(f))
		f = tf.get_next()
	
	tf.list_dir_end()
	
	if _current_folder_files.size() == 0:
		next_folder()
	else:
		_current_file_index = -1
		next_image()

func _on_Apply_pressed() -> void:
	next_image()

func _on_Skip_pressed() -> void:
	next_image()

func _on_Categories_item_selected(index: int) -> void:
	refresh_sub_categories()

func _on_SubCategoies_item_selected(index: int) -> void:
	pass # Replace with function body.

func _on_Categories_Add_pressed() -> void:
	_categories_popup_line_edit.text = ""
	_categories_popup.popup_centered()

func _on_SubCategoies_Add_pressed() -> void:
	_sub_categories_popup_line_edit.text = ""
	_sub_categories_popup.popup_centered()

func _on_NewCategoryPopup_confirmed() -> void:
	if _categories_popup_line_edit.text.empty():
		return
		
	var folder : String = target_folder.append_path(_categories_popup_line_edit.text)
	
	var d : Directory = Directory.new()
	d.make_dir_recursive(folder)
	
	refresh_categories()

func _on_NewSubCategoryPopup_confirmed() -> void:
	if _categories_ob.selected == -1:
		return
		
	if _sub_categories_popup_line_edit.text.empty():
		return
		
	var folder : String = target_folder.append_path(_categories_ob.get_item_text(_categories_ob.selected))
	folder = folder.append_path(_sub_categories_popup_line_edit.text)
	
	var d : Directory = Directory.new()
	d.make_dir_recursive(folder)
	
	refresh_sub_categories()


func _notification(what: int) -> void:
	if what == NOTIFICATION_READY:
		_texture_rect = get_node("ScrollContainer/VBoxContainer/TextureRect") as TextureRect
		_error_label = get_node("ScrollContainer/VBoxContainer/ErrorLabel") as Label
		_categories_ob = get_node("Categories/Categories") as OptionButton
		_sub_categories_ob = get_node("SubCategoies/SubCategoies") as OptionButton
		
		_categories_popup = get_node("Control/NewCategoryPopup") as ConfirmationDialog
		_categories_popup_line_edit = get_node("Control/NewCategoryPopup/VBoxContainer/LineEdit") as LineEdit
		
		_sub_categories_popup = get_node("Control/NewSubCategoryPopup") as ConfirmationDialog
		_sub_categories_popup_line_edit = get_node("Control/NewSubCategoryPopup/VBoxContainer/LineEdit") as LineEdit
		
		_texture_rect.texture = ImageTexture.new()
	elif what == NOTIFICATION_VISIBILITY_CHANGED:
		if is_visible_in_tree():
			sort_folder = ProjectSettings.get("application/config/sort_folder")
			target_folder = ProjectSettings.get("application/config/target_folder")
			refresh_categories()
			refresh_sub_categories()
			
			evaluate_folders()
			_current_folder_index = -1
			next_folder()
			#next_image()