FROM python:latest as builder
WORKDIR /builder
COPY ./test ./test
COPY ./srccode/* ./srccode/
RUN echo "Building App" >> ./test

FROM alpine:latest as unittest
WORKDIR /unittest
COPY --from=builder /builder/test ./test
RUN echo "Unittest Functions Running" >> ./test

FROM alpine:latest as securitycheck
WORKDIR /sec
COPY --from=unittest /unittest/test ./test
RUN echo "Security Functions Running" >> ./test

# docker build -t reports:1 -t reports -f ReportsDockerFile .
FROM reports:latest as emailreports
WORKDIR /emailsrep
COPY --from=securitycheck /sec/test ./test
RUN echo "Sending Emails Function Running" >> ./test

FROM alpine:latest as webapp
WORKDIR /app
COPY --from=builder /builder/srccode/*.py .
RUN echo "Running the webapp"
