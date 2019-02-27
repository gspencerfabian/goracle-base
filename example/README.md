# GOracle Docker Image Usage


### Purpose
For use as a base image when building Go apps that require a Oracle database connection


### Examples
Here are two different examples of how to use goracle as a base image. Every implementation of goracle **requires** a tnsnames.ora file in a folder called `app` that is in the same directory as the Dockerfile.


#### tnsnames.ora (REQUIRED)
```
<SID> =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = <SERVER>)(PORT = 1521))
    (CONNECT_DATA =
      (SID = <SID>)
    )
  )
<SID> =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = <SERVER>)(PORT = 1521))
    (CONNECT_DATA =
      (SID = <SID>)
    )
  )
```
Multiple databases are supported. tnsnames.ora **is required** to be in a folder called `app` alongside the Dockerfile. It will be automatically pulled into the new app image via `ONBUILD` and put into the `$TNS_ADMIN` location which is already set for you.


#### Folder Structure
```
slate [oracle_app] ≻ tree
.
├── app
│   ├── main.go             <-- app code
│   └── tnsnames.ora        <-- database definitation the app code uses
└── Dockerfile
```


#### Alternative Use (SQL Plus Only)
**Dockerfile:**
```docker
FROM gspencerfabian/goracle:v0.0.2

RUN echo "select count(*) from dual;" | sqlplus "<USER>/<PASS>@<SID>"
```
You can use `RUN <command>` for inline sqlplus invoking. Alternatively you can use `ENTRYPOINT ["/path/to/bash.sh"]` to execute a bash script.

