# boom
Emulate DuckDuckGo bangs on your computer

## Why boom?
1. Faster than using duckduckgo bangs (no need to make two requests)

2. More custom than duckduckgo bangs

3. Easier to configure than in-browser search configs

4. Doesn't force you into using a specific search engine.

## Installing
1. Get Nim (needed for the server) via [choosenim](https://github.com/dom96/choosenim)
and a menu, like [rofi](https://github.com/davatorium/rofi) or 
[dmenu](https://tools.suckless.org/dmenu) (not needed if you're only going to use boom 
through your web browser).

2. Make sure `$HOME/.local/bin` is in your `PATH` (just add 
`export PATH="$HOME/.local/bin":$PATH` to your `.bashrc`) and make sure its a folder that
exists.

3. Run the `install.sh` file.

## Usage
`boom [query]`
When boom is run without a query, it will execute a dmenu-like executable, defined in the
`MENU` environmental variable (`rofi -dmenu -L0` by default) to get the search query from
the user. It then searches the query for the boom prefix, defined in the `BOOM_PREFIX`
environmental variable (`@` by default). If it find this prefix, it tries to use the
"boom" search engine. If it doesn't, it will use the default search engine.

If the query wasn't specified through the arguements, the resulting URL will be opened
with `xdg-open`, otherwise it will output the URL into stdout.

### Examples:
```
boom # opens dmenu for query
```
```
boom test # gets default search query
https://searx.cedars.xyz/search?q=test
```
```
boom @g test # gets the g boom search query
https://google.com/search?q=test
```
```
boom @g # open up the g boom without a query
https://google.com
```

## Configuration
Boom has two methods of configuration: Environmental variables and the boom config file
The environmental variables are:

* `BOOM_CONFIG_FILE` - location of the config file, default is `$XDG_CONFIG_HOME/boom` or `$HOME/.config/boom`

* `BOOM_PREFIX` - prefix for the booms, default is `@`

The config file is a simple format. The first line is the default search engine. The 
query is tacked on to the end of the first line if no bang was specified. The following
lines are in a space separated format: `<boom name> <search URL> <default URL>`. The boom
name is the name of the boom. It's what the script looks for after the prefix 
(`@<boom name> <query>`). The search URL is like the first line, execpt for that bang. 
The query will be tacked on to the end of the search URL. If there is no query, the 
script will instead return the `default URL`.

### Example:
This is the config for the examples in the Usage section:
```
https://searx.cedars.xyz/search?q=
g https://google.com/search?q= https://google.com
```

## Errors
The script will return the following error codes:

* `1` - The config file is inaccessible

* `2` - Invalid boom

## Server
This script also comes with a server, for easy integration with browsers. Simply run
`boom_server` to start it. Modify the `BOOM_SERVER_PORT` to adjust the port the server is
ran on (default `5000`) and `BOOM_SERVER_HOST` to change the host (default `localhost`, 
use an empty string to denote all hosts).

Run the server with `boom_server`. Then, make a search query in the following URL format:
`<host>:<port>/?q=<query>`. With default host and port, this will look like:
`localhost:5432/?q=<query>`. This request will return a 302, redirecting you to the 
correct search engine. Requests to other routes will return a 404. Issues with your
request will return a 400. Issues with boom will return a 500.

The boom server prints out a log, so if you use `boom_server` with an init system, it
will generate logs.
