#!/bin/sh

break="--------------------"

# remote details
host=(ip_address ip_address ip_address ip_address ip_address ip_address ip_address ip_address ip_address ip_address ip_address ip_address)
user=(remote_user remote_user remote_user remote_user remote_user remote_user remote_user remote_user remote_user remote_user remote_user remote_user)
alias=(Alias Alias Alias Alias Alias Alias Alias Alias Alias Alias Alias Alias)
remote_dir=(/path/to/file/ /path/to/file/ /path/to/file/ /path/to/file/ /path/to/file/ /path/to/file/ /path/to/file/  /path/to/file/ /path/to/file/ /path/to/file/ /path/to/file/ /path/to/file/)

# filename (can use regex for multiple files)
ads_txt=ads.txt

# to find total enteries in array
END=${#alias[@]}

length=$(($END - 1))

sleep 1
echo "$break"

echo "Enter the text you want to update or paste it and press ENTER, then press CTRL+D"
echo "$break"

# what user want to append to files
input_text=$(cat)
echo ""
echo "$break"

required="y"
exit="n"
sleep 1

# for loop to iterate over all the sites
for i in $(seq 0 $length)
do
	echo "The following text will be added to the ${alias[$i]}'s $ads_txt"
	sleep 2
	echo "$break"
	echo "$input_text"
	echo "$break"
	sleep 1.5
	response="n"
	exit_response=none

	# user confirmation to check and edit the text
	while [ -z "$response" ] || [ $response != $required ]
	do
		read -p "Do you want to continue?(y/n): " response
		if ! [ -z "$response" ] && [ $response = $exit ]
		then
			sleep 1
			echo "$break"
			echo "You cancelled the task!! Quitting..."
			echo "$break"
			exit_response=break
			break
		fi
	done

	# if user denies the editing
	if [ "$exit_response" = "break" ]
	then
		continue
	fi

	sleep 1
	echo "$break"
	echo "Trying to connect to ${alias[$i]}..."
	sleep 1
	echo "Enter password for ${alias[$i]}"
	echo "$break"

	# script to edit the file
	script="cd ${remote_dir[$i]}; echo '$break'; sleep 0.5; echo 'Changed Directory to ${remote_dir[$i]}'; echo '$input_text'>>$ads_txt; sleep 1.5; echo '${alias[$i]} $ads_txt updated'; echo '$break'; sleep 1"
	
	# sites that use the defauld ssh port (22)
	if [ $i -le 8 ]
	then
		ssh -l ${user[$i]} ${host[$i]} "${script}"
	# after 8 sites, our remaining sites uses port 2208 for ssh
	elif [ $i -ge 9 ]
	then
		ssh -l ${user[$i]} ${host[$i]} -p2208 "${script}"
	fi
done