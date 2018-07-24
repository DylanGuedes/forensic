from pyspark.sql.types import StructType, StructField, ArrayType, StringType, DoubleType, IntegerType, DateType
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, col
import requests
import sys

DEFAULT_DATA_COLLECTOR_URL = "http://data-collector:3000"


def extract_schema_string(args):
    capabilities_schema = {}

    for idx, u in enumerate(args):
        if u.find('schema') != -1:
            capability_name = args[idx]
            capability_schema = {}
            schema_size = int(args[idx+1])
            convenient_list = args[idx+2:3*(idx+2)]
            for attr_idx, attr_name in enumerate(convenient_list):
                if not (attr_idx&1):
                    attr_type = convenient_list[attr_idx+1]
                    capability_schema[attr_name] = attr_type
            capabilities_schema[capability_name] = capability_schema

    return capabilities_schema


def mount_spark_capability_schema(capability, capability_string_schema):
    fields = []

    for name, typ in capability_string_schema.items():
        if typ == "string":
            fields.append(StructField(name, StringType(), False))
        elif typ == "double":
            fields.append(StructField(name, DoubleType(), False))
        elif typ == "integer":
            fields.append(StructField(name, IntegerType(), False))
        elif typ == "date":
            fields.append(StructField(name, StringType(), False))

    return StructType([
        StructField("uuid", StringType(), False),
        StructField("capabilities", StructType([
            StructField(capability, ArrayType(StructType(fields)))
        ]))
    ])


def get_data_collection(capability):
    data_collector_url = DEFAULT_DATA_COLLECTOR_URL
    # get data from collector

    try:
        r = requests.post(data_collector_url + '/resources/data', json={"capabilities": [capability]})
        return r.json()["resources"]

    except:
        raise Exception("""
            Your data_collector looks weird.
            Usage: `train_model ${data_collector_url}`
            (default data_collector_url: http://data_collector:3000)
        """)


def get_correlation_attrs(argv):
    for idx, u in enumerate(argv):
        if (u == "--others"):
            return argv[idx+1:]


def publish_strategy(argv):
    for idx, u in enumerate(argv):
        if (u == "--publish"):
            if argv[idx+1] == "console":
                return %{"strategy": "console", "truncate": False}
            elif argv[idx+1] == "hdfs":
                return %{"strategy": "hdfs", "path": argv[idx+2]}


if __name__ == '__main__':
    spark = SparkSession.builder.getOrCreate()
    spark.sparkContext.setLogLevel("ERROR")

    publish_strategy = extract_publish_strategy(sys.argv)
    schema_string = extract_schema_string(sys.argv)
    correlation_attrs = get_correlation_attrs(sys.argv)

    df_table = {}


    for k, v in schema_string.items():
        capability = k.replace("_schema", "")
        sch = mount_spark_capability_schema(capability, v)
        data_collection = get_data_collection(capability)
        df = spark.createDataFrame(data_collection, sch)
        df_table[capability] = df


    for capability, df in df_table.items():
        if publish_strategy["strategy"] == "console":
            df.show(truncate=publish_strategy["truncate"])
        elif publish_strategy["strategy"] == "hdfs":
            (df.write.mode('overwrite')
                    .option("header", "true")
                    .format("csv")
                    .save(publish_strategy["path"]))
