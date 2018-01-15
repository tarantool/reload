package = 'reload'
version = 'scm-1'

source  = {
    url    = 'git://github.com/tarantool/reload.git';
    branch = 'master';
}

description = {
    summary  = "Hot code reloading for Tarantool";
    detailed = [[
    This module allows you to do hot code reloading to ease the process of development
    ]];
    homepage = 'https://github.com/tarantool/reload.git';
    maintainer = "Konstantin Nazarov <mail@kn.am>";
    license  = 'BSD2';
}

build = {
    type = 'builtin';
    modules = {
        ['reload'] = 'reload.lua';
    }
}
