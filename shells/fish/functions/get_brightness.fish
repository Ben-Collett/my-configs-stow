function get_brightness
    echo 🔆(printf %0.0f (math 100 x (math (brightnessctl get)/(brightnessctl m))))%
end
