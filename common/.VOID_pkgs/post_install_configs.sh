#!/bin/bash


# Configure Services (Runit)
echo "Setting up services..."
sudo ln -s /etc/sv/dbus /var/service/
sudo ln -s /etc/sv/elogind /var/service/
sudo ln -s /etc/sv/chronyd /var/service/
sudo ln -s /etc/sv/NetworkManager /var/service/
sudo ln -s /etc/sv/keyd /var/service/

# Finalize User Environment
echo "Finalizing user settings..."
# Change shell to Zsh for the current user
chsh -s /bin/zsh $USER

# visudo %wheel group NOPASSWD edit (uncomment)


# Add Your User to the Correct Groups
# Run this command (replace yourusername with your actual name):
sudo usermod -aG wheel,video,audio,input,_unbound yourusername


# .zshrc alias to reboot or shutdown
#alias reboot='loginctl reboot'
#alias shutdown='loginctl poweroff'


# Create the Polkit Rule
# Create a new file in the Polkit rules directory (name it like 10-power-management.rules)
cat << 'EOF' | sudo tee /etc/polkit-1/rules.d/10-power-management.rules
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.login1.reboot" ||
         action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
         action.id == "org.freedesktop.login1.power-off" ||
         action.id == "org.freedesktop.login1.power-off-multiple-sessions") &&
        subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF


install base pkgs
run commands (run kitten themes)
starship fonts?
