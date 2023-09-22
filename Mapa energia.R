#---------Mapa 4- Energia 

library(readxl)
library(dplyr)
library(leaflet)
geracao <- read_excel("C:\\Users\\clean\\OneDrive\\Documentos\\siga-empreendimentos-geracao.xlsx")


# Filtrar os dados para SigUFPrincipal = "PI"
dados_filtrados <- geracao %>%
  filter(SigUFPrincipal == "MA")

# Visualizar as primeiras linhas dos dados filtrados
head(dados_filtrados)
# Remover linhas com NomEmpreendimento igual a "Altus XVI"
dados_filtrados <- dados_filtrados %>%
  filter(NumCoordNEmpreendimento != 0.000000)
str(dados_filtrados)
attach(dados_filtrados)

# Definir a ordem dos níveis da variável SigTipoGeracao
ordem_niveis <- c("EOL", "UFV", "UHE", "UTE")

# Definir as cores correspondentes aos níveis da variável SigTipoGeracao
cores <- c("yellow", "red", "blue", "gray")
# Nomes correspondentes aos níveis para a legenda

nomes_legenda <- c("Central Geradora Eólica (EOL)",
                   "UFV (Central Geradora Fotovoltaica)",
                   "Usina Hidrelétrica (UHE)",
                   "Central Geradora Termelétrica (UTE)")

mapa_base <- leaflet() %>% #Base
  addProviderTiles("CartoDB.Positron",
                   options = providerTileOptions(noWrap = TRUE, opacity = 2))%>%
  addCircleMarkers(data = dados_filtrados, ##ENERGIA
                   lng = ~NumCoordEEmpreendimento,
                   lat = ~NumCoordNEmpreendimento,
                   fillColor = ~cores[as.factor(SigTipoGeracao)],
                   color = "black",
                   weight = 1,# Cor da borda dos círculos
                   radius = 8,
                   popup = ~paste(
                     "<strong>Nome do Empreendimento:</strong>", NomEmpreendimento,
                     "<br><strong>Potência (KW):<strong>", MdaPotenciaOutorgadaKw,
                     "<br><strong>Tipo de Geração:<strong>", SigTipoGeracao,
                     "<br><strong>Combustível de Origem:<strong>", DscOrigemCombustivel,
                     "<br><strong>Proprietário:<strong>", DscPropriRegimePariticipacao,
                     "<br><strong>Município:<strong>", DscMuninicpios), group = "Energia",
                   labelOptions = labelOptions(
                     style = list("font-size" = "14px", "font-weight" = "bold"),
                     textsize = "15px",
                     direction = "auto",
                     backgroundColor = "yellow")) %>%
  addLegend("bottomright",
            title = "Tipo de Geração",
            color = cores,
            labels = nomes_legenda, group = "Energia")
mapa_base
