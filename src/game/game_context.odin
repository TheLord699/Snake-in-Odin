package game

import "../sounds"

context_init::proc() {
    sounds.play_theme()
}

context_update::proc() {
    sounds.update_theme()
}

context_destroy::proc() {
    sounds.stop_theme()
}
