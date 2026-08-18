package sounds

import rl "vendor:raylib"

death_sound: rl.Sound
eat_sound: rl.Sound

init::proc() {
    death_sound = rl.LoadSound("../assets/sounds/death.mp3")
    eat_sound = rl.LoadSound("../assets/sounds/eat.mp3")
}

destroy::proc() {
    rl.UnloadSound(death_sound)
    rl.UnloadSound(eat_sound)
}

play_death::proc() {
    rl.PlaySound(death_sound)
}

play_eat::proc() {
    rl.PlaySound(eat_sound)
}

stop_all::proc() {
    rl.StopSound(death_sound)
    rl.StopSound(eat_sound)
}