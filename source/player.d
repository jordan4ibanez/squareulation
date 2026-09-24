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

    void controls() {
        auto delta = Delta.getDelta();
        auto speed = 2.0;
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
            walkingAnimationThing += delta * speed * 10.0;
        }
    }

    Vector2 getPos() {
        return this.pos;
    }

    void draw() {

        // auto player = Rectangle(0, 0, 32, 32);
        // auto origin = Vector2(16, 16);

        // DrawRectanglePro(player, origin, 0, Colors.RED);

        auto playerTexture = Textures.get("player.png");
        auto source = Rectangle(0, 0, playerTexture.height, playerTexture.width);
        auto dest = Rectangle(this.pos.x, this.pos.y, 1, 1);

        DrawTexturePro(playerTexture, source, dest, Vector2(1.0 / 2.0, 1.0 / 2.0), cos(
                walkingAnimationThing) * 10.0, Colors.WHITE);
    }

}
