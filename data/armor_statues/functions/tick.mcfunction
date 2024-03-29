#
# Description:	Processing every tick
# Called by:	#main:tick
# Entity @s:	None
#
# Particle at shrine position
#
execute as @e[tag=as_shrine] at @s run particle minecraft:enchant ~ ~ ~ 0.5 0.5 0.5 0.25 5
#
# If book crafting is enabled, check for players holding a written book titled "Statues"
#
execute as @a[tag=as_craft] run function armor_statues:replace_book
#
# Display help in chat and enable for all players
#
execute as @a[scores={as_help=1..}] at @s run function armor_statues:help
#
# Item frame armor stand animation
#
scoreboard players add #animate_time as_angle 1
execute unless score #animate_trigger as_angle matches 0 if score #animate_time as_angle >= #animate_trigger as_angle run function armor_statues:animate_time
