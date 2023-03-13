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
  echo "$ELEMENTS_PROPERTIES_TYPES" | while IFS=\| read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
fi
