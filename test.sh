#!/bin/bash

#docker run --privileged -it --rm -v /pedro/desenvolvimento/workspaces/workspace-benchmark/benchmark/data/instrumented:/apps -v /pedro/desenvolvimento/workspaces/workspace-benchmark/benchmark:/benchmark phtcosta/android28-python27:1.0 bash -c ". /start.sh"

#docker run -it --rm --privileged --device /dev/snd --device /dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -v /pedro/desenvolvimento/workspaces/workspace-benchmark/benchmark/data/input:/apps -v /pedro/desenvolvimento/workspaces/workspace-benchmark/benchmark:/opt/benchmark -v /home/pedro/tmp:/opt/benchmark/report -v /home/pedro/tmp:/opt/benchmark/results phtcosta/android:1.0 bash
#docker run -it --rm --privileged --device /dev/snd -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --device /dev/dri -p 31000:5037 -p 31001:5554 -v /pedro/desenvolvimento/workspaces/workspace-benchmark/benchmark/data/input:/apps -v /pedro/desenvolvimento/workspaces/workspace-benchmark/benchmark:/opt/benchmark -v /home/pedro/tmp:/opt/benchmark/report -v /home/pedro/tmp:/opt/benchmark/results phtcosta/android:1.0 bash

BENCHMARK_DIR=/pedro/desenvolvimento/workspaces/workspace-benchmark/benchmark
docker run -it --rm --privileged -v $BENCHMARK_DIR/data/input:/opt/apps -v $BENCHMARK_DIR:/opt/benchmark -v $BENCHMARK_DIR/report:/opt/report phtcosta/android:1.0 bash
#docker run -it --rm --privileged -v $BENCHMARK_DIR/data/input:/opt/apps -v $BENCHMARK_DIR:/opt/benchmark -v $BENCHMARK_DIR/report:/opt/report -v $BENCHMARK_DIR/results:/opt/results phtcosta/android:1.0 bash

# --privileged --device /dev/snd --device /dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY
#emulator -avd Nexus-One-10  -no-window -gpu off -verbose -qemu

#instalar apk, e rodar monkey
#adb -s emulator-5554 install -r Bcom.google.android.diskusage-05E3FD6B3DA4321376C76A65D21B18D3CBC93D5AAA7AE2E86029C2C21647E8CB.apk
#aapt list -a Bcom.google.android.diskusage-05E3FD6B3DA4321376C76A65D21B18D3CBC93D5AAA7AE2E86029C2C21647E8CB.apk
#adb shell monkey -p com.google.android.diskusage -v 10

#KVM
#https://help.ubuntu.com/community/KVM/Installation
#https://linuxconfig.org/install-and-set-up-kvm-on-ubuntu-18-04-bionic-beaver-linux


#docker
#https://dev.to/fastphat/build-a-lightweight-docker-container-for-android-testing-ikh
#https://hub.docker.com/r/antonienko/android-emulator
#https://hub.docker.com/r/thyrlian/android-sdk/
#https://hub.docker.com/r/netdodo/android-emulator/
#https://github.com/budtmo/docker-android


#GUI
#https://blog.jessfraz.com/post/docker-containers-on-the-desktop/
#https://github.com/jessfraz/dockerfiles
#https://forums.docker.com/t/start-a-gui-application-as-root-in-a-ubuntu-container/17069https://github.com/jessfraz/dockerfiles