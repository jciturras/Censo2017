library(dplyr)
library(readr)
datos <- read_csv("P.AMC.csv")

set.seed(42) #Fijar semilla para siempre tener la misma base de datos

sample <- datos %>% 
  group_by(DC) %>% #se agrupa por DISTRITO CENSAL (estrato)
  sample_frac(0.5) %>% #Seleccionamos aleatoriamente un 50% al interior de cada estrato
  ungroup

table(datos$DC) / nrow(datos) #Estos deben ser iguales
table(sample$DC) / nrow(sample) #Este debe ser igual al de arriba

sample$ESCOLARIDAD <- car::recode(sample$ESCOLARIDAD,"99=NA") #Recode missing data para educación
sample <- sample %>% na.omit() #Dejamos solamente casos completos

# Seleccionar una sub muestra de los jefes de hogar | P07==1 es Jefe de hogar 
jhogar  <- sample %>%filter(P07==1) %>%  select(HOGAR,ESCOLARIDAD) %>% mutate(ed_jho=ESCOLARIDAD) %>% select(-ESCOLARIDAD)

#Pegar el valor de cada hogar/Jefe de hogar
merge1 <-merge(sample,jhogar, by = "HOGAR", all.x = TRUE, all.y = FALSE)  #Base final

# Guardar base de datos ---------------------------------------------------

write.csv(x = merge1,file = "censojuitsa.csv") #se guarda
julio <- read.csv("censojuitsa.csv") #verificar base de datos nueva. TODO OK.
