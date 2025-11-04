.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

help: ## Vis denne hjelpeteksten
	@grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/ : /' | \
	while IFS=' : ' read -r cmd desc; do \
		printf "\033[36m%-20s\033[0m %s\n" "$$cmd" "$$desc"; \
	done

status: ## Git status på alle repos
	@echo "🔍 Sjekker git status..."
	meta git status

pull: ## Git pull på alle repos med rebase
	@echo "⬇️  Oppdaterer alle repos..."
	meta exec "git pull --rebase --autostash" --parallel

root_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
meta_project := $(notdir $(patsubst %/,%,$(root_dir)))

build: ## Build all sub-projects with make build
	@meta exec "make build" --exclude "$(meta_project)"

test: ## Test all sub-projects with make test
	@meta exec "make test" --exclude "$(meta_project)"

list-local-commits: ## Shows local, unpushed, commits
	@meta exec "git log --oneline origin/HEAD..HEAD | cat"

