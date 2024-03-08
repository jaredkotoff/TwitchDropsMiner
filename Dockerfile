FROM python:3.9-bullseye

# Install xvfb - a virtual X display server for the GUI to display to
RUN apt-get update && apt-get upgrade -y
RUN apt-get install libgirepository1.0-dev xvfb -y

COPY . /TwitchDropsMiner/
WORKDIR /TwitchDropsMiner/

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

RUN chmod +x ./docker_entrypoint.sh
ENTRYPOINT ["./docker_entrypoint.sh"]

HEALTHCHECK --interval=10s --timeout=5s --start-period=1m --retries=3 CMD ./healthcheck.sh

ENV UNLINKED_CAMPAIGNS=1
CMD ["python", "main.py", "-vvv"]

# Example command to build:
# docker build -t twitch_drops_miner .

# Suggested command to run:
# docker run -it --init --restart=always -v ./cookies.jar:/TwitchDropsMiner/cookies.jar -v ./settings.json:/TwitchDropsMiner/settings.json:ro twitch_drops_miner
