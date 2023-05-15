#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no argument
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
else
  # If argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]; then
    ELEMENT_INFO=$($PSQL "SELECT properties.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM properties JOIN elements ON properties.atomic_number = elements.atomic_number JOIN types ON properties.type_id = types.type_id WHERE properties.atomic_number = $1")
  # If argument is a string
  elif [[ -n $1 ]]; then
    ELEMENT_INFO=$($PSQL "SELECT properties.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM properties JOIN elements ON properties.atomic_number = elements.atomic_number JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$1' OR elements.name = '$1'")
  fi

  # If element doesn't exist 
  if [[ -z $ELEMENT_INFO ]]; then
    echo "I could not find that element in the database."
  else
    # Parse element row for relevant information
    IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $ELEMENT_INFO
    # Output info
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
