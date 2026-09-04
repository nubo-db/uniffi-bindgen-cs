# NOTE: this is a moving tag, so what it resolves to changes over time. That
# is how the gap below went unnoticed: a published image built when the tag
# meant something else keeps working, while a fresh build of this same file
# does not.
FROM mcr.microsoft.com/dotnet/sdk:10.0

LABEL org.opencontainers.image.source=https://github.com/NordSecurity/uniffi-bindgen-cs

# The test project targets net9.0. An SDK 10 image compiles it and then cannot
# run it, because the 9.0 runtime is not present and the SDK does not imply it.
# The failure surfaces at test time, well after the build has looked healthy.
RUN curl -sSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh \
    && chmod +x /tmp/dotnet-install.sh \
    && /tmp/dotnet-install.sh --channel 9.0 --runtime dotnet --install-dir /usr/share/dotnet \
    && rm /tmp/dotnet-install.sh

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain=1.88

RUN apt-get update && apt-get install -y --no-install-recommends build-essential && apt-get clean

RUN dotnet tool install -g csharpier
RUN echo 'export PATH="$PATH:/root/.dotnet/tools"' >> /root/.bashrc

# Also on PATH for shells that never read a startup file. The .bashrc line
# above is what an interactive session picks up; a non-interactive
# `bash -c` may not, and both cargo and csharpier have to be findable either
# way or the suite fails somewhere unhelpful.
ENV PATH="/root/.cargo/bin:/root/.dotnet/tools:${PATH}"
