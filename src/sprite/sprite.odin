package sprite

import rl "vendor:raylib"


SpriteSheet::struct {
    texture: rl.Texture2D,
    source_size: f32,
    draw_size: f32,
}

sprite_sheet: SpriteSheet


init::proc() {
    sprite_sheet.texture = rl.LoadTexture(
        "../assets/sprites/graphics.png"
    )

    sprite_sheet.source_size = 64
    sprite_sheet.draw_size = 40
}


destroy::proc() {
    rl.UnloadTexture(sprite_sheet.texture)
}


draw_sprite::proc(
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

    dest := rl.Rectangle{
        x + sprite_sheet.draw_size * 0.5,
        y + sprite_sheet.draw_size * 0.5,
        sprite_sheet.draw_size,
        sprite_sheet.draw_size,
    }

    rl.DrawTexturePro(
        sprite_sheet.texture,
        source,
        dest,
        rl.Vector2{
            sprite_sheet.draw_size * 0.5,
            sprite_sheet.draw_size * 0.5,
        },
        rotation,
        rl.WHITE,
    )
}

draw_snake_head::proc(
    direction: [2]int,
    x,
    y: f32,
) {
    if direction == {0, -1} {
        draw_sprite(
            192,
            0,
            x,
            y,
            0,
            false,
        )

    } else if direction == {1, 0} {
        draw_sprite(
            256,
            0,
            x,
            y,
            0,
            false,
        )

    } else if direction == {-1, 0} {
        draw_sprite(
            192,
            64,
            x,
            y,
            0,
            false,
        )

    } else {
        draw_sprite(
            256,
            64,
            x,
            y,
            0,
            false,
        )
    }
}

draw_snake_tail::proc(
    direction: [2]int,
    x,
    y: f32,
) {
    if direction == {0, 1} {
        draw_sprite(
            192,
            128,
            x,
            y,
            0,
            false,
        )

    } else if direction == {0, -1} {
        draw_sprite(
            192,
            128,
            x,
            y,
            180,
            false,
        )

    } else if direction == {-1, 0} {
        draw_sprite(
            256,
            128,
            x,
            y,
            0,
            false,
        )

    } else {
        draw_sprite(
            256,
            128,
            x,
            y,
            180,
            false,
        )
    }
}

draw_snake_body::proc(
    previous_direction: [2]int,
    next_direction: [2]int,
    x,
    y: f32,
) {
    if (
        previous_direction[1] == 0 &&
        next_direction[1] == 0
    ) {
        draw_sprite(
            64,
            0,
            x,
            y,
            0,
            false,
        )

        return
    }

    if (
        previous_direction[0] == 0 &&
        next_direction[0] == 0
    ) {
        draw_sprite(
            128,
            64,
            x,
            y,
            0,
            false,
        )

        return
    }

    connects_up := (
        previous_direction == {0, -1} ||
        next_direction == {0, -1}
    )

    connects_down := (
        previous_direction == {0, 1} ||
        next_direction == {0, 1}
    )

    connects_left := (
        previous_direction == {-1, 0} ||
        next_direction == {-1, 0}
    )

    connects_right := (
        previous_direction == {1, 0} ||
        next_direction == {1, 0}
    )

    if connects_up && connects_left {
        draw_sprite(
            128,
            128,
            x,
            y,
            0,
            false,
        )

        return
    }


    if connects_up && connects_right {
        draw_sprite(
            0,
            64,
            x,
            y,
            0,
            false,
        )

        return
    }

    if connects_down && connects_left {
        draw_sprite(
            128,
            0,
            x,
            y,
            0,
            false,
        )

        return
    }

    if connects_down && connects_right {
        draw_sprite(
            0,
            0,
            x,
            y,
            0,
            false,
        )

        return
    }
}


draw_apple::proc(
    x,
    y: f32,
) {
    draw_sprite(
        0,
        192,
        x,
        y,
        0,
        true,
    )
}