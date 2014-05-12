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
let s:save_cpo= &cpo
set cpo&vim

let s:jclass= {
\   'attr': {
\       'canonical_name': '',
\   },
\}

function! s:jclass.package_name()
    lua << ...
    local canonical_name= vim.eval('self.attr.canonical_name')
    local jc= _G.javainspector:get_jclass(canonical_name)

    vim.command('let l:result=' .. _G.javainspector.bridge.to_vimrepl(jc:package_name()))
...
    return l:result
endfunction

function! s:jclass.canonical_name()
    lua << ...
    local canonical_name= vim.eval('self.attr.canonical_name')
    local jc= _G.javainspector:get_jclass(canonical_name)

    vim.command('let l:result=' .. _G.javainspector.bridge.to_vimrepl(jc:canonical_name()))
...
    return l:result
endfunction

function! s:jclass.simple_name()
    lua << ...
    local canonical_name= vim.eval('self.attr.canonical_name')
    local jc= _G.javainspector:get_jclass(canonical_name)

    vim.command('let l:result=' .. _G.javainspector.bridge.to_vimrepl(jc:simple_name()))
...
    return l:result
endfunction

function! javainspector#jclass#new(canonical_name)
    let l:instance= deepcopy(s:jclass)

    let l:instance.attr.canonical_name= a:canonical_name

    return l:instance
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo
