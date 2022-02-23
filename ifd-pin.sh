# instantiate the expression and list the store paths it needs at evaluation time
list_evaluation_paths () {
	nix-instantiate -v "$@" |& tee /dev/stderr | sed -n "s|^evaluating file '/nix/store/\\([^/]*\\).*'.*\$|\\1|p"
}

# pin each path to prevent its garbage collection
pin_paths () {
	mkdir -p .ifd-pins
	while read -r p; do
		nix-store -r --add-root ".ifd-pins/$p" "/nix/store/$p" >/dev/null
	done
}

list_evaluation_paths "$@" | sort -u | pin_paths
