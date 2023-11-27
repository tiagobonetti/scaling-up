extends Node2D
class_name Stage

@export var max_customers := 20
var customers_spawned := 0

var customer_died := 0
var customer_died_max := 10

var products_sold := 0
var products_sold_max := 10

var failed:
	get:
		return customer_died >= customer_died_max

var succeded:
	get:
		return products_sold >= products_sold_max

var finished:
	get:
		return succeded or failed

var total_time_s := 0.0

@onready var spawners := find_children("", "CustomerSpawner")

func _ready():
	%CenterLabel.visible = false
	print("spawners ", spawners.size())
	for s in spawners:
		print("Spawner:", s.name)
		s.spawned.connect(Callable(on_spawned))
		s.schedule_next_spawn()


func _process(delta):
	if finished:
		return

	total_time_s += delta
	update_top_label()

func update_top_label():
	var minutes = int(total_time_s / 60)
	var seconds = fmod(total_time_s, 60.0)
	%TopLabel.text = "Time: %d:%04.1f Sold: %02d Killed: %02d" % [minutes, seconds, products_sold ,customer_died]

	if finished:
		if succeded :
			%CenterLabel.text = "You have captured the market!\n Time for a price hike!"
		else:
			%CenterLabel.text = "You killed too many customers!\n Time for a fine and cushy retirement!"
		%CenterLabel.visible = true

func on_spawned(customer: Customer):
	customers_spawned += 1
	customer.died.connect(Callable(on_died))
	customer.bought.connect(Callable(on_bought))
	if customers_spawned >= max_customers:
		print("Stop")
		for s in spawners:
			s.stop()

func on_died():
	customer_died += 1
	update_top_label()

func on_bought():
	products_sold += 1
	update_top_label()
