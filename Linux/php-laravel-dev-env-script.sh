sudo apt update

sudo apt upgrade -y

sudo apt install git curl software-properties-common xsel jq network-manager libnss3-tools -y


# brave

if ! [ -x "$(command -v brave-browser)" ];
then
	sudo apt install apt-transport-https -y

	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

	sudo apt update

	sudo apt upgrade -y

	sudo apt install brave-browser -y
fi


#php

if ! [ -x "$(command -v php)" ];
then
	sudo add-apt-repository -y ppa:ondrej/php

	sudo apt install php7.4 php8.0 php8.1 -y

	sudo apt install php7.4-zip php7.4-xml php7.4-mysql php7.4-curl php7.4-mbstring php7.4-mcrypt -y
	sudo apt install php8.0-zip php8.0-xml php8.0-mysql php8.0-curl php8.0-mbstring php8.0-mcrypt -y
	sudo apt install php8.1-zip php8.1-xml php8.1-mysql php8.1-curl php8.1-mbstring php8.1-mcrypt -y
fi


#mysql

if ! [ -x "$(command -v mysql)" ];
then
	sudo apt install mysql-server -y
fi


#composer

if ! [ -x "$(command -v composer)" ];
then
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
	php composer-setup.php
	php -r "unlink('composer-setup.php');"
	
	sudo mv composer.phar /usr/local/bin/composer
	
	echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.zshrc
	
	source .zshrc
fi


#laravel-installer
if ! [ -x "$(command -v laravel)" ];
then
	composer global require laravel/installer
fi


# valet
if ! [ -x "$(command -v valet)" ];
then
	composer global require cpriego/valet-linux -W
fi

valet links
if ! [ $? -eq 0 ];
then
	valet install
	
	
	cd ~/

	PROJECTS_DIR="Projects"
	if [ ! -d "$PROJECTS_DIR" ];
	then
		mkdir $PROJECTS_DIR
	fi


	LARAVEL_DIR="Projects/Laravel"
	if [ ! -d "$LARAVEL_DIR" ];
	then
		mkdir $LARAVEL_DIR
	fi

	cd $LARAVEL_DIR

	valet park

	cd ~/
fi


#vscode
if ! [ -x "$(command -v code)" ];
then
	sudo apt-get install wget gpg
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	rm -f packages.microsoft.gpg
	sudo apt install apt-transport-https
	sudo apt update
	sudo apt install code
fi


#ssh 
SSH_DIR=".ssh"
if [ ! -d "$SSH_DIR" ];
then
	ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''
fi


#nvm
if ! [ -x "$(command -v nvm)" ];
then
	curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
	source ~/.zshrc
fi


#node
if ! [ -x "$(command -v node)" ];
then
	nvm install --lts
fi

echo "Done";
