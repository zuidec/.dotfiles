
# Bash Configuration

To set up bash configs, navigate to the .dotfiles/scripts directory and run  
the `bash_config.sh` script.

In your ~/.ssh/ folder should be a `ssh_key_list` file. Enter key names,  
one per line into this file to be loaded at bash start.  

# NeoVIM Configuration


### Dependencies:  

Ensure the following are installed on your machine:  
* Python
* NeoVIM

In Ubuntu, a sufficiently new version of NeoVIM may not be available without  
building from source or adding an unstable repo:  

```

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim

```

### Setup: 

Then, run the `nvim_config.sh` script from the .dotfiles/scripts directory 

Once that is complete, run `nvim .` and once in NeoVIM, run `:PackerSync`.  
The plugins should install.  
