package board

import "core:fmt"
import rl "vendor:raylib"

Cell::enum u8 {
    EMPTY,
    WALL,
    SNAKE,
    FOOD,
}

Board::struct {
    width: int,
    height: int,
    cells: []Cell,
}

CELL_COLORS := [4]rl.Color{
    rl.DARKGRAY,
    rl.GRAY,
    rl.GREEN,
    rl.RED,
}

board: Board 

init::proc() {
    board.width = 20
    board.height = 15
    board.cells = make([]Cell, board.width * board.height)
    
    for i in 0..<len(board.cells) {
        board.cells[i] = .EMPTY
    }

    build_grid()
    spawn_food()
}

destroy::proc() {
    delete(board.cells)
}

build_grid::proc() {
    for i in 0..<len(board.cells) {
        board.cells[i] = .EMPTY
    }
    
    for x in 0..<board.width {
        set_cell(x, 0, .WALL)    
        set_cell(x, board.height - 1, .WALL) 
    }
    for y in 0..<board.height {
        set_cell(0, y, .WALL)           
        set_cell(board.width - 1, y, .WALL) 
    }  
}

get_cell::proc(x, y: int) -> Cell {
    if x < 0 || x >= board.width || y < 0 || y >= board.height {
        return .WALL
    }
    return board.cells[y * board.width + x]
}

set_cell::proc(x, y: int, value: Cell) {
    if x < 0 || x >= board.width || y < 0 || y >= board.height {
        return
    }
    board.cells[y * board.width + x] = value
}

is_valid_pos::proc(x, y: int) -> bool {
    return x >= 0 && x < board.width && y >= 0 && y < board.height
}

render::proc() {
    CELL_SIZE::f32(40)
    size_vec := rl.Vector2{CELL_SIZE, CELL_SIZE}
    
    for y in 0..<board.height {
        for x in 0..<board.width {
            cell := board.cells[y * board.width + x]
            pos := rl.Vector2{f32(x) * CELL_SIZE, f32(y) * CELL_SIZE}
            
            rl.DrawRectangleV(pos, size_vec, CELL_COLORS[cell])
            rl.DrawRectangleLinesEx(
                rl.Rectangle{pos.x, pos.y, CELL_SIZE, CELL_SIZE},
                1,
                rl.Color{65, 65, 65, 255},
            )
        }
    }
}

get_xy_from_index::proc(index: int) -> (x, y: int) {
    x = index % board.width
    y = index / board.width
    return
}

get_index::proc(x, y: int) -> int {
    return y * board.width + x
}

print::proc() {
    for y in 0..<board.height {
        for x in 0..<board.width {
            cell := board.cells[y * board.width + x]
            char: u8
            switch cell {
                case .EMPTY: char = '.'
                case .WALL:  char = '#'
                case .SNAKE: char = 'S'
                case .FOOD:  char = 'F'
            }
            fmt.printf("%c", char)
        }
        fmt.println()
    }
}
