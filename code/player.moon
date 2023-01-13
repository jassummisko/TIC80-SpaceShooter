--Player
class Plr extends Entity
	type: types.Player
	speed: 2
	spr: 256
	alpha: 1
	w: 2
	h: 1
	cooldown: 0
	wpn: weapons.Bullet
	wpns: {
		[0]: weapons.Bullet
		[1]: weapons.Bolt
		[2]: weapons.Bomb
	}
	score: 0
	health: 1
	ammo: {
		Yellow: 0
		Blue: 0
		Green: 0
		Red: 0
	}

	update: =>
		@controls!
		@cooldown -= 1 if @cooldown > 0

		fuelCols = {colors.LightRed, colors.DarkYellow, colors.Gray}
		for i=1, 2
			add particles, 
				Particle @x, @y+4, (160+rnd 40), (rnd 1, 3)/2, 
					fuelCols[rnd #fuelCols], (rnd 10, 30)

		@collision!
		@die! if @health <= 0

	draw: => 
		super!

	controls: =>
		if btn 0
			@y = max @y-@speed, 8
		if btn 1
			@y = min @y+@speed, scr.height-16
		if btn 2
			@x = max @x-@speed, 0
		if btn 3
			@x = min @x+@speed, scr.width-16
		if btn 4
			@shoot!
		if btnp 5
			@wpn = (@wpn + 1) % (#@wpns+1)


	shoot: =>
		switch @wpn 
			when weapons.Bullet
				bullet = Bullet @x+16, @y
				if @cooldown == 0
					@cooldown = bullet.cooldown
					sfx bullet.sfx, 24, 120, 1
					add objs, bullet
			
			when weapons.Bolt
				bullet = Bolt @x+16, @y
				if @cooldown == 0 	
					@cooldown = bullet.cooldown
					if @ammo.Yellow >= 3
						sfx bullet.sfx, 24, 120, 1
						add objs, bullet
						@ammo.Yellow -= 3
					else 
						for i=1, rnd 0, 1
							add particles, 
								Particle @x+@w*8, @y+4, (20 - rnd 40), 
									(rnd 1, 3), colors.LightYellow, (rnd 10, 30)

			when weapons.Bomb
				bullet = Bomb @x+16, @y
				if @cooldown == 0
					@cooldown = bullet.cooldown
					add objs, bullet


	die: =>
		sfx(sounds.boom, 0, 120, 0)
		for i=1, 15
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add particles, (Scrap @x+8, @y+4, dir, 0, colors.Gray, life)
		@alive = false

	damage: (amt) => @health -= amt

	collision: =>
		for obj in *objs
			if obj.type == types.Enemy or obj.type == types.EnemyProjectile
				if collide(obj, self)
					@die!
					obj\kill!