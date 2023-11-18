#
##########################################################################
#       date > log-git-ubuntu-build.txt; \
#       docker build --no-cache -t ubuntu . \
#               2>&1 | tee -a log-git-ubuntu-build.txt; \
#       date >> log-git-ubuntu-build.txt
############
#
FROM ubuntu:latest
# Create 'vi' backup and swap directory.
RUN mkdir /root/vim-TMP
RUN apt-get update
RUN uname -a
# Ubuntu requires a 'vim' install
RUN apt-get install -y git python3-pip vim
RUN git --version; python3 --version
# In the 'git-fedora' image 'pip' may be used instead of 'pip3'.
RUN pip install boto3 botocore flake8 pytest requests
RUN pip show pip boto3 botocore flake8 pytest requests 2>&1 | tee /git-ubuntu-Pip3Boto3versions.txt
# Install a 'vi' configuration file that understands python and yaml syntax.
# File 'virc' is a copy of a useful '.vimrc' file with backup and swap
# directories configured as '/root/vim-TMP'.
# 'mv' should work,
# but making a backup before overwriting is a more conservative approach.
RUN cp -avp /etc/vim/vimrc /etc/vim/vimrc.ORG
RUN rm -f /etc/vim/vimrc
COPY virc /etc/vim/vimrc
RUN ls -lt /etc/vim/vimrc*
RUN cat /etc/vim/vimrc
COPY pyfuncs.py test_pyfuncs.py Dockerfile /
RUN pytest /test_pyfuncs.py -vrP 2>&1 | tee /git-ubuntu-pytest-results.txt
RUN ls -lrt
ENV MSG='"Hello World from Ubuntu"'
CMD /bin/echo $MSG
# EOF
