#!/bin/python
import subprocess
import time


global last_warned

last_warned = 100

warning_vals = [10, 20, 30]


def get_next_warning(val):
    if val > max(warning_vals):
        return max(warning_vals)
    if val == min(warning_vals):
        return 0
    for i in range(0, len(warning_vals)-1):
        if warning_vals[i+1] == val:
            return warning_vals[i]
    return warning_vals[0]


def nag(message):
    return subprocess.run(["swaynag", "-m", f'"{message}"'], capture_output=True, text=True)


percent = 100
# inc = -5
discharging = True
while True:
    percent = subprocess.run("acpi", capture_output=True, text=True)
    lines = percent.stdout.split('\n')
    discharging = 'dis' in lines[0]
    split_line = lines[0].split(',')[1].strip()
    split_line = split_line[0: len(split_line)-1]
    percent = int(split_line)  # percent+ inc

    # if percent == 0 or percent == 100:
    #    inc = -inc
    #    discharging = not discharging

    warning_val = get_next_warning(last_warned)
    if not discharging:
        if percent > max(warning_vals):
            last_warned = 100
        else:
            for i in range(0, len(warning_vals) - 1):
                if percent > warning_vals[i]:
                    last_warned = warning_vals[i+1]
    if discharging and percent <= warning_val:
        nag(f'battery is at {percent}%')
        last_warned = percent
    time.sleep(5)
