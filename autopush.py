#!/bin/python
import subprocess
import os
from datetime import datetime
from tkinter import Tk, Text, Scrollbar, Button

ignoreNew = ['./.config/nvim/', './.config/fish/', './.config/yazi/']
os.chdir(os.path.expanduser('~/my-configs-stow/'))


def get_untracked(stdout: str):
    out = []
    print(stdout)
    for line in stdout.splitlines():
        if line.startswith('??'):
            out.append(line[2:])
    return out


def display_popup(message):
    print(message)
    root = Tk()
    root.title("Git Status")

    # Create a Text widget for displaying the message
    text_widget = Text(root, wrap='word', height=15, width=50)
    text_widget.insert('1.0', message)  # Insert the message into the Text widget
    text_widget.config(state='disabled')  # Make the text widget read-only

    # Add a Scrollbar to the Text widget
    scrollbar = Scrollbar(root, command=text_widget.yview)
    scrollbar.pack(side='right', fill='y')
    text_widget.config(yscrollcommand=scrollbar.set)
    scrollbar.pack()

    # Add a button to close the popup
    close_button = Button(root, text="Close", command=root.quit)
    close_button.pack()

    root.mainloop()


stdout = subprocess.run(['git', 'status', '-s'], capture_output=True, text=True).stdout


untracked = get_untracked(stdout)

for path in untracked[:]:
    temp = './'+path.strip()
    for ignored_paths in ignoreNew:
        if temp.startswith(ignored_paths):
            untracked.remove(path)

if stdout == '':
    exit(0)
elif len(untracked) >= 1:
    untracked_string = ''
    for line in untracked:
        untracked_string += line+'\r\n'
    display_popup('Following are untracked:\r\n' + untracked_string)
else:
    time_stamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    add = subprocess.run(['git', 'add', '.'])
    commit = subprocess.run(['git', 'commit', '-am', time_stamp],
                          capture_output=True, text=True)
    commit_error = commit.stderr

    if commit_error != '':
        print('commit'+commit_error+'error')
        display_popup(commit_error)
    else:
        push = subprocess.run(['git', 'push'], capture_output=True, text=True)
        push_err = push.returncode
        if push_err != 0:
            print('push'+push_err+'error')
            print(push.stdout)
            display_popup('auto push had an error pushign' + push_err)
