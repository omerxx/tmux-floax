Tmux FloaX
============
Floating panes in Tmux!

![image](./img/floaxv2.png)

## Install 💻

Add this to your `.tmux.conf` and run `Ctrl-I` for TPM to install the plugin.
```conf
set -g @plugin 'omerxx/tmux-floax'
```

## Important to know ❗
The plugin uses Tmux popup window and creates a new session within it. This let's you, the user, enjoy a floating pane that also has Tmux capabilities - splits, windows etc. While most use cases will not require such functionality, do know that it exists.

## Configure ⚙️

The default binding for this plugin is `<prefix>+p` (and `<prefix>+P` for the internal menu)
You can change it by adding this line with your desired key:

```bash
set -g @sessionx-bind '<mykey>'
```

### Additional configuration options:

```bash
# Setting the main key to toggle the floating pane on and off
set -g @floax-bind '<my-key>'

# When the pane is toggled, using this bind pops a menu with additional options
# such as resize, fullscreen, resetting to defaults and more.
set -g @floax-bind-menu 'P'

# The default width and height of the floating pane
set -g @floax-width '80%'
set -g @floax-height '80%'

# The border color can be changed, these are the colors supported by Tmux:
# black, red, green, yellow, blue, magenta, cyan, white
set -g @floax-border-color 'magenta'

# The text color can also be changed, by default it's blue to distinguish from the main window
# Optional colors are as shown above in @floax-border-color
set -g @floax-text-color 'blue'

# The title of the floating pane can remain empty or use the string below
set -g @floax-title 'FloaX'
