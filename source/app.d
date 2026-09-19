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
		DrawText("Hello, World!", 400, 300, 28, Colors.BLACK);
		EndDrawing();
	}

	writeln("Edit source/app.d to start your project.");

	CloseWindow();
}
