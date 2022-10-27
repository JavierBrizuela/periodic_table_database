#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
if [[ -z $1 ]]
then
echo -e "Please provide an element as an argument."
else
if [[ $1 =~ ^[0-9]+$ ]]
then
ELEMENTS_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE elements.atomic_number='$1';")
else
  ELEMENTS_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE  elements.name LIKE '$1' OR elements.symbol LIKE '$1';")
fi
if [[ -z $ELEMENTS_RESULT ]]
then
echo I could not find that element in the database.
else
echo  $ELEMENTS_RESULT | while IFS=\| read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
do
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
done
fi
fi