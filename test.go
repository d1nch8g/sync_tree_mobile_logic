package main

import (
	"encoding/binary"
	"fmt"
)

func main() {
	bytes := []byte{1, 2, 3, 4, 5}
	integer := 282
	reqString := "alloha"
	amountBytes := make([]byte, 8)
	binary.LittleEndian.PutUint64(amountBytes, uint64(integer))
	stringBytes := []byte(reqString)
	byteSum := append(bytes, amountBytes...)
	byteSum1 := append(byteSum, stringBytes...)
	fmt.Println(byteSum1)
}
