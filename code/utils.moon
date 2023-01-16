do --table functions
	export add = table.insert
	export pop = table.remove
	export delObj = (tab, element) ->
		for i=#tab, 1, -1
			if tab[i] == element
				pop(tab, i)
	export removeObjs = (tab) ->
		for i=#tab, 1, -1
			if tab[i].alive == false
				pop(tab, i)
	export containsType = (tab, typ) ->
		for i=#tab, 1, -1
			if tab[i].type == typ
				return true
		return false
	export unpack = table.unpack

do --class functions
	export inheritsFrom = (obj, cls) ->
		result = false
		return true if obj.__class == cls
		c = obj.__class
		while c.__parent != nil
			if c.__parent == cls
				result = true
				break
			c = c.__parent
		result

	export doCollide = (obj1, c1, obj2, c2, func) ->
		cond1 = (inheritsFrom obj1, c1) and (inheritsFrom obj2, c2)
		cond2 = (inheritsFrom obj1, c2) and (inheritsFrom obj2, c1) 
		if cond1 or cond2
			func!
			return true
		return false

do --math functions
	_G[k] = v for k, v in pairs math
	export rnd = math.random
	export flr = math.floor
	
do --utilities
	export unpack = table.unpack
	export printShadow = (text, x, y, colShadow, colText) ->
		print text, x+1, y+1, colShadow
		print text, x, y, colText

	export collide = (o1, o2) ->
		hit = false

		tileSize = 8
		w1 = o1.w*tileSize
		w2 = o2.w*tileSize
		h1 = o1.h*tileSize
		h2 = o2.h*tileSize
		x1, x2 = o1.x, o2.x
		y1, y2 = o1.y, o2.y

		xs = w1/2 + w2/2
		ys = h1/2 + h2/2
		xd = abs (x1 + w1/2) - (x2 + w2/2) 
		yd = abs (y1 + h1/2) - (y2 + h2/2) 

		if xd<xs and yd<ys then
			hit = true

		return hit

	export pal = (...) ->
		args = {...}
		if #args == 2
			c1 = args[1]
			c2 = args[2]
			PALETTE_MAP = 0x3FF0
			poke4(PALETTE_MAP * 2 + c1, c2)
		elseif #args == 1
			c1 = args[1]
			pal(c1, c1)

	export updateAll = (tab) -> (unless element == nil then element\update!) for element in *tab
	export drawAll = (tab) -> (unless element == nil then element\draw!) for element in *tab