title="Select example"
prompt="Pick an option:"
json_path="C:/Users/Jeffe/OneDrive/Documentos/shell/json.json"
nv=0 nn="" json=""
options=(" {"
"   \"data\": [{"
"     \"type\": \"articles\","
"     \"id\": \"1\","
"     \"attributes\": {"
"       \"title\": \"JSON:API paints my bikeshed!\","
"       \"body\": \"The shortest article. Ever.\","
"       \"created\": \"2015-05-22T14:56:29.000Z\","
"       \"updated\": \"2015-05-22T14:56:28.000Z\""
"     },"
"     \"relationships\": {"
"       \"author\": {"
"         \"data\": {\"id\": \"42\", \"type\": \"people\"}"
"       }"
"     }"
"   }],"
"   \"included\": ["
"     {"
"       \"type\": \"people\","
"       \"id\": \"42\","
"       \"attributes\": {"
"         \"name\": \"John\","
"         \"age\": 80,"
"         \"gender\": \"male\","
" 	\"item\" : ["
" 		1,
		2,
		3"
" 	]"
"       }"
"     }"
"   ]"
" }")
cat $json_path | jq '.' > json_tmp.json;
function preper_json() {
	cat json_tmp.json | jq '.'
	tmp_json
}
function tmp_json() {
clear
	cat json_tmp.json | jq -C '.' | awk '{print ((i++)) $0}'
	for o in `cat $json_path` 
	do
			if 
			   [[ $o == *[[:alpha:]]* ]] ||
			   [[ $o == *[[:digit:]]* ]]
			then
				printf "\n$o"
			fi
	done
}



for o in 'cat $json_path | jq '.''
	do
		if 
		   [[ $o == *[[:alpha:]]* ]] ||
		   [[ $o == *[[:digit:]]* ]]
		then
			printf "\n$o"
			fi
	done

function show_json_path() {
jq -r '
paths as $p
  | [ ( [ $p[] | tostring ] | join(".") )
    , ( getpath($p) | tojson )
    ]
  | join(": ")
' json_tmp.json > json_tmp.json
}


function choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "$prompt\n"
    while true
    do
        # list all options (option list is zero-based)
        index=0 
        for o in "${options[@]}"
        do
            if [ "$index" == "$cur" ]
            then echo -e " >\e[7m$o\e[0m" # mark & highlight the current option
            else echo "  $o"
            fi
            index=$(( $index + 1 ))
        done
        read -s -n3 key # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]] # up arrow
        then cur=$(( $cur - 1 ))
            [ "$cur" -lt 0 ] && cur=0
        elif [[ $key == $esc[B ]] # down arrow
        then cur=$(( $cur + 1 ))
            [ "$cur" -ge $count ] && cur=$(( $count - 1 ))
        elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
        then break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done
    # export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
}

selections=(
"Add | Edit"
"Delete"
"Show patch"
"Quit"
"Free Edit"
)
preper_json

while :
do
	choose_from_menu "Selecione uma opção (use ↑ ↓ ∟)" selected_choice "${selections[@]}"
	case "$selected_choice" in
		#Adiciona um novo campo ao JSON
		"Add | Edit")
			tmp_json
			echo 
			echo "Digite o path do novo objeto"
			read p
			echo "Digite o nome do novo objeto"
			read n
			echo "Digite o valor do novo objeto"
			read v
			#jq --argjson v "$v" --arg n "$n" '. += { '"$n"' : $v}' $json_path
			cat <<< $(jq --argjson v "$v" --arg n "$n" --arg p "$p" ''".$p"' += {'"$n"': $v}' json_tmp.json) > json_tmp.json
		;;
		"Show patch")
			show_json_path
		;;
		"Delete")
			tmp_json
			echo 
			echo "Digite o path do objeto"
			read p
			#jq --argjson v "$v" --arg n "$n" '. += { '"$n"' : $v}' $json_path
			cat <<< $(jq --arg p "$p" 'del('".$p"' json_tmp.json)' > json_tmp.json)
		;;
		"Quit")
			break
		;;
		"Free Edit")
			vim json_tmp.json
		;;
		*) echo "invalid option $REPLY";;
	esac
done	

########################################################################################################################
########################################################################################################################


