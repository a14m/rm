rm
==

since you've reached this page,I assume you did the same bad thing I did before.

after using `rm very_important_file` you can't figure out how to retrieve that file.
I'm not sure how to retrive that file, but I came to write this to avoid doing the same stupid mistake ever again.

you can thank me later :D


This is custom script used to avoid deleting files forever instead files will be moved to /Users/user_name/.Trash folder

This script **only works if you invoked it directly from the terminal** `rm file`

**it doesn't work if any script used `rm some_file` or if you used `rm` in other scripts**

and this is done for your own safety, but if you need it to work with other scripts,

please feel free to contact me and i'll instruct you on how to enable that


-----

Install
-
`sudo cp rm.sh /usr/local/bin/rm`

you might need to restart the terminal or run `source ~/.bashrc` or `source ~/.bash_profile`

Uninstall
-
`sudo rm /usr/local/bin/rm`

you might need to restart the terminal or run `source ~/.bashrc` or `source ~/.bash_profile`

**please make sure that local/bin PATH before /bin PATH**

add `export PATH="/usr/local/bin:$PATH"` to `.bash_profile` or `.bashrc` to achive this

Usage
-
`rm [OPTION]...FILE...`

`/bin/rm [OPTION]...FILE...` to use the system rm for special cases this script don't cover

###Options
| option      |  desc. |
|-------------|--------|
| `-h,--help` | display this help text and exit. |
| `--version` | output version information and exit. |
| `-r, -R, --recursive` | **move** the directories and their content to the Trash folder. |
| `-f, --forever` | **remove** the directories and their content to the Trash folder ( what you did :D ).|

Bugs
-
Please report found bugs to <https://github.com/artmees/rm/issues>


COPYRIGHT
---------
Copyright (C) 2013, Ahmed Abdel Razzak. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the
Free Software Foundation; version 2 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59
Temple Place, Suite 330, Boston, MA 02111-1307 USA or see http://www.gnu.org/licenses/.
