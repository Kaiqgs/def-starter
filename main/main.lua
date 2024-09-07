local _gui = require("common._gui")
local stinger = require("common.gameobjects.stinger.stinger")
local util = require("common.util")
local duration = 2

local quad_id = "/quad#screen"

local get_urls = {
    quad_texture = function(socket)
        -- return msg.url(socket, "/quad", "screen")
        return quad_id
    end,
}

stinger.shader_animation = util.on_message_map({
    [stinger.open_stinger] = function(self, _, _, sender)
        self.delay_open = 0
        if self.delay_open then
            timer.delay(self.delay_open, false, function()
                go.animate(
                    get_urls.quad_texture(),
                    "stinger.z",
                    go.PLAYBACK_ONCE_FORWARD,
                    0.0,
                    go.EASING_OUTEXPO,
                    duration,
                    0,
                    function()
                        msg.post(sender, stinger.opened_stinger)
                    end
                )
            end)
            return
        end
        go.animate(
            get_urls.quad_texture(),
            "stinger.z",
            go.PLAYBACK_ONCE_FORWARD,
            0.0,
            go.EASING_OUTEXPO,
            duration,
            0,
            function()
                msg.post(sender, stinger.opened_stinger)
            end
        )
    end,
    [stinger.close_stinger] = function(self, _, _, sender)
        local second_step = 0.65
        -- local player_url = get_urls.player()
        -- if go.exists(player_url) then
        --     msg.post(player_url, "get_position")
        -- end
        -- local player_position = self.player_position or vmath.vector3()
        local function close()
            go.animate(
                get_urls.quad_texture(),
                "stinger.z",
                go.PLAYBACK_ONCE_FORWARD,
                1.0,
                go.EASING_INELASTIC,
                duration * (2 / 4),
                0,
                function()
                    msg.post(sender, stinger.closed_stinger)
                end
            )
        end
        go.animate(
            get_urls.quad_texture(),
            "stinger.z",
            go.PLAYBACK_ONCE_FORWARD,
            second_step,
            go.EASING_INEXPO,
            duration * (2 / 4),
            0,
            close
        )
        -- local screen_position = camera.world_to_screen(nil, player_position)
        -- go.set(get_urls.quad_texture(), "stinger.x", screen_position.x)
        -- go.set(get_urls.quad_texture(), "stinger.y", screen_position.y)
    end,
    -- [hash("position")] = function(self, _, message, _)
    --     self.player_position = message.position
    -- end,
})
local tile_size = 8
local display_size = vmath.vector3(320, 180, 0)
local proxy_collection = "proxy"
_gui.default_click_offset = vmath.vector3(1, -1, 0)
_gui.default_shadow_color = vmath.vector4(0, 0, 0, 1)
_gui.default_shadow_offset = vmath.vector3(1, -1, 0)
local M = {
    width = display_size.x,
    height = display_size.y,
    display_size = display_size,
    tile_size = tile_size,
    tile_vec = vmath.vector3(tile_size, tile_size, 0),
    flow = {
        end_game = hash("end_game"),
        next_game = hash("next_game"),
        start_game = hash("start_game"),
    },
    ids = {
        scene_manager = proxy_collection .. ":/controller#scene_manager",
        game_flow = proxy_collection .. ":/controller#game_flow",
        quad_texture = "/quad#screen",
    },
    scenes = {
        game = 1,
        menu = 2,
    },
    colllision = {
        default = hash("default"),
    },
}

return M
