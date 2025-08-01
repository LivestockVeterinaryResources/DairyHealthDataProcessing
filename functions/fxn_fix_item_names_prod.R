
#BDAT--------------------
if(sum(str_detect(production_columns, 'BIRTH'))>0){
  production<-production%>%
    rename(BDAT = BIRTH)
}

#BREED-------------------
if(sum(str_detect(production_columns, 'BREED'))>0){
  production<-production%>%
    rename(CBRD = BREED)
}

#FRESH--------------------
if(sum(str_detect(production_columns, 'FRSH'))>0){
  production<-production%>%
    rename(FDAT = FRSH)
}

#DDRY--------------------
if(sum(str_detect(production_columns, 'DRYDT'))>0){
  production<-production%>%
    rename(DDAT = DRYDT)
}

#PODAT--------------------
if(sum(str_detect(production_columns, 'PGCK'))>0){
  production<-production%>%
    rename(PODAT = PGCK)
}

#DIM--------------------
if(sum(str_detect(production_columns, 'DNM'))>0){
  production<-production%>%
    rename(DIM = DNM)
}

#HDAT--------------------
if(sum(str_detect(production_columns, 'BRDHT'))>0){
  production<-production%>%
    rename(HDAT = BRDHT)
}

#EID--------------------
if(sum(str_detect(production_columns, 'AIN'))>0){
  production<-production%>%
    rename(EID = AIN)
}

#EID--------------------
if(sum(str_detect(production_columns, 'USDA'))>0){
  production<-production%>%
    rename(EID = USDA)
}

#fat--------------------
if(sum(str_detect(production_columns, 'FAT%'))>0){
  production<-production%>%
    rename(PCTF = 'FAT%')
}

#fat--------------------
if(sum(str_detect(production_columns, 'PROT%'))>0){
  production<-production%>%
    rename(PCTP = 'PROT%')
}

