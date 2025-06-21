# **Wish (Wizard Shell)** ✨  

🚀 **Wish** is a yet another modern, lightweight shell written in **Crystal**, combining speed, flexibility, and a touch of wizardry for an enhanced command-line experience.  

---

### **⚡ Quick Start**  
1. **Installation** (requires Crystal ≥ 1.16):  
   ```sh
   git clone https://github.com/your-repo/wish  
   cd wish  
   crystal build --release src/wish.cr  
   sudo mv wish /usr/local/bin  
   ```

   Or simply download binary from releases and add it to your path!

2. **Run**:  
   ```sh
   wish  
   ```

3. **Example Config** (`~/.config/wish/config.wif`):  
   ```scheme
   ; Add specified path to $PATH variable.
   ; Same as export PATH=/home/archeda/.local/bin:$PATH
   (add-to-path "/home/archeda/.local/bin")

   ; Creating an environment variable. Same as export FOO=bar
   (export FOO "bar")

   ; Prompt customization
   ; You can use *magical* variables via "#variable-name" to make your prompt functional.
   ; Available variables:
   ;
   ; cwd - current working directory. Example: "/home/profile/.local/bin $"
   ;
   ; cwd-shortened - shortened pwd. Example: "/h/p/.l/bin $"
   ;
   ; whoami - name of current user Example: "root /h/p/.l/bin $"
   ;
   ; git - git branch and status in cwd Example: "/h/p/.l/bin [Master] X $ "
   ; NOTE: if there is no git repository in cwd, then value of #git is empty string
   ;
   (set-prompt "#whoami #cwd $ ")

   ; Defining aliases
   (alias ls "lsd")
   (alias cat "bat")
   ```

---

### **🔧 Commands**  
| Command      | Description                         |  
|--------------|-------------------------------------|  
| `wish -v`    | Show version                        |  
| `wish -c`    | Validate config                     |  
| `cd`         | Change working directory            |
| `exit`       | Close wish                          |
| `history`    | List command history                |
| `!!`         | Repeat last command                 |  
| `!number`    | Repeat command with specified index |
| `alias`      | List aliases                        |
| `variables`  | List environment variables          |

And all binaries from `$PATH`

---

### **📦 Dependencies**  
- Crystal ≥ 1.16

---

### **📜 License**  
MIT — free to use and modify.  

--- 

**✨ Experience the magic of the command line!**  

```sh
wish  # Start right away!
```  
