module utility.grid;

struct Grid(T) {
    size_t width;
    size_t height;
    T[] data;

    this(size_t w, size_t h) {
        width = w;
        height = h;
        data = new T[](w * h);
    }

    this(size_t w, size_t h, T defaultValue = T.init) {
        width = w;
        height = h;
        data = new T[](w * h);
        data[] = defaultValue;
    }

    ref T opIndex(size_t x, size_t y) {
        return data[y * width + x];
    }
}
