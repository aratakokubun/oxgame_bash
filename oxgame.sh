# !/bin/sh

# size of the board
size=3

# players
none=0
p1=1
p2=2

# is board full or not
is_not_full=0
is_fill=1

# Initialize ox board
for ((x=0; x<$size; x++)) {
	for ((y=0; y<$size; y++)) {
		eval ARRAY${x}${y}=$none
	}
}

# ----------------------------------------------------------------
# Judge who is the winner
judge_winner() {
	# Horizontal line
	for ((x=0;x<$size;x++)) {
		winner=$((ARRAY${x}0))
		for ((y=1;y<$size;y++)) {
			if [ $winner -ne $((ARRAY${x}${y})) ]; then
				winner=$none
				break
			fi
		}
		# return winner if winner is not $none player
		if [ $winner -ne $none ]; then
			return $winner
		fi
	}

	# Vertical line
	for ((y=0;y<$size;y++)) {
		winner=$((ARRAY0${y}))
		for ((x=1;x<$size;x++)) {
			if [ $winner -ne $((ARRAY${x}${y})) ]; then
				winner=$none
				break
			fi
		}
		# return winner if winner is not $none player
		if [ $winner -ne $none ]; then
			return $winner
		fi
	}

	# Crossing line
	winner=$((ARRAY00))
	for ((c=1;c<$size;c++)) {
		if [ $winner -ne $((ARRAY${c}${c})) ]; then
			winner=$none
			break
		fi
	}
	if [ $winner -ne $none ]; then
		return $winner
	fi
	winner=$((ARRAY$((size-1))0))
	for ((c=1;c<$size;c++)) {
		temp=$((size-1-c))
		if [ $winner -ne $((ARRAY${temp}${c})) ]; then
			winner=$none
			break
		fi
	}
	if  [ $winner -ne $none ]; then
		return $winner
	fi

	# ret none result
	return $none
}

# ----------------------------------------------------------------
check_full() {
	for ((x=0; x<$size; x++)) {
		for ((y=0; y<$size; y++)) {
			if [ $ARRAY${x}${y} -eq $none ]; then
				# not full
				return $is_not_full
			fi
		}
	}
# full
	return $is_full
}

# ----------------------------------------------------------------
print_board() {
	line="+"
	for ((x=0;x<$((size*2-1));x++)) {
		line=$line"-"
	}
	line=$line"+"
	echo $line
	for ((x=0;x<$size;x++)) {
		str="|"
		for ((y=0;y<$size;y++)) {
			# print "o" if p1, elif "x" if p2, else " "
			mark=" "
			eval p=$((ARRAY${x}${y}))
			if [ $p -eq $p1 ]; then
				mark="o"
			elif [ $p -eq $p2 ]; then
				mark="x"
			fi
			str=$str$mark"|"
		}
		echo $str
	}
	echo $line
}

# ----------------------------------------------------------------
turn() {
	# print message
	echo "${1}'s turn"
	if [ $1 -eq $p1 ]; then
		echo "Please input pos to place o"
	else
		echo "Please input pos to place x"
	fi

	# stdin
	while :
	do
	
		while :
		do 
			/bin/echo -n 'x > '
			read x
			if [ $x -lt 0 -o $x -ge $size ]; then
				echo "x must be 0 <= x < ${size}"
			else
				break
			fi
		done
	
		while :
		do
			/bin/echo -n 'y > '
			read y
			if [ $y -lt 0 -o $y -ge $size ]; then
				echo "y must be 0 <= y < ${size}"
			else
				break
			fi
		done
	
		# check if no mark exist in (x,y)
		if [ $((ARRAY${x}${y})) -eq $none ]; then
			eval ARRAY${x}${y}=$1
			break
		else
			echo "$((ARRAY${x}${Y})) is already placed at ${x},${y} "
		fi
	done
}

echo "OX Game Start!"
active_player=$p1
winner=$none
board_full=$is_not_full
while [ $winner -eq $none -a $board_full -eq $is_not_full ]
do
	print_board
	turn $active_player
	judge_winner
	winner=$?
	check_full
	board_full=$?
	# switch player
	if [ $active_player -eq $p1 ];then
		active_player=$p2
	else
		active_player=$p1
	fi

done

if [ $winner -ne $none ]; then
	echo "Winner is ${winner}!"
else
	echo "Draw!"
fi
print_board
