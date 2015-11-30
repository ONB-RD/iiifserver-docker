# iiifserver-docker
Docker container for iiifserver

## Build Docker Image

 1. Provide a licensed copy of Kakadu (v7_7-XXXXXN.zip) in the  iiifserver-docker directory.
 2. Set 'ENV KAKADU_VERSION v7_7-XXXXXN' in the Dockerfile accordingly(without .zip at the end).
 3. Run `docker build -t=iiif .`
 4. Run `docker run -dt -p 80:80 iiif`
 5. Try to access [http://localhost/cgi-bin/iipsrv.fcgi?iiif=00000001.jp2/full/full/0/native.jpg](http://localhost/cgi-bin/iipsrv.fcgi?iiif=00000001.jp2/full/full/0/native.jpg) outside the container.
