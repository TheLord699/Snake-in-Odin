package game

import "core:fmt"
import rl "vendor:raylib"
import "../board"
import "../snake"
import "../sounds"

fps::60
render_texture: rl.RenderTexture2D

init::proc(){
    rl.InitAudioDevice()
    sounds.init()

    screen_width: i32 = 800
    screen_height: i32 = 600

    rl.SetTargetFPS(fps)
    rl.InitWindow(screen_width, screen_height, "Snake Game")
    rl.SetWindowState({.WINDOW_RESIZABLE})
    
    render_texture = rl.LoadRenderTexture(800, 600)

    init_objects()
    game_loop()
}

destroy::proc(){
    sounds.destroy()
    rl.CloseAudioDevice()
    board.destroy()
    snake.destroy()
    rl.UnloadRenderTexture(render_texture)
    rl.CloseWindow()
}

init_objects::proc(){   
    board.init()
    snake.init()
}

render::proc(){
    rl.BeginTextureMode(render_texture)
    rl.ClearBackground(rl.BLACK)
    board.render()
    rl.EndTextureMode()
    
    src := rl.Rectangle{0, 0, 800, 600}
    dst := rl.Rectangle{0, 0, f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}
    
    rl.DrawTexturePro(render_texture.texture, src, dst, rl.Vector2{0, 0}, 0, rl.WHITE)
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
    destroy()
}