.PHONY: install uninstall clean setup-sudoers

SCRIPT_PATH := $(shell pwd)/eject-drives.sh
APP_PATH := $(HOME)/Applications/EjectDrives.app
SUDO_RULE := "/etc/sudoers.d/diskutil-eject"

install: $(SCRIPT_PATH)
	@chmod +x $(SCRIPT_PATH)
	@echo "Building launcher app..."
	@osacompile -o $(APP_PATH) -e 'do shell script "/bin/zsh $(SCRIPT_PATH) > /tmp/eject.log 2>&1" with administrator privileges'
	@echo "✓ Installed: $(APP_PATH)"
	@echo "Add to Stream Deck: System → Open → browse to $(APP_PATH)"
	@echo ""
	@echo "Optional: Run 'make setup-sudoers' for passwordless ejects"

setup-sudoers:
	@echo "Setting up passwordless diskutil eject..."
	@echo "$$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/diskutil eject *" | sudo tee $(SUDO_RULE) > /dev/null
	@echo "✓ Sudoers rule installed at $(SUDO_RULE)"
	@echo "Now eject drives without password prompts!"

uninstall:
	@rm -rf $(APP_PATH)
	@echo "✓ Uninstalled: $(APP_PATH)"

clean:
	@rm -rf $(APP_PATH)
	@echo "✓ Cleaned"
