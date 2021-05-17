#!/bin/bash

NAME=$1
for ARG in "${@:2}"; do
	TEMP=$(echo "$ARG" | tr '[:lower:]' '[:upper:]')
	EXCL_DIR+=(${TEMP})
done
DIRS=($(ls -d */ | sed 's/\///g' | tr '[:lower:]' '[:upper:]'))

echo "NAME = ${NAME}" > Makefile
echo "" >> Makefile

for i in ${!DIRS[@]}; do
	if [[ ! "${EXCL_DIR[@]}" =~ "${DIRS[i]}" ]]; then
		DIR_FINAL+=(${DIRS[i]})
		DIR_FINAL_LOW+=($(echo "${DIRS[i]}" | tr '[:upper:]' '[:lower:]'))
	fi
done

for i in ${!DIR_FINAL[@]}; do
	echo -n "${DIR_FINAL[i]} =" >> Makefile
	CFILES=($(ls ${DIR_FINAL_LOW[i]} | grep \.c))
	echo "	${CFILES[0]} \\" >> Makefile
	for j in ${!CFILES[@]}; do
		if [[ $j -ne 0 ]]; then
			echo -n "		${CFILES[j]}" >> Makefile
			if [[ ${CFILES[j + 1]} ]]; then
				echo " \\" >> Makefile
			fi
		fi
	done
	echo >> Makefile
	echo >> Makefile
done

for i in ${!DIR_FINAL[@]}; do
	DIR_PREFIX+=("${DIR_FINAL[i]}_PREFIX")
	echo "${DIR_PREFIX[i]} = \$(addprefix ${DIR_FINAL_LOW[i]}/, \$(${DIR_FINAL[i]}))" >> Makefile
	echo >> Makefile
done

echo -n "SRC =" >> Makefile
echo "	\$(${DIR_PREFIX[0]}) \\" >> Makefile
for i in ${!DIR_PREFIX[@]}; do
	if [[ $i -ne 0 ]]; then
		echo -n "		\$(${DIR_PREFIX[i]})" >> Makefile
		if [[ ${DIR_PREFIX[i + 1]} ]]; then
			echo " \\" >> Makefile
		fi
	fi
done

echo >> Makefile
echo >> Makefile
echo "OBJ = \$(SRC:.c=.o)" >> Makefile
echo >> Makefile
echo "FLAGS = -Wall -Wextra -Werror" >> Makefile
echo >> Makefile
echo "CC = gcc" >> Makefile
echo >> Makefile
echo "all: \$(NAME)" >> Makefile
echo >> Makefile
echo "\$(NAME): \$(OBJ)" >> Makefile
echo "		@\$(CC) \$(FLAGS) \$(OBJ) \$(INCLUDES) -g -o \$(NAME)" >> Makefile
echo >> Makefile
echo "%.o: %.c" >> Makefile
echo "		\$(CC) \$(FLAGS) \$(INCLUDES) -g -c \$< -o \$@" >> Makefile
echo >> Makefile
echo "clean:" >> Makefile
echo "		rm -f \$(OBJ)" >> Makefile
echo >> Makefile
echo "fclean: clean" >> Makefile
echo "		rm -f \$(NAME)" >> Makefile
echo >> Makefile
echo "re: fclean all" >> Makefile
echo >> Makefile