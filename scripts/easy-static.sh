#!/bin/bash

zenity --list \
  --title="Choose the Bugs You Wish to View" \
  --column="Action" --column="Description" \
    Deploy "Deploy an application" \
    Destroy "Destroy an application infraestructure" \
    List "List all applications deployed" \ > /tmp/option

option=$(cat /tmp/option)

case $option in
    Deploy)
        zenity --info --text="Deploy an application"
        ;;
    Destroy)
        zenity --info --text="Destroy an application infraestructure"
        ;;
    List)
        make list > /tmp/list
        ;;
esac

if [ -f /tmp/list ]; then
    zenity --text-info --filename=/tmp/list
    exit 0
fi

rm /tmp/list
rm /tmp/option