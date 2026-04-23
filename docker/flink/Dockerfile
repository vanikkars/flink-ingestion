FROM flink:1.18-scala_2.12-java11

# ── Versions ──────────────────────────────────────────────────────────────
ARG FLINK_VERSION=1.18.1
ARG ICEBERG_VERSION=1.5.2
ARG HADOOP_VERSION=3.3.6
ARG AWS_SDK_VERSION=1.12.367
ARG KAFKA_CONNECTOR_VERSION=3.1.0-1.18
ARG NESSIE_VERSION=0.77.1

# Directory Flink auto-loads JARs from
ENV FLINK_LIB=/opt/flink/lib

# ── Kafka SQL connector ────────────────────────────────────────────────────
RUN curl -fsSL \
    https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-kafka/${KAFKA_CONNECTOR_VERSION}/flink-sql-connector-kafka-${KAFKA_CONNECTOR_VERSION}.jar \
    -o ${FLINK_LIB}/flink-sql-connector-kafka-${KAFKA_CONNECTOR_VERSION}.jar

# ── Iceberg Flink runtime ─────────────────────────────────────────────────
RUN curl -fsSL \
    https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-1.18/${ICEBERG_VERSION}/iceberg-flink-runtime-1.18-${ICEBERG_VERSION}.jar \
    -o ${FLINK_LIB}/iceberg-flink-runtime-1.18-${ICEBERG_VERSION}.jar

# ── Hadoop AWS + common + hdfs-client + AWS SDK (S3 / MinIO) ──────────────
RUN curl -fsSL \
    https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar \
    -o ${FLINK_LIB}/hadoop-aws-${HADOOP_VERSION}.jar && \
    curl -fsSL \
    https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/${HADOOP_VERSION}/hadoop-common-${HADOOP_VERSION}.jar \
    -o ${FLINK_LIB}/hadoop-common-${HADOOP_VERSION}.jar && \
    curl -fsSL \
    https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-hdfs-client/${HADOOP_VERSION}/hadoop-hdfs-client-${HADOOP_VERSION}.jar \
    -o ${FLINK_LIB}/hadoop-hdfs-client-${HADOOP_VERSION}.jar && \
    curl -fsSL \
    https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar \
    -o ${FLINK_LIB}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar

# ── Nessie catalog client (needed by Iceberg's NessieCatalog) ─────────────
RUN curl -fsSL \
    https://repo1.maven.org/maven2/org/projectnessie/nessie/nessie-client/${NESSIE_VERSION}/nessie-client-${NESSIE_VERSION}.jar \
    -o ${FLINK_LIB}/nessie-client-${NESSIE_VERSION}.jar

# ── Flink S3 FileSystem plugin (ships with Flink, just needs enabling) ─────
RUN cp /opt/flink/opt/flink-s3-fs-hadoop-${FLINK_VERSION}.jar ${FLINK_LIB}/ 2>/dev/null || \
    find /opt/flink/opt -name "flink-s3-fs-hadoop*.jar" -exec cp {} ${FLINK_LIB}/ \;

# ── Hadoop core-site.xml (S3A / MinIO credentials) ────────────────────────
# Place core-site.xml in /opt/flink/conf and point HADOOP_CONF_DIR there
# so Hadoop's Configuration class picks up the S3A credentials/endpoint.
COPY core-site.xml /opt/flink/conf/core-site.xml
ENV HADOOP_CONF_DIR=/opt/flink/conf