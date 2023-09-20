package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net"

	proto "github.com/jm96441n/bender/gen/go"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

type server struct{}

func (s *server) Speak(ctx context.Context, in *proto.QuoteRequest) (*proto.QuoteResponse, error) {
	log.Print("Recieved request to speak")
	return &proto.QuoteResponse{Message: "Bender is great"}, nil
}

func main() {
	port := flag.Int("port", 50051, "The port to listen on")
	flag.Parse()

	listener, err := net.Listen("tcp", fmt.Sprintf(":%d", *port))
	if err != nil {
		log.Fatal(err)
	}

	s := grpc.NewServer()
	proto.RegisterBenderServer(s, &server{})
	reflection.Register(s)
	log.Printf("bender listening on %v", listener.Addr())

	if err = s.Serve(listener); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
