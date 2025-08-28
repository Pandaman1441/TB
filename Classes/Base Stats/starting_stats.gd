extends Resource


class_name StartingStats 

@export var class_type : String = 'Class type'

# resources of a resource
@export var hp: Stat = Stat.new()
@export var pp: Stat = Stat.new()
@export var mp: Stat = Stat.new()
@export var ag: Stat = Stat.new()
@export var wp: Stat = Stat.new()
@export var pr: Stat = Stat.new()
@export var mr: Stat = Stat.new()
@export var resource: Stat = Stat.new()
@export var accuracy: Stat = Stat.new()
@export var crit_chance: Stat = Stat.new()
@export var crit_dmg: StatF = StatF.new()
