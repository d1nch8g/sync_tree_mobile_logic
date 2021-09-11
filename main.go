package main

import (
	"encoding/binary"
	"fmt"
)

func main() {
	x := uint64(19237)
	amountBytes := make([]byte, 8)
	binary.LittleEndian.PutUint64(amountBytes, x)
	fmt.Println(amountBytes)
	fmt.Println(amountBytes[0])
}