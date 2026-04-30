.PHONY: install uninstall clean

SCRIPT_PATH := $(shell pwd)/eject-drives.sh
APP_PATH := $(HOME)/Applications/EjectDrives.app

install: $(SCRIPT_PATH)
	@chmod +x $(SCRIPT_PATH)
	@echo "Building launcher app..."
	@osacompile -o $(APP_PATH) -e 'do shell script "/bin/zsh $(SCRIPT_PATH) > /tmp/eject.log 2>&1 &"'
	@echo "✓ Installed: $(APP_PATH)"
	@echo "Add to Stream Deck: System → Open → browse to $(APP_PATH)"

uninstall:
	@rm -rf $(APP_PATH)
	@echo "✓ Uninstalled: $(APP_PATH)"

clean:
	@rm -rf $(APP_PATH)
	@echo "✓ Cleaned"
