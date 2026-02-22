# Vector2D Lua
A simple 2D vector module in Lua I originally wrote to help with PICO-8 game development *- uses Lua standard libraries, not PICO-8 equivalents*. I added assertions to the code, and tests for peace of mind.


## Usage
Place `vector.lua` inside project directory and import, eg.
```lua
local vector = require('vector')
```

Requires [luaunit](https://github.com/bluebird75/luaunit) to run tests:
```
lua vector.test.lua
```
*Optionally add `--verbose` tag to see individual tests*
