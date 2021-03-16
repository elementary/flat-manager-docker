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
