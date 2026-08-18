package sounds

import rl "vendor:raylib"

death_sound: rl.Sound
eat_sound: rl.Sound
theme_music: rl.Music

init::proc() {
    death_sound = rl.LoadSound("../assets/sounds/snake/death.mp3")
    eat_sound = rl.LoadSound("../assets/sounds/snake/eat.mp3")

    theme_music = rl.LoadMusicStream("../assets/sounds/background/theme.mp3")
    theme_music.looping = true
}

destroy::proc() {
    rl.UnloadSound(death_sound)
    rl.UnloadSound(eat_sound)
    rl.UnloadMusicStream(theme_music)
}

play_death::proc() {
    rl.PlaySound(death_sound)
}

play_eat::proc() {
    rl.PlaySound(eat_sound)
}

play_theme::proc() {
    rl.PlayMusicStream(theme_music)
}

update_theme::proc() {
    rl.UpdateMusicStream(theme_music)
}

restart_theme::proc() {
    rl.StopMusicStream(theme_music)
    rl.PlayMusicStream(theme_music)
}

stop_theme::proc() {
    rl.StopMusicStream(theme_music)
}

stop_all::proc() {
    rl.StopSound(death_sound)
    rl.StopSound(eat_sound)
}