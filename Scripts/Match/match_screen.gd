@tool
extends Control

# Required unique-name nodes:
# PlayerName, PlayerClass, PlayerGender, PlayerGimmick, PlayerGimmickDescription, PlayerRegion, PlayerCountry, PlayerHeight, PlayerWeight
# PlayerStrengthValue, PlayerSpeedValue, PlayerStaminaValue, PlayerSkillValue, PlayerStrikingValue, PlayerCharismaValue
# PlayerAgeValue
# PlayerHeadBar, PlayerBodyBar, PlayerLeftArmBar, PlayerRightArmBar, PlayerLeftLegBar, PlayerRightLegBar
# PlayerNameBox, PlayerStatsBox
# OpponentName, OpponentClass, OpponentGender, OpponentGimmick, OpponentGimmickDescription, OpponentRegion, OpponentCountry, OpponentHeight, OpponentWeight
# OpponentStrengthValue, OpponentSpeedValue, OpponentStaminaValue, OpponentSkillValue, OpponentStrikingValue, OpponentCharismaValue
# OpponentAgeValue
# OpponentHeadBar, OpponentBodyBar, OpponentLeftArmBar, OpponentRightArmBar, OpponentLeftLegBar, OpponentRightLegBar
# OpponentNameBox, OpponentStatsBox

@export var player_wrestler: WrestlerResource:
    set(value):
        player_wrestler = value
        if is_node_ready():
            _update_player()

@export var player_promotion: PromotionResource:
    set(value):
        player_promotion = value
        if is_node_ready():
            _update_player()

@export var opponent_wrestler: WrestlerResource:
    set(value):
        opponent_wrestler = value
        if is_node_ready():
            _update_opponent()

@export var opponent_promotion: PromotionResource:
    set(value):
        opponent_promotion = value
        if is_node_ready():
            _update_opponent()

@export var player_is_champion: bool = false:
    set(value):
        player_is_champion = value
        if is_node_ready():
            _update_player()

@export var opponent_is_champion: bool = false:
    set(value):
        opponent_is_champion = value
        if is_node_ready():
            _update_opponent()

@export var face_name_color: Color = Color(0.2509804, 0.6392157, 1.0, 1.0)
@export var heel_name_color: Color = Color(0.92156863, 0.2901961, 0.2901961, 1.0)
@export var champion_name_color: Color = Color(0.83137256, 0.6862745, 0.21568628, 1.0)
@export var accent_dim_color: Color = Color(0.72, 0.72, 0.72, 1.0)

var _promotion_cache_by_id: Dictionary = {}
var _promotion_cache_ready: bool = false

func _ready() -> void:
    _update_player()
    _update_opponent()

func _update_player() -> void:
    var wrestler := player_wrestler
    if not wrestler:
        return

    var accent := _get_name_color(wrestler, player_is_champion)

    %PlayerName.text = _format_display_name(wrestler, player_is_champion)
    _apply_name_style(%PlayerName, accent)

    var promotion = player_promotion
    if not promotion:
        promotion = _find_promotion_for_wrestler(wrestler)
        
    if promotion:
        %PlayerPromotion.text = _format_promotion_label(promotion)
    else:
        %PlayerPromotion.text = "FREE AGENT"

    %PlayerClass.text = _format_class(wrestler.wrestler_class)
    %PlayerGender.text = _format_gender(int(wrestler.wrestler_gender))
    %PlayerGimmick.text = wrestler.gimmick_name
    %PlayerGimmickDescription.text = _format_gimmick_description(wrestler.gimmick_description)
    %PlayerRegion.text = _format_region(wrestler.birthplace)
    %PlayerCountry.text = _format_country(wrestler)
    %PlayerHeight.text = str(wrestler.wrestler_height)
    %PlayerWeight.text = str(wrestler.wrestler_weight) + "lbs"

    %PlayerStrengthValue.text = str(wrestler.strength)
    %PlayerSpeedValue.text = str(wrestler.speed)
    %PlayerStaminaValue.text = str(wrestler.stamina)
    %PlayerStrikingValue.text = str(wrestler.striking)
    %PlayerSkillValue.text = str(wrestler.skill)
    %PlayerCharismaValue.text = str(wrestler.charisma)
    %PlayerAgeValue.text = str(wrestler.Age)

    _set_damage_bars(
        wrestler,
        %PlayerHeadBar,
        %PlayerBodyBar,
        %PlayerLeftArmBar,
        %PlayerRightArmBar,
        %PlayerLeftLegBar,
        %PlayerRightLegBar
    )

    _apply_panel_accent(%PlayerNameBox, accent)
    _apply_panel_accent(%PlayerStatsBox, accent)
    _apply_bar_fill(%PlayerHeadBar, accent)
    _apply_bar_fill(%PlayerBodyBar, accent)
    _apply_bar_fill(%PlayerLeftArmBar, accent)
    _apply_bar_fill(%PlayerRightArmBar, accent)
    _apply_bar_fill(%PlayerLeftLegBar, accent)
    _apply_bar_fill(%PlayerRightLegBar, accent)
    _apply_panel_accent(%PlayerMovesetBox, accent)
    
func _update_opponent() -> void:
    var wrestler := opponent_wrestler
    if not wrestler:
        return

    var accent := _get_name_color(wrestler, opponent_is_champion)

    %OpponentName.text = _format_display_name(wrestler, opponent_is_champion)
    _apply_name_style(%OpponentName, accent)

    var promotion = opponent_promotion
    if not promotion:
        promotion = _find_promotion_for_wrestler(wrestler)
        
    if promotion:
        %OpponentPromotion.text = _format_promotion_label(promotion)
    else:
        %OpponentPromotion.text = "FREE AGENT"

    %OpponentClass.text = _format_class(wrestler.wrestler_class)
    %OpponentGender.text = _format_gender(int(wrestler.wrestler_gender))
    %OpponentGimmick.text = wrestler.gimmick_name
    %OpponentGimmickDescription.text = _format_gimmick_description(wrestler.gimmick_description)
    %OpponentRegion.text = _format_region(wrestler.birthplace)
    %OpponentCountry.text = _format_country(wrestler)
    %OpponentHeight.text = str(wrestler.wrestler_height)
    %OpponentWeight.text = str(wrestler.wrestler_weight) + "lbs"

    %OpponentStrengthValue.text = str(wrestler.strength)
    %OpponentSpeedValue.text = str(wrestler.speed)
    %OpponentStaminaValue.text = str(wrestler.stamina)
    %OpponentStrikingValue.text = str(wrestler.striking)
    %OpponentSkillValue.text = str(wrestler.skill)
    %OpponentCharismaValue.text = str(wrestler.charisma)
    %OpponentAgeValue.text = str(wrestler.Age)

    _set_damage_bars(
        wrestler,
        %OpponentHeadBar,
        %OpponentBodyBar,
        %OpponentLeftArmBar,
        %OpponentRightArmBar,
        %OpponentLeftLegBar,
        %OpponentRightLegBar
    )

    _apply_panel_accent(%OpponentNameBox, accent)
    _apply_panel_accent(%OpponentStatsBox, accent)
    _apply_bar_fill(%OpponentHeadBar, accent)
    _apply_bar_fill(%OpponentBodyBar, accent)
    _apply_bar_fill(%OpponentLeftArmBar, accent)
    _apply_bar_fill(%OpponentRightArmBar, accent)
    _apply_bar_fill(%OpponentLeftLegBar, accent)
    _apply_bar_fill(%OpponentRightLegBar, accent)
    _apply_panel_accent(%OpponentMovesetBox, accent)

func _set_damage_bars(
    wrestler: WrestlerResource,
    head_bar: ProgressBar,
    body_bar: ProgressBar,
    left_arm_bar: ProgressBar,
    right_arm_bar: ProgressBar,
    left_leg_bar: ProgressBar,
    right_leg_bar: ProgressBar
) -> void:
    head_bar.value = 0
    body_bar.value = 0
    left_arm_bar.value = 0
    right_arm_bar.value = 0
    left_leg_bar.value = 0
    right_leg_bar.value = 0

    head_bar.value = maxf(0.0, 100.0 - wrestler.head_hp)
    body_bar.value = maxf(0.0, 100.0 - wrestler.body_hp)
    left_arm_bar.value = maxf(0.0, 100.0 - wrestler.left_arm_hp)
    right_arm_bar.value = maxf(0.0, 100.0 - wrestler.right_arm_hp)
    left_leg_bar.value = maxf(0.0, 100.0 - wrestler.left_leg_hp)
    right_leg_bar.value = maxf(0.0, 100.0 - wrestler.right_leg_hp)

func _get_name_color(wrestler: WrestlerResource, is_champion: bool) -> Color:
    if is_champion:
        return champion_name_color
    match int(wrestler.wrestler_disposition):
        WrestlerResource.WrestlerDisposition.HEEL:
            return heel_name_color
        WrestlerResource.WrestlerDisposition.FACE:
            return face_name_color
        _:
            return Color(1, 1, 1, 1)

func _apply_name_style(label: Label, color: Color) -> void:
    label.add_theme_color_override("font_color", color)
    label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
    label.add_theme_constant_override("outline_size", 2)

func _apply_panel_accent(panel: PanelContainer, color: Color) -> void:
    if panel.has_theme_stylebox_override("panel"):
        var existing := panel.get_theme_stylebox("panel")
        if existing is StyleBoxFlat:
            var sb_existing := existing as StyleBoxFlat
            sb_existing.border_color = color
            sb_existing.border_width_left = max(sb_existing.border_width_left, 4)
            sb_existing.border_width_top = max(sb_existing.border_width_top, 4)
            sb_existing.border_width_right = max(sb_existing.border_width_right, 4)
            sb_existing.border_width_bottom = max(sb_existing.border_width_bottom, 4)
            return

    var base := panel.get_theme_stylebox("panel")
    if base is StyleBoxFlat:
        var sb := (base as StyleBoxFlat).duplicate()
        sb.border_color = color
        sb.border_width_left = max(sb.border_width_left, 4)
        sb.border_width_top = max(sb.border_width_top, 4)
        sb.border_width_right = max(sb.border_width_right, 4)
        sb.border_width_bottom = max(sb.border_width_bottom, 4)
        panel.add_theme_stylebox_override("panel", sb)

func _apply_bar_fill(bar: ProgressBar, color: Color) -> void:
    var c := color
    c.a = 0.55

    if bar.has_theme_stylebox_override("fill"):
        var existing := bar.get_theme_stylebox("fill")
        if existing is StyleBoxFlat:
            (existing as StyleBoxFlat).bg_color = c
            return

    var base := bar.get_theme_stylebox("fill")
    if base is StyleBoxFlat:
        var sb := (base as StyleBoxFlat).duplicate()
        sb.bg_color = c
        bar.add_theme_stylebox_override("fill", sb)

func _format_class(classes: Array) -> String:
    if classes.is_empty():
        return ""
    var names: Array[String] = []
    for c in classes:
        names.append(_format_enum_name(WrestlerResource.WrestlerClass, int(c)))
    return "/".join(names)

func _format_region(region_value: int) -> String:
    return _format_enum_name(WrestlerResource.Region, region_value)

func _format_country(wrestler: WrestlerResource) -> String:
    match int(wrestler.birthplace):
        WrestlerResource.Region.NORTH_AMERICA:
            return _format_enum_name(WrestlerResource.NA_Countries, int(wrestler.north_american_country))
        WrestlerResource.Region.SOUTH_AMERICA:
            return _format_enum_name(WrestlerResource.SA_Countries, int(wrestler.south_american_country))
        WrestlerResource.Region.EUROPE:
            return _format_enum_name(WrestlerResource.Europe_Countries, int(wrestler.europe_country))
        WrestlerResource.Region.ASIA:
            return _format_enum_name(WrestlerResource.Asia_Countries, int(wrestler.asia_country))
        WrestlerResource.Region.AFRICA:
            return _format_enum_name(WrestlerResource.Africa_Countries, int(wrestler.africa_country))
        WrestlerResource.Region.OCEANIA:
            return _format_enum_name(WrestlerResource.Oceania_Countries, int(wrestler.oceania_country))
        _:
            return ""

func _format_enum_name(enum_dict: Dictionary, value: int) -> String:
    for k in enum_dict.keys():
        if int(enum_dict[k]) == value:
            return _pretty_enum_key(str(k))
    return ""

func _pretty_enum_key(key: String) -> String:
    return key.replace("_", " ").to_lower().capitalize()

func _format_display_name(wrestler: WrestlerResource, is_champion: bool) -> String:
    var prefix := _format_disposition_prefix(int(wrestler.wrestler_disposition))
    var suffix := " (c)" if is_champion else ""
    return "(" + prefix + ") " + wrestler.wrestler_name.to_upper() + suffix

func _format_disposition_prefix(disposition_value: int) -> String:
    match disposition_value:
        WrestlerResource.WrestlerDisposition.HEEL:
            return "h"
        WrestlerResource.WrestlerDisposition.FACE:
            return "f"
        _:
            return ""

func _format_gimmick_description(description: String) -> String:
    if description.strip_edges().is_empty():
        return ""
    return " - " + description

func _format_gender(gender_value: int) -> String:
    return _format_enum_name(WrestlerResource.WrestlerGender, gender_value)

func _format_promotion_label(promotion: PromotionResource) -> String:
    if int(promotion.promotion_id) == 1:
        return "FREE AGENT"
    var initials := str(promotion.promotion_initials).strip_edges()
    if not initials.is_empty():
        return initials
    return str(promotion.promotion_name).strip_edges()

func _get_promotion_cache() -> void:
    if _promotion_cache_ready:
        return

    _promotion_cache_by_id = {}

    var dir = DirAccess.open("res://Promotions")
    if not dir:
        _promotion_cache_ready = true
        return

    dir.list_dir_begin()
    var folder = dir.get_next()
    while folder != "":
        if dir.current_is_dir() and not folder.begins_with("."):
            var folder_path = "res://Promotions/" + folder
            var fdir = DirAccess.open(folder_path)
            if fdir:
                fdir.list_dir_begin()
                var file_name = fdir.get_next()
                while file_name != "":
                    if file_name.ends_with(".tres") and not fdir.current_is_dir():
                        var res = ResourceLoader.load(folder_path + "/" + file_name)
                        if res is PromotionResource:
                            var promo = res as PromotionResource
                            _promotion_cache_by_id[int(promo.promotion_id)] = promo
                    file_name = fdir.get_next()
        folder = dir.get_next()

    _promotion_cache_ready = true

func _find_promotion_by_id(promotion_id: int) -> PromotionResource:
    if promotion_id <= 0:
        return null

    _get_promotion_cache()
    return _promotion_cache_by_id.get(promotion_id, null)

func _find_promotion_for_wrestler(wrestler: WrestlerResource) -> PromotionResource:
    if not wrestler:
        return null

    var contract := wrestler.current_contract
    if contract and int(contract.promotion_id) > 0:
        var promo_from_contract = _find_promotion_by_id(int(contract.promotion_id))
        if promo_from_contract:
            return promo_from_contract

    _get_promotion_cache()
    for promo in _promotion_cache_by_id.values():
        if promo == null:
            continue
        var mens = promo.mens_division
        if mens and wrestler in mens:
            return promo
        var womens = promo.womens_division
        if womens and wrestler in womens:
            return promo

    return null
