#!/usr/bin/env tarantool
-- luacheck: globals box

local reload = require 'reload'
local fio = require 'fio'
local errno = require('errno')

local function write_file(path, data)
    local file = fio.open(path, {'O_RDWR', 'O_CREAT', 'O_TRUNC'}, 644)

    if file == nil then
        error(string.format('Failed to open file %s: %s', path, errno.strerror()))
    end

    file:write(data)

    file:close()
end


local function create_module(test_dir, module_name, code)
    local module_path = fio.pathjoin(test_dir, module_name .. '.lua')

    write_file(module_path, code)
end


local function main()
    local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or '.'
    local test_dir

    if os.getenv('TARANTOOL_VERSION') == nil then
        test_dir = script_dir .. '/.test'
    else
        test_dir = '/tmp'
    end

    os.execute("mkdir -p '" .. test_dir .. "'")
    package.path =  test_dir .. '/?.lua;' .. package.path

    create_module(test_dir, 'foo', [[
    local function bar()
        return 'bar'
    end

    return {bar=bar}
    ]])

    local foo = require('foo')

    assert(foo.bar() == 'bar')

    create_module(test_dir, 'foo', [[
    local function bar()
        return 'qux'
    end

    return {bar=bar}
    ]])

    reload.reload()

    assert(foo.bar() == 'qux')

    os.exit(0)
end



main()
