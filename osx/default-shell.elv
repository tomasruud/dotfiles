use runtime
if (not (has-value [(cat /etc/shells)] $runtime:elvish-path)) {
    echo $runtime:elvish-path | sudo tee -a /etc/shells
}
chsh -s $runtime:elvish-path
