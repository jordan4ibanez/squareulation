import player;
import raylib;
import std.algorithm;
import std.conv;
import std.getopt;
import std.math;
import std.random;
import std.stdio;
import std.string;
import textures.textures;
import utility.delta;
import utility.game_constants;
import utility.grid;

/** 
 * / ~ // todo: protect entity position in base class. build in get and set position into entity to automatically scale their position to normalization.
  *    ! OR, JUST use a special rendering get position to scale it up into the world. (probably a better idea)
 */
void main() {

    // todo: fixed map size: 1024x1024

    const mapWidth = 4096;

    auto map = Grid!int(mapWidth, mapWidth, 1);

    SetTraceLogLevel(TraceLogLevel.LOG_WARNING);
    SetConfigFlags(ConfigFlags.FLAG_WINDOW_RESIZABLE); // | ConfigFlags.FLAG_VSYNC_HINT);

    validateRaylibBinding();
    InitWindow(800, 400, "Squareulation");
    SetTargetFPS(0);

    Textures.load();

    // MaximizeWindow();

    Camera2D camera;
    camera.target = Vector2(0, 0);
    camera.rotation = 0f;
    camera.zoom = 175.0f;

    while (!WindowShouldClose()) {
        Delta.__calculateDelta();

        //? Logic.

        Player.controls(camera);

        {

            float wheel = GetMouseWheelMove();
            if (wheel != 0f) {
                float zoomFactor = 1.1f;
                if (wheel > 0) {
                    camera.zoom *= zoomFactor;
                } else {
                    camera.zoom /= zoomFactor;
                }
                camera.zoom = clamp(camera.zoom, 80.0f, 900.0f);
                // writeln(camera.zoom);
            }
        }

        //? Rendering.

        BeginDrawing();
        ClearBackground(Colors.BLACK);

        // It must center on the player before 2D mode begins or else it is rubber banding towards the player.
        auto windowWidth = GetScreenWidth();
        auto windowHeight = GetScreenHeight();
        camera.target = Player.getPos();
        auto halfWindow = Vector2(windowWidth / 2, windowHeight / 2);
        camera.offset = halfWindow;

        BeginMode2D(camera);

        // Get the top left and bottom right screen coordinates to make this render only what's needed.
        auto renderTopLeft = GetScreenToWorld2D(Vector2(0, 0), camera);
        auto renderBottomRight = Vector2Add(GetScreenToWorld2D(Vector2(windowWidth, windowHeight), camera),
            Vector2(1, 1));

        int startX = cast(int) clamp(renderTopLeft.x, 0, mapWidth);
        int endX = cast(int) clamp(renderBottomRight.x, 0, mapWidth);

        int startY = cast(int) clamp(renderTopLeft.y, 0, mapWidth);
        int endY = cast(int) clamp(renderBottomRight.y, 0, mapWidth);

        // writeln("width:" ~ to!string(endX - startX));
        // writeln("height:" ~ to!string(endY - startY));

        int count = 0;
        // This is really dumb and slow and is just proof of concept.
        foreach (x; startX .. endX) {
            foreach (y; startY .. endY) {
                // DrawTextureEx(Textures.get("arrow.png"), x * 32, y * 32, Colors.WHITE);

                auto pos = Vector2(x, y);
                auto dest = Rectangle(pos.x, pos.y, 1, 1);

                count++;

                {
                    //? Screen boundary check.
                    // Left bounds check.
                    auto worldPos = GetWorldToScreen2D(Vector2(pos.x + 1, pos.y), camera);
                    if (worldPos.x < 0) {
                        continue;
                    }
                    // Right bounds check.
                    worldPos = GetWorldToScreen2D(Vector2(pos.x, pos.y), camera);
                    if (worldPos.x > windowWidth) {
                        continue;
                    }

                    // Top bounds check.
                    worldPos = GetWorldToScreen2D(Vector2(pos.x, pos.y + 1), camera);
                    if (worldPos.y < 0) {
                        continue;
                    }
                    // Bottom bounds check.
                    worldPos = GetWorldToScreen2D(Vector2(pos.x, pos.y), camera);
                    if (worldPos.y > windowHeight) {
                        continue;
                    }
                }

                if (map[x, y] == 1) {
                    auto texture = Textures.get("dirt.png");
                    auto source = Rectangle(0, 0, texture.width, texture.height);

                    DrawTexturePro(texture, source, dest, Vector2(0, 0), 0, Colors.WHITE);
                    // Debug to see the grid.
                    DrawRectangleLinesEx(dest, 0.01, Colors.RED);
                }

            }
        }

        // The player.

        Player.draw();

        DrawCircleV(renderTopLeft, 0.2, Colors.GREEN);
        DrawCircleV(renderBottomRight - 1, 0.2, Colors
                .BLUE);

        EndMode2D();

        DrawText(("FPS:" ~ to!string(GetFPS()) ~ " | Loop count: " ~ to!string(count))
                .toStringz(), 0, 0, 48, Colors.RED);

        DrawText(("POSX:" ~ to!string(Player.getPos().x)).toStringz(), 0, 48, 48, Colors.GREEN);
        DrawText(("POSY:" ~ to!string(Player.getPos().y)).toStringz(), 0, 96, 48, Colors.GREEN);

        EndDrawing();
    }

    writeln("Edit source/app.d to start your project.");

    CloseWindow();
}
