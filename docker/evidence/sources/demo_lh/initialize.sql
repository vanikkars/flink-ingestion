INSTALL httpfs;
INSTALL iceberg;
LOAD httpfs;
LOAD iceberg;

CREATE OR REPLACE SECRET minio (
    TYPE        s3,
    KEY_ID      'minioadmin',
    SECRET      'minioadmin',
    ENDPOINT    'minio:9000',
    URL_STYLE   'path',
    USE_SSL     false,
    REGION      'us-east-1'
);

ATTACH '' AS iceberg_catalog (
    TYPE                   iceberg,
    ENDPOINT               'http://nessie:19120/iceberg',
    AUTHORIZATION_TYPE     'none',
    ACCESS_DELEGATION_MODE 'none'
);