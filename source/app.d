import raylib;
import std.algorithm;
import std.conv;
import std.stdio;
import std.string;
import textures.textures;
import utility.delta;
import utility.grid;

void main() {

    // todo: fixed map size: 1024x1024

    const mapWidth = 1024;
    const tileSize = 32;

    auto map = Grid!int(mapWidth, mapWidth);

    SetTraceLogLevel(TraceLogLevel.LOG_WARNING);
    SetConfigFlags(ConfigFlags.FLAG_WINDOW_RESIZABLE);

    validateRaylibBinding();
    InitWindow(800, 400, "Squareulation");
    SetTargetFPS(0);

    Textures.load();

    // MaximizeWindow();

    Camera2D camera;
    camera.target = Vector2(0, 0);
    camera.rotation = 0f;
    camera.zoom = 2.0f;

    Vector2 playerPos;

    while (!WindowShouldClose()) {

        Delta.__calculateDelta();

        // writeln(Delta.getDelta());

        //? Logic.

        {
            if (IsKeyDown(KeyboardKey.KEY_A)) {
                playerPos.x -= 1;
            } else if (IsKeyDown(KeyboardKey.KEY_D)) {
                playerPos.x += 1;
            }

            if (IsKeyDown(KeyboardKey.KEY_W)) {
                playerPos.y -= 1;
            } else if (IsKeyDown(KeyboardKey.KEY_S)) {
                playerPos.y += 1;
            }
        }

        {

            float wheel = GetMouseWheelMove();
            if (wheel != 0f) {
                float zoomFactor = 1.1f;
                if (wheel > 0) {
                    camera.zoom *= zoomFactor;
                } else {
                    camera.zoom /= zoomFactor;
                }
                camera.zoom = clamp(camera.zoom, 0.1f, 10.0f);
            }
        }

        //? Rendering.

        BeginDrawing();
        ClearBackground(Colors.RAYWHITE);

        BeginMode2D(camera);

        auto windowWidth = GetScreenWidth();
        auto windowHeight = GetScreenHeight();

        camera.target = playerPos;

        auto halfWindow = Vector2(windowWidth / 2, windowHeight / 2);

        camera.offset = halfWindow;

    
        auto topLeft = GetScreenToWorld2D(Vector2(0, 0), camera);
        auto bottomRight = GetScreenToWorld2D(Vector2(windowWidth, windowHeight), camera);

        DrawCircle(cast(int) topLeft.x, cast(int) topLeft.y, 10, Colors.GREEN);
        DrawCircle(cast(int) bottomRight.x, cast(int) bottomRight.y, 10, Colors.BLUE);

        int count = 0;
        // This is really dumb and slow and is just proof of concept.
        foreach (x; 0 .. 10) {
            foreach (y; 0 .. 10) {
                // DrawTextureEx(Textures.get("arrow.png"), x * 32, y * 32, Colors.WHITE);

                auto pos = Vector2(x * tileSize, y * tileSize);
                auto dest = Rectangle(pos.x, pos.y, tileSize, tileSize);

                count++;

                {
                    //? Screen boundary check.
                    // Left bounds check.
                    auto worldPos = GetWorldToScreen2D(Vector2(pos.x + tileSize, pos.y), camera);
                    if (worldPos.x < 0) {
                        continue;
                    }
                    // Right bounds check.
                    worldPos = GetWorldToScreen2D(Vector2(pos.x, pos.y), camera);
                    if (worldPos.x > windowWidth) {
                        continue;
                    }

                    // Top bounds check.
                    worldPos = GetWorldToScreen2D(Vector2(pos.x, pos.y + tileSize), camera);
                    if (worldPos.y < 0) {
                        continue;
                    }
                    // Bottom bounds check.
                    worldPos = GetWorldToScreen2D(Vector2(pos.x, pos.y), camera);
                    if (worldPos.y > windowHeight) {
                        continue;
                    }
                }

                // auto texture = Textures.get("dirt.png");
                // auto source = Rectangle(0, 0, texture.width, texture.height);

                // DrawTexturePro(texture, source, dest, Vector2(0, 0), 0, Colors.WHITE);
                // // Debug to see the grid.
                // DrawRectangleLinesEx(dest, 0.25, Colors.RED);
            }
        }

        EndMode2D();

        // DrawText(("FPS:" ~ to!string(GetFPS()) ~ " | Loop count: " ~ to!string(count))
        //         .toStringz(), 0, 0, 48, Colors.RED);

        EndDrawing();
    }

    writeln("Edit source/app.d to start your project.");

    CloseWindow();
}
