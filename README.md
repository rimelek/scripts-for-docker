# Scripts for Docker
 
Sometimes you need to do tasks that are not yet implemented in Docker.
This project contains scripts you can use with Docker and save some time.

##  Scripts

* [docker-volume-copy](bin/docker-volume-copy.sh): Copy local volume<br> 
```bash
# format: docker-volume-copy.sh VOLUME_SRC VOLUME_DST
./bin/docker-volume-copy.sh my-old-volume my-new-volume
```
* [docker-volume-copy-remote](bin/docker-volume-copy-remote.sh): Copy local volume to a remote server<br>
```bash
# format: docker-volume-copy-remote.sh VOLUME_SRC SSH_REMOTE_SRV SSH_REMOTE_PORT [VOLUME_DST]
./bin/docker-volume-copy-remote.sh my-old-volume user@host.tld 22
# or
./bin/docker-volume-copy-remote.sh my-old-volume user@host.tld 22 my-new-volume
```
If you omit the last argument the name of the source volume wil be used.
**NOTE**: Using SSH key is recommended 
* [docker-volume-export](bin/docker-volume-export.sh): Export volume to a tar archive<br>
```bash
# format: docker-volume-export.sh VOLUME FILE
./bin/docker-volume-export.sh my-volume exported-my-volume.tgz 
```
* [docker-volume-files](bin/docker-volume-files.sh): List files on a volume<br>
```bash
# format: docker-volume-files.sh VOLUME [FOLDER]
./bin/docker-volume-files.sh my-volume
# or
./bin/docker-volume-files.sh my-volume path/to/subfolder
```
**NOTE**: Do not start the name of the folder with "/"
* [docker-volume-import](bin/docker-volume-import.sh): Import exported tar archive to a volume.<br>
```bash
# format: docker-volume-import.sh FILE VOLUME
./bin/docker-volume-export.sh exported-my-volume.tgz my-volume
```

* [docker-image-list](bin/docker-image-list.sh): List images grouped by id or name

```bash
# format: docker-image-list.sh COMMAND
# group by id
./bin/docker-image-list.sh groupById
# group by name
./bin/docker-image-list.sh groupByName
```
