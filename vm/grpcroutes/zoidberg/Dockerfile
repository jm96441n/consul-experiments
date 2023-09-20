FROM golang:1.20 as deps

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

FROM deps as build

WORKDIR /app
COPY go.mod go.sum main.go ./
COPY gen ./gen
RUN go install .

FROM build

CMD ["zoidberg"]
