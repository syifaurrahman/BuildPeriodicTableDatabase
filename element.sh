#!/bin/bash
# Script to look up element info from periodic_table database
# Usage: ./element.sh <atomic_number|symbol|name>
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

ELEMENT_DATA=$($PSQL "
  SELECT
    e.atomic_number,
    e.name,
    e.symbol,
    p.atomic_mass,
    p.melting_point_celsius,
    p.boiling_point_celsius,
    t.type
  FROM elements e
  JOIN properties p USING(atomic_number)
  JOIN types t USING(type_id)
  WHERE e.atomic_number::text = '$1'
     OR LOWER(e.symbol) = LOWER('$1')
     OR LOWER(e.name) = LOWER('$1');
")

if [[ -z $ELEMENT_DATA ]]
then
  echo "I could not find that element in the database."
else
  IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL MASS MELTING BOILING TYPE <<< "$ELEMENT_DATA"

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi