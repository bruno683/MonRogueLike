local tiles = {}

tiles[1] = {id = 0, name = "floor", isTransparent = true, walkable = true, color = {1,1,1}}
tiles[2] = {id = 1, name = "wall",isTransparent = false, walkable = false, color = {1,1,1}}
tiles[3] = {id = 2, name = "tree", isTransparent = false, walkable = false, color = {0,0.5,0}}
tiles[4] = {id = 3, name = "water", isTransparent = false, walkable = false, color = {0,0,0.8}}
tiles[5] = {id = 4, name = "door", isTransparent = false, isOpen = false, walkable = false, color = {0.51, 0.26,0.04, 0.8}}

return tiles