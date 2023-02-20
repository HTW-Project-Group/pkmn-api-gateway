FROM openjdk:17-jdk-slim as build
WORKDIR /workspace/pkmn

RUN mkdir -p deployment
COPY deployment/product/pkmn-product-backend-0.0.1-SNAPSHOT.jar target/app.jar

RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)


FROM openjdk:17-jdk-slim
VOLUME /tmp
ARG DEPENDENCY=/workspace/pkmn/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /pkmn/lib
COPY --from=build ${DEPENDENCY}/META-INF /pkmn/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /pkmn
ENTRYPOINT ["java","-cp","pkmn:pkmn/lib/*","de.htwberlin.BackendApplication"]