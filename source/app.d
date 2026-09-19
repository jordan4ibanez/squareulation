import raylib;
import std.stdio;
import textures.textures;
import utility.grid;

void main() {

	auto map = Grid!int(5, 5);

	SetTraceLogLevel(TraceLogLevel.LOG_WARNING);

	validateRaylibBinding();
	InitWindow(800, 400, "Squareulation");
	SetTargetFPS(60);

	Textures.load();

	while (!WindowShouldClose()) {

		BeginDrawing();
		ClearBackground(Colors.RAYWHITE);

		foreach (x; 0 .. 10) {
			foreach (y; 0 .. 10) {
				// DrawTextureEx(Textures.get("arrow.png"), x * 32, y * 32, Colors.WHITE);
				auto texture = Textures.get("arrow.png");
				auto source = Rectangle(0, 0, texture.width, texture.height);
				auto dest = Rectangle(x * 32, y * 32, 32, 32);
				DrawTexturePro(texture, source, dest, Vector2(0, 0), 0, Colors.WHITE);
			}
		}

		EndDrawing();
	}

	writeln("Edit source/app.d to start your project.");

	CloseWindow();
}
