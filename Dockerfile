FROM python:latest as builder
WORKDIR /builder
COPY ./test ./test
RUN echo "Building App"

FROM alpine:latest as unittest
WORKDIR /unittest
COPY --from=builder /builder/test ./test
RUN echo "Unittest Functions Running" > ./test

FROM alpine:latest as securitycheck
WORKDIR /sec
COPY --from=builder /builder/test ./test
RUN echo "Security Functions Running" >> ./test

FROM alpine:latest as emailreports
WORKDIR /emailsrep
COPY --from=builder /builder/test ./test
RUN echo "Sending Emails Function Running" >> ./test

FROM alpine:latest as webapp
WORKDIR /app
COPY --from=builder /builder/test ./test
RUN cat ./test
