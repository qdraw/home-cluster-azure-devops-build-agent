FROM ubuntu:24.04
ARG POWERSHELL_VERSION=7.4.7 # https://www.nuget.org/packages/PowerShell/7.4.7
ARG DOTNET_VERSION=8.0
ARG NVM_VERSION=0.40.2

RUN apt update
RUN apt upgrade -y
# RUN apt search libicu && exit 1
RUN apt install -y curl git jq libicu74 wget openssh-client zip rsync rclone ansible

WORKDIR /azp/

COPY ./start.sh ./
COPY ./sshsetup.sh ./
RUN chmod +x ./start.sh

RUN if id -u 1000 >/dev/null 2>&1; then userdel -r $(getent passwd 1000 | cut -d: -f1); fi

RUN useradd -u 1000 agent
RUN chown agent ./ && mkdir /home/agent && chown agent /home/agent
USER agent

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash

RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /home/agent/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/agent/.bashrc
RUN bash -c "source /home/agent/.bashrc && nvm install --lts && nvm use --lts && nvm alias default node"

RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh && chmod +x ./dotnet-install.sh && ./dotnet-install.sh --channel ${DOTNET_VERSION}
RUN echo 'export DOTNET_ROOT="$HOME/.dotnet"' >> /home/agent/.bashrc && \
    echo 'export PATH="$PATH:$HOME/.dotnet:$HOME/.dotnet/tools"' >> /home/agent/.bashrc && \
    echo 'export NUGET_XMLDOC_MODE=skip' >> /home/agent/.bashrc && \
    echo 'export DOTNET_CLI_TELEMETRY_OPTOUT=1' >> /home/agent/.bashrc && \
    echo 'export DOTNET_NOLOGO=1' >> /home/agent/.bashrc

RUN bash -c "source /home/agent/.bashrc && dotnet tool install --global PowerShell --version ${POWERSHELL_VERSION}"

# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT ./start.sh
