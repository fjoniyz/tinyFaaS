package rproxy

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"math/rand"
	"net/http"
	"strings"
	"sync"
)

type Status uint32

const (
	StatusOK Status = iota
	StatusAccepted
	StatusNotFound
	StatusError
)

type RProxy struct {
	hosts map[string][]string
	hl    sync.RWMutex
}

// Leader node keeps track of which functions are available in which node
func update_list_on_leader(name string, port string) {
	jsonBody := fmt.Sprintf(`{"http-port": %s, "function-name": %s}`, port, name)
	log.Println("JSON body for updating function: ", jsonBody)
	response, err := http.Post(fmt.Sprintf("http://localhost:90/add"), "json", strings.NewReader(jsonBody))
	if err != nil {
		log.Print("Error: ", err)
		return
	}
	defer response.Body.Close()

	// Read the response body
	body, err := io.ReadAll(response.Body)
	if err != nil {
		fmt.Println("Error reading response:", err)
		return
	}

	// Print the response status and body
	fmt.Println("Response Status:", response.Status)
	fmt.Println("Response Body:", string(body))
	return
}

func New() *RProxy {
	return &RProxy{
		hosts: make(map[string][]string),
	}
}

func (r *RProxy) Add(name string, ips []string) error {
	if len(ips) == 0 {
		return fmt.Errorf("no ips given")
	}

	update_list_on_leader(name, "8000")

	r.hl.Lock()
	defer r.hl.Unlock()

	// if function exists, we should update!
	// if _, ok := r.hosts[name]; ok {
	// 	return fmt.Errorf("function already exists")
	// }

	r.hosts[name] = ips
	return nil
}

func (r *RProxy) Del(name string) error {
	r.hl.Lock()
	defer r.hl.Unlock()

	if _, ok := r.hosts[name]; !ok {
		return fmt.Errorf("function not found")
	}

	delete(r.hosts, name)
	return nil
}

func (r *RProxy) Call(name string, payload []byte, async bool) (Status, []byte) {

	handler, ok := r.hosts[name]

	if !ok {
		log.Printf("function not found: %s", name)
		return StatusNotFound, nil
	}

	log.Printf("have handlers: %s", handler)

	// choose random handler
	h := handler[rand.Intn(len(handler))]

	log.Printf("chosen handler: %s", h)

	// call function
	if async {
		log.Printf("async request accepted")
		go func() {
			resp, err := http.Post(fmt.Sprintf("http://%s:8000/fn", h), "application/binary", bytes.NewBuffer(payload))

			if err != nil {
				return
			}

			resp.Body.Close()

			log.Printf("async request finished")
		}()
		return StatusAccepted, nil
	}

	// call function and return results
	log.Printf("sync request starting")
	resp, err := http.Post(fmt.Sprintf("http://%s:8000/fn", h), "application/binary", bytes.NewBuffer(payload))

	if err != nil {
		log.Print(err)
		return StatusError, nil
	}

	log.Printf("sync request finished")

	defer resp.Body.Close()
	res_body, err := io.ReadAll(resp.Body)

	if err != nil {
		log.Print(err)
		return StatusError, nil
	}

	// log.Printf("have response for sync request: %s", res_body)

	return StatusOK, res_body
}
