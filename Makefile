## help: display this message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##\s//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/    /'

## switch: apply the configuration
.PHONY: switch
switch:
	@scripts/switch

## update: update flake.lock
.PHONY: update
update:
	nix flake update
