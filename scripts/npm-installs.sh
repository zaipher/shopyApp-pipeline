#!/bin/bash
echo '-------------START OF DEPLOY STAGE------------------------'
pwd
ls -l
#----------------------------------
if [ -x "$(command -v node)" ]; then
    read currentNodeVer  <<< $(node -v)
    echo $currentNodeVer
    if [ "$currentNodeVer" = "v12.18.4" ]; then
        echo "Node is updated"
    else
        echo "Updating nodejs"
        sudo yum remove -y nodejs npm
        sudo yum update
        nvm install 12.18.4
        nvm current
        # Should be v12.18.4
        nvm alias default v12.18.4
        node -v
        echo "Done installing nodejs"
    fi
else
    echo "Node is not installed"
    echo 'Error: nvm is not installed.' >&2
    sudo yum remove -y nodejs npm
    sudo yum update
    nvm use --delete-prefix v12.18.4 --silent
    npm config delete prefix
    npm config set prefix $HOME/.nvm/versions/node/v12.18.4
    nvm install 12.18.4
    nvm current
    # Should be v12.18.4
    nvm alias default v12.18.4
    node -v
    echo "Done installing nodejs"
fi

if ! [ -x "$(command -v serverless)" ]; then
    curl -o- -L https://slss.io/install | bash
    source ~/.bash_profile
else
  echo "Sls is installed."
  sls -v
fi
npm install \
@babel/core \
@babel/preset-env \
@babel/preset-react \
babel-loader \
css-loader react \
react-dom \
react-jsx \
react-router \
react-router-dom \
style-loader \
webpack \
webpack-cli \
webpack-dev-server
