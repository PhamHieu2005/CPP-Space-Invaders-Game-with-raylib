# ===== HaikuOS + raylib (C++) Makefile =====
# Cấu trúc mặc định:
#   src/        -> *.cpp
#   include/    -> *.h (tuỳ chọn)
#   lib/        -> (tuỳ chọn) chứa raylib đã build sẵn: include/, lib/
#
# Dùng:
#   make            # build
#   make run        # chạy ./game
#   make clean      # xoá file build

PROJECT_NAME ?= game

CXX       := g++
CXXFLAGS  := -std=c++17 -O2 -Wall -Wno-missing-braces -D_DEFAULT_SOURCE
# Thêm -I include nếu có thư mục include/
INCLUDE_PATHS := -I./src -I./include

# --- Tuỳ chọn: chỉ định đường dẫn raylib thủ công (nếu không cài hệ thống) ---
# Ví dụ: make RAYLIB_INC=./lib/raylib/include RAYLIB_LIB=./lib/raylib/lib
RAYLIB_INC ?=
RAYLIB_LIB ?=
ifneq ($(strip $(RAYLIB_INC)),)
  INCLUDE_PATHS += -I$(RAYLIB_INC)
endif
ifneq ($(strip $(RAYLIB_LIB)),)
  LDFLAGS += -L$(RAYLIB_LIB)
endif

# Link lib cho Haiku (không dùng X11)
LDLIBS := -lraylib -lGL -lpthread -lm -lbe

SRC_DIR := src
OBJ_DIR := obj

SRC  := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRC))

.PHONY: all clean run

all: $(PROJECT_NAME)

$(PROJECT_NAME): $(OBJS)
	$(CXX) $(OBJS) $(LDFLAGS) $(LDLIBS) -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) $(INCLUDE_PATHS) -DPLATFORM_DESKTOP -c $< -o $@

run: $(PROJECT_NAME)
	./$(PROJECT_NAME)

clean:
	rm -rf $(OBJ_DIR) $(PROJECT_NAME)
