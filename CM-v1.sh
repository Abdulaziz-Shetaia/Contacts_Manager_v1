#!/bin/bash

erased_before="no"

function m_main_menu () {
	clear
    echo "-------------------------------"
    echo "press i to add new contact."
    echo "press v to view all contacts."
    echo "press s to search for record."
    echo "press e to delete all contacts."
    echo "press d to delete one contact."
    echo "press q to exit."
    echo "-------------------------------"
    read -e -p "Type to go: " current_state
}

function i_add_new_contact () {
    clear
    # Input validation for first name
    while true; do
        read -e -p "Enter your first name: " fname
        if [[ "$fname" =~ ^[A-Za-z]{2,40}$ ]]; then
            break
        else
            echo "Invalid first name. Please enter a valid name with 2 to 40 characters."
        fi
    done
    
    # Input validation for last name
    while true; do
        read -e -p "Enter your last name: " lname
        if [[ "$lname" =~ ^[A-Za-z]{2,40}$ ]]; then
            break
        else
            echo "Invalid last name. Please enter a valid name with 2 to 40 characters."
        fi
    done

    # Input validation for email
    while true; do
        read -e -p "Enter your Email: " email
        if [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$ ]]; then
            break
        else
            echo "Invalid email format. Please enter a valid email address."
        fi
    done

    # Input validation for phone number
    while true; do
        read -e -p "Enter your phone number: " phone
        if [[ "$phone" =~ ^[0-9+]{6,20}$ ]]; then
            break
        else
            echo "Invalid phone number. Please enter a valid number with minimum 6 digits and '+'."
        fi
    done

    echo "$fname:$lname:$email:$phone" >> database.txt
    clear
    echo " "
    echo "--------------------------------"
    echo "         Contact added!         "
    echo "--------------------------------"
    echo " "
    echo "--------------------------------"
    echo "press m for main menu"
    echo "press q for exit"
    echo "press i to add another contact"
    echo "-------------------------------"
    read -e -p "Type to go: " current_state
    if [ "$current_state" = "m" ]; then
        m_main_menu
    elif [ "$current_state" = "i" ]; then
        i_add_new_contact
    elif [ "$current_state" = "q" ]; then
        q_exit
    fi
}

function v_view_all_contacts () {
	clear
    cat database.txt
    echo " "
    echo "-------------------------------"
    echo "press m for main menu"
    echo "press q for exit"
    echo "-------------------------------"
    read -e -p "Type to go: " current_state
    if [ "$current_state" = "m" ]; then
        m_main_menu
    elif [ "$current_state" = "q" ]; then
        q_exit
    fi
}

function s_search_for_record () {
	clear
    read -e -p "Search for: " qs
    cat -n database.txt | grep "$qs"
    echo " "
    echo "-------------------------------"
    echo "press m for main menu"
    echo "press q for exit"
    echo "press s to search for another record"
    echo "-------------------------------"
    read -e -p "Type to go: " current_state
    if [ "$current_state" = "m" ]; then
        m_main_menu
    elif [ "$current_state" = "s" ]; then
        s_search_for_record
    elif [ "$current_state" = "q" ]; then
        q_exit
    fi
}

function e_delete_all_contacts () {
	clear
	local sure1
	local sure2
	local fuck_it
	read -e -p "ARE YOU SURE YOU WANT TO ERASE ALL DATA? (Y - N): " sure1

	if [ "$sure1" = "Y" ]; then
		read -e -p "ARE YOU REALLY SURE YOU WANT TO ERASE ALL DATA? (Y - N): " sure2
		clear

		if [ "$sure1" = "Y" ] && [ "$sure2" = "Y" ]; then
			read -e -p "I mean... this is important data, Type 'DELETE' to delete it: " fuck_it
			clear

			if [ "$fuck_it" = "DELETE" ]; then
				echo "as you wish..."
				echo -e "---------------------------------------------------------------\nDate of last erase is $(date) and that action done by $USER \n---------------------------------------------------------------" > database.txt
				echo " "
				echo "--------------------------"
				echo "         Deleted...       "
				echo "--------------------------"
				echo " "
				echo "You are being redirected to the main menu."
				erased_before="yes"
				sleep 2
				clear
				m_main_menu
			else
				echo "You are not sure, you are being redirected to the main menu."
				sleep 2
				clear
				m_main_menu
			fi
		else
			echo "You are not sure, you are being redirected to the main menu."
			sleep 2
			clear
			m_main_menu
		fi
	else
		echo "You are not sure, you are being redirected to the main menu."
		sleep 2
		clear
		m_main_menu
	fi
}

function d_delete_one_contact () {
    clear
    cat -n database.txt
    echo " "
    echo "-----------------------------"
    read -e -p "Type contact number to delete: " d_one
    read -e -p "Are you sure you want to delete this contact? (Y - N): " sure3

    if [[ "$sure3" != "Y" ]]; then
        echo " "
        echo "Invalid input or you're not sure!"
        echo "Redirecting to the main menu..."
        sleep 2
        m_main_menu
    else
        if [[ "$d_one" =~ ^[a-zA-Z]$ ]]; then
            echo "Invalid input or you're not sure!"
            echo "Redirecting to the main menu..."
            sleep 2
            m_main_menu
        elif [[ "$d_one" =~ ^[0-9]+$ ]]; then
            if [[ "$d_one" -le 3 ]]; then
                echo "Invalid input or you're not sure!"
                echo "Redirecting to the main menu..."
                sleep 2
                m_main_menu
            else
                line_exists=$(sed -n "${d_one}p" database.txt)
                
                if [[ -z "$line_exists" ]]; then
                    echo " "
		    echo "Contact not found!"
		    echo " "
                    echo "Redirecting to the main menu..."
                    sleep 2
                    m_main_menu
                else
                    sed -i "${d_one}d" database.txt
                    echo " "
                    echo "-------------------------------"
                    echo "       Contact Deleted...      "
                    echo "-------------------------------"
                    echo " "
                    echo "-------------------------------"
                    echo "press m for main menu"
                    echo "press q for exit"
                    echo "press d to delete another contact"
                    echo "-------------------------------"
                    read -e -p "Type to go: " current_state
                    if [ "$current_state" = "m" ]; then
                        m_main_menu
                    elif [ "$current_state" = "d" ]; then
                        d_delete_one_contact
                    elif [ "$current_state" = "q" ]; then
                        q_exit
                    fi
                fi
            fi
        else
            echo "Something is not right!"
            echo "Try again!"
            m_main_menu
        fi
    fi
}

function q_exit () {
	clear
	echo "--------------------"
	echo "     Quitting...    "
	echo "--------------------"
	sleep 2
	clear
	exit
}
m_main_menu

while true; do
    if [ "$current_state" = "m" ] || [ "$current_state" = "M" ]; then
        m_main_menu
    elif [ "$current_state" = "i" ] || [ "$current_state" = "I" ]; then
        i_add_new_contact
    elif [ "$current_state" = "v" ] || [ "$current_state" = "V" ]; then
        v_view_all_contacts
    elif [ "$current_state" = "s" ] || [ "$current_state" = "S" ]; then
        s_search_for_record
    elif [ "$current_state" = "e" ] || [ "$current_state" = "E" ]; then
        e_delete_all_contacts
    elif [ "$current_state" = "d" ] || [ "current_state" = "D" ]; then
        d_delete_one_contact
    elif [ "$current_state" = "q" ] || [ "current_state" = "Q" ]; then
	    q_exit
    else
        echo " "
	echo "----------------------------------"
	echo "Unrecognized command, Redirecting."
	echo "----------------------------------"
	echo " "

	sleep 2
        m_main_menu
    fi
done
