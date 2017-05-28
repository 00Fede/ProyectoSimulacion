# Proyecto Simulacion
Recursos para ejecución de proyecto de simulacion.
Busca modelar problema de predicción de choques sismicos > 10⁴ J de Energia en mina de carbon.
Información tomada de Data-Set seismic-bumps http://archive.ics.uci.edu/ml/datasets/seismic-bumps<br>

BD original: data_tab.mat<br>
BD en forma matricial: data_mat.mat<br>
BD con codificacion: data_mat_enc<br>
BD con codificacion y SMOTE aplicado (th:0.30,num_vec:8): data_mat_smoted<br>

Se utiliza una recodificacion para las variables categoricas<br>
a (No Hazard) -> 0<br>
b (Low Hazard) -> 1<br>
c (High Hazard) -> 2<br>
b (Danger State) -> 3<br>

//Estas caracteristicas son categoricas, se realiza one-hot encoding<br>
N (Coal-getting) -> 10<br>
W (Preparement Shift) -> 01<br>

el archivo decodevars.m es quien hace la recodificación, para cualquier cambio en la codificación,
cambiar el switch que hay adentro y correr decodevars.m

<b>Federico</b>

