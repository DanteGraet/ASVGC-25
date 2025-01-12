selectedBoat = {
    1, 1
}

local boats = {
    {
        {
            type = "default",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Wooden Boat",
            text = ""
        },
        {
            type = "default",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Original Boat",
            text = ""
        },
        {
            type = "default",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "IDK",
            text = ""
        },
        {
            type = "default",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "The Golden Boat",
            text = ""
        },
    },

    -- sail boats
    {
        {
            type = "sailboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Sail Boat",
            text = ""
        },
        {
            type = "sailboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "IDK",
            text = ""
        },
        {
            type = "sailboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "IDK2",
            text = ""
        },
        {
            type = "sailboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Golden sailboat?",
            text = ""
        },
    },

    --speed boats
    {
        {
            type = "speedboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Speedboat",
            text = ""
        },
        {
            type = "speedboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Hovercraft",
            text = ""
        },
        {
            type = "speedboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Wireframe",
            text = ""
        },
        {
            type = "speedboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Floatiest Boatyest",
            text = ""
        },
    },

    --IDK
    {
        {
            type = "idkboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "¯\\_(-_-)_/¯",
            text = ""
        },
        {
            type = "idkboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "0_0",
            text = ""
        },
        {
            type = "idkboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "IDK",
            text = ""
        },
        {
            type = "idkboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Golden thought",
            text = ""
        },
    },


    -- cargoboat
    {
        {
            type = "cargoboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Frigate",
            text = ""
        },
        {
            type = "cargoboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Yacht",
            text = ""
        },
        {
            type = "cargoboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Destroyer",
            text = ""
        },
        {
            type = "cargoboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Super Freighter",
            text = ""
        },
    },

    -- Alien boat
    {
        {
            type = "alienboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Alien Boat",
            text = ""
        },
        {
            type = "alienboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Vengeful Boat",
            text = ""
        },
        {
            type = "alienboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "IDK",
            text = ""
        },
        {
            type = "alienboat",
            skin = love.graphics.newImage("image/player/default.png"),
            name = "Fleet Comander", -- idk but at this point you obviously have unlocked some boats already i think
            text = ""
        },
    },
}

local modificationFunctions = {
    function(self)
        return
    end,
    
    function(self)
        self.minSpeed = 150
        self.maxSpeed = 200
        self.turnSpeed = math.pi/2
    end,

    function(self)
        self.minSpeed = 0
        self.maxSpeed = 500
        self.acceleration = 200
        self.turnSpeed = math.pi/5
    end,

    function(self)

    end,

    function(self)
        self.maxHealth = 6
        self.health = 6
        self.turnSpeed = math.pi/4
        self.acceleration = 100
    end,

    function(self)
        self.maxHealth = 7
        self.health = 7
        self.minSpeed = 0
        self.maxSpeed = 500
        self.turnSpeed = math.pi/2
        self.acceleration = 200
    end,
}

return {modifyBoat = modificationFunctions, data = boats}