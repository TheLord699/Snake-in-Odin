package game

import "core:fmt"
import rl "vendor:raylib"
import "../board"
import "../snake"

fps::60

init::proc(){
    screen_width: i32 = 800
    screen_height: i32 = 600

    rl.SetTargetFPS(fps)
    rl.InitWindow(screen_width, screen_height, "Snake Game")

    init_objects()
    game_loop()
}

init_objects::proc(){   
    board.init()
    snake.init()
}

render::proc(){
    board.render()
}

update::proc(){
    snake.update()
}

game_loop::proc(){
    for !rl.WindowShouldClose() {
        update()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        render()
        rl.EndDrawing()
    }
}