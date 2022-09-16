# https://docs.rstudio.com/tutorials/user/using-python-with-rstudio-and-reticulate/
import pyarrow.parquet as pq

def read_pq(file):
    file = pq.read_table(file)
    return(file)

