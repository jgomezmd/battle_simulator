# SIMULACION

tirada <- function(n_dados, caras = 6){
  return(sort(ceiling(caras*runif(n_dados)), decreasing = TRUE))
}

perdidas_combate <- function(dados_a, dados_d, caras = 6){
  perdida <- c(0,0)
  tirada_a <- tirada(dados_a, caras)
  tirada_d <- tirada(dados_d, caras)
  for (i in 1:min(length(tirada_a),length(tirada_d))){
    if (tirada_a[i] > tirada_d[i]){
      perdida[2] <- perdida[2] + 1
    }
    else {
      perdida[1] <- perdida[1] + 1
      }
  }
  return(perdida)
}

combate <- function(tropas_a, tropas_b, caras = 6){
  tropas <- c(tropas_a, tropas_b)
  while (tropas[1] > 1 && tropas[2] >0){
    tropas <- tropas - perdidas_combate(min(3, tropas[1]-1), min(2, tropas[2]), caras)
  }
  return(tropas)
}

simulacion <- function(N, max_a, max_d){
  l <- 0
  df <- data.frame(evaluacion = numeric(),
                   atacantes_i = numeric(), 
                   defensores_i = numeric(), 
                   atacantes_f = numeric(),
                   defensores_f = numeric()
                   ) 
  for (i in 1:N){
    print(paste(i/N,"% simulado"))
    for (j in 2:max_a){
      for (k in 1:max_d){
        l <- l + 1
        resultado <- combate(j,k)
        df[l,] <- c(i, j, k, resultado[1], resultado[2])
      }
    }
  }
  return(df)
}

# DATAFRAMES TEORICOS PARA CALCULAR LA PROBABILIDAD REAL

df_teorico <- data.frame(ta1 = numeric(),
                   ta2 = numeric(),
                   ta3 = numeric(),
                   td1 = numeric(),
                   td2 = numeric(),
                   resultado = numeric())
l <- 0
caras <- 6

for (i in 1:caras){
  for (j in 1:caras){
    for (k in 1:caras){
      for (a in 1:caras){
        for (b in 1:caras){
          l <- l+1
          resultado <- 0
          ataque <- sort(c(k,a,b), decreasing = TRUE)
          defensa <- sort(c(i,j), decreasing = TRUE)
          for (i in 1:2){
            if (ataque[i]>defensa[i]){resultado <- resultado + 1} else {resultado <- resultado -1}
          }
          df_teorico[l,] <- c(ataque, defensa, resultado)
        }
      }
    }
  }
}


df_teorico_1dado <- data.frame(ta1 = numeric(),
                         ta2 = numeric(),
                         ta3 = numeric(),
                         td1 = numeric(),
                         resultado = numeric())
l <- 0
caras <- 6

for (i in 1:caras){
  for (j in 1:caras){
    for (k in 1:caras){
      for (a in 1:caras){
          l <- l+1
          resultado <- 0
          ataque <- sort(c(j, k, a), decreasing = TRUE)
          defensa <- i
          if (ataque[1] > defensa){resultado <- resultado + 1} else {resultado <- resultado - 1}
          df_teorico_1dado[l,] <- c(ataque, defensa, resultado)
      }
    }
  }
}

