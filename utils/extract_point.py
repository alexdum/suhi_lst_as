import os
import hashlib
import netCDF4 as nc
import xarray as xr
import pandas as pd
import numpy as np
from functools import lru_cache

_DATASETS = {}
_NC_HANDLES = {}
_NC_COORDS = {}

CACHE_DIR = os.path.join(os.path.dirname(__file__), "..", "www", "data", "ncs", ".cache_points")

def _get_dataset(fname):
    if fname not in _DATASETS:
        _DATASETS[fname] = xr.open_dataset(fname)
    return _DATASETS[fname]

def _get_nc_handle(fname):
    if fname not in _NC_HANDLES:
        ds = nc.Dataset(fname)
        _NC_HANDLES[fname] = ds
        _NC_COORDS[fname] = (ds.variables["lon"][:], ds.variables["lat"][:])
    return _NC_HANDLES[fname], _NC_COORDS[fname]

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
    """Full time series extraction with memory & disk Parquet caching (~6ms cached)."""
    lon_r = round(float(lon), 4)
    lat_r = round(float(lat), 4)
    var_str = str(variable)
    
    # Try disk cache first for instant loads
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

    # Compute full time series from NetCDF
    series = _extract_from_nc(fname, lon_r, lat_r, var_str)

    # Save to disk cache silently
    try:
        cache_key = _get_cache_key(fname, lon_r, lat_r, var_str)
        cache_path = os.path.join(CACHE_DIR, f"{cache_key}.parquet")
        df_save = pd.DataFrame({'values': series})
        df_save.to_parquet(cache_path)
    except Exception:
        pass

    return series

def extract_single_value(fname, lon, lat, variable, date_index):
    """Ultra-fast (11ms) single date value extraction for map popups using direct C netCDF4 indexing."""
    try:
        ds, (lons, lats) = _get_nc_handle(fname)
        
        lon_val = float(lon)
        lat_val = float(lat)
        
        i = int(np.abs(lons - lon_val).argmin())
        j = int(np.abs(lats - lat_val).argmin())
        t_idx = int(date_index) - 1
        
        val = ds.variables[str(variable)][t_idx, j, i]
        v_float = float(val)
        
        if np.isnan(v_float) or abs(v_float) > 1e10 or v_float == -9999.0:
            return None
        return round(v_float, 1)
    except Exception:
        return None
