#!/bin/bash
#     Copyright 2014 Netflix, Inc.
#
#     Licensed under the Apache License, Version 2.0 (the "License");
#     you may not use this file except in compliance with the License.
#     You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.
sudo apt-get update
sudo apt-get -y install libmysqlclient-dev libxslt-dev libxml2-dev python-pip python-dev libfontconfig1
sudo apt-get -y install fonts-arphic-ukai fonts-arphic-uming fonts-arphic-gbsn00lp fonts-arphic-bkai00mp fonts-arphic-bsmi00lp fonts-arphic-gkai00mp ttf-bitstream-vera ttf-dejavu
if (( $? == 0 )); then
    echo 'apt-get deps installed'
else
    echo 'Boo, there was an error installing deps!'
    exit 1

fi

sudo fc-cache -vf
if (( $? == 0)); then
    echo 'fc-cache font cache rebuilt successfully'
else
    echo 'Could not rebuild font cache'
    exit 1
fi

command -v phantomjs >/dev/null 2>&1 || { 
echo "phantomjs not found...installing."

PHANTOMJS_64="phantomjs-2.1.1-linux-x86_64"
PHANTOMJS_32="phantomjs-2.1.1-linux-i686"
MACHINE_TYPE=`uname -m`
    if [ ${MACHINE_TYPE} == 'x86_64' ]; then
        sudo wget -O /usr/local/share/${PHANTOMJS_64}.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/${PHANTOMJS_64}.tar.bz2
        sudo tar -xf /usr/local/share/${PHANTOMJS_64}.tar.bz2 -C /usr/local/share/
        sudo ln -s /usr/local/share/${PHANTOMJS_64}/bin/phantomjs /usr/local/bin/phantomjs
    else
        sudo wget -O /usr/local/share/${PHANTOMJS_32}.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/${PHANTOMJS_32}.tar.bz2
        sudo tar -xf /usr/local/share/${PHANTOMJS_32}.tar.bz2 -C /usr/local/share/
        sudo ln -s /usr/local/share/${PHANTOMJS_32}/bin/phantomjs /usr/local/bin/phantomjs
    fi
}

if (( $? == 0 )); then
    echo 'phantomjs installed'
else
    echo 'Boo, there was an error install phantomjs!'
    exit 1
fi

sudo apt-get -y install redis-server
if (( $? == 0 )); then
    echo 'redis server installed'
else
    echo 'Boo, there was an error installing redis-server!'
    exit 1
fi

sudo pip install virtualenv
if (( $? == 0 )); then
    echo 'virtual env installed'
else
    echo 'Boo, there was an error installing virtualenv!'
    exit 1
fi

pwd
virtualenv sketchenv
source sketchenv/bin/activate

if (( $? == 0 )); then
    echo 'virtual env configured'
else
    echo 'Boo, there was an error configuring virtualenv!'
    exit 1
fi


python setup.py install
if (( $? == 0 )); then
    echo 'setup.py installed'
else
    echo 'Boo, there was an error running setup.py!'
    exit 1
fi

python manage.py create_db
if (( $? == 0 )); then
    echo 'db tables created'
else
    echo 'Boo, there was an error creating the database table!'
    exit 1
fi
