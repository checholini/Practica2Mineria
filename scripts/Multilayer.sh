#!/bin/bash

#Direccion del .jar de weka
CLASSPATH="./../../weka-3-8-3/weka.jar"

#Variables clasificacion
MultilayerPerceptron="weka.classifiers.functions.MultilayerPerceptron"

#Variables Seleccion Atributos
ATRIB="weka.filters.supervised.attribute.AttributeSelection"
METHOD="weka.attributeSelection.WrapperSubsetEval"
CLASSIFIER="weka.attributeSelection.GreedyStepwise"


echo "Got $# params"

while (( "$#" )); do
    #Creacion nombre archivo de salida
    FILE_OUT="../Resultados/MultilayerPerceptron/Resultado_$(echo $1 | sed 's/\./\//g' | cut -d "/" -f 7 ).md"


    echo "Param: $1"
    #Impresion de la informacion
    #cut = 1,2 Titulo; 14 Precision; 24 FMeasure
    get_acc_MultilayerPerceptron() {
         printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Correctly Classified Instances" >> ./$FILE_OUT
         printf "* " >> ./$FILE_OUT
        cat Prov.txt | grep "Weighted Avg" | cut -d " " -f 1,2,14,24 >> ./$FILE_OUT
        echo -e "---- \n" >> ./$FILE_OUT
    }

    show_atrib() {
        cat sel.arff | grep "@attribute" | cut -d " " -f 2 >> ./$FILE_OUT
    }
    #Ejecucion de los algoritmos

    mkdir -p ./../Resultados/MultilayerPerceptron/

    #Default tras seleccion
    echo "#Default NN:" > ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 500 -H a > ./Prov.txt
    $(get_acc_MultilayerPerceptron)

    echo "#200 NN:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 200 -H a > ./Prov.txt
    $(get_acc_MultilayerPerceptron)

    echo "#100 NN:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 100 -H a > ./Prov.txt
    $(get_acc_MultilayerPerceptron)

    echo "#T 500 NN:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 500 -H t > ./Prov.txt
    $(get_acc_MultilayerPerceptron)

    echo "#T 200 NN:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 500 -H t > ./Prov.txt
    $(get_acc_MultilayerPerceptron)

    echo "T 100 NN:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 500 -H t > ./Prov.txt
    $(get_acc_MultilayerPerceptron)

    echo "#I 500 NN:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 500 -H i > ./Prov.txt
    $(get_acc_MultilayerPerceptron)

    echo "#I 200 NN:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 500 -H i > ./Prov.txt
    $(get_acc_MultilayerPerceptron)

    echo "I 100 NN:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 500 -H i > ./Prov.txt
    $(get_acc_MultilayerPerceptron)

     echo "#O 500 NN:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 500 -H o > ./Prov.txt
    $(get_acc_MultilayerPerceptron)

    echo "#O 200 NN:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 500 -H o > ./Prov.txt
    $(get_acc_MultilayerPerceptron)

    echo "O 100 NN:" >> ./$FILE_OUT
    java -classpath $CLASSPATH $MultilayerPerceptron -t $1 -x 5 -N 500 -H o > ./Prov.txt
    $(get_acc_MultilayerPerceptron)



    rm ./Prov.txt

    cat ./$FILE_OUT
    shift
done