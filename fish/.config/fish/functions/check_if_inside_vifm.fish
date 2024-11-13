status is-interactive || exit
functions -c fish_prompt original_fish_prompt
function fish_prompt
# prepend fish_prompt with a custom message if running inside VIFM 
  if [ "$INSIDE_VIFM" = "true" ]
    set_color brgreen
    echo "Running inside VIFM, hit Ctrl-D to exit"
  end
original_fish_prompt
end
