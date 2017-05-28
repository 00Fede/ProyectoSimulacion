# Proyecto Simulacion
Recursos para ejecución de proyecto de simulacion.
Busca modelar problema de predicción de choques sismicos > 10⁴ J de Energia en mina de carbon.
Información tomada de Data-Set seismic-bumps http://archive.ics.uci.edu/ml/datasets/seismic-bumps

BD original: data_tab.mat
BD en forma matricial: data_mat.mat
BD con codificacion: data_mat_enc
BD con codificacion y SMOTE aplicado (th:0.30,num_vec:8): data_mat_smoted

Se utiliza una recodificacion para las variables categoricas
a (No Hazard) -> 0
b (Low Hazard) -> 1
c (High Hazard) -> 2
b (Danger State) -> 3

//Estas caracteristicas son categoricas, se realiza one-hot encoding
N (Coal-getting) -> 10
W (Preparement Shift) -> 01

el archivo decodevars.m es quien hace la recodificación, para cualquier cambio en la codificación,
cambiar el switch que hay adentro y correr decodevars.m

Federico

