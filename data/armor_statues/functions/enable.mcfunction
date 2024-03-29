#
# Description:	Enable system for the player and issue control book
# Called by:	command block
# Entity @s:	player
#
# Trigger values in use are:	1-12		Style settings
#								20-39		Pose presets
#								40-51		Nudge position
#								52-57		Adjust rotation
#								60-95		Pose adjustment
#								101-112		Nudge position
#								120-123		Angle step
#								124-125		Face towards or away
#								131-135		Pose mirror and flip
#								141-142		Pose presets
#								151-155		Auto alignment
#                               161-162     Exchange Slots
#								999			Check target
#								1000-1003	Lock and seal
#								1004-1005	Copy and paste
#								1100-1129	Nuge position relative
#								1150		Random pose
#								1160-1171	Pointing
#								1200-1201	Undo/Redo
#
# Set trigger score for player to zero and enable
#
scoreboard players set @s as_trigger 0
scoreboard players enable @s as_trigger
scoreboard players set @s as_help 0
scoreboard players enable @s as_help
scoreboard players set @s if_invisible 0
scoreboard players enable @s if_invisible
scoreboard players set @s as_repeat 0
scoreboard players enable @s as_repeat
#
# Set angle step for rotation and pose adjustment to default 15 degrees
#
scoreboard players set @s as_angle 15
