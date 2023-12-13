#!/bin/sh

echo $(curl "https://api.open-meteo.com/v1/forecast?latitude=45.7805&longitude=4.7464&current=temperature_2m,apparent_temperature,is_day,precipitation,wind_speed_10m,wind_direction_10m&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=auto" 2> /dev/null) > meteo.json

input_file="meteo.json"

current_time=`jq -r '.current.time' "$input_file"`
current_temperature=`jq -r '.current.temperature_2m' "$input_file"`
temperature_unit=`jq -r '.current_units.temperature_2m' "$input_file"`
apparent_temperature=`jq -r '.current.apparent_temperature' "$input_file"`
is_day=`jq -r '.current.is_day' "$input_file"`
current_precipitation=`jq -r '.current.precipitation' "$input_file"`
precipitation_unit=`jq -r '.current_units.precipitation' "$input_file"`
wind_speed=`jq -r '.current.wind_speed_10m' "$input_file"`
wind_direction=`jq -r '.current.wind_direction_10m' "$input_file"`
wind_speed_unit=`jq -r '.current_units.wind_speed_10m' "$input_file"`
wind_direction_unit=`jq -r '.current_units.wind_direction_10m' "$input_file"`
sunrise=`jq -r '.daily.sunrise[0]' "$input_file"`
sunset=`jq -r '.daily.sunset[0]' "$input_file"`

echo "\e[0;34m
------------------------------------------------------
|                                                    |
|                      WEATHER                       |
|                                                    |
------------------------------------------------------\n\e[0m"

#-------------------CURRENT-TIME--------------------------------------------------------

if [ $is_day -eq 1 ]
then
	echo "\e[1;33mTime : $current_time It's day outside 🔆\e[0m"
	echo -n "\e[1;34mSunset at : "
	echo "$sunset 🌕\n\e[0m" | cut -c 12-
else
	echo "\e[1;34mTime : $current_time It's night outside 🌕\e[0m"
	echo -n "\e[1;33mSunrise at : "
	echo "$sunrise 🔆\n\e[0m" | cut -c 12-
fi

#--------------------CURRENT-TEMPERATURE------------------------------------------------

if [ "$(echo "$current_temperature < 18" | bc)" = 1 ]
then
	echo "\e[1;36mCurrent temperature : $current_temperature$temperature_unit 🌨\n\e[0m"
elif [ "$(echo "$current_temperature < 25" | bc)" = 1 ]
then
	echo "\e[0;33mCurrent temperature : $current_temperature$temperature_unit 🌤\n\e[0m"
else
	echo "\e[0;31mCurrent temperature : $current_temperature$temperature_unit 🔥\n\e[0m"
fi

#--------------------APPARENT-TEMPERATURE------------------------------------------------

if [ "$(echo "$apparent_temperature < 18" | bc)" = 1 ]
then
	echo "\e[1;36mApparent temperature : $apparent_temperature$temperature_unit 🌨\n\e[0m"
elif [ "$(echo "$apparent_temperature < 25" | bc)" = 1 ]
then
	echo "\e[0;33mApparent temperature : $apparent_temperature$temperature_unit 🌤\n\e[0m"
else
	echo "\e[0;31mApparent temperature : $apparent_temperature$temperature_unit 🔥\n\e[0m"
fi

#---------------------------------------------------------------------------------------

echo "\e[1;34mCurrent precipitation : $current_precipitation$precipitation_unit ⛈\n\e[0m"

echo "\e[1;36mCurrent wind speed : $wind_speed$wind_speed_unit 🍃\n\e[0m"

echo "\e[1;36mCurrent wind direction : $wind_direction$wind_direction_unit 🍃\n\e[0m"

