extends VBoxContainer

@onready var sector_number_label = $SectorNumber
@onready var sector_mission_label = $SectorMission

func set_sector_number(sector_number: int):
	sector_number_label.text = "Sector %s" % sector_number

func set_sector_mission(mission: String):
	sector_mission_label.text = mission
