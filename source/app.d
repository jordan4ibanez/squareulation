import raylib;
import std.stdio;
import utility.grid;

void main() {

	validateRaylibBinding();
	InitWindow(800, 400, "Squareulation");
	SetTargetFPS(60);
	while (!WindowShouldClose()) {

		BeginDrawing();
		ClearBackground(Colors.RAYWHITE);
		DrawText("Hello, World!", 400, 300, 28, Colors.BLACK);
		EndDrawing();
	}

	auto map = Grid!int(5, 5);

	writeln("Edit source/app.d to start your project.");

	writeln(map[4, 4]);
	CloseWindow();
}
