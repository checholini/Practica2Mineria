#!/bin/bash

#Direccion del .jar de weka
CLASSPATH="./../../weka-3-8-3/weka.jar"

#Variables clasificacion
RandomForest="weka.classifiers.trees.RandomForest"
ZEROR="weka.classifiers.rules.ZeroR"


echo "Got $# params"

while (( "$#" )); do
#Creacion nombre archivo de salida
    FILE_OUT="../Resultados/RandomForest/Resultado_$(echo $1 | sed 's/\./\//g' | cut -d "/" -f 7 ).md"

    #Impresion de la informacion
    #cut = 1,2 Titulo; 14 Precision; 24 FMeasure
    get_acc_RandomForest() {
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Correctly Classified Instances" >> ./$FILE_OUT
        printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Weighted Avg" | awk '{print $1, $2, $5, $7}' >> ./$FILE_OUT
        echo -e "---- \n" >> ./$FILE_OUT
    }

    TOT_NUM_ATTRIB=$(cat $1 | grep "@at" -c)
    NUM_ATTRIB=$((TOT_NUM_ATTRIB - 1))
    #Ejecucion de los algoritmos

    mkdir -p ./../Resultados/RandomForest/

    #Default
    echo "#Default RandomForest:" > ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 100 -K 0 > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con todos los atributos ( $((NUM_ATTRIB)) ):" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 100 -K $NUM_ATTRIB > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con la mitad de atributos ( $((NUM_ATTRIB/2)) ) :" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 100 -K $((NUM_ATTRIB/2)) > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con un cuarto de atributos ( $((NUM_ATTRIB/4)) ):" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 100 -K $((NUM_ATTRIB/4)) > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 200 iteraciones:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 200 -K 0 > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 300 iteraciones::" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 300 -K 0 > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 500 iteraciones::" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 500 -K 0 > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 200 iteraciones y todos los atributos:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 200 -K $NUM_ATTRIB > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 300 iteraciones y todos los atributos::" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 300 -K $NUM_ATTRIB > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 500 iteraciones y todos los atributos::" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 500 -K $NUM_ATTRIB > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 200 iteraciones y $((NUM_ATTRIB/2)) atributos" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 200 -K $((NUM_ATTRIB/2)) > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 300 iteraciones y $((NUM_ATTRIB/2)) atributos" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 300 -K $((NUM_ATTRIB/2)) > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 500 iteraciones y $((NUM_ATTRIB/2)) atributos " >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 500 -K $((NUM_ATTRIB/2)) > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 200 iteraciones y $((NUM_ATTRIB/4)) atributos:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 200 -K $((NUM_ATTRIB/4)) > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 300 iteraciones y $((NUM_ATTRIB/4)) atributos:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 300 -K $((NUM_ATTRIB/4)) > ./Prov.txt
    $(get_acc_RandomForest)

    #Default
    echo "#RandomForest con 500 iteraciones y $((NUM_ATTRIB/4)) atributos" >> ./$FILE_OUT
    java -classpath $CLASSPATH $RandomForest -t $1 -x 5 -P 100 -I 500 -K $((NUM_ATTRIB/4)) > ./Prov.txt
    $(get_acc_RandomForest)

    rm ./Prov.txt
    rm ./sel.arff

    cat ./$FILE_OUT
    shift
done