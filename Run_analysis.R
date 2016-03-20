if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="C:/Users/VIVI/Desktop/datasetpf/getdata-projectfiles-UCI HAR Dataset.zip",
              method="curl")

###Descomprimir los archivos
unzip(zipfile = "C:/Users/VIVI/Desktop/datasetpf/getdata-projectfiles-UCI HAR Dataset.zip", 
      exdir = "./data")

###Crear lista de archivos
ruta <- file.path("./data", "UCI HAR Dataset")
files <- list.files(ruta, recursive = TRUE)

###Leer archivos de Activity
datosActivityTest  <- read.table(file.path(ruta, "test", "Y_test.txt"), header = FALSE)
datosActivityTrain <- read.table(file.path(ruta, "train", "Y_train.txt"), header = FALSE)

###Leer archivos de Subject
datosSubjectTrain <- read.table(file.path(ruta, "train", "subject_train.txt"), header = FALSE)
datosSubjectTest  <- read.table(file.path(ruta, "test", "subject_test.txt"), header = FALSE)

###Leer archivos de Caracteristicas
datosFeaturesTest  <- read.table(file.path(ruta, "test", "X_test.txt"), header = FALSE)
datosFeaturesTrain <- read.table(file.path(ruta, "train", "X_train.txt"), header = FALSE)

###Unir las bases por sus filas
datosSubject <- rbind(datosSubjectTrain, datosSubjectTest)
datosActivity <- rbind(datosActivityTrain, datosActivityTest)
datosFeatures <- rbind(datosFeaturesTrain, datosFeaturesTest)

###Asignar nombre a las variables
names(datosSubject) <- c("subject")
names(datosActivity) <- c("activity")
datosFeaturesNombres <- read.table(file.path(ruta, "features.txt"), header = FALSE)
names(datosFeatures) <- datosFeaturesNombres$V2

###Merge unir las bases
datosCombinados <- cbind(datosSubject, datosActivity)
Datos <- cbind(datosFeatures, datosCombinados)

###Extraer datos de media y desviacion estandar
subdatosFeaturesNombres <- datosFeaturesNombres$V2[grep("mean\\(\\)|std\\(\\)", datosFeaturesNombres$V2)]

###Sacar el dataframe por los nombres
Nombresselect <- c(as.character(subdatosFeaturesNombres), "subject", "activity")
Datos <- subset(Datos, select = Nombresselect)

###Poner nombres descriptivos
activityMarca <- read.table(file.path(ruta, "activity_labels.txt"), header = FALSE)

names(Datos) <- gsub("^t", "time", names(Datos))
names(Datos) <- gsub("^f", "frequency", names(Datos))
names(Datos) <- gsub("Acc", "accelerometer", names(Datos))
names(Datos) <- gsub("Gyro", "gyroscope", names(Datos))
names(Datos) <- gsub("Mag", "magnitude", names(Datos))
names(Datos) <- gsub("BodyBody", "body", names(Datos))

###Crear una base de datos ordenada (tidy data)
Datos2 <- aggregate(. ~subject + activity, Datos, mean)
Datos2 <- Datos2[order(Datos2$subject,Datos2$activity), ]
tidydata <- write.table(Datos2, file = "tidydata.txt", row.name = FALSE)