sources := ts_sdl2.c scm.c # fixme
objects = $(sources:.c=.o)
tinyschemedir := $(HOME)/src/tinyscheme-1.41
CFLAGS += -Werror -Wfatal-errors
CFLAGS += -std=c99  # fixme
CFLAGS += -I $(tinyschemedir) -DUSE_DL=1
CFLAGS += -fPIC
CFLAGS += -I ~/include -L ~/lib
CFLAGS +=-Wl,-rpath=/home/gmcnutt/lib

sdl2lib := ts_sdl2.so

ifeq ($(OPTIMIZE), true)
	CFLAGS += -O2
else
	CFLAGS += -Wall -g
endif

all: $(sdl2lib)

$(sdl2lib): $(objects) Makefile
	$(CC) -I $(tinyschemedir) -shared $(CFLAGS) -DUSE_DL=1 -o $@ $(objects) -lcu -lSDL2 -lSDL2_image -Wl,-rpath=/usr/local/lib
	#strip $(sdl2lib)

run: $(sdl2lib) main.scm
	TINYSCHEMEINIT=$(tinyschemedir)/init.scm $(tinyschemedir)/scheme main.scm

clean:
	rm -f *.o $(sdl2lib) $(isolib) demo
