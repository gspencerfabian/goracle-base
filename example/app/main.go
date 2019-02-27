package main

import (
	"database/sql"
	"fmt"

	_ "github.com/mattn/go-oci8"
)

func main() {
	db, err := sql.Open("oci8", "spencer/secret123@GSFORA1")
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
