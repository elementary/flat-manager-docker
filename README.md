<div align="center">
  <h1 align="center"><center>flat-manager-docker</center></h1>
  <h3 align="center"><center>Flat Manager Docker Image</center></h3>
  <br>
  <br>
</div>

---

This repository contains the source for the docker container used to manage the elementary flatpak repository. It uses
[flat-manager](https://github.com/flatpak/flat-manager) for the API, but also includes modifications to make it optimal
for running in kubernetes, and mount an S3 endpoint for file storage.

Most of this work is based of [this WIP PR](https://github.com/flatpak/flat-manager/pull/20). Once that is merged, this
repository will go down in size a lot.

## Images

- `flat-manager` - This is the Rust `flat-manager` command

## Configuration

You will want to make a custom flat-manager configuration at place it at `/var/run/flat-manager/config.json`.
Here is the example config:

```json
{
    "repos": {
        "stable": {
            "path": "repo",
            "collection-id": "org.test.Stable",
            "suggested-repo-name": "testrepo",
            "runtime-repo-url": "https://dl.flathub.org/repo/flathub.flatpakrepo",
            "gpg-key": null,
            "base-url": null,
            "subsets": {
                "all": {
                    "collection-id": "org.test.Stable",
                    "base-url": null
                },
                "free": {
                    "collection-id": "org.test.Stable.test",
                    "base-url": null
                }
            }
        },
        "beta": {
            "path": "beta-repo",
            "collection-id": "org.test.Beta",
            "suggested-repo-name": "testrepo-beta",
            "runtime-repo-url": "https://dl.flathub.org/repo/flathub.flatpakrepo",
            "gpg-key": null,
            "subsets": {
                "all": {
                    "collection-id": "org.test.Beta",
                    "base-url": null
                },
                "free": {
                    "collection-id": "org.test.Beta.test",
                    "base-url": null
                }
            }
        }
    },
    "port": 8080,
    "delay-update-secs": 10,
    "database-url": "postgres://%2Fvar%2Frun%2Fpostgresql/repo",
    "build-repo-base": "build-repo",
    "build-gpg-key": null,
    "gpg-homedir": null,
    "secret": "c2VjcmV0"
}
```

### S3 Repository

You can also mount an S3 location in the container to statically host the repository. **Warning** this comes with a lot
of warnings and can possibly break at any time. Use at your own risk. [`goofys`](https://github.com/kahing/goofys) and
[`catfs`](https://github.com/kahing/catfs) are installed by default in the `flat-manager` image.

**NOTE** You will also need to run the container with `--privileged` or you will end up getting an error like so
```
fuse: device not found, try 'modprobe fuse' first
```

To do this, simply add a script file at `/var/run/flat-manager/startup.sh`. This file will be ran on container
startup. For instance:

```sh
export AWSACCESSKEYID="aws access key"
export AWSSECRETACCESSKEY="aws secret key"

mkdir -p "$HOME/repository"

/usr/bin/goofys flatpak-repository "$HOME/repository"
```
