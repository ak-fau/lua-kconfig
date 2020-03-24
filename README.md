# Lua kconfig

A small module to handle configuration files in Linux kernel kconfig
format. The module is a pure Lua and does not have any dependencies.

This module provides functions to load a configuration file in a
`.config` Linux kernel configuration format into a Lua table,
optionally filtering variables with a prefix (and removing it).
Resulting table has a metatable storing data to preserve an order and
type of variables in the original configuraiton file and a function to
convert back to a string.  A table may be freely converted betwen flat
(default) and hierarchical forms.

## Usage examples

Usage examples may be found in the source tree in the directory
with `busted` test files. With an example configuration file
`test_config`

~~~~
LUA_HAVE_DOT_CONFIG=y
LUA_INTERPRETER="/usr/bin/lua"
LUA_BOOL_TRUE=y
# LUA_BOOL_FALSE is not set
LUA_INT=42
LUA_HEX=0x42
LUA_STRING="Lua test string with quotes: \", '"
~~~~

this fragment of Lua code

~~~~
kconfig = require "kconfig"
cfg  = kconfig.load("test_config")
~~~~

will set `cfg` variable to the following Lua table:

~~~~
{
  lua_have_dot_config = true,
  lua_hex = 66,
  lua_bool_false = false,
  lua_string = "Lua test string with quotes: \",'",
  lua_int = 42,
  lua_interpreter = "/usr/bin/lua",
  lua_bool_true = true,
}
~~~~

If the `load()` function called with an optional second parameter:
`kconfig.load("test_config", "lua")` only variables starting with the
prefix will be converted and the prefix itself will be removed.  The
resulting table will look like the following:

~~~~
{
  have_dot_config = true,
  hex = 66,
  bool_false = false,
  string = "Lua test string with quotes: \",'",
  int = 42,
  interpreter = "/usr/bin/lua",
  bool_true = true,
}
~~~~

A configuration table returned by the `load()` function may be
converted to a hierarchical representation with
`kconfig.hierarchy(cfg)` function. Result of the conversion (for the
table loaded with a prefix) will be:

~~~~
{
  have = {
           dot = {
                   config = true,
                 },
         },
  hex = 66,
  bool = {
           ["false"] = false,
           ["true"] = true,
         },
  string = "Lua test string with quotes: \",'",
  int = 42,
  interpreter = "/usr/bin/lua",
}
~~~~

Hierarchical table may be converted back to a flat one with
`kconfig.flat()` function.

All the tables have a `__tostring()` function defined in their
metatable.  This function converts the table back to a string
identical to the loaded configuration file fragment.

~~~~
> print(cfg)
LUA_HAVE_DOT_CONFIG=y
LUA_INTERPRETER="/usr/bin/lua"
LUA_BOOL_TRUE=y
# LUA_BOOL_FALSE is not set
LUA_INT=42
LUA_HEX=0x42
LUA_STRING="Lua test string with quotes: \", '"
~~~~


## License

This project is licensed under the MIT License - see the
[LICENSE.txt](LICENSE.txt) file for details.
