package sprite

import rl "vendor:raylib"


SpriteSheet :: struct {
    texture: rl.Texture2D,
    source_size: f32,
    draw_size: f32,
}

sprite_sheet: SpriteSheet

init :: proc() {
    sprite_sheet.texture = rl.LoadTexture(
        "../assets/sprites/graphics.png"
    )

    sprite_sheet.source_size = 64
    sprite_sheet.draw_size = 40
}

destroy :: proc() {
    rl.UnloadTexture(sprite_sheet.texture)
}

draw_sprite :: proc(
    source_x,
    source_y: i32,
    x,
    y: f32,
    rotation: f32,
    flip_y: bool,
) {
    source_height := sprite_sheet.source_size

    if flip_y {
        source_height = -source_height
    }

    source := rl.Rectangle{
        f32(source_x),
        f32(source_y),
        sprite_sheet.source_size,
        source_height,
    }

    half := sprite_sheet.draw_size * 0.5

    dest := rl.Rectangle{
        x + half,
        y + half,
        sprite_sheet.draw_size,
        sprite_sheet.draw_size,
    }

    rl.DrawTexturePro(
        sprite_sheet.texture,
        source,
        dest,
        rl.Vector2{half, half},
        rotation,
        rl.WHITE,
    )
}

Direction :: enum {Up, Down, Left, Right}

Frame :: struct {
    x, y:     i32,
    rotation: f32,
}

dir_of :: proc(v: [2]int) -> Direction {
    switch v {
    case {0, -1}: return .Up
    case {0, 1}: return .Down
    case {-1, 0}: return .Left
    case: return .Right
    }
}

HEAD_FRAMES := [Direction]Frame{
    .Up = {192, 0, 0},
    .Down = {256, 64, 0},
    .Left = {192, 64, 0},
    .Right = {256, 0, 0},
}

TAIL_FRAMES := [Direction]Frame{
    .Up = {192, 128, 180},
    .Down = {192, 128, 0},
    .Left = {256, 128, 0},
    .Right = {256, 128, 180},
}

draw_snake_head :: proc(direction: [2]int, x, y: f32) {
    frame := HEAD_FRAMES[dir_of(direction)]
    draw_sprite(frame.x, frame.y, x, y, frame.rotation, false)
}

draw_snake_tail :: proc(direction: [2]int, x, y: f32) {
    frame := TAIL_FRAMES[dir_of(direction)]
    draw_sprite(frame.x, frame.y, x, y, frame.rotation, false)
}

draw_snake_body :: proc(
    previous_direction,
    next_direction: [2]int,
    x,
    y: f32,
) {
    connections := bit_set[Direction]{
        dir_of(previous_direction),
        dir_of(next_direction),
    }

    frame: Frame

    switch connections {
    case {.Left, .Right}: frame = {64, 0, 0}
    case {.Up, .Down}: frame = {128, 64, 0}
    case {.Up, .Left}: frame = {128, 128, 0}
    case {.Up, .Right}: frame = {0, 64, 0}
    case {.Down, .Left}: frame = {128, 0, 0}
    case {.Down, .Right}: frame = {0, 0, 0}
    }

    draw_sprite(frame.x, frame.y, x, y, frame.rotation, false)
}

draw_apple :: proc(x, y: f32) {
    draw_sprite(0, 192, x, y, 0, true)
}
