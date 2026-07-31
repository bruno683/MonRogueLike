-- module intention_system.lua
-- utilisation :
-- local Intent = require("intention_system")


local Intent = {}
Intent.__index = Intent
-- Constructeur pour créer une nouvelle intention
function Intent.new(name, condition, execute)
    local self = setmetatable({}, Intent)
    self.name = name
    self.condition = condition -- Fonction qui retourne vrai/faux
    self.execute = execute     -- Action à exécuter dans LÖVE2D (déplacement, animation...)
    return self
end


-- Gestionnaire d'intention pour un pnj
local NPC = {}

NPC.__index = NPC
-- Constructeur pour créer un nouveau pnj
function NPC.new(name)
    local self = setmetatable({}, NPC)
    self.name = name
    self.Health = 100
    self.Position = {x = 0, y = 0}
    self.Speed = 100
    self.Animation = nil
    self.State = "idle"
    self.intents = {}
    self.CurrentIntent = nil
    return self
end

-- Constructeur pour ajouter une intention à un pnj
function NPC:addIntent(intent)
    table.insert(self.intents, intent)
end

-- Execution de l'intention du pnj en fonction de la condition
function NPC:executeIntent()
    for _, intent in ipairs(self.intents) do
        if intent.condition() then
            intent.execute()
            break -- Exécuter la première intention dont la condition est vraie
        end
    end
end





return Intent