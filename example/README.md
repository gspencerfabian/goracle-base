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


#### Basic (using sqlplus)
**Dockerfile:**
```docker
FROM gspencerfabian/goracle:v0.0.2

RUN echo "select count(*) from dual;" | sqlplus "<USER>/<PASS>@<SID>"
```
You can use `RUN <command>` for inline sqlplus invoking. Alternatively you can use `ENTRYPOINT ["/path/to/bash.sh"]` to execute a bash script.


#### Advanced (using golang)
**Dockerfile:**
```docker
FROM gspencerfabian/goracle:v0.0.2

RUN cd /app && go build .

ENTRYPOINT ["/app/app"]
```
Execute the built go code with the `ENTRYPOINT` command.


**/app/main.go:**
```go
package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/mattn/go-oci8"
)

var conn string

func init() {
	if conn = os.Getenv("CONNECT"); conn == "" {
		log.Fatal("No environment variable set for CONNECT.")
	}
}

func main() {
	db, err := sql.Open("oci8", conn)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	rows, err := db.Query("select TS from spencer_test")
	if err != nil {
		panic(err)
	}
	defer rows.Close()
	for rows.Next() {
		var ts string
		err = rows.Scan(&ts)
		if err != nil {
			panic(err)
		}
		fmt.Println(ts)
	}
	err = rows.Err()
	if err != nil {
		panic(err)
	}
}
```
The main application should be placed in a folder alongside the Dockerfile called `app`. Inside `app` will be the main golang program plus the tnsnames.ora file.
