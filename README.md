# Scripts for Docker
 
Sometimes you need to do tasks that are not yet implemented in Docker.
This project contains scripts you can use with Docker and save some time.

##  Scripts

* [docker-volume-copy](bin/docker-volume-copy): Copy local volume<br> 
```bash
# format: docker-volume-copy VOLUME_SRC VOLUME_DST
docker-volume-copy my-old-volume my-new-volume
```
* [docker-volume-copy-remote](bin/docker-volume-copy-remote): Copy local volume to a remote server<br>
```bash
# format: docker-volume-copy-remote VOLUME_SRC SSH_REMOTE_SRV SSH_REMOTE_PORT [VOLUME_DST]
docker-volume-copy-remote my-old-volume user@host.tld 22
# or
docker-volume-copy-remote my-old-volume user@host.tld 22 my-new-volume
```
If you omit the last argument the name of the source volume wil be used.
**NOTE**: Using SSH key is recommended 
* [docker-volume-export](bin/docker-volume-export): Export volume to a tar archive<br>
```bash
# format: docker-volume-export VOLUME FILE
docker-volume-export my-volume exported-my-volume.tgz 
```
* [docker-volume-files](bin/docker-volume-files): List files on a volume<br>
```bash
# format: docker-volume-files VOLUME [FOLDER]
docker-volume-files my-volume
# or
docker-volume-files my-volume path/to/subfolder
```
**NOTE**: Do not start the name of the folder with "/"
* [docker-volume-import](bin/docker-volume-import): Import exported tar archive to a volume.<br>
```bash
# format: docker-volume-import FILE VOLUME
docker-volume-export exported-my-volume.tgz my-volume
```

* [docker-image-list](bin/docker-image-list): List images grouped by id or name

```bash
# format: docker-image-list COMMAND
# group by id
docker-image-list groupById
# group by name
docker-image-list groupByName
```