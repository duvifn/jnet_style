FROM ubuntu:18.04
# build with 'docker build -t compute_contours .'
# run with 'docker run -u 1000 --security-opt seccomp:unconfined --rm -it -v /path/to/input:/input -v /path/to/output:/output -w /src compute_contours <script.sh>
# Be aware that if the vrt is relative, you have to ensure that the entire relative path is defined as a volume on the container

# grass should run as the owner user (root is not enough!)
# https://www.shellhacks.com/how-to-grant-root-access-user-root-privileges-linux/
# find current user id by id -u $USER
RUN useradd --shell /bin/bash -u 1000 -g 0 -o -c "" -m user
RUN su user
RUN mkdir -p /src
RUN mkdir -p /output
WORKDIR /src

RUN apt-get update
RUN apt-get install -y python
RUN apt-get install -y gdal-bin python-gdal
RUN apt-get install -y bc
RUN apt-get install -y grass grass-doc
RUN apt-get install -y parallel
ENV INPUT=''
ENV OUTPUT_PATH='/output'
ENV JOB_NUMBER='6'
COPY . /src/

# Run script
CMD [ "./compute_contours.sh", $INPUT, $OUTPUT_PATH, $JOB_NUMBER ]
