extends PanelContainer

@onready var name_label: Label = $%TitleLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var animation_player = $AnimationPlayer
@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/ProgressBar
@onready var purchase_button: Button = %PurchaseButton
@onready var progress_label: Label = %ProgressLabel
@onready var count_label: Label = %CountLabel

var upgrade: MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_button_pressed_signal)


func set_meta_upgrade(upgrade: MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func update_progress():
	var count = 0
	if MetaProgession.save_data["meta_upgrades"].has(upgrade.id):
		count = MetaProgession.save_data["meta_upgrades"][upgrade.id]["quantity"]
	var currency = MetaProgession.save_data["meta_upgrade_currency"]
	var percent = currency / upgrade.experience_cost
	var is_max_count_reached = count >= upgrade.max_quantity
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_max_count_reached
	if is_max_count_reached:
		purchase_button.text = "Max"
	progress_label.text = str(currency) + "/" + str(upgrade.experience_cost)
	count_label.text = "x%d" % count

func select_card():
	animation_player.play("selected")

#SIGNALS

func on_purchase_button_pressed_signal():
	if upgrade == null:
		return
	MetaProgession.add_meta_upgrade(self.upgrade)
	MetaProgession.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgession.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	animation_player.play("selected")
