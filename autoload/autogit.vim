" autogit.vim
"
" autocommit changes to a file to a special git repo.  
"
" inspired by [this
" comment](http://www.reddit.com/r/linux/comments/y5j35/texteditor_with_etherpadlike_feature/c5sijfi)
" in reddit and the discussion.
silent !mkdir ~/.autogit > /dev/null 2>&1

function! autogit#ToggleAutogit()
if has("autocmd")
	if !exists("b:autogit_enabled") || b:autogit_enabled == "0"
		augroup Autogit
			au!
			autocmd BufWritePost <buffer> call autogit#Commit()
		augroup END
		let b:autogit_enabled = 1
	else
		augroup Autogit
			au! BufWritePost <buffer>
		augroup END
		augroup! Autogit
		let b:autogit_enabled = 0
	endif
endif
endfunction

function! autogit#Commit()
	let repo = autogit#PrepareGitRepository()
	call system("GIT_DIR=".repo. " GIT_WORK_TREE=. git add ".expand("%:t"))
	call system('GIT_DIR='.repo. ' GIT_WORK_TREE=. git commit -m "`date`"')
endfunction

function! autogit#PrepareGitRepository()
    let filename = expand("%:p")
    let filename = substitute(filename, '/', '--', 'g')
	let repo_name = $HOME."/.autogit/".filename
	call system("GIT_DIR=".repo_name." git branch")
	if v:shell_error
		call system("GIT_DIR=".repo_name." git init")
	endif
	return repo_name
endfunction

function! autogit#Git(args)
	execute "!GIT_DIR=.autogit-".expand("%:t")." GIT_WORK_TREE=. git --no-pager ".a:args
endfunction
