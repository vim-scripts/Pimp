"LICENSE
"-
" Copyright 2008 (c) Meikel Brandmeyer.
" Copyright 2008 (c) Yariv Barkan.
" All rights reserved.
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
"

if &cp || exists("loaded_pimp")
    finish
endif
let loaded_pimp = 1

let s:save_cpo = &cpo
set cpo&vim

"
" <ipython.vim>
"
if !exists("python_pimp#ScreenCommand")
	let python_pimp#ScreenCommand = "screen"
endif

if !exists("python_pimp#BufferDirectory")
	let python_pimp#BufferDirectory = "/tmp"
endif

if !exists("python_pimp#BufferFile")
	let python_pimp#BufferFile = "vimipython"
endif

function! python_pimp#SendMessage(ipython, msg)
"	call python_pimp#SendLines(a:ipython, split(a:msg, "\\n", 1))
	call python_pimp#EvalCode(a:ipython, split(a:msg, "\\n", 1))
endfunction

function! python_pimp#SendLines(ipython, lines)
	let buffile = g:python_pimp#BufferDirectory . "/" . g:python_pimp#BufferFile . "." . a:ipython . ".pipe"
	call writefile(a:lines, buffile)
	call system(g:python_pimp#ScreenCommand . ' -x ' . a:ipython
				\ . ' -X eval "focus" "readbuf" "paste ." "focus"')
endfunction

function! python_pimp#EvalCode(ipython, lines)
	let dotIndex = stridx(a:ipython, '.')
	let buffile = g:python_pimp#BufferDirectory . "/" . g:python_pimp#BufferFile. strpart(a:ipython, 0, dotIndex) . ".py"
    let preprocessed = ["__name__ = '__pimp_eval__'"] + a:lines
	call writefile(preprocessed, buffile)
	call system(g:python_pimp#ScreenCommand . ' -x ' . a:ipython . ' -X eval "focus"')
	call system(g:python_pimp#ScreenCommand . ' -x ' . a:ipython
				\ . ' -X stuff "%run -i ' . buffile . "\n" . '"')
	call system(g:python_pimp#ScreenCommand . ' -x ' . a:ipython . ' -X eval "focus"')
endfunction
"
" </ipython.vim>
"

function! s:MakePlug(mode, plug, f)
	execute a:mode . "noremap <Plug>Pimp" . a:plug
				\ . " :call <SID>" . a:f . "<CR>"
endfunction

function! s:MapPlug(mode, keys, plug)
	if !hasmapto("<Plug>Pimp" . a:plug)
		execute a:mode . "map <buffer> <unique> <silent> <LocalLeader>" . a:keys
					\ . " <Plug>Pimp" . a:plug
	endif
endfunction

function! s:WithSaved(closure)
	let v = a:closure.get(a:closure.tosafe)
	let r = a:closure.f()
	call a:closure.set(a:closure.tosafe, v)
	return r
endfunction

function! s:WithSavedRegister(reg, closure)
	let a:closure['tosafe'] = a:reg
	let a:closure['get'] = function("getreg")
	let a:closure['set'] = function("setreg")
	return s:WithSaved(a:closure)
endfunction

function! s:WithSavedPosition(closure)
	let a:closure['tosafe'] = "."
	let a:closure['get'] = function("getpos")
	let a:closure['set'] = function("setpos")
	return s:WithSaved(a:closure)
endfunction

function! s:Yank(reg, how)
	let closure = {'register': a:reg, 'yank': a:how}

	function closure.f() dict
		execute self.yank
		return getreg(self.register)
	endfunction

	return s:WithSavedRegister(a:reg, closure)
endfunction

function! s:Connect()
	if !exists("s:PimpId")
		let s:PimpId = $STY
	endif
endfunction

function! s:ResetPimp()
	unlet s:PimpId
	let s:PimpId = input("Please give Pimp Id: ") . ".pimp"
endfunction

function! s:EvalBlock() range
	call s:Connect()

    " get the contents of the clipboard
    let b = @*

	call python_pimp#SendMessage(s:PimpId, b)
endfunction

function! s:EvalFile()
	call s:Connect()

	let closure = {}
	function closure.f() dict
		return s:Yank('l', 'normal ggVG"ly')
	endfunction

	call python_pimp#SendMessage(s:PimpId, s:WithSavedPosition(closure))
endfunction

if !exists("no_plugin_maps") && !exists("no_python_pimp_maps")
	call s:MakePlug('v', 'EvalBlock', 'EvalBlock()')
	call s:MakePlug('n', 'EvalFile', 'EvalFile()')
	call s:MakePlug('n', 'ResetPimp', 'ResetPimp()')

	call s:MapPlug('v', 'pb', 'EvalBlock')
	call s:MapPlug('n', 'pf', 'EvalFile')
	call s:MapPlug('n', 'rp', 'ResetPimp')
endif

let &cpo = s:save_cpo

