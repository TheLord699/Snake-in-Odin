package board

import rl "vendor:raylib"
import "../sprite"

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

CELL_COLORS := [Cell]rl.Color{
    .EMPTY = rl.DARKGRAY,
    .WALL = rl.GRAY,
    .SNAKE = rl.DARKGRAY,
    .FOOD = rl.DARKGRAY,
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
            pos := rl.Vector2{
                f32(x) * CELL_SIZE,
                f32(y) * CELL_SIZE,
            }

            rl.DrawRectangleV(pos, size_vec, CELL_COLORS[cell])

            if cell == .FOOD {
                sprite.draw_apple(pos.x, pos.y)
            }

            rl.DrawRectangleLinesEx(
                rl.Rectangle{
                    pos.x,
                    pos.y,
                    CELL_SIZE,
                    CELL_SIZE,
                },
                1,
                rl.Color{65, 65, 65, 255},
            )
        }
    }
}