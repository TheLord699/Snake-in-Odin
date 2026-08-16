package board

import rl "vendor:raylib"

food: struct {
    x: int,
    y: int,
    active: bool,
}

spawn_food::proc() {
    empty_count := 0
    for y in 0..<board.height {
        for x in 0..<board.width {
            if board.cells[y * board.width + x] == .EMPTY {
                empty_count += 1
            }
        }
    }
    
    if empty_count == 0 {
        return
    }
    
    for {
        x := rl.GetRandomValue(0, i32(board.width - 1))
        y := rl.GetRandomValue(0, i32(board.height - 1))
        
        cell := get_cell(int(x), int(y))
        if cell == .EMPTY {
            food.x = int(x)
            food.y = int(y)
            food.active = true
            set_cell(int(x), int(y), .FOOD)
            return
        }
    }
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
