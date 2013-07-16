unit:
	node test-make/unit.toDDB.js

integration:
	node test-make/integration.item.js

batch:
	node test-make/batch.js

test: unit integration batch

.PHONY: test
