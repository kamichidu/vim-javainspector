" The MIT License (MIT)
"
" Copyright (c) 2014 kamichidu
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
if !has('lua')
    echohl ErrorMsg
    echomsg "javainspector: `if_lua' is not enabled, disabling me..."
    echohl None
    finish
endif

let s:save_cpo= &cpo
set cpo&vim

let s:jclasspath= javaclasspath#get()

let s:obj= {}

function! s:init_lua()
    let l:jclass_path= globpath(&runtimepath, 'lua-jclass/') . '/lib/?.lua'
    let l:bridge_path= globpath(&runtimepath, 'lua/') . '/?.lua'

    lua << ...
    local jclass_path= vim.eval('l:jclass_path')
    local bridge_path= vim.eval('l:bridge_path')
    package.path= package.path .. ';' .. jclass_path .. ';' .. bridge_path

    if not _G.javainspector then
        _G.javainspector= {
            jclass= require 'jclass',
            bridge= require 'bridge',
        }

        local cache= {}
        function _G.javainspector.get_jclass(canonical_name)
            if cache[canonical_name] then
                return cache[canonical_name]
            end

            local jc= self.jclass.for_name(canonical_name)

            cache[canonical_name]= jc

            return jc
        end
    end
...
endfunction

call s:init_lua()

function! s:obj.for_name(canonical_name)
    lua << ...
    local canonical_name= vim.eval('a:canonical_name')
    local jc= _G.javainspector.get_jclass(canonical_name)

    vim.command('let l:result=' .. _G.javainspector.bridge.to_vimrepl(jc))
...
    if !exists(l:result)
        throw 'javainspector: illegal state'
    endif

    return l:result
endfunction

function! javainspector#get()
    return deepcopy(s:obj)
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo
" vim:fen:fdm=marker
