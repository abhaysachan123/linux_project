#!/bin/bash
# -----------------------------------------
# DAILY EXPENSES DIARY
# -----------------------------------------

DATA_FILE="expenses.txt"

[ ! -f "$DATA_FILE" ] && touch "$DATA_FILE"

while true; do
    CHOICE=$(zenity --list --title="Expense Tracker" \
        --column="Select an option" \
        "Add Expense" "View Expenses" "Show Total" "Exit")

    case "$CHOICE" in
        "Add Expense")
            DATE=$(zenity --calendar --title="Select Date")
            [ $? -ne 0 ] && continue

            CATEGORY=$(zenity --entry --title="Expense Category" --text="Enter category:")
            [ $? -ne 0 ] && continue

            AMOUNT=$(zenity --entry --title="Expense Amount" --text="Enter amount (₹):")
            [ $? -ne 0 ] && continue

            echo "$DATE | $CATEGORY | $AMOUNT" >> "$DATA_FILE"
            zenity --info --text="Expense added successfully!"
            ;;

        "View Expenses")
            zenity --text-info --title="Expense Records" \
                   --filename="$DATA_FILE" \
                   --width=400 --height=300
            ;;

        "Show Total")
            TOTAL=$(awk -F'|' '{sum += $3} END {print sum}' "$DATA_FILE")
            zenity --info --title="Total Expense" --text="Your total expenses: ₹$TOTAL"
            ;;

        "Exit")
            zenity --info --text="Goodbye!"
            break
            ;;

        *)
            zenity --warning --text="Please select an option!"
            ;;
    esac
done
