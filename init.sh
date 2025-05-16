#!/bin/bash
echo -e "\033[1;34m正在安装常用软件\033[0m"
sleep 1
sudo apt update && sudo apt upgrade -y
sudo apt install zsh neovim python3 btop lolcat vim git wget curl neofetch lolcat fzf -y
if [[ $? -ne 0 ]]; then
    echo -e "\033[1;31m常用软件安装失败，请检查网络或源配置。\033[0m"
    exit 1
else
    echo -e "\033[1;32m常用软件安装成功！\033[0m"
fi
echo -e "\033[1;34m是否安装lsd(y/N)\033[0m"
read -r install_lsd
if [[ "$install_lsd" == "y" || "$install_lsd" == "Y" ]]; then
    echo -e "\033[1;34m正在安装lsd\n\033[0m"
    sudo apt install lsd
    if [[ $? -ne 0 ]]; then
        echo -e "\033[1;31mlsd 安装失败，请检查网络或源配置。\033[0m"
    else
        echo -e "\033[1;32mlsd安装成功！\033[0m"
    fi
else
    echo -e "\033[1;32m跳过lsd安装\033[0m"
fi

echo -e "\033[1;34m是否安装omz和p10k以及部分插件(y/N)\033[0m"
read -r install_omz
if [[ "$install_omz" == "y" || "$install_omz" == "Y" ]]; then
    echo -e "\033[1;34m正在安装omz和p10k以及部分插件\033[0m"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    
    sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/g' ~/.zshrc
    
    sed -i 's/(git)/(git extract zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
    
    echo -e "\033[1;32momz相关安装成功！\033[0m"
    
else
    echo -e "\033[1;32m跳过omz安装\033[0m"
fi

echo -e "\033[1;34m是否添加lsd的alias (y/N)\033[0m"
read -r alias_lsd
if [[ "$alias_lsd" == "y" || "$alias_lsd" == "Y" ]]; then
    echo 'alias ls=lsd' >>~/.zshrc
fi
echo -e "\033[1;32m跳过添加lsd的alias\n\033[0m"

echo -e "\033[1;34m是否添加登录时的ASCII (y/N)\033[0m"
read -r login_ascii
if [[ "$login_ascii" == "y" || "$login_ascii" == "Y" ]]; then
    mkdir -p ~/.scripts/
  cat > ~/.scripts/motd.sh <<'EOF'
#!/bin/bash
MOTD_CONTENT="
     ██╗██╗   ██╗███████╗████████╗    ██████╗ ███╗   ███╗          ██████╗ ███████╗        ██╗
     ██║██║   ██║██╔════╝╚══██╔══╝    ██╔══██╗████╗ ████║          ██╔══██╗██╔════╝       ██╔╝▄ ██╗▄
     ██║██║   ██║███████╗   ██║       ██████╔╝██╔████╔██║    █████╗██████╔╝█████╗        ██╔╝  ████╗
██   ██║██║   ██║╚════██║   ██║       ██╔══██╗██║╚██╔╝██║    ╚════╝██╔══██╗██╔══╝       ██╔╝  ▀╚██╔▀
╚█████╔╝╚██████╔╝███████║   ██║       ██║  ██║██║ ╚═╝ ██║          ██║  ██║██║         ██╔╝     ╚═╝
 ╚════╝  ╚═════╝ ╚══════╝   ╚═╝       ╚═╝  ╚═╝╚═╝     ╚═╝          ╚═╝  ╚═╝╚═╝         ╚═╝
"

if command -v lolcat &> /dev/null; then
    echo -e "$MOTD_CONTENT" | lolcat
else
    echo -e "$MOTD_CONTENT"
fi
EOF
    
    chmod +x ~/.scripts/motd.sh
    sed -i '1i\/home/$USER/.scripts/motd.sh' ~/.zshrc
else
    echo -e "\033[1;32m跳过ASCII添加\033[0m"
fi

echo -e "\033[1;34m是否修改语言为中文(y/N)\033[0m"
read -r locals_zh
if [[ "$locals_zh" == "y" || "$locals_zh" == "Y" ]]; then
    sudo apt install locales-all -y
    
    echo "LANG=zh_CN.UTF-8
    LC_ALL=zh_CN.UTF-8" >> ~/.zshrc
    
    sudo locale-gen zh_CN.UTF-8
    sudo update-locale LANG=zh_CN.UTF-8
else echo -e "\033[1;32m跳过语言修改\033[0m"
fi

echo -e "\033[1;34m所有步骤执行完成 请手动运行"source ~/.zshrc"\n\033[0m"
