FROM oracle/graalvm-ce:20.0.0-java8 as graalvm
# For JDK 11
#FROM oracle/graalvm-ce:20.0.0-java11 as graalvm
RUN gu install native-image

COPY . /home/app/micronaut-http2-graal
WORKDIR /home/app/micronaut-http2-graal

RUN native-image --no-server -cp build/libs/micronaut-http2-graal-*-all.jar

FROM frolvlad/alpine-glibc
RUN apk update && apk add libstdc++
EXPOSE 8080
COPY --from=graalvm /home/app/micronaut-http2-graal/micronaut-http2-graal /app/micronaut-http2-graal
ENTRYPOINT ["/app/micronaut-http2-graal"]
