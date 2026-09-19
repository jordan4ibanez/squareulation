import raylib;
import std.stdio;
import textures.textures;
import utility.grid;

void main() {

	auto map = Grid!int(5, 5);

	SetTraceLogLevel(TraceLogLevel.LOG_WARNING);
	SetConfigFlags(ConfigFlags.FLAG_WINDOW_RESIZABLE);

	validateRaylibBinding();
	InitWindow(800, 400, "Squareulation");
	SetTargetFPS(60);

	Textures.load();

	Camera2D camera;
	camera.target = Vector2(0, 0);
	camera.rotation = 0f;
	camera.zoom = 2.0f;

	while (!WindowShouldClose()) {

		BeginDrawing();
		ClearBackground(Colors.RAYWHITE);

		BeginMode2D(camera);

		auto windowWidth = GetScreenWidth();
		auto windowHeight = GetScreenHeight();

		camera.offset = Vector2(windowWidth / 2, windowHeight / 2);

		foreach (x; 0 .. 10) {
			foreach (y; 0 .. 10) {
				// DrawTextureEx(Textures.get("arrow.png"), x * 32, y * 32, Colors.WHITE);
				auto texture = Textures.get("arrow.png");
				auto source = Rectangle(0, 0, texture.width, texture.height);
				auto dest = Rectangle(x * 32, y * 32, 32, 32);
				DrawTexturePro(texture, source, dest, Vector2(0, 0), 0, Colors.WHITE);
			}
		}

		EndMode2D();

		EndDrawing();
	}

	writeln("Edit source/app.d to start your project.");

	CloseWindow();
}
