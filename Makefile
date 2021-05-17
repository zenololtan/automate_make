NAME = naam

SRCS =	pa.c \
		pb.c \
		ra.c \
		rd.c \
		rr.c \
		rra.c \
		rrb.c \
		rrr.c \
		sa.c \
		sb.c \
		ss.c

TEST =	l.c \
		lol.c \
		yah.c

SRCS_PREFIX = $(addprefix srcs/, $(SRCS))

TEST_PREFIX = $(addprefix test/, $(TEST))

SRC =	$(SRCS_PREFIX) \
		$(TEST_PREFIX)

OBJ = $(SRC:.c=.o)

FLAGS = -Wall -Wextra -Werror

CC = gcc

all: $(NAME)

$(NAME): $(OBJ)
		@$(CC) $(FLAGS) $(OBJ) $(INCLUDES) -g -o $(NAME)

%.o: %.c
		$(CC) $(FLAGS) $(INCLUDES) -g -c $< -o $@

clean:
		rm -f $(OBJ)

fclean: clean
		rm -f $(NAME)

re: fclean all

