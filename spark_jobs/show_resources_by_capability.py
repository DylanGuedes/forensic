from pyspark.sql.types import StructType, StructField, ArrayType, StringType, DoubleType, IntegerType, DateType
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, col
import requests
import sys

DEFAULT_DATA_COLLECTOR_URL = "http://data-collector:3000"


def getSchema():
    return StructType([
        StructField("uuid", StringType(), False),
        StructField("capabilities", StructType([
            StructField("current_location", ArrayType(
                StructType([
                    StructField("tick", IntegerType(), False),
                    StructField("date", StringType(), False),
                    StructField("nodeID", DoubleType(), False)
                ])
            ))
        ]))
    ])


if __name__ == '__main__':
    data_collector_url = DEFAULT_DATA_COLLECTOR_URL

    if (len(sys.argv) > 1):
        data_collector_url = sys.argv[1]

    spark = SparkSession.builder.getOrCreate()
    spark.sparkContext.setLogLevel("ERROR")


    # get data from collector
    try:
        r = requests.post(data_collector_url + '/resources/data', json={"capabilities": ["current_location"]})
        resources = r.json()["resources"]
        rdd = spark.sparkContext.parallelize(resources)
        try:
            df = spark.createDataFrame(resources, getSchema())
        except:
            raise Exception("Wrong parameters parsing!!")


        df.show(truncate=False)

        print("Query generation completed! Results:")

    except:
        raise Exception("""
            Your data_collector looks weird.
            Usage: `train_model ${data_collector_url}`
            (default data_collector_url: http://data_collector:3000)
        """)
