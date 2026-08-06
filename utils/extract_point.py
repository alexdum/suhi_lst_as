import os
import hashlib
import xarray as xr
import pandas as pd
from functools import lru_cache

_DATASETS = {}
CACHE_DIR = os.path.join(os.path.dirname(__file__), "..", "www", "data", "ncs", ".cache_points")

def _get_dataset(fname):
    if fname not in _DATASETS:
        _DATASETS[fname] = xr.open_dataset(fname)
    return _DATASETS[fname]

def _get_cache_key(fname, lon, lat, variable):
    basename = os.path.basename(fname)
    key_str = f"{basename}_{round(float(lon), 4)}_{round(float(lat), 4)}_{variable}"
    return hashlib.md5(key_str.encode('utf-8')).hexdigest()

@lru_cache(maxsize=2048)
def _extract_from_nc(fname, lon_r, lat_r, variable):
    ds = _get_dataset(fname)
    dsloc = ds.sel(lon=lon_r, lat=lat_r, method='nearest')
    return dsloc[variable].to_pandas()

def extract_point(fname, lon, lat, variable):
    lon_r = round(float(lon), 4)
    lat_r = round(float(lat), 4)
    var_str = str(variable)
    
    # Try disk cache first for instant loads across sessions
    try:
        if not os.path.exists(CACHE_DIR):
            os.makedirs(CACHE_DIR, exist_ok=True)
        
        cache_key = _get_cache_key(fname, lon_r, lat_r, var_str)
        cache_path = os.path.join(CACHE_DIR, f"{cache_key}.parquet")
        
        if os.path.exists(cache_path):
            s = pd.read_parquet(cache_path)['values']
            return s
    except Exception:
        pass

    # Compute from NetCDF
    series = _extract_from_nc(fname, lon_r, lat_r, var_str)

    # Save to disk cache asynchronously/silently
    try:
        cache_key = _get_cache_key(fname, lon_r, lat_r, var_str)
        cache_path = os.path.join(CACHE_DIR, f"{cache_key}.parquet")
        df_save = pd.DataFrame({'values': series})
        df_save.to_parquet(cache_path)
    except Exception:
        pass

    return series
