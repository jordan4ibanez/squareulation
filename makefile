default:
	@dub run

release_mode:
	@dub run --build=release

install:
	@dub upgrade
	@dub run raylib-d:install

clean:
	@dub clean

test:
	@dub test