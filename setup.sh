#!/usr/bin/env bash
set -eu

git submodule update --init

readonly dotfiles=(./dotfiles/*)
readonly config_content=(./config/*)

for dotfile in "${dotfiles[@]}"; do
	target="${HOME}/.$(basename ${dotfile})"
	
	if test -e "${target}" || test -h "${target}"; then
		rm "${target}"
  	fi

	echo "symlinking \"${dotfile}\" to \"${target}\""
	ln -s "$(realpath ${dotfile})" "${target}"
done

for config_file in "${config_content[@]}"; do
  	target="${HOME}/.config/$(basename ${config_file})"

  	if test -e "${target}" || test -h "${target}"; then
	    rm "${target}"
  	fi

  	echo "symlinking \"${config_file}\" to \"${target}\""
	ln -s "$(realpath ${config_file})" "${target}"
done

readonly secrets=(./dotfiles/secrets/*.gpg)

for secret in "${secrets[@]}"; do
	name="$(basename ${secret})"
	echo "Decrypting secret ${name}"
	gpg --output "./dotfiles/secrets/${name%".gpg"}" --decrypt --yes "${secret}"
done

vim +PlugInstall +PlugUpdate +q +q
