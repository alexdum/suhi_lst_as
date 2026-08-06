#!/bin/bash
# Sincronizează doar fișierele de date noi de pe S3 pe mașina de vizualizare locală
# pentru a proteja codul sursă al aplicației (.R)
rsync -av --delete /mnt/suhi/suhi_lst_as/www/data/ncs/ /home/eouser/suhi_lst_as/www/data/ncs/
rsync -av --delete /mnt/suhi/suhi_lst_as/www/data/tabs/ /home/eouser/suhi_lst_as/www/data/tabs/

# Spune serverului Shiny să repornească aplicația pentru a citi noile date
touch /home/eouser/suhi_lst_as/restart.txt
