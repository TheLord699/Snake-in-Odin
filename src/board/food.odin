package board

import rl "vendor:raylib"

food: struct {
    x: int,
    y: int,
    active: bool,
}

spawn_food::proc() {
    empty_cells: [dynamic]struct{x, y: int}
    defer delete(empty_cells)
    
    for y in 0..<board.height {
        for x in 0..<board.width {
            if board.cells[y * board.width + x] == .EMPTY {
                append(&empty_cells, struct{x, y: int}{x, y})
            }
        }
    }
    
    if len(empty_cells) == 0 {
        return
    }
    
    index := rl.GetRandomValue(0, i32(len(empty_cells) - 1))
    pos := empty_cells[index]
    
    food.x = pos.x
    food.y = pos.y
    food.active = true
    set_cell(pos.x, pos.y, .FOOD)
}

remove_food::proc() {
    if food.active {
        set_cell(food.x, food.y, .EMPTY)
        food.active = false
    }
}

is_food_at::proc(x, y: int) -> bool {
    return food.active && food.x == x && food.y == y
}

get_food_pos::proc() -> (x, y: int, ok: bool) {
    if food.active {
        return food.x, food.y, true
    }
    return 0, 0, false
}

reset_food::proc() {
    remove_food()
    spawn_food()
}
