---
output: 
    html_document
---


<script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-AMS_CHTML.js"></script>

Built in [Shiny](https://shiny.rstudio.com/), this dashboard aims to provide accurate and relevant facts and statistics about SUHI for large cities located in WMO Region 6.

The application is based on [LSA-SAF SEVIRI LST All Sky](https://landsaf.ipma.pt/en/products/land-surface-temperature/mlstas/) dataset.

The administrative boundaries for all the cities used in this study were extracted from [OpenStreetMap.](https://wiki.openstreetmap.org/wiki/Tag:boundary%3Dadministrative#10_admin_level_values_for_specific_countries).

The daily values of the Surface Urban Heat Island (SUHI) is detected for each city using the methodology proposed by [Cheval et al. (2022)](https://www.sciencedirect.com/science/article/pii/S2212095521002868).

SUHI is computed as the difference between the LST values of the urban and, respectively, rural areas, as follows: $$SUHI = LST_U - LST_R$$

-   $LST_U$: urban pixels within the administrative perimeter of an urban area; urban pixels refer to artificial surfaces and associated areas;
-   $LST_R$ non-urban pixels from the buffer extended up to 1/2 \* average distance between the city centroid and nodes of the urban administrative perimeter; non-urban pixels refer to any land cover category except for urban and water, and they define the rural area used for comparison with the urban pixels.

![Delimitation of areas for computing *LST_U* and *LST_R* for Brașov (Romania). The rural buffer is drawn at 1/2\* average distance between the city centroid (blue dot) and nodes of the urban administrative perimeter (red dots).](https://ars.els-cdn.com/content/image/1-s2.0-S2212095521002868-gr3.jpg){width="406"}

$SUHI Max$ was calculated from images corresponding to the time step when the maximum LST value was recorded in urban areas. $SUHI Min$ was calculated from images corresponding to the time step when the minimum LST value was recorded in urban areas. $Urban LST mean$ was calculated from the urban pixels extracted from all the images coresponding to each day. $Rural LST mean$ was calculated from the rural pixels extracted from all the images coresponding to each day.
