extends HBoxContainer


func initialize(stat_name : String, stat_value):
	if stat_name[0] == "%":
		stat_name.erase(0,1)
		$Name.text = stat_name
		$Value.text = str(stat_value * 100).pad_decimals(0) + "%"
	elif stat_name[0] == "$":
		stat_name.erase(0,1)
		$Name.text = stat_name
		$Value.text = str(stat_value).pad_decimals(1)
	else:
		$Name.text = stat_name
		$Value.text = str(stat_value).pad_decimals(0)
