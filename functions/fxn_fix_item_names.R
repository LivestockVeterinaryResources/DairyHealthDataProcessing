
#BDAT--------------------
if(sum(str_detect(event_columns, 'BIRTH'))>0){
  events<-events%>%
    rename(BDAT = BIRTH)
}

#BREED-------------------
if(sum(str_detect(event_columns, 'BREED'))>0){
  events<-events%>%
    rename(CBRD = BREED)
}

#FRESH--------------------
if(sum(str_detect(event_columns, 'FRSH'))>0){
  events<-events%>%
    rename(FDAT = FRSH)
}

#DDRY--------------------
if(sum(str_detect(event_columns, 'DRYDT'))>0){
  events<-events%>%
    rename(DDAT = DRYDT)
}

#PODAT--------------------
if(sum(str_detect(event_columns, 'PGCK'))>0){
  events<-events%>%
    rename(PODAT = PGCK)
}

#DIM--------------------
if(sum(str_detect(event_columns, 'DNM'))>0){
  events<-events%>%
    rename(DIM = DNM)
}

#HDAT--------------------
if(sum(str_detect(event_columns, 'BRDHT'))>0){
  events<-events%>%
    rename(HDAT = BRDHT)
}

#EID--------------------
if(sum(str_detect(event_columns, 'AIN'))>0){
  events<-events%>%
    rename(EID = AIN)
}

#EID--------------------
if(sum(str_detect(event_columns, 'USDA'))>0){
  events<-events%>%
    rename(EID = USDA)
}

