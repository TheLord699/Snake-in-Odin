package snake

import rl "vendor:raylib"
import "../board"

Segment :: struct {
    x, y: int,
}

snake: struct {
    body: [dynamic]Segment,
    direction: [2]int,
    dead: bool,
    growing: bool,
    next_direction: [2]int,
}

move_timer: f32 = 0
MOVE_DELAY :: 0.2

init :: proc() {
    snake.body = make([dynamic]Segment)
    reset()
}

destroy :: proc() {
    delete(snake.body)
}

update :: proc() {
    if snake.dead {
        if rl.IsKeyPressed(.R) {
            board.reset_food()
            reset()
        }
        return
    }
    
    if rl.IsKeyPressed(.W) || rl.IsKeyPressed(.UP) {
        if snake.direction != {0, -1} {
            snake.next_direction = {0, 1}
        }
    }
    if rl.IsKeyPressed(.S) || rl.IsKeyPressed(.DOWN) {
        if snake.direction != {0, 1} {
            snake.next_direction = {0, -1}
        }
    }
    if rl.IsKeyPressed(.A) || rl.IsKeyPressed(.LEFT) {
        if snake.direction != {1, 0} {
            snake.next_direction = {-1, 0}
        }
    }
    if rl.IsKeyPressed(.D) || rl.IsKeyPressed(.RIGHT) {
        if snake.direction != {-1, 0} {
            snake.next_direction = {1, 0}
        }
    }
    
    move_timer += rl.GetFrameTime()
    if move_timer < MOVE_DELAY {
        return
    }
    move_timer = 0
    
    snake.direction = snake.next_direction
    
    head := snake.body[0]
    new_head := Segment{
        head.x + snake.direction[0],
        head.y + snake.direction[1],
    }
    
    if !board.is_valid_pos(new_head.x, new_head.y) {
        snake.dead = true
        return
    }
    
    cell := board.get_cell(new_head.x, new_head.y)
    
    if cell == .WALL {
        snake.dead = true
        return
    }
    
    tail_index := len(snake.body) - 1
    for i in 0..<len(snake.body) {
        if !snake.growing && i == tail_index {
            continue
        }
        if snake.body[i].x == new_head.x && snake.body[i].y == new_head.y {
            snake.dead = true
            return
        }
    }
    
    if cell == .FOOD {
        snake.growing = true
        board.remove_food()
        board.spawn_food()
    }
    
    old_tail := snake.body[tail_index]
    
    if !snake.growing {
        board.set_cell(old_tail.x, old_tail.y, .EMPTY)
    }
    
    for i := len(snake.body) - 1; i > 0; i -= 1 {
        snake.body[i] = snake.body[i - 1]
    }
    snake.body[0] = new_head
    
    if snake.growing {
        append(&snake.body, old_tail)
        snake.growing = false
    }
    
    board.set_cell(new_head.x, new_head.y, .SNAKE)
}

is_dead :: proc() -> bool {
    return snake.dead
}

reset :: proc() {
    for seg in snake.body {
        board.set_cell(seg.x, seg.y, .EMPTY)
    }
    
    snake.direction = {1, 0}
    snake.next_direction = {1, 0}
    snake.dead = false
    snake.growing = false
    move_timer = 0
    
    clear(&snake.body)
    
    start_x := board.board.width / 2
    start_y := board.board.height / 2
    append(&snake.body, Segment{start_x, start_y})
    
    board.set_cell(start_x, start_y, .SNAKE)
}