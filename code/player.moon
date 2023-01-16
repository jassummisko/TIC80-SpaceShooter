class Plr extends Entity
	type: types.Player
	speed: 2
	spr: 256
	alpha: 1
	w: 2
	h: 1
	cooldown: 0
	wpn: 0
	score: 0
	health: 1
	ammo: {
		Yellow: 0
		Blue: 0
		Red: 400
	}

	update: =>
		@controls!
		@cooldown -= 1 if @cooldown > 0

		fuelCols = {colors.LightRed, colors.DarkYellow, colors.Gray}
		for i=1, 2
			add particles, 
				Particle @x, @y+4, (160+rnd 40), (rnd 1, 3)/2, 
					fuelCols[rnd #fuelCols], (rnd 10, 30)

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
			WEAPONS[@wpn](self)\shoot!
		if btnp 5
			@wpn = (@wpn + 1) % (#WEAPONS+1)

	kill: =>
		sfx(sounds.boom, 0, 120, 0)
		for i=1, 15
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add particles, (Scrap @x+8, @y+4, dir, 0, colors.Gray, life)
		@alive = false

	damage: (amt) => @health -= amt