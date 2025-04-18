#!/usr/bin/env bash
set -eu

git submodule update --init

readonly dotfiles=(./dotfiles/*)
readonly config_content=(./config/*)
readonly omz_plugins=(./oh-my-zsh-plugins/*)
readonly secrets=(./dotfiles/secrets/*.gpg)
readonly fonts=(./fonts/*/*.otf)

for fontFile in "${fonts[@]}"; do
	target="${HOME}/.local/share/fonts/otf/$(basename "${fontFile}")"

	if [[ ! -d "$(dirname "${target}")" ]]; then
		mkdir -p "$(dirname "${target}")"
	fi

	if test -e "${target}" || test -h "${target}"; then
		rm -rf "${target}"
  	fi

	echo "symlinking \"${fontFile}\" to \"${target}\""
	ln -s "$(realpath "${fontFile}")" "${target}"
done

fc-cache

for dotfile in "${dotfiles[@]}"; do
	target="${HOME}/.$(basename "${dotfile}")"
	
	if test -e "${target}" || test -h "${target}"; then
		rm -rf "${target}"
  	fi

	echo "symlinking \"${dotfile}\" to \"${target}\""
	ln -s "$(realpath "${dotfile}")" "${target}"
done

for config_file in "${config_content[@]}"; do
  	target="${HOME}/.config/$(basename "${config_file}")"

  	if test -e "${target}" || test -h "${target}"; then
	    rm -rf "${target}"
  	fi

  	echo "symlinking \"${config_file}\" to \"${target}\""
	ln -s "$(realpath "${config_file}")" "${target}"
done

for omz_plugin in "${omz_plugins[@]}"; do
  	target="${HOME}/.oh-my-zsh/plugins/$(basename "${omz_plugin}")"

	if test -e "${target}" || test -h "${target}"; then
		rm -rf "${target}"
	fi

	echo "symlinking \"${omz_plugin}\" to \"${target}\""
	ln -s "$(realpath "${omz_plugin}")" "${target}"
done

for secret in "${secrets[@]}"; do
	name="$(basename "${secret}")"
	echo "Decrypting secret ${name}"
	gpg --output "./dotfiles/secrets/${name%".gpg"}" --decrypt --yes "${secret}"
done

vim +PlugInstall +PlugUpdate +q +q
