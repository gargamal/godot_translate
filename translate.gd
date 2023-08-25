extends CanvasLayer
class_name Translate

export(String) var path_translate_file :String = "res://translate/translate.json"
export(String) var path_fr_translate_file :String = "res://translate/translate_fr.csv"
export(String) var path_en_translate_file :String = "res://translate/translate_en.csv"
export(String) var path_es_translate_file :String = "res://translate/translate_es.csv"
export(String) var path_pt_translate_file :String = "res://translate/translate_pt.csv"


var all_translates :Dictionary


func _on_generate_translate_pressed():
	var translate_file :Array = [ 
		{"counrty": "FR", "translates": open_translate_one_file(path_fr_translate_file)},
		{"counrty": "EN", "translates": open_translate_one_file(path_en_translate_file)},
		{"counrty": "ES", "translates": open_translate_one_file(path_es_translate_file)},
		{"counrty": "PT", "translates": open_translate_one_file(path_pt_translate_file)},
	]
	
	var all_translate :Dictionary = { "language": [] }
	
	for idx in range(translate_file[0].translates.size()):
		var key :String = translate_file[0].translates[idx].key
		var translate_elt :Dictionary = {
			"key": key,
			"translate": []
		}
		
		for jdx in range(translate_file.size()):
			var word :String = translate_file[jdx].translates[idx].translate
			var one_translate :Dictionary = {
					"country": translate_file[jdx].counrty,
					"word": word
				}
			translate_elt.translate.append(one_translate)
		
		all_translate.language.append(translate_elt)
	
	var file_save :File = File.new()
	var err_save :int = file_save.open(path_translate_file + ".new", File.WRITE)
	if err_save == OK:
		file_save.store_line(to_json(all_translate))
		file_save.close()


func _on_generate_fr_pressed():
	open_translate_file()
	var langue_list :Array = create_object_langue("FR")
	save_langue(path_fr_translate_file, langue_list)


func _on_generate_en_pressed():
	open_translate_file()
	var langue_list :Array = create_object_langue("EN")
	save_langue(path_en_translate_file, langue_list)


func _on_generate_es_pressed():
	open_translate_file()
	var langue_list :Array = create_object_langue("ES")
	save_langue(path_es_translate_file, langue_list)


func _on_generate_pt_pressed():
	open_translate_file()
	var langue_list :Array = create_object_langue("PT")
	save_langue(path_pt_translate_file, langue_list)


func open_translate_file():
	if all_translates.empty():
		var file = File.new()
		var err :int = file.open(path_translate_file, File.READ)
		if err == OK:
			all_translates = parse_json(file.get_as_text())
			file.close()


func create_object_langue(country :String) -> Array:
	var langue_list :Array = []
	
	for language in all_translates.language:
		for translate in language.translate:
			if translate.country == country:
				langue_list.append({"key": language.key, "translate": translate.word})
	
	return langue_list


func save_langue(path_file :String, langue_list :Array):
	var file_save :File = File.new()
	var err_save :int = file_save.open(path_file, File.WRITE)
	if err_save == OK:
		file_save.store_line(to_json(langue_list))
		file_save.close()
	
	err_save = file_save.open(path_file, File.WRITE)
	if err_save == OK:
		for langue in langue_list:
			file_save.store_line("\"" + langue.key + "\",\"" + langue.translate + "\"")
		file_save.close()


func open_translate_one_file(path_file :String) -> Array:
	var translate_one_file :Array = []
	var file = File.new()
	var err :int = file.open(path_file, File.READ)
	if err == OK:
		var all_file :String = file.get_as_text()
		all_file = all_file.substr(1)
		all_file = all_file.substr(0, all_file.length() - 2)
		file.close()
		
		var file_lines :Array = all_file.split("\"\n\"")
		for file_line in file_lines:
			var file_elt :Array = file_line.split("\",\"")
			translate_one_file.append({"key": file_elt[0], "translate": file_elt[1]})
	
	return translate_one_file
