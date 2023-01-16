export doCollisions = (objs) ->
	for i, obj1 in ipairs objs
		for obj2 in *objs[i,]

			--use "continue if" to override collision (also used it for each new collision for performance reasons)
			--otherwise, do not use "continue if"

			continue if doCollide obj1, Plr, obj2, Enemy, ->
				obj1\kill!
				obj2\kill!
			
			continue if doCollide obj1, Plr, obj2, Projectile, ->
				if obj2.enemy
					obj1\kill!
					obj2\kill! 
			
			continue if doCollide obj1, Enemy, obj2, Bolt, ->
				obj1\damage obj2.damageVal unless obj2.enemy

			doCollide obj1, Enemy, obj2, Bomb, ->
				obj2\explode! unless obj2.exploded
				
			continue if doCollide obj1, Enemy, obj2, Projectile, ->
				unless obj2.enemy
					obj1\damage obj2.damageVal
					obj2\kill!

			continue if doCollide obj1, Plr, obj2, AmmoDrop, ->
				obj2\kill!
				sfx sounds.pickUp
				obj1.ammo[obj2.ammoType] = min obj1.ammo[obj2.ammoType]+5, 400 