module player;

import raylib;
import std.math;
import textures.textures;
import utility.delta;
import utility.game_constants;

static final const class Player {
static:

    Vector2 pos = Vector2(512, 512);
    float walkingAnimationThing = 0f;

    void move() {
        auto delta = Delta.getDelta();
        auto speed = 5.0;
        bool hit = false;

        if (IsKeyDown(KeyboardKey.KEY_A)) {
            this.pos.x -= speed * delta;
            hit = true;
        } else if (IsKeyDown(KeyboardKey.KEY_D)) {
            this.pos.x += speed * delta;
            hit = true;
        }

        if (IsKeyDown(KeyboardKey.KEY_W)) {
            this.pos.y -= speed * delta;
            hit = true;
        } else if (IsKeyDown(KeyboardKey.KEY_S)) {
            this.pos.y += speed * delta;
            hit = true;
        }

        if (hit) {
            walkingAnimationThing += delta * 30.0;
        }
    }

    Vector2 getPos() {
        return this.pos;
    }

    void draw() {
        auto playerTexture = Textures.get("player.png");
        auto source = Rectangle(0, 0, playerTexture.height, playerTexture.width);
        auto dest = Rectangle(this.pos.x * TILE_SIZE, this.pos.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);

        DrawTexturePro(playerTexture, source, dest, Vector2(TILE_SIZE / 2, TILE_SIZE / 2), cos(
                walkingAnimationThing) * 10.0, Colors.WHITE);
    }

}
