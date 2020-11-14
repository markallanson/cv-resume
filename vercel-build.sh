# Vercel uses Amazon Linux 2 for builds which is missing a bunch of stuff we need
# so we go ahead and add the EPEL repo and pull in our build tools.
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install wkhtmltopdf
yum install wget
yum install xorg-x11-server-Xvfb

# The EPEL repo only has an ancient version of pandoc so we need to pull the latest
# manually.
mkdir pandoc
wget -qO- https://github.com/jgm/pandoc/releases/download/2.11.1.1/pandoc-2.11.1.1-linux-amd64.tar.gz | tar xvzf - --strip-components 1 -C ./pandoc
export PATH="./pandoc/bin:$PATH"

# wkhtmltopdf requires an x server, so run xvfb when we run it.
printf '#!/bin/bash\nxvfb-run -a --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf -q $*' > /usr/bin/wkhtmltopdf.sh
chmod a+x /usr/bin/wkhtmltopdf.sh
ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf

make all
