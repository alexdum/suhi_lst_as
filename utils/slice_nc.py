import xarray as xr
import pandas as pd

def extract_slice(fname, day, variable):
  #fname = fname
  # fname = "www/data/ncs/wmo_6_msg_lst_as_daily_avg.nc"
  # day = "2022-04-03"
  ds = xr.open_dataset(fname)
  ds.close()
  data = ds['MLST-AS'].sel(days = day).to_pandas().transpose().melt()
  return(data)


