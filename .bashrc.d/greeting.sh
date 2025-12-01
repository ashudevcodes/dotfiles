HOUR=$(date +%H)

if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 12 ]; then
    MESSAGE="Good morning   shu :) Welcome"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 18 ]; then
    MESSAGE="Good afternoon   shu :) Welcome"
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -lt 21 ]; then
    MESSAGE="Good evening    shu :) Welcome"
elif [ "$HOUR" -ge 21 ] && [ "$HOUR" -lt 23 ]; then
    MESSAGE="It's late, go to bed! Good night   shu :)"
else
    MESSAGE="It's very late, go to bed! Good night   shu :)"
fi

cowsay -f tux "$MESSAGE"

