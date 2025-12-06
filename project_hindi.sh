#!/bin/bash

FILE="expense.txt"

while true; do
CHOICE=$(zenity --list --title="दैनिक खर्च डायरी" --width=400 --height=330 \
--text="कृपया नीचे दिए गए विकल्पों में से चुनें:" \
--ok-label="ठीक है" \
--cancel-label="रद्द करें" \
--column="विकल्प चुनें" \
"खर्च जोड़ें" \
"सभी खर्च देखें" \
"मासिक कुल खर्च" \
"कुल बैलेंस कैलकुलेटर" \
"अंतिम रिकॉर्ड हटाएँ" \
"बंद करें")

case "$CHOICE" in

"खर्च जोड़ें")
ITEM=$(zenity --entry --title="खर्च जोड़ें" --text="खर्च का नाम दर्ज करें:" \
--ok-label="सेव करें" --cancel-label="रद्द करें")
[ -z "$ITEM" ] && continue

COST=$(zenity --entry --title="राशि दर्ज करें" --text="राशि (₹) दर्ज करें:" \
--ok-label="सेव करें" --cancel-label="रद्द करें")
[ -z "$COST" ] && continue

DATE=$(zenity --calendar --title="तारीख चुनें" --text="कृपया तारीख चुनें:" --date-format="%d-%m-%Y" \
--ok-label="ठीक है" --cancel-label="रद्द करें")
[ -z "$DATE" ] && continue

CATEGORY=$(zenity --list --title="श्रेणी चुनें" --text="कृपया श्रेणी चुनें:" \
--ok-label="ठीक है" --cancel-label="रद्द करें" \
--column="श्रेणी" \
"भोजन" "यात्रा" "खरीदारी" "बिल" "मनोरंजन" "अन्य")

echo "$DATE | $ITEM | $CATEGORY | ₹$COST" >> $FILE
zenity --info --title="संदेश" --text="खर्च सफलतापूर्वक जोड़ दिया गया! 👍"
;;

"सभी खर्च देखें")
zenity --text-info --title="सभी खर्च" --filename="$FILE" --width=500 --height=400 \
--ok-label="बंद करें"
;;

"मासिक कुल खर्च")
TOTAL=$(awk -F'₹' '{sum+=$2} END {print sum}' $FILE)
zenity --info --title="मासिक कुल खर्च" --text="कुल खर्च राशि: ₹$TOTAL" \
--ok-label="ठीक है"
;;

"कुल बैलेंस कैलकुलेटर")
INCOME=$(zenity --entry --title="कुल आय" --text="कृपया कुल मासिक आय (₹ में) दर्ज करें:")
EXP=$(awk -F'₹' '{s+=$2} END {print s}' $FILE)
BAL=$((INCOME-EXP))
zenity --info --title="बचा हुआ बैलेंस" --text="उपलब्ध बैलेंस: ₹$BAL" \
--ok-label="ठीक है"
;;

"अंतिम रिकॉर्ड हटाएँ")
sed -i '$d' $FILE
zenity --warning --title="रिकॉर्ड हटाया गया" --text="अंतिम खर्च रिकॉर्ड हटा दिया गया!" \
--ok-label="ठीक है"
;;

"बंद करें")
zenity --info --title="धन्यवाद" --text="इस प्रोग्राम का उपयोग करने के लिए धन्यवाद 🙏" \
--ok-label="ठीक है"
exit 0
;;
esac
done
