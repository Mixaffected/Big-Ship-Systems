--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA


--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "5x3")
    simulator:setProperty("ExampleNumberProperty", 123)

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)

        -- NEW! button/slider options from the UI
        simulator:setInputBool(31, simulator:getIsClicked(1))     -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))      -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))     -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
    end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

-- Main screen = 0
-- map = 1

require("lib.stormworks-easy-buttons.easyButtons")

first_tick = true
first_draw = true

current_screen = 0

width = 0
height = 0

buttons = {
    [1] = {
        ["x"] = 0,
        ["y"] = 0,
        ["text"] = "M",
    },
    [2] = {
        ["x"] = 1,
        ["y"] = 0,
        ["text"] = "E",
    }
}

function onTick()
    if first_tick then
        first_tick = false

        for key, value in pairs(buttons) do
            newButton(value["x"] * 20 + 5, value["y"] * 20 + 3, 20, 20, value["text"], switch_screen, { key },
                { 255, 255, 255 }, nil,
                { 255, 255, 255, 120 }, nil,
                { 255, 255, 255 }, nil, 0, 0, "main")
            a = 1
        end
    end

    is_pressed = input.getBool(1)
    touch_x = input.getNumber(1)
    touch_y = input.getNumber(2)

    if current_screen ~= 0 then
        onTickButtons(is_pressed, touch_x, touch_y, "return")
        return
    end

    onTickButtons(is_pressed, touch_x, touch_y, "main")
end

function onDraw()
    if current_screen ~= 0 then
        onDrawButtons("return")
        return
    end

    if first_draw then
        first_draw = false

        width = screen.getWidth()
        height = screen.getHeight()
    end

    onDrawButtons("main")
end

function switch_screen(index)
    if index < 0 then
        index = 0
    end

    current_screen = index
end
