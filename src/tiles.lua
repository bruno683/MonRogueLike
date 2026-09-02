local tiles = {}

tiles[1] = {id = 0, name = "floor", walkable = true, color = {1,1,1}}
tiles[2] = {id = 1, name = "wall", walkable = false, color = {1,1,1}}
tiles[3] = {id = 2, name = "tree", walkable = false, color = {0,0.5,0}}
tiles[4] = {id = 3, name = "water", walkable = false, color = {0,0,0.8}}
tiles[5] = {id = 4, name = "door", isOpen = false, walkable = false, color = {0.51, 0.26,0.04, 0.8}}

return tiles