@tool
extends Resource
class_name TitleResource

enum TitleDivision { NONE, MAIN_EVENT, SINGLES, WOMENS }

@export_group("Title Info")
@export var title_name: String = ""
@export var promotion_id: int = 0
@export var division: TitleDivision = TitleDivision.NONE
@export var current_holder_id: int = 0
@export var weeks_held: int = 0
@export var previous_holder_ids: Array[int] = []
