#!/bin/bash

# Access database (tuples only)
PSQL="psql -X -A --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if no argument
if [[ ! $1 ]]
    then
    echo Please provide an element as an argument.
fi

if [[ $1 ]]
  then

    OUTPUT_ELEMENT_INFO () {
    ELEMENT_INFO=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties LEFT JOIN types USING (type_id) LEFT JOIN elements USING (atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")
    echo "$ELEMENT_INFO" | while IFS=' | ' read NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
        do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
    }

    # if atomic number 1-10
    if [[ $1 =~ ^[0-9]+$ && $1 -ge 1 && $1 -le 10 ]]
        then
        # echo atomic number
        ATOMIC_NUMBER=$1
        OUTPUT_ELEMENT_INFO
        #

    # if element symbol
    elif [[ $1 =~ ^[A-Z]{1}[a-z]{0,1}$ ]]
        then
        # echo symbol
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
        # if atomic_number not found
        if [[ -z $ATOMIC_NUMBER ]]
            then
            echo "I could not find that element in the database."
            else
            OUTPUT_ELEMENT_INFO
        fi

    # if element name
    elif [[ $1 =~ ^[A-Z]{1}[a-z]{2,}$ ]]
        then
        # echo name
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
        # if atomic_number not found
        if [[ -z $ATOMIC_NUMBER ]]
            then
            echo "I could not find that element in the database."
            else
            OUTPUT_ELEMENT_INFO
        fi
    
    # all other arguments
    else
    echo "I could not find that element in the database."
    
    fi
fi
