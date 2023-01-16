class Item extends Entity
	type: types.Item
	new: (target, ...) =>
		super ...
		@target = target
		@restTime = 40

	update: =>
		super!
        @collision!

    collision: =>

class AmmoDrop extends Item
    ammoType: "Yellow"
    color: 0
	new: (...) =>
		super ...
        @restTime = 60
        @spawnTargetOffsetX = @x + rnd -20, 20
        @spawnTargetOffsetY = @y + rnd -20, 20
	
	update: =>
		super!
        @spawnMove! if @frame <= @restTime
		@moveTowardsPlayer! if @frame > @restTime

    spawnMove: =>
		@x += (@spawnTargetOffsetX - @x) * 0.05 
		@y += (@spawnTargetOffsetY - @y) * 0.05 

    collision: =>
		for obj in *objs
			if obj.type == types.Player
				if collide(obj, self)
					@kill!
                    sfx sounds.pickUp
                    obj.ammo[@ammoType] = min obj.ammo[@ammoType]+5, 400

	moveTowardsPlayer: =>
        targetX = @target.x + (@target.w*8)/2 -- get center of target
        targetY = @target.y + (@target.h*8)/2 -- get center of target
		@x += (targetX - @x) * 0.08 
		@y += (targetY - @y) * 0.08 

	draw: =>
		rectb @x, @y, 3, 3, @color


class YellowAmmo extends AmmoDrop
    ammoType: "Yellow"
    color: colors.LightYellow

class BlueAmmo extends AmmoDrop
    ammoType: "Blue"
    color: colors.LightBlue

class RedAmmo extends AmmoDrop
	ammoType: "Red"
	color: colors.LightRed