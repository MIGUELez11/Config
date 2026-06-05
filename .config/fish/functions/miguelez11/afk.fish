function afk
    while true
        sleep 10
        osascript -e "tell application \"System Events\" to key code 49"
    end
end

function afk_stop
    killall afk
end

function sleepOn
    if test $argv[1]
        set -l duration $argv[1]
    else
        read -P "Enter minutes to sleep: " duration
        set duration (math "$duration * 60")
    end

    echo "sleeping in $duration seconds ($(math "$duration / 60") minutes)"
    sleep $duration
    pmset displaysleepnow
    osascript -e "tell application \"System Events\" to sleep"
end