module player;

import raylib;
import std.math;
import std.stdio;
import textures.textures;
import utility.delta;
import utility.game_constants;

static final const class Player {
static:

    Vector2 pos = Vector2(0, 0);
    float yaw = 0.0f;
    float walkingAnimationThing = 0.0f;
    Vector2 selection = Vector2(-1, -1);

    void controls(Camera2D camera) {
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

        // This has been golfed cause all it does is set your yaw.
        auto mouseInWorld = GetScreenToWorld2D(GetMousePosition(), camera);

        // todo: make this check distance.
        selection = Vector2(floor(mouseInWorld.x), floor(mouseInWorld.y));

        Vector2 diff = Vector2Subtract(mouseInWorld, this.pos);
        this.yaw = atan2(diff.y, diff.x) * RAD2DEG;
    }

    Vector2 getPos() {
        return this.pos;
    }

    void draw() {

        if (IsCursorOnScreen() && selection.x >= 0 && selection.x < MAP_WIDTH && selection.y >= 0 && selection.y < MAP_WIDTH) {
            auto rect = Rectangle(selection.x, selection.y, 1, 1);
            DrawRectangleLinesEx(rect, 0.1, Colors.BLUE);
        }

        auto player = Rectangle(this.pos.x, this.pos.y, 0.35, 0.75);
        auto origin = Vector2(0.175, 0.375);
        DrawRectanglePro(player, origin, this.yaw, Colors.RED);

        auto head = Rectangle(this.pos.x, this.pos.y, 0.4, 0.4);
        auto headOrigin = Vector2(0.2, 0.2);
        DrawRectanglePro(head, headOrigin, this.yaw, Colors.BLUE);

        // auto playerTexture = Textures.get("player.png");
        // auto source = Rectangle(0, 0, playerTexture.height, playerTexture.width);
        // auto dest = Rectangle(this.pos.x, this.pos.y, 1, 1);

        // DrawTexturePro(playerTexture, source, dest, Vector2(1.0 / 2.0, 1.0 / 2.0), cos(
        //         walkingAnimationThing) * 10.0, Colors.WHITE);
    }

}
