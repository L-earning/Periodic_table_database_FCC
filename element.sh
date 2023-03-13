#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
exit
fi

if [[ ! $1 =~ ^[0-9]+$ ]]
then
  ELEMENTS_PROPERTIES_TYPES=$($PSQL "SELECT ATOMIC_NUMBER, SYMBOL, NAME, TYPE, ATOMIC_MASS, MELTING_POINT_CELSIUS, BOILING_POINT_CELSIUS FROM elements INNER JOIN properties USING(ATOMIC_NUMBER) INNER JOIN types USING(type_id) WHERE '$1'=SYMBOL OR '$1'=NAME;")
else
  ELEMENTS_PROPERTIES_TYPES=$($PSQL "SELECT ATOMIC_NUMBER, SYMBOL, NAME, TYPE, ATOMIC_MASS, MELTING_POINT_CELSIUS, BOILING_POINT_CELSIUS FROM elements INNER JOIN properties USING(ATOMIC_NUMBER) INNER JOIN types USING(type_id) WHERE $1=ATOMIC_NUMBER;")
fi
if [[ -z $ELEMENTS_PROPERTIES_TYPES ]]
then
  echo "I could not find that element in the database."
else
  echo "$ELEMENTS_PROPERTIES_TYPES" | while read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
  do
    
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_C celsius and a boiling point of $BOILING_POINT_C celsius."
  done
fi


  

#if [[ $1 == 1 ]] || [[ $1 == "H" ]] || [[ $1 == "Hydrogen" ]]
#then
#  echo "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
#fi



