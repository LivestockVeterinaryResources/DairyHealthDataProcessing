
#BDAT--------------------
if(sum(str_detect(event_columns, 'BIRTH'))>0){
  df<-df%>%
    rename(BDAT = BIRTH)
}

#BREED-------------------
if(sum(str_detect(event_columns, 'BREED'))>0){
  df<-df%>%
    rename(CBRD = BREED)
}

#FRESH--------------------
if(sum(str_detect(event_columns, 'FRSH'))>0){
  df<-df%>%
    rename(FDAT = FRSH)
}

#DDRY--------------------
if(sum(str_detect(event_columns, 'DRYDT'))>0){
  df<-df%>%
    rename(DDAT = DRYDT)
}

#PODAT--------------------
if(sum(str_detect(event_columns, 'PGCK'))>0){
  df<-df%>%
    rename(PODAT = PGCK)
}

#DIM--------------------
if(sum(str_detect(event_columns, 'DNM'))>0){
  
  df<-df%>%
    rename(DIM = DNM)
}

#HDAT--------------------
if(sum(str_detect(event_columns, 'BRDHT'))>0){
  df<-df%>%
    rename(HDAT = BRDHT)
}

#EID--------------------
if(sum(str_detect(event_columns, 'AIN'))>0){
  df<-df%>%
    rename(EID = AIN)
}

#EID--------------------
if(sum(str_detect(event_columns, 'USDA'))>0){
  df<-df%>%
    rename(EID = USDA)
}

