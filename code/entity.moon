class Entity
	type: types.None
	new: (x, y, flip) =>
		@type = @type or types.None
		@x = x or 60
		@y = y or scr.height/2
		@flip = flip or false
		@alpha = @alpha or 0
		@rot = 0
		@w = @w or 1
		@h = @h or 1
		@spr = @spr or 256
		@alive = true
		@frame = 0

	update: =>
		@frame += 1

	draw: =>
		spr(@spr, @x, @y, @alpha, 1, @flip, @rot, @w, @h)

	kill: =>
		@alive = false
