#! /bin/bash
#-
# Copyright 2008 (c) Meikel Brandmeyer.
# Copyright 2008 (c) Yariv Barkan.
# All rights reserved.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# prog must match the BufferFile variable in pimp.vim
prog="vimipython"
version="0.4.0"
majmunka="$0"

usage() {
	echo "Usage: ${0} [options] -- <interp> [<args> ...]"
	echo
	echo "Options:"
	echo " -h          print this help message and exit"
	echo " -s          use given argument as screen command"
	echo " -d          directory where communication buffer files are stored"
	echo
	echo "Internal options: (NOT FOR USER USE!)"
	echo " -S          pass in screenrc name"
	echo
	exit 0
}

args="`getopt hs:S:d: "$@"`"
if [ $? -ne 0 ]; then
	usage
fi

screen=screen
screenrc=
bufferdir=/tmp

set -- ${args}
while [ $# -gt 0 ]; do
	case "$1" in
		-d) bufferdir="$2"; shift; shift;;
		-s) screen="$2"; shift; shift;;
		-S) screenrc="$2"; shift; shift;;
		-h) usage;;
		--) shift; break;;
	esac
done

if [ -z "${screenrc}" ]; then
	screenrc="`mktemp ${bufferdir}/${prog}.XXXXXX`"

    if [ -f ~/.screenrc ]; then
    	cp ~/.screenrc ${screenrc}
    else
        cat >${screenrc} </dev/null
    fi

	cat >>${screenrc} <<EOF
startup_message off
defscrollback   1000
caption         splitonly

obulimit        20971520

msgwait         0
msgminwait      0

defflow         off
EOF

	exec ${screen} -c "${screenrc}" -S pimp -- "${majmunka}" -d "${bufferdir}" -s "${screen}" -S "${screenrc}"
else
	bufferfile="${bufferdir}/${prog}.${STY}.pipe"
	pyfile="${bufferdir}/${prog}$(basename $STY .pimp).py"
	cat >${bufferfile} </dev/null
	
	# "Initializing..."
	
	${screen} -x ${STY} -X eval "hardstatus alwayslastline \"%{= bW}Pimp: <C-a>d to disconnect. Pimp Id: ${STY}\""
	${screen} -x ${STY} -X eval "bufferfile ${bufferfile}"
	
	# "Starting up"
	
	gvim
	ipython

	rm -f ${bufferfile} ${screenrc} ${pyfile}
fi

