#!/bin/bash

NAME=$1
for ARG in "${@:2}"; do
	TEMP=$(echo "$ARG" | tr '[:lower:]' '[:upper:]')
	EXCL_DIR+=(${TEMP})
done
DIRS=($(ls -d */ | sed 's/\///g' | tr '[:lower:]' '[:upper:]'))
# CFILES=($(ls | grep *.c))

echo "NAME = ${NAME}" > Makefile
echo "" >> Makefile

# DIRS=srcs
# CFILES=($(ls srcs/ | grep \.c))

# PRINT CFILES
# for i in ${!CFILES[@]}; do
# 	echo ${CFILES[i]} >> Makefile
# done

# PRINT EXCL_DIR
# for i in ${!EXCL_DIR[@]}; do
# 	echo ${EXCL_DIR[i]} >> Makefile
# done

# PRINT DIRS
# for i in ${!DIRS[@]}; do
# 	echo "${DIRS[i]} = \n" >> Makefile
# done

# for i in ${!DIRS[@]}; do
# 	if [[ ! "${EXCL_DIR[@]}" =~ "${DIRS[i]}" ]]; then
# 		echo -n "${DIRS[i]} = " >> Makefile
# 		TEMP=$(echo "${DIRS[i]}" | tr '[:upper:]' '[:lower:]')
# 		CFILES=($(ls ${TEMP} | grep \.c))
# 		echo "	${CFILES[0]} \\" >> Makefile
# 		for j in ${!CFILES[@]}; do
# 			if [[ $j -ne 0 ]]; then
# 				echo -n "		${CFILES[j]}" >> Makefile
# 				if [[ ${CFILES[j + 1]} ]]; then
# 					echo " \\" >> Makefile
# 				fi
# 			fi
# 		done
# 		echo >> Makefile
# 		echo >> Makefile
# 	fi
# done

for i in ${!DIRS[@]}; do
	if [[ ! "${EXCL_DIR[@]}" =~ "${DIRS[i]}" ]]; then
		DIR_FINAL+=(${DIRS[i]})
		DIR_FINAL_LOW+=($(echo "${DIRS[i]}" | tr '[:upper:]' '[:lower:]'))
	fi
done

for i in ${!DIR_FINAL[@]}; do
	echo -n "${DIR_FINAL[i]} = " >> Makefile
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

