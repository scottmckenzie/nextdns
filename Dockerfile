FROM docker.io/library/golang:1.23 AS build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN CGO_ENABLED=0 go build -o /go/bin/nextdns
RUN touch /etc/nextdns.conf

FROM gcr.io/distroless/static-debian12
COPY --from=build /go/bin/nextdns /usr/bin/nextdns
COPY --from=build /etc/nextdns.conf /etc/nextdns.conf
ENTRYPOINT ["/usr/bin/nextdns"]
CMD ["run"]
