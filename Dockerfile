#FROM adoptopenjdk/openjdk11:latest
#WORKDIR /workspace
#COPY target/*-SNAPSHOT.jar /workspace/app.jar
#ENV TZ="Asia/Ho_Chi_Minh"
#EXPOSE 8080
#ENTRYPOINT ["java","-jar","/workspace/app.jar"]

#
# Build stage
#
FROM adoptopenjdk/openjdk11:latest AS build
ENV HOME=/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME
ADD . $HOME
RUN --mount=type=cache,target=/root/.m2 ./mvnw -f $HOME/pom.xml clean package

#
# Package stage
#
FROM adoptopenjdk/openjdk11:latest
ARG JAR_FILE=/usr/app/target/*.jar
COPY --from=build $JAR_FILE /app/runner.jar
EXPOSE 8080
ENTRYPOINT java -jar /app/runner.jar