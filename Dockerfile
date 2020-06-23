FROM ubuntu:20.04

# based on https://hub.docker.com/r/thyrlian/android-sdk/

RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y --no-install-recommends libncurses5:i386 libc6:i386 libstdc++6:i386 lib32gcc1 lib32ncurses6 lib32z1 zlib1g:i386 && \
	apt-get install -y --no-install-recommends openjdk-8-jdk && \
	apt-get install -y --no-install-recommends python2.7 python-pip-whl python-setuptools python-protobuf && \
	apt-get install -y --no-install-recommends git wget unzip curl tree nano vim && \
	apt-get install -y --no-install-recommends qt5-default aapt apktool expect tcl-expect zipalign gnuplot && \ 
	apt-get upgrade --yes && \
	apt-get dist-upgrade --yes

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV _JAVA_OPTIONS -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap

# download and install Android SDK
# https://developer.android.com/studio#command-tools
ARG ANDROID_SDK_VERSION=6514223
ENV ANDROID_SDK_ROOT /opt/android-sdk
ENV ANDROID_HOME /opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
	wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
	unzip *tools*linux*.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
	rm *tools*linux*.zip

# set the environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator
ENV _JAVA_OPTIONS -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap
# WORKAROUND: for issue https://issuetracker.google.com/issues/37137213
ENV LD_LIBRARY_PATH ${ANDROID_SDK_ROOT}/emulator/lib64:${ANDROID_SDK_ROOT}/emulator/lib64/qt/lib
# patch emulator issue: Running as root without --no-sandbox is not supported. See https://crbug.com/638180.
# https://doc.qt.io/qt-5/qtwebengine-platform-notes.html#sandboxing-support
ENV QTWEBENGINE_DISABLE_SANDBOX 1

# android 
# ARG ANDROID_EMULATOR_PACKAGE_ARM="system-images;android-19;google_apis;armeabi-v7a"
ARG ANDROID_EMULATOR_PACKAGE_x86="system-images;android-19;google_apis;x86"
ARG ANDROID_PLATFORM_VERSION="platforms;android-19"
ARG ANDROID_SDK_PACKAGES="${ANDROID_EMULATOR_PACKAGE_ARM} ${ANDROID_EMULATOR_PACKAGE_x86} ${ANDROID_PLATFORM_VERSION} platform-tools emulator"

# sdkmanager
RUN mkdir /root/.android/
RUN touch /root/.android/repositories.cfg
RUN yes Y | sdkmanager --licenses 
RUN yes Y | sdkmanager --verbose --no_https ${ANDROID_SDK_PACKAGES} 

# avdmanager
ENV EMULATOR_NAME_x86="Nexus-One-10"
#ENV EMULATOR_NAME_ARM="Nexus-One-10_arm"
RUN echo "no" | avdmanager --verbose create avd --force --name "${EMULATOR_NAME_x86}" --device "pixel" --package "${ANDROID_EMULATOR_PACKAGE_x86}"
#RUN echo "no" | avdmanager --verbose create avd --force --name "${EMULATOR_NAME_ARM}" --device "pixel" --package "${ANDROID_EMULATOR_PACKAGE_ARM}"

# accept the license agreements of the SDK components
ADD license_accepter.sh /opt/
RUN chmod +x /opt/license_accepter.sh && /opt/license_accepter.sh $ANDROID_SDK_ROOT && rm /opt/license_accepter.sh

# TODO: nao precisa expor portas!!!
# Expose ADB, ADB control and VNC ports
EXPOSE 5037
EXPOSE 5554
EXPOSE 5555
EXPOSE 5900

WORKDIR /opt
	
# pip and python libraries
RUN curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py && \
	python2 get-pip.py && \
	pip install pandas && \
	pip install numpy matplotlib && \
	pip install	Jinja2 uiautomator	
	
# droidbot
RUN git clone https://github.com/honeynet/droidbot.git && \
	cd droidbot && \
	pip install -e . && \
	rm /opt/get-pip.py
	
	
# stoat
#RUN cd /opt && apt-get install -y --no-install-recommends ruby2.7 build-essential patch ruby-dev zlib1g-dev liblzma-dev && \
#	gem install nokogiri && \
#	git clone https://github.com/rbonifacio/Stoat.git
#ENV STOAT_HOME /opt/Stoat/Stoat
#ENV PATH $PATH:$STOAT_HOME/bin


# sapienz
#RUN cd /opt && apt-get install -y --no-install-recommends libfreetype6-dev libxml2-dev libxslt1-dev python-dev && \
#	git clone https://github.com/droidxp/sapienz.git && \
#	cd sapienz && \
#	pip install -r requirements.txt
#ENV SAPIENZ_HOME /opt/sapienz/


# clean up
RUN apt-get remove -y unzip wget && \
	apt-get clean && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	ln -s /usr/bin/python2.7 /usr/bin/python

# where to find the APKs
VOLUME /opt/apps

# where to find the benchmark
WORKDIR /opt/benchmark
ENV BENCHMARK_HOME /opt/benchmark
VOLUME /opt/benchmark
VOLUME /opt/results
VOLUME /opt/report
