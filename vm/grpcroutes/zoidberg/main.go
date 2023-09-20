package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net"

	proto "github.com/jm96441n/zoidberg/gen/go"
	"google.golang.org/grpc"
)

type server struct{}

func (s *server) Speak(ctx context.Context, in *proto.QuoteRequest) (*proto.QuoteResponse, error) {
	log.Print("Recieved request to speak")
	return &proto.QuoteResponse{Message: "WOOP-WOOP-WOOP-WOOP!"}, nil
}

func main() {
	port := flag.Int("port", 50051, "The port to listen on")
	flag.Parse()

	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", *port))
	if err != nil {
		log.Fatal(err)
	}

	s := grpc.NewServer()

	proto.RegisterZoidbergServer(s, &server{})
	log.Printf("bender listening on %v", listener.Addr())

	if err = s.Serve(listener); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
